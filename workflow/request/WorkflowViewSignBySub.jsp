
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="weaver.systeminfo.SystemEnv" %>
<%@ page import="java.util.Hashtable" %>
<%@ page import="weaver.general.AttachFileUtil" %>
<%@ page import="weaver.general.TimeUtil" %>
<%@ page import="weaver.general.BaseBean" %>
<%@ page import="weaver.file.FileUpload" %>
<jsp:useBean id="FieldInfo" class="weaver.workflow.mode.FieldInfo" scope="page" />
<jsp:useBean id="RecordSetOld" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rssign" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetlog3" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rsCheckUserCreater" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WFUrgerManager" class="weaver.workflow.request.WFUrgerManager" scope="page" />
<jsp:useBean id="WFManager" class="weaver.workflow.workflow.WFManager" scope="page"/>
<jsp:useBean id="WFLinkInfo" class="weaver.workflow.request.WFLinkInfo" scope="page" />
<jsp:useBean id="DocImageManager1" class="weaver.docs.docs.DocImageManager" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="RequestDefaultComInfo" class="weaver.system.RequestDefaultComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfoTemp" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="RequestLogOperateName" class="weaver.workflow.request.RequestLogOperateName" scope="page"/>
<jsp:useBean id="SecCategoryComInfo1" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="docinf" class="weaver.docs.docs.DocComInfo" scope="page" />
<jsp:useBean id="wfrequestcominfo" class="weaver.workflow.workflow.WorkflowRequestComInfo" scope="page" />
<%@ include file="/systeminfo/init_wev8.jsp" %>
 <%
 FileUpload fu = new FileUpload(request);
String f_weaver_belongto_userid=fu.getParameter("f_weaver_belongto_userid");//需要增加的代码
String f_weaver_belongto_usertype=fu.getParameter("f_weaver_belongto_usertype");//需要增加的代码
User user = HrmUserVarify.getUser(request, response, f_weaver_belongto_userid, f_weaver_belongto_usertype) ;//需要增加的代码
int userid=user.getUID();  
int requestid=Util.getIntValue(request.getParameter("requestid"),0);
int workflowid= Util.getIntValue(request.getParameter("workflowid"),0);
String viewLogIds=Util.null2String(request.getParameter("viewLogIds"));
boolean isprint=Util.null2String(request.getParameter("isprint")).equals("true")?true:false;
int nLogCount=Util.getIntValue(request.getParameter("nLogCount"),0);
boolean isOldWf_ = Util.null2String(request.getParameter("isOldWf")).equals("true")?true:false;
int logs_urger=Util.getIntValue((String)session.getAttribute(user.getUID()+"_"+requestid+"urger"),0);
int logs_monitor=Util.getIntValue((String)session.getAttribute(user.getUID()+"_"+requestid+"ismonitor"),0);
int initrequestid = requestid;
ArrayList allrequestid = new ArrayList();
ArrayList allrequestname = new ArrayList();
ArrayList canviewwf = (ArrayList)session.getAttribute("canviewwf");
if(canviewwf == null) canviewwf = new ArrayList();
int mainrequestid = 0;
int mainworkflowid = 0;
String canviewworkflowid = "-1";

rssign.executeSql("select requestname,mainrequestid from workflow_requestbase where requestid = "+ requestid);
if(rssign.next()){
    if(rssign.getInt("mainrequestid") > -1){
      mainrequestid = rssign.getInt("mainrequestid");
      rssign.executeSql("select * from workflow_requestbase where requestid = "+ mainrequestid);
      if(rssign.next()){
          allrequestid.add(mainrequestid + ".main");
          allrequestname.add(rssign.getString("requestname"));
      }
    }
  }

rssign.executeSql("select * from workflow_requestbase where requestid = "+ mainrequestid);
if(rssign.next()){
     mainworkflowid = rssign.getInt("workflowid");
  }

rssign.executeSql("select distinct subworkflowid from Workflow_SubwfSet where mainworkflowid in ("+mainworkflowid+","+workflowid+") and isread = 1 ");
while(rssign.next()){
     canviewworkflowid+=","+rssign.getString("subworkflowid");
  }
/**161014 zzw 添加判断 **/
if(mainrequestid>0&&!"-1".equals(canviewworkflowid)){
rssign.executeSql("select * from workflow_requestbase where mainrequestid = "+ mainrequestid +" and workflowid in ("+canviewworkflowid+")");
while(rssign.next()){
    allrequestid.add(rssign.getString("requestid") + ".parallel");
    allrequestname.add(rssign.getString("requestname"));
    canviewwf.add(rssign.getString("requestid"));
  }
}
if(requestid>0&&!"-1".equals(canviewworkflowid)){
rssign.executeSql("select * from workflow_requestbase where mainrequestid = "+ requestid+" and workflowid in ("+canviewworkflowid+")");
while(rssign.next()){
    allrequestid.add(rssign.getString("requestid") + ".sub");
    allrequestname.add(rssign.getString("requestname"));
    canviewwf.add(rssign.getString("requestid"));
  }
}

int index = allrequestid.indexOf(requestid+".parallel");
if(index>-1){
    allrequestid.remove(index);
    allrequestname.remove(index);
  }

if(mainrequestid > 0){
    rssign.executeSql("select * from Workflow_SubwfSet where mainworkflowid = "+mainworkflowid+" and subworkflowid = "+workflowid+" and isread = 1");
    if(rssign.getCounts()==0){
       allrequestid.remove(0);
       allrequestname.remove(0);
    }
  }

session.setAttribute("canviewwf",canviewwf);

/**流程存为文档是否要签字意见**/
boolean fromworkflowtodoc = Util.null2String((String)session.getAttribute("urlfrom_workflowtodoc_"+requestid)).equals("true");
boolean ReservationSign = false;
RecordSet.executeSql("select * from workflow_base where id = " + workflowid);
if(RecordSet.next()) ReservationSign = (RecordSet.getInt("keepsign")==2);
if(fromworkflowtodoc&&ReservationSign){
	return;
}
/**流程存为文档是否要签字意见**/

