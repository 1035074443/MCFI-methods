function rgb = YUV2BGR(Y,U,V)
%YUV2BGR YUV[420]��ʽͼƬת��ΪrgbͼƬ
%   Y  ---Y����[H,W]
%   U  ---U����[H/2,W/2]
%   V  ---V����[H/2,W/2]
%   rgb---��ͨ�����ͼ��[H,W,3]
[H,W] = size(Y);
ycbcr = zeros(H,W,3); 
ycbcr(:,:,1) = uint8(Y);
ycbcr(:,:,2) = imresize(uint8(U),2,'bilinear');
ycbcr(:,:,3) = imresize(uint8(V),2,'bilinear');
rgb = ycbcr2rgb(uint8(ycbcr));
end

