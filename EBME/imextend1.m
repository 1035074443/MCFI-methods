function im_ex = imextend1(im,ex_size)

im_ex = padarray(im,[ex_size,ex_size],'symmetric','both');
%im_ex = padarray(im,[ex_size,ex_size],'replicate','both');
%im_ex = padarray(im,[ex_size,ex_size],'circular','both');

end