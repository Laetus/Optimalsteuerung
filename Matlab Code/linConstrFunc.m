function [Aineq,bineq,Aeq,beq] = linConstrFunc

%% Initialization
%
cOP = classOptimParam();    % constant Optimization Prameters
cCCP = classCarConstantParam(); % constant Car Parameters
n = cOP.n+1;

%% inequality constraints 

% inequality constraints matrix for acceleration constraints Mwh
% inequalities u_1 >= 0
Aineq1 = diag(repmat([1 0],1,n));
Aineq1 = Aineq1([1:2:2*n-1],:);
Aineq1 = [zeros(n,2*n),Aineq1];
if cCCP.Mwh_max_lin         % select 1 in classCarConstantParam to use the linear inequality contraints for Mwh_max
    Aineq1 = [-Aineq1;Aineq1];
    bineq1 = [cCCP.Mwh_min*ones(n,1);cCCP.Mwh_max*ones(n,1)];
else
    Aineq1 = -Aineq1;
    bineq1 = cCCP.Mwh_min*ones(n,1);
end

% inequality constraints matrix for decelaration constraints Fb
% first n rows inequalities u_2 >= 0
% second n rows inequalities u_2 <= Fb_max
Aineq2 = diag(repmat([0 1],1,n));
Aineq2 = Aineq2([2:2:2*n],:);
Aineq2 = [zeros(n,2*n),Aineq2];
Aineq2 = [-Aineq2;Aineq2];
bineq2 = [cCCP.Fb_min*ones(n,1);cCCP.Fb_max*ones(n,1)];

Aineq = [Aineq1;Aineq2];
bineq = [bineq1;bineq2];

%% equality contraints matrix for position and velocity
%
Aeq = zeros(3,4*n);

Aeq(1,1)=1; % first 2 rows is the initial condition X_0 = [y_0;v_0] = [0;0]
Aeq(2,2)=1;

Aeq(3,2*n)=1;   % final row is the condition v_n = 0
beq = zeros(3,1);
beq(2) = cOP.v0;

end