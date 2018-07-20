clear; clc;
load('./fc/fisher-score/fisher-score/data.mat');

% 1 key
amp = 1:78;
mfcc = 79:208;
fft = 209:248;
force = 249:330;
asd = 331:369;
skinput = 370:501;
psd = 502:541;

% 2 key
% amp = 1:156;
% mfcc = 157:416;
% fft = 417:496;
% force = 497:660;
% asd = 661:738;
% skinput = 739:1002;
% psd = 1003:1082;
% interval = 1083:1083;

% 3 key
% amp = 1:234;
% mfcc = 235:624;
% fft = 625:744;
% force = 745:990;
% asd = 991:1107;
% skinput = 1108:1503;
% psd = 1504:1623;
% interval = 1624:1626;

% 4 key
% amp = 1:312;
% mfcc = 313:832;
% fft = 833:992;
% force = 993:1320;
% asd = 1321:1476;
% skinput = 1477:2004;
% psd = 2005:2164;
% interval = 2165:2170;

data = data(:, [asd,skinput,psd,mfcc]);
% data = data(:, 249:330);
[data,demension] = DTSelection(data, 8, 'one');

save('./asd&skinput&psd&mfcc.mat','demension') ;
sample_size = size(data, 1);
people_num = 8;
per_num = sample_size / people_num;
train_size = 20;

eer = zeros(people_num, 1);
for p=1:people_num
    merange = (p - 1) * per_num + 1 : p * per_num;
    medata = data(merange, :);
    % random medata
    medata = medata(randperm(per_num), :);
    otherdata = data;
    otherdata(merange, :) = [];
    
    % k fold
    k = per_num / train_size;
    for i=1:k
        trainrange = (i - 1) * train_size + 1 : i * train_size;
        traindata = medata(trainrange, :);
        testdata = medata;
        testdata(trainrange, :) = [];
        eer(p) = eer(p) + calEER(traindata, testdata, otherdata, ones(1, size(data, 2)));
    end
    eer(p) = eer(p) / k;
    fprintf("%.4f\n", eer(p));
end
fprintf("avg = %.4f\n", mean(eer));
