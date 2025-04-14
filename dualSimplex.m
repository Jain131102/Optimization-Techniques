clc;
clear;

% STEP 1 - Inputs : A , b , C , Cb 
A = [-2  -1 1 0;
     -1 -3 0 1];

b = [-2; -3];
C = [3 2 0 0]; % Maximize Z= 3x + 2y + 0S1+0S2
Cb = [0; 0];

[m, n] = size(A);
S = [A b];

while true
    % Step 4.1: Calculate Zj and Zj - Cj
    Zj = Cb' * A - C;

    % Step 4.2: Check optimality (only b >= 0 is needed in Dual Simplex)
    if all(b >= 0)
        disp("Optimal solution found.");
        break;
    end

    % Step 4.3: Leaving Variable (most negative b)
    [~, pr] = min(b);

    % Step 4.4: Entering Variable (max ratio Zj / a_ij where a_ij < 0)
    row = A(pr, :);     % Extract the pivot row
    
    % Initialize ratio array with -Inf to ignore non-eligible entries
    ratios = -Inf(1, n);
    
    % Loop through columns to compute ratios only for negative entries
    for j = 1:n
        if row(j) < 0
            ratios(j) = Zj(j) / row(j);
        end
    end
    
    % Choose the column with the maximum ratio (Dual Simplex rule)
    [~, pc] = max(ratios);

    % Step 4.5: Pivot operation
    pivot = A(pr, pc);
    S(pr, :) = S(pr, :) / pivot;
    for i = 1:m
        if i ~= pr
            S(i, :) = S(i, :) - S(i, pc) * S(pr, :);
        end
    end

    % Update A, b, Cb
    A = S(:, 1:n);
    b = S(:, end);
    Cb(pr) = C(pc);
end

% STEP 5 - Extract solution
solution = zeros(n, 1);
for i = 1:n
    col = A(:, i);
    if sum(col == 1) == 1 && sum(col) == 1
        solution(i) = b(col == 1);
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
%      3
%      0
%      4
%      0

% Optimal Value of Z:
%      9


