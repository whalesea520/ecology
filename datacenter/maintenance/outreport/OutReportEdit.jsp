<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="ConditionComInfo" class="weaver.datacenter.ConditionComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>


<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</head>
<%
int outrepid = Util.getIntValue(request.getParameter("outrepid"),0);
rs.executeProc("T_OutReport_SelectByOutrepid",""+outrepid);
rs.next() ;

String outrepname = Util.toScreenToEdit(rs.getString("outrepname"),user.getLanguage()) ;
String outrepenname = Util.null2String(rs.getString("outrepenname")) ;
String outreprow = Util.null2String(rs.getString("outreprow")) ;
String outrepcolumn = Util.null2String(rs.getString("outrepcolumn")) ;
String outrepdesc = Util.toScreenToEdit(rs.getString("outrepdesc"),user.getLanguage()) ;
String outrependesc = Util.null2String(rs.getString("outrependesc")) ;
String modulefilename = Util.toScreenToEdit(rs.getString("modulefilename"),user.getLanguage()) ;  //模板文件名称
String enmodulefilename = Util.toScreenToEdit(rs.getString("enmodulefilename"),user.getLanguage()) ;  //模板文件名称

// 刘煜 2004 年10月23 日增加模板文件自适应行高和列宽
String autocolumn = Util.null2String(rs.getString("autocolumn")) ;  //列宽
String autorow = Util.null2String(rs.getString("autorow")) ;  //行高
String outreptype = Util.null2String(rs.getString("outreptype")) ;  /*报表种类*/
String outrepcategory = Util.null2String(rs.getString("outrepcategory")) ;  /*报表所属 0:固定报表 1：明细报表 2:排序报表*/


/* 如果报表为1：明细报表 ， 预先设置可以查询的表 */
ArrayList tables = null ;
if(outrepcategory.equals("1")) {
    tables = new ArrayList() ;

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
}

// 所有的报表条件
ArrayList conditionids = new ArrayList() ;
ArrayList conditionnames = new ArrayList() ;

rs.executeSql("select * from T_Condition ");
while(rs.next()){
    String conditionid = Util.null2String(rs.getString("conditionid")) ;
    String conditiontype = Util.null2String(rs.getString("conditiontype")) ;
    String conditionname = Util.toScreen(rs.getString("conditionname"),user.getLanguage()) ;

    if(conditiontype.equals("3")) continue ;

    conditionids.add(conditionid) ;
    conditionnames.add(conditionname) ;
} 

int recorderindex = 0 ;   // 如果报表为1：明细报表 ， 预先设置表定义的行数

String imagefilename = "/images/hdHRMCard.gif";
String titlename = SystemEnv.getHtmlLabelName(15514,user.getLanguage()) + ": " + outrepname;
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(),_self} " ;
RCMenuHeight += RCMenuHeightStep;

if(outrepcategory.equals("0") || outrepcategory.equals("2")) {   // 改变行列，报表项定义只有固定报表,排序报表有
    RCMenu += "{"+SystemEnv.getHtmlLabelName(16620,user.getLanguage())+",javascript:onChange(),_self} " ;
    RCMenuHeight += RCMenuHeightStep;

    RCMenu += "{"+SystemEnv.getHtmlLabelName(16621,user.getLanguage())+",javascript:onItemDef(),_self} " ;
    RCMenuHeight += RCMenuHeightStep;
}
else {      // 统计项定义只有明细报表有
    RCMenu += "{"+SystemEnv.getHtmlLabelName(16890,user.getLanguage())+",javascript:onStatDef(),_self} " ;
    RCMenuHeight += RCMenuHeightStep;
}

RCMenu += "{"+SystemEnv.getHtmlLabelName(77,user.getLanguage())+",javascript:onCopy(),_self} " ;
RCMenuHeight += RCMenuHeightStep;

RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(),_self} " ;
RCMenuHeight += RCMenuHeightStep;

RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",OutReport.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep;

%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<FORM id=frmMain name=frmMain action="OutReportOperation.jsp" method=post>
<input type="hidden" name=operation>
<input type=hidden name=outrepid value="<%=outrepid%>">
<input type="hidden" name=outrepcategory value="<%=outrepcategory%>">  <!-- 报表所属 -->
<input type="hidden" name=totaldetail1 value="">  <!-- 报表所属 -->
<input type="hidden" name="systemset" value="1"> <!-- 属于系统设置的模板-->

<input type="hidden" name="conditionid" value="">
<input type="hidden" name="userid" value="">
<input type="hidden" name="usertype" value="">
<input type="hidden" name="outrepconditionid" value="">
<input type="hidden" name="totaldetail2">  <!-- 条件项大小 -->
<input type="hidden" name="outrepshareid" value="">



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



