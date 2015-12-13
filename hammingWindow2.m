function [windowedI, window] = hammingWindow2(I, flagType)
%% flag type can be either 'periodic' or 'symmetric' 
L = size(I);
w = hamming(L(1), flagType); %for square image doesnt matter which image dim used
[X,Y] = meshgrid(w, w);
window = X.*Y;
windowedI = I.*window;
end
