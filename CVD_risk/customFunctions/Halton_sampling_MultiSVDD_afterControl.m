function [Xy_sampled] = ...
    Halton_sampling_MultiSVDD_afterControl(X_star_class, Y_star_class, Ytr_class, Num_class, alpha_star_class, kernel, param_star, Rsquared_star_class, granularity)

n_seq_halton=1000;
Xy_sampled={};

max_thrs = [1, 1, 1, 2, 159, 92, 41,5916, 4.3500, 2.2285, 3.1700, 8.9000, 89.0000, 6.6900];
max_thrs_norm = normalize(max_thrs,'norm',Inf);

for i=1:Num_class % Sample each class separately

    %%%%%%%%%%%% XXXXX %%%%%%%%%%%%

    Xtr = X_star_class{i};
    Ytr = Y_star_class{i};
    
    %%%%%%%%%%%% XXXXX %%%%%%%%%%%%
    
    X_learn = [Xtr,Ytr];
    m = size(X_learn,2);
        
    X = X_learn(X_learn(:,m)==+1,:); % Restringo training set ai punti della classe (+1 perché ora gli passo direttamente
                                     % il vettore con l'hot-encoding della
                                     % class).
    X = X(:,1:m-1);

    index_vet = 1:Num_class;
    index_vet =index_vet(index_vet~=i); % Remove index i -> gets all the other classes.
    Xn = [];

    %%%%%%%%%%%% XXXXX %%%%%%%%%%%%
    
    p_halton=haltonset(1); % Create Halton sequence.
    halton_seq=net(p_halton,500000); % Sequenza di halton di 5000 numeri tra 0 e 1.
    disp(['Sampling set for class ',num2str(i)])
    
    while (size(Xn,1)<granularity) % 5000

        C_camp = [];

        for j = 1:size(X,2) 

            INC_j = 0;%mean(X(:,j))/4; % Per restringere nuvola di punti.                
            X_j = (min(X(:,j))+INC_j)+((max_thrs_norm(j)-INC_j)-(min(X(:,j))+INC_j))*randsample(halton_seq,n_seq_halton);
      
            C_camp = [C_camp,X_j];

        end

        % Evaluate distances from centers.
        
        Tts = {};

        for k = 1:Num_class 

            Tts_k =  NDistanceFromCenter(X_star_class{k},Y_star_class{k},alpha_star_class{k},C_camp,kernel,param_star); 
            Tts{k} = Tts_k;

        end

        % Check if the point is inside region i and outside regions index_vet~=i. 

        prod = (Tts{i}-Rsquared_star_class{i} < 0);

        for k = 1:Num_class-1

            prod  = prod.*(Tts{index_vet(k)}-Rsquared_star_class{index_vet(k)}>0);
                
        end 

        Xn_tmp = C_camp(prod==1,:); % Points in class i.

        Xn = [Xn; Xn_tmp];

        if (rem(size(Xn,1),2) == 0 & size(Xn,1) ~= 0)

            disp(['Size sampling set: ',num2str(size(Xn,1))]);

        end

    end

    yn = NC_SVDD_TEST_afterControl(X_star_class, Y_star_class, Num_class,...
    alpha_star_class, Xn, kernel, param_star, Rsquared_star_class);

    %%%%%%%%%%%% XXXXX %%%%%%%%%%%%

    Xy_sampled_i = [Xn, yn];
    Xy_sampled{i} = Xy_sampled_i;

end
