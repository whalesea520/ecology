<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Timestamp" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetFF" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RequestCheckUser" class="weaver.workflow.request.RequestCheckUser" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page"/>
<jsp:useBean id="AssetAssortmentComInfo" class="weaver.lgc.maintenance.AssetAssortmentComInfo" scope="page" />
<%	//~~~~~~~~~~~~check user's right about current request operate~~~~~~~~~~~
int requestid=Util.getIntValue(request.getParameter("requestid"),0);
String requestname="";
int workflowid=0;
int formid=0;
int nodeid=0;
String nodetype="";
int userid=user.getUID();
int hasright=0;
String status="";
int rowsum=0;
int isremark=0;
RecordSet.executeProc("FnaCurrency_SelectByDefault","");
RecordSet.next();
String defcurrenyid = RecordSet.getString(1);

boolean hasFF = true;
RecordSetFF.executeProc("Base_FreeField_Select","b4");
if(RecordSetFF.getCounts()<=0)
	hasFF = false;
else
	RecordSetFF.first();
	
char flag=Util.getSeparator() ;

RecordSet.executeProc("workflow_Requestbase_SByID",requestid+"");
if(RecordSet.next()){	
	workflowid=RecordSet.getInt("workflowid");
	nodeid=RecordSet.getInt("currentnodeid");
	nodetype=RecordSet.getString("currentnodetype");
	requestname=RecordSet.getString("requestname");
	status=RecordSet.getString("status");
}

RecordSet.executeProc("workflow_currentoperator_SByUs",userid+""+flag+requestid+"");
if(RecordSet.next())	hasright=1;
RecordSet.executeSql("select * from workflow_currentoperator where requestid="+requestid+" and userid="+userid+" and isremark='1'");
if(RecordSet.next())	isremark=1;

String user_fieldid="";
String isreopen="";
String isreject="";
String isend="";
RecordSet.executeProc("workflow_Nodebase_SelectByID",nodeid+"");
if(RecordSet.next()){
	user_fieldid=RecordSet.getString("userids");
	isreopen=RecordSet.getString("isreopen");
	isreject=RecordSet.getString("isreject");
	isend=RecordSet.getString("isend");
}

if(hasright==0&&isremark==0){
	response.sendRedirect("/notice/noright.jsp");
    	return;
}
/*
String clientip=request.getRemoteAddr();
Date newdate = new Date() ;
long datetime = newdate.getTime() ;
Timestamp timestamp = new Timestamp(datetime) ;
String CurrentDate = (timestamp.toString()).substring(0,4) + "-" + (timestamp.toString()).substring(5,7) + "-" +(timestamp.toString()).substring(8,10);
String CurrentTime = (timestamp.toString()).substring(11,13) + ":" + (timestamp.toString()).substring(14,16) + ":" +(timestamp.toString()).substring(17,19);
RecordSet.executeProc("workflow_RequestViewLog_Insert",requestid+""+flag+userid+""+flag+CurrentDate+flag+CurrentTime+flag+clientip);
*/
%>


<form name="frmmain" method="post" action="RequestBill4Operation.jsp">
<input type=hidden name=isremark>
<%
String needcheck="requestname";

String submit="";
if(nodetype.equals("0"))	submit=SystemEnv.getHtmlLabelName(615,user.getLanguage());
if(nodetype.equals("1"))	submit=SystemEnv.getHtmlLabelName(142,user.getLanguage());
if(nodetype.equals("2"))	submit=SystemEnv.getHtmlLabelName(725,user.getLanguage());
if(nodetype.equals("3"))	submit=SystemEnv.getHtmlLabelName(251,user.getLanguage());
%>
<div>

<%if(isremark==1){%>
<BUTTON class=btnSave accessKey=S type=button onclick="doRemark()"><U>S</U>-提交</button>
<%} else {%>
<%if(!isend.equals("1")){%>
<BUTTON class=btn accessKey=B type=button onclick="doSubmit()"><U>B</U>-<%=submit%></button>
<BUTTON class=btn accessKey=M type=button onclick="location.href='Remark.jsp?requestid=<%=requestid%>'"><U>M</U>-转发</button>
<%}}%>

<%if(!isend.equals("1")){%>
<BUTTON class=btnSave accessKey=S type=button onclick="doSave()"><U>S</U>-<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%></button>
<%}%>

