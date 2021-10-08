function G = GetFeature(Y)

[~,~,len] = size(Y);
w1 = fspecial('sobel');
w2 = w1';
G     = [];
for ii = 1:len
    im = Y(:,:,ii);
    imG1 = imfilter(im,w1,'symmetric');
    imG2 = imfilter(im,w2,'symmetric');
    imG = sqrt(imG1.^2+imG2.^2);
    G = cat(3,G,imG);
end

end