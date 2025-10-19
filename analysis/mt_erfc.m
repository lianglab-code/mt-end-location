function I = mt_erfc(params, l)
% xdata: one dimension
% params:
    l0 = params(1);
    sigma = params(2);
    H = params(3); % amplitude
    b = params(4); % baseline
    I = H/2*erfc((l-l0)/(sqrt(2)*sigma))+b;
end
