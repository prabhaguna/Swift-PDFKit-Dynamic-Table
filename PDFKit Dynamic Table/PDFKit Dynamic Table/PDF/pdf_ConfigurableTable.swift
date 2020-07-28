//
//  pdf_DailyData.swift
//  PDFKIT Example
//
//  Created by devmac02 on 7/27/20.
//  Copyright © 2020 prabha. All rights reserved.
//

import UIKit

protocol ConfigurableTableDataSource {
    
    func getPageTitle(table : ConfigurableTable!) -> String!
    func getPageLogo(table : ConfigurableTable!) -> String!

    func getHeaderVisiblity(table : ConfigurableTable!) -> Bool!
    func getSeperatorVisiblity(table : ConfigurableTable!) -> Bool!

    func getTableHeader(table : ConfigurableTable!) -> [String]?
    
    func getNoOfTabelRows(table : ConfigurableTable!) -> Int!
    func getTableRows(table : ConfigurableTable!, for indexRow: Int!) -> [ColumnCell]!
}


final class ConfigurableTable : NSObject {

    private var pageConfiguration : NSMutableDictionary!
    private var headerRow : [String] = [String]()
    private var rows : [[ColumnCell]] = [[ColumnCell]]()
    private var rowsCount : Int = 0
    private var pdfBuilder : PDFBuilder!

    var dataSource : ConfigurableTableDataSource? = nil {
        didSet {
            make_table()
        }
    }
    
    override init() {
        
        self.pdfBuilder = PDFBuilder.shared
    }
    
    func make_table()
    {
        pageConfiguration = NSMutableDictionary()
        pageConfiguration.setObject((dataSource?.getPageTitle(table: self))! as String, forKey: "Title" as NSCopying)
        pageConfiguration.setObject((dataSource?.getPageLogo(table: self))! as String, forKey: "Logo" as NSCopying)
        pageConfiguration.setObject(NSNumber(value: (dataSource?.getHeaderVisiblity(table: self))! as Bool), forKey: "HeaderVisiblity" as NSCopying)
        pageConfiguration.setObject(NSNumber(value: (dataSource?.getSeperatorVisiblity(table: self))! as Bool), forKey: "SeperatorVisiblity" as NSCopying)
        
        headerRow = (dataSource?.getTableHeader(table: self))! as [String]
        rowsCount = (dataSource?.getNoOfTabelRows(table: self))! as Int
        
        for index in 1...rowsCount  {
        
            let row : [ColumnCell] = (dataSource?.getTableRows(table: self, for: index))!
            rows.append(row)
        }
        
        pdfBuilder.configureTable(configDict: pageConfiguration, headerArray: headerRow, dataArray: rows)
    }
   
}

extension ConfigurableTable {

    static func make_string_cell(val : String!) -> ColumnCell
    {
        return ColumnCell(value: val,
                   cellDataType: .string,
                backGroundColor: UIColor.clear,
                foreGroundColor: UIColor.black,
                    fixedHeight: nil,
        fixedWidth_inPercentage: nil,
                       edgeInset: defaultEdgeInset,
       isColumnToCheckPageChange: true)
        
    }
    
    static func make_image_cell(imageName : String!) -> ColumnCell
    {
        return  ColumnCell(value: imageName,
                    cellDataType: .image,
                 backGroundColor: UIColor.clear,
                 foreGroundColor: UIColor.black,
                     fixedHeight: nil,
         fixedWidth_inPercentage: nil,
                       edgeInset: defaultEdgeInset,
       isColumnToCheckPageChange: true)
        
    }
    
    static func make_Arrayofstrings_cell(arrStrings : Array<String>) -> ColumnCell
    {
        return   ColumnCell(value: arrStrings,
                     cellDataType: .array,
                  backGroundColor: UIColor.clear,
                  foreGroundColor: UIColor.black,
                      fixedHeight: nil,
          fixedWidth_inPercentage: nil,
                        edgeInset: defaultEdgeInset,
        isColumnToCheckPageChange: true)
        
    }

}
