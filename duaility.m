clear
clc

% Inputs : A b C  

% Primal : Drug A >=84
%Drug B >=120
% M   N
%A 10  2 >=84
%B 8   4 >=120
%C = 3x + y ( Minimize )

% Dual:
% Constraints:
% 10x+8y<=3
% 2x+4y<=1
% Z= 84x+120y
% x,y,S1,S2>=0
% Standard forms:
% 10x+8y+S1=3
% 2x+4y+S2=1

% Coefficient matrix for constraints
A = [10 8 1 0;
      2 4 0 1 ];

% RHS of constraints
b = [3;1];

% Objective function coefficients (Z=84x+120y+0S1+0S2)
C =[84 120 0 0]; % Coefficients of the objective function
Cb = [0;0];      % Initial basic variable coefficients 

% Dimensions of A
[m, n] = size(A);

% Initialize Zj-Cj values
Zj = zeros(1, n);

% Augmented simplex table
S = [A, b];

% Simplex Iteration
while true
    % Step 1: Calculate Zj - Cj
    for i = 1:n
        Zj(i) = Cb' * A(:, i) - C(i);
    end
    
    % Display Zj-Cj
    disp("Zj-Cj:");
    disp(Zj);
    
    % Step 2: Check optimality
    if all(Zj >= 0)
        disp("Optimal solution found.");
        break;
    else
        disp("Solution is not optimal, proceeding with iteration.");
    end
    
    % Step 3: Find pivot column (most negative Zj-Cj)
    [min_Zj, pivot_col] = min(Zj);
    disp("Pivot Column: " + pivot_col);
    
    % Step 4: Find pivot row (minimum positive ratio)
    ratios = b ./ A(:, pivot_col);
    ratios(ratios <= 0) = Inf; % Ignore negative or zero entries
    [min_ratio, pivot_row] = min(ratios);
    
    % Check for unboundedness
    if isinf(min_ratio)
        error("The problem is unbounded.");
    end
    disp("Pivot Row: " + pivot_row);
    
    % Step 5: Perform pivoting
    key_element = A(pivot_row, pivot_col);
    disp("Key Element: " + key_element);
    
    % Normalize the pivot row
    S(pivot_row, :) = S(pivot_row, :) / key_element;
    
    % Update the other rows
    for i = 1:m
        if i ~= pivot_row
            S(i, :) = S(i, :) - S(i, pivot_col) * S(pivot_row, :);
        end
    end
    
    % Update Cb and b
    Cb(pivot_row) = C(pivot_col);
    b = S(:, end);
    
    % Update A
    A = S(:, 1:n);

    % Display modified simplex table
    disp("Modified Simplex Table:");
    disp(S);
end

% Step 6: Display the final solution
disp("Final Simplex Tableau:");
disp(S);

% Initialize basic variable solutions as zeros
basic_solution = zeros(n, 1);

% Extract basic variables from tableau
for i = 1:m
    % Find the column with a single '1' in the current row
    for j = 1:n
        if A(i, j) == 1 && sum(A(:, j) == 1) == 1
            basic_solution(j) = b(i); % Assign value from RHS
            break;
        end
    end
end

% Display results
disp("Optimal Solution for Dual:");
disp(basic_solution);

% Calculate and display the optimal value
disp("Optimal Value for Dual:");
optimal_value = Cb' * b;
disp(optimal_value); % Negate for minimization problem


%Output

% Zj-Cj:
%      -84           -120              0              0       

% Solution is not optimal, proceeding with iteration.
% Pivot Column: 2
% Pivot Row: 2
% Key Element: 4
% Modified Simplex Table:
%   Columns 1 through 4

%        6              0              1             -2       
%        1/2            1              0              1/4     

%   Column 5

%        1       
%        1/4     

% Zj-Cj:
%      -24              0              0             30       

% Solution is not optimal, proceeding with iteration.
% Pivot Column: 1
% Pivot Row: 1
% Key Element: 6
% Modified Simplex Table:
%   Columns 1 through 4

%        1              0              1/6           -1/3     
%        0              1             -1/12           5/12    

%   Column 5

%        1/6     
%        1/6     

% Zj-Cj:
%        0              0              4             22       

% Optimal solution found.
% Final Simplex Tableau:
%   Columns 1 through 4

%        1              0              1/6           -1/3     
%        0              1             -1/12           5/12    

%   Column 5

%        1/6     
%        1/6     

% Optimal Solution for Dual:
%        1/6     
%        1/6     
%        0       
%        0       

% Optimal Value for Dual:
%       34       

