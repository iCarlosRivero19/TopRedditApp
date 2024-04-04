//
//  DetailsRedditViewModel.swift
//  TopRedditApp
//
//  Created by Carlos Mendoza on 3/4/24.
//

import Foundation
import Combine

final class PostInfoViewModel: PostInfoViewModelProtocol {
    
    private let postInteractor: PostInteractor
    private var cancellables = Set<AnyCancellable>()
    
    var output: PassthroughSubject<Output, Never> = .init()
    var post: Post?
    
    //MARK: - Initialization DI
    
    init(postInteractor: PostInteractor = PostInteractor()) {
        self.postInteractor = postInteractor
    }
    
    //MARK: - Transformation I/O
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] event in
            switch event {
            case .viewDidLoad: self?.fetchRedditInfo(post: self?.post)
            }
        }
        .store(in: &cancellables)
        return output.eraseToAnyPublisher()
    }
    
    //MARK: - Private methods
    
    private func fetchRedditInfo(post: Post?) {
        guard let redditPost = post else { return }
        postInteractor.info(subreddit: redditPost.subreddit, subredditId: redditPost.subredditId)
            .receive(on: DispatchQueue.main)
            .sink { data in
                if case .failure(let error) = data {
                    print(error.localizedDescription)
                }
            } receiveValue: { [weak self] response in
                if let information = response.data.children.map({ $0.data }).first {
                    self?.output.send(.showPostInfo(information))
                }
            }
            .store(in: &cancellables)
    }
    
}

//MARK: - Input/output

extension PostInfoViewModel {
    
    enum Input {
        case viewDidLoad
    }
    
    enum Output {
        case showPostInfo(PostInfo)
    }
}

//MARK: - ViewModel protocol

protocol PostInfoViewModelProtocol {
    typealias Input = PostInfoViewModel.Input
    typealias Output = PostInfoViewModel.Output
    var output: PassthroughSubject<Output, Never> { get }
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never>
}
