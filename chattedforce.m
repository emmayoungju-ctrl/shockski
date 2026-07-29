%% Spring Force Calculation
% Converts measured shock length/travel into spring compression and spring force.
% The spring force is calculated using Hooke's Law:
%
%       F_spring = k * x
%
% where:
%       F_spring = spring force [lb]
%       k        = spring rate [lb/in]
%       x        = spring compression from equilibrium/free length [in]
%
% Notes:
% - Compression should be measured relative to the chosen unloaded or equilibrium shock length.
% - Positive compression corresponds to the shock getting shorter.

load('shockpot_1a_2_inch.mat');
data = shockpot;

% data(:,1) = time
% data(:,2) = measured spring length/distance in inches

time = data(:,1);
L = data(:,2);          % measured spring length, inches

L_eq = 16;              % equilibrium length, inches
k = 62.5;                % spring rate, lb/in CHANGE THIS

compression = L_eq - L; % positive if spring is shorter than equilibrium

F_spring = k .* compression;  % spring force in lb

% Optional: if you only want compression force and no tension
F_spring(F_spring < 0) = 0;

% Plot
figure;
plot(time, F_spring, 'LineWidth', 1.5);
xlabel('Time (s)');
ylabel('Spring Force (lb)');
title('Spring Force vs Time');
grid on;