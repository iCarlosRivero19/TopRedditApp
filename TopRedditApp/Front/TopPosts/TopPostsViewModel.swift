//
//  TopRedditViewModel.swift
//  TopRedditApp
//
//  Created by Carlos Mendoza on 3/4/24.
//

import Foundation
import Combine

final class TopPostsViewModel: TopPostsViewModelProtocol {

    private let postInteractor: PostInteractor
    private var isLoading: Bool = false
    private var cancellables = Set<AnyCancellable>()
    private var redditResponse: RedditResponse<Post>?
    
    var output: PassthroughSubject<Output, Never> = .init()
    
    //MARK: - Initialization DI
    
    init(postInteractor: PostInteractor = PostInteractor()) {
        self.postInteractor = postInteractor
    }
    
    //MARK: - Transformation I/O
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] event in
            switch event {
                case .viewDidLoad: self?.fetchTopPosts(after: nil)
                case .didScrollToBottom: self?.fetchTopPosts(after: self?.redditResponse?.after)
                case .didSelectPost(let post): self?.output.send(.navigateToPostInformation(post))
            }
        }
        .store(in: &cancellables)
        return output.eraseToAnyPublisher()
    }
    
    //MARK: - Private methods
    
    private func fetchTopPosts(after: String?) {
        if !isLoading {
            isLoading.toggle()
            postInteractor.fetchTop(after: after)
                .receive(on: DispatchQueue.main)
                .sink { [weak self] data in
                    if case .failure(let error) = data {
                        self?.isLoading.toggle()
                        print(error.localizedDescription)
                    }
                } receiveValue: { [weak self] response in
                    self?.isLoading.toggle()
                    self?.redditResponse = response.data
                    let posts = response.data.children.map({ $0.data })
                    self?.output.send(.showTopPosts(posts))
                }
                .store(in: &cancellables)
        }
    }
}

//MARK: - Input/output

extension TopPostsViewModel {
    
    enum Input {
        case viewDidLoad
        case didScrollToBottom
        case didSelectPost(Post)
    }
    
    enum Output {
        case showTopPosts([Post])
        case navigateToPostInformation(Post)
    }
}

//MARK: - ViewModel protocol

protocol TopPostsViewModelProtocol {
    typealias Input = TopPostsViewModel.Input
    typealias Output = TopPostsViewModel.Output
    var output: PassthroughSubject<Output, Never> { get }
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never>
}
