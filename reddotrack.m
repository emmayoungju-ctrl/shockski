clc; clear; close all;
% ITERATION 1
% REQUIRES IMAGE PROCESSING TOOLBOX
% tracking neon red dot
%% Load video
videoFile = "maytest1a.mp4";   % CHANGE THIS                                       % import video file
v = VideoReader(videoFile);                                                 % create object with video

%% Read first frame and choose dot
frame1 = readFrame(v);                                                      % extract frame 1

figure;
imshow(frame1);                                                             % display frame1 in figure
title("Click the center of the marked dot");                                % user prompt
[x_prev, y_prev] = ginput(1);                                               % ginput: identifies coordinates of (1) mouse click 
close;

%% Tracking settings
searchRadius = 300;     % pixels around previous dot location                % define search area
minArea = 5;           % minimum detected dot area in pixels                % minimum area of dot present

% For red dot
hueLow1 = 0.00;
hueHigh1 = 0.05;

hueLow2 = 0.95;
hueHigh2 = 1.00;

satMin = 0.40;
valMin = 0.30;

%% Reset video
v.CurrentTime = 0;                                                          % reset ReadFrame

%% Storage
frame_num = [];                                                             % frame number
time_sec = [];                                                              % time?
x_pixelR = [];
y_pixelR = [];

frameIndex = 0;

%% Track dot through video
while hasFrame(v)

    frame = readFrame(v);
    frameIndex = frameIndex + 1;

    currentTime = v.CurrentTime;

    [H, W, ~] = size(frame);

    %% Crop around previous dot location
    xMin = max(round(x_prev - searchRadius), 1);
    xMax = min(round(x_prev + searchRadius), W);
    yMin = max(round(y_prev - searchRadius), 1);
    yMax = min(round(y_prev + searchRadius), H);

    crop = frame(yMin:yMax, xMin:xMax, :);

    %% Convert crop to HSV
    hsvCrop = rgb2hsv(crop);

    Hc = hsvCrop(:,:,1);
    Sc = hsvCrop(:,:,2);
    Vc = hsvCrop(:,:,3);

    %% Detect red dot
    dotMask = ((Hc > hueLow1 & Hc < hueHigh1) | ...
           (Hc > hueLow2 & Hc < hueHigh2)) & ...
           (Sc > satMin) & ...
           (Vc > valMin);

    %% Clean mask
    dotMask = bwareaopen(dotMask, minArea);

    %% Find dot centroid
    stats = regionprops(dotMask, "Centroid", "Area");

    if ~isempty(stats)
        % Choose largest detected colored blob
        [~, idx] = max([stats.Area]);
        centroid = stats(idx).Centroid;

        x_dot = xMin + centroid(1) - 1;
        y_dot = yMin + centroid(2) - 1;

        % Update previous location
        x_prev = x_dot;
        y_prev = y_dot;
    else
        % If dot is not found, keep previous location
        x_dot = x_prev;
        y_dot = y_prev;
    end

    %% Store results
    frame_num(end+1,1) = frameIndex;
    time_sec(end+1,1) = currentTime;
    x_pixelR(end+1,1) = x_dot;
    y_pixelR(end+1,1) = y_dot;
end

%% Put results into table
trackingData = table(frame_num, time_sec, x_pixelR, y_pixelR);

%% Save results
writetable(trackingData, "dot_tracking_pixels.csv");

disp("Tracking complete.");
disp("Saved data to dot_tracking_pixels.csv");

%% Plot x and y pixel location vs frame
figure;
plot(frame_num, x_pixelR, "LineWidth", 1.5);
xlabel("Frame Number");
ylabel("x Pixel Location");
title("Dot x Pixel Location vs Frame");
grid on;

figure;
plot(frame_num, y_pixelR, "LineWidth", 1.5);
xlabel("Frame Number");
ylabel("y Pixel Location");
title("Dot y Pixel Location vs Frame");
grid on;

%% Optional: plot dot path in image coordinates
figure;
plot(x_pixelR, y_pixelR, "LineWidth", 1.5);
set(gca, "YDir", "reverse");
xlabel("x Pixel Location");
ylabel("y Pixel Location");
title("Dot Path in Video Frame");
grid on;
axis equal;

%% used to save

% x_pixelR1a = x_pixelR;
% y_pixelR1a = y_pixelR;
% save("red1a.mat","x_pixelR1a","y_pixelR1a")
