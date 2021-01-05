sub onShowDoc(inputname,spanname)
	temp = document.getElementById(inputname).value
	id1 = window.showModalDialog("/docs/DocBrowserMain.jsp?url=/docs/docs/MutiDocBrowser.jsp?documentids="+temp)
	if (Not IsEmpty(id1)) then

		if (Len(id1(0)) > 500) then '500为表结构文档字段的长度
			result = msgbox("您选择的文档数量太多，数据库将无法保存所有的文档，请重新选择！",48,"注意")
			document.getElementById(spanname).innerHtml =""
			document.getElementById(inputname).value=""
		elseif id1(0)<> "" then
			tempdocids = id1(0)
			tempdocnames = id1(1)
			sHtml = ""
			tempdocids = Mid(tempdocids,2,len(tempdocids))
			document.getElementById(inputname).value = tempdocids
			tempdocnames = Mid(tempdocnames,2,len(tempdocnames))
			while InStr(tempdocids,",") <> 0
				curid = Mid(tempdocids,1,InStr(tempdocids,",")-1)
				curname = Mid(tempdocnames,1,InStr(tempdocnames,",")-1)
				tempdocids = Mid(tempdocids,InStr(tempdocids,",")+1,Len(tempdocids))
				tempdocnames = Mid(tempdocnames,InStr(tempdocnames,",")+1,Len(tempdocnames))
				sHtml = sHtml&"<a href='#' onclick=openFullWindowForXtable('/docs/docs/DocDsp.jsp?id="&curid&"')>"&curname&"</a>&nbsp"
			wend
			sHtml = sHtml&"<a href='#' onclick=openFullWindowForXtable('/docs/docs/DocDsp.jsp?id="&tempdocids&"')>"&tempdocnames&"</a>&nbsp"
			document.getElementById(spanname).innerHtml = sHtml
		else
			document.getElementById(spanname).innerHtml =""
			document.getElementById(inputname).value=""
		end if
	end if
end sub
sub onShowProject(inputname,spanname)
	temp = document.getElementById(inputname).value
	id1 = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/proj/data/MultiTaskBrowser.jsp?resourceids="+temp)
	if (Not IsEmpty(id1)) then

		if (Len(id1(0)) > 500) then '500为表结构相关项目任务字段的长度
			result = msgbox("您选择的相关项目任务数量太多，数据库将无法保存所有的相关项目任务，请重新选择！",48,"注意")
			document.getElementById(spanname).innerHtml =""
			document.getElementById(inputname).value=""
		elseif id1(0)<> "" then
				tempprojectids = id1(0)
				projectName = id1(1)
				sHtml = ""
				tempprojectids = Mid(tempprojectids,2,len(tempprojectids))
				document.getElementById(inputname).value = tempprojectids
				projectName = Mid(projectName,2,len(projectName))
				while InStr(tempprojectids,",") <> 0
					curid = Mid(tempprojectids,1,InStr(tempprojectids,",")-1)
					curname = Mid(projectName,1,InStr(projectName,",")-1)
					tempprojectids = Mid(tempprojectids,InStr(tempprojectids,",")+1,Len(tempprojectids))
					projectName = Mid(projectName,InStr(projectName,",")+1,Len(projectName))
					sHtml = sHtml&"<a href='#' onclick=openFullWindowForXtable('/proj/process/ViewTask.jsp?taskrecordid="&curid&"')>"&curname&"</a>&nbsp"
				wend
				sHtml = sHtml&"<a href='#' onclick=openFullWindowForXtable('/proj/process/ViewTask.jsp?taskrecordid="&tempprojectids&"')>"&projectName&"</a>&nbsp"
				document.getElementById(spanname).innerHtml = sHtml
			else
				document.getElementById(spanname).innerHtml =""
				document.getElementById(inputname).value=""
			end if
	end if
end sub


sub onShowCRM(inputname,spanname)
	temp = document.getElementById(inputname).value
	id1 = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/data/MutiCustomerBrowser.jsp?resourceids="+temp)
	if (Not IsEmpty(id1)) then

		if (Len(id1(0)) > 500) then '500为表结构相关客户字段的长度
			result = msgbox("您选择的相关客户数量太多，数据库将无法保存所有的相关客户，请重新选择！",48,"注意")
			document.getElementById(spanname).innerHtml =""
			document.getElementById(inputname).value=""
		elseif id1(0)<> "" then
			resourceids = id1(0)
			resourcename = id1(1)
			sHtml = ""
			resourceids = Mid(resourceids,2,len(resourceids))
			document.getElementById(inputname).value= resourceids
			resourcename = Mid(resourcename,2,len(resourcename))
			while InStr(resourceids,",") <> 0
				curid = Mid(resourceids,1,InStr(resourceids,",")-1)
				curname = Mid(resourcename,1,InStr(resourcename,",")-1)
				resourceids = Mid(resourceids,InStr(resourceids,",")+1,Len(resourceids))
				resourcename = Mid(resourcename,InStr(resourcename,",")+1,Len(resourcename))
				sHtml = sHtml&"<a href='#' onclick=openFullWindowForXtable('/CRM/data/ViewCustomer.jsp?CustomerID="&curid&"')>"&curname&"</a>&nbsp"
			wend
			sHtml = sHtml&"<a href='#' onclick=openFullWindowForXtable('/CRM/data/ViewCustomer.jsp?CustomerID="&resourceids&"')>"&resourcename&"</a>&nbsp"
			document.getElementById(spanname).innerHtml = sHtml
		else
			document.getElementById(spanname).innerHtml =""
			document.getElementById(inputname).value=""
		end if
	end if
