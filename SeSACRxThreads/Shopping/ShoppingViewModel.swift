//
//  ShoppingViewModel.swift
//  SeSACRxThreads
//
//  Created by hwijinjeong on 4/5/24.
//

import Foundation
import RxSwift
import RxCocoa

import Foundation
import RxSwift
import RxCocoa

class ShoppingViewModel {
    
    // input: addTextField.text, 추가 버튼 클릭, tableView에서 스와이프해서 삭제, checkBtn 탭, startBtn 탭, 검색 결과
    struct Input {
        let shoppingItem: ControlProperty<String?>
        let addBtnTap: ControlEvent<Void>
        let deleteItem: ControlEvent<IndexPath>
        let starBtnTap: ControlEvent<IndexPath>
        let checkBtnTap: ControlEvent<IndexPath>
    }
    
    
    // output: 추가된(+기존에 있던) 테이블뷰 아이템
    struct Output {
        let items: Driver<[ShoppingDataModel]>
    }
    
    let disposeBag = DisposeBag()
    
    private let items = BehaviorRelay<[ShoppingDataModel]>(value: [])

    func transform(input: Input) -> Output {
        
        input.addBtnTap
            .withLatestFrom(input.shoppingItem.orEmpty)
            .filter { !$0.isEmpty }
            .map { ShoppingDataModel(name: $0, isChecked: false, isStarred: false) }
            .subscribe(with: self) { owner, newItem in
                var currentItems = owner.items.value
                currentItems.append(newItem)
                owner.items.accept(currentItems)
            }
            .disposed(by: disposeBag)
        
        input.deleteItem
            .subscribe(with: self) { owner, indexPath in
                var items = owner.items.value
                items.remove(at: indexPath.row)
                owner.items.accept(items)
            }
            .disposed(by: disposeBag)
        
        input.starBtnTap
            .subscribe(with: self) { owner, indexPath in
                var items = owner.items.value
                items[indexPath.row].isStarred.toggle()
                owner.items.accept(items)
            }
            .disposed(by: disposeBag)
        
        input.checkBtnTap
            .subscribe(with: self) { owner, indexPath in
                var items = owner.items.value
                items[indexPath.row].isChecked.toggle()
                owner.items.accept(items)
            }
            .disposed(by: disposeBag)

        
        let driveritems = items
                    .asDriver()
        
        return Output(items: driveritems)
    }
}

