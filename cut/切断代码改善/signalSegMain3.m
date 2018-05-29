%-----------------------------
% 滤波切断主函数：切割原始数据，没有滤波的数据
% 需要调整的地方：
% 设置数据保存的路径
% 设置各个参数
% 切割脚步声的参数设置
% fileNamePrefix='WMR'; %文件名称的前缀
% testTimes=10; %实验重复的次数
% data=[data;dataOriginal(ssbeg(dataIndex):ssend(dataIndex))];
% data=trainsort(data,classNum,perSamplesNum);------E:\IoT\坚果云\IoT\Vikey\data\2017-9-19（cwq）
% save([dirPath,fileNamePrefix,'data20-300.mat'],'data');
% 文件格式为：**num1.txt，如：WM-R1.txt
% ssbeg=ssbeg+hpindex;
% ssend=ssend+hpindex;
%-----------------------------
clc;clear;close all
disp('程序正在运行中...');

%设置数据保存的路径
dirPath='E:\IoT\坚果云\IoT\Vikey\data\2017-9-26(lsh)\';
savePath='随机敲击\'; %数据保存的文件夹
decimatedataPath='测试数据\';
savefileFormat='.mat'; %保存数据格式

%设置各个参数
fileNamePrefix='WMR'; %文件名称的前缀
% fileNamePrefix='WOMR'; %文件名称的前缀
% fileNamePrefix='WMRT'; %文件名称的前缀
% fileNamePrefix='WOMRT'; %文件名称的前缀
if strcmp(fileNamePrefix, 'WMR') || strcmp(fileNamePrefix, 'WOMR')
    testTimes=30; %实验重复的次数
elseif strcmp(fileNamePrefix, 'WMRT') || strcmp(fileNamePrefix, 'WOMRT')
    testTimes=10; %实验重复的次数
else
    error('请选择正确的文件名！');
end
fileFormat='.txt'; %文件格式
knockTimes=9; %每次敲的次数
hpindex = 20000; %去掉高通滤波后前面20000个点
fs=65e3;

%切割脚步声的参数设置
Lm=7; %帧长
Rm=3.2; %帧移
ethresh = 20; %能量最小阈值
zcthresh=1; %过零率最大阈值
minlen  = 3; %最短的脚步声的长度（用于去除长度太小的峰）
maxInter=40; %同一个脚步声的相邻峰的最大间隔(用于合并同一个脚步声的相邻峰)
minInter=50; %不同脚步声的相邻峰的最小间隔(用于去除大于最小长度，但相邻间隔太小的峰)
segLen=40; %切割每一个信号的长度（帧数）
Debug=1; %是否显示切割示意图
filterDebug=0; %是否显示滤波后的信号 
cycleIndex=1; %循环的序号

data=[]; %初始化data,用于保存九个键的数据
% 1:testTimes
for i=1
    dataPath=[dirPath,savePath]; %获取文件的路径
    fileName=[fileNamePrefix,num2str(i)]; %获取文件的名称
    disp([num2str(cycleIndex),':',dataPath,fileName,fileFormat]); %输出提示信息
    dataOriginal=dlmread([dataPath,fileName,fileFormat]); %原始加载数据   
    dataOriginal=dataOriginal'; %转置为行向量
    %画出原始数据
    if filterDebug==1
        figure;
        plot(dataOriginal);
        title('原始数据');
        grid;
    end
    %高通滤波，滤掉20HZ以下的频率
    hpdata=highpass(dataOriginal,fs,20); 
    if filterDebug==1
        figure;
        plot(hpdata);
        title('高通滤波后的数据');
        grid;
    end
    hpdata=hpdata(hpindex:end); %去掉前面20000个点
    if filterDebug==1
        figure;
        plot(hpdata);
        title(['高通滤波','去掉前面的',num2str(hpindex),'个点后的数据']);
        grid;
    end
    %低通滤波，去掉高频噪音
    lpdata=lowpass(hpdata,fs,300);
    if filterDebug==1
        figure;
        plot(lpdata);
        title('低通300HZ后的数据');
        grid;
    end

    [ssbeg,ssend,peakSize]=my_sig_seg(lpdata,fs,Lm,Rm,ethresh,...
    zcthresh,minlen,maxInter,minInter,Debug); %切断

    if length(ssbeg)~=length(ssend) || length(ssbeg)~=knockTimes
        error(['length(ssbeg)~=length(ssend) or length(ssbeg)~=',num2str(knockTimes)]);
    end
    %把之前去掉的点数加回去
    ssbeg=ssbeg+hpindex;
    ssend=ssend+hpindex;
    for dataIndex=1:length(ssbeg)
        data=[data;dataOriginal(ssbeg(dataIndex):ssend(dataIndex))];
    end
    cycleIndex=cycleIndex+1; %循环序号增1
end

disp('切断完毕！');
figure;
plot(data(1,:))




