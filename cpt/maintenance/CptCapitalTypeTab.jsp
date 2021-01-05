<%@page import="weaver.proj.util.PropUtil"%>
<%@page import="org.json.JSONObject"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%
    String nameQuery1 = Util.null2String(request.getParameter("flowTitle"));

    String nameQuery = Util.null2String(request.getParameter("nameQuery"));
    String typedesc = Util.null2String(request.getParameter("typedesc"));
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<SCRIPT language="javascript" src="/cpt/js/common_wev8.js"></script>

</HEAD>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(320,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(703,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<body style="overflow:hidden;">
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%
boolean canAdd=HrmUserVarify.checkUserRight("CptCapitalTypeAdd:Add", user);
boolean canDel=HrmUserVarify.checkUserRight("CptCapitalTypeEdit:Delete", user);
boolean canEdit=HrmUserVarify.checkUserRight("CptCapitalTypeEdit:Edit", user);

if(canAdd){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",javascript:addSub(),_self}" ;
	RCMenuHeight += RCMenuHeightStep ;
}
if(canDel){
	RCMenu += "{"+SystemEnv.getHtmlLabelNames("32136",user.getLanguage())+",javascript:batchDel(),_self}" ;
	RCMenuHeight += RCMenuHeightStep ;
}
String pageId=Util.null2String(PropUtil.getPageId("cpt_cptcapitaltypetab"));
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<TABLE class=Shadow>
<tr>
<td valign="top">
<form name="frmSearch" id="frmSearch" method="post" >
<input type="hidden" name="pageId" id="pageId" value="<%=pageId  %>" />
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
		<%
		if(canAdd){
			%>
			<input type="button" value="<%=SystemEnv.getHtmlLabelNames("82",user.getLanguage())%>" class="e8_btn_top"  onclick="addSub()"/>
			<%
		}
		%>
		<%
		if(canDel){
			%>
			<input type="button" value="<%=SystemEnv.getHtmlLabelNames("32136",user.getLanguage())%>" class="e8_btn_top" onclick="batchDel()"/>
			<%
		}
		%>
			<input type="text" class="searchInput" name="flowTitle" value="<%=nameQuery1 %>" />
			&nbsp;&nbsp;&nbsp;
			<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelNames("347",user.getLanguage())%></span>
			<span title="<%=SystemEnv.getHtmlLabelNames("23036",user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>		
		<div class="advancedSearchDiv" id="advancedSearchDiv">
			<wea:layout type="4col">
			    <wea:group context='<%=SystemEnv.getHtmlLabelNames("15774",user.getLanguage())%>'>
			    	<wea:item><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></wea:item>
				    <wea:item><input  name=nameQuery class=InputStyle value='<%=nameQuery %>'></wea:item>
			    	<wea:item><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></wea:item>
			    	<wea:item><input  name=typedesc class=InputStyle value='<%=typedesc %>'></wea:item>
			    </wea:group>
			    <wea:group context="">
			    	<wea:item type="toolbar">
			    		<input class="zd_btn_submit" type="submit" name="submit1" value="<%=SystemEnv.getHtmlLabelNames("197",user.getLanguage())%>"/>
			    		<input class="zd_btn_cancle" type="button" name="reset" onclick="resetForm();"  value="<%=SystemEnv.getHtmlLabelNames("2022",user.getLanguage())%>"/>
			    		<input class="zd_btn_cancle" type="button" name="cancel" id="cancel" value="<%=SystemEnv.getHtmlLabelNames("201",user.getLanguage())%>"  />
			    	</wea:item>
			    </wea:group>
			</wea:layout>
		</div>
	</form>	
<script>
	$("input[name='submit1']").eq(0).click(function(){
		var adVal = $("input[name='nameQuery']").eq(0).val();
		$("input[name='flowTitle']").eq(0).val(adVal);
	});
	function resetForm(){
		var form= $("#frmSearch");
		form.find("input[name=nameQuery]").val("");
		form.find("input[name=typedesc]").val("");
	}

</script>	
<%


String popedomOtherpara="";

//操作列参数
JSONObject operatorInfo=new JSONObject();
operatorInfo.put("userid", user.getUID());
operatorInfo.put("usertype", user.getLogintype());
operatorInfo.put("languageid", user.getLanguage());
operatorInfo.put("operatortype", "cpt_cpttype");//操作项类型
operatorInfo.put("operator_num", 3);//操作项数量
operatorInfo.put("operator_val", popedomOtherpara);

String sqlWhere = " where 1=1 ";

if(!"".equals(nameQuery1)){
	sqlWhere+=" and name like '%"+nameQuery1+"%'";
}
if(!"".equals(nameQuery)){
	sqlWhere+=" and name like '%"+nameQuery+"%'";
}
if(!"".equals(typedesc)){
	if(sqlWhere.equals("")){
		sqlWhere += " where description like '%"+typedesc+"%' ";
	}else{
		sqlWhere += " and description like '%"+typedesc+"%' ";
	}
}

String orderby =" id ";
String tableString = "";
int perpage=10;                                 
String backfields = " id,name,description,typecode";
String fromSql  = " cptcapitaltype ";

tableString =   " <table pageId=\""+pageId+"\" instanceid=\"CptCapitalAssortmentTable\" tabletype=\"checkbox\"  pagesize=\""+PageIdConst.getPageSize(pageId,user.getUID(),"cpt")+"\"  >"+
				" <checkboxpopedom  id=\"checkbox\" popedompara=\"column:id\" showmethod='weaver.cpt.util.CapitalTransUtil.getCanDelCptType' />"+
                "       <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"id\" sqlsortway=\"asc\" sqlisdistinct=\"true\" />"+
                "       <head>"+
                "           <col width=\"25%\"  text=\""+SystemEnv.getHtmlLabelNames("195",user.getLanguage())+"\" column=\"name\" orderkey=\"name\"   />"+
                "           <col width=\"50%\"  text=\""+SystemEnv.getHtmlLabelNames("433",user.getLanguage())+"\" column=\"description\" orderkey=\"description\"  />"+
                "           <col width=\"25%\"  text=\""+SystemEnv.getHtmlLabelNames("21942",user.getLanguage())+"\" column=\"typecode\" orderkey=\"typecode\" />"+
                "       </head>"+
                "		<operates>"+
                "     <popedom  column='id' otherpara='"+operatorInfo.toString() +"' transmethod='weaver.cpt.util.CapitalTransUtil.getOperates'  ></popedom> ";	
                if(canAdd||canDel||canEdit){
                	tableString+=""+
                "		<operate href=\"javascript:onEdit();\" text=\""+SystemEnv.getHtmlLabelNames("93",user.getLanguage())+"\" target=\"_self\" index=\"0\"/>"+
				"		<operate href=\"javascript:onDel();\" text=\""+SystemEnv.getHtmlLabelNames("91",user.getLanguage())+"\" target=\"_self\" index=\"1\"/>"+
				"		<operate href=\"javascript:onLog();\" text=\""+SystemEnv.getHtmlLabelNames("83",user.getLanguage())+"\" target=\"_self\" index=\"2\"/>";
                }else{
                	
                }
				tableString+="		</operates>"+                  
                " </table>";
%>

<!-- listinfo -->
<wea:SplitPageTag  tableString='<%=tableString %>'  mode="run" />
</td>
</tr>
</TABLE>

</BODY>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<script type="text/javascript">
function addSub(){
	var url="/cpt/maintenance/CptCapitalTypeAdd.jsp?isdialog=1";
	var title="<%=SystemEnv.getHtmlLabelNames("83681",user.getLanguage())%>";
	openDialog(url,title,500,230);
}
function onEdit(id){
if(id){
	var url="/cpt/maintenance/CptCapitalTypeEdit.jsp?isdialog=1&id="+id;
	var title="<%=SystemEnv.getHtmlLabelNames("83683",user.getLanguage())%>";
	openDialog(url,title,500,230);
}
}

function onDel(id){
	if(id){
		window.top.Dialog.confirm('<%=SystemEnv.getHtmlLabelNames("83685",user.getLanguage())%>',function(){
			jQuery.post(
				"/cpt/maintenance/CapitalTypeOperation.jsp",
				{"operation":"delete","id":id},
				function(data){
					window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("83472",user.getLanguage())%>",function(){
						_table.reLoad();
					});
				}
			);
			
		});
	}
}

function batchDel(){
	var typeids = _xtable_CheckedCheckboxId();
	if(typeids=="") return ;
	window.top.Dialog.confirm('<%=SystemEnv.getHtmlLabelNames("83601",user.getLanguage())%>',function(){
		jQuery.post(
			"/cpt/maintenance/CapitalTypeOperation.jsp",
			{"operation":"batchdelete","id":typeids},
			function(data){
				window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("83472",user.getLanguage())%>",function(){
					_table.reLoad();
				});
			}
		);
		
	});
}

function onLog(id){
	//var url="/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where operateitem = 44 and relatedid="+id;
	var url = "/systeminfo/SysMaintenanceLog.jsp?operateitem=44&relatedid="+id;
	var title="<%=SystemEnv.getHtmlLabelNames("32061",user.getLanguage())%>";
	openDialog(url,title,1000,600,false);
}

function onBtnSearchClick(){
	var value=$("input[name='flowTitle']",parent.document).val();
    $("input[name='nameQuery']").val(value);
	frmSearch.submit();
}
$(function(){
	$("#topTitle").topMenuTitle({searchFn:onBtnSearchClick});
});


</script>
</HTML>
