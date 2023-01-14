function [y, k_dist] = ...
    NC_SVDD_TEST(Xtr, Ytr_class, Num_class, x_class, Xts, kernel, param, Rsquared_class)

% Function which tests a multiclass-SVDD:
% Xtr: training set
% Ytr_class: cell array with the target vectors of each class
% Num_class: number of classes
% x_class: lagrange multipliers computed by NC_SVDD_TRAINING
% Xts: test set
% kernel: kernel function (linear, polynomial, gaussian)
% param: kernel parameter
% Rsquared_class: cell array containing the square radius of the SVDD
% computing by NC_SVDD_TRAINING

y=zeros(size(Xts,1),1);

N=size(Xtr,1);

k_dist = {};

for i = 1:Num_class

    k_dist{i} = NDistanceFromCenter(Xtr,Ytr_class{i},x_class{i},Xts,kernel,param);
    %TestObject_N(Xtr, Ytr_class{i}, x_class{i}, Xts, kernel, param);

end

%INC = 10^(10);
        
for i = 1:size(Xts,1)
    for k = 1:Num_class
        for h = 1:Num_class
            if(h~=k)
                
                if(k_dist{k}(i)-Rsquared_class{k}<=0 ...
                        && k_dist{h}(i)-Rsquared_class{h}>0)
                    y(i) = k;
                
                elseif(k_dist{k}(i)-Rsquared_class{k}<=0 ...
                        && k_dist{h}(i)-k_dist{k}(i)<0)
                    y(i) = h;

                elseif(k_dist{k}(i)-Rsquared_class{k}<=0 ...
                        && k_dist{k}(i)-k_dist{h}(i)<0)
                    y(i) = k;

                end

            end

        end
    end
end

end

 %if(floor((k_dist{k}(i)-Rsquared_class{k})*INC)<=0 ...
  %                      && floor((k_dist{h}(i)-Rsquared_class{h})*INC)>0)
   %                 y(i) = k;
                
    %            elseif(floor((k_dist{k}(i)-Rsquared_class{k})*INC)<=0 ...
    %                    && floor((k_dist{h}(i)-k_dist{k}(i))*INC)<0)
     %               y(i) = h;

      %          elseif(floor((k_dist{k}(i)-Rsquared_class{k})*INC)<=0 ...
       %                 && floor((k_dist{k}(i)-k_dist{h}(i))*INC)<0)
       %             y(i) = k;
