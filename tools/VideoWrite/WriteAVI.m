function WriteAVI(Frames,videoOutFile,FPS,mode)
%��ѹ��AVI��ʽд����Ƶ
%   Frames       ---��Ƶ֡ [H,W,N]��[H,W,3,N]
%   videoOutFile ---д��·��,����file.avi
%   FPS          ---��Ƶָ��FPS������30
%   mode         ---д����Ƶ��ɫ��ͨ������ѡ'gray'��'rgb'
%                   gray��[H,W,N]
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

