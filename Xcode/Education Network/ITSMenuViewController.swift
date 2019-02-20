//
//  ITSMenuViewController.swift
//  Education Network
//
//  Created by Scott Hickmann on 12/21/18.
//  Copyright © 2018 Scott Hickmann. All rights reserved.
//

import UIKit

class ITSMenuViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        categoryRef = ITSCategoryRef
        lessonRef = ITSLessonRef
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if dismissQuiz {
            dismissQuiz = false
            performSegue(withIdentifier: "ITS Menu to ITS", sender: self)
        }
    }
    
    @IBAction func onMenuBarButtonItem(_ sender: Any) {
        if sideMenuController!.isMenuRevealed {
            sideMenuController?.hideMenu()
        } else {
            sideMenuController?.revealMenu()
        }
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
