function ps = get_poly_line(img)
%% GET_POLY_LINE allows the user to use draw a polyline on an image.
%
% Input:
% img: 2d image
%
% Output:
% ps: n rows for two points [x1,y1;...;xn,yn]

    h_fig = figure;
    imshow(img(:,:,1),[]);
    set(gca,'position',[0.05,0.05,0.9,0.9]);
    h_line = impoly(gca,'closed',false);
    setColor(h_line,[1,0,0]);
    % you need to double click the endpoints
    ps = wait(h_line);
    disp('selection done');
end
