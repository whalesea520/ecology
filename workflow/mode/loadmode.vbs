Function string2VbArray(str)
	Dim vbsArray
	
	string2VbArray = vbsArray
	if str <> "" then
		vbsArray = Split(str, "(~!@#$%^&*)") 
		string2VbArray = vbsArray
	end if
End Function

Function checkhrmResourceShow()
     if document.all("hrmResourceShow") = "" then 
         checkhrmResourceShow = true
         Exit Function
     end if
     if document.all("hrmResourceShow").value <>"2" then
         checkhrmResourceShow = true
         Exit Function
     end if
     checkhrmResourceShow = false
End Function
sub Browser(id1,fieldid,type1,ismand,nowrow,nowcol)    
   if NOT isempty(id1) and type1<>141 then
        if type1= 2 or type1 = 19 then
            frmmain.ChinaExcel.SetCellVal nowrow,nowcol,getChangeField(id1)
            document.all(fieldid).value=id1
        else
            if type1 = 171 or type1 = 152 or type1 = 142 or type1 = 135 or type1 = 17 or type1 = 18 or type1=27 or type1=37 or type1=56 or type1=57 or type1=65 or type1=166 or type1=168 or type1=170 or type1=194 then
                if id1(0)<> ""  and id1(0)<> "0" then
                    resourceids = id1(0)
                    resourcename = id1(1)
                    sHtml = ""
                    'resourceids = Mid(resourceids,2,len(resourceids))   
                    document.all(fieldid).value= resourceids
                    'resourcename = Mid(resourcename,2,len(resourcename))
                    while InStr(resourceids,",") <> 0
                        curid = Mid(resourceids,1,InStr(resourceids,",")-1)
                        curname = Mid(resourcename,1,InStr(resourcename,",")-1)
                        resourceids = Mid(resourceids,InStr(resourceids,",")+1,Len(resourceids))
                        resourcename = Mid(resourcename,InStr(resourcename,",")+1,Len(resourcename))
                        sHtml = sHtml&curname&","
                    wend
                    sHtml = sHtml&resourcename
                    frmmain.ChinaExcel.SetCellVal nowrow,nowcol,getChangeField(sHtml)                  
                else
                    frmmain.ChinaExcel.SetCellVal nowrow,nowcol,""
                    document.all(fieldid).value=""
                end if

            else
               if  id1(0)<>""   and id1(0)<> "0"  then
                    frmmain.ChinaExcel.SetCellVal nowrow,nowcol,getChangeField(id1(1))
                    document.all(fieldid).value=id1(0)
                else
					if type1 = 161 then
						rid = id1(0)
						rname = id1(1)
						frmmain.ChinaExcel.SetCellVal nowrow,nowcol,getChangeField(rname)
						document.all(fieldid).value=rid
					else
						frmmain.ChinaExcel.SetCellVal nowrow,nowcol,""
						document.all(fieldid).value=""
					end if

                end if
            end if
        end if
        onShowFnaInfo fieldid,nowrow
        imgshoworhide nowrow,nowcol
        frmmain.ChinaExcel.RefreshViewSize
	else
	    BrowserResourceCondition id1,fieldid,type1,ismand,nowrow,nowcol
    end if
    DataInputByBrowser fieldid   
end sub

