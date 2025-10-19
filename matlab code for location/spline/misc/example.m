%% data from image
imgs = tif_img_reader(['/home/image/projects/collaborations/Dong/' ...
                    'g1-1.tif']);
img = imgs(:,:,125);
BW = bwmorph(img,'remove');
[I,J]=find(BW);
x = double(J);
y = double(I);

%% plotting
plot(x,y,'ro');
tmpx1 = max(x);
tmpx2 = min(x);
tmpy1 = max(y);
tmpy2 = min(y);
axis([(tmpx1+tmpx2)-(tmpx1-tmpx2)*1.2 ...
      (tmpx1+tmpx2)+(tmpx1-tmpx2)*1.2 ...
      (tmpy1+tmpy2)-(tmpy1-tmpy2)*1.2 ...
      (tmpy1+tmpy2)+(tmpy1-tmpy2)*1.2 ...
     ]/2);
axis equal;

%% 
k = 4; % order 4
       % control_points = ginput(); % [x0,y0;x1,y1]
       % control_points = control_points';
load('control_points.mat');

% https://pages.mtu.edu/~shene/COURSES/cs3621/NOTES/spline/B-spline/bspline-curve-closed.html
% contains information for both methods below

% 1, from
% https://math.stackexchange.com/questions/1296954/b-spline-how-to-generate-a-closed-curve-using-uniform-b-spline-curve
% control points wrapping, uniformity of knots are required
for ii = 1:(k-1)
    control_points(:,end+1) = control_points(:,ii);
end
n = size(control_points,2);
t = linspace(0,1,n+k);
knots = t;
sp = spmak(knots, control_points);

figure;
plot(x,y,'ro');
tmpx1 = max(x);
tmpx2 = min(x);
tmpy1 = max(y);
tmpy2 = min(y);
axis([(tmpx1+tmpx2)-(tmpx1-tmpx2)*1.2 ...
      (tmpx1+tmpx2)+(tmpx1-tmpx2)*1.2 ...
      (tmpy1+tmpy2)-(tmpy1-tmpy2)*1.2 ...
      (tmpy1+tmpy2)+(tmpy1-tmpy2)*1.2 ...
     ]/2);
axis equal;
hold on;
plot(control_points(1,:),control_points(2,:),'kx');
fnplt(sp,[knots(k) knots(end-k+1)],'k.-');
tmp = fnval(sp,knots(k));
plot(tmp(1),tmp(2),'gx','MarkerSize',20);
tmp = fnval(sp,knots(end-k+1));
plot(tmp(1),tmp(2),'co','MarkerSize',20);
hold off;

% 2, from de Boor's PGS, p282 Periodic Splines
% knots wrapping, uniformity of knots are not required
control_points2 = control_points(:,1:end-3);
n = size(control_points2,2);
t2 = linspace(0,1,n-k+3);

% knots2 = augknt(t2,k);
% to extend end knots from the other side
% knots2 = t2;
tmp = t2(end)-t2(1);
knots2 = [0 0 0 t2 t2(end) t2(end) t2(end)];
for ii = 1:(k-1)
    knots2(ii) = knots2(n-(k-1)+ii)-tmp;
    %    knots2(n+1+ii) = knots2(k+ii)+tmp;
end
control_points2(:,end+1) = control_points2(:,1);
sp2 = spmak(knots2, control_points2);

figure;
plot(x,y,'ro');
tmpx1 = max(x);
tmpx2 = min(x);
tmpy1 = max(y);
tmpy2 = min(y);
axis([(tmpx1+tmpx2)-(tmpx1-tmpx2)*1.2 ...
      (tmpx1+tmpx2)+(tmpx1-tmpx2)*1.2 ...
      (tmpy1+tmpy2)-(tmpy1-tmpy2)*1.2 ...
      (tmpy1+tmpy2)+(tmpy1-tmpy2)*1.2 ...
     ]/2);
axis equal;
hold on;
plot(control_points2(1,:),control_points2(2,:),'kx');
fnplt(sp2,[knots2(k) knots2(n+1)],'k.-');
tmp = fnval(sp2,knots2(k));
plot(tmp(1),tmp(2),'gx','MarkerSize',20);
tmp = fnval(sp2,knots2(end-k+1));
plot(tmp(1),tmp(2),'co','MarkerSize',20);
hold off;
