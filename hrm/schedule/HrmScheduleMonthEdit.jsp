
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.*"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RecordSet1" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RecordSet2" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%
if(!HrmUserVarify.checkUserRight("HrmScheduleMaintanceAdd:Add" , user)) {
    response.sendRedirect("/notice/noright.jsp") ; 
    return ; 
} 
String isclose = Util.null2String(request.getParameter("isclose"));
String isDialog = Util.null2String(request.getParameter("isdialog"));
String subcompanyid = Util.null2String(request.getParameter("subcompanyid"));
String departmentid = Util.null2String(request.getParameter("departmentid"));
String theyear = Util.null2String(request.getParameter("year")) ;
String themonth = Util.null2String(request.getParameter("month")) ;
String orgtype = Util.null2String(request.getParameter("type")) ;
String f_flag = (subcompanyid.length() == 0 && departmentid.length() == 0 ) ? "1" : "0";
if(departmentid.length()>0){
	orgtype = "dept";
}else{
	orgtype = "com";
}
String orgid = Util.null2String(request.getParameter("id")) ;
%>

<HTML>
	<HEAD>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
		<script type="text/javascript">
			var parentWin = parent.parent.getParentWindow(parent);
			var dialog = parent.parent.getDialog(parent);
			if("<%=isclose%>"=="1"){
				parentWin.subcompanyid = "<%=subcompanyid%>";
				parentWin.departmentid = "<%=departmentid%>";
				parentWin.closeDialog();	
			}
		</script>
	</head>
<%
StringBuffer _sql = new StringBuffer();
if(orgtype.equals("dept")){
	_sql.append("select a.theyear,a.themonth,a.subcompanyid1,a.departmentid from (")
	.append(" select row_number()over(order by a.theyear,a.themonth) as num, a.theyear,a.themonth,b.subcompanyid1,b.departmentid")
	.append(" from hrmschedulemonth a left join hrmresource b on a.hrmid = b.id ")
	.append(" group by a.theyear,a.themonth,b.subcompanyid1,b.departmentid ) a ")
	.append(" where a.num  = ").append(orgid);
}else{
	_sql.append("select a.theyear,a.themonth,a.subcompanyid1 from (")
	.append(" select row_number()over(order by a.theyear,a.themonth) as num, a.theyear,a.themonth,b.subcompanyid1")
	.append(" from hrmschedulemonth a left join hrmresource b on a.hrmid = b.id ")
	.append(" group by a.theyear,a.themonth,b.subcompanyid1 ) a ")
	.append(" where a.num  = ").append(orgid);
}
RecordSet.executeSql(_sql.toString());
if(RecordSet.next()){
	theyear = Util.null2String(RecordSet.getString("theyear"));
	themonth = Util.null2String(RecordSet.getString("themonth"));
	subcompanyid = Util.null2String(RecordSet.getString("subcompanyid1"));
	if(orgtype.equals("dept")){
		departmentid = Util.null2String(RecordSet.getString("departmentid"));
	}
}

String subid=subcompanyid;
String orgname="";

if(departmentid.length()==0){
	orgid = subcompanyid;
	orgtype = "com";
   orgname=SubCompanyComInfo.getSubCompanyname(orgid);
}else{
	orgid = departmentid;
	orgtype = "dept";
   subid=DepartmentComInfo.getSubcompanyid1(orgid);
   orgname=DepartmentComInfo.getDepartmentname(orgid);
}
String supids=SubCompanyComInfo.getAllSupCompany(subid);
String deptids="";
String sql="";
if(supids.endsWith(",")){
    supids=supids.substring(0,supids.length()-1);
	//workflowid=5 and 
    sql="select * from hrmschedulediff where workflowid=5 and (diffscope=0 or (diffscope>0 and subcompanyid="+subid+") or (diffscope=2 and subcompanyid in("+supids+")))";

}
else
    sql="select * from hrmschedulediff where workflowid=5 and (diffscope=0 or (diffscope>0 and subcompanyid="+subid+"))";
    //System.out.println(sql);
    String sql1;
     if(orgtype.equals("com"))
      sql1="select * from hrmschedulemonth a,hrmresource b where a.hrmid=b.id  and b.subcompanyid1="+orgid+"  and a.theyear='"+
            theyear+"' and a.themonth='"+themonth+"'";
    else{
     deptids=SubCompanyComInfo.getDepartmentTreeStr(orgid);
     deptids=orgid+","+deptids;
     deptids=deptids.substring(0,deptids.length()-1);
     sql1="select * from hrmschedulemonth a,hrmresource b where a.hrmid=b.id  and b.departmentid in("+deptids+")  and a.theyear='"+
            theyear+"' and a.themonth='"+themonth+"'";
     }
    RecordSet.executeSql(sql);
    RecordSet1.executeSql(sql1);
