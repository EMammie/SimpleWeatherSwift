//
//  WXViewController.swift
//  WeatherExample
//
//  Created by Mammie, Eugene on 11/16/16.
//  Copyright © 2016 com.Development. All rights reserved.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa
import Result

class WXController: UIViewController , UITableViewDataSource, UITableViewDelegate{

    var backgroundImageView : UIImageView = UIImageView()
    var blurredVisualEffectView : UIVisualEffectView = UIVisualEffectView()
    
    var tableView : UITableView = UITableView()
    var screenHeight : CGFloat =  0.0
    let manager = WXManager.sharedInstance()
    
    var hourlyFormatter : DateFormatter {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "h a"
        return dateformatter
    }
    var dailyFormatter : DateFormatter {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "EEEE"
        return dateformatter
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        manager.findCurrentLocation()
    }

    func setupUI() {
        view.backgroundColor = .clear
        
        self.screenHeight = UIScreen.main.bounds.size.height
        
        let background = UIImage(named:"bg")
        backgroundImageView = UIImageView(image: background)
        backgroundImageView.contentMode = UIViewContentMode.scaleAspectFit
        view.addSubview(self.backgroundImageView)
        
        let blurEffect = UIBlurEffect(style: .light)
        let blurredVisualEffectView = UIVisualEffectView(effect: blurEffect)
        blurredVisualEffectView.contentMode = UIViewContentMode.scaleAspectFill
        blurredVisualEffectView.alpha = 0
        blurredVisualEffectView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(blurredVisualEffectView)
        
        tableView.backgroundColor = UIColor.clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = UIColor(white: 1, alpha: 0.2)
        tableView.isPagingEnabled = true
        view.addSubview(self.tableView)
        
        // 1
        let headerFrame = UIScreen.main.bounds
        // 2
        let inset : CGFloat = 20
        // 3
        let temperatureHeight : CGFloat  = 110
        let hiloHeight : CGFloat = 40
        let iconHeight : CGFloat = 30
        // 4
        
        let hiloFrame : CGRect = CGRect(x:inset, y: headerFrame.size.height - hiloHeight, width:headerFrame.size.width - (2 * inset) , height: hiloHeight)
        
        let temperatureFrame = CGRect(x:inset,
                                      y:headerFrame.size.height - (temperatureHeight + hiloHeight), width:
            headerFrame.size.width, height:
            temperatureHeight)
        
        let iconFrame = CGRect(x:inset,
                               y:temperatureFrame.origin.y - iconHeight,
                               width:iconHeight,
                               height:iconHeight)
        // 5
        var conditionsFrame = iconFrame
        conditionsFrame.size.width = self.view.bounds.size.width - (((2 * inset) + iconHeight) + 10);
        conditionsFrame.origin.x = iconFrame.origin.x + (iconHeight + 10);
        
        let header = UIView(frame: headerFrame)
        header.backgroundColor = UIColor.clear
        tableView.tableHeaderView = header
        
        // 2
        // bottom left
        let temperatureLabel = UILabel(frame: temperatureFrame)
        temperatureLabel.backgroundColor = UIColor.clear
        temperatureLabel.textColor = UIColor.white
        temperatureLabel.text = "0°"
        temperatureLabel.font = UIFont(name: "HelveticaNeue-UltraLight", size: 120)
        header.addSubview(temperatureLabel)
        
        // bottom left
        let hiloLabel = UILabel(frame: hiloFrame)
        hiloLabel.backgroundColor = UIColor.clear
        hiloLabel.textColor = UIColor.white
        hiloLabel.text = "0° / 0°"
        hiloLabel.font = UIFont(name: "HelveticaNeue-UltraLight", size: 28)
        header.addSubview(hiloLabel)
        
        // top
        let cityFrame = CGRect(x:0, y:20, width:self.view.bounds.size.width, height: 30)
        let cityLabel = UILabel(frame: cityFrame)
        cityLabel.backgroundColor = UIColor.clear
        cityLabel.textColor = UIColor.white
        cityLabel.text = "Loading..."
        cityLabel.font = UIFont(name: "HelveticaNeue-UltraLight", size: 18)
        cityLabel.textAlignment = NSTextAlignment.center
        header.addSubview(cityLabel)
        
        let conditionsLabel = UILabel(frame: conditionsFrame)
        conditionsLabel.backgroundColor = UIColor.clear
        conditionsLabel.font = UIFont(name: "HelveticaNeue-UltraLight", size: 18)
        conditionsLabel.textColor = UIColor.white
        conditionsLabel.text = "Clear"
        header.addSubview(conditionsLabel)
        
        // bottom left
        let iconView = UIImageView(frame: iconFrame)
        iconView.contentMode = UIViewContentMode.scaleAspectFit
        iconView.backgroundColor = UIColor.clear
        iconView.image = UIImage(named: "weather-clear")
        header.addSubview(iconView)
        
        manager.currentCondition.signal.observe(on: UIScheduler()).observeValues{ newCondition in
            temperatureLabel.text = String(format:"%.0f" ,(newCondition?.temperature)!)
            conditionsLabel.text = newCondition?.condition.capitalized
            cityLabel.text = newCondition?.locationName.capitalized
            iconView.image = UIImage(named: (newCondition?.imageNamed())!)
        }
        
        let (hiloSignal, hiloObserver) = Signal<String,NoError>.pipe()
        manager.currentCondition.signal.skipNil().observe(on:UIScheduler()).observeValues { condition in
            hiloObserver.send(value:String(format: "%.0f° / %.0f°", condition.tempHigh,condition.tempLow))
        }
        hiloLabel.reactive.text <~ hiloSignal
        
        manager.dailyForcast.signal.observe(on:UIScheduler()).observeValues(){ forcasts in
            self.tableView.reloadData()
        }
        manager.hourlyForcast.signal.observe(on:UIScheduler()).observeValues(){ forcasts in
            self.tableView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillLayoutSubviews() {
        
        let bounds = self.view.bounds
        backgroundImageView.frame = bounds
        blurredVisualEffectView.frame = bounds
        tableView.frame = bounds
        
    }
    
    // MARK: - TableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 1
        if (section == 0) {
            return min(manager.hourlyForcast.value.count, 6) + 1
        }
        // 2
        return min(manager.dailyForcast.value.count, 6) + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "CellIdentifier"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) else {
            return UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: cellIdentifier)
        }
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            cell.backgroundColor = UIColor(white: 0, alpha: 0.2)
            cell.textLabel?.textColor = UIColor.white
            cell.detailTextLabel?.textColor = UIColor.white
            
