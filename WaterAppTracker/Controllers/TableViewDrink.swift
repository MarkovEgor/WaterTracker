//
//  TableViewDrink.swift
//  WaterAppDemo
//
//  Created by Egor Markov on 20.12.2020.
//  Copyright © 2020 Egor Markov. All rights reserved.
//

import UIKit

class TableViewDrink: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: - IBOutlet 
    @IBOutlet weak var conternerViewProgress: CircularProgressView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var tableViewCustom: UITableView!
    
    //MARK: - Propirties
    var profileImageView: UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 36, height: 36))
    var countFired: CGFloat = 0
    var timer: Timer?
    var drinksDAO = DAODrink.current
    var volumeDrink = 0
    
    var user: User!
    var userDAO = DaoUserImpl.current
    
    private let reuseIdentifier = "Cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for user in userDAO.getALL() {
            self.user = user
        }
        setupNavigationBar()
        tableViewCustom.delegate = self
        tableViewCustom.dataSource = self
        topView.layer.cornerRadius = 10
        volumeDrinkUpdate()
    }
    
    
    //MARK: - Func
    
    func setupNavigationBar() {
        
        profileImageView.isUserInteractionEnabled = true
        let gettureRecognizer = UITapGestureRecognizer()
        gettureRecognizer.addTarget(self, action: #selector(showMiracle))
        profileImageView.addGestureRecognizer(gettureRecognizer)
        
        let conteinerView = UIView(frame: CGRect(x: 0, y: 0, width: 36, height: 36))
        profileImageView.layer.cornerRadius = 18
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.clipsToBounds = true
        conteinerView.addSubview(profileImageView)
        
        let rightBarItem = UIBarButtonItem(customView: conteinerView)
        navigationItem.rightBarButtonItem = rightBarItem
        
        if let imageProfile = user?.image {
            profileImageView.image = UIImage(data: imageProfile)
        }else{
            profileImageView.image = UIImage(named: "user")
        }
        
    }
    
    @objc func showMiracle() {
        let slideVC = OverlayViewViewController()
        if user != nil{
            slideVC.user = user
            slideVC.delegateAction = self
        }else{
            slideVC.user = User(context: userDAO.context)
            slideVC.delegateAction = self
        }
        slideVC.modalPresentationStyle = .custom
        slideVC.transitioningDelegate = self
        self.present(slideVC, animated: true, completion: nil)
    }
    
    
    func volumeDrinkUpdate() {
        for volume in self.drinksDAO.drinks {
            self.volumeDrink += Int(volume.volume)
        }
        if timer == nil {
            let timer = Timer.scheduledTimer(withTimeInterval: 0.15, repeats: true) { (timer) in
                self.countFired += 1
                DispatchQueue.main.async {
                    self.conternerViewProgress.progress = min(0.3 * self.countFired,  CGFloat(self.volumeDrink / 100))
                    if self.conternerViewProgress.progress == CGFloat(self.volumeDrink) {
                        timer.invalidate()
                        self.timer = nil
                    }
                }
            }
            
            RunLoop.current.add(timer, forMode: .common)
            timer.tolerance = 0.1
            
            self.timer = timer
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == nil {
            return
        }
        
        switch segue.identifier {
            
        case "cellNewDrink":
            
            guard let controller = segue.destination as? CollectionViewDrink else {fatalError("Error")}
            controller.delegateAction = self
            
        default:
            return
        }
    }

    
    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return drinksDAO.drinks.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! TableViewCellDrink
        let drink = drinksDAO.drinks[indexPath.row]
        cell.layer.cornerRadius = 10
        cell.drink = drink
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
       
        if drinksDAO.drinks.count != 0 {
        return "History"
        }
       
        return nil
    }
    
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        // For Header Text Color
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = .white
        
    }
    
    
    //MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            drinksDAO.delete(drinksDAO.drinks[indexPath.row])
            
            drinksDAO.drinks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            volumeDrink = 0
            volumeDrinkUpdate()
        }
        
        tableView.reloadData()
        
    }

    
    
}

//MARK: - Extension
extension TableViewDrink: ActionDelegate {
    func done(source: UIViewController, data: Any?) {
        if source is CollectionViewDrink {
            let drink = data as! Bool
            _ = drinksDAO.getALL()
            if drink == true {
            tableViewCustom.reloadData()
            volumeDrink = 0
            volumeDrinkUpdate()
          }
        }
        
        if source is OverlayViewViewController {
           let user = data as! User
           userDAO.addUpdate(user)
           for user in userDAO.getALL() {
               self.user = user
           }
           setupNavigationBar()
        }
    
    }
}

//MARK: - Extension
extension TableViewDrink: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        PresentationController(presentedViewController: presented, presenting: presenting)
    }
}