<TABLE class=viewform>
  <COLGROUP>
  <COL width="20%">
  <COL width="80%">
  <TBODY>
  <TR class=title>
      <TH colSpan=2><%=SystemEnv.getHtmlLabelName(15514,user.getLanguage())%></TH>
    </TR>
  <TR class=spacing style="height:1px">
    <TD class=line1 colSpan=2 ></TD></TR>
  <TR>
          <TD>名称</TD>
          <TD class=Field><INPUT type=text class="InputStyle" size=50 name="outrepname" onchange='checkinput("outrepname","outrepnameimage")' value=<%=outrepname%>>
          <SPAN id=outrepnameimage></SPAN></TD>
        </TR> 
   <TR class=spacing style="height:1px">
    <TD class=line colSpan=2 ></TD></TR>
   <TR>
          <TD>英文名称</TD>
          <TD class=Field><INPUT type=text class="InputStyle" size=50 name="outrepenname" value="<%=outrepenname%>"></TD>
        </TR> 
        <TR class=spacing style="height:1px">
    <TD class=line colSpan=2 ></TD></TR>
    <% if(outrepcategory.equals("0")||outrepcategory.equals("2")) { // 只有为固定报表或者排序报表时候显示 %>
    <TR>
      <TD>行数</TD>
      <TD class=Field><%=outreprow%></TD>
     </TR> 
     <TR class=spacing style="height:1px"><TD class=line colSpan=2 ></TD></TR>
     <TR>
      <TD>列数</TD>
      <TD class=Field><%=outrepcolumn%></TD>
     </TR> 
     <TR class=spacing style="height:1px"><TD class=line colSpan=2 ></TD></TR>
    <% } %>
    <TR>
        <TD>中文报表模板文件</TD>
          <TD class=Field><INPUT type=text class="InputStyle" size=50 name="modulefilename" value="<%=modulefilename%>"></TD>
        </TR> 
    <TR class=spacing style="height:1px"><TD class=line colSpan=2 ></TD></TR>
      <TR>
        <TD>英文报表模板文件</TD>
        <TD class=Field><INPUT type=text class="InputStyle" size=50 name="enmodulefilename" value="<%=enmodulefilename%>"></TD>
    </TR> 
    <!-- 刘煜 2004 年10月23 日增加模板文件自适应行高和列宽-->
    <TR class=spacing style="height:1px"><TD class=line colSpan=2></TD></TR>
    <TR>
          <TD>报表模板自适应</TD>
          <TD class=Field>
            列宽：<INPUT type=checkbox class=inputstyle name="autocolumn" value='1' <% if(autocolumn.equals("1")) { %> checked <%}%>>
            行高：<INPUT type=checkbox class=inputstyle name="autorow" value='1' <% if(autorow.equals("1")) { %> checked <%}%>>
          </TD>
    </TR> 
    <TR class=spacing style="height:1px"><TD class=line colSpan=2 ></TD></TR>
    <TR> 
      <TD>报表种类</TD>
      <TD class=Field>
         <select class="InputStyle" name="outreptype" style="width:50%">
          <option value="0" <% if(outreptype.equals("0")) { %> selected <%}%>>动态</option>
		  <option value="1" <% if(outreptype.equals("1")) { %> selected <%}%>>年报</option>
		  <option value="2" <% if(outreptype.equals("2")) { %> selected <%}%>>月报</option>
		  <option value="3" <% if(outreptype.equals("3")) { %> selected <%}%>>旬报</option>
		  <option value="4" <% if(outreptype.equals("4")) { %> selected <%}%>>周报</option>
		  <option value="5" <% if(outreptype.equals("5")) { %> selected <%}%>>日报</option>
         </select>
      </TD>
    </TR> <TR class=spacing style="height:1px">
    <TD class=line colSpan=2 ></TD></TR>
        <TR>
          <TD>中文描述</TD>
          <TD class=Field><INPUT type=text class="InputStyle" size=50 name="outrepdesc" value=<%=outrepdesc%>></TD>
        </TR>  
    <TR class=spacing style="height:1px"><TD class=line colSpan=2 ></TD></TR>
    <TR>
          <TD>英文描述</TD>
          <TD class=Field><INPUT type=text class="InputStyle" size=50 name="outrependesc" value="<%=outrependesc%>"></TD>
        </TR> <TR class=spacing style="height:1px">
    <TD class=line1 colSpan=2 ></TD></TR>
 </TBODY></TABLE>
  <br>

