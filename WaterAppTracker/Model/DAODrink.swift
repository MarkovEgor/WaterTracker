//
//  DAODrink.swift
//  WaterAppDemo
//
//  Created by Egor Markov on 20.12.2020.
//  Copyright © 2020 Egor Markov. All rights reserved.
//


import UIKit
import CoreData


class DAODrink: CRUDDrink {
    
    //MARK: - Propirties
    
    //context для работы с базой данных
    var context: NSManagedObjectContext{
        return ((UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext)!
    }
    
    var drinks: [Drink]!
    
    static var current = DAODrink()
    private init() {
       getALL()
    }
    
    //MARK: - Func
    //сохранения всех изменения context
    func save() {
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
    
    // получение всех объектов
    @discardableResult  func getALL() -> [Drink] {
        let fetchRequest: NSFetchRequest<Drink> = Drink.fetchRequest() // объект-контейнер для выборки данных
        
        do {
            drinks = try context.fetch(fetchRequest) // выполнение выборки (select) и присваивание в переменную items, которая хранит список справочных значений для отображения
        } catch {
            fatalError("Fetching Failed")
        }
        
        return drinks
    }
    
    func delete(_ drink: Drink) {
        //удаляем
        context.delete(drink)
        save()
    }
    
    func add(_ drink: Drink) {
        save()
    }
}
