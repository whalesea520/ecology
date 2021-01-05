
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="FormManager" class="weaver.workflow.form.FormManager" scope="page"/>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>
<%
String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(19018,user.getLanguage());//车辆使用情况
String needfav ="1";
String needhelp ="";
int fg=0;
if(!(request.getParameter("fg")==null)){
    fg=Integer.parseInt(Util.null2String(request.getParameter("fg")));
}
String carId =  Util.null2String(request.getParameter("carId"));
String dialog=Util.null2String(request.getParameter("dialog"),"0");
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
//返回
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/car/CarInfoView.jsp?fg="+fg+"&flag=1&id="+carId+"&dialog="+dialog+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
if(fg==2){
//RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/car/CarUseInfo.jsp,_self} " ;
//RCMenuHeight += RCMenuHeightStep ;
}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
	<td height="10" colspan="3"></td>
</tr>
<tr>
	<td ></td>
	<td valign="top">
		<%
		String C2 = "";
        if ((RecordSet.getDBType()).equals("oracle")) {
        	C2 += "(select id,requestid,to_number(carId) as carId,to_number(driver) as driver,to_number(userid) as userid,startdate,starttime,enddate,endtime,cancel from CarUseApprove";
        } else {
        	C2 += "(select id,requestid,carId,driver,userid,startdate,starttime,enddate,endtime,cancel from CarUseApprove";
        }
        RecordSet.executeSql("select id,formid from carbasic where formid!=163 and isuse = 1");
        while (RecordSet.next()) {
        	String mainid = RecordSet.getString("id");
        	String _formid = RecordSet.getString("formid");
        	String _tablename = FormManager.getTablename(_formid);
        	C2 += " union all select id,requestid,";
        	Map _map = new HashMap();
        	rs2.executeSql("select carfieldid,modefieldid,fieldname from mode_carrelatemode c,workflow_billfield b where c.modefieldid=b.id and mainid="+mainid);
        	while (rs2.next()) {
        		String carfieldid = rs2.getString("carfieldid");
        		String modefieldid = rs2.getString("modefieldid");
        		String fieldname = rs2.getString("fieldname");
        		_map.put(carfieldid,fieldname);
        	}
        	if ((RecordSet.getDBType()).equals("oracle")) {
        		C2 += "to_number("+Util.null2s(Util.null2String(_map.get("627")),"0") +") as carId,";
            	C2 += "to_number("+Util.null2s(Util.null2String(_map.get("628")),"0") +") as driver,";
            	C2 += "to_number("+Util.null2s(Util.null2String(_map.get("629")),"0") +") as userid,";
        	} else {
        		C2 += Util.null2s(Util.null2String(_map.get("627")),"0") +" as carId,";
	        	C2 += Util.null2s(Util.null2String(_map.get("628")),"0") +" as driver,";
	        	C2 += Util.null2s(Util.null2String(_map.get("629")),"0") +" as userid,";

        	}
        	C2 += Util.null2s(Util.null2String(_map.get("634")),"''") +" as startDate,";
        	C2 += Util.null2s(Util.null2String(_map.get("635")),"''") +" as startTime,";
        	C2 += Util.null2s(Util.null2String(_map.get("636")),"''") +" as endDate,";
        	C2 += Util.null2s(Util.null2String(_map.get("637")),"''") +" as endTime,";
        	C2 += Util.null2s(Util.null2String(_map.get("639")),"'0'") +" as cancel";
        	C2 += " from " + _tablename;
        }
        C2 += ")";
		
		int perpage = 10;
		String backFields = "t1.*";
		String sqlFrom = " from "+C2+" t1,workflow_requestbase t2";
		String SqlWhere = "where t1.carId = "+carId+" and t1.requestid=t2.requestid and t2.workflowid not in (select workflowid from carbasic where isuse=0) and t2.currentnodetype<>0 ";
		String tableString=""+
			  "<table  pagesize=\""+perpage+"\" tabletype=\"none\">"+
			  "<sql backfields=\""+backFields+"\" sqlform=\""+sqlFrom+"\" sqlprimarykey=\"id\" sqlsortway=\"Desc\" sqldistinct=\"true\" sqlwhere=\""+Util.toHtmlForSplitPage(SqlWhere)+"\"/>"+
			  "<head>"+//车牌                 
					  "<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(21028,user.getLanguage())+"\" column=\"carId\"   target=\"_self\" linkkey=\"id\" linkvaluecolumn=\"carId\"   href=\"/car/CarInfoView.jsp?flag=2&amp;fg="+fg+"\" transmethod=\"weaver.car.CarInfoComInfo.getCarNo\" />"+
					  //请求
					  "<col width=\"30%\"  text=\""+SystemEnv.getHtmlLabelName(648,user.getLanguage())+"\" column=\"requestid\" orderkey=\"t1.requestid\" transmethod=\"weaver.workflow.request.RequestComInfo.getRequestname\"/>"+
					  //状态
					  "<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(602,user.getLanguage())+"\" column=\"requestid\" orderkey=\"t2.requestid\" transmethod=\"weaver.workflow.request.RequestComInfo.getRequestStatus\"/>"+
					  //开始时间
					  "<col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(742,user.getLanguage())+"\"  column=\"startDate\" orderkey=\"startDate\" />"+ 
					  //结束时间
					  "<col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(743,user.getLanguage())+"\"  column=\"endDate\" orderkey=\"endDate\" />"+ 
			  "</head>"+
			  "</table>";
		%>
		<TABLE class=Shadow>
		<tr>
			<td valign="top"><wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" isShowTopInfo="true"/></td>
		</tr>
		</TABLE>
	</td>
	<td></td>
</tr>
<tr>
	<td height="10" colspan="3"></td>
</tr>
</table>
<%if ("1".equals(dialog)) {%>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout type="2col">
			<wea:group context="">
				<wea:item type="toolbar"><!-- 关闭 -->
					<input type="button"
						value="<%=SystemEnv.getHtmlLabelName(309, user.getLanguage())%>"
						id="zd_btn_cancle" class="zd_btn_cancle" onclick="closePrtDlgARfsh()">
				</wea:item>
			</wea:group>
		</wea:layout>
	</div>
<%}%>
</body>
</html>
<script language="javascript">
function goback(){
 window.location.href="/car/CarInfoView.jsp?flag=1&id=2&dialog=<%=dialog%>";
}
function closePrtDlgARfsh(){
	window.parent.closeWinAFrsh();
}
</script>
