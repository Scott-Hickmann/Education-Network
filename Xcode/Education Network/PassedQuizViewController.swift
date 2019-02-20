//
//  PassedQuizViewController.swift
//  Education Network
//
//  Created by Scott Hickmann on 1/1/19.
//  Copyright © 2019 Scott Hickmann. All rights reserved.
//

import UIKit
import Firebase

class PassedQuizViewController: UIViewController {

    @IBOutlet weak var scoreLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        scoreLabel.text = "\(score.clean)%"
    }
    
    @IBAction func onRetakeQuiz(_ sender: UIButton) {
        print("Redo quiz!")
        //navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onNextCategory(_ sender: UIButton) {
        print("Study again!")
        categoryNumber += 1
        categoryRef = gradeRef.collection("Content").document(categories[categoryNumber])
        dismissQuiz = true
        dismiss(animated: false, completion: nil)
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
