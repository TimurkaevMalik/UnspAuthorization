//
//  AuthorizationViewController.swift
//  FeatureTemplate
//
//  Created by Malik Timurkaev on 26.09.2025.
//


import UIKit

@MainActor
protocol AuthEntryViewControllerOutput: AnyObject {
    func authEntryDidRequestStartAuth()
}

final class AuthEntryViewController: UIViewController {
    
    private var output: AuthEntryViewControllerOutput?
    
    private lazy var rootView: AuthEntryView = {
        let uiView = AuthEntryView(output: self)
        return uiView
    }()
    
    init(output: AuthEntryViewControllerOutput? = nil) {
        self.output = output
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension AuthEntryViewController: AuthEntryViewOutput {
    func authButtonTapped() {
        output?.authEntryDidRequestStartAuth()
    }
}
