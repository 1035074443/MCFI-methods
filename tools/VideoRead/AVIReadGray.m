function videos = AVIReadGray(videofile,init2last)
%读取avi格式视频
videoObj = VideoReader(videofile);
nFrames = videoObj.NumberOfFrames;
width = videoObj.Width;
height = videoObj.Height;
vidFrames = read(videoObj);
start_num = fix(init2last(1));
end_num = fix(init2last(2));
if end_num==1
    videos = zeros(height,width,nFrames);
    for k=1:nFrames
        videos(:,:,k) = rgb2gray(vidFrames(:,:,:,k));
    end
elseif end_num>1
    videos = zeros(height,width,end_num-start_num+1);
    for k = 1:end_num-start_num
        videos(:,:,k) = rgb2gray(vidFrames(:,:,:,start_num+k-1));
    end    
end
end