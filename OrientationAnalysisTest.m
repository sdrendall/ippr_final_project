% OrientationAnalysisTest.m
clc; clear; close all;

%% Parameters
objectiveMag = 20;
scannerDimensions = [4490 5680]; %microns

%imagePath = 'C:\Users\csl\Dropbox\OSL\Images\NEBEC\human1.tif';
%imagePath = 'C:\Users\csl\Dropbox\OSL\Images\Ruberti\test2.tif';
imagePath = 'C:\Users\csl\Dropbox\OSL\NEBEC\Images\human1.tif';

% For Cornea
% gaussVariance1 = 2*17.5^2;
% gaussVariance2 = 2*17.5^2;

% For Ruberti
gaussVariance1 = 2*5^2;
gaussVariance2 = 2*17.5^2;

%% Initialize
OrientationAnalysisObj = OrientationAnalysis('objectiveMag',objectiveMag,...
                                             'scannerDimensions',scannerDimensions);
                                         
OrientationAnalysisObj.setImage(imagePath);
OrientationAnalysisObj.setGaussianFilter(gaussVariance1,gaussVariance2);

%% Analyze
[maxOrientation] = OrientationAnalysisObj.getTargetDirection();

%% Display
OrientationAnalysisObj.Display('imageType','originalImage');
OrientationAnalysisObj.Display('imageType','croppedImage',...
                               'title','SHG Image of Corneal Collagen',...
                               'unitsFlag',1,'FontSize',20);
                           
OrientationAnalysisObj.Display('imageType','imageFFT',...
                               'title','Filtered FFT',...
                               'unitsFlag',1,'FontSize',20,...
                               'colormap','hot'); 
OrientationAnalysisObj.Display('imageType','imageRadon',...
                               'title','Radon Transform',...
                               'axisType','tight',...
                               'colormap','hot','FontSize',20);
OrientationAnalysisObj.Display('imageType','radonPeaks',...
                               'title','Probability Density Function',...
                               'axisType','tight','FontSize',20);set(gca,'Color','none');
