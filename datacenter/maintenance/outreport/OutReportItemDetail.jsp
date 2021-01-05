<%@ page import="weaver.general.Util,java.util.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>


<%
String haspost = Util.null2String(request.getParameter("haspost"));
String desc = Util.toScreen(request.getParameter("desc"),user.getLanguage());
%>

<script language=vbs>
if "<%=haspost%>" = "1" then	
	window.parent.returnvalue = "<%=desc%>"
	window.parent.close
end if
if "<%=haspost%>" = "2" then	
	window.parent.returnvalue = ""
	window.parent.close
end if
</script>


<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />


<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</head>



<%

String allid = Util.null2String(request.getParameter("allid"));
String outrepid = "";
String itemrow = "";
String itemcolumn = "";
String itemid = "" ;
String outrepcategory = "" ;

if(!allid.equals("")) {
    String allids[] = Util.TokenizerString2(allid , "_") ;
    outrepid = allids[0] ;
    itemrow = allids[1] ;
    itemcolumn = allids[2] ;
    outrepcategory = allids[3] ;
}
else {
    outrepid = Util.null2String(request.getParameter("outrepid"));
    itemrow = Util.null2String(request.getParameter("itemrow"));
    itemcolumn = Util.null2String(request.getParameter("itemcolumn"));
    outrepcategory = Util.null2String(request.getParameter("outrepcategory"));
}

String itemtype = Util.null2String(request.getParameter("itemtype"));
String itemexpress = "" ;
String itemexpresstype = "" ;
String itemmodtype = "" ;
String itemdesc = "" ;
String itemendesc = "" ;
String picstat = "" ;
String picstatbudget = "" ;
String picstatlast = "" ;


char separator = Util.getSeparator() ;
String para = ""+outrepid + separator + ""+itemrow  + separator + ""+itemcolumn ;
rs.executeProc("T_OutReportItem_SelectByRowCol",para);
if(rs.next()) {
    itemid = Util.null2String(rs.getString("itemid")) ;
    itemdesc = Util.toScreenToEdit(rs.getString("itemdesc"),user.getLanguage()) ;
    itemendesc = Util.toScreenToEdit(rs.getString("itemendesc"),user.getLanguage()) ;
    itemexpress = Util.toScreenToEdit(rs.getString("itemexpress"),user.getLanguage()) ;
    itemexpresstype = Util.null2String(rs.getString("itemexpresstype")) ;
    itemmodtype = Util.null2String(rs.getString("itemmodtype")) ;
    picstat = Util.null2String(rs.getString("picstat")) ;
    picstatbudget = Util.null2String(rs.getString("picstatbudget")) ;
    picstatlast = Util.null2String(rs.getString("picstatlast")) ;
    if(itemtype.equals("")) itemtype = Util.null2String(rs.getString("itemtype")) ;
}
else itemid = "0" ;

if(itemtype.equals("")) {
    if(outrepcategory.equals("0")) itemtype = "1" ;
    else itemtype = "2" ;
}

ArrayList tables = new ArrayList() ;
ArrayList conditionids = new ArrayList();
ArrayList conditionnames = new ArrayList() ;
ArrayList conditionvalues = new ArrayList() ;
if(itemtype.equals("2")) {
    rs.executeProc("T_InputReport_SelectAll","");
    while(rs.next()){
        String inpreptablename = Util.null2String(rs.getString("inpreptablename")) ;
        String inprepbugtablename = Util.null2String(rs.getString("inprepbugtablename")) ;
        String inprepbudget = Util.null2String(rs.getString("inprepbudget")) ;
        String inprepforecast = Util.null2String(rs.getString("inprepforecast")) ;
        tables.add(inpreptablename) ;
        if(inprepbudget.equals("1"))  tables.add(inprepbugtablename) ;
        if(inprepforecast.equals("1"))  tables.add(inpreptablename+"_forecast") ;
    }


    rs.executeSql("select * from T_Condition ");
    while(rs.next()){
        String conditionid = Util.null2String(rs.getString("conditionid")) ;
        String conditiontype = Util.null2String(rs.getString("conditiontype")) ;
        String conditionname = Util.toScreen(rs.getString("conditionname"),user.getLanguage()) ;
        String conditionvalue = "";
        if(Util.getIntValue(conditionid)<8) conditionvalue = "$"+Util.null2String(rs.getString("conditionitemfieldname")) ;
        if(conditiontype.equals("3")) continue ;

        conditionids.add(conditionid) ;
        conditionnames.add(conditionname) ;
        conditionvalues.add(conditionvalue);
    }
}

