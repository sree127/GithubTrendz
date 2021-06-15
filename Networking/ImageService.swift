//
//  ImageService.swift
//  GithubTrendz
//
//  Created by Sreejith Njamelil on 15.06.21.
//

import RxSwift
import Foundation

/// This class deals with ImageCaching
/// If a cached image is found, that is returned
/// If not, a new request is created for fetching the image

extension ImageService {
  struct Dependencies {
    let networkProvider: NetworkProvider
  }
}

final class ImageService {
  
  private let dependencies: Dependencies
  init(dependencies: Dependencies) {
    self.dependencies = dependencies
    imageCache.totalCostLimit = 10 * 1000
    imageCache.countLimit = 30
  }
  
  private let imageCache = NSCache<AnyObject, AnyObject>()
  private let imageDataCache = NSCache<AnyObject, AnyObject>()
  
  func imageFromURL(_ url: URL) -> Observable<UIImage?> {
    Observable.deferred { [unowned self] in
      let image = self.imageCache.object(forKey: url as AnyObject) as? UIImage
      
      let decodedImage: Observable<UIImage?>
      
      if let image = image {
        decodedImage = .just(image)
      } else {
        decodedImage = self.dependencies.networkProvider
          .requestAuthorImage(url: url)
          .asObservable()
          .take(1)
      }
      return decodedImage
        .do(onNext: { image in
          guard let image = image else { return }
          self.imageCache.setObject(image, forKey: url as AnyObject)
        })
    }
  }
}
