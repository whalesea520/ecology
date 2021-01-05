'*********************************
'Show the multi customers selecting browser.
'@author	lupeng
'@version	04/08/12
'*********************************

'****************************************************************************************
'Show the multi customers selecting browser, not needed.
'@param	inputname	the hidden or not input object name, it stores the selected customers' id.
'@param	spanname	the span object name, it shows the selected customers' name.
'****************************************************************************************
Sub onShowMultiCustomer(inputname, spanname)
	Call onShowMultiCustomerBase(inputname, spanname, false)
End Sub

'****************************************************************************************
'Show the multi customers selecting browser, needed.
'@param	inputname	the hidden or not input object name, it stores the selected customers' id.
'@param	spanname	the span object name, it shows the selected customers' name.
'****************************************************************************************
Sub onShowMultiCustomerNeeded(inputname, spanname)
	Call onShowMultiCustomerBase(inputname, spanname, true)
End Sub

'****************************************************************************************
'Show the multi customers selecting browser, the base function.
'@param	inputname	the hidden or not input object name, it stores the selected customers' id.
'@param	spanname	the span object name, it shows the selected customers' name.
'@param	needed		the flag that whether or not to need input.
'****************************************************************************************
Sub onShowMultiCustomerBase(inputname, spanname, needed)
	tmpIds = document.all(inputname).value
	retValue = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/data/MutiCustomerBrowser.jsp?resourceids="&tmpIds)
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
				sHtml = sHtml&"<A href=/CRM/data/ViewCustomer.jsp?CustomerID="&curid&" target='_blank'>"&curname&"</A>&nbsp;"
			Wend
			sHtml = sHtml&"<A href=/CRM/data/ViewCustomer.jsp?CustomerID="&resourceids&" target='_blank'>"&resourcename&"</A>&nbsp;"
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