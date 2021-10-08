function Frame = AVIReadSingleFrame(videofile,location)
%读取avi格式视频的一帧
videoObj = VideoReader(videofile);
nFrames = videoObj.NumberOfFrames;
vidFrames = read(videoObj);
disp(size(vidFrames));
Frame = vidFrames(:,:,:,location);
end
