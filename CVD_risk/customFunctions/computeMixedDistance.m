function dist = computeMixedDistance(row1, row2, h)
    %compute mixed Distance d(x_i,x_j)= (h/m)* HammingDistance(x_i,x_j)+((m-h)/m)* CosineDistance(x_i,x_j)
    % between 2 observations with both categorical and numerical attributes
    m=size(row1,2); % n of features
    
    %extract categorical features
    row1_cat = round(row1(1:h));
    row2_cat = round(row2(1:h));
  
    %extract numerical features
    row1_num = row1(h+1:end);
    row2_num = row2(h+1:end);
   
    % Compute Hamming distance for categorical features
    hammingDist = sum(row1_cat ~= row2_cat);
    
    % Compute Cosine distance for numerical features
    cosineDist = 1 - dot(row1_num, row2_num) / (norm(row1_num) * norm(row2_num));
    
    % Combine distances (weighted sum)    
    d1 = (h / m) * hammingDist; 
    d2 = ((m - h) / m) * cosineDist;

    dist = d1 + d2;    
end
