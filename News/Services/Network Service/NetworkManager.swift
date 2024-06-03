//
//  NetworkManager.swift
//  Swift Day6 Network
//
//  Created by Slsabel Hesham on 14/05/2024.
//

import Foundation
import Alamofire


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
}
