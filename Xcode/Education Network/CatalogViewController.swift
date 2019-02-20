//
//  CatalogViewController.swift
//  Education Network
//
//  Created by Scott Hickmann on 12/20/18.
//  Copyright © 2018 Scott Hickmann. All rights reserved.
//

import UIKit
import Firebase

class CatalogViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var catalogItems: [String]! = []
    var ref = db.collection("Courses")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        getCatalogItems()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return catalogItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Catalog Table View Cell", for: indexPath) as! CatalogTableViewCell
        let cellBackgroundView = UIView()
        cellBackgroundView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.1)
        cell.selectedBackgroundView = cellBackgroundView
        
        cell.catalogItemLabel.text = catalogItems[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        ref = ref.document(catalogItems[indexPath.row]).collection("Content")
        getCatalogItems()
    }
    
    func getCatalogItems() {
        ref.order(by: "Id").getDocuments(completion: { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                for document in querySnapshot!.documents {
                    if document.data()["Type"] as! String == "Video" {
                        categoryRef = self.ref.parent!.parent.parent!
                        lessonRef = self.ref.parent!
                        self.ref = self.ref.parent!.parent
                        self.performSegue(withIdentifier: "Catalog to Lesson", sender: self)
                        return
                    } else {
                        break
                    }
                }
                self.catalogItems = []
                for document in querySnapshot!.documents {
                    self.catalogItems.append(document.documentID)
                }
                self.tableView.reloadData()
            }
        })
    }
    
    @IBAction func onBackButton(_ sender: UIButton) {
        ref = (ref.parent?.parent) ?? ref
        getCatalogItems()
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