<% if(outrepcategory.equals("1")) { // 只有为明细报表时候显示 ，选择可以使用的表 %>
  <table class=liststyle cellspacing=1 id="oTable1" cols=2>
    <COLGROUP> <COL width="50%"><COL width="50%"> <tbody>
	<tr class=header> 
      <td>数据库表</td>
      <td align=right> <button type="button" class=btn accessKey=T onClick="addRow1();"><U>T</U>-加入</button> 
      </td>
    </tr> 
    <tr class=Header> 
      <td><b>表</b></td>
      <td><b>别名</b></td>
    </tr>
    <tr class=line style="height:1px"> 
      <td    colspan=2 style="padding:0;"></td>
    </tr>
    <% 
		rs.executeProc("T_ReportStatitemTable_SById",""+outrepid);
		while(rs.next()) {
			String itemtableid = Util.null2String(rs.getString("itemtableid")) ;
			String itemtable = Util.null2String(rs.getString("itemtable")) ;
			String itemtablealter = Util.null2String(rs.getString("itemtablealter")) ;
  	%>
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
    <%      recorderindex ++ ;  
        }
    %>
    </tbody> 
  </table>
  <br>
<% } %>
  <table class=liststyle cellspacing=1 id="oTable2" cols=3>
    <colgroup> <col width="40%"><col width="30%"><col width="30%"> <tbody> 
    <tr class=header> 
      <td>报表条件项</td>
      <td align=right colspan=2>
          <button type="button" class=btn accessKey=I onClick="addRow2()"><U>I</U>-加入</button>
          <button type="button" class=btn accessKey=M onClick="onShowMoudle()"><U>M</U>-条件模板</button>
      </td>
    </tr>
    <tr class=Header> 
      <td><b>条件</b></td>
      <td><b>中文名称</b></td>
      <td><b>英文名称</b></td>
    </tr>
    <tr class=line style="height:1px"> 
      <td  colspan=3 style="padding:0;"></td>
    </tr>
    <% 
    int conrecorderindex = 0 ;
    rs.executeProc("T_OutRC_SelectByOutrepid",""+outrepid);
    while(rs.next()) {
        String conditionid = Util.null2String(rs.getString("conditionid")) ;
        String conditioncnname = Util.null2String(rs.getString("conditioncnname")) ;
        String conditionenname = Util.null2String(rs.getString("conditionenname")) ;
  	%>
    <tr> 
      <td>
            <select class=inputstyle name='conditionid<%=conrecorderindex%>'>
            <option value=''></option>
            <% for (int i=0 ; i< conditionids.size() ; i++) {%>
            <option value='<%=conditionids.get(i)%>' <% if(((String)conditionids.get(i)).equals(conditionid)) {%> selected <%}%>><%=conditionnames.get(i)%></option>
            <%}%>
        </select>
      </td>
      <td><input type=text class=inputstyle size=50 name="conditioncnname<%=conrecorderindex%>" value="<%=conditioncnname%>">
      </td>
      <td><input type=text class=inputstyle size=50 name="conditionenname<%=conrecorderindex%>" value="<%=conditionenname%>">
      </td>
    </tr>
    <% conrecorderindex ++ ; } %>
    </tbody> 
  </table>
  <br>
  <table class=liststyle cellspacing=1 >
    <colgroup> <col width="40%"><col width="30%"><col width="30%">
    <tbody> 
    <tr class=header> 
      <td><b>报表共享</b></td>
      <td align=right colspan=2> <button type="button" class=btn accesskey=R onClick="onShowResource()"><u>R</u>-人力资源</button>
      <button type="button" class=btn accesskey=O onClick="onShowRolesID()"><u>O</u>-角色</button> 
	  <!--button class=btn accesskey=N onClick="onShowCustomer()"><u>N</u>-基层单位</button-->
      </td>
    </tr>
    <tr  class=line  style="height:1px"> 
      <td colspan=3 style="padding:0;"></td>
    </tr>
    <% 
    boolean isLight = false ;
	rs.executeProc("T_OutRShare_SelectByOutrepid",""+outrepid);
	while(rs.next()) {
		String outrepshareid = Util.null2String(rs.getString("outrepshareid")) ;
		String userid = Util.null2String(rs.getString("userid")) ;
		String usertype = Util.null2String(rs.getString("usertype")) ;
        int sharelevel = Util.getIntValue(rs.getString("sharelevel"),0) ;
		String username = "" ;
		if(usertype.equals("1")) username = Util.toScreen(ResourceComInfo.getResourcename(userid),user.getLanguage()) ;
		else username = Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(userid),user.getLanguage()) ;
		
        isLight = ! isLight ;
  	%>
    <TR class='<%=( isLight ? "datalight" : "datadark" )%>'>
      <td><%=username%></td>
      <td><INPUT type=checkbox name="sharelevels" value="<%=outrepshareid%>" <% if(sharelevel ==1) { %> checked <% } %>>下载</td>
      <td><a onClick="deleteUser('<%=outrepshareid%>')" style="CURSOR:HAND"><img border=0 src="/images/icon_delete.gif"></a></td>
    </tr>
    <%}%>
    </tbody> 
  </table>
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

