% Authors: Ana Garcia Armada et al., Univesidad Carlos III de Madrid
function H_est = estimatechannelDFT(input,N,f1,f2,pos_pilots,Length_Header,Init,Nsymb,PC,ref);

% Function that performs channel estimation using the DFT method.

% Inputs:
%   input:               Input packet
%   N:                     Number of carriers. For IEEE 802.11a, it is 64.
%   f1:                    Guard frequencies at the beginning. For IEEE 802.11a, it is 6.
%   f2:                    Guard frequencies at the end. For IEEE 802.11a, it is 6.
%   pos_pilots:          Position of the pilots. This determines how many there are.
%   Length_Header:        Length in number of samples of the header. For IEEE 802.11a, it is 320.
%   Init:               Position where the long symbols begin. For IEEE 802.11a, it is 161.
%   Nsymb:                Number of long symbols used. For IEEE 802.11a, it is 2.
%   PC:                   Number of samples of the Cyclic Prefix. For IEEE 802.11a, it is 16 for normal symbols,
%                         but for Long Training Symbols, it is 32.
%   ref:                  Reference pilots
% 
% Outputs:
%   H_est:                Channel estimation performed.


block = input(Init:Length_Header); % Tomamos los símbolos largos de entrenamiento

% We estimate as many times as long symbols we have

est_can = []; % Here we'll have the estimation for each long symbol

ini = 1;
for n_s = 1:2:Nsymb
   refi=fft(block(ini+PC:ini+PC+N-1),N);
   % Reorder
   refi = refi(2:end); refi = [refi(1:26) refi(38:end)];
   Qf=refi./ref;
   est_can(n_s,:) = Qf;
   
  % Now we take the next symbol with pilots 
   refi = fft(block(ini+N+PC:ini+2*N+PC-1),N);
   % Reorder
   refi = refi(2:end); refi = [refi(1:26) refi(38:end)];
   Qf=refi./ref;
   est_can(n_s+1,:) = Qf;
   
end 

H_est = sum(est_can)./Nsymb;
