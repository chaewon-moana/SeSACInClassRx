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
                let doneImage = element.checkBox ? UIImage(systemName: "checkmark.square.fill") : UIImage(systemName: "checkmark.square")
                let starImage = element.star ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")
                
                cell.checkBox.setImage(doneImage, for: .normal)
                cell.starMark.setImage(starImage, for: .normal)
                cell.todoLabel.text = element.todo
                print(element)
        
                cell.checkBox.rx.tap
                    .subscribe(with: self, onNext: { owner, _ in
                        owner.viewModel.inputCheckToggleTap.accept(row)
                    })
                    .disposed(by: cell.disposeBag)
                
                cell.starMark.rx.tap
                    .subscribe(with: self, onNext: { owner, _ in
                        owner.viewModel.inputStarToggleTap.accept(row)
                    })
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .subscribe(with: self) { owner, indexPath in
                let vc = ShoppingDetailViewController()
                vc.todo = owner.viewModel.tableData[indexPath.item]
                vc.index = indexPath.item
                owner.present(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
        searchTextField.rx.text.orEmpty
            .bind(to: viewModel.inputAddTodoText)
            .disposed(by: disposeBag)
        
        addButton.rx.tap
            .bind(to: viewModel.inputAddData)
            .disposed(by: disposeBag)
        
        viewModel.outputTextFieldValue
            .bind(to: searchTextField.rx.text)
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
