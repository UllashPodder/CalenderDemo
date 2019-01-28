//
//  ViewController.swift
//  CalenderDemo
//
//  Created by Ullash Podder on 1/24/19.
//  Copyright © 2019 Ullash Podder. All rights reserved.
//

import UIKit
import JTAppleCalendar

class ViewController: UIViewController{
    let formatter = DateFormatter()
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    let todayTextColor = UIColor.red
    let thisMonthTextColor = UIColor.black
    let selectedDateTextColor = UIColor.white
    let invalidDayTextColor = UIColor.white
    var selectedDays:[Date]?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        // CVCalendarMenuView initialization with frame
        setupCalendarView()
    }
    // MARK: - JTAppleCalendar helper functions
    func handleCellView(cell:JTAppleCell?, cellState:CellState){
        guard let validCell = cell as? CustomCalendarCell else { return }
        if cellState.isSelected{
            validCell.selectedView.isHidden = false
            validCell.dateLabel.textColor = selectedDateTextColor
        }
        else{
            if cellState.dateBelongsTo == .thisMonth{
                validCell.dateLabel.textColor = thisMonthTextColor
                if Calendar.current.isDate( cellState.date, inSameDayAs:Date()){
                    validCell.dateLabel.textColor = todayTextColor
                }
            }
            else{
                validCell.dateLabel.textColor = invalidDayTextColor
            }
            validCell.selectedView.isHidden = true
        }
    }
    func handleCellSelectDeselect(cell:JTAppleCell?, cellState:CellState){
        guard let validCell = cell as? CustomCalendarCell else { return }
        if cellState.isSelected{
            if (cellState.dateBelongsTo == .thisMonth) && (Calendar.current.isDate( cellState.date, inSameDayAs:Date()) || cellState.date>Date()){
                validCell.selectedView.isHidden = false
                validCell.dateLabel.textColor = selectedDateTextColor
            }
            else{
                calendarView.deselect(dates: [cellState.date])
            }
        }
        else{
            validCell.selectedView.isHidden = true
            validCell.dateLabel.textColor = thisMonthTextColor
        }
        print("selected dates:\(calendarView.selectedDates)")
    }
    func setupCalendarView() {
        calendarView.calendarDelegate = self
        calendarView.calendarDataSource = self
        calendarView.minimumLineSpacing = 0
        calendarView.minimumInteritemSpacing = 0
        calendarView.allowsMultipleSelection = true
    }
    
}
// MARK: - JTAppleCalendar View and DataSource

extension ViewController: JTAppleCalendarViewDataSource{
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        
    }
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        let today : Date = Date()//.beginningOfMonth
        let startDate = today
        let endDate = Calendar.current.date(byAdding: .month, value: 2, to: today)

        let parameters = ConfigurationParameters(startDate: startDate, endDate: endDate!)
        return parameters
    }

}
extension ViewController: JTAppleCalendarViewDelegate{

    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CustomCalendarCell", for: indexPath) as! CustomCalendarCell
        cell.dateLabel.text = cellState.text
        handleCellView(cell: cell, cellState: cellState)

        return cell
    }
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleCellSelectDeselect(cell: cell, cellState: cellState)

    }
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleCellView(cell: cell, cellState: cellState)
    }
    
}
