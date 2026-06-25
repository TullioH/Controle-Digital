%% Pendulo Invertido
clc; clear all; close all;

% Parâmetros do Pêndulo Invertido
m1 = 2; % Massa do carro [Kg]
m2 = 0.1; % Masso do pêndulo [Kg]
l = 0.3; % Comprimento da haste [m]
g = 9.8; % Aceleração da gravidade [m/s^2]

% Matrizes A e B do espaço de Estados (contínuo)
A = [0 1 0 0;((m1+m2)*g)/(m1*l) 0 0 0;0 0 0 1;(-m2/m1)*g 0 0 0];
B = [0;-1/(m1*l);0;1/m1];

% Matrizes Ad e Bd do espaço de Estados (discreto)
T = 0.1; % Periodo de amostragem
[Ad,Bd] = c2d(A, B, T); % Sistema digital

Qd = diag([1 1 1 1]);
Rd = 1;
Kd = dlqr(Ad,Bd,Qd,Rd);

t = 10;
tempo = [0:T:t];
x(1,:)=[20*pi/180;0;0;0];

for k=1:10/T
    u(k)=-Kd*x(k,:)';
    x(k+1,:)=Ad*x(k,:)'+Bd*u(k);
end

angulo = (180/pi) * x(:,1);
velocidade = x(:,2);
posicao = x(:,3);
velocidade_carro = x(:,4);
comando = u;

% Plotagem dos gráficos dos resultados obtidos
figure
subplot(2,2,1)
stairs(tempo,angulo,'LineWidth',2); grid on
title('Posição Angular do Pêndulo [°]');

subplot(2,2,2)
stairs(tempo,velocidade,'LineWidth',2); grid on
title('Velocidade Angular do Pêndulo [rad/s]');

subplot(2,2,3)
stairs(tempo,posicao,'LineWidth',2); grid on
title('Posição do Carro [m]');

subplot(2,2,4)
stairs(tempo,velocidade_carro,'LineWidth',2); grid on
title('Velocidade do carro [m/s]');

figure
stairs(tempo(1:length(tempo)-1),comando,'LineWidth',2); grid on
title('Comando[N] [m/s]');