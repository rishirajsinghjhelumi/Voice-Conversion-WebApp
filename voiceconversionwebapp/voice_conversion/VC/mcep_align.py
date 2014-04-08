import sys

def alignMCEP(mcepFile, costFile):

	fpCost = open(costFile, "r")
	mcepLines = {}
	for line in fpCost.readlines():
		targetLine, sourceLine, cost = line.strip().split()
		mcepLines[int(targetLine)] = int(sourceLine)
	fpCost.close()

	mcepLength = len(mcepLines)

	mceps = []
	fpMCEP = open(mcepFile, "r")
	for line in fpMCEP.readlines():
		mceps.append(line.strip())
	fpMCEP.close()

	fpMCEP = open(mcepFile, "w")
	for i in xrange(mcepLength):
		fpMCEP.write(mceps[mcepLines[i]] + "\n")
	fpMCEP.close()	

if __name__ == '__main__':
	
	mcepFile = sys.argv[1]
	costFile = sys.argv[2]
	alignMCEP(mcepFile, costFile)
