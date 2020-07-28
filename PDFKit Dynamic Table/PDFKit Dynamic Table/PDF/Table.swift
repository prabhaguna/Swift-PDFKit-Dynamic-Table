//
//  Table.swift
//  PDFKIT Example
//
//  Created by devmac02 on 7/25/20.
//  Copyright © 2020 prabha. All rights reserved.
//

import UIKit

public let defaultEdgeInset = UIEdgeInsets.zero

enum CellDataType {
    case string, attributedString, image, array
}

struct Row {
    let pageNumber : Int!
    let yPos : CGFloat!
    let ColumnElements : [ColumnCell]
    let height : CGFloat!
}

struct ColumnCell {

    let value : Any?
    let cellDataType : CellDataType?
    let backGroundColor : UIColor?
    let foreGroundColor : UIColor?
    let fixedHeight :  CGFloat?
    let fixedWidth_inPercentage :  CGFloat?
    let edgeInset : UIEdgeInsets!
    let isColumnToCheckPageChange :Bool!
}

let lineGrayColor = UIColor(red: 210.0/255.0, green: 210.0/255.0, blue: 210.0/255.0, alpha: 1.0)

final class Table: PDFContent {

    private let defaultOffset: CGFloat = 20
    private var columnWidth : CGFloat!
    private var pageSize: CGSize!
    private var yPos : CGFloat = 0

    private var tableConfiguration : NSMutableDictionary?
    private var tableDataHeaderTitles: [String]?
    private var tableDataItems: [[ColumnCell]]
    private var isShowHeader = true
    private var isShowSeperator = true
    
    init(configDict : NSMutableDictionary,  tableDataItems: [[ColumnCell]], tableDataHeaderTitles: [String]?) {
        self.tableDataItems = tableDataItems
        self.tableDataHeaderTitles = tableDataHeaderTitles
        self.tableConfiguration = configDict
        isShowHeader = (configDict.object(forKey: "HeaderVisiblity") as! NSNumber).boolValue
        isShowSeperator = (configDict.object(forKey: "SeperatorVisiblity") as! NSNumber).boolValue
    }

    override func renderContent(pdfSize: CGSize!, context : UIGraphicsPDFRendererContext!)
    {
        pageSize = pdfSize
        columnWidth = (pageSize.width - defaultOffset * 2) // full size
        if let headerTitles = tableDataHeaderTitles {
            columnWidth = (pageSize.width - defaultOffset * 2) / CGFloat(headerTitles.count)
        }
        
        let tableDataChunked: [[Row]] = seperateElementsByPage(with: pageSize)

        for tableDataChunk in tableDataChunked {
            context.beginPage()
            let cgContext = context.cgContext
            drawLogo_and_pageTitle(drawContext: cgContext, pageRect: pageSize)
            
            if(isShowHeader)
            {
               drawTableHeaderRect(drawContext: cgContext, pageRect: pageSize)
               
               if let headerTitles = tableDataHeaderTitles {
                  drawTableHeaderTitles(titles: headerTitles, drawContext: cgContext, pageRect: pageSize)
               }
            }

            drawTableContentInnerBordersAndText(drawContext: cgContext, pageRect: pageSize, tableDataItems: tableDataChunk)
        }

    }
    
