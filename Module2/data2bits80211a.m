% Authors: Ana Garcia Armada et al., Univesidad Carlos III de Madrid
function bits = data2bits80211a(input,rate)

% This function performs the complementary process to bits2data80211a, it takes the input data modulated in the QPSK
% Modulation, and it returns the corresponding bit sequence.

% The output is the sequence "bits"corresponding to the input data.

% We know that rate=12, therefore the modulation is QPSK:

data = demodulateQPSK(input,45,1*sqrt(2));
bitspercarrier = 2;

% Now we change data to bits: 

bitsj = []; % Here we have the bits together, then we will separate them
index = 1; 
for ii = 1:length(data)
   bitsj(index:index+(bitspercarrier-1)) =  dec2bin(data(ii),bitspercarrier) - 48;
   index = index + bitspercarrier;
end 
%Now we separate the bits and convert them to integers
bits = bitsj >0.5;

