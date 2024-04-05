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
    
    var todo: TODO = TODO(todo: "")
    var delegate: TableViewReload?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureView()
        bind()
    }
    
    private func bind() {
        var editText = PublishRelay<String>()
        var item = PublishRelay<TODO>()
        var starSwitch = PublishRelay<Bool>()
        var doneSwitch = PublishRelay<Bool>()

        let input = ShoppingDetailViewModel.Input(starSwitch: starSwitch,
                                                  doneSwtich: doneSwitch,
                                                  editText: editText,
                                                  editButtonTap: item
        )
    
        let output = viewModel.transform(input: input)
        
        editButton.rx.tap
            .bind(with: self, onNext: { owner, _ in
                item.accept(owner.todo)
                editText.accept(owner.todoTextField.text ?? "")
                owner.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
        
        starMark.rx.isOn
            .bind(to: starSwitch)
            .disposed(by: disposeBag)
        
        checkDone.rx.isOn
            .bind(to: doneSwitch)
            .disposed(by: disposeBag)
//        starMark.rx.isOn
//            .bind(to: starSwitch)
//            .disposed(by: disposeBag)
//        
//        
        
//        starMark.rx.isOn
//            .subscribe(with: self) { owner, _ in
//                starSwitch.accept(owner.todo)
//            }
//            .disposed(by: disposeBag)
        
//        checkDone.rx.isOn
//            .subscribe(with: self, onNext: { owner, _ in
//                doneSwitch.accept(owner.todo)
//            })
//            .disposed(by: disposeBag)
//        
//        editButton.rx.tap
//            .subscribe(with: self) { owner, _ in
//                owner.viewModel.inputText.accept(owner.todoTextField.text!)
//              //  owner.viewModel.inputEdit.onNext(owner.index)
//            }
//            .disposed(by: disposeBag)
    }
    
    private func configureView() {
        view.addSubview(todoTextField)
        view.addSubview(starLabel)
        view.addSubview(starMark)
        view.addSubview(checkDone)
        view.addSubview(checkLabel)
        view.addSubview(editButton)
        view.addSubview(deleteButton)
        
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
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(70)
            make.width.equalTo(130)
            make.centerX.equalTo(view.safeAreaLayoutGuide).offset(-70)
        }
        editButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(70)
            make.width.equalTo(130)
            make.centerX.equalTo(view.safeAreaLayoutGuide).offset(70)
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
