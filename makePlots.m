%% makePlots.m
clc; clear; close all;

%% Convert original .tif images to .png for latex document
filePath = 'C:\Users\James\Dropbox\NortheasternUniversity\Senior\EECE 5626 - Image Processing and Pattern Recognition\TermProject\Final Report\Images\';
image = imread([filePath 'human1.tif']);
imwrite(image,[filePath 'human1.png']);

image = imread([filePath 'Cornea-F-004_004_52_5um - Edited.tif']);
imwrite(image,[filePath 'Cornea-F-004_004_52_5um - Edited.png']);

image = imread([filePath 'Cornea-F-004_037_-46_5um - Edited.tif']);
imwrite(image,[filePath 'Cornea-F-004_037_-46_5um - Edited.png']);

image = imread([filePath 'Lines_2_45degrees.tif']);
imwrite(image,[filePath 'Lines_2_45degrees.png']);

image = imread([filePath 'Lines_15_45degrees.tif']);
imwrite(image,[filePath 'Lines_15_45degrees.png']);

%% Gaussian Filter
filePath = 'C:\Users\slimj_000\Dropbox\NortheasternUniversity\Senior\EECE 5626 - Image Processing and Pattern Recognition\TermProject\Images';
load('gaussFilter_45_90_2_0.8.mat');
isize = size(fan_filter);
[u,v] = meshgrid(linspace(-pi,pi,isize(2)),linspace(-pi,pi,isize(1)));

figure (1);
meshc(u,v,abs(fan_filter));
xlabel('u');
ylabel('v');
saveas(gcf,[filePath '\gaussFilterMesh_45_90_2_0.8.png']);

figure (2);
contour(u,v,abs(fan_filter));
xlabel('u');
ylabel('v');
saveas(gcf,[filePath '\gaussFilterContour_45_90_2_0.8.png']);

figure (3);
imshow(real(fftshift(fft2(fan_filter))));
colormap('parula')
saveas(gcf,[filePath '\gaussFilterKernel_45_90_2_0.8.png']);

%% Ideal Filter
clear;
filePath = 'C:\Users\slimj_000\Dropbox\NortheasternUniversity\Senior\EECE 5626 - Image Processing and Pattern Recognition\TermProject\Images';

load('idealFilter_45_90_2_0.8.mat');
isize = size(fan_filter);
[u,v] = meshgrid(linspace(-pi,pi,isize(2)),linspace(-pi,pi,isize(1)));

figure (4);
meshc(u,v,abs(fan_filter));
xlabel('u');
ylabel('v');
saveas(gcf,[filePath '\idealFilterMesh_45_90_2_0.8.png']);

figure (5);
contour(u,v,abs(fan_filter));
xlabel('u');
ylabel('v');
saveas(gcf,[filePath '\idealFilterContour_45_90_2_0.8.png']);

figure (6);
imshow(real(fftshift(fft2(fan_filter))));
colormap('parula');
saveas(gcf,[filePath '\idealFilterKernel_45_90_2_0.8.png']);

%%
clear;
objectiveMag = 20;
scannerDimensions = [4490 5680]; %microns
filePath = 'C:\Users\slimj_000\Dropbox\NortheasternUniversity\Senior\EECE 5626 - Image Processing and Pattern Recognition\TermProject\Images';
imagePath = 'C:\Users\slimj_000\Dropbox\NortheasternUniversity\Senior\EECE 5626 - Image Processing and Pattern Recognition\TermProject\Images\human1.tif';

gaussVariance1 = 2*5^2;
gaussVariance2 = 2*17.5^2;

OrientationAnalysisObj = OrientationAnalysis('objectiveMag',objectiveMag,...
                                             'scannerDimensions',scannerDimensions);
                                         
OrientationAnalysisObj.setImageFromFile(imagePath);
OrientationAnalysisObj.setGaussianFilter(gaussVariance1,gaussVariance2);
[maxOrientation] = OrientationAnalysisObj.getTargetDirection();

OrientationAnalysisObj.Display('imageType','radonPeaks',...
                               'title','',...
                               'axisType','tight','FontSize',20);
                                set(gca,'Color','none');
                                
                                
figure (8);
OrientationAnalysisObj.getImageAxis(1);
[freqAxisX, freqAxisY] = OrientationAnalysisObj.getFreqAxis();
imagesc(freqAxisX,freqAxisY,abs(fftshift(fft2(OrientationAnalysisObj.croppedImage))));
set(gca,'FontWeight','Bold',...
    'FontSize',20);
colormap('hot'); colorbar;
caxis([0 2e05]);
axis('tight');
title('');
xlabel('Length [um^-^1]');
ylabel('Length [um^-^1]');    
saveas(gcf,[filePath '\imageSpectra_human1.png']);














