function deact_all_pbutt()
%% DEACT_OTHER_PBUTT deactivates all pushbuttons but the current
% one.

% reference:
% https://cn.mathworks.com/help/matlab/ref/isa.html

global TOOLBAR_INFO;
global CANVAS_INFO;

for ii = 1:TOOLBAR_INFO.num_pbutt
    this_pbutt = TOOLBAR_INFO.pbutts{ii};
    is_on = getappdata(this_pbutt,'is_on');
    if is_on == 1
        setappdata(this_pbutt,'is_on',0);
        func_handle = TOOLBAR_INFO.pbutt_deact{ii};
        if isa(func_handle,'function_handle')
            func_handle();
    end
end
end

end
