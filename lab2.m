% 3) Quadratic Program Implementation
% -------------------------
% Variables
% Cost of energy sources [$/MWh]
c = [100 90 130 108 111 90 144 87];

% Max total cost of energy [$/MWh]
c_tot = 100;

% Standard deviation of energy sources [$/MWh]
std = [22 30 15 20 30 36 32 40];

% Total energy demand [MWh]
d_tot = 225;

% -------------------------
% Formulation
% Objective function: 0.5x^TQx + R^Tx
% Q matrix
Q = 2 * diag(std.^2);

% R matrix
R = zeros([1 8]);

% Constraints: Ax ? b
% A matrix
A = [% Energy Amount
     -1 -1 -1 -1 -1 -1 -1 -1;
     % Cost
     c(1)-c_tot c(2)-c_tot c(3)-c_tot c(4)-c_tot c(5)-c_tot c(6)-c_tot c(7)-c_tot c(8)-c_tot;
     % Demand
     -1 0 0 0 0 0 0 0;
     0 -1 0 0 0 0 0 0;
     0 0 -1 0 0 0 0 0;
     0 0 0 -1 0 0 0 0;
     0 0 0 0 -1 0 0 0;
     0 0 0 0 0 -1 0 0;
     0 0 0 0 0 0 -1 0;
     0 0 0 0 0 0 0 -1];
 
% b matrix
b = [-d_tot 0 0 0 0 0 0 0 0 0];

% Solve quadratic program
% Optimized energy amounts from each source
x = quadprog(Q, R, A, b);

% -------------------------
% Problem 3
% Energy amounts from each source utilizing 2012 portfolio
x_3 = ([7.5 8.3 43.4 9 2.3 4.4 0.9 6.3]/100) * d_tot;

% Associated risk
r_3 = 0.5 * x_3 * Q * x_3';

% Associated cost
c_3 = dot(c, x_3);

% -------------------------
% Problem 4
% Total cost ranging from from 50 to 250
n = 100;
c_tot_4 = linspace(88, 250, n);

% Risk associated with total cost range
r_4 = zeros(n, 1);

% Determine optimum energy amount and corresponding risk for each total cost
for i = 1:n
    
    % Constraints: Ax ? b
    % A matrix
    A = [% Energy Amount
         -1 -1 -1 -1 -1 -1 -1 -1;
         % Cost
         c(1)-c_tot_4(i) c(2)-c_tot_4(i) c(3)-c_tot_4(i) c(4)-c_tot_4(i) c(5)-c_tot_4(i) c(6)-c_tot_4(i) c(7)-c_tot_4(i) c(8)-c_tot_4(i);
         % Demand
         -1 0 0 0 0 0 0 0;
         0 -1 0 0 0 0 0 0;
         0 0 -1 0 0 0 0 0;
         0 0 0 -1 0 0 0 0;
         0 0 0 0 -1 0 0 0;
         0 0 0 0 0 -1 0 0;
         0 0 0 0 0 0 -1 0;
         0 0 0 0 0 0 0 -1];

    % Solve quadratic program
    % Optimized energy amounts from each source
    [x, risk] = quadprog(Q, R, A, b);
    
    r_4(i) = risk;
    
end

% Plot of total cost vs. risk
plot(c_tot_4, r_4, 'LineWidth', 1.5);
xlabel('Total Energy Cost [$/MWh]');
ylabel('Risk [$^2]');
title('Total Energy Cost vs. Risk');

% -------------------------
% Problem 5
% Constraints: Ax ? b
% A matrix
A = [% Energy Amount
     -1 -1 -1 -1 -1 -1 -1 -1;
     % Cost
     c(1)-c_tot c(2)-c_tot c(3)-c_tot c(4)-c_tot c(5)-c_tot c(6)-c_tot c(7)-c_tot c(8)-c_tot;
     % Demand
     -1 0 0 0 0 0 0 0;
     0 -1 0 0 0 0 0 0;
     0 0 -1 0 0 0 0 0;
     0 0 0 -1 0 0 0 0;
     0 0 0 0 -1 0 0 0;
     0 0 0 0 0 -1 0 0;
     0 0 0 0 0 0 -1 0;
     0 0 0 0 0 0 0 -1;
     % Supply Limit
     1 0 0 0 0 0 0 0;
     0 1 0 0 0 0 0 0;
     0 0 1 0 0 0 0 0;
     0 0 0 1 0 0 0 0;
     0 0 0 0 1 0 0 0;
     0 0 0 0 0 1 0 0;
     0 0 0 0 0 0 1 0;
     0 0 0 0 0 0 0 1;
     % Renewable Portfolio Standard
     1/3 1/3 1/3 1/3 (1/3)-1 (1/3)-1 (1/3)-1 (1/3)-1];
 
% b matrix
b = [-d_tot 0 0 0 0 0 0 0 0 0 40 50 150 35 10 15 200 50 0];

% Solve quadratic program
% Optimized energy amounts from each source
[x_5, r_5] = quadprog(Q, R, A, b);