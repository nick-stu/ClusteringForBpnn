% ÇÐ¶Ï´úÂë
clc; clear; close all;
type={'over'; 'below'; 'left'; 'right'; 'center'};
dirPath='..\chj\data\';
ath=[18,12,16,19,15,13,16,10,12];
inter=[10,10,10,10,10,10,10,10,10];
fs=69000;
%% ÇÐ¶Ï
i=4;
Cut(dirPath,ath,inter,type{i},fs);