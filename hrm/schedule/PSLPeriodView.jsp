<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@page import="weaver.hrm.attendance.domain.HrmLeaveTypeColor"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="colorManager" class="weaver.hrm.attendance.manager.HrmLeaveTypeColorManager" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif" ; 
String titlename = SystemEnv.getHtmlLabelName(131559,user.getLanguage()) ; 
String needfav = "1" ; 
String needhelp = "" ; 

String leavetype = Util.null2String(request.getParameter("leavetype"));
String subcompanyid = Util.null2String(request.getParameter("subcompanyid"));
if(subcompanyid.length()==0)subcompanyid="0";
String companyid = Util.null2String(request.getParameter("companyid"));
if(companyid.equals("0")) subcompanyid = companyid;//如果companyid=0，则为总部

String showname="";
if(!subcompanyid.equals("0")) showname = SubCompanyComInfo.getSubCompanyname(subcompanyid);
else showname = CompanyComInfo.getCompanyname("1");
StringBuffer mapSql = new StringBuffer("[map]").append("ispaidleave:1");
List<HrmLeaveTypeColor> leaveTypes = colorManager.find(mapSql.toString());
if(leaveTypes.size() > 0 && leavetype.length() == 0 ){
	leavetype = ""+leaveTypes.get(0).getField004();
}
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<script language=javascript src="/js/ecology8/hrm/HrmSearchInit_wev8.js"></script>
<script type="text/javascript">
jQuery(document).ready(function(){
<%if(showname.length()>0){%>
 parent.setTabObjName('<%=showname%>')
 <%}%>
});

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
				url:"/hrm/schedule/PSLPeriodOperation.jsp?isdialog=1&operation=delete&id="+idArr[i],
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
	if(dialog==null){
		dialog = new window.top.Dialog();
	}
	dialog.currentWindow = window;
	if(id==null){
		id="";
	}
	var url = "/hrm/HrmDialogTab.jsp?_fromURL=PSLPeriodAdd&subcompanyid=<%=subcompanyid%>&leavetype="+jQuery("#leavetype").val();
	if(!!id){
		dialog.Title = "<%=SystemEnv.getHtmlLabelNames("26473,131559",user.getLanguage())%>";
		url = "/hrm/HrmDialogTab.jsp?_fromURL=PSLPeriodEdit&subcompanyid=<%=subcompanyid%>&id="+id+"&leavetype="+jQuery("#leavetype").val();
	}else{
		dialog.Title = "<%=SystemEnv.getHtmlLabelNames("82,131559",user.getLanguage())%>";
	}
	dialog.Width = 500;
	dialog.Height = 500;
	dialog.Drag = true;
	dialog.URL = url;
	dialog.show();
}
</script>
<%
if(HrmUserVarify.checkUserRight("PSLPeriod:All" , user)) { 
RCMenu += "{"+SystemEnv.getHtmlLabelName(82 , user.getLanguage())+",javascript:openDialog(),_self} " ; 
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(32136 , user.getLanguage())+",javascript:doDel(),_self} " ; 
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(21671 , user.getLanguage())+",javascript:onSyn(),_self} " ; 
RCMenuHeight += RCMenuHeightStep ;
}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<form id="searchfrm" name="searchfrm" method=post action="PSLPeriodView.jsp">
<input name="subcompanyid" type="hidden" value="<%=subcompanyid %>">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<%if(HrmUserVarify.checkUserRight("PSLPeriod:All" , user)) { %>
				<input type=button class="e8_btn_top" onclick="openDialog();" value="<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%>"></input>
				<input type=button class="e8_btn_top" onclick="doDel();" value="<%=SystemEnv.getHtmlLabelName(32136, user.getLanguage())%>"></input>
				<input type=button class="e8_btn_top" onclick="onSyn();" value="<%=SystemEnv.getHtmlLabelName(21671, user.getLanguage())%>"></input>
			<%} %>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<wea:layout type="2col">     
