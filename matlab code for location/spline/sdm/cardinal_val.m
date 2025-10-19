function [y,ys] = cardinal_val(j,k,x)
%% CARDINAL_VAL calculates the value of the cardinal spline basis
% at x, e.g., 
% y = 
% B_{j,k,Z}(x) = 
% sum_{r=0}^k { (-1)^{k-r} C(k,r) (r-x-j)^{k-1}_+ / (k-1)! } 

% INPUT:
% j: right translate unit
% k: order
% x: nx x 1

% OUTPUT:
% y: nx x 1
% ys: nx x (k+1)

% REFERENCE:
% A Practical Guide to Splines, de Boor, pp.89

% NOTE:
% Numerical stability is not a concern here, e.g., order k should
% be small, e.g., k<6; and the value of x should be small, e.g., 
% x<1000

% EXAMPLE:
% k = 4;
% j = 0;
% x = -1:0.001:5;
% [y,ys] = cardinal_val(j,k,x);
% ColorSet = varycolor(k+1);
% str = ['.' '*' '>' '+' '<' '^'];
% nstr = numel(str);
% figure;
% hold on;
% % axis equal;
% axis(1.05*[min(x) max(x) min(ys(:)) max(ys(:))]);
% plot(x,y,'ko-','markersize',6,'markerfacecolor','k');
% for ii = 1:k+1
%     plot(x,ys(:,ii),'marker',str(mod(ii,nstr)+1), ...
%         'color',ColorSet(ii,:));
% end

x = reshape(x,prod(size(x)),1);
nx = size(x,1);
y = zeros(nx,1);
ys = zeros(nx,k+1);
denorm_f = factorial(k-1);

% the binormial coefs
C = ones(k+1,1);
for ii = 1:k
    C(ii+1) = prod(((k-ii+1):k)./(1:ii));
end

for ii = 0:k
    if mod((k-ii),2) == 0
        a1 = C(ii+1);
    else
        a1 = -1*C(ii+1);
    end
    for jj = 1:nx
        a2 = ii-x(jj)-j;
        if a2 <= 0
            ys(jj,ii+1) = 0;
        else
            ys(jj,ii+1) = a1*a2^(k-1);
        end
    end
end

ys = ys/denorm_f;
y = sum(ys,2);
