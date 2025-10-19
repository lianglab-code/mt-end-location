function [x,y,w,h] = rect_line2roi(rectx,recty)
    if isempty(rectx) || isempty(recty)
        x=nan;y=nan;w=nan;h=nan;
    else
        x = min(rectx);
        y = min(recty);
        w = max(rectx)-x;
        h = max(recty)-y;
    end
end
