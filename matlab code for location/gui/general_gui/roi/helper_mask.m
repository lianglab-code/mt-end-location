function masked = helper_mask(src,mask,varargin)
% src:
% https://cn.mathworks.com/matlabcentral/answers/38547-masking-out-image-area-using-binary-mask
% mask: binary, same size as src, but does not have to be same data type (int vs logical)
% src: rgb or gray image
% varargin: value to be set
    v = 1;
    if nargin>2
        v = varargin{1};
        if v~=0
            cast(mask,class(src));
            mask = mask*v;
            masked = bsxfun(@plus, src, cast(mask,class(src)));
            masked(masked>v) = v;
        else
            cast(mask,class(src));
            mask = 1-mask;
            masked = bsxfun(@times, src, cast(mask,class(src)));
        end
    else
        masked = bsxfun(@plus, src, cast(mask,class(src)));
        masked(masked>1) = 1;
    end
end