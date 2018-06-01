function [] = Cut(dirPath,ath,inter,type,fs)
%% 导入数据
load([dirPath type 'data_69k.mat']);
out=[];
for i=1:size(data,1)
    %% 进行切断
    fprintf('%d:',ceil(i/4));
    [dataout,result]=segmain2(data(i,:),fs,ath( ceil(i/4) ),inter( ceil(i/4) ));
    %% 写出切好的文件并设置输出文件名
    if result==1
       out=[out;dataout];
    else
       fprintf('Fail...\n');
    end
    
    if mod(i,12)==0 
       fprintf('');
%        close all;
    end
end
data=out;
save( [dirPath type 'data20-300_69k'] ,'data');
fprintf('ok\n');