function [sp,err] = fit_sdm(ps, sp)
%% FIT_SDM fit 

% NOTE:
% this is a template for the family of the fitting algorithms
% mentioned in LIU Yang's papers.

% INPUT:
% ps: points, 2xn
% sp: b-spline

% OUTPUT:
% sp: fitted b-spline
% err: error, 1xn

% NOTE:
% The optimization problem is:
% \min_{D}{cost + reg1 + reg2},
% cost = \sum_{i=1}^n{err_sdm(p_i,sp)}^2,
% reg1 = \int{|sp'|^2}dt,
% reg2 = \int{[sp''|^2}dt,
% where
% D is the displacement of the control points
% err_sdm(p_i,sp) is the SDM error of point i (c.f., Liu paper),
% sp' is the first derivative of the spline w.r.t. t,
% sp'' is the second derivative of the spline w.r.t. t.

% R1, R2, R11, R22: the matrices involved in the calculation of the
% derivatives of the regularization terms w.r.t. D.

% Observations:
% 1. Ideally, the projected ts on the curve should cover the whole
% range of [knots(k) knots(end-k+1)]; if this is not the case, the
% situation indicates that there are some control points losing
% control. This also means that one assumption in SDM is violated:
% the initial curve should be sufficiently close to the point
% cloud. In other words, this is not the problem of SDM.
% 2. 

% test data: test_oval.mat

% TODO: 
% 1. to implement step control
% 2. point projection test

is_closed = true;
iter_max = 1;
tol1 = 1e-2; % data tolerance
tol2 = 5e-1; % threshold singular value of the matrix
l1 = 0.5; % regularization term l1 0.1
l2 = 0.1; % regularization term l2 0.1

knots = sp.knots;
k = sp.order;
coefs_ol = sp.coefs;
coefs = coefs_ol(:,1:(end-k+1)); % non-overlapped coefs
m_ol = size(coefs_ol,2); % num of overlapped control points
m = size(coefs,2); % num of non-overlapped control points
n = size(ps,2); % num of points

% regularization term derivative matrices
R1 = construct_cardinal_matrix_1st(k,m);
R2 = construct_cardinal_matrix_2nd(k,m);
Em = eye(m);
R11 = R1*( [Em;Em(1,:)] - [Em(m,:);Em] );
R22 = R2*( [Em;Em(1,:);Em(2,:)] ...
          -2*[Em(m,:);Em;Em(1,:)] ...
          +[Em(m-1,:);Em(m,:);Em] );
R11 = R11*l1;
R22 = R22*l2;

for ii = 1:iter_max
    % step 01: calc foot points
    [d,t] = dist_points_sp_brute(ps,sp);
    
    % step 02: calc tangent, normal, and curve value
    c1 = fnval(sp,t);
    [ct,cn,csc] = calc_sp_tnc(sp,t);
    % flag indicating to incorporate the tangent term
    d_sign = zeros(1,n);
    csn = sign([csc;csc]).*cn;
    % d_sign>0 -> p is at the same side of curvature circle
    d_sign = dot((ps-c1),csn,1);
    
    % step 03: calc values of basis function at foot point
    B_ol = zeros(n,m_ol);
    for jj = 1:m_ol
        B_ol(:,jj) = bspline_basis_val_simple(sp,jj,t);
    end
    % NOTE: IMPORTANT
    % wrap around, otherwise information is lost
    B = B_ol(:,1:m);
    B(:,1:(k-1)) = B(:,1:(k-1)) + B_ol(:,(m_ol-k+2):m_ol);
    
    % step 04: other matrices
    F = dot(ps-c1,cn,1).'; % column vector
    % used to modify tangent
    mod_factor = (d./(d-abs(csc)));
    mod_factor(d_sign>=0) = 0;
    mod_factor = sqrt(mod_factor);
    ct2 = repmat(mod_factor,2,1).*ct;
    G = dot(ps-c1,ct2,1).'; % column vector
   
    % sparse begin
    % spB = sparse(B);
    % spBT = spB.';
    % spNx = sparse(diag(cn(1,:)));
    % spNy = sparse(diag(cn(2,:)));
    % spNxx = spNx*spNx;
    % spNxy = spNx*spNy;
    % spNyy = spNy*spNy;
    % spTx2 = sparse(diag(ct2(1,:)));
    % spTy2 = sparse(diag(ct2(2,:)));
    % spTxx2 = spTx2*spTx2;
    % spTxy2 = spTx2*spTy2;
    % spTyy2 = spTy2*spTy2;
    % spA = [ spBT*(spNxx+spTxx2)*spB, spBT*(spNxy+spTxy2)*spB;
    %         spBT*(spNxy+spTxy2)*spB, spBT*(spNyy+spTyy2)*spB];
    % spb = [spBT*(spNx*F+spTx2*G);spBT*(spNy*F+spTy2*G)];
    % D = spA\spb; % solving the linear system of equations
    % sparse end
    
    % dense begin
    BT = B.';
    Nx = cn(1,:);
    Ny = cn(2,:);
    Tx2 = ct2(1,:);
    Ty2 = ct2(2,:);
    Nxx_Txx2 = Nx.*Nx+Tx2.*Tx2;
    Nxy_Txy2 = Nx.*Ny+Tx2.*Ty2;
    Nyy_Tyy2 = Ny.*Ny+Ty2.*Ty2;
    block1 = bsxfun(@times,BT,Nxx_Txx2)*B;
    block2 = bsxfun(@times,BT,Nxy_Txy2)*B;
    block3 = bsxfun(@times,BT,Nyy_Tyy2)*B;
    A = [block1+R11+R22, block2;...
         block2, block3+R11+R22];
    b = [BT*(Nx.'.*F+Tx2.'.*G); ...
         BT*(Ny.'.*F+Ty2.'.*G)] ...
        - [R11*coefs(1,:).';...
           R11*coefs(2,:).'] ...
        - [R22*coefs(1,:).';...
           R22*coefs(2,:).'];
    
    % 1 normal
    % D = A\b; % solving the linear system of equations
    % 2 svd: result: a little better
    [U S V] = svd(A);
    sv = diag(S);
    svmax = max(sv);
    svflg = sv>(svmax*tol2);
    if(sum(svflg))==0
        return;
    end
    b = U.'*b;
    D = zeros(size(b));
    D(svflg) = b(svflg)./sv(svflg);
    D = V*D;
    % dense end    
    
    dcoefs = reshape(D,2,m);
    coefs = coefs + dcoefs;
    coefs_ol = [coefs,coefs(:,1:(k-1))];
    sp.coefs = coefs_ol;
    
    % debug begin
    % ii
    % max(d.^2)
    % condest(A)
    % [min(t) max(t)]
    % sum(t==min(t))
    % max(abs(b))
    % [min(Nx.'.*F) max(Nx.'.*F) min(Ny.'.*F) max(Ny.'.*F)]
    % mean(F.*F)
    % max(F.*F)
    % sqrt(sum((dcoefs.*dcoefs),1))
        
    % coefs
    if(condest(A)>1e4)
        disp('condest break');
        return;
    end

end