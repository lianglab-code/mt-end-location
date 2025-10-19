function mouse_over_image_rect(img)
%% MOUSE_OVER_IMAGE moves a rectangle on an image figure as the mouse
% moves.

% this is a test. it is not efficient.
% if painting is wanted, set the original alpha of image in the painting
% axes as 0 and using helper_paint func; 
% if erasing is wanted, set the original alpha of image in the
% painting axes as alpha, and using helper_erase func;

patch_alpha = 0.3;
patch_radius = 30;
patch_radius_min = 1;
patch_radius_max = 60;
patch_radius_step = 1;

img = double(img);
imgmax = max(img(:));
imgmin = min(img(:));
img = (img-imgmin)/(imgmax-imgmin);

h_fig = figure('renderer','opengl');
set(h_fig,'nextplot','add');
setappdata(h_fig,'patch_radius',patch_radius);
setappdata(h_fig,'patch_radius_min',patch_radius_min);
setappdata(h_fig,'patch_radius_max',patch_radius_max);
setappdata(h_fig,'patch_radius_step',patch_radius_step);
setappdata(h_fig,'patch_alpha',patch_alpha);

% axes 1: original picture
h_ax = axes('parent',h_fig);
set(h_ax,'color','none');
set(h_ax,'clim',[0 1]);
h_im = imshow(img,[],'parent',h_ax);

% axes 2: roi overlay and the selection overlay
% I add this axes because I can clear all other additional var
% handily
[h w n] = size(img);
h_ax2 = helper_copy_axes(h_ax);
set(h_ax2,'color','none');
set(h_ax2,'clim',[0 1]);
linkaxes([h_ax h_ax2]);
red = cat(3,ones(h,w),zeros(h,w),zeros(h,w));
a = zeros(h,w);

% note: you have to change this property, otherwise adding new axes
% would changed this property of figure to 'replacechildren'
set(h_fig,'nextplot','add');
h_im2 = imshow(red,'parent',h_ax2);
set(h_im2,'alphadata',a);

% generate a rectangular patch
c = [w/2;h/2];
rect = helper_gen_rect(c,patch_radius);
h_patch = patch(rect(1,:),rect(2,:),'g','parent',h_ax2,'facealpha', ...
                patch_alpha,'edgecolor','none');
setappdata(h_fig,'patch_handle',h_patch);

% MAIN ENTRY
set(h_fig,'WindowButtonDownFcn',@wbdfcn);
set(h_fig,'WindowScrollWheelFcn',@wswfcn);


function wbdfcn(obj,evt,userdata)
set(obj,'WindowButtonMotionFcn',@wbmfcn);
set(obj,'WindowButtonUpFcn',@wbufcn);
set(obj,'Pointer','custom');
set(obj,'PointerShapeCData',NaN(16,16));
% inner_erase_region(obj);
inner_paint_region(obj);

function wbufcn(obj,evt,userdata)
set(obj,'WindowButtonMotionFcn','');
set(obj,'Pointer','arrow');

function wbmfcn(obj,evt,userdata)
% inner_erase_region(obj);
inner_paint_region(obj);

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

function inner_erase_region(obj)
h_axes = get(obj,'Children');
curr_cen = get(h_axes(1), 'CurrentPoint');
curr_cen = round(curr_cen(1,1:2))
r = getappdata(obj, 'patch_radius');
p_h = getappdata(obj, 'patch_handle');
rect = helper_gen_rect(curr_cen,r);
set(p_h,'XData',rect(1,:));
set(p_h,'YData',rect(2,:));
h_child = get(h_axes(1),'Children');
for ii = 1:numel(h_child)
    if isgraphics(h_child(ii),'image')
        alpha_data = get(h_child(ii),'alphadata');
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
        set(h_child(ii),'alphadata',alpha_data);
    end
end

function inner_paint_region(obj)
h_axes = get(obj,'Children');
curr_cen = get(h_axes(1), 'CurrentPoint');
curr_cen = round(curr_cen(1,1:2));
r = getappdata(obj, 'patch_radius');
p_h = getappdata(obj, 'patch_handle');
p_a = getappdata(obj, 'patch_alpha');
rect = helper_gen_rect(curr_cen,r);
set(p_h,'XData',rect(1,:));
set(p_h,'YData',rect(2,:));
h_child = get(h_axes(1),'Children');
for ii = 1:numel(h_child)
    if isgraphics(h_child(ii),'image')
        alpha_data = get(h_child(ii),'alphadata');
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
        set(h_child(ii),'alphadata',alpha_data);
    end
end
