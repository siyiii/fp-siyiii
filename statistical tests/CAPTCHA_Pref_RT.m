%import all data: 4-158 Files(k).name
Files=dir('/Users/fansy/Desktop/MA Research/fire/data01_preference_like');

for k = 4:158 %subject
    try
        %jsfile = fileread(Files(k).name);
        jsdata = jsondecode(fileread(Files(k).name)); %data group for each sbj
        
        %reaction time
        for t = 17:103
            rt(k-3,t-16) = jsdata{t}.rt; %rows: subject; column: reaction time to 12 images 
        end
    catch ME
    end
    
end

CAPTCHA_RT = rt(any(rt,2),:); 
save('CAPTCHA_RT.mat', 'CAPTCHA_RT');



