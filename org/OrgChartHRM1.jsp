<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.systeminfo.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet2" class="weaver.conn.RecordSet" scope="page" />
<HTML>
<HEAD>
<LINK href="/css/Weaver_wev8.css" rel="STYLESHEET" type="text/css">
<LINK href="/css/rp_wev8.css" rel="STYLESHEET" type="text/css">
<SCRIPT language=VBS>
Sub window_onload()
	wait.style.display="none"
	On Error Resume Next
	Baco.Refresh.focus
End Sub
</SCRIPT>
</HEAD>
<%
boolean isHr = false;
if(!HrmUserVarify.checkUserRight("HrmResourceAdd:Add",user)) {
  isHr = true;
}
String fnarightlevel = HrmUserVarify.getRightLevel("FnaTransaction:All",user) ;

Calendar today = Calendar.getInstance();
String currentdate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
                     Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
                     Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;
                     
String imagefilename = "/images/hdHRMCard_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(562,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%
int companyid = Util.getIntValue(request.getParameter("companyid"),1);
String departids="\"\"";


RecordSet.executeProc("HrmSubCompany_SByCompanyID",""+companyid);

int subcompanycount = RecordSet.getCounts();
int clientwidth = 125*subcompanycount;

int top = 210;
int cellHeight = 66;
int cellWidth = 105;
int cellWidth2 = 420;
int lineHeight1 = 7;
int lineHeight2 = 73;
int lineWidth = 5;
int cellSpace = 20;
int linestep = 17;


String charttype = Util.null2String(request.getParameter("charttype"));
String indicate = Util.null2String(request.getParameter("indicate"));

String emptype_e = Util.null2String(request.getParameter("emptype_e"));
String emptype_c = Util.null2String(request.getParameter("emptype_c"));
String emptype_s = Util.null2String(request.getParameter("emptype_s"));
String emptype_t = Util.null2String(request.getParameter("emptype_t"));
String empstatus = Util.null2String(request.getParameter("empstatus"));

if(empstatus.equals(""))    empstatus="1" ;
if(charttype.equals(""))
	charttype = "H";
if(indicate.equals(""))
	indicate = "H";
%>

<DIV class="HdrProps">

</DIV>
<FORM action="OrgChartHRM.jsp" id=Baco method=post>
<DIV id=wait style="filter:alpha(opacity=30); height:100%; width:100%">
<TABLE width="100%" height="100%">
	<TR><TD align=center style="font-size: 36pt;"><%=SystemEnv.getHtmlLabelName(562,user.getLanguage())%>...</TD></TR>
</TABLE>


