function [a,b,c,r2] = linear_fit_3(x, y)
%% LINEAR_FIT_3 computes the linear coefficients using 
% generalized svd in homogeneous corordinate
% source:
% https://foto.aalto.fi/seura/julkaisut/pjf/pjf_e/2005/Inkila_2005_PJF.pdf

% Input: x, y
% Output: ax + by + c = 0
% a^2+b^2 = 1
% r2: squared residual sum, e.g., sum(residue^2)
% r2: correlation coefficient; e.g., 1 means perfect line
    
a = 0;
b = 0;
c = 0;
r2 = 0;

B = [ 1, 0, 0;
      0, 1, 0];

x = reshape(x,numel(x),1);
y = reshape(y,numel(x),1);
A = [x, y, ones(size(x))];

[U,V,X,C,S] = gsvd(A,B);
X_inv = inv(X);
% the eigenvalues are sorted
a = X_inv(1,1)/S(1,1);
b = X_inv(1,2)/S(1,1);
c = X_inv(1,3)/S(1,1);
r2 = (C(1,1)/S(1,1))^2;
r2 = 1 - r2/(sum(y.^2)-size(y,1)*mean(y)*mean(y));

end