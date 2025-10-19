function C = image_xcorr(img,mask)
%% IMAGE_XCORR computes the cross-correlation between the input
% image and the mask
%
% Input:
% img: 2d image
% mask: 2d mask
%
% Output:
% C: cross-correlation, same size as img, -1 <= C <= 1
%
% Note:
% C_ij = <img_ij,mask>/(sqrt(<img_ij,img_ij>)*sqrt(<mask,mask>)) 
% 
% Correlation coefficient can be viewed from point of view of optimization:
% Suppose {a*,b*} is the solution of this least-squares optimization problem:
% min_{a0,b0} (img - (a+b*mask))^2
% Then, (img - (a0 + b0*mask))^2 = n * <img,img> * (1 - C^2)
% 
% Source:
% https://www.cs.auckland.ac.nz/courses/compsci773s1c/lectures/CS773S1C-CorrelationMatching.pdf
%
    if ndims(img)~=2 || ndims(mask)~=2
        error('only 2d matrix is supported');
        return;
    end
    [m,n] = size(img);
    [p,q] = size(mask);
    if mod(p,2)~=1 || mod(q,2)~=1
        error('size of the mask must be odd');
        return;
    end
    p2 = (p-1)/2;
    q2 = (q-1)/2;

    % variance of image
    img_box = imboxfilt(img,[p,q],'padding',0); % padding 0
    img_sqr_box = imboxfilt(img.^2,[p,q],'padding',0);
    sigma_f_sqr = img_sqr_box - img_box.^2;
    % variance of mask
    mask_m = mean(mask(:));
    mask2 = mask - mask_m;
    sigma_t_sqr = mean(mask2(:).^2);
    % variance of correlation
    sigma_t_f = imfilter(img,mask,'corr',0)/(p*q) - ...
        mask_m * img_box;

    % % difference
    % D = sigma_f_sqr - (sigma_t_f.^2)/sigma_t_sqr;
    % correlation, D = sigma_f_sqr * (1-C^2)
    C = sigma_t_f./sqrt(sigma_f_sqr.*sigma_t_sqr);
end

% % test 1
% t = img(101:109,101:109,1);
% tm = [0 1 0;1 1 1;0 1 0];
% tt1 = image_xcorr(t,tm);
% tt2 = zeros(9,9);
% tm2 = tm - mean(tm(:));
% for ii = 2:8
%     for jj = 2:8
%         tmp1 = t(ii-1:ii+1,jj-1:jj+1);
%         tmp2 = tmp1 - mean(tmp1(:));
%         tmp3 = mean(tmp2(:).^2); % 1
%         tmp4 = mean(tm2(:).^2); % 2
%         tmp5 = tmp2.*tm2;
%         tmp6 = mean(tmp5(:)); % 3
%         tt2(ii,jj) = tmp3 - tmp6^2/tmp4;
%     end
% end
% % assert: tt1(2:8,2:8) == tt2(2:8,2:8)

% % test2
% img = double(imread('cameraman.tif'));
% tt = img(56:86,147:171);
% out1 = imfilter(img,tt,'corr',0);
% out2 = image_xcorr(img,tt);
% figure;imshow(tt,[]);
% figure;imshow(out1,[]);
% figure;imshow(out2,[]);
% [tmp1,tmp2] = extrema2(out2);
% % assert tmp1 == 1;
% [I,J] = ind2sub(size(img),tmp2(1));
% hold on;
% plot(J,I,'y+','markersize',30);
% hold off;
