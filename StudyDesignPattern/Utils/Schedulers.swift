//
//  Schedulers.swift
//  CWUtils
//
//  Created by iamchiwon on 09/02/2019.
//

import Foundation
import RxSwift

/**
 # (S) Schedulers
 - Author: Mephrine
 - Date: 19.12.07
 - Note: 스케쥴러 사용을 더 편하게 하기 위한 라이브러리
*/
public struct Schedulers {
    //MARK: - Serial Schedulers
    // 메인 스케쥴러 사용
    public static let main = {
        MainScheduler.instance
    }()
    
    // 비동기 이벤트 전달을 보장하지만, 인스턴스는 이미 메인 스레드에 있는 경우, 동기적으로 이벤트를 전달할 수 있음. -> 타이머 등에 사용
    public static let async = {
        MainScheduler.asyncInstance
    }()
    
    //MARK: - Concurrent Schedulers
    // Special QoS Class
   
    // priority 레벨은 user-initiated ~ utility 사이에 있음. QoS정보가 할당되지 않은 작업은 default로 처리. GCD Global Queue는 해당 레벨에서 실행됨.
    public static let `default` = {
        ConcurrentDispatchQueueScheduler(queue: DispatchQueue(label: "default", qos: .default))
    }()
    
    // 'default'와 동일
    public static let io = {
        ConcurrentDispatchQueueScheduler(queue: DispatchQueue(label: "io", qos: .default))
    }()
    
    // QoS정보가 없음을 나타냄. 환경 QoS를 추론해야 한다는 단서를 시스템에 제공. 쓰레드가 기존(legacy) API를 사용하는 경우 사용할 수 있으며, 이 경우 쓰레드가 QoS를 벗어날 수 있음.
    public static let unspecified = {
        ConcurrentDispatchQueueScheduler(queue: DispatchQueue(label: "unspecified", qos: .unspecified))
    }()
    
    
    // Primary QoS Class
    // 중요도가 높고 즉각적인 반응이 요구되는 작업을 실행할 때 사용되는 Qos. -> Global Queue지만 main-thread에서 실행되며 UI 업데이트 등에 사용
    public static let userInteractive = {
        ConcurrentDispatchQueueScheduler(queue: DispatchQueue(label: "userInteractive", qos: .userInteractive))
    }()
    
    // userInteractive와 동일
    public static let immediate = {
        ConcurrentDispatchQueueScheduler(queue: DispatchQueue(label: "immediate", qos: .userInteractive))
    }()
    
    // userInteractive에 비해 우선 순위는 낮지만, async하고 빠른 결과값을 기대할 떄 사용
    public static let userInitiated = {
        ConcurrentDispatchQueueScheduler(queue: DispatchQueue(label: "userInitiated", qos: .userInitiated))
    }()

    // userInitiated와 동일
    public static let computation = {
        ConcurrentDispatchQueueScheduler(queue: DispatchQueue(label: "computation", qos: .userInitiated))
    }()
    
    // 시간이 상대적으로 오래걸리는 작업을 위해 사용. I/O, 통신 등의 작업에서 주로 사용 -> 프로그레스바 등에서도 사용
    public static let utility = {
        ConcurrentDispatchQueueScheduler(queue: DispatchQueue(label: "utility", qos: .utility))
    }()
    
    // 유저가 인지하지도 못하는 Back단에서 실행되는 작업. utility에 비해 상대적으로 천천히 작업하는 경우 사용.
    public static let background = {
        ConcurrentDispatchQueueScheduler(queue: DispatchQueue(label: "background", qos: .background))
    }()
    
}
