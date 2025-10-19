function scwcb(obj,src,evt,handles)
% scroll_wheel callback, navigating through image frames.
% canvas update part is adapted from scwcb_frames.
    
% INPUT:
% obj: ImageViewer obj
% src: figure obj
% evt: event

    if isempty(obj.cur_frame) | (obj.cur_frame<1)
        warning('no cur_frame, figure not scrollable');
        return;
    end
    if isempty(obj.imgs)
        warning('no imgs, figure not scrollable');
        return;
    end
    if isempty(obj.imgs)
        warning('no h_img, figure not scrollable');
        return;
    end
    if isempty(obj.scroll_step)
        warning('no scroll_step, figure not scrollable');
        return;
    end

    sc = evt.VerticalScrollCount; % scrollcount
    post_frame = obj.cur_frame + sc * obj.scroll_step;

    set(0, 'currentfigure', src);
    if post_frame>=1 && post_frame<=obj.num_frames
        set(obj.h_img,'CData',obj.imgs(:,:,post_frame));
        set(src,'Name', num2str(post_frame));
        obj.cur_frame = post_frame;
    end

    obj.update_points();
    obj.update_arrows();
    obj.update_rects();
end
