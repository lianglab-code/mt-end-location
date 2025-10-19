function c = circ_profile(I, x, y, r,varargin)
%% CIRC_PROFILE returns the profile along a circle
%
% Input:
% I: 2D image
% x,y,r: center and radius, scalar / npx1 vec
% 
% Output:
% c: nx1 or nxnp vector
%
% Optional Input:
% d: 0, the half width of the profiling line
% n: 72, the length of the returning vector
% warnon: false

% Note:
% the input output formats are consistent with the MATLAB 
% built-in function IMPROFILE
%
% Test:
% testimg = zeros(70,66);
% p1 = circ_profile(testimg,29,32,6);
% p2 = circ_profile(testimg,29,32,9);
%

% default parameters:
    d = 0;
    n = 72;
    np = numel(x); % number of points
    warnon = false;
    [H,W] = size(I);

    if nargin > 4
        d = varargin{1};
        if nargin > 5
            n = varargin{2};
            if nargin > 6
                warnon = true;
            end
        end
    end

    if np~=numel(y) || np~=numel(r)
        error('size mismatch');
        return;
    end
    % radius cann't be too small!
    if warnon 
        if any(r<2)
            warning('radius cannot be too small,abort');
        end
                % outside of the image check
        if any(x<1) || any(x>W) || any(y<1) || any(y>H)
            warning('center outside of image');
        end
    end

    % output
    c = zeros(n,np);

    % angle
    t = (linspace(0,pi*2-pi*2/n,n))'; % 1xn
    l = floor(d);
    m = 2*l + 1;
    % unit circle
    uu = cos(t);
    vv = sin(t);

    for ii = 1:np
        % radius list
        ww = (r(ii)-l):(r(ii)+l);
        % scaled circle
        u = x(ii) * ones(n,m) + uu * ww;
        v = y(ii) * ones(n,m) + vv * ww;
        % 
        cs = zeros(n,m);
        for j = 1:m
            % cs(:,j) = interp2(I,u(:,j),v(:,j),'cubic',0);
            cs(:,j) = interp2(I,u(:,j),v(:,j),'linear',0);
        end
        c(:,ii) = mean(cs,2);
    end

end