
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.net.*" %>
<%@page import="weaver.formmode.service.FormInfoService"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="selectRs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="UrlComInfo" class="weaver.workflow.field.UrlComInfo" scope="page" />
<jsp:useBean id="ReportShareInfo" class="weaver.formmode.report.ReportShareInfo" scope="page" />
<jsp:useBean id="ModeRightInfo" class="weaver.formmode.setup.ModeRightInfo" scope="page" />

<HTML><HEAD>

<link rel=stylesheet type="text/css" href="/css/Browser_wev8.css">
<link rel=stylesheet type="text/css" href="/css/Weaver_wev8.css">
<script language="javascript" src="/js/weaver_wev8.js"></script>

 <link rel="stylesheet" href="/wui/theme/ecology8/templates/default/css/default_wev8.css" type="text/css"> </link>
<script type="text/javascript" src="/wui/theme/ecology8/templates/default/js/default_wev8.js"> </script> 

<STYLE TYPE="text/css">
table.viewform .field{
	background-color: #F5FAFA;
    padding-left: 2px;
    padding-right: 3px;
}
table.viewform td{
	background-color: #FFFFFF;
}
table.viewform td.line{
	background-color: #F3F2F2;
    background-repeat: repeat-x;
    height: 1px;
    padding: 0 0 0 5px;
}
table.viewform td.line1{
	background-color: #F3F2F2;
	height: 1px;
}

table.viewform tr.title th {
    text-align: left;
    text-indent: -1pt;
}
tr{
	height: 29px;
}
table{
	width: 100%;
}
.sbHolder{
	border: 1px solid #e7eaee;
}
input,select,textarea{
	border: 1px solid #e7eaee;
}


table.liststyle tr.header td {
    color: #003366;
}
#fieldValueTableTr .Header td {
    background: #E8E8E8;
    color: #4F6B72;
    cursor: pointer;
    height: 22px;
    padding: 4px;
    border-left: 1px solid #FFFFFF;
}

.liststyle .Header td{
	background: #E8E8E8;
    color: #4F6B72;
    cursor: pointer;
    height: 22px;
    padding: 4px;
    border-left: 1px solid #FFFFFF;
}

table.viewform tr{
	height: 28px;
}

table.liststyle tbody tr td {
    background-color: #FFFFFF;
    color: #4F6B72;
    overflow: visible;
    padding: 10px 5px;
    vertical-align: top;
}

table.liststyle tr.dataDark td {
    background-color: #F5FAFA;
    color: #4F6B72;
}

table.viewform td.line{
 	background-color: #F3F2F2;
    background-repeat: repeat-x;
    height: 1px;
}
#fieldValueTableTr tr{
	height: 1px;
}
#fieldname{
	width: 100px;
}

#dmlcheck{
	border: 0px;
}
#wherecheck{
	border: 0px;
}
#fieldWhereTableTr tr{
	height: 1px;
}

.selectover{
	border: 1px solid #BA;
}

TR.Selected A:link{
	color: #000000;
}

TR.Selected{
	color: #000000;
}
TR.Selected TD{
	padding: 0px;
}
</style>
</HEAD>
<%

String imagefilename = "/images/hdMaintenance_wev8.gif";
//报表-流程报表-报表条件
String titlename = SystemEnv.getHtmlLabelName(15101,user.getLanguage())+" - " + SystemEnv.getHtmlLabelName(16532,user.getLanguage())+" - " + SystemEnv.getHtmlLabelName(15505,user.getLanguage());
String needfav ="1";
String needhelp ="";

int reportid = Util.getIntValue(request.getParameter("id"),0);
int sharelevel = 0 ;
boolean haveright = false;
List<User> lsUser = new ArrayList<User>();
lsUser.add(user);
//ModeRightInfo.getAllUserCountList(user);
for(int i=0;i<lsUser.size();i++){
	User tempUser = lsUser.get(i);
	ReportShareInfo.setUser(tempUser);
	haveright = ReportShareInfo.checkUserRight(reportid);
	if(haveright){
		break;
	}
}
if(!haveright) {
    //response.sendRedirect("/notice/noright.jsp");
    out.println("<script>window.location.href='/notice/noright.jsp';</script>");
    return;
}

String sql = "select a.reportname,a.formid from mode_Report a where  a.id = "+reportid;
RecordSet.execute(sql) ;
RecordSet.next() ;
String isbill = "1";
int formid = Util.getIntValue(RecordSet.getString("formid"),0);
titlename = Util.null2String(RecordSet.getString("reportname"));

//获得报表显示项
String strReportDspField=",";
String isShowReportDspField = ",";
String fieldId="";
String isshow="";
RecordSet.execute("select fieldId,isshow from mode_ReportDspField where reportId="+reportid) ;
while(RecordSet.next()){
	fieldId=RecordSet.getString("fieldId");
	isshow=RecordSet.getString("isshow");
	if(fieldId!=null&&!fieldId.equals("")){
		strReportDspField+=fieldId+",";
	}
	if(isshow.equals("1")){
		isShowReportDspField+=fieldId+",";
	}
}
FormInfoService formInfoService = new FormInfoService();
List<Map<String, Object>> detailTables = formInfoService.getAllDetailTable(formid);
Map detailtableMap = new HashMap();
int tabIndex = 1;
for(int i=0;i<detailTables.size();i++){
	Map map = detailTables.get(i);
	String tablename = Util.null2String(map.get("tablename"));
	if(!detailtableMap.containsKey(tablename)){
		detailtableMap.put(tablename,tabIndex);
		tabIndex++;
	}
}
String initselectfield = "";
List iframeList = new ArrayList();


%>

<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%

RCMenu += "{"+SystemEnv.getHtmlLabelName(527,user.getLanguage())+",javascript:submit(),_self} " ;//查询
RCMenuHeight += RCMenuHeightStep;

RCMenu += "{"+SystemEnv.getHtmlLabelName(15504,user.getLanguage())+",javascript:onClear(),_self} " ;//清空
RCMenuHeight += RCMenuHeightStep;

%>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td></td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type=button class="e8_btn_top" onclick="submit();" value="<%=SystemEnv.getHtmlLabelName(527,user.getLanguage())%>"><!-- 查询 -->
			<input type=button class="e8_btn_top" onclick="onClear();" value="<%=SystemEnv.getHtmlLabelName(15504,user.getLanguage())%>"><!-- 清空 -->
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span><!-- 菜单 -->
		</td>
	</tr>
</table>
	
<FORM NAME=SearchForm STYLE="margin-bottom:0" action="ReportResult.jsp" method="post">
<iframe id="selectChange" frameborder=0 scrolling=no src=""  style="display:none"></iframe>
<input type="hidden" value="<%=formid%>" name="formid">
<input type=hidden name=isbill value="<%=isbill%>">
<input type=hidden name=reportid value="<%=reportid%>">
<input type=hidden name=reportname value="<%=titlename%>">
<input type=hidden name=operation>

<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">


<col width="">
<col width="10">
<tr>
	<td ></td>
	<td valign="top">
		<TABLE class=Shadow>
		<tr>
		<td valign="top">

  <table width=100% class=viewform border="0">
    <COLGROUP> 
	    <COL width="5%">
	    <COL width="5%"> 
	    <COL width="15%"> 
	    <COL width="18%"> 
	    <COL width="18%">
	    <COL width="18%"> 
	    <COL width="18%">
    </COLGROUP> 
    <TR class=title>
      <td><%=SystemEnv.getHtmlLabelName(19664,user.getLanguage())%></td><!-- 报表列 -->
      <td><%=SystemEnv.getHtmlLabelName(15505,user.getLanguage())%></td><!-- 报表条件 -->
      <td><%=SystemEnv.getHtmlLabelName(261,user.getLanguage())%></td><!-- 字段 -->
      <td colspan=4><%=SystemEnv.getHtmlLabelName(15364,user.getLanguage())%></td><!-- 条件 -->
    </tr>   
    <TR style="height:1px">
      <TD class=line colspan=7></TD>
    </TR>
    
    <TR class=title>
      <td>
<%
	if(strReportDspField.indexOf(",-1,")>-1&&isShowReportDspField.indexOf(",-1,")>-1){
%>
	  <input type="checkbox" name="modedatacreatedateIsShow"  value="1" checked>
<%
    }
%>
	  </td>
      <td><input type="checkbox" name="modedatacreatedate_check_con"  value="1"></td>
      <td><%=SystemEnv.getHtmlLabelName(722,user.getLanguage())%></td><!-- 创建日期 -->
	  <td colspan=4>
	  	<button type=button  type=button class=calendar id=SelectDate onclick="changeclick1(),gettheDate(fromdate,fromdatespan)"></BUTTON>&nbsp;
	    <SPAN id=fromdatespan ></SPAN>
	    -&nbsp;&nbsp;
	    <button type=button  type=button class=calendar id=SelectDate2 onclick="changeclick1(),gettheDate(todate,todatespan)"></BUTTON>&nbsp;
	    <SPAN id=todatespan ></SPAN>
		<input type="hidden" name="fromdate" class=Inputstyle>
		<input type="hidden" name="todate" class=Inputstyle>
	  </td>
    </tr>    
    <tr style="height:1px"><td colspan=7 class=line1></td></tr>
    
      <TR class=title>
      <td>
