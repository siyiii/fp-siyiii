clear;
csvData = csvread('GlmmData.csv', 1, 0);
participant = unique(csvData(:,1));

for n = 1
    idx(n,:) = randsample(1:126,126);
    index1(n,:) = idx(n,(1:63));
    index2(n,:) = idx(n,(64:126));
    
    %first half beta
    Group1 = participant(index1(n,:),1);
    idx1 = [];
    for i = 1:length(Group1)
        idx1(:,i) = find(csvData(:,1) == Group1(i));
    end
    idx1 = idx1(:);
    Image_ID1 = nominal(csvData(idx1,2));
    Position1 = nominal(csvData(idx1,4));
    Click1 = csvData(idx1,5);
    GlmData1 = table(Click1, Image_ID1, Position1);
    modelspec1 = 'Click1 ~ Image_ID1 + Position1';
    mdl1 = fitglm(GlmData1,modelspec1,'Distribution','binomial');
    Coefficients1 = mdl1.Coefficients;
    Estimate1 = table2array(Coefficients1((2:1030),1));
    
    %second half beta
    Group2 = participant(index2(n,:),1);
    for i = 1:length(Group2)
        idx2(:,i) = find(csvData(:,1) == Group2(i));
    end
    idx2 = idx2(:);
    Image_ID2 = nominal(csvData(idx2,2));
    Position2 = nominal(csvData(idx2,4));
    Click2 = csvData(idx2,5);
    GlmData2 = table(Click2, Image_ID2, Position2);
    modelspec2 = 'Click2 ~ Image_ID2 + Position2';
    mdl2 = fitglm(GlmData2,modelspec2,'Distribution','binomial');
    Coefficients2 = mdl2.Coefficients;
    Estimate2 = table2array(Coefficients2((2:1030),1));
    
    %Correlation
    %[co pv] = corrcoef(Estimate1,Estimate2); %visualize - outlier - 25 subjects
    [co pv] = corr(Estimate1,Estimate2, 'type', 'Spearman');

    %corr(n,1) = co(1,2);
    
end

%remove outliers
out1 = find(Estimate1 == min(Estimate1));
out2 = find(Estimate2 == min(Estimate2));

Estimate1(out1,:) = [];
Estimate1(out2,:) = [];
Estimate2(out1,:) = [];
Estimate2(out2,:) = [];

[co pv] = corr(Estimate1,Estimate2, 'type', 'Spearman');
[p,S] = polyfit(Estimate1,Estimate2,1);
[Estimate2_fit,delta] = polyconf(p,Estimate1,S,'alpha',0.05);
plot(Estimate1, Estimate2, 'o'); xlim([-4 5]); ylim([-4 5]);
hold on;
plot(Estimate1,Estimate2_fit,'LineWidth',3,'color','r');
legend('Data','Linear Fit')
xlabel('CAPTCHA-Style Rating - First Half of Test');
ylabel('CAPTCHA-Style Rating - Second Half of Test');

n = numel(Estimate1);
STE = 1/sqrt(n-3);
%95% confidence interval, for 99% use 0.99:
CI = norminv(0.95); 
upper_bound = tanh(atanh(co)+CI*STE);
lower_bound = tanh(atanh(co)-CI*STE);
