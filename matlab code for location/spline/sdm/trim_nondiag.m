function M0 = trim_nondiag(M0)
%% TRIM_NONDIAG trims set the off-diagonal non-zero
% elements to zeros.

% Note:
% An example:
% M0 = [1 2 3 0 5;
%       5 1 2 3 0;
%       0 5 1 2 3;
%       3 0 5 1 2;
%       2 3 0 5 1]
% -> 
% M = [1 2 3 0 0;
%      5 1 2 3 0;
%      0 5 1 2 3;
%      0 0 5 1 2;
%      0 0 0 5 1];

% Note:
% Maybe it would be useful in the construction of the
% regularization terms in the fitting of the open b-spline curve.

[m,n] = size(M0);
for ii=1:m
    % forward
    f1 = false;
    for jj = (ii+1):n
        if M0(ii,jj)==0;
            f1 = true;
            break;
        end
    end
    if f1
        M0(ii,jj:end)=0;
    end
    % reverse
    f2 = false;
    for jj = (ii-1):-1:1
        if M0(ii,jj)==0;
            f2 = true;
            break;
        end
    end
    if f2
        M0(ii,1:jj)=0;
    end
end
