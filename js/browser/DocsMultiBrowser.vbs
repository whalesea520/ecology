'*********************************
'Show the multi docs selecting browser.
'@author	lupeng
'@version	04/08/12
'*********************************

'****************************************************************************************
'Show the multi docs selecting browser, not needed.
'@param	inputname	the hidden or not input object name, it stores the selected docs' id.
'@param	spanname	the span object name, it shows the selected docs' name.
'****************************************************************************************
Sub onShowMultiDocs(inputname, spanname)
	Call onShowMultiDocsBase(inputname, spanname, false)
End Sub

'****************************************************************************************
'Show the multi docs selecting browser, needed.
'@param	inputname	the hidden or not input object name, it stores the selected docs' id.
'@param	spanname	the span object name, it shows the selected docs' name.
'****************************************************************************************
Sub onShowMultiDocsNeeded(inputname, spanname)
	Call onShowMultiDocsBase(inputname, spanname, true)
End Sub

'****************************************************************************************
'Show the multi docs selecting browser, the base function.
'@param	inputname	the hidden or not input object name, it stores the selected docs' id.
'@param	spanname	the span object name, it shows the selected docs' name.
'@param	needed		the flag that whether or not to need input.
'****************************************************************************************
Sub onShowMultiDocsBase(inputname, spanname, needed)
	tmpIds = document.all(inputname).value
	retValue = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/docs/MutiDocBrowser.jsp?documentids="&tmpIds)
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
				sHtml = sHtml&"<A href=/docs/docs/DocDsp.jsp?id="&curid&" target='_blank'>"&curname&"</A>&nbsp;"
			Wend
			sHtml = sHtml&"<A href=/docs/docs/DocDsp.jsp?id="&resourceids&" target='_blank'>"&resourcename&"</A>&nbsp;"
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