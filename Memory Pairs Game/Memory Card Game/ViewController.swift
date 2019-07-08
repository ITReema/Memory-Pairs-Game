//
//  ViewController.swift
//  Memory Pairs Game
//
//  Created by mac_os on 03/11/1440 AH.
//  Copyright © 1440 mac_os. All rights reserved.
//

import UIKit

class ViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    @IBOutlet var collectionBackground: UIImageView!
    var cards = [URL]()
    var selectedCards = [Card]() {
        didSet {
            if self.selectedCards.count == 2 {
                compareCards(self.selectedCards)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionBackground.image = #imageLiteral(resourceName: "Background")
        flags()
    }
    
    //override var prefersStatusBarHidden: Bool { return true }
    
    fileprivate func flags() {
        if let paths = Bundle.main.urls(forResourcesWithExtension: "jpg", subdirectory: "Flags.bundle") {
            cards += paths
            cards.shuffle()
            cards.removeSubrange(12...cards.count - 1)
            cards += cards
            cards.shuffle()
        }
    }
    
    fileprivate func compareCards(_ cards: [Card]) {
        
        guard let first = cards.first?.name else { return }
        guard let last = cards.last?.name else { return }
        
        if first == last {
            selectedCards.removeAll(keepingCapacity: true)
            
            cards.forEach { [weak self] card in
                if let cell = self?.collectionView.cellForItem(at: card.indexPath) as? CollectionViewCell {
                    UIView.animate(withDuration: 0.3, animations:  {
                        cell.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
                    }) { finished in
                        UIView.animate(withDuration: 0.5, animations: {
                            cell.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                        })
                    }
                }
            }
        } else {
            selectedCards.removeAll(keepingCapacity: true)
            
            cards.forEach { (card) in
                
                if let cell = collectionView.cellForItem(at: card.indexPath) as? CollectionViewCell {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                        
                        UIView.transition(from: cell.frontImageView, to: cell.backImageView, duration: 0.4, options: .transitionFlipFromLeft, completion: nil)
                        cell.backImageView.isHidden = false
                        cell.frontImageView.isHidden = true
                    })
                }
            }
        }
    }
}

extension ViewController {
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let cell = collectionView.cellForItem(at: indexPath) as? CollectionViewCell else { return }
        
        if cell.frontImageView.isHidden {
            
            let url = cards[indexPath.item]
            let image = UIImage(contentsOfFile: url.path)
            let filename = url.lastPathComponent
            
            UIView.transition(from: cell.backImageView,
                              to: cell.frontImageView,
                              duration: 0.2,
                              options: .transitionFlipFromRight,
                              completion: { [weak self] _ in
                                
                                cell.backImageView.isHidden = true
                                cell.frontImageView.isHidden = false
                                cell.frontImageView.image = image
                                
                                self?.selectedCards.append(Card(name: filename, indexPath: indexPath))
            })
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let padding: CGFloat = 350
        let size = (UIScreen.main.bounds.width - padding) / 5
        return CGSize(width: size, height: size)
    }
}

extension ViewController {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cards.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? CollectionViewCell
            else { fatalError("Error") }
        
        cell.transform = .identity
        cell.isHidden = false
        
        cell.backImageView.isHidden = false
        cell.frontImageView.isHidden = true
        cell.backImageView.image = #imageLiteral(resourceName: "card")
        
        if cell.isHidden {
            cell.isHidden = false
        }
        
        return cell
    }
}

extension UIView {
    func fillSuperview() {
        guard let superview = self.superview else { return }
        translatesAutoresizingMaskIntoConstraints = superview.translatesAutoresizingMaskIntoConstraints
        if translatesAutoresizingMaskIntoConstraints {
            autoresizingMask = [.flexibleWidth, .flexibleHeight]
            frame = superview.bounds
        } else {
            topAnchor.constraint(equalTo: superview.topAnchor).isActive = true
            bottomAnchor.constraint(equalTo: superview.bottomAnchor).isActive = true
            leftAnchor.constraint(equalTo: superview.leftAnchor).isActive = true
            rightAnchor.constraint(equalTo: superview.rightAnchor).isActive = true
        }
    }
}

