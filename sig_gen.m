function [ s, tfr, itfr ] = sig_gen( nfreqs, N, M, L, gamma_k, I, p)
%[ s, tfr, itfr ] = sig_gen( nfreqs, N, M, L, gamma_k)
%
% generate nfreqs sinusoids with their ideal time frequency representation
%
% INPUT:
% nfreqs:    number of normalised frequencies
% N :        number of points
% M      :   number of frequency bins to process (default: length(x))
% L      :   window duration parameter:  w0 * T, (default: 10)
% gamma_K:   threshold applied on window values (default: 10^(-4))
% I :        number of mixture sources
% p :        order
%
% OUTPUT:
% s:         array of nfreqs signals
% tfr:       array of nfreqs gabor transforms
% itfr:      array of nfreqs ideal time-frequency representations
s=zeros(nfreqs,N);
tfr=zeros(nfreqs,M,N);
itfr=zeros(nfreqs,M,N);
%A=zeros(nfreqs,1);
%F=zeros(nfreqs,1);
SNR=30;
for i=1:nfreqs
    c=0.5*crand(I,p+1)
    c(:,3)=(1/200)*crand(1)
    %A(i)=a;
    %fnorm=rand*0.5;
    %F(i)=fnorm;
    %phi=2*pi*(rand-rand)/2;
    [ s(i,:), itfr(i,:,:) ]=tfrs_ideal(c,N,M,SNR);
    tfr(i,:,:)=tfrgab2(s(i,:), M, L, gamma_k);
end;  

end

