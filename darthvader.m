
% Marc-Antoine Desbiens
% November 2012

function outSound = darthvader(sound, fs, vaderSound, vaderFs)

%Remove other channels
vaderSound = vaderSound(:,1);

%Resample darthVader to fit the sound
[N,D] = rat(fs/vaderFs);
vaderSound = resample(vaderSound, N, D);

%Loop vader Sound
Ls = length(sound);
Lv = length(vaderSound);

if(Ls > Lv)
    for K = 1:ceil(Ls/Lv)
       vaderSound(1+K*Lv:Lv+K*Lv) = vaderSound(1:Lv);
    end
end
    
vaderSound = vaderSound(1:Ls);

%Add sound togheter
outSound = 1.5*sound + 0.5*vaderSound;

