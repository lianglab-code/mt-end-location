% source:
% https://stackoverflow.com/questions/25996184/releasing-cuda-memory-matlab

d = gpuDevice;

N = 2e4;
A = gpuArray.rand(N); % the same as A = rand(N,'gpuArray');
freeMem = NaN(1, 11);
freeMem(1) = d.FreeMemory;
for idx = 2:11
    A = A * 2;
    wait(d);
    freeMem(idx) = d.FreeMemory;
end
plot(1:11, freeMem / 1e9, 'b-', ...
     [1 11], [d.TotalMemory, d.TotalMemory]/1e9, 'r-');
legend({'Free Memory', 'Total Memory'});
xlabel('Iteration');
ylabel('Memory (GB)');

% TotalMemory: 1.7069e10
% freeMem(1): 1.0176e10
% freeMem(end): 6.9762e9
% clear 'A', d.FreeMemory: 1.3329e10
% reset(d), d.Freememory: 1.3329e10
%
% conclusion:
% after using 'clear' to clear gpu var, matlab seems to
% release the gpu memory