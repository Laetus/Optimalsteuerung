function dx = ODE(t, x, u, w, r)
% t time
% x state
% u control (cell array)
% wetter of the course (function handle)

cCCP = classCarConstantParam();     % constant Car Parameters
A = 1.4378946874;
%A = 0;
mu = [0.1, 1.6, -0.8];
fR = [0.015; 0.005; 0.001];
mur = 0.05;
c3 = 100;
%fR = zeros(3,1);

dx = zeros(5,1);
% system of differential equations
dx(1) = x(3) * cos(x(5)) + x(4) * sin(x(5));

dx(2) = x(3) * sin(x(5)) + x(4) * cos(x(5));


dx(3) = 1/cCCP.m *( u(1)/cCCP.R - u(2) ...
    - 0.5000 * cCCP.c_w * cCCP.rho * A * x(3)^2  ...
    -(fR(1) + fR(2)./30*x(3) + fR(3) * (x(3)./30)^4) * cCCP.m * cCCP.g);


Fres_Fs = x(3)^4 / (r)^2 + dx(3)^2  ...
    - ((mu(1) + mu(2) * w + mu(3) * w^2) * cCCP.g)^2;

%Fres_Fs = sqrt(x(3)^4 / (r)^2 + dx(3)^2 ) ...
%    - (mu(1) + mu(2) * w + mu(3) * w^2) * cCCP.g;

if(Fres_Fs > 0)
    if(Fres_Fs <= c3)
    %dx(4) = x(3)^2/(r)/dx(3) * Fres_Fs;
    %dx(4) = Fres_Fs * sin(atan(x(3)^2/dx(3)/r));
    dx(4) =  (Fres_Fs/c3)^5 *(x(3)^2/(r) - mur * cCCP.g) ;
    else
    dx(4) =  x(3)^2/(r) - mur * cCCP.g ;
    end
    %dx(4) = x(3)^1/(r)/dx(3)*Fres_Fs-0.5 *(fR(1)  + fR(2)./30*x(4) + fR(3) * (x(4)./30)^4) * cCCP.g;
else
    dx(4) = 0;
end


dx(5) = u(3);


end