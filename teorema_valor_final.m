close all; clear all; clc
%% Modelo da Planta Continua
Gp=zpk(-3,[ -4 -5],20);

%% Período de Amostragem
T=0.5;

%% Modelo da Planta Discreta
Gz=c2d(Gp,T)

%% Função de Transferencia em Malha Fechada Discreta
FTMF=feedback(Gz,1)

%% Resposta do Sistema Discreto em Relação as 3 entradas R(z)
t=[0:T:10];                     % Escala de Tempo
u_s=ones(1,length(t));          % Degrau Unitário
u_r=t;                          % Rampa Unitária
u_p=(t.^2)/2;                   % Par?bola Unit?ria
y_s=lsim(FTMF,u_s,t);           % Resposta ao degrau unit?rio
y_r=lsim(FTMF,u_r,t);           % Resposta ? rampa unit?ria
y_p=lsim(FTMF,u_p,t);           % Resposta ? par?bola unit?ria

%% Cálculo do erro E(z) para cada uma das entradas 
erro_s=u_s'-y_s;                % Erro degrau 
erro_r=u_r'-y_r;                % Erro rampa  
erro_p=u_p'-y_p;                % Erro par?bola

%% Plotar as figuras
figure();
subplot(2,3,1)
stairs(t,u_s);hold on;stairs(t,y_s, 'r'); grid on
title('Resposta ao Degrau Unitário');xlabel('Tempo(s)')
subplot(2,3,2) 
stairs(t,u_r);hold on;stairs(t,y_r, 'r'); grid on
title('Resposta à Rampa Unitária');xlabel('Tempo(s)')
subplot(2,3,3)
stairs(t,u_p);hold on;stairs(t,y_p, 'r');grid on
title('Resposta à Parabola Unitária');xlabel('Tempo(s)')
subplot(2,3,4)
stairs(t,erro_s);grid on
title('Erro Degrau Unitário');xlabel('Tempo(s)')
subplot(2,3,5)
stairs(t,erro_r);grid on
title('Erro Rampa Unitária');xlabel('Tempo(s)')
subplot(2,3,6)
stairs(t,erro_p);grid on
title('Erro Parábola Unitário');xlabel('Tempo(s)')

%% Adicionando Integrador Livre
% Modelo da Planta Continua
Gp_i=zpk(-3,[0 -4 -5],20);

%% Período de Amostragem
T_i=0.6;

%% Modelo da Planta Discreta
Gz_i=c2d(Gp_i,T_i)

%% Função de Transferencia em Malha Fechada Discreta
FTMFi=feedback(Gz_i,1)

%% Resposta do Sistema Discreto em Relação as 3 entradas R(z)
t=[0:T_i:10];                     % Escala de Tempo
u_s=ones(1,length(t));          % Degrau Unitário
u_r=t;                          % Rampa Unitária
u_p=(t.^2)/2;                   % Par?bola Unit?ria
y_s=lsim(FTMFi,u_s,t);           % Resposta ao degrau unit?rio
y_r=lsim(FTMFi,u_r,t);           % Resposta ? rampa unit?ria
y_p=lsim(FTMFi,u_p,t);           % Resposta ? par?bola unit?ria

%% Cálculo do erro E(z) para cada uma das entradas 
erro_s=u_s'-y_s;                % Erro degrau 
erro_r=u_r'-y_r;                % Erro rampa  
erro_p=u_p'-y_p;                % Erro par?bola

%% Plotar as figuras
figure();
subplot(2,3,1)
stairs(t,u_s);hold on;stairs(t,y_s, 'r'); grid on
title('Resposta ao Degrau Unitário');xlabel('Tempo(s)')
subplot(2,3,2) 
stairs(t,u_r);hold on;stairs(t,y_r, 'r'); grid on
title('Resposta à Rampa Unitária');xlabel('Tempo(s)')
subplot(2,3,3)
stairs(t,u_p);hold on;stairs(t,y_p, 'r');grid on
title('Resposta à Parabola Unitária');xlabel('Tempo(s)')
subplot(2,3,4)
stairs(t,erro_s);grid on
title('Erro Degrau Unitário');xlabel('Tempo(s)')
subplot(2,3,5)
stairs(t,erro_r);grid on
title('Erro Rampa Unitária');xlabel('Tempo(s)')
subplot(2,3,6)
stairs(t,erro_p);grid on
title('Erro Parábola Unitário');xlabel('Tempo(s)')
