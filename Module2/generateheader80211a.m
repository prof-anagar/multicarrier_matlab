function header = generateheader80211a

% Authors: Ana Garcia Armada et al., Univesidad Carlos III de Madrid
% This function generates the header with the 10 short and 2 long training
% sequences of 802.11a
% That is, it generates:
% t1 t2 t3 t4 t5 t6 t7 t8 t9 t10 G12 T1 T2

N = 64; % Number of carriers in 802.11a

PC = 31; % PC samples, actually it is 32

% Generate short training symbols t1...t10 symbols for the short training sequence to be transmitted on the carriers, 
% normalized in power with the first term

symbolsti = sqrt(13/6).*[0 0 0 0 -1-j 0 0 0 -1-j 0 0 0 1+j 0 0 0 1+j 0 0 0 1+j 0 0 0 1+j 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1+j 0 0 0 -1-j 0 0 0 1+j 0 0 0 -1-j 0 0 0 -1-j 0 0 0 1+j 0 0 0]; % Sin el 0 en la central Invertidos. Así sale como en el Standard

tempti = ifft(symbolsti,N);  % Perform the IFFT

% The time interval defined for each "short" symbol in the standard
% is 0.8 microseconds
tempti = tempti(1:16); % Take the first 16 samples. This is to achieve the time of 0.8 us

tempsts = repmat(tempti,[1 10]); % Repeat the symbol ti 10 times

% Add the first sample at the end of the sequence
tempsts = [tempsts tempsts(1)];  

% Apply windowing to the first and last samples, smoothing the transition at the
% edges of the signal and reducing discontinuities and ISI
tempsts(1) = tempsts(1) * 0.5;
tempsts(161) = tempsts(161) * 0.5;

% Generate the long training sequences
simbolosT12 = [0 1 -1 -1 1 1 -1 1 -1 1 -1 -1 -1 -1 -1 1 1 -1 -1 1 -1 1 -1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 1 1 -1 -1 1 1 -1 1 -1 1 1 1 1 1 1 -1 -1 1 1 -1 1 -1 1 1 1 1]; % Invertidos. Así sale como en el stándard


tempT12 = ifft(simbolosT12,N);

tempT12 = repmat(tempT12, [1 2]); % Repetimos en el tiempo otra vez, es decir, hacemos T2

tempT12 = [tempT12(end - PC:end) tempT12]; % Add CP

% Add the first inverted sample at the end according to the standard
tempT12 = [tempT12 tempT12(1)*-1]; 

% Apply windowing and overlap the last sample of the short with the first of the long
tempT12(1) = 0.5 * tempT12(1);
tempT12(161) = 0.5 * tempT12(161);

mix = tempsts(161) + tempT12(1); % Overlap

% The last sample of the "short" sequence overlaps with the first of the "long" sequence. This is necessary to ensure a smooth transition between the two training sequences.
header = [tempsts(1:160) mix tempT12(2:end)]; % Return the header in time
