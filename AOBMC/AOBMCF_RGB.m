function Y_up = AOBMCF_RGB(Y,factor)

power = log2(factor);
if power ~= fix(power)
    error('The second factor must be the power of 2 !');
end
block_size = 8;
search_range = 4;
step_size = 1;

for kk = 1:power
    disp(['The ',num2str(kk),'-th double video...']);
    [im_rows,im_cols,channels,len] = size(Y);
    temp = zeros(im_rows,im_cols,channels,len-1);
    Y_up = zeros(im_rows,im_cols,channels,2*len-1);
    for ii = 1:len-1
       disp(['The ',num2str(ii),'-th frame...']);
       imR1_Y  = rgb2gray(Y(:,:,:,ii));
       imR2_Y  = rgb2gray(Y(:,:,:,ii+1));
       imR1_pad = padarray(imR1_Y,search_range*[1,1],'replicate');
       imR2_pad = padarray(imR2_Y,search_range*[1,1],'replicate');
       MVF = FME(imR1_pad,imR2_pad,im_rows,im_cols,block_size,search_range,step_size);
       MVF = BiMErefine(imR1_pad,imR2_pad,MVF,2,im_rows,im_cols,block_size,search_range,step_size);
       MVF = median_smoothMVF(MVF,im_rows,im_cols,block_size); 
       imR1_pad1 = padarray(Y(:,:,1,ii),search_range*[1,1],'replicate');
       imR2_pad1 = padarray(Y(:,:,1,ii+1),search_range*[1,1],'replicate');
       imR1_pad2 = padarray(Y(:,:,2,ii),search_range*[1,1],'replicate');
       imR2_pad2 = padarray(Y(:,:,2,ii+1),search_range*[1,1],'replicate');
       imR1_pad3 = padarray(Y(:,:,3,ii),search_range*[1,1],'replicate');
       imR2_pad3 = padarray(Y(:,:,3,ii+1),search_range*[1,1],'replicate');
       temp(:,:,1,ii) = AOBMC(imR1_pad1,imR2_pad1,MVF,im_rows,im_cols,block_size,search_range,step_size);
       temp(:,:,2,ii) = AOBMC(imR1_pad2,imR2_pad2,MVF,im_rows,im_cols,block_size,search_range,step_size);
       temp(:,:,3,ii) = AOBMC(imR1_pad3,imR2_pad3,MVF,im_rows,im_cols,block_size,search_range,step_size);
    end
    Y_up(:,:,:,1:2:end) = Y;
    Y_up(:,:,:,2:2:end) = temp; 
    Y = Y_up;
end
end
