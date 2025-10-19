function ind = triusub2ind(N,I,J)
%% TRIUSUB2IND converts I,J sub to column index
%
% Input:
% N: size of the square matrix
% I: row sub
% J: column sub
%
% Output:
% ind: index in the column index
% 
% The 1d reprensentation of upper-triangular matrix is column-major

ind = 0;

if I>J
    error('not triu subscripts');
    return ind;
end

ind = (J-1)*J/2 + I;
