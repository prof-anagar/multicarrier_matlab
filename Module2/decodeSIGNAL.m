% Authors: Ana Garcia Armada et al., Univesidad Carlos III de Madrid
function [rate,len,pilots] = decodeSIGNAL(input);

% This function takes the samples from the input signal "input" and decodes them.
% This way, we obtain the rate at which the packet was encoded and how many symbols there are.

% Inputs:
%   Input:         Input samples from SIGNAL

% Outputs:
%   rate:           The rate at which the packet has been encoded
%   len:            Length of the encoded data in the packet
%   pilotos:        Extracts the pilots from the signal


% Constants
PC = 16; % Number of samples of the cyclic prefix. 
N = 64; % Number of subcarriers

tablarates = [13 15 5 7 9 11 1 3]; % R1-R4 in decimal
tablaindex = [6 9 12 18 24 36 48 54]; % Mbps


% We remove the cyclic prefix

input = input(PC+1:end);

inputdem = fft(input,N); % We change to the frequency domain

%We define the data pattern
pattern = [-26:-22 -20:-8 -6:-1 1:6 8:20 22:26] + 33;

% We get the pilots, that are in known positions

pilots = [inputdem(12) inputdem(26) inputdem(40) inputdem(54)];

% We extract the data using the data pattern 

data = inputdem(pattern);

% Demodulate using BPSK because we have redundancy

datosdem = (data(1:24) + data(25:end)/2) > 0; %To take advatange that we have two times repeated the information.
%The structure of the incoming data contains redundancy, specifically that the information has been encoded in a 
% way that each piece of data appears twice.

bits = datosdem;

bitstr = num2str(bits);
bitstr = bitstr(1:3:end);

rate = tablaindex(find(tablarates == bin2dec(bitstr(1:4))));

len = bin2dec(bitstr(6:6+11));

