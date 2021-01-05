<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Timestamp" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page"/>
<jsp:useBean id="CapitalComInfo" class="weaver.cpt.capital.CapitalComInfo" scope="page"/>
<%	//      check user's right about current request operate
String newfromdate="a";
String newenddate="b";
int requestid=Util.getIntValue(request.getParameter("requestid"),0);
String  isrequest=Util.null2String(request.getParameter("isrequest"));
String logintype = user.getLogintype();

String requestname="";
String requestlevel="";
int workflowid=0;
int formid=0;
int billid=0;
int nodeid=0;
String nodetype="";
int userid=user.getUID();
int hasright=0;
String status="";
int creater=0;
int deleted=0;
int isremark=0;
int creatertype = 0;
int groupid = 0;

int usertype = 0;
if(logintype.equals("1"))
	usertype = 0;
if(logintype.equals("2"))
	usertype = 1;
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
char flag=Util.getSeparator() ;

RecordSet.executeProc("workflow_Requestbase_SByID",requestid+"");
if(RecordSet.next()){	
	workflowid=RecordSet.getInt("workflowid");
	nodeid=RecordSet.getInt("currentnodeid");
	nodetype=RecordSet.getString("currentnodetype");
	requestname=RecordSet.getString("requestname");
	status=RecordSet.getString("status");
	creater=RecordSet.getInt("creater");
	deleted=RecordSet.getInt("deleted");
	creatertype = RecordSet.getInt("creatertype");
	requestlevel=RecordSet.getString("requestlevel");	
}

RecordSet.executeSql("select * from workflow_currentoperator where requestid="+requestid+" and userid="+userid+"and usertype = "+usertype+" and isremark='0'");
if(RecordSet.next())	hasright=1;

RecordSet.executeSql("select * from workflow_currentoperator where requestid="+requestid+" and userid="+userid+" and usertype="+ usertype + " and isremark='1'");
if(RecordSet.next()){
	isremark=1;
}

if(hasright==0&&isremark==0){
	response.sendRedirect("/notice/noright.jsp");
    	return;
}

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

//~~~~~~~~~~~~~get submit button title~~~~~~~~~~~~~~~
String submit="";
if(nodetype.equals("0"))	submit=SystemEnv.getHtmlLabelName(615,user.getLanguage());
if(nodetype.equals("1"))	submit=SystemEnv.getHtmlLabelName(142,user.getLanguage());
if(nodetype.equals("2"))	submit=SystemEnv.getHtmlLabelName(725,user.getLanguage());
if(nodetype.equals("3"))	submit=SystemEnv.getHtmlLabelName(251,user.getLanguage());

//~~~~~~~~~~~~~~get billformid & billid~~~~~~~~~~~~~~~~~~~~~
RecordSet.executeProc("workflow_form_SByRequestid",requestid+"");
RecordSet.next();
formid=RecordSet.getInt("billformid");
billid=RecordSet.getInt("billid");

String needcheck="name";
%>

<form name="frmmain" method="post" action="BillCptStockInOperation.jsp">
<input type=hidden name="requestid" value=<%=requestid%>>
<input type=hidden name="workflowid" value=<%=workflowid%>>
<input type=hidden name="nodeid" value=<%=nodeid%>>
<input type=hidden name="nodetype" value="<%=nodetype%>">
<input type=hidden name="src" value="active">
<input type=hidden name="iscreate" value="0">
<input type=hidden name="formid" value=<%=formid%>>
<input type=hidden name="billid" value=<%=billid%>>
<input type="hidden" value="0" name="nodesnum">
<input type=hidden name=isremark >
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
<%if(isreopen.equals("1") && false){%>
<BUTTON class=btn accessKey=O type=button onclick="doReopen()"><U>O</U>-<%=SystemEnv.getHtmlLabelName(244,user.getLanguage())%></button>
<%}%>
<%if(isreject.equals("1")){%>
<BUTTON class=btn accessKey=J type=button onclick="doReject()"><U>J</U>-<%=SystemEnv.getHtmlLabelName(236,user.getLanguage())%></button>
<%}if(nodetype.equals("0")){%>
<BUTTON class=btnDelete accessKey=D type=button onclick="doDelete()"><U>D</U>-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></button>
<%}
}%>
<BUTTON class=btn accessKey=1 type=button onclick="location.href='RequestView.jsp'"><U>1</U>-返回</button>
</div>
  <br>
  <table class=form>
    <colgroup> <col width="15%"> <col width="85%">
    <tr class=separator> 
      <td class=Sep1 colspan=4></td>
    </tr>
    <tr>
      <td>说明</td>
      <td class=field> 
      <%=Util.toScreen(requestname,user.getLanguage())%> 
        <input type=hidden name=name value="<%=Util.toScreenToEdit(requestname,user.getLanguage())%>">
      &nbsp;&nbsp;&nbsp;&nbsp;
      <span>
      <%if(requestlevel.equals("0")){%>正常 <%}%>
      <%if(requestlevel.equals("1")){%>重要 <%}%>
      <%if(requestlevel.equals("2")){%>紧急 <%}%>
      </span>
      </td>
    </tr>
    <%
