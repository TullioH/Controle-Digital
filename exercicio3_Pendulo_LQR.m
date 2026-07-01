%% EXERCICIO 3 - Controle LQR Discreto do Pendulo Invertido
%
% Enunciado:
% Um pendulo invertido montado sobre um carrinho tem os seguintes
% parametros: m1 = 1.5 kg (carrinho), m2 = 0.15 kg (pendulo),
% l = 0.25 m (comprimento), g = 9.8 m/s^2. O sistema, linearizado em
% torno de theta = 0, e descrito no espaco de estados x = [theta; dtheta; x; dx]
% com periodo de amostragem T = 0.1 s.
%
% O pendulo parte de uma condicao inicial de 15 graus e deve ser
% estabilizado por realimentacao de estados otima (LQR discreto).
%
% Pede-se: projetar DOIS controladores LQR distintos e comparar a
% resposta:
%   (A) Ponderando fortemente o angulo do pendulo:  Q = diag([5000 1 1 1]), R = 1
%   (B) Ponderando fortemente o esforco de controle: Q = diag([1 1 1 1]), R = 5000
%
% Compare o tempo de assentamento do angulo e o esforco de controle maximo
% em cada caso.

clear all; close all; clc;

%% Parametros do modelo
m1 = 1.5; m2 = 0.15; l = 0.25; g = 9.8;

%% Matrizes de estado - sistema continuo
A = [0 1 0 0;
     (m1+m2)*g/(m1*l) 0 0 0;
     0 0 0 1;
     -(m2/m1)*g 0 0 0];
B = [0; -1/(m1*l); 0; 1/m1];

%% Discretizacao
T = 0.1;
[Ad, Bd] = c2d(A,B,T);

%% Caso A - ponderacao no angulo
QA = diag([5000 1 1 1]); RA = 1;
KA = dlqr(Ad,Bd,QA,RA);

%% Caso B - ponderacao no esforco de controle
QB = diag([1 1 1 1]); RB = 5000;
KB = dlqr(Ad,Bd,QB,RB);

disp('Ganho K (ponderacao no angulo):'); disp(KA)
disp('Ganho K (ponderacao no esforco):'); disp(KB)

%% Resultado esperado (rodando o script):
%   KA ~ [-42.98  -5.50  -0.34  -1.40]   -> Ts(angulo) ~ 3.3 s , u_max ~ 11.3 N
%   KB ~ [-24.91  -3.80  -0.01  -0.11]   -> Ts(angulo) ~ 8.9 s , u_max ~ 6.5 N

%% Simulacao
t = 10; tempo = [0:T:t];
N = t/T;
x0 = [15*pi/180; 0; 0; 0];

for caso = 1:2
    if caso == 1, K = KA; else, K = KB; end
    x = zeros(N+1,4); x(1,:) = x0';
    u = zeros(N,1);
    for k = 1:N
        u(k) = -K*x(k,:)';
        x(k+1,:) = (Ad*x(k,:)' + Bd*u(k))';
    end
    angulo(:,caso) = (180/pi)*x(:,1);
    comando(:,caso) = u;
end

%% Plots
figure;
subplot(2,1,1)
stairs(tempo,angulo,'LineWidth',2); grid on;
legend('Caso A - pondera angulo','Caso B - pondera esforco')
title('Posicao Angular do Pendulo [graus]')

subplot(2,1,2)
stairs(tempo(1:end-1),comando,'LineWidth',2); grid on;
legend('Caso A - pondera angulo','Caso B - pondera esforco')
title('Sinal de Controle u(k) [N]')
xlabel('Tempo (s)')
