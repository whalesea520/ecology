<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="java.util.*,java.sql.Timestamp" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="FieldComInfo" class="weaver.workflow.field.FieldComInfo" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<script type="text/javascript" language="javascript" src="/FCKEditor/fckeditor_wev8.js"></script>
<script type="text/javascript" language="javascript" src="/FCKEditor/FCKEditorExt_wev8.js"></script>
<%	
String newfromdate="a";
String newenddate="b";
String workflowid=Util.null2String(request.getParameter("workflowid"));
String nodeid=Util.null2String(request.getParameter("nodeid"));
String formid=Util.null2String(request.getParameter("formid"));
//对不同的模块来说,可以定义自己相关的工作流
String prjid = Util.null2String(request.getParameter("prjid"));
String docid = Util.null2String(request.getParameter("docid"));
String crmid = Util.null2String(request.getParameter("crmid"));
String hrmid = Util.null2String(request.getParameter("hrmid"));
//......
String topage = Util.null2String(request.getParameter("topage"));
                     
int userid=user.getUID();
String logintype = user.getLogintype();

Date newdate = new Date() ;
long datetime = newdate.getTime() ;
Timestamp timestamp = new Timestamp(datetime) ;
String currentdate = (timestamp.toString()).substring(0,4) + "-" + (timestamp.toString()).substring(5,7) + "-" +(timestamp.toString()).substring(8,10);
String currenttime = (timestamp.toString()).substring(11,13) +":" +(timestamp.toString()).substring(14,16)+":"+(timestamp.toString()).substring(17,19);
String username = "";
if(logintype.equals("1"))
	username = Util.toScreen(ResourceComInfo.getResourcename(""+userid),user.getLanguage()) ;
if(logintype.equals("2"))
	username = Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(""+userid),user.getLanguage());

String workflowname=WorkflowComInfo.getWorkflowname(workflowid);
String resourceid=user.getUID()+"";
String needcheck="requestname";
String isSignDoc_add="";
String isSignWorkflow_add="";
RecordSet.execute("select titleFieldId,keywordFieldId,isSignDoc,isSignWorkflow from workflow_base where id="+workflowid);
if(RecordSet.next()){
    isSignDoc_add=Util.null2String(RecordSet.getString("isSignDoc"));
    isSignWorkflow_add=Util.null2String(RecordSet.getString("isSignWorkflow"));
}
%>
<form name="frmmain" method="post" action="BillHotelBookOperation.jsp">
<input type=hidden name="workflowid" value=<%=workflowid%>>
<input type=hidden name="nodeid" value=<%=nodeid%>>
<input type=hidden name="nodetype" value="0">
<input type=hidden name="src">
<input type=hidden name="iscreate" value="1">
<input type=hidden name="formid" value=<%=formid%>>
<input type=hidden name ="topage" value="<%=topage%>">
<input type="hidden" value="0" name="nodesnum">

  <div> 
    <BUTTON class=btn accessKey=B type=button onclick="doSubmit()"><U>B</U>-<%=SystemEnv.getHtmlLabelName(615,user.getLanguage())%></button> 
    <BUTTON class=btnSave accessKey=S type=button onclick="doSave()"><U>S</U>-<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%></button> 
  </div>
  <div align="center"><br>
    <font style="font-size:14pt;FONT-WEIGHT: bold"><%=Util.toScreen(workflowname,user.getLanguage())%></font> <br>
    <br>
  </div>
  <table class=form>
    <colgroup> <col width="20%"> <col width="80%"> 
    <tr class=separator> 
      <td class=Sep1 colspan=2></td>
    </tr>
    <tr> 
      <td>说明</td>
      <td class=field> 
        <input type=text name=requestname onChange="checkinput('requestname','requestnamespan')" size=40 maxlength=25
        value="<%=Util.toScreenToEdit(workflowname+"-"+username+"-"+currentdate,user.getLanguage())%>">
        <span id=requestnamespan></span> 
        <input type=radio value="0" name="requestlevel" checked>正常
        <input type=radio value="1" name="requestlevel">重要
        <input type=radio value="2" name="requestlevel">紧急
      </td>
    </tr>
    <%
