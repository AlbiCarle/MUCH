function [X_star, Y_star, alpha_star, Rsquared_star, ...
    a_star, SV_star, YSV_star, param_star, i] = ...
    FPRcontrol_MSVDD(X, Y_class, x_class, Rsquared_class, kernel, param, C1, C2, thr, param_opt, class,maxIter)
% X: training set
% Y_class: labels of training set
% x_class: lagrange multipliers of SVDD
% Rsquared: squared radii of the SVDD
% kernel: 'linear, 'gaussian', 'polynomial'
% param: kernel parameter
% C1, C2: SVDD weights
% thr: percentage of FP to be achieved
% param_opt: 'Y' if a parameter optimization is necessary
% maxIter: maximum number of iterations per class
Y = Y_class{class};
alpha = x_class{class};
Rsquared = Rsquared_class{class}; 

[X_star, Y_star, alpha_star, Rsquared_star, ...
    a_star, SV_star, YSV_star, param_star, i] = ...
    ZeroFPR_SVDD(X, Y, alpha, Rsquared, kernel, param, C1, C2, thr, param_opt,maxIter);



