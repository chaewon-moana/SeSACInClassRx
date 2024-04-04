//
//  ShoppingDetailViewController.swift
//  SeSACRxThreads
//
//  Created by cho on 4/3/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa


final class ShoppingDetailViewController: UIViewController {

    let disposeBag = DisposeBag()
    let viewModel = ShoppingDetailViewModel()
    
    let todoTextField = UITextField()
    let starLabel = UILabel()
    let starMark = UISwitch()
    let checkLabel = UILabel()
    let checkDone = UISwitch()
    let editButton = UIButton()
    let deleteButton = UIButton()
    
    var todo: TODO = TODO(checkBox: false, todo: "", star: false)
    var index = 0
    var delegate: TableViewReload?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureView()
        bind()
    }
    
    private func bind() {
        deleteButton.rx.tap
            .subscribe(with: self, onNext: { owner, _ in
                owner.viewModel.inputDeleteButtonTap.onNext(owner.index)
                owner.dismiss(animated: true)
                owner.delegate?.tableViewReloadData(index: owner.index)
            })
            .disposed(by: disposeBag)
    }
    
    private func configureView() {
        view.addSubview(todoTextField)
        view.addSubview(starLabel)
        view.addSubview(starMark)
        view.addSubview(checkDone)
        view.addSubview(checkLabel)
        view.addSubview(editButton)
        view.addSubview(deleteButton)
        
        editButton.snp.makeConstraints { make in
            make.width.equalTo(60)
            make.height.equalTo(32)
            make.centerY.equalTo(todoTextField)
            make.trailing.equalTo(todoTextField.snp.trailing).offset(-8)
        }
        todoTextField.snp.makeConstraints { make in
            make.height.equalTo(60)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(12)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(50)
        }
        starLabel.snp.makeConstraints { make in
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.top.equalTo(todoTextField.snp.bottom).offset(30)
        }
        starMark.snp.makeConstraints { make in
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.top.equalTo(todoTextField.snp.bottom).offset(30)
            
        }
        checkLabel.snp.makeConstraints { make in
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.top.equalTo(starLabel.snp.bottom).offset(30)
        }
        checkDone.snp.makeConstraints { make in
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.top.equalTo(starLabel.snp.bottom).offset(30)
        }
        deleteButton.snp.makeConstraints { make in
            make.bottom.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(40)
        }
        todoTextField.backgroundColor = .systemGray6
        todoTextField.text = todo.todo
        editButton.setTitle("수정", for: .normal)
        editButton.setTitleColor(.black, for: .normal)
        editButton.backgroundColor = .systemGray4
        starLabel.text = "즐겨찾기"
        starMark.isOn = todo.star
        checkLabel.text = "완료"
        checkDone.isOn = todo.checkBox
        deleteButton.backgroundColor = .red
        deleteButton.setTitle("삭제", for: .normal)
    }
}
