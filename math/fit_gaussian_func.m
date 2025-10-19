function param = fit_gaussian_func(x,y,varargin)
%% FIT_GAUSSIAN_FUNC fits the gaussian function.
%
% INPUT:
% x: x, 1-d
% y: y, 1-d
% iter: iteration number
%
% OUTPUT:
% param: mu, sigma, A, b
%
% NOTE:
% y = b + A * exp((x-mu)^2/(2*sigma^2))
% ln(y-b) = u + v*x + w*x^2
% u = ln(A)-mu^2/(2*sigma^2)
% v = mu/(sigma^2)
% w = -1/(2*sigma^2)
%
% NOTE2:
% This estimator has not been analyzed from statistical point of
% view, e.g., no analysis about the unbiasedness, consistency and
% efficiency has beed done.
%
% REF:
% Guo: "A simple algorithm for fitting a gaussian function"

if nargin>2
    iter = varargin{1};
else
    iter = 10;
end

RATIO1 = 0.2; % use y<y*RATIO1 as baseline value

ymin = min(y);
ymax = max(y);

b = mean((ymax-ymin)*RATIO1+ymin);
y = y-b;
ind = y>0;
y = y(ind);
x = x(ind);
n = numel(ind);

esty = y; % y2: estimated y
esty2 = esty.*esty;
lny = log(y);

% iter = 1;
for ii = 1:iter

    x1y2 = x.*esty2; % xy2
    x2y2 = x1y2.*x; % x2y2
    x3y2 = x2y2.*x; % x3y2
    x4y2 = x3y2.*x; % x4y2

    A11 = sum(esty2);
    A12 = sum(x1y2);
    A13 = sum(x2y2);
    A21 = A12;
    A22 = A13;
    A23 = sum(x3y2);
    A31 = A22;
    A32 = A23;
    A33 = sum(x4y2);

    b1 = sum(esty2.*lny);
    b2 = sum(x1y2.*lny);
    b3 = sum(x2y2.*lny);

    % AX = B; X = [u;v;w]
    A = [A11, A12, A13;...
         A21, A22, A23;...
         A31, A32, A33];
    B = [b1;b2;b3];
    X = A\B;

    mu = -X(2)/(2*X(3));
    sigma = sqrt(-1/(2*X(3)));
    A = exp(X(1)-X(2)*X(2)/(4*X(3)));
    
    % esty = y; % y2: estimated y
    esty = A*exp(-(x-mu).^2/(2*sigma^2));
    esty2 = esty.*esty;
end

param = [mu; sigma; A; b];