RecordSet.executeProc("workflow_Workflowbase_SByID",workflowid+"");
RecordSet.next();
formid=RecordSet.getInt("formid");

ArrayList fieldids=new ArrayList();
ArrayList viewtypes=new ArrayList();
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
	viewtypes.add(RecordSet.getString("viewtype"));
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

RecordSet.executeProc("bill_CptStockInMain_Select",billid+"");
RecordSet.next();
for(int i=0;i<fieldids.size();i++){
	String fieldname=(String)fieldnames.get(i);	
	fieldvalues.add(RecordSet.getString(fieldname));
}
for(int i=0;i<fieldids.size();i++){
	String fieldid=(String)fieldids.get(i);
	String fieldname=(String)fieldnames.get(i);
	
	String fieldvalue=(String)fieldvalues.get(i);
	String isview=(String)isviews.get(i);
	String isedit=(String)isedits.get(i);
	String ismand=(String)ismands.get(i);
	String fieldhtmltype=(String)fieldhtmltypes.get(i);
	String fieldtype=(String)fieldtypes.get(i);
	String fieldlable=SystemEnv.getHtmlLabelName(Util.getIntValue((String)fieldlabels.get(i),0),user.getLanguage());
	String viewtype = (String)viewtypes.get(i);
	if(fieldname.equals("begindate")) newfromdate="field"+fieldid;
	if(fieldname.equals("enddate")) newenddate="field"+fieldid;
	if(viewtype.equals("1"))
		continue;
	if(fieldname.equals("groupid")){
		groupid = Util.getIntValue(fieldvalue,0);
	}
	
	if(fieldhtmltype.equals("3") && fieldvalue.equals("0")) fieldvalue = "" ;
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
			if(isedit.equals("1")&&isremark==0){
				if(ismand.equals("1")) {%>
        <input type=text name="field<%=fieldid%>" value="<%=Util.toScreenToEdit(fieldvalue,user.getLanguage())%>"
		onChange="checkinput('field<%=fieldid%>','field<%=fieldid%>span')" style="width:50%">
        <span id="field<%=fieldid%>span">
        <%if(fieldvalue.equals("")){%>
        <img src="/images/BacoError_wev8.gif" align=absmiddle>
        <%}%>
        </span> 
        <%
					needcheck+=",field"+fieldid;
				}else{%>
        <input type=text name="field<%=fieldid%>" value="<%=Util.toScreenToEdit(fieldvalue,user.getLanguage())%>" style="width:50%">
        <%}
			}else{
		%>
        <%=Util.toScreen(fieldvalue,user.getLanguage())%> 
        <input type=hidden name="field<%=fieldid%>" value="<%=Util.toScreenToEdit(fieldvalue,user.getLanguage())%>">
        <%
			}
		}
		else if(fieldtype.equals("2")){
			if(isedit.equals("1")&&isremark==0){
				if(ismand.equals("1")) {%>
        <input type=text name="field<%=fieldid%>" value="<%=Util.toScreenToEdit(fieldvalue,user.getLanguage())%>" style="width:50%"
		onKeyPress="ItemCount_KeyPress()" onBlur="checkcount1(this);checkinput('field<%=fieldid%>','field<%=fieldid%>span')">
        <span id="field<%=fieldid%>span">
        <%if(fieldvalue.equals("")){%>
        <img src="/images/BacoError_wev8.gif" align=absmiddle>
        <%}%>
        </span> 
        <%
					needcheck+=",field"+fieldid;
				}else{%>
        <input type=text name="field<%=fieldid%>" value="<%=Util.toScreenToEdit(fieldvalue,user.getLanguage())%>"
		onKeyPress="ItemCount_KeyPress()" onBlur='checkcount1(this)' style="width:50%">
        <%}
			}else{
		%>
        <%=Util.toScreen(fieldvalue,user.getLanguage())%> 
        <input type=hidden name="field<%=fieldid%>" value="<%=Util.toScreenToEdit(fieldvalue,user.getLanguage())%>">
        <%
			}
		}
		else if(fieldtype.equals("3")){
			if(isedit.equals("1")&&isremark==0){
				if(ismand.equals("1")) {%>
        <input type=text name="field<%=fieldid%>" value="<%=Util.toScreenToEdit(fieldvalue,user.getLanguage())%>"
		onKeyPress="ItemNum_KeyPress()" onBlur="checknumber1(this);checkinput('field<%=fieldid%>','field<%=fieldid%>span')">
        <span id="field<%=fieldid%>span">
        <%if(fieldvalue.equals("")){%>
        <img src="/images/BacoError_wev8.gif" align=absmiddle>
        <%}%>
        </span> 
        <%
					needcheck+=",field"+fieldid;
				}else{%>
        <input type=text name="field<%=fieldid%>" value="<%=Util.toScreenToEdit(fieldvalue,user.getLanguage())%>"
		onKeyPress="ItemNum_KeyPress()" onBlur='checknumber1(this)'>
        <%}
			}else{
		%>
        <%=Util.toScreen(fieldvalue,user.getLanguage())%> 
        <input type=hidden name="field<%=fieldid%>" value="<%=Util.toScreenToEdit(fieldvalue,user.getLanguage())%>">
        <%
			}
		}
	}
	else if(fieldhtmltype.equals("2")){
		if(isedit.equals("1")&&isremark==0){
			if(ismand.equals("1")) {%>
        <textarea name="field<%=fieldid%>" onChange="checkinput('field<%=fieldid%>','field<%=fieldid%>span')" 
		 rows="4" cols="40" style="width:80%"><%=Util.toScreenToEdit(fieldvalue,user.getLanguage())%></textarea>
        <span id="field<%=fieldid%>span">
        <%if(fieldvalue.equals("")){%>
        <img src="/images/BacoError_wev8.gif" align=absmiddle>
        <%}%>
        </span> 
        <%
				needcheck+=",field"+fieldid;
			}else{%>
        <textarea name="field<%=fieldid%>" rows="4" cols="40" style="width:80%"><%=Util.toScreenToEdit(fieldvalue,user.getLanguage())%></textarea>
        <%}
		}else{
		%>
        <%=Util.toScreen(fieldvalue,user.getLanguage())%> 
        <input type=hidden name="field<%=fieldid%>" value="<%=Util.toScreenToEdit(fieldvalue,user.getLanguage())%>">
        <%
			}
	}
	else if(fieldhtmltype.equals("3")){
		String showname="";
		String showid="" ;
		String sql="";
		String url=BrowserComInfo.getBrowserurl(fieldtype);
		String linkurl = Util.null2String(BrowserComInfo.getLinkurl(fieldtype));
		if(fieldtype.equals("2") ||fieldtype.equals("19")  )	showname=fieldvalue;
		else if(fieldtype.equals("17")||fieldtype.equals("18")){
			String tablename=BrowserComInfo.getBrowsertablename(fieldtype);
			String columname=BrowserComInfo.getBrowsercolumname(fieldtype);
			String keycolumname=BrowserComInfo.getBrowserkeycolumname(fieldtype);
			sql="select "+keycolumname+","+columname+" from "+tablename+" where "+keycolumname+" in( "+fieldvalue+")";
			RecordSet.executeSql(sql);
			while(RecordSet.next()){
				showid = RecordSet.getString(1);
				String tmpname=RecordSet.getString(2);
				if(!linkurl.equals("")){
					if("/hrm/resource/HrmResource.jsp?id=".equals(linkurl))
                	{
                		showname = "<a href='javaScript:openhrm(" + showid + ");' onclick='pointerXY(event);'>" + tmpname + "</a>&nbsp";
                	}
    				else
						showname +="<a href='"+linkurl+showid+"'>"+tmpname+"</a>&nbsp";
				}else{
					showname += tmpname+" ";	
				}
				
			}
			    
		}
		else {
			int intfieldvalue=Util.getIntValue(fieldvalue,0);
			String tablename=BrowserComInfo.getBrowsertablename(fieldtype);
			String columname=BrowserComInfo.getBrowsercolumname(fieldtype);
			String keycolumname=BrowserComInfo.getBrowserkeycolumname(fieldtype);
			sql="select "+columname+" from "+tablename+" where "+keycolumname+"="+intfieldvalue;
			RecordSet.executeSql(sql);
			RecordSet.next();
			if("/hrm/resource/HrmResource.jsp?id=".equals(linkurl))
        	{
        		showname = "<a href='javaScript:openhrm(" + intfieldvalue + ");' onclick='pointerXY(event);'>" + RecordSet.getString(1) + "</a>&nbsp";
        	}
			else
				showname = "<a href='"+linkurl+intfieldvalue+"'>"+RecordSet.getString(1)+"</a>&nbsp";
		}
		%>
        <%if(isedit.equals("1")&&isremark==0){%>
        <button class=Browser onclick="onShowBrowser('<%=fieldid%>','<%=url%>','<%=linkurl%>','<%=fieldtype%>','<%=ismand%>')"></button>
        <%}%>
        <input type=hidden name="field<%=fieldid%>" value="<%=Util.toScreen(fieldvalue,user.getLanguage())%>">
        <span id="field<%=fieldid%>span">
        <%=Util.toScreen(showname,user.getLanguage())%>
        <%if(ismand.equals("1")){%>
        <%if(fieldvalue.equals("")){%>
        <img src="/images/BacoError_wev8.gif" align=absmiddle>
        <%}%>
        <%	needcheck+=",field"+fieldid;	
			}%></span>
        <%
	}
	else if(fieldhtmltype.equals("4")){%> 
		<%if(isedit.equals("0")||isremark==1){%>
        <input type=checkbox value=1 name="prefield_<%=fieldid%>" DISABLED <%if(fieldvalue.equals("1")){%> checked <%}%>> 
        <input type= hidden name="field<%=fieldid%>" value=<%=fieldvalue%>>
        <%} else {%>
        <input type=checkbox value=1 name="field<%=fieldid%>" <%if(fieldvalue.equals("1")){%> checked <%}%>>
        <%}
    }
	else if(fieldhtmltype.equals("5")){%>
		<%if(isedit.equals("0")||isremark==1){%>
        <select name="field<%=fieldid%>" DISABLED >
	<%
	rs.executeProc("workflow_SelectItemSelectByid",""+fieldid+flag+"1");
	while(rs.next()){
		int tmpselectvalue = rs.getInt("selectvalue");
		String tmpselectname = rs.getString("selectname");
	%>
	<option value="<%=tmpselectvalue%>"  <%if(fieldvalue.equals(""+tmpselectvalue)){%> selected <%}%>><%=Util.toScreen(tmpselectname,user.getLanguage())%></option>
	<%}%>
	</select>
	<input type= hidden name="field<%=fieldid%>" value=<%=fieldvalue%>>
        <%} else {%>
        <select name="field<%=fieldid%>">
		<%
		rs.executeProc("workflow_SelectItemSelectByid",""+fieldid+flag+"1");
		while(rs.next()){
			int tmpselectvalue = rs.getInt("selectvalue");
			String tmpselectname = rs.getString("selectname");
		%>
		<option value="<%=tmpselectvalue%>"  <%if(fieldvalue.equals(""+tmpselectvalue)){%> selected <%}%>><%=Util.toScreen(tmpselectname,user.getLanguage())%></option>
		<%}%>
		</select>
        <%}}
