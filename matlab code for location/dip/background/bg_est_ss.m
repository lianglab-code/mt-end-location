function [bg,w,p] = bg_est_ss(x,y,n)
%% BG_EST_SS estimates the background with the method proposed by
% S. Steenstrup (1981).
% [bg,w,p] = bg_est_ss(x,y,n)

% INPUT:
% x: x, 1xN
% y: y, 1xN
% n: degree of the polynomial

% OUTPUT:
% bg: the estimated background, 1xN
% w: weight, 1xN
% p: polynomials, (n+1)xN

% ASSUMPTION:
% y > 0;
% abiscissa are uniformly distributed;

% TODO:
% 1. constrained least squares fitting

max_degree = 5;
max_iter = 30;
iter = 0;
% delta = 1e-3; % https://en.wikipedia.org/wiki/Iteratively_reweighted_least_squares

if n>max_degree
    error('max degree of the polynomial is 5');
    return;
end

N = numel(x);
bg = nan(1,N);

x = reshape(x,[1 N]);
y = reshape(y,[1 N]);
dx = diff(x);
dx2 = diff(dx);
if sum(dx2)>100*eps
    error('abiscissa must be uniformly distributed');
    return;
end
dx = dx(1);

% to avoid n/0
if sum(y==0)>0
    y = y + eps;
end

% w = 1./y; % weight
w = ones(1,N); % weight
c = zeros(1,n+1);
c_old = c;
f = N-n; % degree of freedom

while(iter<max_iter)
    p = zeros(n+1,N);
    a = zeros(1,n+1);
    b = zeros(1,n+1);
    ga = zeros(1,n+1); % gamma
    
    p_1 = zeros(1,N);
    p(1,:) = ones(1,N);
    ga(1) = sum(w.*p(1,:).*p(1,:))*dx;
    a(1) = sum(w.*x.*p(1,:).*p(1,:))*dx/ga(1);
    b(1) = 0;
    c(1) = sum(w.*y.*p(1,:))*dx/ga(1);
    
    p(2,:) = (x-a(1)).*p(1,:) - b(1)*p_1;
    ga(2) = sum(w.*p(2,:).*p(2,:))*dx;
    a(2) = sum(w.*x.*p(2,:).*p(2,:))*dx/ga(2);
    b(2) = sum(w.*p(2,:).*p(2,:))*dx/ga(1);
    % b(2) = sum(w.*x.*p(1,:).*p(2,:))/ga(1);
    c(2) = sum(w.*y.*p(2,:))*dx/ga(2);
    
    for j = 3:(n+1)
        p(j,:) = (x-a(j-1)).*p(j-1,:)-b(j-1)*p(j-2,:);
        ga(j) = sum(w.*p(j,:).*p(j,:))*dx;
        a(j) = sum(w.*x.*p(j,:).*p(j,:))*dx/ga(j);
        b(j) = sum(w.*p(j,:).*p(j,:))*dx/ga(j-1);
        % b(j) = sum(w.*x.*p(j-1,:).*p(j,:))/ga(j-1);
        c(j) = sum(w.*y.*p(j,:))*dx/ga(j);
    end
    
    z = c*p; % estimated y
    errs = w.*(y-z).^2; % erros
    err = sum(errs); % error
    
    sigma = sqrt(err./(f*ga));
    
    % m = 0;

    % weight 1
    % normal weight changes with signal intensity
    ind = y>(z+2*sqrt(z));
    w(ind) = 1./(y(ind)-z(ind)).^2;
    w(~ind) = 1./z(~ind);
    
    bg = z;
    
    if sum((abs(c_old-c)<sigma+100*eps))==(n+1)
        break;
    end
    
    c_old = c;
    iter = iter+1;
    
end
