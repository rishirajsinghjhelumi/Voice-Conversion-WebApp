import os
import string
import random

def randomString(size=6, chars=string.ascii_uppercase + string.digits):
	return ''.join(random.choice(chars) for _ in range(size))

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

	userDirectory = 'user_data/user_%s'%(userId)
	wavDirectory = os.path.join(userDirectory, 'wav')

	return os.path.abspath(wavDirectory)

def trainCouple(user1Id, user2Id):

	currentDirectory = os.path.abspath(".")

	here = os.path.dirname(os.path.abspath(__file__))
	userDirectory = 'user_data/user_%s'%(user1Id)

	user1WavDirectory = getUserWavDirectory(user1Id)
	user2WavDirectory = getUserWavDirectory(user2Id)

	codeDirectory = os.path.join(here, "VC")
	tempCodeDirectory = os.path.join(userDirectory, "VC_%s"%(user2Id))
	os.system("cp -r %s %s"%(codeDirectory, tempCodeDirectory))
	os.system("chmod -R +x %s"%(tempCodeDirectory))
	os.chdir(tempCodeDirectory)

	os.system("bash training.sh %s %s"%(user1WavDirectory, user2WavDirectory))

	os.chdir(currentDirectory)

def convertUserVoiceToAnother(user1Id, user2Id, speechFile):
	pass