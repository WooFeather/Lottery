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
        let observableButtonTapped: ControlEvent<Void>
        // picker의 선택값을 기준으로 singleButtonTapped
        let singleNetworkingButton: ControlEvent<Void>
    }
    
    struct Output {
        // picker 데이터
        let pickerItems: Observable<[Int]>
        // picker의 선택값 -> TextField의 text
        let pickedItem: Driver<String>
        // 네트워크통신 응답값
        let lotteryData: Observable<Lottery>
    }
    
    func transform(input: Input) -> Output {
        // 가공 데이터
        let pickedItem = PublishRelay<String>()
        let lotteryData = PublishSubject<Lottery>()
        
        input.pickerModelSelected
            .asDriver()
            .drive(with: self) { owner, array in
                let strItem = String(array[0])
                pickedItem.accept(strItem)
            }
            .disposed(by: disposeBag)
        
        input.observableButtonTapped
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(pickedItem)
            .distinctUntilChanged()
            .debug("DISTINGUISH")
            .flatMap {
                NetworkManager.shared.callLotteryAPIWithObservable(drwNo: $0)
                    .debug("NETWORK")
            }
            .debug("TAP")
            .subscribe(with: self) { owner, data in
                print("옵저버블", pickedItem)
                lotteryData.onNext(data)
            } onError: { owner, error in
                print("onError")
            } onCompleted: { owner in
                print("onCompleted")
            } onDisposed: { owner in
                print("onDisposed")
            }
            .disposed(by: disposeBag)

        
        input.singleNetworkingButton
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(pickedItem)
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: "error")
            .drive(with: self) { owner, pickedItem in
                print("싱글", pickedItem)
                // TODO: Single 및 AF로 네트워크 통신
            }
            .disposed(by: disposeBag)
        
        return Output(
            pickerItems: pickerItems,
            pickedItem: pickedItem.asDriver(onErrorJustReturn: "error"),
            lotteryData: lotteryData
        )
    }
}