<%
	if(strReportDspField.indexOf(",-2,")>-1&&isShowReportDspField.indexOf(",-2,")>-1){
%>
	  <input type="checkbox" name="modedatacreaterIsShow"  value="1" checked>
<%
    }
%>
	  </td>
		<td><input type="checkbox" name="modedatacreater_check_con"  value="1" ></td>
		<td><%=SystemEnv.getHtmlLabelName(882,user.getLanguage())%></td><!-- 创建人 -->
		<td colspan=4>
         <%
            String tempbrowserurl = UrlComInfo.getUrlbrowserurl("1") ;
         %>
     	<button type=button  class=Browser  onfocus="changeclick2()" onclick="onShowBrowserHrm('modedatacreater','<%=tempbrowserurl%>')"></button>
	      <input type=hidden name="modedatacreater" >
	      <span id="modedatacreaterspan">
	      </span>
      </td>
      
    </tr>   
    <tr style="height:1px"><td colspan=7 class=line1></td></tr>

    <%
	int linecolor=0;
    sql = "select id as id,fieldname as name,fieldlabel as label,fieldhtmltype as htmltype,childfieldid as childfieldid,type as type,fielddbtype as dbtype,viewtype,detailtable,selectitem from workflow_billfield where billid = "+formid ;
    if(rs.getDBType().equals("sqlserver")){
    	sql += " order by isnull(detailtable,0),dsporder,viewtype ";
    }else{
    	sql += " order by nvl(detailtable,0),dsporder,viewtype ";
    }
	RecordSet.executeSql(sql);
	int tmpcount = 0;
	while(RecordSet.next()){
		tmpcount += 1;
		String id = RecordSet.getString("id");
		String detailtable = RecordSet.getString("detailtable");
		String detailtableIndex = "";
		String childfieldid = Util.null2String(RecordSet.getString("childfieldid"));
		int selectitem =Util.getIntValue(Util.null2String(RecordSet.getString("selectitem")),0);
		if(!detailtable.equals("")){
			if(detailtableMap.containsKey(detailtable)){
				detailtableIndex = Util.null2String(detailtableMap.get(detailtable));
			}
		}
	%>
	<tr class=title >
    	<td>
		<%
			if(strReportDspField.indexOf(","+id+",")>-1&&isShowReportDspField.indexOf(","+id+",")>-1){
		%>
				<input type='checkbox' name='isShow'  value="<%=id%>" checked>
		<%
    		}
		%>
		</td>
		<td>
      		<input type='checkbox' name='check_con'  value="<%=id%>">
		</td>
		<td>
			<input type=hidden name="con<%=id%>_id" value="<%=id%>">

		<%
			String name = RecordSet.getString("name");
			String label = RecordSet.getString("label");
			int ismain=1;
			label = SystemEnv.getHtmlLabelName(Util.getIntValue(label),user.getLanguage());
		    int viewtypeint=Util.getIntValue(RecordSet.getString("viewtype"));
		    if(viewtypeint==1){
		        label="("+SystemEnv.getHtmlLabelName(19325,user.getLanguage())+detailtableIndex+")"+label;//明细表
		        ismain=0;
		    }
		%>
			<input type=hidden name="con<%=id%>_ismain" value="<%=ismain%>">
			<%=Util.toScreen(label,user.getLanguage())%>
			<input type=hidden name="con<%=id%>_colname" value="<%=name%>">
		</td>
		<%
			String htmltype = RecordSet.getString("htmltype");
			String type = RecordSet.getString("type");
			String dbtype = RecordSet.getString("dbtype");
		%>
		    <input type=hidden name="con<%=id%>_htmltype" value="<%=htmltype%>">
		    <input type=hidden name="con<%=id%>_type" value="<%=type%>">
		<%
			if(htmltype.equals("3") &&(type.equals("256")||type.equals("257"))){ // 自定义树形
	    	%>
	        <td >
	          <select class=inputstyle style="width:150px;" name="con<%=id%>_opt" style="width:100%" onfocus="changelevel('<%=tmpcount%>')" >
	            <option value="1"><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option><!-- 包含 -->
	            <option value="2"><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option><!-- 不包含 -->
	          </select>
	        </td>
	        <%
	    	String browserurl = UrlComInfo.getUrlbrowserurl(type) ;
	    	browserurl = browserurl.trim() + "?type="+dbtype+"_"+type;
	        %>
	        <td colspan=3> <button type=button  class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowBrowserCustomNew('<%=id%>','<%=browserurl%>',<%=type %>)"></button>
	          <input type=hidden name="con<%=id%>_value" >
	          <input type=hidden name="con<%=id%>_name" >
	          <span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan">
	          </span> </td>
	        <%}else if(htmltype.equals("1") && type.equals("1")){//单行文本框的文本类型
		%>
		<td>
			<select class=inputstyle name="con<%=id%>_opt" style="width:150px;" onfocus="changelevel('<%=tmpcount%>')" >
		        <option value="1"><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option><!-- 等于 -->
		        <option value="2"><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option><!-- 不等于 -->
		        <option value="3"><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option><!-- 包含 -->
		        <option value="4"><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option><!-- 不包含 -->
			</select>
		</td>
	    <td colspan=3>
			<input type=text class=inputstyle style="width: 178px;" size=12 name="con<%=id%>_value"   onfocus="changelevel('<%=tmpcount%>')"  >
	    </td>
    	<%}else if(htmltype.equals("2")){//多行文本框
    	%>
        <td>
          <select class=inputstyle name="con<%=id%>_opt" style="width:150px;" onfocus="changelevel('<%=tmpcount%>')" >
            <option value="3"><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option><!-- 包含 -->
            <option value="4"><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option><!-- 不包含 -->
          </select>
        </td>
        <td colspan=3>
          <input type=text class=inputstyle style="width: 178px;" size=12 name="con<%=id%>_value"  onfocus="changelevel('<%=tmpcount%>')"  >
        </td>
        <%}
		else if(htmltype.equals("1")&& !type.equals("1")){
		%>
    <td>
      <select class=inputstyle name="con<%=id%>_opt" style="width:150px;" onfocus="changelevel('<%=tmpcount%>')" >
        <option value="1"><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%></option><!-- 大于 -->
        <option value="2"><%=SystemEnv.getHtmlLabelName(325,user.getLanguage())%></option><!-- 大于或等于 -->
        <option value="3"><%=SystemEnv.getHtmlLabelName(15509,user.getLanguage())%></option><!-- 小于 -->
        <option value="4"><%=SystemEnv.getHtmlLabelName(326,user.getLanguage())%></option><!-- 小于或等于 -->
        <option value="5"><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option><!-- 等于 -->
        <option value="6"><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option><!-- 不等于 -->
      </select>
    </td>
    <td >
      <input type=text class=inputstyle style="width: 178px;" size=12 name="con<%=id%>_value"  onfocus="changelevel('<%=tmpcount%>')" >
    </td>
    <td>
      <select class=inputstyle name="con<%=id%>_opt1" style="width:150px;" onfocus="changelevel('<%=tmpcount%>')" >
        <option value="1"><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%></option><!-- 大于 -->
        <option value="2"><%=SystemEnv.getHtmlLabelName(325,user.getLanguage())%></option><!-- 大于或等于 -->
        <option value="3"><%=SystemEnv.getHtmlLabelName(15509,user.getLanguage())%></option><!-- 小于 -->
        <option value="4"><%=SystemEnv.getHtmlLabelName(326,user.getLanguage())%></option><!-- 小于或等于 -->
        <option value="5"><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option><!-- 等于 -->
        <option value="6"><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option><!-- 不等于 -->
      </select>
    </td>
    <td>
      <input type=text class=inputstyle style="width: 178px;" size=12 name="con<%=id%>_value1"  onfocus="changelevel('<%=tmpcount%>')"  >
    </td>
    <%
}
else if(htmltype.equals("4")){
%>
    <td colspan=4>
      <input type=checkbox value=1 name="con<%=id%>_value"  onclick="if(this.checked){this.value='1';changelevel('<%=tmpcount%>');}else{this.value='';changelevel1('<%=tmpcount%>')}">
    </td>
    <%}
else if(htmltype.equals("5")){
%>
    <td>
      <select class=inputstyle name="con<%=id%>_opt" style="width:150px;" onfocus="changelevel('<%=tmpcount%>')" >
        <option value="1"><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option><!-- 等于 -->
        <option value="2"><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option><!-- 不等于 -->
      </select>
    </td>
<%
String selectchange = "";
if(!childfieldid.equals("")&&!childfieldid.equals("0")){//瀛愬瓧娈佃仈鍔?
	selectchange = "changeChildField(this,'"+id+"','"+childfieldid+"');";
	initselectfield += "changeChildField(jQuery('#con"+id+"_value')[0],'"+id+"','"+childfieldid+"');";
}
%>
    <td colspan=3>
      <select notBeauty=true class=inputstyle name="con<%=id%>_value" id="con<%=id%>_value" style="width:150px;" onfocus="changelevel('<%=tmpcount%>')" onchange="changevalue();<%=selectchange%>">
      	<option value='' ></option>
        <%
char flag=2;
rs.executeProc("workflow_SelectItemSelectByid",""+id+flag+isbill);
while(rs.next()){
	int tmpselectvalue = rs.getInt("selectvalue");
	String tmpselectname = rs.getString("selectname");
	String tempcancel = rs.getString("cancel");
	if("1".equals(tempcancel)){
		continue;
	}
%>
        <option value="<%=tmpselectvalue%>"><%=Util.toScreen(tmpselectname,user.getLanguage())%></option>
        <%}%>
      </select>
    </td>
    <%}
else if(htmltype.equals("8")){
	
	int linkfield = 0;
	rs.execute("select id from workflow_billfield where linkfield="+id);
	if(rs.next()){
		linkfield = Util.getIntValue(rs.getString("id"), 0);
	}
	
	String selectchange = "";
    if(linkfield!=0){//公共子字段联动
    	if(!iframeList.contains(id)){
    		iframeList.add(id);
    	}
    	selectchange = "changeChildSelectItemField(this,'"+id+"','"+linkfield+"');";
   	  	int selflinkfieldid = 1;
   		String selfSql = "select linkfield from workflow_billfield where id="+id;
   		selectRs.executeSql(selfSql);
   		if(selectRs.next()){
   			selflinkfieldid = selectRs.getInt("linkfield");
   			if(selflinkfieldid<1){
		    	initselectfield += "changeChildSelectItemField(0,'"+id+"','"+linkfield+"',1);";
   			} 
   		}
    }
    
	%>
	   <td>
      <select class=inputstyle name="con<%=id%>_opt" style="width:150px;" onfocus="changelevel('<%=tmpcount%>')" >
        <option value="1"><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option><!-- 等于 -->
        <option value="2"><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option><!-- 不等于 -->
      </select>
    </td>
    
    <td colspan=3>
      	<select  childsel="<%=linkfield %>" class=inputstyle name="con<%=id%>_value" id="con<%=id%>_value" style="width:150px;" onfocus="changelevel('<%=tmpcount%>');" onchange="changevalue();<%=selectchange%>">
      		<option value='' ></option>
      		<%
			char flag=2;
      		selectRs.executeSql("select id,name,defaultvalue from mode_selectitempagedetail where mainid = "+selectitem+" and statelev = 1  and (cancel=0 or cancel is null)  order by disorder asc,id asc");
			while(selectRs.next()){
				int tmpselectvalue = selectRs.getInt("id");
				String tmpselectname = selectRs.getString("name");
				String isdefault = selectRs.getString("defaultvalue");
				%>
				<option value="<%=tmpselectvalue%>" ><%=Util.toScreen(tmpselectname,user.getLanguage())%></option>
				<%
			}%>
      	</select>
    </td>
    
<%}
		
else if(htmltype.equals("3") && !type.equals("165") && !type.equals("166")&& !type.equals("167")&& !type.equals("168")&& !type.equals("169")&& !type.equals("170")&& !type.equals("2") && !type.equals("4")&& !type.equals("18")&& !type.equals("19")&& !type.equals("17") && !type.equals("37") && !type.equals("65")&& !type.equals("57")&& !type.equals("162")&& !type.equals("135")){
%>
    <td>
      <select class=inputstyle name="con<%=id%>_opt" style="width:150px;" onfocus="changelevel('<%=tmpcount%>')" >
        <option value="1"><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option><!-- 等于 -->
        <option value="2"><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option><!-- 不等于 -->
      </select>
    </td>
    <td colspan=3>
         <%
         	String onclickFun = "";
            String browserurl = UrlComInfo.getUrlbrowserurl(type) ;
            if(type.equals("4") && sharelevel <2) {
                if(sharelevel == 1) browserurl = browserurl.trim() + "?sqlwhere=where subcompanyid1 = " + user.getUserSubCompany1() ;
                else browserurl = browserurl.trim() + "?sqlwhere=where id = " + user.getUserDepartment() ;
                onclickFun =  "onShowBrowserCustomNew('"+id+"','"+browserurl+"',"+type+")";
            }else if("161".equals(type)){
				browserurl = browserurl.trim() + "?type="+dbtype;
				onclickFun = "onShowBrowserCustomNew('"+id+"','"+browserurl+"',"+type+")";
	    	}else if("7".equals(type)||"194".equals(type)||"23".equals(type)||"16".equals(type)||"24".equals(type)){
				browserurl = browserurl.trim();
				onclickFun = "onShowBrowserCustomNew('"+id+"','"+browserurl+"',"+type+")";
	    	}else if("224".equals(type)||"225".equals(type)||"226".equals(type)||"227".equals(type)){
				browserurl = browserurl.trim() + "?type="+dbtype+"|"+id;
				onclickFun = "onShowBrowserCustomNew('"+id+"','"+browserurl+"',"+type+")";
	    	}else{
	    		 onclickFun ="onShowBrowserCustomNew('"+id+"','"+browserurl+"',"+type+")";
	    	}
         %>
     	<button type=button  class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="<%=onclickFun %>"></button>
      <input type=hidden name="con<%=id%>_value" >
      <input type=hidden name="con<%=id%>_name" >
      <span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan">
      </span> </td>
    <%} else if(htmltype.equals("3") &&( type.equals("2") || type.equals("19"))){ // 增加日期和时间的处理（之间）
    	String classStr = "";
    	if(type.equals("2")){
    		classStr = "calendar";
    	}else {
    		classStr = "Clock";
    	}
%>
    <td >
      <select class=inputstyle name="con<%=id%>_opt" style="width:150px;" onfocus="changelevel('<%=tmpcount%>')" >
        <option value="1"><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%></option><!-- 大于 -->
        <option value="2"><%=SystemEnv.getHtmlLabelName(325,user.getLanguage())%></option><!-- 大于或等于 -->
        <option value="3"><%=SystemEnv.getHtmlLabelName(15509,user.getLanguage())%></option><!-- 小于 -->
        <option value="4"><%=SystemEnv.getHtmlLabelName(326,user.getLanguage())%></option><!-- 小于或等于 -->
        <option value="5"><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option><!-- 等于 -->
        <option value="6"><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option><!-- 不等于 -->
      </select>
    </td>
    <td><button type=button  class=<%=classStr %>  onfocus="changelevel('<%=tmpcount%>')"  
<%if(type.equals("2")){%>
   onclick="onSearchWFDate(con<%=id%>_valuespan,con<%=id%>_value)"
<%}else{%>
 onclick ="onSearchWFTime(con<%=id%>_valuespan,con<%=id%>_value)"
<%}%>
 ></button>
      <input type=hidden name="con<%=id%>_value" >
      <span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan">
      </span> </td>
    <td >
      <select class=inputstyle name="con<%=id%>_opt1" style="width:150px;" onfocus="changelevel('<%=tmpcount%>')" >
        <option value="1"><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%></option><!-- 大于 -->
        <option value="2"><%=SystemEnv.getHtmlLabelName(325,user.getLanguage())%></option><!-- 大于或等于 -->
        <option value="3"><%=SystemEnv.getHtmlLabelName(15509,user.getLanguage())%></option><!-- 小于 -->
        <option value="4"><%=SystemEnv.getHtmlLabelName(326,user.getLanguage())%></option><!-- 小于或等于 -->
        <option value="5"><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option><!-- 等于 -->
        <option value="6"><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option><!-- 不等于 -->
      </select>
    </td>
    <td ><button type=button class=<%=classStr %>  onfocus="changelevel('<%=tmpcount%>')"  
<%if(type.equals("2")){%>
   onclick="onSearchWFDate(con<%=id%>_value1span,con<%=id%>_value1)"
<%}else{%>
 onclick ="onSearchWFTime(con<%=id%>_value1span,con<%=id%>_value1)"
<%}%>
 ></button>
      <input type=hidden name="con<%=id%>_value1" >
      <span name="con<%=id%>_value1span" id="con<%=id%>_value1span">
      </span> </td>
     <%} else if(htmltype.equals("3") && type.equals("4")){ // 增加部门的处理
%>
    <td >
      <select class=inputstyle name="con<%=id%>_opt" style="width:150px;" onfocus="changelevel('<%=tmpcount%>')" >
        <option value="1"><%=SystemEnv.getHtmlLabelName(353,user.getLanguage())%></option><!-- 属于 -->
        <option value="2"><%=SystemEnv.getHtmlLabelName(21473,user.getLanguage())%></option><!-- 不属于 -->
      </select>
    </td>
    <td colspan=3> <button type=button  class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowBrowserCustomNew('<%=id%>','/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp','<%=type%>')"></button>
      <input type=hidden name="con<%=id%>_value" >
      <input type=hidden name="con<%=id%>_name" >
      <span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan">
      </span> </td>
	<%} else if(htmltype.equals("3") && ( type.equals("165") || type.equals("167") || type.equals("169"))){ // 增加分权单选字段，人，部门，分部
		String url_tmp = "";
		if(type.equals("165")){
			url_tmp = "/systeminfo/BrowserMain.jsp?url=";
			if(ismain == 1){
				url_tmp += URLEncoder.encode("/hrm/resource/ResourceBrowserByDec.jsp?isbill="+isbill+"&fieldid="+id);
			}else{
				url_tmp += URLEncoder.encode("/hrm/resource/ResourceBrowserByDec.jsp?isdetail=1&isbill="+isbill+"&fieldid="+id);
			}
		}else if(type.equals("167")){
			url_tmp = "/systeminfo/BrowserMain.jsp?url=";
			if(ismain == 1){
				url_tmp += URLEncoder.encode("/hrm/company/DepartmentBrowserByDec.jsp?isbill="+isbill+"&fieldid="+id);
			}else{
				url_tmp += URLEncoder.encode("/hrm/company/DepartmentBrowserByDec.jsp?isdetail=1&isbill="+isbill+"&fieldid="+id);
			}
		}else{
			url_tmp = "/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowserByDec.jsp";
		}
%>
    <td >
      <select class=inputstyle name="con<%=id%>_opt" style="width:150px;" onfocus="changelevel('<%=tmpcount%>')" >
        <option value="1"><%=SystemEnv.getHtmlLabelName(353,user.getLanguage())%></option><!-- 属于 -->
        <option value="2"><%=SystemEnv.getHtmlLabelName(21473,user.getLanguage())%></option><!-- 不属于 -->
      </select>
    </td>
    <td colspan=3> <button type=button  class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowBrowserCustomNew('<%=id%>','<%=url_tmp%>','<%=type%>')"></button>
      <input type=hidden name="con<%=id%>_value" >
      <input type=hidden name="con<%=id%>_name" >
      <span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan">
      </span> </td>
<%} else if(htmltype.equals("3") && ( type.equals("166") || type.equals("168") || type.equals("170"))){ // 增加分权多选字段，人，部门，分部
		String url_tmp = "";
		if(type.equals("166")){
			url_tmp = "/systeminfo/BrowserMain.jsp?url=";
			if(ismain == 1){
				url_tmp += URLEncoder.encode("/hrm/resource/MultiResourceBrowserByDec.jsp?isbill="+isbill+"&fieldid="+id);
			}else{
				url_tmp += URLEncoder.encode("/hrm/resource/MultiResourceBrowserByDec.jsp?isdetail=1&isbill="+isbill+"&fieldid="+id);
			}
		}else if(type.equals("168")){
			url_tmp = "/systeminfo/BrowserMain.jsp?url=";
			if(ismain == 1){
				url_tmp += URLEncoder.encode("/hrm/company/MultiDepartmentBrowserByDecOrder.jsp?isbill="+isbill+"&fieldid="+id);
			}else{
				url_tmp += URLEncoder.encode("/hrm/company/MultiDepartmentBrowserByDecOrder.jsp?isdetail=1&isbill="+isbill+"&fieldid="+id);
			}
		}else{
			url_tmp = "/systeminfo/BrowserMain.jsp?url=/hrm/company/MultiSubcompanyBrowserByDec.jsp";
		}
%>
    <td >
      <select class=inputstyle name="con<%=id%>_opt" style="width:150px;" onfocus="changelevel('<%=tmpcount%>')" >
        <option value="1"><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option><!-- 包含 -->
        <option value="2"><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option><!-- 不包含 -->
      </select>
    </td>
    <td colspan=3> <button type=button  class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowBrowserCustomNew('<%=id%>','<%=url_tmp%>','<%=type%>')"></button>
      <input type=hidden name="con<%=id%>_value" >
      <input type=hidden name="con<%=id%>_name" >
      <span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan">
      </span> </td>

    <%} else if(htmltype.equals("3") && type.equals("57")){ // 增加多部门的处理（包含，不包含）
%>
    <td >
      <select class=inputstyle name="con<%=id%>_opt" style="width:150px;" onfocus="changelevel('<%=tmpcount%>')" >
        <option value="1"><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option><!-- 包含 -->
        <option value="2"><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option><!-- 不包含 -->
      </select>
    </td>
    <td colspan=3> <button type=button  class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowBrowserCustomNew('<%=id%>','/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp','57')"></button>
      <input type=hidden name="con<%=id%>_value" >
      <input type=hidden name="con<%=id%>_name" >
      <span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan">
      </span> </td>
    <%} else if(htmltype.equals("3") && type.equals("17")){ // 增加多人力资源的处理（包含，不包含）
%>
    <td >
      <select class=inputstyle name="con<%=id%>_opt" style="width:150px;" onfocus="changelevel('<%=tmpcount%>')" >
        <option value="1"><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option><!-- 包含 -->
        <option value="2"><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option><!-- 不包含 -->
      </select>
    </td>
    <td colspan=3> <button type=button  class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowBrowserCustomNew('<%=id%>','/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp','<%=type%>')"></button>
      <input type=hidden name="con<%=id%>_value" >
      <input type=hidden name="con<%=id%>_name" >
      <span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan">
      </span> </td>
    <%} else if(htmltype.equals("3") && type.equals("65")){ 
        // modify by mackjoe at 2005-11-24 td2862 增加多角色的处理（包含，不包含）
%>
    <td >
      <select class=inputstyle name="con<%=id%>_opt" style="width:150px;" onfocus="changelevel('<%=tmpcount%>')" >
        <option value="1"><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option><!-- 包含 -->
        <option value="2"><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option><!-- 不包含 -->
      </select>
    </td>
    <td colspan=3> <button type=button  class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowBrowserCustomNew('<%=id%>','/systeminfo/BrowserMain.jsp?url=/hrm/roles/MutiRolesBrowser.jsp','<%=type%>')"></button>
      <input type=hidden name="con<%=id%>_value" >
      <input type=hidden name="con<%=id%>_name" >
      <span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan">
      </span> </td>
    <%} else if(htmltype.equals("3") && type.equals("18")){ // 增加多客户的处理（包含，不包含）
%>
    <td >
      <select class=inputstyle name="con<%=id%>_opt" style="width:150px;" onfocus="changelevel('<%=tmpcount%>')" >
        <option value="1"><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option><!-- 包含 -->
        <option value="2"><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option><!-- 不包含 -->
      </select>
    </td>
     <td colspan=3> <button type=button  class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowBrowserCustomNew('<%=id%>','/systeminfo/BrowserMain.jsp?url=/CRM/data/MutiCustomerBrowser.jsp','<%=type%>')"></button>
      <input type=hidden name="con<%=id%>_value" >
      <input type=hidden name="con<%=id%>_name" >
      <span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan">
      </span> </td>
    <%} else if(htmltype.equals("3") && type.equals("37")){ // 增加多文档的处理（包含，不包含） %>
    <td >
      <select class=inputstyle name="con<%=id%>_opt" style="width:150px;" onfocus="changelevel('<%=tmpcount%>')" >
        <option value="1"><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option><!-- 包含 -->
        <option value="2"><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option><!-- 不包含 -->
      </select>
    </td>
     <td colspan=3> <button type=button  class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowBrowserCustomNew('<%=id%>','/systeminfo/BrowserMain.jsp?url=/docs/docs/MutiDocBrowser.jsp','<%=type%>')"></button>
      <input type=hidden name="con<%=id%>_value" >
      <input type=hidden name="con<%=id%>_name" >
      <span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan">
      </span> </td>
    <%}else if(htmltype.equals("6") ){ // 附件等同于多文档的处理（包含，不包含） %>
        <td >
        <select class=inputstyle name="con<%=id%>_opt" style="width:150px;" onfocus="changelevel('<%=tmpcount%>')" >
          <option value="1"><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option><!-- 包含 -->
          <option value="2"><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option><!-- 不包含 -->
        </select>
      </td>
       <td colspan=3> <button type=button  class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowBrowserCustomNew('<%=id%>','/systeminfo/BrowserMain.jsp?url=/docs/docs/DocBrowser.jsp' ,'<%=type%>')"></button>
        <input type=hidden name="con<%=id%>_value" >
        <input type=hidden name="con<%=id%>_name" >
        <span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan">
        </span> </td>
      <%} else if(htmltype.equals("3")&&type.equals("162")){ // 增加多自定义浏览框的处理（包含，不包含）
%>
    <td >
      <select class=inputstyle name="con<%=id%>_opt" style="width:150px;" onfocus="changelevel('<%=tmpcount%>')" >
        <option value="1"><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option><!-- 包含 -->
        <option value="2"><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option><!-- 不包含 -->
      </select>
    </td>
    <%
	String browserurl = UrlComInfo.getUrlbrowserurl(type) ;
	browserurl = browserurl.trim() + "?type="+dbtype;
    %>
    <td colspan=3> <button type=button  class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowBrowserCustomNew('<%=id%>','<%=browserurl%>',<%=type %>)"></button>
      <input type=hidden name="con<%=id%>_value" >
      <input type=hidden name="con<%=id%>_name" >
      <span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan">
      </span> </td>
    <%} else if(htmltype.equals("3") && type.equals("135")){ // 增加多项目处理（包含，不包含） %>
    <td >
      <select class=inputstyle name="con<%=id%>_opt" style="width:150px;" onfocus="changelevel('<%=tmpcount%>')" >
        <option value="1"><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option><!-- 包含 -->
        <option value="2"><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option><!-- 不包含 -->
      </select>
    </td>
    <td colspan=3> <button type=button  class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowBrowserCustomNew('<%=id%>','/systeminfo/BrowserMain.jsp?url=/proj/data/MultiProjectBrowser.jsp' ,'<%=type%>')"></button>
      <input type=hidden name="con<%=id%>_value" >
      <input type=hidden name="con<%=id%>_name" >
      <span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan">
      </span> </td>
        <%}%>
    </tr>
	<tr style="height:1px"><td colspan=7 class=line1></td></tr>

    <%
 if(linecolor==0) linecolor=1;
          else linecolor=0;}%>

