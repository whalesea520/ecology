
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util,weaver.conn.RecordSet" %>
<%@ page import="weaver.docs.category.security.AclManager " %>
<%@ page import="java.net.*" %>
<%@ page import="org.jdom.*" %>
<%@ page import="org.jdom.input.*" %>
<jsp:useBean id="RecordSetReqDoc" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetReqWF" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet3" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page" />
<jsp:useBean id="LocationComInfo" class="weaver.hrm.location.LocationComInfo" scope="page" />
<jsp:useBean id="CapitalComInfo" class="weaver.cpt.capital.CapitalComInfo" scope="page"/>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="RecordSetRight" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="AllManagers" class="weaver.hrm.resource.AllManagers" scope="page"/>
<jsp:useBean id="RecordSetV" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetEX" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />
<jsp:useBean id="MainCategoryComInfo" class="weaver.docs.category.MainCategoryComInfo" scope="page" />
<jsp:useBean id="SecCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<jsp:useBean id="docrs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="docrs1" class="weaver.conn.RecordSet" scope="page" />
<%@ include file="/docs/common.jsp" %>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script LANGUAGE="JavaScript" SRC="/js/checkinput_wev8.js"></script>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
</HEAD>
<%
char flag = 2;
String ProcPara = "";
String taskrecordid = Util.null2String(request.getParameter("taskrecordid"));

//td8154 
   //文档部分
  docrs.executeSql("select * from prj_doc t1,docdetail t2  where taskid="+taskrecordid+" and t1.docid=t2.id");
  while(docrs.next()){
    int docedition=docrs.getInt("docedition");
    int doceditionid=docrs.getInt("doceditionid");
    int ishistory=docrs.getInt("ishistory");
    int docid=docrs.getInt("docid");
    if(doceditionid>-1&&ishistory==1){
        docrs1.executeSql(" select id from DocDetail where doceditionid = " + doceditionid + " and (docstatus=1 or docstatus=2) order by docedition desc ");
        while(docrs1.next()){      
            int newDocId = docrs1.getInt("id");
            docrs1.executeSql("update prj_doc set docid="+newDocId+" where docid="+docid);
       }
    }    
  }
  //参考文档部分
  docrs.executeSql("select * from Prj_task_referdoc t1,docdetail t2  where taskid="+taskrecordid+" and t1.docid=t2.id");
  while(docrs.next()){
    int docedition=docrs.getInt("docedition");
    int doceditionid=docrs.getInt("doceditionid");
    int ishistory=docrs.getInt("ishistory");
    int docid=docrs.getInt("docid");
    if(doceditionid>-1&&ishistory==1){
        docrs1.executeSql(" select id from DocDetail where doceditionid = " + doceditionid + " and (docstatus=1 or docstatus=2) order by docedition desc ");
        while(docrs1.next()){      
            int newDocId = docrs1.getInt("id");
            docrs1.executeSql("update Prj_task_referdoc set docid="+newDocId+" where docid="+docid);
       }
    }    
  }


RecordSet.executeProc("Prj_TaskProcess_SelectByID",taskrecordid);
RecordSet.next();
String ProjID = RecordSet.getString("prjid");

//==============================================================================================
//TD4080
//added by hubo,2006-04-12
int relatedRequestId = Util.getIntValue(request.getParameter("requestid"),-1);
if(relatedRequestId!=-1){
	response.sendRedirect("/proj/process/RequestOperation.jsp?method=add&type=2&ProjID="+ProjID+"&taskid="+taskrecordid+"&requestid="+relatedRequestId+"");
}
int relatedDocId = Util.getIntValue(request.getParameter("docid"),-1);
if(relatedDocId!=-1){
	response.sendRedirect("/proj/process/DocOperation.jsp?method=add&type=2&ProjID="+ProjID+"&taskid="+taskrecordid+"&docid="+relatedDocId+"");
}
//==============================================================================================

/*ADD BY CHaroes Huang On May 26,2004*/
    RecordSet rs = new RecordSet();
    String status_prj="" ;
    String sql_prjstatus="select status from Prj_ProjectInfo where id = "+ProjID;
    rs.executeSql(sql_prjstatus);
    if(rs.next())
    status_prj=rs.getString("status");

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

