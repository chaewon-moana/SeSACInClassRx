//
//  ShoppingDetailViewModel.swift
//  SeSACRxThreads
//
//  Created by cho on 4/3/24.
//

import Foundation
import RxSwift
import RxCocoa

final class ShoppingDetailViewModel {
    let disposeBag = DisposeBag()
    var dataManager = TableData.shared
    lazy var items = BehaviorSubject(value: dataManager.tableData)
    
    let inputStar = PublishRelay<Bool>()
    let inputDone = PublishRelay<Bool>()
    let inputText = PublishRelay<String>()
    let inputEdit = PublishSubject<Int>()
    
    struct Input {
        let starSwitch: PublishRelay<Bool>
        let doneSwtich: PublishRelay<Bool>
        let editText: PublishRelay<String>
        let editButtonTap: PublishRelay<TODO>
    }
    
    struct Output {
        
    }
    
    func transform(input: Input) -> Output {
        var star: Bool = false
        var done = false
        var text = ""
        Observable.zip(input.doneSwtich.asObservable(), input.starSwitch.asObservable(), input.editText.asObservable())
            .bind { value in
                star = value.0
                done = value.1
                text = value.2
                print(star, done, text)
            }
            .disposed(by: disposeBag)
        
        input.editButtonTap
            .subscribe(with: self) { owner, value in
                let index = owner.dataManager.tableData.firstIndex { item in
                    item.id == value.id
                } ?? 0
                owner.dataManager.tableData[index].star = star
                owner.dataManager.tableData[index].checkBox = done
                owner.dataManager.tableData[index].todo = text
                print(owner.dataManager.tableData)
                print("눌림확인")
            }
            .disposed(by: disposeBag)
        
       
            

//
//        input.starSwitch
//            .subscribe { value in
//                star.accept(value)
//            }
//            .disposed(by: disposeBag)
//        

        input.starSwitch
            .subscribe(with: self) { owner, value in
                print(value)
                star = value
            }
            .disposed(by: disposeBag)
       
            
//
//        input.starSwitch
//            .bind(to: star)
//            .disposed(by: disposeBag)
            
//        input.starSwitch
//            .subscribe(with: self) { owner, element in
//                print(element)
//                print(owner.dataManager.tableData.count)
//                var index = 0
//                for item in 0...owner.dataManager.tableData.count-1 {
//                    if owner.dataManager.tableData[item].id == element.id {
//                        index = item
//                    }
//                }
//                owner.dataManager.tableData[index].checkBox.toggle()
//                owner.items.onNext(owner.dataManager.tableData)
//                print(owner.dataManager.tableData)
//            }
//            .disposed(by: disposeBag)
        
        return Output()
    }
    
//    init() {
////        inputDeleteButtonTap
////            .subscribe(with: self) { owner, index in
////            owner.tableData.remove(at: index)
////            print(owner.tableData)
////            print("지워졌나,,?")
////        }
////        .disposed(by: disposeBag)
//        
//        inputDone.accept(<#T##event: Bool##Bool#>)
//        
//        inputEdit
//            .subscribe(with: self) { owner, index in
//                let data = TODO(checkBox: inputDone, todo: <#T##String#>, star: <#T##Bool#>)
//                tableData[index].checkBox
//            }
//            .disposed(by: disposeBag)
//    }
}
