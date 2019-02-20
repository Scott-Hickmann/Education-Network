//
//  HomeViewController.swift
//  Education Network
//
//  Created by Scott Hickmann on 12/5/18.
//  Copyright © 2018 Scott Hickmann. All rights reserved.
//

import UIKit
import SideMenuSwift

var selectedMenuItem = 0

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var profilePictureView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    var menuItems = ["Home", "ITS", "Courses Catalog", "Settings"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        SideMenuController.preferences.basic.enableRubberEffectWhenPanning = false
        SideMenuController.preferences.basic.position = .under
        
        sideMenuController?.cache(viewControllerGenerator: {
            self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController")
        }, with: "0")
        
        sideMenuController?.cache(viewControllerGenerator: {
            self.storyboard?.instantiateViewController(withIdentifier: "ITSViewController")
        }, with: "1")
        
        sideMenuController?.cache(viewControllerGenerator: {
            self.storyboard?.instantiateViewController(withIdentifier: "CatalogViewController")
        }, with: "2")
        
        profileImageView.layer.borderWidth = 5
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
        let selectedMenuItemIndexPath = IndexPath(row: selectedMenuItem, section: 0)
        tableView.selectRow(at: selectedMenuItemIndexPath, animated: false, scrollPosition: UITableView.ScrollPosition.none)
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
    
    /*func animateMenu(newConstantValue: CGFloat) {
        UIView.animate(withDuration: 0.2, animations: {
            self.menuViewConstraint.constant = newConstantValue
            self.view.layoutIfNeeded()
        })
    }
    
    @IBAction func panPerformed(_ sender: UIPanGestureRecognizer) {
        let menuViewWidth = menuViewWidthConstraint.multiplier * view.frame.width
        print(menuViewWidth)
        print(menuViewWidthConstraint.constant)
        if sender.state == .began || sender.state == .changed {
            let translation = sender.translation(in: view).x
            if translation > 0 { // Swipe right
                UIView.animate(withDuration: 0.2, animations: {
                    if self.menuViewConstraint.constant > 0 {
                        self.menuViewConstraint.constant -= translation / 10
                    } else {
                        self.menuViewConstraint.constant = 0
                    }
                    self.view.layoutIfNeeded()
                })
            } else { // Swipe left
                UIView.animate(withDuration: 0.2, animations: {
                    if self.menuViewConstraint.constant < menuViewWidth {
                        self.menuViewConstraint.constant -= translation / 10
                    } else {
                        self.menuViewConstraint.constant = menuViewWidth
                    }
                    self.view.layoutIfNeeded()
                })
            }
        } else if sender.state == .ended {
            let translation = sender.translation(in: view).x
            if translation > 0 {
                animateMenu(newConstantValue: 0)
            } else {
                animateMenu(newConstantValue: menuViewWidth)
            }
        }
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