<%if(isremark!=1){%>
<%if(isreopen.equals("1")){%>
<BUTTON class=btn accessKey=O type=button onclick="doReopen()"><U>O</U>-<%=SystemEnv.getHtmlLabelName(244,user.getLanguage())%></button>
<%}%>
<%if(isreject.equals("1")){%>
<BUTTON class=btn accessKey=J type=button onclick="doReject()"><U>J</U>-<%=SystemEnv.getHtmlLabelName(236,user.getLanguage())%></button>
<%}%>
<BUTTON class=btnDelete accessKey=S type=button onclick="doDelete()"><U>D</U>-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></button>

<%}%>
<BUTTON class=btn accessKey=1 type=button onclick="location.href='RequestView.jsp'"><U>1</U>-返回</button>
</div>
<br>
<table class=form>
  <colgroup>
  <col width="20%">
  <col width="80%">
  <TR class=Section>
    	  <TH colSpan=2>
    	  <%=SystemEnv.getHtmlLabelName(648,user.getLanguage())%>:<%=Util.toScreen(status,user.getLanguage())%>
    	  </TH></TR>
     <TR class=separator>
    	  <TD class=Sep1 colSpan=2></TD></TR>
  <tr>
  	<td>说明</td>
  	<%if(nodetype.equals("1")){%>
  	<td class=field><input type=text name=requestname value="<%=Util.toScreenToEdit(requestname,user.getLanguage())%>"
  	onChange="checkinput('requestname','requestnamespan')" size=40 maxlength=25>
  	<%if(requestname.equals("")){%><span id=requestnamespan><IMG src="/images/BacoError_wev8.gif" align=absMiddle><%}%></span>
  	</td>
  	<%} else {%>
  	<td class=field><%=Util.toScreen(requestname,user.getLanguage())%>
  	<input type=hidden name=requestname value="<%=Util.toScreenToEdit(requestname,user.getLanguage())%>"></td>
  	<%}%>
  </tr>
<%
RecordSet.executeProc("workflow_Workflowbase_SByID",workflowid+"");
RecordSet.next();
formid=RecordSet.getInt("formid");

ArrayList fieldids=new ArrayList();
ArrayList fieldnames=new ArrayList();
ArrayList fieldvalues=new ArrayList();
ArrayList fieldlabels=new ArrayList();
ArrayList fieldhtmltypes=new ArrayList();
ArrayList fieldtypes=new ArrayList();
RecordSet.executeProc("workflow_billfield_Select",formid+"");
while(RecordSet.next()){
	fieldids.add(RecordSet.getString("id"));
	fieldnames.add(RecordSet.getString("fieldname"));
	fieldlabels.add(RecordSet.getString("fieldlabel"));
	fieldhtmltypes.add(RecordSet.getString("fieldhtmltype"));
	fieldtypes.add(RecordSet.getString("type"));
}

RecordSet.executeProc("workflow_FieldValue_Select",requestid+"");
int billid = 0;
if(RecordSet.next()){
	billid = RecordSet.getInt("billid");
}

RecordSet.executeProc("bill_contract_SelectById",billid+"");
RecordSet.next();
for(int i=0;i<fieldids.size();i++){
	String fieldname=(String)fieldnames.get(i);	
	
	fieldvalues.add(RecordSet.getString(fieldname));
	
}

ArrayList isviews=new ArrayList();
ArrayList isedits=new ArrayList();
ArrayList ismands=new ArrayList();
RecordSet1.executeProc("workflow_FieldForm_Select",nodeid+"");
while(RecordSet1.next()){
	isviews.add(RecordSet1.getString("isview"));
	isedits.add(RecordSet1.getString("isedit"));
	ismands.add(RecordSet1.getString("ismandatory"));
}

