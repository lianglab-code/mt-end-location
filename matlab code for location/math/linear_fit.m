function A = linear_fit(x, y)
%% LINEAR_FIT computes the linear coefficients using lsq
% Input: x, y
% Output: A

% algorithm: x*A = y; A = (x'*x)\(x'*y);
N = length(x);
x = reshape(x,N,1);
y = reshape(y,N,1);
xx = ones(numel(x),2);
xx(:,1) = x;
A = (xx'*xx)\(xx'*y);

end
