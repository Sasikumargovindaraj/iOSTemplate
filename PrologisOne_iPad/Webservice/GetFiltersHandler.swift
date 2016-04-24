//
//  GetSubItemsHandler.swift
//  PrologisOne_iPad
//
//  Created by Sasi on 06/04/16.
//  Copyright © 2016 Prologis. All rights reserved.
//

import UIKit
@objc protocol GetFiltersProtocol{
    optional func filterItemsfailedWItherror(error error:NSError)
    optional func filterItemsfoundPaths(paths paths:NSMutableArray)
}
class GetFiltersHandler: NSObject,NSXMLParserDelegate {
    var parser:NSXMLParser!
    var delegate:GetFiltersProtocol?
    var itemInfo: ItemInfo?
    var isLogionSuccess = false
    var isSessionFound = false
    var isElementFound = false
    
    var isPathFound = false
    var isfoundFolder = false
    var isfoundAttribute = false
    var isKeyFound = false
    var foundPath = ""
    var foundKey = ""
    var foundedFolder = ""
    var foundedAttributes = ""
    var pathsArray:NSMutableArray = NSMutableArray()
    var keyssArray:NSMutableArray = NSMutableArray()
    func getSUbItems(sharedPath path:String, sessionID:String)
    {
        pathsArray.removeAllObjects()
        keyssArray.removeAllObjects()
        //        path = "/shared/01 Real Estate Dashboards/_portal/1.1 Operations"
        
        let andBaseURL = "\(UserDetails.sharedInstance.baseURL):\(UserDetails.sharedInstance.portNumber)/analytics/saw.dll?SoapImpl=webCatalogService"
        let url = "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:v7=\"urn://oracle.bi.webservices/v7\"><soapenv:Header/><soapenv:Body><v7:getSubItems><v7:path>\(path)</v7:path><v7:mask></v7:mask><v7:resolveLinks></v7:resolveLinks><v7:sessionID>\(sessionID)</v7:sessionID></v7:getSubItems></soapenv:Body></soapenv:Envelope>"
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
    }
    
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String])
    {
        print("element name:   \(elementName)")
        if (elementName as NSString).isEqualToString("sawsoap:itemInfo"){
            isElementFound = true
            itemInfo = ItemInfo()
        }else if (elementName as NSString).isEqualToString("sawsoap:path"){
            isPathFound = true
        }else if (elementName as NSString).isEqualToString("sawsoap:caption"){
            isKeyFound = true
        }else if (elementName as NSString).isEqualToString("sawsoap:attributes"){
            isfoundAttribute = true
        }else if (elementName as NSString).isEqualToString("sawsoap:type"){
            isfoundFolder = true
        }else if (elementName as NSString).isEqualToString("faultcode"){
            dispatch_async(dispatch_get_main_queue(), {
                let alert = UIAlertController(title: "Message", message: "Door Access Denied. Please check", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                //                    self.presentViewController(alert, animated: true, completion: nil)
            })
        }
        
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?){
        print("End \(elementName)")
        if (elementName as NSString).isEqualToString("sawsoap:itemInfo"){
            isElementFound = false
            pathsArray .addObject(itemInfo!)
            itemInfo = nil
        }else if (elementName as NSString).isEqualToString("sawsoap:path"){
            isPathFound = false
        }else if (elementName as NSString).isEqualToString("sawsoap:caption"){
            isKeyFound = false
        }else if (elementName as NSString).isEqualToString("sawsoap:attributes"){
            isfoundAttribute = false
        }else if (elementName as NSString).isEqualToString("sawsoap:type"){
            isfoundFolder = false
        }
    }
    
    
    func parser(parser: NSXMLParser, foundCharacters string: String){
        print(string)
        if isElementFound{
            if isPathFound{
                itemInfo?.path = string
                isPathFound = false
            }else if isKeyFound{
                itemInfo?.caption = string
                isKeyFound = false
            }else if isfoundAttribute{
                itemInfo?.attribute = string
                foundedAttributes = string
                isfoundAttribute = false
            }else if isfoundFolder{
                itemInfo?.type = string
                foundedFolder = string
                isfoundFolder = false
            }
        }
        
        
    }
    
    
    
    func parser(parser: NSXMLParser, foundAttributeDeclarationWithName attributeName: String, forElement elementName: String, type: String?, defaultValue: String?){
        
    }
    
    func parserDidEndDocument(parser: NSXMLParser){
        self.delegate?.filterItemsfoundPaths!(paths: pathsArray)
    }
}