<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
	<wea:item><%=SystemEnv.getHtmlLabelNames("30523,63",user.getLanguage())%></wea:item>
   	<wea:item>
      <select id="leavetype" name="leavetype" onchange="changeLeaveType(this)" style="width: 120px;">
	      <%
	      //输出带薪假列表
	       for(int i=0;i<leaveTypes.size();i++){
	       	  int field004 = leaveTypes.get(i).getField004();
	          String str = "<option value='"+(field004)+"' "+(leavetype.equals(""+field004)?"selected":"")+" >"+(leaveTypes.get(i).getField001())+"</option>";   
	          out.println(str);
	       } 
	      %>   
      </select>
   	</wea:item>
</wea:group>
<wea:group context='<%=titlename%>' attributes="{'groupOperDisplay':'none'}">
	<wea:item attributes="{'isTableList':'true'}">
		<%
		String backfields = " id, PSLyear, startdate, enddate "; 
		String fromSql  = " from HrmPSLPeriod ";
		String sqlWhere = " where subcompanyid= "+subcompanyid;
		String orderby = " id " ;
		String tableString = "";
		if(leavetype.length() > 0){
			sqlWhere += " and leavetype= "+leavetype;
		}
		
		//操作字符串
		String  operateString= "";
		operateString = "<operates width=\"20%\">";
		 	       operateString+=" <popedom transmethod=\"weaver.hrm.HrmTransMethod.getPSLPeriodOperate\" otherpara=\""+HrmUserVarify.checkUserRight("PSLPeriod:All", user)+"\" otherpara2=\""+HrmUserVarify.checkUserRight("PSLPeriod:All", user)+":"+HrmUserVarify.checkUserRight("PSLPeriod:All", user)+":"+HrmUserVarify.checkUserRight("PSLPeriod:All", user)+"\"></popedom> ";
		 	       operateString+="     <operate href=\"javascript:openDialog();\" text=\""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"\" index=\"0\"/>";
		 	       operateString+="     <operate href=\"javascript:doDel()\" text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\" index=\"1\"/>";
		 	       operateString+="</operates>";	
		 String tabletype="checkbox";
		 if(HrmUserVarify.checkUserRight("PSLPeriod:All", user)){
		 	tabletype = "checkbox";
		 }
		 
		tableString =" <table pageId=\""+PageIdConst.HRM_PSLPeriodView+"\" tabletype=\""+tabletype+"\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.HRM_PSLPeriodView,user.getUID(),PageIdConst.HRM)+"\" >"+
				" <checkboxpopedom showmethod=\"weaver.hrm.HrmTransMethod.getPSLPeriodCheckbox\" id=\"checkbox\"  popedompara=\"column:id\" />"+
				"	   <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"id\" sqlsortway=\"Asc\" sqlisdistinct=\"false\"/>"+
		    		operateString+
		    "			<head>"+
		    "				<col width=\"30%\"  text=\""+SystemEnv.getHtmlLabelName(445,user.getLanguage())+"\" column=\"PSLyear\" orderkey=\"PSLyear\"/>"+
		    "				<col width=\"35%\"  text=\""+SystemEnv.getHtmlLabelName(19548,user.getLanguage())+"\" column=\"startdate\" orderkey=\"startdate\"/>"+
		    "				<col width=\"35%\"  text=\""+SystemEnv.getHtmlLabelName(19547,user.getLanguage())+"\" column=\"enddate\" orderkey=\"enddate\"/>"+
		    "			</head>"+
		    " </table>";
		%>
		<input type="hidden" name="pageId" id="pageId" value="<%= PageIdConst.HRM_PSLPeriodView %>"/>
		<wea:SplitPageTag isShowTopInfo="false" tableString='<%=tableString%>' mode="run"  /> 
		</wea:item>
	</wea:group>
</wea:layout> 
</form>	
<script language="javascript">
function onSyn(ids){
	if(!ids){
		ids = _xtable_CheckedCheckboxId();
	}
	if(!ids){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(21677,user.getLanguage())%>");
		return;
	}
	if(ids.match(/,$/)){
		ids = ids.substring(0,ids.length-1);
	}
	
	window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(21669,user.getLanguage())%>",function(){
		location.href="/hrm/schedule/PSLPeriodOperation.jsp?operation=syn&subcompanyid=<%=subcompanyid%>&ids="+ids+"&leavetype="+jQuery("#leavetype").val();
	});  
}
function changeLeaveType(obj){
    searchfrm.action="PSLPeriodView.jsp?leavetype="+obj.value;
    searchfrm.submit();
}
</script>
</BODY>
</HTML>

