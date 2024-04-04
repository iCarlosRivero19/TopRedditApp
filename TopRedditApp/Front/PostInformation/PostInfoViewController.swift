//
//  DetailsRedditViewController.swift
//  TopRedditApp
//
//  Created by Carlos Mendoza on 3/4/24.
//

import Foundation
import UIKit
import Combine

final class PostInfoViewController: BaseViewController {
    
    @IBOutlet weak var textView: UITextView!
    
    private var viewModel: PostInfoViewModel = PostInfoViewModel()
    private let input: PassthroughSubject<PostInfoViewModel.Input, Never> = .init()
    private var cancellables = Set<AnyCancellable>()
    
    //MARK: - Initialization
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(viewModel: PostInfoViewModel) {
        self.init()
        self.viewModel = viewModel
    }
    
    //MARK: - Configuration
    
    override func viewDidLoad() {
        super.viewDidLoad()
        input.send(.viewDidLoad)
    }
    
    override func setup() {
        super.setup()
    }
    
    //MARK: - Binding
    
    override func setupBinding() {
        let output = viewModel.transform(input: input.eraseToAnyPublisher())
        output.receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                switch event {
                    case .showPostInfo(let postInfo): self?.renderPostInfo(postInfo)
                }
            }
            .store(in: &cancellables)
    }
    
    //MARK: - Private methods
    
    private func renderPostInfo(_ info: PostInfo) {
        textView.text = info.description
    }
}

