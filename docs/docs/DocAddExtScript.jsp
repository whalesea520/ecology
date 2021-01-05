
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<script language=vbs>
sub onSelectMainDocument
	id = window.showModalDialog("/docs/DocBrowserMain.jsp?url=/docs/docs/DocBrowser.jsp")
	if not IsEmpty(id) then
		spanMainDocument.innerHTML = id(1)
		weaver.maindoc.value=id(0)
	else
		spanMainDocument.innerHTML = "<%=SystemEnv.getHtmlLabelName(524,languageId)%><%=SystemEnv.getHtmlLabelName(58,languageId)%>"
		weaver.maindoc.value = -1
	end if
end sub

sub onShowLanguage
    id = window.showModalDialog("/systeminfo/language/LanguageBrowser.jsp")
    language.innerHtml = id(1)
    weaver.doclangurage.value=id(0)
end sub
</script>

<script language=vbs>
sub onShowBrowser(id,url,linkurl,type1,ismand)
	if type1= 2 or type1 = 19 then
		id1 = window.showModalDialog(url,,"dialogHeight:320px;dialogwidth:275px")
		document.all("customfield"+id+"span").innerHtml = id1
		document.all("customfield"+id).value=id1
	elseif type1 = 141  then
        onShowResourceConditionBrowser  id,url,linkurl,type1,ismand
	else
        if type1=143 then
			tmpids = document.all("customfield"+id).value
			id1 = window.showModalDialog(url&"?treeDocFieldIds="&tmpids)
		elseif type1 <> 171 and type1 <> 17 and type1 <> 18 and type1<>27 and type1<>37 and type1<>56 and type1<>57 and type1<>65 and type1<>142 and type1<>152 and type1<>168 and type1<>4 and type1<>167 and type1<>164 and type1<>169 and type1<>170  and type1<>162 then
			id1 = window.showModalDialog(url)
        elseif type1=142 then
            tmpids = document.all("customfield"+id).value
			id1 = window.showModalDialog(url&"?receiveUnitIds="&tmpids)
		elseif type1=4 or type1=167 or type1=164 or type1=169 or type1=170 then
            tmpids = document.all("customfield"+id).value
			id1 = window.showModalDialog(url&"?selectedids="&tmpids)
		elseif type1=162 then
            tmpids = document.getElementById("customfield"+id).value
			url = url&"&beanids="&tmpids
			url = Mid(url,1,(InStr(url,"url="))+3) & escape(Mid(url,(InStr(url,"url="))+4,len(url)))
			id1 = window.showModalDialog(url)
		else
			tmpids = document.all("customfield"+id).value
			id1 = window.showModalDialog(url&"?resourceids="&tmpids)

		end if



		if NOT isempty(id1) then
			if type1 = 171 or type1 = 17 or type1 = 18 or type1=27 or type1=37 or type1=56 or type1=57 or type1=65 or type1 = 142 or type1 = 168 or type1 = 166 then
				if id1(0)<> ""  and id1(0)<> "0" then
					resourceids = id1(0)
					resourcename = id1(1)
					sHtml = ""
					resourceids = Mid(resourceids,2,len(resourceids))
					document.all("customfield"+id).value= resourceids
					resourcename = Mid(resourcename,2,len(resourcename))
					while InStr(resourceids,",") <> 0
						curid = Mid(resourceids,1,InStr(resourceids,",")-1)
						curname = Mid(resourcename,1,InStr(resourcename,",")-1)
						resourceids = Mid(resourceids,InStr(resourceids,",")+1,Len(resourceids))
						resourcename = Mid(resourcename,InStr(resourcename,",")+1,Len(resourcename))
						sHtml = sHtml&"<a target='_blank' href="&linkurl&curid&">"&curname&"</a>&nbsp"
					wend
					sHtml = sHtml&"<a target='_blank' href="&linkurl&resourceids&">"&resourcename&"</a>&nbsp"
					document.all("customfield"+id+"span").innerHtml = sHtml

				else
					if ismand=0 then
						document.all("customfield"+id+"span").innerHtml = empty
					else
						document.all("customfield"+id+"span").innerHtml ="<img src='/images/BacoError_wev8.gif' align=absmiddle>"
					end if
					document.all("customfield"+id).value=""
				end if
			elseif type1 = 152 then
				if id1(0)<> ""  and id1(0)<> "0" then
					resourceids = id1(0)
					resourcename = id1(1)
					sHtml = ""
					resourceids = Mid(resourceids,2,len(resourceids))
					document.all("customfield"+id).value= resourceids
					resourcename = Mid(resourcename,2,len(resourcename))
					while InStr(resourceids,",") <> 0
						curid = Mid(resourceids,1,InStr(resourceids,",")-1)
						curname = Mid(resourcename,1,InStr(resourcename,",")-1)
						resourceids = Mid(resourceids,InStr(resourceids,",")+1,Len(resourceids))
						resourcename = Mid(resourcename,InStr(resourcename,",")+1,Len(resourcename))
						sHtml = sHtml&"<a target='_blank' href="&linkurl&curid&">"&curname&"</a>&nbsp"
					wend
					sHtml = sHtml&"<a target='_blank' href="&linkurl&resourceids&">"&resourcename&"</a>&nbsp"
					document.all("customfield"+id+"span").innerHtml = sHtml

				else
					if ismand=0 then
						document.all("customfield"+id+"span").innerHtml = empty
					else
						document.all("customfield"+id+"span").innerHtml ="<img src='/images/BacoError_wev8.gif' align=absmiddle>"
					end if
					document.all("customfield"+id).value=""
				end if
			elseif type1 = 143 then
				if id1(0)<> ""  and id1(0)<> "0" then
					resourceids = id1(0)
					resourcename = id1(1)
					sHtml = ""
					resourceids = resourceids+","
					document.all("customfield"+id).value= resourceids
                    resourceids= Mid(resourceids,2,len(resourceids)-2) 
					resourcename = Mid(resourcename,2,len(resourcename))
					while InStr(resourceids,",") <> 0
						curid = Mid(resourceids,1,InStr(resourceids,",")-1)
						curname = Mid(resourcename,1,InStr(resourcename,",")-1)
						resourceids = Mid(resourceids,InStr(resourceids,",")+1,Len(resourceids))
						resourcename = Mid(resourcename,InStr(resourcename,",")+1,Len(resourcename))
						sHtml = sHtml&"<a target='_blank' href="&linkurl&curid&">"&curname&"</a>&nbsp"
					wend
					sHtml = sHtml&"<a target='_blank' href="&linkurl&resourceids&">"&resourcename&"</a>&nbsp"
					document.all("customfield"+id+"span").innerHtml = sHtml

				else
					if ismand=0 then
						document.all("customfield"+id+"span").innerHtml = empty
					else
						document.all("customfield"+id+"span").innerHtml ="<img src='/images/BacoError_wev8.gif' align=absmiddle>"
					end if
					document.all("customfield"+id).value=""
				end if
			else
			    if  id1(0)<>""   and id1(0)<> "0"  then

                   if type1=162 then
				     ids = id1(0)
					names = id1(1)
					descs = id1(2)
					sHtml = ""
					ids = Mid(ids,1,len(ids))
					document.all("customfield"+id).value= ids
					names = Mid(names,1,len(names))
					descs = Mid(descs,1,len(descs))
					while InStr(ids,",") <> 0
						curid = Mid(ids,1,InStr(ids,","))
						curname = Mid(names,1,InStr(names,",")-1)
						curdesc = Mid(descs,1,InStr(descs,",")-1)
						ids = Mid(ids,InStr(ids,",")+1,Len(ids))
						names = Mid(names,InStr(names,",")+1,Len(names))
						descs = Mid(descs,InStr(descs,",")+1,Len(descs))
						sHtml = sHtml&"<a title='"&curdesc&"' >"&curname&"</a>&nbsp"
					wend
					sHtml = sHtml&"<a title='"&descs&"'>"&names&"</a>&nbsp"
					document.all("customfield"+id+"span").innerHtml = sHtml
                    exit sub
                   end if
				   if type1=161 then
				     name = id1(1)
					desc = id1(2)
				    document.all("customfield"+id).value=id1(0)
					sHtml = "<a title='"&desc&"'>"&name&"</a>&nbsp"
					document.all("customfield"+id+"span").innerHtml = sHtml
                    exit sub
                   end if

			        if linkurl = "" then
						document.all("customfield"+id+"span").innerHtml = id1(1)
					else
						document.all("customfield"+id+"span").innerHtml = "<a target='_blank' href="&linkurl&id1(0)&">"&id1(1)&"</a>"
					end if
					document.all("customfield"+id).value=id1(0)
				else
					if ismand=0 then
						document.all("customfield"+id+"span").innerHtml = empty
					else
						document.all("customfield"+id+"span").innerHtml ="<img src='/images/BacoError_wev8.gif' align=absmiddle>"
					end if
					document.all("customfield"+id).value=""
				end if
			end if
		end if
	end if

