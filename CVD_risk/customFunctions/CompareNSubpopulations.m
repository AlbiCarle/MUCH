function CompareNSubpopulations(p1,p2,p3,transition,varName,popName1,popName2,popName3,cfMethod)
    % Perform Kruskal-Wallis test (3 populations)
    clf
    fprintf('Median %s of %s Population , %s, %s: %.2f\n',varName,popName1,transition, cfMethod, median(p1));
    fprintf('Median %s of %s Population , %s, %s: %.2f\n', varName,popName2,transition, cfMethod,median(p2));
    fprintf('Median %s of %s Population , %s, %s: %.2f\n',varName,popName3,transition, cfMethod, median(p3));
    
    group=[ones(size(p1,1),1);2*ones(size(p2,1),1);3*ones(size(p3,1),1)];
    [p_value_kw, table_kw, stats_kw] = kruskalwallis([p1;p2; p3], group, 'off');
    fprintf('P-value for Kruskal Wallis test ( %s, %s, %s): %e\n', varName,transition, cfMethod,p_value_kw);
    if p_value_kw<0.05
        % Bonferroni-corrected post hoc test
        c = multcompare(stats_kw, 'CType', 'bonferroni');
        % % Print the p-value
        fprintf('Post-hoc pairwise comparison with Bonferroni correction:');
        tbl = array2table(c,"VariableNames", ...
            ["Group A","Group B","Lower Limit","A-B","Upper Limit","P-value"])
    end  
end

