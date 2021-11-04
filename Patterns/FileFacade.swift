//
//  FileFacade.swift
//  Patterns
//
//  Created by Кристина Перегудова on 04.11.2021.
//

import Foundation

class StringUtility {
  func imageFileName(name: String) -> String {
    return "\(name).jpg"
  }
}

class FileUtility {
  let fileManager = FileManager.default
  
  func makePath(directory: FileManager.SearchPathDirectory,
                domain: FileManager.SearchPathDomainMask,
                fileName: String) -> URL {
    let directoryUrl = fileManager.urls(for: directory, in: domain).first!
    let destinationUrl = directoryUrl.appendingPathComponent(fileName)
    return destinationUrl
  }
  
  func downloadFile(directory: URL, url: URL) {
    let task = URLSession.shared.downloadTask(with: url) { (localUrl, response, error) in
      if let localUrl = localUrl, error == nil {
        do {
          let imageData = try Data(contentsOf: localUrl)
          try imageData.write(to: directory)
        } catch {
          // handle error
        }
      } else {
        // handle error
      }
    }
    task.resume()
  }
}

class FileFacade {
  let fileUtility = FileUtility()
  let stringUtility = StringUtility()
  
  func downloadImage(url: String, fileName: String, directory: FileManager.SearchPathDirectory,
                     domain: FileManager.SearchPathDomainMask) {
    guard let imageUrl = URL(string: url) else { return }
    
    let downloadFileName = stringUtility.imageFileName(name: fileName)
    let downloadPath = fileUtility.makePath(directory: directory, domain: domain, fileName: downloadFileName)
    
    fileUtility.downloadFile(directory: downloadPath, url: imageUrl)
  }
}

class FileViewModel {
  private let fileFacade = FileFacade()
  
  func downloadImage(from url: String = "https://interactive-examples.mdn.mozilla.net/media/cc0-images/grapefruit-slice-332-332.jpg") {
    fileFacade.downloadImage(url: url,
                             fileName: "tutorial",
                             directory: .documentDirectory,
                             domain: .userDomainMask)
  }
}
