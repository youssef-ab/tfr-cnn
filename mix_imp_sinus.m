close all
clear all
clc
filename = 'test_mix_imp_sinus.mat';
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
tfr_S1=tfr_S(1:M,:);
%truncate signals
for i=0:4
    S(i+1,:)=s(i*100+1:100+i*100);
end
tfr_s=zeros(7,M,N);
for i=0:4
    tfr_s(i+1,:,:)=tfr_S1(:,i*100+1:100+i*100);
end
%tfr_S=abs(tfr_s(1,:,:) + tfr_s(2,:,:) + tfr_s(3,:,:) + tfr_s(4,:,:) + tfr_s(5,:,:)).^2;
figure(1)
imagesc(N*(0:1/N:(1-1/N)),(0:1/M:0.5),squeeze(tfr_s(1,:,:))) 
set(gca,'YDir','normal')
colormap gray;
colormap(flipud(colormap)); 
xlabel('time samples', 'FontSize', 16)  %, 'FontName', 'Times-Roman', 'FontSize', 20
ylabel('normalized frequency', 'FontSize', 16)
title(sprintf('Gabor transform'),'FontSize', 14);
tfr_pred=tfr_s_pred(1,:,:) + tfr_s_pred(2,:,:) + tfr_s_pred(3,:,:) + tfr_s_pred(4,:,:) + tfr_s_pred(5,:,:);
figure(2)
imagesc(N*(0:1/N:(1-1/N)),(0:1/M:0.5),abs(squeeze(tfr_pred)).^2) 
set(gca,'YDir','normal')
colormap gray;
colormap(flipud(colormap)); 
xlabel('time samples', 'FontSize', 16)  %, 'FontName', 'Times-Roman', 'FontSize', 20
ylabel('normalized frequency', 'FontSize', 16)
title(sprintf('predicted transform'),'FontSize', 14);
p=2;
I=2;
SNR=45;
C=zeros(2,3);
c=0.5*crand(I,p+1);
c(1,:)=[0.5 + 0.3481i   0.5 + 0.2211i   0.0031 + 0.0012i];
%c(2,:)=[0   0   0];
c(2,:)=[0.5 + 0.3481i   0.5 + 0.5i   0.0031 + -0.0011i];
[ s_mix1, itfr_mix1 ]=tfrs_ideal(c,N,M,SNR);
tfr_mix1=tfrgab2(s_mix1, M, L2, gamma_k);
figure(3)
imagesc(N*(0:1/N:(1-1/N)),(0:1/M:0.5),squeeze(abs(tfr_mix1).^2)) 
set(gca,'YDir','normal')
colormap gray;
colormap(flipud(colormap)); 
xlabel('time samples', 'FontSize', 16)  %, 'FontName', 'Times-Roman', 'FontSize', 20
ylabel('normalized frequency', 'FontSize', 16)
title(sprintf('Gabor transform'),'FontSize', 14);

t0=[1 30];
[ s_mix2, itfr_mix2 ]=tfr_imp(t0,N,M,SNR);
tfr_mix2=tfrgab2(s_mix2, M, L3, gamma_k);
[~, rtfr_mix2]=tfrrgab2(s_mix2, M, L, gamma_k);

figure(4)
imagesc(N*(0:1/N:(1-1/N)),(0:1/M:0.5),squeeze(abs(tfr_mix2).^2)) 
set(gca,'YDir','normal')
colormap gray;
colormap(flipud(colormap)); 
xlabel('time samples', 'FontSize', 16)  %, 'FontName', 'Times-Roman', 'FontSize', 20
ylabel('normalized frequency', 'FontSize', 16)
title(sprintf('Gabor transform'),'FontSize', 14);
tfr_s(6,:,:) = abs(tfr_mix1).^2;
tfr_s(7,:,:) = abs(tfr_mix2).^2;
%tfr_mix=abs(tfrgab2(s_mix, M, L, gamma_k)).^2;

figure(5)
imagesc(N*(0:1/N:(1-1/N)),(0:1/M:0.5),squeeze(tfr_mix(1,:,:))) 
set(gca,'YDir','normal')
colormap gray;
colormap(flipud(colormap)); 
xlabel('time samples', 'FontSize', 16)  %, 'FontName', 'Times-Roman', 'FontSize', 20
ylabel('normalized frequency', 'FontSize', 16)
title(sprintf('Gabor transform'),'FontSize', 14);

figure(6)
imagesc(N*(0:1/N:(1-1/N)),(0:1/M:0.5),squeeze(abs(tfr_mix_pred(1,:,:)))) 
set(gca,'YDir','normal')
colormap gray;
colormap(flipud(colormap)); 
xlabel('time samples', 'FontSize', 16)  %, 'FontName', 'Times-Roman', 'FontSize', 20
ylabel('normalized frequency', 'FontSize', 16)
title(sprintf('Gabor transform'),'FontSize', 14);

tfr_s=single(tfr_s);
save(filename,'tfr_s');
