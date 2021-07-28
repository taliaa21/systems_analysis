%% CE 191 - Systems Analysis
%   Lab 4 : WIFI for All!
%   Prof. Arnold
%   Spring 2020

% Lab4.m

%%
clear
fs = 16;

%% Problem 3
% Input problem parameters
load density;
R_max = 0.3;

x0_vec = 0:0.1:1;
y0_vec = 0:0.1:1;

f_mat = zeros(11);
for ii = 1:11
    for jj = 1:11
        z = [x0_vec(ii), y0_vec(jj), R_max];
        f_mat(ii,jj) = coverage(z,rho);
    end
end

% PLOT OBJECTIVE AS FUNCTION OF (X0,Y0), GIVEN R = RMAX
% Surf plot of density function
figure(1);
xx = linspace(0,1,size(rho,1));
yy = linspace(0,1,size(rho,2));
surf(xx, yy, rho);
xlabel('x', 'FontSize', fs);
ylabel('y', 'FontSize', fs);
zlabel('density', 'FontSize', fs);
title('Density Function Surface Plot', 'FontSize', fs);

% Surf plot of objective function
figure(2);
surf(x0_vec, y0_vec, f_mat);
xlabel('x0', 'FontSize', fs);
ylabel('y0', 'FontSize', fs);
zlabel('objective', 'FontSize', fs);
title('Objective Function Surface Plot', 'FontSize', fs);

%% Problem 4
% Inequality constraints
A = [-1 0 1; 1 0 1; 0 -1 1; 0 1 1];
b = [0 1 0 1];

% Upper and lower bounds
lb = [0 0 0];
ub = [1 1 R_max];

% Initial Guess
z0 = [0.5, 0.5, 0.25];

% Optimization Options
opts = optimset('Display','iter','TolFun',5e-6);

% Nonlinear Optimizer
[zstar,fstar,exitflag,~,lambda] = ...
    fmincon(@(z) coverage(z,rho), z0, A, b,[],[],lb,ub,[],opts);

% Parse Optimal Solution
x0star = zstar(1);
y0star = zstar(2);
Rstar = zstar(3);

% Compute Geocode. You can plug this into Google Maps 
% to see where the optimal tower location would be!
lat = 37.858871 + x0star*(37.878715 - 37.858871);
lon = -122.282841 + y0star*(-122.252751 - (-122.282841));
fprintf(1,'(latitude,longitude) = (%3.6f,%3.6f)\n',lat,lon);
