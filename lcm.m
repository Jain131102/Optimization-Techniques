clc; clear; close all;

% Supply and Demand
supply = [7 9 18];  % Supply from sources

demand = [5 8 7 14];  % Demand at destinations

% Cost Matrix
cost_matrix = [19 30 50 10; 70 30 40 60 ; 40 8 70 20];

% Number of sources and destinations
[m, n] = size(cost_matrix);

% Initialize allocation matrix
allocation = zeros(m, n);

% Create a copy of the cost matrix to modify during the process
cost_copy = cost_matrix;

% Apply Least Cost Method
while any(supply) && any(demand)
    % Find the least cost cell
    min_val = min(cost_copy(:));
    [min_rows, min_cols] = find(cost_copy == min_val);
    
    % Pick the first occurrence
    i = min_rows(1);
    j = min_cols(1);

    
    % Allocate as much as possible to the least cost cell
    min_alloc = min(supply(i), demand(j));
    allocation(i, j) = min_alloc;
    supply(i) = supply(i) - min_alloc;
    demand(j) = demand(j) - min_alloc;
    
    % Remove exhausted rows/columns by setting their costs to infinity
    if supply(i) == 0
        cost_copy(i, :) = inf;
    end
    if demand(j) == 0
        cost_copy(:, j) = inf;
    end
end

% Compute the total cost by element-wise multiplication
cost_computation = allocation .* cost_matrix;
total_cost = sum(cost_computation(:));

% Display Results
fprintf('Initial Feasible Solution using Least Cost Method:\n');
disp(allocation);

fprintf('Total Transportation Cost: %d\n', total_cost);

% Output

% Initial Feasible Solution using Least Cost Method:
%      0     0     0     7
%      2     0     7     0
%      3     8     0     7

% Total Transportation Cost: 814


