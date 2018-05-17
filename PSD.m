function [ output ] = PSD( input,fs )
%UNTITLED input为信号，len为信号长度fs为采样频率
len = size(input, 2);
ff = fft(input',len)';
ff = abs(ff(:, 1:len / 2 + 1));
X=ff.*ff./(fs*len);
Y=10*log10(X);
% output=premnmx(Y);
output=Y;
% output=mapminmax(Y);%归一化到-1-1
end