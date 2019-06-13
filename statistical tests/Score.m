load('All_Data.mat');

for i = 1:158
    try
        score{:,i} = All_Data{1,i}(:,6);
    catch ME
    end
    
end

score = score(~cellfun('isempty',score));
        
for j = 1:length(score)
    ScoreData(:,j) = score{1,j};
end

save('ScoreData.mat', 'ScoreData');
