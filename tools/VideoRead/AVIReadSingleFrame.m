function Frame = AVIReadSingleFrame(videofile,location)
%��ȡavi��ʽ��Ƶ��һ֡
videoObj = VideoReader(videofile);
nFrames = videoObj.NumberOfFrames;
vidFrames = read(videoObj);
disp(size(vidFrames));
Frame = vidFrames(:,:,:,location);
end
