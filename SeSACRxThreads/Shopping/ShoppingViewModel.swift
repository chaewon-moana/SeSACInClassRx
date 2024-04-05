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
    var dataManager = TableData.shared
    
    lazy var items = BehaviorSubject(value: dataManager.tableData)

    struct Input {
        let searchFieldText: ControlProperty<String?>
        let addButtonTap: ControlEvent<Void>
        let itemDeleted: ControlEvent<IndexPath>
        let doneTap: PublishRelay<TODO>
        let starTap: PublishRelay<TODO>
    }
    
    struct Output {
        let emptyTextField: Driver<String>
        let todo: PublishSubject<[TODO]>
    }
    
    func transform(input: Input) -> Output {
        let emptyText = BehaviorRelay(value: "")
        let todo = PublishSubject<[TODO]>()
        
        input.searchFieldText
            .orEmpty
            .distinctUntilChanged()
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .subscribe(with: self) { owner, value in
                let result = value.isEmpty ? owner.dataManager.tableData : owner.dataManager.tableData.filter { $0.todo.contains(value)}
                owner.items.onNext(result)
            }
            .disposed(by: disposeBag)
        
        input.addButtonTap
            .withLatestFrom(input.searchFieldText.orEmpty)
            .subscribe(with: self) { owner, value in
                let item = TODO(todo: value)
                owner.dataManager.tableData.append(item)
                print(TableData.shared.tableData)
               // owner.tableData.append(item)
                owner.items.onNext(owner.dataManager.tableData)
                emptyText.accept("")
            }
            .disposed(by: disposeBag)

        input.itemDeleted
            .subscribe(with: self) { owner, indexPath in
                owner.dataManager.tableData.remove(at: indexPath.row)
                owner.items.onNext(owner.dataManager.tableData)
            }
            .disposed(by: disposeBag)
        
        //TODO: 다른방법으로 처리할 수 없나?
        input.doneTap
            .subscribe(with: self, onNext: { owner, element in
                let index = owner.dataManager.tableData.firstIndex { value in
                    element.id == value.id
                } ?? 0
                owner.dataManager.tableData[index].checkBox.toggle()
                owner.items.onNext(owner.dataManager.tableData)
            })
            .disposed(by: disposeBag)
        
        input.starTap
            .subscribe(with: self) { owner, element in
                let index = owner.dataManager.tableData.firstIndex { value in
                    element.id == value.id
                } ?? 0
                owner.dataManager.tableData[index].star.toggle()
                owner.items.onNext(owner.dataManager.tableData)
            }
            .disposed(by: disposeBag)

        let result = emptyText
            .asDriver()
        
        return Output(emptyTextField: result, todo: todo)
        
    }
}