sub ShowCustomizeBrowser(url,fieldid,type1,ismand,nowrow,nowcol)
    Dim id1
    if type1 = 162   then
        id1 = window.showModalDialog(url&"&othercallback=1",window)
    else
       if  type1 = 161  then
            id1 = window.showModalDialog(url&"&othercallback=1",window)
       else
           id1 = window.showModalDialog(url&"|"&fieldid,window)   
       end if
    end If
	if wuiUtil.isNotEmpty(id1) and type1<>141 then
        if type1= 2 or type1 = 19 then
            frmmain.ChinaExcel.SetCellVal nowrow,nowcol,getChangeField(wuiUtil.getJsonValueByIndexNew(id1, 0))
            document.all(fieldid).value=wuiUtil.getJsonValueByIndexNew(id1, 0)
        else
            if type1 = 171 or type1 = 152 or type1 = 142 or type1 = 135 or type1 = 17 or type1 = 18 or type1=27 or type1=37 or type1=56 or type1=57 or type1=65 or type1=166 or type1=168 or type1=170 or type1=194 then
                if wuiUtil.getJsonValueByIndexNew(id1, 0)<>""   and wuiUtil.getJsonValueByIndexNew(id1, 0) <> "0" then
                    resourceids = wuiUtil.getJsonValueByIndexNew(id1, 0)
                    resourcename = wuiUtil.getJsonValueByIndexNew(id1, 1)
                    sHtml = ""
                    'resourceids = Mid(resourceids,2,len(resourceids))   
                    document.all(fieldid).value= resourceids
                    'resourcename = Mid(resourcename,2,len(resourcename))
                    while InStr(resourceids,",") <> 0
                        curid = Mid(resourceids,1,InStr(resourceids,",")-1)
                        curname = Mid(resourcename,1,InStr(resourcename,",")-1)
                        resourceids = Mid(resourceids,InStr(resourceids,",")+1,Len(resourceids))
                        resourcename = Mid(resourcename,InStr(resourcename,",")+1,Len(resourcename))
                        sHtml = sHtml&curname&","
                    wend
                    sHtml = sHtml&resourcename
                    frmmain.ChinaExcel.SetCellVal nowrow,nowcol,getChangeField(sHtml)                  
                else
                    frmmain.ChinaExcel.SetCellVal nowrow,nowcol,""
                    document.all(fieldid).value=""
                end if

            else
               if wuiUtil.getJsonValueByIndexNew(id1, 0)<>"" Then
               		  rid = wuiUtil.getJsonValueByIndexNew(id1, 0)
                    rname = wuiUtil.getJsonValueByIndexNew(id1, 1)
                    frmmain.ChinaExcel.SetCellVal nowrow,nowcol,getChangeField(rname)
                    document.all(fieldid).value=rid
                else
                    frmmain.ChinaExcel.SetCellVal nowrow,nowcol,""
                    document.all(fieldid).value=""
                end if
            end if
        end if
        onShowFnaInfo fieldid,nowrow
        imgshoworhide nowrow,nowcol
        frmmain.ChinaExcel.RefreshViewSize
	else
	    BrowserResourceCondition id1,fieldid,type1,ismand,nowrow,nowcol
    end if
    DataInputByBrowser fieldid   
end sub

sub BrowserResourceCondition(dialogId,fieldid,type1,ismand,nowrow,nowcol)

  languageId=readCookie("languageidweaver")

  label_683="安全级别"
  label_18941="的分部成员"
  label_18942="的部门成员"
  label_3005="共享级别"
  label_18945="的角色成员"
  label_18943="的所有人"
  label_1340="所有人"

  if(languageId=8) then
      label_683="SecurityLevel"
      label_18941="subcompany's member"
      label_18942="department member"
      label_3005="Share Level"
      label_18945="role member"
      label_18943="all member"
      label_1340="all member"
  end if

