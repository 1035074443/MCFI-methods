clc;
clear all;
format = 'yuv';
length = 100;
factor = 2;
videofile = 'E:\frame_interpolation\frame_interpolation_generation\videos\football_cif.yuv';
[Y,U,V] = ReadMultiFrames(videofile,[288,352],[1,30]);
Y_up = MCMP(Y,U,V,factor);
Y_up_2 = zeros(288,352,1,59);
Y_up_2(:,:,1,:) = Y_up;
Y_up_2 = uint8(Y_up_2);
disp(size(Y_up_2));

video_out_name = 'E:\frame_interpolation\frame_interpolation_generation\videos\football_cif_MCMP.avi';
video_out = VideoWriter(video_out_name,'Uncompressed AVI');
video_out.FrameRate = 30;
open(video_out);
writeVideo(video_out,Y_up_2);

close(video_out)