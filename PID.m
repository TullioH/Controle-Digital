%% Controlador PID - Proporcional, Integral e Deriativo
clc; close all;

%      +       |----|      |----|
% R(z)-->O---->| Gc |----->| Gp |-------> C(z)
%        Î-    |----|      |----|   |
%        |                          |
%        |--------------------------|

Ts = 0.1; % segundos
Gp = zpk([],[0.1 0.5],1,Ts);
kp = 0.03;
ki = 0.3;
kd = 0.0007;
N = 0;
Gc = pid(kp,ki,kd,N,Ts,'IFormula','BackwardEuler');

% Modelos de Malha Fechada
Gmf1 = feedback(Gp,1);      % Malha Fechada sem Controlador
Gmf2 = feedback(Gc*Gp,1);   % Malha Fechada com Controlador

% Solução das Equações de Diferenças
time = 10/Ts;       % Tempo da Simulação
r = ones(1,time);   % Degrau Unitário

% Simulação da Planta Discreta - Eq. Diferenças
for k = 1:time
    switch k
        case 1
        y1(k) = 0;
        y(k) = 0;
        e(k) = r(k) - y(k);
        u(k) = kp*e(k)+ki*Ts*e(k)+(kd/Ts)*e(k);
        
        case 2
        y1(k) = 0;
        y(k) = 0;
        e(k) = r(k) - y(k);
        u(k) = u(k-1)+kp*e(k)-kp*e(k-1)+ki*Ts*e(k)+(kd/Ts)*(e(k)-2*e(k-1));
            
        otherwise
        y1(k) = 0.6*y1(k-1)-1.05*y1(k-2)+r(k-2);
        y(k) = 0.6*y(k-1)-0.05*y(k-2)+u(k-2);
        e(k) = r(k) - y(k);
        u(k) = u(k-1)+kp*e(k)-kp*e(k-1)+ki*Ts*e(k)+(kd/Ts)*(e(k)-2*e(k-1)+e(k-2));
    end
end

% Plotar resposta Equações de Diferenças e Comparar com Step Matlab
subplot(3,1,1)
step(Gmf1,10); hold on; stairs([0:(time-1)]*Ts,y1,'rx');
title('Sistema Malha Fechada Sem Controlador'); legend('Solução Comando Step','Solução Equação de Diferenças')

subplot(3,1,2)
step(Gmf2,10); hold on; stairs([0:(time-1)]*Ts,y,'rx');
title('Sistema Malha Fechada com Controlador'); legend('Solução Comando Step','Solução Equação de Diferenças')

subplot(3,1,3)
stairs(saida_simulink.time,saida_simulink.signals.values); hold on
stairs([0:(time-1)]*Ts,y,'rx');
title('Saída Simulink PID Discreto'); legend('Saída Simulink','Solução Equação de Diferenças')