String imagefilename = "/images/hdHRMCard.gif";
String titlename = SystemEnv.getHtmlLabelName(20743,user.getLanguage()) + Util.getCharString(Util.getIntValue(itemcolumn,0)) + itemrow    ;

String needfav ="1";
String needhelp ="";
%>
<%  if(itemtype.equals("2")) { %>
<script language=javascript>
var rowindex1=0;
var totalrows1=0;

var rowindex2=0;
var totalrows2=0;

var rowindex3=0;
var totalrows3=0;

function addRow1()
{	
	ncol = oTable1.cols;
	oRow = oTable1.insertRow();	
	for(j=0; j<ncol; j++) {
		oCell = oRow.insertCell(); 
		switch(j) {
			case 0: 
				var oDiv = document.createElement("div");
				var sHtml = "<select class=inputstyle name='itemtable"+rowindex1+"' style='width:50%'> " +
                            "<option value=''></option> " ;

                <% for (int i=0 ; i< tables.size() ; i++) {%>
                    sHtml += "<option value='<%=tables.get(i)%>'><%=tables.get(i)%></option> " ;
                <%}%>
                sHtml += "</select>" ;
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 1: 
				var oDiv = document.createElement("div");
				var sHtml = "<input type=text class=inputstyle size=50 name='itemtablealter"+rowindex1+"'> ";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
		}
	}
	rowindex1 = rowindex1*1 +1;
	frmMain.totaldetail1.value=rowindex1;
	totalrows1 = rowindex1;
}

function addRow2()
{	
	ncol = oTable2.cols;
	oRow = oTable2.insertRow();	
	for(j=0; j<ncol; j++) {
		oCell = oRow.insertCell(); 
		switch(j) {
			case 0: 
				var oDiv = document.createElement("div");
				var sHtml = "<select class=inputstyle name='conditionid"+rowindex2+"' style='width:50%' onchange='changevalue(this,"+rowindex2+")'> " +
                            "<option value=''></option> " ;

                <% for (int i=0 ; i< conditionids.size() ; i++) {%>
                    sHtml += "<option value='<%=conditionids.get(i)%>'><%=conditionnames.get(i)%></option> " ;
                <%}%>
                sHtml += "</select>" ;
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 1: 
				var oDiv = document.createElement("div");
				var sHtml = "<input type=text class=inputstyle size=50 name='conditionvalue"+rowindex2+"'> ";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
		}
	}
	rowindex2 = rowindex2*1 +1;
	frmMain.totaldetail2.value=rowindex2;
	totalrows2 = rowindex2;
}

function addRow3()
{	
	ncol = oTable3.cols;
	oRow = oTable3.insertRow();	
	for(j=0; j<ncol; j++) {
		oCell = oRow.insertCell(); 
		switch(j) {
			case 0: 
				var oDiv = document.createElement("div");
				var sHtml = "<input type='text' size=25 name='coordinatename"+rowindex3+"'>" ;
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 1: 
				var oDiv = document.createElement("div");
				var sHtml = "<input type='text' size=50 name='coordinatevalue"+rowindex3+"'> ";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
		}
	}
	rowindex3 = rowindex3*1 +1;
	frmMain.totaldetail3.value=rowindex3;
	totalrows3 = rowindex3 ;
}

</script>
<%}%>


