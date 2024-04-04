//
//  TopRedditViewController.swift
//  TopRedditApp
//
//  Created by Carlos Mendoza on 3/4/24.
//

import UIKit
import Combine

final class TopPostsViewController: BaseViewController {
    
    @IBOutlet weak var tableView: AutoresizingTableView!
    private var viewModel: TopPostsViewModel = TopPostsViewModel()
    private let input: PassthroughSubject<TopPostsViewModel.Input, Never> = .init()
    private var cancellables = Set<AnyCancellable>()
    private var posts: [Post] = []
    
    private lazy var tableViewDataSource: UITableViewDiffableDataSource<TopPostSection, Post> = {
        buildTableViewDataSource()
    }()
    
    //MARK: - Initialization
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(viewModel: TopPostsViewModel) {
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
        navigationItem.title = Resources.Strings.topRedditTitle
        navigationItem.largeTitleDisplayMode = .automatic
        tableView.delegate = self
    }
    
    override func registerNibs() {
        super.registerNibs()
        tableView.register(UINib(nibName: PostCell.nibName, bundle: nil), forCellReuseIdentifier: PostCell.reuseIdentifierName)
    }
    
    //MARK: - Binding
    
    override func setupBinding() {
        let output = viewModel.transform(input: input.eraseToAnyPublisher())
        output.receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                switch event {
                    case .showTopPosts(let posts):
                        self?.posts.append(contentsOf: posts)
                        self?.applySnapshot(posts: self?.posts, animate: true)
                    
                    case .navigateToPostInformation(let post): self?.presentPostInformationView(with: post)
                }
            }
            .store(in: &cancellables)
    }
    
    //MARK: - Private methods
    
    private func presentPostInformationView(with post: Post) {
        let postInformationViewModel = PostInfoViewModel()
        postInformationViewModel.post = post
        
        let postInformationView = PostInfoViewController(viewModel: postInformationViewModel)
        postInformationView.modalPresentationStyle = .automatic
        present(postInformationView, animated: true)
    }
}

//MARK: - delegate methods

extension TopPostsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let limit = posts.count > 0 ? posts.count - 1 : posts.count
        if indexPath.row >= limit {
            input.send(.didScrollToBottom)
        }
    }
}

//MARK: - dataSource methods

extension TopPostsViewController {
    
    private func applySnapshot(posts: [Post]?, animate: Bool) {
        guard let topPosts = posts else { return }
        var snapshot = NSDiffableDataSourceSnapshot<TopPostSection, Post>()
        snapshot.appendSections([.main])
        snapshot.appendItems(topPosts, toSection: .main)
        tableViewDataSource.apply(snapshot, animatingDifferences: animate)
    }
    
    private func buildTableViewDataSource() -> UITableViewDiffableDataSource<TopPostSection, Post> {
        let dataSource = UITableViewDiffableDataSource<TopPostSection, Post>(tableView: tableView) { [weak self] tableView, indexPath, post in
            let cell = tableView.dequeueReusableCell(withIdentifier: PostCell.reuseIdentifierName, for: indexPath) as! PostCell
            cell.configure(post: post)
            cell.event
                .receive(on: DispatchQueue.main)
                .sink { [weak self] events in
                    switch events {
                        case .selected(let post): self?.input.send(.didSelectPost(post))
                    }
                }
                .store(in: &cell.cancellable)
            
            return cell
        }
        dataSource.defaultRowAnimation = .fade
        return dataSource
    }
}


