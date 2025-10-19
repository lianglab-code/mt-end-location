function check_point(imgs, param, varargin)
%% CHECK_BAREND is a tool for checking the fitting results
% Input:
% imgs: MT images
% param: num_frame x 6 or num_frame x 2
% param_2: as param, opt
%
% example:
% check_point(mtimgs, param_mt);
% check_point(mapimgs, param_map);
% check_point(mtimgs, param_mt, param_map);
    
    num_frame = size(imgs,3);
    if num_frame~=size(param,1)
        error('dimensions mismatch');
    end

    if nargin == 2
        imgroi = struct();
        imgroi.p = reshape([param(:,1:2)]', 2, 1, num_frame);
        imviewer(imgs, imgroi);
    else
        param_2 = varargin{1};
        imgroi = struct();
        imgroi.a = nan(4,2,num_frame); % two arrows for each frame
        if size(param,1)>2 % mt + map
            for ii = 1:num_frame
                imgroi.a(1:4,1,ii) = [param(ii,1:2),param_2(ii,1:2)]; % mt end -> map
                theta = param(ii,4) + pi;
                M = [cos(theta), -sin(theta); sin(theta), cos(theta)];
                imgroi.a(1:4,2,ii) = [param(ii,1:2),param(ii,1:2)+(M*[3;0])'];
            end
        else % only two points
            imgroi.a = reshape([param(:,1:2),param_2(:,1:2)]', 4, 1, num_frame);
        end
        imviewer(imgs, imgroi);
    end
end