% gaussian filter
wg = fspecial('gaussian',[7,7]);
img_smoothed = imfilter(img, wg);

% background removal
wd = strel('disk',10);
img_bg_removed = imtophat(img_smoothed, wd);

