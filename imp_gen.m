function [ s, tfr, itfr, rtfr, I, SNR] = imp_gen( nfreqs, N, M, L, gamma_k)
s=zeros(nfreqs,N);
tfr=zeros(nfreqs,M,N);
rtfr=zeros(nfreqs,M,N);
itfr=zeros(nfreqs,M,N);
I=zeros(nfreqs,1);
SNR=zeros(nfreqs,1);
snr=[5 25 45];
%t0=zeros(nfreqs,I);
for i=1:nfreqs
    I(i)=round(9*rand)+1;
    t0=floor(100*rand(I(i),1))+1;
    idx=round(2*rand)+1;
    SNR(i)=snr(idx);%round(45*rand);
    [ s(i,:), itfr(i,:,:) ]=tfr_imp(t0,N,M,SNR(i));
    tfr(i,:,:)=abs(tfrgab2(s(i,:), M, L, gamma_k)).^2;
    [~, rtfr(i,:,:)]=tfrrgab2(s(i,:), M, L, gamma_k);
end

end

