//
//  DietVideoVC.swift
//  YogaFinal
//
//  Created by TryCatch (students) on 14/03/24.
//

import UIKit
import SDWebImage
import youtube_ios_player_helper
import CoreData

class DietVideoVC: UIViewController, YTPlayerViewDelegate {
    @IBOutlet weak var Segments: UISegmentedControl!
    @IBOutlet weak var textView: UITextView!
    var data: dietModel?
    @IBOutlet weak var videoPlayer: YTPlayerView!
    @IBOutlet weak var label: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        saveDataToCoreDataEarlierWatched()
        
        videoPlayer.delegate = self
        videoPlayer.load(withVideoId: data?.video_link ?? "")
//        let image = data?.img
//        let title = data?.title
        let combinedString = data?.ingredients.joined(separator: "\n")
        textView.text = combinedString
        label.text = data?.title
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
    
    @IBAction func SavedBtn(_ sender: UIButton) {
        
        saveDataToCoreData()
    }
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        switch Segments.selectedSegmentIndex {
            
        case 0:
            let combinedString = data?.ingredients.joined(separator: "\n")
            textView.text = combinedString
        case 1:
            let combinedString = data?.instructions.joined(separator: "\n")
            textView.text = combinedString
        case 2:
            let combinedString = data?.nutritions.joined(separator: "\n")
            textView.text = combinedString
        default:
            break
        }
    }
    
    @IBAction func backBTN(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        videoPlayer.playVideo()
    }
    
    
    
    
    
    func saveDataToCoreData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        // Check if data already exists for the current user's UUID and
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
        
        // Check if data already exists for the current user's UUID and the same title
        let fetchRequest: NSFetchRequest<EarlierWatched> = EarlierWatched.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "title == %@ AND userID == %@", data?.title ?? "", (UIApplication.shared.delegate as? AppDelegate)?.loggedinUseruuid ?? "")
        
        do {
            let existingData = try managedContext.fetch(fetchRequest)
            if existingData.isEmpty {
                // If data doesn't exist, create a new entity for saving data
                guard let entity = NSEntityDescription.entity(forEntityName: "EarlierWatched", in: managedContext) else { return }
                let watchedData = NSManagedObject(entity: entity, insertInto: managedContext)
                
                // Save image, video link, title, and associate with the current user's unique identifier
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
