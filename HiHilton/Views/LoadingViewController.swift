class LoadingViewController: UIViewController {
    
    @IBOutlet weak var loadingText: UILabel!
    
    init() {
        super.init(nibName: nil, bundle: HiHilton)
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadingText.text = "Loading"
        loadingText.font = Font.forStyle(Style.loading)
        loadingText.textColor = .harcourtsNavy
    }
}
