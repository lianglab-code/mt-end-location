function bs = gen_init_bs(pc, num_cp, varargin)
%% GEN_INIT_BS generates an initial cubic b-spline from a given
% point cloud.

% The generated b-spline has a shape of ellipse and is closed.

% INPUT:
% pc: point cloud, 2*n
% num_cp:  number of control points
% s: scaling factor of the ellipse (it seems the eigenvalue is too
% large for closed contour)

% OUTPUT:
% bs: cubic b-spline

% Example:
% rho = pi/6;
% theta = linspace(0,2*pi,100);
% a = 10; b = 2.5;
% x = a*cos(theta);
% y = b*sin(theta);
% p = [cos(rho),-sin(rho);sin(rho),cos(rho)]*[x;y];
% bs = gen_init_bs(p,10);
% plot(p(1,:),p(2,:),'ro');hold on;
% knots = bs.knots;
% k = bs.order;
% fnplt(bs,[knots(k),knots(end-k+1)]);

[M,N] = size(pc);

if M~=2 && N~=2
    error('input must be 2d point cloud');
    return;
elseif M~=2 && N==2
    pc = pc';
    [M,N] = size(pin);
end

if length(varargin)==0
    s = 1.0;
else
    s = varargin{1};
end


% center of mass and the principal direction
pc_ori = mean(pc,2);
pc2 = pc - repmat(pc_ori, 1 , M*N/2);
[V, D] = eig(pc2 * pc2');

a = s*sqrt(D(1,1))/4;
b = s*sqrt(D(2,2))/4;
rho = atan(V(2,1)/V(1,1));

% points on the ellipse as the control points
theta = linspace(0, 2*pi-(2*pi-0)/num_cp, num_cp);
p_ellipse = [cos(rho),-sin(rho); sin(rho),cos(rho)] * ...
    [a*cos(theta);b*sin(theta)] + ...
    repmat(pc_ori, 1, num_cp);

bs = close_spline(p_ellipse);

end