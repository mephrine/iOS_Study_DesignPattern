//
//  SearchBlogDummy.swift
//  StudyDesignPatternTests
//
//  Created by Mephrine on 2020/11/09.
//

import Foundation
@testable import StudyDesignPattern

struct SearchBlogDummy {
    static let jsonData: SearchResult? = jsonStringToData (
        """
        {
        "documents":[
        {
        "blogname":"핑크빛 장미",
        "contents":"ABC 주스 효과 ABC주스를 들어보신 분들이 계신가요? 아마 ABC주스를 해독 쥬스로 들어 보셨을 겁니다. 핫한 해독 쥬스라 ABC주스를 알고 계신 분들이 많긴 하지만 아직까지 모르시는 분들을 위해 간단하게 설명드리고, 믿고 먹을 수 있는 곳을 소개해 드릴테니 참고해 주시면 좋을 것 같습니다. 가장 먼저 ABC주스 이름...",
        "datetime":"2020-06-22T08:16:00.000+09:00",
        "thumbnail":"https://search2.kakaocdn.net/argon/130x130_85_c/6aFkqIVIsXf",
        "title":"ABC 주스 효과",
        "url":"http://fhsdtf3.tistory.com/1"
        },
        {
        "blogname":"궁금할땐",
        "contents":"안녕하세요!! 다이어트의 대명사 ABC주스!! 홈쇼핑에서 ABC 주스에 사과를 안넣어서 밑장빼기? 하다 걸려서 많은 분들이 열받아 했잖아요! 그래서 준비 했습니다. ABC 주스 BEST 3 그리고 ABC 주스가 왜 좋은지 무엇인지에 대해서 알아보도록 할께요!! BEST1 << BEST1 구매후기 보러가기 >> BEST2 << BEST2 구매후기...",
        "datetime":"2020-07-12T09:38:00.000+09:00",
        "thumbnail":"https://search3.kakaocdn.net/argon/130x130_85_c/IOSBg5iCzDd",
        "title":"ABC주스 추천",
        "url":"http://gjk932f.tistory.com/2"
        },
        {
        "blogname":"건강의 모든것",
        "contents":"abc쥬스 효능 abc쥬스란? abc쥬스는 사과(Apple) 비트(Beet) 당근(Carot)을 갈아서 만든 쥬스이다. 이것이 파생되어 현재 시중에도 다양한 abc쥬스가 탄생하게 되었는데, 쉽게 말하면 좋은 영양분이 합쳐져서 액체화 된것이 abc 쥬스이다. abc쥬스는 다양한 방송에서 나와서 인기를 끌고 있으며 심지어 근손실 없이 지방...",
        "datetime":"2020-07-05T20:41:00.000+09:00",
        "thumbnail":"https://search4.kakaocdn.net/argon/130x130_85_c/9Nh6Yae67GK",
        "title":"abc쥬스 효능",
        "url":"http://health.freecontricts.kr/3"
        },
        {
        "blogname":"건강 추구 bodyTV",
        "contents":"ABC쥬스 효능 오늘은 ABC쥬스가 무엇인지, 효능, 다이어트 효능, 건강에 미치는 영향등에 대하여 한번 알아보려고 합니다. 왜냐하면 요즘 코로나19로 몸의 건강, 면역력, 항산화 등이 중요해지면서 건강관리를 해야하는 시대가 되었기 때문입니다. 그래서 건강식품 중 하나인 ABC주스에 대하여 알아보도록 합시다. 그럼...",
        "datetime":"2020-06-18T12:51:00.000+09:00",
        "thumbnail":"https://search1.kakaocdn.net/argon/130x130_85_c/HZE1J2EwUFO",
        "title":"ABC쥬스 효능",
        "url":"http://jeongli.jeongli.co.kr/3"
        },
        {
        "blogname":"새희망홀씨대출자격",
        "contents":"ABC주스 추천 ABC주스란 ABC 주스는 나는 몸신이다에 나오면서 유명해진 몸이 건강해지는 쥬스 입니다. A = APPLE B = BEAT C = CARROT 을 뜻합니다 효능 ABC 주스에는 식이섬유와 식물영양소가 풍부해 내장지방 형성을 방지해주고 원래 있던 내장지방은 에너지원으로 사용하게끔 도와줍니다.또한 내장지방을 배출까지...",
        "datetime":"2020-05-28T15:43:00.000+09:00",
        "thumbnail":"https://search1.kakaocdn.net/argon/130x130_85_c/6kjYtgyW4Y8",
        "title":"abc주스 추천",
        "url":"http://8877.humo.kr/6"
        },
        {
        "blogname":"잡동사니N",
        "contents":"최근 해독과 다이어트에 효과가 좋다고 온라인과 방송 매체를 뜨겁게 달구고 있는 주스가 있죠? 바로 ABC주스라고 불리는 주스인데요. 응?? ABC주스?? 라고 하시는 분들이 계실거에요. 오늘은 이 ABC주스라고 하는 식품에 대해 알아보고 ABC주스의 효능과 부작용 등에 대해서도 함께 알아보는 시간을 가져보려고 합니다...",
        "datetime":"2020-06-15T16:38:00.000+09:00",
        "thumbnail":"https://search2.kakaocdn.net/argon/130x130_85_c/I5jki2A811f",
        "title":"ABC주스 효능 부작용",
        "url":"http://hobin1114.tistory.com/106"
        },
        {
        "blogname":"만년 꼴지 공대생 세상 이야기",
        "contents":"ABC 쥬스란? 기적의 음료라고도 불리는 ABC 쥬스에 대해서 여러분들을 알고 계시는지요! ABC 쥬스는 디톡스에 정말 좋은 효능을 가지고 있는 것으로 알려져 있습니다. ABC 쥬스의 의미는 사과(Apple), 비트 뿌리(Beet root), 당근(Carrot)이 세 가지로 만든 쥬스인데, 영어 이름의 가장 앞글자를 따서 ABC 쥬스라고...",
        "datetime":"2020-07-09T23:49:00.000+09:00",
        "thumbnail":"https://search4.kakaocdn.net/argon/130x130_85_c/FM9KARCgVV4",
        "title":"ABC 쥬스란? 효능은?",
        "url":"http://ojt90902.tistory.com/221"
        },
        {
        "blogname":"칠라네 잡학다식",
        "contents":"ABC 주스 효능 부작용 알아보아요 ABC 주스는 TV프로그램을 통해 포털사이트 실시간 검색어에 오르락 내리락하면서 많은분들에게 이름을 알렸는데요. 특히 다이어트에 도움이되는 주스라고 알려져서 많은분들이 찾고있는 상황입니다. 그럼 과연 다이어트에 도움이 되는지 오늘은 ABC 주스 효능 부작용에 대하여 자세히...",
        "datetime":"2020-07-10T00:12:00.000+09:00",
        "thumbnail":"https://search3.kakaocdn.net/argon/130x130_85_c/4dCIDs4Cblq",
        "title":"ABC 주스 효능 부작용 완벽정리",
        "url":"http://blog6.healthinformation.kr/39"
        },
        {
        "blogname":"건강 추구 bodyTV",
        "contents":"ABC 주스 부작용 ABC 주스 부작용 ABC 주스 부작용을 알려면, ABC 주스가 무엇인지 부터 알아야 이해가 되겠죠? ABC 쥬스는 Apple:사과 Beet:비트 Carrot:당근 왼쪽:사과, 가운데:비트, 오른쪽:당근 1.신장결석 ABC주스 섭취방법을보면 조금만 넣거나, 1/3만 넣어서 섭취하도록 하고 있습니다. 그 이유는 비트에 함유...",
        "datetime":"2020-07-10T20:32:00.000+09:00",
        "thumbnail":"https://search2.kakaocdn.net/argon/130x130_85_c/CYyjND0L0cA",
        "title":"ABC 주스 부작용",
        "url":"http://jeongli.jeongli.co.kr/17"
        },
        {
        "blogname":"프리는덤",
        "contents":"병행되어야 하기 때문에 정말 빼기가 힘듭니다. 그러나 먹는 것만으로도 내장지방을 빼는데 도움이 되는 게 있으니 바로 abc 주스입니다. abc 주스 만드는 법 1. abc 주스 abc 주스 만드는 법 abc 주스는 사과, 비트, 당근의 스펠링을 하나씩 따서 만든 이름인데요. 사과는 apple, 비트는 beet, 당근은 carrot이기 때문...",
        "datetime":"2020-06-23T18:07:00.000+09:00",
        "thumbnail":"https://search4.kakaocdn.net/argon/130x130_85_c/7dWefKhKh8M",
        "title":"abc 주스 만드는 법",
        "url":"http://domfreeee.com/35"
        }
        ],
        "meta":{
        "is_end":false,
        "pageable_count":800,
        "total_count":588805
        }
        }
        """
    )
}
