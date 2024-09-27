//
//  MeditationVC.swift
//  YogaFinal
//
//  Created by TryCatch (students) on 07/03/24.
//

import UIKit
struct meditationModel: Codable{
    var id: String
    var category: String
    var title: String
    var video_link: String
    var img: String
}

class MeditationVC: UIViewController,UISearchBarDelegate {
    var meditationData = [meditationModel]()
    var recommededMedi = [meditationModel]()
    var FavoriteMedi = [meditationModel]()
    var NewMedi = [meditationModel]()
    
    var filteredMediData = [meditationModel]()
       var filteredMediRecommended = [meditationModel]()
       var filteredFavoriteMedi = [meditationModel]()
       var filteredNewMedi = [meditationModel]()
    var currentCategory: String = "focus"
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var collectionView2: UICollectionView!
    
    @IBOutlet weak var collectionView1: UICollectionView!
    
    @IBOutlet weak var collectionView3: UICollectionView!
    
    @IBOutlet weak var collectionView4: UICollectionView!
    
    
   
   
    
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        collectionView1.register(UINib(nibName: "meditationCVC", bundle: .main), forCellWithReuseIdentifier: "meditationCVC")
        collectionView2.register(UINib(nibName: "allMeditationCVC", bundle: .main), forCellWithReuseIdentifier: "allMeditationCVC")
        collectionView3.register(UINib(nibName: "allMeditationCVC", bundle: .main), forCellWithReuseIdentifier: "allMeditationCVC")
        collectionView4.register(UINib(nibName: "allMeditationCVC", bundle: .main), forCellWithReuseIdentifier: "allMeditationCVC")
//        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "Header")

        collectionView1.dataSource = self
        collectionView1.delegate = self
        collectionView2.dataSource = self
        collectionView2.delegate = self
        collectionView3.dataSource = self
        collectionView3.delegate = self
        collectionView4.dataSource = self
        collectionView4.delegate = self
        
        searchBar.delegate = self
        
