
% Marc-Antoine Desbiens
% November 2012

% Find the dominant frequency of a signal
% sound: input
% wLen: sfft window length
% H: sfft window offset
% sr: Sample rate
% minim: Minimum freq that can be found
% maxim: Maximum freq that can be found

function [ fondFreqs ] = findFreq( sound, wLen, H, sr, minim, maxim)

%Short time fourier
SFFT = stft(sound,wLen,wLen,H);
[~, nWindows] = size(SFFT);

%Pad if sound is shorter then window length
sound = padarray(sound,wLen,0);

%Init fondamental frquency array
fondFreqs = zeros(nWindows,1);
fondFreqs(1) = (minim + maxim)./2;

warning('off');

%Find frequency
for i =2:nWindows
    lower = (i-1)*H + wLen/2;
    upper = (i-1)*H + 3*wLen/2;
    FFT = abs(fft(sound(lower:upper),sr));
    %FFT = abs(SFFT(:,i));
    maxFFT = max(FFT);
    minPeakHeight = maxFFT*0.3;
    [pksFound, pksIDFound] = findPeaks(FFT(1:maxim),'MINPEAKHEIGHT',minPeakHeight);
    fondFreqs(i) = fondFreqs(i-1);
    if(size(pksFound,1)==1)
        freq = min(pksIDFound);
        if freq > minim
            fondFreqs(i) = freq;
        end
    end
end

warning('on');

hFilter = [1/10,2/10,4/10,2/10,1/10];
fondFreqs = conv(fondFreqs,hFilter);
    
    