<%--因为当报表是单据的时候，上面的代码本身就可以显示明细字段了。--%>
<%--而如果是表单，则因为表单的明细自动在不同的表里，所以上面的--%>
<%--sql语句查不出明细字段，必须补上下面的代码才行--%>
<%if(isbill.equals("0")){%>

    <%
linecolor=0;
sql="";

/* workflow_fieldlable b 
and  b.langurageid = @language_2
and a.fieldid= b.fieldid
and d.formid = b.formid
by ben 2006-03-27 for td3595
*/
sql = "select t1.fieldid as id,(select distinct fieldname  from workflow_fieldlable t3 where t3.formid = t1.formid and t3.langurageid = "+user.getLanguage() + " and t3.fieldid =t1.fieldid) as name,(select distinct t3.fieldlable  from workflow_fieldlable t3 where t3.formid = t1.formid and t3.langurageid = "+user.getLanguage() + " and t3.fieldid =t1.fieldid) as label,t2.fieldhtmltype as htmltype,t2.childfieldid as childfieldid,t2.type as type,t2.fielddbtype as dbtype from workflow_formfield t1,workflow_formdictdetail t2 where  t2.id = t1.fieldid and t1.formid="+formid + " and (t1.isdetail = '1' or t1.isdetail is not null)";

RecordSet.executeSql(sql);
//tmpcount = 0;
while(RecordSet.next()){
tmpcount += 1;
String id = RecordSet.getString("id");
String childfieldid = Util.null2String(RecordSet.getString("childfieldid"));
%><tr class=title >
    <td>
<%
	if(strReportDspField.indexOf(","+id+",")>-1){
%>
      <input type='checkbox' name='isShow'  value="<%=id%>" checked>
<%
    }
%>
    </td>
    <td>
      <input type='checkbox' name='check_con'  value="<%=id%>">
    </td>
    <td>
      <input type=hidden name="con<%=id%>_id" value="<%=id%>">
      <input type=hidden name="con<%=id%>_ismain" value="0">
      <%
String name = RecordSet.getString("name");
String label = RecordSet.getString("label");

%>
      <%=Util.toScreen("("+SystemEnv.getHtmlLabelName(17463,user.getLanguage())+")"+label,user.getLanguage())%><!-- 明细 -->
      <input type=hidden name="con<%=id%>_colname" value="<%=name%>">
    </td>
    <%
String htmltype = RecordSet.getString("htmltype");
String type = RecordSet.getString("type");
String dbtype = RecordSet.getString("dbtype");

%>
    <input type=hidden name="con<%=id%>_htmltype" value="<%=htmltype%>">
    <input type=hidden name="con<%=id%>_type" value="<%=type%>">
    <%
if((htmltype.equals("1")&& type.equals("1"))||htmltype.equals("2")){
%>
    <td>
      <select class=inputstyle name="con<%=id%>_opt" style="width:150px;" onfocus="changelevel('<%=tmpcount%>')" >
        <option value="1"><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option><!-- 等于 -->
        <option value="2"><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option><!-- 不等于 -->
        <option value="3"><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option><!-- 包含 -->
        <option value="4"><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option><!-- 不包含 -->
      </select>
    </td>
    <td colspan=3>
      <input type=text class=inputstyle style="width: 178px;" size=12 name="con<%=id%>_value"  onfocus="changelevel('<%=tmpcount%>')"  >
    </td>
    <%}
else if(htmltype.equals("1")&& !type.equals("1")){
%>
    <td>
      <select class=inputstyle name="con<%=id%>_opt" style="width:150px;" onfocus="changelevel('<%=tmpcount%>')" >
        <option value="1"><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%></option><!-- 大于 -->
        <option value="2"><%=SystemEnv.getHtmlLabelName(325,user.getLanguage())%></option><!-- 大于或等于 -->
        <option value="3"><%=SystemEnv.getHtmlLabelName(15509,user.getLanguage())%></option><!-- 小于 -->
        <option value="4"><%=SystemEnv.getHtmlLabelName(326,user.getLanguage())%></option><!-- 小于或等于 -->
        <option value="5"><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option><!-- 等于 -->
        <option value="6"><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option><!-- 不等于 -->
      </select>
    </td>
    <td >
      <input type=text class=inputstyle style="width: 178px;" size=12 name="con<%=id%>_value"  onfocus="changelevel('<%=tmpcount%>')" >
    </td>
    <td>
      <select class=inputstyle name="con<%=id%>_opt1" style="width:150px;" onfocus="changelevel('<%=tmpcount%>')" >
        <option value="1"><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%></option><!-- 大于 -->
        <option value="2"><%=SystemEnv.getHtmlLabelName(325,user.getLanguage())%></option><!-- 大于或等于 -->
        <option value="3"><%=SystemEnv.getHtmlLabelName(15509,user.getLanguage())%></option><!-- 小于 -->
        <option value="4"><%=SystemEnv.getHtmlLabelName(326,user.getLanguage())%></option><!-- 小于或等于 -->
        <option value="5"><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option><!-- 等于 -->
        <option value="6"><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option><!-- 不等于 -->
      </select>
    </td>
    <td>
      <input type=text class=inputstyle style="width: 178px;" size=12 name="con<%=id%>_value1"  onfocus="changelevel('<%=tmpcount%>')"  >
    </td>
    <%
}
else if(htmltype.equals("4")){
%>
    <td colspan=4>
    	 <input type=checkbox value=1 name="con<%=id%>_value"  onclick="if(this.checked){this.value='1';changelevel('<%=tmpcount%>');}else{this.value='';changelevel1('<%=tmpcount%>')}">
    </td>
    <%}
else if(htmltype.equals("5")){
%>
    <td>
      <select class=inputstyle name="con<%=id%>_opt" style="width:150px;" onfocus="changelevel('<%=tmpcount%>')" >
        <option value="1"><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option><!-- 等于 -->
        <option value="2"><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option><!-- 不等于 -->
      </select>
    </td>
<%
String selectchange = "";
if(!childfieldid.equals("")&&!childfieldid.equals("0")){//瀛愬瓧娈佃仈鍔?
	selectchange = "changeChildField(this,'"+id+"','"+childfieldid+"');";
	initselectfield += "changeChildField(jQuery('#con"+id+"_value')[0],'"+id+"','"+childfieldid+"');";
}
%>
    <td colspan=3>
      <select notBeauty=true class=inputstyle name="con<%=id%>_value" id="con<%=id%>_value" style="width:150px;"  onfocus="changelevel('<%=tmpcount%>')" onchange="changevalue();<%=selectchange%>">
      	<option value='' ></option>
        <%
char flag=2;
rs.executeProc("workflow_SelectItemSelectByid",""+id+flag+isbill);
while(rs.next()){
	int tmpselectvalue = rs.getInt("selectvalue");
	String tmpselectname = rs.getString("selectname");
	String tempcancel = rs.getString("cancel");
	if("1".equals(tempcancel)){
		continue;
	}
%>
        <option value="<%=tmpselectvalue%>" ><%=Util.toScreen(tmpselectname,user.getLanguage())%></option>
        <%}%>
      </select>
    </td>
    <%} else if(htmltype.equals("3") && !type.equals("165") && !type.equals("166")&& !type.equals("167")&& !type.equals("168")&& !type.equals("169")&& !type.equals("170")&& !type.equals("2")&& !type.equals("4")&& !type.equals("18")&& !type.equals("19")&& !type.equals("17") && !type.equals("37") && !type.equals("65")&& !type.equals("57")&& !type.equals("162")){
%>
    <td>
      <select class=inputstyle name="con<%=id%>_opt" style="width:150px;" onfocus="changelevel('<%=tmpcount%>')" >
        <option value="1"><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option><!-- 等于 -->
        <option value="2"><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option><!-- 不等于 -->
      </select>
    </td>
    <td colspan=3>
         <%
            String browserurl = UrlComInfo.getUrlbrowserurl(type) ;
         	String onclickFun = "";
            if(type.equals("4") && sharelevel <2) {
                if(sharelevel == 1) browserurl = browserurl.trim() + "?sqlwhere=where subcompanyid1 = " + user.getUserSubCompany1() ;
                else browserurl = browserurl.trim() + "?sqlwhere=where id = " + user.getUserDepartment() ;
                onclickFun = "onShowBrowserCustomNew('"+id+"','"+browserurl+"',"+type+")";
            }else if("161".equals(type)){
				browserurl = browserurl.trim() + "?type="+dbtype;
				onclickFun = "onShowBrowserCustomNew('"+id+"','"+browserurl+"',"+type+")";
		    }else if("224".equals(type)||"225".equals(type)||"226".equals(type)||"227".equals(type)){
				browserurl = browserurl.trim() + "?type="+dbtype+"|"+id;
				onclickFun = "onShowBrowserCustomNew('"+id+"','"+browserurl+"',"+type+")";
	    	}else{
		    	 onclickFun = "onShowBrowserCustomNew('"+id+"','"+browserurl+"',"+type+")";
		    }
         %>
		<button type=button tt=1 class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="<%=onclickFun %>"></button>
      	<%--end--%>
      <input type=hidden name="con<%=id%>_value" >
      <input type=hidden name="con<%=id%>_name" >
      <span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan">
      </span> </td>
	  	<%} else if(htmltype.equals("3") && ( type.equals("165") || type.equals("167") || type.equals("169"))){ // 增加分权单选字段，人，部门，分部
		String url_tmp = "";
		if(type.equals("165")){
			url_tmp = "/systeminfo/BrowserMain.jsp?url=";
			url_tmp += URLEncoder.encode("/hrm/resource/ResourceBrowserByDec.jsp?isdetail=1&isbill="+isbill+"&fieldid="+id);
		}else if(type.equals("167")){
			url_tmp = "/systeminfo/BrowserMain.jsp?url=";
			url_tmp += URLEncoder.encode("/hrm/company/DepartmentBrowserByDec.jsp?isdetail=1&isbill="+isbill+"&fieldid="+id);
		}else{
			url_tmp = "/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowserByDec.jsp";
		}
%>
    <td >
      <select class=inputstyle name="con<%=id%>_opt" style="width:150px;" onfocus="changelevel('<%=tmpcount%>')" >
        <option value="1"><%=SystemEnv.getHtmlLabelName(353,user.getLanguage())%></option><!-- 属于 -->
        <option value="2"><%=SystemEnv.getHtmlLabelName(21473,user.getLanguage())%></option><!-- 不属于 -->
      </select>
    </td>
    <td colspan=3> <button type=button  class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowBrowserCustomNew('<%=id%>','<%=url_tmp%>' ,'<%=type%>')"></button>
      <input type=hidden name="con<%=id%>_value" >
      <input type=hidden name="con<%=id%>_name" >
      <span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan">
      </span> </td>
<%} else if(htmltype.equals("3") && ( type.equals("166") || type.equals("168") || type.equals("170"))){ // 增加分权多选字段，人，部门，分部
		String url_tmp = "";
		if(type.equals("166")){
			url_tmp = "/systeminfo/BrowserMain.jsp?url=";
			url_tmp += URLEncoder.encode("/hrm/resource/MultiResourceBrowserByDec.jsp?isdetail=1&isbill="+isbill+"&fieldid="+id);
		}else if(type.equals("168")){
			url_tmp = "/systeminfo/BrowserMain.jsp?url=";
			url_tmp += URLEncoder.encode("/hrm/company/MultiDepartmentBrowserByDec.jsp?isdetail=1&isbill="+isbill+"&fieldid="+id);
		}else{
			url_tmp = "/systeminfo/BrowserMain.jsp?url=/hrm/company/MultiSubcompanyBrowserByDec.jsp";
		}
%>
    <td >
      <select class=inputstyle name="con<%=id%>_opt" style="width:150px;" onfocus="changelevel('<%=tmpcount%>')" >
        <option value="1"><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option><!-- 包含 -->
        <option value="2"><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option><!-- 不包含 -->
      </select>
    </td>
    <td colspan=3> <button type=button  class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowBrowserCustomNew('<%=id%>','<%=url_tmp%>' ,'<%=type%>')"></button>
      <input type=hidden name="con<%=id%>_value" >
      <input type=hidden name="con<%=id%>_name" >
      <span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan">
      </span> </td>
    <%} else if(htmltype.equals("3") &&( type.equals("2") || type.equals("19"))){ // 增加日期和时间的处理（之间）
%>
    <td >
      <select class=inputstyle name="con<%=id%>_opt" style="width:150px;" onfocus="changelevel('<%=tmpcount%>')" >
        <option value="1"><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%></option><!-- 大于 -->
        <option value="2"><%=SystemEnv.getHtmlLabelName(325,user.getLanguage())%></option><!-- 大于或等于 -->
        <option value="3"><%=SystemEnv.getHtmlLabelName(15509,user.getLanguage())%></option><!-- 小于 -->
        <option value="4"><%=SystemEnv.getHtmlLabelName(326,user.getLanguage())%></option><!-- 小于或等于 -->
        <option value="5"><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option><!-- 等于 -->
        <option value="6"><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option><!-- 不等于 -->
      </select>
    </td>
    <td><button type=button  class=Browser  onfocus="changelevel('<%=tmpcount%>')"  
<%if(type.equals("2")){%>
   onclick="onSearchWFDate(con<%=id%>_valuespan,con<%=id%>_value)"
<%}else{%>
 onclick ="onSearchWFTime(con<%=id%>_valuespan,con<%=id%>_value)"
<%}%>
 ></button>
      <input type=hidden name="con<%=id%>_value" >
      <span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan">
      </span> </td>
    <td >
      <select class=inputstyle name="con<%=id%>_opt1" style="width:150px;" onfocus="changelevel('<%=tmpcount%>')" >
        <option value="1"><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%></option><!-- 大于 -->
        <option value="2"><%=SystemEnv.getHtmlLabelName(325,user.getLanguage())%></option><!-- 大于或等于 -->
        <option value="3"><%=SystemEnv.getHtmlLabelName(15509,user.getLanguage())%></option><!-- 小于 -->
        <option value="4"><%=SystemEnv.getHtmlLabelName(326,user.getLanguage())%></option><!-- 小于或等于 -->
        <option value="5"><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option><!-- 等于 -->
        <option value="6"><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option><!-- 不等于 -->
      </select>
    </td>
    <td ><button type=button  class=Browser  onfocus="changelevel('<%=tmpcount%>')"  
<%if(type.equals("2")){%>
   onclick="onSearchWFDate(con<%=id%>_value1span,con<%=id%>_value1)"
<%}else{%>
 onclick ="onSearchWFTime(con<%=id%>_value1span,con<%=id%>_value1)"
<%}%>
 ></button>
      <input type=hidden name="con<%=id%>_value1" >
      <span name="con<%=id%>_value1span" id="con<%=id%>_value1span">
      </span> </td>
    <%}else if(htmltype.equals("3") && type.equals("4")){ // 增加部门的处理（可选择多个部门）
%>
    <td >
      <select class=inputstyle name="con<%=id%>_opt" style="width:150px;" onfocus="changelevel('<%=tmpcount%>')" >
        <option value="1"><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option><!-- 等于 -->
        <option value="2"><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option><!-- 不等于 -->
      </select>
    </td>
    <td colspan=3> <button type=button  class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowBrowserCustomNew('<%=id%>','/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp' ,'<%=type%>')"></button>
      <input type=hidden name="con<%=id%>_value" >
      <input type=hidden name="con<%=id%>_name" >
      <span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan">
      </span> </td>
    <%}else if(htmltype.equals("3") && type.equals("57")){ // 增加多部门的处理（包含，不包含）
%>
    <td >
      <select class=inputstyle name="con<%=id%>_opt" style="width:150px;" onfocus="changelevel('<%=tmpcount%>')" >
        <option value="1"><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option><!-- 包含 -->
        <option value="2"><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option><!-- 不包含 -->
      </select>
    </td>
    <td colspan=3> <button type=button  class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowBrowserCustomNew('<%=id%>','/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp' ,'<%=type%>')"></button>
      <input type=hidden name="con<%=id%>_value" >
      <input type=hidden name="con<%=id%>_name" >
      <span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan">
      </span> </td>
    <%} else if(htmltype.equals("3") && type.equals("17")){ // 增加多人力资源的处理（包含，不包含）
%>
    <td >
      <select class=inputstyle name="con<%=id%>_opt" style="width:150px;" onfocus="changelevel('<%=tmpcount%>')" >
        <option value="1"><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option><!-- 包含 -->
        <option value="2"><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option><!-- 不包含 -->
      </select>
    </td>
    <td colspan=3> <button type=button  class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowBrowserCustomNew('<%=id%>','/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp' ,'<%=type%>')"></button>
      <input type=hidden name="con<%=id%>_value" >
      <input type=hidden name="con<%=id%>_name" >
      <span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan">
      </span> </td>
    <%} else if(htmltype.equals("3") && type.equals("65")){ 
        // modify by mackjoe at 2005-11-24 td2862 增加多角色的处理（包含，不包含）
%>
    <td >
      <select class=inputstyle name="con<%=id%>_opt" style="width:150px;" onfocus="changelevel('<%=tmpcount%>')" >
        <option value="1"><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option><!-- 包含 -->
        <option value="2"><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option><!-- 不包含 -->
      </select>
    </td>
    <td colspan=3> <button type=button  class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowBrowserCustomNew('<%=id%>','/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp' ,'<%=type%>')"></button>
      <input type=hidden name="con<%=id%>_value" >
      <input type=hidden name="con<%=id%>_name" >
      <span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan">
      </span> </td>
    <%} else if(htmltype.equals("3") && type.equals("18")){ // 增加多客户的处理（包含，不包含）
%>
    <td >
      <select class=inputstyle name="con<%=id%>_opt" style="width:150px;" onfocus="changelevel('<%=tmpcount%>')" >
        <option value="1"><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option><!-- 包含 -->
        <option value="2"><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option><!-- 不包含 -->
      </select>
    </td>
    <td colspan=3> <button type=button  class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowBrowserCustomNew('<%=id%>','/systeminfo/BrowserMain.jsp?url=/CRM/data/MutiCustomerBrowser.jsp' ,'<%=type%>')"></button>
      <input type=hidden name="con<%=id%>_value" >
      <input type=hidden name="con<%=id%>_name" >
      <span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan">
      </span> </td>
    <%} else if(htmltype.equals("3") && type.equals("37")){ // 增加多文档的处理（包含，不包含） %>
    <td >
      <select class=inputstyle name="con<%=id%>_opt" style="width:150px;" onfocus="changelevel('<%=tmpcount%>')" >
        <option value="1"><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option><!-- 包含 -->
        <option value="2"><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option><!-- 不包含 -->
      </select>
    </td>
    <td colspan=3> <button type=button  class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowBrowserCustomNew('<%=id%>','/systeminfo/BrowserMain.jsp?url=/docs/docs/MutiDocBrowser.jsp' ,'<%=type%>')"></button>
      <input type=hidden name="con<%=id%>_value"  value="">
      <input type=hidden name="con<%=id%>_name" >
      <span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan">
      </span> </td>
    <%} else if(htmltype.equals("3") && type.equals("162")){ // 增加多自定义浏览框的处理（包含，不包含） %>
    <td >
      <select class=inputstyle name="con<%=id%>_opt" style="width:150px;" onfocus="changelevel('<%=tmpcount%>')" >
        <option value="1"><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option><!-- 包含 -->
        <option value="2"><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option><!-- 不包含 -->
      </select>
    </td>
    <%
		String browserurl = UrlComInfo.getUrlbrowserurl(type) ;
		browserurl = browserurl.trim() + "?type="+dbtype;
    %>
    <td colspan=3> <button type=button  class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowBrowserCustomNew('<%=id%>','<%=browserurl%>',<%=type %>)"></button>
      <input type=hidden name="con<%=id%>_value"  value="">
      <input type=hidden name="con<%=id%>_name" >
      <span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan">
      </span> </td>
    <%}else if(htmltype.equals("3") &&( type.equals("256")|| type.equals("257"))){ //  %>
    <td >
      <select class=inputstyle style="width:150px;" name="con<%=id%>_opt" style="width:100%" onfocus="changelevel('<%=tmpcount%>')" >
        <option value="1"><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option><!-- 包含 -->
        <option value="2"><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option><!-- 不包含 -->
      </select>
    </td>
    <%
		String browserurl = UrlComInfo.getUrlbrowserurl(type) ;
		browserurl = browserurl.trim() + "?type="+dbtype+"_"+type;
    %>
    <td colspan=3> <button type=button  class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowBrowserCustomNew('<%=id%>','<%=browserurl%>',<%=type %>)"></button>
      <input type=hidden name="con<%=id%>_value"  value="">
      <input type=hidden name="con<%=id%>_name" >
      <span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan">
      </span> </td>
    <%}%>
    </tr>
	<tr style="height:1px"><td colspan=7 class=line1></td></tr>

    <%
 if(linecolor==0) linecolor=1;
          else linecolor=0;}%>


<%}%>
  </table>

  	</td>
		</tr>
		</TABLE>
	</td>
	<td></td>
