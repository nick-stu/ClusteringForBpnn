function [] = Cut(dirPath,ath,inter,type,fs)
%% ��������
load([dirPath type 'data_69k.mat']);
out=[];
for i=1:size(data,1)
    %% �����ж�
    fprintf('%d:',ceil(i/4));
    [dataout,result]=segmain2(data(i,:),fs,ath( ceil(i/4) ),inter( ceil(i/4) ));
    %% д���кõ��ļ�����������ļ���
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