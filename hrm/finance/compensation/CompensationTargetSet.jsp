
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<%
boolean hasright=true;
if(!HrmUserVarify.checkUserRight("Compensation:Setting", user)){
    response.sendRedirect("/notice/noright.jsp");
    return;
}
int subcompanyid=Util.getIntValue(request.getParameter("subCompanyId"));
String subcompanyid_kwd = Util.null2String(request.getParameter("subcompanyid_kwd"));
if(subcompanyid_kwd.length()>0)subcompanyid=Util.getIntValue(subcompanyid_kwd);
String subcompanyname=SubCompanyComInfo.getSubCompanyname(""+subcompanyid);

//是否分权系统，如不是，则不显示框架，直接转向到列表页面
int detachable=Util.getIntValue((String)session.getAttribute("detachable"));
if(detachable==1){
    if(subcompanyid>0){
    int operatelevel= CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"Compensation:Setting",subcompanyid);
    if(operatelevel<1){
        hasright=false;
        if(operatelevel==-1){
            response.sendRedirect("/notice/noright.jsp");
            return;
        }
    }
    }else{
       hasright=false;
       //管理员开放全部权限
       if(user.getUID()==1)hasright=true;
    }
}

%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
<script language=javascript src="/js/ecology8/hrm/HrmSearchInit_wev8.js"></script>
<script type="text/javascript">
function onBtnSearchClick(){
	jQuery("#searchfrm").submit();
}

function doDel(id){
	if(!id){
		id = _xtable_CheckedCheckboxId();
	}
	if(!id){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(32568,user.getLanguage())%>");
		return;
	}
	if(id.match(/,$/)){
		id = id.substring(0,id.length-1);
	}
	window.top.Dialog.confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>",function(){
		var idArr = id.split(",");
		var ajaxNum = 0;
		for(var i=0;i<idArr.length;i++){
			ajaxNum++;
			jQuery.ajax({
				url:"CompensationTargetSetOperation.jsp?isdialog=1&option=delete&Targetid="+idArr[i],
				type:"post",
				async:true,
				complete:function(xhr,status){
					ajaxNum--;
					if(ajaxNum==0){
						_table.reLoad();
					}
				}
			});
		}
	});
}

var dialog = null;
function closeDialog(){
	if(dialog)
		dialog.close();
}

function openDialog(id){
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	if(id==null){
		id="";
	}
	var url = "/hrm/HrmDialogTab.jsp?_fromURL=CompensationTargetSetEdit&isdialog=1";
	if(!!id){
		dialog.Title = "<%=SystemEnv.getHtmlLabelName(26473,user.getLanguage())+SystemEnv.getHtmlLabelName(19454,user.getLanguage())%>";
		url = "/hrm/HrmDialogTab.jsp?_fromURL=CompensationTargetSetEdit&isdialog=1&id="+id;
	}else{
		dialog.Title = "<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())+SystemEnv.getHtmlLabelName(19454,user.getLanguage())%>";
	}
	url+="&subCompanyId=<%=subcompanyid%>";
	dialog.Width = 600;
	dialog.Height = 403;
	dialog.Drag = true;
	dialog.URL = url;
	dialog.show();
}

jQuery(document).ready(function(){
<%if(subcompanyname.length()>0){%>
 parent.setTabObjName('<%=subcompanyname%>')
 <%}%>
});
</script>
</head>
<%
String imagefilename = "/images/hdHRM_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(19427,user.getLanguage())+":"+subcompanyname;
String needfav ="1";
String needhelp ="";

String targetname = Util.null2String(request.getParameter("targetname"));

String qname = Util.null2String(request.getParameter("flowTitle"));
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(hasright){
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",javascript:openDialog();,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(32136,user.getLanguage())+",javascript:doDel();,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<form action="" name="searchfrm" id="searchfrm">
<input name="subCompanyId" type="hidden" value="<%=subcompanyid %>">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<%if(hasright){ %>
				<input type=button class="e8_btn_top" onclick="openDialog();" value="<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%>"></input>
				<input type=button class="e8_btn_top" onclick="doDel();" value="<%=SystemEnv.getHtmlLabelName(32136, user.getLanguage())%>"></input>
			<%} %>
			<input type="text" class="searchInput" name="flowTitle" value="<%=qname %>"/>
			<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage())%></span><span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<div class="advancedSearchDiv" id="advancedSearchDiv" style="display:none;" >
	<wea:layout type="4col">
		<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
			<wea:item><%=SystemEnv.getHtmlLabelName(33365,user.getLanguage())%></wea:item>
			<wea:item><input type="text" id="targetname" name="targetname" class="inputStyle" value='<%=targetname%>'></wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(19799,user.getLanguage())%></wea:item>
			<wea:item>
					<brow:browser viewType="0" name="subcompanyid_kwd" browserValue='<%=subcompanyid_kwd %>' 
	        browserUrl="/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/company/MutiSubCompanyByRightBrowser.jsp?rightStr=Compensation:Setting&selectedids="
	        hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
	        completeUrl="/data.jsp?type=164"
	        browserSpanValue='<%=SubCompanyComInfo.getSubcompanynames(subcompanyid_kwd) %>'>
	    </brow:browser>
			</wea:item>
		</wea:group>
		<wea:group context="">
			<wea:item type="toolbar">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(30947,user.getLanguage())%>" class="e8_btn_submit" onclick="onBtnSearchClick();"/>
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(31129,user.getLanguage())%>" class="e8_btn_cancel" id="cancel"/>
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
</form>
<%
String backfields = " id, TargetName, AreaType, subcompanyid, Explain, showorder "; 
String fromSql  = " from HRM_CompensationTargetSet ";
String sqlWhere = " where 1=1 ";
String orderby = " showorder asc " ;
String tableString = "";

