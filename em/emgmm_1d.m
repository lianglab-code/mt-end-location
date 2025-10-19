function [w, mu, sigma, z, flag] = emgmm_1d(y, w0, mu0, sigma0, n, eps)
%% EMGMM_1D estimates the parameters of gaussian mixture model.

% Input:
% y: the observed data
% w0: guess of weights of each gaussian mixture
% mu0: guess of means
% sigma0: guess of sigmas
% n: the number of gaussian mixtures
% eps: convergent criteria

% Output:
% w: estimation of weights
% mu: estimation of means
% sigma: estimation of sigma
% z: label for each observed data
% flag: status of the algorithm

w = zeros(n,1);
mu = zeros(n,1);
sigma = zeros(n,1);
z = zeros(n,1);



end