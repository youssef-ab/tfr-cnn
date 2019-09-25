function [ s, itfr ] = tfr_imp( t0, N, M, SNR)
% [ s, itfr ] = tfr_imp( t0, N, M, SNR)
%
% Computes the ideal time frequency representation of a sinusoide
%
% INPUT:
% t0 :       moments of impulses
% N :        number of points
% M      :   number of frequency bins to process (default: length(x))
% SNR:       rapport signal bruit (default 30)
%
% OUTPUT:
% s:         the signal
% itfr:      ideal time-frequency representation
%t = N*(0:1/N:1-1/N)';
s=zeros(N,1);
itfr = zeros(M,N);
s(t0)=10*rand(length(t0),1);
itfr(:,t0)=repmat(abs(s(t0))',M,1);
%signal with noise
sigma=std(s)*10^(-SNR/20);
b=sigma*crandn(1,N)';
s=s+b;
end

