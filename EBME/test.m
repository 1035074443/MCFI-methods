clc;
clear all;

format = 'avi'; %
length = 30;
videofile = '../videos/mobile_cif.avi';
[videos,status] = videoread(videofile,format,length);
disp(size(videos));
Y_up = EBME_fruc(videos,2);
YY = Y_up(:,:,1);
disp(size(Y_up));
Y_up_2 = zeros(288,352,1,59);
Y_up_2(:,:,1,:) = Y_up;
Y_up_2 = uint8(Y_up_2);
disp(size(Y_up_2));

video_out_name = '../videos/mobile_cif_2_mat.avi';
video_out = VideoWriter(video_out_name,'Uncompressed AVI');
video_out.FrameRate = 30;
open(video_out);
writeVideo(video_out,Y_up_2);

close(video_out)