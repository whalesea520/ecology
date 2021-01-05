<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<html>
<head>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
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
				url:"/hrm/contract/contracttype/HrmConTypeOperation.jsp?isdialog=1&operation=delete&id="+idArr[i],
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


function openDetail(url){
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(15786,user.getLanguage())%>";
	dialog.Width = jQuery(window).width();
	dialog.Height = jQuery(window).height();
	dialog.Drag = true;
	dialog.maxiumnable = true;
	dialog.URL = url;
	dialog.show();
}

function onLog(id){
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	var url = "";
	if(id && id!=""){
		url = "/docs/tabs/DocCommonTab.jsp?_fromURL=3&isdialog=1&secid=65&sqlwhere=<%=xssUtil.put("where operateitem=81 and relatedid=")%>&relatedid="+id;
	}else{
		url = "/docs/tabs/DocCommonTab.jsp?_fromURL=3&isdialog=1&secid=65&sqlwhere=<%=xssUtil.put("where operateitem=81")%>";
	}
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(32061,user.getLanguage())%>";
	dialog.Width = jQuery(window).width();
	dialog.Height = jQuery(window).height();
	dialog.Drag = true;
	dialog.maxiumnable = true;
	dialog.URL = url;
	dialog.show();
}
</script>
</head>
<body>
<%
String qname = Util.null2String(request.getParameter("flowTitle"));
String typename = Util.null2String(request.getParameter("typename"));

int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(179,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(614,user.getLanguage())+SystemEnv.getHtmlLabelName(716,user.getLanguage());
String needfav ="1";
String needhelp ="";
int subcompanyid=-1;
int operatelevel = 0;
if(detachable==1){
        subcompanyid=Util.getIntValue(request.getParameter("subcompanyid1"),-1);
    	operatelevel=CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"HrmContractTypeAdd:Add",subcompanyid);
}else{
	if(HrmUserVarify.checkUserRight("HrmContractTypeAdd:Add", user) || HrmUserVarify.checkUserRight("HrmContractType:Log", user))
		operatelevel=2;
}
if(false && subcompanyid==-1 && detachable==1){
  %>
  <script type="text/javascript">
  window.parent.location.href="HrmContractTypeHelp.jsp";
  </script>
  <%
  return;
}
%>

<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
	if(HrmUserVarify.checkUserRight("HrmContractTypeAdd:Add", user)){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",javascript:openDialog();,_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(32136,user.getLanguage())+",javascript:doDel();,_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	}
