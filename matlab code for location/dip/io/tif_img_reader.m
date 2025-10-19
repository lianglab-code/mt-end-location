function img = tif_img_reader(fname)
% to read multi-page tiff

% INPUT:
% fname: tif file name

% OUTPUT:
% img: h * w * frames if monochromatic,
% img: h * w * channels * frames if multichromatic.

% NOTE:
% http://blogs.mathworks.com/steve/2009/04/02/matlab-r2009a-imread-and-multipage-tiffs/

% fname = 'my_file_with_lots_of_images.tif';
info = imfinfo(fname);

num_images = numel(info);
width = info(1).Width;
height = info(1).Height;
num_channel = 0;

% imagej
is_imagej = false;
if isfield(info(1),'ImageDescription')
    descstr = getfield(info(1),'ImageDescription');
    descstr2 = strsplit(descstr,'\n');
    numstr = numel(descstr2);
    for ii = 1:numstr
        tmpstr = lower(descstr2{ii});
        if(~isempty(strfind(tmpstr,'imagej')))
            is_imagej = true;
            break;
        end
    end
    if(is_imagej)
        for ii = 1:numstr
            tmpstr = lower(descstr2{ii});
            tmpstr2 = strsplit(tmpstr,'=');
            switch tmpstr2{1}
              case {'channels'}
                num_channel = str2num(tmpstr2{2});
            end
        end
    end
end

% is imagej and channel is recorded bin 'channels'
if(is_imagej && num_channel>0)
    if num_channel>1
        % the returned img could be splited into each channel like this:
        % > img1 = squeeze(imgs(:,:,1,:));
        img = zeros(height, width, num_channel, num_images/ ...
                    num_channel);
        for k = 1:num_images
            ind_channel = mod(k,num_channel);
            if ind_channel==0
                ind_channel = num_channel;
                ind_frame = k/num_channel;
            else
                ind_frame = floor(k/num_channel)+1;
            end
            % img(:,:,mod(k-1,num_channel)+1,int16(k/num_channel)+1) = ...
            %     imread(fname,k);
            img(:,:,ind_channel,ind_frame) = imread(fname,k);
        end
    else
        img = zeros(height, width, num_images);
        for k = 1:num_images
            img(:,:,k) = imread(fname, k);
            % ... Do something with image A ...
        end
    end

% not imagej
else
    num_channel = length(info(1).BitsPerSample);
    if num_channel>1
        % the returned img could be splited into each channel like this:
        % > img1 = squeeze(imgs(:,:,1,:));
        img = zeros(height, width, num_channel, num_images);
        for k = 1:num_images
            img(:,:,:,k) = imread(fname, k);
            % ... Do something with image A ...
        end
    else
        img = zeros(height, width, num_images);
        for k = 1:num_images
            img(:,:,k) = imread(fname, k);
            % ... Do something with image A ...
        end
    end
end
