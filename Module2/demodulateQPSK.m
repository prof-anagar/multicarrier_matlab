% Authors: Ana Garcia Armada et al., Univesidad Carlos III de Madrid
function output = demodulateQPSK(input,rotation,energy);

%This function makes the QPSK demodulation of energy. 

%As inputs we have, the sequence of data modulated in QPSK "input", the
%rotation of the original constellation in degrees "rotation" and the
%energy of the signal. 

%The output is the data sequence demodulated. 
 
A = energy; % Energy of 1

basei = [1+1j, -1+1j, -1-1j, 1-1j]; % Original QPSK Constellation
base(1) = basei(3);
base(2) = basei(2);
base(3) = basei(4);
base(4) = basei(1);

out = [0,1,2,3];
aux = A*cos(angle(base(out+1)) + (rotation*pi/180)) + A.*j.*sin(angle(base(out+1)) + rotation*pi/180);   



aux1 = dec2bin(double(real(input) > 0)) - 48;
aux2 = dec2bin(double(imag(input) > 0)) - 48;
auxi = zeros(1,length(input)*2);

auxi(1:2:end) = aux1;
auxi(2:2:end) = aux2;


for ii=1:length(input)
	[throw,output(ii)] = min(aux - input(ii));  
end 

output = output - 1;

