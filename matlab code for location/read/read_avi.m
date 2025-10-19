% R2014a
video = VideoReader('1.avi');
img_width = video.Width;
img_height = video.Height;
num_frames = video.NumberOfFrames;

frames = read(video);
