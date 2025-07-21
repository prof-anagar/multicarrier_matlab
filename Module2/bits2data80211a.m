% Authors: Ana Garcia Armada et al., Univesidad Carlos III de Madrid
function data = bits2data80211a(input,rate,ns,padd);

% This function converts bits to data for IEEE 802.11a. This way, the modulated data is introduced into each of 
% the carriers.

%The inputs are, the input bits, the rate at which they will be transmitted that will select the modulation, in 
% our case BPSK, "ns" is the symbol number we are transmitting, and the padding "padd" that we will establish to 0.

% The ouptut is the modulated data. In principle, it should yield 48 data points, one for each of the carriers.


%Since rate=12:
bitspercarrier = 2;


% We add padding only if it's necessary, not in our case. 
if (padd ~= 0)
   for ii = 1:padd
      input = [input '0'];
   end 
end 

% We locate the input data we need to codify for the symbol number "ns"

init = 48 * (ns - 1) * bitspercarrier + 1;

aux = [];
for ii = init:bitspercarrier:init+bitspercarrier*48-1
   aux = [aux bin2dec(num2str(input(ii:ii+bitspercarrier-1)))];
end 

data = modulateQPSK(aux,45,1*sqrt(2));

end


