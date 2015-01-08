
% Marc-Antoine Desbiens
% November 2012
% timescale: Change the frequency of a sound without altering its speed

%sound : input sound
%ratios : the ratio of new frequency vs old frequency
%n : fft window size (default: 1024)
%H : fft window offset (default: n/4)

function [outputSound, outputSpectro, timeScaleInvRatio]=timescale(sound, ratios, n, H)
    
    %Default args
    if nargin < 3
        n = 1024;
        H = n/4;
    end
    
    %Get the number of windows and the number of frequencies for the sfft
    specgram = stft(sound,n,n,H);
    [nFreq, nWindows] = size(specgram);
    
    %Put all the ratios in an array
    if(size(ratios,1) == 1)
        timeScale = 0:ratios:(nWindows-2);
    else
        cumul = 0;
        timeScale = 0;
        timeScaleInvRatio = 1;
        while(cumul < nWindows-2)
           timeScale = [timeScale cumul];
           ratio = ratios(ceil(cumul) + 1);
           cumul = ratio + cumul;
           invRatio = 1/ratio;
           timeScaleInvRatio = [timeScaleInvRatio invRatio];
        end
    end
    
    %Init the spectrogram with zeros
    outputSpectro = zeros(nFreq, length(timeScale));
    
    %Estimate phase offset for each window
    deltaPhaseAve = zeros(1, nFreq);
    deltaPhaseAve(2:nFreq) = (2 * pi * H) ./((nFreq*2)./(1:nFreq-1));
    
    %Init phase sum
    cumulPhase = angle(specgram(:,1));
    coloneCourante = 1;
    
    %Main loop for time scaling
    for t = timeScale 
        
       % All the columns
       interCols = specgram(:, floor(t) + [1 2]);
       
       %  position offset between the sample and the real value
       pos = t - floor(t);
       
       % interpolation of the 2 samples
       frame = (1-pos)*abs(interCols(:,1)) + pos*abs(interCols(:,2));
       
       % Phase difference between observed value and estimated value
       deltaPhase = angle(interCols(:,2)) - angle(interCols(:,1)) - deltaPhaseAve';
       
       %Scale the phase to a number between -pi and pi
       deltaPhase = deltaPhase - 2 * pi * round(deltaPhase/(2*pi));
       
       %Fix the phase
       outputSpectro(:, coloneCourante) = frame .* exp(1i*cumulPhase);
       
       %Next iteration
       cumulPhase = cumulPhase + deltaPhaseAve' + deltaPhase;
       coloneCourante = coloneCourante + 1;
    end
    
    %output signal
    outputSound = istft(outputSpectro,n,n,H)';
    