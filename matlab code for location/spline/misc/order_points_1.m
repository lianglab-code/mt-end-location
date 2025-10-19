function [xo,yo] = order_points_1(x,y)
%% ORDER_OINTS_1 orders points of a closed curve.
% The curve shoule be simple, e.g., 
% 1. there is no self-intersection,
% 2. the curve is completely convex.

% reference:
% https://stackoverflow.com/questions/19721448/how-can-i-sort-unordered-points-into-an-clock-wise-ordered-list

p = x + y*sqrt(-1);
p0 = mean(p);
a = angle(p-p0);
[sorted_a, idx] = sort(a);
xo = x(idx);
yo = y(idx);

end
