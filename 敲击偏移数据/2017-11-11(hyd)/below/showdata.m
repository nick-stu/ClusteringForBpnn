clc;clear;close all
%读取.txt文件数据
% data1=dlmread('4-1.txt');
% data1=dlmread('channel_0.txt');
% data1=dlmread('X1-1.txt');
data1=dlmread('5-3.txt');

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