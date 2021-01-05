<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>

<%
if(!HrmUserVarify.checkUserRight("CptDepreMethodAdd:Add", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
%>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</head>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(837,user.getLanguage());
String needfav ="1";
String needhelp ="";
String depreid = Util.null2String(request.getParameter("id"));
boolean isEdit=false;
String name="";
String description="";

if(!depreid.equals("")){
	RecordSet.executeProc("CptDepreMethod1_SelectByID",""+depreid);
	RecordSet.next();
	name = Util.toScreenToEdit(RecordSet.getString("name"),user.getLanguage());
	description = Util.toScreenToEdit(RecordSet.getString("description"),user.getLanguage());
	isEdit = true;
}
int rowsum=0;

%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<FORM  name=frmMain action="DepreMethod2Operation.jsp" method=post>
<DIV class=HdrProps></DIV>
<input type="hidden" name=operation value="addoredit">
<BUTTON class=btnSave accessKey=S onclick='OnSubmit()'><U>S</U>-<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%></BUTTON>
<%
if(HrmUserVarify.checkUserRight("CptDepreMethodEdit:Delete", user)&&(!depreid.equals(""))){
%>
<BUTTON class=btnDelete id=Delete accessKey=D onclick="onDelete()"><U>D</U>-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></BUTTON>
<%
}
%>
<BUTTON class=btn accessKey=B onclick='window.history.back(-1)'><U>B</U>-<%=SystemEnv.getHtmlLabelName(1290,user.getLanguage())%></BUTTON>

  <TABLE class=form>
    <COLGROUP> <COL width="20%"> <COL width="80%"> <TBODY> 
    <TR class=Section> 
      <TH colSpan=2><%=SystemEnv.getHtmlLabelName(837,user.getLanguage())%></TH>
    </TR>
    <TR class=separator> 
      <TD class=Sep1 colSpan=2 ></TD>
    </TR>
    <TR> 
      <TD><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
      <TD class=Field> 
        <INPUT type=text size=30  maxlength=60 name="name" onchange='checkinput("name","nameimage")' value="<%=name%>">
        <SPAN id=nameimage><%if(!isEdit) {%><IMG src="/images/BacoError_wev8.gif" align=absMiddle><%}%></SPAN></TD>
    </TR>
    <TR> 
      <TD><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></TD>
      <TD class=Field> 
        <INPUT type=text size=60  maxlength=200  name="description" onchange='checkinput("description","descriptionimage")' value="<%=description%>">
        <SPAN id=descriptionimage><%if(!isEdit) {%><IMG src="/images/BacoError_wev8.gif" align=absMiddle><%}%></SPAN></TD>
    </TR>
    </TBODY> 
  </TABLE>
<table Class=ListShort cols=3>
 
<COLGROUP>
  	<COL width="10%">
  	<COL width="45%">
  	<COL width="45%">
        <TR class=Section>
    	  <TH colSpan=3><%=SystemEnv.getHtmlLabelName(836,user.getLanguage())%></TH></TR>
  	<TR class=separator>
    	  <TD class=Sep1 colSpan=3></TD></TR>
</table>
<table Class=ListShort cols=3 id="oTable">
 
      	<COLGROUP>
  	<COL width="10%">
  	<COL width="45%">
  	<COL width="45%">
    	   <tr class=header> 
            <td><%=SystemEnv.getHtmlLabelName(1426,user.getLanguage())%></td>
            <td><%=SystemEnv.getHtmlLabelName(1427,user.getLanguage())%></td>
            <td><%=SystemEnv.getHtmlLabelName(651,user.getLanguage())%></td>
</tr>
<%
String forCheck = "";
if(isEdit){
RecordSet.executeProc("CptDepreMethod2_SByDepreID",""+depreid);
while(RecordSet.next()){
String tempid = Util.null2String(RecordSet.getString("id"));
String temptime = Util.null2String(RecordSet.getString("time"));
String tempdepreunit = Util.null2String(RecordSet.getString("depreunit"));
%>
<tr>
<td bgcolor="#D2D1F1" height="23"><input type='checkbox' name='check_node' value="<%=tempid%>" ></td>
<td bgcolor="#D2D1F1" height="23">
<input type="hidden" name="node_<%=rowsum%>_id" size=25 value="<%=tempid%>">
<input type="text" name="node_<%=rowsum%>_time" size=10 maxlength=13 value="<%=temptime%>" onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("node_<%=rowsum%>_time");checkinput("node_<%=rowsum%>_time","node_<%=rowsum%>_timeimage")'></td>
 <span id="node_<%=rowsum%>_timeimage"></span></td>
<td bgcolor="#D2D1F1" height="23">
<input type="text" name="node_<%=rowsum%>_depreunit" size=10 maxlength=9 value="<%=tempdepreunit%>" onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("node_<%=rowsum%>_depreunit");checkinput("node_<%=rowsum%>_depreunit","node_<%=rowsum%>_depreunitimage")'></td>
 <span id="node_<%=rowsum%>_depreunitimage"></span></td>
</td>

</tr>
<%
forCheck +=",node_"+rowsum+"_time,node_"+rowsum+"_depreunit";
rowsum += 1;
}
}//end of if(isEdit)
%>
</table>
<br>
<BUTTON Class=Btn type=button accessKey=A onclick="JavaScript:addRow();"><U>A</U>-<%=SystemEnv.getHtmlLabelName(1428,user.getLanguage())%></BUTTON>
<BUTTON Class=Btn type=button accessKey=L onclick="JavaScript:if(isdel()){deleteRow1();}"><U>L</U>-<%=SystemEnv.getHtmlLabelName(1429,user.getLanguage())%></BUTTON></div>
<br>
<input type="hidden" value="0" name="nodesnum">
<input type="hidden" value="" name="delids">
<input type="hidden" value="<%=depreid%>" name="depreid">

</form>
  <SCRIPT LANGUAGE="JavaScript">
forCheck = "<%=forCheck%>";
 
rowindex = "<%=rowsum%>";
delids = "";
function addRow()
{
	ncol = oTable.cols;
	
	oRow = oTable.insertRow();
	
	for(j=0; j<ncol; j++) {
		oCell = oRow.insertCell(); 
		oCell.style.height=24;
		oCell.style.background= "#D2D1F1";
		switch(j) {
			case 0:
				var oDiv = document.createElement("div");
				var sHtml = "<input type='checkbox' name='check_node' value='0'>"; 
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 2: 
				var oDiv = document.createElement("div");
				var tempname = 'node_'+rowindex+'_depreunit';
				
				var sHtml = "<input type=input  size=10 maxlength=9 name="+tempname+" onKeyPress='ItemNum_KeyPress()' 	onBlur=\"checknumber('"+tempname+"');checkinput('"+tempname+"','"+tempname+"image')\"> <span id=\""+tempname+"image\"><IMG src=\"/images/BacoError_wev8.gif\" align=absMiddle></span>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				forCheck +=","+tempname;
				break;
			case 1: 
				var oDiv = document.createElement("div"); 
				var tempname = 'node_'+rowindex+'_time';
				
				var sHtml = "<input type=input  size=10 maxlength=13 name="+tempname+" onKeyPress='ItemNum_KeyPress()' 	onBlur=\"checknumber('"+tempname+"');checkinput('"+tempname+"','"+tempname+"image')\"> <span id=\""+tempname+"image\"><IMG src=\"/images/BacoError_wev8.gif\" align=absMiddle></span>";
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				forCheck +=","+tempname;
				break;
		}
	}
	rowindex = rowindex*1 +1;
}

function deleteRow1()
{
	len = document.forms[0].elements.length;
	var i=0;
	var rowsum1 = 0;
	for(i=len-1; i >= 0;i--) {
		if (document.forms[0].elements[i].name=='check_node')
			rowsum1 += 1;
	}
	for(i=len-1; i >= 0;i--) {
		if (document.forms[0].elements[i].name=='check_node'){
			if(document.forms[0].elements[i].checked==true) {
				var tempstr = ","+document.forms[0].elements[i+1].name+","+document.forms[0].elements[i+2].name;
				forCheck = forCheck.replace(tempstr,"");
				if(document.forms[0].elements[i].value!='0')
					delids +=","+ document.forms[0].elements[i].value;
				oTable.deleteRow(rowsum1);	
			}
			rowsum1 -=1;
		}
	
	}	
}	

function OnSubmit(){
  var arraylength = 150;
  times = new Array(arraylength);
  depreunits = new Array(arraylength);

  var count=0;	
  len = document.forms[0].elements.length;
  pass = true;
  for(i=0;i<len;i++){
	  if((document.forms[0].elements[i].name).indexOf('_depreunit')!=-1){
		if((document.forms[0].elements[i].value<0)||(document.forms[0].elements[i].value>1)){
			pass = false;
			alert("数字校验错");
		}
		times[count]=document.forms[0].elements[i-1].value/1;
		depreunits[count++]=document.forms[0].elements[i].value/1;
	  }
  }
  //sort
  for(j=0;j<arraylength;j++){	
	for(i=0;i<j;i++){
	  if(times[i]>times[i+1]){
		  temp = times[i+1];
		  times[i+1] = times[i];
		  times[i] = temp;
		  temp = depreunits[i+1];
		  depreunits[i+1] = depreunits[i];
		  depreunits[i] = temp;
	  }
	}
  }
  //折扣率逻辑判断
  for(i=0;i<arraylength-1;i++){
	  if(depreunits[i]>depreunits[i+1]){
    		alert("<%=SystemEnv.getHtmlLabelName(15319,user.getLanguage())%>2");
			pass = false;
	  }
  }

  if(check_form(document.forms[0],"'name,description"+forCheck+",'")&&pass){
	selectall();
  }
}

function selectall(){
	document.forms[0].nodesnum.value=rowindex;
	document.forms[0].delids.value=delids;
	document.frmMain.submit();
}

function onDelete(){
		if(confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>")) {
			document.frmMain.operation.value="delete";
			document.frmMain.submit();
		}
}
</script>
</BODY></HTML>
