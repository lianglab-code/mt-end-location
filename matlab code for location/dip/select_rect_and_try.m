% seed_imgs are a time series of the seeded microtubule
h=figure;imagesc(seed_imgs(:,:,1));
i=0;
while ishandle(h)==1
    i=i+1;
    try
        rect{i}=getrect(h);
    catch
        fprintf('Figure already closed\n');
    end
end
