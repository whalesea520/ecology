sub onShowTarget(inputename,spanname,types,pd)
    
    if types="0" then
         cycle="3"
    elseif types="1" then
        cycle="1"
    elseif types="2" then
         cycle="0"
	elseif types="3" then
         cycle="0"
    end if  
    planDate=pd
    temp=planDate&"||"&cycle&"-"&types
    id1 = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/performance/goal/myGoalBrowserForPlan.jsp?temp="&temp)
        if (Not IsEmpty(id1)) then
        if id1(0)<> "" then
          resourceids = id1(0)
          resourcename = id1(1)
          document.all(spanname).innerHtml=resourcename
          document.all(inputename).value=resourceids
        else
          document.all(spanname).innerHtml ="<IMG src='/images/BacoError.gif' align=absMiddle>"
          document.all(inputename).value=""
        end if
        end if
end sub