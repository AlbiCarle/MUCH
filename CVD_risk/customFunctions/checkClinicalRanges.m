function [flag] = checkClinicalRanges(factual,counterfactual)
%checkClinicalRanges check if 
% For each biomarker:
% If factual is in the normal range-> ensure that the cf is still inside the normal range (between lower and upper thr)
% If factual is above the normal range-> ensure that the cf value doesn’t explode towards too high values
% If factual is below the normal range-> ensure that the cf value doesn’t explode towards too low values
%return flag = 1 if the candidate counterfactual satisfies all conditions
%and 0 if not (i.e, the counterfactual must be discarded)
flag=1;
lowLDL= 1.5; 
highLDL= 4.9;
lowHDL= 1;
highHDL=2.4; 
lowTRIG=0.5;
highTRIG= 5.6;
lowTOTCHOL=0.5;
highTOTCHOL= 6.21;
lowSBP=90;
highSBP= 139;
lowDBP= 60;
highDBP= 89; 
lowFBS= 3.2; 
highFBS= 6.9;
lowBMI= 18.5;
highBMI= 34.9;

if (((factual(5)<=highSBP) && (factual(5)>=lowSBP) && (counterfactual(5)>highSBP)) || ((factual(6)<=highDBP) && (factual(6)>=lowDBP)&&(counterfactual(6)>highDBP))||((factual(7)<=highBMI) && (factual(7)>=lowBMI)&&(counterfactual(7)>highBMI))||((factual(8)<=highLDL) && (factual(8)>=lowLDL)&&(counterfactual(8)>highLDL))||((factual(9)<=highHDL) && (factual(9)>=lowHDL)&&(counterfactual(9)>highHDL))||((factual(10)<=highTRIG) && (factual(10)>=lowTRIG)&&(counterfactual(10)>highTRIG))||((factual(11)<=highFBS) && (factual(11)>=lowFBS)&&(counterfactual(11)>highFBS)) ||((factual(13)<=highTOTCHOL) && (factual(13)>=lowTOTCHOL)&&(counterfactual(13)>highTOTCHOL)))
        %if f in normal ranges and cf too high
        flag=0; %discard candidate counterfactual        
elseif (((factual(5)<=highSBP) && (factual(5)>=lowSBP) && (counterfactual(5)<lowSBP)) || ((factual(6)<=highDBP) && (factual(6)>=lowDBP)&&(counterfactual(6)<lowDBP))||((factual(7)<=highBMI) && (factual(7)>=lowBMI)&&(counterfactual(7)<lowBMI))||((factual(8)<=highLDL) && (factual(8)>=lowLDL)&&(counterfactual(8)<lowLDL))||((factual(9)<=highHDL) && (factual(9)>=lowHDL)&&(counterfactual(9)<lowHDL))||((factual(10)<=highTRIG) && (factual(10)>=lowTRIG)&&(counterfactual(10)<lowTRIG))||((factual(11)<=highFBS) && (factual(11)>=lowFBS)&&(counterfactual(11)<lowFBS)) ||((factual(13)<=highTOTCHOL) && (factual(13)>=lowTOTCHOL)&&(counterfactual(13)<lowTOTCHOL)))
         %if f in normal ranges and cf too low   
         flag=0; %discard candidate counterfactual        
elseif ((factual(5)>highSBP) && (counterfactual(5)>(highSBP+0.2*highSBP))|| ((factual(6)>highDBP) && (counterfactual(6)>(highDBP+0.2*highDBP))) || ((factual(7)>highBMI) && (counterfactual(7)>(highBMI+0.2*highBMI))) ||((factual(8)>highLDL) && (counterfactual(8)>(highLDL+0.2*highLDL))) || ((factual(9)>highHDL) && (counterfactual(9)>(highHDL+0.2*highHDL))) ||((factual(10)>highTRIG) && (counterfactual(10)>(highTRIG+0.2*highTRIG))) ||((factual(11)>highFBS) && (counterfactual(11)>(highFBS+0.2*highFBS))) ||((factual(13)>highTOTCHOL) && (counterfactual(13)>(highTOTCHOL+0.2*highTOTCHOL))))    
         %if f above normal ranges and cf too high
          flag=0; %discard candidate counterfactual
elseif ((factual(5)<lowSBP) && (counterfactual(5)<(lowSBP-0.2*lowSBP))||((factual(6)<lowDBP) && (counterfactual(6)<(lowDBP-0.2*lowDBP)))||((factual(7)<lowBMI) && (counterfactual(7)<(lowBMI-0.2*lowBMI))) || ((factual(8)<lowLDL) && (counterfactual(8)<(lowLDL-0.2*lowLDL))) || ((factual(9)<lowHDL) && (counterfactual(9)<(lowHDL-0.2*lowHDL))) || ((factual(10)<lowTRIG) && (counterfactual(10)<(lowTRIG-0.2*lowTRIG))) || ((factual(11)<lowFBS) && (counterfactual(11)<(lowFBS-0.2*lowFBS))) || ((factual(13)<highTOTCHOL) && (counterfactual(13)<(lowTOTCHOL-0.2*lowTOTCHOL))) )    
         %if f below normal ranges and cf too low
          flag=0; %discard candidate counterfactual
elseif (((factual(5)>highSBP) && (counterfactual(5)<lowSBP)) || ((factual(6)>highDBP) && (counterfactual(6)<lowDBP)) || ((factual(7)>highBMI) && (counterfactual(7)<lowBMI)) || ((factual(8)>highLDL) && (counterfactual(8)<lowLDL)) || ((factual(9)>highHDL) && (counterfactual(9)<lowHDL)) || ((factual(10)>highTRIG) && (counterfactual(10)<lowTRIG)) || ((factual(11)>highFBS) && (counterfactual(11)<lowFBS)) || ((factual(13)>highTOTCHOL) && (counterfactual(13)<lowTOTCHOL)))    
         %if f above normal ranges and cf low 
          flag=0; %discard candidate counterfactual   
elseif (((factual(5)<lowSBP) && (counterfactual(5)>highSBP)) || ((factual(6)<lowDBP) && (counterfactual(6)>highDBP)) || ((factual(7)<lowBMI) && (counterfactual(7)>highBMI)) || ((factual(8)<lowLDL) && (counterfactual(8)>highLDL)) || ((factual(9)<lowHDL) && (counterfactual(9)>highHDL)) || ((factual(10)<lowTRIG) && (counterfactual(10)>highTRIG)) || ((factual(11)<lowFBS) && (counterfactual(11)>highFBS)) || ((factual(13)<lowTOTCHOL) && (counterfactual(13)>highTOTCHOL))) 
          %if f below normal ranges and cf high
          flag=0; %discard candidate counterfactual
        
end
end