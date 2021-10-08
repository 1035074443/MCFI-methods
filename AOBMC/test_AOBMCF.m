clc;
clear all;
% addpath('.\utilities\');
% addpath('.\FRUC_codes\');

format = 'avi'; %
length = 30;
videofile = 'E:\frame_interpolation\frame_interpolation_generation\videos\mobile_cif.avi';
[videos,status] = videoread(videofile,format,length);
Y_up = AOBMCF(videos,2);
disp(size(Y_up));
Y_up_2 = zeros(288,352,1,59);
Y_up_2(:,:,1,:) = Y_up;
Y_up_2 = uint8(Y_up_2);
disp(size(Y_up_2));

video_out_name =  'E:\frame_interpolation\frame_interpolation_generation\videos\mobile_cif_212.avi';
video_out = VideoWriter(video_out_name,'Uncompressed AVI');
video_out.FrameRate = 30;
open(video_out);
writeVideo(video_out,Y_up_2);

close(video_out)