%% iterFirFan.m
% This builds general fan-type filter for directional filtering in a 2D
% image. The method for generating this filter is taken from Soo-Chang
% Pei's paper 'Two-dimensional general fan-type FIR digital filter design',
% 1991.
%clc; clear; close all;
function [h, i, MAXERR] = iterFirFan(thetaLow, thetaHigh, B, I, maxIt, ripple, transBandWidth)
%% Step 1 - Initializations

% create ideal frequency response
DESIRE = getFanFilter(I,thetaLow,thetaHigh,B);

% specify window function (2D hamming)
[~, w] = hammingWindow2(I, 'periodic');

% set pass and stop transition bands
% transBandWidth = 0.1*pi;
transitionBand = defineTransBand(DESIRE,transBandWidth);

% take iFFT2 and apply hamming window
test = ifft2(DESIRE);
%figure; mesh(real(test));
test = test.*w;
%figure; mesh(real(test));
%% Step 2 - Test Performance
for i = 1:maxIt
    TEST = fft2(test);
    DIFF = DESIRE - TEST;
    
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