for(int i=0;i<fieldids.size();i++){
	String fieldid=(String)fieldids.get(i);
	String fieldvalue=(String)fieldvalues.get(i);
	String isview=(String)isviews.get(i);
	String isedit=(String)isedits.get(i);
	String ismand=(String)ismands.get(i);
	String fieldhtmltype=(String)fieldhtmltypes.get(i);
	String fieldtype=(String)fieldtypes.get(i);
	String fieldlable=SystemEnv.getHtmlLabelName(Util.getIntValue((String)fieldlabels.get(i),0),user.getLanguage());
	
	if(fieldhtmltype.equals("3") && fieldvalue.equals("0")) fieldvalue = "" ;

   if(isview.equals("1")){
%>
   <tr>
<%if(fieldhtmltype.equals("2")){%>
   	<td valign=top><%=Util.toScreen(fieldlable,user.getLanguage())%></td>
<%}else{%>
   	<td><%=Util.toScreen(fieldlable,user.getLanguage())%></td>
<%}%>   	<td class=field>
<%
	if(fieldhtmltype.equals("1")){
		if(fieldtype.equals("1")){
			if(isedit.equals("1")&&isremark==0){
				if(ismand.equals("1")) {%>
		<input type=text name="field<%=fieldid%>" value="<%=Util.toScreenToEdit(fieldvalue,user.getLanguage())%>"
		onChange="checkinput('field<%=fieldid%>','field<%=fieldid%>span')">
		<span id="field<%=fieldid%>span"><%if(fieldvalue.equals("")){%><img src="/images/BacoError_wev8.gif" align=absmiddle><%}%></span>
				<%
					needcheck+=",field"+fieldid;
				}else{%>
		<input type=text name="field<%=fieldid%>" value="<%=Util.toScreenToEdit(fieldvalue,user.getLanguage())%>">
				<%}
			}else{
		%><%=Util.toScreen(fieldvalue,user.getLanguage())%>
		<input type=hidden name="field<%=fieldid%>" value="<%=Util.toScreenToEdit(fieldvalue,user.getLanguage())%>">
		<%
			}
		}
		else{
			if(isedit.equals("1")&&isremark==0){
				if(ismand.equals("1")) {%>
		<input type=text name="field<%=fieldid%>" value="<%=Util.toScreenToEdit(fieldvalue,user.getLanguage())%>"
		onChange="checkinput('field<%=fieldid%>','field<%=fieldid%>span')" onKeyPress="ItemCount_KeyPress()" onBlur='checknumber1(this)'>
		<span id="field<%=fieldid%>span"><%if(fieldvalue.equals("")){%><img src="/images/BacoError_wev8.gif" align=absmiddle><%}%></span>
				<%
					needcheck+=",field"+fieldid;
				}else{%>
		<input type=text name="field<%=fieldid%>" value="<%=Util.toScreenToEdit(fieldvalue,user.getLanguage())%>"
		onKeyPress="ItemCount_KeyPress()" onBlur='checknumber1(this)'>
				<%}
			}else{
		%><%=Util.toScreen(fieldvalue,user.getLanguage())%>
		<input type=hidden name="field<%=fieldid%>" value="<%=Util.toScreenToEdit(fieldvalue,user.getLanguage())%>"><%
			}
		}
	}
	else if(fieldhtmltype.equals("2")){
		if(isedit.equals("1")&&isremark==0){
			if(ismand.equals("1")) {%>
		<textarea name="field<%=fieldid%>" onChange="checkinput('field<%=fieldid%>','field<%=fieldid%>span')" 
		 style="width=60%"><%=Util.toScreenToEdit(fieldvalue,user.getLanguage())%></textarea>
		<span id="field<%=fieldid%>span"><%if(fieldvalue.equals("")){%><img src="/images/BacoError_wev8.gif" align=absmiddle><%}%></span>
			<%
				needcheck+=",field"+fieldid;
			}else{%>
		<textarea name="field<%=fieldid%>" style="width=60%"><%=Util.toScreenToEdit(fieldvalue,user.getLanguage())%></textarea>
			<%}
		}else{
		%><%=Util.toScreen(fieldvalue,user.getLanguage())%>
		<input type=hidden name="field<%=fieldid%>" value="<%=Util.toScreenToEdit(fieldvalue,user.getLanguage())%>">
		<%
			}
	}
	else if(fieldhtmltype.equals("3")){
		String url=BrowserComInfo.getBrowserurl(fieldtype);
		String tablename=BrowserComInfo.getBrowsertablename(fieldtype);
		String columname=BrowserComInfo.getBrowsercolumname(fieldtype);
		String keycolumname=BrowserComInfo.getBrowserkeycolumname(fieldtype);
		String linkurl = Util.null2String(BrowserComInfo.getLinkurl(fieldtype));
		int intfieldvalue=Util.getIntValue(fieldvalue,0);
		String sql="select "+columname+" from "+tablename+" where "+keycolumname+"="+intfieldvalue;
		RecordSet1.executeSql(sql);
		RecordSet1.next();
		String showname=RecordSet1.getString(1);
		if(fieldtype.equals("2"))	showname=fieldvalue;
		%>
		<%if(isedit.equals("1")&&isremark==0){%><button class=Browser onclick="onShowBrowser('<%=fieldid%>','<%=url%>','<%=fieldtype%>','<%=ismand%>','<%=linkurl%>')"></button><%}%>
		<input type=hidden name="field<%=fieldid%>" value="<%=Util.toScreen(fieldvalue,user.getLanguage())%>">
		<%if(linkurl.equals("")){
		%>
			<span id="field<%=fieldid%>span"><%=Util.toScreen(showname,user.getLanguage())%></span>
		<%}else{%>
		<span id="field<%=fieldid%>span"><a href='<%=linkurl%><%=intfieldvalue%>'><%=Util.toScreen(showname,user.getLanguage())%></a></span>
		<%}%>
		<%if(ismand.equals("1")){%><%if(fieldvalue.equals("")){%><img src="/images/BacoError_wev8.gif" align=absmiddle><%}%>
		<%	needcheck+=",field"+fieldid;	
			}%>
		</span>
		<%
	}
	else if(fieldhtmltype.equals("4")){
	%>
		<input type=checkbox value=1 name="field<%=fieldid%>" 
		<%if(isedit.equals("0")||isremark==1){%> DISABLED <%}%> <%if(fieldvalue.equals("1")){%> checked <%}%>>
	<%}
%>
   	</td>
   </tr>
<%
   }else { %>
   <input type=hidden name="field<%=fieldid%>" value="<%=Util.toScreenToEdit(fieldvalue,user.getLanguage())%>">
 <%}
}
%>

