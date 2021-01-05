<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="java.util.*,java.sql.Timestamp" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page"/>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="BudgetfeeTypeComInfo" class="weaver.fna.maintenance.BudgetfeeTypeComInfo" scope="page"/>
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
String needcheck="requestname";
int rowsum=1;
String isSignDoc_add="";
String isSignWorkflow_add="";
RecordSet.execute("select titleFieldId,keywordFieldId,isSignDoc,isSignWorkflow from workflow_base where id="+workflowid);
if(RecordSet.next()){
    isSignDoc_add=Util.null2String(RecordSet.getString("isSignDoc"));
    isSignWorkflow_add=Util.null2String(RecordSet.getString("isSignWorkflow"));
}
%>
<form name="frmmain" method="post" action="BillTotalBudgetOperation.jsp">
<input type=hidden name="workflowid" value=<%=workflowid%>>
<input type=hidden name="nodeid" value=<%=nodeid%>>
<input type=hidden name="nodetype" value="0">
<input type=hidden name="src">
<input type=hidden name="iscreate" value="1">
<input type=hidden name="formid" value=<%=formid%>>
<input type=hidden name ="topage" value="<%=topage%>">
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
		}else if(fieldtype.equals("1") && !hrmid.equals("")){
			tmpid = Util.getIntValue(hrmid,0);
		}else if(fieldtype.equals("7") && !crmid.equals("")){
			tmpid = Util.getIntValue(crmid,0);
		}else if(fieldtype.equals("4") && !hrmid.equals("")){
			tmpid = Util.getIntValue(ResourceComInfo.getDepartmentID(hrmid),0);
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
	%><select name="field<%=fieldid%>" <%if(isedit.equals("0")){%> DISABLED <%}%> >
	<%
	char flag=2;
	rs.executeProc("workflow_SelectItemSelectByid",""+fieldid+flag+"1");
	while(rs.next()){
		int tmpselectvalue = rs.getInt("selectvalue");
		String tmpselectname = rs.getString("selectname");
	%>
	<option value="<%=tmpselectvalue%>"><%=Util.toScreen(tmpselectname,user.getLanguage())%></option>
	<%}%>
	</select>
        <%}
%>
      </td>
    </tr>
    <%
   }
}
%>
	<tr><td colspan=2>
	<table class=ListShort border=1 width="100%">
	<col width="8%">
	<col width="7%"><col width="7%"><col width="7%"><col width="7%"><col width="7%"><col width="7%">
	<col width="7%"><col width="7%"><col width="7%"><col width="7%"><col width="7%"><col width="7%">
	<col width="8%">
	<tr class=section><th align=center colspan=14><%=SystemEnv.getHtmlLabelName(1012,user.getLanguage())%></th></tr>
	<tr class=separator> <td class=Sep1 colspan=14></td></tr>
	<tr class=header>
		<td><%=SystemEnv.getHtmlLabelName(1462,user.getLanguage())%></td>
		<td><%=SystemEnv.getHtmlLabelName(1492,user.getLanguage())%></td>
		<td><%=SystemEnv.getHtmlLabelName(1493,user.getLanguage())%></td>
		<td><%=SystemEnv.getHtmlLabelName(1494,user.getLanguage())%></td>
		<td><%=SystemEnv.getHtmlLabelName(1495,user.getLanguage())%></td>
		<td><%=SystemEnv.getHtmlLabelName(1496,user.getLanguage())%></td>
		<td><%=SystemEnv.getHtmlLabelName(1497,user.getLanguage())%></td>
		<td><%=SystemEnv.getHtmlLabelName(1498,user.getLanguage())%></td>
		<td><%=SystemEnv.getHtmlLabelName(1499,user.getLanguage())%></td>
		<td><%=SystemEnv.getHtmlLabelName(1800,user.getLanguage())%></td>
		<td><%=SystemEnv.getHtmlLabelName(1801,user.getLanguage())%></td>
		<td><%=SystemEnv.getHtmlLabelName(1802,user.getLanguage())%></td>
		<td><%=SystemEnv.getHtmlLabelName(1803,user.getLanguage())%></td>
		<td><%=SystemEnv.getHtmlLabelName(1013,user.getLanguage())%></td>
	</tr>
