clc; clear; close all;

% Assuming given problem is a balanced problem
supply = [25 30 20];    
demand = [10 15 25 25];  
cost = [5 8 10 12; 6 9 11 13; 7 10 12 14];

[m, n] = size(cost);
allocation = zeros(m, n);

%% Compute Initial Basic Feasible Solution (North West Corner)
supply_left = supply;
demand_left = demand;
i = 1; j = 1;
while i <= m && j <= n
    alloc = min(supply_left(i), demand_left(j));
    allocation(i, j) = alloc;
    supply_left(i) = supply_left(i) - alloc;
    demand_left(j) = demand_left(j) - alloc;
    if supply_left(i) == 0 && i < m
        i = i + 1;
    elseif demand_left(j) == 0 && j < n
        j = j + 1;
    elseif supply_left(i)==0 && demand_left(j)==0 && i < m && j < n
        i = i + 1;
        j = j + 1;
    else
        break;
    end
end

disp('Initial Basic Feasible Solution (NW Corner):');
disp(allocation);

a=allocation.*cost;
sum=sum(a(:));

disp("Minimum transportation cost :");
disp(sum);

% Output
% Initial Basic Feasible Solution (NW Corner):
%     10    15     0     0
%      0     0    25     5
%      0     0     0    20

% Minimum transportation cost :
%    790


