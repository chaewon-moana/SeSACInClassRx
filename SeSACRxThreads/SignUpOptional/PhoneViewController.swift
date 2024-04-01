//
//  PhoneViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//
 
import UIKit
import SnapKit
import RxSwift
import RxCocoa

class PhoneViewController: UIViewController {
   
    let phoneTextField = SignTextField(placeholderText: "연락처를 입력해주세요")
    let nextButton = PointButton(title: "다음")
    let descLabel = UILabel()
    
    var defaultPhoneNumber = "010"
    
    lazy var phoneNumber = BehaviorSubject(value: defaultPhoneNumber)
    let validText = Observable.just("올바른 전화번호를 입력해주세요")
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Color.white
        
        configureLayout()
        bind()
        
    }
    
    func bind() {
        validText
            .bind(to: descLabel.rx.text)
            .disposed(by: disposeBag)
        
        phoneNumber
            .bind(to: phoneTextField.rx.text)
            .disposed(by: disposeBag)
        
        phoneTextField.rx.text.orEmpty
            .map { Int($0) ?? 0 }
            .subscribe(with: self) { owner, value in
                owner.defaultPhoneNumber = "0" + String(value)
                owner.phoneNumber.onNext(owner.defaultPhoneNumber)
            }
            .disposed(by: disposeBag)
        let textCount = phoneTextField.rx.text.orEmpty
            .map { $0.count >= 10 } //10자 이상일 때 - true
        
        textCount
            .bind(to: descLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        textCount
            .bind(with: self) { owner, value in
                owner.nextButton.backgroundColor = value ? .systemPink : .lightGray
            }
            .disposed(by: disposeBag)
        
        nextButton.rx.tap
            .bind(with: self) { owner, _ in
                let vc = NicknameViewController()
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    func configureLayout() {
        view.addSubview(phoneTextField)
        view.addSubview(nextButton)
        view.addSubview(descLabel)
         
        phoneTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(phoneTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        descLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.top.equalTo(phoneTextField.snp.bottom)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }

}
