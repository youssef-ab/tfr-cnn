clear all
close all
clc
filename='dataset_I1_p1_SNR45.mat';
load(filename);
M=500;
N=100;
nfreqs_train=1000;
nfreqs_valid=250;
nfreqs_test=100;
gamma_k = 1e-4;
L=10;
I=1;
p=1;
SNR=45;
c=[0.2 0.49 +j*0.4 0.3+j*0.3 ];
%train dataset
[ s_train, tfr_train, itfr_train, C_train ] = sig_gen( nfreqs_train, N, M, L, gamma_k, I, p, SNR);  
%validation dataset
[ s_valid, tfr_valid, itfr_valid, C_valid ] = sig_gen( nfreqs_valid, N, M, L, gamma_k, I, p, SNR);  
%test dataset
[ s_test, tfr_test, itfr_test, C_test ] = sig_gen( nfreqs_test, N, M, L, gamma_k, I, p, SNR);  

[ s, itfr ] = tfrs_ideal( c, N, M, 30);

%[ err,model_name ] = train_rf_rep_cnn( tfr_train, itfr_train, tfr_valid, itfr_valid);
figure(1); 
imagesc(N*(0:1/N:(1-1/N)),(0:1/M:1),abs(squeeze(tfr_test(19,:,:))));
set(gca,'YDir','normal')
colormap gray;
colormap(flipud(colormap)); 
xlabel('time samples', 'FontSize', 16)  %, 'FontName', 'Times-Roman', 'FontSize', 20
ylabel('normalized frequency', 'FontSize', 16)
title(sprintf('Gabor transform I=%d, p=%d, SNR=%d', I, p, SNR),'FontSize', 14);
%title(sprintf('Gabor transform I=%d, p=%d, SNR=%d, c1=%2.5f + j%2.5f, c2=%2.5f + j%2.5f, c3=%2.5f + j%2.5f'...
%, I, p, SNR, real(C(11,1,1)), imag(C(11,1,1)), real(C(11,1,2)), imag(C(11,1,2)), real(C(11,1,3)), imag(C(11,1,3))),...
%'FontSize', 14);

figure(2); 
imagesc(N*(0:1/N:(1-1/N)),(0:1/M:1),abs(squeeze(itfr_test(19,:,:))).^0.01);
set(gca,'YDir','normal')
colormap gray;
colormap(flipud(colormap)); 
xlabel('time samples', 'FontSize', 16)  %, 'FontName', 'Times-Roman', 'FontSize', 20
ylabel('normalized frequency', 'FontSize', 16)
title(sprintf('Gabor transform I=%d, p=%d', I, p),'FontSize', 14);
%title(sprintf('Ideal transform I=%d, p=%d, c1=%2.5f + j%2.5f, c2=%2.5f + j%2.5f, c3=%2.5f + j%2.5f',...
%I, p, real(C(11,1,1)), imag(C(11,1,1)), real(C(11,1,2)), imag(C(11,1,2)), real(C(11,1,3)), imag(C(11,1,3))),...
%'FontSize', 14);

figure(3);
plot(N*(0:1/N:(1-1/N)),real(s_test(9,:)));
%save(filename);
