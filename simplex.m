clc;
clear;
close all;

% Objective function Z = 10x + 12y ( Maximize )
 
% STEP 1 - Inputs : A , b , C , Cb 
A = [4 6 1 0; 3 8 0 1];    % Coefficients of variables in constraints (x, y, S1, S2, A1, A2)

b = [240; 300];                      % RHS of constraints
C = [10 12 0 0];              % Objective function
Cb = [0; 0];                  % Initial basic variable costs

% STEP 2 - Size of A matrix : m rows , n columns
[m, n] = size(A);

% STEP 3 - Create Augmented matrix S as S= [ A b ]
S = [A b];                          % Augmented matrix for simplex

% STEP 4 -  Start while true loop 
while true
    % Step 4.1: Calculate Zj - Cj
    Zj = Cb' * A - C;
    % Step 4.2: Check optimality
    if all(Zj >= 0)
        disp("Optimal solution found.");
        break;
    end

    % Step 4.3: Entering Variable -> Pivot column (most negative Zj-Cj)
    [~, pc] = min(Zj);

    % Step 4.4: Leaving Variable -> Pivot row (min positive ratio)
    ratios = b ./ A(:, pc);
    ratios(ratios <= 0) = Inf;
    [~, pr] = min(ratios);

    % Step 4.5: Modifying the Simplex Table - Pivot operations
    pivot = A(pr, pc); % Key element : intersection of pivot-row and pivot-column
    S(pr, :) = S(pr, :) / pivot; % Updating the Key Row elements ->  Key row elements/ Key element ( pr x pc )

    for i = 1:m
        if i ~= pr % Remaining Rows 
            S(i, :) = S(i, :) - S(i, pc) * S(pr, :); % Updating remaining rows -> old row elements - corresponding pivot column element * updated pivot row  
        end
    end

    % Update A, b, and Cb
    A = S(:, 1:n);
    b = S(:, end);
    Cb(pr) = C(pc);
end

% STEP 5 - Extract solution
solution = zeros(n, 1);
for i = 1:n
    col = A(:, i); % Extracted a column
    if sum(col == 1) == 1 && sum(col) == 1 % Checks if extracted col is corresponding to basic variable => only 1 count=1 and sum of elements =1
        solution(i) = b(col == 1); % Picks element from b matrix to that row which has 1 
    end
end

% STEP 6 - Display results
disp("Optimal Variable Values:");
disp(solution);

disp("Optimal Value of Z:");
Z = Cb' * b;
disp(Z);

% Output

% Optimal solution found.
% Optimal Variable Values:
%    60.0000
%          0
%          0
%   120.0000

% Optimal Value of Z:
%   600.0000

