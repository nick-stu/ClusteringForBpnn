function [startIndex,endIndex]=my_sig_seg(data,fs,Lm,Rm,ethreshScale,minlen,maxInter,minInter,segLen,Debug,eDebug)
%-------------------------------函数说明-----------------------------------
% 函数功能：切断函数
% 实现方法：1、基于短时能量（非语音信号） 2、基于短时能量和短时过零率（语音信号）
% ---------------------------
% 参数说明
% input：
% data：需要切割的信号，为一个多维向量
% fs:信号的采样频率
% Lm:帧长，ms为单位
% ethreshScale：短时能量低、高阈值缩小的比例
% zcthresh：短时过零率阈值
% minlen：最短的信号长度（用于去除长度太小的峰）
% maxInter：同一个信号的相邻峰的最大间隔(用于合并同一个信号的相邻峰)
% minInter=50; %不同信号的最小间隔(用于去除大于最小长度，但相邻间隔太小的信号)
% segLen：
% output：
% startIndex：信号切割的起点
% endIndex：信号切割的终点
% --------------------------
% 参数设置示例：
% 切割脚步声的参数设置
% Lm=7; %帧长
% Rm=3.2; %帧移
% ethreshScale = [10,2]; %短时能量低、高阈值缩小的比例
% zcthresh=1; %过零率最大阈值
% minlen  = 3; %最短的脚步声的长度（用于去除长度太小的峰）
% maxInter=40; %同一个脚步声的相邻峰的最大间隔(用于合并同一个脚步声的相邻峰)
% minInter=50; %不同脚步声的相邻峰的最小间隔(用于去除大于最小长度，但相邻间隔太小的峰)
% segLen=40; %切割每一个信号的长度（帧数）
% Debug=1; %是否显示切割示意图
% --------------------------
% 特别说明（注意事项）：
% 若是用于切割语音信号，则过零率是小于阈值，而不是大于阈值，需要修改代码的切割开始那个while循环
%--------------------------------------------------------------------------
    data=data'; %把信号从行向量转置成列向量
    
    L=round(Lm*fs/1000); %把帧长转换成点数
    R=round(Rm*fs/1000); %把帧移转换成点数
    
    nsamples=length(data); %取信号的点数
    ss=1; %初始化ss
    loge=[]; %定义变量存储每一帧信号的log dB能量
    zc=[]; %定义变量存储每一帧信号的过零率
    while (ss+L-1 <= nsamples)
        frame=data(ss:ss+L-1).*hamming(L); %分帧，取出一帧信号
        loge=[loge 10*log10(sum(frame.^2))]; %计算一帧信号log dB能量
        zc=[zc sum(abs(diff(sign(frame))))]; %计算一帧信号的过零率
        ss=ss+R; %更新ss，用于取下一帧信号
    end
    nfrm=length(loge); %获取信号的帧数
    
    %zc = normalized (per 10 msec) zero crossings contour for utterance
    zc=zc*fs/(100*L); %把过零率标准化到10ms每帧信号
          
    y=data;
    zcs=zc;
    
    % normalize log loge contour so that peak is at 0 db
    logem=max(loge); %取最高的帧能量
    loge(find(loge < logem - 60))=logem-60; %把能量小于logem - 60的帧的能量设置成logem - 60
    logen=loge-logem; %把所有的帧的能量标准化到-60~0dB
    plotlogen=logen;
    
        
    %设置能量的两个阈值
    maxEnergy=max(logen); %==0 ，信号的最大值
    meanNoiseEnergy=(logen(1)+logen(end))/2; %噪音的平均值
    
    meanEnergy=mean(logen); %信号的均值
    stdValue=std(logen,1); %信号的标准差
    
%     ethresh(1)=meanNoiseEnergy+(maxEnergy-meanNoiseEnergy)/ethreshScale(1); %低阈值
%     ethresh(2)=meanNoiseEnergy+(maxEnergy-meanNoiseEnergy)/ethreshScale(2); %高阈值