</tr>
<tr>
	<td height="10" colspan="3"></td>
</tr>
</table>
<%for(int i=0;i<iframeList.size();i++){%>
<iframe id="selectChange_<%=iframeList.get(i) %>" frameborder=0 scrolling=no src=""  style="display:none"></iframe>
<%} %>
</FORM>

<script language="javascript">
function changeChildField(obj, fieldid, childfieldid){
    var paraStr = "pageParams=1&fieldid="+fieldid+"&childfieldid="+childfieldid+"&isbill=1&isdetail=0&selectvalue="+obj.value;
    $G("selectChange").src = "/formmode/search/SelectChange.jsp?"+paraStr;
}
function changeChildSelectItemField(obj, fieldid, childfieldid,isinit){
	if(isinit&&isinit==1){//编辑时初始化
		obj = $G("con"+fieldid+"_value");
	}
	if(!obj){
		obj = $G("con"+fieldid+"_value");
	}
    var paraStr = "pageParams=1&fieldid="+fieldid+"&childfieldid="+childfieldid+"&isbill=1&isdetail=0&selectvalue="+obj.value;
    if(isinit&&isinit==1){
    	paraStr = paraStr + "&isinit="+isinit;
    }
    
    var iframe = jQuery("#selectChange_"+fieldid);
    if(iframe.length==0){
    	iframe = jQuery("#selectChange");
    }
    iframe.get(0).src = "/formmode/search/SelectItemChangeByQuery.jsp?"+paraStr;
}