Calendar today = Calendar.getInstance();
String currentyear= Util.add0(today.get(Calendar.YEAR), 4);
String currentmonth= Util.add0(today.get(Calendar.MONTH), 2);


String imagefilename = "/images/hdSystem_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(19397,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(93,user.getLanguage()) ;
String needfav ="1";
String needhelp ="";
%>
<BODY>
		<%if("1".equals(isDialog)){ %>
			<div class="zDialog_div_content">
		<%} %>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:history.back(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<FORM style="MARGIN-TOP: 0px" name=frmmain id=frmmain method=post action="HrmScheduleMonthOperation.jsp">
<input type=hidden name="operation" value="update">
<input type=hidden name="theyear" value="<%=theyear%>">
<input type=hidden name="themonth" value="<%=themonth%>">
<input type=hidden name="type" value="<%=orgtype%>">
<input type=hidden name="id" value="<%=orgid%>">
<input type=hidden name="f_flag" value="<%=f_flag%>">
<input type=hidden name="subcompanyid" value="<%=subcompanyid%>">
<input type=hidden name="departmentid" value="<%=departmentid%>">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type=button class="e8_btn_top" onclick="onSubmit();" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>"></input>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<wea:layout type="2col" attributes="{'expandAllGroup':'true'}">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(15880,user.getLanguage())+SystemEnv.getHtmlLabelName(106,user.getLanguage())%>'>
		<wea:item><%if(orgtype.equals("com")){%><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%><%}else{%><%=SystemEnv.getHtmlLabelName(18939,user.getLanguage())%><%}%></wea:item>
		<wea:item><%=orgname%></wea:item>
	  <wea:item><%=SystemEnv.getHtmlLabelName(15880,user.getLanguage())+SystemEnv.getHtmlLabelName(6076,user.getLanguage())%></wea:item>
	  <wea:item>
    	<%=theyear+SystemEnv.getHtmlLabelName(445,user.getLanguage())+themonth+SystemEnv.getHtmlLabelName(6076,user.getLanguage()) %>
	  </wea:item>
	</wea:group>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(6138,user.getLanguage())%>' attributes="{'groupOperDisplay':'none'}">
		<wea:item attributes="{'isTableList':'true'}">
			<%
				String attr = "{'cols':'"+(RecordSet.getCounts()+1)+"'}";
			%>
			<wea:layout type="table" attributes='<%=attr %>'>
				<wea:group context="" attributes="{'groupDisplay':'none','cws':'10%'}">
					<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(15880,user.getLanguage())+SystemEnv.getHtmlLabelName(106,user.getLanguage())%></wea:item>
			    <%while(RecordSet.next()){%>
			    <wea:item type="thead"><%=RecordSet.getString("diffname")%></wea:item>
			    <%} %>
			    <%
						if(orgtype.equals("com"))
						RecordSet2.executeSql("select * from hrmresource where status>-1 and status<4 and subcompanyid1="+orgid+" order by dsporder,lastname");
						else{
						RecordSet2.executeSql("select * from hrmresource where status>-1 and status<4 and departmentid in("+deptids+") order by dsporder,lastname");
						}
					
						while(RecordSet2.next()){
					    String lastname=RecordSet2.getString("lastname");
					    String id=RecordSet2.getString("id");
					%>
			    <wea:item><%=lastname%></wea:item>
			     <%RecordSet.beforFirst();while(RecordSet.next()){
			     String type=RecordSet.getString("id");
			     RecordSet1.beforFirst();
			     String val="";
			     while(RecordSet1.next()){
			         if(RecordSet1.getString("hrmid").equals(id)&&RecordSet1.getString("difftype").equals(type)){
			           val= RecordSet1.getString("hours");
			           break;
			         }
			     }
			     %>
			    <wea:item><input size=10 class=InputStyle name=<%=id+"_"+type%> onKeyPress='ItemNum_KeyPress()' onBlur='checknumber1(this);'  <%if(!val.equals("")){%>value=<%=val%><%}%>></wea:item>
			     <%}%>
					<%}%>
				</wea:group>
			</wea:layout>
		</wea:item>		
	</wea:group>
</wea:layout>
</FORM>
<script language="javascript">
function onSubmit() {
   document.frmmain.submit();

}
</script>
<%if("1".equals(isDialog)){ %>
	</div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout type="2col">
	    	<wea:group context="">
		    	<wea:item type="toolbar">
		    		<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" class="e8_btn_cancel" onclick="dialog.closeByHand();">
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
</BODY>
</HTML>
