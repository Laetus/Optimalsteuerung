function dx = constrODE(~,x,u)

cCCP = classCarConstantParam();     % constant Car Parameters

dx = zeros(2,1);
% system of differential equations
dx(1) = x(2); 
dx(2) = 1/cCCP.m*(u(1)/cCCP.R-u(2)-cCCP.F_A(x(2)));

end