jQuery(document).ready(function(){
	<%=initselectfield%>;
});
function onClear(){
	$("#fromdatespan").html("");
	$("#todatespan").html("");
	$("#modedatacreaterspan").html("");
	$("span[name$='_valuespan']").html("");
	$("span[name$='_value1span']").html("");
	$("input[name$='_value']").val("");
	$("input[name$='_value1']").val("");
	$("input[name$='_name']").val("");
	//清除checkbox
	changeCheckboxStatus(jQuery("input[type='checkbox'][name^='con'],input[type='checkbox'][name='check_con']") ,false);
	var selects = $("select");
	for(var i=0;i<selects.length;i++){
		var objSelect = selects.get(i);
		var text = "";
		if(objSelect.options.length>0){
			objSelect.options[0].selected = true;
			text = objSelect.options[0].text;
		}
		var selshow = $(objSelect).next().find(".sbSelector");
		selshow.attr("title",text);
		selshow.html(text);
	}
}

function changeclick1(){
	var chk = document.SearchForm.modedatacreatedate_check_con;
	changeCheckboxStatus(chk, true);
}
function changeclick2(){
	var chk = document.SearchForm.modedatacreater_check_con;
	changeCheckboxStatus(chk, true);
}
function submit(){
	document.SearchForm.submit();
}

