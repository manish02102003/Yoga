
import UIKit
import CoreData
import SDWebImage

class ProfileVC: UIViewController {
    @IBOutlet weak var collectionView1: UICollectionView!
    @IBOutlet weak var collectionView2: UICollectionView!
    @IBOutlet weak var profileLableView: UILabel!
    @IBOutlet weak var UserNamelabel: UILabel!
    
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    var savedItems: [SavedData] = []
    var EarlierItems : [EarlierWatched] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView1.register(UINib(nibName: "RecentlyCVC", bundle: .main), forCellWithReuseIdentifier: "RecentlyCVC")
        collectionView2.register(UINib(nibName: "SavedCVC", bundle: .main), forCellWithReuseIdentifier: "SavedCVC")
        
       

       
        
    }
  
    override func viewWillAppear(_ animated: Bool) {
        fetchSavedItems()
        fetchEarlierItems()
        collectionView1.reloadData()
        collectionView2.reloadData()

        if let username = globalUsername {
            UserNamelabel.text = username
                }
    }
    @IBAction func Logout(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func fetchSavedItems() {
        let fetchRequest: NSFetchRequest<SavedData> = SavedData.fetchRequest()
        
        do {
            let userUUId = (UIApplication.shared.delegate as? AppDelegate )?.loggedinUseruuid
            savedItems = try managedObjectContext.fetch(fetchRequest).filter({
                $0.userID == userUUId
            })
//            collectionView2.reloadData()
        } catch {
            print("Error fetching saved items: \(error)")
        }
    }
    func fetchEarlierItems() {
        let fetchRequest: NSFetchRequest<EarlierWatched> = EarlierWatched.fetchRequest()
        
        do {
            let userUUId = (UIApplication.shared.delegate as? AppDelegate )?.loggedinUseruuid
            EarlierItems = try managedObjectContext.fetch(fetchRequest).filter(
                {
                    $0.userID == userUUId
                })
//            collectionView1.reloadData()
        } catch {
            print("Error fetching saved items: \(error)")
        }
    }
}

extension ProfileVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionView1 {
            return EarlierItems.count
        } else if collectionView == collectionView2 {
            return savedItems.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collectionView1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecentlyCVC", for: indexPath) as! RecentlyCVC
            let Earlier = EarlierItems[indexPath.item]
                        
                        
                        if let imageUrlString = Earlier.image, let imageUrl = URL(string: imageUrlString) {
                            cell.imageView.sd_setImage(with: imageUrl, placeholderImage: UIImage(named: "placeholder_image"))
                        } else {
                          
                            cell.imageView.image = UIImage(named: "placeholder_image")
                        }
                        cell.label.text = Earlier.title
            
            return cell
        } else if collectionView == collectionView2 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SavedCVC", for: indexPath) as! SavedCVC
            let savedItem = savedItems[indexPath.item]
                        
                        
                        
                       
                        if let imageUrlString = savedItem.image, let imageUrl = URL(string: imageUrlString) {
                            cell.imageView.sd_setImage(with: imageUrl, placeholderImage: UIImage(named: "placeholder_image"))
                        } else {
                            
                            cell.imageView.image = UIImage(named: "placeholder_image")
                        }
                        cell.label.text = savedItem.title
            
            return cell
        }
        return UICollectionViewCell()
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
        
        let width = ((collectionView.frame.width - 30 ) / 2)
        let height = collectionView.frame.height - 20
        return CGSize(width: width, height: height)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let vc = storyboard?.instantiateViewController(identifier: "ProfileVideoVC") as! ProfileVideoVC
        if collectionView == collectionView1{
            vc.video = EarlierItems[indexPath.item].video ?? ""
        }else if collectionView == collectionView2{
            vc.video = savedItems[indexPath.item].video ?? ""
        }
       
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    
}


