function [Xy_sampled] = ...
    Halton_sampling_MultiSVDD_FIFA(Xtr, Ytr, Ytr_class, Num_class, x_class, kernel, param_star, Rsquared_class)

n_seq_halton=1000;
Xy_sampled={};

for i=1:Num_class %sample each class separately
    
    X_learn = [Xtr,Ytr];
        
    X = X_learn(X_learn(:,45)==i,:);%X_learn(X_learn(:,50)==i,:); %restringo training set ai punti della classe
    X = X(:,1:44);%X(:,1:49);

    index_vet = 1:Num_class;
    index_vet =index_vet(index_vet~=i); %remove index i -> gets all the other classes
    Xn = [];

    %create Halton sequence
    p_halton=haltonset(1);
    halton_seq=net(p_halton,500000); %
    disp(i)
    
    while (size(Xn,1)<1000)

        C_camp = [];
        %INC = mean(mean(X))/4; %To narrow point cloud, it's okay because features are in the same range
        for j = 1:size(X,2) 

            if (j==6 || j==7 || j==8 || j == 9) % categorical variables
                X_j = randi([min(X(:,j)),max(X(:,j))],1,n_seq_halton)';
            else  
                INC_j = mean(X(:,j))/4;
                X_j = (min(X(:,j))+INC_j)+((max(X(:,j))-INC_j)-(min(X(:,j))+INC_j))*randsample(halton_seq,n_seq_halton);
            end

                C_camp = [C_camp,X_j];

        end

        %evaluate distances from centers
        Tts1 =  NDistanceFromCenter(Xtr,Ytr_class{1},x_class{1},C_camp,kernel,param_star);        
        Tts2 =  NDistanceFromCenter(Xtr,Ytr_class{2},x_class{2},C_camp,kernel,param_star);
        Tts3 =  NDistanceFromCenter(Xtr,Ytr_class{3},x_class{3},C_camp,kernel,param_star);
        Tts4 =  NDistanceFromCenter(Xtr,Ytr_class{4},x_class{4},C_camp,kernel,param_star);
       

        Tts={Tts1,Tts2, Tts3,Tts4};

        %check if the point is inside region i and outside regions index_vet~=i 
        Xn_tmp = C_camp(((Tts{i}-Rsquared_class{i} <0)).*...
            (Tts{index_vet(1)}-Rsquared_class{index_vet(1)}>0).*...
            (Tts{index_vet(2)}-Rsquared_class{index_vet(2)}>0).*...
            (Tts{index_vet(3)}-Rsquared_class{index_vet(3)}>0)==1,:); %points in class i
        
        Xn = [Xn; Xn_tmp];
        disp(size(Xn,1));
    end

    yn = NC_SVDD_TEST(Xtr, Ytr_class, Num_class, x_class, Xn, kernel, param_star, Rsquared_class);
          
    Xy_sampled_i = [Xn, yn];
    Xy_sampled{i}=Xy_sampled_i;
end
