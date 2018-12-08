//
//  SingleArticleFlowController.swift
//  HiHilton
//
//  Created by Lee Watkins on 2018/09/08.
//  Copyright © 2018 UniekLee. All rights reserved.
//

import FirebaseAnalytics
import SafariServices
import Firebase
import PKHUD

protocol SingleArticleFlow: AnyObject {
    func returningFrom(flowController: SingleArticleFlowController)
}

class SingleArticleFlowController: FlowController {
    var article: Article?
    weak var delegate: SingleArticleFlow?
    
    func start(with article: Article) {
        self.article = article
        navController?.show(self, sender: nil)
    }
    
    func start(with articleId: Int) {
        article = Article()
        article?.id = articleId
        presentSingleArticle()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = nil
        navigationItem.largeTitleDisplayMode = .never
        display(LoadingViewController())
        setUpNavigationItem()
        getArticleDetails()
    }
    
    override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)
        if parent == nil {
            delegate?.returningFrom(flowController: self)
        }
    }
}

extension SingleArticleFlowController {
    func setUpNavigationItem() {
        let shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(userDidTapShareButton(_:)))
        navigationItem.rightBarButtonItem = shareButton
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    @objc func userDidTapShareButton(_ button: UIBarButtonItem) {
        guard let link = linkForArticle else { return }
        let linkBuilder = DynamicLinkComponents(link: link, domain: "hihilton.page.link")
        linkBuilder.iOSParameters = DynamicLinkIOSParameters(bundleID: "com.hihilton.HiHilton")
        
        HUD.show(.labeledProgress(title: nil, subtitle: "Preparing link..."))
        linkBuilder.shorten() { [weak self] url, warnings, error in
            HUD.hide()
            guard let url = url, error == nil else { return }
            let text = "Check out this article on HiHilton."
            self?.displayShareSheet(with: [text, url])
        }
    }
    
    func displayShareSheet(with items: [Any]) {
        let controller = UIActivityViewController(activityItems: items, applicationActivities: nil)
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            controller.popoverPresentationController?.sourceView = view
            controller.popoverPresentationController?.sourceRect = frameForShareSheet
            controller.popoverPresentationController?.permittedArrowDirections = []
        }
        
        present(controller, animated: true, completion: nil)
    }
    
    var linkForArticle: URL? {
        guard
            let baseURL = URL(string: NetworkRouter.baseURLString),
            let articleId = article?.id,
            var linkComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)
            else { return nil }
        
        linkComponents.queryItems = [
            URLQueryItem(name: "post_type", value: "articles"),
            URLQueryItem(name: "p", value: "\(articleId)")
        ]
        return linkComponents.url
    }
    
    var frameForShareSheet: CGRect {
        return CGRect(x: view.bounds.midX, y: view.bounds.midY, width: 0, height: 0)
    }
}

extension SingleArticleFlowController {
    private func presentSingleArticle() {
        let modalNav = UINavigationController(rootViewController: self)
        let closeButton = UIBarButtonItem(barButtonSystemItem: .done,
                                          target: self,
                                          action: #selector(SingleArticleFlowController.modalDoneTapped(_:)))
        navigationItem.setLeftBarButton(closeButton, animated: true)
        navController?.present(modalNav, animated: true, completion: nil)
    }
    
    @objc func modalDoneTapped(_ button: UIBarButtonItem) {
        navController?.dismiss(animated: true, completion: nil)
    }
}

extension SingleArticleFlowController {
    func getArticleDetails() {
        guard let article = article else { return }
        
        if article.fetched {
            getMedia(for: article.id)
        } else {
            getArticle(with: article.id)
        }
    }
    
    private func getMedia(for articleId: Int) {
        ArticleMediaModel.getMedia(for: articleId) { [weak self] (media, error) in
            guard
                let strongSelf = self,
                let article = self?.article
                else { return }
            self?.reportEventDidView(article: article)
            let singleArticleVC = SingleArticleViewController(with: article, media: media, delegate: strongSelf)
            self?.transition(to: singleArticleVC)
            self?.enableShareButton()
        }
    }
    
    private func getArticle(with articleId: Int) {
        SingleArticleModel.getArticle(with: articleId) { [weak self, articleId] (possibleArticle, possibleError) in
            guard let article = possibleArticle else {
                debugPrint(possibleError!.localizedDescription)
                return
            }
            self?.article = article
            self?.getMedia(for: articleId)
            self?.enableShareButton()
        }
    }
    
    private func enableShareButton() {
        navigationItem.rightBarButtonItem?.isEnabled = true
    }
}

// Analytics
extension SingleArticleFlowController {
    private func reportEventDidView(article: Article) {
        Analytics.logEvent(AnalyticsEventViewItem, parameters: [
            AnalyticsParameterItemID: "id-\(article.id)",
            AnalyticsParameterItemName: article.title ?? "",
            AnalyticsParameterContentType: "article"
            ])
    }
}

extension SingleArticleFlowController: SingleArticleDelegate {
    func userDidSelectLink(with url: URL) {
        let controller = SFSafariViewController(url: url)
        controller.preferredControlTintColor = .harcourtsNavy
        present(controller, animated: true, completion: nil)
    }
}

extension SingleArticleFlowController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
}
