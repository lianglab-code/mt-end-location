function ind = trilsub2ind(N,I,J)
%% TRILSUB2IND converts I,J sub to column index
%
% Input:
% N: size of the square matrix
% I: row sub
% J: column sub
%
% Output:
% ind: index in the column index
% 
% The 1d reprensentation of lower-triangular matrix is column-major

ind = 0;

if I<J
    error('not tril subscripts');
    return ind;
end

ind = (N+(N-(J-2)))*(J-1)/2 + (I-J) + 1;
