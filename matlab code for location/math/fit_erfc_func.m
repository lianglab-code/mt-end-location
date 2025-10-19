function [param,resnorm] = fit_erfc_func(x,y,varargin)
%% FIT_ERFC_FUNC fits the erfc function.
%
% INPUT:
% x: x, 1-d
% y: y, 1-d
% param0: [mu0, sigma0, A0, b0], optional
%
% OUTPUT:
% param: [mu, sigma, A, b]
%
% NOTE:
% y = b+ A*erfc( (x-mu)/sigma )
%
% ERF(x;s) = 2/(s*sqrt(2*pi)) * int_0^x( exp(-t^2/(2*s^2)) ) dt
% erf(x) = 1/sqrt(pi) * int_0^x( exp(-t^2) ) dt // matlab definition
% erf(x/(s*sqrt(2))) === ERF(x;s) 
%

% % TEST
%     b = 3;
%     A = 2;
%     n = 0.2;
%     mu = 3;
%     sigma = 3;
%     x = -20:20;
%     y = b+A*erfc((x-mu)/sigma) + n*randn(1,numel(x));

    x = x(:)';
    y = y(:)';
    RANGE = 0.1; % outlier range
    FILTER_WINDOW = 3; % smoothing data, half size
    FILTER_SIGMA = 1; % smoothing data
    OPTIONS = optimoptions('lsqcurvefit', ...
                           'Algorithm', 'levenberg-marquardt', ...
                           'Display','off');


    mu0 = 0;
    sigma0 = 0;
    b0 = 0;
    A0 = 0;

    myfun = @(x,xdata) ...
            x(3) + x(4)*erfc( (xdata-x(1))/(x(2)*sqrt(2)) );
    if nargin<3 % no initial guess
        np = numel(x);
        wx = -FILTER_WINDOW : FILTER_WINDOW;
        wy = exp(-wx.^2/(2*FILTER_SIGMA^2));
        wy = wy/(sum(wy));
        tmp = conv([ones(1,FILTER_WINDOW)*y(1),...
                    y,...
                    ones(1,FILTER_WINDOW)*y(end)],...
                   wy,'same');
        y_smooth = tmp( (FILTER_WINDOW+1) : ...
                        (numel(tmp)-FILTER_WINDOW) );
        % y_smooth = filter(wy,1,y);

        [y_sorted,inds] = sort(y_smooth,'ascend');
        tmp = round(np*RANGE);
        if tmp<1, tmp = 1; end
        b0 = y_sorted(tmp);
        b1 = y_sorted(round(np*(1-RANGE)));
        A0 = b1 - b0;
        [~,mu0_ind] = min( abs(y_sorted-(b1+b0)/2) );
        mu0 = x(inds(mu0_ind));
        %
        y_diff = abs(diff(y_sorted));
        tmp = y_diff(y_diff>mean(y_diff));
        ind1 = find(tmp,1,'first');
        ind2 = find(tmp,1,'last');
        sigma0 = abs((x(inds(ind1)) - x(inds(ind2)))/2);
        param0 = [mu0,sigma0,b0,A0];
    else
        param0 = varargin{1};
    end
    
    [param,resnorm] = lsqcurvefit(myfun,param0,x,y,...
                                  [],[],OPTIONS);

end
