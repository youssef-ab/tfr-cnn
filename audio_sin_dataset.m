clear all
close all
clc
filename='dataset.mat';
load(filename);
M=500;
N=100;
nfreqs_train=250;
nfreqs_valid=50;
nfreqs_test=20;
gamma_k = 1e-3;
L=10;
c=[0.49 +j*0.4 0.3+j*0.3 ];
%train dataset
%[ F_train, A_train, s_train, tfr_train, itfr_train ] = sig_gen( nfreqs_train, N, M, L, gamma_k); 
%validation dataset
%[ F_valid, A_valid, s_valid, tfr_valid, itfr_valid ] = sig_gen( nfreqs_valid, N, M, L, gamma_k); 
%test dataset
[ s_test, tfr_test, itfr_test ] = sig_gen( nfreqs_test, N, M, L, gamma_k, 5, 2);  
[ s, itfr ] = tfrs_ideal( c, N, M, 30);

%[ err,model_name ] = train_rf_rep_cnn( tfr_train, itfr_train, tfr_valid, itfr_valid);
figure(1); 
imagesc(N*(0:1/N:(1-1/N)),(0:1/M:1),abs(squeeze(itfr_test(2,:,:))).^0.5);
set(gca,'YDir','normal')
colormap gray;
colormap(flipud(colormap)); 
xlabel('time samples', 'FontSize', 16)  %, 'FontName', 'Times-Roman', 'FontSize', 20
ylabel('normalized frequency', 'FontSize', 16)
figure(2);
plot(N*(0:1/N:(1-1/N)),real(s_test(4,:)));
%save(filename);
