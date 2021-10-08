function YUV_infor = WriteYUV(Y,U,V,filename,flag)
%�ú������ڽ�YUV��ά���鱣��Ϊ��Ƶyuv��ʽ�ļ�
%yuv��Ƶ�Ĳ�����ʽΪ4��2��0
%���������
%          Y        ---- ����ͼ�����ά����
%         U,V       ---- ɫ��ͼ�����ά����
%      yuvfilename  ---- ��Ƶyuv�ļ�����(���)��·����
%         flag      ---- ��ʾ��Ƶ��Ϣ��1��ʾ(Ĭ��), 0����ʾ

%���������
%       YUV_infor   ---- �������Ƶyuv�ļ���Ϣ
%����ʾ����
%  YUV_infor = WriteYUV(Y,U,V,'.\output.yuv');

[Y_rows,Y_cols,Y_len] = size(Y);
[U_rows,U_cols,U_len] = size(U);
[V_rows,V_cols,V_len] = size(V);

if ~isequal(Y_len,U_len,V_len)
    error('Error, Y U V have the same length! ');
elseif ~isequal([Y_rows,Y_cols]/2,[U_rows,U_cols],[V_rows,V_cols])
    error('Error, It should be 4:2:0 ');
end

fid=fopen(filename,'w');
if (fid < 0) 
    error('Could not open the file!');
end

for ii = 1:Y_len
    fwrite(fid,Y(:,:,ii)','uchar');
    fwrite(fid,U(:,:,ii)','uchar');
    fwrite(fid,V(:,:,ii)','uchar');
end
fclose(fid);

YUV_infor.Ysize  = [Y_rows,Y_cols];
YUV_infor.UVsize = [U_rows,U_cols];
YUV_infor.length = Y_len;
YUV_infor.filename = filename;

if flag
    disp('---YUV Information---');
    disp(['Spatial Resolution : ',num2str(Y_rows),'*',num2str(Y_cols)]);
    disp(['The Length of Video: ',num2str(Y_len)]);
    disp(['The Name of YUVFile: ',filename]);
    disp('----Write Finish----');
end

end

    