boolean isLight = false;

String sqlTemp = "select nodeid from workflow_flownode where workflowid = "+workflowid+" and nodetype = '0'";
RecordSet.executeSql(sqlTemp);
RecordSet.next();
String creatorNodeId = RecordSet.getString("nodeid");
WFManager.setWfid(workflowid);
WFManager.getWfInfo();
String orderbytype = Util.null2String(WFManager.getOrderbytype());
String orderby = "desc";
String imgline="<img src=\"/images/xp/L_wev8.png\">";
if("2".equals(orderbytype)){
	orderby = "asc";
    imgline="<img src=\"/images/xp/L1_wev8.png\">";
}
WFLinkInfo.setRequest(request);
ArrayList log_loglist=WFLinkInfo.getRequestLog(requestid,workflowid,viewLogIds,orderby);

String lineNTdOne="";
String lineNTdTwo="";
int log_branchenodeid=0;
String log_tempvalue="";
%>

<%

  for(int i=0;i<allrequestid.size();i++)
  {
        int languageidfromrequest = user.getLanguage();
        String temp = allrequestid.get(i).toString();
        int tempindex = temp.indexOf(".");
        requestid = Util.getIntValue(temp.substring(0,tempindex),0);
        temp = temp.substring(tempindex);
        String workflow_name = "";
        if(temp.equals(".main")){
            workflow_name = SystemEnv.getHtmlLabelName(21254,languageidfromrequest);
            workflow_name +=" "+allrequestname.get(i).toString();
            workflow_name +=" "+SystemEnv.getHtmlLabelName(504,languageidfromrequest)+":";
        }else if(temp.equals(".sub")){
        	workflow_name = SystemEnv.getHtmlLabelName(19344,languageidfromrequest);
        	workflow_name +=" "+allrequestname.get(i).toString();
            workflow_name +=" "+SystemEnv.getHtmlLabelName(504,languageidfromrequest)+":";
            workflow_name +=" "+"&nbsp;"+"&nbsp;"+"&nbsp;"+"&nbsp;"+"&nbsp;"+"<a href=javaScript:openFullWindowHaveBar('/workflow/request/ViewRequest.jsp?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+"&requestid="+requestid+"&isovertime=0')>"+SystemEnv.getHtmlLabelName(367,languageidfromrequest)+SystemEnv.getHtmlLabelName(19344,languageidfromrequest);
            workflow_name +=" "+allrequestname.get(i).toString()+"</a>";
        }else if(temp.equals(".parallel")){
        	workflow_name = SystemEnv.getHtmlLabelName(21255,languageidfromrequest);
            workflow_name +=" "+allrequestname.get(i).toString();
            workflow_name +=" "+SystemEnv.getHtmlLabelName(504,languageidfromrequest)+":";
            workflow_name +=" "+"&nbsp;"+"&nbsp;"+"&nbsp;"+"&nbsp;"+"&nbsp;"+"<a href=javaScript:openFullWindowHaveBar('/workflow/request/ViewRequest.jsp?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+"&requestid="+requestid+"&isovertime=0')>"+SystemEnv.getHtmlLabelName(367,languageidfromrequest)+SystemEnv.getHtmlLabelName(21255,languageidfromrequest);
            workflow_name +=" "+allrequestname.get(i).toString()+"</a>";
        }

        viewLogIds = "";
        rssign.executeSql("select nodeid from workflow_requestlog where requestid = "+requestid);
        while(rssign.next()){
          viewLogIds += rssign.getString("nodeid")+",";
        }
        viewLogIds +="-1";
        int tempworkflowid=0;
        rssign.executeSql("select * from workflow_requestbase where requestid = "+ requestid);
        if(rssign.next()){
             tempworkflowid = rssign.getInt("workflowid");
          }
        log_loglist=WFLinkInfo.getRequestLog(requestid,tempworkflowid,viewLogIds,orderby);
%>
<div id=WorkFlowDiv style="display:''">
    <table class=liststyle cellspacing=1  >
    	<colgroup>
        <col width="10%"><col width="50%"> <col width="10%">  <col width="30%">
    	<tbody id="WorkFlowDiv_TBL">
          <tr class="header">
             <th colspan = 4><%=workflow_name%></th>
   		    </tr>
			 <col width="10%"><col width="50%"> <col width="10%">  <col width="30%">
          <tbody>
          <tr class=Header>
            <th><%=SystemEnv.getHtmlLabelName(15586,languageidfromrequest)%></th>
            <th><%=SystemEnv.getHtmlLabelName(504,languageidfromrequest)%></th>
            <th><%=SystemEnv.getHtmlLabelName(104,languageidfromrequest)%></th>
            <th><%=SystemEnv.getHtmlLabelName(15525,languageidfromrequest)%></th>
          </tr>

<%

for(int j=0;j<log_loglist.size();j++)
{
    Hashtable htlog=(Hashtable)log_loglist.get(j);
    int log_isbranche=Util.getIntValue((String)htlog.get("isbranche"),0);
    int log_nodeid=Util.getIntValue((String)htlog.get("nodeid"),0);
    int log_nodeattribute=Util.getIntValue((String)htlog.get("nodeattribute"),0);
    String log_nodename=Util.null2String((String)htlog.get("nodename"));
    int log_destnodeid=Util.getIntValue((String)htlog.get("destnodeid"));
    String log_remark=Util.null2String((String)htlog.get("remark"));
    String log_operatortype=Util.null2String((String)htlog.get("operatortype"));
    String log_operator=Util.null2String((String)htlog.get("operator"));
    String log_agenttype=Util.null2String((String)htlog.get("agenttype"));
    String log_agentorbyagentid=Util.null2String((String)htlog.get("agentorbyagentid"));
    String log_operatedate=Util.null2String((String)htlog.get("operatedate"));
    String log_operatetime=Util.null2String((String)htlog.get("operatetime"));
    String log_logtype=Util.null2String((String)htlog.get("logtype"));
    String log_receivedPersons=Util.null2String((String)htlog.get("receivedPersons"));
    String log_annexdocids=Util.null2String((String)htlog.get("annexdocids"));
    String log_operatorDept=Util.null2String((String)htlog.get("operatorDept"));
    String log_signdocids=Util.null2String((String)htlog.get("signdocids"));
    String log_signworkflowids=Util.null2String((String)htlog.get("signworkflowids"));
    int tempRequestLogId=Util.getIntValue((String)htlog.get("logid"),0);
    String log_nodeimg="";
    if(log_tempvalue.equals(log_operator+"_"+log_operatortype+"_"+log_operatedate+"_"+log_operatetime)){
        log_branchenodeid=0;
    }else{
        log_tempvalue=log_operator+"_"+log_operatortype+"_"+log_operatedate+"_"+log_operatetime;
    }
    if(log_nodeattribute==1&&(log_logtype.equals("0")||log_logtype.equals("2"))&&log_branchenodeid==0){
        log_branchenodeid=log_nodeid;
        log_nodeimg=imgline;
    }
    if(log_isbranche==1){
        log_nodeimg="<img src=\"/images/xp/T_wev8.png\">";
        log_branchenodeid=0;
    }
	nLogCount++;

	lineNTdOne="line"+String.valueOf(nLogCount)+"TdOne";
    if(log_isbranche==0&&"2".equals(orderbytype)) isLight = !isLight;

%>

          <tr <%if(isLight){%> class=datalight <%} else {%> class=datadark  <%}%>>
           <td><%=log_nodeimg%><%=Util.toScreen(log_nodename,languageidfromrequest)%></td>

           <td width=50%>
							<table width=100%>
		  <tr>
             <td colspan="3">
            	<%if(!log_logtype.equals("t")){
            	String tempremark = log_remark;
							tempremark = Util.StringReplace(tempremark,"&lt;br&gt;","<br>");
            	%>
             <%=Util.StringReplace(tempremark,"&nbsp;"," ")%>
             <%}
            if(!log_annexdocids.equals("")||!log_signdocids.equals("")||!log_signworkflowids.equals("")){
                %>
           <br/>
          <table width="70%">
                 <tr height="1"><td><td style="border:1px dotted #000000;border-top-color:#ffffff;border-left-color:#ffffff;border-right-color:#ffffff;height:1px">&nbsp;</td></tr>
             </table>
          <table>
          <tbody >
           <%
            String signhead="";
            if(!log_signdocids.equals("")){
            RecordSetlog3.executeSql("select id,docsubject,accessorycount,SecCategory from docdetail where id in("+log_signdocids+") order by id asc");
            int linknum=-1;
            while(RecordSetlog3.next()){
              linknum++;
              if(linknum==0){
                  signhead=SystemEnv.getHtmlLabelName(857,languageidfromrequest)+":";
              }else{
                  signhead="&nbsp;";
              }
              String showid = Util.null2String(RecordSetlog3.getString(1)) ;
              String tempshowname= Util.toScreen(RecordSetlog3.getString(2),languageidfromrequest) ;
              %>

          <tr>
            <td style="PADDING-left:10px"><nobr><%=signhead%></td>
            <td >
                <a style="cursor:pointer" onclick="addDocReadTag('<%=showid%>');openFullWindowHaveBar('/docs/docs/DocDsp.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>&id=<%=showid%>&isrequest=1&requestid=<%=requestid%>')"><%=tempshowname%></a>&nbsp;
            </td>
          </tr>
              <%}
              }
            ArrayList tempwflists=Util.TokenizerString(log_signworkflowids,",");
            int tempnum = Util.getIntValue(String.valueOf(session.getAttribute("slinkwfnum")));
            for(int k=0;k<tempwflists.size();k++){
              if(k==0){
                  signhead=SystemEnv.getHtmlLabelName(1044,languageidfromrequest)+":";
              }else{
                  signhead="&nbsp;";
              }
                tempnum++;
                session.setAttribute("resrequestid" + tempnum, "" + tempwflists.get(k));
              String temprequestname="<a style=\"cursor:pointer\" onclick=\"openFullWindowHaveBar('/workflow/request/ViewRequest.jsp?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+"&isrequest=1&requestid="+tempwflists.get(k)+"&wflinkno="+tempnum+"')\">"+wfrequestcominfo.getRequestName((String)tempwflists.get(k))+"</a>";
              %>

          <tr>
            <td style="PADDING-left:10px"><nobr><%=signhead%></td>
            <td><%=temprequestname%></td>
          </tr>
              <%
            }
            session.setAttribute("slinkwfnum", "" + tempnum);
            session.setAttribute("haslinkworkflow", "1");
            if(!log_annexdocids.equals("")){
            RecordSetlog3.executeSql("select id,docsubject,accessorycount,SecCategory from docdetail where id in("+log_annexdocids+") order by id asc");
            int linknum=-1;
            while(RecordSetlog3.next()){
              linknum++;
              if(linknum==0){
                  signhead=SystemEnv.getHtmlLabelName(22194,languageidfromrequest)+":";
              }else{
                  signhead="&nbsp;";
              }
              String showid = Util.null2String(RecordSetlog3.getString(1)) ;
              String tempshowname= Util.toScreen(RecordSetlog3.getString(2),user.getLanguage()) ;
              int accessoryCount=RecordSetlog3.getInt(3);
              String SecCategory=Util.null2String(RecordSetlog3.getString(4));
              DocImageManager1.resetParameter();
              DocImageManager1.setDocid(Util.getIntValue(showid));
              DocImageManager1.selectDocImageInfo();

              String docImagefilename = "";
              String fileExtendName = "";
              String docImagefileid = "";
              int versionId = 0;
              long docImagefileSize = 0;
              if(DocImageManager1.next()){
                //DocImageManager会得到doc第一个附件的最新版本

                docImagefilename = DocImageManager1.getImagefilename();
                fileExtendName = docImagefilename.substring(docImagefilename.lastIndexOf(".")+1).toLowerCase();
                docImagefileid = DocImageManager1.getImagefileid();
                docImagefileSize = DocImageManager1.getImageFileSize(Util.getIntValue(docImagefileid));
                versionId = DocImageManager1.getVersionId();
              }
             if(accessoryCount>1){
               fileExtendName ="htm";
             }
              String imgSrc= AttachFileUtil.getImgStrbyExtendName(fileExtendName,16);
              boolean nodownload=SecCategoryComInfo1.getNoDownload(SecCategory).equals("1")?true:false;
              %>

          <tr>
            <td style="PADDING-left:10px"><nobr><%=signhead%></td>
            <td >
              <%=imgSrc%>
              <%if(accessoryCount==1 && (Util.isExt(fileExtendName)||fileExtendName.equalsIgnoreCase("pdf"))){%>
                <a style="cursor:pointer" onclick="addDocReadTag('<%=showid%>');openFullWindowHaveBar('/docs/docs/DocDspExt.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>&id=<%=showid%>&imagefileId=<%=docImagefileid%>&isFromAccessory=true&isrequest=1&requestid=<%=requestid%>')"><%=docImagefilename%></a>&nbsp
              <%}else{%>
                <a style="cursor:pointer" onclick="addDocReadTag('<%=showid%>');openFullWindowHaveBar('/docs/docs/DocDsp.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>&id=<%=showid%>&isrequest=1&requestid=<%=requestid%>')"><%=tempshowname%></a>&nbsp
              <%}
              if(!isprint&&accessoryCount==1 &&((!fileExtendName.equalsIgnoreCase("xls")&&!fileExtendName.equalsIgnoreCase("doc"))||!nodownload)){%>
              <button type=button  class=btnFlowd accessKey=1  onclick="addDocReadTag('<%=showid%>');top.location='/weaver/weaver.file.FileDownload?fileid=<%=docImagefileid%>&download=1&requestid=<%=requestid%>&fromrequest=1'">
                    <U><%=linknum%></U>-<%=SystemEnv.getHtmlLabelName(258,user.getLanguage())%>	(<%=docImagefileSize/1000%>K)
                  </BUTTON>
              <%}%>
            </td>
          </tr>
              <%}}%>
          </tbody>
          </table>
                <%}%>
             </td>
             </tr>
             <tr>
             <td>&nbsp;</td>
              <td align=right>

             <%
                 BaseBean wfsbean=FieldInfo.getWfsbean();
                int showimg = Util.getIntValue(wfsbean.getPropValue("WFSignatureImg","showimg"),0);
                rssign.execute("select * from DocSignature  where hrmresid=" + log_operator + "order by markid");
                String userimg = "";
                if (showimg == 1 && rssign.next()) {
                    // 获取签章图片并显示

                    String markpath = Util.null2String(rssign.getString("markpath"));
                    if (!markpath.equals("")) {
                        userimg = "/weaver/weaver.file.ImgFileDownload?userid=" + log_operator;
                    }
                }
                if(!userimg.equals("") && "0".equals(log_operatortype)){
			%>
			<img id=markImg src="<%=userimg%>" ></img>
			<%
			}
			else
			 {
                 if(isOldWf_)
             {
              //System.out.println("viewsign_old");
            if(log_operatortype.equals("0")){%>
            <%if(isprint==false){%>
			<%if(!"0".equals(Util.null2String(log_operatorDept))&&!"".equals(Util.null2String(log_operatorDept))){%>
	               <a href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=Util.toScreen(log_operatorDept,user.getLanguage())%>" target="_blank"><%=Util.toScreen(DepartmentComInfoTemp.getDepartmentname(log_operatorDept),user.getLanguage())%></a>
	               /
				   <%}%>
	<a href="javaScript:openhrm(<%=log_operator%>);" onclick='pointerXY(event);'>
              <%=Util.toScreen(ResourceComInfo.getResourcename(log_operator),user.getLanguage())%></a>
            <%}else{%>
			<%if(!"0".equals(Util.null2String(log_operatorDept))&&!"".equals(Util.null2String(log_operatorDept))){%>
 <%=Util.toScreen(DepartmentComInfoTemp.getDepartmentname(log_operatorDept),user.getLanguage())%>
 <%}%>
              <%=Util.toScreen(ResourceComInfo.getResourcename(log_operator),user.getLanguage())%>
            <%}%>

<%}else if(log_operatortype.equals("1")){%>
  <%if(isprint==false){%>
	<a href="/CRM/data/ViewCustomer.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>&CustomerID=<%=log_operator%>&requestid=<%=requestid%>"><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(log_operator),user.getLanguage())%></a>
  <%}else{%>
    <%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(log_operator),user.getLanguage())%>
  <%}%>
<%}else{%>
<%=SystemEnv.getHtmlLabelName(468,user.getLanguage())%>
<%}

             }
             else
             {
                        //System.out.println("viewsign_new");
                         if(log_operatortype.equals("0")){%>
            <!-- modify by xhheng @20050304 for TD 1691 -->
            <%if(isprint==false)
            {
                if(!log_agenttype.equals("2")){%>
				<%if(!"0".equals(Util.null2String(log_operatorDept))&&!"".equals(Util.null2String(log_operatorDept))){%>

	               <a href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=Util.toScreen(log_operatorDept,user.getLanguage())%>" target="_blank"><%=Util.toScreen(DepartmentComInfoTemp.getDepartmentname(log_operatorDept),user.getLanguage())%></a>
	               /
				   <%}%>
	                   <a href="javaScript:openhrm(<%=log_operator%>);" onclick='pointerXY(event);'><%=Util.toScreen(ResourceComInfo.getResourcename(log_operator),user.getLanguage())%></a>
               <%}
                /*----------added by xwj for td2891 begin----------- */
                else if(log_agenttype.equals("2")){

                   if(!(""+log_nodeid).equals(creatorNodeId) || ((""+log_nodeid).equals(creatorNodeId) && !WFLinkInfo.isCreateOpt(tempRequestLogId,requestid))){//非创建节点log,必须体现代理关系%>

                    <%if(!"0".equals(Util.null2String(log_operatorDept))&&!"".equals(Util.null2String(log_operatorDept))){%>
	               <a href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=Util.toScreen(ResourceComInfo.getDepartmentID(log_agentorbyagentid),user.getLanguage())%>" target="_blank"><%=Util.toScreen(DepartmentComInfoTemp.getDepartmentname(ResourceComInfo.getDepartmentID(log_agentorbyagentid)),user.getLanguage())%></a>
	               /
				   <%}%>
                    <a href="javaScript:openhrm(<%=log_agentorbyagentid%>);" onclick='pointerXY(event);'><%=Util.toScreen(ResourceComInfo.getResourcename(log_agentorbyagentid),user.getLanguage())+SystemEnv.getHtmlLabelName(24214,user.getLanguage())%></a>
                    ->
                    <%if(!"0".equals(Util.null2String(log_operatorDept))&&!"".equals(Util.null2String(log_operatorDept))){%>
	               <a href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=Util.toScreen(log_operatorDept,user.getLanguage())%>" target="_blank"><%=Util.toScreen(DepartmentComInfoTemp.getDepartmentname(log_operatorDept),user.getLanguage())%></a>
	               /
				   <%}%>
                    <a href="javaScript:openhrm(<%=log_operator%>);" onclick='pointerXY(event);'><%=Util.toScreen(ResourceComInfo.getResourcename(log_operator),user.getLanguage())+SystemEnv.getHtmlLabelName(24213,user.getLanguage())%></a>

                   <%}
                   else{//创造节点log, 如果设置代理时选中了代理流程创建,同时代理人本身对该流程就具有创建权限,那么该代理人创建节点的log不体现代理关系

                   String agentCheckSql = " select * from workflow_Agent where workflowId="+ tempworkflowid +" and beagenterId=" + log_agentorbyagentid +
													 " and agenttype = '1' " +
													 " and ( ( (endDate = '" + TimeUtil.getCurrentDateString() + "' and (endTime='' or endTime is null))" +
													 " or (endDate = '" + TimeUtil.getCurrentDateString() + "' and endTime > '" + (TimeUtil.getCurrentTimeString()).substring(11,19) + "' ) ) " +
													 " or endDate > '" + TimeUtil.getCurrentDateString() + "' or endDate = '' or endDate is null)" +
													 " and ( ( (beginDate = '" + TimeUtil.getCurrentDateString() + "' and (beginTime='' or beginTime is null))" +
													 " or (beginDate = '" + TimeUtil.getCurrentDateString() + "' and beginTime < '" + (TimeUtil.getCurrentTimeString()).substring(11,19) + "' ) ) " +
													 " or beginDate < '" + TimeUtil.getCurrentDateString() + "' or beginDate = '' or beginDate is null)";
                  RecordSetlog3.executeSql(agentCheckSql);
                  if(!RecordSetlog3.next()){
                      %>
                      <%if(!"0".equals(Util.null2String(log_operatorDept))&&!"".equals(Util.null2String(log_operatorDept))){%>
	               <a href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=Util.toScreen(log_operatorDept,user.getLanguage())%>" target="_blank"><%=Util.toScreen(DepartmentComInfoTemp.getDepartmentname(log_operatorDept),user.getLanguage())%></a>
				   <%}%>
	               /
                      <a href="javaScript:openhrm(<%=log_operator%>);" onclick='pointerXY(event);'><%=Util.toScreen(ResourceComInfo.getResourcename(log_operator),user.getLanguage())%></a>
                  <%}
                  else{
                  String isCreator = RecordSetlog3.getString("isCreateAgenter");

                  if(!isCreator.equals("1")){%>

                    <%if(!"0".equals(Util.null2String(log_operatorDept))&&!"".equals(Util.null2String(log_operatorDept))){%>
	               <a href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=Util.toScreen(log_operatorDept,user.getLanguage())%>" target="_blank"><%=Util.toScreen(DepartmentComInfoTemp.getDepartmentname(log_operatorDept),user.getLanguage())%></a>
	               /
				   <%}%>
                    <a href="javaScript:openhrm(<%=log_operator%>);" onclick='pointerXY(event);'><%=Util.toScreen(ResourceComInfo.getResourcename(log_operator),user.getLanguage())%></a>
                  <%}
                  else{

                   int userLevelUp = -1;
                   int uesrLevelTo = -1;
                   int secLevel = -1;
                   rsCheckUserCreater.executeSql("select seclevel from HrmResource where id= " + log_operator);
                   if(rsCheckUserCreater.next()){
                   secLevel = rsCheckUserCreater.getInt("seclevel");
                   }
                   else{
                   rsCheckUserCreater.executeSql("select seclevel from HrmResourceManager where id= " + log_operator);
                   if(rsCheckUserCreater.next()){
                   secLevel = rsCheckUserCreater.getInt("seclevel");
                   }
                   }

                   //是否有此流程的创建权限

                   boolean haswfcreate = new weaver.share.ShareManager().hasWfCreatePermission(HrmUserVarify.getUser(request, response), workflowid);;
                   if(haswfcreate){%>
                    <%if(!"0".equals(Util.null2String(log_operatorDept))&&!"".equals(Util.null2String(log_operatorDept))){%>
	               <a href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=Util.toScreen(log_operatorDept,user.getLanguage())%>" target="_blank"><%=Util.toScreen(DepartmentComInfoTemp.getDepartmentname(log_operatorDept),user.getLanguage())%></a>
	               /
				   <%}%>
                   <a href="javaScript:openhrm(<%=log_operator%>);" onclick='pointerXY(event);'><%=Util.toScreen(ResourceComInfo.getResourcename(log_operator),user.getLanguage())%></a>
                   <%}
                  else{%>
                   <%if(!"0".equals(Util.null2String(ResourceComInfo.getDepartmentID(log_agentorbyagentid)))&&!"".equals(Util.null2String(ResourceComInfo.getDepartmentID(log_agentorbyagentid)))){%>
	               <a href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=Util.toScreen(ResourceComInfo.getDepartmentID(log_agentorbyagentid),user.getLanguage())%>" target="_blank"><%=Util.toScreen(DepartmentComInfoTemp.getDepartmentname(ResourceComInfo.getDepartmentID(log_agentorbyagentid)),user.getLanguage())%></a>
	               /
				   <%}%>
                   <a href="javaScript:openhrm(<%=log_agentorbyagentid%>);" onclick='pointerXY(event);'><%=Util.toScreen(ResourceComInfo.getResourcename(log_agentorbyagentid),user.getLanguage())+SystemEnv.getHtmlLabelName(24214,user.getLanguage())%></a>
                    ->
                    <%if(!"0".equals(Util.null2String(log_operatorDept))&&!"".equals(Util.null2String(log_operatorDept))){%>
	               <a href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=Util.toScreen(log_operatorDept,user.getLanguage())%>" target="_blank"><%=Util.toScreen(DepartmentComInfoTemp.getDepartmentname(log_operatorDept),user.getLanguage())%></a>
	               /
				   <%}%>
                    <a href="javaScript:openhrm(<%=log_operator%>);" onclick='pointerXY(event);'><%=Util.toScreen(ResourceComInfo.getResourcename(log_operator),user.getLanguage())+SystemEnv.getHtmlLabelName(24213,user.getLanguage())%></a>

                  <%}
                  }

                  }
                }
                }
                /*----------added by xwj for td2891 end----------- */
                else{
                }
            }
            else
            {

               if(!log_agenttype.equals("2")){%>
                   <%if(!"0".equals(Util.null2String(ResourceComInfo.getDepartmentID(log_agentorbyagentid)))&&!"".equals(Util.null2String(ResourceComInfo.getDepartmentID(log_agentorbyagentid)))){%>
	               <%=Util.toScreen(DepartmentComInfoTemp.getDepartmentname(ResourceComInfo.getDepartmentID(log_agentorbyagentid)),user.getLanguage())%>
	               /
				   <%}%>
	                   <%=Util.toScreen(ResourceComInfo.getResourcename(log_operator),user.getLanguage())%>
               <%}
                else if(log_agenttype.equals("2")){%>

                   <%if(!"0".equals(Util.null2String(ResourceComInfo.getDepartmentID(log_agentorbyagentid)))&&!"".equals(Util.null2String(ResourceComInfo.getDepartmentID(log_agentorbyagentid)))){%>
	               <%=Util.toScreen(DepartmentComInfoTemp.getDepartmentname(ResourceComInfo.getDepartmentID(log_agentorbyagentid)),user.getLanguage())%>
	               /
				   <%}%>
                   
                  <%=Util.toScreen(ResourceComInfo.getResourcename(log_agentorbyagentid),user.getLanguage())+SystemEnv.getHtmlLabelName(24214,user.getLanguage())%>
                ->
                   <%if(!"0".equals(Util.null2String(ResourceComInfo.getDepartmentID(log_agentorbyagentid)))&&!"".equals(Util.null2String(ResourceComInfo.getDepartmentID(log_agentorbyagentid)))){%>
	               <%=Util.toScreen(DepartmentComInfoTemp.getDepartmentname(ResourceComInfo.getDepartmentID(log_agentorbyagentid)),user.getLanguage())%>
	               /
				   <%}%>
                <%=Util.toScreen(ResourceComInfo.getResourcename(log_operator),user.getLanguage())+SystemEnv.getHtmlLabelName(24213,user.getLanguage())%>

                <%}
                else{
                }

           }

       }

       else if(log_operatortype.equals("1")){%>
  <!-- modify by xhheng @20050304 for TD 1691 -->
  <%if(isprint==false){%>
	<a href="/CRM/data/ViewCustomer.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>&CustomerID=<%=log_operator%>&requestid=<%=requestid%>"><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(log_operator),user.getLanguage())%></a>
  <%}else{%>
    <%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(log_operator),user.getLanguage())%>
  <%}%>
<%}else{%>
<%=SystemEnv.getHtmlLabelName(468,user.getLanguage())%>
<%}


}}%>

      <%-- xwj for td2104 on 20050802 end --%>


            </td>
            </tr>
            <tr>
            <td>&nbsp;</td>
           <td align=right><%=Util.toScreen(log_operatedate,user.getLanguage())%>
              &nbsp<%=Util.toScreen(log_operatetime,user.getLanguage())%>
              </td>
            </tr>
             </table>
             <!--xwj for td2104 20050825-->
            <td>
              <%
	String logtype = log_logtype;
	String operationname = RequestLogOperateName.getOperateName(""+tempworkflowid,""+requestid,""+log_nodeid,logtype,log_operator,user.getLanguage(),log_operatedate,log_operatetime);
	%>
	<%=operationname%>
