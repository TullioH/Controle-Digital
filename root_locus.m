%% Lugar Geométrico das Raízes para Sistemas Discretos
clc; clear all; close all;

% Exemplo 1: Utilize o LGR para obter os valores de K para estabilidade.
% Verifique com o critério de Routh-Hurwitz

%      +       |----------------------------|
% R(z)-->O---->| K*(z+0.5)/((z-0.25)*(z-1)) |-------> C(z)
%        Î-    |----------------------------|   |
%        |                                      |
%        |--------------------------------------|

T = 0.1; % segundos
Gz = zpk(-0.5,[0.25 1],1,T)
Gw = tf(d2c(Gz,'tustin'))

rlocus(Gz); hold on
grid on;

% Para Ts = 0.8
Ts = 0.8;
sigma = -4/Ts;
r = exp(sigma*T);
[x,y] = circulo(r);
plot(x,y)

% Para epson = 0.5 -> K = 0.325 (no gráfico)
epson = 0.5
K = 0.325
overshoot = exp((-epson*pi)/sqrt(1-epson^2))

GMF = feedback(K*Gz,1)
figure;
step(GMF); hold on
K = 0.236
GMF = feedback(K*Gz,1)
step(GMF);
legend('K = 0.325','K = 0.236')