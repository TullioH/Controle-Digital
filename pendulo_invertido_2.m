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

% Cálculo de 3 Conjuntos de Ganhos Kd - 3 Ponderações Diferentes
for i=1:3
    switch i
        case 1
            % Ponderação na Posição Angular
            Qd = diag([10000 1 1 1]);
            Rd= 1;
            Kd(:,i) = dlqr(Ad,Bd,Qd,Rd);
            
        case 2
            % Poderação na Velocidade Angular
            Qd = diag([1 10000 1 1]);
            Rd= 1;
            Kd(:,i) = dlqr(Ad,Bd,Qd,Rd);
            
        case 3
            % Poderação no Comando - Esforço de Controle
            Qd = diag([1 1 1 1]);
            Rd= 10000;
            Kd(:,i) = dlqr(Ad,Bd,Qd,Rd);
    end
end

% Simulação da Planta
t = 10;
tempo = [0:T:t];
x(1,:)=[20*pi/180;0;0;0];

for m=1:3
    for k=1:10/T
        u(k)=-Kd(:,m)'*x(k,:)';
        x(k+1,:)=Ad*x(k,:)'+Bd*u(k);
    end
    
    angulo(:,m) = (180/pi)*x(:,1);
    velocidade(:,m) = x(:,2);
    comando(:,m) = u';
end

% Plotagem dos gráficos dos resultados obtidos
figure
subplot(2,2,1)
stairs(tempo,angulo,'LineWidth',2); grid on
title('Posição Angular do Pêndulo [°]');
legend('Pond. Posição','Pond. Velocidade','Pond. Comando');

subplot(2,2,2)
stairs(tempo,velocidade,'LineWidth',2); grid on
title('Velocidade Angular do Pêndulo [rad/s]');
legend('Pond. Posição','Pond. Velocidade','Pond. Comando');

subplot(2,2,[3,4])
stairs(tempo(1:length(tempo)-1),comando,'LineWidth',2); grid on
title('Comando[N] [m/s]');
legend('Pond. Posição','Pond. Velocidade','Pond. Comando');