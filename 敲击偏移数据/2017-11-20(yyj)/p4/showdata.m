clc;clear;close all

data=dlmread('channel_0.txt');

figure(1);     
plot(data);ylabel('振幅');xlabel('采样点');  
title('“陶瓷Sensor + Amplifier”时域图');
ylabel('振幅');
xlabel( '采样点'); 

%输入文件的名字
% value=input('输入文件名字：');
% a=floor(value/10);
% b=mod(value,10);
% outName=[num2str(a),'-',num2str(b)];
% 
% eval(['!rename' , ',channel_0.txt' , [',',outName,'.txt']]); %重命名channel_0.txt
% 
% 

