function onShowDoc()
	id1 = window.showModalDialog("/docs/DocBrowserMain.jsp?url=/docs/docs/MutiDocBrowser.jsp?documentids=")
	if (Not IsEmpty(id1)) then

		if (Len(id1(0)) > 500) then '500为表结构文档字段的长度
			result = msgbox("您选择的文档数量太多，数据库将无法保存所有的文档，请重新选择！",48,"注意")
		elseif id1(0)<> "" then
			tempdocids = id1(0)
			tempdocnames = id1(1)
			sHtml = ""
			tempdocids = Mid(tempdocids,2,len(tempdocids))
			tempdocnames = Mid(tempdocnames,2,len(tempdocnames))
			while InStr(tempdocids,",") <> 0
				curid = Mid(tempdocids,1,InStr(tempdocids,",")-1)
				curname = Mid(tempdocnames,1,InStr(tempdocnames,",")-1)
				tempdocids = Mid(tempdocids,InStr(tempdocids,",")+1,Len(tempdocids))
				tempdocnames = Mid(tempdocnames,InStr(tempdocnames,",")+1,Len(tempdocnames))
				sHtml = sHtml&"<a href='javascript:void(0)'  linkid="&curid&" linkType='doc' onclick='try{return openAppLink(this,"&curid&");}catch(e){}' ondblclick='return false;'  unselectable='off' contenteditable='false' style='cursor:pointer;text-decoration:underline !important;margin-right:8px'>"&curname&"</a>&nbsp"
			wend
			sHtml = sHtml&"<a href='javascript:void(0)'  linkid="&tempdocids&" linkType='doc' onclick='try{return openAppLink(this,"&tempdocids&");}catch(e){}' ondblclick='return false;' unselectable='off' contenteditable='false' style='cursor:pointer;text-decoration:underline !important;margin-right:8px'>"&tempdocnames&"</a>&nbsp"

		    onShowDoc=sHtml
		end if
	end if
end function
function onShowTask()
	id1 = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/proj/data/MultiTaskBrowser.jsp?resourceids=")
	if (Not IsEmpty(id1)) then

		if (Len(id1(0)) > 500) then '500为表结构相关项目任务字段的长度
			result = msgbox("您选择的相关项目任务数量太多，数据库将无法保存所有的相关项目任务，请重新选择！",48,"注意")
		elseif id1(0)<> "" then
				tempprojectids = id1(0)
				projectName = id1(1)
				sHtml = ""
				tempprojectids = Mid(tempprojectids,2,len(tempprojectids))
				projectName = Mid(projectName,2,len(projectName))
				while InStr(tempprojectids,",") <> 0
					curid = Mid(tempprojectids,1,InStr(tempprojectids,",")-1)
					curname = Mid(projectName,1,InStr(projectName,",")-1)
					tempprojectids = Mid(tempprojectids,InStr(tempprojectids,",")+1,Len(tempprojectids))
					projectName = Mid(projectName,InStr(projectName,",")+1,Len(projectName))
					sHtml = sHtml&"<a href='javascript:void(0)' linkid="&curid&" linkType='task' onclick='try{return openAppLink(this,"&curid&");}catch(e){}' target='_blank' unselectable='off' contenteditable='false' style='cursor:pointer;text-decoration:underline !important;margin-right:8px'>"&curname&"</a>&nbsp"
				wend
				sHtml = sHtml&"<a href='javascript:void(0)' linkid="&tempprojectids&" linkType='task' onclick='try{return openAppLink(this,"&tempprojectids&");}catch(e){}' target='_blank' unselectable='off' contenteditable='false' style='cursor:pointer;text-decoration:underline !important;margin-right:8px'>"&projectName&"</a>&nbsp"
			    
			    onShowTask=sHtml
			end if
	end if
end function


