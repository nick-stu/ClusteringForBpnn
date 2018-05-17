function [ fftdata ] = FFT( data )
%FFT Summary of this function goes here
%   Detailed explanation goes here
    N = size(data, 2);
    fftdata = fft(data', N / 2 + 1)';
    fftdata = abs(fftdata(:, 1:N / 2 + 1));
    fftdata = premnmx(fftdata);
end

