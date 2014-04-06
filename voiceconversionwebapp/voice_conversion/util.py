import os

def makeDirectory(directory):
	if not os.path.exists(directory):
		os.makedirs(directory)

def saveUserParagraph(userId, paragraphId, speechFile):
	
	file_path = "user_data/user_%s/wav/paragraph_%s.wav"%(userId, paragraphId)
	input_file = speechFile.file

	output_file = open(file_path, 'wb')

	input_file.seek(0)
	while True:
		data = input_file.read(2<<16)
		if not data:
		    break
		output_file.write(data)

	output_file.close()

def initUserDirectories(userId):
	
	userDirectory = 'user_data/user_%s'%(userId)
	wavDirectory = os.path.join(userDirectory, 'wav')
	convertedSpeechDirectory = os.path.join(userDirectory, 'converted')

	makeDirectory(userDirectory)
	makeDirectory(wavDirectory)
	makeDirectory(convertedSpeechDirectory)

def getUserWavDirectory(userId):

	userDirectory = 'static/user_data/user_%s'%(userId)
	wavDirectory = os.path.join(userDirectory, 'wav')

	return wavDirectory

def trainCouple(user1Id, user2Id):
	pass

def convertUserVoiceToAnother(user1Id, user2Id, speechFile):
	pass