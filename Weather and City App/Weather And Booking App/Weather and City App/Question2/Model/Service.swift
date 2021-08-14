//
//  Service.swift
//  Question2
//
//  Created by User on 2021-04-22.
//  Copyright © 2021 Seneca. All rights reserved.
//

import Foundation
import UIKit
class Service {
    
    static func fetchImg(urlstr : String, complition : @escaping (UIImage?) -> Void )  {
        guard let url = URL(string: urlstr) else {return}
        
        guard let imagedata = try? Data(contentsOf: url) else{return}
        let image = UIImage(data: imagedata)
        DispatchQueue.main.async {
            complition(image)
        }
        
    }
   
}
class dataclass {
    
    static var shared = dataclass()
    private init () {}
    
    func getDataFromYh(url: String, complition: @escaping (weatherinfo)->Void) {
        //urlsession
        guard let url = URL(string: url) else {  return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data{
                if let list = try? JSONDecoder().decode(weatherinfo.self, from: data){
                    complition(list)
                }
            }
            }.resume()
    }
    
}
