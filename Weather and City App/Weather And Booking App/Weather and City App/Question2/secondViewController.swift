//
//  secondViewController.swift
//  Question2
//
//  Created by User on 2021-04-22.
//  Copyright © 2021 Seneca. All rights reserved.
//

import UIKit
import CoreData
class secondViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
       

        // Do any additional setup after loading the view.
    }
    let myappdelegate = UIApplication.shared.delegate as! AppDelegate
    override func resignFirstResponder() -> Bool {
        tripnametxtfld.resignFirstResponder()
        citnametxtfld.resignFirstResponder()
        return true
    }
    
    @IBOutlet weak var tripnametxtfld: UITextField!
    
    @IBOutlet weak var citnametxtfld: UITextField!
    
    @IBAction func addbttn(_ sender: UIButton) {
        
        let city = citnametxtfld.text
        let url = "https://api.openweathermap.org/data/2.5/weather?q=\(city ?? "toronto")&appid=8bc9a9a6c42c033b59e5c916ab386cd9"
        
        //getDataFromYh1(url: url)
        dataclass.shared.getDataFromYh(url: url) { (data) in
            DispatchQueue.main.async { [unowned self] in
                self.datastore = data
            }
        }
        
        let alert = UIAlertController(title: "Saved", message: "City and Trip name has been saved", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
        self.view.endEditing(true)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    var datastore : weatherinfo?{
        didSet{
            let myweather = Myweather(context: CoreDataStack.share.persistentContainer.viewContext)
            myweather.cityname = citnametxtfld.text
            myweather.tripname = tripnametxtfld.text
            myweather.temp = datastore?.main.temp ?? 0
            myweather.icon = datastore?.weather[0].icon
            CoreDataStack.share.saveContext()
        }
    }
    

    
}
