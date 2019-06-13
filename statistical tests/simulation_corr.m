%%Based on the result from file "Inter_Rater_Corr_Artificial_Preference", sbjweight = 0.6

%Import the Excel file including ratings of 1500 images
data = dataset('xlsfile', '1500Images.xlsx');
Preference = zscore(double(data(:,3)));

%Randomize the order of 15 images per trial
numImage = length(Preference);
numImgPerTrial = 15; % showing 15 images per trial
numTrial = numImage / numImgPerTrial;

%% simulating experiments
% this code assumes that people make choices by comparing images side-by-side

numSbj = 100;
iteration = 1;
sbjClick = zeros(numImage, numSbj);
sbjCorr = zeros(numSbj, 1);
Corr = zeros(0,numSbj, iteration); %correlation between true & measured ratings for each numClickPerTrial (1,2,3,...,10)
Avg_Corr = zeros(10,numSbj);
SD_Corr = zeros(10,numSbj);

for numClickPerTrial = 1:10
    for iter = 1:iteration
        for iSbj = 1:numSbj
            
            % add noise to the preference, to mimic the idiosyncrasies in preference
            sbjWeight = 0.6; % this can be manipulated
            sbjPref = Preference + sbjWeight*randn(size(Preference));
            co = corrcoef(Preference, sbjPref);
            sbjCorr(iSbj) = co(1,2);
            
            % shuffling the image order to be presented
            orderIdx = randperm(numImage); % counter balanced position design from file Counter_Balanced_Sequences
            for iT = 1:numTrial
                % in each trial we show 15 images
                trialIdx = orderIdx(numImgPerTrial*(iT-1) + (1:numImgPerTrial));
                % out of 15 images, the sbj clicks the top 3 image based on sbjPref
                trialPref = sbjPref(trialIdx) + 1 * (-7:7).'/7;
                [~, topIdx] = sort(trialPref, 'descend'); % idx(1:3) are the top 3 images
                sbjClick(trialIdx(topIdx(1:numClickPerTrial)), iSbj) = 1;
            end
            
            [co,pv] = corrcoef(Preference, mean(sbjClick(:,1:iSbj),2));
            Corr(numClickPerTrial,iSbj,iter) = co(1,2);
        end
    end
    
    % plot correlation
    Avg_Corr(numClickPerTrial,:) = mean(Corr(numClickPerTrial,:,:),3);
    SD_Corr(numClickPerTrial,:) = std(Corr(numClickPerTrial,:,:),0,3);
    
    subplot(4,3,numClickPerTrial);
    errorbar((1:numSbj),Avg_Corr(numClickPerTrial,:),SD_Corr(numClickPerTrial,:));
    title(numClickPerTrial);
        
end

%plot(Avg_Corr, 'o');
%ylim([0 1]);
%xlabel('Number of Participants');
%ylabel('True & Measured Correlation');
