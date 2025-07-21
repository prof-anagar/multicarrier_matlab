% Authors: Ana Garcia Armada et al., Univesidad Carlos III de Madrid
function [corr,output_data,rate,n_symbols,padding] = receivepack80211aZFP(input_packet,Nsymb,Rate,H_est);

% This function receives a data packet according to the IEEE 802.11a standard, retrieves the necessary information, 
% and decodes the raw data to pass it to the upper layer.
% The channel is corrected with the estimation using Zero Forcing.

% Inputs:
%   input_packet:          These are the samples of the packet.
%   Nsymb:                 Indicates the number of symbols being used. This is to bridge
%                          the fact that the header is not protected by convolutional coding.
%   Rate:                  Indicates the Rate. It is similar to the previous parameter.
%   H_est:                 Channel estimation. Passed with the guards and everything.

% Outputs:
%   output_data:           These are the decoded data, output in bits.
%   rate:                  The rate used in that packet.
%   n_symbols:             Number of symbols transmitted in that packet.
%   padding:               Number of padding bits in the last symbol.


corr = [];

padding = 0;

% Constant

HeaderLength = 321; %The header has 321 samples
SignalLength=80;

nopilots = [1:5 7:19 21:33 35:47 49:52];

N = 64; % Number of subcarriers
PC = 16;	% Number of samples of the cyclic prefix. 

% First we obtain the the header of the packet and we remove the training sequences.
input = input_packet(HeaderLength+1:end);

% We obtain the signal

SIGNAL = input(1:SignalLength);

% We decode the signal

[rate,len,pilots] = decodeSIGNAL(SIGNAL); 

% Once we have the features of the packet we decode the rest

n_symbols = Nsymb;
rate = Rate;
   
% We start receiving the symbols
init = HeaderLength+SignalLength;

output_data = [];


for n_s =1:n_symbols
   if (init + (n_s * SignalLength) <= length(input_packet))
      actual = input_packet(init+1+((n_s - 1) * SignalLength):init+(n_s * SignalLength));   
   else
      disp('Error with the size.');
      mensaje = ['Packet size: ' num2str(length(input_packet)) ', Size required: ' num2str(init + (n_s * SignalLength)) '.'];
      disp(mensaje);
      return;
   end 
   
  % In actual we have the samples of the actual symbol
   actual = actual(PC + 1:end); % We remove the cyclic prefix
   
   
   % We make the fft
   simbFFTa = fft(actual,N);
   
   % We delete the guardbands
   simbFFTa = [simbFFTa(2:27) simbFFTa(39:64)];
   
   H_estimated = [H_est(2:27) H_est(39:64)];
   %Correcting the channel with the ZF implementation
   simbFFTb = simbFFTa./H_estimated; % ZF
   
    %Reorder
   simbFFTb = [simbFFTb(27:52) simbFFTb(1:26)];
   
  
   % Removing the pilots
   simbFFT = simbFFTb(nopilots);
   
     
   output_data = [output_data data2bits80211a(simbFFT,rate)];
   corr = [corr simbFFT];
   
      
   
end 