</DIV>
<DIV class="Btnbar">
<BUTTON accesskey=R class="btnRefresh" id=Refresh type=submit><U>R</U>-<%=SystemEnv.getHtmlLabelName(354,user.getLanguage())%></BUTTON>
</DIV>
<TABLE class="Form">
	<TR class="Separator">
		<TD class="Sep1" colspan=5></TD>
	</TR>
	<TR>
		<TD width=100><B><%=SystemEnv.getHtmlLabelName(563,user.getLanguage())%></B></TD>
		<TD width=200>
	<SELECT name=charttype onchange="changetype()">
		<OPTION value=D <%if(charttype.equals("D")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%></OPTION>
		<OPTION value=H <%if(charttype.equals("H")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></OPTION>
<%if(software.equals("ALL") || software.equals("CRM")){%>
		<OPTION value=C <%if(charttype.equals("C")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(147,user.getLanguage())%></OPTION>
		<OPTION value=R <%if(charttype.equals("R")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(101,user.getLanguage())%></OPTION>
<%}%>
<%if(software.equals("ALL") || software.equals("HRM") || software.equals("CRM")){
        if( fnarightlevel.equals("2") ) { %>
		<OPTION value=F <%if(charttype.equals("F")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(189,user.getLanguage())%></OPTION>
<%      }
}%>
	</SELECT>
	<script language=javascript>
	function changetype(){
		if(document.all("charttype").value=="C") location = "OrgChartCRM.jsp";
		if(document.all("charttype").value=="F") location = "OrgChartFna.jsp";
		if(document.all("charttype").value=="I") location = "OrgChartLgc.jsp";
		if(document.all("charttype").value=="P") location = "OrgChartHRM.jsp";
		if(document.all("charttype").value=="H") location = "OrgChartHRM.jsp";
		if(document.all("charttype").value=="D") location = "OrgChartDoc.jsp";
		if(document.all("charttype").value=="R") location = "OrgChartProj.jsp";
	
	
	}
	</script>
	</TD>
<!--		<TD width=100><B><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%></B></TD>
		<TD width=200>
	<SELECT name=companyid>
	<%
	while(CompanyComInfo.next()){	
		String tmpcompanyid = CompanyComInfo.getCompanyid();
		String isselected="";
		if(Util.getIntValue(tmpcompanyid,0)==companyid)
			isselected=" selected";
	%>
		<OPTION value="<%=CompanyComInfo.getCompanyid()%>" <%=isselected%>><%=CompanyComInfo.getCompanyname()%></OPTION>
	<%}%>
	</SELECT></TD>-->
		<TD></TD>
	</TR>
</TABLE>

<%
  if(isHr){
%>
	<TABLE class="Form">
		<TR class="Section">
		 <TH colspan="10" ><P align="left"><%=SystemEnv.getHtmlLabelName(324,user.getLanguage())%></TH>
		</TR>
		<TBODY >
			<TR class=separator><TD colspan="10" class=Sep1></TD></TR>
		<!--	<TR><TD colspan=10>
			  <TABLE><TR>
				<TD align=right><B><%=SystemEnv.getHtmlLabelName(564,user.getLanguage())%></B></TD>
				<TD COLSPAN=1>
					<SELECT Name=indicate>
					   <OPTION VALUE="H" <%if(charttype.equals("H")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></OPTION>
					   <OPTION VALUE="F" <%if(charttype.equals("F")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(565,user.getLanguage())%></OPTION>
					   
							<OPTION VALUE="P" <%if(charttype.equals("P")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(503,user.getLanguage())%></OPTION>
							<OPTION VALUE="C" <%if(charttype.equals("C")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(425,user.getLanguage())%></OPTION>
							<OPTION VALUE="R" <%if(charttype.equals("R")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(566,user.getLanguage())%></OPTION>
							
					</SELECT>
				</TD>
				
				<TD WIDTH=80px align=right><B><%=SystemEnv.getHtmlLabelName(567,user.getLanguage())%></B></TD>
				<TD>
				     <SELECT Name=Scenario id=scenario WIDTH=120>
			           <OPTION VALUE=></OPTION>
					
					</SELECT>
				</TD>
							
				
			  </TR></TABLE>
			  
			</TD></TR>
		-->	
<!--		<TR><TD><B><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></B></TD>
			
			<TD>
			<%
			String ischecked = "";
			if(emptype_e.equals("1"))
				ischecked = " checked";
			%>
				<INPUT TYPE=checkbox VALUE=1 name=emptype_e <%=ischecked%>><%=SystemEnv.getHtmlLabelName(131,user.getLanguage())%></td><td>
			<%
			ischecked = "";
			if(emptype_c.equals("1"))
				ischecked = " checked";
			%>
				<INPUT TYPE=checkbox VALUE=1 name=emptype_c <%=ischecked%>><%=SystemEnv.getHtmlLabelName(130,user.getLanguage())%></td><td>
			<%
			ischecked = "";
			if(emptype_s.equals("1"))
				ischecked = " checked";
			%>	<INPUT TYPE=checkbox VALUE=1 name=emptype_s <%=ischecked%>><%=SystemEnv.getHtmlLabelName(134,user.getLanguage())%></td><td>
			<%
			ischecked = "";
			if(emptype_t.equals("1"))
				ischecked = " checked";
			%>	<INPUT TYPE=checkbox VALUE=1 name=emptype_t <%=ischecked%>><%=SystemEnv.getHtmlLabelName(480,user.getLanguage())%>
			</TD>
		</TR>
-->		
			<TR><TD><B><%=SystemEnv.getHtmlLabelName(169,user.getLanguage())%></b></TD>
			
				<TD>
				<SELECT Name=empstatus >
				<%
			ischecked = "";
			if(empstatus.equals("0"))
				ischecked = " selected";
			%>
			     	<OPTION VALUE="0" <%=ischecked%>><%=SystemEnv.getHtmlLabelName(15710, user.getLanguage())%> </option>
			<%
			ischecked = "";
			if(empstatus.equals("1"))
				ischecked = " selected";
			%>
			     	<OPTION VALUE="1" <%=ischecked%>><%=SystemEnv.getHtmlLabelName(15711, user.getLanguage())%></option>
			<%
			ischecked = "";
			if(empstatus.equals("2"))
				ischecked = " selected";
			%>
			     	<OPTION VALUE="2" <%=ischecked%>><%=SystemEnv.getHtmlLabelName(480, user.getLanguage())%></option>
			 <%
			ischecked = "";
			if(empstatus.equals("3"))
				ischecked = " selected";
			%>
			     	<OPTION VALUE="3" <%=ischecked%>><%=SystemEnv.getHtmlLabelName(15844, user.getLanguage())%></option>
            <%
			ischecked = "";
			if(empstatus.equals("4"))
				ischecked = " selected";
			%>
			     	<OPTION VALUE="4" <%=ischecked%>><%=SystemEnv.getHtmlLabelName(6094, user.getLanguage())%></option>			     	    	
			<%
			ischecked = "";
			if(empstatus.equals("5"))
				ischecked = " selected";
			%>
			     	<OPTION VALUE="5" <%=ischecked%>><%=SystemEnv.getHtmlLabelName(6091, user.getLanguage())%></option>
			 <%
			ischecked = "";
			if(empstatus.equals("6"))
				ischecked = " selected";
			%>
			     	<OPTION VALUE="6" <%=ischecked%>><%=SystemEnv.getHtmlLabelName(6092, user.getLanguage())%></option>
			 <%
			ischecked = "";
			if(empstatus.equals("7"))
				ischecked = " selected";
			%>
			     	<OPTION VALUE="7" <%=ischecked%>><%=SystemEnv.getHtmlLabelName(2245, user.getLanguage())%></option>
			 <%
			ischecked = "";
			if(empstatus.equals("8"))
				ischecked = " selected";
			%>
			     	<OPTION VALUE="8" <%=ischecked%>><%=SystemEnv.getHtmlLabelName(1831, user.getLanguage())%></option>    	 
			 </select>    	   	    	     	
			</TD>
	     </TR>
			
		</TBODY>
	</TABLE>
<%
  }
%>	
	
	<%
	String sql=" select count(id) from HrmResource ";
	int ishead = 0;
	String resourcetype="";
	int ishead2 = 0;
	if(emptype_e.equals("1")){
			if(ishead2==0){
				ishead2=1;
				resourcetype += "resourcetype='2'";
			}
	}
	if(emptype_c.equals("1")){
			if(ishead2==0){
				ishead2=1;
				resourcetype += "resourcetype='1'";
			}
			else	
				resourcetype += " or resourcetype='1'";
	}
	if(emptype_s.equals("1")){
			if(ishead2==0){
				ishead2=1;
				resourcetype += "resourcetype='3'";
			}
			else	
				resourcetype += " or resourcetype='3'";
	}
	if(emptype_t.equals("1")){
			if(ishead2==0){
				ishead2=1;
				resourcetype += "resourcetype='4'";
			}
			else	
				resourcetype += " or resourcetype='4'";
	}
	if(!resourcetype.equals("")){
		if(ishead==0){
			ishead = 1;
			sql += " where (";
			sql += resourcetype;
			sql += ")";
		}
		else{
			sql += " and (";
			sql += resourcetype;
			sql += ")";
		}
	}
	if(!empstatus.equals("")&&!empstatus.equals("8")){
		if(ishead==0){
			ishead = 1;
			sql += " where status = "+empstatus;			
		}
		else{
			sql += " and status = " +empstatus;
		}
	}
	if(empstatus.equals("8")){
		if(ishead==0){
			ishead = 1;
			sql += " where (  status = 0 or status = 1 or status = 2 or status = 3) ";
		}
		else{
			sql += " and (  status = 0 or status = 1 or status = 2 or status = 3) ";
		}
	}
	
	int curnum = 0;
//	out.print(sql);
	%>
	
	 <TABLE CLASS=ListShort>
	   <COL WIDTH=10%><COL WIDTH=20%><COL WIDTH=*%>
		
		  <TR class="separator">
			 <TD colspan="10" class="Sep3" ></TD>
		  </TR>
	</TABLE>
			<TABLE onclick="oc_ShowMenu 1,oc_divMenuTop" cellpadding=1 cellspacing=1 Class=ChartTop STYLE="POSITION:absolute;Z-INDEX:100;FONT-SIZE:8pt;LETTER-SPACING:-1pt;TOP:<%=top%>;LEFT:<%=(clientwidth/2-cellWidth2/2)>0?(clientwidth/2-cellWidth2/2):20%>;height:<%=cellHeight%>;width:<%=cellWidth2%>">
		<COL WIDTH=300px><COL>
		<TR height=28px><TD colspan=2 Class=ChartTop id=t><%=CompanyComInfo.getCompanyname(""+companyid)%></TD></TR>
		<TR height=14px><TD align=right><%=SystemEnv.getHtmlLabelName(2016,user.getLanguage())%></TD>
		<%
		RecordSet2.execute(sql);
		String tmpnum="";
		if(RecordSet2.next())
			tmpnum = RecordSet2.getString(1);
		%>
		<TD class=ChartCell><%=tmpnum%></TD>
		</TR>
		</TABLE>

		<DIV HEIGHT=1 Class=line Style="POSITION:absolute;LEFT:<%=clientwidth/2%>;TOP:<%=top+cellHeight%>;WIDTH:1;HEIGHT:<%=lineHeight1%>"></DIV>
		
		<HR Size=1 style="POSITION:absolute;COLOR:black;BACKGROUND-COLOR:black;BORDER-BOTTOM:black 1;HEIGHT: 1;LEFT:<%=(cellSpace+cellWidth/2)%>;TOP:<%=top+cellHeight+lineHeight1%> ; WIDTH:<%=clientwidth-cellWidth-cellSpace%>;Z-INDEX: 50">
		
		<%
		top=top+cellHeight+lineHeight1;
		int subcompanynum = 0;
		while(RecordSet.next()){
			String subcompanyid=RecordSet.getString(1);;
			subcompanynum+=1;
			int leftstep = (subcompanynum-1)*(cellWidth+cellSpace);
		%>
		<DIV Class=line Style="LEFT:<%=(leftstep+cellSpace+cellWidth/2)%>; TOP:<%=top%>; WIDTH:1; HEIGHT:<%=lineHeight1%>"></DIV>
		
		<TABLE onclick="oc_ShowMenu <%=subcompanynum%>,oc_divMenuGroup" cellpadding=1 cellspacing=1 Class=ChartGroup 
		STYLE="POSITION:absolute;Z-INDEX:100;FONT-SIZE:8pt;LETTER-SPACING:-1pt;TOP:<%=top+lineHeight1%>;LEFT:<%=leftstep+cellSpace%>;height:<%=cellHeight%>;width:<%=cellWidth%>">
		<TR height=28px><TD colspan=1 TITLE="<%=RecordSet.getString(2)%>" id=t><%=RecordSet.getString(2)%></TD></TR>
		<TR height=14px>
		<%
		String sqltmp=sql;
		if(ishead==0){
			sqltmp += " where ( subcompanyid1="+subcompanyid + " or subcompanyid2="+subcompanyid +" or subcompanyid3="+subcompanyid +" or subcompanyid4="+subcompanyid +")";
		}else{
			sqltmp += " and ( subcompanyid1="+subcompanyid + " or subcompanyid2="+subcompanyid +" or subcompanyid3="+subcompanyid +" or subcompanyid4="+subcompanyid +")";
		}
		RecordSet2.execute(sqltmp);
		if(RecordSet2.next())
			tmpnum = RecordSet2.getString(1);
		%>
		<TD class=ChartCell width=100%><%=tmpnum%></TD>		
		</TR>		
		</TABLE>
		<%
		int curtop = top+lineHeight1+cellHeight/2-lineHeight2;
		while(DepartmentComInfo.next()){
			String tmpid = DepartmentComInfo.getSubcompanyid1();
/*	         	if(companyid==1)
	         		tmpid = DepartmentComInfo.getSubcompanyid1();
	         	if(companyid==2)
	         		tmpid = DepartmentComInfo.getSubcompanyid2();
	         	if(companyid==3)
	         		tmpid = DepartmentComInfo.getSubcompanyid3();
	         	if(companyid==4)
	         		tmpid = DepartmentComInfo.getSubcompanyid4();  */
	         		
	         		
	         	if(!tmpid.equals(subcompanyid)) continue;
	         	departids +=",\"";
	         	departids += DepartmentComInfo.getDepartmentid();
	         	departids +="\"";
	         	curnum += 1;
	         	curtop += lineHeight2;
	         	
		%>
		
		<DIV class=line style="LEFT:<%=leftstep+cellSpace+linestep%>; TOP:<%=curtop%>; WIDTH:5; HEIGHT:<%=lineHeight2%>"></DIV>
		<TABLE onclick="oc_ShowMenu <%=curnum%>,oc_divMenuDivision" cellpadding=1 cellspacing=1 Class=ChartCompany 
		STYLE="POSITION:absolute;Z-INDEX:100;FONT-SIZE:8pt;LETTER-SPACING:-1pt;TOP:<%=curtop+lineHeight2-cellHeight/2%>;LEFT:<%=leftstep+cellSpace+linestep+lineWidth%>;height:<%=cellHeight%>;width:<%=cellWidth%>">
		<TR height=28px><TD colspan=1 TITLE="<%=DepartmentComInfo.getDepartmentname()%>" id=t><%=DepartmentComInfo.getDepartmentmark()%>-<%=DepartmentComInfo.getDepartmentname()%></TD></TR>
		<TR height=14px>
		<%
		sqltmp=sql;
		if(ishead==0){
			sqltmp += " where ( departmentid="+DepartmentComInfo.getDepartmentid()+")";
		}else{
			sqltmp += " and ( departmentid="+DepartmentComInfo.getDepartmentid()+")";
		}
		RecordSet2.execute(sqltmp);
		if(RecordSet2.next())
			tmpnum = RecordSet2.getString(1);
		%>
		<TD class=ChartCell width=100%><%=tmpnum%></TD>
		
		</TR>
		
		</TABLE>
		
		<%}%>
		<%}%>
		

		<DIV style="position:absolute;top:947;left:804;visibility:hidden;width:1;height:1;"></DIV>
	

<SCRIPT language=VBScript>
oc_DivisionList=array(<%=departids%>)



dim oc_CurrentMenu
dim oc_CurrentIndex

Sub oc_ShowMenu(Index,elMenu)
	dim t
	on error resume next
	oc_CurrentMenu.style.visibility="hidden"
	on error goto 0
	Set oc_CurrentMenu=elMenu
	oc_CurrentIndex = Index

	' title
	set elFrom = window.event.srcElement
	do while elFrom.tagName<>"TABLE"
		set elFrom = elFrom.parentElement
	loop
	elMenu.all("t").innerText = elFrom.all("t").innerText

	st = document.body.scrollTop
	oh = document.body.offsetHeight
	t = (st + window.event.clientY) - 2
	l = (document.body.scrollLeft + window.event.clientX) -10
	h = elMenu.clientHeight
	w = elMenu.clientWidth

	if ((l + w) > (document.body.scrollLeft + document.body.offsetWidth)) then l = l - (w-20)
	if ((t + h) > (document.body.scrollTop + document.body.offsetHeight)) then t = t - (h+2)

	elMenu.style.left = l
	elMenu.style.top = t
	elMenu.style.visibility = "visible"
End Sub

Sub oc_CurrentMenuOnMouseOut()
	set el = window.event.srcElement
	if (el.tagName = "A") then set el = el.parentElement
	if (el.tagName = "IMG") then set el = el.parentElement
	if (el.tagName = "TD" AND el.className <> "MenuPopupSelected" AND el.className <> "NoHand") then el.className = "MenuPopup"
End Sub

Sub oc_CurrentMenuOnMouseOver()
	set el = window.event.srcElement
	if (el.tagName = "A") then set el = el.parentElement
	if (el.tagName = "IMG") then set el = el.parentElement
	if (el.tagName = "TD" AND el.className <> "MenuPopupSelected" AND el.className <> "NoHand") then el.className = "MenuPopupFocus"
End Sub

Sub document_onmouseover
	on error resume next
	If window.event.srcElement.tagName = "BODY" Then
		oc_CurrentMenu.style.visibility = "hidden"
	End If
End Sub

Sub document_onmouseup
	on error resume next
	If window.event.srcElement.tagName = "BODY" Then
		oc_CurrentMenu.style.visibility = "hidden"
	End If
End Sub

Function oc_getAllDivisions(isQuoted)
	oc_getAllDivisions = Null
	For i = 1 To UBound(oc_DivisionList)
		d = oc_DivisionList(i)
		If isQuoted Then d = "'" & d & "'"
		oc_getAllDivisions = oc_getAllDivisions + "," & d
	Next
End Function
</SCRIPT>


	<DIV id="oc_divMenuTop" style="visibility:hidden; LEFT:0px; POSITION:absolute; TOP:0px; WIDTH:240px; Z-INDEX: 200">
	<TABLE cellpadding=2 cellspacing=0 class="MenuPopup" LANGUAGE=javascript onclick="return oc_CurrentMenuOnClick()" onmouseout="return oc_CurrentMenuonmouseout()" onmouseover="return oc_CurrentMenuonmouseover()" style="HEIGHT: 79px; WIDTH: 246px">
    <TR><TD class="NoHand" style=text-align:center;color:white id=t>Title</TD>
    </TR>
	
	</TABLE>
	</DIV>
	<DIV id="oc_divMenuGroup" style="visibility:hidden; LEFT:0px; POSITION:absolute; TOP:0px; WIDTH:240px; Z-INDEX: 200">
	<TABLE cellpadding=2 cellspacing=0 class="MenuPopup" LANGUAGE=javascript onclick="return oc_CurrentMenuOnClick()" onmouseout="return oc_CurrentMenuonmouseout()" onmouseover="return oc_CurrentMenuonmouseover()" style="HEIGHT: 79px; WIDTH: 246px">
    <TR><TD class="NoHand" style=text-align:center;color:white id=t>Title</TD></TR>
	
	</TABLE>
	</DIV>
	<DIV id="oc_divMenuDivision" style="visibility:hidden; LEFT:0px; POSITION:absolute; TOP:0px; WIDTH:240px; Z-INDEX: 200">
	<TABLE cellpadding=2 cellspacing=0 class="MenuPopup" LANGUAGE=javascript onclick="return oc_CurrentMenuOnClick()" onmouseout="return oc_CurrentMenuonmouseout()" onmouseover="return oc_CurrentMenuonmouseover()" style="HEIGHT: 79px; WIDTH: 246px">
    <TR><TD class="NoHand" style=text-align:center;color:white id=t>Title</TD></TR>
	
		 <TR id=D1><TD class=MenuPopup><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></TD></TR>
	
		 <TR id=D2><TD class=MenuPopup><%=SystemEnv.getHtmlLabelName(515,user.getLanguage())%></TD></TR>
		 
		 <TR id=D3><TD class=MenuPopup><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></TD></TR>
		
	
	</TABLE>
	</DIV>
	<SCRIPT LANGUAGE=VBScript>
	Sub oc_CurrentMenuOnClick
		set el = window.event.srcElement
		if (el.tagName = "A") then set el = el.parentElement
		select case el.parentElement.id
		
			case "D1"
				r="/hrm/company/HrmDepartmentDsp.jsp?id=" & oc_DivisionList(oc_CurrentIndex)
			case "D2"
				r="/hrm/company/HrmCostcenterChart.jsp?id=" & oc_DivisionList(oc_CurrentIndex)
			case "D3"
				r="/hrm/search/HrmResourceSearchTmp.jsp?from=hrmorg&department=" & oc_DivisionList(oc_CurrentIndex)
		end select
		oc_CurrentMenu.style.visibility = "hidden"
		if (r <> "") then
			window.event.returnValue = false
			window.location.href = r
		end if
	End Sub
	</SCRIPT>

</FORM>
</BODY>
</HTML>
