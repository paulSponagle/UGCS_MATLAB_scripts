imageA = imread('peppers.png');
imageA=imageA(:,:,1);
imageB = imread('AT3_1m4_01.tif');
imageB=imageB(:,:,1);

% figure, imshow(imageA)
% title('Image A - peppers')
% figure, imshow(imageB)
% title('Image B - 2nd image')

fftA = fft2(double(imageA));
fftB = fft2(double(imageB));

figure, imshow(abs(fftshift(fftA)),[24 100000]), colormap gray
title('Peppers FFT2 Magnitude')
figure, imshow(angle(fftshift(fftA)),[-pi pi]), colormap gray
title('Peppers FFT2 Phase')
figure, imshow(abs(fftshift(fftB)),[24 100000]), colormap gray
title('Image B FFT2 Magnitude')
figure, imshow(angle(fftshift(fftB)),[-pi pi]), colormap gray
title('Image B FFT2 Phase')

fftC = abs(fftA).*exp(i*angle(fftB));
fftD = abs(fftB).*exp(i*angle(fftA));

imageC = ifft2(fftC);
imageD = ifft2(fftD);

%Calculate limits for plotting

cmin = min(min(abs(imageC)));
cmax = max(max(abs(imageC)));

dmin = min(min(abs(imageD)));
dmax = max(max(abs(imageD)));
%Display switched images

figure, imshow(abs(imageC), [cmin cmax]), colormap gray
title('Image C  Magnitude')
figure, imshow(abs(imageD), [dmin dmax]), colormap gray
title('Image D  Magnitude')