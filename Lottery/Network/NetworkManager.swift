//
//  NetworkManager.swift
//  Lottery
//
//  Created by 조우현 on 2/24/25.
//

import Foundation
import RxSwift
import RxCocoa

final class NetworkManager {
    static let shared = NetworkManager()
    
    private init() { }
    
    func callLotteryAPIWithObservable(drwNo: String) -> Observable<Lottery> {
        return Observable<Lottery>.create { value in
            
            let urlString = "https://www.dhlottery.co.kr/common.do?method=getLottoNumber&drwNo=\(drwNo)"
            
            guard let url = URL(string: urlString) else {
                value.onError(APIError.invalidURL)
                return Disposables.create {
                    print("🗑️ Disposed")
                }
            }
            
            print("URL", url)
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                if error != nil {
                    value.onError(APIError.unknownResponse)
                    return
                }
                
                guard let response = response as? HTTPURLResponse,
                      (200...299).contains(response.statusCode) else {
                    value.onError(APIError.statusError)
                    return
                }
                
                guard let data = data else {
                    return value.onError(APIError.unknownResponse)
                }
                
                do {
                    let result = try JSONDecoder().decode(Lottery.self, from: data)
                    value.onNext(result)
                    value.onCompleted()
                } catch {
                    value.onError(APIError.unknownResponse)
                }
            }.resume()
            
            return Disposables.create {
                print("🗑️ Disposed")
            }
        }
    }
}
