
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.*,weaver.file.*"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RecordSet1" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="ExcelFile" class="weaver.file.ExcelFile" scope="session"/>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%
if(!HrmUserVarify.checkUserRight("HrmScheduleMaintanceAdd:Add" , user)) {
    response.sendRedirect("/notice/noright.jsp") ; 
    return ; 
} 
String isclose = Util.null2String(request.getParameter("isclose"));
String isDialog = Util.null2String(request.getParameter("isdialog"));
String orgtype = Util.null2String(request.getParameter("type"),"com") ;
String orgid = Util.null2String(request.getParameter("id")) ;
String subcompanyid = Util.null2String(request.getParameter("subcompanyid"));
String departmentid = Util.null2String(request.getParameter("departmentid"));
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
			
			function jsSubCompanySubmint(e, datas, name){
				document.frmmain.enctype="multipart/form-data";
				var subcompanyid = document.frmmain.subcompanyid.value;
				document.frmmain.action="HrmScheduleMonthAdd.jsp?subcompanyid="+subcompanyid
				document.frmmain.submit();
			}
		</script>
	</head>
<%
String msg = Util.null2String(request.getParameter("msg")) ;
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

String sql="";
if(supids.endsWith(",")){
    supids=supids.substring(0,supids.length()-1);
	//workflowid=5 and
    sql="select * from hrmschedulediff where workflowid=5 and (diffscope=0 or (diffscope>0 and subcompanyid="+subid+") or (diffscope=2 and subcompanyid in("+supids+")))";

}
else
    sql="select * from hrmschedulediff where workflowid=5 and (diffscope=0 or (diffscope>0 and subcompanyid="+subid+"))";
RecordSet.executeSql(sql);
Calendar today = Calendar.getInstance();
String currentyear= Util.add0(today.get(Calendar.YEAR), 4);
String currentmonth= Util.add0(today.get(Calendar.MONTH), 2);


