//
//  ReportViewController.swift
//  PrologisOne_iPad
//
//  Created by Sasi on 24/03/16.
//  Copyright © 2016 Prologis. All rights reserved.
//

import UIKit

class ReportViewController: UIViewController,UIWebViewDelegate,CustomPopOverProtocol,NSXMLParserDelegate {
    var isLoadedCompletely = false
    var pathArray:NSMutableArray?
    var keyArray:NSMutableArray?
    var selectedIndex = -1
    var parser:NSXMLParser!

    @IBOutlet weak var webView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()

        let btnExport = UIButton()
        btnExport.setImage(UIImage(named: "Export"), forState: .Normal)
        btnExport.frame = CGRectMake(0, 0, 45, 32)
        btnExport.addTarget(self, action: Selector("didExportTap:"), forControlEvents: .TouchUpInside)
        let barBtnExport = UIBarButtonItem()
        barBtnExport.customView = btnExport
        
        let btnFilter = UIButton()
        btnFilter.setImage(UIImage(named: "Filter"), forState: .Normal)
        btnFilter.frame = CGRectMake(0, 0, 45, 39)
        btnFilter.addTarget(self, action: Selector("didFilterTap:"), forControlEvents: .TouchUpInside)
        let barBtnFilter = UIBarButtonItem()
        barBtnFilter.customView = btnFilter
        
        let btnFavourite = UIButton()
        btnFavourite.setImage(UIImage(named: "Saved_Filter"), forState: .Normal)
        btnFavourite.frame = CGRectMake(0, 0, 45, 31)
        btnFavourite.addTarget(self, action: Selector("didFavouriteTap:"), forControlEvents: .TouchUpInside)
        let barBtnFavourite = UIBarButtonItem()
        barBtnFavourite.customView = btnFavourite
        
        
        let backButton = UIButton()
        backButton.tintColor = UIColor.redColor()
        backButton.setTitle("Home", forState: .Normal)
        backButton.titleLabel?.textColor =  self.hexToColor("00A389")
        backButton.setTitleColor(self.hexToColor("00A389"), forState: .Normal)
//        backButton.setImage(UIImage(named: "Home"), forState: .Normal)
        backButton.frame = CGRectMake(0, 0, 70, 45)
        backButton.addTarget(self, action: Selector("didBackTap:"), forControlEvents: .TouchUpInside)
        let backBarButtonItem = UIBarButtonItem()
        backBarButtonItem.customView = backButton
        backBarButtonItem.customView?.tintColor = UIColor.orangeColor()
        backButton.contentMode = .ScaleAspectFit
        
        let menuButton = UIButton()
        menuButton.tintColor = UIColor.redColor()
        menuButton.setImage(UIImage(named:"nav_retina"), forState: .Normal)
        menuButton.frame = CGRectMake(0, 0, 45, 45)
        menuButton.addTarget(self, action: Selector("didMenuTap:"), forControlEvents: .TouchUpInside)
        let menuBarButtonItem = UIBarButtonItem()
        menuBarButtonItem.customView = menuButton
        menuBarButtonItem.customView?.tintColor = UIColor.orangeColor()
        menuButton.contentMode = .ScaleAspectFit
        
        self.navigationItem.rightBarButtonItems = [barBtnExport,barBtnFilter,barBtnFavourite]
        self.navigationItem.leftBarButtonItems = [backBarButtonItem, menuBarButtonItem]
        
      //  self.navigationController?.hidesBarsOnTap = true
        
//        let pagePath:String = keyArray?.objectAtIndex(selectedIndex) as! String
//        self.navigationController?.title = pagePath
    }
    
    
    override func viewDidAppear(animated: Bool) {
  //     self.loadWebView()
    }
