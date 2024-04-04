//
//  ShoppingTableViewCell.swift
//  SeSACRxThreads
//
//  Created by hwijinjeong on 4/3/24.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class ShoppingTableViewCell: UITableViewCell {

    static let identifier = "ShoppingTableViewCell"
    
    var disposeBag = DisposeBag()
    
    let appNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    let checkBtn = UIButton().then {
        $0.setImage(UIImage(systemName: "checkmark.square")?.withRenderingMode(.alwaysOriginal).withTintColor(.black), for: .normal)
    }
    
    let starBtn = UIButton().then {
        $0.setImage(UIImage(systemName: "star")?.withRenderingMode(.alwaysOriginal).withTintColor(.black), for: .normal)
    }
     
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .lightGray
        
        self.selectionStyle = .none
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16))
        
        contentView.layer.cornerRadius = 10
    }
    
    private func configure() {
        contentView.addSubview(appNameLabel)
        contentView.addSubview(checkBtn)
        contentView.addSubview(starBtn)
        
        checkBtn.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(20)
            $0.size.equalTo(20)
        }
        
        appNameLabel.snp.makeConstraints {
            $0.centerY.equalTo(checkBtn)
            $0.leading.equalTo(checkBtn.snp.trailing).offset(20)
            $0.trailing.equalTo(starBtn.snp.leading).offset(-8)
        }
        
        starBtn.snp.makeConstraints {
            $0.centerY.equalTo(checkBtn)
            $0.trailing.equalToSuperview().inset(20)
            $0.size.equalTo(20)
        }
    }

}
