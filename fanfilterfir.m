%function fanfilterfir(p,q,B)
clc; clear; close all;
numPixelRow = 200;
numPixelColumn = 200;
p = 1; q = -1; B = 0.8*pi;
%% make mesh grid in spatial domain
%[numPixelRow, numPixelColumn] = size(image);
axisM = linspace(0,numPixelColumn,numPixelColumn);
axisN = linspace(0,numPixelRow,numPixelRow);
[m,n] =  meshgrid(axisM,axisN);

%% make mesh grid in frequency domain
axisU = linspace(-pi,pi,numPixelColumn);
axisV = linspace(-pi,pi,numPixelRow);
[u,v] =  meshgrid(axisU,axisV);

%% build spatial domain filter using analytical filter
intRegionV = ((v > -B) & (v < B));
intRegionU1 = ((v/p) > u) & ((v/q) < u);
intRegionU2 = ((v/p) < u) & ((v/q) > u);
intRegionAll = intRegionV & (intRegionU1 | intRegionU2);

%figure; imagesc(intRegionAll)
uGrid = zeros(size(u));
uGrid(intRegionAll) = u(intRegionAll);
vGrid = zeros(size(v));
vGrid(intRegionAll) = v(intRegionAll);
% uGrid = u(intRegionAll);
% vGrid = v(intRegionAll);
h = zeros(size(u));
normSum = 1;
for uIdx = 1:length(uGrid)
    for vIdx = 1:length(vGrid)
        if intRegionAll(uIdx,vIdx) ~= 0
            h = h + 2*cos(m*uGrid(uIdx,vIdx) + n*vGrid(uIdx,vIdx));
            normSum = normSum + 1;
        end
    end
    disp(vIdx)
end
h = h / (4*pi^2 * normSum);
%figure (1); mesh(h)

figure (2);
mesh(abs(fftshift(fft2(h))))