%     ethresh(1)=meanNoiseEnergy+(maxEnergy-meanNoiseEnergy)/ethreshScale(1); %低阈值
%     ethresh(2)=meanEnergy+3*stdValue; %高阈值

    ethresh(1)=meanEnergy+1*stdValue; %低阈值
    ethresh(2)=meanEnergy+3*stdValue; %高阈值


    
    
    % force first frame to be below threshold
    % 把第一帧的能量设置低于能量阈值
    if (logen(1) > ethresh(1)-1)  
        logen(1)=ethresh(1)-1;
    end
    
    % force last frame to be below threshold
    % 把最后一帧的能量设置低于能量阈值
    if (logen(nfrm) > ethresh(1)-1) 
        logen(nfrm)=ethresh(1)-1;
    end
    
    if eDebug==1
        figure;
        % plot log loge contour in graphics Panel 2
        plot(1:nfrm,plotlogen,'r','LineWidth',2),xlabel('Frame Number'),...
            ylabel('log loge (dB)'),hold on,grid on;

        %在能量图中画出能量的阈值线
        % plot log loge threshold
        xx=[1 nfrm];
        yy=[ethresh(1) ethresh(1)];
        plot(xx,yy,'k:','LineWidth',2); axis tight;
        axis([0 nfrm+1 min(plotlogen) max(plotlogen)]);
        text(length(plotlogen),ethresh(1),['TL=',num2str(ethresh(1))]); %显示具体的阈值

        xx=[1 nfrm];
        yy=[ethresh(2) ethresh(2)];
        plot(xx,yy,'r:','LineWidth',2); axis tight;
        axis([0 nfrm+1 min(plotlogen) max(plotlogen)]);
        text(length(plotlogen),ethresh(2),['TH=',num2str(ethresh(2))]); %显示具体的阈值
    end
    
    isav=1;
    %切割的开始
    while(1)
        % using threshold of 0 (dB) -thresh, find the strongest centroid and zero
        % out the region for future checks
        % peak1 is the lower peak, peak2 is the higher peak
        logem=max(logen);
        if (logem < ethresh(2))
           isav=isav-1;
           break;
        end

%         zcm=min(zcs);
%         peak=find(zcs == zcm);
%         if (zcm > zcthresh || peak(1) < 5 || peak(1) > nfrm-5) 
%             isav=isav-1;
%             break;
%         end
            
%         peak=find(logen == logem);
%         peaklow=find((logen(1:peak(1)-1) < -ethresh) & (zcs(1:peak(1)-1) > zcthresh));
%         peak1(isav)=peaklow(length(peaklow));
%         peakhi=find(logen(peak(1)+1:nfrm) < -ethresh & zcs(peak(1)+1:nfrm) > zcthresh);
%         peak2(isav)=peakhi(1)+peak(1);
        peak=find(logen == logem);
        peaklow=find((logen(1:peak(1)-1) < ethresh(1)));
        peak1(isav)=peaklow(length(peaklow))+1;
        peakhi=find(logen(peak(1)+1:nfrm) < ethresh(1));
        peak2(isav)=peakhi(1)+peak(1)-1;

        %防止又找回原来的位置
%         zcs(peak1(isav):peak2(isav))=1000; 
        %防止又找回原来的位置
        logen(peak1(isav):peak2(isav))=ethresh(1)-1000;
     
        isav=isav+1;
    end

    %determine final endpoints
    %排序且去掉最后的0
    peak1s=sort(peak1(1:isav));
    peak2s=sort(peak2(1:isav));   
  
%     while(0)
    %把同一个脚步声的相邻峰合并
    %length(peak1s)~=1是为了防止只有一个峰时的特殊情况：i+1大于索引了
    flag=1;
    while(flag==1)
        flag=0;
        i=1;
        while (i<=length(peak1s))
            if(i~=1 && i~=length(peak1s))
                if (abs(peak1s(i)-peak2s(i-1)) <= abs(peak2s(i)-peak1s(i+1)) && abs(peak1s(i)-peak2s(i-1)) <= maxInter)
                    peak2s(i-1)=peak2s(i);
                    peak1s(i)=0;
                    peak2s(i)=0;
                    flag=1;
                    i=1-1;
                elseif (abs(peak1s(i)-peak2s(i-1)) >= abs(peak2s(i)-peak1s(i+1)) && abs(peak2s(i)-peak1s(i+1))<= maxInter)
                    peak1s(i+1)=peak1s(i);
                    peak1s(i)=0;
                    peak2s(i)=0;
                    flag=1;
                    i=1-1;
                end
            elseif (i==1 && length(peak1s)~=1 && abs(peak2s(i)-peak1s(i+1))<= maxInter)
                    peak1s(i+1)=peak1s(i);
                    peak1s(i)=0;
                    peak2s(i)=0;
                    flag=1;
                    i=1-1;
            elseif (i==length(peaks) && length(peak1s)~=1 && abs(peak1s(i)-peak2s(i-1))<= maxInter)
                    peak2s(i-1)=peak2s(i);
                    peak1s(i)=0;
                    peak2s(i)=0;
                    flag=1;  
                    i=1-1;
            end
            % update peak1s, peak2s and determine final endpoints
            %合并两个峰后，把被合并的峰所占的位置清楚掉，排序还是从大到小来排，顺序不变，后面得向前挤
            peak1s=peak1s(find(peak1s~=0));
            peak2s=peak2s(find(peak2s~=0));
            % 前后对应顺序不变，所以不用再次排序了
            % peak1s=sort(peak1s(1:end));
            % peak2s=sort(peak2s(1:end));
            i=i+1;
        end
    end
  
    peakSize=peak2s-peak1s;
    
    %去除长度小于最小长度且离左右的间隔都大于同一个脚步声的两个峰的最大间隔的振动峰
    %经过上面的合并，所有峰之间的间隔都大于同一个脚步声的两个峰的最大间隔了
    %和长度大于最小长度但离左右间隔小于不同脚步声的相邻峰的最小间隔的振动峰
    %length(peak1s)~=1是为了防止只有一个峰时的特殊情况：i+1大于索引了
    for i=1:length(peak1s)
        if (peak2s(i)-peak1s(i) < minlen)
                peak1s(i)=0;
                peak2s(i)=0;
        else            
            if (i~=length(peak1s) && length(peak1s)~=1 && abs(peak2s(i)-peak1s(i+1)) < minInter)
                if peakSize(i)>= peakSize(i+1)
                    peak1s(i+1)=0;
                    peak2s(i+1)=0;  
                else
                    peak1s(i)=0;
                    peak2s(i)=0;                    
                end
            end
        end
    end 
     %去掉0，即舍弃长度较少的
    peak1s=peak1s(find(peak1s~=0));
    peak2s=peak2s(find(peak2s~=0));
    
    peak2s=peak1s+segLen; %设置成切割一定长度的峰
    
    %返回结果
    %计算每一个脚步声的大小
    peakSize=peak2s-peak1s;
    %计算脚步声之间的间隔
    interval=peak1s(2:end)-peak2s(1:end-1);
    
    for index=1:length(peak1s)
        startIndex(index)=(peak1s(index)-1)*R+L/2+1; 
        endIndex(index)=(peak2s(index)-1)*R+L/2+1;
    end

