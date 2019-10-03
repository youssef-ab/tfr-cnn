close all
clear all
clc
filename = 'test_mix_SNR25.mat';
test='test_mix_SNR25.mat';
load(filename);
%% Generate signals and TFRs and save them in array
gamma_k = 1e-4;
L1=5;
L2=10;
L3=5;
N=100;
M=500;
SNR=25;
p1=1;
I1=1;
C1=zeros(I1,p1+1);
c1(1,:)=[-0.5 0.2i]
%c1=0.5*crand(I1,p1+1);
%c(1,:)=[0.5 + 0.3481i   0.5 + 0.2211i   0.0031 + 0.0012i];
[ s_mix0, itfr_sinus ]=tfr_sinus_ideal(c1,N,M,SNR);
tfr_mix0=tfrgab2(s_mix0, M, L1, gamma_k).^2;
[~, rtfr_mix0]=tfrrgab2(s_mix0, M, L1, gamma_k);
p2=2;
I2=1;
C2=zeros(I2,p2+1);
c2=0.5*crand(I2,p2+1);
c2(1,:)=[-0.3 0.2i   0.0015i];
[ s_mix1, itfr_mix1 ]=tfr_sinus_ideal(c2,N,M,SNR);
s1=s_mix0+s_mix1;
tfr_mix1=tfrgab2(s_mix1, M, L1, gamma_k);
[~, rtfr_mix1]=tfrrgab2(s_mix1, M, L1, gamma_k);
t0=[5 20];
[ s_mix2, itfr_mix2 ]=tfr_imp_ideal(t0,N,M,SNR);
s=[s_mix2(1:20); s1(21:30) + s_mix2(21:30); s1(31:100)];
tfr_s=abs(tfrgab2(s, M, L1, gamma_k)).^2;
[~, rtfr_s]=tfrrgab2(s, M, L1, gamma_k);

tfr_s=single(tfr_s);
rtfr_s=single(rtfr_s);
%save(filename);
%% figures comparaison
load("test_mix_imp_SNR25_pred.mat");
tfr_S_pred=zeros(M,100);
for i=0:0
    tfr_S_pred(:,i*100+1:100+i*100)=tfr_s_pred(i+1,:,:);
end
figure(1)
imagesc(N*(0:1/N:(1-1/N)),(0:1/M:0.5),squeeze(tfr_s.^0.5)) 
set(gca,'YDir','normal')
colormap gray;
colormap(flipud(colormap)); 
xlabel('time samples', 'FontSize', 16)  %, 'FontName', 'Times-Roman', 'FontSize', 20
ylabel('normalized frequency', 'FontSize', 16)
title(sprintf('Gabor transform SNR=25 dB, L=%2.2f', L2),'FontSize', 14);
figure(2)
imagesc(N*(0:1/N:(1-1/N)),(0:1/M:0.5),squeeze(rtfr_s.^0.5))
set(gca,'YDir','normal')
colormap gray;
colormap(flipud(colormap));
xlabel('time samples', 'FontSize', 16)  %, 'FontName', 'Times-Roman', 'FontSize', 20
ylabel('normalized frequency', 'FontSize', 16)
title(sprintf('Reassigned spectrogram SNR=25 dB, L=%2.2f', L2),'FontSize', 14);
figure(3)
imagesc(N*(0:1/N:(1-1/N)),(0:1/M:0.5),squeeze(abs(tfr_s_pred))) 
set(gca,'YDir','normal')
colormap gray;
colormap(flipud(colormap)); 
xlabel('time samples', 'FontSize', 16)  %, 'FontName', 'Times-Roman', 'FontSize', 20
ylabel('normalized frequency', 'FontSize', 16)
title(sprintf('Predicted transform SNR=25 dB, L=%2.2f', L2),'FontSize', 14);

