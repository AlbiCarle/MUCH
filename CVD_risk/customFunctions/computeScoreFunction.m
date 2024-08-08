function s = computeScoreFunction(Xfc, cf_class, Xcf, kernel, param, Xtr_star_class, Ytr_star_class, x_star_class, xb, tau1, tau2,flag) 

if isequal(flag,'centreofmass')
    n_rows=size(Xfc,1);
    
    s=zeros(n_rows, 1);

    for i = 1:size(s,1)       
        d1 = computeMixedDistance(Xfc(i, :), Xcf(i, :), 4); % distance vector between the factual and the counterfactual
        d2 = computeMixedDistance(xb, Xcf(i, :), 4);  %distance vector between the counterfactual and the barycenter of the target class
    end     
else
    K = KernelMatrix(Xfc, Xcf, kernel, param);
    d1 = 2*(1-diag(K)); % distance vector between the factual and the counterfactual for gaussian kernel
    d2 = NDistanceFromCenter(Xtr_star_class{y},Ytr_star_class{y},x_star_class{y},Xcf,kernel,param); % distance between counterfactual and the centre of its class
end
    s = tau1*d1 + tau2*d2;
end