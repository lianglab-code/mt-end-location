function R = construct_cardinal_matrix_1st(k,m,varargin)
%% CONSTRUCT_CARDINAL_MATRIX_1ST constructs the R1 matrix for
% regularizing the b-spline.

% The regularization term is \int_{P}{||P'||_2^2}dt, where P is the
% curve. The curve is represented by b-spline. The derivatives of
% this term with respect to the control points require the matrix R
% returned by this subroutine.

% The matrix R_{ij} = \int{Q_{j,k-1}*(Q_{i,k-1}-Q_{i+1,k-1})}dt
% where i=1:m, j=1:(m+1), Q_{j,k-1} = Q_{((j-1) mod m) +1,k-1} 
% or Q_{j,k-1} = 0 if j>m.

% INPUT:
% k: order of the original b-spline
% m: number of segments
% is_closed: true, default

% OUTPUT:
% R: m x m+1

% NOTE:
% i and j start from 1. 
% For order k b-spline, the span of Q_1 is [0 k], five breaks, four
% intervals.
% Given i, the span of j is i-k+2 <= j <= i+k-1, including 2k-2 js.

% TODO:
% What if 2*k-2>m+1??... I have no idea now.
% Done: well, I just wrap it around: e.g., k=4, m=4
% [ r1 r2 r3 r4 r5 r6 ] -> [ r1+r6 r2 r3 r4 r5]

if nargin>2
    is_closed = varargin{1};
    if ~is_closed
        error('open curve fitting is not supported yet');
        return;
    end
else
    is_closed = true;
end

R = zeros(m,m+1);

Q0 = construct_cardinal_spline(k-1,0);
Q0 = fn2fm(Q0,'pp');
Q1 = construct_cardinal_spline(k-1,1);
Q1 = fn2fm(Q1,'pp');
Q1.coefs = -1*Q1.coefs;
Q0_1 = sum_ppform(Q0,Q1);

int_coef = zeros(1,2*k-2);
% to construct 2k-2 j cardinal spline (order k-1)
% Given i = 1; the corresponding support is [0,k]
jj = 1;
sp = construct_cardinal_spline(k-1,(1-k+2)-1+jj-1);
pp = fn2fm(sp,'pp');
prod_pp = prod_ppform(pp,Q0_1);
int_pp = fnint(prod_pp);
int_coef(1) = ppval(int_pp,int_pp.breaks(end));

for jj = 2:(2*k-2)
    pp.breaks = pp.breaks+1; % 1 because of the cardinality
    prod_pp = prod_ppform(pp,Q0_1);
    int_pp = fnint(prod_pp);
    int_coef(jj) = ppval(int_pp,int_pp.breaks(end));
end

if (2*k-2)<=(m+1)
    tmp_row = [int_coef, zeros(1,m+1-(2*k-2))];
    %tmp_row = circshift(tmp_row,(1-k+2)-1,2); % i = 1, first row
    %R = toeplitz(tmp_row);
else
    tmp_row = int_coef(1:m+1);
    for ii = (m+2):(2*k-2)
        tmp_row(ii-(m+1)) = tmp_row(ii-(m+1))+int_coef(ii);
    end
end

R(1,:) = tmp_row;
for ii = 2:m
    tmp_row = circshift(tmp_row,1,2);
    R(ii,:) = tmp_row;
end
R = circshift(R,(1-k+2)-1,2); % i = 1, first row

% Not bad, I learned how to use circshift and toeplitz:)
