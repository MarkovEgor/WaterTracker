//
//  CRUD.swift
//  WaterAppDemo
//
//  Created by Egor Markov on 20.12.2020.
//  Copyright © 2020 Egor Markov. All rights reserved.
//

import Foundation
import CoreData

//MARK: - Protocol
protocol CRUDDrink {
    
    var drinks: [Drink]! {get set} // хранит текущие данные из БД
    
    func getALL() -> [Drink] // получение всех объектов
    
    func delete(_ drink: Drink) // удаление объекта
    
    func add(_ drink: Drink) // добаляет или обновляет текущий объект
    
}

protocol CRUDUser {
    
    var users: [User]! {get set} // хранит текущие данные из БД
    
    func getALL() -> [User] // получение всех объектов
    
    func delete(_ user: User) // удаление объекта
    
    func addUpdate(_ user: User) // добаляет или обновляет текущий объект
}
