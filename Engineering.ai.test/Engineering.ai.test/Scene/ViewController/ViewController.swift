//
//  ViewController.swift
//  Engineering.ai.test
//
//  Created by PCQ182 on 25/12/19.
//  Copyright © 2019 PCQ182. All rights reserved.
//

import UIKit
import SVProgressHUD
import UIScrollView_InfiniteScroll

class ViewController: UIViewController {

    // MARK: - Outlets -
    @IBOutlet weak var postTbl: UITableView!
    
    // MARK: - Variable -
    private var currentPage = 0
    private var totalPage = 0
    private var post = [Post]()
    private var refreshControl = UIRefreshControl()

    // MARK: - View Life Cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        prepareView()
    }

    private func prepareView(){
        SVProgressHUD.show()
        postTbl.rowHeight = UITableView.automaticDimension
        postTbl.estimatedRowHeight = 50
        self.postTbl.tableFooterView = UIView()
        getPostListing()
        addRefreshController()
        
        postTbl.addInfiniteScroll { (tableView) -> Void in
            if self.currentPage != self.totalPage {
                self.currentPage += 1
                self.getPostListing()
            }else{
                self.postTbl.finishInfiniteScroll()
            }
        }
    }
    
    private func addRefreshController() {
        self.refreshControl.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        postTbl.addSubview(refreshControl)
    }
    
    @objc func refresh(sender:AnyObject) {
        // Code to refresh table view
        self.currentPage = 0
        self.refreshControl.beginRefreshing()
        self.getPostListing()
    }
    
    // MARK: - Get post listing -
    private func getPostListing(){
        let param = ["tags":"story","page":"\(currentPage)"]
       
        APIManager.shared.sendGenericCall(type: PostModal.self, router: .getListing(parameter: param), success: { (response) in
            SVProgressHUD.dismiss()

            self.totalPage = Int(response.nbPages) ?? 0
             self.postTbl.finishInfiniteScroll()
            
            if self.currentPage == 0 {
                self.post = response.hits
            }else{
                self.post.append(contentsOf: response.hits)
            }
            
            self.postTbl.reloadData()
        }) { (error) in
            SVProgressHUD.dismiss()
        }
    }
}

// MARK: - TableView DataSource-
extension ViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.post.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostCell
        cell.post = self.post[indexPath.row]
        cell.switchSelected = { selected in
            self.post[indexPath.row].isSelected = selected
        }
        return cell
    }
}
