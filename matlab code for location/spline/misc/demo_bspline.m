function demo_bspline
%% DEMO_BSPLINE is a demo fo b-spline
% When a control point is moved, the curve is modified.

    is_closed = true;
    nc = 6; % num control points, non-overlapping
    dim = 2;
    np = 100; % points of each segment
    knots = 1:(nc+7);
    k = 4;
    tol = 0.1;

    coefs = 10*rand(2,nc);
    coefs2 = [coefs,coefs(:,1:3)];
    act_ind = 0; % used to indicated the point being selected

    sp = spmak(knots,coefs2);

    fh = figure;
    fa = axes('parent',fh);
    axis equal;
    axis manual;
    axis([-1 11 -1 11]);

    t = linspace(knots(k),knots(end-k+1),np);
    xy = fnval(sp,t);
    axy = fnval(sp,knots(k:end-k+1));

    % spline
    l = line('parent',fa);
    update_line(l,xy);
    config_line(l);
    
    % control polygon
    lc = line('parent',fa);
    update_line(lc,coefs);
    config_linec(lc);
    
    % anchor points
    la = line('parent',fa);
    update_line(la,axy);
    config_linea(la);

    % setting window callbacks
    set(fh,'WindowButtonDownFcn',@wbdfcn);
    set(fh,'WindowButtonMotionFcn','');
    set(fh,'WindowButtonUpFcn','');
    
    % callbacks
    function wbdfcn(obj,evt,userdata)
        pos = get(fa,'CurrentPoint');
        pos = pos(1,1:2)';
        dist = coefs - repmat(pos,1,nc);
        dist = sqrt(sum(dist.^2,1));
        [min_dist,min_ind] = min(dist);
        if min_dist<tol
            act_ind = min_ind;
            set(fh,'WindowButtonMotionFcn',@wbmfcn);
            set(fh,'WindowButtonUpFcn',@wbufcn);
        end
    end
    
    function wbufcn(obj,evt,userdata)
        set(fh,'WindowButtonMotionFcn','');
        set(fh,'WindowButtonUpFcn','');
    end
    
    function wbmfcn(obj,evt,userdata)
        pos = get(fa,'CurrentPoint');
        pos = pos(1,1:2)';
        coefs(:,act_ind) = pos;
        coefs2 = [coefs,coefs(:,1:3)];
        sp.coefs = coefs2;
        xy = fnval(sp,t);
        axy = fnval(sp,knots(k:end-k+1));
        update_line(l,xy);
        update_line(lc,coefs);
        update_line(la,axy);
    end
    
    function update_line(tmpl,tmpxy)
        set(tmpl,'xdata',tmpxy(1,:));
        set(tmpl,'ydata',tmpxy(2,:));
    end
    
    function config_line(tmpl)
        set(tmpl,'linewidth',2);
        set(tmpl,'color','r');
    end
    
    function config_linec(tmpl)
        set(tmpl,'linewidth',3);
        set(tmpl,'color','k');
        set(tmpl,'linestyle','--');
        set(tmpl,'marker','o');
        set(tmpl,'markerfacecolor','k');
    end
    
    function config_linea(tmpl)
        set(tmpl,'color','b');
        set(tmpl,'linestyle','none');
        set(tmpl,'marker','o');
        set(tmpl,'markersize',8);
        set(tmpl,'markerfacecolor','b');
    end
    
end