            if (indexPath.section == 0) {
            
                if (indexPath.row == 0) {
                    self.configureHeaderCell(cell , title:"Hourly Forecast")
                }
                else {
                    let weather = manager.hourlyForcast.value[indexPath.row - 1]
                    self.configureHourlyCell(cell,weather: weather)

                }
            }
            else if (indexPath.section == 1) {
                // 1
                if (indexPath.row == 0) {
                    self.configureHeaderCell(cell, title:"Daily Forecast")
                }
                else {
                    // 3
                    let weather = manager.dailyForcast.value[indexPath.row - 1]
                    self.configureDailyCell(cell, weather:weather)
                }
            }
        
         return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellCount = self.tableView(tableView, numberOfRowsInSection: indexPath.section)
        return self.screenHeight / CGFloat(cellCount)
    }
    
    
    func scrollViewDidScroll(_ scrollView :UIScrollView){
        let height = scrollView.bounds.size.height
        let  position = max(scrollView.contentOffset.y, 0.0)
        let percent = min(position / height, 1.0)
        self.blurredVisualEffectView.alpha = percent
    }

    func configureHeaderCell(_ cell : UITableViewCell ,title: String) {
        cell.textLabel?.font = UIFont.init(name:"HelveticaNeue-Medium", size:18)
        cell.textLabel?.text = title
        cell.detailTextLabel?.text = ""
        cell.imageView?.image = nil
    }
    
    func configureHourlyCell(_ cell : UITableViewCell, weather: WXHourlyCondition){
        cell.textLabel?.font = UIFont.init(name:"HelveticaNeue-Light", size:18)
        cell.detailTextLabel?.font = UIFont.init(name:"HelveticaNeue-Medium", size:18)
        cell.textLabel?.text = self.hourlyFormatter.string(from:Date(timeIntervalSince1970: weather.dt))
        cell.detailTextLabel?.text = String.init(format:"%.0f°",weather.main.temp)
        cell.imageView?.image = UIImage(named: weather.imageNamed())
        cell.imageView?.contentMode = .scaleAspectFit
    }
    
    func configureDailyCell(_ cell : UITableViewCell , weather: WXDailyCondition ){
        cell.textLabel?.font = UIFont.init(name:"HelveticaNeue-Light", size:18)
        cell.detailTextLabel?.font = UIFont.init(name:"HelveticaNeue-Medium", size:18)
        let interval = TimeInterval(weather.time!)
        let time = Date(timeIntervalSince1970: interval)
        let date = self.dailyFormatter.string(from: time)
        cell.textLabel?.text = date 
        cell.detailTextLabel?.text = String(format: "%.0f° / %.0f°",weather.temp.max,weather.temp.min)
        cell.imageView?.image = UIImage(named: weather.imageNamed())
        cell.imageView?.contentMode = .scaleAspectFit
    }

}
