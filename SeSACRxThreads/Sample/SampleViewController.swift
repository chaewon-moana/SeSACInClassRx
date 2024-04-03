//
//  SampleViewController.swift
//  SeSACRxThreads
//
//  Created by cho on 4/2/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class SampleViewController: UIViewController {

    let tableView = UITableView()
    let searchTextField = UITextField()
    let addButton = UIButton()
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()
        view.backgroundColor = .white
    }
    
    func configureLayout() {
        view.addSubview(tableView)
        view.addSubview(searchTextField)
        view.addSubview(addButton)
        
        searchTextField.snp.makeConstraints { make in
            make.trailing.equalTo(addButton.snp.leading).inset(10)
            make.top.leading.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.height.equalTo(40)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchTextField.snp.bottom)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        addButton.snp.makeConstraints { make in
            make.size.equalTo(40)
            make.top.equalTo(searchTextField)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(10)
        }
        
        addButton.setTitle("저장", for: .normal)
        addButton.setTitleColor(.black, for: .normal)
        searchTextField.placeholder = "추가할 내용을 입력해주세요"
    }
}
