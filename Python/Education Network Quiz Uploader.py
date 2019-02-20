import google.oauth2.credentials

import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore

# Use the application default credentials
cred = credentials.Certificate("education-network-firebase-adminsdk-6hfw2-60e06fd930.json")
firebase_admin.initialize_app(cred)

db = firestore.client()
quizFile = open("Quiz.txt","r")

quizRaw = quizFile.readlines()
for lineNumber in range(len(quizRaw)):
	quizRaw[lineNumber] = quizRaw[lineNumber].replace("\n", "")

subject = quizRaw[0]
grade = quizRaw[1]
category = quizRaw[2]

print(subject)
print(grade)
print(category)

del quizRaw[:4]

quizzes = []
quiz = {}

for lineNumber in range(len(quizRaw)):
	if lineNumber % 7 == 0:
		quiz["Question"] = quizRaw[lineNumber]
	elif lineNumber % 7 == 5:
		quiz["Answer"] = quizRaw[lineNumber]
		quizzes.append(quiz)
	elif lineNumber % 7 == 6:
		quiz = {}
	else:
		optionNumber, option = quizRaw[lineNumber].split(": ")
		quiz[optionNumber] = option

print(quizzes)

for quizNumber in range(len(quizzes)):
	db.collection('Courses').document(subject).collection('Content').document(grade).collection('Content').document(category).collection("Quiz").document(str(quizNumber)).set(quizzes[quizNumber])