<%
    boolean islight=true;
    RecordSet.executeProc("FnaBudgetfeeType_Select","");
    while(BudgetfeeTypeComInfo.next()){
        String curid=BudgetfeeTypeComInfo.getBudgetfeeTypeid();
        String curtypename=BudgetfeeTypeComInfo.getBudgetfeeTypename();
%>
    <tr <%if(islight){%> class=datalight <%} else {%> class=datadark <%}%>>
		<td><%=Util.toScreen(curtypename,user.getLanguage())%></td>
<%      for(int j=1;j<13;j++){%>
		<td><input size=5 name=fee_<%=rowsum%>_<%=j%>  onKeyPress='ItemNum_KeyPress()' onBlur='checknumber1(this);changenumber(<%=rowsum%>,<%=j%>)'></td>
<%      }%>		
		<td><span id=fee_<%=rowsum%>_0></span>
		<input type=hidden name="row<%=rowsum%>" value="<%=curid%>"></td>
	</tr>
<%  
        islight=!islight;
        rowsum++;
    }  
%>
	<tr class=TOTAL style="FONT-WEIGHT: bold; COLOR: red">
		<td><%=SystemEnv.getHtmlLabelName(358,user.getLanguage())%></td>
<%  for(int k=1;k<13;k++){
%>
		<td><span id=fee_0_<%=k%>></span></td>
<%  }
%>		
		<td><span id=fee_0_0></span></td>
	</tr>
	</table>
	<input type=hidden name=rowsum value=<%=(rowsum-1)%>>
	</td></tr>    	  
	<tr class="Title">
      <td colspan=2 align="center" valign="middle"><font style="font-size:14pt;FONT-WEIGHT: bold"><%=SystemEnv.getHtmlLabelName(17614,user.getLanguage())%></font></td>
    </tr>
    <tr>
      <td><%=SystemEnv.getHtmlLabelName(504,user.getLanguage())%></td>
      <td class=field>
		<input type="hidden" id="remarkText10404" name="remarkText10404" value="">
        <textarea name=remark rows=4 cols=40 style="width=80%;display:none" ></textarea>
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
	if(check_form(document.frmmain,parastr)){
		document.frmmain.src.value='save';
		if(checktimeok()){
			//附件上传
                        StartUploadAll();
                        checkuploadcomplet();
		}
	}
}
function doSubmit(){
	parastr = "<%=needcheck%>" ;
	if(check_form(document.frmmain,parastr)){
		document.frmmain.src.value='submit';
		document.all("remark").value += "\n<%=username%> <%=currentdate%> <%=currenttime%>" ;
		if(checktimeok()){
			//附件上传
                        StartUploadAll();
                        checkuploadcomplet();
		}
	}
}

function changenumber(rowval,colval){
	count_total = 0 ;
	for(i=1;i<13;i++){
		count_total+=eval(toFloat(document.all("fee_"+rowval+"_"+i).value,0)) ;
	}
	document.all("fee_"+rowval+"_0").innerHTML = count_total; 
	
	count_total = 0 ;
	for(i=1;i<<%=rowsum%>;i++){
		count_total+=eval(toFloat(document.all("fee_"+i+"_"+colval).value,0)) ;
	}
	document.all("fee_0"+"_"+colval).innerHTML = count_total; 
	
	count_total = 0 ;
	for(i=1;i<13;i++){
		count_total+=eval(toFloat(document.all("fee_0"+"_"+i).innerHTML,0)) ;
	}
	document.all("fee_0_0").innerHTML = count_total; 
}

function toFloat(str , def) {
	if(isNaN(parseFloat(str))) return def ;
	else return str ;
}

function toInt(str , def) {
	if(isNaN(parseInt(str))) return def ;
	else return str ;
}   
</script> 

<script language=vbs>
sub getTheDate(inputname,spanname)
	returndate = window.showModalDialog("/systeminfo/Calendar.jsp",,"dialogHeight:320px;dialogwidth:275px")
	spanname.innerHtml= returndate
	inputname.value=returndate
end sub
</script>
