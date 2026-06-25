close all; clear all; clc;

s = tf('s');
T = 0.2; % Período de amostragem [segundos]
Gp = 3/(s*(s+3));
Gz = c2d(Gp, T)

Gw = d2c(Gz,'tustin')

