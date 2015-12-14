%% genSynthLinesTest.m
clc; clear; close;

%%
filePath = 'C:\Users\slimj_000\Dropbox\NortheasternUniversity\Senior\EECE 5626 - Image Processing and Pattern Recognition\TermProject\Images';
theta = 45;
numLines = 15;
Isize = [480,480];
synthI = genSynthLines(theta,numLines,Isize);

figure (1);
imagesc(synthI);

imwrite(synthI,[filePath '\Lines_' num2str(numLines) '_' num2str(theta) 'degrees.tif']);