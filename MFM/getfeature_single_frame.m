function imG= getfeature_single_frame(Y)

w1 = fspecial('sobel');
w2 = w1';
im = Y;
imG1 = imfilter(im,w1,'symmetric');
imG2 = imfilter(im,w2,'symmetric');
imG = sqrt(imG1.^2+imG2.^2);

end