end sub


sub onShowResourceConditionBrowser(id,url,linkurl,type1,ismand)

	tmpids = document.all("customfield"+id).value
	dialogId = window.showModalDialog(url&"?resourceCondition="&tmpids)
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
			    sHtml = sHtml&","&shareTypeText&"("&relatedShareNames&")"
	        else	if  shareTypeValue= "2" then
			             sHtml = sHtml&","&shareTypeText&"("&relatedShareNames&")"&"<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>>="&secLevelValue&"<%=SystemEnv.getHtmlLabelName(18941,user.getLanguage())%>"
			        else   if shareTypeValue= "3" then
			                   sHtml = sHtml&","&shareTypeText&"("&relatedShareNames&")"&"<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>>="&secLevelValue&"<%=SystemEnv.getHtmlLabelName(18942,user.getLanguage())%>"
					       else  if shareTypeValue= "4" then
			                         sHtml = sHtml&","&shareTypeText&"("&relatedShareNames&")"&"<%=SystemEnv.getHtmlLabelName(3005,user.getLanguage())%>="&rolelevelText&"  <%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>>="&secLevelValue&"<%=SystemEnv.getHtmlLabelName(18945,user.getLanguage())%>"
						         else
			                         sHtml = sHtml&","&"<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>>="&secLevelValue&"<%=SystemEnv.getHtmlLabelName(18943,user.getLanguage())%>"
								 end if
						   end if
					end if
	        end if
		wend

            fileIdValue=fileIdValue&"~"&shareTypeValues&"_"&relatedShareIdses&"_"&rolelevelValues&"_"&secLevelValues


	        if shareTypeValues= "1" then
			    sHtml = sHtml&","&shareTypeTexts&"("&relatedShareNameses&")"
	        else	if  shareTypeValues= "2" then
			             sHtml = sHtml&","&shareTypeTexts&"("&relatedShareNameses&")"&"<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>>="&secLevelValues&"<%=SystemEnv.getHtmlLabelName(18941,user.getLanguage())%>"
			        else   if shareTypeValues= "3" then
			                   sHtml = sHtml&","&shareTypeTexts&"("&relatedShareNameses&")"&"<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>>="&secLevelValues&"<%=SystemEnv.getHtmlLabelName(18942,user.getLanguage())%>"
					       else  if shareTypeValues= "4" then
			                         sHtml = sHtml&","&shareTypeTexts&"("&relatedShareNameses&")"&"<%=SystemEnv.getHtmlLabelName(3005,user.getLanguage())%>="&rolelevelTexts&"  <%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>>="&secLevelValues&"<%=SystemEnv.getHtmlLabelName(18945,user.getLanguage())%>"
						         else
			                         sHtml = sHtml&","&"<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>>="&secLevelValues&"<%=SystemEnv.getHtmlLabelName(18943,user.getLanguage())%>"
								 end if
						   end if
					end if
	        end if

		sHtml = Mid(sHtml,2,len(sHtml))
		fileIdValue=Mid(fileIdValue,2,len(fileIdValue))

		document.all("customfield"+id).value= fileIdValue
		document.all("customfield"+id+"span").innerHtml = sHtml
	else
        if ismand=0 then
                document.all("customfield"+id+"span").innerHtml = empty
        else
                document.all("customfield"+id+"span").innerHtml ="<img src='/images/BacoError_wev8.gif' align=absmiddle>"
        end if
        document.all("customfield"+id).value=""
	end if
	end if

