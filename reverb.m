
% Marc-Antoine Desbiens
% November 2012

%Reverb Effect
%sound: Input sound
%gain: Delay amplitude
%delaytime: delay time in seconds
%fs: frequency sample of the input

function [outSound] = reverb(sound, gain, delaytime, fs)

if nargin == 4
    M=floor(delaytime./1000.*fs);
else
    M=floor(delaytime);
end

b = zeros(M,1);
b(1) = 1;
b(M) = -gain;
a = 1;

h = impz(b,a);
outSound = conv(sound,h);
