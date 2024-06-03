//
//  NewDetailsViewController.swift
//  Swift Day6 Network
//
//  Created by Slsabel Hesham on 29/04/2024.
//

import UIKit
import SDWebImage
import CoreData
import Toast_Swift
class NewDetailsViewController: UIViewController {
    var new : New?
    var newsProtocol : NewsProtocol?
    
    
    @IBOutlet weak var detailsView: UIView!
    @IBOutlet weak var favBtn: UIButton!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var newTitle: UILabel!
    @IBOutlet weak var newImage: UIImageView!
    var isFavourite: Bool = false
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let corners: UIRectCorner = [.topRight, .topLeft]
        let cornerRadius: CGFloat = 20.0
        let maskPath = UIBezierPath(roundedRect: detailsView.bounds,
                                    byRoundingCorners: corners,
                                    cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = maskPath.cgPath
        
        detailsView.layer.mask = maskLayer
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "News")
        let predicate = NSPredicate(format: "title == %@", ((new?.title)!))
        fetchRequest.predicate = predicate
        do{
            let news = try context.fetch(fetchRequest)
            for item in news{
                if let newTitle = new?.title,
                   let itemTitle = item.value(forKey: "title") as? String {
                    let isExist = newTitle == itemTitle
                    if(isExist){
                        isFavourite = true
                    }else{
                        isFavourite = false
                    }
                }
            }
        } catch let error as NSError{
            print(error)
        }
        newImage.sd_setImage(with: URL(string: new!.imageUrl!)                                     , placeholderImage: UIImage(named: "placeholder_image.jpeg"))
        
        textView.text = new?.desription
        label.text = new?.author
        newTitle.text = new?.title
        
        if(isFavourite){
            favBtn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        }else{
            favBtn.setImage(UIImage(systemName: "heart"), for: .normal)
        }
    }
    @IBAction func addToFav(_ sender: UIButton) {
        if(favBtn.currentImage == UIImage(systemName: "heart")){
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let entity = NSEntityDescription.entity(forEntityName: "News", in: context)
            let mNew = NSManagedObject(entity: entity!, insertInto: context)
            mNew.setValue(new?.title, forKey: "title")
            mNew.setValue(new?.desription, forKey: "desription")
            mNew.setValue(new?.author, forKey: "author")
            mNew.setValue(new?.imageUrl, forKey: "imageUrl")
            mNew.setValue(new?.publishedAt, forKey: "publishedAt")
            
            do{
                try context.save()
                newsProtocol?.reloadNews()
                print("saved")
            }catch let error as NSError{
                print(error)
            }
            favBtn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            self.view.makeToast("New added to favourites")
            
        }else{
            
            let alertController = UIAlertController(title: "Delete", message: "Are you sure you want to delete the new from favourites?", preferredStyle: .alert)
            
            let deleteAction = UIAlertAction(title: "Delete", style: .default) { (action: UIAlertAction!) in
                
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let context = appDelegate.persistentContainer.viewContext
                let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "News")
                let predicate = NSPredicate(format: "title == %@", (self.new?.title)!)
                fetchRequest.predicate = predicate
                do{
                    let movies = try context.fetch(fetchRequest)
                    for movie in movies{
                        context.delete(movie)
                        try context.save()
                        self.newsProtocol?.reloadNews()
                        print("deleted")
                    }
                } catch let error as NSError{
                    print(error)
                }
                
                self.favBtn.setImage(UIImage(systemName: "heart"), for: .normal)
                self.view.makeToast("New removed from favourites")
                
            }
            alertController.addAction(deleteAction)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            { (action:UIAlertAction!) in
            }
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
