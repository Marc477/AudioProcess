
% Marc-Antoine Desbiens
% November 2012

% Mono-tuner: takes a sound and tune it to a unique frequency
% sound: input
% sr: Sample rate
% freq: the desired frenquency for the output
% minfreq/maxfreq: range inside of which frequencies will be detected

function monotonizedSound = monotonize(sound, sr, freq, minfreq, maxfreq)
    n = 1024;
    H = n/4;
    k=1;
    
    %Find fondamental frequency in each window
    peaks = findFreq(sound,n,H,sr, minfreq, maxfreq);
    ratios = peaks ./ freq;
    %Change speed before resampling
    [scaledSound, specgramSortant, invertedRatios] = timescale(sound,ratios,n,H);
    samplesPerWindow = size(scaledSound,1)/size(specgramSortant,2);
    %Resample to change pitch
    monotonizedSound = zeros(length(sound),1);
    for it=0:length(invertedRatios)-2
        [num,denum] = rat(invertedRatios(it+1));
        nextWindow = resample(scaledSound(ceil(samplesPerWindow*it + 1):ceil(samplesPerWindow*(it+1)+1)),denum,num);
        monotonizedSound(k:k+length(nextWindow)-1) = nextWindow;
        k = k + length(nextWindow);
    end
end