<%
if(hasFF)
{
	for(int i=1;i<=5;i++)
	{
		if(RecordSetFF.getString(i*2+1).equals("1"))
		{%>
        <TR>
          <TD><%=Util.toScreen(RecordSetFF.getString(i*2),user.getLanguage())%></TD>
          <TD class=Field><BUTTON class=Calendar onclick="getDate(<%=i%>)"></BUTTON> 
              <SPAN id=datespan<%=i%> ><%=RecordSet.getString("datefield"+i)%></SPAN> 
              <input type="hidden" name="dff0<%=i%>" id="dff0<%=i%>" value="<%=RecordSet.getString("datefield"+i)%>"></TD>
        </TR>
		<%}
	}
	for(int i=1;i<=5;i++)
	{
		if(RecordSetFF.getString(i*2+11).equals("1"))
		{%>
        <TR>
          <TD><%=Util.toScreen(RecordSetFF.getString(i*2+10),user.getLanguage())%></TD>
          <TD class=Field><INPUT class=saveHistory maxLength=30 size=30 name="nff0<%=i%>" value="<%=RecordSet.getString("numberfield"+i)%>"></TD>
        </TR>
		<%}
	}
	for(int i=1;i<=5;i++)
	{
		if(RecordSetFF.getString(i*2+21).equals("1"))
		{%>
        <TR>
          <TD><%=Util.toScreen(RecordSetFF.getString(i*2+20),user.getLanguage())%></TD>
          <TD class=Field><INPUT class=saveHistory maxLength=100 size=30 name="tff0<%=i%>" value="<%=Util.toScreen(RecordSet.getString("textfield"+i),user.getLanguage())%>"></TD>
        </TR>
		<%}
	}
	for(int i=1;i<=5;i++)
	{
		if(RecordSetFF.getString(i*2+31).equals("1"))
		{%>
        <TR>
          <TD><%=Util.toScreen(RecordSetFF.getString(i*2+30),user.getLanguage())%></TD>
          <TD class=Field><INPUT type=checkbox name="bff0<%=i%>" value="1" <%if(RecordSet.getString("tinyintfield"+i).equals("1")){%> checked<%}%>></TD>
        </TR>
		<%}
	}
}
%>

<TR class=Section>
    	  <TH colSpan=2>
    	  资产
    	  </TH></TR>
     <TR class=separator>
    	  <TD class=Sep1 colSpan=2></TD></TR>
  <tr>
  <table Class=ListShort cols=9 id="oTable">
      	<COLGROUP>
      	<COL width="4%">
  	<COL width="14%">
  	<COL width="13%">
  	<COL width="13%">
  	<COL width="13%">
  	<COL width="13%">
  	<COL width="10%">
  	<COL width="10%">
  	<COL width="10%">
    	   <tr class=header> 
    	   <td>选中</td>
            <td>资产</td>
            <td>批号</td>
            <td>数量</td>
            <td>单价</td>
            <td>税率(%)</td>
            <td>金额</td>
            <td>税额</td>
            <td>税价合计</td>
            </tr>
            <%
