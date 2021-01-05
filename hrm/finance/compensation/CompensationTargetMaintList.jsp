
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<HTML><HEAD>
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
			var datas = idArr[i].split(":");
			var subcompanyid = datas[0];
			var CompensationYear = datas[1];
			var CompensationMonth = datas[2];
			jQuery.ajax({
				url:"CompansationTargetMaintOperation.jsp?isdialog=1&option=delete&subcompanyid="+subcompanyid+"&CompensationYear="+CompensationYear+"&CompensationMonth="+CompensationMonth,
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
	var datas = id.split(":");
	var subcompanyid = datas[0];
	var CompensationYear = datas[1];
	var CompensationMonth = datas[2];
	var url = "/hrm/HrmDialogTab.jsp?_fromURL=CompensationTargetMaintEdit&isdialog=1&isedit=0";
	if(!!id){
		dialog.Title = "<%=SystemEnv.getHtmlLabelName(26473,user.getLanguage())+SystemEnv.getHtmlLabelName(33371,user.getLanguage())%>";
		url = "/hrm/HrmDialogTab.jsp?_fromURL=CompensationTargetMaintEdit&isdialog=1&subCompanyId="+subcompanyid+"&CompensationYear="+CompensationYear+"&CompensationMonth="+CompensationMonth+"&&isedit=1";
	}else{
		dialog.Title = "<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())+SystemEnv.getHtmlLabelName(33371,user.getLanguage())%>";
	}
	dialog.Width = 900;
	dialog.Height = 800;
	dialog.maxiumnable=true;
	//dialog.DefaultMax=true;
	dialog.Drag = true;
	dialog.URL = url;
	dialog.show();
}



</script>
</head>
<%
if(!HrmUserVarify.checkUserRight("Compensation:Maintenance", user)){
    response.sendRedirect("/notice/noright.jsp");
    return;
}

String title="";
String allrightcompany = SubCompanyComInfo.getRightSubCompany(user.getUID(), "Compensation:Maintenance",-1);
String sqlwhere=" where subcompanyid in("+allrightcompany+")";

String imagefilename = "/images/hdHRM_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(19430,user.getLanguage())+"："+title;
String needfav ="1";
String needhelp ="";

String subcompanyid = Util.null2String(request.getParameter("subcompanyid"));
String subcompanyname = "";
if(subcompanyid.length()>0)subcompanyname = SubCompanyComInfo.getSubCompanyname(subcompanyid);
String compensationyear = Util.null2String(request.getParameter("compensationyear"));
String compensationmonth = Util.null2String(request.getParameter("compensationmonth"));

String qname = Util.null2String(request.getParameter("flowTitle"));

%>
<body>

<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",javascript:openDialog();,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(32136,user.getLanguage())+",javascript:doDel();,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<form action="" name="searchfrm" id="searchfrm">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type=button class="e8_btn_top" onclick="openDialog();" value="<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%>"></input>
			<input type=button class="e8_btn_top" onclick="doDel();" value="<%=SystemEnv.getHtmlLabelName(32136, user.getLanguage())%>"></input>
			<input type="text" class="searchInput" name="flowTitle" value="<%=qname %>"/>
			<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage())%></span><span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<div class="advancedSearchDiv" id="advancedSearchDiv" style="display:none;" >
	<wea:layout type="4col">
		<wea:group context='<%=SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>'>
			<wea:item><%=SystemEnv.getHtmlLabelName(1878,user.getLanguage())%></wea:item>
			<wea:item>
					<brow:browser viewType="0"  name="subcompanyid" browserValue='<%=subcompanyid %>' 
            browserUrl="/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/company/SubcompanyBrowser.jsp?selectedids="
            hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
            completeUrl="/data.jsp?type=164"
            browserSpanValue='<%=Util.toScreen(SubCompanyComInfo.getSubCompanyname(subcompanyid),user.getLanguage()) %>'>
          </brow:browser>
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(33370,user.getLanguage())%></wea:item>
			<wea:item>
			 <select name="compensationyear" style="width: 60px" >
			 	<option value=""></option>
        <%
        		Calendar cal = Calendar.getInstance();
        	 int currentyear = cal.get(Calendar.YEAR);
            // 查询选择框的所有可以选择的值
            for(int y=currentyear-50;y<currentyear+50;y++){
	   		%>
	    		<option value="<%=y%>" <%if(y==Util.getIntValue(compensationyear)){%>selected<%}%>><%=y%></option>
	   		<%
            }
       	%>
          </select>&nbsp;&nbsp;
           <select name="compensationmonth" style="width: 60px">
           	<option value=""></option>
            <option value="01" <%if(compensationmonth.equals("01")){%>selected<%}%>>01</option>
            <option value="02" <%if(compensationmonth.equals("02")){%>selected<%}%>>02</option>
            <option value="03" <%if(compensationmonth.equals("03")){%>selected<%}%>>03</option>
            <option value="04" <%if(compensationmonth.equals("04")){%>selected<%}%>>04</option>
            <option value="05" <%if(compensationmonth.equals("05")){%>selected<%}%>>05</option>
            <option value="06" <%if(compensationmonth.equals("06")){%>selected<%}%>>06</option>
            <option value="07" <%if(compensationmonth.equals("07")){%>selected<%}%>>07</option>
            <option value="08" <%if(compensationmonth.equals("08")){%>selected<%}%>>08</option>
            <option value="09" <%if(compensationmonth.equals("09")){%>selected<%}%>>09</option>
            <option value="10" <%if(compensationmonth.equals("10")){%>selected<%}%>>10</option>
            <option value="11" <%if(compensationmonth.equals("11")){%>selected<%}%>>11</option>
            <option value="12" <%if(compensationmonth.equals("12")){%>selected<%}%>>12</option>
        </select>
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
String backfields = " ltrim(rtrim(str(subcompanyid)))+':'+ ltrim(rtrim(str(CompensationYear)))+ ':'+ ltrim(rtrim(str(CompensationMonth))) as id, " 
						+ "subcompanyid, (ltrim(rtrim(str(CompensationYear))) +'-'+ ltrim(rtrim(str(CompensationMonth)))) as yearmonth , COUNT(*)  as  empNum "; 
