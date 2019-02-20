import re
from itertools import groupby

import urllib.request
from bs4 import BeautifulSoup

import google.oauth2.credentials

import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore

from googleapiclient.discovery import build
from googleapiclient.errors import HttpError
from google_auth_oauthlib.flow import InstalledAppFlow

# The CLIENT_SECRETS_FILE variable specifies the name of a file that contains
# the OAuth 2.0 information for this application, including its client_id and
# client_secret.
CLIENT_SECRETS_FILE = "client_secret_217910399803-bttdfm04q3fssc5k9hhjv5cshnklf9oc.apps.googleusercontent.com.json"

# This OAuth 2.0 access scope allows for full read/write access to the
# authenticated user's account and requires requests to use an SSL connection.
SCOPES = ['https://www.googleapis.com/auth/youtube.force-ssl']
API_SERVICE_NAME = 'youtube'
API_VERSION = 'v3'

# Use the application default credentials
cred = credentials.Certificate("education-network-firebase-adminsdk-6hfw2-60e06fd930.json")
firebase_admin.initialize_app(cred)

db = firestore.client()

subject = "Math"
grade = "2nd grade"

db.collection('Courses').document(subject).set({
  "Type": "Subject"
})

db.collection('Courses').document(subject).collection('Content').document(grade).set({
  "Type": "Grade"
})

def getAuthenticatedService():
  flow = InstalledAppFlow.from_client_secrets_file(CLIENT_SECRETS_FILE, SCOPES)
  credentials = flow.run_console()
  return build(API_SERVICE_NAME, API_VERSION, credentials=credentials)

def uploadToFirestore(videoId, videoDuration):
  #categoryRef.set({
  #  "Lessons": {str(lessonNumber): lesson}
  #}, merge=True)
  categoryRef.set({
    "Type": "Category",
    "Id": categoryNumber
  })
  lessonRef.set({
    "Type": "Lesson",
    "Id": lessonNumber
  })
  lessonRef.collection('Content').document(videoId).set({
    "Type": "Video",
    "Id": videoId,
    "Duration": videoDuration,
    "Score": 0,
    "Comprehension count": 0,
    "Dislike count": 0,
    "Incomprehension count": 0,
    "Irrelevance count": 0
  })

timeValueInSeconds = {"H": 3600, "M": 60, "S": 1}

def durationInSeconds(ISO8601Time):
  listTime = [''.join(g) for _, g in groupby(ISO8601Time, str.isalpha)]#re.findall('\d+', ISO8601Time)
  listTime.pop(0)#listTime.reverse()
  secondsTime = 0
  for position in range(0, len(listTime), 2):
    secondsTime += int(listTime[position])*timeValueInSeconds[listTime[position+1]]
  return secondsTime

def videosListById(client, **kwargs):
  video = client.videos().list(
    **kwargs
  ).execute()

  videoId = video["items"][0]["id"]
  ISO8601Duration = video["items"][0]["contentDetails"]["duration"]
  videoDuration = durationInSeconds(ISO8601Duration)

  if videoDuration <= 600:
    print("Id: %s, Duration: %ss" % (videoId, videoDuration))
    uploadToFirestore(videoId, videoDuration)

def searchListByKeyword(client, **kwargs):
  response = client.search().list(
    **kwargs
  ).execute()

  for video in response["items"]:
    videosListById(client,
      part='contentDetails',
      id=video["id"]["videoId"])

def getVideos():
  searchListByKeyword(client,
      part='id',
      maxResults=25,
      q='%s %s' % (lesson, grade),
      type='video')

#req = urllib.request.Request('https://www.khanacademy.org/math/cc-2nd-grade-math/cc-2nd-add-subtract-100', headers={'User-agent' : 'Mozilla/5.0'})
#with urllib.request.urlopen(req) as response:
#  html = response.read()
categoryNumber = -1
lessonNumber = 0
previousCategory = None
client = getAuthenticatedService()
htmlFile = open("Results.html","r")
html = htmlFile.read()
soup = BeautifulSoup(html, 'html.parser')
for lessonHtml in soup.findAll(attrs={'class':'text_12zg6rl-o_O-LabelSmall_t10oqw-o_O-link_1aw2z3h'}):
  lesson, category = lessonHtml.text.split(": ")
  if previousCategory != category:
    categoryNumber += 1
    lessonNumber = 0
    previousCategory = category
    print("\n%s" % category)
  print(lesson)
  categoryRef = db.collection('Courses').document(subject).collection('Content').document(grade).collection('Content').document(category)
  lessonRef = categoryRef.collection('Content').document(lesson)
  getVideos()
  lessonNumber += 1
