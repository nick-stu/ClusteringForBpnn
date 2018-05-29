function [] = qiewav( jianNum,outName,dirPath,ath,delbeg,delEnd )
% 导入数据并切断
for num=1:jianNum
    
    %设置文件名
    if strcmp(outName,'wav')
        fileName=[dirPath,'wavAudio',num2str(num-1),'.wav'];
    end
    filePath = fileName;
    %导入数据
    if strcmp(outName,'a')|| strcmp(outName,'oa')
        filePath=[fileName,'.txt'];
    end
    
    %  load filePath;
    if strcmp(outName,'wav')
        [Odata,fs] = audioread(filePath);
        fs = 44100;
        %去掉最前x点
        Odata=Odata(delbeg(num)+1:end-delEnd(num),:);
        Odata = Odata';
        
        
        %去掉最后x点
        Odata(1,:) = highpass(Odata(1,:),fs,20);
        Odata(1,:) = lowpass(Odata(1,:),fs,300);
        Odata(2,:) = highpass(Odata(2,:),fs,20);
        Odata(2,:) = lowpass(Odata(2,:),fs,300);
        Originaldata  = Odata(1,:);
        
    else
        Originaldata=dlmread(filePath);
        fs=100;
    end
    
    %进行切断
    [result,ssbeg,ssend]=seg_var(Originaldata,fs);
    %写出切好的文件并设置输出文件名
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
        disp('没有切好');
    end;
end

end

