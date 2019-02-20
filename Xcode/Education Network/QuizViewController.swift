//
//  QuizViewController.swift
//  Education Network
//
//  Created by Scott Hickmann on 12/21/18.
//  Copyright © 2018 Scott Hickmann. All rights reserved.
//

import UIKit
import Firebase

var score: Float!
var dismissQuiz = false

extension Float {
    var clean: String {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}

class QuizViewController: UIViewController {

    @IBOutlet weak var feedbackView: UIView!
    @IBOutlet weak var quizProgressView: UIProgressView!
    @IBOutlet weak var questionLabel: UILabel!
    
    var questions: [QueryDocumentSnapshot]!
    
    var questionNumber: Int!
    var correctAnswers: Int!
    
    var options: [String] = []
    
    override func viewWillAppear(_ animated: Bool) {
        options = ["A", "B", "C", "D"].shuffled()
        if dismissQuiz {
            navigationController?.popViewController(animated: false)
        }
        
        score = 0
        questions = []
        questionNumber = 0
        correctAnswers = 0
        
        categoryRef.collection("Quiz").getDocuments(completion: { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                for document in querySnapshot!.documents {
                    self.questions.append(document)
                }
                userRef.collection("Quiz").document(categoryRef.documentID).setData([
                    "Time": FieldValue.serverTimestamp()
                ]) { err in
                    if let err = err {
                        print("Error creating document: \(err)")
                    } else {
                        self.nextQuestion()
                    }
                }
            }
        })
    }
    
    func nextQuestion() {
        quizProgressView.progress = Float(questionNumber) / Float(questions.count)
        if questionNumber == questions.count {
            score = Float(correctAnswers) / Float(questions.count) * 100
            if score > 75 {
                print("You passed this quiz!")
                performSegue(withIdentifier: "Quiz to Passed Quiz", sender: self)
            } else {
                print("You failed this quiz.")
                
                performSegue(withIdentifier: "Quiz to Failed Quiz", sender: self)
            }
            return
        }
        options = ["Option 1", "Option 2", "Option 3", "Option 4"].shuffled()
        questionLabel.text = "\(questions[questionNumber].data()["Question"]!)\n\nA: \(questions[questionNumber].data()[options[0]]!)\nB: \(questions[questionNumber].data()[options[1]]!)\nC: \(questions[questionNumber].data()[options[2]]!)\nD: \(questions[questionNumber].data()[options[3]]!)"
    }

    func storeQuestionResult(correct: Bool) {
        userRef.collection("Quiz").document(categoryRef.documentID).updateData([
            String(self.questionNumber): correct
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                self.questionNumber += 1
                self.nextQuestion()
            }
        }
    }
    
    func checkIfCorrect(optionNumber: Int) {
        if options[optionNumber] == questions[questionNumber].data()["Answer"] as! String {
            UIView.animate(withDuration: 1, animations: {
                self.feedbackView.backgroundColor = #colorLiteral(red: 0.5175517201, green: 0.717028439, blue: 0.2291049361, alpha: 0.5)
                self.feedbackView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
            }, completion: {(finished: Bool) in
                self.correctAnswers += 1
                self.storeQuestionResult(correct: true)
            })
        } else {
            UIView.animate(withDuration: 1, animations: {
                self.feedbackView.backgroundColor = #colorLiteral(red: 0.8509803922, green: 0.2292038202, blue: 0.1465344131, alpha: 0.5)
                self.feedbackView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
            }, completion: {(finished: Bool) in
                self.storeQuestionResult(correct: false)
            })
        }
    }
    
    @IBAction func onA(_ sender: UIButton) {
        checkIfCorrect(optionNumber: 0)
    }
    
    @IBAction func onB(_ sender: UIButton) {
        checkIfCorrect(optionNumber: 1)
    }
    
    @IBAction func onC(_ sender: UIButton) {
        checkIfCorrect(optionNumber: 2)
    }
    
    @IBAction func onD(_ sender: UIButton) {
        checkIfCorrect(optionNumber: 3)
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
