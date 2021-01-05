
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ page import="weaver.general.GCONST" %>
<%@ page import="weaver.general.IsGovProj" %>
<%@ page import="weaver.general.Util" %>

<%

%>
<jsp:useBean id="DocNewsManager" class="weaver.docs.news.DocNewsManager" scope="page" />
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />
<jsp:useBean id="PicUploadComInfo" class="weaver.docs.tools.PicUploadComInfo" scope="page" />
<jsp:useBean id="LanguageComInfo" class="weaver.systeminfo.language.LanguageComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="CustomerTypeComInfo" class="weaver.crm.Maint.CustomerTypeComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script type='text/javascript' src='/dwr/interface/DocDwrUtil.js'></script>
<script type='text/javascript' src='/dwr/engine.js'></script>
<script type='text/javascript' src='/dwr/util.js'></script>
<script language=javascript src="/js/ecology8/docs/docSearchInit_wev8.js"></script>
<script language=javascript src="/js/ecology8/docs/docExt_wev8.js"></script>
<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
<script type="text/javascript">
var parentWin = parent.parent.getParentWindow(parent);
var parentDialog = parent.parent.getDialog(parent);
function onPreview(id){
	parentWin.onPreview(id);
}
</script>
</head>
<%
if(!HrmUserVarify.checkUserRight("DocFrontpageEdit:Edit", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
int isgoveproj = Util.getIntValue(IsGovProj.getPath(),0);//0:非政务系统，1：政务系统
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(68,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(70,user.getLanguage());
String needfav ="1";
String needhelp ="";
String isclose = Util.null2String(request.getParameter("isclose"));
String isDialog = Util.null2String(request.getParameter("isdialog"));
int id = Util.getIntValue(request.getParameter("id"),0);
String operation = Util.null2String(request.getParameter("operation"));
%>
<BODY onbeforeunload="checkLeave()">
<%if("1".equals(isDialog)){ %>
<div class="zDialog_div_content">
<%} %>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<div>
<form action="" name="frmmain" id="frmmain">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" id="zd_btn_submit_0" class="e8_btn_top" onclick="onSave();">
			<%if(!operation.equals("add")){%>
				<input type="button" name="zd_btn_submit" onclick="parentWin.onPreview(<%=id %>);" class="e8_btn_top" value="<%= SystemEnv.getHtmlLabelName(221,user.getLanguage())%>"/>
			<%} %>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>					
		</td>
	</tr>
</table>
</form>

<%

DocNewsManager.setId(id);
DocNewsManager.getDocNewsInfoById();
/**
//如果新闻设置表其他人在修改，直接跳转到查看页面，否则将将新闻设置表状态改为签出状态
if(DocNewsManager.getCheckOutStatus()==1 && DocNewsManager.getCheckOutUserId()!=user.getUID()){
	String checkOutUserName="";
	checkOutUserName=ResourceComInfo.getResourcename(""+DocNewsManager.getCheckOutUserId());
	String checkOutMessage=SystemEnv.getHtmlLabelName(19695,user.getLanguage())+SystemEnv.getHtmlLabelName(19690,user.getLanguage())+"："+checkOutUserName;
	checkOutMessage=URLEncoder.encode(checkOutMessage);
	response.sendRedirect("NewsDsp.jsp?id="+id+"&checkOutMessage="+checkOutMessage);
    return ;
}else{
	RecordSet.executeSql("update DocFrontpage set checkOutStatus=1,checkOutUserId="+user.getUID()+" where id="+id);
}
**/
	RecordSet.executeSql("update DocFrontpage set checkOutStatus=1,checkOutUserId="+user.getUID()+" where id="+id);
String frontpagename = DocNewsManager.getFrontpagename();
String frontpagedesc = DocNewsManager.getFrontpagedesc();
String isactive = DocNewsManager.getIsactive();
int departmentid = DocNewsManager.getDepartmentid();
String linktype = DocNewsManager.getLinktype();
String hasdocsubject = DocNewsManager.getHasdocsubject();
String hasfrontpagelist = DocNewsManager.getHasfrontpagelist();
int newsperpage = DocNewsManager.getNewsperpage();
int titlesperpage = DocNewsManager.getTitlesperpage();
int defnewspicid = DocNewsManager.getDefnewspicid();
int backgroundpicid = DocNewsManager.getBackgroundpicid();
String importdocid = DocNewsManager.getImportdocid();
int headerdocid = DocNewsManager.getHeaderdocid();
int footerdocid = DocNewsManager.getFooterdocid();
String secopt = DocNewsManager.getSecopt();
int seclevelopt = DocNewsManager.getSeclevelopt();
int departmentopt = DocNewsManager.getDepartmentopt();
int dateopt = DocNewsManager.getDateopt();
int languageopt = DocNewsManager.getLanguageopt();
String clauseopt = Util.toScreenToEdit(DocNewsManager.getClauseopt(),user.getLanguage());
String newsclause = DocNewsManager.getNewsclause();
int languageid =DocNewsManager.getLanguageid();
int publishtype =DocNewsManager.getPublishtype();


int newstypeid =DocNewsManager.getNewstypeid();
int typeordernum =DocNewsManager.getTypeordernum();
int subcompanyid = DocNewsManager.getSubcompanyid();
int operatelevel=0;
int detachable = Util.getIntValue(String.valueOf(session.getAttribute("docdetachable")),0);
if(detachable==1){
	operatelevel= CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"DocFrontpageEdit:Edit",subcompanyid);
}else{
    if(HrmUserVarify.checkUserRight("DocFrontpageEdit:Edit", user))
        operatelevel=2;
}

DocNewsManager.closeStatement();

    //判断此新闻是否被外部网站所引用
    boolean isRefByWeb = false;
    RecordSet.executeSql("select count(*) from website where newsid ="+id);
    if(RecordSet.next()){
        if(RecordSet.getInt(1)>0){
            isRefByWeb = true;
        }
    }
%>
<script type="text/javascript">
	try{
		parent.setTabObjName("<%= frontpagename %>");
	}catch(e){}
</script>
<FORM id=weaver name=weaver action="NewsOperation.jsp" method=post>
<input type="hidden" name="isdialog" value="<%=isDialog%>">
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%if(!isDialog.equals("1")){ %>
<%
if(HrmUserVarify.checkUserRight("DocFrontpageEdit:Edit", user)){
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%
}if(HrmUserVarify.checkUserRight("DocFrontpageAdd:add", user)){
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",javascript:location='DocNewsAdd.jsp',_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/docs/news/DocNews.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%
}if(HrmUserVarify.checkUserRight("DocFrontpageEdit:Delete", user)&&!isRefByWeb){    //如果被外部网站引用也不能被删除
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%
}if(HrmUserVarify.checkUserRight("DocFrontpage:log", user)){
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",javascript:location='/systeminfo/SysMaintenanceLog.jsp?secid=65&sqlwhere="+xssUtil.put("where operateitem=6 and relatedid="+id)+"',_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%
}
%>
<%}else{
	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;
	if(!operation.equals("add")){
		RCMenu += "{"+SystemEnv.getHtmlLabelName(221,user.getLanguage())+",javascript:onPreview("+id+"),_top} " ;
		RCMenuHeight += RCMenuHeightStep ;
	}
} %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
	<wea:layout attributes="{'layoutTableId':'baseInfo','layoutTableDisplay':'none'}">
		<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
			<wea:item><%=SystemEnv.getHtmlLabelName(70,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></wea:item>
			<wea:item>
				<wea:required id="frontpagespan" required="true" value='<%=frontpagename%>'>
					<INPUT class=InputStyle  value="<%=frontpagename%>" id="frontpagename" name=frontpagename onChange="checkinput('frontpagename','frontpagespan')" >
				</wea:required>
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(19789,user.getLanguage())%></wea:item>
			<wea:item>
				<select class=InputStyle  name=newstypeid>
					<%
						rs.executeSql("select id,typename from newstype order by dspnum");
						while(rs.next()){
							String  strSelected="";
							if(newstypeid==rs.getInt("id")) strSelected="selected";
					%>	
						<option value="<%=rs.getString("id")%>"  <%=strSelected%>><%=rs.getString("typename")%></option>
					<%}%>
				 </select>
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(1993,user.getLanguage())%></wea:item>
			<wea:item>
				<select class=InputStyle  name=publishtype size=1>
					<option value="1" <%if(publishtype==1){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(1994,user.getLanguage())%></option>
					<option value="0" <%if(publishtype==0){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(1995,user.getLanguage())%></option>
					<%if(isgoveproj==0){%>
						<%if(isPortalOK){%><!--portal begin-->
							   <%while(CustomerTypeComInfo.next()){
									String curid=CustomerTypeComInfo.getCustomerTypeid();
									String curname=CustomerTypeComInfo.getCustomerTypename();
									String value="-"+curid;
							   %>
									<option value="<%=value%>" <%if(publishtype==Util.getIntValue(value,0)){%> selected <%}%>><%=Util.toScreen(curname,user.getLanguage())%></option>
							   <%
							   }%>
						<%}%><!--portal end-->
					<%}%>
				</select>
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(155,user.getLanguage())%></wea:item>
			<wea:item>
				<%
				  String ischecked = "";
				  if(isactive.equals("1"))
					ischecked = " checked";
				  %>
				  <INPUT class=InputStyle name=isactive value=1 type=checkbox <%=ischecked%>></TD>
			</wea:item>
			
			<wea:item><%=SystemEnv.getHtmlLabelName(15513,user.getLanguage())%></wea:item>
			<wea:item><INPUT class=InputStyle style="width:30px;" maxLength=3 size=3 value='<%=typeordernum %>' name=typeordernum></wea:item>
			<%if(detachable==1){ %>
				<wea:item><%= SystemEnv.getHtmlLabelName(17868,user.getLanguage())%></wea:item>
				<wea:item>
					<span>
						<brow:browser viewType="0" name="subcompanyid" browserValue='<%= ""+subcompanyid %>' 
								browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp"
								hasInput='<%=operatelevel>0?"true":"false" %>' isSingle="true" hasBrowser = "true" isMustInput='<%=operatelevel>0?"2":"0" %>'
								completeUrl="/data.jsp?type=164" temptitle='<%= SystemEnv.getHtmlLabelName(17868,user.getLanguage())%>' language='<%=""+user.getLanguage() %>'
								browserSpanValue='<%=subcompanyid!=0?Util.toScreen(SubCompanyComInfo.getSubCompanyname(subcompanyid+""),user.getLanguage()):""%>'>
						</brow:browser>
					</span>
				</wea:item>
			<%}%>
		</wea:group>
	</wea:layout>
	<wea:layout  needImportDefaultJsAndCss="false" attributes="{'layoutTableId':'contentInfo','layoutTableDisplay':'none'}">
		<wea:group context='<%=SystemEnv.getHtmlLabelName(33437,user.getLanguage())%>'>
			<wea:item><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></wea:item>
			<wea:item>
				<span>
					   <brow:browser viewType="0" name="continuedepart" browserValue='<%=""+departmentopt%>' 
						browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp"
						hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
						completeUrl="/data.jsp?type=4" linkUrl="#" temptitle='<%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%>'  language='<%=""+user.getLanguage() %>'
						browserSpanValue='<%= Util.toScreen(DepartmentComInfo.getDepartmentname(departmentopt+""),user.getLanguage())%>'></brow:browser>
				</span>			
			</wea:item>
			<%if(isMultilanguageOK){   //  多语言版本， 在 init.jsp 中获得判断 %>
			<wea:item><%=SystemEnv.getHtmlLabelName(231,user.getLanguage())%></wea:item>
			<wea:item>
				 <span>
					   <brow:browser viewType="0" name="continuelanguagenameid" browserValue='<%=""+languageopt%>' 
						browserUrl="/systeminfo/BrowserMain.jsp?url=/systeminfo/language/LanguageBrowser.jsp"
						 temptitle='<%=SystemEnv.getHtmlLabelName(231,user.getLanguage())%>'  language='<%=""+user.getLanguage() %>'
						hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
						completeUrl="/data.jsp?type=-99998" linkUrl="#" 
						browserSpanValue='<%= LanguageComInfo.getLanguagename(""+languageopt)%>'></brow:browser>
				</span>		
			</wea:item>
			<%}%>
			<wea:item><%=SystemEnv.getHtmlLabelName(328,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(277,user.getLanguage())%></wea:item>
			<wea:item>
				<input class=InputStyle style="width:50px;" maxlength=2 size=10 name=continuetime value="<%=dateopt%>">
				<span><%=SystemEnv.getHtmlLabelName(329,user.getLanguage())%></span>
				<span class="e8tips" title="<%=SystemEnv.getHtmlLabelName(33438,user.getLanguage()) %>"><img src="/images/tooltip_wev8.png" align="absMiddle"/></span>
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(15610,user.getLanguage())%></wea:item>
			<wea:item><TEXTAREA name=condition class=InputStyle rows=3><%=clauseopt%></TEXTAREA>
				<span class="e8tips" title="<%=SystemEnv.getHtmlLabelName(18541,user.getLanguage())+":seccategory=69 and doccreaterid=1" %>"><img src="/images/tooltip_wev8.png" align="absMiddle"/></span>
			</wea:item>
		</wea:group>
		<wea:group context='<%=SystemEnv.getHtmlLabelNames("459,58",user.getLanguage())%>'>
			<wea:item><%=SystemEnv.getHtmlLabelName(224,user.getLanguage())%></wea:item>
			<wea:item>
				<span>
					   <brow:browser viewType="0" name="headerdocid" browserValue='<%=""+headerdocid%>' 
						browserUrl="/systeminfo/BrowserMain.jsp?mouldID=doc&url=/docs/docs/DocBrowser.jsp?initwhere=doctype<>2"
						hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
						completeUrl="/data.jsp?type=9" linkUrl="/docs/docs/DocDsp.jsp?id="
						 temptitle='<%=SystemEnv.getHtmlLabelName(224,user.getLanguage())%>'  language='<%=""+user.getLanguage() %>'
						browserSpanValue='<%= DocComInfo.getDocname(""+headerdocid)%>'></brow:browser>
				</span>		
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(322,user.getLanguage())%></wea:item>
			<wea:item>
				<%
				   String importdocidtext="";
				   String[] tempdocids = Util.TokenizerString2(importdocid,",");
				   for(int i=0;i<tempdocids.length;i++) {
						if(importdocidtext.equals("")){
							importdocidtext ="<a href='/docs/docs/DocDsp.jsp?id="+tempdocids[i]+"'>"+DocComInfo.getDocname(tempdocids[i])+"</a>";
						}else{
							importdocidtext +=",<a href='/docs/docs/DocDsp.jsp?id="+tempdocids[i]+"'>"+DocComInfo.getDocname(tempdocids[i])+"</a>";
					   }     
				  }
				  String url = "/systeminfo/BrowserMain.jsp?mouldID=doc&url=/docs/docs/MutiDocBrowser.jsp?documentids="+importdocid;
				  %>
				  
				 <span>
					   <brow:browser viewType="0" name="importdocid" browserValue='<%=""+importdocid%>' 
						browserUrl='<%=url %>'
						 temptitle='<%=SystemEnv.getHtmlLabelName(322,user.getLanguage())%>'  language='<%=""+user.getLanguage() %>'
						hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='1'
						completeUrl="/data.jsp?type=9" linkUrl="/docs/docs/DocDsp.jsp?id="
						browserSpanValue='<%= importdocidtext%>'></brow:browser>
				</span>	
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(323,user.getLanguage())%></wea:item>
			<wea:item>
				<span>
					   <brow:browser viewType="0" name="footerdocid" browserValue='<%=""+footerdocid%>' 
						browserUrl="/systeminfo/BrowserMain.jsp?mouldID=doc&url=/docs/docs/DocBrowser.jsp?initwhere=doctype<>2"
						hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
						 temptitle='<%=SystemEnv.getHtmlLabelName(323,user.getLanguage())%>'  language='<%=""+user.getLanguage() %>'
						completeUrl="/data.jsp?type=9" linkUrl="/docs/docs/DocDsp.jsp?id="
						browserSpanValue='<%= DocComInfo.getDocname(""+footerdocid)%>'></brow:browser>
				</span>		
			</wea:item>
		</wea:group>
	</wea:layout>
	<wea:layout  needImportDefaultJsAndCss="false" attributes="{'layoutTableId':'showInfo','layoutTableDisplay':'none'}">
		<wea:group context='<%=SystemEnv.getHtmlLabelNames("31835,30747",user.getLanguage()) %>'>
			<wea:item><%=SystemEnv.getHtmlLabelNames("31835,70,33439",user.getLanguage())%></wea:item>
			<wea:item>
				<%
				  String ischecked = "";
				  if(hasdocsubject.equals("1"))
					ischecked = " checked";
				  %>
				 <INPUT class=InputStyle name=hasdocsubject value=1 type=checkbox <%=ischecked%>>
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelNames("227,316,17491",user.getLanguage())%></wea:item>
			<wea:item><INPUT class=InputStyle style="width:30px;" maxLength=2 size=13 id="newsperpage" name=newsperpage value='<%=newsperpage%>'></wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelNames("24986,316,17491",user.getLanguage())%></wea:item>
			<wea:item><INPUT class=InputStyle style="width:30px;" maxLength=2 size=13 id="titlesperpage" name=titlesperpage value='<%=titlesperpage%>'></wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelNames("227,31238",user.getLanguage())%></wea:item>
			<wea:item>
				<span>
					   <brow:browser viewType="0" name="defnewspicid" browserDialogWidth="800" browserValue='<%=""+defnewspicid%>' 
						browserUrl="/systeminfo/BrowserMain.jsp?mouldID=doc&url=/docs/tools/DocPicBrowser.jsp?pictype=1"
						 temptitle='<%=SystemEnv.getHtmlLabelName(74,user.getLanguage())%>'  language='<%=""+user.getLanguage() %>'
						hasInput="false" isSingle="true" hasBrowser = "true" isMustInput='1'
						completeUrl="/data.jsp?type=9" linkUrl="/docs/tools/DocPicUploadEdit.jsp?id="
						browserSpanValue='<%= PicUploadComInfo.getPicname(""+defnewspicid)%>'></brow:browser>
				</span>		
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelNames("70,33440",user.getLanguage())%></wea:item>
			<wea:item>
				<span>
					   <brow:browser viewType="0" name="backgroundpicid" browserDialogWidth="800" browserValue='<%=""+backgroundpicid%>' 
						browserUrl="/systeminfo/BrowserMain.jsp?mouldID=doc&url=/docs/tools/DocPicBrowser.jsp?pictype=3"
						 temptitle='<%=SystemEnv.getHtmlLabelName(334,user.getLanguage())%>'  language='<%=""+user.getLanguage() %>'
						hasInput="false" isSingle="true" hasBrowser = "true" isMustInput='1'
						completeUrl="/data.jsp?type=9" linkUrl="/docs/tools/DocPicUploadEdit.jsp?id="
						browserSpanValue='<%= PicUploadComInfo.getPicname(""+backgroundpicid)%>'></brow:browser>
				</span>	
			</wea:item>
		</wea:group>
	</wea:layout>
 
<input type=hidden name=operation>
<input type=hidden name=id value="<%=id%>">
<input type=hidden name=frontpagename value="<%=frontpagename%>">
</FORM>
</div>
<script>

jQuery(document).ready(function(){
	try{
		var dialog = parent.parent.getDialog(parent);
		dialog.getPageData("initData",0);
	}catch(e){}
	jQuery(".e8tips").wTooltip({html:true});
	try{
		var id = jQuery("li.current",parent.document).find("a").attr("id");
		if(id){
			jQuery("#"+id.replace(/Tab/g,"")).show();
		}
		var _document = document;
		parent.registerClickEvent(null,_document);
	}catch(e){
		jQuery("#baseInfo").show();
	}
});

var isCheckLeave = true;
function onSave(){
	DocDwrUtil.ifNewsCheckOutByCurrentUser(<%=id%>,<%=user.getUID()%>,
		{callback:function(result){
			if(result){

	var languageid=<%=user.getLanguage()%>;
	if(check_form(document.weaver,'frontpagename')){
    if(document.getElementById("newsperpage").value != "" && document.getElementById("newsperpage").value*1<=0){
	    	top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(23259,user.getLanguage())%>");
        return;
    }else if(document.getElementById("titlesperpage").value != "" && document.getElementById("titlesperpage").value*1<=0){
	    	top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(23260,user.getLanguage())%>");
        return;
    }
    <%if(detachable==1){ %>
   		if(!check_form(weaver,'subcompanyid')){
   			return;
   		}
   	<%}%>
    <%if(operation.equals("add")){%>
    	document.weaver.operation.value="add";
    <%}else{%>
		document.weaver.operation.value="edit";
	<%}%>
	document.weaver.submit();}
	
			}else{
				alert("<%=SystemEnv.getHtmlLabelName(26097,user.getLanguage())%>");
				return;
			}
		}
		}
	)
}

function onDelete(){
	if(confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>")) {
		document.weaver.operation.value="delete";
		document.weaver.submit();
	}
}

function onCheckIn(id){
		isCheckLeave = false;
		DocDwrUtil.checkInNewsDsp(id,
			{callback:function(result){
				if(result){
					window.location.href="/docs/news/NewsDsp.jsp?id="+id;
				}
			}
			}
		)
}

function checkLeave(){
	if(isCheckLeave){
		DocDwrUtil.checkInNewsDsp(<%=id%>,
			{callback:function(result){
			}
			}
		)
	}
}

function onBtnSearchClick(){
	jQuery("#frmmain").submit();
}

</script>
<%if("1".equals(isDialog)){ %>
	</div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout needImportDefaultJsAndCss="false">
			<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
				<wea:item type="toolbar">
					<%--<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" id="zd_btn_submit_0" class="zd_btn_submit" onclick="onSave;">
						<%if(!operation.equals("add")){%>
							<span class="e8_sep_line">|</span>
							<input type="button" name="zd_btn_submit" onclick="parentWin.onPreview(<%=id %>);" class="zd_btn_submit" value="<%= SystemEnv.getHtmlLabelName(221,user.getLanguage())%>"/>
						<%} %>					
					<span class="e8_sep_line">|</span>--%>
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="parentDialog.closeByHand();">
				</wea:item>
			</wea:group>
		</wea:layout>
</div>
	<script type="text/javascript">
		jQuery(document).ready(function(){
			resizeDialog(document);
		});
	</script>
<%} %>
</BODY></HTML>
