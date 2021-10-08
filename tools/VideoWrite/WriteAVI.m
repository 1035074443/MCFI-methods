function WriteAVI(Frames,videoOutFile,FPS,mode)
%无压缩AVI格式写出视频
%   Frames       ---视频帧 [H,W,N]或[H,W,3,N]
%   videoOutFile ---写出路径,例如file.avi
%   FPS          ---视频指定FPS，例如30
%   mode         ---写出视频的色彩通道，可选'gray'或'rgb'
%                   gray：[H,W,N]
%                   rgb:  [H,W,3,N]

if strcmp(mode,'gray')
    [H,W,N] = size(Frames);
    FramesEmpty = zeros(H,W,1,N);
    FramesEmpty(:,:,1,:) = Frames;
    Frames = FramesEmpty;
end
Frames = uint8(Frames);
video_out = VideoWriter(videoOutFile,'Uncompressed AVI');
video_out.FrameRate = FPS;
open(video_out);
writeVideo(video_out,Frames);
close(video_out)
end

