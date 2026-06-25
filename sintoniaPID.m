clc; close all; clear all

%% PROGRAMA OTIMIZAÇÃO PID - ENTRADA PARA QUALQUER FUNÇÃO G(Z)

%% Ponto Inicial dos Parâmetros do Controlador %% IMPORTANTE DEFINIÇÃO %%
kp_ini=0.1; ki_ini=0.1; kd_ini=0.1;
x0 = [kp_ini ki_ini kd_ini];

%% Limites Máximos e Mínimos dos Parâmetros
kp_max=0.5; ki_max=0.5; kd_max=0.2;
kp_min=0; ki_min=0; kd_min=0;
v_max=[kp_max ki_max kd_max];
v_min=[kp_min ki_min kd_min];

%% Especificação Desejada + implicito erro em RP zerado 
t_resposta_des=4;

%% Tempos de Amostragem e de Simulação
Ts=0.1;
tsim=10; 
tempo=[0:Ts:tsim-Ts];

%% Definição do perfil de entrada - Degrau Unitário
u=ones(length(tempo),1);

%% Saída de Referencia - Degrau Filtrado 
G_ref=tf([0 1],[t_resposta_des/4 1]); % 4 x tempo de resposta = 98% da resposta final desejada
yref=lsim(G_ref,u,tempo);

%% Modelo do Planta Discreta
Gz=zpk([],[0.1 0.5],1,Ts);

%% Definição do Problema de Otimização
options = optimset('Display','iter','MaxFunEvals',500);
[p,fval] = fmincon(@funcao_custo,x0,[],[],[],[],v_min,v_max,[],options,yref,Ts,tsim,Gz)

%% Simulação em Malha Fechada com Parâmetros Ótimos
Gc=pid(p(1),p(2),p(3),0,Ts,'IFormula','BackwardEuler');
y_opt=step(feedback(Gc*Gz,1),tempo);

%% Plotar Resultados Obtidos
stairs(tempo,y_opt,'r');hold on;stairs(tempo,yref,'b');
legend('Sintonia PID Otimizado','Refer?ncia');title('Resposta ao Degrau Filtrado - PID')