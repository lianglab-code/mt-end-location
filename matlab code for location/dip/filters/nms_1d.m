function [out,pmax] = nms_1d(in,n)
%% NMS_1D suppresses the non-maximum values of the input 1d array
% out = nms_1d(in,n,varargin)
%
% INPUT:
% in: 1d input array
% n: window radius
% 
% OUTPUT:
% out: non-maximum suppressed output
% pmax: partial maximum sequence of in
%
% REFERENCE:
% Efficient Non-Maximum Suppression, Neubeck and van Gool
%
% NOTE:
% The input sequence should be distince, e.g., I(i)~=I(j), if i~=j.
% if I(i) == I(j), then neither is a maximum.
    
    in = reshape(in,[1,numel(in)]);
    Win = numel(in);
    I = padarray(in,[0,n],-inf,'both');
    W = numel(I); % width
    out = inf(1,W)*(-1);
    pmax = inf(1,W)*(-1);
    
    % if(W < 2*n+1)
    %     error(['window size larger than the width of the input ' ...
    %            'array']);
    %     return;
    % end
    
    % initiation
    i = n+1;
    comp_partial_max(1,i-1);
    % chkpt = i;
    chkpt = -1;
    
    % while i < (W-2*n)
    while i<=(W-n)
        j = comp_partial_max(i,i+n);
        k = comp_partial_max(i+n+1,j+n);
        % if i==j || I(j)>I(k)
        if i==j || I(j)>=I(k)
            if (chkpt<=(j-n) || I(j)>=pmax(chkpt)) ...
                       && ...
                       ((j-n)==i || I(j)>=pmax(j-n))
                out(j) = I(j);
            end
            if i<j
                chkpt = i+n+1;
            end
            i = j+n+1;
        else
            i = k;
            chkpt = j+n+1;
            while i<=(W-n)
                j = comp_partial_max(chkpt,i+n);
                % if I(i)>I(j)
                if I(i)>=I(j)
                    out(i) = I(i);
                    % i = i+n-1; % i = i+n+1?
                    i = i+n+1;
                    break;
                else
                    % chkpt = i+n-1; % chk = i+n+1?
                    chkpt = i+n+1;
                    i = j;
                end
            end
        end
    end
    
    out = out((n+1):(Win+n));
    pmax = pmax((n+1):(Win+n));

    % function best = comp_partial_max(from,to)
    % % if two max exist, return the right one
    %     best = to;
    %     if to<from
    %         return;
    %     end
    %     pmax(to) = I(to);
    %     while to > from
    %         to = to - 1;
    %         if I(to) <= I(best)
    %             pmax(to) = I(best);
    %         else
    %             pmax(to) = I(to);
    %             best = to;
    %         end
    %     end
    % end

    function best = comp_partial_max(from,to)
    % if two max exist, return the left one
        best = to;
        if to<from
            return;
        end
        pmax(to) = I(to);
        while to > from
            to = to - 1;
            if I(to) >= I(best)
                pmax(to) = I(to);
                best = to;
            else
                pmax(to) = I(best);
            end
        end
    end

end