//
//  WebServiceHandler.swift
//  PrologisOne_iPad
//
//  Created by Sasi on 26/03/16.
//  Copyright © 2016 Prologis. All rights reserved.
//

import UIKit

class WebServiceHandler: NSObject {
   class func getAllAccessLevels()
    {
        let andBaseURL = "\(UserDetails.sharedInstance.baseURL):\(UserDetails.sharedInstance.portNumber)/analytics/saw.dll?SoapImpl=nQSessionService"
        let url = "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:v7=\"urn://oracle.bi.webservices/v7\"><soapenv:Header/><soapenv:Body><v7:logon><v7:name>dptest_006</v7:name><v7:password>passw0rd1</v7:password></v7:logon></soapenv:Body></soapenv:Envelope>"
        
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
                
                
            }
            
        })
        task.resume()
    }

}
