function FactualCounterfactualComparison(pre,post)
    % Execute Wilcoxon test for each feature with Bonferroni correction
    num_feats = size(pre, 2);  
    p_values = zeros(1, num_feats);
    
    for i = 1:num_feats
        % Esexute Wilcoxon for each feature
        p_values(i) = signrank(pre(:, i), post(:, i));
    end

    bonferroni_threshold = 0.05 / num_feats;    
    % check significant p-values after correction
    significant = p_values < bonferroni_threshold;
    
    for i = 1:num_feats
        fprintf('Feature %d: p-value = %.5f, significant= %d\n', i, p_values(i), significant(i));
    end
 
    fprintf('Bonferroni threshold: %.5f\n', bonferroni_threshold);
    fprintf('Number of significant features: %d\n', sum(significant));
end