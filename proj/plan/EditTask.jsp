
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util,
                 weaver.conn.RecordSet" %>
<%@ page import="org.jdom.*" %>
<%@ page import="org.jdom.input.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet3" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="AllManagers" class="weaver.hrm.resource.AllManagers" scope="page"/>
<jsp:useBean id="RecordSetV" class="weaver.conn.RecordSet" scope="page" />

<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script LANGUAGE="JavaScript" SRC="/js/checkinput_wev8.js"></script>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<SCRIPT language="javascript" src="/js/projTask/ProjTask_wev8.js"></script>
</HEAD>
<%
int sign = Util.getIntValue(request.getParameter("sign"),-1);
String taskrecordid = request.getParameter("taskrecordid");
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(93,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(1332,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep;

RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/proj/plan/ViewTask.jsp?taskrecordid="+taskrecordid+",_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<%
if(sign!=-1){//如果从计算天数的页面返回的话
String ProjID=Util.null2String(request.getParameter("ProjID"));
String parentid=Util.null2String(request.getParameter("parentid"));
String parentids=Util.null2String(request.getParameter("parentids"));
String parenthrmids=Util.null2String(request.getParameter("parenthrmids"));
String hrmid=Util.null2String(request.getParameter("hrmid"));
String oldhrmid=Util.null2String(request.getParameter("oldhrmid"));
String finish=Util.null2String(request.getParameter("finish"));
String level=Util.null2String(request.getParameter("level"));
String subject=Util.null2String(request.getParameter("subject"));
String begindate=Util.null2String(request.getParameter("begindate"));
String enddate=Util.null2String(request.getParameter("enddate"));
String workday=Util.null2String(request.getParameter("workday"));
String fixedcost=Util.null2String(request.getParameter("fixedcost"));
String islandmark=Util.null2String(request.getParameter("islandmark"));
String pretaskid=Util.null2String(request.getParameter("taskids02"));
String content=Util.null2String(request.getParameter("content"));


RecordSet.executeProc("Prj_TaskProcess_SelectByID",taskrecordid);
RecordSet.next();
//String pretaskid=RecordSet.getString("prefinish");
ProjID = RecordSet.getString("prjid");

/*ADD BY CHaroes Huang On May 26,2004*/
    RecordSet rs = new RecordSet();
    String status_prj="" ;
    String sql_prjstatus="select status from Prj_ProjectInfo where id = "+ProjID;
    rs.executeSql(sql_prjstatus);
    if(rs.next())
    status_prj=rs.getString("status");
String taskname="";
if(!pretaskid.equals("0")){
    ArrayList pretaskids = Util.TokenizerString(pretaskid,",");
    int taskidnum = pretaskids.size();
    for(int j=0;j<taskidnum;j++){
 		///==============================================================================================	
 		//TD3732
 		//modified by hubo,2006-03-14
   		//String sql_1="select subject from Prj_TaskProcess where id = "+pretaskids.get(j);
 		String sql_1="select id,subject from Prj_TaskProcess where prjid="+Util.getIntValue(ProjID)+" AND taskIndex="+pretaskids.get(j)+"";
   		RecordSet3.executeSql(sql_1);
   		RecordSet3.next();
   		taskname +="<a href=/proj/process/ViewTask.jsp?taskrecordid="+RecordSet3.getInt("id")+">"+ RecordSet3.getString("subject")+ "</a>" +" ";
 		//==============================================================================================
    }
}

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

	boolean isResponser=false;
	if( RecordSet.getString("parenthrmids").indexOf(","+user.getUID()+"|")!=-1 && user.getLogintype().equals("1") ){
	  isResponser=true;
	}

if((!canedit && !isResponser)){
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
/*权限－end*/


%>


<FORM id=weaver name=weaver action="/proj/plan/TaskOperation.jsp" method=post>

  <input type="hidden" name="method" value="edit">
  <input type="hidden" name="type" value="plan">
  <input type="hidden" name="taskrecordid" value="<%=taskrecordid%>">
  <input type="hidden" name="ProjID" value="<%=RecordSet.getString("prjid")%>">
  <input type="hidden" name="parentids" value="<%=RecordSet.getString("parentids")%>">
  <input type="hidden" name="oldhrmid" value="<%=RecordSet.getString("hrmid")%>">

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
  <COL width="49%">
  <COL width="10">
  <COL width="49%">
  <TBODY>

  <TR>
    <TD vAlign=top>
      <TABLE class=viewform>
      <COLGROUP>
  	  <COL width="30%">
  	  <COL width="70%">
        <TBODY>

		<TR>
          <TD><%=SystemEnv.getHtmlLabelName(344,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=inputstyle maxLength=75 size=35 name="subject" value="<%=subject%>" onChange="checkinput('subject','subjectspan')"> <span
            id=subjectspan></span> </TD>
         </TR><TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
         <TR>
          <TD><%=SystemEnv.getHtmlLabelName(2097,user.getLanguage())%></TD>
          <TD class=Field>
          <button type="button" class=Browser id=SelectHrmid onClick="onShowHrmid()"></BUTTON> <span
            id=Hrmidspan>
				<%if(user.getLogintype().equals("1")){%><a href="/hrm/resource/HrmResource.jsp?id=<%=hrmid%>"><%}%><%=Util.toScreen(ResourceComInfo.getResourcename(hrmid),user.getLanguage())%><%if(user.getLogintype().equals("1")){%></a><%}%>
			</span>
              <INPUT class=inputstyle type=hidden name="hrmid" value="<%=hrmid%>"></TD>
        </TR><TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
        <TR>
        <TD><%=SystemEnv.getHtmlLabelName(1322,user.getLanguage())%></TD>
          <TD class=Field>
          <button type="button" class=Calendar onclick="getProjPBDate()"></BUTTON>
              <SPAN id=begindatespan >
				  <%if(!begindate.equals("x")){%>
						<%=begindate%>
				  <%}%>
			  </SPAN>
              <input type="hidden" name="begindate" id="begindate" value="<%=begindate%>">
          </TD>
        </TR><TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
        <TR>
        <TD><%=SystemEnv.getHtmlLabelName(1323,user.getLanguage())%></TD>
          <TD class=Field>
          <button type="button" class=Calendar onclick="getProjPEDate()"></BUTTON>
              <SPAN id=enddatespan >
				  <%if(!enddate.equals("-")){%>
						<%=enddate%>
				  <%}%>
			  </SPAN>
              <input type="hidden" name="enddate" id="enddate" value="<%=enddate%>">

          </TD>
         </TR><TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
         <TR>
         <TD><%=SystemEnv.getHtmlLabelName(1324,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=inputstyle maxLength=5 size=5 name="workday" value="<%=workday%>" onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("workday")' onchange="onWorkLongChange(this,begindate,begindatespan,enddate,enddatespan)"><SPAN id=workdayimage></SPAN></TD>
         </TR><TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
          <TR>
         <TD><%=SystemEnv.getHtmlLabelName(101,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(386,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=inputstyle maxLength=20 size=20 name="fixedcost" value="<%=fixedcost%>" onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("fixedcost")'><SPAN id=workdayimage></SPAN></TD>
         </TR><TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
       <TR>

          <TD><%=SystemEnv.getHtmlLabelName(2233,user.getLanguage())%></TD>
          <TD class=Field>
          	<button type="button" class=Browser onclick="onShowMTask('taskids02span','taskids02','ProjID','taskrecordid')"></button>
			<input type=hidden name="taskids02" value="<%=pretaskid%>">
			<span id="taskids02span">
             <%=taskname%>
            </span>
		  </TD>
        </TR><TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>

         <%if(RecordSet.getString("level_n").equals("1")){%>
            <TR>
          <TD><%=SystemEnv.getHtmlLabelName(2232,user.getLanguage())%></TD>
          <TD class=Field>
          <INPUT type=checkbox name="islandmark" value=1  <%if(islandmark.equals("1")){%> checked <%}%> ></TD>
        </TR><TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
    <%}%>
	  </TABLE>
	</TD>
	<TD></TD>
	<TD vAlign=top>
	 <TABLE class=viewform>
      <COLGROUP>
  	  <COL width="100%">
         <TR>
           <TD ><%=SystemEnv.getHtmlLabelName(1332,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%></TD>
		 </TR>
		 <TR>
           <TD class=Field><TEXTAREA class=inputstyle name="content" ROWS=8 STYLE="width:100%"><%=content%></TEXTAREA></TD>
         </TR>
     </TABLE>
	</TD>
   </TR>
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
</table>

</FORM>
</BODY>
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</HTML>









<%}else{//若是从一般进入
RecordSet.executeProc("Prj_TaskProcess_SelectByID",taskrecordid);
RecordSet.next();
String ProjID = RecordSet.getString("prjid");

String pretaskid=RecordSet.getString("prefinish");
//获取前置任务的index
weaver.proj.Templet.ProjTempletUtil ptu = new weaver.proj.Templet.ProjTempletUtil();
Element rootElement = null;
Document xmlDoc = new Document();
ArrayList indextList = new ArrayList();
RecordSet3.executeSql("select relationXml from Prj_ProjectInfo where id="+ProjID);
if (RecordSet3.next()){
	String xmlStr = Util.null2String(RecordSet3.getString(1));
	if ("".equals(xmlStr)||"<rootTask/>".equals(xmlStr)){
        	//如果没有值它将初始化一个值
        	rootElement = ptu.getXmlRootNode(Util.getIntValue(ProjID));
        } else {
            SAXBuilder builder = new SAXBuilder();
            xmlDoc = builder.build(new java.io.StringBufferInputStream(xmlStr));
            rootElement  = xmlDoc.getRootElement();
        }
        ArrayList resultList = new ArrayList();
        indextList = ptu.getIndexList(resultList,rootElement,0);
}
String taskname="";
if(!pretaskid.equals("0")){
    ArrayList pretaskids = Util.TokenizerString(pretaskid,",");
    int taskidnum = pretaskids.size();
    for(int j=0;j<taskidnum;j++){
    	String index = "";
    	try {
    		index = ((String[]) indextList.get(Util.getIntValue((String)pretaskids.get(j))-1))[0];
    	}catch(Exception e){
    		index = "";
    	}
    	if(!index.equals("")) {
    		//==============================================================================================	
    		//TD3732
			//modified by hubo,2006-03-14
		    //String sql_1="select subject from Prj_TaskProcess where id = "+pretaskids.get(j);
			String sql_1="select id,subject from Prj_TaskProcess where prjid="+Util.getIntValue(ProjID)+" AND taskIndex="+index+"";
		    RecordSet3.executeSql(sql_1);
		    RecordSet3.next();
		    taskname +="<a href=/proj/process/ViewTask.jsp?taskrecordid="+RecordSet3.getInt("id")+">"+ RecordSet3.getString("subject")+ "</a>" +" ";
			//==============================================================================================
    	}
    }
}

/*
boolean canedit_finish = true;
if(!pretaskid.equals("0")){
    PreFinish = RecordSet3.getString("finish");
    if(!PreFinish.equals("100")) canedit_finish=false;
    //out.print(canedit_finish);
}//查看是否有在前置任务，若有，在前置任务完成的情况下才能对进度进行编辑。
*/

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

	boolean isResponser=false;
	if( RecordSet.getString("parenthrmids").indexOf(","+user.getUID()+"|")!=-1 && user.getLogintype().equals("1") ){
	  isResponser=true;
	}

if(!canedit && !isResponser){
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
/*权限－end*/


%>

<FORM id=weaver name=weaver action="/proj/plan/TaskOperation.jsp" method=post >

  <input type="hidden" name="method" value="edit">
  <input type="hidden" name="type" value="plan">
  <input type="hidden" name="taskrecordid" value="<%=taskrecordid%>">
  <input type="hidden" name="ProjID" value="<%=RecordSet.getString("prjid")%>">
  <input type="hidden" name="parentids" value="<%=RecordSet.getString("parentids")%>">
  <input type="hidden" name="oldhrmid" value="<%=RecordSet.getString("hrmid")%>">

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
  <COL width="49%">
  <COL width="10">
  <COL width="49%">
  <TBODY>

  <TR>
    <TD vAlign=top>
      <TABLE class=viewform>
      <COLGROUP>
  	  <COL width="30%">
  	  <COL width="70%">
        <TBODY>

		<TR>
          <TD><%=SystemEnv.getHtmlLabelName(344,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=inputstyle maxLength=75 size=35 name="subject" value="<%=RecordSet.getString("subject")%>" onChange="checkinput('subject','subjectspan')"> <span
            id=subjectspan></span> </TD>
         </TR><TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
           <TR>
          <TD><%=SystemEnv.getHtmlLabelName(2097,user.getLanguage())%></TD>
          <TD class=Field>
          <button type="button" class=Browser id=SelectHrmid onClick="onShowHrmid()"></BUTTON> <span
            id=Hrmidspan>
				<%if(user.getLogintype().equals("1")){%><a href="/hrm/resource/HrmResource.jsp?id=<%=RecordSet.getString("hrmid")%>"><%}%><%=Util.toScreen(ResourceComInfo.getResourcename(RecordSet.getString("hrmid")),user.getLanguage())%><%if(user.getLogintype().equals("1")){%></a><%}%>
			</span>
              <INPUT class=inputstyle type=hidden name="hrmid" value="<%=RecordSet.getString("hrmid")%>"></TD>
        </TR><TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
        <TR>
        <TD><%=SystemEnv.getHtmlLabelName(1322,user.getLanguage())%></TD>
          <TD class=Field>
          <button type="button" class=Calendar onclick="getProjPBDate()"></BUTTON>
              <SPAN id=begindatespan >
				  <%if(!RecordSet.getString("begindate").equals("x")){%>
						<%=RecordSet.getString("begindate")%>
				  <%}%>
			  </SPAN>
              <input type="hidden" name="begindate" id="begindate" value="<%=RecordSet.getString("begindate")%>">
          </TD>
        </TR><TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
        <TR>
        <TD><%=SystemEnv.getHtmlLabelName(1323,user.getLanguage())%></TD>
          <TD class=Field>
          <button type="button" class=Calendar onclick="getProjPEDate()"></BUTTON>
              <SPAN id=enddatespan >
				  <%if(!RecordSet.getString("enddate").equals("-")){%>
						<%=RecordSet.getString("enddate")%>
				  <%}%>
			  </SPAN>
              <input type="hidden" name="enddate" id="enddate" value="<%=RecordSet.getString("enddate")%>">

          </TD>
         </TR><TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
         <TR>
         <TD><%=SystemEnv.getHtmlLabelName(1324,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=inputstyle maxLength=5 size=5 name="workday" value="<%=RecordSet.getString("workday")%>" onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("workday")' onchange="onWorkLongChange(this,begindate,begindatespan,enddate,enddatespan)"><SPAN id=workdayimage></SPAN></TD>
         </TR><TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
          <TR>
         <TD>项目预算</TD>
          <TD class=Field><INPUT class=inputstyle maxLength=20 size=20 name="fixedcost" value="<%=RecordSet.getString("fixedcost")%>" onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("fixedcost")'><SPAN id=workdayimage></SPAN></TD>
         </TR><TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
       <TR>

          <TD>前置任务</TD>
          <TD class=Field>
          	<button type="button" class=Browser onclick="onShowMTask('taskids02span','taskids02','ProjID','taskrecordid')"></button>
			<input type=hidden name="taskids02" value="<%=pretaskid%>">
			<span id="taskids02span">
             <%=taskname%>
            </span>
		  </TD>
        </TR><TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>

         <%if(RecordSet.getString("level_n").equals("1")){%>
            <TR>
          <TD>里程碑任务</TD>
          <TD class=Field>
          <INPUT type=checkbox name="islandmark" value=1  <%if(RecordSet.getString("islandmark").equals("1")){%> checked <%}%> ></TD>
        </TR><TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
    <%}%>
	  </TABLE>
	</TD>
	<TD></TD>
	<TD vAlign=top>
	 <TABLE class=viewform>
      <COLGROUP>
  	  <COL width="100%">
         <TR>
           <TD >任务说明</TD>
		 </TR>
		 <TR>
           <TD class=Field><TEXTAREA class=inputstyle name="content" ROWS=8 STYLE="width:100%"><%=RecordSet.getString("content")%></TEXTAREA></TD>
         </TR>
     </TABLE>
	</TD>
   </TR>
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
</table>

</FORM>
<script>

function onShowHrmid(){
	var results = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/proj/process/ResourceBrowser_proj.jsp?ProjID=<%=ProjID%>")
	if (results) {
	if (results.id!="") {
		$G("Hrmidspan").innerHTML = "<A href='/hrm/resource/HrmResource.jsp?id="+results.id+"'>"+results.name+"</A>"
		$G("hrmid").value=results.id;
	}else{
		$G("Hrmidspan").innerHTML = "";
		$G("hrmid").value="";
	}
	}
}


</script>


</BODY>
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</HTML>
<%}%>
<%@include file="/hrm/include.jsp"%>

<script type="text/javascript">

function onShowMTask(spanname,inputename,prj,task){
        ProjID = $("input[name="+prj+"]").val();
        taskrecordid = $("input[name="+task+"]").val();
		taskids = $("input[name="+inputename+"]").val();
		data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/proj/process/SingleTaskBrowser.jsp?taskids="+taskids+"&ProjID="+ProjID+"&taskrecordid="+taskrecordid);
        if (data){
				if(data.id){
					task_ids = data.id.split(",");
					taskname = data.name.split(",");
					sHtml="";
					for(var i=0;i<task_ids.length;i++){
						if(task_ids){
							sHtml = sHtml+"<a href=/proj/process/ViewTask.jsp?taskrecordid="+task_ids[i]+">"+taskname[i]+"</a>&nbsp";
						}
					}
					$("#"+spanname).html( sHtml);
					$("input[name="+inputename+"]").val(data.id);
				}else{
					$("#"+spanname).html( "");
					$("input[name="+inputename+"]").val("");
				}
	}
}

function submitData()
{
	if (check_form(weaver,'subject')&&checkDateRange(weaver.begindate,weaver.enddate,"<%=SystemEnv.getHtmlLabelName(16722,user.getLanguage())%>"))
		weaver.submit();
}
</script>