end sub

sub onShowRequest(inputname,spanname)
	temp = document.getElementById(inputname).value
	id1 = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/workflow/request/MultiRequestBrowser.jsp?resourceids="+temp)
	if (Not IsEmpty(id1)) then

		if (Len(id1(0)) > 500) then '500为表结构相关流程字段的长度
			result = msgbox("您选择的相关流程数量太多，数据库将无法保存所有的相关流程，请重新选择！",48,"注意")
			document.getElementById(spanname).innerHtml =""
			document.getElementById(inputname).value=""
		elseif id1(0)<> "" then
			resourceids = id1(0)
			resourcename = id1(1)
			sHtml = ""
			resourceids = Mid(resourceids,2,len(resourceids))
			document.getElementById(inputname).value= resourceids
			resourcename = Mid(resourcename,2,len(resourcename))
			while InStr(resourceids,",") <> 0
				curid = Mid(resourceids,1,InStr(resourceids,",")-1)
				curname = Mid(resourcename,1,InStr(resourcename,",")-1)
				resourceids = Mid(resourceids,InStr(resourceids,",")+1,Len(resourceids))
				resourcename = Mid(resourcename,InStr(resourcename,",")+1,Len(resourcename))
				sHtml = sHtml&"<a href='#' onclick=openFullWindowForXtable('/workflow/request/ViewRequest.jsp?requestid="&curid&"')>"&curname&"</a>&nbsp"
			wend
			sHtml = sHtml&"<a href='#' onclick=openFullWindowForXtable('/workflow/request/ViewRequest.jsp?requestid="&resourceids&"')>"&resourcename&"</a>&nbsp"
			document.getElementById(spanname).innerHtml = sHtml
		else
			document.getElementById(spanname).innerHtml =""
			document.getElementById(inputname).value=""
		end if
	end if
end sub

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
				sHtml = sHtml&"<A href='#' onclick=openFullWindowForXtable('/proj/data/ViewProject.jsp?ProjID="&curid&"')>"&curname&"</A>&nbsp;"
			Wend
			sHtml = sHtml&"<A href='#' onclick=openFullWindowForXtable('/proj/data/ViewProject.jsp?ProjID="&resourceids&"')>"&resourcename&"</A>&nbsp;"
			document.all(spanname).innerHtml = sHtml			
		Else
			document.all(inputname).value = ""
			document.all(spanname).innerHtml = ""	
		End If
	End If
End Sub

sub onShowCoworkerID()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	coworkerspan.innerHtml = "<A href='HrmResource.jsp?id="&id(0)&"' target='_black'>"&id(1)&"</A>"
	weaver.coworker.value=id(0)
	else 
	coworkerspan.innerHtml = ""
	weaver.coworker.value=""
	end if
	end if
end sub
sub onShowCreaterID()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	createrspan.innerHtml = "<A href='HrmResource.jsp?id="&id(0)&"' target='_black'>"&id(1)&"</A>"
	weaver.creater.value=id(0)
	else 
	createrspan.innerHtml = ""
	weaver.creater.value=""
	end if
	end if
end sub
sub onShowPrincipalID()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	principalspan.innerHtml = "<A href='HrmResource.jsp?id="&id(0)&"' target='_black'>"&id(1)&"</A>"
	weaver.principal.value=id(0)
	else 
	principalspan.innerHtml = ""
	weaver.principal.value=""
	end if
	end if
end sub
sub onShowResourceOnly(input,span)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
	if NOT isempty(id) then
	    if id(0)<> "" then
			document.getElementById(span).innerHtml = "<a href='javaScript:openhrm("&id(0)&");' onclick='pointerXY(event);'>"&id(1)&"</a>"
			document.getElementById(input).value=id(0)	
		else
			document.getElementById(span).innerHtml = " <IMG src='/images/BacoError.gif' align=absMiddle>"
			document.getElementById(input).value=""		
		end if
	end if
end sub