if (Not IsEmpty(dialogId)) then

	if dialogId(0)<> "" then
	    shareTypeValues = dialogId(0)
		shareTypeTexts = dialogId(1)
		relatedShareIdses = dialogId(2)
		relatedShareNameses = dialogId(3)
		rolelevelValues = dialogId(4)
		rolelevelTexts = dialogId(5)
		secLevelValues = dialogId(6)
		secLevelTexts = dialogId(7)

		sHtml = ""
		fileIdValue=""
		shareTypeValues = Mid(shareTypeValues,2,len(shareTypeValues))
		shareTypeTexts = Mid(shareTypeTexts,2,len(shareTypeTexts))
		relatedShareIdses = Mid(relatedShareIdses,2,len(relatedShareIdses))
		relatedShareNameses = Mid(relatedShareNameses,2,len(relatedShareNameses))
		rolelevelValues = Mid(rolelevelValues,2,len(rolelevelValues))
		rolelevelTexts = Mid(rolelevelTexts,2,len(rolelevelTexts))
		secLevelValues = Mid(secLevelValues,2,len(secLevelValues))
		secLevelTexts = Mid(secLevelTexts,2,len(secLevelTexts))


		while InStr(shareTypeValues,"~") <> 0

			shareTypeValue = Mid(shareTypeValues,1,InStr(shareTypeValues,"~")-1)
			shareTypeText = Mid(shareTypeTexts,1,InStr(shareTypeTexts,"~")-1)
			relatedShareIds = Mid(relatedShareIdses,1,InStr(relatedShareIdses,"~")-1)
			relatedShareNames = Mid(relatedShareNameses,1,InStr(relatedShareNameses,"~")-1)
			rolelevelValue = Mid(rolelevelValues,1,InStr(rolelevelValues,"~")-1)
			rolelevelText = Mid(rolelevelTexts,1,InStr(rolelevelTexts,"~")-1)
			secLevelValue = Mid(secLevelValues,1,InStr(secLevelValues,"~")-1)
			secLevelText = Mid(secLevelTexts,1,InStr(secLevelTexts,"~")-1)

			shareTypeValues = Mid(shareTypeValues,InStr(shareTypeValues,"~")+1,Len(shareTypeValues))
			shareTypeTexts = Mid(shareTypeTexts,InStr(shareTypeTexts,"~")+1,Len(shareTypeTexts))
			relatedShareIdses = Mid(relatedShareIdses,InStr(relatedShareIdses,"~")+1,Len(relatedShareIdses))
			relatedShareNameses = Mid(relatedShareNameses,InStr(relatedShareNameses,"~")+1,Len(relatedShareNameses))
			rolelevelValues = Mid(rolelevelValues,InStr(rolelevelValues,"~")+1,Len(rolelevelValues))
			rolelevelTexts = Mid(rolelevelTexts,InStr(rolelevelTexts,"~")+1,Len(rolelevelTexts))
			secLevelValues = Mid(secLevelValues,InStr(secLevelValues,"~")+1,Len(secLevelValues))
			secLevelTexts = Mid(secLevelTexts,InStr(secLevelTexts,"~")+1,Len(secLevelTexts))

            fileIdValue=fileIdValue&"~"&shareTypeValue&"_"&relatedShareIds&"_"&rolelevelValue&"_"&secLevelValue
		
	        if shareTypeValue= "1" then
			    sHtml = sHtml&"，"&shareTypeText&"("&relatedShareNames&")"
	        else	if  shareTypeValue= "2" then
			             sHtml = sHtml&"，"&shareTypeText&"("&relatedShareNames&")"
			             if checkhrmResourceShow then
			                 sHtml = sHtml&label_683&">="&secLevelValue&label_18941
			             end if
			        else   if shareTypeValue= "3" then
			                   sHtml = sHtml&"，"&shareTypeText&"("&relatedShareNames&")"
			                   
                                 if checkhrmResourceShow then
                                     sHtml = sHtml&label_683&">="&secLevelValue&label_18942
                                 end if
			                   
					       else  if shareTypeValue= "4" then
			                         sHtml = sHtml&"，"&shareTypeText&"("&relatedShareNames&")"
			                         
                                     if checkhrmResourceShow then
                                         sHtml = sHtml&label_3005&"="&rolelevelText&label_683&">="&secLevelValue&label_18945
                                     end if
			                         
						         else
                                     if checkhrmResourceShow then
                                        sHtml = sHtml&"，"&label_683&">="&secLevelValue&label_18943
                                     else
                                        sHtml = sHtml&"，"&label_1340
                                     end if
								 end if
						   end if
					end if
	        end if
		wend

            fileIdValue=fileIdValue&"~"&shareTypeValues&"_"&relatedShareIdses&"_"&rolelevelValues&"_"&secLevelValues

            if shareTypeValues= "1" then
                sHtml = sHtml&"，"&shareTypeTexts&"("&relatedShareNameses&")"
            else    if  shareTypeValues= "2" then
                         sHtml = sHtml&"，"&shareTypeTexts&"("&relatedShareNameses&")"
                         
                         if checkhrmResourceShow then
                             sHtml = sHtml&label_683&">="&secLevelValues&label_18941
                         end if
                    else   if shareTypeValues= "3" then
                               sHtml = sHtml&"，"&shareTypeTexts&"("&relatedShareNameses&")"
                               
                                if checkhrmResourceShow then
                                    sHtml = sHtml&label_683&">="&secLevelValues&label_18942
                                end if
                           else  if shareTypeValues= "4" then
                                     sHtml = sHtml&"，"&shareTypeTexts&"("&relatedShareNameses&")"
                                     
                                    if checkhrmResourceShow then
                                        sHtml = sHtml&label_3005&"="&rolelevelTexts&label_683&">="&secLevelValues&label_18945
                                    end if
                                 else
                                     
                                     if checkhrmResourceShow then
                                        sHtml = sHtml&"，"&label_683&">="&secLevelValues&label_18943
                                     else
                                        sHtml = sHtml&"，"&label_1340
                                     end if
                                 end if
                           end if
                    end if
            end if
		sHtml = Mid(sHtml,2,len(sHtml))
		fileIdValue=Mid(fileIdValue,2,len(fileIdValue))

		document.all(fieldid).value= fileIdValue
		frmmain.ChinaExcel.SetCellVal nowrow,nowcol,getChangeField(sHtml)
	else	
        if ismand=0 then
                frmmain.ChinaExcel.SetCellVal nowrow,nowcol, getChangeField(empty)
        else
                frmmain.ChinaExcel.SetCellVal nowrow,nowcol,""
        end if
        document.all(fieldid).value=""
	end if
	imgshoworhide nowrow,nowcol
    frmmain.ChinaExcel.RefreshViewSize
