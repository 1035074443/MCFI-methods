function [Y,U,V] = RGB2YUV(rgb)
%RGB2YUV ��rgb��ͨ��ͼ��[H,W,3]תYUVͼ��[H,W],[H/2,W/2],[H/2,W/2]
%   rgb     ---����ͼ��[H,W,3]
%   [Y,U,V] ---�������[H,W],[H/2,W/2],[H/2,W/2]
[H,W,~] = size(rgb);
X = rgb2ycbcr(uint8(rgb));
Y = X(:,:,1);
U = imresize(X(:,:,2),[H/2,W/2],'bilinear');
V = imresize(X(:,:,3),[H/2,W/2],'bilinear');
end

