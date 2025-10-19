function deact_other_pbutt()
%% DEACT_OTHER_PBUTT deactivates all pushbuttons but the current
% one.

% reference:
% https://cn.mathworks.com/help/matlab/ref/isa.html

global TOOLBAR_INFO;
global CANVAS_INFO;

for ii = 1:TOOLBAR_INFO.num_pbutt    
    if ii ~= TOOLBAR_INFO.curr_butt
        func_handle = TOOLBAR_INFO.pbutt_deact{ii};
        if isa(func_handle,'function_handle')
            func_handle();
        end
    end
end

end