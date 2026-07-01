%% EXERCICIO 1 - Lugar Geometrico das Raizes, Criterio de Jury e Ts
%
% Enunciado:
% Um sistema discreto em malha fechada tem realimentacao unitaria e
% funcao de transferencia de ramo direto:
%
%           K (z + 0.4)
% G(z) = -----------------,      T = 0.1 s
%         (z - 0.2)(z - 0.8)
%
% Pede-se:
%   a) A faixa de valores de K para que o sistema em malha fechada seja
%      estavel (Criterio de Jury).
%   b) O valor de K para que o tempo de assentamento (2%) seja Ts = 0.6 s.
%   c) Para o K encontrado no item (b), calcule zeta, wn e o overshoot
%      dos polos dominantes de malha fechada (verificacao).

clear all; close all; clc;

T = 0.1;
Gz = zpk(-0.4, [0.2 0.8], 1, T);

%% Item a) LGR + analise por Routh-Hurwitz via Tustin (equivalente ao Jury)
rlocus(Gz); grid on;
Gw = tf(d2c(Gz,'tustin'));   % transformada bilinear para aplicar Routh-Hurwitz

% Polinomio caracteristico: Q(z) = z^2 + (K-1) z + (0.16+0.4K)
% Jury (grau 2):
%   I)   Q(1)  > 0  -> 0.16 + 1.4K > 0        -> K > -0.114 (sempre ok p/ K>0)
%   II)  Q(-1) > 0  -> 2.16 - 0.6K > 0        -> K < 3.6
%   III) a2 > |a0|  -> 1 > |0.16+0.4K|        -> K < 2.1  (mais restritiva)
% Faixa de estabilidade: 0 < K < 2.1
disp('Faixa de K para estabilidade (Jury): 0 < K < 2.1')

%% Item b) Circulo de tempo de assentamento no plano z
Ts_desejado = 0.6;
sigma = -4/Ts_desejado;
R = exp(sigma*T);
fprintf('sigma = %.4f | Raio do circulo Ts=0.6s: R = %.4f\n', sigma, R)

hold on;
[xc,yc] = Circulo(R);
plot(xc,yc,'r--','LineWidth',1.5)
legend('LGR','Circulo Ts = 0.6 s')

% Varredura de K para achar o ponto onde o polo dominante cruza o circulo
Kvec = linspace(0.001,2.09,20000);
melhorErro = inf; melhorK = 0;
for K = Kvec
    p = roots([1 (K-1) (0.16+0.4*K)]);
    if ~isreal(p)
        erro = abs(abs(p(1))-R);
        if erro < melhorErro
            melhorErro = erro; melhorK = K;
        end
    end
end
fprintf('K para Ts = 0.6 s  ->  K = %.4f\n', melhorK)

%% Item c) Verificacao: zeta, wn e overshoot para o K encontrado
p = roots([1 (melhorK-1) (0.16+0.4*melhorK)]);
Rm = abs(p(1));
theta = abs(angle(p(1)));
zeta = -log(Rm)/sqrt(log(Rm)^2+theta^2);
wn = sqrt(log(Rm)^2+theta^2)/T;
overshoot = exp(-zeta*pi/sqrt(1-zeta^2));
fprintf('Polos MF: %.4f%+.4fi\n', real(p(1)), imag(p(1)))
fprintf('zeta = %.4f | wn = %.4f rad/s | overshoot = %.2f %%\n', zeta, wn, 100*overshoot)

%% Resposta ao degrau em malha fechada com o K encontrado
figure;
step(feedback(melhorK*Gz,1));
title(sprintf('Resposta ao degrau - K = %.4f (Ts=0.6s)', melhorK))
