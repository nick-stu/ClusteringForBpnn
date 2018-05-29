% ÇÐ¶Ï´úÂë
clc; clear; close all;
type={'over'; 'below'; 'left'; 'right'; 'center'};
dirPath='..\chj\data\';
ath=[21,18,18,19,18,20,21,15,18];
inter=[20,10,10,10,10,10,10,10,10];
fs=69000;
%% ÇÐ¶Ï
i=3;
Cut(dirPath,ath,inter,type{i},fs);