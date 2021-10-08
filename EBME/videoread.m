function [videos,status] = videoread(videofile,format,length)

[~,~,ext] = fileparts(videofile);
init2last = [0,length-1];
if strcmp(ext,'.yuv')
    % for uncompressed videos
    [videos,~,~] = ReadMultiFrames(videofile,format,init2last);
    status = 'uncompressed';
else
    % for compressed videos
    videoObj = VideoReader(videofile);
    nFrames = videoObj.NumberOfFrames;
    vidFrames = read(videoObj);
    disp(size(vidFrames));
    for k = 1 : length
             videos(:,:,k) = double(rgb2gray(vidFrames(:,:,:,k)));
             status = 'compressed';
    end
end
end