function test_fit_gaussian_func
% test param
    N = 1000;
    M = 6; % span: 6 sigma

    debug_flag = [true; ...
                  false; ...
                  false; ...
                  false; ...
                  false];
    
    % parameter 0
    % mu, sigma, A, b, noise_level, span_lo, span_hi
    param0 = [0,3,1,0,0.1,-6*3,6*3; ... % test normal
              0,3,1,0,0.1,-3*3,3*3; ... % truncated mile
              0,3,1,0,0.1,-1*3,1*3; ... % truncated severe
              0,3,1,0,0.1,-3,5*3; ...
              0,3,1,0,0.1,-6*3,6*3];


    for ii = 1:numel(debug_flag)
        if debug_flag(ii)
            % test 1 normal condition
            p0 = param0(ii,:);
            x = linspace(p0(6),p0(7),N);
            x = x';
            y = p0(4) + p0(3)*exp(-(x-p0(1)).^2/(2*p0(2)^2));
            noisy_y = y + randn(size(y))*p0(3)*p0(5);
            if ii==4
                noisy_y(1) = -3;
            end

            % test
            % p = fit_gaussian_func(x,noisy_y,20)
            p = fit_gaussian_func_auto(x,noisy_y);
            y2 = p(4) + p(3)*exp(-(x-p(1)).^2/(2*p(2)^2));
            plot_test_fit();
        end
    end

    % conclusion
    % normal test: ok
    % mild truncated test: ok
    % severe truncated test: not ok
    % shifted test: ok
    % robust test: not ok

    function plot_test_fit
        figure;hold on;
        plot(x,y,'r-');
        plot(x,noisy_y,'ko');
        plot(x,y2,'b--');

        figure;hold on;
        plot(x,noisy_y-y,'ro');
        plot(x,noisy_y-y2,'k.');

        figure;
        plot(x,abs(y-y2),'r.-');
    end

end
