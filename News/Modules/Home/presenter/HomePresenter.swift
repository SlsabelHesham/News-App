//
//  HomePresenter.swift
//  Swift Day6 Network
//
//  Created by Slsabel Hesham on 14/05/2024.
//

import Foundation
import Reachability

class HomePresenter{
    var news : [New]?
    weak var view : HomeProtocol?
    
    func attachView(view: HomeProtocol){
        self.view = view
    }
    func getNews(){
        do {
            let reachability = try Reachability()
            if reachability.connection != .unavailable {
                
                getDataFromNetwork { [weak self] news in
                    self?.news = news
                    DispatchQueue.main.async {
                        self?.view?.renderTable()
                    }
                    self?.view?.cashData(newsArray: news)
                }
            } else {
                print("No internet connection")
                self.news = getLocalData()
                DispatchQueue.main.async {
                    self.view?.renderTable()
                }

            }
        } catch {
            print("\(error)")
        }

    }
}
