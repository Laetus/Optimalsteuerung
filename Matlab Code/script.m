close all; clc

cOP = classOptimParam();    % constant Optimization Prameters
cCCP = classCarConstantParam(); % constant Car Parameters

n = cOP.n+1;      % number of intervals
tf = cOP.tf;    % time to run from 0 to tf
h = cOP.tf/cOP.n;

x = zeros(2*n,1);   % x = [y;v] y: Position v: velocity
u = zeros(2*n,1);   % u = [Mwh;Fb]  Mwh: acceleration   Fb: deceleration
z = [x;u];

[Aineq,bineq,Aeq,beq] = linConstrFunc();

z0 = rand(4*n,1);   % random initial vector
% approximating the initial vector
z0(1) = 0;              % x_0 = 0
z0(2) = 0;              % v_0 = 0
z0(2*n) = 0;            % v_n = 0
z0(2*n+2:2:4*n) = 0;    % Fb_i = 0 

% Optimization parameters
options                 = optimoptions('fmincon');
options.Algorithm       = 'interior-point';
options.Display         = 'iter';
options.MaxFunEvals     = 6000;

tic
z0 = fmincon(@(z) 0, z0,Aineq,bineq,Aeq,beq,[],[],@nonlinConstrFunc,options);
load zMin;
%z0 = zMin;
zMin = fmincon(@costFunc,z0,Aineq,bineq,Aeq,beq,[],[],@nonlinConstrFunc,options);
t = toc

figure
subplot(2,2,1)
plot(0:h:tf,zMin(1:2:2*n-1))
title('Solution position y')
subplot(2,2,2)
plot(0:h:tf,zMin(2:2:2*n))
title('Solution velocity v')
subplot(2,2,3)
stairs(0:h:tf,zMin(2*n+1:2:4*n-1))
title('Solution acceleration Mwh')
subplot(2,2,4)
plot(0:h:tf,zMin(2*n+2:2:4*n))
title('Solution deceleration Fb')
