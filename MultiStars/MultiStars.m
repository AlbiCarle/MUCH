%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Star Dataset Multi-Counterfactuals %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% This is the example code used for the classification and extraction
% of multicontrasts from the Star dataset.

% The script is divided as follows:
% 1) Data preprocessing.
% 2) Classification using multiclass SVDD.
% 3) Extraction of counterfactuals.

% The evaluation and visualization of counterfactuals are reported 
% in the SpiderStars.mlx file.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% XXXX %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc; clear all; close all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% XXXX %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

addpath('.../MC-SVDD')
addpath('.../Counterfactuals_Utilities')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% XXXX %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Data preprocessing

I = readtable('star_classification.csv');

I.obj_ID = [];
I.run_ID = [];
I.rerun_ID = [];
I.field_ID = [];
I.spec_obj_ID = [];
I.fiber_ID = [];
I.cam_col = [];

I = [I(:,1:7) I(:,9:11) I(:,8)];

rand_shuffle = randperm(size(I, 1));

X = [I.alpha, I.delta, I.u, I.g, I.r, I.i, I.z, I.redshift, I.plate, I.MJD];
X = X(rand_shuffle, :);

Y = grp2idx(I.class);
Y = Y(rand_shuffle,:);

X_Y = [X,Y];

X1 = X_Y(Y==1,:);
X2 = X_Y(Y==2,:);
X3 = X_Y(Y==3,:);

N_sample_per_class = 2000;

X_learn = [X1(1:N_sample_per_class,1:10);
           X2(1:N_sample_per_class,1:10);
           X3(1:N_sample_per_class,1:10)];

Y_learn = [1*ones(N_sample_per_class,1);
           2*ones(N_sample_per_class,1);
           3*ones(N_sample_per_class,1)];

[Z, C, S] = normalize(X_learn,'norm',Inf); % for de-normalizing: X = Z.*S + C

cv = cvpartition(Y_learn,'HoldOut',0.3, 'Stratify',true);
idx = cv.test;

Xtr = Z(~idx,:); Ytr = Y_learn(~idx,:);
Xts = Z(idx,:); Yts = Y_learn(idx,:);

figure(1)

gscatter(Xtr(:,7), Xtr(:,8), Ytr,'brg','.',[7 7]);

%% MC-SVDD

% Cross Validation

kernel = 'gaussian';
Num_class = size(unique(Ytr),1);

%Cpar = [[1,1,1,1,1,1,1,1,1];...
         %[1,0.1,0.1,0.1,0.1,1,0.1,0.1,0.1];...
         %[1,0,0,0.5,0,1,0,0.5,0];...
         %[1,0.5,0.5,0.5,0.5,1,0.5,0.5,0.5];...
         %[1,5,5,5,5,1,5,5,5];...
         %[100,0.5,0.5,0,0.5,1,0,0,0.5];...
         %[0.1,0,0,0,0,0.1,0,0,0]
         %[100,0.5,0.5,0,0.5,1,0,0,0.5];...
         %[0.1,0,0,0,0,0.1,0,0,0]];

% KerPar = linspace(0.1, 5, 100);

%[param_star, C_star, err_matrix] = ...
   % CV_MultiSVDD(Xtr, Ytr, kernel,2, KerPar,Cpar);

param_star = 1;
C_star = [1,1,1,1,1,1,1,1,1];%[1000, 0, 100, 0, 10, 1, 0, 0, 10, 0, 1, 0, 100, 0, 0, 1];%[1,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1];

[x_class, Ytr_class, Rsquared_class, a_class, SV_class, YSV_class]=...
    NC_SVDD_TRAINING(Xtr, Ytr, Num_class, kernel, param_star, C_star);

%%%%

[y_pred, k_dist] = ...
    NC_SVDD_TEST(Xtr, Ytr_class, Num_class, x_class, Xtr, kernel, param_star, Rsquared_class);

%%%%

% training

CM = ConfusionMatrix(Ytr, y_pred, Num_class)

figure(2)

cm = confusionchart(Ytr, y_pred);

accuracy = sum(diag(CM))/size(Ytr,1);

outliers = sum(y_pred==0)/size(Ytr,1);

% test

[y_preds, k_dist2] = ...
    NC_SVDD_TEST(Xtr, Ytr_class, Num_class, x_class, Xts, kernel, param_star, Rsquared_class);

CMs = ConfusionMatrix(Yts, y_preds, Num_class)

figure(3)

cms = confusionchart(Yts, y_preds);

accuracy2 = sum(diag(CMs))/size(Yts,1);

outliers2 = sum(y_preds==0)/size(Yts,1);

F1_test_1 = (2*CMs(1,1))/(2*CMs(1,1) + CMs(1,2) + CMs(1,3) + CMs(2,1) + CMs(3,1));
F1_test_2 = (2*CMs(2,2))/(2*CMs(2,2) + CMs(2,1) + CMs(2,3) + CMs(1,2) + CMs(3,2));
F1_test_3 = (2*CMs(3,3))/(2*CMs(3,3) + CMs(3,1) + CMs(3,2) + CMs(1,3) + CMs(2,3));

F1_test_macro = (F1_test_1 + F1_test_2 + F1_test_3)/3;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% XXXX %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Extraction of Counterfactuals

% sampling of SVDD boundary and internal points using Halton quasi-random sampling

Xy_sampled = ...
    Halton_sampling_MultiSVDD(Xtr, Ytr, Ytr_class, Num_class, x_class, kernel, param_star, Rsquared_class)
%Xy_sampled_i = ...
%Halton_sampling_SVDD(Xtr, Ytr_class, Num_class, x_class, kernel, param_star, Rsquared_class)

% generate counterfactuals

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
