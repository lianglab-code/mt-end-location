function f = filament_tip(params,xdata)
% function I = FilamentTip2D(params, xdata)
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
