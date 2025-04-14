% Hungarian Algorithm 
clc; clear;

%% Example Cost Matrix (minimization problem)
% Input -> costMatrix
costMatrix = [10  3  3  2 8;
              9 7 8 2 7;
              7 5 6 2 4;
              3 5 8 2 4
              9 10 9 6 10];

%% Step 0: Check if the problem is balanced (square matrix)
[m, n] = size(costMatrix);
if m ~= n
    fprintf('The problem is unbalanced. Balancing the matrix by adding dummy rows/columns.\n');
    if m < n
        costMatrix = [costMatrix; zeros(n - m, n)];
    else
        costMatrix = [costMatrix, zeros(m, m - n)];
    end
    [m, n] = size(costMatrix);
end

fprintf('Balanced Cost Matrix:\n');
disp(costMatrix);

%% Step 1: Row Reduction
rowMin = min(costMatrix, [], 2);
rowRed = costMatrix - repmat(rowMin, 1, n);
fprintf('Row Reduced Matrix:\n');
disp(rowRed);

%% Step 2: Column Reduction
colMin = min(rowRed, [], 1);
colRed = rowRed - repmat(colMin, m, 1);
fprintf('Column Reduced Matrix:\n');
disp(colRed);

%% Step 3: Initial Zero Marking (Starring)
mask = zeros(n);  % 0: no mark, 1: starred zero, 2: primed zero.
rowCover = zeros(n,1);
colCover = zeros(n,1);

for i = 1:n
    for j = 1:n
        if colRed(i,j) == 0 && ~rowCover(i) && ~colCover(j)
            mask(i,j) = 1;   % Star the zero.
            rowCover(i) = 1; % Mark row as having a starred zero.
            colCover(j) = 1; % Mark column as having a starred zero.
        end
    end
end

% Clear covers for the next steps.
rowCover(:) = 0;
colCover(:) = 0;

% Cover each column containing a starred zero.
for j = 1:n
    if any(mask(:, j) == 1)
        colCover(j) = 1;
    end
end

%% Step 4: Main Loop of the Algorithm
while sum(colCover) < n
    % Find an uncovered zero.
    uncovered = (colRed == 0) & (repmat(rowCover, 1, n) == 0) & (repmat(colCover', n, 1) == 0);
    [r, c] = find(uncovered, 1);
    
    while isempty(r)
        % Adjust the matrix if no uncovered zero is found.
        minVal = min(min(colRed(rowCover==0, colCover==0)));
        colRed(rowCover==1, :) = colRed(rowCover==1, :) + minVal;
        colRed(:, colCover==0) = colRed(:, colCover==0) - minVal;
        uncovered = (colRed == 0) & (repmat(rowCover, 1, n) == 0) & (repmat(colCover', n, 1) == 0);
        [r, c] = find(uncovered, 1);
    end
    
    % Prime the uncovered zero.
    mask(r, c) = 2;
    
    % Check for a starred zero in the same row.
    starCol = find(mask(r, :) == 1, 1);
    if ~isempty(starCol)
        rowCover(r) = 1;
        colCover(starCol) = 0;
    else
        % Construct an augmenting path.
        path = [r, c];
        done = false;
        while ~done
            last_col = path(end, 2);
            r_index = find(mask(:, last_col) == 1, 1);
            if isempty(r_index)
                done = true;
            else
                path = [path; r_index, last_col]; %#ok<AGROW>
                c_index = find(mask(path(end,1), :) == 2, 1);
                path = [path; path(end,1), c_index]; %#ok<AGROW>
            end
        end
        
        % Augment the path: star primed zeros and unstar starred zeros.
        for i = 1:size(path, 1)
            if mask(path(i,1), path(i,2)) == 1
                mask(path(i,1), path(i,2)) = 0;
            else
                mask(path(i,1), path(i,2)) = 1;
            end
        end
        
        % Reset covers and erase all primes.
        rowCover(:) = 0;
        colCover(:) = 0;
        mask(mask == 2) = 0;
        
        % Cover columns with starred zeros.
        for j = 1:n
            if any(mask(:, j) == 1)
                colCover(j) = 1;
            end
        end
    end
end

%% Step 5: Final Assignment
assignment = zeros(n,1);
for i = 1:n
    j = find(mask(i, :) == 1, 1);
    if ~isempty(j)
        assignment(i) = j;
    else
        assignment(i) = 0;
    end
end

fprintf('Final Assignment (row -> column):\n');
disp(assignment);

% Create and display the Assignment Matrix.
assignmentMatrix = zeros(n);
for i = 1:n
    if assignment(i) > 0
        assignmentMatrix(i, assignment(i)) = 1;
    end
end

fprintf('Assignment Matrix (1 indicates the chosen assignment):\n');
disp(assignmentMatrix);

% Compute the final cost using the original cost matrix.
finalCost = 0;
for i = 1:n
    finalCost = finalCost + costMatrix(i, assignment(i));
end
fprintf('Final Cost: %d\n', finalCost);


% Question 1 : Cost Matrix = [21 16 25 43; 25 18 14 53; 32 27 18 41]

% Input - >   costMatrix = [21 16 25 43; 25 18 14 53; 32 27 18 41];

% Output ->
% The problem is unbalanced. Balancing the matrix by adding dummy rows/columns.
% Balanced Cost Matrix:
%     21    16    25    43
%     25    18    14    53
%     32    27    18    41
%      0     0     0     0

% Row Reduced Matrix:
%      5     0     9    27
%     11     4     0    39
%     14     9     0    23
%      0     0     0     0

% Column Reduced Matrix:
%      5     0     9    27
%     11     4     0    39
%     14     9     0    23
%      0     0     0     0

% Final Assignment (row -> column):
%      1
%      2
%      3
%      4

% Assignment Matrix (1 indicates the chosen assignment):
%      1     0     0     0
%      0     1     0     0
%      0     0     1     0
%      0     0     0     1

% Final Cost: 57

