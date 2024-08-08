function [counterfactuals] = computeCF_MUCH(num_classes,n_feats, Xts,y_pred_ts, kernel, param_star, f_class, Xy_sampled_norm,actionable,header,S,C,checkRangesFlag)
% Function which creates a set of counterfactuals with class c!=f_class starting from a factual in class f_class
% num_classes: number of output classes
% n_feats: number of input features
% Xts: test set 
% y_pred_ts: predicted output (test set)
% kernel: kernel function (linear, polynomial, gaussian)
% param_star: kernel parameter
% f_class: factual class
% Xy_sampled_norm: set of points sampled with quasi-random Halton sequence with
% corresponding predicted output (normalized)
%actionable: if 1 we add constraints in terms of non-modifiable features
%header: input and output labels
%S,C: scale and center for de-normalization
%checkRangesFlag: if 1 we add constraints in terms of valid clinical ranges
%Returns:
%results: cell array with factuals and corresponding counterfactual explanations for each class c!=f_class

results={};
%denormalization of test set and set of candidate points
Xts=Xts(:,1:n_feats).*S+C; 
Xy_sampled = cell(1, 3);
for i = 1:num_classes
    normMatrix = cellArray{i};    
    % Denormalize features
    denormalizedFeatures = normMatrix(:, 1:end-1) .*S + C;
    % Combine denormalized features and output class
    Xy_sampled = [denormalizedFeatures, normMatrix(:, end)];
end
Xy_pred = [Xts, y_pred_ts];
[n,m] = size(Xy_pred);
X_factual = Xy_pred(Xy_pred(:,m) == f_class,:); % select test points predicted as f_class

XC = []; 
YC = 0;

X_candidate=[];
index_vet= 1:num_classes;
index_vet=index_vet(index_vet~=f_class); % all classes but the factual class

for i = 1 : size(X_factual,1) %for each factual
    disp(['Factual --> ',num2str(i)]);
    results{i,1}=[header;num2cell(X_factual(i,:))]; %save i-th factual and relative class in the final table    
    for j = 1 : num_classes-1      
        if actionable == true
            X_candidate=[];         
            Xn=Xy_sampled{index_vet(j)};
            %check all candidate counterfactuals and keep only those that
            %satify the constrains 
            for fa = 1 : size(Xn,1) 
                %constrain non-modifiable features: sex, Diabetes, HTN, and age
                if ((abs(Xn(fa,1)-X_factual(i,1))<= 0.5)  && (abs(Xn(fa,2)-X_factual(i,2))<= 0.5) && ...
                     (abs(Xn(fa,3)-X_factual(i,3))<= 0.5) && (abs(Xn(fa,12)-X_factual(i,12))<= 8) ) %
                    % check & constrain smoking status
                    if ((X_factual(i,4)==2 && Xn(fa,4)>0.5) ||(X_factual(i,4)==1 && Xn(fa,4)>0.5 && Xn(fa,4)<=1.5 ) ||(X_factual(i,4)==0 && Xn(fa,4)<=0.5))
                        if(checkRangesFlag==1)
                            if(checkClinicalRanges(X_factual(i,:),Xn(fa,:))==1) %check clinical ranges
                                X_candidate=[X_candidate;Xn(fa,1:m-1)];
                            end
                        else
                            X_candidate=[X_candidate;Xn(fa,1:m-1)];
                            
                        end
                    end
                end
            end         
        else
            X_candidate = Xy_sampled{index_vet(j)}; % select all SVDD sampled points belonging to class j            
        end
        
         if isempty(X_candidate)==1 %if no candidate points remain after applying actionability constraints     
            XC_j = zeros(1,m); %n.a.
           
         else %find the cf in class j at minimum distance from factual i
            K = KernelMatrix(X_candidate,X_factual(i,1:m-1),kernel, param_star);
            sq_dist = 2*(1-K); 
            sq_minimum = min(sq_dist);
            [indexOpt,~] = find(sq_dist == sq_minimum); 
            XC_j=[X_candidate(indexOpt(1),:),index_vet(j)]; % extract counterfactual and relative class
            
        end
     
     X_candidate=[];
     results{i,j+1}=[header; num2cell(XC_j)]; %save counterfactual of class j in the final table
    end
end