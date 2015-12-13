function fanFilter = getFanFilter(hSize,thetaLow,thetaHigh,B)
% make mesh grid
numPixelRow = hSize(1);
numPixelColumn = hSize(2);
axisX = linspace(-pi,pi,numPixelColumn);
axisY = linspace(-pi,pi,numPixelRow);
[axisxx,axisyy] =  meshgrid(axisX,-axisY);

% shift angle by pi/2 to align correctly with FFT
thetaLow = mod(thetaLow+90,180);
thetaHigh = mod(thetaHigh+90,180);

% create Angle image
theta = atan(axisyy./axisxx);
theta = (180/pi)*theta;
theta(theta < 0) = theta(theta < 0) + 180;

% create fanfilter mask
fanFilter = zeros(numPixelRow,numPixelColumn);
if thetaLow < thetaHigh
    fanFilter((theta > thetaLow) & (theta < thetaHigh)) = 1;
elseif thetaHigh < thetaLow
    fanFilter(((theta > thetaLow) & (theta < 180)) |...
        ((theta > 0) & (theta < thetaHigh))) = 1;
end

if ~isempty(B)
    regionXX = (axisxx > -B) & (axisxx < B);
    regionYY = (axisyy > -B) & (axisyy < B);
    fanFilterTemp = zeros(size(fanFilter));
    fanFilterTemp(regionXX & regionYY) = fanFilter(regionXX & regionYY);
    fanFilter = fanFilterTemp;
end