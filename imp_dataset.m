clear all
close all
clc
model_name='Iv_imp_pv_SNRv_model';
filename='dataset_Iv_imp_pv_SNRv.mat';
load(filename);
%load(filename,'tfr_train', 'itfr_train', 'tfr_valid', 'itfr_valid', 'model_name');
M=500;
k=3;
N=100;
nfreqs_train=3000;
nfreqs_valid=500;
nfreqs_test=100;
gamma_k = 1e-4;
L=5;
[ s_train, tfr_train, itfr_train, rtfr_train,  I_train,  SNR_train ] = imp_gen( nfreqs_train, N, M, L, gamma_k);
[ s_valid, tfr_valid, itfr_valid, rtfr_valid,  I_valid,  SNR_valid ] = imp_gen( nfreqs_valid, N, M, L, gamma_k);


i=6;
%[~, rtfr_test] = recursive_rsp(s_test(i,:), k, L, mi, mf, M);

figure(1); 
imagesc(N*(0:1/N:(1-1/N)),(0:1/M:1),squeeze(tfr_train(i,:,:)));
set(gca,'YDir','normal')
colormap gray;
colormap(flipud(colormap)); 
xlabel('time samples', 'FontSize', 16)  %, 'FontName', 'Times-Roman', 'FontSize', 20
ylabel('normalized frequency', 'FontSize', 16)
title(sprintf('Gabor transform I=%d, SNR=%d', I_train(i), SNR_train(i)),'FontSize', 14);
%title(sprintf('Gabor transform I=%d, p=%d, SNR=%d, c1=%2.5f + j%2.5f, c2=%2.5f + j%2.5f, c3=%2.5f + j%2.5f'...
%, I, p, SNR, real(C(11,1,1)), imag(C(11,1,1)), real(C(11,1,2)), imag(C(11,1,2)), real(C(11,1,3)), imag(C(11,1,3))),...
%'FontSize', 14);
figure(2); 
imagesc(N*(0:1/N:(1-1/N)),(0:1/M:1),abs(squeeze(itfr_train(i,:,:))));
set(gca,'YDir','normal')
colormap gray;
colormap(flipud(colormap)); 
xlabel('time samples', 'FontSize', 16)  %, 'FontName', 'Times-Roman', 'FontSize', 20
ylabel('normalized frequency', 'FontSize', 16)
title(sprintf('Ideal transform I=%d', I_train(i)),'FontSize', 14);

figure(3); 
imagesc(N*(0:1/N:(1-1/N)),(0:1/M:1),squeeze(rtfr_train(i,:,:)));
set(gca,'YDir','normal')
colormap gray;
colormap(flipud(colormap)); 
xlabel('time samples', 'FontSize', 16)  %, 'FontName', 'Times-Roman', 'FontSize', 20
ylabel('normalized frequency', 'FontSize', 16)
title(sprintf('Recursive reassigned spectrogram  I=%d, SNR=%d, L=%2.2f ', I_train(i), SNR_train(i), L),'FontSize', 14);


itfr_valid=single(itfr_valid);
itfr_train=single(itfr_train);
tfr_valid=single(tfr_valid);
tfr_train=single(tfr_train);
rtfr_train=single(rtfr_train);
rtfr_valid=single(rtfr_valid);
SNR_valid=single(SNR_valid);
SNR_train=single(SNR_train);
I_train=single(I_train);
I_valid=single(I_valid);

save(filename, 's_train', 'tfr_train', 'itfr_train', 'rtfr_train', 'I_train', 'SNR_train', 's_valid', 'tfr_valid', 'itfr_valid', 'rtfr_valid', 'I_valid', 'SNR_valid', 'model_name');

