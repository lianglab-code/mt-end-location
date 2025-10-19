function f = fract(n)
%% FRACT returns a continued fraction

% INPUT:
% n: level

% OUTPUT:
% f: a symbolic fraction

% REFERENCE:
% Rovenski, Modeling of curves and surfaces with MATLAB, p6

syms a;
if n>0
    f = a+1/fract(n-1);
else
    f = a;
end
