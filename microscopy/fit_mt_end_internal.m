function [param_out, res, exitflag] = ...
    fit_mt_end_internal(img,...
                        param_in,...
                        param_lb,...
                        param_ub,...
                        varargin)
%% FIT_MT_END_INTERNAL fits images to 2d filament end
% original reference: fit_2d_filament_end.m
% ~ means ignoring some parameters

% Inputs:
% img: 2d image
% param_in: initial parameters, 1x6: [x,y,sigma,theta,amp,baseline]
% param_lb: initial parameters lower bound, 1x6
% param_ub: initial parameters upper bound, 1x6
% 'robust': optional, not implemented

% param_out:
% 1. x0
% 2. y0
% 3. sigma
% 4. theta
% 5. amplitude
% 6. baseline

% exitflag:
% 1 Function converged to a solution x.
% 2 Change in x was less than the specified tolerance.
% 3 Change in the residual was less than the specified tolerance.
% 4 Magnitude of search direction was smaller than the specified tolerance.
% 0 Number of iterations exceeded options.MaxIterations or number of function evaluations exceeded options.MaxFunctionEvaluations.
% -1 Output function terminated the algorithm.
% -2 Problem is infeasible: the bounds lb and ub are inconsistent. 

% Note:
% theta:
%
%            \
%             \
%     theta    \      
%  --------------.--------------> x
%                |
%                |
%                |
%                |
%                |
%                |
%                |
%                |
%                |
%
%                y

    [h, w] = size(img);
    
    [xg, yg] = meshgrid(1:w, 1:h);
    xdata = cat(3, xg, yg);

    res = nan;
    exitflag = nan;
    param_out = nan(1,6);

    if nargin == 4
        OPTIONS = optimoptions('lsqcurvefit', ...
                               'Algorithm', 'trust-region-reflective', ...
                               'Display','off');


        [a, b, ~, c, ~] = ...
            lsqcurvefit(@FilamentTip2D, ...
                        param_in, ...
                        xdata, ...
                        img, ...
                        param_lb, ...
                        param_ub, ...
                        OPTIONS);
        res = b;
        exitflag = c;
        param_out = a;

    elseif (nargin == 5) && ...
            strcmp(lower(varargin{1}),'robust')
        error('robust not implemented');
    else
        error('wrong usage');
    end
       
end
