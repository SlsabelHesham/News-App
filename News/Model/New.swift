//
//  New.swift
//  Swift Day6 Network
//
//  Created by Slsabel Hesham on 29/04/2024.
//

import Foundation

class New: Codable {
    var author: String?
    var title: String?
    var desription: String?
    var imageUrl: String?
    var url: String?
    var publishedAt: String?
    
    enum keyConvension: String, CodingKey{
        case author = "author"
        case title = "title"
        case desription = "desription"
        case imageUrl = "imageUrl"
        case url = "url"
        case publishedAt = "publishedAt"

    }
    init(author: String,
            title: String,
            desription: String,
            imageUrl: String,
            url: String,
            publishedAt: String) {
           self.author = author
           self.title = title
           self.desription = desription
           self.imageUrl = imageUrl
           self.url = url
           self.publishedAt = publishedAt
       }
}
/*
func getDataFromNetwork(handler: @escaping ([New]) -> Void){
    let url = "https://raw.githubusercontent.com/DevTides/NewsApi/master/news.json"
    
    Alamofire.request(url).responseData { response in
        switch response.result {
        case .success(let data):
            do {
                let results = try JSONDecoder().decode([New].self, from: data)
                handler(results)
            } catch {
                print("\(error.localizedDescription)")
            }
        case .failure(let error):
            print("\(error.localizedDescription)")
        }
    }

 }*/


/*func getDataFromNetwork(handler: @escaping ([New]) -> Void){
    let url = URL(string: "https://raw.githubusercontent.com/DevTides/NewsApi/master/news.json")
    guard let url = url else{
        return
    }
    let request = URLRequest(url: url)
    let session = URLSession(configuration: .default)
    let task = session.dataTask(with: request){ data, response, error in
        guard let data = data else {
            print("no data")
            return
        }
        do {
            let results = try JSONDecoder().decode([New].self, from: data)
            print(results[0].title ?? "No Title")
            handler(results)
        } catch  {
            print(error.localizedDescription)
        }
    }
    task.resume()
}
*/
