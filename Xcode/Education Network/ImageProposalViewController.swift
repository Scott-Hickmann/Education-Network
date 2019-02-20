//
//  ImageProposalViewController.swift
//  Education Network
//
//  Created by Scott Hickmann on 11/24/18.
//  Copyright © 2018 Scott Hickmann. All rights reserved.
//

import UIKit
import Firebase

let imageRef = db.collection("Images").document("Math").collection("Addition")

class ImageProposalViewController: UIViewController {
    
    var imagesUrls: [DocumentSnapshot] = []
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        buttonsAreEnabled(enabled: false)
        imageView.contentMode = .scaleAspectFit
        
        imageRef/*.limit(to: 10)*/.getDocuments(completion: { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                for document in querySnapshot!.documents {
                    self.imagesUrls.append(document)
                }
                self.getImage()
            }
        })
    }
    
    func buttonsAreEnabled(enabled: Bool) {
        yesButton.isEnabled = enabled
        noButton.isEnabled = enabled
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadImage(from url: URL) {
        print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() {
                self.imageView.image = UIImage(data: data)
                self.buttonsAreEnabled(enabled: true)
            }
        }
    }
    
    func getImage() {
        if imagesUrls.count == 0 {
            return
        }
        let imageUrl = URL(string: self.imagesUrls[0].data()!["Link"] as! String)
        print(imageUrl!)
        downloadImage(from: imageUrl!)
    }
    
    func nextImage(popularityChange: Int) {
        buttonsAreEnabled(enabled: false)
        imageRef.document(imagesUrls[0].documentID).updateData([
            "Popularity": self.imagesUrls[0].data()!["Popularity"] as! Int + popularityChange
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                self.imagesUrls.remove(at: 0)
                self.getImage()
            }
        }
    }
    
    @IBAction func onYes(_ sender: UIButton) {
        nextImage(popularityChange: 1)
    }
    
    @IBAction func onNo(_ sender: UIButton) {
        nextImage(popularityChange: -1)
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
