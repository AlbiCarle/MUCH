%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% FIFA 2023 Multi-Counterfactuals %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% This is the example code used for the classification and extraction
% of multicontrasts from the FIFA 2023 dataset.

% The script is divided as follows:
% 1) Data preprocessing.
% 2) Classification using multiclass SVDD.
% 3) Extraction of counterfactuals.

% The evaluation and visualization of counterfactuals are reported 
% in the SpiderFoundamental.mlx file.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% XXXX %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc; clear all; close all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% XXXX %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

addpath('.../MC-SVDD')
addpath('.../Counterfactuals_Utilities')

%% Data preprocessing 

I = readtable('FIFA_23_clean.csv');

PreferredFoot = char(I.PreferredFoot);
    PreferredFoot(PreferredFoot=='Left ') = '1';
    PreferredFoot(PreferredFoot=='Right') = '2';
    PreferredFoot = str2num(PreferredFoot);
    PreferredFoot(PreferredFoot== 11111) = 1;
    PreferredFoot(PreferredFoot== 22222) = 2;

AttackingWorkRate = char(I.AttackingWorkRate);
    AttackingWorkRate(AttackingWorkRate=='Low   ') = '1';
    AttackingWorkRate(AttackingWorkRate=='Medium') = '2';
    AttackingWorkRate(AttackingWorkRate=='High  ') = '3';
    AttackingWorkRate = str2num(AttackingWorkRate);
    AttackingWorkRate(AttackingWorkRate==111111) = 1;
    AttackingWorkRate(AttackingWorkRate==222222) = 2;
    AttackingWorkRate(AttackingWorkRate==333311) = 3;
    
DefensiveWorkRate = char(I.DefensiveWorkRate);
    DefensiveWorkRate(DefensiveWorkRate=='Low   ') = '1';
    DefensiveWorkRate(DefensiveWorkRate=='Medium') = '2';
    DefensiveWorkRate(DefensiveWorkRate=='High  ') = '3';
    DefensiveWorkRate = str2num(DefensiveWorkRate);
    DefensiveWorkRate(DefensiveWorkRate==111111) = 1;
    DefensiveWorkRate(DefensiveWorkRate==222222) = 2;
    DefensiveWorkRate(DefensiveWorkRate==333311) = 3;
    
X = [table2array(I(:,1:5)),...
        PreferredFoot,...
        table2array(I(:,7)), ...
        AttackingWorkRate, ...
        DefensiveWorkRate, ...
        table2array(I(:,15:49))];

Y = char(I.PositionClass);

Y(Y=='MF') = '1';
Y(Y=='DE') = '2';
Y(Y=='FO') = '3';
Y(Y=='GK') = '4';

Y = str2num(Y);

Y(Y == 11) = 1;
Y(Y == 22) = 2;
Y(Y == 33) = 3;
Y(Y == 44) = 4;

N_sample_per_class = 2000;

X1 = X(Y==1,:);
X1 = X1(randperm(size(X1, 1)), :);
X1 = X1(1:N_sample_per_class,:);
X2 = X(Y==2,:);
X2 = X2(randperm(size(X2, 1)), :);
X2 = X2(1:N_sample_per_class,:);
X3 = X(Y==3,:);
X3 = X3(randperm(size(X3, 1)), :);
X3 = X3(1:N_sample_per_class,:);
X4 = X(Y==4,:);
X4 = X4(randperm(size(X4, 1)), :);
X4 = X4(1:N_sample_per_class,:);

X_red = [X1;X2;X3;X4];
Y_red = [ones(N_sample_per_class,1);
        2*ones(N_sample_per_class,1);
        3*ones(N_sample_per_class,1);
        4*ones(N_sample_per_class,1)];

%X_red = X;
%Y_red = Y;

[Z, C, S] = normalize(X_red,'norm',Inf); % for de-normalizing: X = Z.*S + C

cv = cvpartition(Y_red,'HoldOut',0.3, 'Stratify',true);
idx = cv.test;

Xtr = X_red(~idx,:); Ytr = Y_red(~idx,:);
Xts = X_red(idx,:); Yts = Y_red(idx,:);

figure(1)

gscatter(Xtr(:,2), Xtr(:,44), Ytr,'brgk','.',[7 7]);
    
legend('MF', 'DE', 'FO', 'GK')

