'*********************************
'Show the workflow selecting browser.
'@author	zjf
'@version	06/05/25
'*********************************

'****************************************************************************************
'Show the workFlow selecting browser, not need.
'@param	inputname	the hidden or not input object name, it stores the selected WorkFlow's id.
'@param	spanname	the span object name, it shows the selected WorkFlow's name.
'****************************************************************************************
Sub onShowWorkFlow(inputname, spanname)
	Call onShowWorkFlowBase(inputname, spanname, false)
End Sub

'****************************************************************************************
'Show the WorkFlow selecting browser, need.
'@param	inputname	the hidden or not input object name, it stores the selected WorkFlow's id.
'@param	spanname	the span object name, it shows the selected WorkFlow's name.
'****************************************************************************************
Sub onShowWorkFlowNeeded(inputname, spanname)
	Call onShowWorkFlowBase(inputname, spanname, true)
End Sub

'****************************************************************************************
'Show the hrm resource selecting browser, the base function.
'@param	inputname	the hidden or not input object name, it stores the selected WorkFlow's id.
'@param	spanname	the span object name, it shows the selected WorkFlow's name.
'@param	needed		the flag that whether or not to need input.
'****************************************************************************************
Sub onShowWorkFlowBase(inputname, spanname, needed)
	retValue = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser.jsp")
	If (Not IsEmpty(retValue)) Then
		If retValue(0) <> "" Then
			document.all(spanname).innerHtml = retValue(1)
			document.all(inputname).value = retValue(0)
		Else 
			document.all(inputname).value = ""
			If needed Then
				document.all(spanname).innerHtml = "<IMG src='/images/BacoError.gif' align=absMiddle>"
			Else
				document.all(spanname).innerHtml = ""
			End If
		End If
	End If
End Sub