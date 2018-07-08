function [] = qiewav( jianNum,outName,dirPath,ath,delbeg,delEnd )
% �������ݲ��ж�
for num=1:jianNum
    
    %�����ļ���
    if strcmp(outName,'wav')
        fileName=[dirPath,'wavAudio',num2str(num-1),'.wav'];
    end
    filePath = fileName;
    %��������
    if strcmp(outName,'a')|| strcmp(outName,'oa')
        filePath=[fileName,'.txt'];
    end
    
    %  load filePath;
    if strcmp(outName,'wav')
        [Odata,fs] = audioread(filePath);
        fs = 44100;
        %ȥ����ǰx��
        Odata=Odata(delbeg(num)+1:end-delEnd(num),:);
        Odata = Odata';
        
        
        %ȥ�����x��
        Odata(1,:) = highpass(Odata(1,:),fs,20);
        Odata(1,:) = lowpass(Odata(1,:),fs,300);
        Odata(2,:) = highpass(Odata(2,:),fs,20);
        Odata(2,:) = lowpass(Odata(2,:),fs,300);
        Originaldata  = Odata(1,:);
        
    else
        Originaldata=dlmread(filePath);
        fs=100;
    end
    
    %�����ж�
    [result,ssbeg,ssend]=seg_var(Originaldata,fs);
    %д���кõ��ļ�����������ļ���
    if result==1
        data1 =[];
        data2 = [];
        for i=1:30
            data1=[data1;Odata(1,ssbeg(i):ssend(i))];
            data2=[data2;Odata(2,ssbeg(i):ssend(i))];
        end
        dlmwrite([dirPath,'wavJoint',num2str(num),'.txt'], [data1,data2], 'delimiter', ' ');
        dlmwrite([dirPath,'wavDiff',num2str(num),'.txt'], data1-data2, 'delimiter', ' ');
        dlmwrite([dirPath,'wavAdd',num2str(num),'.txt'], data1+data2, 'delimiter', ' ');
        
        
    else
        disp('û���к�');
    end;
end

end

