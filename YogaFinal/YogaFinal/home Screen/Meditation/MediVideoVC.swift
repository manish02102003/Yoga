//
//  MediVideoVC.swift
//  YogaFinal
//
//  Created by TryCatch (students) on 14/03/24.
//

import UIKit
import SDWebImage
import youtube_ios_player_helper
import CoreData

class MediVideoVC: UIViewController,YTPlayerViewDelegate {
    var data : meditationModel?
    var MediItem : [meditationModel] = []
    var data1 = ["Now Playing","Now Playing","Now Playing","Now Playing","Now Playing"]
    var selectedIndex: Int?
    
    @IBOutlet weak var videoPlayer: YTPlayerView!
    @IBOutlet weak var collectionView1: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView1.register(UINib(nibName: "UpNextCVC", bundle: .main), forCellWithReuseIdentifier: "UpNextCVC")
        videoPlayer.delegate = self
        videoPlayer.load(withVideoId: data?.video_link ?? "")
        saveDataToCoreDataEarlierWatched()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func ShareVideoBtn(_ sender: UIButton) {
        
        guard let videoLink = data?.video_link else {
                print("No video link available to share.")
                return
            }
            
            
            let videoURL = URL(string: "https://www.youtube.com/watch?v=\(videoLink)")
            let activityViewController = UIActivityViewController(activityItems: [videoURL as Any], applicationActivities: nil)
  
            present(activityViewController, animated: true, completion: nil)
        
    }
    
    @IBAction func backBTN(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        videoPlayer.playVideo()
    }
    @IBAction func savedBtn(_ sender: UIButton) {
        saveDataToCoreData()
    }
        
    func saveDataToCoreData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        // Check if data already exists for the current user's UUID 
        let fetchRequest: NSFetchRequest<SavedData> = SavedData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "title == %@ AND userID == %@", data?.title ?? "", (UIApplication.shared.delegate as? AppDelegate)?.loggedinUseruuid ?? "")
        
        do {
            let existingData = try managedContext.fetch(fetchRequest)
            if existingData.isEmpty {
                // If data doesn't exist create a new entity for saving data
                guard let entity = NSEntityDescription.entity(forEntityName: "SavedData", in: managedContext) else { return }
                let savedData = NSManagedObject(entity: entity, insertInto: managedContext)
                
                
                savedData.setValue(data?.img, forKey: "image")
                savedData.setValue(data?.video_link, forKey: "video")
                savedData.setValue(data?.title, forKey: "title")
                savedData.setValue((UIApplication.shared.delegate as? AppDelegate)?.loggedinUseruuid, forKey: "userID")
                
                
                try managedContext.save()
                print("Data saved to CoreData")
            } else {
                print("Data already exists in CoreData")
            }
        } catch let error as NSError {
            print("Could not save data. \(error), \(error.userInfo)")
        }
    }

    func saveDataToCoreDataEarlierWatched() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        // Check if data already exists for the current user UUID 
        let fetchRequest: NSFetchRequest<EarlierWatched> = EarlierWatched.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "title == %@ AND userID == %@", data?.title ?? "", (UIApplication.shared.delegate as? AppDelegate)?.loggedinUseruuid ?? "")
        
        do {
            let existingData = try managedContext.fetch(fetchRequest)
            if existingData.isEmpty {
                // If data doesn't exist create a new entity for saving data
                guard let entity = NSEntityDescription.entity(forEntityName: "EarlierWatched", in: managedContext) else { return }
                let watchedData = NSManagedObject(entity: entity, insertInto: managedContext)
                
                
                watchedData.setValue(data?.img, forKey: "image")
                watchedData.setValue(data?.video_link, forKey: "video")
                watchedData.setValue(data?.title, forKey: "title")
                watchedData.setValue((UIApplication.shared.delegate as? AppDelegate)?.loggedinUseruuid, forKey: "userID")
                
                // Save changes to the managed object context
                try managedContext.save()
                print("Data saved to CoreData")
            } else {
                print("Data already exists in CoreData")
            }
        } catch let error as NSError {
            print("Could not save data. \(error), \(error.userInfo)")
        }
    }


    
}
extension MediVideoVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return MediItem.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView1.dequeueReusableCell(withReuseIdentifier: "UpNextCVC", for: indexPath) as! UpNextCVC
       
        cell.titleLable.text = MediItem[indexPath.row].title
//        cell.subTitleLable.text =  data1[indexPath.row]/* MediItem[indexPath.row].id */
        if let index = selectedIndex, indexPath.item == index {
                   // Display text for the selected cell
                   cell.subTitleLable.text = data1[index]
               } else {
                   // Blank the text for other cells
                   cell.subTitleLable.text = ""
               }
        let url = URL(string:  MediItem[indexPath.row].img )
        cell.upNextImgView.sd_setImage(with: url)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = ((collectionView1.frame.width - 20)/1)
        let height = (collectionView1.frame.height - 160)
        return CGSize(width: width, height: height)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        data = MediItem[indexPath.item]

        selectedIndex = indexPath.item
        videoPlayer.load(withVideoId: MediItem[indexPath.row].video_link )
        collectionView1.reloadData()
       
    }
}
