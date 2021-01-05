'*********************************
'Show the lgc selecting browser.
'@author	lupeng
'@version	04/08/03
'*********************************

'****************************************************************************************
'Show the lgc selecting browser, not need.
'@param	inputname	the hidden or not input object name, it stores the selected lgc's id.
'@param	spanname	the span object name, it shows the selected lgc's name.
'****************************************************************************************
Sub onShowLgcAsset(inputname, spanname)
	Call onShowLgcAssetBase(inputname, spanname, false)
End Sub

'****************************************************************************************
'Show the lgc selecting browser, need.
'@param	inputname	the hidden or not input object name, it stores the selected lgc's id.
'@param	spanname	the span object name, it shows the selected lgc's name.
'****************************************************************************************
Sub onShowLgcAssetNeeded(inputname, spanname)
	Call onShowLgcAssetBase(inputname, spanname, true)
End Sub

'****************************************************************************************
'Show the lgc selecting browser, the base function.
'@param	inputname	the hidden or not input object name, it stores the selected lgc's id.
'@param	spanname	the span object name, it shows the selected lgc's name.
'@param	needed		the flag that whether or not to need input.
'****************************************************************************************
Sub onShowLgcAssetBase(inputname, spanname, needed)
	retValue = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/lgc/asset/LgcAssetBrowser.jsp")
	If (Not IsEmpty(retValue)) Then
		If retValue(0) <> "" Then
			document.all(spanname).innerHtml = "<A href='/lgc/asset/LgcAsset.jsp?paraid="&retValue(0)&"'>"&retValue(1)&"</A>"
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