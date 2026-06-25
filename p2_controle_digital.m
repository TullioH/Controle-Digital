%% Avaliação 2 - Estabilidade
% Nome: Alexandre Reis Francisco Júnior
% Data: 27/05/2026

%% Questão 1
% Limpeza de Área de Trabalho
clc; close all; clear all;
s = tf('s');

% Função de Transferência da Planta
disp('Gs');
Gs = 3/(s+2)

% Período de amostragem
T = 0.1;

% Função de Transferência Malha Aberta no domínio z.
disp('Gz');
Gz = c2d(Gs, T)

% Aproximação de tempo contínuo de Tustin
disp('Gw');
Gw = d2c(Gz,'tustin')

%% Questão 2
% Limpeza de Área de Trabalho
clc; close all; clear all;
s = tf('s');

% Função de Transferência da Planta
disp('Gs');
Gs = 3/(s+2)

% Período de amostragem
T = 0.1;

% Função de Transferência Malha Aberta no domínio z.
disp('Gz');
Gz = c2d(Gs, T)

% Aproximação de tempo contínuo de Tustin
disp('Gw');
Gw = d2c(Gz,'tustin')