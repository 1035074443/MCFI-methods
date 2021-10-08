function [Y,U,V] = YUVRead(yuvfilename,cols,rows,init2last)
%�ú������ڽ�yuv��ʽ����Ƶ������֡�ֱ���뵽��ά����Y,U,V֮��
%yuv��Ƶ�Ĳ�����ʽΪ4��2��0
%���������
%      yuvfilename  ---- ��Ƶyuv�ļ�·����
%      cols,rows    ---- ��Ƶ��ʽ(��ʽ��or�ֱ���[rows,cols])
%      init2last    ----  ��ȡ����Ƶ֡�ķ�Χ[��ʼ֡��ţ���ֹ֡���]
%���������
%         Y         ---- ���ȣ���ά���飬����άΪ֡��ţ�ǰ��ά�ǵ�֡���к���
%        U,V        ---- ɫ���ά���飬����άΪ֡��ţ�ǰ��ά�ǵ�֡���к���
%����ʾ����
%  [Y,U,V] = YUVRead('.\videoname.yuv',352,288,[100,101]);

point = fopen(yuvfilename,'r');
if point == -1
    error('���ļ�ʧ�ܣ�');
end

order_num = init2last(1);
frames_num = init2last(2) - order_num + 1;
k = 0;
Y = zeros(rows,cols,frames_num);
U = zeros(rows/2,cols/2,frames_num);
V = U;

offset = order_num*(rows*cols + rows*cols/2);
status = fseek(point,offset,'bof');
pro = fread(point,1,'uchar');
if (isempty(pro)&&feof(point)) || status ~=0
    error('��ȡλ�ö�λʧ�ܣ�');
end
fseek(point,-1,'cof');

for ii = 1:frames_num
    k = k + 1;
    pro = fread(point,1,'uchar');
    if feof(point)&&isempty(pro)
        disp('��ȡ֡����Χ�ѳ���yuv��Ƶ��֡����');
        Y = Y(:,:,1:k-1);
        U = U(:,:,1:k-1);
        V = V(:,:,1:k-1);
        break;
    end
    fseek(point,-1,'cof');
    temp = fread(point,[cols,rows],'uchar');
    Y(:,:,ii) = temp';
    temp = fread(point,[cols/2,rows/2],'uchar');
    U(:,:,ii) = temp';
    temp = fread(point,[cols/2,rows/2],'uchar');
    V(:,:,ii) = temp';
end
fclose(point);
end