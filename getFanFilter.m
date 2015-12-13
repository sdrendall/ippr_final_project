function fanFilter = getFanFilter(hSize, thetaLow, thetaHigh)
    %% fanFilter = getFanFilter(hSize, thetaLow, thetaHigh)
    %
    % Generates the frequency spectrum of a fan filter that passes frequency components
    %  within the given range of phases
    %
    % hSize: Size of the filter to be returned in the form [nRows, nCols]
    % thetaLow: Lower bound for the phase of components to be passed
    % thetaHigh: Upper bound for the phase of components to be passed

    % make mesh grid
    numPixelRow = hSize(1)
    numPixelColumn = hSize(2)
    %axisX = linspace(-numPixelColumn, numPixelColumn, numPixelColumn);
    %axisY = linspace(-numPixelRow, numPixelRow, numPixelRow);
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

end