ArrayList fieldids=new ArrayList();
ArrayList fieldlabels=new ArrayList();
ArrayList fieldhtmltypes=new ArrayList();
ArrayList fieldtypes=new ArrayList();
ArrayList fieldnames=new ArrayList();
RecordSet.executeProc("workflow_billfield_Select",formid+"");
while(RecordSet.next()){
	fieldids.add(RecordSet.getString("id"));
	fieldlabels.add(RecordSet.getString("fieldlabel"));
	fieldhtmltypes.add(RecordSet.getString("fieldhtmltype"));
	fieldtypes.add(RecordSet.getString("type"));
	fieldnames.add(RecordSet.getString("fieldname"));
}

ArrayList isviews=new ArrayList();
ArrayList isedits=new ArrayList();
ArrayList ismands=new ArrayList();
RecordSet.executeProc("workflow_FieldForm_Select",nodeid+"");
while(RecordSet.next()){
	isviews.add(RecordSet.getString("isview"));
	isedits.add(RecordSet.getString("isedit"));
	ismands.add(RecordSet.getString("ismandatory"));
}
for(int i=0;i<fieldids.size();i++){
	String fieldname=(String)fieldnames.get(i);
	String fieldid=(String)fieldids.get(i);
	String isview=(String)isviews.get(i);
	String isedit=(String)isedits.get(i);
	String ismand=(String)ismands.get(i);
	String fieldhtmltype=(String)fieldhtmltypes.get(i);
	String fieldtype=(String)fieldtypes.get(i);
	String fieldlable=SystemEnv.getHtmlLabelName(Util.getIntValue((String)fieldlabels.get(i),0),user.getLanguage());
	if(fieldname.equals("begindate")) newfromdate="field"+fieldid;
	if(fieldname.equals("enddate")) newenddate="field"+fieldid;
   if(isview.equals("1")){
%>
    <tr> 
      <%if(fieldhtmltype.equals("2")){%>
      <td valign=top><%=Util.toScreen(fieldlable,user.getLanguage())%></td>
      <%}else{%>
      <td><%=Util.toScreen(fieldlable,user.getLanguage())%></td>
      <%}%>
      <td class=field> 
        <%
	if(fieldhtmltype.equals("1")){
		if(fieldtype.equals("1")){
			if(isedit.equals("1")){
				if(ismand.equals("1")) {%>
        <input type=text name="field<%=fieldid%>" onChange="checkinput('field<%=fieldid%>','field<%=fieldid%>span')" style="width:50%">
        <span id="field<%=fieldid%>span"><img src="/images/BacoError_wev8.gif" align=absmiddle></span> 
        <%
					needcheck+=",field"+fieldid;
				}else{%>
        <input type=text name="field<%=fieldid%>" style="width:50%">
        <%}
			}
		}
		else if(fieldtype.equals("2")){
			if(isedit.equals("1")){
				if(ismand.equals("1")) {%>
        <input type=text name="field<%=fieldid%>" style="width:50%"
		onKeyPress="ItemCount_KeyPress()" onBlur="checkcount1(this);checkinput('field<%=fieldid%>','field<%=fieldid%>span')">
        <span id="field<%=fieldid%>span"><img src="/images/BacoError_wev8.gif" align=absmiddle></span> 
        <%
					needcheck+=",field"+fieldid;
				}else{%>
        <input type=text name="field<%=fieldid%>" onKeyPress="ItemCount_KeyPress()" onBlur='checkcount1(this)' style="width:50%">
        <%}
			}
		}
		else if(fieldtype.equals("3")){
			if(isedit.equals("1")){
				if(ismand.equals("1")) {%>
        <input type=text name="field<%=fieldid%>" style="width:50%"
		onKeyPress="ItemNum_KeyPress()" onBlur="checknumber1(this);checkinput('field<%=fieldid%>','field<%=fieldid%>span')">
        <span id="field<%=fieldid%>span"><img src="/images/BacoError_wev8.gif" align=absmiddle></span> 
        <%
					needcheck+=",field"+fieldid;
				}else{%>
        <input type=text name="field<%=fieldid%>" onKeyPress="ItemNum_KeyPress()" onBlur='checknumber1(this)' style="width:50%">
        <%}
			}
		}
	}
	else if(fieldhtmltype.equals("2")){
		if(isedit.equals("1")){
			if(ismand.equals("1")) {%>
        <textarea name="field<%=fieldid%>" onChange="checkinput('field<%=fieldid%>','field<%=fieldid%>span')"
		rows="4" cols="40" style="width:80%"></textarea>
        <span id="field<%=fieldid%>span"><img src="/images/BacoError_wev8.gif" align=absmiddle></span> 
        <%
				needcheck+=",field"+fieldid;
			}else{%>
        <textarea name="field<%=fieldid%>" rows=4 cols=40 style="width:80%"></textarea>
        <%}
		}
	}
	else if(fieldhtmltype.equals("3")){
		String url=BrowserComInfo.getBrowserurl(fieldtype);
		String linkurl=BrowserComInfo.getLinkurl(fieldtype);
		String showname = "";
		int tmpid = 0;
		if(fieldtype.equals("8") && !prjid.equals("")){
			tmpid = Util.getIntValue(prjid,0);
		}else if(fieldtype.equals("9") && !docid.equals("")){
			tmpid = Util.getIntValue(docid,0);
		}else if(fieldtype.equals("7") && !crmid.equals("")){
			tmpid = Util.getIntValue(crmid,0);
		}else if(fieldtype.equals("4") && !hrmid.equals("")){
			tmpid = Util.getIntValue(ResourceComInfo.getDepartmentID(hrmid),0);
		}else if(fieldtype.equals("1") && !hrmid.equals("")){
			tmpid = Util.getIntValue(hrmid,0);
		}
		String showid = "";
		if(tmpid!=0)
			showid = ""+tmpid;
		if(tmpid !=0){
			String tablename=BrowserComInfo.getBrowsertablename(fieldtype);
			String columname=BrowserComInfo.getBrowsercolumname(fieldtype);
			String keycolumname=BrowserComInfo.getBrowserkeycolumname(fieldtype);
			String sql="select "+columname+" from "+tablename+" where "+keycolumname+"="+tmpid;
			RecordSet.executeSql(sql);
			if(RecordSet.next())
			{
				if("/hrm/resource/HrmResource.jsp?id=".equals(linkurl))
            	{
            		showname = "<a href='javaScript:openhrm(" + tmpid + ");' onclick='pointerXY(event);'>" + RecordSet.getString(1) + "</a>&nbsp";
            	}
				else
					showname = "<a href='"+linkurl+tmpid+"'>"+RecordSet.getString(1)+"</a>&nbsp";
			}
		}
		if(isedit.equals("1")){
		%>
        <button class=Browser onClick="onShowBrowser('<%=fieldid%>','<%=url%>','<%=linkurl%>','<%=fieldtype%>','<%=ismand%>')"></button> 
        <%}%>
        <input type=hidden name="field<%=fieldid%>" value="<%=showid%>">
        <span id="field<%=fieldid%>span"> 
        <%=Util.toScreen(showname,user.getLanguage())%>
        <%if(ismand.equals("1") && showname.equals("")){%>
        <img src="/images/BacoError_wev8.gif" align=absmiddle> 
        <%	needcheck+=",field"+fieldid;	
			}%>
        </span> 
        <%
	}
	else if(fieldhtmltype.equals("4")){
	%>
        <input type=checkbox value=1 name="field<%=fieldid%>" <%if(isedit.equals("0")){%> DISABLED <%}%> >
        <%}
    else if(fieldhtmltype.equals("5")){
	    if(fieldname.equals("payterm")){
	%>
	    <select name="field<%=fieldid%>" size=1>
	        <option value="0">老三样</option>
	        <option value="1">自己支付</option>
	        <option value="2">公司全付</option>
	    </select> 
	<%  }
	    continue;
	}
%>
      </td>
    </tr>
    <%
   }
}
%>
    <tr>
    <td>宾馆预定详细信息</td>
    <td>&nbsp;</td>
    </tr>
    <tr class=Section> 
      <td colspan=2>
	  <table class=form>
	  <!-- 详细信息 -->
	  <tr><td>
		<BUTTON Class=Btn type=button accessKey=A onclick="addRow1()"><U>A</U>-添加</BUTTON>
		<BUTTON Class=Btn type=button accessKey=E onclick="deleteRow1();"><U>E</U>-删除</BUTTON>
		<br> </td>
      </tr>
      <TR class=separator>
    	  <TD class=Sep1></TD></TR>
	  <tr><td>
	    <table Class=ListShort cols=4 id="oTable1">
	      <COLGROUP> 
	      <COL width="10%"><COL width="35%"> <COL width="35%"><COL width="20%">
	      <tr class=header> 
	        <td>&nbsp;</td>
	        <td>宾馆名称</td>
	        <td>房型</td>
	        <td>房间数</td>
	      </tr>
	    </table>
	   </td></tr>
      </table>
      </td>
    </tr>   	      	  
	<tr class="Title">
      <td colspan=2 align="center" valign="middle"><font style="font-size:14pt;FONT-WEIGHT: bold"><%=SystemEnv.getHtmlLabelName(17614,user.getLanguage())%></font></td>
    </tr>
    <tr>
      <td><%=SystemEnv.getHtmlLabelName(504,user.getLanguage())%></td>
      <td class=field>
		<input type="hidden" id="remarkText10404" name="remarkText10404" value="">
        <textarea name=remark rows=4 cols=40 style="width=80%;display:none"></textarea>
