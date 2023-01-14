function [Xy_sampled] = ...
    Halton_sampling_MultiSVDD(Xtr, Ytr, Ytr_class, Num_class, x_class, kernel, param_star, Rsquared_class)

% Function that samples the data from Halston sequences

n_seq_halton=1000;
Xy_sampled={};

for i=1:Num_class %sample each class separately
    
    X_learn = [Xtr,Ytr];
    m = size(X_learn,2);
        
    X = X_learn(X_learn(:,m)==i,:); %restrict training set to class points.
    X = X(:,1:m-1);

    index_vet = 1:Num_class;
    index_vet =index_vet(index_vet~=i); %remove index i -> gets all the other classes
    Xn = [];

    %create Halton sequence
    p_halton=haltonset(1);
    halton_seq=net(p_halton,500000); %Halton sequence of 5000 numbers between 0 and 1
    disp(i)
    
    while (size(Xn,1)<5000)

        C_camp = [];
        %INC = mean(mean(X))/4; 
        for j = 1:size(X,2) 

            %if (j==6 || j==7 || j==8 || j == 9) % categorical variable (if any)
            %    X_j = randi([min(X(:,j)),max(X(:,j))],1,n_seq_halton)';
            %else  
                INC_j = mean(X(:,j))/4;
                X_j = (min(X(:,j))+INC_j)+((max(X(:,j))-INC_j)-(min(X(:,j))+INC_j))*randsample(halton_seq,n_seq_halton);
           % end

                C_camp = [C_camp,X_j];

        end

        %evaluate distances from centers
        
        Tts = {};

        for k = 1:Num_class 

            Tts_k =  NDistanceFromCenter(Xtr,Ytr_class{k},x_class{k},C_camp,kernel,param_star); 
            Tts{k} = Tts_k;

        end

        %check if the point is inside region i and outside regions index_vet~=i 

        prod = (Tts{i}-Rsquared_class{i} <0);

        for k = 1:Num_class-1

            prod  = prod.*(Tts{index_vet(k)}-Rsquared_class{index_vet(k)}>0);
                
        end 

        Xn_tmp = C_camp(prod==1,:); %points in class i

        Xn = [Xn; Xn_tmp];
        disp(size(Xn,1));
    end

    yn = NC_SVDD_TEST(Xtr, Ytr_class, Num_class, x_class, Xn, kernel, param_star, Rsquared_class);
          
    Xy_sampled_i = [Xn, yn];
    Xy_sampled{i}=Xy_sampled_i;
end
