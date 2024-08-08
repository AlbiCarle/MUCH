function [stats_DICE,stats_SVDD] = plotDeltaCF(F_DICE,CF_DICE,F_SVDD,CF_SVDD,labels,col_index,m,M)
%parallel coords plot of the modifiable features (median and quantiles)
Xdiff_DICE=CF_DICE-F_DICE;
Xdiff_SVDD=CF_SVDD-F_SVDD;

stats_DICE = describe_stats(Xdiff_DICE);
stats_SVDD = describe_stats(Xdiff_SVDD);

line0 = [0,0,0,0,0,0,0,0];
columnplot = [0;0;1;2;3;4;5;6;7];

%extract median and quantiles for each method
q1_DICE = quantile(Xdiff_DICE(:,col_index),0.25);
q2_DICE = quantile(Xdiff_DICE(:,col_index),0.75);
med_DICE = median(Xdiff_DICE(:,col_index));

q1_SVDD= quantile(Xdiff_SVDD(:,col_index),0.25);
q2_SVDD = quantile(Xdiff_SVDD(:,col_index),0.75);
med_SVDD = median(Xdiff_SVDD(:,col_index));
Xplot = [m;M;line0;q1_DICE;med_DICE;q2_DICE;q1_SVDD;med_SVDD;q2_SVDD];

coordvars = {labels};
coordvars = cat(2,coordvars{:});
T = array2table(Xplot);
T.Properties.VariableNames = coordvars;

clf
h = parallelplot(Xplot);
h.GroupData = columnplot;
h.CoordinateTickLabels = labels;
h.Color = ["#FFFFFF";"#000000"; "#1f78b4"; "#1f78b4"; "#1f78b4";...
          "#ff7f00"; "#ff7f00"; "#ff7f00";]; 
h.LineWidth = [0.01,0.1, 1,2,1, ...
                1,2,1];
h.LineStyle = {'none','-','--','-','--',...
               '--','-','--'};
h.MarkerStyle= {'none','none','none','*','none','none','*','none'};
h.LineAlpha = [0.4,0.4,0.7,0.7,0.7,0.7,0.7,0.7];
h.FontSize=8;
h.MarkerSize= 5;
h.LegendVisible='off';
end

