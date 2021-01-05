'*********************************
'Show the lgc asset unit selecting browser.
'@author	lupeng
'@version	04/08/03
'*********************************

'****************************************************************************************
'Show the lgc asset unit selecting browser, not need.
'@param	inputname	the hidden or not input object name, it stores the selected unit's id.
'@param	spanname	the span object name, it shows the selected unit's name.
'****************************************************************************************
Sub onShowLgcAssetUnit(inputname, spanname)
	Call onShowLgcAssetUnitBase(inputname, spanname, false)
End Sub

'****************************************************************************************
'Show the lgc asset unit selecting browser, need.
'@param	inputname	the hidden or not input object name, it stores the selected unit's id.
'@param	spanname	the span object name, it shows the selected unit's name.
'****************************************************************************************
Sub onShowLgcAssetUnitNeeded(inputname, spanname)
	Call onShowLgcAssetUnitBase(inputname, spanname, true)
End Sub

'****************************************************************************************
'Show the department selecting browser, the base function.
'@param	inputname	the hidden or not input object name, it stores the selected unit's id.
'@param	spanname	the span object name, it shows the selected unit's name.
'@param	needed		the flag that whether or not need to input.
'****************************************************************************************
Sub onShowLgcAssetUnitBase(inputname, spanname, needed)
	retValue = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/lgc/maintenance/LgcAssetUnitBrowser.jsp")
	If (Not IsEmpty(retValue)) Then
		If retValue(0) <> "" Then
			document.all(spanname).innerHtml = retValue(2)
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