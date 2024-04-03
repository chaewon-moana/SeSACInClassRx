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
    var tableData = TableData.tableData
    let inputDeleteButtonTap = PublishSubject<Int>()
    
    init() {
        inputDeleteButtonTap.subscribe(with: self) { owner, index in
            owner.tableData.remove(at: index)
        }
        .disposed(by: disposeBag)
    }
}
