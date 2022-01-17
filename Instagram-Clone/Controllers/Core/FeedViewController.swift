//
//  FeedViewController.swift
//  Instagram-Clone
//
//  Created by Pedro Gomes Rubbo Pacheco on 27/03/21.
//

import UIKit

class FeedViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    private var viewModels = [[FeedCellType]]()

    // MARK: - Subviews
    
    private var collectionView: UICollectionView?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Instagram"
        view.backgroundColor = .systemBackground
        self.configureCollectionView()
        self.fetchPosts()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView?.frame = view.bounds
    }
    
    // MARK: - Functionalities
    
    private func fetchPosts() {
        guard let username = UserDefaults.standard.string(forKey: "username") else { return }
        DatabaseManager.shared.posts(for: username) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let posts):
                    let group = DispatchGroup()
                    
                    posts.forEach { model in
                        group.enter()
                        self?.createViewModel(model: model, username: username, completion: { success in
                            defer {
                                group.leave()
                            }
                            if !success {
                                print("failed to create VM")
                            }
                        })
                    }
                    
                    group.notify(queue: .main) {
                        self?.collectionView?.reloadData()
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    private func createViewModel(model: Post, username: String ,completion: @escaping (Bool) -> Void) {
        let group = DispatchGroup()
        group.enter()
        
        var profilePictureURL: URL?
        
        StorageManager.shared.downloadProfileURL(for: username) { url in
            defer {
                group.leave()
            }
            profilePictureURL = url
        }
        
        group.notify(queue: .main) { [weak self] in
            guard let self = self, let postUrl = URL(string: model.postUrlString), let profilePictureURL = profilePictureURL else {
                completion(false)
                return
            }
            
            let postData: [FeedCellType] = [
                .poster(viewModel: PosterCollectionViewCellViewModel(username: username, profilePictureURL: profilePictureURL)),
                .post(viewModel: PostCollectionViewCellViewModel(postURL: postUrl)),
                .actions(viewModel: PostActionsCollectionViewCellViewModel(isLiked: false)),
                .likeCount(viewModel: PostLikesCollectionViewCellViewModel(likers: [])),
                .caption(viewModel: PostCaptionCollectionViewCellViewModel(username: username, caption: model.caption)),
                .timestamp(viewModel: PostDatetimeCollectionViewCellViewModel(date: DateFormatter.formatter.date(from: model.postedDate) ?? Date()))
            ]
            self.viewModels.append(postData)
            completion(true)
        }
    }
    
    // MARK: - CollectionView Delegate
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModels[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cellType = viewModels[indexPath.section][indexPath.row]
        
        switch cellType {
        case .poster(let viewModel):
            
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: PosterCollectionViewCell.identifier,
                for: indexPath
            ) as? PosterCollectionViewCell else {
                fatalError()
            }
            cell.delegate = self
            cell.configure(with: viewModel)
            return cell
            
        case .post(let viewModel):
            
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: PostCollectionViewCell.identifier,
                for: indexPath
            ) as? PostCollectionViewCell else {
                fatalError()
            }
            cell.delegate = self
            cell.configure(with: viewModel)
            return cell
            
        case .actions(let viewModel):
            
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: PostActionsCollectionViewCell.identifier,
                for: indexPath
            ) as? PostActionsCollectionViewCell else {
                fatalError()
            }
            cell.delegate = self
            cell.configure(with: viewModel)
            return cell
            
        case .likeCount(let viewModel):
            
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: PostLikesCollectionViewCell.identifier,
                for: indexPath
            ) as? PostLikesCollectionViewCell else {
                fatalError()
            }
            cell.delegate = self
            cell.configure(with: viewModel)
            return cell
            
        case .caption(let viewModel):
            
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: PostCaptionCollectionViewCell.identifier,
                for: indexPath
            ) as? PostCaptionCollectionViewCell else {
                fatalError()
            }
            cell.delegate = self
            cell.configure(with: viewModel)
            return cell
            
        case .timestamp(let viewModel):
            
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: PostDatetimeCollectionViewCell.identifier,
                for: indexPath
            ) as? PostDatetimeCollectionViewCell else {
                fatalError()
            }
            cell.configure(with: viewModel)
            return cell
            
        }
        
        
    }
    
}

//MARK: - PosterCell Delegate

