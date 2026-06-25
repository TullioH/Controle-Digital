function f = funcao_custo(x0,yref,Ts,t,Gz)

% Parâmetros do controlador à serem otimizados
kp=x0(1);
ki=x0(2);
kd=x0(3);

% Simulação do Sistema
Gc=pid(kp,ki,kd,0,Ts,'IFormula','BackwardEuler');
tempo=[0:Ts:t-Ts];
y=step(feedback(Gc*Gz,1),tempo);

% Função Custo Obtida pelos Objetivos do Controle
f = sqrt(sum(abs(y-yref).^2));
end