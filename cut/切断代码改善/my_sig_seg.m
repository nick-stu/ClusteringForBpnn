function [startIndex,endIndex]=my_sig_seg(data,fs,Lm,Rm,ethreshScale,minlen,maxInter,minInter,segLen,Debug,eDebug)
%-------------------------------����˵��-----------------------------------
% �������ܣ��жϺ���
% ʵ�ַ�����1�����ڶ�ʱ�������������źţ� 2�����ڶ�ʱ�����Ͷ�ʱ�����ʣ������źţ�
% ---------------------------
% ����˵��
% input��
% data����Ҫ�и���źţ�Ϊһ����ά����
% fs:�źŵĲ���Ƶ��
% Lm:֡����msΪ��λ
% ethreshScale����ʱ�����͡�����ֵ��С�ı���
% zcthresh����ʱ��������ֵ
% minlen����̵��źų��ȣ�����ȥ������̫С�ķ壩
% maxInter��ͬһ���źŵ����ڷ�������(���ںϲ�ͬһ���źŵ����ڷ�)
% minInter=50; %��ͬ�źŵ���С���(����ȥ��������С���ȣ������ڼ��̫С���ź�)
% segLen��
% output��
% startIndex���ź��и�����
% endIndex���ź��и���յ�
% --------------------------
% ��������ʾ����
% �и�Ų����Ĳ�������
% Lm=7; %֡��
% Rm=3.2; %֡��
% ethreshScale = [10,2]; %��ʱ�����͡�����ֵ��С�ı���
% zcthresh=1; %�����������ֵ
% minlen  = 3; %��̵ĽŲ����ĳ��ȣ�����ȥ������̫С�ķ壩
% maxInter=40; %ͬһ���Ų��������ڷ�������(���ںϲ�ͬһ���Ų��������ڷ�)
% minInter=50; %��ͬ�Ų��������ڷ����С���(����ȥ��������С���ȣ������ڼ��̫С�ķ�)
% segLen=40; %�и�ÿһ���źŵĳ��ȣ�֡����
% Debug=1; %�Ƿ���ʾ�и�ʾ��ͼ
% --------------------------
% �ر�˵����ע�������
% ���������и������źţ����������С����ֵ�������Ǵ�����ֵ����Ҫ�޸Ĵ�����иʼ�Ǹ�whileѭ��
%--------------------------------------------------------------------------
    data=data'; %���źŴ�������ת�ó�������
    
    L=round(Lm*fs/1000); %��֡��ת���ɵ���
    R=round(Rm*fs/1000); %��֡��ת���ɵ���
    
    nsamples=length(data); %ȡ�źŵĵ���
    ss=1; %��ʼ��ss
    loge=[]; %��������洢ÿһ֡�źŵ�log dB����
    zc=[]; %��������洢ÿһ֡�źŵĹ�����
    while (ss+L-1 <= nsamples)
        frame=data(ss:ss+L-1).*hamming(L); %��֡��ȡ��һ֡�ź�
        loge=[loge 10*log10(sum(frame.^2))]; %����һ֡�ź�log dB����
        zc=[zc sum(abs(diff(sign(frame))))]; %����һ֡�źŵĹ�����
        ss=ss+R; %����ss������ȡ��һ֡�ź�
    end
    nfrm=length(loge); %��ȡ�źŵ�֡��
    
    %zc = normalized (per 10 msec) zero crossings contour for utterance
    zc=zc*fs/(100*L); %�ѹ����ʱ�׼����10msÿ֡�ź�
          
    y=data;
    zcs=zc;
    
    % normalize log loge contour so that peak is at 0 db
    logem=max(loge); %ȡ��ߵ�֡����
    loge(find(loge < logem - 60))=logem-60; %������С��logem - 60��֡���������ó�logem - 60
    logen=loge-logem; %�����е�֡��������׼����-60~0dB
    plotlogen=logen;
    
        
    %����������������ֵ
    maxEnergy=max(logen); %==0 ���źŵ����ֵ
    meanNoiseEnergy=(logen(1)+logen(end))/2; %������ƽ��ֵ
    
    meanEnergy=mean(logen); %�źŵľ�ֵ
    stdValue=std(logen,1); %�źŵı�׼��
    
