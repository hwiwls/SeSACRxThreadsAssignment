//
//  ShoppingViewModel.swift
//  SeSACRxThreads
//
//  Created by hwijinjeong on 4/5/24.
//

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
        let searchQuery: ControlProperty<String?>
    }
    
    
    // output: 추가된(+기존에 있던) 테이블뷰 아이템, 추가 버튼 클릭
    struct Output {
        let items: Driver<[ShoppingDataModel]>
        let addBtnTap: Driver<Void>
    }
}
