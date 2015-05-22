function dx = ODE(t, x, u, w, r)
% t time
% x state
% u control (cell array)
% wetter of the course (function handle)

cCCP = classCarConstantParam();     % constant Car Parameters
A = 1.4378946874;
%A = 0;
mu = [0.1, 1.6, -0.8];
fR = [0.8e-2; 0.15e-2; 0.08e-2];
%fR = zeros(3,1);

dx = zeros(5,1);
% system of differential equations
dx(1) = x(3) * cos(x(5)) + x(4) * sin(x(5));

dx(2) = x(3) * sin(x(5)) + x(4) * cos(x(5));


dx(3) = 1/cCCP.m *( u(1)/cCCP.R - u(2) ...
    - 0.5000 * cCCP.c_w * cCCP.rho * A * x(3)^2  ...
    -(fR(1) + fR(2)./100./3.6 *x(3) + fR(3) * (x(3)./100./3.6)^4) * cCCP.m * cCCP.g);


Fres_Fs = sqrt( x(3)^4 / (r)^2 + dx(3)^2 ) ...
    - (mu(1) + mu(2) * w + mu(3) * w^2) * cCCP.g;

if(Fres_Fs > 0)
    if abs(dx(3)) < 1e-3
        error('verdammt')
    end
    dx(4) = x(3)^2/(r)/dx(3) * Fres_Fs;
else
    dx(4) = 0;
end


dx(5) = u(3);


end