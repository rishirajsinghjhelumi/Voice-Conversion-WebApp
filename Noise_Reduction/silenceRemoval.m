function silenceRemoval(INPUT_FILE)

OUTPUT_FILE = INPUT_FILE;

[segments,fs] = detectVoiced(INPUT_FILE);
 
data = segments{1};

for i = 2:length(segments);
	data = [data; segments{i}];
end

wavwrite(data, fs, OUTPUT_FILE);

end