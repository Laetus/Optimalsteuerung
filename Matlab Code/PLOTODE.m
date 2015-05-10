%% Plot ODE
% 

x = zMin(1:2*n);
u = zMin(2*n+1:4*n);

for i = 0:cOP.n-1   % shooting n-1 times
    [t,y] = ode45(@(t, xx) constrODE(t, xx,u(2*i+1:2*i+2)),[i*h,(i+1)*h],x(2*i+1:2*i+2));
    % equality constraints (Stetigkeitsbed für die Knoten)
    % X(t_{i+1})-X_{i+1} = 0
    % with X(t_{i+1}) being y(end,1:2) the Runge Kutta approximation
    hold on
    plot(t, y)
end