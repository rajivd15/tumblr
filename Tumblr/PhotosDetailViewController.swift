//
//  PhotosDetailViewController.swift
//  Tumblr
//
//  Created by Rajiv Deshmukh on 7/15/16.
//  Copyright © 2016 Rajiv Deshmukh. All rights reserved.
//

import UIKit

class PhotosDetailViewController: UIViewController {

    var text: String!
    @IBOutlet weak var myDetailImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myDetailImage.setImageWithURL(NSURL(string : text)!)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
