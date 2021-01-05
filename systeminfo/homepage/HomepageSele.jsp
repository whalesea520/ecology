
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<html>
  <head>
    <link href="/css/Weaver_wev8.css" type=text/css rel=stylesheet>
  </head>  
<body>

<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(1500,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(172,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
	RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:onSave(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;

	RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:goBack(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
    
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<%
	int subCompanyId=user.getUserSubCompany1();		
%>
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
		<TABLE class="Shadow">
			<tr>
				<td valign="top">	
				<form name="frmAdd" method="post" action="HomepageSeleOpreate.jsp?subCompanyId=<%=subCompanyId%>">
				 <input name="method" type="hidden">
				 <TABLE class=ListStyle cellspacing=1>
					<COLGROUP>
					<COL width="30%">
					<COL width="30%">
					<COL width="20%">
                    <COL width="20%">

                    <TR class=Header>
						<TH colspan=4><%=SystemEnv.getHtmlLabelName(19420,user.getLanguage())%></TH>
					</TR>

					<%
					String isAppoint="false";
					String appointHp="select infoid from hpsubcompanyappiont where subcompanyid="+subCompanyId;	
					int appointHpId=-1;
					rs.executeSql(appointHp);
					if(rs.next()) {
						appointHpId=Util.getIntValue(rs.getString(1));


						rs1.executeSql("select * from hpinfo where id="+appointHpId);
						if (rs1.next()) {
							isAppoint="true";
							String infoname=Util.null2String(rs1.getString("infoname"));
							String infodesc=Util.null2String(rs1.getString("infodesc"));

					%>
							<TR class="DataDark">
									<td><%=infoname%></td>
									<td><%=infodesc%></td>					
									<td><input type=radio name="rdiSele1" value="<%=appointHpId%>"  checked disabled> <input type="hidden" value="<%=appointHpId%>" name="rdiSele"></td>
                                    <td><a href="javascript:doPrivew('<%=appointHpId%>')"><%=SystemEnv.getHtmlLabelName(221,user.getLanguage())%></a></td>
                            </TR>
					<%}							
					} else {
							String userUseHp="select infoid from hpuserselect where userid="+user.getUID();
							int userUseHpId=-1;
							rs.executeSql(userUseHp);
							if(rs.next()) userUseHpId=Util.getIntValue(rs.getString(1));

							if(userUseHpId==-1) userUseHpId=1;


							int subcompanyid=user.getUserSubCompany1();
							String strSql="select * from hpinfo where (subcompanyid=0 or subcompanyid="+subcompanyid+") and (isuse='1' or isuse='2')";

							//System.out.println(strSql);
							rs.executeSql(strSql);
							int i=1;
							while(rs.next()){
								int infoid=Util.getIntValue(rs.getString("id"));
								String infoname=Util.null2String(rs.getString("infoname"));
								String infodesc=Util.null2String(rs.getString("infodesc"));
								i++;								
						   %>

							<TR class="<%if(i%2==0) out.println("DataDark"); else out.println("DataLight");%>">
								<td><%=infoname%></td>
								<td><%=infodesc%></td>					
								<td><input type=radio name="rdiSele" value="<%=infoid%>" <%if(userUseHpId==infoid) out.println("checked");%>></td>
                                <td><a href="javascript:doPrivew('<%=infoid%>')"><%=SystemEnv.getHtmlLabelName(221,user.getLanguage())%></a></td>
                            </TR>
						<%}
					}%>			
				</TABLE>
				</form>
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
</body>
</html>
<SCRIPT LANGUAGE="JavaScript">

function onSave(){		
	frmAdd.method.value="save";
	frmAdd.submit();
}
function goBack(){      
   window.location='/systeminfo/menuconfig/CustomSetting.jsp';
}
function doPrivew(hpid){
      openFullWindowForXtable("/homepage/Homepage.jsp?hpid="+hpid+"&opt=privew&subCompanyId=<%=subCompanyId%>");
}
</SCRIPT>