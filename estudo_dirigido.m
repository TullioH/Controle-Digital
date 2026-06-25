% Limpeza de Área de Trabalho
close all; clear all; clc;

s = tf('s');
T = 0.1; % Período de amostragem [segundos]
Gp = 2/(s*(s+2));
Gz = c2d(Gp, T)

Gw = d2c(Gz,'tustin')
FTMFs = feedback(Gw,1)

