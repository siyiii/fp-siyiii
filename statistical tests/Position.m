% simple case: 12 images each trial and 87 trials in total including 14 attention check trials
numPos = 12;
numTrial = 87;
numImg = numTrial * numPos;

% distribute 1030 image, position to 120 participants
vctSbj = 1:numPos;
matSbj = vctSbj;
for ii = 2:numPos
    matSbj = vertcat(matSbj, circshift(vctSbj,[0 ii-1]));
end

% row: images
% col: position
matImgPos = repmat(matSbj, numTrial, 1);

% shuffle images and position
imgIdx = randperm(numImg);
posIdx = randperm(numPos);

% for each participant, construct trial x pos matrix
for iSbj = 1:120
    matTrial{iSbj} = zeros(numTrial, numPos); % row: trial, col: position
    numTry = 0;
    while 1
        for iPos = 1:numPos
            tmpImg = Shuffle(find(matImgPos(:,iPos) == iSbj));
            % apply shuffled image and position indices
            matTrial{iSbj}(:,posIdx(iPos)) = imgIdx(tmpImg);
        end
        locAttn{iSbj} = sum(matTrial{iSbj} > 1030, 2);
        if sum(locAttn{iSbj} > 1) == 0
            % the attention checks should be dispersed
            distAttn = diff(find(locAttn{iSbj}));
            if sum(distAttn < 5) == 0
                break;
            end
        end
        numTry = numTry + 1;
    end
    [iSbj numTry]
end

% sanity check
matImgPos2 = nan(numImg, numPos, 2);
for iImg = 1:numImg
    for iSbj = 1:120
        [trialIdx, posIdx] = ind2sub([numTrial, numPos], find(matTrial{iSbj} == iImg));
        matImgPos2(iImg, posIdx, 1) = iSbj;
        matImgPos2(iImg, posIdx, 2) = trialIdx;
    end
end

sum(isnan(matImgPos2))

save('matTrial.mat', 'matTrial');


