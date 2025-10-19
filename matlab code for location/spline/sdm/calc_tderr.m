function [A,b] = calc_tderr(bs,m,t,x,Nk)
%% CALC_TDERR calculates the A and b for part I of the derivatives
% of the f(D).

% INPUT:
% bs: b-spline
% m: number of coefficients
% t: foot points, 1 x n
% x: sample points, 2 x n
% Nk: normal 2 x n

% OUTPUT:
% A: (2*m) x (2*m)
% b: (2*m) x 1
% Az = b, z = (D1x, D2x, ..., Dmx,D1y, ..., Dmy)'

% NOTE:
% f(D) = sigma(e_k(D))
% e_k(D) = [ (P(tk)-Xk)' Nk ] ^2

