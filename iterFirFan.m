%% iterFirFan.m
% This builds general fan-type filter for directional filtering in a 2D
% image. The method for generating this filter is taken from Soo-Chang
% Pei's paper 'Two-dimensional general fan-type FIR digital filter design',
% 1991.
%clc; clear; close all;
function [h, i, MAXERR] = iterFirFan(thetaLow, thetaHigh, B, hSize, maxIt, ripple, transBandWidth)
%% Step 1 - Initializations

% create ideal frequency response
desired_filter = getFanFilter(hSize, thetaLow, thetaHigh, B);

% specify window function (2D hamming)
w = hammingWindow2(hSize);

% set pass and stop transition bands
transitionBand = defineTransBand(desired_filter, transBandWidth);

% take iFFT2 and apply hamming window
test = ifft2(desired_filter);
test = test.*w;

%% Step 2 - Test Performance
for i = 1:maxIt
    TEST = fft2(test);
    DIFF = desired_filter - TEST;
    
    % set values of DIFF in stop-transition band to zero
    DIFF = adjustTransBand(transitionBand,DIFF);
    
    % find max value of diff
    MAXERR(i) = max(abs(DIFF(:)));
    
%     if MAXERR > ripple
%         return
%     end
    
    h = test;
    
    ripple = MAXERR;
    
    %% Step 4 - Differential Correction
    diff = ifft2(DIFF);
    test = test + (diff.*w);
    
end
