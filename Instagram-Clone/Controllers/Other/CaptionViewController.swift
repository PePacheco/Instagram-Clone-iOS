//
//  CaptionViewController.swift
//  Instagram-Clone
//
//  Created by Pedro Gomes Rubbo Pacheco on 27/03/21.
//

import UIKit

class CaptionViewController: UIViewController {
    
    //MARK: - Subviews
    
    private let image: UIImage
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let textView: UITextView = {
        let textView = UITextView()
        textView.text = "Add caption..."
        textView.backgroundColor = .secondarySystemBackground
        textView.font = .systemFont(ofSize: 22)
        textView.textContainerInset = UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
        return textView
    }()
    
    //MARK: - Initializers
    
    init(image: UIImage) {
        self.image = image
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(imageView)
        view.addSubview(textView)
        imageView.image = image
        textView.delegate = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Post", style: .done, target: self, action: #selector(didTapPost))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let size: CGFloat = view.width/4
        imageView.frame = CGRect(
            x: (view.width-size)/2,
            y: view.safeAreaInsets.top - 10,
            width: size,
            height: size
        )
        textView.frame = CGRect(
            x: 20,
            y: imageView.bottom + 20,
            width: view.width - 40,
            height: 100
        )
    }
    
    //MARK: - Actions
    
    @objc func didTapPost() {
        textView.resignFirstResponder()
        var caption = textView.text ?? ""
        if caption == "Add caption..." {
            caption = ""
        }
        // Upload photo, update database
    }

}

//MARK: - TextView Delegates

extension CaptionViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Add caption..." {
            textView.text = nil
        }
    }
}
