function [x,y,u,v] = getQuiverPlot(Isize)
%% getQuiverPlot.m
% INPUTS:
% Isize - [numRows, numColumns] size of synthetic image
%
% OUTPUTS:
% u and v  - [numRows x numColumns] i and j components of each quiver
% x and y - [numRows x numColumns] meshgrid output for plotting

%%

% generate mesh grid
[x,y] = meshgrid(linspace(0,pi,Isize(1)),-linspace(0,pi,Isize(2)));
theta = atan(y./x);
u = cos(theta);
v = sin(theta);

figure (1);
quiver(x,y,u,v);

end