//
//  CollectionViewController.swift
//  Swift Day6 Network
//
//  Created by Slsabel Hesham on 29/04/2024.
//

import UIKit
import SDWebImage
import CoreData
import Reachability

protocol HomeProtocol : AnyObject{
    func renderTable()
    func cashData(newsArray: [New])
}


class CollectionViewControoler: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource, HomeProtocol {
    
    @IBOutlet weak var collectionTable: UICollectionView!
    //var newsArray :[New] = []
    var presenter : HomePresenter!

    let indecator = UIActivityIndicatorView(style: .medium)

    override func viewDidLoad() {
        super.viewDidLoad()

        presenter = HomePresenter()
        
        self.tabBarController?.tabBar.barTintColor = UIColor.systemOrange
        self.tabBarController?.tabBar.tintColor = UIColor.systemOrange
        collectionTable.delegate = self
        collectionTable.dataSource = self
        indecator.center = self.view.center
        indecator.startAnimating()
        self.view.addSubview(indecator)
        
        presenter.getNews()
        presenter.attachView(view: self)
        
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "details" {
            if let indexPath = collectionTable.indexPathsForSelectedItems?.first {
                let detailsVC = segue.destination as! NewDetailsViewController
                let selectedNew = presenter?.news?[indexPath.row]
                detailsVC.new = selectedNew
            }
        }
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter?.news?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionCustomCell
    

        cell.newLabel.text = presenter?.news?[indexPath.row].author
        cell.newImage.sd_setImage(with: URL(string: presenter?.news?[indexPath.row].imageUrl ?? "")
                                     , placeholderImage: UIImage(named: "placeholder_image.jpeg"))
        cell.newImage.layer.cornerRadius = 20.0
        cell.newView.layer.cornerRadius = 20.0
        return cell

    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: view.frame.width / 2, height: view.frame.width / 2)
    }

}

extension CollectionViewControoler {
    func renderTable() {
        indecator.stopAnimating()
        self.collectionTable.reloadData()
    }
    
    
    func cashData(newsArray: [New]) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CashedNews")
        
        do {
            let existingNews = try context.fetch(fetchRequest)
            for newsItem in existingNews {
                context.delete(newsItem)
            }
            
            for newsItem in newsArray {
                let entity = NSEntityDescription.entity(forEntityName: "CashedNews", in: context)!
                let mNew = NSManagedObject(entity: entity, insertInto: context)
                mNew.setValue(newsItem.title, forKey: "title")
                mNew.setValue(newsItem.desription, forKey: "desription")
                mNew.setValue(newsItem.author, forKey: "author")
                mNew.setValue(newsItem.imageUrl, forKey: "imageUrl")
                mNew.setValue(newsItem.url, forKey: "url")
                mNew.setValue(newsItem.publishedAt, forKey: "publishedAt")
            }
            
            try context.save()
            print("cached")
        } catch {
            print("\(error)")
        }
    }

}


























/*
 func fetchData() {
     let appDelegate = UIApplication.shared.delegate as! AppDelegate
     let context = appDelegate.persistentContainer.viewContext
     let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CashedNews")
     
     do {
         let news = try context.fetch(fetchRequest)
         var fetchedNewsArray: [New] = []
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
         self.newsArray = fetchedNewsArray
         self.indecator.stopAnimating()
         self.collectionTable.reloadData()
     } catch {
         print("\(error)")
     }
 }


 */
