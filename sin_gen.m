function [ s, tfr, itfr, rtfr, I, p, SNR] = sin_gen( nfreqs, N, M, L, gamma_k)
%[ s, tfr, itfr ] = sin_gen( nfreqs, N, M, L, gamma_k)
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
% rtfr:      reassigned spectrogram
% I:         number of component in the signal
% p:         sinus order
s=zeros(nfreqs,N);
%imp=zeros(nfreqs,N);
%itfr_imp=zeros(nfreqs,M,N);
tfr=zeros(nfreqs,M,N);
rtfr=zeros(nfreqs,M,N);
itfr=zeros(nfreqs,M,N);
I=zeros(nfreqs,1);
p=zeros(nfreqs,1);
SNR=zeros(nfreqs,1);
snr=[5 25 45];
%C=zeros(nfreqs,I,p+1);
for i=1:nfreqs
    I(i)=round(9*rand)+1;
    p(i)=round(rand)+1;
    c=0.5*crand(I(i),p(i)+1);
    imc3=-(1/500)*randn(I(i),1);
    rec3=(1/50)*randn(I(i),1);
    if p(i)==2
        c(:,3)=rec3+j*imc3;
    end
    %C(i,:,:)=c;
    %phi=2*pi*(rand-rand)/2;
    idx=round(2*rand)+1;
    SNR(i)=snr(idx);%round(45*rand);
    [ s(i,:), itfr(i,:,:) ]=tfr_sinus_ideal(c,N,M,SNR(i));
    tfr(i,:,:)=abs(tfrgab2(s(i,:), M, L, gamma_k)).^2;
    [~, rtfr(i,:,:)]=tfrrgab2(s(i,:), M, L, gamma_k);
end

end

