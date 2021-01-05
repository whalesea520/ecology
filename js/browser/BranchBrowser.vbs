'*********************************
'Show the branch selecting browser.
'@author	ben
'@version	06/02/13
'*********************************

'****************************************************************************************
'Show the lgc selecting browser, not need.
'@param	inputname	the hidden or not input object name, it stores the selected department's id.
'@param	spanname	the span object name, it shows the selected department's name.
'****************************************************************************************
Sub onShowBranch(inputname, spanname)
	Call onShowBranchBase(inputname, spanname, false)
End Sub

'****************************************************************************************
'Show the lgc selecting browser, need.
'@param	inputname	the hidden or not input object name, it stores the selected department's id.
'@param	spanname	the span object name, it shows the selected department's name.
'****************************************************************************************
Sub onShowBranchNeeded(inputname, spanname)
	Call onShowDepartmentBase(inputname, spanname, true)
End Sub

'****************************************************************************************
'Show the Branch selecting browser, the base function.
'@param	inputname	the hidden or not input object name, it stores the selected department's id.
'@param	spanname	the span object name, it shows the selected department's name.
'@param	needed		the flag that whether or not need to input.
'****************************************************************************************
Sub onShowBranchBase(inputname, spanname, needed)
	retValue = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp?selectedids="&document.all(inputname).value)
	If (Not IsEmpty(retValue)) Then
		If retValue(0) <> "" Then
			document.all(spanname).innerHtml = "<A href='/hrm/company/HrmSubCompanyDsp.jsp?id="&retValue(0)&"'>"&retValue(1)&"</A>"
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