%% Multi Class SVDD

% cross-validation

Cpar = [[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1];...
     [1,0.1,0.1,0.1,0.1,1,0.1,0.1,0.1,0.1,1,0.1,0.1,0.1,0.1,1];...
     [1,0,0,0.5,0,1,0,0.5,0,0,1,0.5,0,0,0,1];...
     [1,0.5,0.5,0.5,0.5,1,0.5,0.5,0.5,0.5,1,0.5,0.5,0.5,0.5,1];...
     [1,5,5,5,5,1,5,5,5,5,1,5,5,5,5,1];...
     [100,0.5,0.5,0,0.5,1,0,0,0.5,0,1,0,0.5,0,0,1];...
     [0.1,0,0,0,0,0.1,0,0,0,0,0.1,0,0,0,0,0.1]
     [100,0.5,0.5,0,0.5,1,0,0,0.5,0,1,0,0.5,0,0,1];...
     [0.1,0,0,0,0,0.1,0,0,0,0,0.1,0,0,0,0,0.1]];

KerPar = linspace(1, 70, 70);

kernel = 'gaussian';
Num_class = size(unique(Y),1);

[param_star, C_star, err_matrix] = ...
    CV_MultiSVDD(Xtr, Ytr, kernel,2, KerPar,Cpar);

%param_star = 70;
%C_star = [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1];%[1000, 0, 100, 0, 10, 1, 0, 0, 10, 0, 1, 0, 100, 0, 0, 1];%[1,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1];

% Multi Class SVDD

[x_class, Ytr_class, Rsquared_class, a_class, SV_class, YSV_class]=...
    NC_SVDD_TRAINING(Xtr, Ytr, Num_class, kernel, param_star, C_star);

% Evaluation of the model

[y_pred, k_dist] = ...
    NC_SVDD_TEST(Xtr, Ytr_class, Num_class, x_class, Xtr, kernel, param_star, Rsquared_class);

%training

CM = ConfusionMatrix(Ytr, y_pred, Num_class)

figure(2)

cm = confusionchart(Ytr, y_pred);

accuracy = sum(diag(CM))/size(Ytr,1);

%test

[y_preds, k_dist2] = ...
    NC_SVDD_TEST(Xtr, Ytr_class, Num_class, x_class, Xts, kernel, param_star, Rsquared_class);

CMs = ConfusionMatrix(Yts, y_preds, Num_class)

figure(3)

cms = confusionchart(Yts, y_preds);

accuracy2 = sum(diag(CMs))/size(Yts,1);


%% Extraction of the Counterfactuals

% sampling of SVDD boundary and internal points using Halton quasi-random sampling
Xy_sampled = Halton_sampling_MultiSVDD(Xtr, Ytr, Ytr_class, Num_class, x_class, kernel, param_star, Rsquared_class)
%Xy_sampled_i = ...
%   Halton_sampling_SVDD(Xtr, Ytr_class, Num_class, x_class, kernel, param_star, Rsquared_class)

%  generate counterfactuals

%% generate counterfactuals

counterfactuals_cell = {};

for i = 1:Num_class
    f_class = i;
    actionable=false;
    header=I.Properties.VariableNames;
    counterfactuals = multiclassCounterfactuals(Xtr, Ytr_class, Num_class, x_class, Xts,y_preds, kernel, param_star, Rsquared_class, f_class, Xy_sampled,actionable,header)
    counterfactuals_cell{i} = counterfactuals;
end

Xtr = Xtr.*S + C;
Xts = Xts.*S + C;

for i = 1:Num_class

    counterfactuals_i = counterfactuals_cell{i};

    for j = 1:size(counterfactuals_i,1)

        for k = 1:Num_class

            tmp = counterfactuals_i{j,k}(2,:);
            counterfactuals_i{j,k} = [header;num2cell(cell2mat(tmp).*[S,1] + C)];

        end

    end

    counterfactuals_cell{i} = counterfactuals_i;

end


counterfactuals1 = counterfactuals_cell{1};
save('...','counterfactuals1')

counterfactuals2 = counterfactuals_cell{2};
save('...','counterfactuals2')

counterfactuals3 = counterfactuals_cell{3};
save('...','counterfactuals3')

counterfactuals4 = counterfactuals_cell{4};
save('...','counterfactuals4')

