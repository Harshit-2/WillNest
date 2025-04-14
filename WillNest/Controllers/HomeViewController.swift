// HomeViewController.swift

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet var imageButtons: [UIButton]!
    @IBOutlet weak var testimonialCollectionView: UICollectionView!

    let testimonials: [UIImage] = [
        UIImage(named: "testimonial1")!,
        UIImage(named: "testimonial2")!,
        UIImage(named: "testimonial3")!,
        UIImage(named: "testimonial4")!,
        UIImage(named: "testimonial5")!
    ]
    
    var timer: Timer?
    var currentIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup for banner image
        bannerImageView.layer.cornerRadius = 15
        bannerImageView.clipsToBounds = true
        
        // Button styling
        for button in imageButtons {
            button.layer.borderWidth = 0
            button.layer.borderColor = UIColor.clear.cgColor
            button.layer.cornerRadius = 10
            button.clipsToBounds = true
        }

        // CollectionView setup
        setupCollectionView()
        
        // Hide back button
        self.navigationItem.hidesBackButton = true
    }
    
    func setupCollectionView() {
        // Register cell
        let nib = UINib(nibName: "TestimonialCell", bundle: nil)
        testimonialCollectionView.register(nib, forCellWithReuseIdentifier: "TestimonialCell")
        
        // Set delegates
        testimonialCollectionView.delegate = self
        testimonialCollectionView.dataSource = self
        
        // Configure collection view
        testimonialCollectionView.isPagingEnabled = true
        testimonialCollectionView.showsHorizontalScrollIndicator = false
        
        // Configure layout
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        // Make each cell the exact width of the collection view
        layout.itemSize = CGSize(
            width: testimonialCollectionView.frame.width,
            height: testimonialCollectionView.frame.height
        )
        
        testimonialCollectionView.collectionViewLayout = layout
        
        // Need to reload data here for proper initialization
        testimonialCollectionView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Update layout after all views have been positioned and sized correctly
        if let layout = testimonialCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.itemSize = testimonialCollectionView.frame.size
            testimonialCollectionView.collectionViewLayout.invalidateLayout()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Start auto-scroll after view appears
        startAutoScroll()
    }

    func startAutoScroll() {
        // Cancel any existing timer
        timer?.invalidate()
        
        // Initialize with first item
        if !testimonials.isEmpty {
            testimonialCollectionView.scrollToItem(
                at: IndexPath(item: currentIndex, section: 0),
                at: .centeredHorizontally,
                animated: false
            )
        }
        
        // Start new timer after a short delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.timer = Timer.scheduledTimer(
                timeInterval: 4.0,
                target: self,
                selector: #selector(self.scrollToNextTestimonial),
                userInfo: nil,
                repeats: true
            )
        }
    }

    @objc func scrollToNextTestimonial() {
        if testimonials.isEmpty { return }
        
        currentIndex = (currentIndex + 1) % testimonials.count
        
        testimonialCollectionView.scrollToItem(
            at: IndexPath(item: currentIndex, section: 0),
            at: .centeredHorizontally,
            animated: true
        )
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
    }
}

// MARK: - CollectionView DataSource & Delegate
extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return testimonials.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TestimonialCell", for: indexPath) as? TestimonialCell else {
            return UICollectionViewCell()
        }
        
        cell.imageView.image = testimonials[indexPath.item]
        return cell
    }
    
    // This ensures cells are sized exactly to the collection view's dimensions
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
}
