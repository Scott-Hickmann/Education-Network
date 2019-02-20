//
//  ViewController.swift
//  Education Network
//
//  Created by Scott Hickmann on 11/21/18.
//  Copyright © 2018 Scott Hickmann. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    
    /*var instruction: DocumentSnapshot!
    
    @IBOutlet weak var instructionText: UILabel!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        buttonsAreEnabled(enabled: false)
        
        lessonRef.whereField("Previous instruction", isEqualTo: "").order(by: "Popularity", descending: true).limit(to: 1).getDocuments() { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                for document in querySnapshot!.documents {
                    self.instruction = document
                    break
                }
                self.teach()
            }
        }
    }
    
    func buttonsAreEnabled(enabled: Bool) {
        yesButton.isEnabled = enabled
        noButton.isEnabled = enabled
    }
    
    func teach() {
        instructionText.text = instruction.data()!["Text"] as? String
        buttonsAreEnabled(enabled: true)
    }

    func nextInstruction() {
        if instruction.data()!["Next instruction"] as! String == "" {
            instructionText.text = "You did it!"
            return
        }
        lessonRef.document(instruction.data()!["Next instruction"] as! String).getDocument(completion: { (document, error) in
            if let document = document, document.exists {
                self.instruction = document
                self.teach()
            } else {
                print("Document does not exist")
            }
        })
    }
    
    @IBAction func onYes(_ sender: UIButton) {
        buttonsAreEnabled(enabled: false)
        lessonRef.document(instruction.documentID).updateData([
            "Popularity": self.instruction.data()!["Popularity"] as! Int + 1
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                self.nextInstruction()
            }
        }
    }
    
    @IBAction func onNo(_ sender: UIButton) {
        buttonsAreEnabled(enabled: false)
        lessonRef.whereField("Tags", arrayContains: (instruction.data()!["Tags"] as! [String]).randomElement()!).order(by: "Popularity", descending: true).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                for document in querySnapshot!.documents {
                    if document.data()["Text"] as! String != self.instruction.data()!["Text"] as! String {
                        self.instruction = document
                        break
                    }
                }
                self.teach()
                self.buttonsAreEnabled(enabled: true)
            }
        }
    }*/
}

