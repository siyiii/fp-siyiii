clear;
%% Ratings for 375 images among 203 participants
data = dataset('xlsfile', 'Preference.xlsx'); %Natural_Unnatural.xlsx
imageName = cellstr(dataset('xlsfile', 'Image_Name.xlsx'));

Rating = double(data(:,1:100)); %ratings of 375 images
Image = cellstr(data(:,101:200)); %order of 375 images

numImg = length(imageName);
numImgPerSbj = size(Image,2);
numSbj = length(Rating);

x = zeros(numImg, numImgPerSbj);
index = zeros(numSbj,size(Image,2));
rating_image = zeros(numSbj,numImg);

for i = 1:numSbj
    for j = 1:numImgPerSbj
        x(:,j) = double(ismember(imageName, Image(i,j)));
        index(i,j) = find(x(:,j)==1);
        rating_image(i,index(i,j)) = Rating(i,j);
    end
end

rating_image(rating_image == 0) = NaN;

%% Inter-Rater Correlation (Reference:Intraclass Correlations: Uses in Assessing Rater Reliability)
%mean rating per image
avePerImg = nanmean(rating_image);
%mean rating per rater/subject
avePerSbj = nanmean(rating_image,2);
%total mean
aveAll = nanmean(avePerImg);

%between image sum sqrs
BSS = numSbj*sum((avePerImg-aveAll).^2);
%between images mean squares
BMS = BSS/(numImg-1);

%within image sum sqrs
WSS = nansum(nansum((rating_image-avePerImg).^2));
%within image mean sqrs
WMS = WSS/(numImg*(numSbj-1));

%compate inter-rater correlation
r = (BMS-WMS)/(BMS+(numSbj-1)*WMS);
%Inter-Rater Correlation for Naturalness is 0.9708; for preference is
%0.7212.

