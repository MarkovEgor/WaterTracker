//
//  CollectionViewDrink.swift
//  WaterAppDemo
//
//  Created by Egor Markov on 20.12.2020.
//  Copyright © 2020 Egor Markov. All rights reserved.
//

import UIKit



class CollectionViewDrink: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    //MARK: - IBOutlet
    @IBOutlet weak var collectionView: UICollectionView!
     
    //MARK: - Propirties
    
    var delegateAction: ActionDelegate!
    var drinkDAO = DAODrink.current
    var drinks: Drink!
    var volume = 100
    var modelController: TableViewDrink!
    
    var drinksPage = [Page(imageName: "Water", titleName: "Water"),
                  Page(imageName: "Milk", titleName: "Milk"),
                  Page(imageName: "Tea", titleName: "Tea"),
                  Page(imageName: "Coffee", titleName: "Coffee")]
    
    private let reuseIdentifier = "Cell"
    
    
    private lazy var pageControll: UIPageControl = {
         let pc = UIPageControl()
         pc.currentPage = 0
         pc.numberOfPages = drinksPage.count
         pc.currentPageIndicatorTintColor = .white
         pc.pageIndicatorTintColor = .black
      
         return pc
     }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.isPagingEnabled = true
        setupBottonControlls()
    }
    
 
    //MARK: - IBAction
    
    @IBAction func addMlDrink(_ sender: UISegmentedControl) {
        segmentDrinkMl(sender.selectedSegmentIndex)
    }

    @IBAction func addDrinkSave(_ sender: UIButton) {
        saveDrinkCoreData()
        
    }
    
    
    //MARK: - Func
    
    private func setupBottonControlls() {
        
        let bottonControlStackView = UIStackView(arrangedSubviews: [ pageControll])
        bottonControlStackView.alignment = .fill
        bottonControlStackView.distribution = .fillEqually
        bottonControlStackView.spacing = 20
        view.addSubview(bottonControlStackView)
        bottonControlStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            bottonControlStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            bottonControlStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            bottonControlStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            bottonControlStackView.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    func segmentDrinkMl(_ index: Int) {
       
        switch index {
        case 0:
            volume = 100
        case 1:
            volume = 150
        case 2:
            volume = 200
        case 3:
            volume = 500
        default:
            volume = 100
        }
    }
    
    func saveDrinkCoreData() {
        drinks = Drink(context: drinkDAO.context) // создаем task только при сохранении (не раньше, чтобы не было лишних объектов в контексте core data)

        drinks.title = drinksPage[pageControll.currentPage].titleName
        drinks.volume = Int16(volume)
        drinkDAO.add(drinks)
        delegateAction.done(source: self, data: true)
        closeController()
       
    }
    
    // закрывает контроллер в зависимости от того, как его открыли (модально или через navigation controller)
       func closeController() {
           if presentingViewController is UINavigationController { // если открыли как контроллер без исп. стека
               dismiss(animated: true, completion: nil) // просто скрываем
           }
           else if let controller = navigationController{ // если открыли с navigation controller
               controller.popViewController(animated: true) // удалить из стека контроллеров
           }
           else {
               fatalError("can't close controller")
           }
       }
    
    
    
    
 // MARK: UICollectionViewDataSource

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return drinksPage.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CollectionViewCellDrink
        
        let drink = drinksPage[indexPath.item]
        cell.page = drink
    
        
        return cell
    }
    
    
    //   MARK:- UICollectionViewDelegateFlowLayout

     func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        segmentDrinkMl(0)
        let x = targetContentOffset.pointee.x
        pageControll.currentPage = Int(x / collectionView.frame.width)
        
    }
    
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width - 10
        
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 10)
    }

    
    
    
}


