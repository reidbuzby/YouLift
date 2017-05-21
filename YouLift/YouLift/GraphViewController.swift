//
//  GraphViewController.swift
//  YouLift
//
//  Created by rbuzby on 5/15/17.
//  Copyright © 2017 rbuzby. All rights reserved.
//
//
//
//
//

import UIKit
import Charts


class GraphViewController: UIViewController, ChartViewDelegate {

    @IBOutlet weak var lineChartView: LineChartView!
    
    @IBOutlet weak var exerciseName: UILabel!
    
    var name: String = ""
    
    var exerciseData = [(Double, Date)]()
    var dates = [String]()
    var weights = [Double]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lineChartView.delegate = self
        
        lineChartView.gridBackgroundColor = UIColor.darkGray
        
        exerciseName.text = name
        
        self.view.backgroundColor = UIColor(hue: 0.0, saturation: 0.0, brightness: 0.51, alpha: 1.0)
        
        for exercise in exerciseData {
            weights.append(exercise.0)
        }
        
        lineChartView.backgroundColor = UIColor(hue: 0.0, saturation: 0.0, brightness: 0.51, alpha: 1.0)
        
        
        
        for exercise in exerciseData {
            var year = ""
            var index1 = exercise.1.description.index(exercise.1.description.startIndex, offsetBy: 2)
            var index2 = exercise.1.description.index(exercise.1.description.startIndex, offsetBy: 3)
            year.append(exercise.1.description[index1])
            year.append(exercise.1.description[index2])
            print(year)
            
            var month = ""
            index1 = exercise.1.description.index(exercise.1.description.startIndex, offsetBy: 5)
            index2 = exercise.1.description.index(exercise.1.description.startIndex, offsetBy: 6)
            month.append(exercise.1.description[index1])
            month.append(exercise.1.description[index2])
            
            var day = ""
            index1 = exercise.1.description.index(exercise.1.description.startIndex, offsetBy: 8)
            index2 = exercise.1.description.index(exercise.1.description.startIndex, offsetBy: 9)
            day.append(exercise.1.description[index1])
            day.append(exercise.1.description[index2])
            
            var date = month + "/" + day + "/" + year
            
            
            //dates.append(date)

        }
        print(dates)
        
        setChartData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    let months = ["Jan" , "Feb", "Mar", "Apr", "May", "June", "July", "August", "Sept", "Oct", "Nov", "Dec"]
    
    let dollars1 = [1453.0,2352,5431,1442,5451,6486,1173,5678,9234,1345,9411,2212]
    
    func setChartData() {
        var values : [ChartDataEntry] = [ChartDataEntry]()
        for i in 0 ..< weights.count {
            values.append(ChartDataEntry(x: Double(i), y: weights[i]))
        }
        
        let set1: LineChartDataSet = LineChartDataSet(values: values, label: "Weight (lbs)")
        
        set1.axisDependency = .left
        set1.setColor(UIColor(red: 0.73, green: 0.89, blue: 0.94, alpha: 1))
        set1.setCircleColor(UIColor(red: 0.73, green: 0.89, blue: 0.94, alpha: 1)) // our circle will be dark red
        set1.lineWidth = 2.0
        set1.circleRadius = 6.0 // the radius of the node circle
        set1.fillAlpha = 65 / 255.0
        set1.fillColor = UIColor(red: 0.73, green: 0.89, blue: 0.94, alpha: 1)
        set1.highlightColor = UIColor.white
        set1.drawCircleHoleEnabled = false
        
        var dataSets : [LineChartDataSet] = [LineChartDataSet]()
        dataSets.append(set1)
        
        let data: LineChartData = LineChartData(dataSets: dataSets)
        data.setValueTextColor(UIColor.white)
        
        //lineChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: dates)
        
        self.lineChartView.rightAxis.drawLabelsEnabled = false
        self.lineChartView.xAxis.drawLabelsEnabled = false
        
        self.lineChartView.xAxis.gridColor = UIColor.black
        self.lineChartView.leftAxis.gridColor = UIColor.black
        self.lineChartView.rightAxis.gridColor = UIColor.black
        self.lineChartView.borderColor = UIColor.black
        
        self.lineChartView.chartDescription?.text = ""
        
        
        self.lineChartView.data = data
        
        
        
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print(weights[Int(entry.x)])
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
