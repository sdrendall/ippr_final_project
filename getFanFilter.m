function fanFilter = getFanFilter(hSize, thetaLow, thetaHigh, maxRadius)
    %% fanFilter = getFanFilter(hSize, thetaLow, thetaHigh)
    %
    % Generates the frequency spectrum of a fan filter that passes frequency components
    %  within the given range of phases
    %
    % hSize: Size of the filter to be returned in the form [nRows, nCols]
    % thetaLow: Lower bound for the phase of components to be passed
    % thetaHigh: Upper bound for the phase of components to be passed
    % maxRadius: The maximum length of the 'arms' of the fan filter, normalized from 0 to 1

    % make mesh grid
    numPixelRow = hSize(1);
    numPixelColumn = hSize(2);
    axisX = -floor(numPixelColumn/2):(ceil(numPixelColumn/2) - 1);
    axisY = -floor(numPixelRow/2):ceil((numPixelRow/2) - 1);
    [axisxx, axisyy] =  meshgrid(axisX, -axisY);

    % shift angle by pi/2 to align correctly with FFT
    thetaLow = mod(thetaLow + 90, 180);
    thetaHigh = mod(thetaHigh + 90, 180);

    % create Angle image
    theta = atan(axisyy./axisxx);
    theta = (180/pi)*theta;
    theta(theta < 0) = theta(theta < 0) + 180;

    % create fanfilter mask
    fanFilter = zeros(numPixelRow, numPixelColumn);
    if thetaLow < thetaHigh
        fanFilter((theta > thetaLow) & (theta < thetaHigh)) = 1;
    elseif thetaHigh < thetaLow
        fanFilter(((theta > thetaLow) & (theta < 180)) |...
            ((theta > 0) & (theta < thetaHigh))) = 1;
    end

    if (exist('maxRadius', 'var') && ~isempty(maxRadius))
        axisxx_norm = pi*axisxx/max(abs(axisxx(:)));
        axisyy_norm = pi*axisyy/max(abs(axisyy(:)));
        regionXX = (axisxx_norm > -maxRadius) & (axisxx_norm < maxRadius);
        regionYY = (axisyy_norm > -maxRadius) & (axisyy_norm < maxRadius);
        fanFilterTemp = zeros(size(fanFilter));
        fanFilterTemp(regionXX & regionYY) = fanFilter(regionXX & regionYY);
        fanFilter = fanFilterTemp;
    end
end
