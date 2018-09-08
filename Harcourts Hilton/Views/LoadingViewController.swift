class LoadingViewController: UIViewController {
    
    @IBOutlet weak var loadingText: UILabel!
    
    init() {
        super.init(nibName: nil, bundle: HarcourtsHilton)
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadingText.text = "Loading"
    }
}