end sub


sub onShowResource()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
	if NOT isempty(id) then
	    if id(0)<> "" then
		owneridspan.innerHtml = "<a href='javaScript:openhrm("&id(0)&");' onclick='pointerXY(event);'>"&id(1)&"</a>"
		weaver.ownerid.value=id(0)
		docdepartmentidspan.innerHtml = "<a href='/hrm/company/HrmDepartmentDsp.jsp?id="&id(2)&"'>"&id(3)&"</a>"
		weaver.docdepartmentid.value=id(2)
		else
		owneridspan.innerHtml = " <IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
		weaver.ownerid.value=""
		docdepartmentidspan.innerHtml = " <IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
		weaver.docdepartmentid.value=""
		end if
	end if
end sub

    sub onShowHrmresID(objval)
    id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
    if (Not IsEmpty(id)) then
    if id(0)<> "" then
    hrmresspan.innerHtml = "<A href='javaScript:openhrm("&id(0)&");' onclick='pointerXY(event);'>"&id(1)&"</A>"
    weaver.hrmresid.value=id(0)

    else
    if objval="2" then
    hrmresspan.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
    else
    hrmresspan.innerHtml =""
    end if
    weaver.hrmresid.value=""
    end if
    end if
    end sub

    sub onShowAssetId(objval)
    id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/cpt/capital/CapitalBrowser.jsp")
    if (Not IsEmpty(id)) then
    if id(0)<> "" and id(0)<> "0"  then
    assetidspan.innerHtml = "<A href='/cpt/capital/CptCapital.jsp?id="&id(0)&"'>"&id(1)&"</A>"
    weaver.assetid.value=id(0)
    else
    if objval="2" then
    assetidspan.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
    else
    assetidspan.innerHtml =""
    end if
    //weaver.assetid.value="0"
    weaver.assetid.value=""
    end if
    end if
    end sub

    sub onShowCrmID(objval)
    id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp")
    if (Not IsEmpty(id)) then
    if id(0)<> "" then
    crmidspan.innerHtml = "<A href='/CRM/data/ViewCustomer.jsp?CustomerID="&id(0)&"'>"&id(1)&"</A>"
    weaver.crmid.value=id(0)
    else
    if objval="2" then
    crmidspan.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
    else
    crmidspan.innerHtml =""
    end if
    //weaver.crmid.value="0"
    weaver.crmid.value=""
    end if
    end if
    end sub

    sub onShowItemID(objval)
    id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/lgc/asset/LgcAssetBrowser.jsp")
    if (Not IsEmpty(id)) then
    if id(0)<> "" then
    itemspan.innerHtml = "<A href='/lgc/asset/LgcAsset.jsp?paraid="&id(0)&"'>"&id(1)&"</A>"
    weaver.itemid.value=id(0)
    else
    if objval="2" then
    itemspan.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
    else
    itemspan.innerHtml =""
    end if
    //weaver.itemid.value="0"
    weaver.itemid.value=""
    end if
    end if
    end sub

    sub onShowItemmaincategoryID(objval)
    id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/lgc/maintenance/LgcAssortmentBrowserAll.jsp")
    if (Not IsEmpty(id)) then
    if id(0)<> "" then
    itemmaincategorypan.innerHtml = id(1)
    weaver.itemmaincategoryid.value=id(0)
    else
    if objval="2" then
    itemmaincategorypan.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
    else
    itemmaincategorypan.innerHtml =""
    end if
    //weaver.itemmaincategoryid.value="0"
    weaver.itemmaincategoryid.value=""
    end if
    end if
    end sub

    sub onShowProjectID(objval)
    id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/proj/data/ProjectBrowser.jsp")
    if (Not IsEmpty(id)) then
    if id(0)<> "" then
    projectidspan.innerHtml = "<A href='/proj/data/ViewProject.jsp?ProjID="&id(0)&"'>"&id(1)&"</A>"
    weaver.projectid.value=id(0)
    else
    if objval="2" then
    projectidspan.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
    else
    projectidspan.innerHtml =""
    end if
    //weaver.projectid.value="0"
    weaver.projectid.value=""
    end if
    end if
    end sub


