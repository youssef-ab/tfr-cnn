clear all
close all
clc
model_name='Iv_imp_pv_SNRv_model';
filename='dataset_Iv_imp_pv_SNRv.mat';
%load(filename);
M=500;
k=3;
N=100;
nfreqs_train=3000;
nfreqs_valid=500;
nfreqs_train1=1500;
nfreqs_valid1=250;
nfreqs_test=100;
nfreqs_train2=1500;
nfreqs_valid2=250;
gamma_k = 1e-4;
L=7;
s_train=zeros(nfreqs_train,N); s_valid=zeros(nfreqs_valid,N);
tfr_train=zeros(nfreqs_train,M,N); tfr_valid=zeros(nfreqs_valid,M,N);
rtfr_train=zeros(nfreqs_train,M,N); rtfr_valid=zeros(nfreqs_valid,M,N);
itfr_train=zeros(nfreqs_train,M,N); itfr_valid=zeros(nfreqs_valid,M,N);
I_train=zeros(nfreqs_train,1); I_valid=zeros(nfreqs_valid,1);
p_train=zeros(nfreqs_train1,1); p_valid=zeros(nfreqs_valid1,1);
SNR_train=zeros(nfreqs_train,1); SNR_valid=zeros(nfreqs_valid1,1);
[ s_train1, tfr_train1, itfr_train1, rtfr_train1,  I_train1, p_train1,  SNR_train1 ] = sin_gen( nfreqs_train1, N, M, L, gamma_k);
[ s_valid1, tfr_valid1, itfr_valid1, rtfr_valid1,  I_valid1, p_valid1,  SNR_valid1 ] = sin_gen( nfreqs_valid1, N, M, L, gamma_k);

[ s_train2, tfr_train2, itfr_train2, rtfr_train2,  I_train2,  SNR_train2 ] = imp_gen( nfreqs_train2, N, M, L, gamma_k);
[ s_valid2, tfr_valid2, itfr_valid2, rtfr_valid2,  I_valid2,  SNR_valid2 ] = imp_gen( nfreqs_valid2, N, M, L, gamma_k);

for i=1:nfreqs_train1
    s_train(2*i,:)=s_train1(i,:); tfr_train(2*i,:,:)=tfr_train1(i,:,:); itfr_train(2*i,:,:)=itfr_train1(i,:,:); rtfr_train(2*i,:,:)=rtfr_train1(i,:,:);  I_train(2*i)=I_train1(i); p_train(2*i)=p_train1(i);  SNR_train(2*i)=SNR_train1(i);
    s_train(2*i-1,:)=s_train2(i,:); tfr_train(2*i-1,:,:)=tfr_train2(i,:,:); itfr_train(2*i-1,:,:)=itfr_train2(i,:,:); rtfr_train(2*i-1,:,:)=rtfr_train2(i,:,:);  I_train(2*i-1)=I_train2(i); SNR_train(2*i-1)=SNR_train2(i);
end
for i=1:nfreqs_valid1
    s_valid(2*i,:)=s_valid1(i,:); tfr_valid(2*i,:,:)=tfr_valid1(i,:,:); itfr_valid(2*i,:,:)=itfr_train1(i,:,:); rtfr_train(2*i,:,:)=rtfr_train1(i,:,:);  I_train(2*i)=I_train1(i); p_train(2*i)=p_train1(i);  SNR_train(2*i)=SNR_train1(i);
    s_valid(2*i-1,:)=s_valid2(i,:); tfr_valid(2*i-1,:,:)=tfr_valid2(i,:,:); itfr_valid(2*i-1,:,:)=itfr_train2(i,:,:); rtfr_train(2*i-1,:,:)=rtfr_train2(i,:,:);  I_train(2*i-1)=I_train2(i); SNR_train(2*i-1)=SNR_train2(i);
end




i=3000;
%[~, rtfr_test] = recursive_rsp(s_test(i,:), k, L, mi, mf, M);

figure(1); 
imagesc(N*(0:1/N:(1-1/N)),(0:1/M:1),squeeze(tfr_train(i,:,:)));
set(gca,'YDir','normal')
colormap gray;
colormap(flipud(colormap)); 
xlabel('time samples', 'FontSize', 16)  %, 'FontName', 'Times-Roman', 'FontSize', 20
ylabel('normalized frequency', 'FontSize', 16)
title(sprintf('Gabor transform I=%d, p=%d, SNR=%d', I_train(i), p_train(i), SNR_train(i)),'FontSize', 14);
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
title(sprintf('Ideal transform I=%d, p=%d', I_train(i), p_train(i)),'FontSize', 14);

figure(3); 
imagesc(N*(0:1/N:(1-1/N)),(0:1/M:1),squeeze(rtfr_train(i,:,:)));
set(gca,'YDir','normal')
colormap gray;
colormap(flipud(colormap)); 
xlabel('time samples', 'FontSize', 16)  %, 'FontName', 'Times-Roman', 'FontSize', 20
ylabel('normalized frequency', 'FontSize', 16)
title(sprintf('Recursive reassigned spectrogram  I=%d, p=%d, SNR=%d, L=%2.2f ', I_train(i), p_train(i), SNR_train(i), L),'FontSize', 14);

% convert from double to single
itfr_valid=single(itfr_valid);
itfr_train=single(itfr_train);
tfr_valid=single(tfr_valid);
tfr_train=single(tfr_train);
rtfr_train=single(rtfr_train);
rtfr_valid=single(rtfr_valid);
SNR_valid=single(SNR_valid);
SNR_train=single(SNR_train);
p_train=single(p_train);
p_valid=single(p_valid);
I_train=single(I_train);
I_valid=single(I_valid);
% save signals
save(filename, 's_train', 'tfr_train', 'itfr_train', 'rtfr_train', 'I_train', 'p_train', 'SNR_train', 's_valid', 'tfr_valid', 'itfr_valid', 'rtfr_valid', 'I_valid', 'p_valid', 'SNR_valid', 'model_name');





