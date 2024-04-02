//
//  ShoppingViewController.swift
//  SeSACRxThreads
//
//  Created by hwijinjeong on 4/3/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class ShoppingViewController: UIViewController {
    
    let addTextField = UITextField().then {
        $0.backgroundColor = .lightGray
        $0.borderStyle = .roundedRect
    }
    
    private let addButton = UIButton(type: .system).then {
        $0.setTitle("추가", for: .normal)
        $0.backgroundColor = .black
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 10
    }
    
    private let tableView: UITableView = {
       let view = UITableView()
        view.register(ShoppingTableViewCell.self, forCellReuseIdentifier: ShoppingTableViewCell.identifier)
        view.backgroundColor = .white
        view.rowHeight = 50
        view.separatorStyle = .none
       return view
     }()
   
    var items = PublishSubject<[String]>()
    var shoppingList = [String]()
     
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        configView()
        bind()
    }
    
    func bind() {
        items
            .bind(to: tableView.rx.items(cellIdentifier: ShoppingTableViewCell.identifier, cellType: ShoppingTableViewCell.self)) { (row, element, cell) in
                
                cell.appNameLabel.text = "test \(element)"

            }
            .disposed(by: disposeBag)
        
        addButton.rx.tap
            .subscribe(with: self, onNext: { owner, _ in
                guard let newItem = owner.addTextField.text else {
                    return
                }
                owner.shoppingList.append(newItem)
                owner.items.onNext(owner.shoppingList)
                owner.addTextField.text = ""
            })
            .disposed(by: disposeBag)
        
    }
    
    private func configView() {
        view.addSubview(addTextField)
        view.addSubview(addButton)
        view.addSubview(tableView)
        
        addTextField.snp.makeConstraints {
            $0.leading.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.trailing.equalTo(addButton.snp.leading).offset(-12)
            $0.height.equalTo(40)
        }
        
        addButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.width.equalTo(60)
            $0.height.equalTo(40)
        }
        
        tableView.snp.makeConstraints {
            $0.leading.bottom.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.top.equalTo(addButton.snp.bottom).offset(20)
        }

    }
}