%>
      </td>
    </tr>
    <%
   }else { %>
   <input type=hidden name="field<%=fieldid%>" value="<%=Util.toScreenToEdit(fieldvalue,user.getLanguage())%>">
 <%}%>
 </tr>
<%}%> 

<TR class=Section>
    	  <TH colSpan=2>
    	  资产
    	  </TH></TR>
     <TR class=separator>
    	  <TD class=Sep1 colSpan=2></TD></TR>
  <tr>
   <table Class=ListShort cols=11 id="oTable">
      	<COLGROUP>
  	<COL width="8%">
  	<COL width="12%">
  	<COL width="8%">
  	<COL width="8%">
  	<COL width="8%">
  	<COL width="8%">
  	<COL width="10%">
  	<COL width="10%">
  	<COL width="10%">
  	<COL width="10%">
  	<COL width="10%">
    	   <tr class=header> 
    	   <%
String dsptypes="";
String edittypes ="";
String mandtypes ="";
int tmpcount = 1;
for(int i=0;i<fieldids.size();i++){
	String fieldname=(String)fieldnames.get(i);
	String fieldid=(String)fieldids.get(i);
	String isview=(String)isviews.get(i);
	String isedit=(String)isedits.get(i);
	String ismand=(String)ismands.get(i);
	String fieldhtmltype=(String)fieldhtmltypes.get(i);
	String fieldtype=(String)fieldtypes.get(i);
	String fieldlable=SystemEnv.getHtmlLabelName(Util.getIntValue((String)fieldlabels.get(i),0),user.getLanguage());
	String viewtype = (String)viewtypes.get(i);
	if(viewtype.equals("0"))
		continue;
	
	dsptypes +=",0"+tmpcount+"_"+isview;
	edittypes +=","+tmpcount+"_"+isedit;
	mandtypes +=","+tmpcount+"_"+ismand;
	tmpcount++;
	
%>
    	  
            <td <%if(isview.equals("0")){%> style="display:none" <%}%>><%=Util.toScreen(fieldlable,user.getLanguage())%></td>
<%}%>
            </tr>
    	   
            <%
            
	           int linecolor=0;  
	RecordSet.executeProc("bill_CptStockInDetail_Select",billid+"");
	int rowsum=0;
	while(RecordSet.next()){
            %>
            <tr <%if(linecolor==0){%> class=datalight <%} else {%> class=datadark <%}%> > 
            <input type='hidden' name='node_<%=rowsum%>_id' id='node_<%=rowsum%>_id' value="<%=RecordSet.getString("id")%>">
            
            <td <%if(dsptypes.indexOf("01_0")!=-1){%> style="display:none" <%}%>>
            <% if(edittypes.indexOf("1_1")!=-1){
            	if(mandtypes.indexOf("1_1")!=-1){%>
            		<input  type='text' style="width:80%" name='node_<%=rowsum%>_cptno' id='node_<%=rowsum%>_cptno' value="<%=RecordSet.getString("cptno")%>"  OnBlur=checkinput('node_<%=rowsum%>_cptno','node_<%=rowsum%>_cptnospan')>
            		<span id="node_<%=rowsum%>_cptnospan">
            		<%if(RecordSet.getString("cptno").equals("")){%>
            		<img src="/images/BacoError_wev8.gif" align=absmiddle>
		        <%
        	 	needcheck+=",node_"+rowsum+"_cptno";}%>
		        </span>
		<%}else{%>
            		<input  type='text' style="width:80%" style="width:80%" name='node_<%=rowsum%>_cptno' id='node_<%=rowsum%>_cptno' value="<%=Util.toScreenToEdit(RecordSet.getString("cptno"),user.getLanguage())%>">
            	<%}%>
	    <%}else{%>
	    <%=RecordSet.getString("cptno")%>
	    <input type='hidden' name='node_<%=rowsum%>_cptno' id='node_<%=rowsum%>_cptno' value="<%=RecordSet.getString("cptno")%>">
	    <%}%>
	    </td>
          
            <td <%if(dsptypes.indexOf("02_0")!=-1){%> style="display:none" <%}%>>
            <a href='/cpt/capital/CptCapital.jsp?id=<%=RecordSet.getString("cptid")%>'><%=Util.toScreen(CapitalComInfo.getCapitalname(RecordSet.getString("cptid")),user.getLanguage())%> </a>
            <% if(edittypes.indexOf("2_1")!=-1){%>
            <button class=Browser onClick='onShowAsset(node_<%=rowsum%>_cptspan,node_<%=rowsum%>_cptid)'></button>
            <span class=saveHistory id=node_<%=rowsum%>_cptspan>
            
        	 <% if(mandtypes.indexOf("2_1")!=-1){%>
        	 			<img src='/images/BacoError_wev8.gif' align=absmiddle>
        	 <%
        	 	needcheck+=",node_"+rowsum+"_cptid";
        	 }%>
        	 </span>
        	<%}%>
	    <input type='hidden' name='node_<%=rowsum%>_cptid' id='node_<%=rowsum%>_cptid' value="<%=RecordSet.getString("cptid")%>">
	    </td>
            
            <td <%if(dsptypes.indexOf("03_0")!=-1){%> style="display:none" <%}%>>
            <% if(edittypes.indexOf("3_1")!=-1){
            	if(mandtypes.indexOf("3_1")!=-1){%>
            		<input  type='text' style="width:80%" name='node_<%=rowsum%>_cpttype' id='node_<%=rowsum%>_cpttype' value="<%=RecordSet.getString("cpttype")%>"  OnBlur=checkinput('node_<%=rowsum%>_cpttype','node_<%=rowsum%>_cpttypespan')>
            		<span id="node_<%=rowsum%>_cpttypespan">
            		<%if(RecordSet.getString("cpttype").equals("")){%>
            		<img src="/images/BacoError_wev8.gif" align=absmiddle>
		        <%
        	 	needcheck+=",node_"+rowsum+"_cpttype";}%>
		        </span>
		<%}else{%>
            		<input  type='text' style="width:80%" name='node_<%=rowsum%>_cpttype' id='node_<%=rowsum%>_cpttype' value="<%=Util.toScreenToEdit(RecordSet.getString("cpttype"),user.getLanguage())%>">
            	<%}%>
	    <%}else{%>
	    <%=RecordSet.getString("cpttype")%>
	    <input type='hidden' name='node_<%=rowsum%>_cpttype' id='node_<%=rowsum%>_cpttype' value="<%=RecordSet.getString("cpttype")%>">
	    <%}%>
	    </td>
	    
            <td <%if(dsptypes.indexOf("04_0")!=-1){%> style="display:none" <%}%>>
            <% if(edittypes.indexOf("4_1")!=-1){
            	if(mandtypes.indexOf("4_1")!=-1){%>
            		<input  type='text' style="width:80%" name='node_<%=rowsum%>_plannumber' id='node_<%=rowsum%>_plannumber' value="<%=RecordSet.getString("plannumber")%>"  onKeyPress='ItemNum_KeyPress()' onBlur=checkinput('node_<%=rowsum%>_plannumber','node_<%=rowsum%>_plannumberspan')>
            		<span id="node_<%=rowsum%>_plannumberspan">
            		<%if(RecordSet.getString("plannumber").equals("")){%>
            		<img src="/images/BacoError_wev8.gif" align=absmiddle>
		         <%
        	 	needcheck+=",node_"+rowsum+"_plannumber";}%>
		        </span>
		<%}else{%>
            		<input  type='text' style="width:80%" name='node_<%=rowsum%>_plannumber' id='node_<%=rowsum%>_plannumber' value="<%=RecordSet.getString("plannumber")%>">
            	<%}%>
	    <%}else{%>
	    	<%=RecordSet.getString("plannumber")%>
	    <input type='hidden' name='node_<%=rowsum%>_plannumber' id='node_<%=rowsum%>_plannumber' value="<%=RecordSet.getString("plannumber")%>">
	    <%}%>
	    </td>
	    
	    <td <%if(dsptypes.indexOf("05_0")!=-1){%> style="display:none" <%}%>>
            <% if(edittypes.indexOf("5_1")!=-1){
            	if(mandtypes.indexOf("5_1")!=-1){%>
            		<input  type='text' style="width:80%" name='node_<%=rowsum%>_innumber' id='node_<%=rowsum%>_innumber' value="<%=RecordSet.getString("innumber")%>"  onKeyPress='ItemNum_KeyPress()' onBlur=checkinput('node_<%=rowsum%>_innumber','node_<%=rowsum%>_innumberspan')>
            		<span id="node_<%=rowsum%>_innumberspan">
            		<%if(RecordSet.getString("innumber").equals("")){%>
            		<img src="/images/BacoError_wev8.gif" align=absmiddle>
		         <%
        	 	needcheck+=",node_"+rowsum+"_innumber";}%>
		        </span>
		<%}else{%>
            		<input  type='text' style="width:80%" name='node_<%=rowsum%>_innumber' id='node_<%=rowsum%>_innumber' value="<%=RecordSet.getString("innumber")%>">
            	<%}%>
	    <%}else{%>
	    	<%=RecordSet.getString("innumber")%>
	    <input type='hidden' name='node_<%=rowsum%>_innumber' id='node_<%=rowsum%>_innumber' value="<%=RecordSet.getString("innumber")%>">
	    <%}%>
	    </td>
	    
            <td <%if(dsptypes.indexOf("06_0")!=-1){%> style="display:none" <%}%>>
            <% if(edittypes.indexOf("6_1")!=-1){
            	if(mandtypes.indexOf("6_1")!=-1){%>
            		<input  type='text' style="width:80%" name='node_<%=rowsum%>_planprice' id='node_<%=rowsum%>_planprice' value="<%=RecordSet.getString("planprice")%>"  onKeyPress='ItemNum_KeyPress()' onBlur=checkinput('node_<%=rowsum%>_planprice','node_<%=rowsum%>_planpricespan')>
            		<span id="node_<%=rowsum%>_planpricespan">
            		<%if(RecordSet.getString("planprice").equals("")){%>
            		<img src="/images/BacoError_wev8.gif" align=absmiddle>
		        <%
        	 	needcheck+=",node_"+rowsum+"_planprice";}%>
		        </span>
		<%}else{%>
            		<input  type='text' style="width:80%" name='node_<%=rowsum%>_planprice' id='node_<%=rowsum%>_planprice' value="<%=RecordSet.getString("planprice")%>">
            	<%}%>
	    <%}else{%>
	    <%=RecordSet.getString("planprice")%>
	    <input type='hidden' name='node_<%=rowsum%>_planprice' id='node_<%=rowsum%>_planprice' value="<%=RecordSet.getString("planprice")%>">
	    <%}%>
	    </td>
	    
	    <td <%if(dsptypes.indexOf("07_0")!=-1){%> style="display:none" <%}%>>
            <% if(edittypes.indexOf("7_1")!=-1){
            	if(mandtypes.indexOf("7_1")!=-1){%>
            		<input  type='text' style="width:80%" name='node_<%=rowsum%>_inprice' id='node_<%=rowsum%>_inprice' value="<%=RecordSet.getString("inprice")%>"  onKeyPress='ItemNum_KeyPress()' onBlur=checkinput('node_<%=rowsum%>_inprice','node_<%=rowsum%>_inpricespan')>
            		<span id="node_<%=rowsum%>_inpricespan">
            		<%if(RecordSet.getString("inprice").equals("")){%>
            		<img src="/images/BacoError_wev8.gif" align=absmiddle>
		        <%
        	 	needcheck+=",node_"+rowsum+"_inprice";}%>
		        </span>
		<%}else{%>
            		<input  type='text' style="width:80%" name='node_<%=rowsum%>_inprice' id='node_<%=rowsum%>_inprice' value="<%=RecordSet.getString("inprice")%>">
            	<%}%>
	    <%}else{%>
	    <%=RecordSet.getString("inprice")%>
	    <input type='hidden' name='node_<%=rowsum%>_inprice' id='node_<%=rowsum%>_inprice' value="<%=RecordSet.getString("inprice")%>">
	    <%}%>
	    </td>
	    	    
            <td <%if(dsptypes.indexOf("08_0")!=-1){%> style="display:none" <%}%>>
            <% if(edittypes.indexOf("8_1")!=-1){
            	if(mandtypes.indexOf("8_1")!=-1){%>
            		<input  type='text' style="width:80%" name='node_<%=rowsum%>_planamount' id='node_<%=rowsum%>_planamount' value="<%=RecordSet.getString("planamount")%>"  onKeyPress='ItemNum_KeyPress()' onBlur=checkinput('node_<%=rowsum%>_planamount','node_<%=rowsum%>_planamountspan')>
            		<span id="node_<%=rowsum%>_planamountspan">
            		<%if(RecordSet.getString("planamount").equals("")){%>
            		<img src="/images/BacoError_wev8.gif" align=absmiddle>
		        <%
        	 	needcheck+=",node_"+rowsum+"_planamount";}%>
		        </span>
		<%}else{%>
            		<input  type='text' style="width:80%" name='node_<%=rowsum%>_planamount' id='node_<%=rowsum%>_planamount' value="<%=RecordSet.getString("planamount")%>">
            	<%}%>
	    <%}else{%>
	    <%=RecordSet.getString("planamount")%>
	    <input type='hidden' name='node_<%=rowsum%>_planamount' id='node_<%=rowsum%>_planamount' value="<%=RecordSet.getString("planamount")%>">
	    <%}%>
	    </td>
	    
	    <td <%if(dsptypes.indexOf("09_0")!=-1){%> style="display:none" <%}%>>
            <% if(edittypes.indexOf("9_1")!=-1){
            	if(mandtypes.indexOf("9_1")!=-1){%>
            		<input  type='text' style="width:80%" name='node_<%=rowsum%>_inamount' id='node_<%=rowsum%>_inamount' value="<%=RecordSet.getString("inamount")%>"  onKeyPress='ItemNum_KeyPress()' onBlur=checkinput('node_<%=rowsum%>_inamount','node_<%=rowsum%>_inamountspan')>
            		<span id="node_<%=rowsum%>_inamountspan">
            		<%if(RecordSet.getString("inamount").equals("")){%>
            		<img src="/images/BacoError_wev8.gif" align=absmiddle>
		        <%
        	 	needcheck+=",node_"+rowsum+"_inamount";}%>
		        </span>
		<%}else{%>
            		<input  type='text' style="width:80%" name='node_<%=rowsum%>_inamount' id='node_<%=rowsum%>_inamount' value="<%=RecordSet.getString("inamount")%>">
            	<%}%>
	    <%}else{%>
	    <%=RecordSet.getString("inamount")%>
	    <input type='hidden' name='node_<%=rowsum%>_inamount' id='node_<%=rowsum%>_inamount' value="<%=RecordSet.getString("inamount")%>">
	    <%}%>
	    </td>
	    
	    <td <%if(dsptypes.indexOf("010_0")!=-1){%> style="display:none" <%}%>>
            <% if(edittypes.indexOf("10_1")!=-1){
            	if(mandtypes.indexOf("10_1")!=-1){%>
            		<input  type='text' style="width:80%" name='node_<%=rowsum%>_difprice' id='node_<%=rowsum%>_difprice' value="<%=RecordSet.getString("difprice")%>"  onKeyPress='ItemNum_KeyPress()' onBlur=checkinput('node_<%=rowsum%>_difprice','node_<%=rowsum%>_difpricespan')>
            		<span id="node_<%=rowsum%>_difpricespan">
            		<%if(RecordSet.getString("difprice").equals("")){%>
            		<img src="/images/BacoError_wev8.gif" align=absmiddle>
		        <%
        	 	needcheck+=",node_"+rowsum+"_difprice";}%>
		        </span>
		<%}else{%>
            		<input  type='text' style="width:80%" name='node_<%=rowsum%>_difprice' id='node_<%=rowsum%>_difprice' value="<%=RecordSet.getString("difprice")%>">
            	<%}%>
	    <%}else{%>
	    <%=RecordSet.getString("difprice")%>
	    <input type='hidden' name='node_<%=rowsum%>_difprice' id='node_<%=rowsum%>_difprice' value="<%=RecordSet.getString("difprice")%>">
	    <%}%>
	    </td>
	   <td <%if(dsptypes.indexOf("011_0")!=-1){%> style="display:none" <%}%>>
            <a href='/cpt/capital/CptCapital.jsp?id=<%=RecordSet.getString("capitalid")%>'><%=Util.toScreen(CapitalComInfo.getCapitalname(RecordSet.getString("capitalid")),user.getLanguage())%> </a>
            <input type='hidden' name='node_<%=rowsum%>_capitalid' id='node_<%=rowsum%>_capitalid' value="<%=RecordSet.getString("capitalid")%>">
	    </td>
           </tr>
            <%if(linecolor==0) linecolor=1;
          else linecolor=0; rowsum++;}%>
  </table>
  
  
  </tr>  
  </table>
  <br>
