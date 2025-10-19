function [lo, params] = fit_erfc(li)
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

    % fitting begin
    [mmax, mmin, mmid, Imax, Imin, Imid] = p_find(li);

    % check if the curve shape looks like erfc
    if(~((Imid>Imax) && (Imid<Imin)))
        error('curve does not look like erfc func');
    end
    % extend beyond the max & min value for fitting
    % ext_n = round(ln/10); 
    % ext_n = 10; 
    ext_n = 0; 
    Is = 1; % start index
    if ((Imax-ext_n) > 0)
        Is = Imax-ext_n;
    end
    Ie = ln;
    if ((Imin+ext_n) < ln)
        Ie = Imin+ext_n;
    end
    % special treatment
    Ie = Ie - 2;
    ydata = li(Is:Ie);
    xdata = 1:length(ydata);
    xdata = reshape(xdata, size(ydata));
    param_in = [Imid-Is+1, ...
                (Imin-Imax+1)/(2*sqrt(2)), ...
                mmax-mmin, ...
                mmin];

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
    params(1) = params(1)+Is-1;
    params(5) = b;
    params(6) = c;
    % fitting end
    
    % normalization
    lo = (lo-a(4))/a(3);
    
    function [mmax, mmin, mmid, Imax, Imin, Imid] = p_find(profile)
        [mmax, Imax] = max(profile);
        [mmin, Imin] = min(profile);
        mmid = (mmax+mmin)/2;
        profile2 = profile(Imax:Imin);
        [~, Imid] = min((profile2-mmid).^2);
        Imid = Imid+Imax-1;
    end

end