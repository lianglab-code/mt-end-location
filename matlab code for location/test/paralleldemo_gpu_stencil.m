function paralleldemo_gpu_stencil()

    gridSize = 500;
    numGenerations = 100;
    initialGrid = (rand(gridSize,gridSize) > .75);
    gpu = gpuDevice();

    % Draw the initial grid
    hold off
    imagesc(initialGrid);
    colormap([1 1 1;0 0.5 0]);
    title('Initial Grid');

    function X = updateGrid(X, N)
        p = [1 1:N-1];
        q = [2:N N];
        % Count how many of the eight neighbors are alive.
        neighbors = X(:,p) + X(:,q) + X(p,:) + X(q,:) + ...
            X(p,p) + X(q,q) + X(p,q) + X(q,p);
        % A live cell with two live neighbors, or any cell with
        % three live neighbors, is alive at the next step.
        X = (X & (neighbors == 2)) | (neighbors == 3);
    end

    grid = initialGrid;
    % Loop through each generation updating the grid and displaying it
    for generation = 1:numGenerations
        grid = updateGrid(grid, gridSize);

        imagesc(grid);
        title(num2str(generation));
        drawnow;
    end
    
    grid = initialGrid;
    timer = tic();

    for generation = 1:numGenerations
        grid = updateGrid(grid, gridSize);
    end

    cpuTime = toc(timer);
    fprintf('Average time on the CPU: %2.3fms per generation.\n', ...
            1000*cpuTime/numGenerations);
    
    expectedResult = grid;
    
    grid = gpuArray(initialGrid);
    timer = tic();

    for generation = 1:numGenerations
        grid = updateGrid(grid, gridSize);
    end

    wait(gpu); % Only needed to ensure accurate timing
    gpuSimpleTime = toc(timer);

    % Print out the average computation time and check the result is unchanged.
    fprintf(['Average time on the GPU: %2.3fms per generation ', ...
             '(%1.1fx faster).\n'], ...
            1000*gpuSimpleTime/numGenerations, cpuTime/gpuSimpleTime);
    assert(isequal(grid, expectedResult));
    
    grid = gpuArray(initialGrid);

    function X = updateParentGrid(row, col, N)
    % Take account of boundary effects
        rowU = max(1,row-1);  rowD = min(N,row+1);
        colL = max(1,col-1);  colR = min(N,col+1);
        % Count neighbors
        neighbors ...
            = grid(rowU,colL) + grid(row,colL) + grid(rowD,colL) ...
            + grid(rowU,col)                   + grid(rowD,col) ...
            + grid(rowU,colR) + grid(row,colR) + grid(rowD,colR);
        % A live cell with two live neighbors, or any cell with
        % three live neighbors, is alive at the next step.
        X = (grid(row,col) & (neighbors == 2)) | (neighbors == 3);
    end


    timer = tic();

    rows = gpuArray.colon(1, gridSize)';
    cols = gpuArray.colon(1, gridSize);
    for generation = 1:numGenerations
        grid = arrayfun(@updateParentGrid, rows, cols, gridSize);
    end

    wait(gpu); % Only needed to ensure accurate timing
    gpuArrayfunTime = toc(timer);

    % Print out the average computation time and check the result is unchanged.
    fprintf(['Average time using GPU arrayfun: %2.3fms per generation ', ...
             '(%1.1fx faster).\n'], ...
            1000*gpuArrayfunTime/numGenerations, cpuTime/gpuArrayfunTime);
    assert(isequal(grid, expectedResult));
    
    fprintf('CPU:          %2.3fms per generation.\n', ...
            1000*cpuTime/numGenerations);
    fprintf('Simple GPU:   %2.3fms per generation (%1.1fx faster).\n', ...
            1000*gpuSimpleTime/numGenerations, cpuTime/gpuSimpleTime);
    fprintf('Arrayfun GPU: %2.3fms per generation (%1.1fx faster).\n', ...
            1000*gpuArrayfunTime/numGenerations, cpuTime/gpuArrayfunTime);
end