<%
lineNTdTwo="line"+String.valueOf(nLogCount)+"TdTwo"+Util.getRandom();
%>
            </td>
                      <%--added by xwj for td2104 on 2005-8-1--%>
          <td id="<%=lineNTdTwo%>">
              <%
                String tempStr ="";
                if(log_receivedPersons.length()>0) tempStr = Util.toScreen(log_receivedPersons.substring(0,log_receivedPersons.length()-1),user.getLanguage());
			String showoperators="";
				try
				{
				showoperators=RequestDefaultComInfo.getShowoperator(""+user.getUID());
				}
				catch (Exception eshows)
				{}
                if (!showoperators.equals("1")) {
                if(!"".equals(tempStr) && tempStr != null){
                        tempStr = "<span style=\"cursor:pointer;\" style='cursor:pointer;color: blue; text-decoration: underline' onClick=showallreceived('"+requestid+"','"+log_nodeid+"','"+log_operator+"','"+log_operatedate+
                                "','"+log_operatetime+"','"+lineNTdTwo+"','"+log_logtype+"',"+log_destnodeid+") >"+SystemEnv.getHtmlLabelName(89, user.getLanguage())+"</span>";
                }
				}
              %>
              <%=tempStr%>
          </td>
          </tr>

          <%
	if(log_isbranche==0&&!"2".equals(orderbytype)) isLight = !isLight;
}}requestid = initrequestid;
%>