sub onShowMutiDummy(input,span)	
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/category/DocTreeDocFieldBrowserMulti.jsp?para="+input.value)
	if NOT isempty(id) then
	    if id(0)<> "" then	
			dummyidArray=Split(id(0),",")
			dim dummynamestr
	    dummynamestr=Replace(id(1),"<","&lt;",1,-1,1)
			dummynamestr=Replace(dummynamestr,">","&gt;",1,-1,1)
			
			dummynames=Split(dummynamestr,",")
			dummyLen=ubound(dummyidArray)-lbound(dummyidArray) 

			For k = 0 To dummyLen
				sHtml = sHtml&"<a href='/docs/docdummy/DocDummyList.jsp?dummyId="&dummyidArray(k)&"'>"&dummynames(k)&"</a>&nbsp"
			Next

			input.value=id(0)
			span.innerHTML=sHtml
		else			
			input.value=""
			span.innerHTML=""
		end if
	end if
end sub

</script>

<script language=javascript>
<%if(fromFlowDoc.equals("1")){%>
jQuery(window.parent.document).find("div#docblock .e8_btn_top_first_disabled").attr("disabled",false);
jQuery(window.parent.document).find("div#docblock .e8_btn_top_disabled").attr("disabled",false);
jQuery(window.parent.document).find("div#docblock .e8_btn_top_first_disabled").removeClass().addClass("e8_btn_top_first"); 
jQuery(window.parent.document).find("div#docblock .e8_btn_top_disabled").removeClass().addClass("e8_btn_top"); 
<%}%>
function afterOnShowResource(e,data,name,params){
	if(data){
		if(data.id!=""){
			weaver.docdepartmentid.value=wuiUtil.getJsonValueByIndex(data,2);
			docdepartmentidspan.innerHTML = "<a href='/hrm/company/HrmDepartmentDsp.jsp?id="+wuiUtil.getJsonValueByIndex(data,2)+"'>"+wuiUtil.getJsonValueByIndex(data,3)+"</a>";
		}else{
			weaver.docdepartmentid.value="";
			docdepartmentidspan.innerHTML = "";
		}
	}
}