    //MARK: - SPLIT TABLE IN TO PAGES
    private func seperateElementsByPage(with pageRect: CGSize) -> [[Row]]
    {
        var chunckedElements : [[Row]] = [[Row]]()
        
        let stringClnHeight = 30
        let imageClnHeight = 60
        let arrElementHeight = 30
        let pageTopPadding = (isShowHeader) ? 150 : 100
        let pageBottomPadding = 150
        var pageNumber = 1
        var ypos = pageTopPadding

        var pageElements : [Row] = [Row]()
        var rowIndex = 0
        var isTabelContainsGropedRow = false
        var groupCellsCount = 0
        
        while rowIndex < tableDataItems.count {
                
            let columns = tableDataItems[rowIndex]
            var expectedHeight = 0
            
            for index in 0...(columns.count - 1)
            {
                let column = columns[index]
                
                    if column.cellDataType == CellDataType.string
                    {
                        if(expectedHeight < stringClnHeight)
                        {
                            expectedHeight = stringClnHeight
                        }
                    }
                    else if column.cellDataType == CellDataType.attributedString
                    {
                        let aString : NSAttributedString = column.value as! NSAttributedString
                        var tabWidth = columnWidth
                        if let widthinConfig = column.fixedWidth_inPercentage {
                            tabWidth = columnWidth * (widthinConfig / 100)
                        }
                        let stringHeight = Int(aString.height(withConstrainedWidth: tabWidth!))
                        if(expectedHeight < stringHeight)
                        {
                            expectedHeight = stringHeight
                        }
                    }
                    else if column.cellDataType == CellDataType.image
                    {
                        if(expectedHeight < imageClnHeight)
                        {
                            expectedHeight = imageClnHeight
                        }
                    }
                    else if column.cellDataType == CellDataType.array
                    {
                        let clmnArray = column.value as! Array<Any>
                        let arrClmnHeight = clmnArray.count * arrElementHeight
                        
                        if(expectedHeight < arrClmnHeight)
                        {
                            expectedHeight = arrClmnHeight
                        }
                    }
                    
                    if let fixedHeight = column.fixedHeight {
                    
                        if(expectedHeight < Int(fixedHeight))
                        {
                            expectedHeight = Int(fixedHeight)
                        }
                    }
                    
                expectedHeight = expectedHeight + Int(column.edgeInset!.top + column.edgeInset!.bottom)
            }
            
            pageElements.append(Row(pageNumber: pageNumber, yPos: CGFloat(ypos), ColumnElements: columns, height: CGFloat(expectedHeight)))
            ypos = ypos + expectedHeight

            rowIndex = rowIndex + 1
       
            if let firstColumnInrow = columns.first {
        
                if (firstColumnInrow.isColumnToCheckPageChange == true) {
                
                    if(pageRect.height < CGFloat(ypos + pageBottomPadding)) //content excced the page
                    {
                        if(isTabelContainsGropedRow)
                        {
                            groupCellsCount = groupCellsCount + 1
                            //last page elements
                            for _ in 0..<groupCellsCount {
                                if(pageElements.count > 0)
                                {
                                    pageElements.removeLast()
                                }
                            }
                            rowIndex = rowIndex - groupCellsCount
                        }
                        
                        chunckedElements.append(pageElements)
                        pageElements = [Row]()
                        pageNumber = pageNumber + 1
                        ypos = pageTopPadding
                        groupCellsCount = 0
                        continue
                    }
                    else
                    {
                        if((rowIndex == tableDataItems.count)) //content excced the page
                        {
                            //remaing elements
                            chunckedElements.append(pageElements)
                            pageElements = [Row]()
                        }
                    }
                    groupCellsCount = 0
                }
                else
                {
                    isTabelContainsGropedRow = true
                    groupCellsCount = groupCellsCount + 1
                }
            }
        }
        
        return chunckedElements
    }

}

// Drawings
private extension Table {

    func drawLogo_and_pageTitle(drawContext: CGContext, pageRect: CGSize)
    {
        drawContext.saveGState()
        
        let Logo = self.tableConfiguration?.object(forKey: "Logo") as! String
        let image = UIImage(named: Logo)
        
        let heightRatio =  50 / image!.size.height // for logo fixed height as 50px
        
        let imageFrame = CGRect(x: pageRect.width - 200, y: 20, width: image!.size.width * heightRatio, height: 50)
        image?.draw(in: imageFrame)
        yPos = 80;
        
        let textFont =  UIFont(name: "Oswald-Regular", size: 25.0) //UIFont.systemFont(ofSize: 16.0, weight: .medium)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .left
        paragraphStyle.lineBreakMode = .byWordWrapping
        let titleAttributes = [
            NSAttributedString.Key.paragraphStyle: paragraphStyle,
            NSAttributedString.Key.font: textFont
        ]
        
        let title = self.tableConfiguration?.object(forKey: "Title")
        let attributedTitle = NSAttributedString(string: title as! String, attributes: titleAttributes as [NSAttributedString.Key : Any])
        let tabX = defaultOffset
        let textRect = CGRect(x: tabX,
                              y: 40,
                              width: 300,
                              height: 80)
        attributedTitle.draw(in: textRect)
    }

