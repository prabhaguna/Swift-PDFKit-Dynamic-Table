//
//  pdf_asthma_Control_Tests.swift
//  PDFKIT Example
//
//  Created by devmac02 on 7/27/20.
//  Copyright © 2020 Sempercon. All rights reserved.
//

import UIKit

let blueHeaderBg = UIColor(red: 56.0/255, green: 158.0/255, blue: 150.0/255, alpha: 1.0)

struct asthmaTest {

    let header : String!
    let score  : String!
    let desc   : String!
}


protocol asthma_Control_Tests_DataSource {
    
    func getNoOfTabelRows_for_asthma_Control_Tests(table : asthma_Control_Tests!) -> Int!
    func getTableRows_for_asthma_Control_Tests(table : asthma_Control_Tests!, for indexRow: Int!) -> asthmaTest!
}

final class asthma_Control_Tests {
    
    private var pageConfiguration : NSMutableDictionary!
    private var rows : [[ColumnCell]] = [[ColumnCell]]()
    private var rowsCount : Int = 0
    private var pdfBuilder : PDFBuilder!
    
    var dataSource : asthma_Control_Tests_DataSource? = nil {
        
        didSet {
            
            configure_asthma_Control_Tests()
            rowsCount = (dataSource?.getNoOfTabelRows_for_asthma_Control_Tests(table: self))! as Int

            for index in 1...rowsCount  {
            
                let row : asthmaTest = (dataSource?.getTableRows_for_asthma_Control_Tests(table: self, for: index))!
                make_asthma_Control_Tests_row(asthmaTest: row)
            }
            
            pdfBuilder.configureTable(configDict: pageConfiguration, headerArray: nil, dataArray: rows)
        }
    
    }

    init(pdfBuilder : PDFBuilder) {
        
        self.pdfBuilder = pdfBuilder
    }
    
    private func configure_asthma_Control_Tests()
    {
        pageConfiguration = NSMutableDictionary()
        pageConfiguration.setObject("Asthma Control Tests", forKey: "Title" as NSCopying)
        pageConfiguration.setObject(NSNumber(value: false), forKey: "HeaderVisiblity" as NSCopying)
        pageConfiguration.setObject(NSNumber(value: false), forKey: "SeperatorVisiblity" as NSCopying)

    }
    
    private func make_asthma_Control_Tests_row(asthmaTest : asthmaTest!)
    {
    
            let defaultedgeinset = UIEdgeInsets(top: 10, left: 20, bottom: 20, right: 0)

            //HEADER TREATED AS ROW WITH ONE COLUMN
            var headerColumn : [ColumnCell] = [ColumnCell]()
            let header = asthma_Control_Tests.makeHeader(header: asthmaTest.header)
            
            headerColumn.append(ColumnCell(value: header,
                              cellDataType: .attributedString,
                           backGroundColor: blueHeaderBg,
                           foreGroundColor: UIColor.white,
                               fixedHeight: 30,
                   fixedWidth_inPercentage: 50,
                                 edgeInset: defaultedgeinset,
                 isColumnToCheckPageChange: false))
            rows.append(contentsOf: [headerColumn])
            
            //SCORE TREATED AS ROW WITH ONE COLUMN
            var scoreColumn : [ColumnCell] = [ColumnCell]()
            let ascore = asthma_Control_Tests.makeScore(score: asthmaTest.score)
            
            scoreColumn.append(ColumnCell(value: ascore,
                               cellDataType: .attributedString,
                            backGroundColor: UIColor.clear,
                            foreGroundColor: UIColor.black,
                                fixedHeight: nil,
                    fixedWidth_inPercentage: 50,
                                  edgeInset: UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 0),
                  isColumnToCheckPageChange: false))
            rows.append(contentsOf: [scoreColumn])
            
            //DESC TREATED AS ROW WITH ONE COLUMN
            var descColumn: [ColumnCell] = [ColumnCell]()
            let adesc = asthma_Control_Tests.makeDescription(desc: asthmaTest.desc)
           
            descColumn.append(ColumnCell(value: adesc,
                                  cellDataType: .attributedString,
                               backGroundColor: UIColor.clear,
                               foreGroundColor: UIColor.black,
                                   fixedHeight: nil,
                       fixedWidth_inPercentage: 50,
                                     edgeInset: UIEdgeInsets(top: 0, left: 20, bottom: 50, right: 0),
                     isColumnToCheckPageChange: true))
            rows.append(contentsOf: [descColumn])
            
    }
   
}

extension asthma_Control_Tests {

    private static func makeHeader(header : String!) -> NSMutableAttributedString
    {
        let aHeder = NSMutableAttributedString(string: header)
            aHeder.addAttributes([.font:UIFont(name: "OpenSans-Bold", size: 22) as Any], range: NSRange(location: 0, length: aHeder.length))
        return aHeder
    }
    
    private static func makeScore(score : String!) -> NSMutableAttributedString
    {
       let aScore = NSMutableAttributedString(string: "Score: ")
            aScore.addAttributes([.font:UIFont(name: "OpenSans", size: 18) as Any], range: NSRange(location: 0, length: aScore.length))
            
       let aScoreVal = NSMutableAttributedString(string: score)
            aScoreVal.addAttributes([.font:UIFont(name: "OpenSans-Bold", size: 18) as Any], range: NSRange(location: 0, length: aScoreVal.length))
        aScore.append(aScoreVal)
        return aScore
    }
    
    private static func makeDescription(desc : String!) -> NSMutableAttributedString
    {

      let aDesc = NSMutableAttributedString(string: desc)
            aDesc.addAttributes([.font:UIFont(name: "OpenSans", size: 15) as Any], range: NSRange(location: 0, length: aDesc.length))
      return aDesc
    }

}
