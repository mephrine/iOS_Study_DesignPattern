//
//  BaseViewController.swift
//  StudyDesignPattern
//
//  Created by Mephrine on 2020/11/01.
//

import UIKit

/**
 # (Class) BaseViewController.swift
 - Author: Mephrine
 - Date: 20.11.01
 - Note: 뷰만 그리는 클래스
 */
class BaseViewController: UIViewController {
    private let STATUS_HEIGHT = UIApplication.shared.statusBarFrame.size.height
    
    // 상속된 현재 클래스 이름 리턴
    lazy private(set) var classNm: String = {
      return type(of: self).description().components(separatedBy: ".").last ?? ""
    }()
    
    // PopGesture 플래그 변수
    private var isViewControllerPopGesture = true
    
    //제스쳐 관련 플래그 변수
    private var isPopGesture = true
    private var isPopSwipe = false
    
    private(set) var didSetupConstraints = false
    
    
    //MARK: - LifeCycle
    
    init() {
      super.init(nibName: nil, bundle: nil)
    }

    required convenience init?(coder aDecoder: NSCoder) {
      self.init()
    }

    
    override func loadView() {
        super.loadView()
        initView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.setNeedsUpdateConstraints()
        
        // 자동으로 스크롤뷰 인셋 조정하는 코드 막기
        automaticallyAdjustsScrollViewInsets = false
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setInteractivePopGesture(isViewControllerPopGesture)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if isPopSwipe {
            if isPopGesture {
                popGesture()
            }
            isPopSwipe = false
        }
    }
    
    override func updateViewConstraints() {
      if !didSetupConstraints {
        constraints()
        didSetupConstraints = true
      }
        
      super.updateViewConstraints()
    }
    
    //MARK: - UI
    /**
     # initView
     - Author: Mephrine
     - Date: 20.07.12
     - Parameters:
     - Returns:
     - Note: ViewController에서 view 초기화 시에 실행할 내용 정의하는 Override용 함수
    */
    //MARK: - UI
    func initView() {
        fatalError("Subclasses need to implement the `initView()` method.")
    }
    
    func constraints() {
        fatalError("Subclasses need to implement the `constraints()` method.")
    }
    
    //MARK: - e.g.
    /**
     # popGesture
     - Author: Mephrine
     - Date: 20.07.12
     - Parameters:
     - Returns:
     - Note: ViewController에서 PopGesture시에 실행할 내용 정의하는 Override용 함수
    */
    func popGesture() {
        
    }
    
    /**
     # setInteractivePopGesture
     - Author: Mephrine
     - Date: 20.07.12
     - Parameters:
     - isRegi: PopGesture 적용 여부 Bool
     - Returns:
     - Note: ViewController PopGesture를 적용/해제하는 함수
     */
    func setInteractivePopGesture(_ isRegi:Bool = true) {
        if isRegi {
            navigationController?.interactivePopGestureRecognizer?.delegate = self as UIGestureRecognizerDelegate
            navigationController?.interactivePopGestureRecognizer?.isEnabled = true
            isPopGesture = true
        } else {
            navigationController?.interactivePopGestureRecognizer?.delegate = nil
            navigationController?.interactivePopGestureRecognizer?.isEnabled = false
            isPopGesture = false
        }
    }
    
    
    // MARK: SafeArea
    /**
     # safeAreaTopAnchor
     - Author: Mephrine
     - Date: 20.06.24
     - Parameters:
     - Returns: CGFloat
     - Note: 현재 디바이스의 safeAreaTop pixel값을 리턴하는 함수
    */
    lazy var safeAreaTopAnchor: CGFloat = {
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow
            var topPadding = window?.safeAreaInsets.top
            
            if topPadding == 0 {
                topPadding = topLayoutGuide.length
                if topPadding == 0 {
                    topPadding = UIApplication.shared.statusBarFrame.size.height
                }
            }
            
            return topPadding ?? STATUS_HEIGHT
        } else {
            return STATUS_HEIGHT
        }
    }()
    
    
    /**
     # safeAreaBottomAnchor
     - Author: Mephrine
     - Date: 20.07.12
     - Parameters:
     - Returns: CGFloat
     - Note: 현재 디바이스의 safeAreaBottom pixel값을 리턴하는 함수
    */
    lazy var safeAreaBottomAnchor: CGFloat = {
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow
            let bottomPadding = window?.safeAreaInsets.bottom
            return bottomPadding!
        } else {
            return bottomLayoutGuide.length
        }
    }()
}


//MARK: -  UIGestureRecognizerDelegate.
// ViewController PopGesture 사용 / 해제를 위한 delegate 함수를 처리
extension BaseViewController: UIGestureRecognizerDelegate {
    internal func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        switch gestureRecognizer.state {
        case .possible:
            isPopSwipe = true
            break
        case .began:
            isPopSwipe = true
            break
        case .changed:
            isPopSwipe = true
            break
        default:
            isPopSwipe = false
            break
        }
        return true
    }
}
