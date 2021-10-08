function im_up = upsamp(im)

%Fill Zeros 
% [im_rows,im_cols] = size(im);
% im_up = zeros(2*im_rows,2*im_cols);
% im_up(1:2:end,1:2:end) = im;

%Bicubic
im_up = interp2(im,'cubic');
im_up = padarray(im_up,[1,1],'replicate','post');

end