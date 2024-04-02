//
//  BirthdayViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//
 
import UIKit
import SnapKit
import RxSwift
import RxCocoa

class BirthdayViewController: UIViewController {
    
    let birthDayPicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .wheels
        picker.locale = Locale(identifier: "ko-KR")
        picker.maximumDate = Date()
        return picker
    }()
    
    let infoLabel: UILabel = {
       let label = UILabel()
        label.textColor = Color.black
        label.text = "만 17세 이상만 가입 가능합니다."
        return label
    }()
    
    let containerStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.spacing = 10 
        return stack
    }()
    
    let yearLabel: UILabel = {
       let label = UILabel()
        label.textColor = Color.black
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }()
    
    let monthLabel: UILabel = {
       let label = UILabel()
        label.textColor = Color.black
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }()
    
    let dayLabel: UILabel = {
       let label = UILabel()
        label.textColor = Color.black
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }()

    let nextButton = PointButton(title: "가입하기")
    
    let disposeBag = DisposeBag()
    
    let yearData = BehaviorSubject(value: 8888)//PublishSubject<Int>()
    let monthData = BehaviorSubject(value: 88)
    let dayData = BehaviorSubject(value: 88)
        
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.white
        configureLayout()
        bind()
    }
    
    func bind() {
        birthDayPicker.rx.date
            .bind(with: self) { owner, date in
                print(date)
                let component = Calendar.current.dateComponents([.year, .month, .day], from: date)
                owner.yearData.onNext(component.year!)
                owner.monthData.onNext(component.month!)
                owner.dayData.onNext(component.day!)
            }
            .disposed(by: disposeBag)

        yearData
            .map { "\($0)년" }
            .bind(to: yearLabel.rx.text)
            .disposed(by: disposeBag)
        
        monthData
            .map { "\($0)월" }
            .bind(to: monthLabel.rx.text)
            .disposed(by: disposeBag)
        
        dayData
            .map { "\($0)일" }
            .bind(to: dayLabel.rx.text)
            .disposed(by: disposeBag)
        nextButton.rx.tap
            .subscribe(with: self) { owner, _ in
                print("가입완료")
            }
            .disposed(by: disposeBag)
        
        let validFlag = Observable.combineLatest(yearData, monthData, dayData) { year, month, day in //만 17세이상이면 true
            let today = Date()
            let todayYear = Calendar.current.component(.year, from: Date())
            let todayMonth = Calendar.current.component(.month, from: Date())
            let todayDay = Calendar.current.component(.day, from: Date())
            print(todayYear, todayMonth, todayDay, year, month, day)
            let checkAge = year + 17 // 2000년생이면 2017년에 만 17세 되는,,, 2007년생,,,
                
            if checkAge < todayYear {
                return true
            } else if checkAge == todayYear {
                if month < todayMonth {
                    return true
                } else if month == todayMonth {
                    if day > todayDay { //생일이 3일애가 4월 2일에는 미성년자
                        return false
                    } else {
                        return true
                    }
                } else {
                    return false
                }
            } else {
                return false
            }
        }
        
        validFlag
            .bind(with: self) { owner, value in
                owner.infoLabel.textColor = value ? .blue : .red
                owner.nextButton.backgroundColor = value ? .blue : .lightGray
                owner.infoLabel.text = value ? "가입 가능한 나이입니다." : "만 17세 이상만 가입 가능합니다."
            }
            .disposed(by: disposeBag)
        
        validFlag
            .bind(to: nextButton.rx.isEnabled)

    }

    func configureLayout() {
        view.addSubview(infoLabel)
        view.addSubview(containerStackView)
        view.addSubview(birthDayPicker)
        view.addSubview(nextButton)
 
        infoLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(150)
            $0.centerX.equalToSuperview()
        }
        
        containerStackView.snp.makeConstraints {
            $0.top.equalTo(infoLabel.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
        }
        
        [yearLabel, monthLabel, dayLabel].forEach {
            containerStackView.addArrangedSubview($0)
        }
        
        birthDayPicker.snp.makeConstraints {
            $0.top.equalTo(containerStackView.snp.bottom)
            $0.centerX.equalToSuperview()
        }
   
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(birthDayPicker.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }

}
