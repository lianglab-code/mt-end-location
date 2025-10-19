function play_frames(img)
%PLAY_FRAMES displays frames in img.

[m,n,f] = size(img);

figure;
for i = 1:f
    imagesc(img(:,:,i));
    axis square;
    drawnow;
    pause(0.1);
end
