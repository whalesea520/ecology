<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif" ; 
String titlename = SystemEnv.getHtmlLabelName(21609,user.getLanguage()); 
String needfav = "1" ; 
String needhelp = "" ; 

String subcompanyid = Util.null2String(request.getParameter("subcompanyid"));
if(subcompanyid.length()==0)subcompanyid="0";
String companyid = Util.null2String(request.getParameter("companyid"));
if(companyid.equals("0")) subcompanyid = companyid;
String showname = "";
if(!subcompanyid.equals("0")) showname = SubCompanyComInfo.getSubCompanyname(subcompanyid);
else showname = CompanyComInfo.getCompanyname("1");
%>
<script type="text/javascript">
jQuery(document).ready(function(){
<%if(showname.length()>0){%>
 parent.setTabObjName('<%=showname%>')
 <%}%>
});
</script>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(HrmUserVarify.checkUserRight("LeaveTypeColor:All",user)) { 
RCMenu += "{"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+",javascript:onEdit(),_self} " ; 
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+SystemEnv.getHtmlLabelName(495,user.getLanguage())+",javascript:ondelete(),_self} " ; 
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(21671 , user.getLanguage())+",javascript:onSyn(),_self} " ; 
RCMenuHeight += RCMenuHeightStep ;
}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<%if(HrmUserVarify.checkUserRight("LeaveTypeColor:All", user)){ %>
				<input type=button class="e8_btn_top" onclick="onEdit();" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>"></input>
				<input type=button class="e8_btn_top" onclick="onSyn();" value="<%=SystemEnv.getHtmlLabelName(21671,user.getLanguage())%>"></input>
				<input type=button class="e8_btn_top" onclick="ondelete();" value="<%=SystemEnv.getHtmlLabelName(32757, user.getLanguage())%>"></input>
			<%} %>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<wea:layout type="table" needImportDefaultJsAndCss="false" attributes="{'cols':'3','cws':'5%,45%,50%'}">
	<wea:group context="" attributes="{'groupDisplay':'none'}">
    <wea:item type="thead"><input type=checkbox name=checkbox value="" onclick="checkall(this)"></wea:item>
    <wea:item type="thead"><%=SystemEnv.getHtmlLabelName(1881,user.getLanguage())%></wea:item>
    <wea:item type="thead"><%=SystemEnv.getHtmlLabelName(16071,user.getLanguage())%></wea:item>
<%
    String leavetypeid = "";
    String otherleavetypeid = "";
    String sql = "select * from workflow_billfield where billid = 180 and (fieldname = 'leaveType' or fieldname = 'otherLeaveType') ";
    RecordSet.executeSql(sql);
    while(RecordSet.next()){
      if(RecordSet.getString("fieldname").toLowerCase().equals("leavetype")) leavetypeid = RecordSet.getString("id");
      if(RecordSet.getString("fieldname").toLowerCase().equals("otherleavetype")) otherleavetypeid = RecordSet.getString("id");
    }

	sql = "select fieldid,selectvalue,selectname,a.id,b.id as colorid,itemid,color,subcompanyid from (select fieldid,selectvalue,selectname,id from workflow_SelectItem where isbill=1 and fieldid in (select id from workflow_billfield where billid = 180 and (fieldname = 'leaveType' or fieldname = 'otherLeaveType')) ) a left join hrmleavetypecolor b on a.id = b.itemid and subcompanyid = " + subcompanyid + " order by fieldid asc,selectvalue asc";
	RecordSet.executeSql(sql);
	
	while(RecordSet.next()){
		String selectname =RecordSet.getString("selectname");
		String color=Util.null2String(RecordSet.getString("color"));
		String id = Util.null2String(RecordSet.getString("colorid"));
		if(RecordSet.getString("fieldid").equals(leavetypeid)&&RecordSet.getString("selectvalue").equals("4")) continue;
        if(color.equals("")) color = "#FF0000";
		%>		
    <wea:item><input type="checkbox" id="periodbox" name="periodbox" value='<%=id%>'></wea:item>
    <wea:item><%=selectname%></A></wea:item>
    <wea:item><span style="width:16px;height:8px;display:inline-block;background:<%=color%>"></span></wea:item>
<%}%>
</wea:group>
</wea:layout>
</BODY>
<script language="javascript">
function onEdit(){
   location = "LeaveTypeColorEdit.jsp?subcompanyid=<%=subcompanyid%>";
}
function onSyn(){
   var v = document.getElementsByName("periodbox");
   var ids = "";
   var flag = false;
   for(var i=0;i<v.length;i++){
      if(v[i].checked == true) {
         if(v[i].value!="") ids = ids + v[i].value + ",";
         flag = true;
      }   
   }
   if(ids=="" && !flag){
      window.top.dialog.alert("<%=SystemEnv.getHtmlLabelName(21677,user.getLanguage())%>");
      return false;
   }else{
     if(ids=="" && flag) ids = "-1,";
     if(confirm("<%=SystemEnv.getHtmlLabelName(21669,user.getLanguage())%>")){
       location.href="/hrm/schedule/LeaveTypeColorOperation.jsp?operation=syn&subcompanyid=<%=subcompanyid%>&ids="+ids;       
     }   
  }
}
function checkall(obj){
	jQuery(document).find("input[name=periodbox]").each(function(){
		changeCheckboxStatus(this,obj.checked);
	})
}
function ondelete(){
   var v = document.getElementsByName("periodbox");
   var ids = "";
   var flag = false;
   for(var i=0;i<v.length;i++){
      if(v[i].checked == true) {
         if(v[i].value!="") ids = ids + v[i].value + ",";
         flag = true;
      }
   }
   if(ids=="" && !flag){
      window.top.dialog.alert("<%=SystemEnv.getHtmlLabelName(15445,user.getLanguage())%>");
      return false;
   }else{
    if(ids=="" && flag) ids = "-1,";
    if(confirm("<%=SystemEnv.getHtmlLabelName(15459,user.getLanguage())%>")){
       if(confirm("<%=SystemEnv.getHtmlLabelName(18260,user.getLanguage())%>")){   
          location.href="/hrm/schedule/LeaveTypeColorOperation.jsp?operation=syndelete&subcompanyid=<%=subcompanyid%>&ids="+ids;       
       }else{
          location.href="/hrm/schedule/LeaveTypeColorOperation.jsp?operation=delete&subcompanyid=<%=subcompanyid%>&ids="+ids;       
       }
    }
   }  
}
</script>
</HTML>
