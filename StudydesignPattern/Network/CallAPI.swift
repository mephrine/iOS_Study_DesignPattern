//
//  CallAPI.swift
//  StudyDesignPattern
//
//  Created by Mephrine on 2020/10/26.
//

import Alamofire
import Moya
import RxSwift
import SwiftyJSON

public protocol ALSwiftyJSONAble {
    init?(jsonData:JSON)
}

/**
# (E) APIError
- Author: Mephrine
- Date: 20.07.12
- Note: API Error 모음
*/
enum APIError: Error {
    case noData
    
    var desc: String? {
        switch self {
        case .noData:
            return "Error : NoData"
        }
    }
}

// API Log
let SHOWING_DEBUG_REQUEST_API_LOG    = false
let SHOWING_DEBUG_RECEIVE_API_LOG    = false

// Domain
let API_DOMAIN               = "https://dapi.kakao.com"

// Page Count
let PAGE_COUNT               = 25

/**
 # (E) CallAPI.swift
 - Author: Mephrine
 - Date: 20.06.22
 - Note: 사용할 API enum으로 관리.
*/
// MARK: - Enum
enum CallAPI {
    case searchBlog(query: String, sort: String, page: Int)     // 유저검색
    case searchCafe(query: String, sort: String, page: Int)    // 유저 정보 조회
}

// MARK: Extension CallAPI
extension CallAPI: TargetType, AccessTokenAuthorizable {
    // 각 case의 도메인
    var baseURL: URL {
        switch self {
        default:
            return URL(string: API_DOMAIN)!
        }
    }
    
    // 각 case의 URL Path
    var path: String {
        switch self {
        case .searchBlog(_:_:_:):
            return "/v2/search/blog"
        case .searchCafe(_:_:_:):
            return "/v2/search/cafe"
        }
    }
    
    var task: Task {
        return .requestParameters(parameters: parameters ?? [:], encoding: parameterEncoding)
    }
    
    // 각 case의 메소드 타입 get / post
    var method: Moya.Method {
        switch self {
        default:
            return .get
        }
    }
    
    // 테스트용도로 제공하는 데이터. 로컬에 json파일 넣고 해당 파일명으로 설정해주면 사용 가능. - Unit Test시 사용
    var sampleData: Data {
        return stubbedResponseFromJSONFile(filename: "object_response")
    }
    
    // 헤더에 추가할 내용 정의
    var headers: [String: String]? {
        switch self {
        default :
            return ["Authorization": "KakaoAK c12de4cb2f877c3ae8773020d5ffba9a"]
        }
    }
    
    // 파라미터
    var parameters: [String: Any]? {
        switch self {
        case .searchCafe(let query, let sort, let page), .searchBlog(let query, let sort, let page):
            return ["query": query, "sort": sort, "page": page, "size": PAGE_COUNT]
        default :
            return nil
        }
    }
    
    
    var authorizationType: AuthorizationType? {
        /*
         Header 사용 여부. bearer, basic 방식으로 보낼 수 있음.
         case .MwaveVoteSend:
         return .bearer
         */
        switch self {
        default:
            return .bearer
        }
    }
    
    var parameterEncoding: ParameterEncoding {
        /* 아래와 같이도 사용 가능.
         case .sendChatData:
         return URLEncoding.httpBody
         */
        return URLEncoding.default
    }

    // 파일 전송등 multipart 사용 시 사용.
    var multipartBody: [Moya.MultipartFormData]? {
        return nil
    }
    
     /*
         # stubbedResponseFromJSONFile
           - Author: Mephrine.
           - Date: 20.03.17
           - parameters:
            - filename : 테스트 json 파일명
            - inDirectory : 테스트 json 경로
            - bundle : 테스트 json 접근을 위한 앱 번들
           - returns: Data
           - Note: 테스트 JSON File 경로 정의 - Unit Test시 사용
       */
    private func stubbedResponseFromJSONFile(filename: String, inDirectory subpath: String = "", bundle:Bundle = Bundle.main ) -> Data {
        guard let path = bundle.path(forResource: filename, ofType: "json",
                                     inDirectory: subpath)
            else {
                return Data()
        }
        
        if let dataString = try? String(contentsOfFile: path),
            let data = dataString.data(using: String.Encoding.utf8){
            return data
        } else {
            return Data()
        }
    }
    
}
