% Authors: Ana Garcia Armada et al., Univesidad Carlos III de Madrid
function signal = fillsignal(rate,len);

% This function fills the OFDM SYMBOL SIGNAL with the appropriate data.
% It produces the OFDM symbol, including its guard interval and everything.
% Inputs:
%   rate: This is the desired rate (6, 9, 12, 18, 24, 36, 48, 54) Mbps
%   len: This is the number of octets requested by the upper layer (MAC) for
%         transmission.
% Outputs:
% signal: This is the output signal. It is an OFDM symbol with the guard included.

% We will have 24 bits. Since they are modulated in BPSK and with a 1/2 convolutional encoder,
% we will have 48 bits, one for each of the carriers.


PC = 15; % PC samples. Actually, it is 16.
bits = zeros(1,24);% First, all zeros; we will fill in as appropriate.


% Our rate is 12 Mbps, which corresponds to an integer value that
% represents the rate in binary but in decimal format of 5.
   
bits(1:4) = dec2bin(5,4) - 48;
bits(6:6+11) = dec2bin(len,12) - 48; % Place Length
bits(18) = mod(sum(bits),2); % Add parity

% Just duplicate.
bits12 = [bits bits];

% We now have the encoded data; we need to modulate them in BPSK:
% 0 --> -1
% 1 --> +1


bitsmod = bits12 * 2;
bitsmod = bitsmod - 1;

symbols = zeros(1,64);
pattern = [-26:-22 -20:-8 -6:-1 1:6 8:20 22:26] + 33;
symbols(pattern) = bitsmod;

% Place the pilots with known amplitudes
symbols(12) = 1;
symbols(26) = 1;
symbols(40) = 1;
symbols(54) = -1;
%Generate the OFDM symbol
signal = ifft(symbols); 
signal = [signal(end - PC:end) signal]; % Adding PC
