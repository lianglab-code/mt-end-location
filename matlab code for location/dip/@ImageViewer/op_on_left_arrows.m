function op_on_left_arrows(obj)
% just a wrapper
% NOTE: the value at the first frame must be initialized!
    if obj.active_ind > 0 && ...
            obj.active_ind <= size(obj.imgroi.a,2)
        disp(strcat('Computing: Localizing left arrows:',...
                    num2str(obj.active_ind))); % start
        params = obj.localize_left_endpoints();
        p1 = params(1:2,:);
        p2 = p1 + ImageViewer.ABL*[...
            cos(params(4,:)+pi);...
            sin(params(4,:)+pi)];
        p12 = reshape([p1;p2],[4,1,obj.num_frames]);
        obj.imgroi.a(:,obj.active_ind,:) = p12;
        obj.imgroi.a2(:,obj.active_ind,:) = reshape(...
            params,[8,1,obj.num_frames]);
        disp('done'); % end
    end
end