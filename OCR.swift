//
//  NewControllerViewController.swift
//  SheHackP2
//
//  Created by Emma Park on 2020/01/11.
//  Copyright © 2020 Emma Park. All rights reserved.
//
import Foundation
import UIKit

class SecondScreenViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var image :UIImage?
 
    init(nibName: String?, bundle: Bundle?, image: UIImage){
        print("uiimage constructor")
        super.init(nibName: nibName, bundle: bundle)
        self.image = image
    }
    
    required init?(coder: NSCoder){
        print("coder constructor")
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
      //  let fileImage = image?.pngData()
        // Do any additional setup after loading the view.
        let semaphore = DispatchSemaphore (value: 0)

        let parameters = [
          [
            "key": "apikey",
            "value": "5f9324a8a588957",
            "type": "text"
          ],
          [
            "key": "iscreatesearchablepdf",
            "value": "false",
            "type": "text"
          ],
          [
            "key": "issearchablepdfhidetextlayer",
            "value": "false",
            "type": "text"
          ],
          [
            "key": "filetype",
            "value": "jpg",
            "type": "text"
          ],
          [
            "key": "file",
            "src": "/Users/emmapark/Downloads/IMG_8925.JPG",
            "type": "file"
          ]] as [[String : Any]]

        let boundary = "Boundary-\(UUID().uuidString)"
        var body = ""
        var error: Error? = nil
        var paramValue = "";
        var paramName:Any
        var paramSrc:Any
        
         body += "--\(boundary)\r\n"
         paramName = parameters[0]["key"]!
         body += "Content-Disposition:form-data; name=\"\(paramName)\""
         paramValue = parameters[0]["value"] as! String
         body += "\r\n\r\n\(paramValue)\r\n"
//
        
        paramName = parameters[1]["key"]!
        body += "Content-Disposition:form-data; name=\"\(paramName)\""
        paramValue = parameters[1]["value"] as! String
        body += "\r\n\r\n\(paramValue)\r\n"
        
        paramName = parameters[2]["key"]!
        body += "Content-Disposition:form-data; name=\"\(paramName)\""
        paramValue = parameters[2]["value"] as! String
        body += "\r\n\r\n\(paramValue)\r\n"
        
        paramName = parameters[3]["key"]!
        body += "Content-Disposition:form-data; name=\"\(paramName)\""
        paramValue = parameters[3]["value"] as! String
        body += "\r\n\r\n\(paramValue)\r\n"
         
       // print("Size \(image!.size) \n")
        
        paramName = parameters[4]["key"]!
        body += "Content-Disposition:form-data; name=\"\(paramName)\""
        paramSrc = parameters[4]["src"] as! String
        let fileData = image!.pngData()!
        let fileContent = fileData.base64EncodedString()
        body += "; filename=\"\(paramSrc)\r\n" + "Content-Type: \"content-type header\"\r\n\r\n\(fileContent)\r\n"
            
        
        body += "--\(boundary)--\r\n";
        //print("DATA\(body)\n")
        let postData = body.data(using: .utf8)

        var request = URLRequest(url: URL(string: "https://api.ocr.space/parse/image")!,timeoutInterval: Double.infinity)
        request.addValue("", forHTTPHeaderField: "")
        request.addValue("multipart/form-data; boundary=--------------------------293326906587902853798281", forHTTPHeaderField: "Content-Type")
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
          print("POSTING DATA \n")
        request.httpMethod = "POST"
        request.httpBody = postData

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            print("RESPONSE DATA------> \n \(response)")
            if let responseData=data {
                print("RECIEVED DATA \n")
                do{
                    let json = try JSONSerialization.jsonObject(with: responseData, options: JSONSerialization.ReadingOptions.allowFragments)
                    print(json)
                }catch{
                    print("could not serialize")
                }
            }
            semaphore.signal()
    }
        task.resume()
        semaphore.wait()

   

}

}

