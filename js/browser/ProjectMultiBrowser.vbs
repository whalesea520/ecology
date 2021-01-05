'*********************************
'Show the multi projects selecting browser.
'@author	lupeng
'@version	04/08/12
'*********************************

'****************************************************************************************
'Show the multi projects selecting browser, not needed.
'@param	inputname	the hidden or not input object name, it stores the selected projects' id.
'@param	spanname	the span object name, it shows the selected projects' name.
'****************************************************************************************
Sub onShowMultiProject(inputname, spanname)
	Call onShowMultiProjectBase(inputname, spanname, false)
End Sub

'****************************************************************************************
'Show the multi projects selecting browser, needed.
'@param	inputname	the hidden or not input object name, it stores the selected projects' id.
'@param	spanname	the span object name, it shows the selected projects' name.
'****************************************************************************************
Sub onShowMultiProjectNeeded(inputname, spanname)
	Call onShowMultiProjectBase(inputname, spanname, true)
End Sub

'****************************************************************************************
'Show the multi projects selecting browser, the base function.
'@param	inputname	the hidden or not input object name, it stores the selected projects' id.
'@param	spanname	the span object name, it shows the selected projects' name.
'@param	needed		the flag that whether or not to need input.
'****************************************************************************************
Sub onShowMultiProjectBase(inputname, spanname, needed)
	tmpIds = document.all(inputname).value
	retValue = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/proj/data/MultiProjectBrowser.jsp?projectids="&tmpIds)
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
				sHtml = sHtml&"<A href=/proj/data/ViewProject.jsp?ProjID="&curid&" target='_blank'>"&curname&"</A>&nbsp;"
			Wend
			sHtml = sHtml&"<A href=/proj/data/ViewProject.jsp?ProjID="&resourceids&" target='_blank'>"&resourcename&"</A>&nbsp;"
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

Sub onShowMultiProjectCowork(inputname, spanname)
	c_tmpIds = document.all(inputname).value
	c_retValue = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/proj/data/MultiProjectBrowser.jsp?projectids="&c_tmpIds)
	If (Not IsEmpty(c_retValue)) Then
	    if (Len(c_retValue(0)) > 500) then '500为表结构相关项目字段的长度
			result = msgbox("您选择的相关项目数量太多，数据库将无法保存所有的相关项目，请重新选择！",48,"注意")
			document.all(spanname).innerHtml =""
			document.all(inputname).value=""
		elseif c_retValue(0)<> "" then
			resourceids = c_retValue(0)
			resourcename = c_retValue(1)
			sHtml = ""
			resourceids = Mid(resourceids,2,len(resourceids))
			document.all(inputname).value = resourceids
			resourcename = Mid(resourcename,2,len(resourcename))
			While InStr(resourceids,",") <> 0
				curid = Mid(resourceids,1,InStr(resourceids,",")-1)
				curname = Mid(resourcename,1,InStr(resourcename,",")-1)
				resourceids = Mid(resourceids,InStr(resourceids,",")+1,Len(resourceids))
				resourcename = Mid(resourcename,InStr(resourcename,",")+1,Len(resourcename))
				sHtml = sHtml&"<A  href=javascript:openFullWindowForXtable('/proj/data/ViewProject.jsp?ProjID="&curid&"')>"&curname&"</A>&nbsp;"
			Wend
			sHtml = sHtml&"<A  href=javascript:openFullWindowForXtable('/proj/data/ViewProject.jsp?ProjID="&resourceids&"')>"&resourcename&"</A>&nbsp;"
			document.all(spanname).innerHtml = sHtml			
		Else
			document.all(inputname).value = ""
			document.all(spanname).innerHtml = ""	
		End If
	End If
End Sub