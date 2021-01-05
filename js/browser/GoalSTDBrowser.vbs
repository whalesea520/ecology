sub onShowSTD(inputename,id)
    
    id1 = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/performance/goal/myGoalSTDBrowser.jsp?id="&id)
        if (Not IsEmpty(id1)) then
        if id1(0)<> "" then
          resourceids = id1(0)
          resourcename = id1(1)
       
          document.all(inputename).value=resourceids
        else
          
          document.all(inputename).value=""
        end if
        end if
end sub