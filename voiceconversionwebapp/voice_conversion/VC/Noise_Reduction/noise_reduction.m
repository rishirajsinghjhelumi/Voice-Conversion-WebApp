function noise_reduction(wavFile)

[y,fs,bps] = wavread(wavFile);
[B,A] = butter(2,0.1);
data = filter(B,A,y);

wavwrite(data, fs, bps, wavFile);

end