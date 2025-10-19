function tif_img_writer(imgs, fname)
% to write multi-page tiff
% tif_img_writer(imgs, fname)
% only monochromatic image is supported.
% ref: https://cn.mathworks.com/help/matlab/ref/tiff-class.html


[img_h, img_w, num_frames] = size(imgs);
class_str = class(imgs);

% type conversion
if strcmp(class_str,'double') || strcmp(class_str,'float')
    imgs = uint16(imgs);
    class_str = class(imgs);
    warning('image type conversion; truncation might happen!');
end

t = Tiff(fname,'w');

% set tags
tagStruct.Photometric = Tiff.Photometric.MinIsBlack;
tagStruct.Compression = Tiff.Compression.None;
tagStruct.SamplesPerPixel = 1;
tagStruct.SampleFormat = Tiff.SampleFormat.UInt;
tagStruct.ExtraSamples = Tiff.ExtraSamples.Unspecified;
tagStruct.ImageLength = img_h;
tagStruct.ImageWidth = img_w;
%tagStruct.TileLength = 32;
%tagStruct.TileWidth = 32;
%tagStruct.RowsPerStrip = 256;
tagStruct.PlanarConfiguration = Tiff.PlanarConfiguration.Chunky;
if strcmp(class_str,'uint16')
    tagStruct.BitsPerSample = 16;
elseif strcmp(class_str,'uint8')
    tagStruct.BitsPerSample = 8;
end
% setTag(t,tagStruct);
t.setTag(tagStruct);
t.write(imgs(:,:,1));

% write multiple images
for ii = 2:num_frames
    t.writeDirectory();
    t.setTag(tagStruct);
    t.write(imgs(:,:,ii));
end

t.close();

end