function onShowCRM()
	id1 = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/data/MutiCustomerBrowser.jsp?resourceids=")
	if (Not IsEmpty(id1)) then

		if (Len(id1(0)) > 500) then '500为表结构相关客户字段的长度
			result = msgbox("您选择的相关客户数量太多，数据库将无法保存所有的相关客户，请重新选择！",48,"注意")
		elseif id1(0)<> "" then
			resourceids = id1(0)
			resourcename = id1(1)
			sHtml = ""
			resourceids = Mid(resourceids,2,len(resourceids))
			resourcename = Mid(resourcename,2,len(resourcename))
			while InStr(resourceids,",") <> 0
				curid = Mid(resourceids,1,InStr(resourceids,",")-1)
				curname = Mid(resourcename,1,InStr(resourcename,",")-1)
				resourceids = Mid(resourceids,InStr(resourceids,",")+1,Len(resourceids))
				resourcename = Mid(resourcename,InStr(resourcename,",")+1,Len(resourcename))
				sHtml = sHtml&"<a href='javascript:void(0)' linkid="&curid&" linkType='crm' onclick='try{return openAppLink(this,"&curid&");}catch(e){}' unselectable='off' contenteditable='false' style='cursor:pointer;text-decoration:underline !important;margin-right:8px'>"&curname&"</a>&nbsp"
			wend
			sHtml = sHtml&"<a href='javascript:void(0)' linkid="&resourceids&" linkType='crm' onclick='try{return openAppLink(this,"&resourceids&");}catch(e){}' unselectable='off' contenteditable='false' style='cursor:pointer;text-decoration:underline !important;margin-right:8px'>"&resourcename&"</a>&nbsp"
			
			onShowCRM=sHtml
		end if
	end if
end function

function onShowRequest()
	id1 = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/workflow/request/MultiRequestBrowser.jsp?resourceids=")
	if (Not IsEmpty(id1)) then

		if (Len(id1(0)) > 500) then '500为表结构相关流程字段的长度
			result = msgbox("您选择的相关流程数量太多，数据库将无法保存所有的相关流程，请重新选择！",48,"注意")
		elseif id1(0)<> "" then
			resourceids = id1(0)
			resourcename = id1(1)
			sHtml = ""
			resourceids = Mid(resourceids,2,len(resourceids))
			resourcename = Mid(resourcename,2,len(resourcename))
			while InStr(resourceids,",") <> 0
				curid = Mid(resourceids,1,InStr(resourceids,",")-1)
				curname = Mid(resourcename,1,InStr(resourcename,",")-1)
				resourceids = Mid(resourceids,InStr(resourceids,",")+1,Len(resourceids))
				resourcename = Mid(resourcename,InStr(resourcename,",")+1,Len(resourcename))
				sHtml = sHtml&"<a href='javascript:void(0)' linkid="&curid&" linkType='workflow' onclick='try{return openAppLink(this,"&curid&");}catch(e){}' unselectable='off' contenteditable='false' style='cursor:pointer;text-decoration:underline !important;margin-right:8px'>"&curname&"</a>&nbsp"
			wend
			sHtml = sHtml&"<a href='javascript:void(0)' linkid="&resourceids&" linkType='workflow' onclick='try{return openAppLink(this,"&resourceids&");}catch(e){}' unselectable='off' contenteditable='false' style='cursor:pointer;text-decoration:underline !important;margin-right:8px'>"&resourcename&"</a>&nbsp"
			
			onShowRequest=sHtml
		end if
	end if
end function

function onShowProject()
	c_retValue = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/proj/data/MultiProjectBrowser.jsp?projectids=")
	If (Not IsEmpty(c_retValue)) Then
	    if (Len(c_retValue(0)) > 500) then '500为表结构相关项目字段的长度
			result = msgbox("您选择的相关项目数量太多，数据库将无法保存所有的相关项目，请重新选择！",48,"注意")
		elseif c_retValue(0)<> "" then
			resourceids = c_retValue(0)
			resourcename = c_retValue(1)
			sHtml = ""
			resourceids = Mid(resourceids,2,len(resourceids))
			resourcename = Mid(resourcename,2,len(resourcename))
			While InStr(resourceids,",") <> 0
				curid = Mid(resourceids,1,InStr(resourceids,",")-1)
				curname = Mid(resourcename,1,InStr(resourcename,",")-1)
				resourceids = Mid(resourceids,InStr(resourceids,",")+1,Len(resourceids))
				resourcename = Mid(resourcename,InStr(resourcename,",")+1,Len(resourcename))
				sHtml = sHtml&"<A href='javascript:void(0)' linkid="&curid&" linkType='project' onclick='try{return openAppLink(this,"&curid&");}catch(e){}' unselectable='off' contenteditable='false' style='cursor:pointer;text-decoration:underline !important;margin-right:8px'>"&curname&"</A>&nbsp;"
			Wend
			sHtml = sHtml&"<A href='javascript:void(0)' linkid="&resourceids&" linkType='project' onclick='try{return openAppLink(this,"&resourceids&");}catch(e){}' unselectable='off' contenteditable='false' style='cursor:pointer;text-decoration:underline !important;margin-right:8px'>"&resourcename&"</A>&nbsp;"
			
			onShowProject=sHtml
		End If
	End If
End function
