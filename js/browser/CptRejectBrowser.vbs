'*********************************
'Show the cpt reject selecting browser.
'@author	lupeng
'@version	04/08/04
'*********************************

'****************************************************************************************
'Show the cpt reject selecting browser, not need.
'@param	inputname	the hidden or not input object name, it stores the selected cpt reject's id.
'@param	spanname	the span object name, it shows the selected cpt reject's name.
'****************************************************************************************
Sub onShowCptReject(inputname, spanname)
	Call onShowCptRejectBase(inputname, spanname, false)
End Sub

'****************************************************************************************
'Show the cpt reject selecting browser, need.
'@param	inputname	the hidden or not input object name, it stores the selected cpt reject's id.
'@param	spanname	the span object name, it shows the selected cpt reject's name.
'****************************************************************************************
Sub onShowCptRejectNeeded(inputname, spanname)
	Call onShowCptRejectBase(inputname, spanname, true)
End Sub

'****************************************************************************************
'Show the cpt reject selecting browser, the base function.
'@param	inputname	the hidden or not input object name, it stores the selected cpt reject's id.
'@param	spanname	the span object name, it shows the selected cpt reject's name.
'@param	needed		the flag that whether or not to need input.
'****************************************************************************************
Sub onShowCptRejectBase(inputname, spanname, needed)
	retValue = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/cpt/capital/CptRejectBrowser.jsp")
	If (Not IsEmpty(retValue)) Then
		If retValue(0) <> "" Then
			document.all(spanname).innerHtml = "<A href='cpt/capital/CptCapital.jsp?id="&retValue(0)&"'>"&retValue(1)&"</A>"
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