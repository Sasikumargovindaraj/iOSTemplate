//
//  LoginViewController.swift
//  PrologisOne_iPad
//
//  Created by Sasi on 26/03/16.
//  Copyright © 2016 Prologis. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController,NSXMLParserDelegate,GetSessionEnvironmantProtocol,GetSubItemstProtocol,GetFiltersProtocol {
    @IBOutlet weak var topNavigationBar: UINavigationBar!
    @IBOutlet weak var vwImageHolder: UIView!
    var parser:NSXMLParser!
    let getSubItems = GetSubItemsHandler()
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var txtUserName: EGFloatingTextField!
  
    @IBOutlet weak var txtPassWord: EGFloatingTextField!
    var isLogionSuccess = false
    var sessionID = ""
    var issessionOver = false
    var isInitialDashBoard = false
    var isPortalOver = false
    
    var pathsArray:NSMutableArray = NSMutableArray()
    var keyssArray:NSMutableArray = NSMutableArray()
    var mainFilterArray:NSMutableArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /*
        var titleImg : UIImageView
        titleImg = UIImageView(frame:CGRectMake(0, 0, 172, 36));
        titleImg.image = UIImage(named: "Prologies_title")
        topNavigationBar.topItem?.titleView = titleImg
        baseView.layer.borderWidth = 0.0;
        baseView.layer.borderColor = UIColor.whiteColor().CGColor
        baseView.backgroundColor = UIColor(red: 85.0, green: 121.0, blue: 103.0, alpha: 0.5)
        txtUserName.backgroundColor = UIColor.clearColor()
        txtPassWord.backgroundColor = UIColor.clearColor()
        txtUserName.floatingLabel = true
        txtUserName.setPlaceHolder("")
        txtPassWord.floatingLabel = true
        txtPassWord.setPlaceHolder("")
        
        let imageViewLeftUN = UIImageView(frame: CGRectMake(10, 6, 60, 33));
        let imageLeftUN = UIImage(named: "mailImage.png");
        imageViewLeftUN.contentMode = .ScaleAspectFit
        imageViewLeftUN.image = imageLeftUN;
//        txtUserName.leftView = imageViewLeftUN;
        txtUserName.leftViewMode = UITextFieldViewMode.Always
        
        let imageViewLeftPWD = UIImageView(frame: CGRectMake(10, 6, 60, 33));
        imageViewLeftPWD.contentMode = .ScaleAspectFit
        let imageLeftPWD = UIImage(named: "lock.png");
        imageViewLeftPWD.image = imageLeftPWD;
//        txtPassWord.leftView = imageViewLeftPWD;
        txtPassWord.leftViewMode = UITextFieldViewMode.Always
        // Do any additional setup after loading the view.
*/
        let maskLayer = CAShapeLayer()
        maskLayer.path = UIBezierPath(roundedRect: vwImageHolder!.bounds, byRoundingCorners: UIRectCorner.TopLeft.union(.TopRight), cornerRadii: CGSizeMake(10, 10)).CGPath
        vwImageHolder!.layer.mask = maskLayer
    }
    override func viewWillAppear(animated: Bool) {
        /*
        if UserDetails.sharedInstance.userName.characters.count > 0 && UserDetails.sharedInstance.passWord.characters.count > 0 && UserDetails.sharedInstance.baseURL.characters.count > 0 && UserDetails.sharedInstance.portNumber.characters.count > 0 {
            txtUserName.text = UserDetails.sharedInstance.userName
            txtPassWord.text = UserDetails.sharedInstance.passWord
            getAllAccessLevels()

        }else{
            // show error
        }
        
       */
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func btnLoginPressed(sender: AnyObject) {
        //getAllAccessLevels()
        let storyBoard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let viewController = storyBoard.instantiateViewControllerWithIdentifier("ViewController") as! ViewController
        viewController.keyArray = self.keyssArray
        viewController.pathArray = self.pathsArray
        let navigationController = UINavigationController(rootViewController: viewController)
        self.presentViewController(navigationController, animated: true, completion: {})
    }

    func getAllAccessLevels()
    {
        isLogionSuccess = false
        
        let andBaseURL = "\(UserDetails.sharedInstance.baseURL):\(UserDetails.sharedInstance.portNumber)/analytics/saw.dll?SoapImpl=nQSessionService"
        let url = "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:v7=\"urn://oracle.bi.webservices/v7\"><soapenv:Header/><soapenv:Body><v7:logon><v7:name>\(txtUserName.text!)</v7:name><v7:password>\(txtPassWord.text!)</v7:password></v7:logon></soapenv:Body></soapenv:Envelope>"
        
        print(url)
        let is_SoapMessage: String = url
        
        let lobj_Request = NSMutableURLRequest(URL: NSURL(string: andBaseURL)!)
        let session = NSURLSession.sharedSession()

        lobj_Request.HTTPMethod = "POST"
        lobj_Request.HTTPBody = is_SoapMessage.dataUsingEncoding(NSUTF8StringEncoding)
        lobj_Request.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        lobj_Request.addValue("288", forHTTPHeaderField: "Content-Length")
        //        lobj_Request.addValue("#logon", forHTTPHeaderField: "action")
        let task = session.dataTaskWithRequest(lobj_Request, completionHandler: {data, response, error -> Void in
            
            if error != nil
            {
                
                
            }else{
                let strData = NSString(data: data!, encoding: NSUTF8StringEncoding)
                print("Body: \(strData!)")
                print("Response: \(response)")
                self.parser = NSXMLParser(data: data!)
                self.parser.delegate = self
                self.parser.parse()
                
            }
            
        })
        task.resume()
    }
    
    
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String])
    {
        print("element name:   \(elementName)")
            if (elementName as NSString).isEqualToString("sawsoap:sessionID"){
                isLogionSuccess = true
            }else if (elementName as NSString).isEqualToString("accessLevels"){
                
            
            }else if (elementName as NSString).isEqualToString("faultcode"){
                dispatch_async(dispatch_get_main_queue(), {
                    let alert = UIAlertController(title: "Message", message: "Door Access Denied. Please check", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                })
            }


    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?){
        print("End \(elementName)")
         if (elementName as NSString).isEqualToString("sawsoap:sessionID"){
             isLogionSuccess = false
        }
    }
    
    
    func parser(parser: NSXMLParser, foundCharacters string: String){
        print(string)
            if isLogionSuccess {
                sessionID = string
                UserDetails.sharedInstance.sessionID = string
            }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "GoToHomePage" {
            
        }
    }

    
    func parser(parser: NSXMLParser, foundAttributeDeclarationWithName attributeName: String, forElement elementName: String, type: String?, defaultValue: String?){
        
    }

    func parserDidEndDocument(parser: NSXMLParser){
        if   sessionID.characters.count > 0{
            //                    getSUbItems(sharedPath: "")
            //                    currentWebservice = 2
            //                    getSessionEnvironment()
            let sessionHnader = GetSessionEnvironmentHandler()
            sessionHnader.delegate = self
            sessionHnader.getSessionEnvironment(sessionID: sessionID)
            
        }else{
            dispatch_async(dispatch_get_main_queue(), {
                let alert = UIAlertController(title: "Message", message: "No session found. Please login again", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            })
        }
    }
    
    func foundPaths(paths paths:NSMutableArray){
        for path in paths{
            if path.lowercaseString.rangeOfString("dash") != nil {
                issessionOver = true
                getSubItems.delegate = self
                getSubItems.getSUbItems(sharedPath:path as! String, sessionID: self.sessionID)
            }
            print(path)
        }
       
        
    }
    
    func subItemsfoundPaths(paths paths:NSMutableArray){
        if issessionOver && isInitialDashBoard && isPortalOver{
            for path in paths{
                let newItem = path as! ItemInfo
                if newItem.type.lowercaseString != "folder" && newItem.attribute.lowercaseString == "0"{
                    pathsArray .addObject(newItem.path)
                    keyssArray.addObject(newItem.caption)
                }
                
                print(newItem.path)
            }
            
            if pathsArray.count > 0 && keyssArray.count > 0{
                dispatch_async(dispatch_get_main_queue(), {
                    let storyBoard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
                    let viewController = storyBoard.instantiateViewControllerWithIdentifier("ViewController") as! ViewController
                    viewController.keyArray = self.keyssArray
                    viewController.pathArray = self.pathsArray
                    let navigationController = UINavigationController(rootViewController: viewController)
                    self.presentViewController(navigationController, animated: true, completion: {})
                })
            }

            
            
        }else if issessionOver && isInitialDashBoard{
            for itemInfor in paths {
                let newItem = itemInfor as! ItemInfo
                if newItem.path.lowercaseString.rangeOfString("operat") != nil {
                    isPortalOver = true
                    getSubItems.delegate = self
                    getSubItems.getSUbItems(sharedPath: newItem.path , sessionID: self.sessionID)
                    break
                }
                print(newItem.path)
            }
        }else if issessionOver {
            for itemInfo in paths{
                let newItem = itemInfo as! ItemInfo

                if newItem.path.lowercaseString.rangeOfString("portal") != nil {
                    isInitialDashBoard = true
                    getSubItems.delegate = self
                    getSubItems.getSUbItems(sharedPath: newItem.path, sessionID: self.sessionID)
                    break
                }
                
                if newItem.path.lowercaseString.rangeOfString("filter") != nil {
                    let getFilterItems = GetFiltersHandler()
                    getFilterItems.delegate = self
                    getFilterItems.getSUbItems(sharedPath: newItem.path, sessionID: self.sessionID)
                }
                print(newItem.path)
            }
        }

    }
    
    func filterItemsfoundPaths(paths paths:NSMutableArray){
        for path in paths{
            let newItem = path as! ItemInfo
            if newItem.type.lowercaseString != "folder" && newItem.attribute.lowercaseString == "0"{
                mainFilterArray.addObject(newItem.path)
            }
            print(newItem.path)
        }
    }
}




