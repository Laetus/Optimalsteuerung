z0 = 15000 .*ones(4*n,1);
Aineq * z0

z0 = -15000 .*ones(4*n,1);
Aineq * z0

z0(1:2*n) = 0;
Aineq * z0
