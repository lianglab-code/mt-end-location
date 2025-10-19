function [x_e, z_e] = simple_kalman(z, A, H, R, Q)
%% SIMPLE_KALMAN is my implementation of kalman filter

% Input:
% z: observation
% Output:
% x_e: estimated state
% z_e: filtered observation

% Assumption:
% 1. no control input
% 2. gaussian state noise
% 3. gaussian measurement noise
% 4. state noise and measurement noise are independent

% motion model:
% x_k+1 = A * x_k + w
% w ~ N(0,R)
% measurement model:
% z_k = H * x_k + v
% v ~ N(0,Q)

% dimensions:
% x: n*1
% A: n*n
% w: n*1
% z: m*1
% H: m*n
% v: m*1

[m, num_meas] = size(z); % n samples, m dimensions
[m, n] = size(H);

x_e = zeros(n, num_meas);
z_e = zeros(m, num_meas);

% 2-D motion model
% x = [ x0; x0dot; y0; y0dot];
% z = [ x0_m; y0_m];
% A = [ 1, dt, 0, 0;
%     0, 1, 0, 0;
%     0, 0, 1, dt;
%     0, 0, 0, 1 ];
% H = [1, 0, 0, 0;
%      0, 0, 1, 0];

% Problem: how to estimate R and Q?

% init
% x_e(:,1) = H*z(:,1);
x_e(:,1) = zeros(n,1);
w = zeros(n,1);
v = zeros(m,1);
P = eye(n); % covar mat of w

x_p = zeros(n,1); % predicted x

for ii = 2:num_meas
    % prediction stage
    x_p = A * x_e(:,ii-1);
    P = A * P * A' + R;
    % update stage
    K = P * H' * inv(H*P*H'+Q);
    x_e(:,ii) = x_p + K * (z(:,ii) - H*x_p);
    P = P - K*H*P;
end

z_e = H*x_e;

end