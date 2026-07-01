%% EXERCICIO 2 - Sintonia Otima de PID Digital (fmincon)
%
% Enunciado:
% Uma planta discreta, com periodo de amostragem T = 0.1 s, e dada por:
%
%              1
% G(z) = -----------------
%         (z-0.3)(z-0.6)
%
% Deseja-se projetar um controlador PID digital (formula de Euler para
% tras) que faca a saida seguir um degrau de referencia filtrado por
% G_ref(s) = 1/((tresp/4)s + 1), com tempo de resposta (98%) tresp = 3 s.
%
% Os parametros do controlador devem respeitar:
%   0 <= Kp <= 0.6      0 <= Ki <= 0.6      0 <= Kd <= 0.3
%
% Pede-se: usar otimizacao (fmincon) para encontrar Kp, Ki, Kd que
% minimizem o erro quadratico entre a saida do sistema e a referencia
% filtrada, e plotar o resultado comparando com a referencia.

clc; close all; clear all;

%% Ponto inicial dos parametros do controlador
kp_ini = 0.1; ki_ini = 0.1; kd_ini = 0.1;
x0 = [kp_ini ki_ini kd_ini];

%% Limites maximos e minimos dos parametros
kp_max=0.6; ki_max=0.6; kd_max=0.3;
kp_min=0;   ki_min=0;   kd_min=0;
v_max = [kp_max ki_max kd_max];
v_min = [kp_min ki_min kd_min];

%% Especificacao desejada
tresposta_des = 3;

%% Tempos de amostragem e de simulacao
Ts = 0.1;
tsim = 8;
tempo = [0:Ts:tsim-Ts];

%% Entrada degrau unitario
u = ones(length(tempo),1);

%% Referencia filtrada (98% em tresposta_des)
G_ref = tf([0 1],[tresposta_des/4 1]);
yref = lsim(G_ref,u,tempo);

%% Modelo da planta discreta
Gz = zpk([],[0.3 0.6],1,Ts);

%% Otimizacao
options = optimset('Display','iter','MaxFunEvals',500);
[p,fval] = fmincon(@funcao_custo,x0,[],[],[],[],v_min,v_max,[],options,yref,Ts,tsim,Gz)

%% Resultado esperado (rodando o script): p = [Kp Ki Kd] proximo de
%   Kp ~ 0.091   Ki ~ 0.345   Kd ~ 0.008    (fval ~ 0.13)

%% Simulacao em malha fechada com os parametros otimos
Gc = pid(p(1),p(2),p(3),0,Ts,'IFormula','BackwardEuler');
y_opt = step(feedback(Gc*Gz,1),tempo);

%% Plot
stairs(tempo,y_opt,'b'); hold on; stairs(tempo,yref,'r');
legend('Sintonia PID Otimizado','Referencia'); grid on
title('Resposta ao Degrau Filtrado - PID Otimizado')
xlabel('Tempo (s)')