function checkDocMain(){
	if(document.weaver.docpublishtype!=null&&document.weaver.docpublishtype.value==2){
		if(check_form(document.weaver,'docmain')){
			return true;
		} else {
			//DocAllPropPanel.expand(true);
			onExpandOrCollapse(true);
			//DocSetTabPanel.setActiveTab("DocPropAdd");
			onActiveTab("divProp");
			return false;  
		}
	} 
	return true;
}

function afterSaveValidate(){
	<%if (!fromFlowDoc.equals("1")) {%>
       	if(!check_form(document.weaver,getNeedinputitems())){
			onExpandOrCollapse(true);
			onActiveTab("divProp");
		try{
			enableTabBtn();
		}catch(e){}
			return false;
		}
	    if(checkSubjectRepeated()&&checkDocMain()){
		    if (<%=isPersonalDoc%>) {
			    document.weaver.docstatus.value=1
			    document.weaver.from.value='personalDoc'
			    document.weaver.userCategory.value=<%=userCategory%>
		    }
		//document.getElementById("btn_saveid").disabled=true;
		//document.getElementById("btn_draft").disabled=true;


	        document.weaver.operation.value='addsave';
		    if(SaveDocument()){
		        mybody.onbeforeunload=null;

                showPrompt("<%=SystemEnv.getHtmlLabelName(18885,languageId)%>");
                 try{
		        	Ext.getCmp("divContentTab").getBottomToolbar().disable();
		        }catch(e){}
		        document.weaver.submit();
		    }
		} else {
		try{
			enableTabBtn();
		}catch(e){}
       }
       <%}
       else
       {%>
       if(checkDocMain()){
		    if (<%=isPersonalDoc%>) {
			    document.weaver.docstatus.value=1
			    document.weaver.from.value='personalDoc'
			    document.weaver.userCategory.value=<%=userCategory%>
		    }

		    
			document.weaver.operation.value='addsave';
		    if(SaveDocument()){
		        mybody.onbeforeunload=null;


                showPrompt("<%=SystemEnv.getHtmlLabelName(18885,languageId)%>");

                 try{
		        	Ext.getCmp("divContentTab").getBottomToolbar().disable();
		        }catch(e){}
		        document.weaver.submit();
		    }
		}
       <%}%>
}

