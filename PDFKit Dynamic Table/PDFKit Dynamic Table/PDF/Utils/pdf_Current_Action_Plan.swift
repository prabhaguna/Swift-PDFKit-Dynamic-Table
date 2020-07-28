//
//  pdf_Current_Action_Plan.swift
//  PDFKIT Example
//
//  Created by devmac02 on 7/28/20.
//  Copyright © 2020 Sempercon. All rights reserved.
//

import UIKit

struct Action_Plan_colors {
    let green : UIColor     = UIColor(red: 142.0/255.0, green: 171.0/255.0, blue: 4.0/255.0, alpha: 1.0)
    let yellow : UIColor!   = UIColor(red: 231.0/255.0, green: 167.0/255.0, blue: 12.0/255.0, alpha: 1.0)
    let red : UIColor!      = UIColor(red: 161.0/255.0, green: 18.0/255.0, blue: 6.0/255.0, alpha: 1.0)
    
    static let shared = Action_Plan_colors()
    
    private init(){
    
    }
}

struct Action_Plan_Title {
    let title : String?
    let desc  : String?
    let bgColor  : UIColor?
}

protocol Current_Action_Plan_DataSource {
    
    func getNoOfTabelSections_for_Current_Action_Plan(table : Current_Action_Plan!) -> Int!
    func getNoOfTabelRows_for_Current_Action_Plan(table : Current_Action_Plan!, for section : Int!) -> Int!
    func get_action_plan_section_titles(table: Current_Action_Plan, for section : Int!) -> Action_Plan_Title?
    func get_action_plan_section_Info(table : Current_Action_Plan!,for section : Int!,row : Int!) -> [NSMutableAttributedString]?

}



final class Current_Action_Plan : NSObject {

    private var pageConfiguration : NSMutableDictionary!
    private var rows : [[ColumnCell]] = [[ColumnCell]]()
    private var sectionsCount : Int = 0
    private var rowsCount : Int = 0
    private var pdfBuilder : PDFBuilder!
    
    var dataSource : Current_Action_Plan_DataSource? = nil {
        
        didSet {
            
            configure_Current_Action_Plan()
            sectionsCount = (dataSource?.getNoOfTabelSections_for_Current_Action_Plan(table: self))! as Int

            for sectionIndex in 0..<sectionsCount  {
            
                if  let row  = dataSource?.get_action_plan_section_titles(table: self, for: sectionIndex){
                    let sectionCell = Current_Action_Plan.make_Current_Action_Plan_Title(action_Plan_Title: row)
                    rows.append([sectionCell])
                }
               
                
                let rowCount = (dataSource?.getNoOfTabelRows_for_Current_Action_Plan(table: self, for: sectionIndex))! as Int
                
                for rowIndex in 0..<rowCount  {
                
                    let ColumContent : [NSMutableAttributedString] = (dataSource?.get_action_plan_section_Info(table: self, for: sectionIndex, row: rowIndex))!
                    
                    var columns = [ColumnCell]()
                    
                    for aString in ColumContent {
                        columns.append(Current_Action_Plan.make_Current_Action_Plan_Zone_column(aInfo: aString))
                    }
                    rows.append(columns)
                }
            }
            
            pdfBuilder.configureTable(configDict: pageConfiguration, headerArray: nil, dataArray: rows)
        }
    
    }
    
    init(pdfBuilder : PDFBuilder) {
        self.pdfBuilder = pdfBuilder
    }
    
    private func configure_Current_Action_Plan()
    {
        pageConfiguration = NSMutableDictionary()
        pageConfiguration.setObject("Current Action Plan", forKey: "Title" as NSCopying)
        pageConfiguration.setObject(NSNumber(value: false), forKey: "HeaderVisiblity" as NSCopying)
        pageConfiguration.setObject(NSNumber(value: false), forKey: "SeperatorVisiblity" as NSCopying)

    }
    

}

extension Current_Action_Plan {

    static func make_Current_Action_Plan_Title(action_Plan_Title : Action_Plan_Title) -> ColumnCell
    {
        let atitle = NSMutableAttributedString(string: action_Plan_Title.title! + " ")
            atitle.addAttributes([.font:UIFont(name: "Oswald-Regular", size: 18) as Any], range: NSRange(location: 0, length: atitle.length))
            
        let adesc = NSMutableAttributedString(string: action_Plan_Title.desc!)
            adesc.addAttributes([.font:UIFont(name: "Oswald-Regular", size: 14) as Any], range: NSRange(location: 0, length: adesc.length))
        atitle.append(adesc)
    
        return    ColumnCell(value: atitle,
                      cellDataType: .attributedString,
                   backGroundColor: action_Plan_Title.bgColor,
                   foreGroundColor: UIColor.white,
                       fixedHeight: nil,
           fixedWidth_inPercentage: 100,
                         edgeInset: UIEdgeInsets(top: 0, left: 20, bottom: 10, right: 0),
         isColumnToCheckPageChange: true)
    }
    
    static func make_Current_Action_Plan_Zone_column(aInfo : NSAttributedString) -> ColumnCell
    {
        
        return    ColumnCell(value: aInfo,
                      cellDataType: .attributedString,
                   backGroundColor: UIColor.clear,
                   foreGroundColor: nil,
                       fixedHeight: nil,
           fixedWidth_inPercentage: 50,
                         edgeInset: UIEdgeInsets(top: 5, left: 20, bottom: 5, right: 0),
         isColumnToCheckPageChange: true)
    }
}
