function B = diag_times(A,d)
%% DIAG_TIMES calculates the matrix product B = A'*D*A
% by using bsxfun without creating a large/sparse diagonal
% matrix D (e.g., suppose that m>>n). 

% INPUT:
% A: m x n matrix
% d: 1 x m vector

% OUTPUT:
% B: n x n matrix, A' * diag(d) * A

% REFERENCE:
% https://cn.mathworks.com/matlabcentral/answers/87629-efficiently-multiplying-diagonal-and-general-matrices

d = reshape(d,1,prod(size(d)));
B = bsxfun(@times,A',d)*A;