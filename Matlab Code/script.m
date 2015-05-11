close all; clc

%% Saving command window output
%
diary
diary('Johannes Diary')
diary on

%% 
%
cOP = classOptimParam();    % constant Optimization Prameters
cCCP = classCarConstantParam(); % constant Car Parameters

n = cOP.n+1;      % number of intervals +1
tf = cOP.tf;    % time to run from 0 to tf
h = cOP.tf/cOP.n;


% x = zeros(2*n,1);   % x = [y;v] y: Position v: velocity
% u = zeros(2*n,1);   % u = [Mwh;Fb]  Mwh: acceleration   Fb: deceleration
% z = [x;u];



%% Linear contraints
%

[Aineq,bineq,Aeq,beq] = linConstrFunc();

%% Initial point
%

zMin = zeros(4*n,1);   % random initial vector
zMin(1:2:2*n-1) = 1:1:length(0:2:2*n-1);
zMin(2:2:2*n) = linspace(0, 30,n); 
zMin(2*n+1:2:4*n-1) = 100.*ones(n,1);
% approximating the initial vector
zMin(1) = 0;              % y_0 = 0
zMin(2) = 0;              % v_0 = 0
z0(2*n) = 0;             % v_n = 0
zMin(2*n+2:2:4*n) = 0;    % Fb_i = 0 

%% Optimization parameters
%

options                 = optimoptions('fmincon');
options.Algorithm       = 'interior-point';
options.Display         = 'iter';
options.MaxFunEvals     = 20000;


%% Phase 1
%

zMin = fmincon(@(z) 0, zMin,Aineq,bineq,Aeq,beq,[],[],[],options);



zMin = fmincon(@(z) 0, zMin,Aineq,bineq,Aeq,beq,[],[],@nonlinConstrFunc,options);

z0 = zMin;

%load zMin;
%z0 = zMin;

%% Optimization
%

tic
[zMin, costFuncVal, ~, output] = fmincon(@costFunc,zMin,Aineq,bineq,Aeq, ...
                                    beq,[],[],@nonlinConstrFunc,options);
OPtime = toc;

%% Plot output
%

figure
subplot(2,2,1)
stairs(0:h:tf,zMin(1:2:2*n-1))
title('Solution position y')
xlabel('Time [s]') 
ylabel('Path [m]') 
subplot(2,2,2)
stairs(0:h:tf,zMin(2:2:2*n))
title('Solution velocity v')
xlabel('Time [s]') 
ylabel(' v [m/s]')
subplot(2,2,3)
stairs(0:h:tf,zMin(2*n+1:2:4*n-1))
title('Solution acceleration torque Mwh')
xlabel('Time [s]') 
ylabel(' M_{wh} [Nm]')
subplot(2,2,4)
stairs(0:h:tf,cCCP.R.*zMin(2*n+2:2:4*n))
title('Solution deceleration torque R*Fb')
xlabel('Time [s]') 
ylabel('F_B [Nm]')


%% Save figure as pdf 
%

filename = ['Output_' datestr(now, 'ddmmyy') '_n_' num2str(n) ...
    '_iterations_' num2str(output.iterations) ...
    '_Time_' num2str(ceil(OPtime))];
saveas(gca, filename, 'pdf');

clear filename

%% Saving workspace variables to file
% 
save(  [ 'Output_' datestr(now, 'ddmmyy') '_n_' num2str(n) ...
    '_iterations_' num2str(output.iterations) ...
    '_Time_' num2str(ceil(OPtime))]);

