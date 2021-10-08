clc;
clear all;
format = 'avi'; %
length = 10;
videofile = 'E:\frame_interpolation\frame_interpolation_generation\videos\mobile_cif.avi';
[videos,status] = videoread(videofile,format,length);
Y_up = DSME(videos,2);
disp(size(Y_up));
Y_up_2 = zeros(288,352,1,19);
Y_up_2(:,:,1,:) = Y_up;
Y_up_2 = uint8(Y_up_2);
disp(size(Y_up_2));

video_out_name = 'E:\frame_interpolation\frame_interpolation_generation\videos\mobile_cif_DSME.avi';
video_out = VideoWriter(video_out_name,'Uncompressed AVI');
video_out.FrameRate = 30;
open(video_out);
writeVideo(video_out,Y_up_2);

close(video_out)