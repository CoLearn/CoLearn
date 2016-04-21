//
//  SearchResultsViewController.swift
//  CoLearn
//
//  Created by Rahul Krishna Vasantham on 3/30/16.
//  Copyright © 2016 CoLearn. All rights reserved.
//

import UIKit

class SearchResultsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var langType: Languages.LangType?
    var usersCanTeachTheLanguage: [ParseDBUser]?
    
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet var searchResultsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.searchResultsTableView.delegate = self
        self.searchResultsTableView.dataSource = self
        if let language = langType?.getName() {
            self.languageLabel.text = language
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if let usersCanTeachTheLanguage = usersCanTeachTheLanguage {
            return usersCanTeachTheLanguage.count
        }
        return 0
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SearchTableViewCell", forIndexPath: indexPath) as! SearchTableViewCell
        
        let userObj = self.usersCanTeachTheLanguage![indexPath.row]
        cell.nameLabel.text = userObj.fullName!
        cell.locationLabel.text = userObj.location
        // Configure the cell...

        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
