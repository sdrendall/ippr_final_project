%% OrientationAnalysis.m
% This object preforms our novel orientation analysis algorithm on any
% image.  It is a work in progress but has been switched to this object
% oriented style in order to add modularity to the algorithm now that it is
% in its linear form. Its abstraction from the user with also make it
% easier for anyone to experiment with the algorithm on their own data
% sets.
%
% OrientationAnalysis Methods:
%
%   findDirection       - Performs the basic algorithm on the prepared
%                         image.
%
%
%
%
%
%

classdef OrientationAnalysis < handle
    
    properties
        %% ========================= PROPERTIES ===========================
        
        % Scalar, magnification of objective lens used.
        objectiveMag
        
        % Vector, first element is the length in microns (um) of the
        % scanner in the x-dimension, second element is the same for the
        % y-dimension.
        scannerDimensions
        
        % Customizable filter to be applied to imageFFT in freq domain
        freqFilter
        
        % Matrix, original image to be processed
        originalImage
        
        % Matrix, image after being cropped to be square
        croppedImage
        
        % Matrix, image after being filtered in freq domain
        freqFilteredImage
        
        % Matrix, image of the 2DFT of the croppedImage
        imageFFT
        
        % Matrix, image of the Radon Transform of imageFFT
        imageRadon
        
        % Vector, extraction of x'=0 row of imageRadon
        radonPeaks
        
    end
    
    properties (Hidden = true)
        
        % Vector contains the sampling frequency of the image
        samplingFreq
        
        % path to the processed image
        imagePath
        
    end
    
    methods
        %% ======================= CONSTRUCTOR ============================
        function self = OrientationAnalysis(varargin)
            
            %parse
            p = inputParser;
            p.KeepUnmatched = true;
            p.addParameter('objectiveMag',20,@isscalar);
            p.addParameter('scannerDimensions',[],@ismatrix);
            p.parse(varargin{:});
            
            %load variables
            self.objectiveMag = p.Results.objectiveMag;
            self.scannerDimensions = p.Results.scannerDimensions;
            
        end
        
        %% =========================== setImage ===========================
        function setImage(self,imagePath)
            %
            %
            %
            %
            self.imagePath = imagePath;
            self.originalImage = imread(imagePath);
            
            % Check if image is RGB, if true, convert to grayscale
            if size(self.originalImage,3) == 3
                self.originalImage = rgb2gray(self.originalImage);
            end
            
            %Crop image to be square
            [numPixelRow, numPixelColumn] = size(self.originalImage);
            if numPixelRow > numPixelColumn
                padding = (numPixelRow - numPixelColumn) / 2;
                self.croppedImage  = self.originalImage(1+padding:end-padding,:);
            elseif numPixelRow < numPixelColumn
                padding = (numPixelColumn - numPixelRow) / 2;
                self.croppedImage  = self.originalImage(:,1+padding:end-padding);
            else
                self.croppedImage = self.originalImage;
            end
            
        end
        
        %% ========================== setGaussianFilter ===================
        function setGaussianFilter(self,gaussVariance1,gaussVariance2)
            %
            %
            %
            %
            
            % Initialize domain for filter
            [numPixelRow, numPixelColumn] = size(self.croppedImage);
            axisX = linspace(-numPixelColumn,numPixelColumn,numPixelColumn);
            axisY = linspace(-numPixelRow,numPixelRow,numPixelRow);
            [axisxx,axisyy] =  meshgrid(axisX,axisY);
            
            % Compute filter in polar coordinates
            rsq = axisxx.^2+axisyy.^2;
            self.freqFilter = (1-exp(-(rsq/gaussVariance1/2))).*exp(-(rsq/gaussVariance2/2));
            self.freqFilter = self.freqFilter./max(self.freqFilter(:));
            
        end
        
        %% ======================== getTargetDirection =========================
        function [maxOrientation] = getTargetDirection(self)
            %
            %
            %
            %
            
            % Take 2DFFT and apply frequency filter
            self.imageFFT = fftshift(fft2(self.croppedImage)) .* self.freqFilter;
            self.freqFilteredImage = ifft2(fftshift(self.imageFFT));
            
            % Take Radon Transform of imageFFT
            angleRange = 0:180;
            self.imageRadon = radon(abs(self.imageFFT),angleRange);
            
            % Extract the middle row of the imageRadon
            numRadonRows = size(self.imageRadon,1);
            self.radonPeaks = self.imageRadon(ceil(numRadonRows/2),:);
            [~,maxOrientation] = max(self.radonPeaks);
            
        end
        
        %% ========================= Display =========================
        function Display(self,varargin)
            % Function for advanced formatting of image display.  Shows
            % image in real units, cases are set for each step along the
            % path of the algorithm.
            % INPUT
            %   imageType   = String, which image you want to display.
            %                 Options are: 'originalImage', 'croppedImage',
            %                 'imageFFT', 'imageRadon'.
            
            p = inputParser;
            p.KeepUnmatched = true;
            p.addParameter('imageType','radonPeaks',@ischar);
            p.addParameter('title','',@ischar);
            p.addParameter('unitsFlag',0,@isscalar);
            p.addParameter('colormap','gray',@ischar);
            p.addParameter('axisType','image',@ischar);
            p.addParameter('FontSize',12,@isscalar);
            p.addParameter('FontWeight','bold',@ischar);
            p.parse(varargin{:});
            
            switch (p.Results.imageType)
                
                case ('originalImage')
                    %%
                    [imageAxisX, imageAxisY] = self.getImageAxis(p.Results.unitsFlag);
                    figure;
                    imagesc(imageAxisX,imageAxisY,self.originalImage);
                    set(gca,'FontWeight',p.Results.FontWeight,...
                            'FontSize',p.Results.FontSize);
                    colormap(p.Results.colormap);
                    axis(p.Results.axisType);
                    title(p.Results.title);
                    
                    if (p.Results.unitsFlag)
                        xlabel('Length [um]');
                        ylabel('Length [um]');
                    else
                        xlabel('Pixels');
                        ylabel('Pixels');
                    end
                    
                case ('croppedImage')
                    %%
                    [imageAxisX, imageAxisY] = self.getImageAxis(p.Results.unitsFlag);
                    
                    if length(imageAxisX) ~= size(self.croppedImage,2)
                        imageAxisX = imageAxisX(1:size(self.croppedImage,2));
                    elseif length(imageAxisY) ~= size(self.croppedImage,1)
                        imageAxisY = imageAxisY(1:size(self.croppedImage,1));
                    end
                    
                    figure;
                    imagesc(imageAxisX,imageAxisY,self.croppedImage);
                    set(gca,'FontWeight',p.Results.FontWeight,...
                            'FontSize',p.Results.FontSize);
                    colormap(p.Results.colormap);
                    axis(p.Results.axisType);
                    title(p.Results.title);
                    
                    if (p.Results.unitsFlag)
                        xlabel('Length [um]');
                        ylabel('Length [um]');
                    else
                        xlabel('Pixels');
                        ylabel('Pixels');
                    end
                    
                case ('imageFFT')
                    %%
                    [freqAxisX, freqAxisY] = self.getFreqAxis();
                        
                    figure;
                    imagesc(freqAxisX,freqAxisY,abs(self.imageFFT));
                    set(gca,'FontWeight',p.Results.FontWeight,...
                            'FontSize',p.Results.FontSize);
                    colormap(p.Results.colormap); colorbar;
                    caxis([0 2e05]);
                    axis(p.Results.axisType);
                    title(p.Results.title);
                    
                    if (p.Results.unitsFlag)
                        xlabel('Length [um^-^1]');
                        ylabel('Length [um^-^1]');     
                    else
                        xlabel('Length [Pixels^-^1]');
                        ylabel('Length [Pixels^-^1]');
                    end
 
                case ('imageRadon')
                    %%
                    % Calculate size of image dimensions
                    [axisY, ~] = size(self.imageRadon);
                    
                    % Display
                    figure;
                    imagesc(0:180,(-axisY:axisY)/2,self.imageRadon);
                    colormap(p.Results.colormap); colorbar;
                    axis(p.Results.axisType);
                    title(p.Results.title);
                    set(gca,'FontWeight',p.Results.FontWeight,...
                            'FontSize',p.Results.FontSize);
                    xlabel('\theta (degrees)');
                    
                    
                case ('radonPeaks')
                    %% Normalize to area under curve to get PDF
                    figure;
                    plot(0:180,(self.radonPeaks) / sum(self.radonPeaks),...
                         'LineWidth',3);
                    title(p.Results.title);
                    set(gca,'FontWeight',p.Results.FontWeight,...
                            'FontSize',p.Results.FontSize);
                    xlabel('\theta (degrees)');
                    axis(p.Results.axisType);
                    
            end
            
        end
        
        %% ===================== getImageAxis =============================
        function [imageAxisX, imageAxisY] = getImageAxis(self,unitsFlag)
            
            [numPixelRow, numPixelColumn] = size(self.originalImage);
            
            if (unitsFlag)
                realAxisLengthX = self.scannerDimensions(2)/self.objectiveMag;
                realAxisLengthY = self.scannerDimensions(1)/self.objectiveMag;
                
                self.samplingFreq(1) = numPixelRow / realAxisLengthY;
                self.samplingFreq(2) = numPixelColumn / realAxisLengthX;
                
                imageAxisX = realAxisLengthX * ((1:numPixelColumn)/numPixelColumn);
                imageAxisY = realAxisLengthY * ((1:numPixelRow)/numPixelRow);
                
            else
                self.samplingFreq(1) = 1;
                self.samplingFreq(2) = 1;
                
                imageAxisX = 1:numPixelColumn;
                imageAxisY = 1:numPixelRow;   
                
            end
            
        end
        
        %% ======================== getFreqAxis ===========================
        function [freqAxisX, freqAxisY] = getFreqAxis(self)
            
            maxFrequencySampled = self.samplingFreq / 2;
            [numPixelRow, numPixelColumn] = size(self.originalImage);
            
            freqAxisX = maxFrequencySampled(1)*(((1:numPixelColumn)/numPixelColumn) - 0.5);
            freqAxisY = maxFrequencySampled(2)*(((1:numPixelRow)/numPixelRow) - 0.5);
            
            if length(freqAxisX) ~= size(self.imageFFT,1)
                padding = abs(length(freqAxisX) - size(self.imageFFT,2)) / 2;
                freqAxisX = freqAxisX(padding+1:end-padding);
            elseif length(freqAxisY) ~= size(self.imageFFT,2)
                padding = abs(length(freqAxisY) - size(self.imageFFT,1)) / 2;
                freqAxisY = freqAxisY(padding+1:end-padding);
            end
            
        end
        
    end
    
end