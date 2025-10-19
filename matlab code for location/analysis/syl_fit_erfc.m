function [lo, params] = syl_fit_erfc(li)
%% FIT_ERFC fits the input data with erfc model.
% Input:
% li: line input

% Output:
% lo: line output, normalized
% params: params for erfc,
% params: 1x6 vector:
% center, sigma, amplitude
% baseline, residue, exitflag

ln = numel(li);
lo = li;
params = zeros(1,6);

% fitting options
OPTIONS = optimoptions('lsqcurvefit', ...
    'Algorithm', 'levenberg-marquardt', ...
    'Display','off');


ydata = li(:,2);
xdata = li(:,1);

param_in = [0, ...
    1, ...
    1, ...
    0];

% optimization
[a, b, ~, c, ~] = ...
    lsqcurvefit(@mt_erfc, ...
    param_in, ...
    xdata, ...
    ydata, ...
    [], ...
    [], ...
    OPTIONS);

params(1:4) = a;
params(5) = b;
params(6) = c;
% fitting end

lo(:,2) = mt_erfc(a,lo(:,1));

end