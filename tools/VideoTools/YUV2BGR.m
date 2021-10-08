function rgb = YUV2BGR(Y,U,V)
%YUV2BGR YUV[420]格式图片转换为rgb图片
%   Y  ---Y分量[H,W]
%   U  ---U分量[H/2,W/2]
%   V  ---V分量[H/2,W/2]
%   rgb---三通道输出图像[H,W,3]
[H,W] = size(Y);
ycbcr = zeros(H,W,3); 
ycbcr(:,:,1) = uint8(Y);
ycbcr(:,:,2) = imresize(uint8(U),2,'bilinear');
ycbcr(:,:,3) = imresize(uint8(V),2,'bilinear');
rgb = ycbcr2rgb(uint8(ycbcr));
end

