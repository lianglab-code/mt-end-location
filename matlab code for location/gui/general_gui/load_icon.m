function imgout = load_icon(filename, w, h)
%% LOAD_ICON loads image for CData of uicontrols

% INPUT:
% filename: icon file name
% w: widht
% h: height

% OUTPUT:
% imgout: output image

[img,map] = imread(filename);
dims = size(img);
if h~=dims(1) || w~=dims(2)
    error(['icon image must have dimensions', ...
          num2str(w), ...
          ' x ', ...
          num2str(h)]);
end

if prod(size(map))~=0
    imgout = ind2rgb(img,map);
else
    imgout = img;
end

if size(imgout,3)==1
    imgout = repmat(imgout,1,1,3);
end

end