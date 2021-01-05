
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="SMSXML" class="weaver.servicefiles.SMSXML" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</head>
<%
if(true){
	response.sendRedirect("/sms/SmsService.jsp") ;
	return ;
}
if(!HrmUserVarify.checkUserRight("ServiceFile:Manage",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}

String imagefilename = "/images/hdSystem_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(23664,user.getLanguage());
String needfav ="1";
String needhelp ="";

String constructclass = Util.null2String(SMSXML.getConstructClass());
ArrayList propertyArr = SMSXML.getPropertyArr();
ArrayList valueArr = SMSXML.getValueArr();
Hashtable dataHST = new Hashtable();
for(int i=0;i<propertyArr.size();i++){
    String propertyS = (String)propertyArr.get(i);
    String valueS = (String)valueArr.get(i);
    dataHST.put(propertyS,valueS);
}

boolean isGenaral = true;
String type = "";
String host = "";
String port = "";
String dbname = "";
String username = "";
String password = "";
String sql = "";
if(constructclass.equals("weaver.sms.JdbcSmsService")){
    isGenaral = true;
    type = (String)dataHST.get("type");
    host = (String)dataHST.get("host");
    port = (String)dataHST.get("port");
    dbname = (String)dataHST.get("dbname");
    username = (String)dataHST.get("username");
    password = (String)dataHST.get("password");
    sql = (String)dataHST.get("sql");
}else{
    isGenaral = false;
}

%>

<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<FORM style="MARGIN-TOP: 0px" name=frmMain method=post action="XMLFileOperation.jsp">
<input type="hidden" name=operation  value="sms">
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
	<td height="10" colspan="3"></td>
</tr>
<tr>
	<td valign="top" colspan="3">
		<TABLE class=Shadow>
		<tr>
		<td valign="top">
			  <TABLE class=ViewForm>
				<COLGROUP> <COL width="20%"> <COL width="80%">
				<TBODY>
					
				<TR class=Title>
				  <TH colSpan=2><%=titlename%></TH>
				</TR>
				<TR class=Spacing>
				  <TD class=Line1 colSpan=2></TD>
				</TR>
				<tr>
				  <td><%=SystemEnv.getHtmlLabelName(599,user.getLanguage())%></td>
				  <td class=Field>
				  	<select id="interfacetype" name="interfacetype" onchange="typeChange(this.value)">
				  		<option value=1 <%if(isGenaral){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(23684,user.getLanguage())%></option>
				  		<option value=2 <%if(!isGenaral){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(23685,user.getLanguage())%></option>
				  	</select>
				  </td>
				</tr>
				<TR style="height:1px"><TD class=Line colSpan=3></TD></TR>
				<tr>
				  <td><%=SystemEnv.getHtmlLabelName(23683,user.getLanguage())%></td>
				  <td class=Field>
				  	<input class="inputstyle" type=text id="constructclass" name="constructclass" size=50 value="<%=constructclass%>" <%if(isGenaral){%>disabled<%}%>>
				  </td>
				</tr>
				<TR style="height:1px"><TD class=Line colSpan=3></TD></TR>
				
				<tr><td colSpan=3>
					<DIV id="DIV_1" <%if(isGenaral){%>style="display:'';"<%}else{%>style="display:none;"<%}%>>
						<table class=ViewForm width="100%">
							<COL width="20%">
							<COL width="80%">
							<tr>
								<td><%=SystemEnv.getHtmlLabelName(15025,user.getLanguage())%></td>
								<td class=Field>
									<select id="type" name="type">
										<option value="sqlserver" <%if(type.equals("sqlserver")){%>selected<%}%>>sqlserver2000</option>
										<option value="sqlserver2005" <%if(type.equals("sqlserver2005")){%>selected<%}%>>sqlserver2005</option>
										<option value="sqlserver2008" <%if(type.equals("sqlserver2008")){%>selected<%}%>>sqlserver2008</option>
										<option value="oracle" <%if(type.equals("oracle")){%>selected<%}%>>oracle</option>
										<option value="mysql" <%if(type.equals("mysql")){%>selected<%}%>>mysql</option>
										<option value="db2" <%if(type.equals("db2")){%>selected<%}%>>db2</option>
									</select>
								</td>
							</tr>
							<TR style="height:1px"><TD class=Line colSpan=3></TD></TR>
							<tr>
								<td><%=SystemEnv.getHtmlLabelName(2071,user.getLanguage())%>ip</td>
								<td class=Field>
									<input class="inputstyle" type=text size=50 id="host" name="host" value="<%=host%>">
								</td>
							</tr>
							<TR style="height:1px"><TD class=Line colSpan=3></TD></TR>
							<tr>
								<td><%=SystemEnv.getHtmlLabelName(18782,user.getLanguage())%></td>
								<td class=Field>
									<input class="inputstyle" type=text size=50 id="port" name="port" value="<%=port%>">
								</td>
							</tr>
							<TR style="height:1px"><TD class=Line colSpan=3></TD></TR>
							<tr>
								<td><%=SystemEnv.getHtmlLabelName(15026,user.getLanguage())%></td>
								<td class=Field>
									<input class="inputstyle" type=text size=50 id="dbname" name="dbname" value="<%=dbname%>">
								</td>
							</tr>
							<TR style="height:1px"><TD class=Line colSpan=3></TD></TR>
							<tr>
								<td><%=SystemEnv.getHtmlLabelName(2024,user.getLanguage())%></td>
								<td class=Field>
									<input class="inputstyle" type=text size=50 id="username" name="username" value="<%=username%>">
								</td>
							</tr>
							<TR style="height:1px"><TD class=Line colSpan=3></TD></TR>
							<tr>
								<td><%=SystemEnv.getHtmlLabelName(409,user.getLanguage())%></td>
								<td class=Field>
									<input class="inputstyle" type=text size=50 id="password" name="password" value="<%=password%>">
								</td>
							</tr>
							<TR style="height:1px"><TD class=Line colSpan=3></TD></TR>
							<tr>
								<td valign="top"><%=SystemEnv.getHtmlLabelName(23686,user.getLanguage())%></td>
								<td class=Field>
									<textarea rows=4 cols=68 id="sql" name="sql"><%=sql%></textarea>
								</td>
							</tr>
							<TR style="height:1px"><TD class=Line colSpan=3></TD></TR>
						</table>
					</DIV>
					
					<DIV id="DIV_2" <%if(isGenaral){%>style="display:none;"<%}else{%>style="display:'';"<%}%>>
					<table id=propertyTable class=liststyle width="100%">
					
					<COL width="30%">
					<COL width="60%">
					<COL width="10%">
					<tr class="Header">
						<TH><%=SystemEnv.getHtmlLabelName(713,user.getLanguage())%></TH>
						<TH><%=SystemEnv.getHtmlLabelName(19113,user.getLanguage())%></TH>
						<TH><a href="#" onclick="addProperty()"><%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(713,user.getLanguage())%></a></TH>
					</tr>
					<%
					int propertynum = 0;
					for(int i=0;i<propertyArr.size();i++){
       		  propertynum++;
        		String propertyS = (String)propertyArr.get(i);
        		String valueS = (String)dataHST.get(propertyS);
         		if(propertynum%2==1){
        		%>
        		<tr class="datalight">
        		<%
            }else{
        		%>
        		<tr class="datadark">    
        		<%
            }
      	    %>
					  <td>
				  		<input class="inputstyle" type=text id="property_<%=propertynum%>" name="property_<%=propertynum%>" value="<%=propertyS%>">
				 	  </td>
				 	  <td>
				 	 		<input class="inputstyle" type=text size=50 id="value_<%=propertynum%>" name="value_<%=propertynum%>" value="<%=valueS%>">
				 	  </td>
				 	  <td><a href="#" onclick="deleteProperty(<%=propertynum%>)"><%=SystemEnv.getHtmlLabelName(15504,user.getLanguage())%></a></td>
					</tr>
        	<%}%>
        	<input type="hidden" id="propertynum" name="propertynum" value="<%=propertynum%>">
			  	</table>
			  	</DIV>
			  </td></tr>

<tr>
<td colSpan="8">
<table class=ReportStyle>
<TBODY>
<TR><TD>
<B><%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%>：&nbsp;</B>
<BR>
1、<%=SystemEnv.getHtmlLabelName(23964,user.getLanguage())%>；
<BR>
2、<%=SystemEnv.getHtmlLabelName(23965,user.getLanguage())%>；
<BR>
3、<%=SystemEnv.getHtmlLabelName(23966,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(23967,user.getLanguage())%>；
<BR>
4、<%=SystemEnv.getHtmlLabelName(23968,user.getLanguage())%>；
<BR>
5、<%=SystemEnv.getHtmlLabelName(23969,user.getLanguage())%>。
</TD>
</TR>
</TBODY>
</table>
</td>
</tr>
        
				</TBODY>
			  </TABLE>
			  
		</td>
		</tr>
		</TABLE>
	</td>
</tr>
<tr>
	<td height="10" colspan="3"></td>
</tr>
</table>
  </FORM>
</BODY>
<script language="JavaScript" src="/js/addRowBg_wev8.js" >
</script>
<script language="javascript">
function onSubmit(){
    interfacetype = document.getElementById("interfacetype").value;
    if(interfacetype==2){
        constructclass = document.getElementById("constructclass").value;
        if(constructclass=="weaver.sms.JdbcSmsService"){
            alert("该接口类是通用接口类，请重新设置接口类");
            document.getElementById("constructclass").value="";
            return;
        }
    }
    frmMain.submit();
}
function addProperty(){
    document.getElementById("propertynum").value = document.getElementById("propertynum").value*1 + 1;
    nowrowindex = document.getElementById("propertynum").value;
    objTable = document.getElementById("propertyTable");
    oRow = objTable.insertRow();
    rowColor1 = getRowBg();
    for(j=0; j<3; j++){
        oCell = oRow.insertCell();
        oCell.style.height=24;
        oCell.style.background=rowColor1;
        switch(j){
            case 0:
                var oDiv = document.createElement("div");
                var sHtml = "<input class='inputstyle' type=text id='property_"+nowrowindex+"' name='property_"+nowrowindex+"'>";
                oDiv.innerHTML = sHtml;
                oCell.appendChild(oDiv);
                break;
            case 1:
                var oDiv = document.createElement("div");
                var sHtml = "<input class='inputstyle' type=text size=50 id='value_"+nowrowindex+"' name='value_"+nowrowindex+"'>";
                oDiv.innerHTML = sHtml;
                oCell.appendChild(oDiv);
                break;
            case 2:
                var oDiv = document.createElement("div");
                var sHtml = "<a href='#' onclick='deleteProperty("+nowrowindex+")'><%=SystemEnv.getHtmlLabelName(15504,user.getLanguage())%></a>";
                oDiv.innerHTML = sHtml;
                oCell.appendChild(oDiv);
                break;
        }
    }
}
function deleteProperty(rowindex){
    document.getElementById("property_"+rowindex).value="";
    document.getElementById("value_"+rowindex).value="";
}

function typeChange(changeValue){
    if(changeValue==1){
        document.getElementById("constructclass").value = "weaver.sms.JdbcSmsService";
        document.getElementById("constructclass").disabled = true;
        document.getElementById("DIV_1").style.display = "";
        document.getElementById("DIV_2").style.display = "none";
    }else if(changeValue==2){
        if(<%=isGenaral%>)
            document.getElementById("constructclass").value = "";
        else
            document.getElementById("constructclass").value = "<%=constructclass%>";
        document.getElementById("constructclass").disabled = false;
        document.getElementById("DIV_1").style.display = "none";
        document.getElementById("DIV_2").style.display = "";
    }
}
</script>

</HTML>
