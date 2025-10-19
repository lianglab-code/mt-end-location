function [sp, pp] = construct_cardinal_spline(k,varargin)
%% CONSTRUCT_CARDINAL_SPLINE constructs a cardinal b-spline basis
% by using matlab's spmak functionality

% INPUT:
% k: order
% translate: translate of the cardinal b-spline

% OUTPUT:
% sp: cardinal b-spline basis
% pp: sp in PP-form

translate = 0;

if nargin>1
    translate = varargin{1};
end

knots = (0:k)+translate;
coefs = 1;
sp = spmak(knots,coefs);
pp = fn2fm(sp,'pp');
