%% ODE Test
%


%% Weather w
%
w = 1; 

%% control
%
u = zeros(3,1);
u(1) = 400;
u(2) = 0;
u(3) = 0.1;

%% 
%
r =  200; % radius of test course

%%
%

z0 = zeros(5,1);
z0(3) = 10;

[T, Y] = ode15s( @(t, x) ODE(t, x, u, w, r), [0 120], z0);

%%
%
clf

subplot(2,2,1)
plot( Y(:, 1), Y(:, 2));
title('y vs z')
xlabel('y [m]')
ylabel(' z[m]')

pathlength = sum(sqrt(Y(:, 1).^2 + Y(:, 2).^2)); 

subplot(2,2,2)

plot(T, Y(:,4));
title('v_r(t)')
xlabel('Time t  [s]')
ylabel(' v_r(t) [m/s]')


subplot(2,2,3)

plot(T, Y(:, 3))
xlabel('Time t [s]')
ylabel('v(t) [m/s]')
hold on
plot(10, 100/3.6, 'o' )