if(!canview){
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
/*权限－end*/

%>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(367,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(1332,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>




<%if((canedit || isResponser) && !status_prj.equals("6") ){%>

<FORM id=delplan name=delplan action="/proj/plan/TaskOperation.jsp" method=post>
<input type="hidden" name="taskrecordid" value="<%=taskrecordid%>">
<input type="hidden" name="ProjID" value="<%=RecordSet.getString("prjid")%>">
<input type="hidden" name="parentids" value="<%=RecordSet.getString("parentids")%>">
<input type="hidden" name="method" value="del">
</form>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+",/proj/plan/EditTask.jsp?taskrecordid="+taskrecordid+",_self} " ;
RCMenuHeight += RCMenuHeightStep;

RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:doDeletePlan();,_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%}%>
<%

//RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/proj/data/ViewProject.jsp?ProjID="+RecordSet.getString("prjid")+",_self} " ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:history.go(-1);,_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
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
          <TD class=Field><%=RecordSet.getString("subject")%></TD>
         </TR>
		 <TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
           <TR>
          <TD><%=SystemEnv.getHtmlLabelName(2097,user.getLanguage())%></TD>
          <TD class=Field>
				<%if(user.getLogintype().equals("1")){%><a href="/hrm/resource/HrmResource.jsp?id=<%=RecordSet.getString("hrmid")%>"><%}%><%=Util.toScreen(ResourceComInfo.getResourcename(RecordSet.getString("hrmid")),user.getLanguage())%><%if(user.getLogintype().equals("1")){%></a><%}%>
        </TR>
         <TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
        <TR>
        <TD><%=SystemEnv.getHtmlLabelName(1322,user.getLanguage())%></TD>
          <TD class=Field>
		  <%if(!RecordSet.getString("begindate").equals("x")){%>
				<%=RecordSet.getString("begindate")%>
          <%}%>
          </TD>
        </TR><TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
        <TR>
        <TD><%=SystemEnv.getHtmlLabelName(1323,user.getLanguage())%></TD>
          <TD class=Field>
		  <%if(!RecordSet.getString("enddate").equals("-")){%>
				<%=RecordSet.getString("enddate")%>
		  <%}%>
          </TD>
         </TR><TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>

         <TR>
         <TD><%=SystemEnv.getHtmlLabelName(1324,user.getLanguage())%></TD>
          <TD class=Field><%=RecordSet.getString("workday")%></TD>
         </TR><TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
<%if(!user.getLogintype().equals("2")){%>
         <TR>
         <TD><%=SystemEnv.getHtmlLabelName(101,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(386,user.getLanguage())%></TD>
          <TD class=Field><%=RecordSet.getString("fixedcost")%> </TD>
         </TR><TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
<%}%>
        <TR>
        <%
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
        String pretaskid=RecordSet.getString("prefinish");
        String taskname="";
        if(!pretaskid.equals("")){
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
	            	taskname += "<a href=/proj/plan/ViewTask.jsp?taskrecordid="+RecordSet3.getInt("id")+">"+ RecordSet3.getString("subject")+ "</a>" +" ";
					//==============================================================================================
	            }
            }
        }
        %>
            <TD><%=SystemEnv.getHtmlLabelName(2233,user.getLanguage())%></TD>
            <%if(pretaskid.equals("")){%> <TD class=Field></TD>
            <%}else{%>
             <TD class=Field><%=taskname%></TD>
            <%}%>
        </TR><TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
         <TR>
          <TD><%=SystemEnv.getHtmlLabelName(2232,user.getLanguage())%></TD>
          <TD class=Field>
          <INPUT type=checkbox name="islandmark" value=1  <%if(RecordSet.getString("islandmark").equals("1")){%> checked <%}%> disabled></TD>
        </TR><TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
         <TR>
           <TD ><%=SystemEnv.getHtmlLabelName(2240,user.getLanguage())%></TD>
           <TD class=Field><%=Util.toHtml(RecordSet.getString("content"))%></TD>
         </TR><TR style="height:1px;"><TD class=Line1 colSpan=2></TD></TR>
     </TABLE>
	</TD>
	<TD></TD>
	<TD vAlign=top  style="word-break: break-all;"  >


	<FORM id=Exchange name=Exchange action="/discuss/ExchangeOperation.jsp" method=post>
	 <input type="hidden" name="method1" value="add">
     <input type="hidden" name="types" value="PT">
     <input type="hidden" name="sign" value="plan">
	 <input type="hidden" name="sortid" value="<%=taskrecordid%>">
   <TABLE class=liststyle cellspacing=1  cellpadding=1  >
      <TR class=header>
       <TH ><%=SystemEnv.getHtmlLabelName(15153,user.getLanguage())%></TH>
       <Td align=right >
	   <%
        //RCMenu += "{-}";
        //RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self}";
        //RCMenuHeight += RCMenuHeightStep;
	   %>
        <a href="javascript:if(check_form(Exchange,'ExchangeInfo')){Exchange.submit();}">
		<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%></a>&nbsp&nbsp
      </Td>
      </TR>
	   <TR class=line  style="height:1px;">
    	  <TD  colSpan="2" style="padding:0;"></TD>
	   </TR>

	   <TR >
    	  <TD class=Field colSpan="2">
		  <TEXTAREA class=inputstyle NAME=ExchangeInfo ROWS=3 STYLE="width:96%" onchange='checkinput("ExchangeInfo","ExchangeInfospan")'></TEXTAREA>
		 		<span id=ExchangeInfospan name=ExchangeInfospan >
 			  <IMG src='/images/BacoError_wev8.gif' align=absMiddle>
 			  </span>
		 </TD>
	   </TR>
 <tr class="Header"><TD><%=SystemEnv.getHtmlLabelName(857,user.getLanguage())%></TD>
          <TD>
			<input type=hidden name="docids" class="wuiBrowser" value="" 
				_param="documentids"
				_url="/docs/DocBrowserMain.jsp?url=/docs/docs/MutiDocBrowser.jsp">
		  </TD>

        </TR>
	 </TABLE>
	</FORM>

  <TABLE class=liststyle cellspacing=1 >
        <COLGROUP>
		<COL width="20%">
  		<COL width="30%">
  		<COL width="40%">
        <TBODY>
	    <TR class=Header>
	      <th><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%></th>
	      <th><%=SystemEnv.getHtmlLabelName(277,user.getLanguage())%></th>
	      <th><%=SystemEnv.getHtmlLabelName(616,user.getLanguage())%></th>

	    </TR>   <TR class=line  style="height:1px;">
    	  <TD  colSpan="3" style="padding:0;"></TD>
	   </TR>
<%
boolean isLight = false;
char flag0=2;
int nLogCount=0;
RecordSetEX.executeProc("ExchangeInfo_SelectBID",taskrecordid+flag0+"PT");
while(RecordSetEX.next())
{
nLogCount++;
if (nLogCount==2) {
%>
</tbody></table>
<div  id=WorkFlowDiv style="display:none">
    <table class=liststyle cellspacing=1 >
           <COLGROUP>
		<COL width="20%">
  		<COL width="30%">
  		<COL width="40%">
    <tbody>
<%}
		if(isLight)
		{%>
	<TR CLASS=DataLight>
<%		}else{%>
	<TR CLASS=DataDark>
<%		}%>
          <TD><%=RecordSetEX.getString("createDate")%></TD>
          <TD><%=RecordSetEX.getString("createTime")%></TD>
          <TD>
			<%if(Util.getIntValue(RecordSetEX.getString("creater"))>0){%>
			<a href="/hrm/resource/HrmResource.jsp?id=<%=RecordSetEX.getString("creater")%>"><%=Util.toScreen(ResourceComInfo.getResourcename(RecordSetEX.getString("creater")),user.getLanguage())%></a>
			<%}else{%>
			<A href="javascript:openFullWindowForXtable('/CRM/data/ViewCustomer.jsp?CustomerID=<%=RecordSetEX.getString("creater").substring(1)%>')"><%=CustomerInfoComInfo.getCustomerInfoname(""+RecordSetEX.getString("creater").substring(1))%></a>
			<%}%>
		  </TD>

        </TR>
<%		if(isLight)
		{%>
	<TR CLASS=DataLight>
<%		}else{%>
	<TR CLASS=DataDark>
<%		}%>
          <TD colSpan=4><%=Util.toHtml(RecordSetEX.getString("remark"))%></TD>
        </TR>
<%		if(isLight)
		{%>
	<TR CLASS=DataLight>
<%		}else{%>
	<TR CLASS=DataDark>
<%		}%>
<%
        String docids_0=  Util.null2String(RecordSetEX.getString("docids"));
        String docsname="";
        if(!docids_0.equals("")){

            ArrayList docs_muti = Util.TokenizerString(docids_0,",");
            int docsnum = docs_muti.size();

            for(int i=0;i<docsnum;i++){
                docsname= docsname+"<a href=javascript:openFullWindowForXtable('/docs/docs/DocDsp.jsp?id="+docs_muti.get(i)+"')>"+Util.toScreen(DocComInfo.getDocname(""+docs_muti.get(i)),user.getLanguage())+"</a><br>" +" ";
            }
        }

 %>
    <td ><%=SystemEnv.getHtmlLabelName(857,user.getLanguage())%>: </td> <td  colSpan=2> <%=docsname%></td>
         </TR>
<%
	isLight = !isLight;
}
%>	  </TBODY>
	  </TABLE>
<% if (nLogCount>=2) { %> </div> <%}%>
        <table class=liststyle cellspacing=1 >
        <COLGROUP>
		<COL width="30%">
  		<COL width="30%">
  		<COL width="40%">
          <tbody>
          <tr>
            <td> </td>
            <td> </td>
            <% if (nLogCount>=2) { %>
            <td align=right><SPAN id=WorkFlowspan><a href='/discuss/ViewExchange.jsp?types=PT&sortid=<%=taskrecordid%>&types_prj=1' ><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></a></span></td>
            <%}%>
          </tr>
         </tbody>
        </table>


	</TD>
   </TR>
   </TBODY>
</TABLE>



<%
String sql = "";
%>

<!--RequiredWF Begin-->
<%
sql="SELECT a.id, a.workflowname, b.isNecessary, b.isTempletTask FROM workflow_base a, Prj_task_needwf b WHERE b.taskId="+Integer.parseInt(taskrecordid)+" AND a.id=b.workflowid";
RecordSet.executeSql(sql);
%>
<TABLE class=liststyle cellspacing=1 id="tblRequiredWF">
<TBODY>
	<TR class=header>
		<TH colSpan=2><%=SystemEnv.getHtmlLabelName(17905,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(259,user.getLanguage())%></TH>		<!--TODO:Label-->
		<th style="width:100px;text-align:right"><%if(ismanager){%><a href="javascript:onShowWorkflow()"><%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></a><%}%></th>
	</TR>
   <TR class=Header>
      <th><%=SystemEnv.getHtmlLabelName(2079,user.getLanguage())%></th>
	   <th style="width:80px"><%=SystemEnv.getHtmlLabelName(17906,user.getLanguage())%></th>																			
	   <th><%=SystemEnv.getHtmlLabelName(104,user.getLanguage())%></th>
	</TR>
	<TR class=line><TD colSpan=3></TD></TR>
<%
int reqWFId = 0;
String reqWFName="";
String reqWFIsNecessary="";
String reqWFIsTemplet = "";
int requiredWFCount = 0;

String CurrentUser = ""+user.getUID();
int usertype = 0;
if(logintype.equals("2"))
	usertype= 1;
while(RecordSet.next()){
	reqWFId = RecordSet.getInt("id");
	reqWFName = RecordSet.getString("workflowname");
	reqWFIsNecessary = RecordSet.getString("isNecessary");
	reqWFIsTemplet = RecordSet.getString("isTempletTask");
%>
	<tr class=datadark>
      <td><a href="/workflow/request/AddRequest.jsp?workflowid=<%=reqWFId%>&prjid=<%=ProjID%>&topage=/proj/plan/ViewTask.jsp?taskrecordid=<%=taskrecordid%>"><%=Util.toScreen(reqWFName,user.getLanguage())%></a><%
			/* the count of required workflow that has been added */
sql="select count(distinct t1.requestid) as requiredWFCount from workflow_requestbase t1,workflow_currentoperator t2, Prj_Request t3 ";
String sqlwhere=" where t1.requestid = t2.requestid and t2.userid = "+CurrentUser+" and t2.usertype=" + usertype + " and t1.requestid = t3.requestid  and t3.prjid = "+ProjID+" and t3.taskid = "+taskrecordid+" AND t3.workflowid="+reqWFId;	
sql=sql+sqlwhere;
			RecordSetReqWF.executeSql(sql);
			if(RecordSetReqWF.next())
				requiredWFCount = RecordSetReqWF.getInt("requiredWFCount");
			%></a> 
			(<%=requiredWFCount%>)
			<%if(requiredWFCount==0 && reqWFIsNecessary.equals("1"))	out.println("<img src='/images/BacoError_wev8.gif' align='absmiddle'>");%></td>
      <td>
			<input 
				type="checkbox" 
				name="requiredWF<%=reqWFId%>"
				value="<%=reqWFId%>"
				<%
				if(reqWFIsNecessary.equals("1")) out.println("checked");
				if(!ismanager) out.println("disabled");
				%>
				onclick="javascript:modifyRequiredWFNecessary()"
			>
		</td>
      <TD>
			<%if(ismanager){%>
			<a href="/proj/plan/TaskRelatedOperation.jsp?method=delRequiredWF&ProjID=<%=ProjID%>&taskID=<%=taskrecordid%>&requiredWFID=<%=reqWFId%>"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a>
			<input type="checkbox" name="requiredWFIDs" value="<%=reqWFId%>" style="visibility:hidden" checked>
			<%}%>
		</TD>
   </tr>
<%}%>
</TBODY>
</TABLE>
<!--RequiredWF End-->

<%
String topage=URLEncoder.encode( "/proj/process/RequestOperation.jsp?method=add&ProjID="+ProjID+"&type=1&taskid="+taskrecordid);
%>
<a name="anchor_wf">
      <TABLE class=liststyle cellspacing=1 >
	<form name=workflow method=get action="/workflow/request/RequestType.jsp">
	<input type=hidden name=topage value='<%=topage%>'>
	<input type=hidden name=prjid value='<%=ProjID%>'>
	</form>
        <TBODY>
        <TR class=header>
          <TH colSpan=4><%=SystemEnv.getHtmlLabelName(259,user.getLanguage())%></TH>
          <TD align=right colSpan=2>
          <%if(canedit || isResponser){%>
		  <A href="javascript:onShowRequest();"><%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></A>
		  <A href="javascript:document.workflow.submit();"><%=SystemEnv.getHtmlLabelName(365,user.getLanguage())%></A>
          <%}%>
		  </TD></TR>

        <TR class=Header>
          <th><%=SystemEnv.getHtmlLabelName(722,user.getLanguage())%></th>
		  <th><%=SystemEnv.getHtmlLabelName(882,user.getLanguage())%></th>
		  <th><%=SystemEnv.getHtmlLabelName(259,user.getLanguage())%></th>
		  <th><%=SystemEnv.getHtmlLabelName(1334,user.getLanguage())%></th>
		  <th><%=SystemEnv.getHtmlLabelName(1335,user.getLanguage())%></th>
		  <TD width=49><%=SystemEnv.getHtmlLabelName(104,user.getLanguage())%></TD>
		</TR>

<%
sql="select distinct t1.requestid, t1.createdate, t1.creater,t1.creatertype, t1.workflowid, t1.requestname, t1.status, t3.id as recorderid from workflow_requestbase t1,workflow_currentoperator t2, Prj_Request t3 ";
String sqlwhere=" where t1.requestid = t2.requestid and t2.userid = "+CurrentUser+" and t2.usertype=" + usertype + " and t1.requestid = t3.requestid  and t3.prjid = "+ProjID+" and t3.taskid = "+taskrecordid+" ";
String orderby=" order by t1.createdate desc ";
sql=sql+sqlwhere+orderby;
RecordSet.executeSql(sql);
while(RecordSet.next())
{
	String requestid=RecordSet.getString("requestid");
	String createdate=RecordSet.getString("createdate");
	String creater=RecordSet.getString("creater");
	String creatertype=RecordSet.getString("creatertype");
	String creatername=ResourceComInfo.getResourcename(creater);
	String workflowid=RecordSet.getString("workflowid");
	String workflowname=WorkflowComInfo.getWorkflowname(workflowid);
	String requestname=RecordSet.getString("requestname");
	String status=RecordSet.getString("status");
%>
    <tr class=datadark>
      <td><%=Util.toScreen(createdate,user.getLanguage())%></td>
      <td>
      <%if(creatertype.equals("0")){%>
      <%if(user.getLogintype().equals("1")){%><a href="/hrm/resource/HrmResource.jsp?id=<%=creater%>"><%}%><%=Util.toScreen(creatername,user.getLanguage())%><%if(user.getLogintype().equals("1")){%></a><%}%>
      <%}else if(creatertype.equals("1")){%>
      <a href="javascript:openFullWindowForXtable('/CRM/data/ViewCustomer.jsp?CustomerID=<%=creater%>')"><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(creater),user.getLanguage())%></a>
      <%}else{%>
      <%=SystemEnv.getHtmlLabelName(468,user.getLanguage())%>
      <%}%>
      </td>
	  <td><%=Util.toScreen(workflowname,user.getLanguage())%></td>
      <td><a href="javascript:openFullWindowForXtable('/workflow/request/ViewRequest.jsp?requestid=<%=requestid%>')"><%=Util.toScreen(requestname,user.getLanguage())%></a></td>
      <td><%=Util.toScreen(status,user.getLanguage())%></td>
      <TD nowrap>
		  <%if(canedit || isResponser || ( creater.equals(""+user.getUID()) && ((creatertype.equals("0") && user.getLogintype().equals("1")) || (creatertype.equals("1") && user.getLogintype().equals("2")) ) )){%>
		  <a href="/proj/process/RequestOperation.jsp?method=del&ProjID=<%=ProjID%>&type=1&taskid=<%=taskrecordid%>&id=<%=RecordSet.getString("recorderid")%>"  onclick="return isdel()"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a>
		  <%}%>
	  </TD>
       </tr>       <TR class=line>
          <TD colSpan=6></TD></TR>

<%}%>
		</TBODY>
	</TABLE>



<!--RequiredDocs Begin-->
<%
sql="SELECT docMainCategory,docSubCategory,docSecCategory,isNecessary,isTempletTask FROM Prj_task_needdoc WHERE taskId="+Integer.parseInt(taskrecordid);
RecordSet.executeSql(sql);
%>
<TABLE class=liststyle cellspacing=1 >
<TBODY>
	<TR class=header>
		<TH colSpan=2><%=SystemEnv.getHtmlLabelName(17905,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%></TH>		<!--TODO:Label-->
		<th style="width:100px;text-align:right">
			<%if(ismanager){%><a href="javascript:onSelectCategory()"><%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></a><%}%>
		</th>
	</TR>
   <TR class=Header>
      <th><%=SystemEnv.getHtmlLabelName(16398,user.getLanguage())%></th>
	   <th style="width:80px"><%=SystemEnv.getHtmlLabelName(17906,user.getLanguage())%></th>
		<td><%=SystemEnv.getHtmlLabelName(104,user.getLanguage())%></td>
	</TR>
	<TR class=line><TD colSpan=3></TD></TR>
<%
String reqDocMainCategory="";
String reqDocSubCategory="";
String reqDocSecCategory = "";
String reqIsNecessary = "";
String reqIsTempletTask = "";
int requiredDocCount = 0;
while(RecordSet.next()){
	reqDocMainCategory = RecordSet.getString("docMainCategory");
	reqDocSubCategory = RecordSet.getString("docSubCategory");
	reqDocSecCategory = RecordSet.getString("docSecCategory");
	reqIsNecessary = RecordSet.getString("isNecessary");
	reqIsTempletTask = RecordSet.getString("isTempletTask");
%>
	<tr class=datadark>
      <td>
			<a href="javascript:openFullWindowHaveBar('/docs/docs/DocAdd.jsp?prjid=<%=ProjID%>&mainid=<%=reqDocMainCategory%>&subid=<%=reqDocSubCategory%>&secid=<%=reqDocSecCategory%>&topage=/proj/plan/ViewTask.jsp?taskrecordid=<%=taskrecordid%>')"><%=Util.toScreen(MainCategoryComInfo.getMainCategoryname(reqDocMainCategory),user.getLanguage())%>/<%=Util.toScreen(SubCategoryComInfo.getSubCategoryname(reqDocSubCategory),user.getLanguage())%>/<%=Util.toScreen(SecCategoryComInfo.getSecCategoryname(reqDocSecCategory),user.getLanguage())%><%
			/* the count of required document that has been added */
			
sql="SELECT COUNT(*) AS requiredDocCount FROM DocDetail  t1, "+tables+" t2, Prj_Doc t3 ";
sqlwhere=" where t1.id = t2.sourceid  and t1.id = t3.docid  and t3.prjid = "+ProjID+" and t3.taskid = "+taskrecordid+" AND t3.secid="+Util.getIntValue(reqDocSecCategory);	
//sqlwhere += " and ( t1.doccreaterid="+user.getUID()+" or t1.docstatus=1 or t1.docstatus=2 )";
sql=sql+sqlwhere;
			RecordSetReqDoc.executeSql(sql);
			if(RecordSetReqDoc.next())
				requiredDocCount = RecordSetReqDoc.getInt("requiredDocCount");
			%></a> 
			(<%=requiredDocCount%>)
			<%if(requiredDocCount==0 && reqIsNecessary.equals("1"))	out.println("<img src='/images/BacoError_wev8.gif' align='absmiddle'>");%>
		</td>
      <td>
			<input 
				type="checkbox" 
				name="requiredDoc<%=reqDocSecCategory%>"
				value="<%=reqDocSecCategory%>"
				<%
				if(reqIsNecessary.equals("1")) out.println("checked");
				if(!ismanager) out.println("disabled");
				%> 
				onclick="javascript:modifyRequiredDocNecessary()"
			>
		</td>
		<td>
			<%if(ismanager){%>
			<a href="/proj/plan/TaskRelatedOperation.jsp?method=delRequiredDoc&ProjID=<%=ProjID%>&taskID=<%=taskrecordid%>&secID=<%=reqDocSecCategory%>"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a>
			<%}%>
		</td>
   </tr>
<%}%>
</TBODY>
</TABLE>
<!--RequiredDocs End  -->
<!--ReferencedDocs Begin-->
<%
sql="SELECT a.id, a.docsubject, a.ownerid, a.usertype, a.doccreatedate, a.doccreatetime FROM DocDetail a, Prj_task_referdoc b, "+tables+" t2 WHERE b.taskId="+Integer.parseInt(taskrecordid)+" AND a.id=b.docid and a.id=t2.sourceid";
RecordSet.executeSql(sql);
%>
<TABLE class=liststyle cellspacing=1 >
<TBODY>
	<TR class=header>
		<TH colSpan=3><%=SystemEnv.getHtmlLabelName(191,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%></TH>
		<th style="width:100px;text-align:right"><%if(ismanager){%><a href="javascript:onShowMultiDocsRow()"><%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></a><%}%></th>
	</TR>
   <TR class=Header>
      <th><%=SystemEnv.getHtmlLabelName(1339,user.getLanguage())%></th>
	   <th><%=SystemEnv.getHtmlLabelName(1340,user.getLanguage())%></th>
	   <th><%=SystemEnv.getHtmlLabelName(1341,user.getLanguage())%></th>
		<th><%=SystemEnv.getHtmlLabelName(104,user.getLanguage())%></th>
	</TR>
	<TR class=line><TD colSpan=4></TD></TR>
<%
int refDocId = 0;
String refDocCreateDate="";
String refDocCreateTime="";
String refDocName="";
String refOwnerType = "";
String refOwnerID = "";
while(RecordSet.next()){
	refDocId = RecordSet.getInt("id");
	refDocCreateDate = RecordSet.getString("doccreatedate");
	refDocCreateTime = RecordSet.getString("doccreatetime");
	refDocName = RecordSet.getString("docsubject");
	refOwnerType = RecordSet.getString("usertype");
	refOwnerID = RecordSet.getString("ownerid");
%>
	<tr class=datadark>
      <td style="width:220px"><%=Util.toScreen(refDocCreateDate,user.getLanguage())%> <%=Util.toScreen(refDocCreateTime,user.getLanguage())%></td>
      <td style="width:80px">
			<%if(refOwnerType.equals("1")){%>
				<a href="/hrm/resource/HrmResource.jsp?id=<%=refOwnerID%>"><%=Util.toScreen(ResourceComInfo.getResourcename(refOwnerID),user.getLanguage())%></a>
			<%}else if(refOwnerType.equals("2")){%>
				<a href="javascript:openFullWindowForXtable('/CRM/data/ViewCustomer.jsp?CustomerID=<%=refOwnerID%>')"><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(refOwnerID),user.getLanguage())%></a>
			<%}%>
		</td>
      <td><a href="javascript:openFullWindowForXtable('/docs/docs/DocDsp.jsp?id=<%=refDocId%>')"><%=Util.toScreen(refDocName,user.getLanguage())%></a></td>
      <td>
		<%if(ismanager){%>
		<a href="/proj/plan/TaskRelatedOperation.jsp?method=delReferencedDoc&ProjID=<%=ProjID%>&taskID=<%=taskrecordid%>&docID=<%=refDocId%>"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a>
		<%}%></td>
   </tr>
<%}%>
</TBODY>
</TABLE>
<!--ReferencedDocs End-->
<%
topage=URLEncoder.encode( "/proj/process/DocOperation.jsp?method=add&ProjID="+ProjID+"&type=1&taskid="+taskrecordid);
%>
<a name="anchor_doc">
      <TABLE class=liststyle cellspacing=1 >
	<form name=doc method=post action="/docs/docs/DocList.jsp">
	<input type=hidden name=topage value='<%=topage%>'>
    <input type=hidden name=isOpenNewWind value='1'>
	<input type=hidden name=prjid value='<%=ProjID%>'>
	</form>
        <TBODY>
        <TR class=header>
          <TH colSpan=2><%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%></TH>
          <TD align=right colSpan=2>
          <%if(canedit || isResponser){%>
  		  <A href="javascript:onShowDoc();"><%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></A>

		  <A href="javascript:document.doc.submit();"><%=SystemEnv.getHtmlLabelName(365,user.getLanguage())%></A>
              <% } %>
		  </TD></TR>

        <TR class=Header>
          <th><%=SystemEnv.getHtmlLabelName(1339,user.getLanguage())%></th>
		  <th><%=SystemEnv.getHtmlLabelName(1340,user.getLanguage())%></th>
		  <th><%=SystemEnv.getHtmlLabelName(1341,user.getLanguage())%></th>
		  <TD width=49><%=SystemEnv.getHtmlLabelName(104,user.getLanguage())%></TD>

		</TR>      <TR class=line>
          <TD colSpan=4></TD></TR>

<%

sql="SELECT distinct t1.id, t1.docsubject, t1.ownerid, t1.usertype, t1.doccreatedate, t1.doccreatetime, t3.id as recorderid FROM DocDetail  t1, "+tables+" t2, Prj_Doc t3 ";
sqlwhere=" where t1.docstatus in ('1','2','5') and t1.id = t2.sourceid  and t1.id = t3.docid  and t3.prjid = "+ProjID+" and t3.taskid = "+taskrecordid+" " ;
sqlwhere += " and ( t1.doccreaterid="+user.getUID()+" or t1.docstatus=1 or t1.docstatus=2 )";
orderby=" ORDER BY t1.id DESC ";
//out.print(sql);
sql=sql+sqlwhere+orderby;
RecordSet.executeSql(sql);
while(RecordSet.next())
{
	String id=RecordSet.getString("id");
	String createdate=RecordSet.getString("doccreatedate");
	String createtime=RecordSet.getString("doccreatetime");
	String ownerid=RecordSet.getString("ownerid");
	String ownertype=RecordSet.getString("usertype");
	String docsubject=RecordSet.getString("docsubject");
%>
    <tr class=datadark>
      <td><%=Util.toScreen(createdate,user.getLanguage())%>&nbsp<%=Util.toScreen(createtime,user.getLanguage())%></td>
      <td>
      <%if(ownertype.equals("1")){%>
      <%if(user.getLogintype().equals("1")){%><a href="/hrm/resource/HrmResource.jsp?id=<%=ownerid%>"><%}%><%=Util.toScreen(ResourceComInfo.getResourcename(ownerid),user.getLanguage())%><%if(user.getLogintype().equals("1")){%></a><%}%>
      <%}else if(ownertype.equals("2")){%>
      <a href="javascript:openFullWindowForXtable('/CRM/data/ViewCustomer.jsp?CustomerID=<%=ownerid%>')"><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(ownerid),user.getLanguage())%></a>
      <%}%>
      </td>
      <td><a href="javascript:openFullWindowForXtable('/docs/docs/DocDsp.jsp?id=<%=id%>')"><%=Util.toScreen(docsubject,user.getLanguage())%></a></td>
      <TD nowrap>
		  <%if(canedit || isResponser || ( ownerid.equals(""+user.getUID()) && ownertype.equals(""+user.getLogintype()) )){%>
		  <a href="/proj/process/DocOperation.jsp?method=del&ProjID=<%=ProjID%>&type=1&taskid=<%=taskrecordid%>&id=<%=RecordSet.getString("recorderid")%>"  onclick="return isdel()"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a>
		  <%}%>
	  </TD>
       </tr>

<%}%>
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
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<script language=vbs>









sub onShowMDoc(inputname,spanname)
	tmpids = document.all(inputname).value
		id1 = window.showModalDialog("/docs/DocBrowserMain.jsp?url=/docs/docs/MutiDocBrowser.jsp?documentids="&tmpids)
	if (Not IsEmpty(id1)) then
			if id1(0)<> "" then
				tempdocids = id1(0)
				tempdocnames = id1(1)
				sHtml = ""
				tempdocids = Mid(tempdocids,2,len(tempdocids))
				document.all(inputname).value = tempdocids
				tempdocnames = Mid(tempdocnames,2,len(tempdocnames))
				while InStr(tempdocids,",") <> 0
					curid = Mid(tempdocids,1,InStr(tempdocids,",")-1)
					curname = Mid(tempdocnames,1,InStr(tempdocnames,",")-1)
					tempdocids = Mid(tempdocids,InStr(tempdocids,",")+1,Len(tempdocids))
					tempdocnames = Mid(tempdocnames,InStr(tempdocnames,",")+1,Len(tempdocnames))
					sHtml = sHtml&"<a href=javascript:openFullWindowForXtable('/docs/docs/DocDsp.jsp?id="&curid&"')>"&curname&"</a>&nbsp"
				wend
				sHtml = sHtml&"<a href=javascript:openFullWindowForXtable('/docs/docs/DocDsp.jsp?id="&tempdocids&"')>"&tempdocnames&"</a>&nbsp"
				document.all(spanname).innerHtml = sHtml
			else
				document.all(spanname).innerHtml =""
				document.all(inputname).value=""
			end if
	end if
end sub
</script>

<script language=javascript>

function onShowDoc(){
	datas = window.showModalDialog("/docs/DocBrowserMain.jsp?url=/proj/process/DocBrowser.jsp");
	if (datas&&datas.id){
		window.location = "/proj/process/DocOperation.jsp?method=add&ProjID=<%=ProjID%>&type=1&taskid=<%=taskrecordid%>&docid="+datas.id;
	}
}

function onShowWorkflow(){
	var  wfIDs = $("input[name=requiredWFIDs]");
	var tmpIds="";
	if (wfIDs.length>0 ){
		for (var i=0 ;i< wfIDs.length;i++){
			tmpIds = tmpIds + wfIDs[i].value + ","
		}
		
		tmpIds = tmpIds.substr(1);
	}

	tmpIds2 = "," + tmpIds + ",";
	
	var  oTbl = document.getElementById("tblRequiredWF")
	var  rows = oTbl.rows;
	
	datas = window.showModalDialog("/workflow/WFBrowserMain.jsp?url=/workflow/workflow/WorkflowMutiBrowser.jsp?wfids="+tmpIds);
	if (datas){
		if(datas.id!=""&&datas.id!="0"){
			window.location = "/proj/plan/TaskRelatedOperation.jsp?method=addRequiredWF&ProjID=<%=ProjID%>&taskID=<%=taskrecordid%>&wfIDs="+datas.id;
		}
	}
}
function onShowRequest(){
	datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/workflow/request/RequestBrowser.jsp?isrequest=1");
	if (datas){
		if (datas.id!= "" && datas.id!="0"){
			window.location = "/proj/process/RequestOperation.jsp?method=add&ProjID=<%=ProjID%>&type=1&taskid=<%=taskrecordid%>&requestid=" +datas.id;
		}
	}
}
function onShowMultiDocsRow(){
	var refdocs = document.getElementsByName("referdocs");
	var tmpIds="";
	for (i=0 ;i< refdocs.length;i++){
		tmpIds = tmpIds + refdocs[i].value + ",";
	}
	tmpIds = tmpIds.substr(1);
	datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/docs/MutiDocBrowser.jsp?documentids="+tmpIds)
	if(datas.id!=""){
		window.location = "/proj/plan/TaskRelatedOperation.jsp?method=addReferencedDoc&ProjID=<%=ProjID%>&taskID=<%=taskrecordid%>&docIDs="+datas.id;
	}
}

function displaydiv_1()
	{
		if(WorkFlowDiv.style.display == ""){
			WorkFlowDiv.style.display = "none";
			WorkFlowspan.innerHTML = "<a href='#' onClick=displaydiv_1()><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></a>";
		}
		else{
			WorkFlowspan.innerHTML = "<a href='#' onClick=displaydiv_1()><%=SystemEnv.getHtmlLabelName(15154,user.getLanguage())%></a>";
			WorkFlowDiv.style.display = "";
		}
	}
</script>
<script language="javascript">
function submitData()
{
	if (check_form(Exchange,'ExchangeInfo'))
		Exchange.submit();
}


function doDeletePlan(){
    if(confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>")) {
        document.delplan.submit();
    }
}

function onSelectCategory() {
	var oTbl = document.getElementById("tblRequiredDoc");
	/* returnValue = Array(1, id, path, mainid, subid); */
   var datas = showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/category/MultiCategorySingleBrowser.jsp");
	if (datas&&datas.id>0) {
	      window.location = "TaskRelatedOperation.jsp?method=addRequiredDoc&taskID=<%=taskrecordid%>&secID="+datas.id;
	}
}

function modifyRequiredWFNecessary(){
	with(window.event.srcElement){
		checked ? isNecessaryTmp=1 : isNecessaryTmp=0;
		location = "/proj/plan/TaskRelatedOperation.jsp?method=modifyRequiredWFN&taskID=<%=taskrecordid%>&wfID="+value+"&isNecessary="+isNecessaryTmp;
	}
}

function modifyRequiredDocNecessary(){
	with(window.event.srcElement){
		checked ? isNecessaryTmp=1 : isNecessaryTmp=0;
		location = "/proj/plan/TaskRelatedOperation.jsp?method=modifyRequiredDocN&taskID=<%=taskrecordid%>&secID="+value+"&isNecessary="+isNecessaryTmp;
	}
}

function doDeletePlan(){
    if(confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>")) {
        document.delplan.submit();
    }
}
</script>
</BODY>
</HTML>
