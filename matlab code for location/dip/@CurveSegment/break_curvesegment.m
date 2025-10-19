function Cs = break_curvesegment(C,k_num,k_thres,spreg)
%% BREAK_CURVESEGMENT breaks the curve at large curvature
%
% Cs = break_curvesegment(C,thres)
%
% Input:
% C: a CurveSegment
% k_num: min num of points; no breaking if less than it
% k_thres: curvature threshold
% spreg: spline regularization in csaps
%
% Output:
% Cs: cells of CurveSegment
%
% example inputs:
% k_num: 7, k_thres: 0.1, spreg: 0.1

    warning('off','signal:findpeaks:largeMinPeakHeight');

    Cs = {};

    np = get_curve_length(C);
    if np < k_num
        Cs{end+1} = C;
    else
        p = C.Points;
        t = 1:np;
        pp = csaps(t, p, spreg);
        curvature = abs(calc_pp_curvature(pp,t));
        [pks,loc] = findpeaks(curvature,...
                              'MinPeakHeight',...
                              k_thres);
        if numel(pks)==0
            Cs{end+1} = C;
        elseif numel(loc)==1 && (loc==1 || loc==np)
            Cs{end+1} = C;
        else
            nl = numel(loc);
            if loc(1)~=1
                Cs{end+1} = CurveSegment(...
                    C.Start,...
                    p(:,loc(1)),...
                    p(:,1:loc(1)) );
            end
            for jj = 2:nl
                Cs{end+1} = CurveSegment(...
                    p(:,loc(jj-1)),...
                    p(:,loc(jj)),...
                    p(:,loc(jj-1):loc(jj)) );
            end
            if loc(nl)~=np
                Cs{end+1} = CurveSegment(...
                    p(:,loc(nl)),...
                    C.End,...
                    p(:,loc(nl):np) );
            end
        end
    end

    warning('on','signal:findpeaks:largeMinPeakHeight');

end