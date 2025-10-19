function idx = find_first_outlier(y0, varargin)
%% FIND_FIRST_OUTLIER finds the first outlier forwardly or
% backwardly. Of course, the method is not robust.

% Input:
% y0: the input series
% varargin{1}: string for direction, 'forward' OR 'backward'
% varargin{2}: the initial number of point used for fitting

% Output:
% idx: the index of the first outlier, 1-based

direction = 'forward';
np = 10;
Nsigma = 3;

if nargin>1
    direction = varargin{1};
    if nargin>2
        np = varargin{2};
    end
end

if (strcmp(direction,'backward'))
    y0 = y0(end:-1:1);
elseif ~strcmp(direction,'forward')
    error('forward or backward');
end

N = length(y0);
x0 = 1:N;
y0 = reshape(y0, 1, N);
idx = np;
A = linear_fit(x0(1:idx),y0(1:idx));
% sd = sqrt(sum((A(1)*x0(1:idx)+A(2)-y0(1:idx)).^2)/(idx-1));
sd = median(abs(A(1)*x0(1:idx)+A(2)-y0(1:idx)));

for idx = (np+1):N
    res = abs(A(1)*x0(idx)+A(2)-y0(idx));
    if res>(sd*Nsigma)
        break;
    else
        A = linear_fit(x0(1:idx),y0(1:idx));
        %        sd =
        %        sqrt(sum((A(1)*x0(1:idx)+A(2)-y0(1:idx)).^2)/(idx-1));
        sd = median(abs(A(1)*x0(1:idx)+A(2)-y0(1:idx)));
    end
end

if (strcmp(direction,'backward'))
    idx = N-idx+1;
end

end