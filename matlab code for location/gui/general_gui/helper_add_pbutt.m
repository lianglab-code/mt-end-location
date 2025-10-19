function helper_add_pbutt(n, str, icon_filename, varargin)
%% HELPER_ADD_PBUTT is a helper that add a pushbutton info into the
% TOOLBAR_INFO struct, to save space.

% INPUT:
% n: button number
% str: tool tip string
% icon_filename: filename of the icon
% callback_handle: callback function handle
% deact_handle: function to be deactivated
global TOOLBAR_INFO;

if n<1 || n> TOOLBAR_INFO.num_pbutt
    error('too many pushbuttons');
end

callback_handle = '';
deact_handle = '';
if nargin > 3
    callback_handle = varargin{1};
    if nargin > 4
        deact_handle = varargin{2};
    end
end

% from: http://undocumentedmatlab.com/blog/button-customization
TOOLBAR_INFO.pbutt_names{n} = ['<html><h3><b>' str '</b><h3></html>'];
TOOLBAR_INFO.cdata{n} = load_icon( ...
    icon_filename, ...
    TOOLBAR_INFO.butt_size, ...
    TOOLBAR_INFO.butt_size);
TOOLBAR_INFO.pbutt_callback{n} = callback_handle;
TOOLBAR_INFO.pbutt_deact{n} = deact_handle;

end