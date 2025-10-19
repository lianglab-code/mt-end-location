function [p,param] = op_localize_endpoint(img,p1,p2,varargin)
%% OP_LOCALIZE_ENDPOINT is an example of extending the functionality
% of the image_viewer.

% This example localizes/adjusts the endpoint around p0 in the image
% to tubule end, e.g., MT end. The method used to localize a point is
% nonlinear fitting a filament tip model.

% INPUT:
% img: 2d image
% p1: end point (start), vector with two element
% p2: internal point (end), vector with two element; used to
%     determine the direction of the filament.
% param0: param0 of the filament model;
%         [x;y;sigma;theta;a;b;residual;exitflag];
%         not used now, might be used to indicate the average param

% OUTPUT:
% p: corrected end point, 2x1 column vector
% param: [x;y;sigma;theta;a;b;residual;exitflag]

% NOTE:
% Please refer to the program fit_one_mt_end of the MT project

%% input check
[img_h,img_w,num_frames] = size(img);
if num_frames>1
    warning('only 2d image is supported, abort');
    return;
end

p = nan(2,1);
param = nan(8,1);
if prod(size(p1))~=2 || prod(size(p2))~=2
    warning('please input a point with correct format, abort');
    return;
end
if sum(isnan(p1))>0 || sum(isnan(p2))>0
    warning('point with nan value');
    return;
end
p1 = reshape(p1,[2 1]);
p2 = reshape(p2,[2 1]);
p = p1;

%% hard-coded criteria for dots
MAX_TRY = 2; % the p0 might not be close enough to the center
FWHM = 7; % the width of a MT
R = FWHM; % radius of cropping region for fitting

%% algo begins here
% fitting setup
[xg, yg] = meshgrid(1:(2*R+1), 1:(2*R+1));
xdata = cat(3, xg, yg);

for ii = 1:MAX_TRY
    I = round(p1(2));
    J = round(p1(1));
    if I<(R+1) || I>(img_h-R) ...
            || J<(R+1) || J>(img_w-R)
        warning('the endpoint is too close to the border, abort');
        return;
    end
    crop = img((I-R):(I+R),(J-R):(J+R));
    crop2 = sort(crop(:),'ascend');
    % guess of the gaussian model
    x0 = 1+R;
    y0 = 1+R;
    b0 = sum(crop2(1:5))/5;
    a0 = (crop2(end)+crop2(end-1))/2-b0;
    s0 = FWHM;
    t0 = atan2(p1(2)-p2(2),p1(1)-p2(1));
    
    param_in = [x0, y0, s0, t0, a0, b0];
    param_lb = [x0-R/2, y0-R/2, FWHM/2, t0-pi/4, crop2(end)/2, crop2(1)];
    param_ub = [x0+R/2, y0+R/2, FWHM*2, t0+pi/4, crop2(end), crop2(R*2*R)];

    param = helper_fitmodel(xdata,crop,...
                            param_in,...
                            param_lb,...
                            param_ub);
    param(1) = param(1)-(1+R)+J;
    param(2) = param(2)-(1+R)+I;
    p(1) = param(1);
    p(2) = param(2);
end

%% -------------- NESTED FUNCTIONS -----------------

function po = helper_fitmodel(xdata,Z,p0,pl,pu)
%% HELPER_FITMODEL is a wrapper for the fit function.
% po = helper_fitmodel(X,Y,xdata,p0,pl,pu)

% INPUT:
% xdata: meshgrid
% Z: Z
% p0: param guess
% pl: param lowerbound
% pu: param upperbound

% OUTPUT:
% po: param output, including res and flag

% fitting options
OPTIONS = optimoptions('lsqcurvefit', ...
                       'Algorithm', 'trust-region-reflective', ...
                       'Display','off');

[param_out, res, ~, exitflag, ~] = ...
    lsqcurvefit(@fitmodel, ...
                p0, ...
                xdata, ...
                Z, ...
                pl, ...
                pu, ...
                OPTIONS);
po = [param_out,res,exitflag];
end

% filament tip
% EXAMPLE:
% params = [0 0 3 pi/4 10 0];
% [X,Y] = meshgrid(-20:20,-20:20);
% xdata = cat(3,X,Y);
% f = fitmodel(params,xdata);
% mesh(X,Y,f)
% xlabel('X');
% ylabel('Y');
% text(4,60,texlabel('x=y=b=0;s=3;theta=pi/4;a=10'));
% NOTE: the direction is from inside MT to the tip of MT. 
%       For example, if theta=0, the growth direction of MT is from
%       left to right.
function f = fitmodel(params,xdata)
% function I = FilamentTip2D(params, xdata)
    x = xdata(:,:,1);
    y = xdata(:,:,2);
    % params:
    x0 = params(1);
    y0 = params(2);
    s = params(3); % sigma
    t = params(4); % theta
    a = params(5); % amplitude
    b = params(6); % baseline
    
    g = -(x-x0).*sin(t-pi/2) + (y-y0).*cos(t-pi/2) + 0.5;
    g( g < 0 ) = 0;
    g( g > 1 ) = 1;
    A = 1/(2*s^2); % tmp var
    f = a*( g .*exp( -A*( ( x-x0 ).^2 + ( y-y0 ).^2 ) ) + ...
            (1-g).*exp( -A*(-( x-x0 )*sin(t) + ( y-y0 )*cos(t)).^2) ) + ...
        b;
end

end