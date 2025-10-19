function pbutt = add_pbutton(n, no, w, h, m, str, parent)
%% ADD_PBUTTON adds a push button and arrange the layout in PARENT
% The layout is vertical, from top to buttom.
% It is mainly used in the Main Window for a series of tasks.

% Input:
% n: the number of buttons
% no: the index of the current button
% w: button width
% h: button height
% m: margin to the figure window
% str: the button string
% parent: the main figure

pbutt = uicontrol( ...
    'Parent', parent, ...
    'Style', 'pushbutton', ...
    'String', str, ...
    'Position', [m, m+(m+h)*(n-no), w, h], ...
    'Enable', 'off', ...
    'Callback', '');
end
