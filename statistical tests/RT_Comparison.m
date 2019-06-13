load('CAPTCHA_RT.mat');
CAPTCHA_RT = CAPTCHA_RT/1000; %ms ---> s
Likert_RT = double(dataset('xlsfile', 'Likert_RT.xlsx'))/1000;

sbj_CAP_RT = sum(CAPTCHA_RT,2)/1030;
sbj_Lik_RT = sum(Likert_RT,2)/100;
sample_Lik_RT = randsample(sbj_Lik_RT,129);

avg_CAP_RT = mean(sbj_CAP_RT);sd_CAP_RT = std(sbj_CAP_RT);
avg_Lik_RT = mean(sample_Lik_RT);sd_Lik_RT = std(sample_Lik_RT);

plot(sbj_CAP_RT,'LineWidth',1);
hold on;
plot(sample_Lik_RT,'LineWidth',1,'color','r');
legend('CAPTCHA-Style Rating Time', 'Likert Scale Rating Time');
xlabel('Number of Subject');
ylabel('Rating Time');

[h,p,ci,stats] = ttest2(sbj_CAP_RT,sample_Lik_RT);