%   for index=1:length(peak1s)
%       startIndex(index)=(peak1s(index)-1)*R+1; 
%       endIndex(index)=(peak2s(index)-1)*R+L;
%    end
    
    startIndex=uint32(startIndex); %转成整数类型
    endIndex=uint32(endIndex); %转成整数类型
    
    
    %画图
    if Debug==1
         figure;
         subplot(211);
        % normalize speech signal to range [-1 +1]
            ym=max(abs(y));
            y=y/ym;

            %画出原信号,
            xlabel('Samples'),...
            plot(y,'b');
            ylabel('Amplitude'),grid on, axis tight;

            %画出切割出来的位置
            hold on; 
            for index=1:length(peak1s)             
                %包含前一帧和后一帧的，他们的整帧信号
                % ssbeg=(peak1s(index)-1)*R+1; ssend=(peak2s(index)-1)*R+L;
                %包含前一帧和后一帧的，他们的半帧信号
                ssbeg=(peak1s(index)-1)*R+L/2+1; ssend=(peak2s(index)-1)*R+L/2+1;
                xx=[ssbeg ssbeg]; yy=[min(y) max(y)]; 
                plot(xx,yy,'k','LineWidth',2);
                xx=[ssend ssend]; 
                plot(xx,yy,'k','LineWidth',2);
                axis([1 length(y) min(y) max(y)]);
            end
            
        %画出原信号的能量
         subplot(212);
        % plot log loge contour in graphics Panel 2
        plot(1:nfrm,plotlogen,'r','LineWidth',2),xlabel('Frame Number'),...
            ylabel('log loge (dB)'),hold on,grid on;
    

        % plot each log loge centroid beginning and ending frames
        %切出来的帧的起点是阈值等高线的前一帧，帧的终点是阈值等高线的后一帧
        %画出能量决定的切割位置
        for index=1:length(peak1s)
            xx=[peak1s(index) peak1s(index)];
            yy=[max(plotlogen) min(plotlogen)];
            plot(xx,yy,'g:','LineWidth',2);
            xx=[peak2s(index) peak2s(index)];
            plot(xx,yy,'b:','LineWidth',2);
        end
        %在能量图中画出能量的阈值线
        % plot log loge threshold
        xx=[1 nfrm];
        yy=[ethresh(1) ethresh(1)];
        plot(xx,yy,'k:','LineWidth',2); axis tight;
        axis([0 nfrm+1 min(plotlogen) max(plotlogen)]);
        text(length(plotlogen),ethresh(1),['TL=',num2str(ethresh(1))]); %显示具体的阈值

        xx=[1 nfrm];
        yy=[ethresh(2) ethresh(2)];
        plot(xx,yy,'r:','LineWidth',2); axis tight;
        axis([0 nfrm+1 min(plotlogen) max(plotlogen)]);
        text(length(plotlogen),ethresh(2),['TH=',num2str(ethresh(2))]); %显示具体的阈值
        
        axis([0 nfrm+1 -60 0]);
    end
end