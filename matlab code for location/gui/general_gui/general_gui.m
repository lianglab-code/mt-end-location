function general_gui(img)
%% GENERAL_GUI is a GUI template for interactive image processing
% programs.

% add modules, if there is any
add_paths('.');

%% GLOBAL PARAM INITIALIZATION
global IMG_INFO;
global TOOLBAR_INFO;
global CANVAS_INFO;

%% Initialization
init_global_param(img);
init_toolbar_gui();
init_canvas_gui();

end
