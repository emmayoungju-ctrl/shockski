clear; clc;

%% load data
load('green1a_2.mat')
load('red1a_2.mat')

%% calculation
index = 0;
shockpot = zeros(length(x_pixelR),2);

for i = 1:length(x_pixelG)
    index = index + 1;
    xGreen = x_pixelG(index);
    yGreen = y_pixelG(index);
    xRed = x_pixelR(index);
    yRed = y_pixelR(index);
    time = index*(1/60);
    distance = sqrt((xRed - xGreen)^2 + (yRed - yGreen)^2);
    shockpot(index,:) = [time, distance];
end

% normalizing pixels to inches
shockpot(:,2) = shockpot(:,2)/(1330/13);
% matlab
    % first ref: 2s 1178.151228364043
    % second ref: last frame 1347.196242650222
% imagej
    % first ref: 1319.9795
    % second ref: 1332.4222
plot(shockpot(:,1), shockpot(:,2),'LineWidth',1)
title("Shock Length Over Time")
xlabel("Time (s)")
ylabel("Distance (pixels)")
grid on

%% documentation
% shockpot: first column -- time
            % second column -- distance in pixels
%  save("shockpot_1a_2_inch.mat","shockpot")