function im_pyr = subsamp_PFRUC(im,lev)

im_pyr = cell(lev,1);
im_pyr{1} = im;
im_temp = im;
w = fspecial('gaussian',[5,5],1.5);
for kk = 2:lev
    
    %Y Channel
    imY_temp = im_temp(:,:,1);
    imY_temp = imfilter(imY_temp,w,'conv','replicate','same');
    imY_temp = imY_temp(1:2:end,1:2:end);
    %U Channel
    imU_temp = im_temp(:,:,2);
    imU_temp = imfilter(imU_temp,w,'conv','replicate','same');
    imU_temp = imU_temp(1:2:end,1:2:end);
    %V Channel
    imV_temp = im_temp(:,:,3);
    imV_temp = imfilter(imV_temp,w,'conv','replicate','same');
    imV_temp = imV_temp(1:2:end,1:2:end);

    im_temp = cat(3,imY_temp,imU_temp,imV_temp);
    im_pyr{kk} = im_temp;

end



    


    