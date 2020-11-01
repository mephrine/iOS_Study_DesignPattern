//
//  CustomProvider.swift
//  StudyDesignPattern
//
//  Created by Mephrine on 2020/11/01.
//

import Moya
import RxSwift
import Alamofire

/**
 # (C) CustomProvider.swift
 - Author: Mephrine
 - Date: 20.02.18
 - Note: Moya 네트워크 통신을 담당하는 Provider를 커스터마이징한 클래스. 로딩뷰 관련 처리
*/
class CustomProvider<T: TargetType>: MoyaProvider<T>{
    // StubClosure => Unit Test에서 주로 사용되며, 클로저를 추가할 경우, API를 타지 않고 sample data에서 json을 꺼내와서 사용할 수 있음.
    init(stubClosure: @escaping StubClosure = MoyaProvider.neverStub) {
        // Network 시작 / 종료에 관한 처리를 하는 클로저
        let networkClosure = { (_ change: NetworkActivityChangeType, _ target: TargetType) in
            switch change {
            case .began:
                // 로딩뷰 시작
                break
            case .ended:
                // 로딩뷰 종료
                break
            }
        }
        
        // Configuration 관련 커스텀
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = HTTPHeaders.default.dictionary
        
        //
        let session = Session(configuration: configuration, startRequestsImmediately: false)
        
        super.init(stubClosure: stubClosure,
                   session: session,
                   plugins: [APILoggingPlugin(),
                             NetworkActivityPlugin(networkActivityClosure: networkClosure)])
    }
}

extension Reactive where Base: CustomProvider<CallAPI> {
    /**
     # request
     - Author: Mephrine
     - Date: 20.01.16
     - Parameters:
         - token: MoyaProvider에 의해 필요한 사양(enum 케이스)을 제공하는 Entity.
         - callbackQueue: Callback queue. nil인 경우, provider initializer의 큐가 사용됨.
     - Returns: Single<Response>
     - Note: Moya를 통해 Network 통신을 하고 callbackqueue를 받은 것을 처리하는 Single 생성
    */
    internal func request(_ token: Base.Target, callbackQueue: DispatchQueue? = nil) -> Single<Response> {
        return Single.create { [weak base] single in
            let cancellableToken = base?.request(token, callbackQueue: callbackQueue) { result in
                switch result {
                case let .success(response):
                    single(.success(response))
                    break
                case let .failure(error):
                    single(.error(error))
                    break
                }
            }
            return Disposables.create {
                cancellableToken?.cancel()
            }
        }.timeout(.seconds(30), scheduler: Schedulers.async)
    }
}

