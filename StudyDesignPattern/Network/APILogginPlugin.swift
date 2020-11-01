//
//  APILogginPlugin.swift
//  StudyDesignPattern
//
//  Created by Mephrine on 2020/10/26.
//

import Foundation
import Moya

/**
   # (C) APILoggingPlugin
   - Author: Mephrine
   - Date: 20.02.18
   - Note: API 통신 간의 커스텀 로깅을 위한 클래스
   */
final class APILoggingPlugin: PluginType {
    /**
     # willSend
     - Author: Mephrine
     - Date: 20.02.17
     - Parameters:
        - request : Request 타입 (URLRequest)
        - target : Target 타입 (CallAPI에 정의된 내용)
     - Returns:
     - Note: API를 보내기 직전에 호출 - URL, header, path등
     */
    func willSend(_ request: RequestType, target: TargetType) {
        if !SHOWING_DEBUG_REQUEST_API_LOG { return }
        let headers = request.request?.allHTTPHeaderFields ?? [:]
        let urlStr = request.request?.url?.absoluteString ?? "nil"
        let path = urlStr.replacingOccurrences(of: "\(API_DOMAIN)", with: "")
        if let body = request.request?.httpBody {
            let bodyString = String(bytes: body, encoding: .utf8) ?? "nil"
            //            Logger.i(#"*****willSend*****\n \#(body)"#)
            let message: String = """
            ############
            <willSend - \(path) - \(Date().debugDescription)>
            url: \(urlStr)
            headers: \(headers)
            body: \(bodyString)
            ############
            """
            log.i(message)
        } else {
            let message: String = """
            ############
            <willSend - \(path) - \(Date().debugDescription)>
            url: \(urlStr)
            headers: \(headers)
            body: nil
            ############
            """
            log.i(message)
        }
    }
    
    /**
     # willSend
     - Author: Mephrine
     - Date: 20.02.17
     - Parameters:
        - result : Network 통신 결과 response값
        - target : Target 타입 (CallAPI에 정의된 내용)
     - Returns:
     - Note: API를 통해 받은 데이터 처리
     */
    func didReceive(_ result: Result<Moya.Response, MoyaError>, target: TargetType) {
        
        if !SHOWING_DEBUG_RECEIVE_API_LOG { return }
        
        switch result {
        case .success(let response):
            let request = response.request
            let urlStr = request?.url?.absoluteString ?? "nil"
            let method = request?.httpMethod ?? "nil"
            let statusCode = response.statusCode
            
            var bodyString = "nil"
            if let data = request?.httpBody,
                let string = String(bytes: data, encoding: .utf8) {
                bodyString = string
            }
            var responseString = "nil"
            let data = response.data
            if let responseStr = String(bytes: data, encoding: .utf8) {
                responseString = responseStr
            }
            let message: String = """
            🤩🤩🤩🤩🤩🤩
            <didReceive - \(method)
            statusCode: \(statusCode)>
            url: \(urlStr)
            body: \(bodyString)
            response: \(responseString)
            🤩🤩🤩🤩🤩🤩
            """
            log.i(message)
        case .failure(let error):
            let message: String = """
            🤩🤩🤩🤩🤩🤩
            <didReceive -
            error: \(error.localizedDescription)
            🤩🤩🤩🤩🤩🤩
            """
            log.i(message)
        }
        
        
        
        
        
    }
}