function changevalue(){
/**
	var tempvalue = document.getElementById("neworganizationid").value;
	document.getElementById("con"+tempvalue+"_value").value = "";
	document.getElementById("con"+tempvalue+"_name").value = "";
	document.getElementById("con"+tempvalue+"_valuespan").value = "";
	document.getElementById("con"+tempvalue+"_valuespan").innerText="";
**/
}

function onShowBrowser2(id,url) {
	var url = url + "?selectedids=" + $G("con"+id+"_value").value;
	var id1 = window.showModalDialog(url);
	if (id1 != null && id1 != undefined) {
	    if (wuiUtil.getJsonValueByIndex(id1, 0) != "" && wuiUtil.getJsonValueByIndex(id1, 0) != "0") {
	    	var rid = wuiUtil.getJsonValueByIndex(id1, 0);
	    	var rname = wuiUtil.getJsonValueByIndex(id1, 1);
			if (rname.indexOf(",") == 0) {
				rname = rname.substr(1);
			}
			$G("con"+id+"_valuespan").innerHTML = rname;
			$G("con"+id+"_value").value = rid;
	        $G("con"+id+"_name").value = rname;
	    } else {
	    	$G("con"+id+"_valuespan").innerHTML = "";
	    	$G("con"+id+"_value").value="";
	    	$G("con"+id+"_name").value="";
	    }
	}
}

