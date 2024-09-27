//
//  DietVC.swift
//  YogaFinal
//
//  Created by TryCatch (students) on 07/03/24.
//

import UIKit
import SDWebImage
struct dietModel: Codable {
    var id: String
    var category: String
    var title: String
    var video_link: String
    var img: String
    var popular: String
    var you_must_try: String
    var ingredients: [String]
    var instructions: [String]
    var nutritions: [String]
    var veg : String
    
}
struct appleModel: Codable{
    var cal: String
    var img: String
}


class DietVC: UIViewController,UISearchBarDelegate {
    
    var dietData = [dietModel]()
    var recommendedDiet = [dietModel]()
    var popolarDiet = [dietModel]()
    var youMustTry = [dietModel]()

    
    var filteredDietData = [dietModel]()
       var filteredDietRecommended = [dietModel]()
       var filteredPopularDiet = [dietModel]()
       var filteredYouMustTry = [dietModel]()
    var currentCategory: String = "dinner"

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView1: UICollectionView!
    @IBOutlet weak var collectionView2: UICollectionView!
    @IBOutlet weak var collectionView3: UICollectionView!
    @IBOutlet weak var collectionView4: UICollectionView!
    @IBOutlet weak var collectionView5: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView1.register(UINib(nibName: "DietCVC", bundle: .main), forCellWithReuseIdentifier: "DietCVC")
//        collectionView2.register(UINib(nibName: "AppleCVC", bundle: .main), forCellWithReuseIdentifier: "AppleCVC")
        collectionView3.register(UINib(nibName: "allCVC", bundle: .main), forCellWithReuseIdentifier: "allCVC")
        collectionView4.register(UINib(nibName: "allCVC", bundle: .main), forCellWithReuseIdentifier: "allCVC")
        collectionView5.register(UINib(nibName: "allCVC", bundle: .main), forCellWithReuseIdentifier: "allCVC")
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
               collectionView3.reloadData()
               collectionView4.reloadData()
               collectionView5.reloadData()
           } else {
               filteredDietData = dietData.filter { $0.title.lowercased().contains(searchText.lowercased()) }
               filteredDietRecommended = recommendedDiet.filter { $0.title.lowercased().contains(searchText.lowercased()) }
               filteredPopularDiet = popolarDiet.filter { $0.title.lowercased().contains(searchText.lowercased()) }
               filteredYouMustTry = youMustTry.filter { $0.title.lowercased().contains(searchText.lowercased()) }
               
               collectionView1.reloadData()
               collectionView3.reloadData()
               collectionView4.reloadData()
               collectionView5.reloadData()
           }
       }
    

    @IBAction func dinnerBTN(_ sender: UIButton) {
        currentCategory = "dinner"
        apiCall1()
    }
    @IBAction func lunchBTN(_ sender: UIButton) {
        currentCategory = "lunch"
        apiCall1()
    }
    @IBAction func breakBTN(_ sender: UIButton) {
        currentCategory = "breakfast"
        apiCall1()
    }
    func apiCall1(){
        guard let url = URL(string: "https://mapi.trycatchtech.com/v3/yoga_app/diet_list_by_categories?category=\(currentCategory)")else{return}
        let urlrequest = URLRequest(url: url)
        URLSession.shared.dataTask(with: urlrequest) { data,response,error in
            if let error = error{
                print(error.localizedDescription)
                return
            }
            if let data = data{
                do{
                    let jsondata = try JSONDecoder().decode([dietModel].self, from: data)
                    self.dietData = jsondata
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
        guard let url = URL(string: "https://mapi.trycatchtech.com/v3/yoga_app/diet_list_by_categories?category=lunch")else{return}
        let urlrequest = URLRequest(url: url)
        URLSession.shared.dataTask(with: urlrequest) { data,response,error in
            if let error = error{
                print(error.localizedDescription)
                return
            }
            if let data = data{
                
                do{
                    
                    
                    let jsondata = try JSONDecoder().decode([dietModel].self, from: data)
                    self.recommendedDiet = jsondata
                    
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
    func apiCall5(){
        guard let url = URL(string: "https://mapi.trycatchtech.com/v3/yoga_app/you_must_try_diet")else{return}
        let urlrequest = URLRequest(url: url)
        URLSession.shared.dataTask(with: urlrequest) { data,response,error in
            if let error = error{
                print(error.localizedDescription)
                return
            }
            if let data = data{
                
                do{
                    
                    
                    let jsondata = try JSONDecoder().decode([dietModel].self, from: data)
                    self.youMustTry = jsondata
                    
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
    func apiCall6(){
        guard let url = URL(string: "https://mapi.trycatchtech.com/v3/yoga_app/diet_list_by_categories?category=dinner")else{return}
        let urlrequest = URLRequest(url: url)
        URLSession.shared.dataTask(with: urlrequest) { data,response,error in
            if let error = error{
                print(error.localizedDescription)
                return
            }
            if let data = data{
                
                do{
                    
                    
                    let jsondata = try JSONDecoder().decode([dietModel].self, from: data)
                    self.popolarDiet = jsondata
                    
                    DispatchQueue.main.async {
                        self.collectionView5.reloadData()
                    }
                }
                catch{
                    print("Error in trycatch" , error)
                }
            }
            
        }.resume()
        
    }
}




extension DietVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionView1 {
            if searchBar.text?.isEmpty ?? true {
                return dietData.count
            } else {
                return filteredDietData.count
            }
        } 
        
//        else if collectionView == collectionView2 {
//            return appleArray.count
//        }
        
        else if collectionView == collectionView3 {
            if searchBar.text?.isEmpty ?? true {
                return recommendedDiet.count
            } else {
                return filteredDietRecommended.count
            }
        } else if collectionView == collectionView4 {
            if searchBar.text?.isEmpty ?? true {
                return youMustTry.count
            } else {
                return filteredYouMustTry.count
            }
        }else if collectionView == collectionView5 {
            if searchBar.text?.isEmpty ?? true {
                return popolarDiet.count
            } else {
                return filteredPopularDiet.count
            }
        }

        return 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collectionView1{
            let cell = collectionView1.dequeueReusableCell(withReuseIdentifier: "DietCVC", for: indexPath) as! DietCVC
            let DietItem: dietModel
            if searchBar.text?.isEmpty ?? true {
                DietItem = dietData[indexPath.row]
            } else {
                DietItem = filteredDietData[indexPath.row]
            }
            cell.dietLable.text = DietItem.title
            let imgurl = URL(string: DietItem.img)
            cell.dietIMG.sd_setImage(with: imgurl)
            return cell
        }
//        if collectionView == collectionView2{
//            let cell = collectionView2.dequeueReusableCell(withReuseIdentifier: "AppleCVC", for: indexPath) as! AppleCVC
//            cell.calLabel.text = appleArray[indexPath.row].cal
//            cell.imageapple.image = UIImage(named: appleArray[indexPath.row].img) 
//            return cell
//        }
        if collectionView == collectionView3{
            let cell = collectionView3.dequeueReusableCell(withReuseIdentifier: "allCVC", for: indexPath) as! allCVC
            let DietItem: dietModel
            if searchBar.text?.isEmpty ?? true {
                DietItem = recommendedDiet[indexPath.row]
            } else {
                DietItem = filteredDietRecommended[indexPath.row]
            }
            
            cell.label.text = DietItem.title
            let imgurl = URL(string: DietItem.img)
            cell.imgview.sd_setImage(with: imgurl)
            
            return cell
        }
        if collectionView == collectionView4{
            let cell = collectionView4.dequeueReusableCell(withReuseIdentifier: "allCVC", for: indexPath) as! allCVC
            let DietItem: dietModel
            if searchBar.text?.isEmpty ?? true {
                DietItem = youMustTry[indexPath.row]
            } else {
                DietItem = filteredYouMustTry[indexPath.row]
            }
            
            cell.label.text = DietItem.title
            let imgurl = URL(string: DietItem.img)
            cell.imgview.sd_setImage(with: imgurl)
            
            return cell
        }
        if collectionView == collectionView5{
            let cell = collectionView5.dequeueReusableCell(withReuseIdentifier: "allCVC", for: indexPath) as! allCVC
            let DietItem: dietModel
            if searchBar.text?.isEmpty ?? true {
                DietItem = popolarDiet[indexPath.row]
            } else {
                DietItem = filteredPopularDiet[indexPath.row]
            }
            
            cell.label.text = DietItem.title
            let imgurl = URL(string: DietItem.img)
            cell.imgview.sd_setImage(with: imgurl)
            
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == collectionView2 {
            return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
            
        }
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 10
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == collectionView2 {
            let width = ((collectionView.frame.width - 40 ) / 3)
            let height = collectionView.frame.height - 20
            return CGSize(width: width, height: height)
            
        }
        
        let width = ((collectionView.frame.width - 30 ) / 2)
        let height = collectionView.frame.height - 20
        return CGSize(width: width, height: height)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedDiet: dietModel
        
        if collectionView == collectionView1 {
            if searchBar.text?.isEmpty ?? true {
                 selectedDiet = dietData[indexPath.row]
            } else {
                 selectedDiet = filteredDietData[indexPath.row]
            }
        } else if collectionView == collectionView3 {
            if searchBar.text?.isEmpty ?? true {
                 selectedDiet = recommendedDiet[indexPath.row]
            } else {
                 selectedDiet = filteredDietRecommended[indexPath.row]
            }
        } else if collectionView == collectionView4 {
            if searchBar.text?.isEmpty ?? true {
                 selectedDiet = youMustTry[indexPath.row]
            } else {
                 selectedDiet  = filteredYouMustTry[indexPath.row]
            }
        } else if collectionView == collectionView5 {
            if searchBar.text?.isEmpty ?? true {
                selectedDiet  = popolarDiet[indexPath.row]
            } else {
             selectedDiet  = filteredPopularDiet[indexPath.row]
            }
        } else {
            return
        }
        let vc = storyboard?.instantiateViewController(identifier: "DietVideoVC") as! DietVideoVC
        vc.data = selectedDiet
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
