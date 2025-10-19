function bs = sdm(ps,bs_init)

% ps: 2 x np
% bs_init: initial b-spline

% load 'test.mat';
% ps = [x';y'];
% bs_init = sp;

% Closed spline case
% No regularization parts
% The number of control points should not be too much, otherwise
% the optimization would be too immense

iter_max = 100;
tol = 1e-2;
bs = bs_init;

% number of sample points
np = size(ps,2);
dim = size(ps,1);
% spline info
k = bs.order;
coefs = bs.coefs;
knots = bs.knots;
% closed spline, k-1 overlapped points
% there are 2*nc params to be optimized, for 2d case
nc = size(coefs,2)-k+1;
d_coefs = zeros(2,nc); % displacement of control points

%% step 1: generate the initial spline -> done
% gen_init_bs.m

% debug start
figure;
hold on;
axis equal;
dbg_l1 = plot(ps(1,:),ps(2,:),'ko','Markersize',4,...
          'MarkerFaceColor','k');
dbg_plotx = linspace(knots(k),knots(end-k+1),500);
dgb_ploty1 = fnval(bs,dbg_plotx); % initial points
dgb_ploty2 = dgb_ploty1; % optimized points
dgb_ly1 = plot(dbg_ploty1(1,:),dbg_ploty1(2,:),'b--','linewidth',4);
dgb_ly2 = plot(dbg_ploty2(1,:),dbg_ploty2(2,:),'r-','linewidth',4);
% debug end

%% step 2: 
curr_tol = 1;
for iter = 1:iter_max
    if curr_tol < tol
        break;
    end
    
    % step 2.1 calculate the foot points
    % misc/dist_points_sp_brute.m
    [d,t] = dist_points_sp_brute(ps,bs);
    
    % step 2.2 calculate the values, tangents, norms and curvatures
    % at foot points
    cps = fnval(bs,t); % points on curve
    [ct,cn,csc] = calc_sp_tnc(bs,t);
    cr = 1./abs(csc); % curvature radius
    
    % step 2.3 classify the sample points
    dps = ps-cps; % displacement from ps to cps
    dps_sign = sum(dps.*cn,1);
    flag_sd = sign(dps_sign.*csc); % d<0 in the original paper, use
                                   % error_sd
    flag_sd = (flag_sd==-1);
    flag_td = not(flag_sd); % d>0 in the original paper, use
                            % error_td
    TBD 
end 