function p12 = get_line(img)
%% GET_LINE allows the user to use draw a line on an image.
%
% Input:
% img: 2d image
%
% Output:
% p12: two rows for two points [x1,y1;x2,y2]

    h_fig = figure;
    imshow(img(:,:,1),[]);
    set(gca,'position',[0,0,1,1]);
    h_line = imline(gca);
    setColor(h_line,[1,0,0]);
    % you need to double click the endpoints
    p12 = wait(h_line); 
    disp('selection done');
end
