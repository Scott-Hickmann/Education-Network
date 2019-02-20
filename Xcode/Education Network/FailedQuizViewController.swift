//
//  FailedQuizViewController.swift
//  Education Network
//
//  Created by Scott Hickmann on 1/1/19.
//  Copyright © 2019 Scott Hickmann. All rights reserved.
//

import UIKit

class FailedQuizViewController: UIViewController {

    @IBOutlet weak var scoreLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        scoreLabel.text = "\(score.clean)%"
    }
    
    @IBAction func onRetryQuiz(_ sender: UIButton) {
        print("Retry quiz!")
        //navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onStudyAgain(_ sender: UIButton) {
        print("Study again!")
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
