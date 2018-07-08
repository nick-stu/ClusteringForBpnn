%% 切断代码
clc; clear; close all;
type={'over'; 'below'; 'left'; 'right'; 'center'};
dirPath='..\chj\data\';
fs=69000;
%% 切断
i=4;
%% 导入数据
load([dirPath type{i} 'data_69k.mat']);
data=data( 4*1+1 :4*2 ,:);
out=[];
%% 进行切断
[dataout,result]=segmain2(data(1,:),fs,14,10);
if result~=1
   fprintf('Fail...\n');
end
out=[out;dataout];