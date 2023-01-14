function [counterfactuals_cleaned] = ...
    clean_counterfactuals(counterfactuals, Num_classes)

% Function that counts the number of valid counterfactuals for each class
% and removes rows with at least one non-valid counterfactual

n = size(counterfactuals,1); % maximum number of counterfactuals (i.e., number of factuals) 
drop_indexes = [];
for i=2:Num_classes %for each class of counterfactuals
        drop_indexes_i=[];
        for j = 1: n %for each factual
            if cell2mat(counterfactuals{j,i}(2,1) ) == 0 % if the counterfactual for the specific class is not available
                drop_indexes_i = [drop_indexes_i;j]; %save the index to remove
            end                
        end
%         disp(drop_indexes_i)
        disp([num2str(size(drop_indexes_i,1)),'/',num2str(n),' NOT AVAILABLE for column ',num2str(i)])
        drop_indexes=[drop_indexes;drop_indexes_i];
end
drop_indexes = unique(drop_indexes);%remove duplicate indexes
hold_indexes = setdiff(linspace(1,n,n),drop_indexes); %extract the indexes to be kept
counterfactuals_cleaned = counterfactuals(hold_indexes,:); % clean the counterfactuals matrix from non-valid counterfactuals