String fromSql  = " from HRM_CompensationTargetInfo a ";
String sqlWhere = " where 1 = 1 ";
String groupby =  " group by subcompanyid, CompensationYear, CompensationMonth" ; 
String orderby = "  CompensationYear desc,CompensationMonth desc " ;
String tableString = "";


if(!qname.equals("")){
	sqlWhere += " and subcompanyid in (select id from hrmsubcompany where subcompanyname like '%"+qname+"%' ) ";
}		

if (!"".equals(subcompanyid)) {
	sqlWhere += " and subcompanyid = "+subcompanyid;
	}  	  	

if (!"".equals(compensationyear)) {  
	sqlWhere += " and compensationyear = "+compensationyear; 	  	
}

if (!"".equals(compensationmonth)) {  
	sqlWhere += " and compensationmonth = "+compensationmonth; 	  	
}

//操作字符串
String  operateString= "";
operateString = "<operates width=\"20%\">";
operateString+="     <operate href=\"javascript:openDialog();\" text=\""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"\" index=\"0\"/>";
operateString+="     <operate href=\"javascript:doDel()\" text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\" index=\"1\"/>";
//operateString+="     <operate href=\"javascript:onLog()\" text=\""+SystemEnv.getHtmlLabelName(83,user.getLanguage())+"\" index=\"2\"/>";
operateString+="</operates>";	
String tabletype="checkbox";
 
tableString =" <table pageId=\""+PageIdConst.HRM_CompensationTargetMaintList+"\" tabletype=\""+tabletype+"\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.HRM_CompensationTargetMaintList,user.getUID(),PageIdConst.HRM)+"\" >"+
		" <checkboxpopedom showmethod=\"weaver.hrm.HrmTransMethod.getCompensationTargetMaintListCheckbox\" id=\"checkbox\"  popedompara=\"column:id\" />"+
		"	   <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlgroupby=\""+groupby+"\" sqlorderby=\""+orderby+"\"  sqlprimarykey=\"a.id\" sqlsortway=\"Asc\" sqlisdistinct=\"false\"/>"+
    operateString+
    "			<head>"+
    "				<col width=\"40%\" text=\""+SystemEnv.getHtmlLabelName(1878,user.getLanguage()) +"\" column=\"subcompanyid\" orderkey=\"subcompanyid\" transmethod=\"weaver.hrm.company.SubCompanyComInfo.getSubCompanyname\" />"+
    "				<col width=\"40%\" text=\""+SystemEnv.getHtmlLabelName(33370,user.getLanguage()) +"\" column=\"yearmonth\" orderkey=\"yearmonth\" />"+
    "				<col width=\"30%\" text=\""+SystemEnv.getHtmlLabelName(15861,user.getLanguage()) +"\" column=\"empNum\" orderkey=\"empNum\" />"+
    "			</head>"+
    " </table>";
%>
<input type="hidden" name="pageId" id="pageId" value="<%= PageIdConst.HRM_CompensationTargetMaintList %>"/>
<wea:SplitPageTag isShowTopInfo="false" tableString='<%=tableString%>' mode="run" /> 
</body>
</html>

