//
//  DelegateAction.swift
//  WaterAppDemo
//
//  Created by Egor Markov on 20.12.2020.
//  Copyright © 2020 Egor Markov. All rights reserved.
//

import UIKit

//MARK: - Protocol

//  уведомление другого контроллера о своем дейстии и передача объекта (если необходимо)
protocol ActionDelegate {
    func done(source: UIViewController, data: Any?) // ОК, сохранить
}

// реализации по-умолчанию для интерфейса
extension ActionDelegate {
    func done(source: UIViewController, data: Any?) {
        fatalError("not implemented")
    }
    
}
