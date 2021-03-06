//
//  ViewController.swift
//  CombineLoginTutorial
//
//  Created by 최민한 on 2022/04/28.
//

import UIKit
import SnapKit
import Then
import Combine
import CombineCocoa

final class CombineViewController: UIViewController {
    
    private let idTextField = UITextField().then {
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    private let pwTextField = UITextField().then {
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    private let button = UIButton(type: .system).then {
        $0.setTitle("확인", for: .normal)
    }
    
    private var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupLayout()
        bind()
    }
    
    private func setupLayout() {
        view.do {
            $0.backgroundColor = .white
            $0.addSubview(idTextField)
            $0.addSubview(pwTextField)
            $0.addSubview(button)
        }
        
        idTextField.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
        
        pwTextField.snp.makeConstraints { make in
            make.top.equalTo(idTextField.snp.bottom).offset(40)
            make.leading.trailing.equalToSuperview().inset(20)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
        }
        
        button.snp.makeConstraints { make in
            make.top.equalTo(pwTextField.snp.bottom).offset(40)
            make.leading.trailing.equalToSuperview().inset(20)
            make.centerX.equalToSuperview()
        }
    }
    
    private func bind() {
        Publishers.CombineLatest(
            idTextField.textPublisher.replaceNil(with: ""),
            pwTextField.textPublisher.replaceNil(with: "")
        ).map { a, b in
            a.count > 5 && b.count > 5
        }.assign(to: \.isEnabled, on: button)
            .store(in: &cancellables)
        
        button.tapPublisher
            .sink { _ in
                print("button tapped.")
            }.store(in: &cancellables)
    }

}

