//
//  WXViewController.swift
//  WeatherExample
//
//  Created by Mammie, Eugene on 11/16/16.
//  Copyright © 2016 com.Development. All rights reserved.
//

import UIKit
import LBBlurredImage

class WXController: UIViewController , UITableViewDataSource, UITableViewDelegate{

    var backgroundImageView : UIImageView = UIImageView()
    var blurredImageView : UIImageView = UIImageView()
    var tableView : UITableView = UITableView()
    var screenHeight : CGFloat =  0.0
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.red
        
        self.screenHeight = UIScreen.main.bounds.size.height;
        
        let background = UIImage(named:"bg")
        
        // 2
        backgroundImageView = UIImageView.init(image: background)
        backgroundImageView.contentMode = UIViewContentMode.scaleAspectFit
        view.addSubview(self.backgroundImageView)
        
        // 3
        blurredImageView.contentMode = UIViewContentMode.scaleAspectFill
        blurredImageView.alpha = 0
        
        blurredImageView.setImageToBlur(background, completionBlock: nil)
        view.addSubview(blurredImageView)
        
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
        
        let header = UIView.init(frame: headerFrame)
        header.backgroundColor = UIColor.clear
        tableView.tableHeaderView = header
        
        // 2
        // bottom left
        let temperatureLabel = UILabel.init(frame: temperatureFrame)
        temperatureLabel.backgroundColor = UIColor.clear
        temperatureLabel.textColor = UIColor.white
        temperatureLabel.text = "0°"
        temperatureLabel.font = UIFont.init(name: "HelveticaNeue-UltraLight", size: 120)
        header.addSubview(temperatureLabel)
        
        // bottom left
        let hiloLabel = UILabel.init(frame: hiloFrame)
        hiloLabel.backgroundColor = UIColor.clear
        hiloLabel.textColor = UIColor.white
        hiloLabel.text = "0° / 0°"
        hiloLabel.font = UIFont.init(name: "HelveticaNeue-UltraLight", size: 28)
        header.addSubview(hiloLabel)
        
        // top
        let cityFrame = CGRect(x:0, y:20, width:self.view.bounds.size.width, height: 30)
        let cityLabel = UILabel.init(frame: cityFrame)
        cityLabel.backgroundColor = UIColor.clear
        cityLabel.textColor = UIColor.white
        cityLabel.text = "Loading..."
        cityLabel.font = UIFont.init(name: "HelveticaNeue-UltraLight", size: 18)
        cityLabel.textAlignment = NSTextAlignment.center
        header.addSubview(cityLabel)
        
        let conditionsLabel = UILabel.init(frame: conditionsFrame)
        conditionsLabel.backgroundColor = UIColor.clear
        conditionsLabel.font = UIFont.init(name: "HelveticaNeue-UltraLight", size: 18)
        conditionsLabel.textColor = UIColor.white
        conditionsLabel.text = "Clear"
        header.addSubview(conditionsLabel)
        
        // 3
        // bottom left
        let iconView = UIImageView.init(frame: iconFrame)
        iconView.contentMode = UIViewContentMode.scaleAspectFit
        iconView.backgroundColor = UIColor.clear
        iconView.image = UIImage(named: "weather-clear")
        header.addSubview(iconView)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillLayoutSubviews() {
        
        let bounds = self.view.bounds
        
        backgroundImageView.frame = bounds
        blurredImageView.frame = bounds
        tableView.frame = bounds
        
    }
    // MARK: - TableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // TODO: Return count of forecast
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "CellIdentifier"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        
        if (!(cell != nil)){
            
            cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: cellIdentifier)
        }
            cell?.selectionStyle = UITableViewCellSelectionStyle.none
            cell?.backgroundColor = UIColor.init(white: 0, alpha: 0.2)
            cell?.textLabel?.textColor = UIColor.white
            cell?.detailTextLabel?.textColor = UIColor.white
        
        //TODO:Setup The cell
        
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // TODO: Determine cell height based on screen
        return 44
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