<script defer>
function funcremark_log(){
	FCKEditorExt.initEditor("frmmain","remark",<%=user.getLanguage()%>,FCKEditorExt.NO_IMAGE);
	FCKEditorExt.toolbarExpand(false);
}
funcremark_log();
</script>
      </td>
    </tr>
    <tr><td class=Line2 colSpan=2></td></tr>
  <%
         if("1".equals(isSignDoc_add)){
         %>
          <tr>
            <td><%=SystemEnv.getHtmlLabelName(857,user.getLanguage())%></td>
            <td class=field>
                <input type="hidden" id="signdocids" name="signdocids">
                <button class=Browser onclick="onShowSignBrowser('/docs/docs/MutiDocBrowser.jsp','/docs/docs/DocDsp.jsp?isrequest=1&id=','signdocids','signdocspan',37)" title="<%=SystemEnv.getHtmlLabelName(857,user.getLanguage())%>"></button>
                <span id="signdocspan"></span>
            </td>
          </tr>
          <tr><td class=Line2 colSpan=2></td></tr>
         <%}%>
     <%
         if("1".equals(isSignWorkflow_add)){
         %>
          <tr>
            <td><%=SystemEnv.getHtmlLabelName(1044,user.getLanguage())%></td>
            <td class=field>
                <input type="hidden" id="signworkflowids" name="signworkflowids">
                <button class=Browser onclick="onShowSignBrowser('/workflow/request/MultiRequestBrowser.jsp','/workflow/request/ViewRequest.jsp?isrequest=1&requestid=','signworkflowids','signworkflowspan',152)" title="<%=SystemEnv.getHtmlLabelName(1044,user.getLanguage())%>"></button>
                <span id="signworkflowspan"></span>
            </td>
          </tr>
          <tr><td class=Line2 colSpan=2></td></tr>
         <%}%>
  </table>
