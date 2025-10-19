function c = my_line_profile(I, x, y, d, n)
%% MY_LINE_PROFILE returns the line profile with width 2d+1

% Input:
% I: 2D image
% x,y: 2x1 vector, defining the start and end points
% d: the half width of the profiling line
% n: the length of the returning vector

% output:
% c: the returning vector

% the input output formats are consistent with the MATLAB 
% built-in function IMPROFILE

p1 = x(1) + y(1)*sqrt(-1);
p2 = x(2) + y(2)*sqrt(-1);

theta = angle(p2-p1);
u0 = cos(theta) + sin(theta)*sqrt(-1);
u1 = u0*sqrt(-1);
u2 = -u0*sqrt(-1);

l = floor(d);
pstart = ones(2*l+1,1)*(1+i);
pend = ones(2*l+1,1)*(1+i);
for j = 1:d
    pstart(j) = p1 + u1*j;
    pstart(2*l+2-j) = p1 + u2*j;
    pend(j) = p2 + u1*j;
    pend(2*l+2-j) = p2 + u2*j;
end
pstart(l+1) = p1;
pend(l+1) = p2;

c = zeros(n,1);
cs = zeros(n, 2*l+1);

for j = 1:(2*l+1)
    xdat = [real(pstart(j)), real(pend(j))];
    ydat = [imag(pstart(j)), imag(pend(j))];
    cs(:,j) = improfile(I, xdat, ydat, n);
end

c = mean(cs,2);

end