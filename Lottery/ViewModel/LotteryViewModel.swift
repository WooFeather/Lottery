//
//  LotteryViewModel.swift
//  Lottery
//
//  Created by 조우현 on 2/24/25.
//

import Foundation
import RxSwift
import RxCocoa

final class LotteryViewModel {
    private let disposeBag = DisposeBag()
    
    // 원본 데이터
    private var pickerItems = Observable.just(Array(1...1154))
    
    struct Input {
        // picker 데이터 선택
        let pickerModelSelected: ControlEvent<[Int]>
        // picker의 선택값을 기준으로 observableButtonTapped
        // picker의 선택값을 기준으로 singleButtonTapped
    }
    
    struct Output {
        // picker 데이터
        let pickerItems: Observable<[Int]>
        // picker의 선택값 -> TextField의 text
        let pickedItem: PublishRelay<String>
        // observableButtonTapped 네트워크 통신 응답값 -> 각 label
        // singleButtonTapped 네트워크 통신 응답값 => 각 label
    }
    
    func transform(input: Input) -> Output {
        // 가공 데이터
        let pickedItem = PublishRelay<String>()
        
        input.pickerModelSelected
            .bind(with: self) { owner, array in
                let strItem = String(array[0])
                pickedItem.accept(strItem)
            }
            .disposed(by: disposeBag)
        
        return Output(
            pickerItems: pickerItems,
            pickedItem: pickedItem
        )
    }
}