function onShowBrowser(id,url) {
	var id1 ;
	if(url.indexOf("/MutiResourceBrowser.jsp")!=-1){ 
		id1 = window.showModalDialog(url + "&selectedids=" + $G("con"+id+"_value").value, "", "dialogHeight:600px;dialogwidth:648px");
	}else{
		id1 = window.showModalDialog(url + "&selectedids=" + $G("con"+id+"_value").value);
	}
	if (id1 != null) {
		var rid = wuiUtil.getJsonValueByIndex(id1, 0);
		var rname = wuiUtil.getJsonValueByIndex(id1, 1);
	    if (rid != "" && rid != "0") {
			if (rname.indexOf(",") == 0) {
				rname = rname.substr(1);
			}
			$G("con"+id+"_valuespan").innerHTML = rname
			$G("con"+id+"_value").value=rid
	        $G("con"+id+"_name").value=rname
	    } else {
	    	$G("con"+id+"_valuespan").innerHTML = "";
	    	$G("con"+id+"_value").value="";
	    	$G("con"+id+"_name").value="";
	    }
	}
}

function onShowBrowserCustomNew(id, url, type1) {
	url+="&iscustom=1";
	if (type1 == 256|| type1==257) {
		tmpids = $GetEle("con"+id+"_value").value;
		url = url + "&selectedids=" + tmpids;
	}else if (type1 == 7||type1 == 194||type1 == 165||type1 == 166||type1 == 167||type1 == 168||type1 == 169||type1 == 170||type1 == 23||type1 == 16||type1 == 24){
		
	}else{
		tmpids = $GetEle("con"+id+"_value").value;
		url = url + "|" + id + "&beanids=" + tmpids;
		url = url.substring(0, url.indexOf("url=") + 4) + encodeURI(url.substr(url.indexOf("url=") + 4));
	}
	var dialogurl = url;
	var dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	dialog.URL = dialogurl;
	dialog.callbackfun = function (paramobj, id1) {
		if (id1 != null) {
		if (wuiUtil.getJsonValueByIndex(id1, 0) != "") {
			var ids = doReturnSpanHtml(wuiUtil.getJsonValueByIndex(id1, 0));
			var names = wuiUtil.getJsonValueByIndex(id1, 1);
			var descs = wuiUtil.getJsonValueByIndex(id1, 2);
			if (type1 == 161||type1 == 7||type1 == 194||type1 == 165||type1 == 167||type1 == 169||type1 == 23||type1 == 16||type1 == 24) {
				var href = "";
				if(id1.href&&id1.href!=""){
					href = id1.href+ids;
				}else{
					href = "";
				}
				var hrefstr="";
        		names = names.replace(new RegExp(/(<)/g),"&lt;");
        		names = names.replace(new RegExp(/(>)/g),"&gt;");
				if(href!=''){
					hrefstr=" href='"+href+"' target='_blank' ";
				}
				var sHtml = "<a "+hrefstr+" title='" + names + "'>" + names + "</a>";
				$G("con" + id + "_valuespan").innerHTML = sHtml;
				$G("con" + id + "_value").value = ids;
				$G("con" + id + "_name").value = names;
			}
			else if (type1 == 162||type1 == 166||type1 == 168||type1 == 170||type1 == 57) {
				var sHtml = "";
				var href = wuiUtil.getJsonValueByIndex(id1, 3);
				
				var idArray = ids.split(",");
				var curnameArray = names.split("~~WEAVERSplitFlag~~");
				if(curnameArray.length < idArray.length){
					curnameArray = names.split(",");
				}
				var curdescArray = descs.split(",");

				for ( var i = 0; i < idArray.length; i++) {
					var curid = idArray[i];
					var curname = curnameArray[i];
					var curdesc = curdescArray[i];
					if(curdesc==''||curdesc=='undefined'||curdesc==null){
						curdesc = curname;
					}
					if(curdesc){
						curdesc = curname;
					}
        		    curname = curname.replace(new RegExp(/(<)/g),"&lt;");
        		    curname = curname.replace(new RegExp(/(>)/g),"&gt;");
					if(href == undefined || href=="" ){
						sHtml +=  wrapshowhtml("<a title='" + curdesc + "' >" + curname + "</a>&nbsp",curid,1);
					}else{
						sHtml +=  wrapshowhtml("<a href='"+href+curid+"' target='_blank' title='" + curdesc + "' >" + curname + "</a>&nbsp",curid,1);
					}
				}

				$G("con" + id + "_valuespan").innerHTML = sHtml;
				$G("con" + id + "_value").value = doReturnSpanHtml(wuiUtil.getJsonValueByIndex(id1, 0));
				$G("con" + id + "_name").value = wuiUtil.getJsonValueByIndex(id1, 1);
			}
			else{
				$G("con" + id + "_valuespan").innerHTML =  names ;
				$G("con" + id + "_value").value = ids;
				$G("con" + id + "_name").value = names;
			}
		} else {
			$G("con" + id + "_valuespan").innerHTML = "";
			$G("con" + id + "_value").value = "";
			$G("con" + id + "_name").value = "";
		}
	}
		
	//hoverShowNameSpan(".e8_showNameClass");
	   
	};
	
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(18214,user.getLanguage())%>";//请选择
	dialog.Width = 550 ;
	if(url.indexOf("/MutiResourceBrowser.jsp")!=-1){ 
		dialog.Width=648; 
	}
	dialog.Height = 600;
	dialog.Drag = true;
	dialog.show();

}