</form>
 
<script language=javascript>
rowindex1 = 0 ;

function addRow1()
{	
	ncol = oTable1.cols;
	oRow = oTable1.insertRow(-1);
	for(j=0; j<ncol; j++) {
		oCell = oRow.insertCell(-1);  
		oCell.style.height=24;
		oCell.style.background= "#D2D1F1";
		switch(j) {
			case 0:
				var oDiv = document.createElement("div");
				var sHtml = "<input type='checkbox' name='check_type' value='"+rowindex1+"'>"; 
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 1: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<button class=browser name='hotel_"+rowindex1+"_browser' "+
				        " onclick=onShowHotel(hotelid_"+rowindex1+",hotelspan_"+rowindex1+")>"+
				        " </button> <input type=hidden name='hotelid_"+rowindex1+"'> "+
				        " <span id='hotelspan_"+rowindex1+"'><img src='/images/BacoError_wev8.gif' align=absmiddle></span>";
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				break;
			case 2: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<input type='input' name='roomstyle_"+rowindex1+"' style='width=80%'>";
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				break; 
				break;
			case 3: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<nobr><input type='text' style=width:50%  id='roomsum_"+rowindex1+"' name='roomsum_"+
				rowindex1+"' onKeyPress='ItemCount_KeyPress()' onBlur='checkcount1(this)'>";
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv); 
				break; 
		}
	}
	rowindex1 = rowindex1*1 +1;
}

