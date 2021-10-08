function im_up = upsamp(im)

%Fill Zeros 
% [im_rows,im_cols] = size(im);
% im_up = zeros(2*im_rows,2*im_cols);
% im_up(1:2:end,1:2:end) = im;

%Bicubic
im_up = interp2(im,'cubic');
im_up = padarray(im_up,[1,1],'replicate','post');

%Bicubic_Change
% [im_rows,im_cols] = size(im);
% im_up = zeros(2*im_rows,2*im_cols);
% im = interp2(im,'cubic');
% im = padarray(im,[1,1],'replicate','both');
% for jj = 2:2*im_cols+1
%     temp = im(:,jj);
%     temp = interp1(temp,1.5:length(temp));
%     im_up(:,jj-1) = temp;
% end

end