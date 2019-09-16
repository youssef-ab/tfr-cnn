close all
clear all
clc
filename = 'test_mix_imp_sinus_SNR45.mat';
test='test_mix_imp_sinus_SNR45.mat'
load(filename);
gamma_k = 1e-4;
L1=7;
L2=10;
L3=5;
N=100;
M=500;
S=zeros(5,100);
%tfr_s=abs(tfrgab2(s, M, L, gamma_k)).^2;
tfr_S=abs(tfrgab2(s, 2*M, L1, gamma_k)).^2;
[~, rtfr_S]=tfrrgab2(s, 2*M, L1, gamma_k);
tfr_S1=tfr_S(1:M,:);
rtfr_S1=rtfr_S(1:M,:);
%truncate signals
for i=0:4
    S(i+1,:)=s(i*100+1:100+i*100);
end
tfr_s=zeros(8,M,N);
rtfr_s=zeros(8,M,N);
for i=0:4
    tfr_s(i+1,:,:)=tfr_S1(:,i*100+1:100+i*100);
    rtfr_s(i+1,:,:)=rtfr_S1(:,i*100+1:100+i*100);
end
%tfr_S=abs(tfr_s(1,:,:) + tfr_s(2,:,:) + tfr_s(3,:,:) + tfr_s(4,:,:) + tfr_s(5,:,:)).^2;

SNR=5;
p1=1;
I1=1;
C1=zeros(I1,p1+1);
c1=0.5*crand(I1,p1+1);
%c(1,:)=[0.5 + 0.3481i   0.5 + 0.2211i   0.0031 + 0.0012i];
[ s_sinus, itfr_sinus ]=tfrs_ideal(c1,N,M,SNR);
tfr_sinus=tfrgab2(s_sinus, M, L2, gamma_k);
[~, rtfr_sinus]=tfrrgab2(s_sinus, M, L2, gamma_k);
p2=2;
I2=2;
C2=zeros(I2,p2+1);
c2=0.5*crand(I2,p2+1);
c2(1,:)=[0.5 + 0.3481i   0.5 + 0.2211i   0.0031 + 0.0012i];
%c(2,:)=[0   0   0];
c2(2,:)=[0.5 + 0.3481i   0.5 + 0.5i   0.0031 + -0.0011i];
[ s_mix1, itfr_mix1 ]=tfrs_ideal(c2,N,M,SNR);
tfr_mix1=tfrgab2(s_mix1, M, L2, gamma_k);
[~, rtfr_mix1]=tfrrgab2(s_mix1, M, L1, gamma_k);
figure(3)
imagesc(N*(0:1/N:(1-1/N)),(0:1/M:0.5),squeeze(abs(tfr_mix1).^2)) 
set(gca,'YDir','normal')
colormap gray;
colormap(flipud(colormap)); 
xlabel('time samples', 'FontSize', 16)  %, 'FontName', 'Times-Roman', 'FontSize', 20
ylabel('normalized frequency', 'FontSize', 16)
title(sprintf('Gabor transform'),'FontSize', 14);

t0=[30];
[ s_mix2, itfr_mix2 ]=tfr_imp(t0,N,M,SNR);
tfr_mix2=tfrgab2(s_mix2, M, L3, gamma_k);
[~, rtfr_mix2]=tfrrgab2(s_mix2, M, L3, gamma_k);
figure(4)
imagesc(N*(0:1/N:(1-1/N)),(0:1/M:0.5),squeeze(abs(tfr_mix2).^2)) 
set(gca,'YDir','normal')
colormap gray;
colormap(flipud(colormap)); 
xlabel('time samples', 'FontSize', 16)  %, 'FontName', 'Times-Roman', 'FontSize', 20
ylabel('normalized frequency', 'FontSize', 16)
title(sprintf('Gabor transform'),'FontSize', 14);
tfr_s(6,:,:) = abs(tfr_sinus).^2; rtfr_s(6,:,:) = rtfr_sinus;
tfr_s(7,:,:) = abs(tfr_mix1).^2; rtfr_s(7,:,:) = rtfr_mix1;
tfr_s(8,:,:) = abs(tfr_mix2).^2; rtfr_s(8,:,:) = rtfr_mix2;
%tfr_mix=abs(tfrgab2(s_mix, M, L, gamma_k)).^2;

