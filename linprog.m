clc;
clear all;
close all;


% Problem:
% Maximize Profit = (3.00 - 2.80) * Corn + (5.00 - 4.55) * Soybeans
% Maximize Profit = 0.20 * Corn + 0.45 * Soybeans
% Subject to:
% 2 * Corn + 1 * Soybeans <= 120 (land constraint)
% 7 * Corn + 30 * Soybeans <= 700 (labor constraint)
% 10 * Corn + 4 * Soybeans <= 200 (fertilizer constraint)
% Corn >= 0, Soybeans >= 0 (non-negativity)

% Inputs for linprog:

% Coefficients of the objective function (maximize 0.20 * Corn + 0.45 * Soybeans)

% Negate for linprog (maximization problem)
f = [-0.20; -0.45];

% Coefficients of the inequality constraints (Ax <= b)
A = [2 1;
     7 30;
     10 4];

% Right-hand side of the inequality constraints
b = [120;
     700;
     200];

% Lower bounds (Corn, Soybeans >= 0)
lb = [0; 0];

% No upper bounds
ub = [];

% No equality constraints
Aeq = [];
beq = [];

% Use linprog to solve the linear program
[x, fval, exitflag, output] = linprog(f, A, b, Aeq, beq, lb, ub)


% Output -

% Optimal solution found.


% x =

%    11.7647
%    20.5882


% fval =

%   -11.6176


% exitflag =

%      1


% output = 

%   struct with fields:

%          iterations: 2
%           algorithm: 'dual-simplex-highs'
%     constrviolation: 0
%             message: 'Optimal solution found.'
%       firstorderopt: 0




