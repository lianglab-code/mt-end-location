function sp = fit_tdm(ps, sp0)
%% FIT_TDM fit 

% test data: test_oval.mat

is_closed = true;
iter_max = 6;
knots = sp0.knots;
k = sp0.order;
coefs_ol = sp0.coefs;
coefs = coefs_ol(:,1:(end-k+1)); % non-overlapped coefs
m_ol = size(coefs_ol,2); % num of overlapped control points
m = size(coefs,2); % num of non-overlapped control points
n = size(ps,2); % num of points

tol1 = 1e-2; % data tolerance
tol2 = 5e-1; % threshold singular value of the matrix
l1 = 0.005; % regularization term l1 0.1
l2 = 0.005; % regularization term l2 0.1

% initial b-spline:
% gen sp0

sp = sp0;

% debug begin
I = eye(2*m,2*m);
lambda = 5;

figure;
plot(ps(1,:),ps(2,:),'ko');
hold on;
axis equal;
ColorSet = varycolor(iter_max);
t0 = linspace(knots(k),knots(end-k+1),200);
xy = fnval(sp,t0);
plot(xy(1,:),xy(2,:),'ro-','markersize',3,'markerfacecolor','r','linewidth',3);
plot([coefs(1,:),coefs(1,1)],[coefs(2,:),coefs(2,1)],'ro--','markersize',3,'markerfacecolor','k','linewidth',3);
% debug end

% regularization term
R1 = construct_cardinal_matrix_1st(k,m);
R2 = construct_cardinal_matrix_2nd(k,m);
Em = eye(m);
R11 = R1*( [Em;Em(1,:)] - [Em(m,:);Em] );
R22 = R2*( [Em;Em(1,:);Em(2,:)] ...
          -2*[Em(m,:);Em;Em(1,:)] ...
          +[Em(m-1,:);Em(m,:);Em] );
R11 = R11*l1;
R22 = R22*l2;

% debug begin
figure;
% debug end

for ii = 1:iter_max
    % step 01: calc foot points
    [d,t] = dist_points_sp_brute(ps,sp);
        
    % step 02: calc tangent, normal, and curve value
    c1 = fnval(sp,t);
    [ct,cn,csc] = calc_sp_tnc(sp,t);
    
    % debug
    % quiver(ps(1,:),ps(2,:),c1(1,:)-ps(1,:),c1(2,:)-ps(2,:),0);
    % debug

    % step 03: calc values of basis function at foot point
    B_ol = zeros(n,m_ol);
    for jj = 1:m_ol
        B_ol(:,jj) = bspline_basis_val_simple(sp,jj,t);
    end
    % NOTE: IMPORTANT
    % wrap around, otherwise information is lost
    B = B_ol(:,1:m);
    B(:,1:(k-1)) = B(:,1:(k-1)) + B_ol(:,(m_ol-k+2):m_ol);
    assignin('base','B_ol',B_ol);
    assignin('base','B',B);
    %assignin('base','d',d);
    %assignin('base','t',t);
    F = dot(ps-c1,cn,1).'; % column vector

    % % sparse begin
    % spB = sparse(B);
    % spBT = spB.';
    % spNx = sparse(diag(cn(1,:)));
    % spNy = sparse(diag(cn(2,:)));
    % spNxx = spNx*spNx;
    % spNxy = spNx*spNy;
    % spNyy = spNy*spNy;
    % spA = [ spBT*spNxx*spB, spBT*spNxy*spB;
    %         spBT*spNxy*spB, spBT*spNyy*spB];
    % spb = [spBT*spNx*F;spBT*spNy*F];
    % % solving the linear system of equations
    % D = spA\spb;
    % % sparse end

    % dense begin
    BT = B.';
    Nx = cn(1,:);
    Ny = cn(2,:);
    Nxx = Nx.*Nx;
    Nxy = Nx.*Ny;
    Nyy = Ny.*Ny;
    BTNxxB = bsxfun(@times,BT,Nxx)*B;
    BTNxyB = bsxfun(@times,BT,Nxy)*B;
    BTNyyB = bsxfun(@times,BT,Nyy)*B;
    % % without regularization
    % A = [BTNxxB, BTNxyB;...
    %      BTNxyB, BTNyyB];
    % b = [BT*(Nx.'.*F);...
    %      BT*(Ny.'.*F)];
    % with regularization
    A = [BTNxxB+R11+R22, BTNxyB;...
         BTNxyB, BTNyyB+R11+R22];
    b = [BT*(Nx.'.*F);...
         BT*(Ny.'.*F)] ...
        - [R11*coefs(1,:).';...
           R11*coefs(2,:).'] ...
        - [R22*coefs(1,:).';...
           R22*coefs(2,:).'];
    
    % 1 normal
    D = A\b; % solving the linear system of equations
    % 2 svd: result: a little better
    % [U S V] = svd(A);
    % sv = diag(S);
    % svmax = max(sv);
    % svflg = sv>(svmax*tol2);
    % b = U.'*b;
    % D = zeros(size(b));
    % D(svflg) = b(svflg)./sv(svflg);
    % D = V*D;

    % % debug begin test regularization
    % D = (A+condest(A)/lambda*I)\b;
    % % debug end
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
    % subplot(5,6,ii);hist(t);drawnow;
    % max(abs(b))
    % [min(Nx.'.*F) max(Nx.'.*F) min(Ny.'.*F) max(Ny.'.*F)]
    % mean(F.*F)
    % max(F.*F)
    % sqrt(sum((dcoefs.*dcoefs),1))
    
    subplot(2,3,ii);
    xy = fnval(sp,t0);
    plot(xy(1,:),xy(2,:),'-','color',ColorSet(ii,:));
    hold on;
    plot(ps(1,:),ps(2,:),'k.');
    plot([coefs(1,:),coefs(1,1)],[coefs(2,:),coefs(2,1)],'*--',...
         'color',ColorSet(ii,:),...
         'markerfacecolor',ColorSet(ii,:));
    plot(coefs(1,1),coefs(2,1),'r.','markersize',20);
    hold off;
    axis equal;
    drawnow;
    
    % coefs
    if(condest(A)>1e4)
        disp('condest break');
        return;
    end
    % debug end
    
end