//
//  RootTableViewController.swift
//  SensorNetApp
//
//  Created by Quinton Black on 2015-03-30.
//  Copyright (c) 2015 Quinton and Brian. All rights reserved.
//

/* Title:       RootTableViewController.swift
 * Date:        March 28, 2015
 * Author:      Brian Sage and Quinton Black
 * Description: This is the view controller for the main table view screen.
 *              It goes out and gets a list of modules and their information,
 *              stores it in the storage class, and displays each module available
 *              in the table view. When you select a module, you will be segued to 
 *              that module's screen.
 */

import UIKit

class RootTableViewController: UITableViewController, UITableViewDelegate {
    
    //variables
    let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        
               
        //initialize storage
        var storage = Storage()
        
        //initialize DAL
        var dal = DataAccessLayer()
        
        //create gradient background
        //gradients: http://www.reddit.com/r/swift/comments/27mrlx/gradient_background_of_uiview_in_swift/
        let gradient : CAGradientLayer = CAGradientLayer()
        gradient.frame = view.bounds
        let cor1 = UIColor(white: 0.2, alpha: 0.98).CGColor
        let cor2 = UIColor(white: 0.5, alpha: 0.98).CGColor
        let arrayColors = [cor1, cor2]
        gradient.colors = arrayColors
        view.layer.insertSublayer(gradient, atIndex: 0)
        
        //create loader animation for when retrieving data from service
        activityIndicator.frame = self.view.bounds
        activityIndicator.autoresizingMask = .FlexibleWidth | .FlexibleHeight
        activityIndicator.startAnimating()
        self.view.addSubview( activityIndicator )
        self.tableView.reloadData()
        activityIndicator.stopAnimating()
        
        //get modules from webservice
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return Storage.modules.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //create new cell
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell
        
        //get the module for this row
        var module = Storage.modules[indexPath.row]
        
        //create nice font text for the cell
        let text = module.name
        let font = UIFont.boldSystemFontOfSize(16)
        let textColor = UIColor.whiteColor()
        let attributes = [
            NSForegroundColorAttributeName : textColor,
            NSFontAttributeName : font
        ]
        let attributedString = NSAttributedString(string: text, attributes: attributes)
        
        //set the cell to have transparent background and fancy text
        cell.backgroundColor = UIColor.clearColor()
        cell.textLabel?.attributedText = attributedString
        
        return cell
    }
    
    /*
    *  This method is used for manual segue control
    */
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let moduleInfo = Storage.modulesInfo[indexPath.row]
//        if (moduleInfo.moduleType == String(ModuleType.RGB.rawValue)){
//            self.performSegueWithIdentifier("rgb", sender:tableView.cellForRowAtIndexPath(indexPath))
//        }
//        else if(moduleInfo.moduleType == String(ModuleType.LIGHT.rawValue)){
//            self.performSegueWithIdentifier("light", sender:tableView.cellForRowAtIndexPath(indexPath))
//        }
//        else if(moduleInfo.moduleType == String(ModuleType.ENVIRONMENT.rawValue)){
//            self.performSegueWithIdentifier("environment", sender:tableView.cellForRowAtIndexPath(indexPath))
//        }
        
        //just in case we cant change the module type use the moduleId instead
        switch (moduleInfo.moduleId) {
        case "858050250518":
            self.performSegueWithIdentifier("environment", sender:tableView.cellForRowAtIndexPath(indexPath))
        case "870985681430":
            self.performSegueWithIdentifier("rgb", sender:tableView.cellForRowAtIndexPath(indexPath))
            
        case "918415594774":
            self.performSegueWithIdentifier("light", sender:tableView.cellForRowAtIndexPath(indexPath))
        default:
            var dumb = 1
        }
    }

    


    /*
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        let indexPath = tableView.indexPathForCell(sender as UITableViewCell)!
        let moduleInfo = Storage.modulesInfo[indexPath.row]
        
        if (segue.identifier == "rgb") {
            let destinationVC = segue.destinationViewController as RGBViewController;
            destinationVC.pageTitle = "RGB Light"
            destinationVC.moduleInfo = moduleInfo
        }
        else if(segue.identifier == "light") {
            let destinationVC = segue.destinationViewController as SwitchViewController;
            destinationVC.pageTitle = "Main Light"
            destinationVC.moduleInfo = moduleInfo
        }
        else if(segue.identifier == "environment") {
            let destinationVC = segue.destinationViewController as TemperatureViewController;
            destinationVC.pageTitle = "Environment"
            destinationVC.moduleInfo = moduleInfo
        }
    }
}
