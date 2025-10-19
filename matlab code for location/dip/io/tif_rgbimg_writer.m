function tif_rgbimg_writer(rgb,fname)
% to write RGB tiff
% tif_rgbimg_writer(rgb,fname)
% only uint8 is supported

% type conversion
class_str = class(rgb);
if strcmp(class_str,'double') || strcmp(class_str,'float')
    rgb = rgb/max(rgb(:));
    rgb = uint16(rgb*2^16);
    class_str = class(rgb);
    warning('image type conversion; truncation might happen!');
end

t = Tiff(fname,'w');
tagstruct.ImageLength = size(rgb,1);
tagstruct.ImageWidth = size(rgb,2);
tagstruct.Photometric = Tiff.Photometric.RGB;
if strcmp(class_str,'uint8')
    tagstruct.BitsPerSample = 8;
else
    tagstruct.BitsPerSample = 16;
end
tagstruct.SamplesPerPixel = 3;
tagstruct.PlanarConfiguration = Tiff.PlanarConfiguration.Chunky;
tagstruct.Software = 'MATLAB';
setTag(t,tagstruct)
write(t,rgb);
close(t);
