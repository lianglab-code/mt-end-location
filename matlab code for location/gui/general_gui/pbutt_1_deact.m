function pbutt_1_deact()
%% PBUTT_1_DEACT deactivates some functions when the current
% pushbutton is changed.

% reference
% https://cn.mathworks.com/help/matlab/ref/pan.html

global TOOLBAR_INFO;
global CANVAS_INFO;

move_axes(CANVAS_INFO.h_axes,'off');
end