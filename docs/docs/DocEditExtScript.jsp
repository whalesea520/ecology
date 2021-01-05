
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="java.net.*" %>
<%@ page import="weaver.file.Prop" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
int docid = Util.getIntValue(request.getParameter("docid"));
String fromFlowDoc = Util.null2String(request.getParameter("fromFlowDoc"));
boolean isIWebOffice2006 = Util.null2String(request.getParameter("isIWebOffice2006")).equals("1");
int requestid = Util.getIntValue(request.getParameter("requestid"));
String docstatus = Util.null2String(request.getParameter("docstatus"));
String ifVersion = Util.null2String(request.getParameter("ifVersion"));
String isCompellentMark = Util.null2String(request.getParameter("isCompellentMark"));
String canPostil = Util.null2String(request.getParameter("canPostil"));
String nodeid = Util.null2String(request.getParameter("nodeid"));
String isFromAccessory = Util.null2String(request.getParameter("isFromAccessory"));
String topageFromOther = Util.null2String(request.getParameter("topageFromOther"));
String signatureType = Util.null2String(Prop.getPropValue("wps_office_signature","wps_office_signature"));
String wps_version=Util.null2String(Prop.getPropValue("wps_office_signature","wps_version"));
int currentnodeid = Util.getIntValue(request.getParameter("currentnodeid"));
%>
<script language=vbs>
sub onSelectMainDocument
	id = window.showModalDialog("/docs/DocBrowserMain.jsp?url=/docs/docs/DocBrowser.jsp")
	if not IsEmpty(id) then
		spanMainDocument.innerHTML = id(1)
		weaver.maindoc.value=id(0)
	else
		spanMainDocument.innerHTML = "<%=SystemEnv.getHtmlLabelName(524,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%>"
		weaver.maindoc.value = -1
	end if
end sub

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
    assetidspan.innerHtml = "<A href='/cpt/capital/CapitalBrowser.jsp?id="&id(0)&"'>"&id(1)&"</A>"
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

<script type='text/javascript' src='/dwr/interface/DocDwrUtil.js'></script>
<script type='text/javascript' src='/dwr/engine.js'></script>
<script type='text/javascript' src='/dwr/util.js'></script>
<script language="javascript">
<%if(fromFlowDoc.equals("1")){%>
jQuery(window.parent.document).find("div#docblock .e8_btn_top_first_disabled").attr("disabled",false);
jQuery(window.parent.document).find("div#docblock .e8_btn_top_disabled").attr("disabled",false);
jQuery(window.parent.document).find("div#docblock .e8_btn_top_first_disabled").removeClass().addClass("e8_btn_top_first"); 
jQuery(window.parent.document).find("div#docblock .e8_btn_top_disabled").removeClass().addClass("e8_btn_top"); 
<%}%>
var checkresult = false;
var nowFunc = null;
var nowObj = null;
//签章类型
var signatureType = '<%=signatureType%>';

function checkCanSubmit(onFunc,onObj){
    var s = document.createElement("SCRIPT");
    document.getElementsByTagName("HEAD")[0].appendChild(s);
    s.src="DocCanSubmitCheck.jsp?docid=<%=docid%>";
    
	nowFunc = onFunc;
	nowObj = onObj;
}

function checkCanSubmitCallBack(data){
	if(data>0) {
		checkresult=false;
		alert("<%=SystemEnv.getHtmlLabelName(20411,user.getLanguage())%>");
	}
	else checkresult=true;
	
	if(checkresult&&nowFunc!=null)
		if(nowObj==null) eval(nowFunc+"()");
		else eval(nowFunc+"(nowObj)");
}

function openVersion(vid){
    docVersionWord(vid);
}

function checkDocMain(){
	if(document.weaver.docpublishtype!=null&&document.weaver.docpublishtype.value==2){
		if(check_form(document.weaver,'docmain')){
			return true;
		} else {
			onExpandOrCollapse(true);
			onActiveTab("divProp");
			return false;  
		}
	} 
	return true;
}

