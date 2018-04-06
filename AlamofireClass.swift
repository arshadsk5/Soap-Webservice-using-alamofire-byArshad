//
//  AlamofireClass.swift
//  NTUCAdept
//
//  Created by Shaik Arshad on 5/4/18.
//  Copyright © 2018 Shaik Arshad. All rights reserved.
//

import UIKit
import Alamofire
import SWXMLHash
import SwiftyJSON

var baseViewObj: BaseViewController = BaseViewController()

class AlamofireClass: NSObject {

    class func alamofireMethod(soapMessage: String, soapMsgLength: Int, method : Alamofire.HTTPMethod, isTokenRequired: Bool, isPolicyMemberIdRequired: Bool, actionResponse: String, actionResult: String, action : String, completionHandler: @escaping (_ data: JSON?, _ error: NSError?) -> ()) {
    
        let theURL = URL(string: apiUrl)
        
        var mutableR = URLRequest(url: theURL!)
        mutableR.addValue(const_Domain_Name, forHTTPHeaderField: "Host")
        mutableR.addValue("text/xml;charset=utf-8", forHTTPHeaderField: "Content-Type")
        mutableR.addValue(action, forHTTPHeaderField: "SOAPAction")
        mutableR.addValue(String(soapMsgLength), forHTTPHeaderField: "Content-Length")
        
        if isTokenRequired {
            mutableR.addValue(Utilities.getToken(), forHTTPHeaderField: "AuthenticationToken")
        }
        
        
        
        mutableR.addValue(String(soapMsgLength), forHTTPHeaderField: "AuthenticationToken")
        
        
        mutableR.httpMethod = method.rawValue
        mutableR.httpBody = soapMessage.data(using: String.Encoding.utf8)
        
        var alamofireManager : Alamofire.SessionManager?
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForResource = 60
        configuration.timeoutIntervalForRequest = 60
        //configuration.httpAdditionalHeaders = header
        //configuration.requestCachePolicy = .useProtocolCachePolicy
        
        alamofireManager = Alamofire.SessionManager(configuration:
            configuration)
        alamofireManager = Alamofire.SessionManager.default
        
        if kNetworkController.checkNetworkStatus() {
            alamofireManager?.request(mutableR)
                .responseString { response in
                    print(response.response?.statusCode as Any)
                    
                    if (response.response?.statusCode != nil) {
                        let statusCode : Int = (response.response?.statusCode)!
                        
                        if response.result.isSuccess {
                            if let xmlString = response.result.value {
                                let xml = SWXMLHash.parse(xmlString)
                                let body =  xml["soap:Envelope"]["soap:Body"]
                                
                                if let responseElement = body["response parameter"]["result parameter"].element {
                                    let responseResult = responseElement.text
                                    
                                    if let data = responseResult.data(using: .utf8) {
                                        if let json = try? JSON(data: data) {
                                            print("the response is",JSON(json))
                                            let responseData = JSON(json)
                                            if statusCode == 200 {
                                                completionHandler(responseData, nil)
                                            }
                                        }
                                    }
                                    
                                }
                            }
                            
                        } else{
                            completionHandler(nil, response.result.error! as NSError)
                        }
                    }
                    
                    /* if let xmlString = response.result.value {
                     let xml = SWXMLHash.parse(xmlString)
                     let body =  xml["soap:Envelope"]["soap:Body"]
                     if let responseElement = body[actionResponse][actionResult].element {
                     let responseResult = responseElement.text
                     print("the response is",JSON(responseResult))
                     /* let xmlInner = SWXMLHash.parse(responseResult.stringByDecodingHTMLEntities)
                     for element in xmlInner["PolicyHolders"]["Table"].all {
                     if let nameElement = element["Name"].element {
                     var countryStruct = Country()
                     countryStruct.name = nameElement.text
                     result.append(countryStruct)
                     }
                     } */
                     }
                     completion(result)
                     }else{
                     print("error fetching XML")
                     } */
            }
        } else{
            baseViewObj.hideLoader()
            print("No internet connection")
        }
    }
    
   /* class func soapRequestCall(){
        Alamofire.request(.POST,
                          parameters: nil,
                          encoding: .Custom({
                            (convertible, params) in
                            //a.
                            let mutableRequest = convertible.URLRequest.copy() as!                NSMutableURLRequest
                            // or
                            //b.
                            
                            mutableRequest.HTTPMethod = "POST"
                            
                            mutableRequest.URL = NSURL(string: "http://holidaywebservice.com/HolidayService_v2/HolidayService2.asmx?wsdl")
                            let mutableReques02 = NSMutableURLRequest(URL: theURL!)
                            //
                            //mutableReques02.HTTPBody =....
                            
                            mutableRequest.HTTPBody = "xmlns:soap:http://schemas.xmlsoap.org/soap/envelope/, xmlns:i :http://www.w3.org/2001/XMLSchema-instance,xmlns:d : http://www.w3.org/2001/XMLSchema,xmlns:c:http://schemas.xmlsoap.org/soap/encoding/,xmlns:v:http://schemas.xmlsoap.org/soap/envelope/<hs:GetHolidaysAvaible><hs:countrycode> UnitedStates</hs:countrycode></hs:GetHolidaysAvaible></SOAP-ENV:Body></SOAP-ENV:Envelope>"
                            .dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
                            
                            return (mutableRequest, nil)}),
                          headers:
            ["Username": "login", // Login API
                "Password": "password" , // Password API
                "AuthenticatedToken" : "35432",  // Authenticated API
                "Authorization": "Basic nasiouynvo8eyt829409", // Authenticated API
                "Accept" :       "text/xml",
                "Content-Type" : "text/xml; charset=UTF-8", // Type content and charset accept
                "Accept-Charset" : "UTF-8",])
            .responsePropertyList { response in
                let xml = SWXMLHash.parse(response.data!)
                print(xml)
        }
    } */
    
    
}
