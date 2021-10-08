function [Y,U,V] = YUVReadSingleFrame(yuvfilename,cols,rows,order_num)
%该函数用于将yuv格式的视频某单帧分别读入到二维数组Y,U,V之中
%yuv视频的采样格式为4：2：0
%输入参数：
%      yuvfilename  ---- 视频yuv文件路径名
%      cols,rows    ---- 视频格式(格式名or分辨率[rows,cols])
%      order_num    ---- 读取视频帧的序号(从0开始计数)
%输出参数：
%         Y         ---- 亮度图像
%        U,V        ---- 色差图像
%调用示范：
%  [Y,U,V] = ReadSingleFrame('.\videoname.yuv',352,288,100);
close all;
point = fopen(yuvfilename,'r');
if point == -1
    error('打开文件失败！');
end

offset = order_num*(rows*cols + rows*cols/2);
status = fseek(point,offset,'bof');
pro = fread(point,1,'uchar');
if (isempty(pro)&&feof(point)) || status ~=0
    error('读取位置定位失败！');
end
fseek(point,-1,'cof');

temp = fread(point,[cols,rows],'uchar');
Y = temp';
temp = fread(point,[cols/2,rows/2],'uchar');
U = temp';
temp = fread(point,[cols/2,rows/2],'uchar');
V = temp';

fclose(point);

end











