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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 150

        // Initialize a UIRefreshControl
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)

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
        
        return cell
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
   
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    
        let vc = segue.destinationViewController as! PhotosDetailViewController
        let indexPath = tableView.indexPathForCell(sender as! UITableViewCell)
        
        if let temp = posts[indexPath!.row] as? NSDictionary {
            //NSLog("temp:\(temp)")
            if let photos = temp["photos"] as? [AnyObject] {
                NSLog("photos:\(photos)")
                if let p = photos[0] as? NSDictionary {
                    if let orgImg = p["original_size"] as? NSDictionary {
                        if let url = orgImg["url"] as? String {
                            vc.text = url;
                        }
                    }
                }
            }
        } else {
            NSLog("temp is null");
        }
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //Get rid of the gray selection effect by deselecting the cell with animation
        tableView.deselectRowAtIndexPath(indexPath, animated:true)
    }
    
    // Makes a network request to get updated data
    // Updates the tableView with the new data
    // Hides the RefreshControl
    func refreshControlAction(refreshControl: UIRefreshControl) {
        
        // ... Create the NSURLRequest (myRequest) ...
        let clientId = "Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV"
        let url = NSURL(string:"https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=\(clientId)")
        let myRequest = NSURLRequest(URL: url!)
        
        // Configure session so that completion handler is executed on main UI thread
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate:nil,
            delegateQueue:NSOperationQueue.mainQueue()
        )
        
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(myRequest,
                                                                      completionHandler: { (dataOrNil, response, error) in
                                                                        if let data = dataOrNil {
                                                                            if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                                                                                data, options:[]) as? NSDictionary {
                                                                                //NSLog("response: \(responseDictionary)")
                                                                                if let resp =  responseDictionary["response"] as? NSDictionary {
                                                                                    // NSLog("resp:\(resp)")
                                                                                    if let temp = resp["posts"] as? [NSDictionary] {
                                                                                        self.posts = temp;                                                                        // Reload the tableView now that there is new data
                                                                        self.tableView.reloadData()
                                                                        
                                                                        // Tell the refreshControl to stop spinning
                                                                        refreshControl.endRefreshing()
                                                                                    }
                                                                                }
                                                                            }
                                                                        }
        });
        task.resume()
    }
}

