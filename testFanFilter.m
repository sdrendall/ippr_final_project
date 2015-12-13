% testFanFilter.m
clc; clear; 
%close all;

%% Parameters
%imagePath = 'C:\Users\papastone\repos\orientationanalysis\human1.tif';
%imagePath = 'C:\Users\csl\Dropbox\OSL\NEBEC\Images\human1.tif';
imagePath = 'C:\Users\slimj_000\Dropbox\OSL\NEBEC\Images\human1.tif';
gaussVariance1 = 2*5^2;
gaussVariance2 = 2*17.5^2;

%% Initialize
OrientationAnalysisObj = OrientationAnalysis();
OrientationAnalysisObj.setImage(imagePath);
OrientationAnalysisObj.setGaussianFilter(gaussVariance1,gaussVariance2);

%% Analyze
[maxOrientation] = OrientationAnalysisObj.getTargetDirection();

%% Plot Radon Peaks
% OrientationAnalysisObj.Display('imageType','radonPeaks',...
%                                'title','Probability Density Function',...
%                                'axisType','tight','FontSize',20);set(gca,'Color','none');

%%
thetaLow = 160;
thetaHigh = 180;
B = 0.8*pi;
maxIt = 100;
ripple = inf;
transBandWidth = 0.1*pi;
%fanFilter1 = getFanFilter(OrientationAnalysisObj.croppedImage,stopBand1,passBand1);
[fanFilter1,i,MAXERR] = iterFirFan(thetaLow,thetaHigh,B,zeros(480),maxIt,ripple,transBandWidth);
figure(4),
surf(real(fanFilter1));
title('output filter, spatial')
fanFilter1 = fft2(fanFilter1);

imageFFT1 = fftshift(fft2(OrientationAnalysisObj.croppedImage)) .* fanFilter1;
imageFilt1 = ifft2(fftshift(imageFFT1));
imageFilt1 = real(imageFilt1);

%%
figure (3),
surf(real(fanFilter1));
title('Output Fan Filter')

figure (2);
subplot(2,2,1);
imagesc(real(fanFilter1));
colormap('gray'); colorbar;
set(gca,'YDir','normal');

subplot(2,2,2);
imagesc(mat2gray(abs(imageFFT1)));
caxis([0 2e05]);
colormap('gray'); colorbar;
set(gca,'YDir','normal');

subplot(2,2,3);
imagesc(OrientationAnalysisObj.croppedImage);
colormap('gray'); colorbar;
set(gca,'YDir','normal');

subplot(2,2,4);
imagesc(imageFilt1);
colormap('gray'); colorbar;
set(gca,'YDir','normal');
