function [I,J] = ind2trilsub(N,ind)
%% IND2TRILSUB converts tril column index to sub
%
% Input:
% N: size of the square matrix
% ind: index in the column index
%
% Output:
% I: row sub
% J: column sub
% 
% The 1d reprensentation of lower-triangular matrix is column-major

I = 0;
J = 0;

if ind > N*(N+1)/2
    error('index out of boundary');
    return;
end

% J1 = (2*N+1)/2 - sqrt( ((2*N+1)/2)^2 - 2*ind );
% J2 = (2*N+3)/2 - sqrt( ((2*N+3)/2)^2 - (2*N+2*ind+2) );

tmp = ( (2*N+1) - sqrt((2*N+1)^2-8*ind) )/2;
J1 = tmp;
J2 = tmp+1;

if floor(J2) == J2
    J2 = J2-1;
else
    J2 = floor(J2);
end

J1 = ceil(J1);

if J1 ~= J2
    error('something is terribly wrong');
    return;
end

J = J1;
I = ind - 1 - (N+(N-(J-2)))*(J-1)/2 + J;
