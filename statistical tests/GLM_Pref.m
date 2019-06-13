clear;
csvData = csvread('GlmmData.csv', 1, 0);

%Participant = nominal(csvData(:,1));
Image_ID = nominal(csvData(:,2));
%Trial = nominal(csvData(:,3));
Position = nominal(csvData(:,4));
%Row = nominal(csvData(:,4));
%Column = nominal(csvData(:,5));
Click = csvData(:,5);
%Task = nominal(csvData(:,7)); %Task=1 for preference rating

GlmData = table(Click, Image_ID, Position);

modelspec = 'Click ~ Image_ID + Position';

mdl = fitglm(GlmData,modelspec,'Distribution','binomial');
% model = fitglme(GlmmData, 'Click ~ Image_ID + Position + (1 | Participant)', ...
%     'Distribution','Binomial', 'FitMethod', 'Laplace', 'Verbose',1);
Coefficients = mdl.Coefficients;

Estimate = table2array(Coefficients((2:1030),1));

data = dataset('xlsfile', 'FIRE_stim_info.xlsx');
Preference = dataset2cell(data(:,18));
True_Data = cell2mat(Preference((3:1031),1));

%Correlation
[co,pv] = corrcoef(Estimate,True_Data); %[[0.764267536984748]

[p,S] = polyfit(True_Data,Estimate,1);
[Estimate_fit,delta] = polyconf(p,True_Data,S,'alpha',0.05);
plot(True_Data, Estimate, 'o');
hold on;
plot(True_Data,Estimate_fit,'LineWidth',3,'color','r');
hconf = plot(True_Data,Estimate_fit+delta,'LineWidth',1,'LineStyle',':','color',.7*[1 1 1]);
plot(True_Data,Estimate_fit-delta,'LineWidth',1,'LineStyle',':','color',.7*[1 1 1])
legend('Data','Linear Fit','95% Prediction Interval')
ylabel('Estimated Prefrence by GLM');
xlabel('True Preference');

p = 2:12;
position((1:11),1) = table2array(Coefficients((1031:1041),1));%mean
position((1:11),2) = table2array(Coefficients((1031:1041),2));%SE
position((1:11),3) = table2array(Coefficients((1031:1041),3));%t

for v = 1:11
    errlow(v) = - 1.96*position(v,2);
    errhigh(v) = + 1.96*position(v,2) ;
end

data = position(:,1);
bar(p,data,'FaceColor',[0 0.4470 0.7410]);
hold on

er = errorbar(p,data',errlow,errhigh);    
er.Color = [1 0 0];
er.LineWidth = 2;
er.LineStyle = 'none';  
hold off

xlim([1 13]); ylim([-0.5 0.5]);
xlabel('Image Position');
ylabel('Estimated Preference Effect (beta coefficient)');

