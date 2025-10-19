function x = filter_hp(y,lambda,varargin)
%% FILTER_HP implements the Hodrick-Prescott filter
% x = filter_hp(y,lambda,d)

% INPUT:
% y: observation
% lambda: regularization term
% d: degree of difference

% OUTPUT:
% x: the estimated y

% REF:
% Kim, Koh, Boyd and Gorinevsky: l1 trend filtering.

% NOTE:
% there is a built-in function in the economy toolbox:
% hpfilter

d = 2;
if nargin>2
    d = varargin{1};
end

n = numel(y);

y = reshape(y,[n 1]);

c = zeros(n-d,1);
r = zeros(1,n);
c(1) = 1;

% d = 2
r(1) = 1;
r(2) = -2;
r(3) = 1;
if d>2
    r_old = r;
    for ii = 3:d
        for jj = 2:(1+d)
            r(jj) = r_old(jj)-r_old(jj-1);
        end
        r_old = r;
    end
end

D = toeplitz(c,r);
x = (eye(n,n)+2*lambda*D'*D)\y; % fantastic