<% if(outrepcategory.equals("1")) { /* 如果报表为1：明细报表 ， 增加加一行的功能 */ %>
<script language=javascript>

var rowindex1= <%=recorderindex%> ;
var totalrows1= <%=recorderindex%> ;
frmMain.totaldetail1.value=rowindex1;

function addRow1()
{	
	ncol = oTable1.attributes["cols"].nodeValue;
	oRow = oTable1.insertRow(-1);	
	for(j=0; j<ncol; j++) {
		oCell = oRow.insertCell(-1); 
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

</script>
<%}%>


<script language=javascript>

function onStatDef(){
	 	document.frmMain.action="OutReportStatitem.jsp";
		document.frmMain.submit();
 }


function onItemDef(){
	 	document.frmMain.action="OutReportItem.jsp";
		document.frmMain.submit();
 }

function onChange(){
	 	document.frmMain.action="OutReportChange.jsp";
		document.frmMain.submit();
 }
 

 function onSave(){
	if(check_form(document.frmMain,'inprepname')){
	 	document.frmMain.operation.value="edit";
		document.frmMain.submit();
	}
 }

 function onCopy(){
    if(confirm("确定复制该报表定义？")) {
        document.frmMain.operation.value="copy";
        document.frmMain.submit();
    }
 }

 function onDelete(){
		if(confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>")) {
			document.frmMain.operation.value="delete";
			document.frmMain.submit();
		}
}

function onShowMoudle(){
    document.frmMain.action="ReportSearchModule.jsp";
    document.frmMain.submit();
}

function deleteCondition(outrepconditionid){
    document.frmMain.operation.value = "deletecondition";
    document.frmMain.outrepconditionid.value = outrepconditionid;
    document.frmMain.submit();
}

function deleteUser(outrepshareid){
    document.frmMain.operation.value = "deleteuser";
    document.frmMain.outrepshareid.value = outrepshareid;
    document.frmMain.submit();
}


var rowindex2=<%=conrecorderindex%>;
var totalrows2=rowindex2;
frmMain.totaldetail2.value=rowindex2;

function addRow2()
{	
	var ncol=oTable2.attributes["cols"].nodeValue;
	oRow = oTable2.insertRow(-1);	
	for(j=0; j<ncol; j++) {
		oCell = oRow.insertCell(-1); 
		switch(j) {
			case 0: 
				var oDiv = document.createElement("div");
				var sHtml = "<select class=inputstyle name='conditionid"+rowindex2+"' > " +
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
				var sHtml = "<input type=text class=inputstyle size=50 name='conditioncnname"+rowindex2+"'> ";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
            case 2: 
				var oDiv = document.createElement("div");
				var sHtml = "<input type=text class=inputstyle size=50 name='conditionenname"+rowindex2+"'> ";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
		}
	}
	rowindex2 = rowindex2*1 +1;
	frmMain.totaldetail2.value=rowindex2;
	totalrows2 = rowindex2;
}

</script>
 
 <script type="text/javascript">
 function onShowCondition(){
	datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/datacenter/maintenance/condition/OutReportConditionBrowser.jsp");
	if (datas){
		if(datas.id){
	        document.frmMain.operation.value = "addcondition"
	        document.frmMain.conditionid.value = datas.id;
	        document.frmMain.submit();
		}
	}
 }
 
function onShowCustomer(){
	datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp");
	if (datas){
		if(datas.id){
	        document.frmMain.operation.value = "adduser";
	        document.frmMain.userid.value = datas.id;
	        document.frmMain.usertype.value = 2;
	        document.frmMain.submit();
		}
	}
}

function onShowResource(){
	datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp");
	if (datas){
		if(datas.id){
	        document.frmMain.operation.value = "adduser";
	        document.frmMain.userid.value = datas.id;
	        document.frmMain.usertype.value = 1;
	        document.frmMain.submit();
		}
	}
}

function onShowRolesID(){
	datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/roles/HrmRolesBrowser.jsp");
	if (datas){
		if (datas.id){
			document.frmMain.operation.value = "adduser";
	        document.frmMain.userid.value = datas.id;
	        document.frmMain.usertype.value = 3;
	        document.frmMain.submit();
		}
	}
}

</script>
 
</BODY></HTML>