String imagefilename = "/images/hdSystem_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(19397,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(82,user.getLanguage()) ;
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
RCMenu += "{"+SystemEnv.getHtmlLabelName(17416,user.getLanguage())+"Excel"+SystemEnv.getHtmlLabelName(64,user.getLanguage())+" , /weaver/weaver.file.ExcelOut,ExcelOut} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<%if(!msg.equals("")){out.print("<font color=red><b>!"+SystemEnv.getHtmlLabelName(Integer.parseInt(msg),user.getLanguage())+"</b></font>");}%>
<iframe id="ExcelOut" name="ExcelOut" border=0 frameborder=no noresize=NORESIZE style="display: none"></iframe>
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
<FORM style="MARGIN-TOP: 0px" name=frmmain id=frmmain method=post enctype="multipart/form-data" action="HrmScheduleMonthOperation.jsp">
<input type=hidden id="operation" name="operation" value="add">
<input type=hidden name="departmentid" value="<%=departmentid%>">
<input type=hidden name="type" value="<%=orgtype%>">
<input type=hidden name="id" value="<%=orgid%>">
<input type=hidden name="isdialog" value="1">
<wea:layout type="2col" attributes="{'expandAllGroup':'true'}">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(15880,user.getLanguage())+SystemEnv.getHtmlLabelName(106,user.getLanguage())%>'>
	  <%if(orgtype.equals("com")){%>
	  <wea:item><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></wea:item>
	  <wea:item>
	  	<brow:browser viewType="0" name="subcompanyid" browserValue='<%=subcompanyid %>' 
	  		browserurl="/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/company/SubcompanyBrowser.jsp?selectedids="
        hasInput="true" isSingle="false" hasBrowser="true" isMustInput='2' width="150px" _callback="jsSubCompanySubmint"
        completeUrl="/data.jsp?type=164" browserSpanValue='<%=orgname %>'>
   		</brow:browser>
	  </wea:item>
	  <%}else{%>
	  <wea:item><%=SystemEnv.getHtmlLabelName(18939,user.getLanguage())%></wea:item>
	  <wea:item><%=orgname%></wea:item>
	  <%}%>
	  <wea:item><%=SystemEnv.getHtmlLabelName(15880,user.getLanguage())+SystemEnv.getHtmlLabelName(6076,user.getLanguage())%></wea:item>
	  <wea:item>
      <select name="theyear" style="width: 80px">
          <%for(int y=1909;y<2100;y++){%>
          <option value="<%=y%>" <%if(currentyear.equals(""+y)){%>selected<%}%>><%=y%></option>
          <%}%>
      </select> <%=SystemEnv.getHtmlLabelName(445,user.getLanguage())%>
      <select name="themonth" style="width: 80px">
          <option value="01" <%if(currentmonth.equals("01")){%>selected<%}%>>01</option>
          <option value="02" <%if(currentmonth.equals("02")){%>selected<%}%>>02</option>
          <option value="03" <%if(currentmonth.equals("03")){%>selected<%}%>>03</option>
          <option value="04" <%if(currentmonth.equals("04")){%>selected<%}%>>04</option>
          <option value="05" <%if(currentmonth.equals("05")){%>selected<%}%>>05</option>
          <option value="06" <%if(currentmonth.equals("06")){%>selected<%}%>>06</option>
          <option value="07" <%if(currentmonth.equals("07")){%>selected<%}%>>07</option>
          <option value="08" <%if(currentmonth.equals("08")){%>selected<%}%>>08</option>
          <option value="09" <%if(currentmonth.equals("09")){%>selected<%}%>>09</option>
          <option value="10" <%if(currentmonth.equals("10")){%>selected<%}%>>10</option>
          <option value="11" <%if(currentmonth.equals("11")){%>selected<%}%>>11</option>
          <option value="12" <%if(currentmonth.equals("12")){%>selected<%}%>>12</option>
      </select> <%=SystemEnv.getHtmlLabelName(6076,user.getLanguage())%>
	  </wea:item>
		<%if(orgtype.equals("com")){%>
    <wea:item><%=SystemEnv.getHtmlLabelName(16699,user.getLanguage())%></wea:item>
    <wea:item><input class=inputstyle type=file  name="excelfile" size=40>&nbsp;&nbsp;<button Class=AddDoc type=button onclick="loadexcel(this)"><%=SystemEnv.getHtmlLabelName(18596,user.getLanguage())%></button></wea:item>
		<%}%>
	</wea:group>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(6138,user.getLanguage())%>' attributes="{'groupOperDisplay':'none'}">
		<wea:item attributes="{'isTableList':'true'}">
			<%
				String attr = "{'cols':'"+(RecordSet.getCounts()+1)+"'}";
			%>
			<wea:layout type="table" attributes='<%=attr %>'>
				<wea:group context="" attributes="{'groupDisplay':'none','cws':'10%'}">
					<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(15880,user.getLanguage())+SystemEnv.getHtmlLabelName(106,user.getLanguage())%></wea:item>
			    <%
					ExcelFile.init() ;
			 		ExcelFile.setFilename(orgname+currentmonth+SystemEnv.getHtmlLabelName(6076,user.getLanguage())+SystemEnv.getHtmlLabelName(15880,user.getLanguage())+SystemEnv.getHtmlLabelName(563,user.getLanguage())) ;
			    ExcelStyle est = ExcelFile.newExcelStyle("Header") ;
			    est.setGroundcolor(ExcelStyle.WeaverHeaderGroundcolor) ;
			   	est.setFontcolor(ExcelStyle.WeaverHeaderFontcolor) ;
			   	est.setFontbold(ExcelStyle.WeaverHeaderFontbold) ;
			   	est.setAlign(ExcelStyle.WeaverHeaderAlign) ;
			   	ExcelSheet es = ExcelFile.newExcelSheet(orgname+currentmonth+SystemEnv.getHtmlLabelName(6076,user.getLanguage())+SystemEnv.getHtmlLabelName(15880,user.getLanguage())+SystemEnv.getHtmlLabelName(563,user.getLanguage())) ;
			  	ExcelRow er = es.newExcelRow() ;
			    er.addStringValue("id","Header") ;
			    er.addStringValue("name","Header") ;
			    while(RecordSet.next()){
					er.addStringValue(RecordSet.getString("diffname"),"Header") ;
					%>
    			<wea:item type="thead"><%=RecordSet.getString("diffname")%></wea:item>
    			<%} es.addExcelRow(er) ; %>
	
					<%
						if(orgtype.equals("com"))
						RecordSet1.executeSql("select * from hrmresource where status>-1 and status<4 and subcompanyid1="+orgid+" order by dsporder,lastname");
						else{
						String deptids=SubCompanyComInfo.getDepartmentTreeStr(orgid);
					     deptids=orgid+","+deptids;
					     deptids=deptids.substring(0,deptids.length()-1);
						RecordSet1.executeSql("select * from hrmresource where status>-1 and status<4 and departmentid in("+deptids+") order by dsporder,lastname");
						}
						while(RecordSet1.next()){
						ExcelRow er1 = es.newExcelRow () ;
					    String lastname=RecordSet1.getString("lastname");
					    String id=RecordSet1.getString("id");
					    er1.addStringValue(id) ;
					    er1.addStringValue(lastname) ;
					    es.addExcelRow(er1) ;
					
					%>
					    <wea:item><%=lastname%></wea:item>
					     <%RecordSet.beforFirst();while(RecordSet.next()){
					     String type=RecordSet.getString("id");%>
					    <wea:item><input size=10 class=InputStyle name=<%=id+"_"+type%> onKeyPress='ItemNum_KeyPress()' onBlur='checknumber1(this);' ></wea:item>
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
	var checkStr = "";
	<%if(orgtype.equals("com")){%>
		checkStr = "subcompanyid";
	<%}else {%>
		checkStr = "departmentid";
	<%}%>
	
	if(check_form(document.frmmain,checkStr)){
	  document.frmmain.submit();
	}


}

function loadexcel() {
  frmmain.operation.value="importnew";
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
