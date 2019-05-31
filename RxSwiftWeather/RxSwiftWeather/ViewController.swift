//
//  ViewController.swift
//  RxSwiftWeather
//
//  Created by Federico Nieto on 30/05/2019.
//  Copyright © 2019 Federico Nieto. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var cityTextField: UITextField!
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        cityTextField.rx.controlEvent(.editingDidEndOnExit)
        .asObservable()
        .map{
            self.cityTextField.text
        }
        .subscribe(onNext: {city in
            if let city = city {
                if city.isEmpty {
                    self.displayWeather(weather: nil)
                } else {
                    self.searchWeatherData(for: city)
                }
            }
        }).disposed(by: disposeBag)
    }
    
    private func searchWeatherData(for city: String) {
        guard let encodedCity = city.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
            return
        }
        let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(encodedCity)&APPID=ae74dab1543fd87d3535d3179124fce9")!
        let resource = Resource<WeatherResult>(url: url)
        
        let search = URLRequest.load(resource: resource)
        .observeOn(MainScheduler.instance)
        .asDriver(onErrorJustReturn: WeatherResult.empty)
        
        search.map { "\($0.main.temp) 🌡" }
        .drive(self.tempLabel.rx.text)
        .disposed(by: disposeBag)
        
        search.map { "\($0.main.humidity) 💦" }
        .drive(self.humidityLabel.rx.text)
        .disposed(by: disposeBag)
        
    }
    
    private func displayWeather(weather: Weather?) {
        if let weather = weather {
            self.tempLabel.text = ("\(weather.temp) 🌡")
            self.humidityLabel.text = ("\(weather.humidity) 💦")
        } else {
            self.tempLabel.text = "🌡"
            self.humidityLabel.text = "💦"
        }
        
    }


}

