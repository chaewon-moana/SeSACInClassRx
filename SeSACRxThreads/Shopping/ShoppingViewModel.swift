//
//  ShoppingViewModel.swift
//  SeSACRxThreads
//
//  Created by cho on 4/3/24.
//

import Foundation
import RxSwift
import RxCocoa

/*
 struct TODO {
     let checkBox: Bool
     let todo: String
     let star: Bool
 }
 */

final class ShoppingViewModel {
    let disposeBag = DisposeBag()
    
    var tableData = [
        TODO(checkBox: false, todo: "테에스트으1", star: false),
        TODO(checkBox: false, todo: "테에스트으2", star: false),
        TODO(checkBox: false, todo: "테에스트으3", star: false)
    ]
    
    lazy var items = BehaviorRelay(value: tableData)

    let inputAddTodoText = PublishRelay<String>()
    
    init() {
        inputAddTodoText
            .distinctUntilChanged()
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe(with: self) { owner, value in
                owner.tableData.append(TODO(checkBox: false, todo: value, star: false))
                owner.items.accept(owner.tableData)
            }
            .disposed(by: disposeBag)
        
        
    }
    
    
}
