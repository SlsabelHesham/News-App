//
//  LocalManager.swift
//  Swift Day6 Network
//
//  Created by Slsabel Hesham on 14/05/2024.
//

import Foundation
import CoreData

func getLocalData() -> [New] {
    let appDelegate = Utility.appDelegete
    let context = appDelegate.persistentContainer.viewContext
    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CashedNews")
    var fetchedNewsArray: [New] = []
    do {
        let news = try context.fetch(fetchRequest)
        for new in news {
            if let title = new.value(forKey: "title") as? String,
               let author = new.value(forKey: "author") as? String,
               let desc = new.value(forKey: "desription") as? String,
               let imageUrl = new.value(forKey: "imageUrl") as? String,
               let publishedAt = new.value(forKey: "publishedAt") as? String {
                let cashedNew = New(author: author, title: title, desription: desc, imageUrl: imageUrl, url: "", publishedAt: publishedAt)
                fetchedNewsArray.append(cashedNew)
                
                
            }
        }
    } catch {
        print("\(error)")
    }
    return fetchedNewsArray
}