end if

end sub

public Function FirstRowNo(objid)
    rowno=frmmain.ChinaExcel.GetCellUserStringValueRow (objid)
    colno=frmmain.ChinaExcel.GetCellUserStringValueCol (objid)
    frmmain.ChinaExcel.GetCellCombiNationWeb rowno,colno,StartCombiRow,StartCombiCol,nCombiRows,nCombiCols
    rowno=nCombiRows+1+rowno
    FirstRowNo=rowno
end Function

sub rowDel(detailgroup)     
    num=document.all("totalrow"&detailgroup).value
    heads="detail"&detailgroup&"_head"
    ends="detail"&detailgroup&"_end"
    sels="detail"&detailgroup&"_sel"
    headrow=frmmain.ChinaExcel.GetCellUserStringValueRow (heads)
    endrow=frmmain.ChinaExcel.GetCellUserStringValueRow (ends)
    selcol=frmmain.ChinaExcel.GetCellUserStringValueCol (sels)
	frmmain.ChinaExcel.SetCanRefresh false
	bool="0"
	if NOT isempty(headrow) and headrow <>"" and NOT isempty(endrow) and endrow<>"" then
        t=endrow-1
		frmmain.ChinaExcel.GetCellCombiNationWeb t,selcol,StartCombiRow,StartCombiCol,nCombiRows,nCombiCols
        do while t>(headrow+nCombiRows+1)
            if nCombiRows>0 then
                k=t-nCombiRows
            else
                k=t
            end if
            if frmmain.ChinaExcel.GetCellCheckBoxValue (k,selcol) then
                bool="1"
                exit do
            end if
            t=t-1
        loop
    end if
    if bool="1" then
    if confirm("你确定要删除吗？") then
    if NOT isempty(headrow) and headrow <>"" and NOT isempty(endrow) and endrow<>"" then
        i=endrow-1
		frmmain.ChinaExcel.GetCellCombiNationWeb i,selcol,StartCombiRow,StartCombiCol,nCombiRows,nCombiCols
        while i>(headrow+nCombiRows+1)           
            if nCombiRows>0 then
                k=i-nCombiRows
            else
                k=i
            end if
            bol=frmmain.ChinaExcel.GetCellCheckBoxValue (k,selcol)
            if bol then
					n=k
                    delrow="0"
					while n<=i
						j=frmmain.ChinaExcel.GetMaxCol
						while j>=0
							userstr=frmmain.ChinaExcel.GetCellUserStringValue(n,j)
							if NOT isempty(userstr) and InStr(userstr,"_sel")<1 then
							indx=InStr(userstr,"_")
							if indx>1 then
								rightstr=Mid(userstr,indx+1,Len(userstr))
								userstr=Mid(userstr,1,indx)								
								indx=InStr(rightstr,"_")
								if indx>1 then
								userstr=userstr+Mid(rightstr,1,indx-1)
                                delrow=Mid(rightstr,1,indx-1)
                                resetsubmitdtlid(delrow&"_"&detailgroup)
								end if
								deldetail(userstr)
							end if
							end if
							j=j-1
						wend
					n=n+1
					wend
                    dtlid=document.all("dtl_id_"&detailgroup&"_"&delrow).value
                    if dtlid<>"" then
                        if document.all("deldtlid"&detailgroup).value="" then
                            document.all("deldtlid"&detailgroup).value=dtlid
                        else
                            document.all("deldtlid"&detailgroup).value=document.all("deldtlid"&detailgroup).value&","&dtlid
                        end if
                    end if
                    frmmain.ChinaExcel.DeleteRow k,i
                    num=num-1
                    document.all("totalrow"&detailgroup).value=num
                    
            end if
            i=i-1
        wend
    end if
    frmmain.ChinaExcel.ReCalculate
    end if
    else
     MsgBox "请选择需要删除的数据", vbExclamation
    end if
    endrow=frmmain.ChinaExcel.GetCellUserStringValueRow (ends)
	falg=frmmain.ChinaExcel.GetCellCheckBoxValue (endrow-1,selcol)
    frmmain.ChinaExcel.GoToCell endrow-1,selcol	
	frmmain.ChinaExcel.SetCellCheckBoxValue endrow-1,selcol,falg
	frmmain.ChinaExcel.SetCanRefresh true
	frmmain.ChinaExcel.RefreshViewSize    
