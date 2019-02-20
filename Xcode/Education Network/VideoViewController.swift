//
//  VideoViewController.swift
//  Education Network
//
//  Created by Scott Hickmann on 11/27/18.
//  Copyright © 2018 Scott Hickmann. All rights reserved.
//

import UIKit
import Firebase
import youtube_ios_player_helper
import SideMenuSwift

class VideoViewController: UIViewController, YTPlayerViewDelegate {
    
    @IBOutlet weak var playerView: YTPlayerView!
    @IBOutlet weak var lessonNavigationBar: UINavigationItem!
    @IBOutlet weak var irrelevanceButton: UIBarButtonItem!
    @IBOutlet weak var comprehensionButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var incomprehensionButton: UIButton!
    @IBOutlet weak var dislikeButton: UIButton!
    
    var lessons: [String] = []
    var videos: [DocumentSnapshot] = []
    var lessonNumber = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        playerView.delegate = self
        
        buttonsAreEnabled(enabled: false)
        
        //let menuViewController = storyboard!.instantiateViewController(withIdentifier: "Menu View Controller")
        //view.addSubview(menuViewController.view!)
        //addChild(menuViewController)

        categoryRef.collection("Content").order(by: "Id").getDocuments(completion: { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                for document in querySnapshot!.documents {
                    self.lessons.append(document.documentID)
                }
                print(self.lessons)
                self.lessonNavigationBar.title = self.lessons[0]
                self.getVideos()
            }
        })
        /*.getDocument(completion: { (documentSnapshot, error) in
            if let error = error {
                print("Error getting document: \(error)")
            } else {
                self.lessons = documentSnapshot!.data()!["Lessons"] as! [String: String]
                print(self.lessons)
                self.lessonNavigationBar.title = self.lessons["0"]
                self.getVideos()
            }
        })*/
    }
    
    func buttonsAreEnabled(enabled: Bool) {
        irrelevanceButton.isEnabled = enabled
        comprehensionButton.isEnabled = enabled
        //skipButton.isEnabled = enabled
        incomprehensionButton.isEnabled = enabled
        //dislikeButton.isEnabled = enabled
    }
    
    func downloadVideo(from id: String) {
        let playerVars = ["playsinline": 1] // 0: will play video in fullscreen
        playerView.load(withVideoId: id, playerVars: playerVars)
        buttonsAreEnabled(enabled: true)
    }
    
    func getVideo() {
        if videos.count == 0 {
            return
        }
        let videoId = self.videos[0].data()!["Id"] as! String
        print(videoId)
        downloadVideo(from: videoId)
    }
    
    func getVideos() {
        videos = []
        lessonRef.collection("Content")/*.limit(to: 10)*/.order(by: "Score").getDocuments(completion: { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                for document in querySnapshot!.documents {
                    self.videos.append(document)
                }
                self.getVideo()
            }
        })
    }
    
    func nextLesson() {
        lessonNumber += 1
        lessonNavigationBar.title = lessons[lessonNumber]
        lessonRef = categoryRef.collection("Content").document(lessons[lessonNumber])
        getVideos()
    }
    
    func seeOtherVideo(fieldToChange: String) {
        lessonRef.collection("Content").document(videos[0].documentID).updateData([
            fieldToChange: self.videos[0].data()![fieldToChange] as! Int + 1
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                self.videos.remove(at: 0)
                self.getVideo()
            }
        }
    }
    
    @IBAction func onMenuBarButtonItem(_ sender: Any) {
        if sideMenuController!.isMenuRevealed {
            sideMenuController?.hideMenu()
        } else {
            sideMenuController?.revealMenu()
        }
    }
    
    @IBAction func onIrrelevanceButton(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Irrelevance", message: "Are you sure that this video is irrelevant?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { action in
            self.buttonsAreEnabled(enabled: false)
            self.seeOtherVideo(fieldToChange: "Irrelevance count")
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        
        present(alert, animated: true)
    }
    
    @IBAction func onITSComprehensionButton(_ sender: UIButton) {
        buttonsAreEnabled(enabled: false)
        lessonRef.collection("Content").document(videos[0].documentID).updateData([
            "Comprehension count": self.videos[0].data()!["Comprehension count"] as! Int + 1
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                self.nextLesson()
            }
        }
        // Post a like on Youtube
    }
    
    @IBAction func onLessonComprehensionButton(_ sender: UIButton) {
        buttonsAreEnabled(enabled: false)
        lessonRef.collection("Content").document(videos[0].documentID).updateData([
            "Comprehension count": self.videos[0].data()!["Comprehension count"] as! Int + 1
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                self.navigationController?.popViewController(animated: true)
            }
        }
        // Post a like on Youtube
    }
    
    /*@IBAction func onSkipButton(_ sender: UIButton) {
        buttonsAreEnabled(enabled: false)
        nextLesson()
        // Don't change anything in relation with the video
    }*/
    
    @IBAction func onIncomprehensionButton(_ sender: UIButton) {
        buttonsAreEnabled(enabled: false)
        seeOtherVideo(fieldToChange: "Incomprehension count")
        // Post a dislike on Youtube
    }
    
    /*@IBAction func onDislikeButton(_ sender: UIButton) {
        buttonsAreEnabled(enabled: false)
        seeOtherVideo(fieldToChange: "Dislike count")
    }*/
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */

}