        apiCall1()
        apiCall4()
        apiCall5()
        apiCall6()
        
    }
    
    
    @IBAction func Logout(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
           filterContentForSearchText(searchText)
       }
       
       func filterContentForSearchText(_ searchText: String) {
           if searchText.isEmpty {
               collectionView1.reloadData()
               collectionView2.reloadData()
               collectionView3.reloadData()
               collectionView4.reloadData()
           } else {
               filteredMediData = meditationData.filter { $0.title.lowercased().contains(searchText.lowercased()) }
               filteredMediRecommended = recommededMedi.filter { $0.title.lowercased().contains(searchText.lowercased()) }
               filteredFavoriteMedi = FavoriteMedi.filter { $0.title.lowercased().contains(searchText.lowercased()) }
               filteredNewMedi = NewMedi.filter { $0.title.lowercased().contains(searchText.lowercased()) }
               
               collectionView1.reloadData()
               collectionView2.reloadData()
               collectionView3.reloadData()
               collectionView4.reloadData()
           }
       }
    
    
    @IBAction func focusBtn(_ sender: UIButton) {
        currentCategory = "focus"
        apiCall1()
    }
    
    @IBAction func relaxdBtn(_ sender: UIButton) {
        currentCategory = "relax"
        apiCall1()
    }
    
    @IBAction func sleepBtn(_ sender: UIButton) {
        currentCategory =  "sleep"
        apiCall1()
    }
    func apiCall4(){
        guard let url = URL(string: "https://mapi.trycatchtech.com/v3/yoga_app/recommended_meditation")else{return}
        let urlrequest = URLRequest(url: url)
        URLSession.shared.dataTask(with: urlrequest) { data,response,error in
            if let error = error{
                print(error.localizedDescription)
                return
            }
            if let data = data{
                do{
                    let jsondata = try JSONDecoder().decode([meditationModel].self, from: data)
                    self.recommededMedi = jsondata
                    DispatchQueue.main.async {
                        self.collectionView2.reloadData()
                    }
                }
                catch{
                    print("Error in trycatch" , error)
                }
            }
            
        }.resume()
        
    }
    func apiCall5(){
        guard let url = URL(string: "https://mapi.trycatchtech.com/v3/yoga_app/single_meditation?meditation_id=1")else{return}
        let urlrequest = URLRequest(url: url)
        URLSession.shared.dataTask(with: urlrequest) { data,response,error in
            if let error = error{
                print(error.localizedDescription)
                return
            }
            if let data = data{
                do{
                    let jsondata = try JSONDecoder().decode([meditationModel].self, from: data)
                    self.FavoriteMedi = jsondata
                    DispatchQueue.main.async {
                        self.collectionView3.reloadData()
                    }
                }
                catch{
                    print("Error in trycatch" , error)
                }
            }
            
        }.resume()
        
    }
    func apiCall6(){
        guard let url = URL(string: "https://mapi.trycatchtech.com/v3/yoga_app/new_meditation")else{return}
        let urlrequest = URLRequest(url: url)
        URLSession.shared.dataTask(with: urlrequest) { data,response,error in
            if let error = error{
                print(error.localizedDescription)
                return
            }
            if let data = data{
                do{
                    let jsondata = try JSONDecoder().decode([meditationModel].self, from: data)
                    self.NewMedi = jsondata
                    DispatchQueue.main.async {
                        self.collectionView4.reloadData()
                    }
                }
                catch{
                    print("Error in trycatch" , error)
                }
            }
            
        }.resume()
        
    }
    
    func apiCall1(){
        guard let url = URL(string: "https://mapi.trycatchtech.com/v3/yoga_app/meditation_list_by_categories?category=\(currentCategory)")else{return}
        let urlrequest = URLRequest(url: url)
        URLSession.shared.dataTask(with: urlrequest) { data,response,error in
            if let error = error{
                print(error.localizedDescription)
                return
            }
            if let data = data{
                do{
                    let jsondata = try JSONDecoder().decode([meditationModel].self, from: data)
                    self.meditationData = jsondata
                    DispatchQueue.main.async {
                        self.collectionView1.reloadData()
                    }
                }
                catch{
                    print("Error in trycatch" , error)
                }
            }
            
        }.resume()
        
    }


}
extension MeditationVC: UICollectionViewDelegate , UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionView1 {
            if searchBar.text?.isEmpty ?? true {
                return meditationData.count
            } else {
                return filteredMediData.count
            }
        } else if collectionView == collectionView2 {
            if searchBar.text?.isEmpty ?? true {
                return recommededMedi.count
            } else {
                return filteredMediRecommended.count
            }
        } else if collectionView == collectionView3 {
            if searchBar.text?.isEmpty ?? true {
                return FavoriteMedi.count
            } else {
                return filteredFavoriteMedi.count
            }
        } else if collectionView == collectionView4 {
            if searchBar.text?.isEmpty ?? true {
                return NewMedi.count
            } else {
                return filteredNewMedi.count
            }
        }
        return 0
    }


    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collectionView1{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "meditationCVC", for: indexPath) as! meditationCVC
            let MediItem: meditationModel
            if searchBar.text?.isEmpty ?? true {
                MediItem = meditationData[indexPath.row]
            } else {
                MediItem = filteredMediData[indexPath.row]
            }
            cell.labelMed.text = MediItem.title
            let imgurl = URL(string: MediItem.img )
            cell.imgViewMed.sd_setImage(with: imgurl)
            return cell
        } else if collectionView == collectionView2 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "allMeditationCVC", for: indexPath) as! allMeditationCVC
            let MediItem: meditationModel
            if searchBar.text?.isEmpty ?? true {
                MediItem = recommededMedi[indexPath.row]
            } else {
                MediItem = filteredMediRecommended[indexPath.row]
            }
            cell.label.text = MediItem.title
            let imgurl = URL(string: MediItem.img )
            cell.imgview.sd_setImage(with: imgurl)
            return cell
            
        }else if collectionView == collectionView3 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "allMeditationCVC", for: indexPath) as! allMeditationCVC
            let MediItem: meditationModel
            if searchBar.text?.isEmpty ?? true {
                MediItem = FavoriteMedi[indexPath.row]
            } else {
                MediItem = filteredFavoriteMedi[indexPath.row]
            }
            cell.label.text = MediItem.title
            let imgurl = URL(string: MediItem.img )
            cell.imgview.sd_setImage(with: imgurl)
            return cell
            
        }else if collectionView == collectionView4 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "allMeditationCVC", for: indexPath) as! allMeditationCVC
            let MediItem: meditationModel
            if searchBar.text?.isEmpty ?? true {
                MediItem = NewMedi[indexPath.row]
            } else {
                MediItem = filteredNewMedi[indexPath.row]
            }
            cell.label.text = MediItem.title
            let imgurl = URL(string: MediItem.img )
            cell.imgview.sd_setImage(with: imgurl)
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
        var selectedMediItem: meditationModel?
        var nextFiveMediItems: [meditationModel] = []

        // Determine the selected yoga item based on the collectionView
        switch collectionView {
        case collectionView1:
            selectedMediItem = searchBar.text?.isEmpty ?? true ? meditationData[indexPath.row] : filteredMediData[indexPath.row]
            nextFiveMediItems = getNextFiveMediItems(from: meditationData, currentIndex: indexPath.row)
        case collectionView2:
            selectedMediItem = searchBar.text?.isEmpty ?? true ? recommededMedi[indexPath.row] : filteredMediRecommended[indexPath.row]
            nextFiveMediItems = getNextFiveMediItems(from: recommededMedi, currentIndex: indexPath.row)
        case collectionView3:
            selectedMediItem = searchBar.text?.isEmpty ?? true ? FavoriteMedi[indexPath.row] : filteredFavoriteMedi[indexPath.row]
            nextFiveMediItems = getNextFiveMediItems(from: FavoriteMedi, currentIndex: indexPath.row)
        case collectionView4:
            selectedMediItem = searchBar.text?.isEmpty ?? true ? NewMedi[indexPath.row] : filteredNewMedi[indexPath.row]
            nextFiveMediItems = getNextFiveMediItems(from: NewMedi, currentIndex: indexPath.row)
        default:
            break
        }

        
        guard let selectedMedi = selectedMediItem else { return }

        
        let vc = storyboard?.instantiateViewController(identifier: "MediVideoVC" ) as! MediVideoVC
        vc.data = selectedMedi
        vc.MediItem = nextFiveMediItems
        navigationController?.pushViewController(vc, animated: true)
    }

    
    private func getNextFiveMediItems(from mediArray: [meditationModel], currentIndex: Int) -> [meditationModel] {
        let startIndex = currentIndex + 1
        let endIndex = min(currentIndex + 6, mediArray.count)
        var nextFiveItems: [meditationModel] = []
        for index in startIndex..<endIndex {
            nextFiveItems.append(mediArray[index])
        }
        return nextFiveItems
    }
    
}


