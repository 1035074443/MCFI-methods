function videos = AVIRead(videofile,init2last)
%读取avi格式视频
videoObj = VideoReader(videofile);
nFrames = videoObj.NumberOfFrames;
width = videoObj.Width;
height = videoObj.Height;
vidFrames = read(videoObj);
start_num = fix(init2last(1));
end_num = fix(init2last(2));
if end_num==1
    videos = zeros(height,width,3,nFrames);
    videos = vidFrames;
elseif end_num>1
    videos = zeros(height,width,3,end_num-start_num+1);
    for k = 1:end_num-start_num
        videos(:,:,:,k) = vidFrames(:,:,:,start_num+k-1);
    end    
end
end