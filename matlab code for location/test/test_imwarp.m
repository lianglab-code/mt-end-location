function test_imwarp()

% source
% https://www.mathworks.com/matlabcentral/answers/67114-what-is-the-difference-between-imwarp-and-imtransform
% https://www.mathworks.com/help/images/examples/creating-a-gallery-of-transformed-images.html
% https://blogs.mathworks.com/steve/2013/08/28/introduction-to-spatial-referencing/?s_tid=srchtitle

%% imtransform
is_imtransform = true;
if is_imtransform
    % Read and display image
    I = imread('pout.tif');
    figure;imshow(I);
    % Create geometric transformation
    T = [1 -sin(pi/4) 0; sin(pi/4) 1 0; 0 0 1];
    tform = maketform('affine', T);
    % Define input spatial referencing
    udata = [-1 1];
    vdata = [-1 1];
    % Define output spatial referencing
    xdata = [-0.8 0.8];
    ydata = [-0.8 0.8];
    output_size = round(size(I)/8);
    % Apply geometric transformation to image
    J = imtransform(I, tform, 'UData', udata, 'VData', vdata, ...
                    'XData', xdata, 'YData', ydata, ...
                    'Size', output_size);
    % Display transformed image
    figure;imshow(J);
end

%% imwarp
is_imwarp = true;
if is_imwarp
    % Read and display image
    I = imread('pout.tif');
    figure;imshow(I);
    % Create geometric transformation object
    T = [1 -sin(pi/4) 0; sin(pi/4) 1 0; 0 0 1];
    tform = affine2d(T);
    % Define input spatial referencing. World limits of input image are from
    % -1 to 1 in both X and Y directions.
    RI = imref2d(size(I),[-1 1],[-1 1]);
    % Define output spatial referencing. World limits out output image are
    % from -0.8 to 0.8 in both X and Y directions. Output grid size is 1/8
    % that of the input image.
    Rout = imref2d(round(size(I)/8),[-0.8 0.8],[-0.8 0.8]);
    % Apply geometric transformation to image
    [J,RJ] = imwarp(I,RI,tform,'OutputView',Rout);
    % Display transformed image
    figure;imshow(J,RJ)
end