</tbody></table>
</div>

<script language="javascript">
function openSignPrint() {
  var redirectUrl = "PrintRequest.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>&requestid=<%=requestid%>&isprint=1&fromFlowDoc=1&urger=<%=logs_urger%>&ismonitor=<%=logs_monitor%>" ;
  <%//解决相关流程打印权限问题
  String wflinkno = Util.null2String((String) session.getAttribute(requestid+"wflinkno"));
  if(!wflinkno.equals("")){
  %>
  redirectUrl = "PrintRequest.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>&requestid=<%=requestid%>&isprint=1&fromFlowDoc=1&isrequest=1&wflinkno=<%=wflinkno%>&urger=<%=logs_urger%>&ismonitor=<%=logs_monitor%>";
  <%}%>
  var width = screen.width ;
  var height = screen.height ;
  if (height == 768 ) height -= 75 ;
  if (height == 600 ) height -= 60 ;
  var szFeatures = "top=0," ;
  szFeatures +="left=0," ;
  szFeatures +="width="+width+"," ;
  szFeatures +="height="+height+"," ;
  szFeatures +="directories=no," ;
  szFeatures +="status=yes," ;
  szFeatures +="menubar=no," ;
szFeatures +="toolbar=yes," ;
  szFeatures +="scrollbars=yes," ;

  szFeatures +="resizable=yes" ; //channelmode
  window.open(redirectUrl,"",szFeatures) ;
}
var showTableDiv  = $GetEle('divshowreceivied');
var oIframe = document.createElement('iframe');
function showreceiviedPopup(content){
    showTableDiv.style.display='';
    var message_Div = document.createElement("div");
     message_Div.id="message_Div";
     message_Div.className="xTable_message";
     showTableDiv.appendChild(message_Div);
     var message_Div1  = $GetEle("message_Div");
     message_Div1.style.display="inline";
     message_Div1.innerHTML=content;
     var pTop= document.body.offsetHeight/2+document.body.scrollTop-50;
     var pLeft= document.body.offsetWidth/2-50;
     message_Div1.style.position="absolute"
     message_Div1.style.top=pTop;
     message_Div1.style.left=pLeft;

     message_Div1.style.zIndex=1002;

     oIframe.id = 'HelpFrame';
     showTableDiv.appendChild(oIframe);
     oIframe.frameborder = 0;
     oIframe.style.position = 'absolute';
     oIframe.style.top = pTop;
     oIframe.style.left = pLeft;
     oIframe.style.zIndex = message_Div1.style.zIndex - 1;
     oIframe.style.width = parseInt(message_Div1.offsetWidth);
     oIframe.style.height = parseInt(message_Div1.offsetHeight);
     oIframe.style.display = 'block';
}
function ajaxinit(){
    var ajax=false;
    try {
        ajax = new ActiveXObject("Msxml2.XMLHTTP");
    } catch (e) {
        try {
            ajax = new ActiveXObject("Microsoft.XMLHTTP");
        } catch (E) {
            ajax = false;
        }
    }
    if (!ajax && typeof XMLHttpRequest!='undefined') {
    ajax = new XMLHttpRequest();
    }
    return ajax;
}
function showallreceived(requestid,viewLogIds,operator,operatedate,operatetime,returntdid,logtype,destnodeid){
    showreceiviedPopup("<%=SystemEnv.getHtmlLabelName(19205,user.getLanguage())%>");
    var ajax=ajaxinit();
    ajax.open("POST", "/workflow/request/WorkflowReceiviedPersons.jsp", true);
    ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
    ajax.send("requestid="+requestid+"&viewnodeIds="+viewLogIds+"&operator="+operator+"&operatedate="+operatedate+"&operatetime="+operatetime+"&returntdid="+returntdid+"&logtype="+logtype+"&destnodeid="+destnodeid);
    //获取执行状态

    ajax.onreadystatechange = function() {
        //如果执行状态成功，那么就把返回信息写到指定的层里

        if (ajax.readyState == 4 && ajax.status == 200) {
            try{
            $GetEle(returntdid).innerHTML = ajax.responseText;
            }catch(e){}
            showTableDiv.style.display='none';
            oIframe.style.display='none';
        }
    }
}
function displaydiv_1()
{
    if(WorkFlowDiv.style.display == ""){
        WorkFlowDiv.style.display = "none";
        //WorkFlowspan.innerHTML = "<a href='javascript:void(0);' onClick=displaydiv_1() target=_self><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></a>";
		WorkFlowspan.innerHTML = "<span style='cursor:pointer;color: blue; text-decoration: underline' onClick='displaydiv_1()' ><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></span>";
    }
    else{
        WorkFlowDiv.style.display = "";
        //WorkFlowspan.innerHTML = "<a href='javascript:void(0);' onClick=displaydiv_1() target=_self><%=SystemEnv.getHtmlLabelName(15154,user.getLanguage())%></a>";
		WorkFlowspan.innerHTML = "<span style='cursor:pointer;color: blue; text-decoration: underline' onClick='displaydiv_1()' ><%=SystemEnv.getHtmlLabelName(15154,user.getLanguage())%></span>";
    }
}
//屏蔽掉原来接收人显示部分功能  mackjoe at 2006-06-13 td4491
function accesoryChanage(obj,maxUploadImageSize){
    var objValue = obj.value;
    if (objValue=="") return ;
    var fileLenth;
    try {
        var oFile=$GetEle("oFile");
        oFile.FilePath=objValue;
        fileLenth= oFile.getFileSize();
    } catch (e){
		if(e.message=="<%=SystemEnv.getHtmlLabelName(83411,user.getLanguage())%>"||e.message=="<%=SystemEnv.getHtmlLabelName(83411,user.getLanguage())%>"){
			alert("<%=SystemEnv.getHtmlLabelName(21015,user.getLanguage())%> ");
		}else{
			alert("<%=SystemEnv.getHtmlLabelName(21090,user.getLanguage())%> ");
		}
        createAndRemoveObj(obj);
        return  ;
    }
    if (fileLenth==-1) {
        createAndRemoveObj(obj);
        return ;
    }
    var fileLenthByM = (fileLenth/(1024*1024)).toFixed(1)
    if (fileLenthByM>maxUploadImageSize) {
     	alert("<%=SystemEnv.getHtmlLabelName(20254,user.getLanguage())%>"+fileLenthByM+"M,<%=SystemEnv.getHtmlLabelName(20255,user.getLanguage())%>"+maxUploadImageSize+"M<%=SystemEnv.getHtmlLabelName(20256 ,user.getLanguage())%>");
        createAndRemoveObj(obj);
    }
}

