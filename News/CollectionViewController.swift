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
//private let reuseIdentifier = "Cell"

class CollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var cellLabel: UILabel!
    var indecator : UIActivityIndicatorView?
    @IBOutlet weak var cellImage: UIImageView!
    var newsArray :[New] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        indecator = UIActivityIndicatorView(style: .medium)
        indecator!.center = view.center
        indecator!.startAnimating()
        view.addSubview(indecator!)
        do {
            let reachability = try Reachability()
            if reachability.connection != .unavailable {
                
                getDataFromNetwork { news in
                    DispatchQueue.main.async {
                        self.newsArray = news
                        self.indecator?.stopAnimating()
                        self.collectionView.reloadData()
                    }
                    self.cashData(newsArray: news)
                    print("tt")
                }
            } else {
                print("No internet connection")
                
                self.fetchData()
                
            }
        } catch {
            print("Unable to create Reachability object: \(error)")
        }
    }
    
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
            // Add all fetched news items to the newsArray
            self.newsArray = fetchedNewsArray
            // Reload collection view
            self.collectionView.reloadData()
            print("Fetched \(newsArray.count) news items from Core Data")
        } catch {
            print("Error fetching data: \(error)")
        }
    }

    func cashData(newsArray: [New]) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CashedNews")
        
        do {
            // Delete all existing cached news items
            let existingNews = try context.fetch(fetchRequest)
            for newsItem in existingNews {
                context.delete(newsItem)
            }
            
            // Insert new news items
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
            
            // Save changes to the context
            try context.save()
            print("Data cached successfully")
        } catch {
            print("Error caching data: \(error)")
        }
    }
        /*
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
            } catch  {
                print(error.localizedDescription)
            }
        }
        task.resume()
        */
    
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        //self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if segue.identifier == "details" {
            // Check if there is a selected item
            if let indexPath = collectionView.indexPathsForSelectedItems?.first {
                let detailsVC = segue.destination as! NewDetailsViewController
                let selectedNew = newsArray[indexPath.row]
                detailsVC.new = selectedNew
            }
        }
        
    }
    

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return newsArray.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
    

        cell.myLabel.text = newsArray[indexPath.row].author
        cell.myCell.sd_setImage(with: URL(string: newsArray[indexPath.row].imageUrl!)!
                                     , placeholderImage: UIImage(named: "placeholder_image.jpeg"))
        // Configure the ce
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: view.frame.width / 2.1, height: view.frame.width / 2)
    }

}
