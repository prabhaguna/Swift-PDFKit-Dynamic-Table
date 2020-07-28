//
//  ViewController.swift
//  PDFKit Dynamic Table
//
//  Created by devmac02 on 7/28/20.
//  Copyright © 2020 prabha. All rights reserved.
//

import UIKit

class ViewController: UIViewController,ConfigurableTableDataSource {
   
    var pdftable : ConfigurableTable? = nil
    

    //MARK: - VIEW DELEGATES
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        title = "PDFKit Dynamic Table"
        
        let btnCreatePdf = UIBarButtonItem(title: "Create", style: .done, target: self, action: #selector(btnCreatePdfClicked(sender:)))
        navigationItem.leftBarButtonItem = btnCreatePdf
        
        let btnSavesPdf = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(btnSavePdfClicked(sender:)))
        navigationItem.rightBarButtonItem = btnSavesPdf
        changeSaveBtnState(isEnable: false)
        
    }
    
    //MARK: - BUTTON ACTIONS
    @IBAction func btnCreatePdfClicked(sender : UIBarButtonItem){
        self.createPDF()
        changeSaveBtnState(isEnable: true)
    }
    
    @IBAction func btnSavePdfClicked(sender : UIBarButtonItem){
        PDFBuilder.shared.savePdf()
        changeSaveBtnState(isEnable: false)
    }
    
    
    //MARK: - PRIVATE FUNCTIONS
    func createPDF()
    {
        pdftable = ConfigurableTable()
        pdftable!.dataSource = self
        PDFBuilder.shared.configurePdf(pdfcontainerView: self.view)
    }
    
    func changeSaveBtnState(isEnable : Bool)
    {
        self.navigationItem.rightBarButtonItem!.isEnabled = isEnable;
    }

    //MARK: - CONFIGURABLE TABLE DATA SOURCE
    func getPageLogo(table: ConfigurableTable!) -> String! {
        "Logo.png"
    }
    
    func getPageTitle(table: ConfigurableTable!) -> String! {
        "MY PDF"
    }
    
    func getHeaderVisiblity(table: ConfigurableTable!) -> Bool! {
        true
    }
    
    func getSeperatorVisiblity(table: ConfigurableTable!) -> Bool! {
        true
    }
    
    func getTableHeader(table: ConfigurableTable!) -> [String]? {
        var header : [String] = [String]()
        header.append("String")
        header.append("Image")
        header.append("Array of Strings")
        return header
    }
    
    func getNoOfTabelRows(table: ConfigurableTable!) -> Int! {
        25
    }
    
    func getTableRows(table: ConfigurableTable!, for indexRow: Int!) -> [ColumnCell]! {
        
         let column1  = ConfigurableTable.make_string_cell(val: "Index \(indexRow!)")
         let column2  = ConfigurableTable.make_image_cell(imageName:"pinImage.png")
         let arrStrings = ["String 1", "String 2", "String 3"]
         let column3  = ConfigurableTable.make_Arrayofstrings_cell(arrStrings: arrStrings)
            
         return [column1, column2, column3]
    }
}