// 返回表单页面
function backToForm() {
	var tab1 = parent.document.getElementById("tab1");
	jQuery(tab1).parent().find("li.current").removeClass("current");
	jQuery(tab1).addClass("current");
	jQuery(tab1).find("a").click();
	var navo = jQuery(tab1).parent().find("li.magic-line");
	navo.css("left", jQuery(tab1).offset().left - (navo.width() - jQuery(tab1).width())/2 - 5);
}

  function onSave(){
	try{
		disableTabBtn();
	}catch(e){
	}
	if(!jQuery("#seccategory").val()){
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(81559,user.getLanguage())%>");
		try{
			enableTabBtn();
		}catch(e){}
		return;
	}
	if(<%=!isPersonalDoc%>){
		checkDocSubject($GetEle("docsubject"),function(){
			if($GetEle("namerepeated").value==1){
				try{
					enableTabBtn();
				}catch(e){}
				return;
			}
			afterSaveValidate();
		});
	}else{
		afterSaveValidate();
	}
       
       
  }
  
  function afterDraftValidate(){
  	if(!check_form(document.weaver,getNeedinputitems())){
			onExpandOrCollapse(true);
			onActiveTab("divProp");
		try{
			enableTabBtn();
		}catch(e){}
			return false;
		}
		
	    if(checkSubjectRepeated()&&checkDocMain()){

            document.weaver.docstatus.value=0;
            document.weaver.operation.value='adddraft';
            if(SaveDocument()){
            mybody.onbeforeunload=null;

            showPrompt("<%=SystemEnv.getHtmlLabelName(18885,languageId)%>");

		    try{
        		Ext.getCmp("divContentTab").getBottomToolbar().disable();
	        }catch(e){}
            document.weaver.submit();
            }
        }else {
		try{
			enableTabBtn();
		}catch(e){}
       }
  }
  
  function onDraft(){
    	try{
		disableTabBtn();
	}catch(e){}
	if(!jQuery("#seccategory").val()){
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(81559,user.getLanguage())%>");
		try{
			enableTabBtn();
		}catch(e){}
		return;
	}
	if(<%=!isPersonalDoc%>){
		checkDocSubject($GetEle("docsubject"),function(){
			if($GetEle("namerepeated").value==1){
				try{
					parent.enableTabBtn();
				}catch(e){}
				return;
			}
			afterDraftValidate();
		});
	}else{
		afterDraftValidate();
	}
    	
    }
	
	function afterPreviewValidate(){
		if(!check_form(document.weaver,getNeedinputitems())){
			//DocAllPropPanel.expand(true);
			onExpandOrCollapse(true);
			//DocSetTabPanel.setActiveTab("DocPropAdd");
			onActiveTab("divProp");
		try{
			enableTabBtn();
		}catch(e){}
			return false;
		}
		
	    if(checkSubjectRepeated()&&checkDocMain()){

            document.weaver.docstatus.value=0;
            document.weaver.operation.value='addpreview';
                if(SaveDocument()){
                mybody.onbeforeunload=null;

                showPrompt("<%=SystemEnv.getHtmlLabelName(18885,languageId)%>");

                try{
	        		Ext.getCmp("divContentTab").getBottomToolbar().disable();
		        }catch(e){}
                document.weaver.submit();
                }
        } else {
    	try{
			enableTabBtn();
		}catch(e){}
       }
	}
	
    function onPreview(){
	try{
		disableTabBtn();
	}catch(e){}
	if(!jQuery("#seccategory").val()){
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(81559,user.getLanguage())%>");
		try{
			enableTabBtn();
		}catch(e){}
		return;
	}
	if(<%=!isPersonalDoc%>){
		checkDocSubject($GetEle("docsubject"),function(){
			if($GetEle("namerepeated").value==1){
				try{
					enableTabBtn();
				}catch(e){}
				return;
			}
			afterPreviewValidate();
		});
	}else{
		afterPreviewValidate();
	}
        
    }
