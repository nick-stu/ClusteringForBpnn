clc;clear;close all
%读取.txt文件数据
% data1=dlmread('4-1.txt');
data1=dlmread('channel_0.txt');
% data1=dlmread('X1-1.txt');
% data1=dlmread('5-3.txt');

% fileName='1-1';

figure(1);     
% subplot(311);
plot(data1);ylabel('振幅');xlabel('采样点');  
title('“陶瓷Sensor + Amplifier”时域图');
% subplot(312);
% plot(data2);ylabel('振 幅');xlabel  ('采样点');   
% subplot(313);
% plot(data3);
ylabel('振幅');
xlabel( '采样点'); 

% if mod(num2,3)==0
%     num2=0;
%     num1=num1+1;
% end
% num2=num2+1;
% outName=[num2str(num1),'-',num2str(num2)];

value=input('输入文件名字：');
a=floor(value/10);
b=mod(value,10);
outName=[num2str(a),'-',num2str(b)];

dlmwrite([outName,'.txt'],'data1');



