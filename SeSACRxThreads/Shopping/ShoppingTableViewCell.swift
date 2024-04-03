//
//  ShoppingTableViewCell.swift
//  SeSACRxThreads
//
//  Created by cho on 4/3/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class ShoppingTableViewCell: UITableViewCell {

    let checkBox = UIButton()
    let todoLabel = UILabel()
    let starMark = UIButton()
    
    var disposeBag = DisposeBag()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(checkBox)
        contentView.addSubview(todoLabel)
        contentView.addSubview(starMark)
        
        checkBox.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.size.equalTo(40)
            make.leading.equalToSuperview().offset(12)
        }
        todoLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(checkBox.snp.trailing).offset(12)
        }
        starMark.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-12)
            make.size.equalTo(40)
        }
        checkBox.setImage(UIImage(systemName: "checkmark.square"), for: .normal) //체크되면은 checkmark.square.fill
        starMark.setImage(UIImage(systemName: "star"), for: .normal) //확인되면은 star.fill
        todoLabel.text = "테스트라벨"
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
