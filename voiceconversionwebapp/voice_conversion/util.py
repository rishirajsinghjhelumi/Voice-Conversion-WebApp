import os
import string
import random

from multiprocessing import Pool

def randomString(size=6, chars=string.ascii_uppercase + string.digits):
	return ''.join(random.choice(chars) for _ in range(size))

def makeDirectory(directory):
	if not os.path.exists(directory):
		os.makedirs(directory)

def noiseReduction(wavFile):

	wavFile = os.path.abspath(wavFile)

	currentDirectory = os.path.abspath(".")
	noiseReductionCodeDirectory = "Noise_Reduction"

	def runNoiseReduction():
		os.chdir(noiseReductionCodeDirectory)
		os.system('octave --silent --eval "noise_reduction(\'%s\')"'%(wavFile))
		os.system('octave --silent --eval "silenceRemoval(\'%s\')"'%(wavFile))
		os.chdir(currentDirectory)

	pool = Pool(maxtasksperchild = 1)
	pool.map(runNoiseReduction, [])
	pool.close()
	pool.join()

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

	noiseReduction(file_path)

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

	def runTraining():
		os.chdir(tempCodeDirectory)
		os.system("bash training.sh %s %s"%(user1WavDirectory, user2WavDirectory))
		os.chdir(currentDirectory)

	pool = Pool(maxtasksperchild = 1)
	pool.map(runTraining, [])
	pool.close()
	pool.join()

def convertUserVoiceToAnother(user1Id, user2Id, speechFile):

	currentDirectory = os.path.abspath(".")

	userDirectory = 'user_data/user_%s'%(user1Id)
	codeDirectory = os.path.join(userDirectory, "VC_%s"%(user2Id))
	convertedWavDirectory = os.path.join(userDirectory, "converted")
	user2WavDirectory = getUserWavDirectory(user2Id)

	randomFileName = randomString(15)
	randomTestDirectory = os.path.join(userDirectory, randomFileName)
	makeDirectory(randomTestDirectory)

	user1TestWavDirectory = os.path.abspath(randomTestDirectory)

	file_path = os.path.join(randomTestDirectory, "test_%s.wav"%(randomFileName))
	input_file = speechFile.file
	output_file = open(file_path, 'wb')
	input_file.seek(0)
	while True:
		data = input_file.read(2<<16)
		if not data:
		    break
		output_file.write(data)
	output_file.close()

	noiseReduction(file_path)

	def runTesting():
		os.chdir(codeDirectory)
		os.system("bash testing.sh %s %s"%(user1TestWavDirectory, user2WavDirectory))
		os.chdir(currentDirectory)

	pool = Pool(maxtasksperchild = 1)
	pool.map(runTesting, [])
	pool.close()
	pool.join()

	convertedFilePath = os.path.join(convertedWavDirectory, randomFileName + ".wav")
	os.system("mv %s/Speaker_B_Predicted.wav %s"%(codeDirectory, convertedFilePath))
	os.system("rm -rf %s"%(user1TestWavDirectory))
	
	return os.path.join("static", convertedFilePath)