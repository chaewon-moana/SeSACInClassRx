//
//  ShoppingViewController.swift
//  SeSACRxThreads
//
//  Created by cho on 4/3/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class ShoppingViewController: UIViewController {
    
    let tableView = UITableView()
    let searchTextField = UITextField()
    let addButton = UIButton()
    
    let viewModel = ShoppingViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        bind()
        view.backgroundColor = .white
        navigationItem.title = "쇼핑"
        tableView.register(ShoppingTableViewCell.self, forCellReuseIdentifier: "ShoppingTableViewCell")
    }
    
    private func bind() {
        viewModel.items
            .bind(to: tableView.rx.items(cellIdentifier: "ShoppingTableViewCell", cellType: ShoppingTableViewCell.self)) { (row, element, cell) in
                let doneImage = element.checkBox ? UIImage(systemName: "checkmark.square") : UIImage(systemName: "checkmark.square.fill")
                let starImage = element.star ? UIImage(systemName: "star") : UIImage(systemName: "star.fill")
                
                cell.checkBox.setImage(doneImage, for: .normal)
                cell.starMark.setImage(starImage, for: .normal)
                cell.todoLabel.text = element.todo
            }
            .disposed(by: disposeBag)
        
        searchTextField.rx.text.orEmpty
            .bind(to: viewModel.inputAddTodoText)
            .disposed(by: disposeBag)
    }
    
    private func configureView() {
        view.addSubview(tableView)
        view.addSubview(searchTextField)
        view.addSubview(addButton)
        
        searchTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.horizontalEdges.top.equalTo(view.safeAreaLayoutGuide).inset(12)
        }
        addButton.snp.makeConstraints { make in
            make.width.equalTo(60)
            make.height.equalTo(32)
            make.centerY.equalTo(searchTextField)
            make.trailing.equalTo(searchTextField.snp.trailing).offset(-8)
        }
        tableView.snp.makeConstraints { make in
            make.bottom.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(12)
            make.top.equalTo(searchTextField.snp.bottom).offset(12)
        }
        
        searchTextField.placeholder = "구매하실 목록을 추가해주세요"
        searchTextField.backgroundColor = .systemGray6
        searchTextField.layer.cornerRadius = 8
        
        addButton.setTitle("추가", for: .normal)
        addButton.setTitleColor(.black, for: .normal)
        addButton.backgroundColor = .systemGray4
        addButton.layer.cornerRadius = 8
        
        tableView.rowHeight = 80
    }
    
    
}
