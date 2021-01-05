
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.workflow.request.RequestInfo" %>
<%@ include file="/docs/common.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet3" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetC" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetHrm" class="weaver.conn.RecordSet" scope="page" />

<jsp:useBean id="AllManagers" class="weaver.hrm.resource.AllManagers" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="RecordSetV" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ProjectProcessList" class="weaver.proj.Maint.ProjectProcessList" scope="page" />
<jsp:useBean id="ProjectStatusComInfo" class="weaver.proj.Maint.ProjectStatusComInfo" scope="page" />

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script type="text/javascript">
var e;
var rowsNum = 0;
var tbl;
var imgIDs = "";
window.onload = function(){
	tbl = document.getElementById("mytbl");
	if(!tbl) return;
	rowsNum = tbl.rows.length;

	var aImgIDs = imgIDs.split(",");
	for(var i=0; i<aImgIDs.length; i++){
		try{setImgSrc(aImgIDs[i])}catch(e){}
	}
}

function toggleChild(tr, children){
	for(var i=0; i<children.length; i++){
		var child = children[i];
		var childType = getChildType(child);
		var clicked = child.getAttribute("clicked");
		//alert(child+","+childType+","+clicked);
		if(childType=="node" && clicked=="false"){
			toggleChild(child, getChildren(child));
		}
		child.style.display = tr.open=="true" ? "none" : "";
	}
	changeImg(tr);
}

function changeImg(tr){
	var img = document.getElementById("img"+tr.id);
	if(tr.open=="true"){
		img.src = img.src.replace("rank1", "rank2");
	}else{
		img.src = img.src.replace("rank2", "rank1");
	}
	tr.open = tr.open=="true" ? "false" : "true";
}

function getChildType(tr){
	var type;
	var level = tr.getAttribute("level");
	var _level;
	try{
		_level = tbl.rows(tr.rowIndex+1).getAttribute("level");
		if(_level==parseInt(level)+1){
			type = "node";
		}else{
			type = "leaf";
		}
	}catch(e){
		type = "leaf";
	}
	return type;
}

function getChildren(tr){
	tbl = document.getElementById("mytbl");
	if(!tbl) return;
	rowsNum = tbl.rows.length;

	var children = new Array();
	var level = tr.getAttribute("level");
	var _level = -1;
	for(var i=tr.rowIndex+1; i<rowsNum; i++){
		_level = tbl.rows[i].getAttribute("level");
		if(_level==parseInt(level)+1){
			children.push(tbl.rows[i]);
		}else if(level==_level){
			break;
		}else{
			continue;
		}
	}
	return children;
}

function setImgSrc(trId){
	
	var tr = document.getElementById(trId);
	var o = document.getElementById("img"+trId);
	var trType = getChildType(tr);
	o.src = trType=="leaf" ? o.src.replace("rank2", "rank1") : o.src.replace("rank1", "rank2");
	
	//changeImg(document.getElementById(trId));
}
</script>
</HEAD>
<%
char flag = 2;
String ProcPara = "";
String ProjID = Util.null2String(request.getParameter("ProjID"));
String islandmark = Util.null2String(request.getParameter("islandmark"));
 

String logintype = ""+user.getLogintype();
/*权限－begin*/
boolean canview=false;
boolean canedit=false;
boolean iscreater=false;
boolean ismanager=false;
boolean ismanagers=false;
boolean ismember=false;
boolean isrole=false;
boolean isshare=false;
String iscustomer="0";

String ViewSql="select * from PrjShareDetail where prjid="+ProjID+" and usertype="+user.getLogintype()+" and userid="+user.getUID();

RecordSetV.executeSql(ViewSql);
//out.print(ViewSql);
if(RecordSetV.next())
{
	 canview=true;
	 if(RecordSetV.getString("usertype").equals("2")){
	 	iscustomer=RecordSetV.getString("sharelevel");
	 }else{
		 if(RecordSetV.getString("sharelevel").equals("2")){
			canedit=true;	
			ismanager=true;  
		 }else if (RecordSetV.getString("sharelevel").equals("3")){
			canedit=true;	
			ismanagers=true;
		 }else if (RecordSetV.getString("sharelevel").equals("4")){
			canedit=true;	
			isrole=true;
		 }else if (RecordSetV.getString("sharelevel").equals("5")){
			ismember=true;
		 }else if (RecordSetV.getString("sharelevel").equals("1")){
			isshare=true;
		 }	 
	 }
}

