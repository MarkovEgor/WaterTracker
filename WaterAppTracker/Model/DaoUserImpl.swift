//
//  DaoUserImpl.swift
//  WaterAppDemo
//
//  Created by Egor Markov on 20.12.2020.
//  Copyright © 2020 Egor Markov. All rights reserved.
//


import Foundation
import CoreData
import UIKit

class DaoUserImpl: CRUDUser {
    
    //MARK: - Propirties
    
    //context для работы с базой данных
    var context: NSManagedObjectContext{
        return ((UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext)!
    }
    
    //Sington
    
    var users: [User]!
    static var current = DaoUserImpl()
    private init() {
       _ = getALL()
        
    }
    
    
    //MARK: - Func
    
    //сохранения всех изменения context
    func save() {
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
    
    // получение всех объектов
    func getALL() -> [User] {
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest() // объект-контейнер для выборки данных

        do {
            users = try context.fetch(fetchRequest) // выполнение выборки (select) и присваивание в переменную items, которая хранит список справочных значений для отображения
        } catch {
            fatalError("Fetching Failed")
        }
        
        return users
    }
    
    func delete(_ user: User) {
        //удаляем
        context.delete(user)
        save()
        
    }
    
    func addUpdate(_ user: User) {
        
        // если объект не было то добавляем, если  был но изменили сохраняем
        if !users.contains(user) {
            users.append(user)
        }
        save()
    }
    
    // добавление объекта
    func update(_ item: User) {
        save()
    }
    
    
}
