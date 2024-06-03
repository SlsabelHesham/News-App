//
//  ViewController.swift
//  Swift Day6 Network
//
//  Created by Slsabel Hesham on 29/04/2024.
//

import UIKit
import CoreData

class ViewController: UIViewController , UITableViewDelegate, UITableViewDataSource , NewsProtocol{
    func reloadNews() {
        fetchData()
        if(favouriteNews.count == 0){
            nodataImage.isHidden = false
            noFav.isHidden = false
        }
        favTable.reloadData()
    }
    
    
    @IBOutlet weak var noFav: UILabel!
    @IBOutlet weak var nodataImage: UIImageView!
    var favouriteNews: [New] = []
    func fetchData(){
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "News")
        do{
            let news = try context.fetch(fetchRequest) 
            favouriteNews.removeAll()
            for new in news{
                let title = new.value(forKey: "title") as? String
                let author = new.value(forKey: "author") as? String
                let desc = new.value(forKey: "desription") as? String
                let imageUrl = new.value(forKey: "imageUrl") as? String
                let publishedAt = new.value(forKey: "publishedAt") as? String
                let favNew = New(author: author!, title: title!, desription: desc!, imageUrl: imageUrl!, url: "", publishedAt: publishedAt!)
                favouriteNews.append(favNew)
            }
        } catch let error as NSError{
            print(error)
        }
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favouriteNews.count

    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? NewCustomCell
        cell?.layer.cornerRadius = 15;
        cell?.layer.borderWidth = 7;
        cell?.cellView.layer.cornerRadius = 15
        cell?.layer.borderColor = UIColor.black.cgColor;
        if(favouriteNews.count == 0){
            nodataImage.isHidden = false
            noFav.isHidden = false
        }else{
            nodataImage.isHidden = true
            noFav.isHidden = true
            let new = favouriteNews[indexPath.row]
            cell?.cellLabel.text = new.title
            cell?.cellImage.sd_setImage(with: URL(string: new.imageUrl!)
             , placeholderImage: UIImage(named: "placeholder_image.jpeg"))
            cell?.cellImage.layer.cornerRadius = 10.0
            
        }
        
        return cell!
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "details" {
            let indexPath = favTable.indexPathForSelectedRow!
            let detailsVC = segue.destination as! NewDetailsViewController
            let selectedNew = favouriteNews[indexPath.row]
            detailsVC.new = selectedNew
            detailsVC.newsProtocol = self
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        print("appear")
        fetchData()
        favTable.reloadData()
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            
            let alertController = UIAlertController(title: "Confirm Deletion", message: "Are you sure yow want to delete new from favourires?", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "Delete", style: .default) { (action:UIAlertAction!) in
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let context = appDelegate.persistentContainer.viewContext
                let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "News")
                let predicate = NSPredicate(format: "title == %@",
                                            (self.favouriteNews[indexPath.row].title!))
                
                
                fetchRequest.predicate = predicate
                do{
                    let news = try context.fetch(fetchRequest)
                    for new in news{
                        context.delete(new)
                        try context.save()
                        print("deleted")
                        //favouriteNews.remove(at: indexPath.row)
                        self.fetchData()
                        if(self.favouriteNews.count == 0){
                            self.nodataImage.isHidden = false
                            self.noFav.isHidden = false
                        }
                        self.favTable.reloadData()
                    }
                } catch let error as NSError{
                    print(error)
                }
                
            }

            alertController.addAction(okAction)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction!) in
            }
            alertController.addAction(cancelAction)
            
            self.present(alertController, animated: true, completion:nil)
            
            
            
        }
    }
    
    @IBOutlet weak var favTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.favTable.delegate = self
        self.favTable.dataSource = self
        fetchData()
        self.favTable.reloadData()
    }


}

