'*********************************
'Show the date selecting browser.
'@author	lupeng
'@version	04/08/04
'*********************************

Sub onShowDate(inputname,spanname)
  onWPNOShowDate spanname,inputname
End Sub

'****************************************************************************************
'Show the lgc selecting browser, need.
'@param	inputname	the hidden or not input object name, it stores the selected date's value.
'@param	spanname	the span object name, it shows the selected date's value.
'****************************************************************************************
Sub onShowDateNeeded(inputname,spanname)
   onWPShowDate spanname,inputname
End Sub

'****************************************************************************************
'Show the department selecting browser, the base function.
'@param	inputname	the hidden or not input object name, it stores the selected date's value.
'@param	spanname	the span object name, it shows the selected date's value.
'@param	needed		the flag that whether or not need to input.
'****************************************************************************************
Sub onShowDateBase(inputname, spanname, needed)
	retValue = window.showModalDialog("/systeminfo/Calendar.jsp",,"dialogHeight:320px;dialogwidth:275px")	
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