<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(this),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<% if(!itemid.equals("0")) {%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%}%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:window.close(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<FORM id=frmMain name=frmMain action="OutReportItemDetail.jsp" method=post>
<input type="hidden" name=operation>
<input type=hidden name=outrepid value="<%=outrepid%>">
<input type=hidden name=itemid value="<%=itemid%>">
<input type=hidden name=itemrow value="<%=itemrow%>">
<input type=hidden name=itemcolumn value="<%=itemcolumn%>">
<input type=hidden name=outrepcategory value="<%=outrepcategory%>">
<input type="hidden" name="totaldetail1"> 
<input type="hidden" name="totaldetail2"> 
<input type="hidden" name="totaldetail3"> 
<% for (int i=0 ; i< conditionids.size() ; i++) {%>
<input type="hidden" name="conditionids_<%=conditionids.get(i)%>" value='<%=conditionvalues.get(i)%>'>
<%}%>


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
		<TABLE class=Shadow>
		<tr>
		<td valign="top">

  <table class=liststyle>
    <colgroup> <col width="40%"><col width="60%"><tbody> 
      <tr class=header> 
        <th ><%=SystemEnv.getHtmlLabelName(20744,user.getLanguage())%></th>
        <th><%=SystemEnv.getHtmlLabelName(20745,user.getLanguage())%></th>
      </tr>
      <tr class=line> 
        <td colspan=2></td>
      </tr>
      <tr> 
        <td class=Field> 
          <% if(outrepcategory.equals("0")) { // 只有为固定报表时候显示 %>
          <input type="radio" name="itemtype" value="1" <% if(itemtype.equals("1")) {%> checked <%}%> onClick="doChange(1)">
          <%=SystemEnv.getHtmlLabelName(608,user.getLanguage())%>
          <% } %>
          <input type="radio" name="itemtype" value="2" <% if( itemtype.equals("2")) {%> checked <%}%> onClick="doChange(2)">
          <%=SystemEnv.getHtmlLabelName(20746,user.getLanguage())%>
          <input type="radio" name="itemtype" value="3" <% if( itemtype.equals("3")) {%> checked <%}%> onClick="doChange(3)">
          <%=SystemEnv.getHtmlLabelName(20747,user.getLanguage())%> 
        </td>
        <td class=Field> 
          <% if(outrepcategory.equals("0")) { // 固定报表时候显示 %>
          <input type=text class=inputstyle size=50 name="itemdesc" value="<%=itemdesc%>">
          <% } else { // 排序报表时候显示 %>
          <%=SystemEnv.getHtmlLabelName(1997,user.getLanguage())%><input type=text class=inputstyle size=20 name="itemdesc" value="<%=itemdesc%>">&nbsp;
          <%=SystemEnv.getHtmlLabelName(642,user.getLanguage())%><input type=text class=inputstyle size=20 name="itemendesc" value="<%=itemendesc%>">
          <% } %>
        </td>
      </tr>
    </tbody> 
  </table>
  <br>
<%
if(itemtype.equals("1")) {%>

  <table class=liststyle>
    <colgroup> <col width="20%"> <col width="80%"> <tbody> 
    <tr class=header> 
      <th colspan=2><%=SystemEnv.getHtmlLabelName(20748,user.getLanguage())%></th>
    </tr>
    <tr class=line> 
      <td colspan=2 ></td>
    </tr>
    <tr> 
      <td><%=SystemEnv.getHtmlLabelName(20749,user.getLanguage())%></td>
      <td class=Field>
        <input type=text class=inputstyle size=50 name="itemexpress" value="<%=itemexpress%>">
    </tr>
    </tbody>
  </table>
  <%}%>
  <%
if(itemtype.equals("3")) {%>
  <table class=liststyle>
    <colgroup> <col width="20%"> <col width="80%"> <tbody> 
    <tr class=header> 
      <th colspan=2><%=SystemEnv.getHtmlLabelName(20748,user.getLanguage())%></th>
    </tr>
    <tr class=line> 
      <td colspan=2 ></td>
    </tr>
    <tr> 
      <td><%=SystemEnv.getHtmlLabelName(20750,user.getLanguage())%></td>
      <td class=Field>
        <input type=text class=inputstyle size=50 name="itemexpress" value="<%=itemexpress%>"> <br><%=SystemEnv.getHtmlLabelName(20751,user.getLanguage())%><BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(20752,user.getLanguage())%>
      </td>
    </tr>
    <% if(outrepcategory.equals("2")) { // 只有为排序报表时候显示 %>
    <tr> 
      <td><%=SystemEnv.getHtmlLabelName(20753,user.getLanguage())%></td>
      <td class=Field>
        <input type="checkbox" name="picstat" value="1" <% if(picstat.equals("1")) {%> checked <%}%>>
        <%=SystemEnv.getHtmlLabelName(20754,user.getLanguage())%>
      </td>
    </tr>
    <% } %>
    </tbody>
  </table>
  <%}%>
  <%
if(itemtype.equals("2")) {%>
  <table class=liststyle cellspacing=1 id="oTable1" cols=2>
    <COLGROUP> <COL width="50%"><COL width="50%"> <tbody>
	<tr class=header> 
      <td><%=SystemEnv.getHtmlLabelName(15190,user.getLanguage())%></td>
      <td align=right> <button class=btn accessKey=T onClick="addRow1();"><U>T</U>-<%=SystemEnv.getHtmlLabelName(193,user.getLanguage())%></button> 
      </td>
    </tr> 
    <tr class=Header> 
      <td><b><%=SystemEnv.getHtmlLabelName(15190,user.getLanguage())%></b></td>
      <td><b><%=SystemEnv.getHtmlLabelName(475,user.getLanguage())%></b></td>
    </tr>
    <tr class=line> 
      <td    colspan=2></td>
    </tr>
    <% 
	if(!itemid.equals("0")) {
		rs.executeProc("T_OutRItemTable_SelectByItemid",""+itemid);
		int recorderindex = 0 ;
		while(rs.next()) {
			String itemtableid = Util.null2String(rs.getString("itemtableid")) ;
			String itemtable = Util.null2String(rs.getString("itemtable")) ;
			String itemtablealter = Util.null2String(rs.getString("itemtablealter")) ;
  	%>
        <script language=javascript>
            rowindex1 = rowindex1*1 +1;
            frmMain.totaldetail1.value=rowindex1;
            totalrows1 = rowindex1;
        </script>
    <tr> 
      <td>
        <select class=inputstyle name='itemtable<%=recorderindex%>' style='width:50%'>
            <option value=''></option>
            <% for (int i=0 ; i< tables.size() ; i++) {%>
            <option value='<%=tables.get(i)%>' <% if(((String)tables.get(i)).equals(itemtable)) {%> selected <%}%>><%=tables.get(i)%></option>
            <%}%>
        </select></td>
      <td><input type=text class=inputstyle size=50 name="itemtablealter<%=recorderindex%>" value='<%=itemtablealter%>'></td>
    </tr>
    <%recorderindex ++ ; } }%>
    </tbody> 
  </table>
  
    <br>
  <table class=liststyle cellspacing=1 >
   <colgroup> <col width="50%"><col width="50%"> 
    <tbody> 
    <tr class=Header> 
      <th ><%=SystemEnv.getHtmlLabelName(18125,user.getLanguage())%></th>
      <th ><%=SystemEnv.getHtmlLabelName(599,user.getLanguage())%></th>
    </tr>	<TR class=Line><TD colspan="2" ></TD></TR> 
    <tr> 
      <td class=Field> 
        <input type=text class=inputstyle  name="itemexpress" value="<%=itemexpress%>" style="width:100%"></td>
        
      <td class=Field>
        <% if(outrepcategory.equals("0")) { // 只有为固定报表时候显示 %>
        <input type="radio" name="itemexpresstype" value="1" <% if(itemexpresstype.equals("1") || itemexpresstype.equals("")) {%> checked <%}%>>
        <%=SystemEnv.getHtmlLabelName(449,user.getLanguage())%>
        <input type="radio" name="itemexpresstype" value="2" <% if(itemexpresstype.equals("2")) {%> checked <%}%>>
        <%=SystemEnv.getHtmlLabelName(20755,user.getLanguage())%>
        <%} else { // 在排序报表的时候判断是否作为图形统计项目%>
        <input type="checkbox" name="picstat" value="1" <% if(picstat.equals("1")) {%> checked <%}%>>
        <%=SystemEnv.getHtmlLabelName(20754,user.getLanguage())%>
        <input type="hidden" name="itemexpresstype" value="1">
        <%}%>
      </td>
    </tr>
    </tbody> 
  </table>
  <br>
  <table class=liststyle cellspacing=1 id="oTable2" cols=2>
    <colgroup> <col width="50%"><col width="50%"> <tbody> 
    <tr class=header> 
      <td><%=SystemEnv.getHtmlLabelName(20331,user.getLanguage())%></td>
      <td align=right> <button class=btn accesskey=I onClick="addRow2();"><u>I</u>-<%=SystemEnv.getHtmlLabelName(193,user.getLanguage())%></button>
      </td>
    </tr>
    <tr class=Header> 
      <td><b><%=SystemEnv.getHtmlLabelName(15364,user.getLanguage())%></b></td>
      <td><b><%=SystemEnv.getHtmlLabelName(19113,user.getLanguage())%></b></td>
    </tr>
    <tr class=line> 
      <td  colspan=2></td>
    </tr>
    <% 
	if(!itemid.equals("0")) {
		int recorderindex = 0 ;
		rs.executeProc("T_OutRICondition_SByItemid",""+itemid);
		while(rs.next()) {
			String itemconditionid = Util.null2String(rs.getString("itemconditionid")) ;
			String conditionid = Util.null2String(rs.getString("conditionid")) ;
			String conditionvalue = Util.toScreenToEdit(rs.getString("conditionvalue"),user.getLanguage()) ;
  	%>
        <script language=javascript>
            rowindex2 = rowindex2*1 +1;
            frmMain.totaldetail2.value=rowindex2;
            totalrows2 = rowindex2;
        </script>
    <tr> 
      <td>
            <select class=inputstyle name='conditionid<%=recorderindex%>' style='width:50%' onchange='changevalue(this,<%=recorderindex%>)'>
            <option value=''></option>
            <% for (int i=0 ; i< conditionids.size() ; i++) {%>
            <option value='<%=conditionids.get(i)%>' <% if(((String)conditionids.get(i)).equals(conditionid)) {%> selected <%}%>><%=conditionnames.get(i)%></option>
            <%}%>
        </select>
      </td>
      <td><input type=text class=inputstyle size=50 name="conditionvalue<%=recorderindex%>" value="<%=conditionvalue%>">
      </td>
    </tr>
    <% recorderindex ++ ; } }%>
    </tbody> 
  </table>
  <%}%>
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

  
</form>
<br>
<script language=javascript>
itemoldtype = <%=itemtype%>

function doChange(thevalue){
    if(thevalue != itemoldtype) 
	    document.frmMain.submit();
 }

 function onSave(obj){
    document.frmMain.action = "OutReportItemOperation.jsp" ;
	document.frmMain.operation.value="edit";
	document.frmMain.submit();
    obj.disabled=true; 
 }
 function onDelete(){
		if(confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>")) {
            document.frmMain.action = "OutReportItemOperation.jsp" ;
			document.frmMain.operation.value="delete";
			document.frmMain.submit();
		}
}
function changevalue(obj,index2){
    var index=obj.value;
    if(index==''){
        document.all("conditionvalue"+index2).value='';
    }else{
        document.all("conditionvalue"+index2).value=document.all("conditionids_"+index).value;
    }
}
</script>
 
</BODY></HTML>
