function gray = RGB2GRAY(rgb)
%RGB2GRAY RGB3通道图转GRAY灰度图
%   rgb ---输入图像[H,W,3]
gray = rgb2gray(uint8(rgb));
end

