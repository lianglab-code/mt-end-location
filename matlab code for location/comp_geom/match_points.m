function pairs = match_points(p1,p2,cutoff)
%% MATCH_POINTS finds the correspondence between two point sets by using intlinprog
%
% Input:
% p1,p2: two nx2 point sets
% cutoff: distance cutoff
%
% Output:
% pairs: the correspondence pair, n_pairs x 2

    % Param:
    COST_FACTOR = 1.5;

    np1 = size(p1,1);
    np2 = size(p2,1);
    % cutoff = 10;
    cost1 = COST_FACTOR * cutoff;
    cost_mat = construct_cost(p1,p2,cutoff,cost1);
    [x,fval,exitflag,output] = solve_intlinprog(cost_mat);
    y = reshape(x,np1+np2,np1+np2);

    I = zeros(np1,1);
    J = zeros(np1,1);
    for ii = 1:np1
        jj = find(y(ii,:));
        if jj<=np2
            I(ii) = ii;
            J(ii) = jj;
        end
    end

    % I(I==0) = [];
    % J(J==0) = [];
    % pairs = [I,J];
    pairs = [I(I~=0),J(I~=0)];
end
