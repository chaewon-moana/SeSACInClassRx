//
//  ShoppingViewModel.swift
//  SeSACRxThreads
//
//  Created by cho on 4/3/24.
//

import Foundation
import RxSwift
import RxCocoa

final class ShoppingViewModel {
    let disposeBag = DisposeBag()

    var tableData = TableData.tableData

    lazy var items = BehaviorSubject(value: tableData)

    let inputAddTodoText = PublishSubject<String>()
    let inputAddData = PublishSubject<Void>()
    let inputCheckToggleTap = PublishRelay<Int>()
    let inputStarToggleTap = PublishRelay<Int>()
    let inputTrigger = PublishSubject<Int>()
    let inputDeleteTap = PublishSubject<Void>()
    
    let outputTextFieldValue = BehaviorRelay(value: "")
    
    init() {
        inputTrigger
            .subscribe(with: self) { owner, _ in
                owner.items.onNext(owner.tableData)
            }
            .disposed(by: disposeBag)
        
        inputAddTodoText
            .distinctUntilChanged()
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .subscribe(with: self) { owner, value in
                let result = value.isEmpty ? owner.tableData : owner.tableData.filter { $0.todo.contains(value)}
                owner.items.onNext(result)
            }
            .disposed(by: disposeBag)
        
        inputAddData
            .withLatestFrom(inputAddTodoText)
            .distinctUntilChanged()
            .subscribe(with: self) { owner, value in
                owner.tableData.append(TODO(checkBox: false, todo: value, star: false))
                owner.items.onNext(owner.tableData)
                owner.outputTextFieldValue.accept("")
            }
            .disposed(by: disposeBag)

        inputCheckToggleTap
            .subscribe(with: self) { owner, index in
                owner.tableData[index].checkBox.toggle()
                owner.items.onNext(owner.tableData)
            }
            .disposed(by: disposeBag)
        
        inputStarToggleTap
            .subscribe(with: self) { owner, index in
                owner.tableData[index].star.toggle()
                owner.items.onNext(owner.tableData)
            }
            .disposed(by: disposeBag)
    }
    
    
}
