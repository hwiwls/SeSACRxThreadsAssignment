//
//  SearchViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2024/04/01.
//

import UIKit
import RxSwift
import RxCocoa

class SearchViewController: UIViewController {
   
    private let tableView: UITableView = {
       let view = UITableView()
        view.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.identifier)
        view.backgroundColor = .white
        view.rowHeight = 180
        view.separatorStyle = .none
       return view
     }()
    
    let searchBar = UISearchBar()
      
    var data = ["A", "B", "C", "AB", "D", "ABC", "BBB", "EC", "SA", "AAAB", "ED", "F", "G", "H"]
   
    lazy var items = BehaviorSubject(value: data)
     
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        configure()
        setSearchController()
        bind()
    }
    
    func bind() {
        items   // subscribe도 상괸 없음
            .bind(to: tableView.rx.items(cellIdentifier: SearchTableViewCell.identifier, cellType: SearchTableViewCell.self)) { (row, element, cell) in
                
                cell.appNameLabel.text = "test \(element)"
                cell.appIconImageView.backgroundColor = .systemBlue
                
                cell.downloadButton.rx.tap
                    .bind(with: self) { owner, _ in
                        owner.navigationController?.pushViewController(BirthdayViewController(), animated: true)
                    }
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
        
        Observable.zip(tableView.rx.itemSelected, tableView.rx.modelSelected(String.self))
            .bind(with: self) { owner, value in
                print(value.0, value.1)
                
                owner.data.remove(at: value.0.row)
                owner.items.onNext(owner.data)
            }
            .disposed(by: disposeBag)
        
        searchBar
            .rx
            .text
            .orEmpty
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(with: self) { owner, value in
                print("search: \(value)")
                
                let result = value.isEmpty ? owner.data : owner.data.filter { $0.contains(value) }
                owner.items.onNext(result)
            }
            .disposed(by: disposeBag)
        
        // 버튼을 탭 했을 때에도 이런식으로 사용
        searchBar.rx.searchButtonClicked    // Void 타입의 요소를 방출하는 Observable
            .withLatestFrom(searchBar.rx.text.orEmpty)  // 서치바에 작성된 것 중에서 마지막 거
            .distinctUntilChanged() // 여러 번 눌러도 검색 안되게끔
            .subscribe(with: self, onNext: { owner, value in
                print("search btn clicked: \(value)")
                let result = value.isEmpty ? owner.data : owner.data.filter { $0.contains(value) }
                owner.items.onNext(result)
            })
            .disposed(by: disposeBag)
    }
     
    private func setSearchController() {
        view.addSubview(searchBar)
        navigationItem.titleView = searchBar
        
//        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "추가", style: .plain, target: self, action: #selector(plusButtonClicked))
    }
    
    @objc func plusButtonClicked() {
        let sample = ["A", "B", "C", "D", "E"]
        
        data.append(sample.randomElement()!)
        
        items.onNext(data)

    }

    
    private func configure() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }

    }
}
