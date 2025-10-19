function [a,b,r] = linear_fit_weighted(x, y, sigma)
%% LINEAR_FIT_WEIGHTED computes the linear coefficients using lsq
% Input: x, y, sigma
% Output: b,a,r, y = a + b*x
%
% Note: Numerical Recipes 3rd, p781

    sigma2 = sigma.^2;
    S = sum(1./sigma2);
    Sx = sum(x./sigma2);
    Sy = sum(y./sigma2);
    Sxx = sum((x.*x)./sigma2);
    Syy = sum((y.*y)./sigma2);
    Sxy = sum((x.*y)./sigma2);
    Delta = S*Sxx-Sx*Sx;
    a = (Sxx*Sy-Sx*Sxy)/Delta;
    b = (S*Sxy-Sx*Sy)/Delta;

    % 3. Pearson correlation coefficient
    r = Sxy/(sqrt(Sxx)*sqrt(Syy));

end
