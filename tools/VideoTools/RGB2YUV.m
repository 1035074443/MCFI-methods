function [Y,U,V] = RGB2YUV(rgb)
%RGB2YUV 将rgb三通道图像[H,W,3]转YUV图像[H,W],[H/2,W/2],[H/2,W/2]
%   rgb     ---输入图像[H,W,3]
%   [Y,U,V] ---输出分量[H,W],[H/2,W/2],[H/2,W/2]
[H,W,~] = size(rgb);
X = rgb2ycbcr(uint8(rgb));
Y = X(:,:,1);
U = imresize(X(:,:,2),[H/2,W/2],'bilinear');
V = imresize(X(:,:,3),[H/2,W/2],'bilinear');
end

