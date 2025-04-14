clc; clear;
syms x;

f = exp(-x) - (x^2)/5;  % Input Function

% STEP 1 - Compute first and second derivatives -> diff(f,x)
d1 = diff(f, x);  % First derivative
d2 = diff(d1, x); % Second derivative

% STEP 2 - Convert symbolic to function -> matlabFunction(d1)
f1 = matlabFunction(d1);
f2 = matlabFunction(d2);

% STEP 3 -Set Initial guess and tolerance = 1e-6
x_k = 0.5;  
tol = 1e-6;

% STEP 4 - Start loop
for i = 1:100  
    x_new = x_k - f1(x_k) / f2(x_k);  % STEP 4.1 - Calc Newton's update
    
    if abs(x_new - x_k) < tol   % STEP 4.2 - Stop if s_new -x_k is less than tol
        break;
    end
    x_k = x_new;    % STEP 4.1 - Update x_k
end

% STEP 5 - Display output
fprintf('Optimal x = %.6f, f(x) = %.6f\n', x_k, subs(f, x_k));

%Output
%Optimal x = -2.455226, f(x) = 10.443443
