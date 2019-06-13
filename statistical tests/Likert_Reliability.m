clear;
%% Ratings for 375 images among 200 participants
data = dataset('xlsfile', 'Preference.xlsx'); %Preference
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

for n = 1:10
for k = 1:375 %375
    rating_mat{k} = rating_image(:,k);
    rating_pref{k} = nonzeros(rating_mat{k}(:,1));
    
    l(1,k) = length(rating_pref{k});
    idx{k} = randsample(1:l(1,k),l(1,k));
    if bitget(l(1,k),1)       
        index1{k} = idx{k}(1,(1:(l(1,k)-1)/2));
        index2{k} = idx{k}(1,((l(1,k)+1)/2:l(1,k)));        
    else
        index1{k} = idx{k}(1,(1:l(1,k)/2));
        index2{k} = idx{k}(1,((l(1,k)/2)+1:l(1,k)));
    end
    group1{k} = rating_pref{k}(index1{k},1);
    group2{k} = rating_pref{k}(index2{k},1);
    
    rating_g1{k} = mean(group1{k});
    rating_g2{k} = mean(group2{k});
    
    likert_rating(k,1) =  rating_g1{k};
    likert_rating(k,2) =  rating_g2{k};
    
    co = corr(likert_rating(:,1), likert_rating(:,2), 'type', 'Spearman');

end

%[co pv] = corr(likert_rating(:,1), likert_rating(:,2), 'type', 'Spearman');
% [p,S] = polyfit(likert_rating(:,1),likert_rating(:,2),1);
% [group2_fit,delta] = polyconf(p,likert_rating(:,1),S,'alpha',0.05);
% plot(likert_rating(:,1), likert_rating(:,2), 'o'); 
% hold on;
% plot(likert_rating(:,1),group2_fit,'LineWidth',3,'color','r');
% legend('Data','Linear Fit')
% xlabel('Likert Rating - First Half of Test');
% ylabel('Likert Rating - Second Half of Test');
% 
% n = numel(likert_rating(:,1));
% STE = 1/sqrt(n-3);
% %95% confidence interval, for 99% use 0.99:
% CI = norminv(0.95); 
% upper_bound = tanh(atanh(co)+CI*STE);
% lower_bound = tanh(atanh(co)-CI*STE);
