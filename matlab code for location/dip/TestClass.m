classdef TestClass 
    properties
        h_fig;
    end
    
    methods
        function obj = TestClass()
            obj.h_fig = figure;
            plot([0,.5,1],[0,.5,1],'ro-');
            set(obj.h_fig, ...
                'WindowButtonDownFcn', @obj.cb, ...
                'WindowButtonMotionFcn', '', ...
                'WindowButtonUpfcn', '', ...
                'WindowScrollWheelFcn','', ...
                'WindowKeyPressFcn', '');
        end
    end
    methods(Access='private')
        function cb(obj,src,evt)
            h_axes = get(obj.h_fig,'CurrentAxes');
            p = get(h_axes,'CurrentPoint');
            disp(p);
        end
    end
end