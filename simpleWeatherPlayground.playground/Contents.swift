//: Playground - noun: a place where people can play

import UIKit
import XCPlayground
//import Mantle


let url = URL(string: "http://api.openweathermap.org/data/2.5/weather?q=Londonid=524901&APPID=f9976cb284fb9b6ffa68977af727e5fb")

let sessionConfig = URLSessionConfiguration.default
let session = URLSession(configuration: sessionConfig)

let task = session.dataTask(with: url!, completionHandler: {(Data, UrlResponse, Error) in
        if let error = Error {
            print(error.localizedDescription)
            print("There was an error")
        } else if let httpResponse = UrlResponse as? HTTPURLResponse {
            if httpResponse.statusCode == 200 {
                print("There was data")
            }
        }
    }
    )

    task.resume()



