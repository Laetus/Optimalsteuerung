function [c,ceq] = nonlinConstrFunc(z)

global global_testingODE

%% Initialization
%
cOP = classOptimParam();    % constant Optimization Prameters
ceq = zeros(cOP.n,1);       % Compute nonlinear equalities at z

testingODE = 0; % select 1 to get an plot of the y and v solution of ode45
if testingODE && global_testingODE
    testVal = [];
    testY = cell(1,cOP.n); 
    testT = cell(1,cOP.n);
end

h = cOP.tf/cOP.n;
n = cOP.n+1;
x = z(1:2*n);
u = z(2*n+1:4*n);

%% multiple shooting for nonlinear equality constraints
%
for i = 0:cOP.n-1   % shooting n-1 times
    [t,y] = ode15s(@(t, xx) constrODE(t, xx,u(2*i+1:2*i+2)),[i*h,(i+1)*h],x(2*i+1:2*i+2));
    % equality constraints (Stetigkeitsbed für die Knoten)
    % X(t_{i+1})-X_{i+1} = 0
    % with X(t_{i+1}) being y(end,1:2) the Runge Kutta approximation
    ceq(2*i+1,1) = y(end,1)-x(2*i+3);
    ceq(2*i+2,1) = y(end,2)-x(2*i+4);
    if testingODE && global_testingODE
        testVal(i+1,:) = [y(end,1) y(end,2)];
        testY{i+1} = y(:,1:2);
        testT{i+1} = t;
    end
end

if testingODE && global_testingODE
    % plot of multiple shooted position values y
    global_testingODE = 0;
    close all
    figure
    for i = 1:cOP.n
        subplot(2,1,1)
        plot(testT{i},testY{i}(:,1),'b-')
        hold on
        plot(testT{i}(1),testY{i}(1,1),'bo','MarkerSize',9,'MarkerFaceColor','b')
        plot(testT{i}(end),testY{i}(end,1),'bo')
        xlabel('t'); ylabel('x'); title('Multiple Shooting of position');
        subplot(2,1,2)
        plot(testT{i},testY{i}(:,2),'b-')
        hold on
        plot(testT{i}(1),testY{i}(1,2),'bo','MarkerSize',9,'MarkerFaceColor','b')
        plot(testT{i}(end),testY{i}(end,2),'bo')
        xlabel('t'); ylabel('v'); title('Multiple Shooting of velocity');
    end
end

%% nonlinear inequality constraints
%
cCCP = classCarConstantParam();     % constant Car Parameters

% c = R.*u(1:2:2*n-1)-R.*cCCP.R*(u(2:2:2*n)+R.*cCCP.F_A(x(2:2:2*n))+R.*cCCP.F_R*ones(n,1)+R.*cCCP.m*cCCP.a_max(x(2:2:2*n)));
% c = -R.*u(2:2:2*n)-R.*cCCP.F_A(x(2:2:2*n)) - R.*cCCP.F_R*ones(n,1)+ R.*cCCP.m*cCCP.a_max(x(2:2:2*n));

if cCCP.Mwh_max_lin
    c = [];
else
    c = u(1:2:2*n-1)./cCCP.R   -  cCCP.m*cCCP.a_max(x(2:2:2*n));
end

end