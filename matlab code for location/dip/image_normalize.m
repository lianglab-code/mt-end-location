function img2 = image_normalize(img,varargin)
%% IMAGE_NORMALIZE normalizes the input image
%
% Input:
% img: input image
% alpha: stretch range: [alpha,1-alpha]
% 
% Output:
% img2: output image
%
    alpha = 0.01;
    if nargin > 1
        alpha = varargin{1};
        if alpha <= 0 || alpha >=0.5
            error('quantile range error');
            return;
        end
    end

    tmp = img(:);
    q = quantile(tmp,[alpha,1-alpha]);
    img2 = (img-q(1))/(q(2)-q(1));
    img2(img2<0) = 0;
    img2(img2>1) = 1;
end