%     ethresh(1)=meanNoiseEnergy+(maxEnergy-meanNoiseEnergy)/ethreshScale(1); %����ֵ
%     ethresh(2)=meanNoiseEnergy+(maxEnergy-meanNoiseEnergy)/ethreshScale(2); %����ֵ

%     ethresh(1)=meanNoiseEnergy+(maxEnergy-meanNoiseEnergy)/ethreshScale(1); %����ֵ
%     ethresh(2)=meanEnergy+3*stdValue; %����ֵ

    ethresh(1)=meanEnergy+1*stdValue; %����ֵ
    ethresh(2)=meanEnergy+3*stdValue; %����ֵ


    
    
    % force first frame to be below threshold
    % �ѵ�һ֡���������õ���������ֵ
    if (logen(1) > ethresh(1)-1)  
        logen(1)=ethresh(1)-1;
    end
    
    % force last frame to be below threshold
    % �����һ֡���������õ���������ֵ
    if (logen(nfrm) > ethresh(1)-1) 
        logen(nfrm)=ethresh(1)-1;
    end
    
    if eDebug==1
        figure;
        % plot log loge contour in graphics Panel 2
        plot(1:nfrm,plotlogen,'r','LineWidth',2),xlabel('Frame Number'),...
            ylabel('log loge (dB)'),hold on,grid on;

        %������ͼ�л�����������ֵ��
        % plot log loge threshold
        xx=[1 nfrm];
        yy=[ethresh(1) ethresh(1)];
        plot(xx,yy,'k:','LineWidth',2); axis tight;
        axis([0 nfrm+1 min(plotlogen) max(plotlogen)]);
        text(length(plotlogen),ethresh(1),['TL=',num2str(ethresh(1))]); %��ʾ�������ֵ

        xx=[1 nfrm];
        yy=[ethresh(2) ethresh(2)];
        plot(xx,yy,'r:','LineWidth',2); axis tight;
        axis([0 nfrm+1 min(plotlogen) max(plotlogen)]);
        text(length(plotlogen),ethresh(2),['TH=',num2str(ethresh(2))]); %��ʾ�������ֵ
    end
    
    isav=1;
    %�и�Ŀ�ʼ
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

        %��ֹ���һ�ԭ����λ��
%         zcs(peak1(isav):peak2(isav))=1000; 
        %��ֹ���һ�ԭ����λ��
        logen(peak1(isav):peak2(isav))=ethresh(1)-1000;
     
        isav=isav+1;
    end

    %determine final endpoints
    %������ȥ������0
    peak1s=sort(peak1(1:isav));
    peak2s=sort(peak2(1:isav));   
  
%     while(0)
    %��ͬһ���Ų��������ڷ�ϲ�
    %length(peak1s)~=1��Ϊ�˷�ֹֻ��һ����ʱ�����������i+1����������
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
            %�ϲ�������󣬰ѱ��ϲ��ķ���ռ��λ��������������ǴӴ�С���ţ�˳�򲻱䣬�������ǰ��
            peak1s=peak1s(find(peak1s~=0));
            peak2s=peak2s(find(peak2s~=0));
            % ǰ���Ӧ˳�򲻱䣬���Բ����ٴ�������
            % peak1s=sort(peak1s(1:end));
            % peak2s=sort(peak2s(1:end));
            i=i+1;
        end
    end
  
    peakSize=peak2s-peak1s;
    
    %ȥ������С����С�����������ҵļ��������ͬһ���Ų��������������������񶯷�
    %��������ĺϲ������з�֮��ļ��������ͬһ���Ų�������������������
    %�ͳ��ȴ�����С���ȵ������Ҽ��С�ڲ�ͬ�Ų��������ڷ����С������񶯷�
    %length(peak1s)~=1��Ϊ�˷�ֹֻ��һ����ʱ�����������i+1����������
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
     %ȥ��0�����������Ƚ��ٵ�
    peak1s=peak1s(find(peak1s~=0));
    peak2s=peak2s(find(peak2s~=0));
    
    peak2s=peak1s+segLen; %���ó��и�һ�����ȵķ�
    
    %���ؽ��
    %����ÿһ���Ų����Ĵ�С
    peakSize=peak2s-peak1s;
    %����Ų���֮��ļ��
    interval=peak1s(2:end)-peak2s(1:end-1);
    
    for index=1:length(peak1s)
        startIndex(index)=(peak1s(index)-1)*R+L/2+1; 
        endIndex(index)=(peak2s(index)-1)*R+L/2+1;
    end

