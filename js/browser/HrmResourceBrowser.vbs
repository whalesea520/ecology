'*********************************
'Show the hrm resource selecting browser.
'@author	lupeng
'@version	04/08/12
'*********************************

'****************************************************************************************
'Show the hrm resource selecting browser, not need.
'@param	inputname	the hidden or not input object name, it stores the selected hrm resource's id.
'@param	spanname	the span object name, it shows the selected hrm resource's name.
'****************************************************************************************
Sub onShowHrmResource(inputname, spanname)
	Call onShowHrmResourceBase(inputname, spanname, false)
End Sub

'****************************************************************************************
'Show the hrm resource selecting browser, need.
'@param	inputname	the hidden or not input object name, it stores the selected hrm resource's id.
'@param	spanname	the span object name, it shows the selected hrm resource's name.
'****************************************************************************************
Sub onShowHrmResourceNeeded(inputname, spanname)
	Call onShowHrmResourceBase(inputname, spanname, true)
End Sub

'****************************************************************************************
'Show the hrm resource selecting browser, the base function.
'@param	inputname	the hidden or not input object name, it stores the selected hrm resource's id.
'@param	spanname	the span object name, it shows the selected hrm resource's name.
'@param	needed		the flag that whether or not to need input.
'****************************************************************************************
Sub onShowHrmResourceBase(inputname, spanname, needed)
	retValue = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
	If (Not IsEmpty(retValue)) Then
		If retValue(0) <> "" Then
			document.all(spanname).innerHtml = "<A href='/hrm/resource/HrmResource.jsp?id="&retValue(0)&"'>"&retValue(1)&"</A>"
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