clear; clc;
warning off;
addpath(genpath(pwd));
basePath = './大力小力/';
dirs = dir(basePath);
sampleNum = 270;
for x=1:size(dirs, 1)
    if (dirs(x).name(1) == '.')
        continue;
    end
    fprintf('%s ', dirs(x).name);
    
    load([basePath, dirs(x).name, '/hard/harddecimate_data_0.6k.mat']);
    hard = decimate_data(1:sampleNum, :);
    psdData = PSD(hard, 600);
    decimate_data = cat(2,hard,psdData);
    save([basePath, dirs(x).name '/hard/' 'hard_decimatedata_0.6k_withPSD.mat'],'decimate_data');
    disp([basePath, dirs(x).name '/hard/' 'hard_decimatedata_0.6k_withPSD.mat']);
    
    load([basePath, dirs(x).name, '/gentle/gentledecimate_data_0.6k.mat']);
    gentle = decimate_data(1:sampleNum, :);
    psdData = PSD(gentle, 600);
    decimate_data = cat(2,gentle,psdData);
    save([basePath, dirs(x).name '/gentle/' 'gentle_decimatedata_0.6k_withPSD.mat'],'decimate_data');
    disp([basePath, dirs(x).name '/gentle/' 'gentle_decimatedata_0.6k_withPSD.mat']);
end