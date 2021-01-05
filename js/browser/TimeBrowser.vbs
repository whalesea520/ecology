'*********************************
'Show the date selecting browser.
'@author	lupeng
'@version	04/08/04
'*********************************

'****************************************************************************************
'Show the time selecting browser, not need.
'@param	inputname	the hidden or not input object name, it stores the selected time's value.
'@param	spanname	the span object name, it shows the selected time's value.
'****************************************************************************************
Sub onShowTime(inputname, spanname)
	Call onShowTimeBase(inputname, spanname, false)
End Sub

'****************************************************************************************
'Show the time selecting browser, need.
'@param	inputname	the hidden or not input object name, it stores the selected time's value.
'@param	spanname	the span object name, it shows the selected time's value.
'****************************************************************************************
Sub onShowTimeNeeded(inputname, spanname)
	Call onShowTimeBase(inputname, spanname, true)
End Sub

'****************************************************************************************
'Show the time selecting browser, the base function.
'@param	inputname	the hidden or not input object name, it stores the selected time's value.
'@param	spanname	the span object name, it shows the selected time's value.
'@param	needed		the flag that whether or not need to input.
'****************************************************************************************
Sub onShowTimeBase(inputname, spanname, needed)
	retValue = window.showModalDialog("/systeminfo/Clock.jsp",,"dialogHeight:360px;dialogwidth:275px")	
	If retValue <> "" Then
		document.all(spanname).innerHtml = retValue
		document.all(inputname).value = retValue
	Else 
		document.all(inputname).value = ""
		If needed Then
			document.all(spanname).innerHtml = "<IMG src='/images/BacoError.gif' align=absMiddle>"
		Else
			document.all(spanname).innerHtml = ""
		End If
	End If	
End Sub