//    for (index,value)  in enumerate(numbers)
//    {
//    println("Index \(index): value  \(value)")
//    }
    func hexToColor(hexString:String) -> UIColor {
        let r, g, b: CGFloat
        
 
            let start = hexString.startIndex.advancedBy(1)
            let hexColor = hexString.substringFromIndex(start)
            
//            if hexColor.characters.count == 8 {
                let scanner = NSScanner(string: hexColor)
                var hexNumber: UInt64 = 0
                
                if scanner.scanHexLongLong(&hexNumber) {
                    r = CGFloat((hexNumber & 0xFF0000) >> 16) / 255
                    g = CGFloat((hexNumber & 0x00ff00) >> 8) / 255
                    b = CGFloat(hexNumber & 0x0000ff) / 255
                     
                  return  UIColor(red: r, green: g, blue: b, alpha: 1)
               // }
 
        }
    return UIColor.whiteColor()
    }

    func loadWebView(){
        var portalPath:String = pathArray?.objectAtIndex(selectedIndex) as! String
        let pagePath:String = keyArray?.objectAtIndex(selectedIndex) as! String
        var arraySharedpath:Array = portalPath.characters.split{ $0 == "/" }.map(String.init)
        arraySharedpath.removeLast()
        portalPath = arraySharedpath.joinWithSeparator("/")
        print(portalPath)
        let url : NSString = "\(UserDetails.sharedInstance.baseURL):\(UserDetails.sharedInstance.portNumber)/analytics/saw.dll?dashboard&PortalPath=/\(portalPath)&Page=\(pagePath)"
        webView.delegate = self
        webView.hidden = true
        let urlwithPercentEscapes = url.stringByAddingPercentEncodingWithAllowedCharacters( NSCharacterSet.URLQueryAllowedCharacterSet())
        let webURL : NSURL = NSURL(string: urlwithPercentEscapes! as String)!
        webView.loadRequest(NSURLRequest(URL: webURL))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func webViewDidStartLoad(webView: UIWebView) {
        print("webViewDidStartLoad")
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        print("webViewDidFinishLoad")
        webView.stringByEvaluatingJavaScriptFromString("document.getElementsByClassName('PageTable')[0].style.display='none'")
        if isLoadedCompletely{
            webView.hidden = false
        }
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        print("didFailLoadWithError")
        
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        print(request.URL)
        webView.sizeThatFits(self.webView.frame.size)
        let url = request.URL?.absoluteString
         webView.stringByEvaluatingJavaScriptFromString("document.getElementsByClassName('PageTable')[0].style.display='none'")
        if url?.rangeOfString("analytics/res/empty.htm") != nil{
            print("succees")
           isLoadedCompletely = true
        }
        return true
    }
    
    func didExportTap(sender:UIButton) {
        
    }
    func getSUbItems()
    {
        if UserDetails.sharedInstance.sessionID.characters.count > 0{
            let andBaseURL = "\(UserDetails.sharedInstance.baseURL):\(UserDetails.sharedInstance.portNumber)/analytics/saw.dll?SoapImpl=webCatalogService"
            let url = "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:v7=\"urn://oracle.bi.webservices/v7\"><soapenv:Header/><soapenv:Body><v7:getSubItems><v7:path>/shared/01 Real Estate Dashboards/_portal/1.1 Operations</v7:path><v7:mask></v7:mask><v7:resolveLinks></v7:resolveLinks><v7:sessionID>\(UserDetails.sharedInstance.sessionID)</v7:sessionID></v7:getSubItems></soapenv:Body></soapenv:Envelope>"
            print(url)
            let is_SoapMessage: String = url
            //            /shared/01 Real Estate Dashboards/_portal/1.1 Operations
            //            /shared/02 Real Estate Reports/Operations/Reports
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
        }else{
            dispatch_async(dispatch_get_main_queue(), {
                let alert = UIAlertController(title: "Message", message: "No session found. Please login again", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            })
        }
        
    }
    func didMenuTap(sender:UIButton) {
        
    }
    
    func didBackTap(sender:UIButton) {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }

    
    func didFilterTap(sender:UIButton) {
        
        let model = FilterModel()
        model.title = "From Date";
        model.placeHolder = "Enter From Date";
        model.isDateField = true;
        
        let model1 = FilterModel()
        model1.title = "To Date";
        model1.placeHolder = "Enter To Date";
        model1.isDateField = true;
        
        let model2 = FilterModel()
        model2.title = "Currency";
        model2.placeHolder = "USD";
        
        let model3 = FilterModel()
        model3.title = "Division";
        model3.placeHolder = "Enter Division";
        
        let model4 = FilterModel()
        model4.title = "Region";
        model4.placeHolder = "Enter Region";
        
        let arrTemp:[FilterModel] = [model,model1,model2,model3,model4];
        let filter = FilterViewController()
        filter.arrData = arrTemp;
//        filter.modalPresentationStyle = UIModalPresentationStyle.Popover
//        filter.popoverPresentationController?.sourceView = self.view
        filter.preferredContentSize = CGSizeMake(400,550);
//        filter.popoverPresentationController!.sourceRect = sender.frame;
        filter.modalPresentationStyle = UIModalPresentationStyle.FormSheet
        self .presentViewController(filter, animated: true, completion: nil)
        
        

    }
 

    func didFavouriteTap(sender:UIButton) {
        let arrTemp:[NSString] = ["Filter1","Filter2","Filter3","Filter4","Filter5"]
        let _popViewController = CustomPopOverViewController(size: CGSizeMake(320, 268))
        _popViewController.m_dlgPopOver = self;
                _popViewController.isCellSelectionBtnRequired = true
        _popViewController.m_arrDisplayItems = arrTemp
        _popViewController.view.backgroundColor = UIColor.blackColor()
//        let navogationCOntroller = UINavigationController(rootViewController: _popViewController)
        
        let popoverFinal = UIPopoverController(contentViewController: _popViewController)
        popoverFinal.popoverContentSize = CGSizeMake(320, 218)

        popoverFinal.backgroundColor = self.hexToColor("00A389")
        var frme:CGRect
        frme = sender.frame
        frme.origin.y += sender.frame.height
        popoverFinal.presentPopoverFromRect(frme, inView: self.view, permittedArrowDirections: .Any, animated: true)

    }

    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String])
    {
            if (elementName as NSString).isEqualToString("sawsoap:sessionID"){
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
        
        
    }
    
    
    func parser(parser: NSXMLParser, foundCharacters string: String){
        print(string)
        
    }
    

    
    func parser(parser: NSXMLParser, foundAttributeDeclarationWithName attributeName: String, forElement elementName: String, type: String?, defaultValue: String?){
        
    }
    
    func parserDidEndDocument(parser: NSXMLParser){
        dispatch_async(dispatch_get_main_queue(), {
            
        })
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
