//
//  GetSessionEnvironmentHandler.swift
//  PrologisOne_iPad
//
//  Created by Sasi on 06/04/16.
//  Copyright © 2016 Prologis. All rights reserved.
//

import UIKit
@objc protocol GetSessionEnvironmantProtocol{
   optional func failedWItherror(error error:NSError)
   optional func foundPaths(paths paths:NSMutableArray)
}
class GetSessionEnvironmentHandler: NSObject,NSXMLParserDelegate {
    var parser:NSXMLParser!
    var issharedPath = false
    var canAddKeys = false
    var pathsArray:NSMutableArray = NSMutableArray()
    var delegate:GetSessionEnvironmantProtocol?
    func getSessionEnvironment(sessionID sessionID:String)
    {
            let andBaseURL = "\(UserDetails.sharedInstance.baseURL):\(UserDetails.sharedInstance.portNumber)/analytics/saw.dll?SoapImpl=nQSessionService"
            let url = "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:v7=\"urn://oracle.bi.webservices/v7\"><soapenv:Header/><soapenv:Body><v7:getSessionEnvironment><v7:sessionID>\(sessionID)</v7:sessionID></v7:getSessionEnvironment></soapenv:Body></soapenv:Envelope>"
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
                self.delegate?.failedWItherror!(error: error!)
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
    //\(UserDetails.sharedInstance.baseURL)
    //\(UserDetails.sharedInstance.portNumber)
    
    
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String])
    {
        print("element name:   \(elementName)")
        if (elementName as NSString).isEqualToString("sawsoap:sharedDirectories"){
            issharedPath = true
        }else   if (elementName as NSString).isEqualToString("sawsoap:path"){
            canAddKeys = true
        }
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?){
        print("element name:   \(elementName)")
        if (elementName as NSString).isEqualToString("sawsoap:sharedDirectories"){
            issharedPath = false
        }else   if (elementName as NSString).isEqualToString("sawsoap:path"){
            canAddKeys = false
        }
    }
    
    
    func parser(parser: NSXMLParser, foundCharacters string: String){
        if issharedPath && canAddKeys{
            pathsArray.addObject(string)
        }
    }
    
    
    
    func parser(parser: NSXMLParser, foundAttributeDeclarationWithName attributeName: String, forElement elementName: String, type: String?, defaultValue: String?){
        
    }
    
    func parserDidEndDocument(parser: NSXMLParser){
        self.delegate?.foundPaths!(paths: pathsArray)
    }
    
}
