function [WB_Fraction] = DPImageAnalysis()

%Öffnen der gewünschten Bilddatei und Auslesen
[filename, pathname] = uigetfile({'*.jpg';'*.tiff'}); 
I = imread(strcat(pathname, filename));

%Fehlermeldung vermeiden
if ndims(I)>2
    K = rgb2gray(I);
else
    K = I;
end

%Erhöhung des Konstrasts
G = imadjust(K);

%Binärisieren (Schwarz-Weiß)
BW = imbinarize(G, 'adaptive', 'Sensitivity', 0.50, 'ForegroundPolarity', 'dark');

%1: white, 0:black
WhiteFraction = (sum(BW(:)) / numel(BW))*100;
BlackFraction = 100 - WhiteFraction;

WB_Fraction = [WhiteFraction, BlackFraction];

figure('Name','DP Image Analysis Results','NumberTitle','off');
montage({I BW});
title(['White fraction: ' num2str(WhiteFraction) '      Black fraction: ' num2str(BlackFraction)]);


%Validierung

%verschiedene Kantenerkennungsmethoden des binärisierten Bildes
BW_sobel = edge(BW, 'Sobel');
BW_roberts = edge(BW, 'Roberts');
BW_canny = edge(BW, 'Canny');

%Überlagerung der Kanten mit dem ursprünglichen Gefüge
BW_sobel_maskedI = imoverlay(I, BW_sobel, [1 0 0]);
BW_roberts_maskedI = imoverlay(I, BW_roberts, [1 0 0]);
BW_canny_maskedI = imoverlay(I, BW_canny, [1 0 0]);

BW_sobel_maskedBW = imoverlay(BW, BW_sobel, [1 0 0]);
BW_roberts_maskedBW = imoverlay(BW, BW_roberts, [1 0 0]);
BW_canny_maskedBW = imoverlay(BW, BW_canny, [1 0 0]);


figure('Name','Edge Detection Methods','NumberTitle','off');
subplot(3,3,1);
imshow(BW_sobel);
title('Sobel Method');
subplot(3,3,2);
imshow(BW_sobel_maskedBW);
subplot(3,3,3);
imshow(BW_sobel_maskedI);
subplot(3,3,4);
imshow(BW_roberts);
title('Roberts Method');
subplot(3,3,5);
imshow(BW_roberts_maskedBW);
subplot(3,3,6);
imshow(BW_roberts_maskedI);
subplot(3,3,7);
imshow(BW_canny);
title('Canny Method');
subplot(3,3,8);
imshow(BW_canny_maskedBW);
subplot(3,3,9);
imshow(BW_canny_maskedI);
linkaxes;

end

