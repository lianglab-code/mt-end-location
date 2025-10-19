function u = vec2triu(v,varargin)
%% VEC2TRIU converts the vector v to a upper-triangular matrix.
% u = vec2triu(v)

% INPUT:
% v: m(m-1)/2
% k: k-off diagonal;0 default

% OUTPUT:
% u: upper-triangular matrix

% EXAMPLE:
% v = 1:3;
% u = vec2triu(v); % [1 2;0 3];
% u = vec2triu(v,1); % [0 1 2; 0 0 3; 0 0 0];

k = 0;
if nargin>1
    k = varargin{1};
end

nv = numel(v);
v = reshape(v,1,nv);
m = floor(sqrt(nv*2));

if (m*(m+1)/2)~=nv
    error('dimension mismatch');
    return;
end

u = zeros(m,m);

ind = 1;
for ii = 1:m
    u(ii,ii:m) = v(ind:(ind+(m-ii+1)-1));
    ind = ind+(m-ii+1);
end

if k>0
    u = padarray(u,[0,k],0,'pre');
    u = padarray(u,[k,0],0,'post');
end
