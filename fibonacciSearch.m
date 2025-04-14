clc; 
clear all;

syms x;

% Define the symbolic function to minimize
f_sym = x^2 + 54/x;

% Convert symbolic to numeric function
f = matlabFunction(f_sym);

% Interval [a, b]
a = -5; 
b = 15; 
Ld=b-a;
% Number of iterations
n = 7;

% Generate Fibonacci numbers
F = [1, 1];
for i = 3:n+2  
    F(i) = F(i-1) + F(i-2);
end

% Fibonacci Search
for k = 1:n
    L = (F(n-k+1) / F(n+1)) * Ld; 
    x1 = a + L;
    x2 = b - L;
    
    f1 = f(x1);
    f2 = f(x2);
    
    if f1 < f2
        b = x2; % Move left
    else
        a = x1; % Move right
    end
end

% Final optimal estimate
x_opt = (a + b) / 2;
f_opt = f(x_opt);
fprintf('Optimal a = %.6f, b = %.6f\n', a, b);
fprintf('\nMinimum at x = %.4f, f(x) = %.4f\n', x_opt, f_opt);


%Output
%Optimal a = 26.428571, b = 15.000000

%Minimum at x = 20.7143, f(x) = 431.6885