if(HrmUserVarify.checkUserRight("HrmContractType:Log", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",javascript:onLog(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<form id="searchfrm" name="searchfrm" action="HrmContractType.jsp" method="post">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<%if(HrmUserVarify.checkUserRight("HrmContractTypeAdd:Add", user)){ %>
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
		<wea:group context='<%=SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>'>
			<wea:item><%=SystemEnv.getHtmlLabelName(15520,user.getLanguage())%></wea:item>
			<wea:item><input type="text" id="typename" name="typename" class="inputStyle" value='<%=typename%>'></wea:item>
			<wea:item>&nbsp;</wea:item>
			<wea:item>&nbsp;</wea:item>
		</wea:group>
		<wea:group context="">
			<wea:item type="toolbar">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>" class="e8_btn_submit" onclick="onBtnSearchClick()"/>
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(2022,user.getLanguage())%>" class="e8_btn_cancel" onclick="resetCondtion();"/>
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(31129,user.getLanguage())%>" class="e8_btn_cancel" id="cancel"/>
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
<%
String backfields = " type.id, type.subcompanyid,type.typename,type.saveurl,type.contracttempletid, " 
									+ " type.ishirecontract,type.remindaheaddate,template.templetname,template.templetdocid "; 
String fromSql  = " from HrmContractType type left join HrmContractTemplet template on type.contracttempletid = template.ID ";
String sqlWhere = " where 1=1 ";
String orderby = " type.id " ;
String tableString = "";

if(Util.null2String(request.getParameter("subcompanyid")).length()==0){
	//如果没有传入subcompanyid
	if(detachable==1){
		//分权情况，取有权限的分部
		int[] companyids = CheckSubCompanyRight.getSubComByUserRightId(user.getUID(),"HrmContractTypeAdd:Add");
		String comStr = "";
		for(int i=0;companyids!=null&&i<companyids.length;i++){
			if(comStr.length()>0)comStr+=",";
			comStr+=companyids[i];
		}
		
		sqlWhere = " where type.subcompanyid in ("+comStr+")";
	}else{
		//不分权情况，显示全部
		sqlWhere = " where 1=1 ";
	}
}

if(!qname.equals("")){
	sqlWhere += " and type.typename like '%"+qname+"%'";
}
if(typename.length() > 0){
	sqlWhere += " and type.typename like '%"+typename+"%'";
}

if(subcompanyid!=-1){
	sqlWhere += " and type.subcompanyid = "+subcompanyid;
}
//操作字符串
String  operateString= "";
operateString = "<operates width=\"20%\">";
 	       operateString+=" <popedom transmethod=\"weaver.hrm.HrmTransMethod.getHrmContractTypeOperate\" otherpara=\""+HrmUserVarify.checkUserRight("HrmContractTypeEdit:Edit", user)+"\" otherpara2=\""+HrmUserVarify.checkUserRight("HrmContractTypeDelete:Delete", user)+":"+HrmUserVarify.checkUserRight("HrmContractType:Log", user)+":"+HrmUserVarify.checkUserRight("HrmContractTypeAdd:Add", user)+"\"></popedom> ";
 	       operateString+="     <operate href=\"javascript:openDialog();\" text=\""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"\" index=\"0\"/>";
 	       operateString+="     <operate href=\"javascript:doDel()\" text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\" index=\"1\"/>";
 	       operateString+="     <operate href=\"javascript:onLog()\" text=\""+SystemEnv.getHtmlLabelName(83,user.getLanguage())+"\" index=\"2\"/>";
 	       operateString+="</operates>";	
 String tabletype="checkbox";
 if(HrmUserVarify.checkUserRight("HrmContractTypeDelete:Delete", user)){
 	tabletype = "checkbox";
 }
 
tableString =" <table pageId=\""+PageIdConst.HRM_ContractType+"\" tabletype=\""+tabletype+"\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.HRM_ContractType,user.getUID(),PageIdConst.HRM)+"\" >"+
		" <checkboxpopedom showmethod=\"weaver.hrm.HrmTransMethod.getHrmContractTypeCheckbox\"  id=\"checkbox\"  popedompara=\"column:type.id\" />"+
		"	   <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\" sqlprimarykey=\"type.id\" sqlsortway=\"Asc\" sqlisdistinct=\"true\"/>"+
    operateString+
    "			<head>"+
    "				<col width=\""+(detachable == 1?"20":"25")+"%\" text=\""+SystemEnv.getHtmlLabelName(15520,user.getLanguage())+"\" column=\"typename\" orderkey=\"typename\" />";
	if(detachable == 1){
		tableString +="	<col width=\"20%\" text=\""+SystemEnv.getHtmlLabelName(17868,user.getLanguage())+"\" column=\"subcompanyid\" orderkey=\"subcompanyid\" transmethod=\"weaver.hrm.company.SubCompanyComInfo.getSubCompanyname\" />";
	}
    tableString +="	<col width=\""+(detachable == 1?"25":"30")+"%\" text=\""+SystemEnv.getHtmlLabelName(15786,user.getLanguage())+"\" column=\"templetdocid\" orderkey=\"templetdocid\" transmethod=\"weaver.hrm.HrmTransMethod.getHrmContractTypeTempletname\" otherpara=\"column:subcompanyid+column:templetname\"/>"+
	"				<col width=\""+(detachable == 1?"15":"20")+"%\" text=\""+SystemEnv.getHtmlLabelName(15791,user.getLanguage())+"\" column=\"ishirecontract\" orderkey=\"ishirecontract\" transmethod=\"weaver.hrm.common.SplitPageTagFormat.colFormat\" otherpara=\"{cmd:array["+user.getLanguage()+";default=161,1=163]}\"/>"+
    "				<col width=\""+(detachable == 1?"15":"20")+"%\" text=\""+SystemEnv.getHtmlLabelNames("20920,15792",user.getLanguage())+"\" column=\"remindaheaddate\" orderkey=\"remindaheaddate\" />"+
    "			</head>"+
    " </table>";
%>
<input type="hidden" name="pageId" id="pageId" value="<%= PageIdConst.HRM_ContractType %>"/>
<wea:SplitPageTag isShowTopInfo="false" tableString='<%=tableString%>' mode="run" /> 
</form>
<script type="text/javascript">
function openDialog(id){
	if(dialog==null){
		dialog = new window.top.Dialog();
	}
	dialog.currentWindow = window;
	if(id==null){
		id="";
	}
	var url = "/hrm/HrmDialogTab.jsp?_fromURL=HrmContractTypeAdd&subcompanyid=<%=subcompanyid%>";
	if(!!id){
		dialog.Title = "<%=SystemEnv.getHtmlLabelName(26473,user.getLanguage())+SystemEnv.getHtmlLabelName(6158,user.getLanguage())%>";
		url = "/hrm/HrmDialogTab.jsp?_fromURL=HrmContractTypeEditDo&id="+id+"&subcompanyid=<%=subcompanyid%>";
	}else{
		dialog.Title = "<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())+SystemEnv.getHtmlLabelName(6158,user.getLanguage())%>";
	}
	dialog.Width = 700;
	dialog.Height = 450;
	dialog.maxiumnable = true;
	dialog.Drag = true;
	dialog.URL = url;
	dialog.show();
}
</script>
</body>
</html>
