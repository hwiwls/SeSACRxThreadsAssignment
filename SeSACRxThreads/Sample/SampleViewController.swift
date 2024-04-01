//
//  SampleViewController.swift
//  SeSACRxThreads
//
//  Created by hwijinjeong on 4/1/24.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class SampleViewController: UIViewController {

    private let disposeBag = DisposeBag()
    
    private let textField = UITextField().then {
        $0.borderStyle = .roundedRect
    }
    
    private let addButton = UIButton(type: .system).then {
        $0.setTitle("추가", for: .normal)
        $0.backgroundColor = .black
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 10
    }
    
    let tableView = UITableView().then {
        $0.backgroundColor = .lightGray
    }
    
    
    private var items = BehaviorSubject<[String]>(value: ["First Item", "Second Item", "Third Item"])

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        configView()
    }
    
    func configView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        view.addSubview(addButton)
        view.addSubview(textField)
        view.addSubview(tableView)
        
        textField.snp.makeConstraints {
            $0.leading.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.trailing.equalTo(addButton.snp.leading).offset(-12)
            $0.height.equalTo(40)
        }
        
        addButton.snp.makeConstraints {
            $0.trailing.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.width.equalTo(60)
            $0.height.equalTo(40)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(textField.snp.bottom).offset(20)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        items
            .bind(to: tableView.rx.items(cellIdentifier: "Cell")) { index, item, cell in
                cell.textLabel?.text = item
            }
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard let self = self else { return }
                var currentItems = try? self.items.value()
                currentItems?.remove(at: indexPath.row)
                self.items.onNext(currentItems ?? [])
                self.tableView.deselectRow(at: indexPath, animated: true)
            })
            .disposed(by: disposeBag)
        
        addButton.rx.tap
            .bind { [weak self] in
                self?.addNewItem()
            }
            .disposed(by: disposeBag)
        
    }
    
    private func addNewItem() {
        guard let newItem = textField.text else { return }
        var currentItems = try? items.value()
        currentItems?.append(newItem)
        items.onNext(currentItems ?? [])
        textField.text = ""
    }
}
