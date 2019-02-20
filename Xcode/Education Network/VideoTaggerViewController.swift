//
//  VideoTaggerViewController.swift
//  Education Network
//
//  Created by Scott Hickmann on 11/25/18.
//  Copyright © 2018 Scott Hickmann. All rights reserved.
//

import UIKit
import Firebase
import youtube_ios_player_helper

class VideoTaggerViewController: UIViewController, YTPlayerViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    var videos: [DocumentSnapshot] = []
    var tags: [[String: Any]] = []
    var tag: [String: Any] = [:]
    
    @IBOutlet weak var playerView: YTPlayerView!
    @IBOutlet weak var tagsPickerView: UIPickerView!
    @IBOutlet weak var doneButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        playerView.delegate = self
        tagsPickerView.delegate = self
        tagsPickerView.dataSource = self
        
        buttonsAreEnabled(enabled: false)
        
        subjectPropertiesRef.getDocument(completion: { (document, error) in
            if let document = document, document.exists {
                self.tags = document.data()!["Tags"] as! [[String : Any]]
                self.tag = self.tags[0]
                self.tagsPickerView.reloadAllComponents()
            } else {
                print("Document does not exist")
            }
        })
        
        videoRef.whereField("Popularity", isGreaterThanOrEqualTo: 10)/*.limit(to: 10)*/.getDocuments(completion: { (querySnapshot, error) in
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
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return tags.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return tags[row]["Name"] as? String
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        tag = tags[row]
    }
    
    func buttonsAreEnabled(enabled: Bool) {
        doneButton.isEnabled = enabled
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
        print(videos[0].documentID)
        videoRef.document(videos[0].documentID).updateData([
            "Tags Popularity.\(tag["Name"]!)": self.videos[0].data()!["Tags.\(tag["Name"]!)"] as? Int ?? 0 + popularityChange
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                self.videos.remove(at: 0)
                self.getVideo()
            }
        }
    }

    @IBAction func onDone(_ sender: UIButton) {
        nextVideo(popularityChange: 1)
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
