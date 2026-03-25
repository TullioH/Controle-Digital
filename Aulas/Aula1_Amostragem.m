% Limpeza da Workspace
clc;
clear all;
close all;

w1 = 2*pi; % Frequência do sinal
deltaT = 0.01; % Incremento do sinal "contínuo"
tf = 3; % Tempo final de simulação
t = 0:deltaT:tf-deltaT; % Vetor de tempo "contínuo"
x = sin(w1*t); % Sinal "contínuo" x(t)

T = 0.1; % Tempo de amostragem
Delta = T/deltaT; % Taxa de decimação
xe = x(1:Delta:end); % Amostragem do sinal x(t)

% Gráfico superior
figure;
subplot(2,1,1); % Criando uma figura com dois gráficos
plot(t,x,'k'); % Sinal contínuo em preto
hold on;
stairs([0:length(xe)-1]*T,xe,'r'); % Sinal interpolado em vermelho
stem([0:length(xe)-1]*T,xe,'b'); % Sinal amostrado em azul
hold off;
xlabel('Tempo (s)');
ylabel('Amplitude');
title('Sinal Contínuo e Amostrado');
legend('Sinal Contínuo','Interpolado','Amostrado');

% Gráfico inferior
subplot(2,1,2);
plot([0:length(xe)-1],xe,'k*'); % Sinal discreto x[n] em preto com pontos
xlabel('Índice n');
ylabel('Amplitude');
title('Sinal Discreto');
legend('x[n]');