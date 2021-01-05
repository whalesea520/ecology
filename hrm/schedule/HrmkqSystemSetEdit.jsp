
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<%
if(!HrmUserVarify.checkUserRight("HrmkqSystemSetEdit:Edit" , user)) {
    response.sendRedirect("/notice/noright.jsp") ; 
    return ; 
} 
%>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</head>
<%
RecordSet.executeProc("HrmkqSystemSet_Select","");
RecordSet.next();

String tosomeone = RecordSet.getString("tosomeone") ; //收件人地址
String timeinterval = Util.null2String(RecordSet.getString("timeinterval")) ; //数据采集时间间隔(分钟)
String getdatatype = Util.null2String(RecordSet.getString("getdatatype")) ; //数据采集方式
String getdatavalue = Util.null2String(RecordSet.getString("getdatavalue")) ; //各个方式的值
String avgworkhour = Util.null2String(RecordSet.getString("avgworkhour")) ; //平均每月工作时间(小时)
int salaryenddate = Util.getIntValue(RecordSet.getString("salaryenddate"),31) ; //薪资计算截至日期(包含当天，号)
String signIpScope = Util.null2String(RecordSet.getString("signIpScope")) ; //签到签退ip

if( getdatatype.equals("") ) getdatatype = "1" ;

String imagefilename = "/images/hdSystem_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(774,user.getLanguage()) ;
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<FORM style="MARGIN-TOP: 0px" name=frmmain id=frmmain method=post action="HrmkqSystemSetOperation.jsp">
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
<td height="0" colspan="3"></td>
</tr>
<tr>
<td ></td>
<td valign="top">
<TABLE class=Shadow>
<tr>
<td valign="top">
			<TABLE class=ViewForm>
				<COLGROUP>
                <COL width="20%">
                <COL width="80%">
                <TBODY> 
				<TR class=Title> 
				  <TH colSpan=2><%=SystemEnv.getHtmlLabelName(16743,user.getLanguage())%></TH>
				</TR>
				<TR class=Spacing style="height:2px"> 
				  <TD class=Line1 colSpan=2></TD>
				</TR>
				<tr>
				  <td><%=SystemEnv.getHtmlLabelName(16745,user.getLanguage())%></td>
				  <td class=Field> 
					<input  accesskey=Z name=tosomeone id=tosomeone onchange='checkinput("tosomeone","tosomeoneImage")' value="<%=Util.toScreenToEdit(tosomeone,user.getLanguage())%>" maxlength="50" style="width :50%" class=InputStyle>
					<SPAN id=tosomeoneImage>
<%if(tosomeone.equals("")){%>
					<IMG src = "/images/BacoError_wev8.gif" align=absMiddle>
<%}%>
					</SPAN><%=SystemEnv.getHtmlLabelName(2089,user.getLanguage())%>
				  </td>
				</tr>				
				<TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
			   </TBODY> 
			  </TABLE>
			  <br>			  
			  <TABLE class=ViewForm>
				<COLGROUP>
                <COL width="20%">
                <COL width="80%">
                <TBODY> 
				<TR class=Title> 
				  <TH colSpan=2><%=SystemEnv.getHtmlLabelName(18781,user.getLanguage())%></TH>
				</TR>
				<TR class=Spacing style="height:2px"> 
				  <TD class=Line1 colSpan=2></TD>
				</TR>	
                 <tr>
                  <td><%=SystemEnv.getHtmlLabelName(18780,user.getLanguage())%></td>
				  <td class=Field> 
					<select class=inputstyle name="getdatatype" onChange="showType()">
                      <option value="1" <%if(getdatatype.equals("1")){%>selected<%}%>>510(<%=SystemEnv.getHtmlLabelName(18783,user.getLanguage())%>)</option>
                      <option value="2" <%if(getdatatype.equals("2")){%>selected<%}%>>350(<%=SystemEnv.getHtmlLabelName(18784,user.getLanguage())%>)</option>
                    </select>
				  </td>
				</tr>
                <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 	
                <tr id = getdatatype510 <%if(!getdatatype.equals("1")) {%> style="display:none"<%}%>>	
                <td>COM <%=SystemEnv.getHtmlLabelName(18782,user.getLanguage())%></td>
                <td class=Field>
				  <span id="getdatatype510span" <%if(!getdatatype.equals("1")) {%> style="display:none"<%}%>>
                   <select class=inputstyle name="getdatavalue1">
                      <option value="1" <%if(getdatavalue.equals("1")) {%> selected <%}%>>COM 1</option>
                      <option value="2" <%if(getdatavalue.equals("2")) {%> selected <%}%>>COM 2</option>
                      <option value="3" <%if(getdatavalue.equals("3")) {%> selected <%}%>>COM 3</option>
                      <option value="4" <%if(getdatavalue.equals("4")) {%> selected <%}%>>COM 4</option>
                    </select>
                   </span>
                 </td>
				</tr>
                <tr id = getdatatype350 <%if(!getdatatype.equals("2")) {%> style="display:none"<%}%>>	
                <td>IP <%=SystemEnv.getHtmlLabelName(110,user.getLanguage())%></td>
                <td class=Field>
				  <span id="getdatatype350span" <%if(!getdatatype.equals("2")) {%> style="display:none"<%}%>>
                   <textarea class=Inputstyle name="getdatavalue2"
                   rows="4" cols="40" style="width:80%" ><%=getdatavalue%></textarea><%=SystemEnv.getHtmlLabelName(18785,user.getLanguage())%>
                   </span>
                </td>
				</tr>
                <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
                <tr>				  <td><%=SystemEnv.getHtmlLabelName(16744,user.getLanguage())%>(<%=SystemEnv.getHtmlLabelName(15049,user.getLanguage())%>)</td>
				  <td class=Field> 
					<input accesskey=Z name=timeinterval id=timeinterval onBlur='checkcount1(this);checkinput("timeinterval","timeintervalImage")' value="<%=timeinterval%>" maxlength="50" style="width :50%" onKeyPress="ItemCount_KeyPress()"  class=InputStyle>
					<SPAN id=timeintervalImage>
