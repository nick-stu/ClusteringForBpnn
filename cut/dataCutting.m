% ÇÐ¶Ï´úÂë
clc; clear; close all;
type={'over'; 'below'; 'left'; 'right'; 'center'};
dirPath='..\chj\data\';
% ath=[18,12,14,16,16,15,18,14,18];
% inter=[20,10,10,10,10,10,10,10,10];
ath=[20,18,20,20,19,21,18,17,18];
inter=[20,10,10,10,10,10,10,10,10];
fs=69000;
%% ÇÐ¶Ï
i=5;
Cut(dirPath,ath,inter,type{i},fs);