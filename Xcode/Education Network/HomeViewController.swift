//
//  HomeViewController.swift
//  Education Network
//
//  Created by Scott Hickmann on 12/16/18.
//  Copyright © 2018 Scott Hickmann. All rights reserved.
//

import UIKit
import SideMenuSwift

var ITSCategoryRef = db.collection("Courses").document("Math").collection("Content").document("2nd grade").collection("Content").document("Addition and subtraction within 100")
var ITSLessonRef = categoryRef.collection("Content").document("Repeated addition")

var gradeRef = db.collection("Courses").document("Math").collection("Content").document("2nd grade")
var categoryRef = gradeRef.collection("Content").document("Addition and subtraction within 100")
var lessonRef = categoryRef.collection("Content").document("Repeated addition")
var userRef = db.collection("Users").document("scott_hickmann")
var categories: [String] = []
var categoryNumber = 0

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var profilePictureView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    var menuItems = ["Home", "ITS", "Courses Catalog", "Settings"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        profileImageView.layer.borderWidth = 10
        profileImageView.layer.masksToBounds = false
        profileImageView.layer.borderColor = UIColor.clear.cgColor
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
        profileImageView.clipsToBounds = true
        
        profilePictureView.layer.borderWidth = profileImageView.layer.borderWidth
        profilePictureView.layer.masksToBounds = false
        profilePictureView.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.1)
        
        profilePictureView.layer.cornerRadius = profilePictureView.frame.height / 2
    }
    
    override func viewWillAppear(_ animated: Bool) {
        SideMenuController.preferences.basic.enablePanGesture = false
        
        let selectedMenuItemIndexPath = IndexPath(row: selectedMenuItem, section: 0)
        tableView.selectRow(at: selectedMenuItemIndexPath, animated: false, scrollPosition: UITableView.ScrollPosition.none)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        SideMenuController.preferences.basic.enablePanGesture = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Menu Table View Cell", for: indexPath) as! MenuTableViewCell
        let cellBackgroundView = UIView()
        cellBackgroundView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.1)
        cell.selectedBackgroundView = cellBackgroundView
        
        if indexPath.row == 0 {
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: UITableView.ScrollPosition.none)
        }
        
        cell.menuItemLabel.text = menuItems[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        selectedMenuItem = indexPath.row
        sideMenuController?.setContentViewController(with: "\(indexPath.row)")
        sideMenuController?.hideMenu()
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

