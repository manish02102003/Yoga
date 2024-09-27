//
//  ViewController.swift
//  YogaFinal
//
//  Created by TryCatch (students) on 06/03/24.
//

import UIKit
import SDWebImage

struct yogaModel: Codable{
   var id: String
   var category:String
   var sub_category:String
   var title:String
   var video_link:String
   var img: String
   var popular:String
   var weight_loss:String
}



class ViewController: UIViewController,UISearchBarDelegate {
    
    var yogaData = [yogaModel]()
    var yogaPopular = [yogaModel]()
    var yogaRecommended = [yogaModel]()
    var yogaWeightLoss = [yogaModel]()
    
    var filteredYogaData = [yogaModel]()
       var filteredYogaPopular = [yogaModel]()
       var filteredYogaRecommended = [yogaModel]()
       var filteredYogaWeightLoss = [yogaModel]()
    
    
    var currentGender: String = "women"
        var currentCategory: String = "pro"
    
    @IBOutlet weak var searchBar: UISearchBar!
    

    @IBOutlet weak var collectionView2: UICollectionView!
    
    @IBOutlet weak var collectionView1: UICollectionView!
    
    @IBOutlet weak var collectionView3: UICollectionView!
    
    @IBOutlet weak var collectionView4: UICollectionView!
    
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        collectionView1.register(UINib(nibName: "CustumCVC1", bundle: .main), forCellWithReuseIdentifier: "CustumCVC1")
        collectionView2.register(UINib(nibName: "PopularYogaCVC", bundle: .main), forCellWithReuseIdentifier: "PopularYogaCVC")
        collectionView3.register(UINib(nibName: "RecommendedCVC", bundle: .main), forCellWithReuseIdentifier: "RecommendedCVC")
        collectionView4.register(UINib(nibName: "WeightLossCVC", bundle: .main), forCellWithReuseIdentifier: "WeightLossCVC")
        segmentControl.addTarget(self, action: #selector(segmentControlValueChanged(_:)), for: .valueChanged)
            
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
    
    @objc func segmentControlValueChanged(_ sender: UISegmentedControl) {
            switch sender.selectedSegmentIndex {
            case 0:
                currentGender = "women"
            case 1:
                currentGender = "men"
            default:
                break
            }
            
           apiCall1()
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
               filteredYogaData = yogaData.filter { $0.title.lowercased().contains(searchText.lowercased()) }
               filteredYogaPopular = yogaPopular.filter { $0.title.lowercased().contains(searchText.lowercased()) }
               filteredYogaRecommended = yogaRecommended.filter { $0.title.lowercased().contains(searchText.lowercased()) }
               filteredYogaWeightLoss = yogaWeightLoss.filter { $0.title.lowercased().contains(searchText.lowercased()) }
               
               collectionView1.reloadData()
               collectionView2.reloadData()
               collectionView3.reloadData()
               collectionView4.reloadData()
           }
       }
    
    
    @IBAction func newBtn(_ sender: UIButton) {
        currentCategory = "new"
                apiCall1()
    }
    
    @IBAction func skilledBtn(_ sender: UIButton) {
        currentCategory = "skilled"
                apiCall1()
    }
    
    @IBAction func proBtn(_ sender: UIButton) {
        currentCategory = "pro"
                apiCall1()
    }
    
