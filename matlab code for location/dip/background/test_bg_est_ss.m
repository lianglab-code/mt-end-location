% imgs = tif_img_reader('/home/image/proj/neuron_tracing/data/mutA1.tif');
% img = imgs(:,:,40);
[img_h, img_w, num_frames] = size(imgs);

img2 = img;
bg = zeros(size(img));
x = 1:img_w;
w = zeros(size(img));
for ii = 1:img_h
    y = img(ii,:);
    [bg(ii,:),w(ii,:)] = bg_est_ss(x,y,3);
end
img2 = img - bg;

bg2 = zeros(size(img));
x = 1:img_h;
x = x';
img3 = zeros(size(img));
for ii = 1:img_w
    y = bg(:,ii);
    bg2(:,ii) = bg_est_ss(x,y,3);
end

img3 = img - bg2;

t1 = quantile(bg(:),0.1);
t2 = quantile(bg(:),0.9);
figure;imshow(bg,[t1 t2]);
figure;imshow(bg2,[t1 t2]);

t1 = quantile(img(:),0.1);
t2 = quantile(img(:),0.9);
t3 = quantile(img3(:),0.1);
t4 = quantile(img3(:),0.9);
figure;imshow(img,[t1 t2]);
figure;imshow(img-imgbg,[t3 t4]);