% Authors: Marta Barriendos & Ana Garcia Armada, Univesidad Carlos III de Madrid
function salida = modulateQPSK(input,rotation,energy);

% Function that performs the QPSK modulation of energy, generating the output in low-pass equivalent.
A = energy; % Energy of 1

% Validity check of input data
err = find((input ~= 0) & (input ~= 1) & (input ~= 2) & (input ~= 3));
if (isempty(err) == 0) 
   disp('Incorrect input data for the QPSK modulator');
   disp('Valid data: 0,1,2,3');
   disp('Position of data incorrect:');
   err
   disp('Incorrect data:');
   input(err)
   salida = zeros(1,length(input));
   return;
else
   basei = [1+1j, -1+1j, -1-1j, 1-1j]; % QPSK original constellation

   base(1) = basei(3);
   base(2) = basei(2);
   base(3) = basei(4);
   base(4) = basei(1);
   
   salida = A*cos(angle(base(input+1)) + (rotation*pi/180)) + A.*j.*sin(angle(base(input+1)) + rotation*pi/180);   
end
