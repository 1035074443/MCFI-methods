function [Y,U,V] = yuv2mat(yuvfilename,format,frames_num) 
%�ú������ڽ�yuv��ʽ����Ƶ��֡�ֱ���뵽��ά����Y,U,V֮��
%yuv��Ƶ�Ĳ�����ʽΪ4��2��0
%���������
%      yuvfilename  ---- ��Ƶyuv�ļ�·����
%      format       ---- ��Ƶ��ʽ(��ʽ��or�ֱ���[rows,cols])
%      frames_num   ---- ��ȡ����Ƶ֡��(ԭyuv��Ƶ��ǰframes_num֡)
%���������
%         Y         ---- ���ȣ���ά���飬����άΪ֡��ţ�ǰ��ά�ǵ�֡���к���
%        U,V        ---- ɫ���ά���飬����άΪ֡��ţ�ǰ��ά�ǵ�֡���к���
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

%������Ƶ֡
Y = zeros(rows,cols,frames_num);
U = zeros(rows/2,cols/2,frames_num);
V = U;

k = 0; %��¼��ȡ��֡���
point = fopen(yuvfilename,'r');
if point == -1
    error('���ļ�ʧ�ܣ�');
end
for ii = 1:frames_num
    k = k + 1;
    pro = fread(point,1,'uchar');
    if feof(point)&&isempty(pro)
        disp(['��ȡ֡���ѳ���yuv��Ƶ��֡��(',num2str(k-1),'֡)��']);
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

        