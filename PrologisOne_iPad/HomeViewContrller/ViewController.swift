//
//  ViewController.swift
//  PrologisOne_iPad
//
//  Created by Sasi on 22/03/16.
//  Copyright © 2016 Prologis. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UIWebViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UICollectionViewDelegate {
    @IBOutlet weak var webViewLogin: UIWebView!
    var pathArray:NSMutableArray?
    var keyArray:NSMutableArray?
    var isFirstTime = true
    var selectedIndex = -1
    @IBOutlet weak var _collectionView: UICollectionView!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        var titleImg : UIImageView
        
        titleImg = UIImageView(frame:CGRectMake(0, 0, 172, 36));
        titleImg.image = UIImage(named: "Prologies_title")
        self.navigationController?.navigationBar.topItem?.titleView = titleImg
        let nibName = UINib(nibName: "HomeCell", bundle:nil)
        _collectionView.registerNib(nibName, forCellWithReuseIdentifier: "HomeCell")
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 50, right: 20)
        _collectionView.collectionViewLayout = layout
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "deviceOriented", name: UIDeviceOrientationDidChangeNotification, object: nil)
        
        
    }
 

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  6//; (keyArray?.count)!
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("HomeCell", forIndexPath: indexPath) as! HomeCell
       // cell._lblTitle.text = (keyArray?.objectAtIndex(indexPath.row))! as? String
        let _font = UIFont.systemFontOfSize(26)
        cell._lblTitle.font = _font
        cell._lblTitle.textColor = UIColor.blackColor()
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        if(UIDeviceOrientationIsLandscape(UIDevice.currentDevice().orientation)) {
            return CGSizeMake((collectionView.frame.size.width/2) - 40.0 , 170)
        }
        return CGSizeMake(300 , 155)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(20, 20, 20, 20)
    }

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
//        selectedIndex = indexPath.row
//        if isFirstTime{
//            let storage : NSHTTPCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
//            for cookie in storage.cookies!  {
//                storage.deleteCookie(cookie)
//            }
//            NSUserDefaults.standardUserDefaults()
//            isFirstTime = false
//            let url : NSString = "\(UserDetails.sharedInstance.baseURL):\(UserDetails.sharedInstance.portNumber)/analytics/saw.dll?dashboard&PortalPath=/shared/00 Home/_portal/0.1 Home&NQUser=\(UserDetails.sharedInstance.userName)&NQPassword=\(UserDetails.sharedInstance.passWord)"
//            let urlwithPercentEscapes = url.stringByAddingPercentEncodingWithAllowedCharacters( NSCharacterSet.URLQueryAllowedCharacterSet())
//            let webURL : NSURL = NSURL(string: urlwithPercentEscapes! as String)!
//            webViewLogin.delegate = self
//            webViewLogin.loadRequest(NSURLRequest(URL: webURL))
//        }else{
            let storyBoard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
            let viewController = storyBoard.instantiateViewControllerWithIdentifier("ReportViewController") as! ReportViewController
            viewController.webView = self.webViewLogin
            viewController.selectedIndex = self.selectedIndex
            viewController.pathArray = self.pathArray
            viewController.keyArray = self.keyArray
            self.navigationController?.pushViewController(viewController, animated: true)
       // }
    }
    func webViewDidStartLoad(webView: UIWebView) {
        print("webViewDidStartLoad")
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        print("webViewDidFinishLoad")

    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        print("didFailLoadWithError")

    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        print(request.URL)
        let url = request.URL?.absoluteString
        if url?.rangeOfString("analytics/res/empty.htm") != nil{
            print("succees")
            let storyBoard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
            let viewController = storyBoard.instantiateViewControllerWithIdentifier("ReportViewController") as! ReportViewController
            viewController.title = self.keyArray?.objectAtIndex(selectedIndex) as? String
            viewController.webView = self.webViewLogin
            viewController.selectedIndex = self.selectedIndex
            viewController.pathArray = self.pathArray
            viewController.keyArray = self.keyArray
            self.navigationController?.pushViewController(viewController, animated: true)
        }else{
            
        }
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func deviceOriented() {
        _collectionView .reloadData();
    }

}

