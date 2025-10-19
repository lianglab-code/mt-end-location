k = 10^3;
nseg = 10^3;
in2 = rand(k,nseg);
g = zeros(size(in2));
h = zeros(size(in2));
g(1,:) = in2(1,:);
h(k,:) = in2(k,:);

% 1
disp('1');
tic
for ii = 2:k
    g(ii,:) = bsxfun(@min,g(ii-1,:),in2(ii,:));
    h(k-ii+1,:) = bsxfun(@min,h(k-ii+2,:),in2(k-ii+1,:));
end
toc
g1 = g;
h1 = h;

% 2
disp('2');
tic
for ii = 2:k
    for jj = 1:nseg
        g(ii,jj) = min(g(ii-1,jj),in2(ii,jj));
        h(k-ii+1,jj) = min(h(k-ii+2,jj),in2(k-ii+1,jj));
    end
end
toc
g2 = g;
h2 = h;

% 3
disp('3');
tic
for jj = 1:nseg
    for ii = 2:k
        g(ii,jj) = min(g(ii-1,jj),in2(ii,jj));
        h(k-ii+1,jj) = min(h(k-ii+2,jj),in2(k-ii+1,jj));
    end
end
toc
g3 = g;
h3 = h;

% CONCLUSION
% g1 == g2 == g3
% h1 == h2 == h3

% for k = 10000; nseg = 10000;
% 1: 11.37s
% 2: 24.26s
% 3: 14.22s

% total element = 1e7

% for k = 1; nseg = 1e7;
% 1: 5e-6s
% 2: 2e-6s
% 3: 0.31s

% for k = 10; nseg = 1e6;
% 1: 0.98s
% 2: 1.42s
% 3: 1.41s

% for k = 100; nseg = 1e5;
% 1: 0.82s
% 2: 3.19s
% 3: 1.45s

% for k = 1000; nseg = 10000;
% 1: 0.86s
% 2: 1.98s
% 3: 1.42s

% for k = 2000; nseg = 5000;
% 1: 0.97s
% 2: 2.23s
% 3: 1.52s

% for k = 5000; nseg = 2000;
% 1: 1.19s
% 2: 2.31s
% 3: 1.42s

% for k = 10000; nseg = 1000;
% 1: 1.50s
% 2: 2.26s
% 3: 1.43s

% for k = 20000; nseg = 500;
% 1: 1.59s
% 2: 2.15s
% 3: 1.43s

% for k = 100000; nseg = 100;
% 1: 1.83s
% 2: 1.70s
% 3: 1.45s

% for k = 1000000; nseg = 10;
% 1: 13.34s
% 2: 1.72s
% 3: 1.50s

% for k = 1e7; nseg = 1;
% 1: 127.1s
% 2: 1.80s
% 3: 1.43s

