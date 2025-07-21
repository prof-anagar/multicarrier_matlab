% Authors: Ana Garcia Armada et al., Univesidad Carlos III de Madrid
function symb = generatesymbol80211a(data);

% This function generates an OFDM symbol with the data passed as an argument. It adds the cyclic prefix.
% It follows the IEEE802.11a standard and it also includes the guard intervals.
% The data we are introducing as input goes into each carrier, and we
% assumed that is already modulated. 

%The output is the time-domain symbol, along with the cyclic prefix.

% Constantes
N = 64; % 64 subcarriers
GF = 6; % 6 frequency guards
PC = 15; % Cyclic prefix

% We add the guards following the implementation.

datosi = [0 data(27:52) zeros(1,11) data(1:26)];

symb = ifft(datosi,N); %Generating the OFDM symbol

symb = [symb(end - PC:end) symb]; %Add the cylic prefix



