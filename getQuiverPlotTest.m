%% getQuiverPlotTest.m
clc; clear; close all;

%%
filePath = 'C:\Users\slimj_000\Dropbox\NortheasternUniversity\Senior\EECE 5626 - Image Processing and Pattern Recognition\TermProject\Images';
Isize = [20,20];
[x,y,u,v] = getQuiverPlot(Isize);

figure (1);
quiver(x,y,u,v);
%print('-dtiffn',[filePath '\quiver' num2str(Isize(1)) '.tif']);

%imwrite(synthI,[filePath '\Lines_' num2str(numLines) '_' num2str(theta) 'degrees.tif']);