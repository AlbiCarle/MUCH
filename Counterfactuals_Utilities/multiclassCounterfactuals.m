function [counterfactuals] = multiclassCounterfactuals(Xtr, Ytr_class, Num_class, x_class, Xts,y_pred_ts, kernel, param_star, Rsquared_class, f_class, Xy_sampled,actionable,header)
% Function which creates a set of counterfactuals with class c!=i starting from a factual in class i:
% Xtr: training set
% Ytr_class: cell array with the target vectors of each class
% Num_class: number of classes
% x_class: lagrange multipliers computed by NC_SVDD_TRAINING
% Xts: test set
% kernel: kernel function (linear, polynomial, gaussian)
% param: kernel parameter
% Rsquared_class: cell array containing the square radius of the SVDD
% computing by NC_SVDD_TRAINING
%f_class: factual class
%% generating countefactuals

counterfactuals={};
X_pred = [Xts, y_pred_ts];
[n,m] = size(X_pred);
X_factual = X_pred(X_pred(:,m) == f_class,:);% select points of the test set that belong to class f_class

XC = []; %counterfactuals
%X_sampled = Xy_sampled(:,1:m-1);
X_non_mod=[];
index_vet= 1:Num_class;
index_vet=index_vet(index_vet~=f_class); % all classes but the factual class
conta_counter=0;

for i = 1 : size(X_factual,1) %for each factual
    disp(['Factual --> ',num2str(i)])
    %X_non_mod = X_sampled
    tmp=[header;num2cell(X_factual(i,:))];
    counterfactuals{i,1}=tmp; %save i-th factual and relative class in the final table
    for j = 1 : Num_class-1 %for each class different from the factual class
        
        if actionable == true
            X_non_mod=[];
            Xn=Xy_sampled{index_vet(j)};
            for fa = 1 : size(Xn,1) %check all constrained candidate counterfactuals
         
                if (abs(Xn(fa,'...')-X_factual(i,1))<= '...' && ... 
                     abs(Xn(fa,'...')-X_factual(i,2))<= '...')  
                    
                        X_non_mod=[X_non_mod;Xn(fa,1:m-1)];

                end
            end
          
        else
            X_non_mod =Xy_sampled{index_vet(j)}; % select all SVDD sampled points belonging to class j
            X_non_mod = X_non_mod(:,1:m-1);
        end
        
     if isempty(X_non_mod)==1 %se non ci sono punti sul bordo della svdd nell'intorno di età
            A = zeros(1,m);
            XC_j = A;
           
        else
        conta_counter=conta_counter+1;
        %disp ("Size punti candidati "+string(size(X_non_mod)));
        z = X_factual(i,1:m-1);
        K = KernelMatrix(X_non_mod,z,kernel, param_star);
        sq_dist = 2*(1-K); % distance vector between the factual in class i and the candidate counterfactuals in class j
        sq_minimum = min(sq_dist);
        [indexOpt,bb] = find(sq_dist == sq_minimum); % index related to the point at minimum distance
        XC_j=[X_non_mod(indexOpt(1),:),index_vet(j)]; % extract counterfactual and relative class
        %XC = [XC;XC_j];
    end
     
     X_non_mod=[];
     tmp_c=[header; num2cell(XC_j)];
     counterfactuals{i,j+1}=tmp_c; %save counterfactual of class j in the final table
    end
end