    func drawTableHeaderRect(drawContext: CGContext, pageRect: CGSize) {
        drawContext.saveGState()
        drawContext.setLineWidth(1.0)

        // Draw header's 1 bottom horizontal line
        drawContext.move(to: CGPoint(x: defaultOffset, y: yPos + defaultOffset * 3))
        drawContext.addLine(to: CGPoint(x: pageRect.width - defaultOffset, y: yPos + defaultOffset * 3))
        lineGrayColor.setStroke()
        drawContext.strokePath()

        // Draw header's 3 vertical lines
        drawContext.setLineWidth(1.0)
        drawContext.saveGState()

        drawContext.restoreGState()
    }

    func drawTableHeaderTitles(titles: [String], drawContext: CGContext, pageRect: CGSize) {
        // prepare title attributes
        let textFont =  UIFont(name: "Oswald-Regular", size: 15.0) //UIFont.systemFont(ofSize: 16.0, weight: .medium)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .left
        paragraphStyle.lineBreakMode = .byWordWrapping
        let titleAttributes = [
            NSAttributedString.Key.paragraphStyle: paragraphStyle,
            NSAttributedString.Key.font: textFont,
            NSAttributedString.Key.foregroundColor: UIColor(red: 56.0/255.0, green: 162.0/255.0, blue: 154.0/255.0, alpha: 1.0)
        ]

  
        let tabWidth = columnWidth!
        for titleIndex in 0..<titles.count {
            let attributedTitle = NSAttributedString(string: titles[titleIndex].capitalized, attributes: titleAttributes as [NSAttributedString.Key : Any])
            let tabX = CGFloat(titleIndex) * tabWidth
            let textRect = CGRect(x: tabX + defaultOffset,
                                  y: yPos + (defaultOffset * 3 / 2),
                                  width: tabWidth,
                                  height: defaultOffset * 2)
            attributedTitle.draw(in: textRect)
        }
        
        yPos = yPos + (defaultOffset * 3)
    }

