import Foundation

var semaphore = DispatchSemaphore (value: 0)

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
    "value": "jpeg",
    "type": "text"
  ],
  [
    "key": "",
    "src": "/Users/fadumaahmed/Desktop/test.png",
    "type": "file"
  ]] as [[String : Any]]

let boundary = "Boundary-\(UUID().uuidString)"
var body = ""
var error: Error? = nil
for param in parameters {
  if param["disabled"] == nil {
    let paramName = param["key"]!
    body += "--\(boundary)\r\n"
    body += "Content-Disposition:form-data; name=\"\(paramName)\""
    let paramType = param["type"] as! String
    if paramType == "text" {
      let paramValue = param["value"] as! String
      body += "\r\n\r\n\(paramValue)\r\n"
    } else {
      let paramSrc = param["src"] as! String
      let fileData = try NSData(contentsOfFile:paramSrc, options:[]) as Data
      let fileContent = String(data: fileData, encoding: .utf8)!
      body += "; filename=\"\(paramSrc)\"\r\n"
        + "Content-Type: \"content-type header\"\r\n\r\n\(fileContent)\r\n"
    }
  }
}
body += "--\(boundary)--\r\n";
let postData = body.data(using: .utf8)

var request = URLRequest(url: URL(string: "https://api.ocr.space/parse/image")!,timeoutInterval: Double.infinity)
request.addValue("", forHTTPHeaderField: "")
request.addValue("multipart/form-data; boundary=--------------------------293326906587902853798281", forHTTPHeaderField: "Content-Type")
request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

request.httpMethod = "POST"
request.httpBody = postData

let task = URLSession.shared.dataTask(with: request) { data, response, error in 
  guard let data = data else {
    print(String(describing: error))
    return
  }
  print(String(data: data, encoding: .utf8)!)
  semaphore.signal()
}

task.resume()
semaphore.wait()
