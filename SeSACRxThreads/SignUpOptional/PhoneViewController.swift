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
    
    let disposeBag = DisposeBag()
   
    let phoneTextField = SignTextField(placeholderText: "연락처를 입력해주세요")
    let nextButton = PointButton(title: "다음")
    
    let internationalNum = BehaviorSubject(value: "010")
    
    let descriptionLabel = UILabel()
    
    let validText = Observable.just("숫자를 10자 이상 입력해야 합니다")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Color.white
        
        configureLayout()
        
        nextButton.addTarget(self, action: #selector(nextButtonClicked), for: .touchUpInside)
        
        bind()
    }
    
    @objc func nextButtonClicked() {
        navigationController?.pushViewController(NicknameViewController(), animated: true)
    }
    
    func bind() {
        internationalNum
            .bind(to: phoneTextField.rx.text)
            .disposed(by: disposeBag)
        
        validText
            .bind(to: descriptionLabel.rx.text)
            .disposed(by: disposeBag)
        
        // 텍스트 필드에 숫자만 입력되도록 필터링
        let numberInput = phoneTextField.rx.text.orEmpty
            .map { $0.filter { $0.isNumber } }
            .share(replay: 1)   // 최신 상태 유지
        
        numberInput
            .bind(to: phoneTextField.rx.text)
            .disposed(by: disposeBag)
        
        let validation = numberInput
            .map { $0.count > 10 }
        
        validation
            .bind(to: nextButton.rx.isEnabled, descriptionLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        validation
            .bind(with: self) { owner, value in
                let color: UIColor = value ? .systemPink : .lightGray
                owner.nextButton.backgroundColor = color
            }
            .disposed(by: disposeBag)
        
        nextButton
            .rx
            .tap
            .bind(with: self) { owner, _ in
                print("show alert")
            }
            .disposed(by: disposeBag)
            
    }

    
    func configureLayout() {
        view.addSubview(phoneTextField)
        view.addSubview(descriptionLabel)
        view.addSubview(nextButton)
         
        phoneTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(phoneTextField.snp.bottom).offset(4)
            make.trailing.equalTo(phoneTextField.snp.trailing)
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(phoneTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }

}
