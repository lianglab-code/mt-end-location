level = 9;
N = 10000;
% N = 100;
R = 1000000; % rounding
M = 2.^(1:level)/2;

test_no = 10;
check = zeros(test_no,level);
true_max = zeros(test_no,level);

% test 1 correctness
for jj = 1:test_no
    sample = round(rand(level,N)*R); % rounding
    % sample = rand(level,N)*100; % no rounding
    for ii = 1:level
        [tmp2,tmp3]= nms_1d(sample,M(ii)); 
        tmp4 = nms_1d_naive(sample,M(ii));
        true_max(jj,ii) = sum(tmp4~=-inf);
        check(jj,ii) = sum(tmp2~=tmp4)/true_max(jj,ii);
        % subplot(3,3,ii);
        % plot(tmp);
        % hold on;
        % X2 = find(tmp2~=-inf);
        % Y2 = tmp2(X2);
        % plot(X2,Y2,'ro','markersize',16);
        % X4 = find(tmp4~=-inf);
        % Y4 = tmp4(X4);
        % plot(X4,Y4,'k*','markersize',16);
        % hold off;
    end
end
% check


% test 2 efficiency
% tic
% for jj = 1:1000
%     for ii = 1:level
%         [tmp2,tmp3]= nms_1d(tmp(jj,:),M(ii));
%     end
% end
% toc


% tic
% for jj = 1:1000
%     for ii = 1:level
%         tmp4 = nms_1d_naive(tmp(jj,:),M(ii));
%     end
% end
% toc