function deleteRow1()
{
    var flag = false;
	var ids = document.getElementsByName('check_type');
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
                if (document.forms[0].elements[i].name=='check_type')
                    rowsum1 ++;
            }
            for(i=len-1; i >= 0;i--) {
                if (document.forms[0].elements[i].name=='check_type'){
                    if(document.forms[0].elements[i].checked==true)
                        oTable1.deleteRow(rowsum1);
                    rowsum1--;
                }
            }
        }
    }else{
        alert('<%=SystemEnv.getHtmlLabelName(22686,user.getLanguage())%>');
		return;
    }
}


function DateCompare(YearFrom, MonthFrom, DayFrom,YearTo, MonthTo,DayTo)
{  
    YearFrom  = parseInt(YearFrom,10);
    MonthFrom = parseInt(MonthFrom,10);
    DayFrom = parseInt(DayFrom,10);
    YearTo    = parseInt(YearTo,10);
    MonthTo   = parseInt(MonthTo,10);
    DayTo = parseInt(DayTo,10);
    if(YearTo<YearFrom)
    return false;
    else{
        if(YearTo==YearFrom){
            if(MonthTo<MonthFrom)
            return false;
            else{
                if(MonthTo==MonthFrom){
                    if(DayTo<DayFrom)
                    return false;
                    else
                    return true;
                }
                else 
                return true;
            }
            }
        else
        return true;
        }
}


function checktimeok(){
if ("<%=newenddate%>"!="b" && "<%=newfromdate%>"!="a" && document.frmmain.<%=newenddate%>.value != ""){
			YearFrom=document.frmmain.<%=newfromdate%>.value.substring(0,4);
			MonthFrom=document.frmmain.<%=newfromdate%>.value.substring(5,7);
			DayFrom=document.frmmain.<%=newfromdate%>.value.substring(8,10);
			YearTo=document.frmmain.<%=newenddate%>.value.substring(0,4);
			MonthTo=document.frmmain.<%=newenddate%>.value.substring(5,7);
			DayTo=document.frmmain.<%=newenddate%>.value.substring(8,10);
			// window.alert(YearFrom+MonthFrom+DayFrom);
                   if (!DateCompare(YearFrom, MonthFrom, DayFrom,YearTo, MonthTo,DayTo )){
        window.alert("<%=SystemEnv.getHtmlLabelName(15273,user.getLanguage())%>");
         return false;
  			 }
  }
     return true; 
}

function doSave(){
	parastr = "<%=needcheck%>" ;
	len = document.forms[0].elements.length;
	var i=0;
	var rowsum1 = 0;
	for(i=len-1; i >= 0;i--) {
		if (document.forms[0].elements[i].name=='check_type')
			parastr+=",hotelid_"+document.forms[0].elements[i].value;
	}

	if(check_form(document.frmmain,parastr)){
		document.frmmain.src.value='save';
		document.frmmain.nodesnum.value=rowindex1;
		alert(document.frmmain.nodesnum.value);
		if(checktimeok()){
			//附件上传
                        StartUploadAll();
                        checkuploadcomplet();
		}
	}
}
function (){
	parastr = "<%=needcheck%>" ;
	len = document.forms[0].elements.length;
	var i=0;
	var rowsum1 = 0;
	for(i=len-1; i >= 0;i--) {
		if (document.forms[0].elements[i].name=='check_type')
			parastr+=",hotelid_"+document.forms[0].elements[i].value;
	}
	if(check_form(document.frmmain,parastr)){
		document.frmmain.src.value='submit';
		document.frmmain.nodesnum.value=rowindex1;
		document.all("remark").value += "\n<%=username%> <%=currentdate%> <%=currenttime%>" ;
		if(checktimeok()){
			//附件上传
                        StartUploadAll();
                        checkuploadcomplet();
		}
	}
}   
function doSigned() {
		document.all("remark").value += "\n<%=username%> <%=currentdate%> <%=currenttime%>" ;
		document.all("remark").disabled = true;
}
</script> 
<script language=vbs>
sub onShowHotel(inputname,spanname)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp?type=16")
	
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	spanname.innerHtml = "<A href='/CRM/data/ViewCustomer.jsp?CustomerID="&id(0)&"'>"&id(1)&"</A>"
	inputname.value=id(0)
	else 
	spanname.innerHtml = "<img src='/images/BacoError_wev8.gif' align=absmiddle>"
	inputname.value=""
	end if
	end if
end sub
</script>
