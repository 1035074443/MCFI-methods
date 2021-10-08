function [Y,U,V] = ReadSingleFrame(yuvfilename,format,order_num)
%�ú������ڽ�yuv��ʽ����Ƶĳ��֡�ֱ���뵽��ά����Y,U,V֮��
%yuv��Ƶ�Ĳ�����ʽΪ4��2��0
%���������
%      yuvfilename  ---- ��Ƶyuv�ļ�·����
%      format       ---- ��Ƶ��ʽ(��ʽ��or�ֱ���[rows,cols])
%      order_num   ----  ��ȡ��Ƶ֡�����(��0��ʼ����)
%���������
%         Y         ---- ����ͼ��
%        U,V        ---- ɫ��ͼ��
%����ʾ����
%  [Y,U,V] = yuv2mat('.\videoname.yuv','cif',100);
%  [Y,U,V] = yuv2mat('.\videoname.yuv',[288,352],100);
close all;
if ischar(format)
    format = lower(format);
    switch format
        case 'sub_qcif'
            cols = 128; rows = 96;
        case 'qcif'
            cols = 176; rows = 144;
        case 'cif'
            cols = 352; rows = 288;
        case 'sif'
            cols = 352; rows = 240;
        case '4cif'
            cols = 704; rows = 576;
        otherwise
            error('no format!');
    end
elseif isequal(size(format),[1,2])||isequal(size(format),[2,1])
    cols = format(2);rows = format(1);
else
    error('�ڶ�������������');
end


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