    func drawTableContentInnerBordersAndText(drawContext: CGContext, pageRect: CGSize, tableDataItems: [Row]) {
        drawContext.setLineWidth(1.0)
        drawContext.saveGState()

        for elementIndex in 0..<tableDataItems.count {
            let row = tableDataItems[elementIndex]

            // Draw content's elements texts
            let textFont = UIFont(name: "Oswald-Light", size: 13.0)//UIFont.systemFont(ofSize: 13.0, weight: .regular)
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .left
            paragraphStyle.lineBreakMode = .byWordWrapping
           
            //let tabWidth = (pageRect.width - defaultOffset * 2) / CGFloat(3)
            
            let columns  = row.ColumnElements
            for (rowIndex, column) in columns.enumerated() {
                
                var tabWidth = CGFloat(columnWidth)
                
                if let widthinConfig = column.fixedWidth_inPercentage {
                    tabWidth = CGFloat(columnWidth) * (widthinConfig / 100)
                }
                let xPos = CGFloat(rowIndex) * tabWidth + defaultOffset

                //drawBackground
                if let clmBackgroundColor =  column.backGroundColor {
                
                    let bgView = UIView(frame: CGRect(x: xPos, y: row.yPos, width: tabWidth, height: row.height))
                    let bgRect = CGRect(x: xPos,
                                          y: row.yPos,
                                          width: tabWidth,
                                          height: row.height)
                    bgView.backgroundColor = clmBackgroundColor
                    bgView.drawHierarchy(in: bgRect, afterScreenUpdates: true)
                }
                
                tabWidth = tabWidth - (column.edgeInset.left + column.edgeInset.right)

                if column.cellDataType == CellDataType.string {
                    
                    let textAttributes = [
                        NSAttributedString.Key.paragraphStyle: paragraphStyle,
                        NSAttributedString.Key.font: textFont,
                        NSAttributedString.Key.foregroundColor : column.foreGroundColor
                    ]
                    var attributedText = NSAttributedString(string: "", attributes: textAttributes as [NSAttributedString.Key : Any])
                    attributedText = NSAttributedString(string: column.value as! String, attributes: textAttributes as [NSAttributedString.Key : Any])
                    
                    let midY = row.yPos + (row.height - attributedText.height(withConstrainedWidth: tabWidth)) / 2

                    let textRect = CGRect(x: xPos + column.edgeInset.left,
                                          y: midY,
                                          width: tabWidth,
                                          height: row.height)
                    attributedText.draw(in: textRect)
                }
                if column.cellDataType == CellDataType.attributedString {
                    
                    let attributedText = column.value as! NSMutableAttributedString
                    
                    if let foreGndColor = column.foreGroundColor {
                         attributedText.addAttributes([.foregroundColor : foreGndColor as Any], range: NSRange(location: 0, length: attributedText.length))
                    }
                    
                   
                    let midY = row.yPos + (row.height - attributedText.height(withConstrainedWidth: tabWidth)) / 2

                    let textRect = CGRect(x: xPos + column.edgeInset.left,
                                          y: midY,
                                          width: tabWidth,
                                          height: row.height)
                    attributedText.draw(in: textRect)
                }
                
                if column.cellDataType == CellDataType.image {
                    
                    let imgName = column.value as! String
                    let image = UIImage(named: imgName)
                    
                    //let midX = (tabX + defaultOffset) + (tabWidth - 50) / 2
                    let lX = xPos
                    let midY = row.yPos + (row.height - 50) / 2
                    
                    image?.draw(in: CGRect(x: lX, y: midY, width: 50, height: 50))
         
                }
                
                if column.cellDataType == CellDataType.array{
                    
                    let textAttributes = [
                        NSAttributedString.Key.paragraphStyle: paragraphStyle,
                        NSAttributedString.Key.font: textFont,
                        NSAttributedString.Key.foregroundColor : column.foreGroundColor
                    ]
                    
                    let clnArr = column.value as! Array<Any>
                    
                    var clstring = ""
                    for strVal in clnArr {
                    
                        if(clstring.count != 0)
                        {
                            clstring = clstring + "\n"
                        }
                        clstring = clstring + (strVal as! String)
                    }
                    
                    var attributedText = NSAttributedString(string: "", attributes: textAttributes as [NSAttributedString.Key : Any])
                    attributedText = NSAttributedString(string: clstring , attributes: textAttributes as [NSAttributedString.Key : Any])
                    
                    let midY = row.yPos + (row.height - attributedText.height(withConstrainedWidth: tabWidth)) / 2

                    let textRect = CGRect(x: xPos + column.edgeInset.left,
                                          y: midY,
                                          width: tabWidth,
                                          height: row.height)
                    attributedText.draw(in: textRect)
                }
                
            }

            if(isShowSeperator)
            {
                // Draw content's element bottom horizontal line
                drawContext.move(to: CGPoint(x: defaultOffset, y: row.yPos + row.height))
                drawContext.addLine(to: CGPoint(x: pageRect.width - defaultOffset, y: row.yPos + row.height))
                lineGrayColor.setStroke()
                drawContext.strokePath()
            }

        }
        drawContext.restoreGState()
    }
}
