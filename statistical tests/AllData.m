%import all data: 4-158 Files(k).name
Files=dir('/Users/fansy/Desktop/MA Research/fire/data01_preference_like');
%import image_id
data = dataset('xlsfile', 'FIRE_stim_info.xlsx');
Image_Name = dataset2cell(data(:,1));

%main trial 1-87: sbj, trial #, position, image_id ~ click (0 or 1)
numImg = 1030;

for k = 4
    %try
        %jsfile = fileread(Files(k).name);
        jsdata = jsondecode(fileread(Files(k).name));
        
        %sbj
        table((1:numImg),1) = num2cell(k-3);
        
        %image_id
        table((1:numImg),2) = Image_Name((2:1031),1);
        
        %image displayed
        for t = 17:103
            mat1(:,t-16) = vertcat(jsdata{t}.image_array{1}, jsdata{t}.image_array{2}, jsdata{t}.image_array{3});
        end
        
        for i = 1:numImg
            [row(i),col(i)] = find(mat1==string(Image_Name(i)));
        end
        
        %trial
        table((1:numImg),3) = num2cell(transpose(col));
        
        %row
        table((1:numImg),4) = num2cell(transpose(ceil(row/4)));
        
        %column
        table((1:numImg),5) = num2cell(transpose(rem(row,4)));
        column = cell2mat(table((1:numImg),5));
        column(column==0) = 4;
        table((1:numImg),5) = num2cell(column);
        
        %click
        for t = 17:103
            click(:,t-16) = jsdata{t}.clikced;
        end
        mat2 = click(:);
        
        A = table((1:numImg),2);
        Z = zeros(size(A));
        for p = 1: size(A,1)
            Z(p,:) = ismember(A(p,:),mat2);
        end
        table(:,6) = num2cell(Z);
        
        All_Data{k} = table;
    %catch ME
    %end
end

%save('All_Data.mat', 'All_Data');



