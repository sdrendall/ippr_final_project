function transBand = defineTransBand(fanFilter,transBandWidth)
[Iw,Il] = size(fanFilter);
numIt = round(transBandWidth * Iw / (2*pi));
paddedFilter = fanFilter;
for i = 1:numIt
    filterBig = zeros(Iw+2,Il+2);
    filterBig(2:end-1,2:end-1) = paddedFilter;
    
    filterBig(1:end-2,1:end-2) = filterBig(1:end-2,1:end-2) + paddedFilter;
    filterBig(1:end-2,3:end) = filterBig(1:end-2,3:end) + paddedFilter;
    filterBig(3:end,1:end-2) = filterBig(3:end,1:end-2) + paddedFilter;
    filterBig(3:end,3:end) = filterBig(3:end,3:end) + paddedFilter;
    
    paddedFilter = filterBig(2:end-1,2:end-1);
    paddedFilter(paddedFilter > 1) = 1;
end

transBand = paddedFilter - fanFilter;
end