/*
 * 关闭当前页面
 */
function closeCurrentPage() {
	var browserName=navigator.appName;
    //alert(browserName);
    if (browserName == "Netscape") {    
        window.open('','_self','');
        window.close();
    } else {
        window.close();
    }  
}

/*
 * isFromAccessory 是否是附件
 * newVersion 是否生成新版本
 * notSubmit  是否提交form  true仅保存,false保存并提交
 * closeCurPage 保存后是否需要关闭页面  true关闭
 */
function afterSaveValidate(isFromAccessory,newVersion,notSubmit,closeCurPage){
	if(isFromAccessory||(check_form(document.weaver,getneedinputitems())&&checkSubjectRepeated()&&checkDocMain())){//如果是附件编辑提交的话，不需要验证文档的字段信息。
		document.weaver.operation.value='editsave';
		var saveStatus;
		document.getElementById("WebOffice").WebSetMsgByName("VERSIONDETAIL","<%=SystemEnv.getHtmlLabelName(28121, user.getLanguage())%>");
		document.getElementById("WebOffice").WebSetMsgByName("CLIENTADDRESS","<%=request.getRemoteAddr()%>");
		if(isFromAccessory && newVersion) {
			var notInputVDetail = isFromAccessory;// 是否需要手动输入版本信息  false-手动输入
			saveStatus=SaveDocumentNewV(notInputVDetail,isFromAccessory);
		} else {
			saveStatus=SaveDocument();
		}
		if(saveStatus){
			mybody.onbeforeunload = null;
			if(!notSubmit) {
				showPrompt("<%=SystemEnv.getHtmlLabelName(18893,user.getLanguage())%>");
				//Ext.getCmp("divContentTab").getBottomToolbar().disable();
				document.weaver.submit();
			} else if(notSubmit && closeCurPage) {
				closeCurrentPage();
			}
		}
    }
}

