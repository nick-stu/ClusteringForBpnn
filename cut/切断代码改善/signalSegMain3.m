%-----------------------------
% �˲��ж����������и�ԭʼ���ݣ�û���˲�������
% ��Ҫ�����ĵط���
% �������ݱ����·��
% ���ø�������
% �и�Ų����Ĳ�������
% fileNamePrefix='WMR'; %�ļ����Ƶ�ǰ׺
% testTimes=10; %ʵ���ظ��Ĵ���
% data=[data;dataOriginal(ssbeg(dataIndex):ssend(dataIndex))];
% data=trainsort(data,classNum,perSamplesNum);------E:\IoT\�����\IoT\Vikey\data\2017-9-19��cwq��
% save([dirPath,fileNamePrefix,'data20-300.mat'],'data');
% �ļ���ʽΪ��**num1.txt���磺WM-R1.txt
% ssbeg=ssbeg+hpindex;
% ssend=ssend+hpindex;
%-----------------------------
clc;clear;close all
disp('��������������...');

%�������ݱ����·��
dirPath='E:\IoT\�����\IoT\Vikey\data\2017-9-26(lsh)\';
savePath='����û�\'; %���ݱ�����ļ���
decimatedataPath='��������\';
savefileFormat='.mat'; %�������ݸ�ʽ

%���ø�������
fileNamePrefix='WMR'; %�ļ����Ƶ�ǰ׺
% fileNamePrefix='WOMR'; %�ļ����Ƶ�ǰ׺
% fileNamePrefix='WMRT'; %�ļ����Ƶ�ǰ׺
% fileNamePrefix='WOMRT'; %�ļ����Ƶ�ǰ׺
if strcmp(fileNamePrefix, 'WMR') || strcmp(fileNamePrefix, 'WOMR')
    testTimes=30; %ʵ���ظ��Ĵ���
elseif strcmp(fileNamePrefix, 'WMRT') || strcmp(fileNamePrefix, 'WOMRT')
    testTimes=10; %ʵ���ظ��Ĵ���
else
    error('��ѡ����ȷ���ļ�����');
end
fileFormat='.txt'; %�ļ���ʽ
knockTimes=9; %ÿ���õĴ���
hpindex = 20000; %ȥ����ͨ�˲���ǰ��20000����
fs=65e3;

%�и�Ų����Ĳ�������
Lm=7; %֡��
Rm=3.2; %֡��
ethresh = 20; %������С��ֵ
zcthresh=1; %�����������ֵ
minlen  = 3; %��̵ĽŲ����ĳ��ȣ�����ȥ������̫С�ķ壩
maxInter=40; %ͬһ���Ų��������ڷ�������(���ںϲ�ͬһ���Ų��������ڷ�)
minInter=50; %��ͬ�Ų��������ڷ����С���(����ȥ��������С���ȣ������ڼ��̫С�ķ�)
segLen=40; %�и�ÿһ���źŵĳ��ȣ�֡����
Debug=1; %�Ƿ���ʾ�и�ʾ��ͼ
filterDebug=0; %�Ƿ���ʾ�˲�����ź� 
cycleIndex=1; %ѭ�������

data=[]; %��ʼ��data,���ڱ���Ÿ���������
% 1:testTimes
for i=1
    dataPath=[dirPath,savePath]; %��ȡ�ļ���·��
    fileName=[fileNamePrefix,num2str(i)]; %��ȡ�ļ�������
    disp([num2str(cycleIndex),':',dataPath,fileName,fileFormat]); %�����ʾ��Ϣ
    dataOriginal=dlmread([dataPath,fileName,fileFormat]); %ԭʼ��������   
    dataOriginal=dataOriginal'; %ת��Ϊ������
    %����ԭʼ����
    if filterDebug==1
        figure;
        plot(dataOriginal);
        title('ԭʼ����');
        grid;
    end
    %��ͨ�˲����˵�20HZ���µ�Ƶ��
    hpdata=highpass(dataOriginal,fs,20); 
    if filterDebug==1
        figure;
        plot(hpdata);
        title('��ͨ�˲��������');
        grid;
    end
    hpdata=hpdata(hpindex:end); %ȥ��ǰ��20000����
    if filterDebug==1
        figure;
        plot(hpdata);
        title(['��ͨ�˲�','ȥ��ǰ���',num2str(hpindex),'����������']);
        grid;
    end
    %��ͨ�˲���ȥ����Ƶ����
    lpdata=lowpass(hpdata,fs,300);
    if filterDebug==1
        figure;
        plot(lpdata);
        title('��ͨ300HZ�������');
        grid;
    end

    [ssbeg,ssend,peakSize]=my_sig_seg(lpdata,fs,Lm,Rm,ethresh,...
    zcthresh,minlen,maxInter,minInter,Debug); %�ж�

    if length(ssbeg)~=length(ssend) || length(ssbeg)~=knockTimes
        error(['length(ssbeg)~=length(ssend) or length(ssbeg)~=',num2str(knockTimes)]);
    end
    %��֮ǰȥ���ĵ����ӻ�ȥ
    ssbeg=ssbeg+hpindex;
    ssend=ssend+hpindex;
    for dataIndex=1:length(ssbeg)
        data=[data;dataOriginal(ssbeg(dataIndex):ssend(dataIndex))];
    end
    cycleIndex=cycleIndex+1; %ѭ�������1
end

disp('�ж���ϣ�');
figure;
plot(data(1,:))




