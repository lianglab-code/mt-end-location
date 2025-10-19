function [param,resnorm,exitflag,residual] = ...
        fit_2d_gaussian(I, varargin)
%% FIT_2D_GAUSSIAN localizes the center of a single point in an 
% image and returns the coordinate of the center in the local coordinate 
% system.
%
% Input:
% I: input image
%
% Optional Input:
% param0: [x0,y0,sigma,H,b]
% algo: 'levenberg-marquardt' or 'trust-region-reflective'
%
% Output:
% param: [x0,y0,sigma,H,b]
% res: residual
% exitflag: lsqcurvefit exitflag
%
% Original program: point_localize_by_fitting
%
% Note:
% Gaussian model: I = b + H * exp((-(x-x0).^2-(y-y0).^2)/(2*sigma^2));
%
% Example:
% crop = 
%    1.0e+04 * ...
%     [0.9343    0.2382   -0.1658   -0.2118   -0.2191   -0.2604   -0.2010...
%     0.5319   -0.1157   -0.1784    0.1837    0.2607   -0.0469   -0.2428...
%    -0.0153   -0.3505    0.1648    1.0764    1.2485    0.5316   -0.1405...
%    -0.2830   -0.3040    0.6240    1.8753    2.0836    1.0483   -0.0127...
%    -0.2906   -0.2114    0.6641    1.8001    1.9735    0.9609   -0.0874...
%    -0.2006   -0.1845    0.2638    0.9149    1.0282    0.3930   -0.2563...
%    -0.0391   -0.0557   -0.0518    0.0700    0.1454   -0.0003   -0.1823];
% [p1,r1,flag1,res1] = fit_2d_gaussian(crop,[],'levenberg-marquardt');
% [p2,r2,flag2,res2] = fit_2d_gaussian(crop,[],'trust-region-reflective');
% % results:
% % p1 == [4.65 4.42 1.13 2.6e4 -1.19e3];
% % p2 == [4.65 4.43 1.16 2.4e4 -0.11e3];
% % flag1 == 3
% % flag2 == 3
% % r1 == 2.59e8
% % r2 == 2.65e8
% 
% See Also:
% localize_beads

% output results
    param = zeros(5,1);
    resnorm = 0;
    exitflag = 0;
    residual = [];

    [m,n] = size(I);
    [X,Y] = meshgrid(1:n, 1:m);
    xdata = zeros(m,n,2);
    xdata(:,:,1) = X;
    xdata(:,:,2) = Y;

    % estimate the parameters
    Imin = min(I(:));
    Imax = max(I(:));
    if nargin < 2
        param0 = [n/2 m/2 min(m,n)/6 (Imax-Imin) Imin];
    else
        param0 = varargin{1};
        if isempty(param0)
            param0 = [n/2 m/2 min(m,n)/6 (Imax-Imin) Imin];
        end
    end
    % algo = 'trust-region-reflective';
    algo = 'levenberg-marquardt';
    if nargin > 2
        algo = varargin{2};
    end
    %

    % To turn off the warning
    if strcmp(lower(algo),'levenberg-marquardt')
        OPTIONS = optimoptions('lsqcurvefit', ...
                               'Algorithm', ...
                               'levenberg-marquardt', ...
                               'Display','off');
        [param, resnorm, residual, exitflag] = ...
            lsqcurvefit(@gaussian_2d, ...
                        param0, ...
                        xdata, ...
                        I, [], [], OPTIONS);
    else
        lb = [1 1 0 0 Imin];
        ub = [n m min(m,n) (Imax-Imin) Imax];
        OPTIONS = optimoptions('lsqcurvefit', ...
                               'Algorithm', ...
                               'trust-region-reflective', ...
                               'Display','off');
        [param, resnorm, residual, exitflag] = ...
            lsqcurvefit(@gaussian_2d, ...
                        param0, ...
                        xdata, ...
                        I, lb, ub, OPTIONS);
    end

    % % Debug
    % Z = gaussian_2d(param, xdata);
    % figure;
    % surf(X, Y, Z,'facealpha',0.5);
    % hold on;
    % % plot3(X, Y, I, 'ro');
    % mesh(X,Y,I,'facealpha',0.5);
    % hold off;
    % title(algo);

    function z = gaussian_2d(param, xdata)
    %% GAUSSIAN_2D calculates the value for a symmetric 2d gaussian function.
    % Input:
    % param: the parameters, [x0, y0, sigma, a, b]
    % xdata: x and y
    % z = b + H*exp( -((x-x0)^2+(y-y0)^2) / (2*sigma^2) );
    % param(1): x0
    % param(2): y0
    % param(3): sigma
    % param(4): magnitude
    % param(5): baseline
        z = param(5) + param(4) .* exp(-((xdata(:,:,1)-param(1)).^2+(xdata(:,:,2)-param(2)).^2)/(2*param(3)^2));
    end

end