function doReturnSpanHtml(obj){
	var t_x = obj.substring(0, 1);
	if(t_x == ','){
		t_x = obj.substring(1, obj.length);
	}else{
		t_x = obj;
	}
	return t_x;
}

function onShowBrowserHrm(id,url) {
	var id1 = window.showModalDialog(url + "&selectedids=" + $G(id).value);
	if (id1 != null) {
		var rid = wuiUtil.getJsonValueByIndex(id1, 0);
		var rname = wuiUtil.getJsonValueByIndex(id1, 1);
	    if (rid != "" && rid != "0") {
			if (rname.indexOf(",") == 0) {
				rname = rname.substr(1);
			}
			$G(id+"span").innerHTML = rname
			$G(id).value=rid
	    } else {
	    	$G(id+"span").innerHTML = "";
	    	$G(id).value="";
	    }
	}
}

function onShowBrowser1(id,url,type1) {
	if (type1 == 1) {
		var id1 = window.showModalDialog(url, "", "dialogHeight:320px;dialogwidth:275px");
		$G("con"+id+"_valuespan").innerHTML = id1;
		$G("con"+id+"_value").value=id1;
	} else if( type1 == 2) {
		var id1 = window.showModalDialog(url, "","dialogHeight:320px;dialogwidth:275px");
		$G("con"+id+"_value1span").innerHTML = id1;
		$G("con"+id+"_value1").value=id1;
	}
}
function changelevel(tmpindex) {
	var chk = document.getElementsByName("check_con")[tmpindex - 1];
	changeCheckboxStatus(chk, true);
}
function changelevel1(tmpindex) {
	var chk = document.getElementsByName("check_con")[tmpindex - 1];
	changeCheckboxStatus(chk, false);
}
jQuery(function($){
	onClear();
	var sbHolderSpan = $(".sbHolder").parent();
	for(var i=0;i<sbHolderSpan.length;i++){
		sbHolderSpan.get(i).onclick = function(){
			setChangelevel(this);
		}
	}
	
	sbHolderSpan.hover(
	  function () {
		var tr = $(this).parent().parent();
	    addClassHover(tr);
	  },
	  function () {
	    var tr = $(this).parent().parent();
	    removeClassHover(tr);
	  }
	);
	
	var text = $("input[type=text]");
	text.hover(
	  function () {
		var tr = $(this).parent().parent();
	    addClassHover(tr);
	  },
	  function () {
	    var tr = $(this).parent().parent();
	    removeClassHover(tr);
	  }
	);
});

function addClassHover(tr){
	tr.addClass("Selected");
	tr.find("td").addClass("e8Selected");
}

function removeClassHover(tr){
	tr.removeClass("Selected");
	tr.find("td").removeClass("e8Selected");
}

function setChangelevel(obj){
	var tr = $(obj).parent().parent();
	var check_con = tr.find("input[name=check_con]");
	if(check_con.length==1){
		changeCheckboxStatus(check_con.get(0), true);
	}
}
</script>

<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/selectDateTime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>

<!-- browser 相关 -->
<script type="text/javascript" src="/formmode/js/modebrow_wev8.js"></script>
<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>
</BODY></HTML>