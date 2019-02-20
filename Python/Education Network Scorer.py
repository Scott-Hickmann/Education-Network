import google.oauth2.credentials

import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore

# Use the application default credentials
cred = credentials.Certificate("education-network-firebase-adminsdk-6hfw2-60e06fd930.json")
firebase_admin.initialize_app(cred)

db = firestore.client()

subject = "Math"
grade = "2nd grade"

categories = db.collection('Courses').document(subject).collection('Content').document(grade).collection('Content')
for category in categories.order_by('Id').get():
	print("\n%s" % category.id)
	lessons = categories.document(category.id).collection('Content')
	for lesson in lessons.order_by('Id').get():
		print(lesson.id)
		videos = lessons.document(lesson.id).collection('Content')
		for video in videos.order_by('Score').get():
			print(video.id)
			comprehensionCount = video.to_dict()["Comprehension count"]
			incomprehensionCount = video.to_dict()["Incomprehension count"]
			irrelevanceCount = video.to_dict()["Irrelevance count"]
			score = 2*comprehensionCount - incomprehensionCount - 2 * irrelevanceCount
			videos.document(video.id).update({"Score": score})