// repeat submit flag
var mf = false;
// save document
function onSaveOnly() {
	if(mf) {
		//console.log("submit repeated data.");
		return ;
	}
	mf = true;
	if(SaveDocument()){
		setWebObjectSaved();
		alert("<%=SystemEnv.getHtmlLabelName(18758,user.getLanguage())%>!");
	} else {
		alert("<%=SystemEnv.getHtmlLabelName(84544,user.getLanguage())%>!");
	}
	mf = false;
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

// 初始保存方法	
function onSave2(notSubmit){
	if(!checkCheckout()){
		return false;
	}
	btndisabledtrue();
	setTimeout("btndisabledfalse();",10000);
	<!-- 是否是附件 true代表是附件 -->
	var isFromAccessory = <%=isFromAccessory %>;
	<!-- 是否是流程文档 true代表是 -->
	var fromFlowDoc = "<%=fromFlowDoc %>" === "1";
	var isIWebOffice2006 = <%=isIWebOffice2006 %>;
	
	DocDwrUtil.ifCheckOutByCurrentUser(document.weaver.id.value,document.weaver.userId.value,{
		callback:function(result){
			if(result) {
				if(fromFlowDoc) {
					if(checkDocMain()) {
						if(isIWebOffice2006) {
							if(document.getElementById("WebOffice").Pages >=1) {
								document.getElementById("WebOffice").ShowType="1";								 
							}
						}
						document.weaver.operation.value='editsave';
						var saveStatus;
						saveStatus=SaveDocument();
						if(saveStatus && !notSubmit) {
							mybody.onbeforeunload=null;
							showPrompt("<%=SystemEnv.getHtmlLabelName(18893,user.getLanguage())%>");
							//Ext.getCmp("divContentTab").getBottomToolbar().disable();
							document.weaver.submit();
						} else if(saveStatus && notSubmit) {
							mybody.onbeforeunload=null;
							alert("<%=SystemEnv.getHtmlLabelNames("21656,15242",user.getLanguage())%>");
						}
					}
				} else {
					if(!checkresult) {
						return checkCanSubmit("onSave",null);
					}
					checkDocSubject($GetEle("docsubject"),function() {
						if($GetEle("namerepeated").value==1) {
							return;
						}
						if(isFromAccessory) {
							afterSaveValidate(true, true, true, true);
						} else {
							afterSaveValidate();
						}
						
					});
				}
			} else {
				top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(26090,user.getLanguage())%>");
				return;
			}
		}
	});
}
//通过ajax请求验证流程是否已经提交所调用的保存方法
function onSave(notSubmit){
<%
	if("1".equals(fromFlowDoc)){
%>
		jQuery.ajax({
				type: "POST",
				url: "/docs/reply/OperDocReply.jsp",
				data: {
				operation: 'workflowremark',
				requestid: <%=requestid%>,
				currentnodeid:<%=currentnodeid%>
				},
				cache: false,
				async:false,
				dataType: 'json',
				success: function(msg){	
					if("success"==msg.result){			
						onSave2(notSubmit);
					}else{
						alert("<%=SystemEnv.getHtmlLabelName(24338,user.getLanguage())%>");
					}
			}
		});	
<%
	}else{
%>
		onSave2(notSubmit);
<%}%>	
}
function afterSaveNewValidate(){
	if(check_form(document.weaver,getneedinputitems())&&checkSubjectRepeated()&&checkDocMain()){
		
		document.weaver.docstatus.value=1;
		document.weaver.operation.value='editsave';
        if(SaveDocumentNewV()){
			mybody.onbeforeunload=null;
			showPrompt("<%=SystemEnv.getHtmlLabelName(18893,user.getLanguage())%>");
			document.weaver.submit();
		}
    }
}

function onSaveNewVersion(notSubmit){
	if(!checkCheckout()){
		return false;
	}
	btndisabledtrue();
	setTimeout("btndisabledfalse();",10000);
	document.getElementById("WebOffice").WebSetMsgByName("NONEWVERSION","TRUE");
		DocDwrUtil.ifCheckOutByCurrentUser(document.weaver.id.value,document.weaver.userId.value,
			{callback:function(result){
				if(result){
<%
if (!fromFlowDoc.equals("1")) {
%>
	if(!checkresult) return checkCanSubmit("onSaveNewVersion",null);

		checkDocSubject($GetEle("docsubject"),function(){
			if($GetEle("namerepeated").value==1){
				return;
			}
			afterSaveNewValidate();
		});

	
<%
}else{
        if (docstatus.equals("2")||docstatus.equals("5")) {
%>
            document.weaver.docstatus.value="<%=docstatus%>";
<%
        }else{
%>
		    document.weaver.docstatus.value=1;
<%
        }
%>
		document.weaver.operation.value='editsave';
        if(SaveDocumentNewV() && !notSubmit){
			mybody.onbeforeunload=null;
			showPrompt("<%=SystemEnv.getHtmlLabelName(18893,user.getLanguage())%>");
			document.weaver.submit();
		}
<%
}
%>
				}else{
					top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(26090,user.getLanguage())%>");
					return;
				}
			  }
			}
		);
}

function afterDraftValidate(){
	if(check_form(document.weaver,getneedinputitems())&&checkSubjectRepeated()&&checkDocMain()){
    //document.weaver.docstatus.value=0;
    document.weaver.operation.value='editdraft';
    if(SaveDocument()){
    mybody.onbeforeunload=null;

    //增加提示信息  开始
    showPrompt("<%=SystemEnv.getHtmlLabelName(18893,user.getLanguage())%>");
    //增加提示信息  结束
    //Ext.getCmp("divContentTab").getBottomToolbar().disable();
    document.weaver.submit();
    }
    }
}

function onDraft2(){
	if(!checkCheckout()){
		return false;
	}
	btndisabledtrue();
	setTimeout("btndisabledfalse();",10000);

		DocDwrUtil.ifCheckOutByCurrentUser(document.weaver.id.value,document.weaver.userId.value,
			{callback:function(result){
				if(result){
	if(!checkresult) return checkCanSubmit("onDraft",null);

		checkDocSubject($GetEle("docsubject"),function(){
			if($GetEle("namerepeated").value==1){
				return;
			}
			afterDraftValidate();
		});

    
				}else{
					top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(26090,user.getLanguage())%>");
					return;
				}
			  }
			}
		);
}
function onDraft(){
<%
	if("1".equals(fromFlowDoc)){
%>
		jQuery.ajax({
				type: "POST",
				url: "/docs/reply/OperDocReply.jsp",
				data: {
				operation: 'workflowremark',
				requestid: <%=requestid%>,
				currentnodeid:<%=currentnodeid%>
				},
				cache: false,
				async:false,
				dataType: 'json',
				success: function(msg){	
					if("success"==msg.result){			
						onDraft2();
					}else{
						alert("<%=SystemEnv.getHtmlLabelName(24338,user.getLanguage())%>");
					}
				}
		});	
<%		
	}else{
%>
		onDraft2();
	<%}%>	
}
function afterPreviewValidate(){
	if(check_form(document.weaver,getneedinputitems())&&checkSubjectRepeated()&&checkDocMain()){
    //document.weaver.docstatus.value=0;
    document.weaver.operation.value='editpreview';
    if(SaveDocument()){
    mybody.onbeforeunload=null;

    //增加提示信息  开始
    showPrompt("<%=SystemEnv.getHtmlLabelName(18893,user.getLanguage())%>");
    //增加提示信息  结束
    //Ext.getCmp("divContentTab").getBottomToolbar().disable();
    document.weaver.submit();
    }
    }
}

function onPreview(){
	btndisabledtrue();
	setTimeout("btndisabledfalse();",10000);

		DocDwrUtil.ifCheckOutByCurrentUser(document.weaver.id.value,document.weaver.userId.value,
			{callback:function(result){
				if(result){
	if(!checkresult) return checkCanSubmit("onPreview",null);

		checkDocSubject($GetEle("docsubject"),function(){
			if($GetEle("namerepeated").value==1){
				return;
			}
			afterPreviewValidate();
		});

    
				}else{
					top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(26090,user.getLanguage())%>");
					return;
				}
			  }
			}
		);
}

function btndisabledtrue(){
	try{
		document.getElementById("wfbtn_save").disabled=true;
	}catch(e){}
	try{
		document.getElementById("wfbtn_signature1").disabled=true;
	}catch(e){}
	try{
		document.getElementById("BUTTONbtn_save").disabled=true;
	}catch(e){}
	try{
		document.getElementById("BUTTONbtn_draft").disabled=true;
	}catch(e){}
	try{
		document.getElementById("BUTTONbtn_preview").disabled=true;
	}catch(e){}
	try{
		document.getElementById("BUTTONmenuTypeChanger").disabled=true;
	}catch(e){}
	try{
		document.getElementById("WebOffice").DisableMenu("<%=SystemEnv.getHtmlLabelName(19718,user.getLanguage())%>(&S)");
	}catch(e){}
	try{
		document.getElementById("WebOffice").DisableMenu("<%=SystemEnv.getHtmlLabelName(19719,user.getLanguage())%>");
	}catch(e){}
	try{
		document.getElementById("WebOffice").DisableMenu("<%=SystemEnv.getHtmlLabelName(221,user.getLanguage())%>");
	}catch(e){}
	try{
		document.getElementById("WebOffice").DisableMenu("<%=SystemEnv.getHtmlLabelName(16386,user.getLanguage())%>");
	}catch(e){}
	try{
		parent.disableTabBtn();
	}catch(e){}
}

function btndisabledfalse(){
	try{
		document.getElementById("wfbtn_save").disabled=false;
	}catch(e){}
	try{
		document.getElementById("wfbtn_signature1").disabled=false;
	}catch(e){}
	try{
		document.getElementById("BUTTONbtn_save").disabled=false;
	}catch(e){}
	try{
		document.getElementById("BUTTONbtn_draft").disabled=false;
	}catch(e){}
	try{
		document.getElementById("BUTTONbtn_preview").disabled=false;
	}catch(e){}
	try{
		document.getElementById("BUTTONmenuTypeChanger").disabled=false;
	}catch(e){}
	try{
		document.getElementById("WebOffice").EnableMenu("<%=SystemEnv.getHtmlLabelName(19718,user.getLanguage())%>(&S)");
	}catch(e){}
	try{
		document.getElementById("WebOffice").EnableMenu("<%=SystemEnv.getHtmlLabelName(19719,user.getLanguage())%>");
	}catch(e){}
	try{
		document.getElementById("WebOffice").EnableMenu("<%=SystemEnv.getHtmlLabelName(221,user.getLanguage())%>");
	}catch(e){}
	try{
		document.getElementById("WebOffice").EnableMenu("<%=SystemEnv.getHtmlLabelName(16386,user.getLanguage())%>");
	}catch(e){}
	try{
		parent.enableTabBtn();
	}catch(e){}	
}

var stSign = 0x00000001;     //电子签章
var stHand = 0x00000002;     //手写签名
var stSign_360 = 0x00000000;  //360电子签章
var stHand_360 = 0x00000001;  //360手写签名
var  ssSucceeded = 0x0000;   //成功
var  ssDocumentLocked    = 0x0003;     //文档已经锁定

//作用：设置活动文档对象
function SetActiveDocument(){
			
	if(weaver.WebOffice.WebObject != null){
		//若为360签章
		if("2" == signatureType){
			if (weaver.WebOffice.FileType == ".doc") {
				weaver.SignatureAPI.SetActiveDocument(weaver.WebOffice.WebObject);   //设置WORD对象
			}
			if (weaver.WebOffice.FileType == ".xls") {
				weaver.SignatureAPI.SetActiveDocument(weaver.WebOffice.WebObject);   //设置EXCEL对象
			}
		}else{
			if (document.getElementById("WebOffice").FileType==".doc"){
				weaver.SignatureAPI.ActiveDocument=document.getElementById("WebOffice").WebObject;   //设置WORD对象
			}  
			if (document.getElementById("WebOffice").FileType==".xls"){
				weaver.SignatureAPI.ActiveDocument=document.getElementById("WebOffice").WebObject.Application.ActiveWorkbook.ActiveSheet;   //设置EXCEL对象
			}
		}
	}
}

//创建签章
function CreateSignature(id){
  <%if(isIWebOffice2006 == true){%>
	   if(document.getElementById("WebOffice").Pages >=1){
		  document.getElementById("WebOffice").ShowType="1";								 
	   }
  <%}%>
  
  //设置活动文档
  SetActiveDocument();   

    var revisionsCount=0;

    try{
	    revisionsCount=document.getElementById("WebOffice").WebObject.Revisions.Count;
    }catch(e){
    }
	
	//签章个数
    var signatureCount=0;
    try{
		try{
			weaver.SignatureAPI.InitSignatureItems();  //当签章数据发生变化时，请重新执行该方法
		}catch(e){}
		if("1" == signatureType){//WPS混合签章
		    signatureCount = weaver.SignatureAPI.iSignatureCount();
		}else if("2" == signatureType){//360签章
			signatureCount = weaver.SignatureAPI.AllSignatureCount;
		}else{
		    signatureCount=weaver.SignatureAPI.SignatureCount;
		}
    }catch(e){
    }
    if(revisionsCount>0&&signatureCount<=0){
		document.getElementById("WebOffice").WebSetMsgByName("NONEWVERSION","TRUE");
		document.getElementById("noSavePDF").value="TRUE";
<%
if(ifVersion.equals("1")){
%>
        SaveDocumentNewV();
<%
}else if("1".equals(isCompellentMark)){
%>
	    if(hasAcceptAllRevisions=="true"){
            SaveDocumentNewV();
            hasAcceptAllRevisions="false";
        }else{
			SaveDocument();
		}
<%
}else{
%>
        SaveDocument();
<%
}
%>
        document.getElementById("WebOffice").WebSetMsgByName("NONEWVERSION","FALSE");	
		if("1" == signatureType){//WPS混合签章
		    weaver.SignatureAPI.UnLockDocument();	//解保护
		}else{
			if(weaver.SignatureAPI.SelectionState==ssDocumentLocked) {
				weaver.SignatureAPI.UnLockDocument();	//解保护
			}
		}
        //接受痕迹
        document.getElementById("WebOffice").WebObject.AcceptAllRevisions(); 
        hasAcceptAllRevisions="true";
    }

    var t_EditType = document.getElementById("WebOffice").EditType;
	document.getElementById("WebOffice").EditType = "-1,0,0,0,0,0,1<%=canPostil%>";

    var t_TrackRevisions = false;
	try{
		t_TrackRevisions = document.getElementById("WebOffice").WebObject.TrackRevisions;
	    document.getElementById("WebOffice").WebObject.TrackRevisions = false;  //取消修订
	}catch(e){}
	
  //如果为电子签章
  if(id==0){
	   		//WPS混合签章
	   if("1" == signatureType){
			weaver.SignatureAPI.ActiveDocument=weaver.WebOffice.WebObject;
			try{
			  weaver.SignatureAPI.CreateSignature(stSign);	//建立电子签章			
			}catch(e){
				try{
					weaver.SignatureAPI.EndLoadSignature();          //释放调用资源             
					weaver.SignatureAPI.ReleaseActiveDocument();
				}catch(e){}		
			}
	
		}else if("2" == signatureType){//360签章
		   	try{
				weaver.SignatureAPI.SetSignatureParam("SealPosLock","true",1); 	//锁定签章不移动
				weaver.SignatureAPI.Action_Do(stSign_360);	//建立电子签章			
			}catch(e){
			}		
		} else{//Office签章
			if(weaver.SignatureAPI.SelectionState==ssSucceeded) {			
				try{
					weaver.SignatureAPI.CreateSignature(stSign);	//建立电子签章
				}catch(e){
					try{
						weaver.SignatureAPI.ActionAddinButton(stSign);	//建立电子签章
						weaver.SignatureAPI.ReleaseActiveDocument();
					}catch(e){}		
				}
			}else if(weaver.SignatureAPI.SelectionState==ssDocumentLocked) {
				 weaver.SignatureAPI.UnLockDocument();	//解保护
				try{
					weaver.SignatureAPI.CreateSignature(stSign);	//建立电子签章
				}catch(e){
					try{
						weaver.SignatureAPI.ActionAddinButton(stSign);	//建立电子签章
						weaver.SignatureAPI.ReleaseActiveDocument();
					}catch(e){}		
				}
			}
		}
    }
	//如果为手写签名
	if(id==1){
		if("2" == signatureType){
			try{
				weaver.SignatureAPI.Action_Do(stHand_360); 
			}catch(e){}
		}else{
			if(weaver.SignatureAPI.SelectionState==ssSucceeded){
				weaver.SignatureAPI.CreateSignature(stHand);  //建立手写签名
			}
		}
	}
	
	try{
		document.getElementById("WebOffice").WebObject.TrackRevisions = t_TrackRevisions;  
	}catch(e){}

	document.getElementById("WebOffice").EditType = t_EditType;
}

//签章确认
 function saveIsignatureFun(){
	btndisabledtrue();
	setTimeout("btndisabledfalse();",10000);

  <%if(isIWebOffice2006 == true){%>
	   if(document.getElementById("WebOffice").Pages >=1){
		  document.getElementById("WebOffice").ShowType="1";								 
	   }
  <%}%>


  if(window.confirm('<%=SystemEnv.getHtmlLabelName(21667,user.getLanguage())%>')){

	   try{
		   SetActiveDocument();   //设置活动文档
		   try{
			   weaver.SignatureAPI.InitSignatureItems();  //当签章数据发生变化时，请重新执行该方法
		   }catch(e){}
		   //签章个数
		   var newSignatureCount=0;
		   if("1" == signatureType){//WPS混合签章
				newSignatureCount = weaver.SignatureAPI.iSignatureCount();
		   }else if("2" == signatureType){//360签章
				newSignatureCount = weaver.SignatureAPI.AllSignatureCount;
		   }else{
				newSignatureCount = weaver.SignatureAPI.SignatureCount;
		   }
			if(newSignatureCount!=document.getElementById("signatureCount").value){
				//DocCheckInOutUtil.saveIsignatureFun(<%=requestid%>,<%=nodeid%>,<%=user.getUID()%>,<%=Util.getIntValue(user.getLogintype(),1)%>,newSignatureCount-document.getElementById("signatureCount").value,saveIsignatureFunReturn);
				document.getElementById("DocCheckInOutUtilIframe").src="/docs/docs/DocCheckInOutUtilIframe.jsp?operation=saveIsignatureFun&requestid=<%=requestid%>&nodeId=<%=nodeid%>&userId=<%=user.getUID()%>&loginType=<%=Util.getIntValue(user.getLogintype(),1)%>&signNum="+(newSignatureCount-document.getElementById("signatureCount").value);
				return ;
			}
	   }catch(e){

	   }

         document.getElementById("WebOffice").WebSetMsgByName("CLEARHANDWRITTEN","TRUE");//ClearHandwritten   清除手写批注

<%if (!ifVersion.equals("1")) {%> 
	     onSave(false); 
<%} else {%>
	     onSaveNewVersion(false);
<%}%>

  }
}
function saveIsignatureFunReturn(){
     document.getElementById("WebOffice").WebSetMsgByName("CLEARHANDWRITTEN","TRUE");//ClearHandwritten   清除手写批注

<%if (!ifVersion.equals("1")) {%> 
     onSave(); 
<%} else {%>
     onSaveNewVersion();
<%}%>
}
function onDelpic(imgid){
	if(!checkresult) return checkCanSubmit("onDelpic",imgid);
	
	document.weaver.operation.value='delpic';
	document.weaver.delimgid.value=imgid;
	document.weaver.submit();
}

    accessorynum = 2 ;
    function addannexRow()
    {
    ncol = rewardTable.cols;
    oRow = rewardTable.insertRow();
    for(j=0; j<ncol; j++) {
    oCell = oRow.insertCell();
    oCell.style.height=24;
    switch(j) {
    case 0:
    var oDiv = document.createElement("div");
    var sHtml = "<%=SystemEnv.getHtmlLabelName(156,user.getLanguage())%>";
    oDiv.innerHTML = sHtml;
    oCell.appendChild(oDiv);
    break;
    case 1:
    var oDiv = document.createElement("div");
    var sHtml = "<input type=file size=70 name='accessory"+accessorynum+"'>";
    oDiv.innerHTML = sHtml;
    oCell.appendChild(oDiv);
    break;

    }
    }
    accessorynum = accessorynum*1 +1;
    document.weaver.accessorynum.value = accessorynum ;
    }


function returnTrue(o){
	return;
}

function docCheckIn(docId) {
	//DocCheckInOutUtil.docCheckIn(docId,returnTrue);
	document.getElementById("DocCheckInOutUtilIframe").src="/docs/docs/DocCheckInOutUtilIframe.jsp?operation=docCheckIn&docId="+docId+"&userId=<%=user.getUID()%>&f_weaver_belongto_userid="+f_weaver_belongto_userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype;
}

function doImgAcc(){
	onExpandOrCollapse(true);
	onActiveTab("divAcc");
}
function docVersionWord(vid){
    url="/docs/docs/listVersion.jsp?canDel=true&versionId="+vid+"&docid=<%=docid%>";
    
	window.showModalDialog("/systeminfo/BrowserMain.jsp?url="+escape(url));
	
}

function onCleanCopy(){
	try{
	  <%if(isIWebOffice2006 == true){%>
		   if(document.getElementById("WebOffice").Pages >=1){
			  document.getElementById("WebOffice").ShowType="1";								 
		   }
	  <%}%>


		var revisionsCount=0;

		try{
			revisionsCount=document.getElementById("WebOffice").WebObject.Revisions.Count;
		}catch(e){
		}

		if(revisionsCount>0){
			document.getElementById("WebOffice").WebSetMsgByName("NONEWVERSION","TRUE");
			document.getElementById("noSavePDF").value="TRUE";        
			SaveDocumentNewV_all(0,false,false);

			document.getElementById("WebOffice").WebSetMsgByName("NONEWVERSION","FALSE");

			document.getElementById("WebOffice").WebObject.AcceptAllRevisions(); 
		}

	}catch(e){
	}
}
function checkCheckout(){

	var DocCheckInOut = false;
    jQuery.ajax({
        type: "POST",
        url: "/docs/docs/DocCheckInOutUtilIframe.jsp",
        data: {
            docid: <%=docid%>,
            userId: <%=user.getUID()%>,
            operation: 'checkDocCheckoutStatus'
        },
        cache: false,
        async:false,
        dataType: 'json',
	        success: function(retObj){
        	if(retObj.checkuserid == "" || retObj.checkuserid != '<%=user.getUID()%>'){
        		DocCheckInOut = false;
        	}else{
        		DocCheckInOut = true;
        	}
        }
    });
    if(!DocCheckInOut){
       top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(26090,user.getLanguage())%>");
    }
    return DocCheckInOut;
}
</script>
<SCRIPT language="javascript" src="/js/selectDateTime_wev8.js"></script>

<div id="_xTable" style="position:absolute; display:none; top:0px; left:0px; width:200px; height:28px;">
<div id="xTable_message" style="border:1px solid #8888AA;background:white;position:absolute;padding:5px;z-index:100;"></div>
<iframe src="javascript:false" style="position:absolute; visibility:inherit; top:0px; left:0px; width:200px; height:28px; z-index:-1; filter='progid:DXImageTransform.Microsoft.Alpha(style=0,opacity=0)';"></iframe>
</div>

<script language="vbs">

    function docVersionWord2(vid)
    url=escape("/docs/docs/listVersion.jsp?versionId="&vid&"&docid=<%=docid%>")
    id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url="&url)
	if (Not IsEmpty(id)) then
    if id(0)<> "" then
    window.location="DocEditExt.jsp?id=<%=docid%>&versionId="&id(0)&"&fromFlowDoc=<%=fromFlowDoc%>&requestid=<%=requestid%>&isFromAccessory=<%=isFromAccessory%>&isNoTurnWhenHasToPage=true&topage=<%=URLEncoder.encode(topageFromOther)%>"
    end if
    end if
    end function

    function docVersion(vid)

	url=escape("/docs/docs/listVersion.jsp?versionId="&vid&"&docid=<%=docid%>")
    id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url="&url)

    if (Not IsEmpty(id)) then
    if id(0)<> "" then
    docVersion=id(0)
    window.location="DocEditExt.jsp?id=<%=docid%>&versionId="&id(0)&"&isFromAccessory=true&imagefileId="&id(1)&"&fromFlowDoc=<%=fromFlowDoc%>&requestid=<%=requestid%>&topage=<%=URLEncoder.encode(topageFromOther)%>"

    end if
    end if
    end function
</script>
<!-- added by cyril on 20080610 for td8828-->
<script language=javascript src="/js/checkData_wev8.js"></script>
<!-- end by cyril on 20080610 for td8828-->