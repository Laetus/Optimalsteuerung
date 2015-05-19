classdef classCarConstantParam < handle
    % classCarParam providing parameters for the dynamics of our car
    
    properties
        Fb_min = 0;             % minimum braking force
        Fb_max = 15000;         % maximum braking force [N]
        Mwh_min = 0;            % minimum acceleration force
        Mwh_max = 300;          % maximum acceleration force
        Mwh_max_lin = 1;        % select 1 to use the linear constraint for Mwh_max, otherwise the nonlinear constraint is used
        m = 1239;               % mass of car [kg]
        R = 0.302;              % radius of wheel [m]
        c_w  = 0.3;             % air drag coefficient [1]
        rho = 1.249512;         % air density [kg/m^3]
        A = 1.4378946874;       % effective flow surface [m^2]
        f_Rcoeff = 0.015;            % friction coefficient [1]
        g = 9.81;               % acceleration of gravity [m/s^2]
        
    end
    
    methods
        % other functions
        function f = F_R(obj)
            f = obj.f_Rcoeff * obj.m * obj.g;
        end
        
        function a = a_max(obj,v)
            %a = obj.g*0.2500*(-5/3e-6*v.^4+0.229167e-3*v.^3-0.01033333*v.^2+0.132083*v+1);
            a = obj.g*0.25*(-1.666667e-6*v.^4 + 0.229167e-3*v.^3 - 0.01033333*v.^2 + 0.132083*v + 1);
        end
        
        function f = F_A(obj,v)
            f = 0.5*obj.c_w*obj.rho*obj.A*v.^2;
        end
    end
end