function createAndRemoveObj(obj){
    objName = obj.name;
    tempObjonchange=obj.onchange;
    outerHTML="<input name="+objName+" class=InputStyle type=file size=50 >";
    $GetEle(objName).outerHTML=outerHTML;
    $GetEle(objName).onchange=tempObjonchange;
}
function addannexRow(accname,maxsize)
  {
    $GetEle(accname+'_num').value=parseInt($GetEle(accname+'_num').value)+1;
    ncol = $GetEle(accname+'_tab').cols;
    oRow = $GetEle(accname+'_tab').insertRow(-1);
    for(j=0; j<ncol; j++) {
      oCell = oRow.insertCell(-1);

      switch(j) {
        case 0:
          var oDiv = document.createElement("div");
          oCell.colSpan=3;
          var sHtml = "<input class=InputStyle  type=file size=50 name='"+accname+"_"+$GetEle(accname+'_num').value+"' onchange='accesoryChanage(this,"+maxsize+")'> (<%=SystemEnv.getHtmlLabelName(18976,user.getLanguage())%>"+maxsize+"<%=SystemEnv.getHtmlLabelName(18977,user.getLanguage())%>) ";
          oDiv.innerHTML = sHtml;
          oCell.appendChild(oDiv);
          break;
      }
    }
  }

 function onChangeSharetype(delspan,delid,ismand,Uploadobj){
	fieldid=delid.substr(0,delid.indexOf("_"));
    linknum=delid.substr(delid.lastIndexOf("_")+1);
	fieldidnum=fieldid+"_idnum_1";
	fieldidspan=fieldid+"span";
    delfieldid=fieldid+"_id_"+linknum;
    if($GetEle(delspan).style.visibility=='visible'){
      $GetEle(delspan).style.visibility='hidden';
      $GetEle(delid).value='0';
	  $GetEle(fieldidnum).value=parseInt($GetEle(fieldidnum).value)+1;
        var tempvalue=$GetEle(fieldid).value;
          if(tempvalue==""){
              tempvalue=$GetEle(delfieldid).value;
          }else{
              tempvalue+=","+$GetEle(delfieldid).value;
          }
	     $GetEle(fieldid).value=tempvalue;
    }else{
      $GetEle(delspan).style.visibility='visible';
      $GetEle(delid).value='1';
	  $GetEle(fieldidnum).value=parseInt($GetEle(fieldidnum).value)-1;
        var tempvalue=$GetEle(fieldid).value;
        var tempdelvalue=","+$GetEle(delfieldid).value+",";
          if(tempvalue.substr(0,1)!=",") tempvalue=","+tempvalue;
          if(tempvalue.substr(tempvalue.length-1)!=",") tempvalue+=",";
          tempvalue=tempvalue.substr(0,tempvalue.indexOf(tempdelvalue))+tempvalue.substr(tempvalue.indexOf(tempdelvalue)+tempdelvalue.length-1);
          if(tempvalue.substr(0,1)==",") tempvalue=tempvalue.substr(1);
          if(tempvalue.substr(tempvalue.length-1)==",") tempvalue=tempvalue.substr(0,tempvalue.length-1);
	     $GetEle(fieldid).value=tempvalue;
    }
	//alert($GetEle(fieldidnum).value);
	if (ismand=="1")
	  {
	if ($GetEle(fieldidnum).value=="0")
	  {
	    $GetEle(fieldid).value="";
        if(Uploadobj.getStats().files_queued==0){
		$GetEle(fieldidspan).innerHTML="<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
        }
	  }
	  else
	  {
		 $GetEle(fieldidspan).innerHTML="";
	  }
	  }
  }
</script>