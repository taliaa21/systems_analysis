%% CE 191 - Systems Analysis
%   Lab 5 : Cal Band
%   Oski Bear, SID 18681868
%   Prof. Arnold
%   Due 4/20 at 4pm

% Lab5.m

clear;

%% Parameters
% Number of Cal Band members
M = 40;

% Grid size;
nx = 25;
ny = 20;

% Grid
x_vec = 1:nx;
y_vec = 1:ny;

% Planning horizon (time steps)
N = 24;

% Preallocate Value Function
V = inf*ones(nx*ny,N,M);

%% Load Script Cal
load scriptcal.mat  % Courtesy of Kat Chang (Cal Band, Stunt '05)

% Plot Script Cal final formation
figure(1); clf;
plot(XN(:,2), XN(:,3), 'o', 'MarkerFaceColor', 'b')
xlim([0 nx])
ylim([0 ny])

% Value Function Boundary Condition
for i = 1:M
    ind = sub2ind([nx,ny],XN(i,2),XN(i,3));
    V(ind, end, i) = 0;
end

%% Admissible Controls

% Preallocate array of cells for admissible control 
Uadmis = cell(nx,ny);

% Iterate over x
for i = 1:nx
    % Iterate over y
    for j = 1:ny
        
        if(i == 1 && j == 1)  % Southwest corner
            Uadmis{i,j} = [0 0; 0 1; 1 1; 1 0];
        elseif(i == 1 && j == ny) % Northwest corner
            Uadmis{i,j} = [0 0; 0 -1; 1 0; 1 -1];
        elseif(i == nx && j == 1) % Southeast corner
            Uadmis{i,j} = [0 0; 0 1; -1 0; -1 1];
        elseif(i == nx && j == ny) % Northeast corner
            Uadmis{i,j} = [0 0; 0 -1; -1 0; -1 -1];
        elseif(i == 1)  % West border
            Uadmis{i,j} = [0 0; 0 1; 0 -1; 1 1; 1 0; 1 -1];
        elseif(i == nx) % East border
            Uadmis{i,j} = [0 0; 0 1; 0 -1; -1 1; -1 0; -1 -1];
        elseif(j == 1) % South border
            Uadmis{i,j} = [0 0; 1 0; -1 0; -1 1; 0 1; 1 1];
        elseif(j == ny) % North border
            Uadmis{i,j} = [0 0; 1 0; -1 0; -1 -1; 0 -1; 1 -1];
        else            % All interior points
            Uadmis{i,j} = [0 0; 0 1; 1 1; 1 0; 1 -1; 0 -1; -1 -1; -1 0; -1 1];
        end
        
    end
end

%% Solve DP

% Preallocate Control
Ustar = cell(nx*ny,N,M);

% Iterate across Calbandsmen
for m = 1:M
    
    % Iterate backward in time
    for k = (N-1):-1:1
    
        % Iterate over x
        for i = 1:nx
            % Iterate over y
            for j = 1:ny
        
                % Subscript to index
                ind = sub2ind([nx,ny],i,j);
                ind_nxt = sub2ind([nx,ny], i+Uadmis{i,j}(:,1), j+Uadmis{i,j}(:,2));
                
                % Cost-per-time-step
                c = sqrt(((Uadmis{i,j}(:,1)).^2) + ((Uadmis{i,j}(:,2)).^2));
                
                % Value Function
                [V(ind, k, m), idx] = min(c + V(ind_nxt, k+1, m));
                
                % Save Optimal Control
                Ustar{ind, k, m} = Uadmis{i, j}(idx, :);
                
            end
        end
    end
end

%% Animate!

% Random Initial Condition
% x0 = ceil(rand(1,M)*nx);
% y0 = ceil(rand(1,M)*ny);

% March on from the student section side
% [x0,y0] = ind2sub([nx,ny],1:M);

% Rectangle initial condition
x0 = x0rect;
y0 = y0rect;

x = zeros(N,M);
y = zeros(N,M);
x(1,:) = x0;
y(1,:) = y0;

for k = 1:(N-1)
    
    % Plot band member location in a for loop
    figure(2); clf;
    plot(x(k, :), y(k, :), 'o', 'MarkerFaceColor', 'b')
    xlim([0,nx]);
    ylim([0,ny]);
    set(gca,'FontSize',14);
    grid on;
    
    pause(1);   % Adjust animation speed here
    
    % Band member dynamics with optimal control Ustar [Eqn (1,2) in lab handout]
    ind = sub2ind([nx,ny],x(k,:),y(k,:));
    for m = 1:M
        x(k+1,m) = x(k, m) + Ustar{ind(m), k, m}(1);
        y(k+1,m) = y(k, m) + Ustar{ind(m), k, m}(2);
    end
    
end

% Plot last time step
figure(2); clf;
plot(x(end, :), y(end, :), 'o', 'MarkerFaceColor', 'b')
xlim([0,nx]);
ylim([0,ny]);
set(gca,'FontSize',14);
grid on;