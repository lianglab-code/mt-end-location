function [A,b] = calc_axb(bs,m,t,x,Yk)
%% CALC_AXB calculates the A and b for of the derivatives
% of the f(D). The form of f(D) is 
% f(D) = sigma{k}(e_k(D))
% e_k(D) = [ (P(tk)-Xk)' Yk ] ^2

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

% EXAMPLE:
% for TDM:
% Yk = Nk
% for SDM:
% There are two parts.
% Part I:
% Yk = Tk*dk/(dk-rhok)
% Part II:
% Yk = Nk
% then A = A1+A2, b = b1+b2.
% Solution of Ax=b is the displacement of the control points.