    func apiCall1(){
        guard let url = URL(string: "https://mapi.trycatchtech.com/v3/yoga_app/yoga_list_by_categories?category=\(currentGender)&&sub_category=\(currentCategory)")else{return}
        let urlrequest = URLRequest(url: url)
        URLSession.shared.dataTask(with: urlrequest) { data,response,error in
            if let error = error{
                print(error.localizedDescription)
                return
            }
            if let data = data{
                do{
                    let jsondata = try JSONDecoder().decode([yogaModel].self, from: data)
                    self.yogaData = jsondata
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
    func apiCall4(){
        guard let url = URL(string: "https://mapi.trycatchtech.com/v3/yoga_app/popular_yoga")else{return}
        let urlrequest = URLRequest(url: url)
        URLSession.shared.dataTask(with: urlrequest) { data,response,error in
            if let error = error{
                print(error.localizedDescription)
                return
            }
            if let data = data{
                do{
                    let jsondata = try JSONDecoder().decode([yogaModel].self, from: data)
                    self.yogaPopular = jsondata
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
        guard let url = URL(string: "https://mapi.trycatchtech.com/v3/yoga_app/recommended_yoga")else{return}
        let urlrequest = URLRequest(url: url)
        URLSession.shared.dataTask(with: urlrequest) { data,response,error in
            if let error = error{
                print(error.localizedDescription)
                return
            }
            if let data = data{
                do{
                    let jsondata = try JSONDecoder().decode([yogaModel].self, from: data)
                    self.yogaRecommended = jsondata
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
        guard let url = URL(string: "https://mapi.trycatchtech.com/v3/yoga_app/weight_loss_yoga")else{return}
        let urlrequest = URLRequest(url: url)
        URLSession.shared.dataTask(with: urlrequest) { data,response,error in
            if let error = error{
                print(error.localizedDescription)
                return
            }
            if let data = data{
                do{
                    let jsondata = try JSONDecoder().decode([yogaModel].self, from: data)
                    self.yogaWeightLoss = jsondata
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
    
    

}
extension ViewController: UICollectionViewDelegate , UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionView1 {
            if searchBar.text?.isEmpty ?? true {
                return yogaData.count
            } else {
                return filteredYogaData.count
            }
        } else if collectionView == collectionView2 {
            if searchBar.text?.isEmpty ?? true {
                return yogaPopular.count
            } else {
                return filteredYogaPopular.count
            }
        } else if collectionView == collectionView3 {
            if searchBar.text?.isEmpty ?? true {
                return yogaRecommended.count
            } else {
                return filteredYogaRecommended.count
            }
        } else if collectionView == collectionView4 {
            if searchBar.text?.isEmpty ?? true {
                return yogaWeightLoss.count
            } else {
                return filteredYogaWeightLoss.count
            }
        }
        return 0
    }
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        if kind == UICollectionView.elementKindSectionHeader {
//            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Header", for: indexPath)
//            // Configure header view if needed
//            return headerView
//        }
//        return UICollectionReusableView()
//    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collectionView1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustumCVC1", for: indexPath) as! CustumCVC1
            let yogaItem: yogaModel
            if searchBar.text?.isEmpty ?? true {
                yogaItem = yogaData[indexPath.row]
            } else {
                yogaItem = filteredYogaData[indexPath.row]
            }
            cell.cellLable.text = yogaItem.title
            let imgurl = URL(string: yogaItem.img )
            cell.cellImgView.sd_setImage(with: imgurl)
            return cell
        } else if collectionView == collectionView2 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PopularYogaCVC", for: indexPath) as! PopularYogaCVC
            let yogaItem: yogaModel
            if searchBar.text?.isEmpty ?? true {
                yogaItem = yogaPopular[indexPath.row]
            } else {
                yogaItem = filteredYogaPopular[indexPath.row]
            }
            cell.popLableView.text = yogaItem.title
            let imgurl = URL(string: yogaItem.img )
            cell.popImgView.sd_setImage(with: imgurl)
            return cell
        } else if collectionView == collectionView3 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecommendedCVC", for: indexPath) as! RecommendedCVC
            let yogaItem: yogaModel
            if searchBar.text?.isEmpty ?? true {
                yogaItem = yogaRecommended[indexPath.row]
            } else {
                yogaItem = filteredYogaRecommended[indexPath.row]
            }
            cell.recommLableView.text = yogaItem.title
            let imgurl = URL(string: yogaItem.img )
            cell.recommImgView.sd_setImage(with: imgurl)
            return cell
        } else if collectionView == collectionView4 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeightLossCVC", for: indexPath) as! WeightLossCVC
            let yogaItem: yogaModel
            if searchBar.text?.isEmpty ?? true {
                yogaItem = yogaWeightLoss[indexPath.row]
            } else {
                yogaItem = filteredYogaWeightLoss[indexPath.row]
            }
            cell.weightLableView.text = yogaItem.title
            let imgurl = URL(string: yogaItem.img )
            cell.weightImgView.sd_setImage(with: imgurl)
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
        var selectedYogaItem: yogaModel?
        var nextFiveYogaItems: [yogaModel] = []
        
        // Determine the selected yoga item based on the collectionView
        switch collectionView {
        case collectionView1:
            selectedYogaItem = searchBar.text?.isEmpty ?? true ? yogaData[indexPath.row] : filteredYogaData[indexPath.row]
            nextFiveYogaItems = getNextFiveYogaItems(from: yogaData, currentIndex: indexPath.row)
        case collectionView2:
            selectedYogaItem = searchBar.text?.isEmpty ?? true ? yogaPopular[indexPath.row] : filteredYogaPopular[indexPath.row]
            nextFiveYogaItems = getNextFiveYogaItems(from: yogaPopular, currentIndex: indexPath.row)
        case collectionView3:
            selectedYogaItem = searchBar.text?.isEmpty ?? true ? yogaRecommended[indexPath.row] : filteredYogaRecommended[indexPath.row]
            nextFiveYogaItems = getNextFiveYogaItems(from: yogaRecommended, currentIndex: indexPath.row)
        case collectionView4:
            selectedYogaItem = searchBar.text?.isEmpty ?? true ? yogaWeightLoss[indexPath.row] : filteredYogaWeightLoss[indexPath.row]
            nextFiveYogaItems = getNextFiveYogaItems(from: yogaWeightLoss, currentIndex: indexPath.row)
        default:
            break
        }

        // Ensure a selected yoga item is available
        guard let selectedYoga = selectedYogaItem else { return }

        // Navigate to the YogaVideoVC and pass the selected and next five yoga items
        let vc = storyboard?.instantiateViewController(identifier: "YogaVideoVC" ) as! YogaVideoVC
        vc.data = selectedYoga
        vc.yogaItem = nextFiveYogaItems
        navigationController?.pushViewController(vc, animated: true)
    }

    //  to get the next five yoga items
    private func getNextFiveYogaItems(from yogaArray: [yogaModel], currentIndex: Int) -> [yogaModel] {
        let startIndex = currentIndex + 1
        let endIndex = min(currentIndex + 6, yogaArray.count)
        var nextFiveItems: [yogaModel] = []
        for index in startIndex..<endIndex {
            nextFiveItems.append(yogaArray[index])
        }
        return nextFiveItems
    }
    
}


