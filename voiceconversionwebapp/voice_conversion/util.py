import os

def saveUserParagraph(userId, paragraphId, speechFile):
	
	file_path = "static/user_data/user_%s/wav/paragraph_%s.wav"%(userId, paragraphId)
	input_file = speechFile.file

	output_file = open(file_path, 'wb')

	input_file.seek(0)
	while True:
		data = input_file.read(2<<16)
		if not data:
		    break
		output_file.write(data)

	output_file.close()