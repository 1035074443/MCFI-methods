function [Y,U,V] = YUVReadSingleFrame(yuvfilename,cols,rows,order_num)
%�ú������ڽ�yuv��ʽ����Ƶĳ��֡�ֱ���뵽��ά����Y,U,V֮��
%yuv��Ƶ�Ĳ�����ʽΪ4��2��0
%���������
%      yuvfilename  ---- ��Ƶyuv�ļ�·����
%      cols,rows    ---- ��Ƶ��ʽ(��ʽ��or�ֱ���[rows,cols])
%      order_num    ---- ��ȡ��Ƶ֡�����(��0��ʼ����)
%���������
%         Y         ---- ����ͼ��
%        U,V        ---- ɫ��ͼ��
%����ʾ����
%  [Y,U,V] = ReadSingleFrame('.\videoname.yuv',352,288,100);
close all;
point = fopen(yuvfilename,'r');
if point == -1
    error('���ļ�ʧ�ܣ�');
end

offset = order_num*(rows*cols + rows*cols/2);
status = fseek(point,offset,'bof');
pro = fread(point,1,'uchar');
if (isempty(pro)&&feof(point)) || status ~=0
    error('��ȡλ�ö�λʧ�ܣ�');
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











