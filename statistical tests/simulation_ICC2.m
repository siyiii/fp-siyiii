%% Import the Excel file including ratings of 1500 images
data = dataset('xlsfile', '1500Images.xlsx');
Preference = zscore(double(data(:,3)));

%Randomize the order of 15 images per trial
numImage = length(Preference);
numImgPerTrial = 15; % showing 15 images per trial
numTrial = numImage / numImgPerTrial;
numClickPerTrial = 5; % sbj clicking 3 images per trial

%% Simulating experiments
% this code assumes that people make choices by comparing images side-by-side
numSbj = 100;
iteration = 2;
sbjClick = zeros(numImage, numSbj);
sbjCorr = zeros(numSbj, 1);
sbjPref = zeros(0,numSbj,numImage);
sbjWeight = zeros(1,21);
r = zeros(iteration,21);

% generate artificial data for 100 participants rating 1500 images
for i = 1:21
    for iter = 1:iteration
        sbjPref = zeros(0,numSbj,numImage);
        for iSbj = 1:numSbj
            sbjWeight(i) = 0.05*i-0.05;
            sbjPref(i,iSbj,:) = Preference.' + sbjWeight(i)*randn(size(Preference.'));
        end
        %number of images
        numImage = size(sbjPref(i,:,:),3);
        %number of raters/subjects
        numSbj = size(sbjPref(i,:,:),2);
        
        %mean rating per image
        avePerImg = mean(sbjPref(i,:,:),2);
        %total mean
        aveAll = mean(avePerImg);
        
        %between image sum sqrs
        BSS = numSbj*sum((avePerImg-aveAll).^2);
        %between images mean squares
        BMS = BSS/(numImage-1);
        
        %within image sum sqrs
        WSS = sum(sum((sbjPref(i,:,:)-avePerImg).^2));
        %within image mean sqrs
        WMS = WSS/(numImage*(numSbj-1));
        
        %compate inter-rater correlation
        r(iter,i) = (BMS-WMS)/(BMS+(numSbj-1)*WMS);        
    end
end


figure;
Avg_r = mean(r);
SD_r = std(r);
errorbar(sbjWeight,Avg_r,SD_r);
xlabel('Subject Weight');
ylabel('Preference Inter-Rater Correlation');

%sbjweight = 0.6 (i=13)
