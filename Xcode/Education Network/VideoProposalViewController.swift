//
//  VideoProposalViewController.swift
//  Education Network
//
//  Created by Scott Hickmann on 11/25/18.
//  Copyright © 2018 Scott Hickmann. All rights reserved.
//

import UIKit
import Firebase
import youtube_ios_player_helper

let videoRef = db.collection("Videos").document("Math").collection("Addition")
let subjectPropertiesRef = db.collection("Videos").document("Math").collection("Properties").document("Addition")

class VideoProposalViewController: UIViewController, YTPlayerViewDelegate {

    var videos: [DocumentSnapshot] = []
    
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var playerView: YTPlayerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        playerView.delegate = self
        
        buttonsAreEnabled(enabled: false)
        
        videoRef/*.limit(to: 10)*/.getDocuments(completion: { (querySnapshot, error) in
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
    
    func buttonsAreEnabled(enabled: Bool) {
        yesButton.isEnabled = enabled
        noButton.isEnabled = enabled
    }
    
    func downloadVideo(from id: String) {
        let playerVars = ["playsinline": 1] // 0: will play video in fullscreen
        self.playerView.load(withVideoId: id, playerVars: playerVars)
        self.buttonsAreEnabled(enabled: true)
    }
    
    func getVideo() {
        if videos.count == 0 {
            return
        }
        let videoId = self.videos[0].data()!["ID"] as! String
        print(videoId)
        downloadVideo(from: videoId)
    }
    
    func nextVideo(popularityChange: Int) {
        buttonsAreEnabled(enabled: false)
        videoRef.document(videos[0].documentID).updateData([
            "Popularity": self.videos[0].data()!["Popularity"] as! Int + popularityChange
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                self.videos.remove(at: 0)
                self.getVideo()
            }
        }
    }
    
    @IBAction func onYes(_ sender: UIButton) {
        nextVideo(popularityChange: 1)
    }
    
    @IBAction func onNo(_ sender: UIButton) {
        nextVideo(popularityChange: -1)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
