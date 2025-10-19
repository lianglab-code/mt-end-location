function seg_out = img_manual_segment(img,varargin)
%% IMG_MANUAL_SEGMENT allows user to manually paint on the input img
% to segment the target.
% seg_out = manual_segment(img,varargin)
%
% INPUT:
% img: 2d image, mxn
% mask: optional, original mask, binary
%
% OUTPUT:
% seg_out: segmentation result, binary image
%
% INTERACTIVE CONTROL:
% mouse scroll wheel: to change the size of the rectangle (pen)
% any key: to finish the segmentation process
%
% NOTE:
% I learned the way of outputing result:)

% PARAMETERS
patch_alpha = 0.3;
patch_radius = 30;
patch_radius_min = 1;
patch_radius_max = 60;
patch_radius_step = 1;

[h,w,L] = size(img);
if L~=1
    error('multi-frame or color image is not allowed');
end

mask = [];
if nargin>1
    mask = double(logical(varargin{1}))*patch_alpha;
else
    mask = zeros(h,w);
end

img = double(img);
img2 = img(:);

% quantiles used to set the range of the image
q1 = quantile(img2,0.1);
q2 = quantile(img2,0.9);
if (q2-q1)<1e-6
    error('something wrong with the image');
end
img = (img-q1)/(q2-q1);
clear 'img2';

% figure
h_fig = figure('renderer','opengl');
setappdata(h_fig,'patch_radius',patch_radius);
setappdata(h_fig,'patch_radius_min',patch_radius_min);
setappdata(h_fig,'patch_radius_max',patch_radius_max);
setappdata(h_fig,'patch_radius_step',patch_radius_step);
setappdata(h_fig,'patch_alpha',patch_alpha);
seg_out = [];
guidata(h_fig,seg_out);

% axes
h_ax = axes('parent',h_fig);
set(h_ax,'nextplot','add');
set(h_ax,'color','none');
set(h_ax,'clim',[0 1]);
h_im1 = imshow(img,[],'parent',h_ax);
setappdata(h_fig,'h_ax',h_ax);

% painting canvas
red = cat(3,ones(h,w),zeros(h,w),zeros(h,w));
h_im2 = imshow(red,'parent',h_ax);
set(h_im2,'alphadata',mask);
setappdata(h_fig,'h_im2',h_im2);

c = [w/2;h/2];
rect = helper_gen_rect(c,patch_radius);
h_patch = patch(rect(1,:),rect(2,:),'g','parent',h_ax,'facealpha', ...
                patch_alpha,'edgecolor','none');
setappdata(h_fig,'patch_handle',h_patch);


%% MAIN ENTRY
set(h_fig,'WindowButtonDownFcn',@wbdfcn);
set(h_fig,'WindowScrollWheelFcn',@wswfcn);
set(h_fig,'WindowKeyPressFcn', @kbcb);
set(h_fig,'CloseRequestFcn', @crfcn);
uiwait(h_fig);
alpha_data = get(h_im2, 'alphadata');
seg_out = alpha_data~=0;
% close(h_fig);
delete(h_fig);



%% INNER FUNCTIONS
% circle generation
function rect = helper_gen_rect(c,r)
rect = [c(1)-r, c(1)+r, ...
        c(1)+r, c(1)-r; ...
        c(2)-r, c(2)-r, ...
        c(2)+r, c(2)+r];

function wbdfcn(obj,evt,userdata)
set(obj,'WindowButtonUpFcn',@wbufcn);
set(obj,'Pointer','custom');
set(obj,'PointerShapeCData',NaN(16,16));
mouse_button = get(obj,'SelectionType');
switch lower(mouse_button)
  case 'normal'
    inner_paint_region(obj);
    set(obj,'WindowButtonMotionFcn',@l_wbmfcn);
  case 'alt'
    inner_erase_region(obj);
    set(obj,'WindowButtonMotionFcn',@r_wbmfcn);
end

function wbufcn(obj,evt,userdata)
set(obj,'WindowButtonMotionFcn','');
set(obj,'Pointer','arrow');

function l_wbmfcn(obj,evt,userdata)
inner_paint_region(obj);

function r_wbmfcn(obj,evt,userdata)
inner_erase_region(obj);

function wswfcn(obj,evt,userdata)
% disp('wbufcn');
r = getappdata(obj,'patch_radius');
rmin = getappdata(obj,'patch_radius_min');
rmax = getappdata(obj,'patch_radius_max');
step = getappdata(obj,'patch_radius_step');
% scrollcount
sc = evt.VerticalScrollCount;
r2 = r - sc*step;
if r2>=rmin && r2<=rmax
    r = r2;
    setappdata(obj,'patch_radius',r);
    h_axes = get(obj,'Children');
    curr_cen = get(h_axes(1), 'CurrentPoint');
    curr_cen = curr_cen(1,1:2);
    p_h = getappdata(obj, 'patch_handle');
    rect = helper_gen_rect(curr_cen,r);
    set(p_h,'XData',rect(1,:));
    set(p_h,'YData',rect(2,:));
end

function inner_paint_region(obj)
r = getappdata(obj, 'patch_radius');
p_h = getappdata(obj, 'patch_handle');
p_a = getappdata(obj, 'patch_alpha');
h_ax = getappdata(obj, 'h_ax');
h_im2 = getappdata(obj, 'h_im2');
curr_cen = get(h_ax, 'CurrentPoint');
curr_cen = round(curr_cen(1,1:2));
rect = helper_gen_rect(curr_cen,r);
set(p_h,'XData',rect(1,:));
set(p_h,'YData',rect(2,:));
alpha_data = get(h_im2, 'alphadata');
[x,y] = deal(curr_cen(1), curr_cen(2));
% left, right, down, up
[a,b,c,d] = deal(x-r,x+r,y-r,y+r);
if a<1
    a = 1;
end
if c<1
    c = 1;
end
if b>size(alpha_data,2)
    b = size(alpha_data,2);
end
if d>size(alpha_data,1)
    d = size(alpha_data,1);
end
alpha_data(c:d,a:b) = p_a;
set(h_im2,'alphadata',alpha_data);

function inner_erase_region(obj)
r = getappdata(obj, 'patch_radius');
p_h = getappdata(obj, 'patch_handle');
p_a = getappdata(obj, 'patch_alpha');
h_ax = getappdata(obj, 'h_ax');
h_im2 = getappdata(obj, 'h_im2');
curr_cen = get(h_ax, 'CurrentPoint');
curr_cen = round(curr_cen(1,1:2));
rect = helper_gen_rect(curr_cen,r);
set(p_h,'XData',rect(1,:));
set(p_h,'YData',rect(2,:));
alpha_data = get(h_im2, 'alphadata');
[x,y] = deal(curr_cen(1), curr_cen(2));
% left, right, down, up
[a,b,c,d] = deal(x-r,x+r,y-r,y+r);
if a<1
    a = 1;
end
if c<1
    c = 1;
end
if b>size(alpha_data,2)
    b = size(alpha_data,2);
end
if d>size(alpha_data,1)
    d = size(alpha_data,1);
end
alpha_data(c:d,a:b) = 0;
set(h_im2,'alphadata',alpha_data);


% keyboard callback
function kbcb(obj,evt,userdata)
uiresume(obj);

% CloseRequestFcn
function crfcn(obj,evt,userdata)
uiresume(obj);
