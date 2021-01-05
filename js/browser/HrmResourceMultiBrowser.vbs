'*********************************
'Show the multi hrm resources selecting browser.
'@author	lupeng
'@version	04/08/12
'*********************************

'****************************************************************************************
'Show the multi hrm resources selecting browser, not needed.
'@param	inputname	the hidden or not input object name, it stores the selected hrm resources' id.
'@param	spanname	the span object name, it shows the selected reqeusts' name.
'****************************************************************************************
Sub onShowMultiHrmResource(inputname, spanname)
	Call onShowMultiHrmResourceBase(inputname, spanname, false)
End Sub

'****************************************************************************************
'Show the multi hrm resources selecting browser, needed.
'@param	inputname	the hidden or not input object name, it stores the selected hrm resources' id.
'@param	spanname	the span object name, it shows the selected hrm resources' name.
'****************************************************************************************
Sub onShowMultiHrmResourceNeeded(inputname, spanname)
	Call onShowMultiHrmResourceBase(inputname, spanname, true)
End Sub

'****************************************************************************************
'Show the multi hrm resources selecting browser, the base function.
'@param	inputname	the hidden or not input object name, it stores the selected hrm resources' id.
'@param	spanname	the span object name, it shows the selected hrm resources' name.
'@param	needed		the flag that whether or not to need input.
'****************************************************************************************
Sub onShowMultiHrmResourceBase(inputname, spanname, needed)
	tmpIds = document.all(inputname).value
	retValue = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids="&tmpIds)
	If (Not IsEmpty(retValue)) Then
		If retValue(0) <> "" Then
			resourceids = retValue(0)
			resourcename = retValue(1)
			sHtml = ""
			resourceids = Mid(resourceids,2,len(resourceids))
			document.all(inputname).value = resourceids
			resourcename = Mid(resourcename,2,len(resourcename))
			While InStr(resourceids,",") <> 0
				curid = Mid(resourceids,1,InStr(resourceids,",")-1)
				curname = Mid(resourcename,1,InStr(resourcename,",")-1)
				resourceids = Mid(resourceids,InStr(resourceids,",")+1,Len(resourceids))
				resourcename = Mid(resourcename,InStr(resourcename,",")+1,Len(resourcename))
				sHtml = sHtml&"<A href=/hrm/resource/HrmResource.jsp?id="&curid&">"&curname&"</A>&nbsp;"
			Wend
			sHtml = sHtml&"<A href=/hrm/resource/HrmResource.jsp?id="&resourceids&">"&resourcename&"</A>&nbsp;"
			document.all(spanname).innerHtml = sHtml			
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