figure(5)
imagesc(N*(0:1/N:(1-1/N)),(0:1/M:0.5),squeeze(tfr_s(2,:,:))) 
set(gca,'YDir','normal')
colormap gray;
colormap(flipud(colormap)); 
xlabel('time samples', 'FontSize', 16)  %, 'FontName', 'Times-Roman', 'FontSize', 20
ylabel('normalized frequency', 'FontSize', 16)
title(sprintf('Gabor transform'),'FontSize', 14);
figure(6)
imagesc(N*(0:1/N:(1-1/N)),(0:1/M:0.5),squeeze(rtfr_s(2,:,:))) 
set(gca,'YDir','normal')
colormap gray;
colormap(flipud(colormap)); 
xlabel('time samples', 'FontSize', 16)  %, 'FontName', 'Times-Roman', 'FontSize', 20
ylabel('normalized frequency', 'FontSize', 16)
title(sprintf('Gabor transform'),'FontSize', 14);
tfr_s=single(tfr_s);
rtfr_s=single(rtfr_s);
%%prediction
load('test_imp_SNR45_pred.mat');
figure(6)
imagesc(N*(0:1/N:(1-1/N)),(0:1/M:0.5),squeeze(abs(tfr_s(8,:,:)))) 
set(gca,'YDir','normal')
colormap gray;
colormap(flipud(colormap)); 
xlabel('time samples', 'FontSize', 16)  %, 'FontName', 'Times-Roman', 'FontSize', 20
ylabel('normalized frequency', 'FontSize', 16)
title(sprintf('Gabor transform SNR=%d dB, L=%2.2f', SNR, L2),'FontSize', 14);
figure(7)
imagesc(N*(0:1/N:(1-1/N)),(0:1/M:0.5),squeeze(rtfr_s(8,:,:)))
set(gca,'YDir','normal')
colormap gray;
colormap(flipud(colormap)); 
xlabel('time samples', 'FontSize', 16)  %, 'FontName', 'Times-Roman', 'FontSize', 20
ylabel('normalized frequency', 'FontSize', 16)
title(sprintf('Reassigned spectrogram SNR=%d dB, L=%2.2f', SNR, L2),'FontSize', 14);
figure(9)
imagesc(N*(0:1/N:(1-1/N)),(0:1/M:0.5),squeeze(itfr_mix2))
set(gca,'YDir','normal')
colormap gray;
colormap(flipud(colormap)); 
xlabel('time samples', 'FontSize', 16)  %, 'FontName', 'Times-Roman', 'FontSize', 20
ylabel('normalized frequency', 'FontSize', 16)
title(sprintf('Ideal transform SNR=%d dB, L=%2.2f', SNR, L2),'FontSize', 14);
figure(10)
imagesc(500*(0:1/500:(1-1/500)),(0:1/M:0.5),squeeze(abs(tfr_s_pred(8,:,:)))) 
set(gca,'YDir','normal')
colormap gray;
colormap(flipud(colormap)); 
xlabel('time samples', 'FontSize', 16)  %, 'FontName', 'Times-Roman', 'FontSize', 20
ylabel('normalized frequency', 'FontSize', 16)
title(sprintf('Predicted transform SNR=%d dB, L=%2.2f', SNR, L2),'FontSize', 14);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tfr_S_pred=zeros(M,500);
for i=0:4
    tfr_S_pred(:,i*100+1:100+i*100)=tfr_s_pred(i+1,:,:);
end
figure(11)
imagesc(M*(0:1/M:(1-1/M)),(0:1/M:0.5),squeeze(tfr_S1)) 
set(gca,'YDir','normal')
colormap gray;
colormap(flipud(colormap)); 
xlabel('time samples', 'FontSize', 16)  %, 'FontName', 'Times-Roman', 'FontSize', 20
ylabel('normalized frequency', 'FontSize', 16)
title(sprintf('Gabor transform SNR=25 dB, L=%2.2f', L1),'FontSize', 14);
figure(12)
imagesc(500*(0:1/500:(1-1/500)),(0:1/M:0.5),squeeze(abs(tfr_S_pred))) 
set(gca,'YDir','normal')
colormap gray;
colormap(flipud(colormap)); 
xlabel('time samples', 'FontSize', 16)  %, 'FontName', 'Times-Roman', 'FontSize', 20
ylabel('normalized frequency', 'FontSize', 16)
title(sprintf('Predicted transform SNR=25 dB, L=%2.2f', L1),'FontSize', 14);
figure(13)
imagesc(500*(0:1/500:(1-1/500)),(0:1/M:0.5),squeeze(rtfr_S1))
set(gca,'YDir','normal')
colormap gray;
colormap(flipud(colormap)); 
xlabel('time samples', 'FontSize', 16)  %, 'FontName', 'Times-Roman', 'FontSize', 20
ylabel('normalized frequency', 'FontSize', 16)
title(sprintf('Reassigned spectrogram SNR=25 dB, L=%2.2f', L1),'FontSize', 14);
%save(filename,'tfr_s','rtfr_s','t0','c1','test');
