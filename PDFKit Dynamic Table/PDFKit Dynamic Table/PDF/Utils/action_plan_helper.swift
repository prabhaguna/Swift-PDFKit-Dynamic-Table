//
//  action_plan_helper.swift
//  PDFKIT Example
//
//  Created by devmac02 on 7/28/20.
//  Copyright © 2020 Sempercon. All rights reserved.
//

import UIKit

class action_plan_helper: NSObject {
    
    static func make_greenZone_left_content() -> NSMutableAttributedString
    {
        let content = action_plan_helper.format_title(title: "Symptoms" + "\n")
       
        var desc = "• No coughing, shortness of breath, wheezing, or chest tightness" + "\n"
        desc =  desc + "• Sleeping all night" + "\n"
        desc =  desc + "• Can do all usual activities (work, play)" + "\n"
        desc =  desc + "My peak flow should be above "

        content.append(action_plan_helper.format_content(desc: desc))
        content.append(action_plan_helper.format_value(value: "480"))

        return content
    }
    
     static func make_yellowZone_left_content() -> NSMutableAttributedString
    {
        let content = action_plan_helper.format_title(title: "Symptoms" + "\n")
       
        var desc = "• Some problems with coughing, shortness of breath, wheezing, or chest tightness OR" + "\n"
        desc =  desc + "• Waking up at night due to asthma OR" + "\n"
        desc =  desc + "• Using more quick-relief asthma medicine OR" + "\n"
        desc =  desc + "• Can do some, but not all, usual activities (work, play)" + "\n"
        desc =  desc + "My peak flow should be between "

        content.append(action_plan_helper.format_content(desc: desc))
        
        content.append(action_plan_helper.format_value(value: "300"))
        content.append(action_plan_helper.format_content(desc: " and "))
        content.append(action_plan_helper.format_value(value: "480"))

        return content
    }
    
    static func make_redZone_left_content() -> NSMutableAttributedString
    {
        let content = action_plan_helper.format_title(title: "Symptoms" + "\n")
       
        var desc = "• Symptoms are same or worse after 24 hours in the Yellow Zone OR" + "\n"
        desc =  desc + "• Very short of breath OR" + "\n"
        desc =  desc + "• Quick-relief asthma medicines have not helped OR" + "\n"
        desc =  desc + "• Cannot do usual activities (work, play)" + "\n"
        desc =  desc + "My peak flow is less than "

        content.append(action_plan_helper.format_content(desc: desc))
        content.append(action_plan_helper.format_value(value: "300"))

        return content
    }
    
    
}

extension action_plan_helper {

    static func format_title(title : String) -> NSMutableAttributedString
    {
         let aContent =  NSMutableAttributedString(string: title)
         let aContentAttributes  = [NSAttributedString.Key.font: UIFont(name: "OpenSans-Bold", size: 15),
                                   NSAttributedString.Key.foregroundColor: blueHeaderBg]
        aContent.addAttributes(aContentAttributes as [NSAttributedString.Key : Any], range: NSRange(location: 0, length: aContent.length))
        return aContent
    }
    
    static func format_content(desc : String) -> NSMutableAttributedString
    {
        let symptomsdesc = NSMutableAttributedString(string: desc)
        let symptomsdescAttributes  = [NSAttributedString.Key.font: UIFont(name: "OpenSans", size: 12),
                                   NSAttributedString.Key.foregroundColor: UIColor.black]
        symptomsdesc.addAttributes(symptomsdescAttributes as [NSAttributedString.Key : Any], range: NSRange(location: 0, length: symptomsdesc.length))
        return symptomsdesc
    }
    
    static func format_value(value : String) -> NSMutableAttributedString
    {
        let symptomsdesc = NSMutableAttributedString(string: value)
        let symptomsdescAttributes  = [NSAttributedString.Key.font: UIFont(name: "OpenSans-Bold", size: 13),
                                   NSAttributedString.Key.foregroundColor: UIColor.black]
        symptomsdesc.addAttributes(symptomsdescAttributes as [NSAttributedString.Key : Any], range: NSRange(location: 0, length: symptomsdesc.length))
        return symptomsdesc
    }

}
