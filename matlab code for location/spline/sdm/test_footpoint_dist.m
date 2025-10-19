function status = test_footpoint_dist(sp,t)
%% TEST_FOOTPOINT_DIST tests the distribution of the footpoints

% INPUT:
% sp: b-spline
% t: footpoint

% OUTPUT:
% status: bool, ok/not ok

% NOTE:
% Chi-Squared test for uniform distribution is used
% The range is knots[k] .. knots[end-k+1]

num_t = length(t);
num_bin = 10;

knots = sp.knots;
k = sp.order;

f = zeros(1,10); % frequency
bins = linspace(knots(k),knots(end-k+1),num_bin+1);

for ii = 2:(num_bin+1)
    f(ii-1) = sum(t<=bins(ii));
end

df = diff(f);
f(2:end) = df;
f = f/num_t;
exp_f = 1/num_bin;
chi2 = num_t/exp_f*sum((f-exp_f).^2); % chi-squared
degree = num_bin-1; % degree