end sub



sub onShowCustomerThis(fieldid,nowrow,nowcol)
    reportUserIdInputName=document.getElementById("reportUserIdInputName").value
    reportUserId=document.getElementById(reportUserIdInputName).value

    inprepIdTemp=document.getElementById("inprepIdTemp").value
	url="/systeminfo/BrowserMain.jsp?url=/datacenter/input/CustomerBrowserForBasicUnit.jsp?reportUserId="&reportUserId&"%26isSecurity=false%26inprepId="&inprepIdTemp&"%26isInit=1"
    dialogId = window.showModalDialog(url)

	if NOT isempty(dialogId) then
        if dialogId(0)<> "" then
		    document.getElementById(fieldid).value=dialogId(0)
		    frmmain.ChinaExcel.SetCellVal nowrow,nowcol,getChangeField(dialogId(1))
		else
		    document.getElementById(fieldid).value =""
		    frmmain.ChinaExcel.SetCellVal nowrow,nowcol,""
		end if
		imgshoworhide nowrow,nowcol
        frmmain.ChinaExcel.RefreshViewSize
	end if
end sub

sub onShowReportUserIdThis(id1,fieldid,nowrow,nowcol)
		if NOT isempty(id1) then
		       hisReportUserId=document.getElementById(fieldid).value
			   if  hisReportUserId<>id1(0) then
			       crmIdInputName=document.getElementById("crmIdInputName").value
			       document.getElementById(crmIdInputName).value=""
				   tempCrmIdInputName=crmIdInputName&"_7_3"
				   crmIdRow=frmmain.ChinaExcel.GetCellUserStringValueRow(tempCrmIdInputName)
				   crmIdCol=frmmain.ChinaExcel.GetCellUserStringValueCol(tempCrmIdInputName)
				   frmmain.ChinaExcel.SetCellVal crmIdRow,crmIdCol,""
				   imgshoworhide crmIdRow,crmIdCol
				   frmmain.ChinaExcel.RefreshViewSize
			   end if
			   if  id1(0)<>""  and id1(0)<> "0"  then
					document.getElementById(fieldid).value=id1(0)
					frmmain.ChinaExcel.SetCellVal nowrow,nowcol,getChangeField(id1(1))
				else
					document.getElementById(fieldid).value=""
					frmmain.ChinaExcel.SetCellVal nowrow,nowcol,""
				end if
				imgshoworhide nowrow,nowcol
				frmmain.ChinaExcel.RefreshViewSize
		end if
end sub

sub onShowInprepDspDateThis(id1,fieldid,type1,ismand,nowrow,nowcol)
   if NOT isempty(id1)  then
        frmmain.ChinaExcel.SetCellVal nowrow,nowcol,getChangeField(id1(1))
        document.getElementById(fieldid).value=id1
        document.getElementById("date").value=id1
        imgshoworhide nowrow,nowcol
        frmmain.ChinaExcel.RefreshViewSize
   end if
end sub
sub onShowSignBrowser(url,linkurl,inputname,spanname,type1)
    tmpids = document.all(inputname).value
    if type1=37 then
    id1 = window.showModalDialog("/systeminfo/BrowserMain.jsp?url="&url&"?documentids="&tmpids)
    else
    id1 = window.showModalDialog("/systeminfo/BrowserMain.jsp?url="&url&"?resourceids="&tmpids)
    end if
        if NOT isempty(id1) then
		   if id1(0)<> ""  and id1(0)<> "0"  then
					resourceids = id1(0)
					resourcename = id1(1)
					sHtml = ""
					'resourceids = Mid(resourceids,2,len(resourceids))
					document.all(inputname).value= resourceids
					'resourcename = Mid(resourcename,2,len(resourcename))
					while InStr(resourceids,",") <> 0
						curid = Mid(resourceids,1,InStr(resourceids,",")-1)
						curname = Mid(resourcename,1,InStr(resourcename,",")-1)
						resourceids = Mid(resourceids,InStr(resourceids,",")+1,Len(resourceids))
						resourcename = Mid(resourcename,InStr(resourcename,",")+1,Len(resourcename))
						sHtml = sHtml&"<a href="&linkurl&curid&" target='_blank'>"&curname&"</a>&nbsp"
					wend
					sHtml = sHtml&"<a href="&linkurl&resourceids&" target='_blank'>"&resourcename&"</a>&nbsp"
					document.all(spanname).innerHtml = sHtml

		else
				    document.all(spanname).innerHtml = empty
					document.all(inputname).value=""
        end if
      end if
end sub