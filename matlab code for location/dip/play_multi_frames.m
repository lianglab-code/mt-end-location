function play_multi_frames(plot_rows,plot_cols,frames,varargin)
%PLAY_FRAMES displays frames in img.

n_varargs = length(varargin);

figure;

for i = 1:n_varargs
    imgs_4d(:,:,:,i) = varargin{i};
end

for i = 1:frames
    for j = 1:n_varargs
        subplot(plot_rows, plot_cols, j);
        imagesc(imgs_4d(:,:,i,j));
        axis square;
    end
    drawnow;
    pause(0.1);
end
