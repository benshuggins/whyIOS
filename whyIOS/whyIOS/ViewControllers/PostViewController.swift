//
//  PostViewController.swift
//  whyIOS
//
//  Created by Ben Huggins on 2/6/19.
//  Copyright © 2019 User. All rights reserved.
//

import UIKit

class PostViewController: UITableViewController {

    var fetchedPosts: [Post] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refresh()

    }

    func refresh () {
        PostController.fetchPosts { (posts) in
            guard let posts = posts else {return}
            self.fetchedPosts = posts
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        }
    }

    @IBAction func refreshButtonTapped(_ sender: Any) {
        refresh()
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        let newPostAlertController = UIAlertController(title: "Why learn ios?", message: nil, preferredStyle: .alert)
        
        var usernameTextField = UITextField()
        usernameTextField.placeholder = "name"
        newPostAlertController.addTextField { (username) in
            usernameTextField = username
        }
        var reasonTextField = UITextField()
        reasonTextField.placeholder = "reason"
        newPostAlertController.addTextField { (reason) in
            reasonTextField = reason
        }
        var cohortTextField = UITextField()
        cohortTextField.placeholder = "cohort"
        newPostAlertController.addTextField { (cohort) in
            cohortTextField = cohort
        }

        let postAction = UIAlertAction(title: "Add Reason", style: .default) { (postAction) in
            guard let username = usernameTextField.text, !username.isEmpty,
                let text = reasonTextField.text, !text.isEmpty, let cohort = cohortTextField.text, !cohort.isEmpty else {
                    return
            }
            
            PostController.postReason(name: username, reason: text, cohort: cohort, completion: { (success) in
                if success {
                    self.refresh()}
            })
            }
        
        newPostAlertController.addAction(postAction)
        
         self.present(newPostAlertController, animated: true, completion: nil)
    }
    
   

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
         return fetchedPosts.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       guard let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as? PostTableViewCell else {return UITableViewCell()}
 
        let post = fetchedPosts[indexPath.row]
        cell.nameLabel.text = post.name
        cell.reasonLabel.text = post.reason
        cell.cohortLabel.text = post.cohort
    
        return cell
    }
    
}
