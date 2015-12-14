function [synthI,x,y] = genSynthLines(theta,numLines,Isize)
%% synthI = genSynthLines(theta,numLines,Isize)
% INPUTS:
% theta - [1 x N] list of angles you wish to generate
% numLines - [scalar] number of lines to display per angle
% Isize - [numRows, numColumns] size of synthetic image
%
% OUTPUTS:
% synthI  - [numRows x numColumns] binary image of straight lines
% x and y - [numRows x numColumns] meshgrid output for plotting
synthI = zeros(Isize(1),Isize(2));
a
% convert to radians
theta = theta * pi/180;
for i = 1:length(theta)
    % get slopes in x and y direction
    u = cos(theta(i));
    v = sin(theta(i));
    
    % generate mesh grid
    [x,y] = meshgrid(linspace(-pi,pi,Isize(1)),-linspace(-pi,pi,Isize(2)));
    
    % make plane wave
    synthI_temp = sin((numLines*u*y + numLines*v*x) - (pi/2));
    
    % create binary image
    synthI_temp2 = zeros(Isize(1),Isize(2));
    synthI_temp2(synthI_temp > 0) = 1;
    synthI_temp = synthI_temp2;
    
    % add new angle and re-threshold
    synthI = synthI + synthI_temp;
    synthI_temp2 = zeros(Isize(1),Isize(2));
    synthI_temp2(synthI > 0) = 1;
    synthI = synthI_temp2;
    
end

end