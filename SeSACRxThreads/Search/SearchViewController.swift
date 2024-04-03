//
//  SearchViewController.swift
//  SeSACRxThreads
//
//  Created by cho on 4/2/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class SearchViewController: UIViewController {

    private let tableView = UITableView()
    private let searchBar = UISearchBar()
    
    let disposeBag = DisposeBag()
    
    var data = ["A", "B", "C", "AB", "D"]
    
    lazy var items = BehaviorSubject(value: data)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()
    }
 
    func configureLayout() {
        view.addSubview(tableView)
        navigationItem.titleView = searchBar
        
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
