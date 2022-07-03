import UIKit
import Combine
import NetworkClient

public final class ImageLoader: UIImageView {
    
    private var network: NetworkProtocol?
    private var imageURL: URL?
    private var cancellable = Set<AnyCancellable>()
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.style = .medium
        indicator.color = .darkGray
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    public init(network: NetworkProtocol = Network(session: URLSession.cacheSession)) {
        self.network = network
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public func loadImageWithUrl(_ url: URL) {
        imageURL = url
        image = nil
        activityIndicator.startAnimating()
        fetchImage(url: url)
    }
    
}


private extension ImageLoader {
    
    func setup() {
        addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    func fetchImage(url: URL) {
        network?.request(for: url,
                         receive: .main)
        .sink { [weak self] result in
            switch result {
            case .finished:
                print("Done")
            case .failure(let error):
                print(error)
            }
            self?.activityIndicator.stopAnimating()
            
        } receiveValue: { [weak self] data in
            if let imageToCache = UIImage(data: data) {
                if self?.imageURL == url {
                    self?.image = imageToCache
                }
            }
        }.store(in: &cancellable)
    }
}
