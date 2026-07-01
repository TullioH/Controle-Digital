function f = funcao_custo(x0,yref,Ts,t,Gz)

% Parametros do controlador a serem otimizados
kp = x0(1);
ki = x0(2);
kd = x0(3);

% Simulacao do sistema em malha fechada
Gc = pid(kp,ki,kd,0,Ts,'IFormula','BackwardEuler');
tempo = [0:Ts:t-Ts];
y = step(feedback(Gc*Gz,1),tempo);

% Funcao custo: erro quadratico entre a saida e a referencia filtrada
f = sqrt(sum(abs(y-yref).^2));
end
