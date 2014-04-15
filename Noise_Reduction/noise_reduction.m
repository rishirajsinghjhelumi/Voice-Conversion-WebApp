function noise_reduction(wavFile)

[y,fs,bps] = wavread(wavFile);
[data] = specsub(y,fs);

wavwrite(data, fs, bps, wavFile);

end