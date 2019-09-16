clear all
close all
clc
model_name='Iv_pv_SNRv_model';
filename='dataset_Iv_pv_SNRv.mat';
load(filename);
%load(filename,'tfr_train', 'itfr_train', 'tfr_valid', 'itfr_valid', 'model_name');
M=500;
k=3;
N=100;
nfreqs_train=3000;
nfreqs_valid=500;
nfreqs_test=100;
gamma_k = 1e-4;
L=10;
I=2;
p=2;
%SNR=45;
%c=[0.2 0.49 +j*0.4 0.3+j*0.3 ];
s_train=zeros(nfreqs_train,N); tfr_train=zeros(nfreqs_train,M,N); itfr_train=zeros(nfreqs_train,M,N); rtfr_train=zeros(nfreqs_train,M,N);
s_valid=zeros(nfreqs_valid,N); tfr_valid=zeros(nfreqs_valid,M,N); itfr_valid=zeros(nfreqs_valid,M,N); rtfr_valid=zeros(nfreqs_valid,M,N);
s_test=zeros(nfreqs_test,N); tfr_test=zeros(nfreqs_test,M,N); itfr_test=zeros(nfreqs_test,M,N); rtfr_test=zeros(nfreqs_test,M,N);
[ s_test, tfr_test, itfr_test, rtfr_test, C_test ] = sig_gen( nfreqs_test, N, M, L, gamma_k, I, p);
for I=1:10
    %train dataset
%     [ s_train_tmp, tfr_train_tmp, itfr_train_tmp, C_train ] = sig_gen( 100, N, M, L, gamma_k, I, p, SNR);
%     s_train((I-1)*100+1:I*100,:)=s_train_tmp; tfr_train((I-1)*100+1:I*100,:,:)=tfr_train_tmp;
%     itfr_train((I-1)*100+1:I*100,:,:)=itfr_train_tmp;
%     %validation dataset
%     [ s_valid_tmp, tfr_valid_tmp, itfr_valid_tmp, C_valid ] = sig_gen( 25, N, M, L, gamma_k, I, p, SNR);
%     s_valid((I-1)*25+1:I*25,:)=s_valid_tmp; tfr_valid((I-1)*25+1:I*25,:,:)=tfr_valid_tmp;
%     itfr_valid((I-1)*25+1:I*25,:,:)=itfr_valid_tmp;
    %test dataset
    [ s_test_tmp, tfr_test_tmp, itfr_test_tmp, rtfr_test_tmp, C_test ] = sig_gen( 10, N, M, L, gamma_k, I, p, SNR);
    s_test((I-1)*10+1:I*10,:)=s_test_tmp; tfr_test((I-1)*10+1:I*10,:,:)=tfr_test_tmp;
    itfr_test((I-1)*10+1:I*10,:,:)=itfr_test_tmp; rtfr_test((I-1)*10+1:I*10,:,:)=rtfr_test_tmp;
end
[ s, itfr ] = tfrs_ideal( c, N, M, 30);
h=histogram(tfr_test(6,:,:),256)

S=reyni_entropy(tfr_test(1,:,:),256, 0.1);



%[ err,model_name ] = train_rf_rep_cnn( tfr_train, itfr_train, tfr_valid, itfr_valid);
i=90;
%[~, rtfr_test] = recursive_rsp(s_test(i,:), k, L, mi, mf, M);

figure(1); 
imagesc(N*(0:1/N:(1-1/N)),(0:1/M:1),squeeze(tfr_test(i,:,:)));
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
imagesc(N*(0:1/N:(1-1/N)),(0:1/M:1),abs(squeeze(itfr_test(i,:,:))));
set(gca,'YDir','normal')
colormap gray;
colormap(flipud(colormap)); 
xlabel('time samples', 'FontSize', 16)  %, 'FontName', 'Times-Roman', 'FontSize', 20
ylabel('normalized frequency', 'FontSize', 16)
title(sprintf('Ideal transform I=%d, p=%d', I, p),'FontSize', 14);
%title(sprintf('Ideal transform I=%d, p=%d, c1=%2.5f + j%2.5f, c2=%2.5f + j%2.5f, c3=%2.5f + j%2.5f',...
%I, p, real(C(11,1,1)), imag(C(11,1,1)), real(C(11,1,2)), imag(C(11,1,2)), real(C(11,1,3)), imag(C(11,1,3))),...
%'FontSize', 14);

figure(3); 
imagesc(N*(0:1/N:(1-1/N)),(0:1/M:1),abs(squeeze(itfr_pred(i,:,:))));
set(gca,'YDir','normal')
colormap gray;
colormap(flipud(colormap)); 
xlabel('time samples', 'FontSize', 16)  %, 'FontName', 'Times-Roman', 'FontSize', 20
ylabel('normalized frequency', 'FontSize', 16)
title(sprintf('Predicted transform I=%d, p=%d', I, p),'FontSize', 14);

figure(4); 
imagesc(N*(0:1/N:(1-1/N)),(0:1/M:1),squeeze(rtfr_test(i,:,:)));
set(gca,'YDir','normal')
colormap gray;
colormap(flipud(colormap)); 
xlabel('time samples', 'FontSize', 16)  %, 'FontName', 'Times-Roman', 'FontSize', 20
ylabel('normalized frequency', 'FontSize', 16)
title(sprintf('Recursive reassigned spectrogram  I=%d, p=%d, SNR=%d, L=%2.2f ', I, p, SNR, L),'FontSize', 14);

figure(5);
plot(N*(0:1/N:(1-1/N)),real(s_train(5,:)));

save(filename, 'tfr_train', 'itfr_train', 'tfr_valid', 'itfr_valid', 's_test', 'tfr_test', 'itfr_test', 'rtfr_test', 'model_name');
