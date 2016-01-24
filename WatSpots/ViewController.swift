//
//  ViewController.swift
//  WatSpots
//
//  Created by Aayush Shah on 2016-01-24.
//  Copyright © 2016 WatOpenedUp. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var logo: UIImageView!

    @IBOutlet var course: UITextField!
    
    @IBOutlet var catalog: UITextField!
    
    @IBOutlet var section: UITextField!

    @IBOutlet var checkLabel: UILabel!

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }
    
    func labelUpdate(s:String) {
        checkLabel.text = s
    }
    
    @IBAction func button(sender: AnyObject) {
        
        let  term = "1161"
        var  subjectId = "";
        var  catalog_number = "";
        var  wanted_section = "";
        
        subjectId = course.text!;
        catalog_number = catalog.text!;
        wanted_section = section.text!;
        var s = "LEC 00" + wanted_section;
        
        let uw_url = "https://api.uwaterloo.ca/v2/terms/"
        let uw_api_key = "/schedule.json?key=0263b6b83ac199b9600e8adca70c8a6b"
        let url = NSURL(string: uw_url + term + "/" + subjectId + "/" + catalog_number + uw_api_key)!
        
        var task = NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) -> Void in
            
            if let urlContent = data {
                
                do {
                    
                    let json = try NSJSONSerialization.JSONObjectWithData(urlContent, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                    
                    if let blogs = json["data"] as? NSArray! {
                        
                        for blog in blogs{
                            
                            let sec = blog["section"] as! String
                            let e_total = blog["enrollment_total"] as! Int
                            let e_max = blog["enrollment_capacity"] as! Int
                            
                            // s = "LEC 004"
                            if (sec == s)
                            {
                                let seats = e_max - e_total
                                if(seats>0)
                                {
                                    dispatch_async(dispatch_get_main_queue()) {
                                    self.labelUpdate( "There are \(seats) seats available for \(s)!");
                                    }
                                    
                                    let instructor_dict = blog["classes"] as! NSArray
                                    
                                    //Getting Instructor Name
                                    for items in instructor_dict{
                                        let ins = (items["instructors"]) as! NSArray
                                        
                                        if (ins[0] as! String != ""){
                                            print(ins[0]);
                                            
                                        }
                                        
                                    }
                                    
                                }else{
                                    dispatch_async(dispatch_get_main_queue()) {
                                        // update label
                                        self.labelUpdate("Sorry there are no seats available.")
                                    }
                                    
                                }
                                
                            }
                        }
                    }
                } catch {
                    print("error serializing JSON: \(error)")
                }
                
            }
            
            
        }
        
        task.resume()

        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        logo.image = UIImage(named: "uw.png");
        checkLabel.text = "";
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

