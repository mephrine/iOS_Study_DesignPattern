//
//  SearchCafeDummy.swift
//  StudyDesignPatternTests
//
//  Created by Mephrine on 2020/11/09.
//

import Foundation
@testable import StudyDesignPattern

struct SearchCafeDummy {
    static let jsonData: SearchResult? = jsonStringToData (
        """
        {
        "documents":[
        {
        "cafename":"＊여성시대＊ 차분한 20대들의 알흠다운 공간",
        "contents":"출처 : 여성시대 너의 키링, https://youtu.be/uvET6tjCFsk 비트가 적은이유는 비트를 과다섭취시 신장결석을 유발시키기때문이래 나는 아침에만 200ml먹었는데 효과봄...",
        "datetime":"2020-07-05T20:42:48.000+09:00",
        "thumbnail":"https://search1.kakaocdn.net/thumb/P100x100/?fname=https%3A%2F%2Fsearch1.kakaocdn.net%2Fargon%2F130x130_85_c%2FB0uFVmHfzrr",
        "title":"요즘 유행하는 ABC쥬스",
        "url":"http://cafe.daum.net/subdued20club/ReHf/2799433"
        },
        {
        "cafename":"＊여성시대＊ 차분한 20대들의 알흠다운 공간",
        "contents":"들킬까봐 쉬쉬했었는데 어느새 임종마스코트 되벌임ㅋㅋㅋㅋㅋㅋㅋ 전화인증은 남동충 시켜서 함ㅋㅋㅋㅋㅋㅋㅋ tmi) 저 abc초콜렛은 여시가 혼자 다 먹었다고한다",
        "datetime":"2020-03-07T02:12:52.000+09:00",
        "thumbnail":"https://search1.kakaocdn.net/thumb/P100x100/?fname=https%3A%2F%2Fsearch1.kakaocdn.net%2Fargon%2F130x130_85_c%2F2mNOWBd5oSY",
        "title":"임종격투기 전설의 abc남 정체",
        "url":"http://cafe.daum.net/subdued20club/ReHf/2626354"
        },
        {
        "cafename":"소울드레서 (SoulDresser)",
        "contents":"https://www.youtube.com/watch?v=411EDwknRTM&feature=youtu.be 미국 ABC뉴스에서 경기도 지역에 있는 자가격리자 집에 음식을 배달하는 자원봉사자들을 영상에...",
        "datetime":"2020-03-15T10:24:29.000+09:00",
        "thumbnail":"https://search1.kakaocdn.net/thumb/P100x100/?fname=https%3A%2F%2Fsearch4.kakaocdn.net%2Fargon%2F130x130_85_c%2F4XsnaXoP2vh",
        "title":"美ABC 자가격리자 음식배달하는 자원봉사자에 대한 반응",
        "url":"http://cafe.daum.net/SoulDresser/FLTB/225423"
        },
        {
        "cafename":"시어머니와 며느리",
        "contents":"드디어 ABC쥬스가 완성되었습니다. 월요일(6월1일)부터 발송가능합니다. 처음이라 물량이 딸립니다. 입금순으로 보내드릴게요. ABC쥬스는 생즙이기 때문에 받으시면...",
        "datetime":"2020-05-30T17:02:14.000+09:00",
        "thumbnail":"https://search1.kakaocdn.net/thumb/P100x100/?fname=https%3A%2F%2Fsearch4.kakaocdn.net%2Fargon%2F130x130_85_c%2FKMbtHNeovvQ",
        "title":"ABC즙 (비트 사과 당근)혼합 생즙 1차 가공했습니다",
        "url":"http://cafe.daum.net/motherordaughter/W2mH/287"
        },
        {
        "cafename":"여자 혼자가는여행",
        "contents":"시간 살균했더니 이렇게 이쁜 색감과 더불어 맛있는 즙이 탄생되었습니다. 이름은 abc쥬스(즙) 독소를 빼주니 다이어트쥬스랍니다. 뱃살 쏘옥 들어 갈날을 고대하며...",
        "datetime":"2020-06-05T21:04:27.000+09:00",
        "thumbnail":"https://search1.kakaocdn.net/thumb/P100x100/?fname=https%3A%2F%2Fsearch2.kakaocdn.net%2Fargon%2F130x130_85_c%2FDAbvaOkvb1R",
        "title":"ABC즙 출시되었습니다(볶은비트차 새싹보리분말합배송가능)",
        "url":"http://cafe.daum.net/girlbackpaker/NYkK/164"
        },
        {
        "cafename":"소울드레서 (SoulDresser)",
        "contents":"중략 https://www.abc.es/play/series/noticias/abci-corea-nueva-potencia-mundial-series-201808190202_noticia.html 최근 5년동안 세계의 드라마 수출 순위 한국은...",
        "datetime":"2020-01-06T23:55:16.000+09:00",
        "thumbnail":"https://search1.kakaocdn.net/thumb/P100x100/?fname=https%3A%2F%2Fsearch3.kakaocdn.net%2Fargon%2F130x130_85_c%2F7LVdjLtYOGw",
        "title":"스페인 abc “한국은 드라마 삼대 강국”",
        "url":"http://cafe.daum.net/SoulDresser/FLTB/196892"
        },
        {
        "cafename":"쭉빵카페",
        "contents":"출처 : https://twitter.com/joom1217/status/1281827571282219010?s=21 작년 유니클로 앞에서도 시위 하셨었대",
        "datetime":"2020-07-12T21:09:44.000+09:00",
        "thumbnail":"https://search1.kakaocdn.net/thumb/P100x100/?fname=https%3A%2F%2Fsearch4.kakaocdn.net%2Fargon%2F130x130_85_c%2F3tQnC7cDavu",
        "title":"대구 동성로 ABC 마트 앞 1인 시위",
        "url":"http://cafe.daum.net/ok1221/9Zdf/2123684"
        },
        {
        "cafename":"우리는 네비게이토",
        "contents":"코로나기간동안 52가지의 하나님의 속성과 성품을 찬양하며 참 많이 행복한 시간을 보냈습니다. 1년 52주 365일 내내 하나님을 찬양하기 원하는 마음에 52가지의 하나님...",
        "datetime":"2020-06-19T09:31:09.000+09:00",
        "thumbnail":"https://search1.kakaocdn.net/thumb/P100x100/?fname=https%3A%2F%2Fsearch1.kakaocdn.net%2Fargon%2F130x130_85_c%2FED2ximaVmCK",
        "title":"♥오병이어 ABC 하나님 찬양♥",
        "url":"http://cafe.daum.net/navc/R2IG/2933"
        },
        {
        "cafename":"이혼남녀",
        "contents":"다른데 살빠지는건 싫은데 뱃살은 좀 빼고 싶어서 시작한 ABC쥬스~ 사람들이 진짜 빠지냐고 묻네요. 이제 꼴랑 10일 했는디 ㅋㅋㅋ 원래 사람들은 초반에 뭐든 궁금해...",
        "datetime":"2020-04-24T01:01:41.000+09:00",
        "thumbnail":"https://search1.kakaocdn.net/thumb/P100x100/?fname=https%3A%2F%2Fsearch4.kakaocdn.net%2Fargon%2F130x130_85_c%2FBUYNmiXnIdX",
        "title":"뱃살이 이기나 ABC가 이기나~",
        "url":"http://cafe.daum.net/wabsu/1ExL/2186"
        },
        {
        "cafename":"♡ 광주전남3040싱글 한마음 ♡",
        "contents":"벙주-츄 일시-2020년 6월 13일 토요일 오후 4시 장소-쌍촌동 ABC볼링장 벙비-게임수만큼 또는 팀전입니다ㅋ 마이볼 있으신 분은 가져오시고 초보여도 건강한 몸과...",
        "datetime":"2020-06-09T09:22:53.000+09:00",
        "thumbnail":"https://search1.kakaocdn.net/thumb/P100x100/?fname=https%3A%2F%2Fsearch4.kakaocdn.net%2Fargon%2F130x130_85_c%2FLwOS8SdkBpX",
        "title":"6월 13일(토) 오후4시 쌍촌동ABC볼링",
        "url":"http://cafe.daum.net/jinjin4403/kUAR/189"
        }
        ],
        "meta":{
        "is_end":false,
        "pageable_count":991,
        "total_count":376710
        }
        }
        """
    )
}