<%@ include file="/workflow/request/WorkflowManageSign.jsp" %>
<script language=vbs>
sub onShowResourceID(ismand)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	resourceidspan.innerHtml = "<A href='javaScript:openhrm("&id(0)&");' onclick='pointerXY(event);'>"&id(1)&"</A>"
	frmmain.resourceid.value=id(0)
	else 
		if ismand=1 then
			resourceidspan.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
		else
			resourceidspan.innerHtml = ""
		end if
	frmmain.resourceid.value="0"
	end if
	end if
end sub
</script>   
</form>
<script language=javascript>

	function doRemark(){
		document.frmmain.isremark.value='1';
		document.frmmain.src.value='save';
		document.all("remark").value += "\n<%=username%> <%=currentdate%> <%=currenttime%>" ;
		document.frmmain.nodesnum.value=<%=rowsum%>;
		//附件上传
                        StartUploadAll();
                        checkuploadcomplet();
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
        window.alert("结束时间不能小于起始时间");
         return false;
  			 }
  }
     return true; 
}

	
	function doSave(){
		if(check_form(document.frmmain,'<%=needcheck%>')){
            if(document.frmmain.field289.value == document.frmmain.field290.value )
                alert("<%=SystemEnv.getHtmlNoteName(43,user.getLanguage())%>");
            else {
                document.frmmain.src.value='save';
    //			document.all("remark").value += "\n<%=username%> <%=currentdate%> <%=currenttime%>" ;
                document.frmmain.nodesnum.value=<%=rowsum%>;
                if(checktimeok()){
	                //附件上传
                        StartUploadAll();
                        checkuploadcomplet();
				}
            }
		}
	}
	function doSubmit(){
		if(check_form(document.frmmain,'<%=needcheck%>')){
            if(document.frmmain.field289.value == document.frmmain.field290.value )
                alert("<%=SystemEnv.getHtmlNoteName(43,user.getLanguage())%>");
            else {
                document.frmmain.src.value='submit';
                document.all("remark").value += "\n<%=username%> <%=currentdate%> <%=currenttime%>" ;
                document.frmmain.nodesnum.value=<%=rowsum%>;
                if(checktimeok()){
	                //附件上传
                        StartUploadAll();
                        checkuploadcomplet();
				}
            }
		}
	}
	function doReject(){
			document.frmmain.src.value='reject';
			document.all("remark").value += "\n<%=username%> <%=currentdate%> <%=currenttime%>" ;
		    document.frmmain.nodesnum.value=<%=rowsum%>;
            if(onSetRejectNode()){
			//附件上传
                        StartUploadAll();
                        checkuploadcomplet();
                }
	}
	function doReopen(){
			document.frmmain.src.value='reopen';
			document.all("remark").value += "\n<%=username%> <%=currentdate%> <%=currenttime%>" ;
		    document.frmmain.nodesnum.value=<%=rowsum%>;
			//附件上传
                        StartUploadAll();
                        checkuploadcomplet();
	}
	function doDelete(){
			document.frmmain.src.value='delete';
			document.all("remark").value += "\n<%=username%> <%=currentdate%> <%=currenttime%>" ;
		    document.frmmain.nodesnum.value=<%=rowsum%>;
			//附件上传
                        StartUploadAll();
                        checkuploadcomplet();
	}
</script>

</body>
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</html>
