
% Marc-Antoine Desbiens
% November 2012

%Delay effect
%sound: Input sound
%gain: Delay amplitude
%delaytime: delay time in seconds
%fs: frequency sample of the input

function [outSound] = delay(sound, gain, delaytime, fs)

if nargin == 4
    M=floor(delaytime./1000.*fs);
else
    M=floor(delaytime);
end

L = length(sound);
reponse = sound;

for n = M+1:L
    reponse(n) = sound(n)+gain*(reponse(n-M));
end

outSound = reponse;