RecordSet.executeProc("bill_contractdetail_Select",billid+"");
while(RecordSet.next())
{
%>
 <tr style="height:24;background:#D2D1F1"> 
 <td><input type='checkbox' name='check_node' value='<%=RecordSet.getInt("id")%>'>
 <input type="hidden" name="node_<%=rowsum%>_id" size=25 value="<%=RecordSet.getString("id")%>">
 </td>
 
  <td><button class=Browser onClick='onShowAsset(node_<%=rowsum%>_assetspan,node_<%=rowsum%>_assetid)'></button>
	<span class=saveHistory id=node_<%=rowsum%>_assetspan>
	<%=AssetAssortmentComInfo.getAssortmentName(RecordSet.getString("assetid"))%>
	</span>
	<input type='hidden' name='node_<%=rowsum%>_assetid' id='node_<%=rowsum%>_assetid' value='<%=RecordSet.getString("assetid")%>'>
</td>
  <td>
  <input type='input' style=width:100% name='node_<%=rowsum%>_batchmark' value='<%=RecordSet.getString("batchmark")%>'>
  </td>
  <td>
  <input type='input' style=width:100% name='node_<%=rowsum%>_number' value='<%=RecordSet.getString("number_n")%>' onchange='changenumber(<%=rowsum%>)'>
  </td>
  <td>
  <input type='input' style=width:100% name='node_<%=rowsum%>_unitprice' value='<%=RecordSet.getString("unitprice")%>' onchange='changenumber(<%=rowsum%>)'>
  </td>
  <td>
  <input type='input' style=width:100% name='node_<%=rowsum%>_taxrate' value='<%=RecordSet.getString("taxrate")%>' onchange='changenumber(<%=rowsum%>)'>
  </td>
  <td>
  <span id='node_<%=rowsum%>_totalprice' name='node_<%=rowsum%>_totalprice'><%=(RecordSet.getFloat("number_n")*RecordSet.getFloat("unitprice"))%></span>
  </td>
  <td>
  <span id='node_<%=rowsum%>_totaltax' name='node_<%=rowsum%>_totaltax'><%=(RecordSet.getFloat("number_n")*RecordSet.getFloat("unitprice"))*(RecordSet.getInt("taxrate")/100.0)%></span>
  </td>
  <td>
  <span id='node_<%=rowsum%>_total' name='node_<%=rowsum%>_total'><%=(RecordSet.getFloat("number_n")*RecordSet.getFloat("unitprice"))*(1+RecordSet.getInt("taxrate")/100.0)%></span>
  </td>
  
</tr>
 <%
 rowsum += 1;
 }
 %>     
            
  </table>
  
  </tr>  	  
<br>
<BUTTON Class=Btn type=button accessKey=A onclick="addRow();"><U>A</U>-添加</BUTTON>
<BUTTON Class=Btn type=button accessKey=E onclick="deleteRow1();"><U>E</U>-删除</BUTTON></div>
<br>
</table>
<%@ include file="/workflow/request/WorkflowManageSign.jsp" %>

<input type=hidden name="requestid" value=<%=requestid%>>
<input type=hidden name="workflowid" value=<%=workflowid%>>
<input type=hidden name="nodeid" value=<%=nodeid%>>
<input type=hidden name="nodetype" value=<%=nodetype%>>
<input type=hidden name="src">
<input type=hidden name="iscreate" value="0">
<input type=hidden name="formid" value=<%=formid%>>
<input type="hidden" value="0" name="nodesnum">
<input type="hidden" value="" name="delids">
<input type="hidden" value="<%=defcurrenyid%>" name="defcurrencyid">
<input type=hidden name="billid" value=<%=billid%>>
</form>
<script language=javascript>
rowindex = "<%=rowsum%>";
delids = "";
function addRow()
{
	ncol = oTable.cols;
	
	oRow = oTable.insertRow(-1);
	
	for(j=0; j<ncol; j++) {
		oCell = oRow.insertCell(-1);  
		oCell.style.height=24;
		oCell.style.background= "#D2D1F1";
		switch(j) {
			case 0:
				var oDiv = document.createElement("div");
				var sHtml = "<input type='checkbox' name='check_node' value='0'>"; 
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			
			case 1: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<button class=Browser onClick='onShowAsset(node_"+rowindex+"_assetspan,node_"+rowindex+"_assetid)'></button> " + 
        					"<span class=saveHistory id=node_"+rowindex+"_assetspan><img src='/images/BacoError_wev8.gif' align=absMiddle></span> "+
        					"<input type='hidden' name='node_"+rowindex+"_assetid' id='node_"+rowindex+"_assetid'>";
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				break;
			case 2: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<input type='input' style=width:100% name='node_"+rowindex+"_batchmark'>";
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				break;
			case 3: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<input type='input' style=width:100%  name='node_"+rowindex+"_number' onchange='changenumber("+rowindex+")'>";
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				break;
			case 4: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<input type='input' style=width:100% name='node_"+rowindex+"_unitprice' onchange='changenumber("+rowindex+")'>";
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				break;
			case 5: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<input type='input'  style=width:100%  name='node_"+rowindex+"_taxrate' onchange='changenumber("+rowindex+")'>";
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				break;
			case 6: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<span id='node_"+rowindex+"_totalprice' name='node_"+rowindex+"_totalprice'></span>";
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				break;
			case 7: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<span id='node_"+rowindex+"_totaltax' name='node_"+rowindex+"_totaltax'></span>";
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				break;
			case 8: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<span id='node_"+rowindex+"_total' name='node_"+rowindex+"_total'></span>";
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				break;
			
		}
	}
	rowindex = rowindex*1 +1;
	
}