function selectTemplate2(seccategory,wordmouldid){
	jQuery("#selectTaohongMouldBtn").trigger("click");  
}

function getBrowserUrlFn(seccategoryid){
	 wordmouldid=document.getElementById("selectedpubmouldid").value;
	 return "/systeminfo/BrowserMain.jsp?url=/docs/docs/DocEditTemplateList.jsp?seccategory="+seccategoryid+"&wordmouldid="+wordmouldid+"&workflowid=<%=workflowid%>";
}

   function afterSelectMould(e,rt,name,params){
    	var seccategory = <%=mouldSecCategoryId%>;
    	var wordmouldid = "<%=docmodule%>";
	    if(rt != null){
			try{
				window.onbeforeunload=null;
			}catch(e){
			}
		window.location.href="/docs/docs/DocAddExt.jsp?f_weaver_belongto_userid=<%=f_weaver_belongto_userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>&fromFlowDoc=<%=fromFlowDoc%>&requestid=<%=requestid%>&topage=<%=tmptopage%>&mainid=<%=mainid%>&secid=<%=secid%>&subid=<%=subid%>&docId=&isintervenor=&docmodule="+rt.id+"&ischeckeditmould=1";


		
	}
}

    
    function selectTemplate(seccategory,wordmouldid){
    	if(!seccategory)seccategory = <%=mouldSecCategoryId%>;
    	if(!wordmouldid) wordmouldid = "<%=docmodule%>";
	    wordmouldid=document.getElementById("editMouldId").value;
	    var rt = window.showModalDialog("TaoHongTemplateEdit.jsp?seccategory="+seccategory+"&wordmouldid="+wordmouldid," ","dialogWidth=450px;dialogHeight=450px");
	    if(rt != null){
			document.getElementById("WebOffice").Template=rt;
	        document.getElementById("editMouldId").value=rt;
	
			document.getElementById("WebOffice").FileName="";
			document.getElementById("WebOffice").FileType="<%=docType%>";
			document.getElementById("WebOffice").EditType="1<%=canPostil%>";
				<%if(isIWebOffice2006 == true){%>
			document.getElementById("WebOffice").ShowToolBar="0";      //ShowToolBar:是否显示工具栏:1显示,0不显示
				<%}%>
	
			document.getElementById("WebOffice").MaxFileSize = <%=maxOfficeDocFileSize%> * 1024; 
			document.getElementById("WebOffice").UserName="<%=user.getUsername()%>";
			document.getElementById("WebOffice").WebSetMsgByName("USERID","<%=user.getUID()%>");
			document.getElementById("WebOffice").WebOpen();  	//打开该文档
	
	<%if(!editMouldIdAndSecCategoryId.equals("")){%>
	      document.getElementById("WebOffice").WebSetMsgByName("ISEDITMOULD","TRUE");
	      document.getElementById("WebOffice").WebSetMsgByName("EDITMOULDID",rt);
	      document.getElementById("WebOffice").WebSetMsgByName("REQUESTID","<%=requestid%>");
	      document.getElementById("WebOffice").WebSetMsgByName("WORKFLOWID","<%=workflowid%>");
	      document.getElementById("WebOffice").WebSetMsgByName("LANGUAGEID","<%=languageId%>");
		  document.getElementById("WebOffice").WebSetMsgByName("SHOWDOCMOULDBOOKMARK","<%=fromFlowDoc%>");//载入是否显示“文档模板书签表”数据,这根据“是否来源于流程建文挡”来确定。
	      document.getElementById("WebOffice").WebLoadBookMarks();//替换书签
	<%}%>

	}
}

</script>
<SCRIPT language="javascript" src="/js/selectDateTime_wev8.js"></script>

<!-- added by cyril on 20080610 for td8828-->
<script language=javascript src="/js/checkData_wev8.js"></script>
<!-- end by cyril on 20080610 for td8828-->