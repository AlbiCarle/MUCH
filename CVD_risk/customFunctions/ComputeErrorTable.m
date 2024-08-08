function errorTable = ComputeErrorTable(S1,S1_ts,S2,S2_ts,Ycf_2_ts,Ycf_1_ts, Epsilon,n) 
    %compute error and size of the conformal set for different epsilon values
    Err2 = [];
    Err1 = [];
    ErrAvg = [];
    AvgEmpty = [];
    AvgSingle = [];
    AvgDouble = [];
    varnams = {'AvgErr','HM_err','HL_err','empty','single','double'};
    
    for epsilon = Epsilon
    
        qhat1 = quantile(S1, (ceil((n+1)*(1-epsilon)))/n);
        qhat2 = quantile(S2, (ceil((n+1)*(1-epsilon)))/n);
        
        Cset = [(S1_ts-qhat1 <= 0)*2,(S2_ts-qhat2 <= 0)*1];
        
        err_ts_2 = 1-sum(Ycf_2_ts == Cset(:,1))/size(Ycf_2_ts(Ycf_2_ts==2),1);
        Err2 = [Err2; err_ts_2];
        
        err_ts_1 = 1-sum(Ycf_1_ts == Cset(:,2))/size(Ycf_1_ts(Ycf_1_ts==1),1);
        Err1 = [Err1; err_ts_1];
        
        err_ts_avg = (err_ts_2 + err_ts_1)/2;
        ErrAvg = [ErrAvg; err_ts_avg];
        
        empty = sum(Cset(:,1)==0 & Cset(:,2)==0);
        AvgEmpty = [AvgEmpty; empty/size(Cset,1)];
        
        double = sum(Cset(:,1)==2 & Cset(:,2)==1);
        AvgDouble = [AvgDouble; double/size(Cset,1)];
        
        single = (size(Cset,1) - (empty + double));
        AvgSingle = [AvgSingle; single/size(Cset,1)];
    
    end  
    errorTable = array2table([ErrAvg, Err2, Err1, AvgEmpty, AvgSingle, AvgDouble],VariableNames=varnams);
end