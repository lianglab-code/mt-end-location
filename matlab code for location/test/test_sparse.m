% compare matrix multiplication with sparse and full matrices

len0 = 1000;
perf_f = zeros(1,10);
perf_s = zeros(1,10);
num_test = 15;

for ii = 1:num_test
    len = ii*len0;
    tic;
    sa = sprand(len,len,0.1);
    sn = sparse(diag(1:len));
    tmp1 = sa*sn;
    perf_s(ii) = toc;

    tic;
    fa = rand(len,len);
    fn = diag(1:len);
    tmp2 = fa*fn;
    perf_f(ii) = toc;
    
    clear 'sa' 'sn' 'fa' 'fn';
end

plot([1:num_test],perf_f,'ro-');hold on;
plot([1:num_test],perf_s,'k.-');
legend('full','sparse');

figure;
plot(perf_s./perf_f,'ro-');
hold on;
plot([0 num_test],[1 1],'k-','linewidth',4);
legend('sparse/full');

% results
% perf_f =
%     0.0799    0.1897    0.4436    0.8274    1.6232    2.2626    3.5616    4.0464    5.2852
%     8.3623    9.5466   14.1918   14.5924   21.2395   25.5265
    
% perf_s =
%     0.0761    0.2258    0.4549    0.7901    1.4813    1.9034    3.3453    4.3039    5.1424
%     6.4190    7.9288    9.4150   12.0975   13.0443   14.9593

% conclusion
% it seems sprase is better, only if the original problem is really sparse