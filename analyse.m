
% Marc-Antoine Desbiens
% November 2012
% Main function for processing sounds (it calls all the effects)

% x : Input sound
% y : Output sound
% handles: interface handles

%Note: All handles.somethingValue are from 0 to 1   
% or   -1 to 1 (time and pitch)
% 0 is always the sound without the effect

function y = analyse(x, handles)

%Get values from the UI
timeValue = get(handles.sTime, 'Value');
pitchValue = get(handles.sPitch, 'Value');
delayValue = get(handles.sDelay, 'Value');
delayTimeValue = get(handles.sDelayTime, 'Value');
reverbValue = get(handles.sReverb, 'Value');
wahwahValue = get(handles.sWahwah, 'Value');
tuneValue = get(handles.sTune, 'Value');
tuneOn = get(handles.cbTune, 'Value');
minfreq = floor(100-get(handles.sMinMax, 'Value')*100);
maxfreq = floor(get(handles.sMinMax, 'Value')*1000);
%minfreq = 15;

%Init sound
y = x;

%Chewbacca
if(handles.rSelect == 2)
    y = handles.chewSound;
    [N,D] = rat(handles.fs/handles.chewFs);
    y = resample(y, N, D);
end

%Reverse
if get(handles.cbReverse,'Value') == 1
    y = flipud(y);
end

%Robot
if(handles.rSelect == 3)
    y = sign(y).*abs(y).^(1/3);
    d = 800;
    n = length(y);
    y(1:n-d+1) = y(1:n-d+1) + y(d:n) + y(d/2:n-d/2);
    y = y*0.33;
end

%MonoTune
if (tuneOn == 1)
    freq = handles.notes(floor(tuneValue*49)+1);
    y = monotonize(y, handles.fs, freq, minfreq, maxfreq);
end

%Time scale
if timeValue ~= 0 || pitchValue ~= 0
    y=timescale(y,8^(timeValue-0.4*pitchValue));
end

%Pitch shift
if pitchValue ~= 0
    [N,D] = rat(8^(-0.4*pitchValue));
    y = resample(y,N,D);
end

%Reverb
if reverbValue > 0
    y = reverb(y, reverbValue, 120, handles.fs);
end

%Delay
if delayTimeValue > 0
    y = delay(y, delayValue, 2000*delayTimeValue, handles.fs);
end

%Wahwah
if wahwahValue > 0
    y = wahwah(y, wahwahValue*40000+1000, handles.fs);
end

%Darth Vader
if(handles.rSelect == 1)
    y = darthvader(y, handles.fs, handles.vaderSound, handles.vaderFs);
end
