function zoom_axes(h_ax, mag)
%% ZOOM_AXES zooms the figure

% INPUT:
% h_ax: figure handle
% mag: magnifying factor, >1 zoom-in; <1 zoom-out;

% reference:
% https://cn.mathworks.com/help/matlab/ref/isgraphics.html
% https://cn.mathworks.com/help/matlab/ref/findall.html
% findall returns a handle array, not a cell!

% nothing to do
if mag==1
    return;
end

if mag>20 || mag<0.05
    warning('magnification factor is too extreme!');
end

% not a figure
if isgraphics(h_ax,'axes')~=1
    error('zoom_axes can only zoom an axes');
    return;
end

a0 = axis(h_ax); % axis
w0 = a0(2)-a0(1); % width
h0 = a0(4)-a0(3); % height
x0 = (a0(2)+a0(1))/2; % center
y0 = (a0(4)+a0(3))/2; % center

w1 = w0/mag;
h1 = h0/mag;
a1 = [x0-w1/2 x0+w1/2 y0-h1/2 y0+h1/2];
axis(h_ax,a1);

end