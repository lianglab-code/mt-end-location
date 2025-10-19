function ppout = prod_ppform(pp1,pp2)
%% PROD_PPFORM multiplies two pp-form piecewise polynomials:
% pp1 with pp2

% INPUT:
% pp1: piecewise polynomial 1, in pp-form
% pp2: piecewise polynomial 2, in pp-form

% OUTPUT:
% ppout: convoluted piecewise polynomial

% ASSUMPTION:
% The breaks of the pp1 and pp2 have overlaps and the overlaps must
% match. The non-overlap parts are treated as zeros.
% The breaks in pp1(and pp2) must be unique.
% The dimension of the PP is 1.

% EXAMPLE:
% coefs = [1/6, 0, 0, 0;
%          -1/2, 1/2, 1/2, 1/6;
%          1/2, -1, 0, 1/6;
%          -1/6, 1/2, -1/2, 1/6];
% p1 = ppmak(0:4,coefs,1);
% p2 = ppmak(1:5,coefs,1);
% p3 = prod_ppform(p1,p2);

ppout = [];

b1 = fnbrk(pp1, 'breaks');
b2 = fnbrk(pp2, 'breaks');
c1 = fnbrk(pp1,'coefs');
c2 = fnbrk(pp2,'coefs');
num_b1 = numel(b1);
num_b2 = numel(b2);

breaks = unique([b1 b2]);
num_break = numel(breaks);
coefs = cell(num_break-1,1);
max_order = 0;

for ii = 1:(num_break-1)
    % pp1
    ind1 = find(b1==breaks(ii),1);
    if isempty(ind1)
        pc1 = [0];
    else
        if ind1==num_b1
            pc1 = [0];
        else
            if b1(ind1+1)~=breaks(ii+1)
                error('breaks in pp1 are corrupted!');
                return;
            else
                pc1 = c1(ind1,:);
            end
        end
    end
    % pp2
    ind2 = find(b2==breaks(ii),1);
    if isempty(ind2)
        pc2 = [0];
    else
        if ind2==num_b2
            pc2 = [0];
        else
            if b2(ind2+1)~=breaks(ii+1)
                error('breaks in pp2 are corrupted!');
                return;
            else
                pc2 = c2(ind2,:);
            end
        end
    end

    pc = conv(pc1,pc2);
    cur_order = length(pc);
    if cur_order>max_order
        max_order = cur_order;
    end
    coefs{ii} = pc;
end

for ii = 1:(num_break-1)
    coefs{ii} = [zeros(1,max_order-length(coefs{ii})),coefs{ii}];
end

coefs = cell2mat(coefs);
ppout = ppmak(breaks,coefs,1);
