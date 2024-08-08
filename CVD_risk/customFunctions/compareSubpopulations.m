function compareSubpopulations(p1,p2,transition,varName,popName1,popName2,cfMethod)
    % Perform Mann-Whitney U test (2 populations)
    fprintf('Median %s of %s Population, %s, %s: %.2f\n', varName,transition,popName1,cfMethod, median(p1));
    fprintf('Median %s of %s Population, %s, %s: %.2f\n', varName,transition,popName2,cfMethod, median(p2));
    [p_value, h] = ranksum(p1,p2);
    % Print the p-value
    fprintf('P-value for Mann-Whitney U test (%s in %s vs %s, %s, %s): %e\n', varName,popName1,popName2,transition,cfMethod, p_value);
    % Print whether the null hypothesis (medians are equal) is rejected
    fprintf('Null hypothesis (medians are equal) rejected? %d\n', h);

end