extension FeedViewController: PosterCollectionViewCellDelegate {
    func posterCollectionViewCellDidTapMore(_ cell: PosterCollectionViewCell) {
        let sheet = UIAlertController(title: "Post Actions", message: nil, preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        sheet.addAction(UIAlertAction(title: "Share Post", style: .default, handler: nil))
        sheet.addAction(UIAlertAction(title: "Report Post", style: .destructive, handler: nil))
        present(sheet, animated: true)
    }
    
    func posterCollectionViewCellDidTapUsername(_ cell: PosterCollectionViewCell) {
        let vc = ProfileViewController(user: User(username: "kanye west", email: "kanye@gmail.com"))
        navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: - PostCell Delegate

extension FeedViewController: PostCollectionViewCellDelegate {
    func postCollectionViewCellDidLike(_ cell: PostCollectionViewCell) {
        print("did tap to like")
    }
}

//MARK: - PostActionsCell Delegate

extension FeedViewController: PostActionsCollectionViewCellDelegate {
    func postActionsCollectionViewCellDidTapLike(_ cell: PostActionsCollectionViewCell, isLiked: Bool) {
        // call DB to update like state
    }
    
    func postActionsCollectionViewCellDidTapComment(_ cell: PostActionsCollectionViewCell) {
//        let vc = PostViewController()
//        vc.title = "Post"
//        navigationController?.pushViewController(vc, animated: true)
    }
    
    func postActionsCollectionViewCellDidTapShare(_ cell: PostActionsCollectionViewCell) {
        let vc = UIActivityViewController(activityItems: ["Sharing from Instagram"], applicationActivities: [])
        present(vc, animated: true)
    }
}

//MARK: - PostLikesCell Delegate

extension FeedViewController: PostLikesCollectionViewCellDelegate {
    func postLikesCollectionViewCellDidTapLikeCount(_ cell: PostLikesCollectionViewCell) {
        let vc = ListViewController()
        vc.title = "Liked By"
        navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: - PostCaptionCell Delegate

extension FeedViewController: PostCaptionCollectionViewCellDelegate {
    func postCaptionCollectionViewCellDidTapCaption(_ cell: PostCaptionCollectionViewCell) {
        print("tapped on caption")
    }
}

//MARK: - Creating Collection View

extension FeedViewController {
    private func configureCollectionView() {
        let sectionHeight: CGFloat = 220 + view.width // was 240 + view.width
        let collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { index, _ -> NSCollectionLayoutSection? in
            
            // Item
            let posterItem = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(60)
                )
            )
            
            let postItem = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalWidth(1)
                )
            )
            
            let actionsItem = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(40)
                )
            )
            
            let likeCountItem = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(40)
                )
            )
            
            let captionItem = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(40) // was 60
                )
            )
            
            let timestampItem = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(40)
                )
            )
            
            // Group
            let group = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(sectionHeight)
                ),
                subitems: [
                    posterItem,
                    postItem,
                    actionsItem,
                    likeCountItem,
                    captionItem,
                    timestampItem
                ]
            )
            // Section
            let section = NSCollectionLayoutSection(group: group)
            
            section.contentInsets = NSDirectionalEdgeInsets(top: 3, leading: 0, bottom: 10, trailing: 0)
            
            return section
        })
    )
        view.addSubview(collectionView)
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(
            PosterCollectionViewCell.self,
            forCellWithReuseIdentifier: PosterCollectionViewCell.identifier
        )
        
        collectionView.register(
            PostCollectionViewCell.self,
            forCellWithReuseIdentifier: PostCollectionViewCell.identifier
        )
        
        collectionView.register(
            PostActionsCollectionViewCell.self,
            forCellWithReuseIdentifier: PostActionsCollectionViewCell.identifier
        )
        
        collectionView.register(
            PostLikesCollectionViewCell.self,
            forCellWithReuseIdentifier: PostLikesCollectionViewCell.identifier
        )
        
        collectionView.register(
            PostCaptionCollectionViewCell.self,
            forCellWithReuseIdentifier: PostCaptionCollectionViewCell.identifier
        )
        
        collectionView.register(
            PostDatetimeCollectionViewCell.self,
            forCellWithReuseIdentifier: PostDatetimeCollectionViewCell.identifier
        )
        
        self.collectionView = collectionView
    }
}