<%if(timeinterval.equals("")){%>
					<IMG src = "/images/BacoError_wev8.gif" align=absMiddle>
<%}%>
					</SPAN>
				  </td>
				</tr>
                <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
				</TBODY> 
			  </TABLE>
              <br>
              <TABLE class=ViewForm>
				<COLGROUP>
                <COL width="20%">
                <COL width="80%">
                <TBODY> 
				<TR class=Title> 
				  <TH colSpan=2><%=SystemEnv.getHtmlLabelName(18786,user.getLanguage())%></TH>
				</TR>
				<TR class=Spacing style="height:2px"> 
				  <TD class=Line1 colSpan=2></TD>
				</TR>
				<tr>
				  <td><%=SystemEnv.getHtmlLabelName(18787,user.getLanguage())%>(<%=SystemEnv.getHtmlLabelName(391,user.getLanguage())%>)</td>
				  <td class=Field> 
					<input  accesskey=Z name=avgworkhour id=avgworkhour onBlur='checkinput("avgworkhour","avgworkhourimage")' value="<%=Util.toScreenToEdit(avgworkhour,user.getLanguage())%>" maxlength="50" style="width :50%" class=InputStyle>
					<SPAN id=avgworkhourimage>
<%if(avgworkhour.equals("")){%>
					<IMG src = "/images/BacoError_wev8.gif" align=absMiddle>
<%}%>
					</SPAN><%=SystemEnv.getHtmlLabelName(391,user.getLanguage())%>
				  </td>
				</tr>				
				<TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
                <tr>
				  <td><%=SystemEnv.getHtmlLabelName(18788,user.getLanguage())%>(<%=SystemEnv.getHtmlLabelName(18789,user.getLanguage())%>)</td>
				  <td class=Field> 
					<select class=inputstyle name="salaryenddate">
                    <% for(int i=1 ; i<=31 ; i++) { 
                            String dataselected = "" ;
                            if(i == salaryenddate) dataselected = "selected" ;
                    %>
                      <option value="<%=i%>" <%=dataselected%>><%=i%></option>
                    <% } %>
                      </select>
				  </td>
				</tr>				
				<TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
			   </TBODY> 
			  </TABLE>
              <br>
              <TABLE class=ViewForm>
				<COLGROUP>
                <COL width="20%">
                <COL width="80%">
                <TBODY> 
				<TR class=Title> 
				  <TH colSpan=2><%=SystemEnv.getHtmlLabelName(20044,user.getLanguage())%></TH>
				</TR>
				<TR class=Spacing style="height:2px"> 
				  <TD class=Line1 colSpan=2></TD>
				</TR>
				<tr>
				  <td><%=SystemEnv.getHtmlLabelName(20045,user.getLanguage())%></td>
				  <td class=Field> 
					<input name=signIpScope id=signIpScope onBlur='checkinput("signIpScope","signIpScopeImage")' value="<%=signIpScope%>" size=80 maxlength=200  class=InputStyle><SPAN id=signIpScopeImage>
<%if(signIpScope.equals("")){%>					
						<IMG src = "/images/BacoError_wev8.gif" align=absMiddle>
<%}%>	
					</SPAN>
					<br><%=SystemEnv.getHtmlLabelName(15196,user.getLanguage())%>：10.*.*.*;10.16.0.12;10.16.0.13-10.16.0.18
				  </td>
				</tr>				
				<TR style="height:1px"><TD class=Line colSpan=2></TD></TR>  
			   </TBODY> 
			  </TABLE>

		    </td>
		  </tr>
	</TABLE>
</td>
<td></td>
</tr>
<tr>
<td height="0" colspan="3"></td>
</tr>
</table>
</FORM>
<script language="javascript">
function onSubmit() {
   if(check_form(document.frmmain,'to,timeinterval')){
   document.frmmain.submit();
   }
}

function showType(){
    getdatatypelist = window.document.frmmain.getdatatype;
    if(getdatatypelist.value==1){
        getdatatype510.style.display='';
        getdatatype510span.style.display ='';
        getdatatype350.style.display='none';
        getdatatype350span.style.display ='none';
    }
    if(getdatatypelist.value==2){
        getdatatype510.style.display='none';
        getdatatype510span.style.display ='none';
        getdatatype350.style.display='';
        getdatatype350span.style.display ='';
    }
}
</script>
</BODY>
</HTML>