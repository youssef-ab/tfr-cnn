 function [ s, itfr ] = tfrs_ideal( c, N, M, SNR)
% [ s, tfr, itfr ] = tfr_ideal( a, fnorm, N, M, L, gamma_K, phi)
%
% Computes the ideal time frequency representation of a sinusoide
%
% INPUT:
% c :        signal amplitude
% N :        number of points
% fnorm :    normalised frequency
% M      :   number of frequency bins to process (default: length(x))
% SNR:       rapport signal bruit (default 30)
%
% OUTPUT:
% s:         the signal
% itfr:      ideal time-frequency representation

if ~exist('SNR', 'var')
 SNR = 30;
end
if (N<=0)
 error('N must be greater or equal to 1.');
else
 t = N*(0:1/N:1-1/N)';
 s=zeros(N,1);
 itfr = zeros(M,N);
 for j=1:length(c(:,1))
     s_tmp=zeros(N,1);
     itfr_tmp = zeros(M,N);
     for i=1:length(c(1,:))
         s_tmp = s_tmp + real(c(j,i))*(t.^(i-1)) + 1i*2*pi*imag(c(j,i))*(t.^(i-1));
     end
     s_tmp=exp(s_tmp);
     a_max=10;
     [I,~] = find(abs(s_tmp)>a_max);
     s_tmp(I) = a_max * exp(1j * angle(s_tmp(I)));
     abs(s_tmp);
    %s = exp(1i*(2.0*pi*imag(c(2))*t));
     w=0;
     for i=1:length(c(1,:))-1
         w=w+2*pi*i*imag(c(j,i+1))*t.^(i-1);
     end
     [I,~] = find(or(w > pi, w < 0));
     s_tmp(I) = 0;
     %ideal transformation
     m0 = round((M-1)*w/(2*pi))+1;
     for i=1:N
         if(and(m0(i)>0,m0(i)<=500))
            itfr_tmp(m0(i),i)=abs(s_tmp(i));
         end
     end
     s=s+s_tmp;
     itfr=itfr+itfr_tmp;
 end
 %signal with noise
 sigma=std(s)*10^(-SNR/20);
 b=sigma*crandn(1,N)';
 s=s+b;

end

