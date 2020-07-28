//
//  PDFBuilder.swift
//  PDFKIT Example
//
//  Created by devmac02 on 7/24/20.
//  Copyright © 2020 prabha. All rights reserved.
//

import UIKit
import PDFKit

extension NSAttributedString {
    func height(withConstrainedWidth width: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)
        return ceil(boundingBox.height)
    }

    func width(withConstrainedHeight height: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)
        return ceil(boundingBox.width)
    }
}

class PDFBuilder: NSObject {

    var pdfView: PDFView!
    var pdfContents : Array<PDFContent> = Array<PDFContent>()
    private var pdfFiledata : Data?
    static let shared = PDFBuilder()
    
    //MARK:- PRIVATE FUNCTIONS
    private override init() {

    }
    
    private func getPDFData() -> Data {
        // default page format
        let pageWidth = 8.5 * 72.0
        let pageHeight = 11 * 72.0
        let pageRect = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: UIGraphicsPDFRendererFormat())
        let data = renderer.pdfData { context in
        
            for content in pdfContents {
                content.renderContent(pdfSize: pageRect.size, context: context)
            }
        }
        return data
    }
    
    private func createPDF() {
        pdfFiledata = getPDFData()
        pdfView.document = PDFDocument(data: pdfFiledata!)
        pdfView.autoScales = true
    }
   
    //MARK:- PUBLIC FUNCTIONS
    func configurePdf(pdfcontainerView : UIView!) {
        
        pdfView = PDFView()
        pdfView.translatesAutoresizingMaskIntoConstraints = false
        pdfcontainerView.addSubview(pdfView)
        pdfView.topAnchor.constraint(equalTo: pdfcontainerView.safeAreaLayoutGuide.topAnchor).isActive = true
        pdfView.leadingAnchor.constraint(equalTo: pdfcontainerView.leadingAnchor).isActive = true
        pdfView.trailingAnchor.constraint(equalTo: pdfcontainerView.trailingAnchor).isActive = true
        pdfView.bottomAnchor.constraint(equalTo: pdfcontainerView.safeAreaLayoutGuide.bottomAnchor).isActive = true
        createPDF()
    }
    
    func savePdf()
    {
        if let data = pdfFiledata {
        
            var docURL = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).last as NSURL?
            docURL = docURL?.appendingPathComponent( "Dynamic.pdf") as NSURL?

            do
            {
                try data.write(to: docURL! as URL)
                Generals.showAlert(title: "Message", message: "Pdf save successfully in DocumentDirectory!!!")
            }
            catch
            {
                Generals.showAlert(title: "Error", message: "Fail to save the pdf!!!")
            }
        }
    }
    
 
    
    func configureTable(configDict : NSMutableDictionary, headerArray : [String]?, dataArray : [[ColumnCell]])
    {
        let table = Table(configDict:configDict, tableDataItems:dataArray , tableDataHeaderTitles:headerArray)
        pdfContents.append(table)
    }

}



