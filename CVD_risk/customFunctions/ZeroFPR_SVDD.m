function [X_star, Y_star, alpha_star, Rsquared_star, ...
    a_star, SV_star, YSV_star, param_star, i] = ...
    ZeroFPR_SVDD(X, Y, alpha, Rsquared, kernel, param, C1, C2, threshold, param_opt,maxIter)

% ZeroFPR_SVDD
% X: training set
% Y: labels of training set
% alpha: lagrange multipliers of SVDD
% Rsquared: squared radius of the SVDD
% kernel: 'linear, 'gaussian', 'polynomial'
% param: kernel parameter
% C1, C2: SVDD weights
% threshold: percentage of FP to be achieved
% param_opt: 'Y' if a parameter optimization is necessary
% maxIter: maximum number of iterations per class

i=0;
m = size(X,2);
y_i= SVDD_N1C_TEST(X, Y, alpha, X, kernel, param, Rsquared);

while(i<maxIter)    
    i=i+1;
    X_pred_i=[X,Y,y_i];
    XP_i = X_pred_i(X_pred_i(:,m+2)==1,(1:m));
    XN_i = X_pred_i(X_pred_i(:,m+2)==-1,(1:m)); 
    X_i = [XP_i;XN_i];
    YP_i=X_pred_i(X_pred_i(:,m+2)==1,m+1);
    YN_i=X_pred_i(X_pred_i(:,m+2)==-1,m+1);
    Y_i = [YP_i;YN_i];
    if(isequal(param_opt,'Y'))
        X_opt=X_i(1:1000,:);
        Y_opt=Y_i(1:1000,:);
        intKerPar = linspace(0.1,5,10); 
        [param_star, ~, ~, ~, ~] = ...
            OptimiseParam_NSVDD(X_opt, Y_opt, kernel, 0.5, 3, intKerPar, C1, C2);
    else
        param_star = param;
    end
    
    [alpha, Rsquared_i, a_i, SV_i, YSV_i] = ...
    SVDD_N1C_TRAINING(X_i, Y_i, kernel, param_star, C1, C2,'off');   
    y_i = SVDD_N1C_TEST(X_i, Y_i, alpha, X, kernel, param_star, Rsquared_i); 
    M_i = [y_i Y]; 
    N = nnz(Y_i(:,1)==-1); 
    FP = sum(M_i(:,1)==+1 & M_i(:,2)==-1);
    FPR_i = FP/N;
    if(FPR_i<threshold)% || (abs(FPR_i-FPR_old)<0.01*FPR_old))
        disp('Threshold reached')
        break;
    end
    disp(['Iteration ', num2str(i), '--> FPR = ', num2str(FPR_i)])
end
X_star = X_i; 
Y_star = Y_i;
alpha_star = alpha;
Rsquared_star = Rsquared_i;
a_star = a_i;
SV_star = SV_i;
YSV_star = YSV_i;