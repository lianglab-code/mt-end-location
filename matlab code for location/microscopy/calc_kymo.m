function [x,t,sigma] = calc_kymo(kymoimg)
%% CALC_KYMO calculates the end points of the kymograph
%    [x,t] = calc_kymo(kymoimg)
%
%    INPUT:
%    kymoimg: the kymograph, the left part is brighter
%
%    OUTPUT:
%    x: the end point at each frame
%    t: frame number
%
%    EXAMPLE:
%    [xx,tt,ss] = calc_kymo(kymoimg);
%    [y2,status] = l1tf(xx,10); % regularization of 10

% params
    gauss_sigma = 1; % gaussian filter sigma
    sz_pad = 2; % padding size
    n_gmm = 2; % mixture of 2 gaussians
    n_border = 10; % skip border
    sigma0 = 3; % initial sigma

    [imgh,imgw] = size(kymoimg);

    img1 = padarray(kymoimg,[sz_pad,sz_pad],'replicate');
    img2 = filter_gauss_2d(img1,gauss_sigma);
    gmm = gmdistribution.fit(img2(:),n_gmm,'Regularize',0.001);
    clusterX = cluster(gmm,img2(:));
    [imgmax,imgI] = max(gmm.mu);
    clusterY = (clusterX==imgI);
    img3 = reshape(clusterY,size(img2));
    img4 = img3((sz_pad+1):(end-sz_pad),(sz_pad+1):(end-sz_pad));
    img5 = 1-img4;

    xy = zeros(2,imgh);
    for ii = 1:imgh
        xy(2,ii) = ii;
        xy(1,ii) = 0;
        imgx = find(img5(ii,:),1);
        if(~isempty(imgx))
            xy(1,ii) = imgx;
        end
    end

    t = (1:imgh)';
    x = zeros(imgh,1);
    sigma = nan(imgh,1);
    tmpt = 1:(2*n_border+1);
    OPTIONS = optimoptions('lsqcurvefit', ...
                           'Algorithm', 'trust-region-reflective', ...
                           'Display','off');
    
    for ii = 1:imgh
        imgx = find(img5(ii,:),1);
        if(~isempty(imgx))
            x(ii) = imgx;
            if(imgx>n_border && imgx<=(imgw-n_border))
                tmpy = kymoimg(ii,(imgx-n_border):(imgx+n_border));
                [mmax,Imax] = max(tmpy);
                [mmin,Imin] = min(tmpy);
                p0 = [n_border+1, sigma0, mmax-mmin, mmin];
                lb = [1, 0, 0.5*(mmax-mmin), 0.5*mmin];
                ub = [2*n_border+1, 2*n_border+1, ...
                      (mmax-mmin), ...
                      (mmax+mmin)/2];
                [a,b,~,c,~] = lsqcurvefit(@mt_erfc,p0,tmpt,tmpy,lb, ...
                                          ub,OPTIONS);
                if(c>-1)
                    x(ii) = imgx+a(1)-(n_border+1);
                end
            end
        end
    end

    function I = mt_erfc(params, l)
    % xdata: one dimension
    % params:
        l0 = params(1);
        sigma = params(2);
        H = params(3); % amplitude
        b = params(4); % baseline
        I = H/2*erfc((l-l0)/(sqrt(2)*sigma))+b;
    end

end
