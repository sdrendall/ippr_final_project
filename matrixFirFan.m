%% matrixFirFan.m
clc; clear; close all;

%% set up spatial frequency coordinate space
hSize = [480,480];
numPixelRow = hSize(1);
numPixelColumn = hSize(2);
axisX = linspace(-pi,pi,numPixelRow);
axisY = linspace(-pi,pi,numPixelColumn);
[axisxx, axisyy] =  meshgrid(axisX, -axisY);

% in accordance with paper's syntax
z1 = axisxx;
z2 = axisyy;

%% Build filter from matrix definition
phi = pi/4; % fan orientation
theta = 0.1*pi; % aperature angle

a = 1 / tan(theta/2);
% a0 = 1; a1 = 1;
% b0 = 1;
% 
% x = [-3, -5, -7, -5, -3;...
%     -1, -3, -5, -3, -1;...
%     0, 0, 0, 0, 0;...
%     1, 3, 5, 3, 1;...
%     3, 5, 7, 5, 3];
% P_phi = cos(phi)*x - sin(phi)*x';
% Q_phi = sin(phi)*x + cos(phi)*x';

% A_2 = a0 * (Q_phi * Q_phi) - (a^2 * (P_phi * P_phi)) + 1j*a*a1 * (P_phi * Q_phi);
% B_2 = b0 * (Q_phi * Q_phi) - (a^2 * (P_phi * P_phi));

% A_1 = [0.2464, 0.9407, 1.1418, 0.4027, 0.0671;...
%       0.9407, 3.2233, 3.8917, 1.6092, 0.4027;...
%       1.1418, 3.8917, 6.1484, 3.8917, 1.1418;...
%       0.4027, 1.6092, 3.8917, 3.2233, 0.9407;...
%       0.0671, 0.4027, 1.1418, 0.9407, 0.2464];
%   
% B_1 = [0.0947, 0.1941, 0.0732, -0.0163, 0.0245;...
%       0.1941, -0.2738, -0.7181, 0.0774, 0.3112;...
%       0.0732, -0.7181, 1.0000, 2.8851, 1.2743;...
%       -0.0163, 0.0774, 2.8851, 3.6570, 1.1768;...
%       0.0245, 0.3112, 1.2743, 1.1768, 0.3131];

B_C1 = [0.3513, 1.01, 1.01, 0.3513];
A_C1 = [1, 0.9644, 0.6701, 0.088];

A_C = A_C1' * A_C1;
B_C = B_C1' * B_C1;

Hw1 = zeros(numPixelRow,numPixelColumn);
for iZ_1 = 1:numPixelRow
    for iZ_2 = 1:numPixelColumn
%         z_1 = [1, z1(iZ_1,iZ_2), z1(iZ_1,iZ_2)^2, z1(iZ_1,iZ_2)^3, z1(iZ_1,iZ_2)^4];
%         z_2 = [1, z2(iZ_1,iZ_2), z2(iZ_1,iZ_2)^2, z2(iZ_1,iZ_2)^3, z2(iZ_1,iZ_2)^4];
        
        z_1 = [1, z1(iZ_1,iZ_2), z1(iZ_1,iZ_2)^2, z1(iZ_1,iZ_2)^3];
        z_2 = [1, z2(iZ_1,iZ_2), z2(iZ_1,iZ_2)^2, z2(iZ_1,iZ_2)^3];
%         z_1 = [1, z1(iZ_1,iZ_2), z1(iZ_1,iZ_2).^2];
%         z_2 = [1, z2(iZ_1,iZ_2), z2(iZ_1,iZ_2).^2];
        
        Hw1(iZ_1,iZ_2) = (z_1 * B_C * z_2') / (z_1 * A_C * z_2');
    end
end

figure (1); mesh(z1,z2,abs(Hw1));
%zlim([0 1]);







