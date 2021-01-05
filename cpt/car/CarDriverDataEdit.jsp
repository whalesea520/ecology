
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</head>
<% 
if(!HrmUserVarify.checkUserRight("Car:Maintenance",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
   }
%>
<%
String imagefilename = "/images/hdHRM_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(93,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(17631,user.getLanguage());

String needfav ="1";
String needhelp ="";

String sql="";
String id=Util.fromScreen(request.getParameter("id"),user.getLanguage());
sql="select * from CarDriverData where id ="+id ;
RecordSet.executeSql(sql);
RecordSet.next();
String driverid = RecordSet.getString("driverid");
String cartypeid = RecordSet.getString("cartypeid");
String isreception = RecordSet.getString("isreception");
String startDate = RecordSet.getString("startdate");
String startTime = RecordSet.getString("starttime");
String backTime = RecordSet.getString("backtime");
String runkm = RecordSet.getString("runKM");
String startkm = RecordSet.getString("startkm");
String backkm = RecordSet.getString("backkm");
String useperson = RecordSet.getString("useperson");
String usedepartment = RecordSet.getString("usedepartment");
String iscarout = RecordSet.getString("iscarout");
String remark = RecordSet.getString("remark");
String isholiday = RecordSet.getString("isholiday");


String driverName=ResourceComInfo.getResourcename(driverid+"");
String resourceId = Util.null2String(request.getParameter("resourceid"));

ArrayList paraArray = new ArrayList() ;
ArrayList deptArray = new ArrayList() ;



sql="select * from cardriverdatapara where driverdataid = "+ id ;
RecordSet.executeSql(sql);
while(RecordSet.next()){
    paraArray.add(RecordSet.getString("paraid"));
}

deptArray = Util.TokenizerString(usedepartment,",");

%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

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
			
			<TABLE class="Shadow">
			<tr>
			<td valign="top">
			
<form name=frmmain action="CarDriverDataOperation.jsp">
<input type="hidden" name=operation>
<input type="hidden" name=id value=<%=id%>>
<TABLE class=viewform>
  <COLGROUP>
  <COL width="20%"><COL width="30%"><COL width="20%"><COL width="30%">
  <TBODY>
  <TR class=title>
    <TH colSpan=4><%=SystemEnv.getHtmlLabelName(17631,user.getLanguage())%></TH></TR>
  <TR class=spacing>
      <TD class=line1 colSpan=4></TD></TR>
  <TR>
    <TD><%=SystemEnv.getHtmlLabelName(17649,user.getLanguage())%></TD>
    <TD  class=field>
    <button class=Browser onClick="onShowResource()"></button>
	<span id=driveridspan>
    <a href="/hrm/resource/HrmResource.jsp?id=<%=driverid%>"></a><%if(driverid.equals("")){%><IMG src="/images/BacoError_wev8.gif" align="absMiddle"><%}else {%>
    <%=Util.toScreen(driverName,user.getLanguage())%><%}%>
	</span>
	<input type=hidden name="driverid" value="<%=driverid%>">
    <input type=hidden name="driverName" value="<%=driverName%>">
	</TD>

    <td><%=SystemEnv.getHtmlLabelName(17651,user.getLanguage())%></td>
    <td class=field>
        <select name="cartypeid" size=1 style="width:80%">
<%
     sql="select * from cartype";
     RecordSet.executeSql(sql);
     while(RecordSet.next()){
        String tmpcartypeid=RecordSet.getString("id");
        String tmpcartypename=RecordSet.getString("name");
        String selected = "" ;
        if(tmpcartypeid.equals(cartypeid))    selected="selected";
%>      <option value="<%=tmpcartypeid%>" <%=selected%>><%=tmpcartypename%></option>
<%
     }
%>
        </select>
    </td>
  </tr>
  <TR><TD class=Line colspan=4></TD></TR> 
  <tr>  
    <td><%=SystemEnv.getHtmlLabelName(17666,user.getLanguage())%></td>
    <td class=field>
        <input type=radio name="isholiday" value="0" <%if(isholiday.equals("0")){%> checked <%}%>><%=SystemEnv.getHtmlLabelName(225,user.getLanguage())%>
        <input type=radio name="isholiday" value="2" <%if(isholiday.equals("2")){%> checked <%}%>><%=SystemEnv.getHtmlLabelName(17667,user.getLanguage())%>
        <input type=radio name="isholiday" value="1" <%if(isholiday.equals("1")){%> checked <%}%>><%=SystemEnv.getHtmlLabelName(516,user.getLanguage())%>
    </td>
  </TR>
  <TR><TD class=Line colspan=4></TD></TR> 
  <TR>
    <!--TD>回车日期</TD>
    <TD class=Field><BUTTON class=Calendar onclick="getBackdate()"></BUTTON>
    <input type=hidden name="backdate" value="">
    <SPAN id=backdatespan><IMG src="/images/BacoError_wev8.gif" align=absMiddle></SPAN></TD !-->
    <TD><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%>,<%=SystemEnv.getHtmlLabelName(17657,user.getLanguage())%></TD>
	  <TD class="Field"><BUTTON type='button' class="Calendar" id="SelectStartDate" onclick="onShowDate(startdatespan,startdate)"></BUTTON> 
		  <SPAN id="startdatespan"><%if (startDate.equals("")) {%><IMG src="/images/BacoError_wev8.gif" align="absMiddle">
		  <%} else {%><%=startDate%><%}%></SPAN> 
		  <INPUT type="hidden" name="startdate" value=<%=startDate%>>  
		  &nbsp;&nbsp;&nbsp;
		  <BUTTON type='button' class="Clock" id="SelectStartTime" onclick="onWorkFlowShowTime(starttimespan,starttime,1)"></BUTTON>
		  <SPAN id="starttimespan"><%if (startTime.equals("")) {%><IMG src="/images/BacoError_wev8.gif" align="absMiddle">
		  <%} else{%><%=startTime%><%}%></SPAN>
		  <INPUT type="hidden" name="starttime" value=<%=startTime%>></TD>

    <TD><%=SystemEnv.getHtmlLabelName(17658,user.getLanguage())%></TD>
	  <TD class="Field">
		  <BUTTON type='button' class="Clock" id="SelectBackTime" onclick="onWorkFlowShowTime(backtimespan,backtime,1)"></BUTTON>
		  <SPAN id="backtimespan"><%if (backTime.equals("")) {%><IMG src="/images/BacoError_wev8.gif" align="absMiddle"><%}else {%><%=backTime%><%}%></SPAN>
		  <INPUT type="hidden" name="backtime"  value=<%=backTime%>></TD>
  </TR>
  <TR><TD class=Line colspan=4></TD></TR> 
  <TR>
    <TD><%=SystemEnv.getHtmlLabelName(17668,user.getLanguage())%></TD>
    <TD class=Field><INPUT class=inputstyle type=text size=10 name="startkm" onKeyPress="ItemNum_KeyPress()" 
    onBlur="checknumber1(this);checkinput('startkm','startkmspan')" value="<%=startkm%>"> km
    <SPAN id=startkmspan></SPAN></TD>
    <TD><%=SystemEnv.getHtmlLabelName(17669,user.getLanguage())%></TD>
    <TD class=Field><INPUT class=inputstyle type=text size=10 name="backkm" onKeyPress="ItemNum_KeyPress()" 
    onBlur="checknumber1(this);checkinput('backkm','backkmspan')" value="<%=backkm%>"> km
    <SPAN id=backkmspan></SPAN></TD>
  </TR>
  <TR><TD class=Line colspan=4></TD></TR> 
  <TR>
    <TD><%=SystemEnv.getHtmlLabelName(17670,user.getLanguage())%></TD>
          <TD class=Field><BUTTON type='button' class=Browser id="SelectMember" onclick="onShowMultiHrmResourceNeeded('useperson','usepersonspan')"></BUTTON> 
              <SPAN id=usepersonspan>
			   <%if (!useperson.equals("")) {
					ArrayList members = Util.TokenizerString(useperson,",");
					for (int i = 0; i < members.size(); i++) {
				%><A href='/hrm/resource/HrmResource.jsp?id=<%=(String)members.get(i)%>' target="mainFrame"><%=ResourceComInfo.getResourcename((String)members.get(i))%></a>&nbsp;
				<%}
				}%>
			  </SPAN> 
              <INPUT type=hidden name="useperson" value=<%=useperson%>></TD>


    <td><%=SystemEnv.getHtmlLabelName(17671,user.getLanguage())%></td>
               <TD class=Field>
                 <button type='button' class=Browser onClick="onShowDepartment()"></button>
                 <span class=inputstyle id=usedepartmentspan><%if(usedepartment.equals("")){%><IMG src="/images/BacoError_wev8.gif" align="absMiddle"><%}else {%><%=Util.toScreen(DepartmentComInfo.getDepartmentname(usedepartment),user.getLanguage())%><%}%></span>
                 <input class=inputstyle id=department type=hidden name=usedepartment value="<%=usedepartment%>">
               </TD>
  </TR>
  <TR><TD class=Line colspan=4></TD></TR> 
  <tr>
    <td><%=SystemEnv.getHtmlLabelName(17672,user.getLanguage())%></td>
    <td class=field>
        <input type=checkbox name="iscarout" value="1" <%if(iscarout.equals("1")){%> checked <%}%>>
    </td>
    <td><%=SystemEnv.getHtmlLabelName(17673,user.getLanguage())%></td>
    <td class=field>
        <input type=checkbox name="isreception" value="1" <%if(isreception.equals("1")){%> checked <%}%>>
    </td>
  </tr>
  <TR><TD class=Line colspan=4></TD></TR> 
  <tr>
    <td><%=SystemEnv.getHtmlLabelName(17633,user.getLanguage())%></td>
    <td class=field colspan=3>
<%
    sql="select * from carparameter";
    RecordSet.executeSql(sql);
    while(RecordSet.next()){
        String tmpparaid=RecordSet.getString("id");
        String tmpparaname=RecordSet.getString("name");
        String checked = "" ;
        if(paraArray.indexOf(tmpparaid)!=-1)    checked="checked";
%>      <input type=checkbox name="check_para" value="<%=tmpparaid%>" <%=checked%>><%=tmpparaname%>&nbsp;
<%
    }
%>    
    </td>
    
  </tr>
  <TR><TD class=Line colspan=4></TD></TR> 
  <tr>
    <td valign=top><%=SystemEnv.getHtmlLabelName(454,user.getLanguage())%></td>
    <td class=field colspan=3>
    <textarea class=inputstyle cols=50 rows=5 name="remark" style="width:80%"><%=Util.toScreenToEdit(remark,user.getLanguage())%></textarea>
    </td>
  </tr>
  <TR><TD class=Line colspan=4></TD></TR> 
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

<script language=vbs>
sub onShowDepartment(spanname,inputename)
		tmpids = document.all(inputename).value
		id1 = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/cpt/car/UseDepartmentBrowser.jsp?departmentids="&tmpids)
		    if (Not IsEmpty(id1)) then
				if id1(0)<> "" then
					departmentids = id1(0)
					departmentnames = id1(1)
					sHtml = ""
					departmentids = Mid(departmentids,2,len(departmentids))
					document.all(inputename).value= departmentids
					departmentnames = Mid(departmentnames,2,len(departmentnames))
					while InStr(departmentids,",") <> 0
						curid = Mid(departmentids,1,InStr(departmentids,",")-1)
						curname = Mid(departmentnames,1,InStr(departmentnames,",")-1)
						departmentids = Mid(departmentids,InStr(departmentids,",")+1,Len(departmentids))
						departmentnames = Mid(departmentnames,InStr(departmentnames,",")+1,Len(departmentnames))
						sHtml = sHtml&curname&",&nbsp"
					wend
					sHtml = sHtml&departmentnames&"&nbsp"
					document.all(spanname).innerHtml = sHtml
				else
					document.all(spanname).innerHtml ="<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
					document.all(inputename).value=""
				end if
			end if
end sub

sub onShowDepartment()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="&document.frmmain.usedepartment.value)
	if Not isempty(id) then
	if id(0)<> 0 then
	usedepartmentspan.innerHtml = id(1)
	document.frmmain.usedepartment.value=id(0)
	else
	usedepartmentspan.innerHtml = ""
	document.frmmain.usedepartment.value=""
	end if
	end if
end sub

sub onShowResource()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
	if NOT isempty(id) then
	        if id(0)<> "" then
		driveridspan.innerHtml = "<a href='/hrm/resource/HrmResource.jsp?id="&id(0)&"'>"&id(1)&"</a>"
		document.frmmain.driverid.value=id(0)
        document.frmmain.driverName.value=id(1)
		else
		driveridspan.innerHtml = " <IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
		document.frmmain.driverid.value=""
		end if
	end if
end sub
sub onShowMultiHrmResourceNeeded(inputename,spanname)
    tmpids = document.all(inputename).value
    id1 = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids="&tmpids)
        if (Not IsEmpty(id1)) then
        if id1(0)<> "" then
          resourceids = id1(0)
          resourcename = id1(1)
          sHtml = ""
          resourceids = Mid(resourceids,2,len(resourceids))
          document.all(inputename).value= resourceids
          resourcename = Mid(resourcename,2,len(resourcename))
          while InStr(resourceids,",") <> 0
            curid = Mid(resourceids,1,InStr(resourceids,",")-1)
            curname = Mid(resourcename,1,InStr(resourcename,",")-1)
            resourceids = Mid(resourceids,InStr(resourceids,",")+1,Len(resourceids))
            resourcename = Mid(resourcename,InStr(resourcename,",")+1,Len(resourcename))
            sHtml = sHtml&"<a href=/hrm/resource/HrmResource.jsp?id="&curid&">"&curname&"</a>&nbsp"
          wend
          sHtml = sHtml&"<a href=/hrm/resource/HrmResource.jsp?id="&resourceids&">"&resourcename&"</a>&nbsp"
          document.all(spanname).innerHtml = sHtml
          
        else
          document.all(spanname).innerHtml ="<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
          document.all(inputename).value=""
        end if
         end if
end sub

</script>

<script language=javascript>
 function onSave(){
	if(check_form(document.frmmain,'startdate,starttime,backtime,startkm,backkm,usedepartment')){
	 	document.frmmain.operation.value="edit";
		document.frmmain.submit();
	}
 }
 function onDelete(){
		if(isdel()) {
			document.frmmain.operation.value="delete";
			document.frmmain.submit();
		}
}
 </script>
 </TBODY></TABLE>
</BODY>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
<SCRIPT language="javascript"  src="/js/selectDateTime_wev8.js"></script>
</HTML>
