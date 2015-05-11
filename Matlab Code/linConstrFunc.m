function [Aineq,bineq,Aeq,beq] = linConstrFunc

cOP = classOptimParam();    % constant Optimization Prameters
cCCP = classCarConstantParam(); % constant Car Parameters
n = cOP.n+1;

% inequality constraints matrix for acceleration constraints Mwh
% inequalities u_1 >= 0
Aineq1 = diag(repmat([1 0],1,n));
Aineq1 = Aineq1([1:2:2*n-1],:);
Aineq1 = [zeros(n,2*n),Aineq1];
Aineq1 = -Aineq1;
bineq1 = repmat(cCCP.Mwh_min,n,1);

% inequality constraints matrix for decelaration constraints Fb
% first n rows inequalities u_2 >= 0
% second n rows inequalities u_2 <= Fb_max
Aineq = diag(repmat([0 1],1,n));
Aineq = Aineq([2:2:2*n],:);
Aineq = [zeros(n,2*n),Aineq];
Aineq = [-Aineq;Aineq];
bineq = [cCCP.Fb_min*ones(n,1);cCCP.Fb_max*ones(n,1)];

Aineq = [Aineq1;Aineq];
bineq = [bineq1;bineq];

% equality contraints matrix for position and velocity
Aeq = zeros(3,4*n);

Aeq(1,1)=1; % first 2 rows is the initial condition X_0 = [y_0;v_0] = [0;0]
Aeq(2,2)=1;

Aeq(3,2*n)=1;   % final row is the condition v_n = 0
beq = zeros(3,1);
beq(2) = cOP.v0;

end