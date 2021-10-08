function Y_up = AOBMCF(Y,factor)
%%
%  input:
%     Y : 输入Y分量;
%     factor:  插值因子;
%  output:
%    Y_up: 上转Y分量;
%% main

power = log2(factor);
if power ~= fix(power)
    error('The second factor must be the power of 2 !');
end
%% interpolated Parameters
% params.block_size = 8;
% params.search_range = 4;
% params.step_size = 1;
% params.im_rows = size(Y,1);
% params.im_cols = size(Y,2);
% disp(params.im_rows);
% disp(params.im_cols);

block_size = 8;
search_range = 4;
step_size = 1;
im_rows = size(Y,1);
im_cols = size(Y,2);

for kk = 1:power
    disp(['The ',num2str(kk),'-th double video...']);
    len = size(Y,3);
    temp = zeros(im_rows,im_cols,len-1);
    Y_up = zeros(im_rows,im_cols,2*len-1);
    for ii = 1:len-1
       disp(['The ',num2str(ii),'-th frame...']);
%%  Y up-converted
       imR1_Y  = Y(:,:,ii);
       imR2_Y  = Y(:,:,ii+1);
       imR1_pad = padarray(imR1_Y,search_range*[1,1],'replicate');
       imR2_pad = padarray(imR2_Y,search_range*[1,1],'replicate');
%% --------------------Bi-directional Motion Estimation------------------
       MVF = FME(imR1_pad,imR2_pad,im_rows,im_cols,block_size,search_range,step_size);
       MVF = BiMErefine(imR1_pad,imR2_pad,MVF,2,im_rows,im_cols,block_size,search_range,step_size);
    
%% ---------------------------Motion Analysis----------------------------
       MVF = median_smoothMVF(MVF,im_rows,im_cols,block_size); 
%%  AOBMC
      temp(:,:,ii) = AOBMC(imR1_pad,imR2_pad,MVF,im_rows,im_cols,block_size,search_range,step_size);
    end
    Y_up(:,:,1:2:end) = Y;
    Y_up(:,:,2:2:end) = temp; 
    Y = Y_up;
end
end