%   for index=1:length(peak1s)
%       startIndex(index)=(peak1s(index)-1)*R+1; 
%       endIndex(index)=(peak2s(index)-1)*R+L;
%    end
    
    startIndex=uint32(startIndex); %ת����������
    endIndex=uint32(endIndex); %ת����������
    
    
    %��ͼ
    if Debug==1
         figure;
         subplot(211);
        % normalize speech signal to range [-1 +1]
            ym=max(abs(y));
            y=y/ym;

            %����ԭ�ź�,
            xlabel('Samples'),...
            plot(y,'b');
            ylabel('Amplitude'),grid on, axis tight;

            %�����и������λ��
            hold on; 
            for index=1:length(peak1s)             
                %����ǰһ֡�ͺ�һ֡�ģ����ǵ���֡�ź�
                % ssbeg=(peak1s(index)-1)*R+1; ssend=(peak2s(index)-1)*R+L;
                %����ǰһ֡�ͺ�һ֡�ģ����ǵİ�֡�ź�
                ssbeg=(peak1s(index)-1)*R+L/2+1; ssend=(peak2s(index)-1)*R+L/2+1;
                xx=[ssbeg ssbeg]; yy=[min(y) max(y)]; 
                plot(xx,yy,'k','LineWidth',2);
                xx=[ssend ssend]; 
                plot(xx,yy,'k','LineWidth',2);
                axis([1 length(y) min(y) max(y)]);
            end
            
        %����ԭ�źŵ�����
         subplot(212);
        % plot log loge contour in graphics Panel 2
        plot(1:nfrm,plotlogen,'r','LineWidth',2),xlabel('Frame Number'),...
            ylabel('log loge (dB)'),hold on,grid on;
    

        % plot each log loge centroid beginning and ending frames
        %�г�����֡���������ֵ�ȸ��ߵ�ǰһ֡��֡���յ�����ֵ�ȸ��ߵĺ�һ֡
        %���������������и�λ��
        for index=1:length(peak1s)
            xx=[peak1s(index) peak1s(index)];
            yy=[max(plotlogen) min(plotlogen)];
            plot(xx,yy,'g:','LineWidth',2);
            xx=[peak2s(index) peak2s(index)];
            plot(xx,yy,'b:','LineWidth',2);
        end
        %������ͼ�л�����������ֵ��
        % plot log loge threshold
        xx=[1 nfrm];
        yy=[ethresh(1) ethresh(1)];
        plot(xx,yy,'k:','LineWidth',2); axis tight;
        axis([0 nfrm+1 min(plotlogen) max(plotlogen)]);
        text(length(plotlogen),ethresh(1),['TL=',num2str(ethresh(1))]); %��ʾ�������ֵ

        xx=[1 nfrm];
        yy=[ethresh(2) ethresh(2)];
        plot(xx,yy,'r:','LineWidth',2); axis tight;
        axis([0 nfrm+1 min(plotlogen) max(plotlogen)]);
        text(length(plotlogen),ethresh(2),['TH=',num2str(ethresh(2))]); %��ʾ�������ֵ
        
        axis([0 nfrm+1 -60 0]);
    end
end