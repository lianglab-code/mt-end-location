load 'misc/control_points.mat';
imgs = tif_img_reader(['/home/image/projects/collaborations/Dong/' ...
                    'g1-1.tif']);
img = imgs(:,:,125);
BW = bwmorph(img,'remove');
[I,J]=find(BW);
x = J;
y = I;
xx = x + 20*rand(size(x));
yy = y + 20*rand(size(y));
p = [xx';yy']; % 2*n

% initial b-spline generation
init_bs = gen_init_bs(p,20,0.2);

k = init_bs.order;
knots = init_bs.knots;
num_tk = 100;
t_start = knots(k);
t_end = knots(end-k+1);
coefs = init_bs.coefs;
t_seq = linspace(t_start, t_end, num_tk);
bs_val = fnval(init_bs, t_seq);
bs_1_der = fnder(init_bs);
bs_1_der_val = fnval(bs_1_der, t_seq);
bs_2_der = fnder(bs_1_der);
bs_2_der_val = fnval(bs_2_der, t_seq);
l = sqrt(bs_1_der_val(1,:).^2+bs_1_der_val(2,:).^2);

% plot the shape
plot(bs_val(1,:),bs_val(2,:),'ro-'); axis equal; hold on;
% plot the control points
% plot(coefs(1,1),coefs(2,1),'go-','MarkerSize',18, ...
%      'MarkerFaceColor','r');
% plot(coefs(1,:),coefs(2,:),'m.-','MarkerSize',24, ...
%      'LineWidth',3);

% plot the tangents
quiver(bs_val(1,:),bs_val(2,:), ...
       bs_1_der_val(1,:),bs_1_der_val(2,:));

% signed curvature: 
% k = (x'y''-y'x'')/sqrt(x'^2+y'^2)^3
% normal vec = [0 -1; 1 0] * tangent vec
curvature = ( bs_1_der_val(1,:).*bs_2_der_val(2,:) - ...
              bs_1_der_val(2,:).*bs_2_der_val(1,:) ) ./ ...
    l.^3;
radius = 1./curvature;
normal = [0 -1; 1 0] * bs_1_der_val;
normal(1,:) = normal(1,:)./l;
normal(2,:) = normal(2,:)./l;

% plot the osculating circle center
% quiver(bs_val(1,:),bs_val(2,:), ...
%        normal(1,:).*radius,normal(2,:).*radius, 0);
circ_ori = bs_val;
circ_ori(1,:) = circ_ori(1,:) + normal(1,:).*radius;
circ_ori(2,:) = circ_ori(2,:) + normal(2,:).*radius;

% plot the evolute circle
% viscircles(circ_ori.',radius.');
% plot(circ_ori(1,:),circ_ori(2,:),'ko');

% [grids, p_grids, Imax, Jmax] = gen_coarse_grid(pc, size(BW,2), ...
%                                                size(BW,1),40);