function changenumber(rowval){
	document.all("node_"+rowval+"_totalprice").innerHTML = document.all("node_"+rowval+"_number").value * document.all("node_"+rowval+"_unitprice").value;
	document.all("node_"+rowval+"_totaltax").innerHTML = document.all("node_"+rowval+"_number").value * document.all("node_"+rowval+"_unitprice").value * document.all("node_"+rowval+"_taxrate").value/100.0;
	document.all("node_"+rowval+"_total").innerHTML = document.all("node_"+rowval+"_totalprice").innerHTML/1 + document.all("node_"+rowval+"_totaltax").innerHTML/1;
	
}

function deleteRow1()
{
	var flag = false;
	var ids = document.getElementsByName('check_node');
	for(i=0; i<ids.length; i++) {
		if(ids[i].checked==true) {
			flag = true;
			break;
		}
	}
    if(flag) {
		if(isdel()){
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
                        if(document.forms[0].elements[i].value!='0')
                            delids +=","+ document.forms[0].elements[i].value;
                        oTable.deleteRow(rowsum1);
                    }
                    rowsum1 -=1;
                }

            }
        }
    }else{
        alert('<%=SystemEnv.getHtmlLabelName(22686,user.getLanguage())%>');
		return;
    }
}	
	
	function doRemark(){
		document.frmmain.isremark.value='1';
		document.frmmain.src.value='save';
		document.frmmain.remark.disabled=false ;
		//附件上传
                        StartUploadAll();
                        checkuploadcomplet();
	}
	function doSave(){
		if(check_form(document.frmmain,'<%=needcheck%>')){
			document.frmmain.src.value='save';
			document.frmmain.nodesnum.value=rowindex;
			document.frmmain.delids.value=delids;
			document.frmmain.remark.disabled=false ;
			//附件上传
                        StartUploadAll();
                        checkuploadcomplet();
		}
	}
	function doSubmit(){
		if(check_form(document.frmmain,'<%=needcheck%>')){
			document.frmmain.src.value='submit';
			document.frmmain.nodesnum.value=rowindex;
			document.frmmain.delids.value=delids;
			document.frmmain.remark.disabled=false ;
			//附件上传
                        StartUploadAll();
                        checkuploadcomplet();
		}
	}
	function doReject(){
			document.frmmain.src.value='reject';
			document.frmmain.nodesnum.value=rowindex;
			document.frmmain.delids.value=delids;
			document.frmmain.remark.disabled=false ;
        if(onSetRejectNode()){
			//附件上传
                        StartUploadAll();
                        checkuploadcomplet();
        }
	}
	function doReopen(){
			document.frmmain.src.value='reopen';
			document.frmmain.nodesnum.value=rowindex;
			document.frmmain.delids.value=delids;
			document.frmmain.remark.disabled=false ;
			//附件上传
                        StartUploadAll();
                        checkuploadcomplet();
	}
	function doDelete(){
			document.frmmain.src.value='delete';
			document.frmmain.nodesnum.value=rowindex;
			document.frmmain.delids.value=delids;
			document.frmmain.remark.disabled=false ;
			//附件上传
                        StartUploadAll();
                        checkuploadcomplet();
	}
</script>
<script language=vbs>

sub onShowAsset(spanname,inputname)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/lgc/asset/LgcAssetBrowser.jsp")
	if NOT isempty(id) then
	    if id(0)<> "" then
		spanname.innerHtml = id(1)
		inputname.value=id(0)
		else
		spanname.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
		inputname.value=""
		end if
	end if
end sub
</script>