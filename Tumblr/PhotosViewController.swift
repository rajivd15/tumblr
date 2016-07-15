//
//  ViewController.swift
//  Tumblr
//
//  Created by Rajiv Deshmukh on 7/14/16.
//  Copyright © 2016 Rajiv Deshmukh. All rights reserved.
//

import UIKit
import AFNetworking

class PhotosViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var posts: [NSDictionary]! = [NSDictionary]()
    var photos: [NSDictionary]! = [NSDictionary]()

    override func viewWillAppear(animated: Bool) {
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 150

        // Do any additional setup after loading the view, typically from a nib.
        let clientId = "Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV"
        let url = NSURL(string:"https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=\(clientId)")
        let request = NSURLRequest(URL: url!)
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate:nil,
            delegateQueue:NSOperationQueue.mainQueue()
        )

        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,
                                                                      completionHandler: { (dataOrNil, response, error) in
                                                                        if let data = dataOrNil {
                                                                            if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                                                                                data, options:[]) as? NSDictionary {
                                                                                //NSLog("response: \(responseDictionary)")
                                                                                if let resp =  responseDictionary["response"] as? NSDictionary {
                                                                                    // NSLog("resp:\(resp)")
                                                                                    if let temp = resp["posts"] as? [NSDictionary] {
                                                                                        self.posts = temp;
                                                                                        self.tableView.reloadData()
                                                                                        // NSLog("posts:\(self.posts)")
                                                                                    }
                                                                                    
                                                                                }
                                                                            }
                                                                        }
                                                                        
                                                                        
                                                                        
        });
        task.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("DemoPrototypeCell", forIndexPath: indexPath) as! DemoPrototypeCell
        
        cell.myLabel.text = posts[indexPath.row]["summary"] as? String
        
        photos = posts[indexPath.row]["photos"] as? [NSDictionary]
        
        let fetchedVal = photos[0]["alt_sizes"]![2] as? NSDictionary
        let urlString = fetchedVal!["url"] as? String
        let url = NSURL(string: urlString!)!
        
        cell.myImage.setImageWithURL(url)
        
//        let url = NSURL(string: "https://65.media.tumblr.com/3aacabb6d75827114f0192221ecfd0cb/tumblr_oabv07PJdN1qggwnvo1_75sq.jpg")!
        
        return cell
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }

}

