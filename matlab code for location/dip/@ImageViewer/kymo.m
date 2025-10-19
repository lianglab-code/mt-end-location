function kymo(obj)
% make a kymograph
    if obj.active_ind > 0 && ...
            obj.active_ind <= size(obj.imgroi.a,2)
        p0 = obj.imgroi.a(:,obj.active_ind,:);
        tmp = p0-repmat(p0(:,1,1),[1 1 obj.num_frames]);
        if sum(abs(tmp(:)))>eps
            warning(['line segments are different at differnt ' ...
                     'frames, abort']);
            return;
        end
        clear 'tmp';
        p1 = [p0(1,1,1);p0(2,1,1)];
        p2 = [p0(3,1,1);p0(4,1,1)];
        kimg = kymograph(obj.imgs,p1,p2,...
                         ImageViewer.KYMO_N,...
                         ImageViewer.KYMO_W);
        figure;
        imshow(kimg,[],'Border', 'tight');
    end
end