if(Util.null2String(request.getParameter("subCompanyId")).length()==0 || subcompanyid==-1){
	//如果没有传入subcompanyid
	if(detachable==1){
		//分权情况，取有权限的分部
		int[] companyids = CheckSubCompanyRight.getSubComByUserRightId(user.getUID(),"Compensation:Setting");
		String comStr = "";
		for(int i=0;companyids!=null&&i<companyids.length;i++){
			if(comStr.length()>0)comStr+=",";
			comStr+=companyids[i];
		}
		
		sqlWhere = " where subCompanyId in ("+comStr+")";
	}else{
		//不分权情况，显示全部
		sqlWhere = " where 1=1 ";
	}
}else{
	sqlWhere = " where subCompanyId = "+subcompanyid;
}

if(!qname.equals("")){
	sqlWhere += " and TargetName like '%"+qname+"%'";
}		

if (!"".equals(targetname)) {
	sqlWhere += " and TargetName like '%"+targetname+"%'";
	}  	  	

if (!"".equals(subcompanyid_kwd)) {  
	sqlWhere += " and subCompanyId in ("+subcompanyid_kwd+")"; 	  	
}
//操作字符串
String  operateString= "";
String tabletype="checkbox";
if(hasright){
	operateString = "<operates width=\"20%\">";
	operateString+="     <operate href=\"javascript:openDialog();\" text=\""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"\" isalwaysshow='true' index=\"0\"/>";
	operateString+="     <operate href=\"javascript:doDel()\" text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\" isalwaysshow='true' index=\"1\"/>";
	//operateString+="     <operate href=\"javascript:onLog()\" text=\""+SystemEnv.getHtmlLabelName(83,user.getLanguage())+"\" isalwaysshow='true' index=\"2\"/>";
	operateString+="</operates>";	
	tabletype = "checkbox";
}
 
tableString =" <table pageId=\""+PageIdConst.HRM_CompensationTargetSet+"\" tabletype=\""+tabletype+"\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.HRM_CompensationTargetSet,user.getUID(),PageIdConst.HRM)+"\" >"+
		" <checkboxpopedom showmethod=\"weaver.hrm.HrmTransMethod.getCompensationTargetSetCheckbox\"  id=\"checkbox\"  popedompara=\"column:id\" />"+
		"	   <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"id\" sqlsortway=\"Asc\" sqlisdistinct=\"true\"/>"+
    operateString+
    "			<head>"+
    "				<col width=\"30%\" text=\""+SystemEnv.getHtmlLabelName(33365,user.getLanguage())+"\" column=\"TargetName\" orderkey=\"TargetName\"/>"+
    "				<col width=\"20%\" text=\""+SystemEnv.getHtmlLabelName(19799,user.getLanguage())+"\" column=\"subcompanyid\" orderkey=\"subcompanyid\" transmethod=\"weaver.hrm.company.SubCompanyComInfo.getSubCompanyname\" />"+
    "				<col width=\"20%\" text=\""+SystemEnv.getHtmlLabelName(19374,user.getLanguage())+"\" column=\"AreaType\" orderkey=\"AreaType\" transmethod=\"weaver.hrm.HrmTransMethod.getCompensationTargetAreatypename\" otherpara=\""+user.getLanguage()+"\"  />"+
    "				<col width=\"20%\" text=\""+SystemEnv.getHtmlLabelName(85,user.getLanguage())+"\" column=\"Explain\" orderkey=\"Explain\" />"+
    "				<col width=\"10%\" text=\""+SystemEnv.getHtmlLabelName(88,user.getLanguage())+"\" column=\"showorder\" orderkey=\"showorder\" />"+
    "			</head>"+
    " </table>";
%>
<input type="hidden" name="pageId" id="pageId" value="<%= PageIdConst.HRM_CompensationTargetSet %>"/>
<wea:SplitPageTag isShowTopInfo="false" tableString='<%=tableString%>' mode="run" /> 
</BODY>
</HTML>
