%% EXERCICIO 4 - Erro em Regime Permanente via Teorema do Valor Final
%
% Enunciado:
% A planta continua
%
%              15 (s+3)
% Gp(s) = -------------------
%           (s+2)(s+6)
%
% e discretizada com T = 0.25 s e realimentada com ganho unitario
% (sem controlador).
%
% Pede-se:
%   a) Calcule as constantes de erro Kp, Kv, Ka e os erros de regime
%      permanente para entrada degrau, rampa e parabola unitarios.
%   b) Repita o calculo adicionando um integrador livre em serie com a
%      planta (Gp_i(s) = Gp(s)/s) e compare os resultados.
%   c) Simule e plote a resposta e o erro para as tres entradas em cada
%      caso.

close all; clear all; clc;

%% Modelo da planta continua (sem integrador - tipo 0)
Gp = zpk(-3,[-2 -6],15);
T = 0.25;
Gz = c2d(Gp,T)

%% Malha fechada
FTMF = feedback(Gz,1);

%% Constantes de erro discretas (Kp, Kv, Ka)
z = tf('z',T);
Kp = dcgain(Gz);                       % z->1 direto (posicao)
Kv_sys = minreal((z-1)/T * Gz);
Kv = dcgain(Kv_sys);                   % velocidade
Ka_sys = minreal(((z-1)/T)^2 * Gz);
Ka = dcgain(Ka_sys);                   % aceleracao

ess_degrau  = 1/(1+Kp);
ess_rampa   = 1/Kv;
ess_parab   = 1/Ka;

fprintf('--- SEM integrador (tipo 0) ---\n')
fprintf('Kp = %.4f  -> erro degrau  = %.4f\n', Kp, ess_degrau)
fprintf('Kv = %.4e  -> erro rampa   = %.4e\n', Kv, ess_rampa)
fprintf('Ka = %.4e  -> erro parabola = %.4e\n', Ka, ess_parab)
% Resultado esperado: Kp=3.75 -> erro degrau=0.2105 ; Kv~0 -> erro rampa=Inf ; erro parabola=Inf

%% Item b) Com integrador livre adicionado
Gp_i = zpk(-3,[0 -2 -6],15);
Gz_i = c2d(Gp_i,T)
Kp_i = dcgain(Gz_i);
Kv_i_sys = minreal((z-1)/T * Gz_i);
Kv_i = dcgain(Kv_i_sys);
Ka_i_sys = minreal(((z-1)/T)^2 * Gz_i);
Ka_i = dcgain(Ka_i_sys);

ess_degrau_i = 1/(1+Kp_i);
ess_rampa_i  = 1/Kv_i;
ess_parab_i  = 1/Ka_i;

fprintf('\n--- COM integrador livre (tipo 1) ---\n')
fprintf('Kp = %.3e -> erro degrau  = %.4e (~0)\n', Kp_i, ess_degrau_i)
fprintf('Kv = %.4f -> erro rampa   = %.4f\n', Kv_i, ess_rampa_i)
fprintf('Ka = %.4e -> erro parabola = %.4e\n', Ka_i, ess_parab_i)
% Resultado esperado: erro degrau ~ 0 ; Kv=3.75 -> erro rampa=0.2667 ; erro parabola=Inf

%% Item c) Simulacao das respostas e erros (tipo 0)
FTMFi = feedback(Gz_i,1);
t = [0:T:10];
u_s = ones(1,length(t));
u_r = t;
u_p = (t.^2)/2;

y_s = lsim(FTMF,u_s,t);  erro_s = u_s'-y_s;
y_r = lsim(FTMF,u_r,t);  erro_r = u_r'-y_r;
y_p = lsim(FTMF,u_p,t);  erro_p = u_p'-y_p;

figure();
subplot(2,3,1); stairs(t,u_s); hold on; stairs(t,y_s,'r'); grid on
title('Degrau (tipo 0)'); xlabel('Tempo(s)')
subplot(2,3,2); stairs(t,u_r); hold on; stairs(t,y_r,'r'); grid on
title('Rampa (tipo 0)'); xlabel('Tempo(s)')
subplot(2,3,3); stairs(t,u_p); hold on; stairs(t,y_p,'r'); grid on
title('Parabola (tipo 0)'); xlabel('Tempo(s)')
subplot(2,3,4); stairs(t,erro_s); grid on; title('Erro degrau')
subplot(2,3,5); stairs(t,erro_r); grid on; title('Erro rampa')
subplot(2,3,6); stairs(t,erro_p); grid on; title('Erro parabola')

%% Simulacao (tipo 1 - com integrador)
y_s_i = lsim(FTMFi,u_s,t);  erro_s_i = u_s'-y_s_i;
y_r_i = lsim(FTMFi,u_r,t);  erro_r_i = u_r'-y_r_i;
y_p_i = lsim(FTMFi,u_p,t);  erro_p_i = u_p'-y_p_i;

figure();
subplot(2,3,1); stairs(t,u_s); hold on; stairs(t,y_s_i,'r'); grid on
title('Degrau (tipo 1)'); xlabel('Tempo(s)')
subplot(2,3,2); stairs(t,u_r); hold on; stairs(t,y_r_i,'r'); grid on
title('Rampa (tipo 1)'); xlabel('Tempo(s)')
subplot(2,3,3); stairs(t,u_p); hold on; stairs(t,y_p_i,'r'); grid on
title('Parabola (tipo 1)'); xlabel('Tempo(s)')
subplot(2,3,4); stairs(t,erro_s_i); grid on; title('Erro degrau')
subplot(2,3,5); stairs(t,erro_r_i); grid on; title('Erro rampa')
subplot(2,3,6); stairs(t,erro_p_i); grid on; title('Erro parabola')