if(!canview){
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
/*权限－end*/

String log = Util.null2String(request.getParameter("log"));
String level = Util.null2String(request.getParameter("level"));
String subject= Util.fromScreen2(request.getParameter("subject"),user.getLanguage());
String begindate01= Util.null2String(request.getParameter("begindate01"));
String begindate02= Util.null2String(request.getParameter("begindate02"));
String enddate01= Util.null2String(request.getParameter("enddate01"));
String enddate02= Util.null2String(request.getParameter("enddate02"));
String hrmid = Util.null2String(request.getParameter("hrmid"));
if(level.equals("")){
	level = "10" ;
}
RecordSet.executeProc("Prj_ProjectInfo_SelectByID",ProjID);
if(RecordSet.getCounts()<=0)
	response.sendRedirect("/base/error/DBError.jsp?type=FindData");
RecordSet.first();

int requestid = RecordSet.getInt("requestid");
/*获得相关的请求信息*/
RequestInfo rqInfo = null;
if(requestid!=0){
	rqInfo = new RequestInfo(requestid,user);
	//System.out.println("requestInfo.getWorkflowid() = "+requestInfo.getWorkflowid());
}else{
	rqInfo = new RequestInfo();
}

String status = RecordSet.getString("status");
String statusname = "";
statusname = ("0".equals(status)?"草稿":"1".equals(status)?"正常":"2".equals(status)?"延期":"3".equals(status)?"完成":"4".equals(status)?"冻结":"5".equals(status)?"立项批准":"6".equals(status)?"待审批":"7".equals(status)?"审批退回":"草稿");
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(407,user.getLanguage())+"-"+"<a href='/proj/data/ViewProject.jsp?log="+log+"&ProjID="+ProjID+"'>"+Util.toScreen(RecordSet.getString("name"),user.getLanguage())+"</a>"+"("+statusname+")";
String needfav ="1";
String needhelp ="";

String isCurrentActived = "";

String sqlwhere="";
//TD5130
//modified by hubo, 2006-10-12
sqlwhere=" where prjid = "+ProjID+" and  level_n <= 10 and isdelete='0' ";
if(!subject.equals("")){
	sqlwhere+=" and subject like '%"+subject+"%' ";
}
if(!begindate01.equals("")){
	sqlwhere+=" and begindate>='"+begindate01+"'";
}
if(!begindate02.equals("")){
	sqlwhere+=" and begindate<='"+begindate02+"'";
}
if(!enddate01.equals("")){
	sqlwhere+=" and enddate>='"+enddate01+"'";
}
if(!enddate02.equals("")){
	sqlwhere+=" and enddate<='"+enddate02+"'";
}
if(!hrmid.equals("")){
	sqlwhere+=" and hrmid='"+hrmid+"'";
}

String sqlstr = "" ;
ArrayList theparentmaxdsporder = null ;
if(!islandmark.equals("1")) {
    theparentmaxdsporder = new ArrayList() ;
    String sqlmaxorderstr = " select max(dsporder) , parentid from Prj_TaskProcess " + sqlwhere + 
                            " group by parentid " ;
    RecordSet.executeSql(sqlmaxorderstr);
    while( RecordSet.next() ) {
        String maxdsporder = ""+Util.getIntValue(RecordSet.getString(1),0) ;
        String theparentid = Util.null2String(RecordSet.getString(2)) ;
        theparentmaxdsporder.add(theparentid+"_"+maxdsporder) ;
    }
    sqlstr = " SELECT * FROM Prj_TaskProcess " +sqlwhere+ " order by parentid , dsporder";
}
else {
    sqlstr = " SELECT * FROM Prj_TaskProcess " +sqlwhere+ " and islandmark='1' order by parentid, dsporder ";
}
//System.out.println("newplan sqlstr :"+sqlstr);
ProjectProcessList.getProcessList(sqlstr) ;

if(ProjectProcessList.next()){
	isCurrentActived = ProjectProcessList.getIsactived();
}
ProjectProcessList.beforeFirest() ;

String CurrentUser = ""+user.getUID();
int usertype = 0;
if(user.getLogintype().equals("2"))
	usertype= 1;

ArrayList requesttaskids=new ArrayList();
ArrayList requesttaskcounts=new ArrayList();
ArrayList doctaskids=new ArrayList();
ArrayList doctaskcounts=new ArrayList();

sqlstr="";
sqlstr="select t3.taskid, count(distinct t3.requestid) from workflow_requestbase t1,workflow_currentoperator t2, Prj_Request t3 where t1.requestid = t2.requestid and t2.userid = "+CurrentUser+" and t2.usertype=" + usertype + " and t1.requestid = t3.requestid  and t3.prjid = "+ProjID+" group by t3.taskid ";
RecordSetC.executeSql(sqlstr);
while(RecordSetC.next()){
		requesttaskids.add(RecordSetC.getString(1));
		requesttaskcounts.add(RecordSetC.getString(2));
}

sqlstr="SELECT t3.taskid, count(distinct t3.docid) FROM DocDetail  t1, "+tables+" t2, Prj_Doc t3  where t1.docstatus in ('1','2','5') and t1.id = t2.sourceid  and t1.id = t3.docid  and t3.prjid = "+ProjID+" group by t3.taskid ";
RecordSetC.executeSql(sqlstr);
while(RecordSetC.next()){
		doctaskids.add(RecordSetC.getString(1));
		doctaskcounts.add(RecordSetC.getString(2));
}


ProcPara = ProjID + flag + "0" ;
RecordSetHrm.executeProc("Prj_Member_SumProcess",ProcPara);
   // System.out.println("COUNT :"+RecordSetHrm.getCounts() );
   
//批准时流程必填字段检查
boolean hasMandField = false;
if(requestid!=0){
    String fieldnames = "";
    int fieldnum = 0;
    String sqlForSearch = "SELECT b.fieldname from workflow_nodeform a, workflow_billfield b where a.fieldid= b.id and a.ismandatory=1 and a.nodeid="+rqInfo.getNodeid()+" order by b.dsporder";
    RecordSetC.executeSql(sqlForSearch);
    while(RecordSetC.next()){
        fieldnum++;
        fieldnames += Util.null2String(RecordSetC.getString("fieldname"))+",";
    }
    if(!fieldnames.equals("")){
        fieldnames = fieldnames.substring(0,fieldnames.length()-1);
        sqlForSearch = "select "+fieldnames+" from Bill_ApproveProj where requestid="+requestid;
        RecordSetC.executeSql(sqlForSearch);
        RecordSetC.next();
        for(int i=1;i<=fieldnum;i++){
            String fieldvalue = Util.null2String(RecordSetC.getString(i));
            if(fieldvalue.equals("")){
                hasMandField = true;
                break;
            }
        }
    }
}
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>


<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>


<DIV>
<%
// add by dongping for Fixed BUG728
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javaScript:weaver.submit(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%//System.out.println("canedit = "+canedit);%>
<%if(!isCurrentActived.equals("2") && canedit && !status.equals("6")){%>
<%
    //RCMenu += "{"+SystemEnv.getHtmlLabelName(1342,user.getLanguage())+",/proj/plan/AddTask.jsp?ProjID="+ProjID+",_self} " ;
    //RCMenuHeight += RCMenuHeightStep;
%>
<%}%>





<%if(ProjectProcessList.getCounts()>0 && canedit){%>
	<!--BUTTON AccessKey=B CLASS=btn onclick="if(issubmit()){location='/proj/plan/PlanOperation.jsp?ProjID=<%=ProjID%>&method=tellmember'}"><U>B</U>-<%=SystemEnv.getHtmlLabelName(1348,user.getLanguage())%></BUTTON -->
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(1348,user.getLanguage())+",/systeminfo/BrowserMain.jsp?url=/proj/process/ProjNotice.jsp?ProjID="+ProjID+",_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%}%>
<%if(ProjectProcessList.getCounts()>0){%>

<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(1349,user.getLanguage())+",/proj/plan/DspMember.jsp?ProjID="+ProjID+",_self} " ;
RCMenuHeight += RCMenuHeightStep;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1044,user.getLanguage())+",/proj/process/DspRequest.jsp?ProjID="+ProjID+",_self} " ;
RCMenuHeight += RCMenuHeightStep;
RCMenu += "{"+SystemEnv.getHtmlLabelName(857,user.getLanguage())+",/proj/process/DspDoc.jsp?ProjID="+ProjID+",_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%}%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/proj/data/ViewTaskLog.jsp?ProjID="+ProjID+",_self} " ;
RCMenuHeight += RCMenuHeightStep;
if("1".equals(islandmark)){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/proj/plan/NewPlan.jsp?ProjID="+ProjID+",_self} " ;
	RCMenuHeight += RCMenuHeightStep;
}else{
	RCMenu += "{"+SystemEnv.getHtmlLabelName(2232,user.getLanguage())+",/proj/plan/NewPlan.jsp?ProjID="+ProjID+"&islandmark=1,_self} " ;
	RCMenuHeight += RCMenuHeightStep;
}


%>

<%if(rqInfo.getHasright()==1&&!rqInfo.getIsend().equals("1")&&!rqInfo.getNodetype().equals("0")){%>
	<%
    RCMenu += "{"+SystemEnv.getHtmlLabelName(142,user.getLanguage())+",javascript:doSubmit(this),_top} " ;
    RCMenuHeight += RCMenuHeightStep ;
	%>
<%}%>
<%if(rqInfo.getHasright()==1&&!rqInfo.getIsend().equals("1")&&rqInfo.getNodetype().equals("0")){%>
	<%
    RCMenu += "{"+SystemEnv.getHtmlLabelName(15143,user.getLanguage())+",javascript:doSubmit2(this),_top} " ;
    RCMenuHeight += RCMenuHeightStep ;
	%>
<%}%>
<%if(rqInfo.getHasright()==1&&rqInfo.getIsreject().equals("1")){%>
	<%
    RCMenu += "{"+SystemEnv.getHtmlLabelName(236,user.getLanguage())+",javascript:doReject(this),_top} " ;
    RCMenuHeight += RCMenuHeightStep ;
	%>
<%}%>
<%  /*审批退回后，工作流被删除，重新提交工作流*/
	if(requestid==0&&status.equals("7")&& ismanager){%>
		<%
	RCMenu += "{"+SystemEnv.getHtmlLabelName(15143,user.getLanguage())+",javascript:submitPlan(this),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;
	%>
<%}else if(!isCurrentActived.equals("2") && ProjectProcessList.getCounts()>0 && ismanager && (status.equals("0")||status.equals("")||"7".equals(status) )){//提交批准%>
	<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(1343,user.getLanguage())+",javascript:submitPlan(this),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>

<%}%>
</DIV>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<form name=weaver method=post action="/proj/plan/NewPlan.jsp">
  <input type="hidden" name="ProjID" value="<%=ProjID%>">
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

<table class=liststyle cellspacing=1 >
  <tr class=datadark>
     <td width="60"><%=SystemEnv.getHtmlLabelName(2099,user.getLanguage())%></td>
     <td class=field>&nbsp
		<select class=inputstyle  name=level size=1    onChange="weaver.submit()">
		 <%for(int i=1;i<=10;i++){%>
			 <option value="<%=i%>" <%if(level.equals(""+i)){%>selected<%}%>><%=i%></option>
		 <%}%>
		 </select>	 
	 </td>
     <td width="60" align=right><%=SystemEnv.getHtmlLabelName(1352,user.getLanguage())%></td>
     <td class=field>&nbsp
		<input name=subject size=15 class="InputStyle" value="<%=Util.toScreenToEdit(request.getParameter("subject"),user.getLanguage())%>">	 
	 </td>
     <TD><%=SystemEnv.getHtmlLabelName(1322,user.getLanguage())%></TD>
     <TD class=Field>
			  <button type="button" class=calendar id=SelectDate onclick=getProjSubDate(begindate01span,begindate01)></BUTTON>&nbsp;
			  <SPAN id=begindate01span ><%=begindate01%></SPAN>
			  <input type="hidden" name="begindate01" value="<%=begindate01%>">
			  －	&nbsp;<button type="button" class=calendar id=SelectDate onclick=getProjSubDate(begindate02span,begindate02)></BUTTON>&nbsp;
			  <SPAN id=begindate02span ><%=begindate02%></SPAN>
			  <input type="hidden" name="begindate02" value="<%=begindate02%>">
		  
	</TD>
     <TD><%=SystemEnv.getHtmlLabelName(1323,user.getLanguage())%></TD>
     <TD class=field>
			  <button type="button" class=calendar id=SelectDate onclick=getProjSubDate(enddate01span,enddate01)></BUTTON>&nbsp;
			  <SPAN id=enddate01span ><%=enddate01%></SPAN>
			  <input type="hidden" name="enddate01" value="<%=enddate01%>">
			  －	&nbsp;<button type="button" class=calendar id=SelectDate onclick=getProjSubDate(enddate02span,enddate02)></BUTTON>&nbsp;
			  <SPAN id=enddate02span ><%=enddate02%></SPAN>
			  <input type="hidden" name="enddate02" value="<%=enddate02%>">
		  
	</TD>
     <td width="60" align=right><%=SystemEnv.getHtmlLabelName(2097,user.getLanguage())%></td>
     <td class=field>&nbsp
		<select class=inputstyle  name=hrmid size=1  onChange="weaver.submit()">
			 <option value="" <%if(hrmid.equals("")){%>selected<%}%>></option>
		 <%while(RecordSetHrm.next()){%>
			 <option value="<%=RecordSetHrm.getString("hrmid")%>" <%if(RecordSetHrm.getString("hrmid").equals(""+hrmid)){%>selected<%}%>><%=ResourceComInfo.getResourcename(RecordSetHrm.getString("hrmid"))%></option>
		 <%}%>
		 </select>	 
	 </td>
  </tr>
</table>

</form>
<TABLE class=liststyle cellspacing=1  id="mytbl">
<TBODY>
  <colgroup>
  <% if(canedit && !islandmark.equals("1") ) { //增加是否有顺序调整的判断 %>
  <col width="30%">
  <col width="10%">
  <col width="10%">
  <col width="6%">
  <col width="10%">
  <col width="10%">
  <col width="6%">
  <col width="10%">
  <col width="8%">
  <%}else {%>
  <col width="30%">
  <col width="10%">
  <col width="10%">
  <col width="10%">
  <col width="10%">
  <col width="10%">
  <col width="10%">
  <col width="10%">
  <%}%>
	    <TR class=Header>
	      <th><%=SystemEnv.getHtmlLabelName(1352,user.getLanguage())%></th>
		  <th nowrap><%=SystemEnv.getHtmlLabelName(2238,user.getLanguage())%>/<%=SystemEnv.getHtmlLabelName(17855,user.getLanguage())%></th>
		  <th nowrap><%=SystemEnv.getHtmlLabelName(2097,user.getLanguage())%></th>
		  <th nowrap><%=SystemEnv.getHtmlLabelName(1324,user.getLanguage())%></th>
	      <th nowrap><%=SystemEnv.getHtmlLabelName(1322,user.getLanguage())%></th>
	      <th nowrap><%=SystemEnv.getHtmlLabelName(1323,user.getLanguage())%></th>

		  <th><%=SystemEnv.getHtmlLabelName(104,user.getLanguage())%></th>
          <th><%=SystemEnv.getHtmlLabelName(15274,user.getLanguage())%></th>
          <% if(canedit && !islandmark.equals("1") ) { %><th nowrap><%=SystemEnv.getHtmlLabelName(88,user.getLanguage())%></th><%}%>
	    </TR>
		
<%
boolean isLight = false;
if(ProjectProcessList.getCounts()>0){
	RecordSet2.executeProc("Prj_TaskProcess_Sum",ProjID);
	RecordSet2.next();
%>

	    <TR class=Header>
	      <th>Total</th>
		  <th nowrap>&nbsp;</th>
		  <th nowrap>&nbsp;</th>
		  <th nowrap><%=RecordSet2.getString("workday")%></th>
		  <th nowrap><%if(!RecordSet2.getString("begindate").equals("x")){%><%=RecordSet2.getString("begindate")%><%}%></th>
		  <th nowrap><%if(!RecordSet2.getString("enddate").equals("-")){%><%=RecordSet2.getString("enddate")%>		  <%}%></th>

		  <th nowrap>&nbsp;</th>
          <th nowrap><%=RecordSet2.getString("fixedcost")%></th>
          <% if(canedit && !islandmark.equals("1") ) { %><th nowrap>&nbsp;</th><%}%>
	    </TR>
		<TR class=Line>
		<Th colspan="8" ></th>
		<% if(canedit && !islandmark.equals("1") ) { %><th class="Line"></th><%}%></TR> 

<%
int prelevel=1;
String prerecid="";
while(ProjectProcessList.next()) {
	boolean isResponser=false;
	if( (ProjectProcessList.getParenthrmids()).indexOf(","+user.getUID()+"|")!=-1 && user.getLogintype().equals("1") ){
	  isResponser=true;
	}
%>


	<TR CLASS=<%if(isLight){%>DataLight<%}else{%>DataDark<%}%>
		id="<%=ProjectProcessList.getId()%>" 
		level="<%=Util.getIntValue(ProjectProcessList.getLevel_n())%>" 
		clicked="false" 
		<%
		if(Util.getIntValue(ProjectProcessList.getLevel_n())>Util.getIntValue(level)){
			out.print(" style=\"display:none\" open=\"true\" ");
		}else{
			out.print(" style=\"display:\" open=\"true\" ");
		}
		%>>

          <TD>
				<%for(int i=1;i<Util.getIntValue(ProjectProcessList.getLevel_n());i++){%>&nbsp&nbsp&nbsp&nbsp<%}%>
			<img id="img<%=ProjectProcessList.getId()%>" 
				src="/images/project_rank1_wev8.gif"
				class="project_rank"  
				onmouseup='rankclick("taskdiv<%=ProjectProcessList.getId()%>")'>
				<%if(Util.getIntValue(ProjectProcessList.getLevel_n())==Util.getIntValue(level)){%> 
					<script type="text/javascript">imgIDs+="<%=ProjectProcessList.getId()%>,";</script>
				<%}%>
				
				<a href="/proj/plan/ViewTask.jsp?taskrecordid=<%=ProjectProcessList.getId()%>" ><%=ProjectProcessList.getSubject()%></a>
               <%
                String prefinish= ProjectProcessList.getPrefinish();
                if(!prefinish.equals("0")){%> 
                    <img src="/images/ArrowUpGreen_wev8.gif"  width="7" height="10">
                 <%}%>              
            </TD>
          <TD nowrap>
<%
		String temptaskid="";
		String temprequestcount="0";
		String tempdoccount="0";
		for(int i=0;i<requesttaskids.size();i++){
			temptaskid=(String) requesttaskids.get(i);
			if(temptaskid.equals(ProjectProcessList.getId())) {
				temprequestcount=(String) requesttaskcounts.get(i);
				break;
			}
		}
		for(int i=0;i<doctaskids.size();i++){
			temptaskid=(String) doctaskids.get(i);
			if(temptaskid.equals(ProjectProcessList.getId())) {
				tempdoccount=(String) doctaskcounts.get(i);
				break;
			}
		}

		int coworkCount = 0;
		String taskIds = "";//coworkIds
		//=============================================Cowork_Items
		if("oracle".equals(RecordSet.getDBType())){
			RecordSet.executeSql("SELECT id FROM cowork_items WHERE ','||relatedprj||',' LIKE '%,"+ProjectProcessList.getId()+",%'");
		}else{
			RecordSet.executeSql("SELECT id FROM cowork_items WHERE ','+relatedprj+',' LIKE '%,"+ProjectProcessList.getId()+",%'");
		}
		while(RecordSet.next()){
			coworkCount ++;
			taskIds += RecordSet.getString("id") + ",";
		}
		//if(taskIds.endsWith(",")) taskIds = taskIds.substring(0,taskIds.length()-1);
		//=============================================Cowork_Discuss
		if("oracle".equals(RecordSet.getDBType())){
			RecordSet.executeSql("SELECT coworkid FROM cowork_discuss WHERE ','||relatedprj||',' LIKE '%,"+ProjectProcessList.getId()+",%'");
		}else{
			RecordSet.executeSql("SELECT coworkid FROM cowork_discuss WHERE ','+relatedprj+',' LIKE '%,"+ProjectProcessList.getId()+",%'");
		}
		while(RecordSet.next()){
			if((","+taskIds).indexOf(","+RecordSet.getString("coworkid")+",")==-1){
				coworkCount++;
				taskIds += RecordSet.getString("coworkid") + ",";
			}
		}
		if(taskIds.endsWith(",")) taskIds = taskIds.substring(0,taskIds.length()-1);
%>
			<%if(!temprequestcount.equals("0")){%>
				<a href="/proj/plan/ViewTask.jsp?taskrecordid=<%=ProjectProcessList.getId()%>#anchor_wf" ><img src="/images/prj_request_wev8.gif" border=0 alt="<%=SystemEnv.getHtmlLabelName(259,user.getLanguage())%>"></a><%=temprequestcount%> 
			<%}%>
			<%if(!tempdoccount.equals("0")){%>
				<a href="/proj/plan/ViewTask.jsp?taskrecordid=<%=ProjectProcessList.getId()%>#anchor_doc" ><img src="/images/prj_doc_wev8.gif" border=0 alt="<%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%>"></a><%=tempdoccount%>
			<%}%>
			<%if(coworkCount>0){%>
				<a href="/cowork/coworkview.jsp?taskIds=<%=taskIds%>&type=all"><img src="/images_face/ecologyFace_2/LeftMenuIcon/MyAssistance_wev8.gif" style="border:0" alt="<%=SystemEnv.getHtmlLabelName(17855,user.getLanguage())%>" /></a><%=coworkCount%>
			<%}%>
		  </TD>
		  <TD nowrap><%if(user.getLogintype().equals("1")){%><a href="/hrm/resource/HrmResource.jsp?id=<%=ProjectProcessList.getHrmid()%>"><%if(ProjectProcessList.getHrmid().equals(""+user.getUID())){ %><font class=fontred><%}}%><%=ResourceComInfo.getResourcename(ProjectProcessList.getHrmid())%><%if(user.getLogintype().equals("1")){%><%if(ProjectProcessList.getHrmid().equals(""+user.getUID())){ %></font></a><%}}%></TD>
          <TD nowrap><%=ProjectProcessList.getWorkday()%></TD>
          <TD nowrap><%if(!ProjectProcessList.getBegindate().equals("x")){%><%=ProjectProcessList.getBegindate()%><%}%></TD>
          <TD nowrap><%if(!ProjectProcessList.getEnddate().equals("-")){%><%=ProjectProcessList.getEnddate()%>		  <%}%></TD>

          <TD nowrap>
		  <!--<%if(canedit || isResponser ){%>	  
		  <a href="/proj/plan/AddTask.jsp?ProjID=<%=ProjID%>&parentid=<%=ProjectProcessList.getId()%>"><%=SystemEnv.getHtmlLabelName(2098,user.getLanguage())%></a>
		  <%}%>-->	  
		  </TD>
          <TD><%=ProjectProcessList.getFixedcost()%></TD>

          <% if(canedit && !islandmark.equals("1") ) { %>
         <td align=center>
             <!--<table border=0 width=100%><tr>
            <td width=50%>
            <% int recorderindex = Util.getIntValue(ProjectProcessList.getDsporder(),0) ;
               int theparentid = Util.getIntValue(ProjectProcessList.getParentid(),0) ;
               int ismaxindex = theparentmaxdsporder.indexOf(""+theparentid+"_"+recorderindex) ;
               if(recorderindex != 1 && recorderindex != 0 ) { %>
            <a href='TaskOperation.jsp?ProjID=<%=ProjID%>&taskrecordid=<%=ProjectProcessList.getId()%>&method=uporder'><img src="/images/ArrowUpGreen_wev8.gif" border=0></a>
            <% } %>
            </td>
            <td width=50%>
            <% if(ismaxindex == -1 && recorderindex != 0 ) { %>
            <a href='TaskOperation.jsp?ProjID=<%=ProjID%>&taskrecordid=<%=ProjectProcessList.getId()%>&method=downorder'><img src="/images/ArrowDownRed_wev8.gif" border=0></a>
            <% } %>
            </td>
            </tr>
            </table>-->
          </td>
          <%}%>
    </TR>

	

<%
	isLight = !isLight;
	prelevel = Util.getIntValue(ProjectProcessList.getLevel_n());
	prerecid = ProjectProcessList.getId();
}
%>

<%
}
%>
</TBODY>
</TABLE>
</td>
		</tr>
		</TABLE>
	</td>
	<td></td>
</tr>
<tr>
	<td height="10" colspan="3"></td>
</tr>

<FORM id=weaver2 name=weaver2 action="/workflow/request/BillApproveProjOperation.jsp" method=post>
	<%if(requestid!=0){%>
	  <%if(rqInfo.getHasright()==1||rqInfo.getIsremark()==1){%>
			<input type=hidden name="requestid" value=<%=rqInfo.getRequestid()%>>
			<input type=hidden name="workflowid" value=<%=rqInfo.getWorkflowid()%>>
			<input type=hidden name="nodeid" value=<%=rqInfo.getNodeid()%>>
			<input type=hidden name="nodetype" value=<%=rqInfo.getNodetype()%>>
			<input type=hidden name="src">
			<input type=hidden name="iscreate" value="0">
			<input type=hidden name="formid" value=<%=rqInfo.getFormid()%>>
			<input type=hidden name="billid" value=<%=rqInfo.getBillid()%>>
			<input type=hidden name="requestname" value=<%=rqInfo.getRequestname()%>>
			<input type=hidden name="isfromproj" value="1">
			<input type="hidden" name="ProjID" value="<%=ProjID%>"/>
		<%}%>
	<%}%>

  </FORM>

</table>
<script language=vbs>
sub getProj(prjid)
	returndate =  window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/proj/process/ProjNotice.jsp?ProjID="&prjid)

   
end sub
</script>

<script language=javascript >
function rankclick(targetId)
{    
  
  /*
		var objSrcElement = window.event.srcElement;
    if (document.all(targetId)==null) {

           objSrcElement.src = "/images/project_rank1_wev8.gif";

	} else {
         var targetElement = document.all(targetId);

          if (targetElement.style.display == "none") 
		{
             objSrcElement.src = "/images/project_rank1_wev8.gif";
             targetElement.style.display = "";
		}
            else
		{
             objSrcElement.src = "/images/project_rank2_wev8.gif";
             targetElement.style.display = "none";
		}
	}
	*/

	e = event.srcElement;
	var o = e;
	while(o.tagName!="TR") o=o.parentNode;
	var children = getChildren(o);
	var trType = getChildType(o);
	if(trType=="leaf") return;
	toggleChild(o, children);
	o.clicked = o.clicked=="true" ? "false" : "true";
}



function submitS()
{
	if(issubmit()){
		document.all("method").value="delete" ;
		weaver.submit();
		}
}

function submitPlan(obj){
	if(confirm("你确定要提交审批吗？")){
		obj.disabled = true;
		document.location = "/proj/plan/PlanOperation.jsp?ProjID=<%=ProjID%>&method=submitplan" ;
	}
}

function approvePlan(obj){
	obj.disabled = true;
	document.location = "/proj/plan/PlanOperation.jsp?ProjID=<%=ProjID%>&method=approveplan" ;
}


function doSubmit(obj){
	var hasMandField = "<%=hasMandField%>";
	if(confirm("你确定要批准吗？")){
		if(hasMandField=="true"){
			alert("<%=SystemEnv.getHtmlLabelName(18015,user.getLanguage())%><%=SystemEnv.getHtmlNoteName(14,user.getLanguage())%>！");
			return;
		}
		obj.disabled = true;
		document.weaver2.src.value='submit';
		document.weaver2.submit();
	}
}

function doSubmit2(obj){
	if(confirm("你确定要提交吗？")){
		obj.disabled = true;
		document.weaver2.src.value='submit';
		document.weaver2.submit();
	}
}

function doReject(obj){
	if(confirm("你确定要退回吗？")){
		obj.disabled = true;
		document.weaver2.src.value='reject';
		document.weaver2.submit();
	}
}
</script>
</BODY>
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</HTML>
