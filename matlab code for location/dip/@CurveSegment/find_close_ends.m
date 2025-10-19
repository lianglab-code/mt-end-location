function pairends = find_close_ends(Cs,r)
%% FIND_CLOSE_ENDS finds paired end points which are close.
%
% pairends = find_close_ends(Cs,r)
%
% Input:
% Cs: cell of CurveSegment
% r: radius
%
% Output:
% pairends: num_pairs x 2, negative value indicates End of curve
%

    num_Cs = numel(Cs);
    % assume that this will allocate enough memory for pe
    pe = zeros(4*num_Cs,2);
    ind = 0;
    for I = 1:(num_Cs-1)
        C1 = Cs{I};
        C1s = C1.Start;
        C1e = C1.End;
        for J = (I+1):num_Cs
            C2 = Cs{J};
            C2s = C2.Start;
            C2e = C2.End;
            if pd(C1s,C2s)<r
                ind = ind + 1;
                pe(ind,:) = [I,J];
            end
            if pd(C1s,C2e)<r
                ind = ind + 1;
                pe(ind,:) = [I,-J];
            end
            if pd(C1e,C2s)<r
                ind = ind + 1;
                pe(ind,:) = [-I,J];
            end
            if pd(C1e,C2e)<r
                ind = ind + 1;
                pe(ind,:) = [-I,-J];
            end
        end
    end

    % remember to clear this kind of situation
    % o *****************
    % the first curve has only one point, so the start and end
    % point coincide.
    num_points = zeros(num_Cs);
    for I = 1:num_Cs
        num_points(I) = get_curve_length(Cs{I});
    end
    % to remove the zero entries
    inds = find(prod(pe,2)~=0);
    pe2 = pe(inds,:);
    % to remove the duplicate pair: (1,2),(1,-2), if seg2 has len 1
    for I = 1:numel(pe2)
        if num_points(abs(pe2(I)))==1
            pe2(I) = abs(pe2(I));
        end
    end
    pairends = unique(pe2,'row');

    % helper functions
    function pdout = pd(pda,pdb)
        pdout = sqrt(sum((pda-pdb).^2));
    end

end