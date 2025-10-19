function [theta,x0,y0] = linear_fit_2(x, y)
%% LINEAR_FIT computes the linear coefficients using lsq
% Input: x, y
% Output: theta (atan(slope)), (x0,y0) on the fitted line

% algorithm: x*A = y; A = (x'*x)\(x'*y);
N = length(x);
x = reshape(x,N,1);
y = reshape(y,N,1);
xx = ones(numel(x),2);
xx(:,1) = x;
A = (xx'*xx)\(xx'*y);

if A(1)>1e4
    theta = pi/2;
    x0 = 0;
    y0 = A(2);
else
    theta = atan(A(1));
    x0 = mean(x);
    y0 = 0;
end

end
