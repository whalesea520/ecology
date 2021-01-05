
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ page import="weaver.file.FileUpload" %>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.StringTokenizer" %>
<%@ page import="weaver.general.StaticObj" %>
<%@ page import="weaver.interfaces.workflow.browser.Browser" %>
<%@ page import="weaver.interfaces.workflow.browser.BrowserBean" %>
<%@ page import="weaver.meeting.MeetingBrowser"%>
<%@page import="weaver.fna.general.FnaCommon"%><jsp:useBean id="CoworkDAO" class="weaver.cowork.CoworkDAO" scope="page"/>
<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="java.text.NumberFormat" %>
<%@page import="weaver.formmode.tree.CustomTreeData"%>
<%@ page import="weaver.general.AttachFileUtil" %>
<%@ page import="weaver.systeminfo.SystemEnv" %>
<%@ page import="weaver.workflow.request.RequestConstants" %>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="recordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet_nf1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet_nf2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="FieldComInfo" class="weaver.workflow.field.FieldComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page"/>
<jsp:useBean id="DocImageManager" class="weaver.docs.docs.DocImageManager" scope="page" />
<jsp:useBean id="SecCategoryComInfo1" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="ProjectInfoComInfo1" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo1" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="deptVirComInfo" class="weaver.hrm.companyvirtual.DepartmentVirtualComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo1" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="subCompVirComInfo" class="weaver.hrm.companyvirtual.SubCompanyVirtualComInfo" scope="page"/>
<jsp:useBean id="DocComInfo1" class="weaver.docs.docs.DocComInfo" scope="page"/>
<jsp:useBean id="CapitalComInfo1" class="weaver.cpt.capital.CapitalComInfo" scope="page"/>
<jsp:useBean id="WorkflowRequestComInfo1" class="weaver.workflow.workflow.WorkflowRequestComInfo" scope="page"/>
<jsp:useBean id="ResourceConditionManager" class="weaver.workflow.request.ResourceConditionManager" scope="page"/>
<jsp:useBean id="DocReceiveUnitComInfo" class="weaver.docs.senddoc.DocReceiveUnitComInfo" scope="page"/>
<jsp:useBean id="SpecialField" class="weaver.workflow.field.SpecialFieldInfo" scope="page" />
<jsp:useBean id="docReceiveUnitComInfo_vba" class="weaver.docs.senddoc.DocReceiveUnitComInfo" scope="page"/>
<jsp:useBean id="WFNodeFieldMainManager" class="weaver.workflow.workflow.WFNodeFieldMainManager" scope="page" />
<jsp:useBean id="workflowJspBean" class="weaver.workflow.request.WorkflowJspBean" scope="page"/>
<%
HashMap specialfield = SpecialField.getFormSpecialField();//特殊字段的字段信息



FileUpload fu = new FileUpload(request);
String f_weaver_belongto_userid=fu.getParameter("f_weaver_belongto_userid");//需要增加的代码
String f_weaver_belongto_usertype=fu.getParameter("f_weaver_belongto_usertype");//需要增加的代码
User user = HrmUserVarify.getUser(request, response, f_weaver_belongto_userid, f_weaver_belongto_usertype) ;//需要增加的代码
int userid=user.getUID();  
int usertype = 0;
int workflowid = Util.getIntValue(request.getParameter("workflowid"));
int requestid=Util.getIntValue(request.getParameter("requestid"),0);
//String workflowname = Util.null2String(request.getParameter("workflowname"));//update by fanggsh 20060509 TD4294
String workflowname = Util.null2String((String)session.getAttribute(userid+"_"+requestid+"workflowname"));//update by fanggsh 20060509 TD4294
String  fromFlowDoc=Util.null2String(request.getParameter("fromFlowDoc"));  //是否从流程创建文档而来
int languageidfromrequest = Util.getIntValue(request.getParameter("languageid"));

boolean canactive = Util.null2String(request.getParameter("canactive")).equalsIgnoreCase("true") ;  
int deleted = Util.getIntValue(request.getParameter("deleted"),0) ;  //请求是否删除  1:是 0或者其它 否



int nodeid = Util.getIntValue(request.getParameter("nodeid"),0) ;  

String docFlags=Util.null2String((String)session.getAttribute("requestAdd"+requestid));
//String requestname = Util.null2String(request.getParameter("requestname"));//update by fanggsh 20060509 TD4294
String requestname = Util.null2String((String)session.getAttribute(userid+"_"+requestid+"requestname"));//update by fanggsh 20060509 TD4294
String requestlevel = Util.null2String(request.getParameter("requestlevel"));

String isbill = Util.null2String(request.getParameter("isbill"));
int billid=Util.getIntValue(request.getParameter("billid"),0);

int formid=Util.getIntValue(request.getParameter("formid"),0);

boolean isprint = Util.null2String(request.getParameter("isprint")).equalsIgnoreCase("true") ;  
boolean isurger = Util.null2String(request.getParameter("isurger")).equalsIgnoreCase("true") ;
boolean wfmonitor = Util.null2String(request.getParameter("wfmonitor")).equalsIgnoreCase("true") ;
String isrequest = Util.null2String(request.getParameter("isrequest"));
int intervenorright=Util.getIntValue(request.getParameter("intervenorright"),0);
int desrequestid = Util.getIntValue(request.getParameter("desrequestid"),0);//父流程ID
String sql = "" ;
ArrayList htmlfckfield_body=new ArrayList();

String logintype = Util.null2String(request.getParameter("logintype"));

char flag = Util.getSeparator() ;

String nodetype = Util.null2String(request.getParameter("nodetype"));


Hashtable otherPara_hs1918 = new Hashtable();
try{
	//初始化财务相关流程必要信息
	new FnaCommon().loadWFLayoutToHtmlFnaInfo(formid, workflowid, requestid, otherPara_hs1918);
}catch(Exception ex1){
	new BaseBean().writeLog(ex1);
}

HashMap<String, String> _isEnableFnaWfHm = (HashMap<String, String>)otherPara_hs1918.get("_isEnableFnaWfHm_FnaCommon.getIsEnableFnaWfHm_workflowid="+workflowid+"__requestId="+requestid);
if(_isEnableFnaWfHm==null){
	_isEnableFnaWfHm = new HashMap<String, String>();
}
HashMap<String, String> fnaWfSetMap = (HashMap<String, String>)otherPara_hs1918.get("_isEnableFnaWfHm_fnaBudgetControl.getFnaWfFieldInfo4Expense_workflowid="+workflowid+"__requestId="+requestid);
if(fnaWfSetMap==null){
	fnaWfSetMap = new HashMap<String, String>();
}
HashMap<String, HashMap<String, String>> reqDataMap = (HashMap<String, HashMap<String, String>>)otherPara_hs1918.get("_isEnableFnaWfHm_FnaCommon.qryFnaExpenseRequestRecord_workflowid="+workflowid+"__requestId="+requestid);
if(reqDataMap==null){
	reqDataMap = new HashMap<String, HashMap<String, String>>();
}

%>

<!-- browser 相关 -->
<script type="text/javascript" src="/js/workflow/wfbrow_wev8.js"></script>
<script type="text/javascript">
window.__userid = '<%=request.getParameter("f_weaver_belongto_userid")%>';
window.__usertype = '<%=request.getParameter("f_weaver_belongto_usertype")%>';
</script>


<DIV>
<%if(canactive&&deleted==1){%>
<button type=button  class=btnFlow accessKey=A type=submit><U>A</U>-<%=SystemEnv.getHtmlLabelName(737,languageidfromrequest)%></button>
<%}%>
</DIV>
<%if(!isprint){%>
<BR>
<!--请求的标题开始 -->
<DIV align="center" style="margin-bottom:4px;">
<font style="font-size:14pt;FONT-WEIGHT: bold"><%=Util.toScreen(workflowname,languageidfromrequest)%></font>
</DIV>
<!--请求的标题结束 -->
<title><%=Util.toScreen(workflowname,languageidfromrequest)%></title>
<BR>
<%}%>
<%if (isprint) {%>
<!--打印的时候显示请求的标题  开始 -->
<DIV align="center" class="gen_printtitle">
<font style="font-size:14pt;FONT-WEIGHT: bold"><%=Util.toScreen(workflowname,languageidfromrequest)%></font>
</DIV>
<!--打印的时候显示请求的标题  结束 -->
<%}%>
<iframe id="fileDownload" frameborder=0 scrolling=no src=""  style="display:none"></iframe>
<TABLE class="ViewForm <%=isprint?"gen_printmain":"" %>">
  <COLGROUP>
  <COL width="20%">
  <COL width="80%">
  <%//xwj for td1834 on 2005-05-22
    String isEdit_ = "-1";
    RecordSet.executeSql("select isedit from workflow_nodeform where nodeid = " + String.valueOf(nodeid) + " and fieldid = -1");
    if(RecordSet.next()){
    isEdit_ = "-1";
    }
   
  %>

  <!--新建的第一行，包括说明和重要性 -->
  <TR class=spacing style="height:1px;">
    <TD class=line1 colSpan=2></TD>
  </TR>
  <TR>
    <td class="fieldnameClass">
     <%=SystemEnv.getHtmlLabelName(21192,languageidfromrequest)%>
    </TD>
    <td class=fieldvalueClass>
       
         <%if(!"1".equals(isEdit_)){//xwj for td1834 on 2005-05-22%>
       <%=Util.toScreenToEdit(requestname,languageidfromrequest)%>
       <input type=hidden name=requestname value="<%=Util.toScreenToEdit(requestname,languageidfromrequest)%>">
       <%}
       else{%>
        <input type=text class=Inputstyle  name=requestname onChange="checkinput('requestname','requestnamespan')" size=<%=RequestConstants.RequestName_Size%> maxlength=<%=RequestConstants.RequestName_MaxLength%>  value = "<%=Util.toScreenToEdit(requestname,languageidfromrequest)%>" >
        <span id=requestnamespan><%if("".equals(Util.toScreenToEdit(requestname,languageidfromrequest))){%><img src="/images/BacoError_wev8.gif" align=absmiddle><%}%></span>
       <%}%>
    
      &nbsp;&nbsp;&nbsp;&nbsp;
      <%if(requestlevel.equals("0")){%><%=SystemEnv.getHtmlLabelName(225,languageidfromrequest)%>
      <%} else if(requestlevel.equals("1")){%><%=SystemEnv.getHtmlLabelName(15533,languageidfromrequest)%>
      <%} else if(requestlevel.equals("2")){%><%=SystemEnv.getHtmlLabelName(2087,languageidfromrequest)%> <%}%>
     
     
    </TD>
  </TR>
    <TR style="height:1px;"><TD class=Line2 colSpan=2></TD></TR>
    	<%
    	int rqMessageType=-1;
    	int wfMessageType=-1;
			String sqlWfMessage = "select a.messagetype,b.docCategory,b.messagetype as wfMessageType from workflow_requestbase a,workflow_base b where a.workflowid=b.id and a.requestid="+requestid ;
			RecordSet.executeSql(sqlWfMessage);
			if (RecordSet.next()) {
				wfMessageType=RecordSet.getInt("wfMessageType");
				rqMessageType=RecordSet.getInt("messagetype");
			}
    
			//WFNodeFieldMainManager.resetParameter();
			//WFNodeFieldMainManager.setNodeid(nodeid);
			//WFNodeFieldMainManager.setFieldid(-3);//"是否短信提醒"字段在workflow_nodeform中的fieldid 定为 "-3"
			//WFNodeFieldMainManager.selectWfNodeField();
			//if(WFNodeFieldMainManager.getIsview().equals("1")){
			if(wfMessageType==1){
			%>
			<TR>
				<td class="fieldnameClass" > <%=SystemEnv.getHtmlLabelName(17586,languageidfromrequest)%></TD>
				<td class=fieldvalueClass>
					<%if(rqMessageType==0){%><%=SystemEnv.getHtmlLabelName(17583,languageidfromrequest)%><%}%>
		    	<%if(rqMessageType==1){%><%=SystemEnv.getHtmlLabelName(17584,languageidfromrequest)%><%}%>
		    	<%if(rqMessageType==2){%><%=SystemEnv.getHtmlLabelName(17585,languageidfromrequest)%><%}%>
		    </td>
	    </TR>
    	<TR style="height:1px;"><TD class=Line2 colSpan=2></TD></TR>
     	<%}
     	//}%>
     	<!-- 微信提醒(QC:98106) -->
     	<%
    	int rqChatsType=-1;
    	int wfChatsType=-1;
			String sqlWfChats = "select a.messagetype,a.chatstype,b.docCategory,b.messagetype as wfMessageType,b.chatstype as wfChatsType from workflow_requestbase a,workflow_base b where a.workflowid=b.id and a.requestid="+requestid ;
			RecordSet.executeSql(sqlWfChats);
			if (RecordSet.next()) {
				wfChatsType=RecordSet.getInt("wfChatsType");
				rqChatsType=RecordSet.getInt("chatstype");
			} 
			if(wfChatsType==1){
			%>
			<TR>
				<TD class="fieldnameClass"> <%=SystemEnv.getHtmlLabelName(32812,languageidfromrequest)%></TD>
				<td class="fieldvalueClass">
					<%if(rqChatsType==0){%><%=SystemEnv.getHtmlLabelName(19782,languageidfromrequest)%><%}%>
		    	<%if(rqChatsType==1){%><%=SystemEnv.getHtmlLabelName(26928,languageidfromrequest)%><%}%> 
		    </td>
	    </TR>
    	<TR style="height:1px;"><TD class=Line2 colSpan=2></TD></TR>
     	<%}
     	//}%>
  <!--第一行结束 -->

<%

//查询表单或者单据的字段,字段的名称，字段的HTML类型和字段的类型（基于HTML类型的一个扩展）

ArrayList fieldids=new ArrayList();             //字段队列
ArrayList fieldorders = new ArrayList();        //字段显示顺序队列 (单据文件不需要)
ArrayList languageids=new ArrayList();          //字段显示的语言(单据文件不需要)
ArrayList fieldlabels=new ArrayList();          //单据的字段的label队列
ArrayList fieldhtmltypes=new ArrayList();       //单据的字段的html type队列
ArrayList fieldtypes=new ArrayList();           //单据的字段的type队列
ArrayList fieldnames=new ArrayList();           //单据的字段的表字段名队列
ArrayList fieldvalues=new ArrayList();          //字段的值



ArrayList fieldviewtypes=new ArrayList();       //单据是否是detail表的字段1:是 0:否(如果是,将不显示)
ArrayList fielddbtypes=new ArrayList();       //单据是否是detail表的字段1:是 0:否(如果是,将不显示)
ArrayList fieldimgwidths=new ArrayList();
ArrayList fieldimgheights=new ArrayList();
ArrayList fieldimgnums=new ArrayList();
ArrayList fieldqfws = new ArrayList(); //字段的值



int qfws=0;
String isTextInForm = "";
RecordSet.executeSql("select * from workflow_createdoc where workflowid="+workflowid);	
 		if(RecordSet.next()){
 		  	isTextInForm = RecordSet.getString("isTextInForm");
 		}
String forbidAttDownload="";
RecordSet.execute("select forbidAttDownload from workflow_base where id="+workflowid);
if(RecordSet.next()){
   forbidAttDownload = Util.null2String(RecordSet.getString("forbidAttDownload"));
}

if(isbill.equals("0")) {
    RecordSet.executeSql("select t2.fieldid,t2.fieldorder,t1.fieldlable,t1.langurageid from workflow_fieldlable t1,workflow_formfield t2 where t1.formid=t2.formid and t1.fieldid=t2.fieldid and (t2.isdetail<>'1' or t2.isdetail is null) and   t1.langurageid="+languageidfromrequest+"   and t2.formid="+formid+" order by t2.fieldorder");

    while(RecordSet.next()){
        fieldids.add(Util.null2String(RecordSet.getString("fieldid")));
        fieldorders.add(Util.null2String(RecordSet.getString("fieldorder")));
        fieldlabels.add(Util.null2String(RecordSet.getString("fieldlable")));
        languageids.add(Util.null2String(RecordSet.getString("langurageid")));
    }
    /*
    RecordSet.executeProc("workflow_FieldID_Select",formid+"");

    while(RecordSet.next()){
        fieldids.add(Util.null2String(RecordSet.getString(1)));
        fieldorders.add(Util.null2String(RecordSet.getString(2)));
    }

    RecordSet.executeProc("workflow_FieldLabel_Select",formid+"");
    while(RecordSet.next()){
        fieldlabels.add(Util.null2String(RecordSet.getString("fieldlable")));
        languageids.add(Util.null2String(RecordSet.getString("languageid")));
    }
    */
}
else {
    RecordSet.executeProc("workflow_billfield_Select",formid+"");
    while(RecordSet.next()){
        fieldids.add(Util.null2String(RecordSet.getString("id")));
        fieldlabels.add(Util.null2String(RecordSet.getString("fieldlabel")));
        fieldhtmltypes.add(Util.null2String(RecordSet.getString("fieldhtmltype")));
        fieldtypes.add(Util.null2String(RecordSet.getString("type")));
        fieldnames.add(Util.null2String(RecordSet.getString("fieldname")));
        fieldviewtypes.add(Util.null2String(RecordSet.getString("viewtype")));
		fielddbtypes.add(Util.null2String(RecordSet.getString("fielddbtype")));
        fieldimgwidths.add(Util.null2String(RecordSet.getString("imgwidth")));
        fieldimgheights.add(Util.null2String(RecordSet.getString("imgheight")));
        fieldimgnums.add(Util.null2String(RecordSet.getString("textheight")));
        fieldqfws.add(Util.null2String(RecordSet.getString("qfws")));
    }
}

// 查询每一个字段的值



if( !isbill.equals("1")) {
    RecordSet.executeProc("workflow_FieldValue_Select",requestid+"");       // 从workflow_form表中查



    RecordSet.next();
    for(int i=0;i<fieldids.size();i++){
        String fieldname=FieldComInfo.getFieldname((String)fieldids.get(i));
        fieldvalues.add(Util.null2String(RecordSet.getString(fieldname)));
    }
}
else {
    RecordSet.executeSql("select tablename from workflow_bill where id = " + formid) ; // 查询工作流单据表的信息



    RecordSet.next();
    String tablename = RecordSet.getString("tablename") ;
    RecordSet.executeSql("select * from " + tablename + " where id = " + billid) ; // 对于默认的单据表,必须以id作为自增长的Primary key, billid的值就是id. 如果不是,则需要改写这个部分. 另外,默认的单据表必须有 requestid 的字段




    RecordSet.next();
    for(int i=0;i<fieldids.size();i++){
        String fieldname=(String)fieldnames.get(i);
        fieldvalues.add(Util.null2String(RecordSet.getString(fieldname)));
    }
}


// 确定字段是否显示
ArrayList isfieldids=new ArrayList();              //字段队列
ArrayList isviews=new ArrayList();              //字段是否显示队列

RecordSet.executeProc("workflow_FieldForm_Select",nodeid+"");

while(RecordSet.next()){
    isfieldids.add(Util.null2String(RecordSet.getString("fieldid")));
    isviews.add(RecordSet.getString("isview"));
}


// 得到每个字段的信息并在页面显示



if(intervenorright!=1){
for(int i=0;i<fieldids.size();i++){         // 循环开始



    int tmpindex = i ;
    if(isbill.equals("0")) tmpindex = fieldorders.indexOf(""+i);     // 如果是表单, 得到表单顺序对应的 i

    String fieldid=(String)fieldids.get(tmpindex);  //字段id

    if( isbill.equals("1")) {
        String viewtype = (String)fieldviewtypes.get(tmpindex) ;   // 如果是单据的从表字段,不显示



        if( viewtype.equals("1") ) continue ;
    }

    String isview="0" ;    //字段是否显示
    int isfieldidindex = isfieldids.indexOf(fieldid) ;
    if( isfieldidindex != -1 ) isview=(String)isviews.get(isfieldidindex);    //字段是否显示
    if( ! isview.equals("1") ) continue ;           //不显示即进行下一步循环




    String fieldname = "" ;                         //字段数据库表中的字段名



    String fieldhtmltype = "" ;                     //字段的页面类型



    String fieldtype = "" ;                         //字段的类型



    String fieldlable = "" ;                        //字段显示名



	String fielddbtype = "";
	int fieldimgwidth=0;                            //图片字段宽度
    int fieldimgheight=0;                           //图片字段高度
    int fieldimgnum=0;                              //每行显示图片个数
    int languageid = 0 ;

    if(isbill.equals("0")) {
        languageid= Util.getIntValue( (String)languageids.get(tmpindex), 0 ) ;    //需要更新



        fieldhtmltype=FieldComInfo.getFieldhtmltype(fieldid);
        fieldtype=FieldComInfo.getFieldType(fieldid);
        fieldlable=(String)fieldlabels.get(tmpindex);
        fieldname=FieldComInfo.getFieldname(fieldid);
		fielddbtype=FieldComInfo.getFielddbtype(fieldid);
		fieldimgwidth=FieldComInfo.getImgWidth(fieldid);
		fieldimgheight=FieldComInfo.getImgHeight(fieldid);
		fieldimgnum=FieldComInfo.getImgNumPreRow(fieldid);
    }
    else {
        languageid = languageidfromrequest ;
        fieldname=(String)fieldnames.get(tmpindex);
        fieldhtmltype=(String)fieldhtmltypes.get(tmpindex);
        fieldtype=(String)fieldtypes.get(tmpindex);
        fieldlable = SystemEnv.getHtmlLabelName( Util.getIntValue((String)fieldlabels.get(tmpindex),0),languageid );
		fielddbtype=(String)fielddbtypes.get(tmpindex);
		fieldimgwidth=Util.getIntValue((String)fieldimgwidths.get(tmpindex),0);
		fieldimgheight=Util.getIntValue((String)fieldimgheights.get(tmpindex),0);
		fieldimgnum=Util.getIntValue((String)fieldimgnums.get(tmpindex),0);
	    qfws=Util.getIntValue((String)fieldqfws.get(tmpindex),0);
    }

    String fieldvalue=(String)fieldvalues.get(tmpindex);

    // 下面开始逐行显示字段
%>
    <tr>
      <td class="fieldnameClass" <%if(fieldhtmltype.equals("2")){%> valign=top <%}%>> <%=Util.toScreen(fieldlable,languageid)%> </td>
      <td class=fieldvalueClass style="word-wrap:break-word;word-break:break-all;">
		
      <%
	 //add by dongping 
		//永乐要求在审批会议的流程中增加会议室报表链接，点击后在新窗口显示会议室报表



		if (fieldtype.equals("118")) { %>           
    <!-- modify by xhheng @20050304 for TD 1691 -->
    <%if(isprint==false){%>
			<a href="/meeting/report/MeetingRoomPlan.jsp" target=blank><%=SystemEnv.getHtmlLabelName(2193,languageidfromrequest)%></a>		
    <%}%>
		<% }
        if(fieldhtmltype.equals("1") || fieldhtmltype.equals("2") ){  // 单行,多行文本框

      /*------xwj for td3131 20051116 begin--------*/
      if(fieldhtmltype.equals("1") && fieldtype.equals("4")){
      %>
            <TABLE cols=2 id="field<%=fieldid%>_tab">
                <tr><td>
                    <script language="javascript">
                     window.document.write(milfloatFormat(floatFormat(<%=fieldvalue%>)));
                    </script>
                </td></tr>
                <tr><td>
                    <script language="javascript">
                     window.document.write(numberChangeToChinese(<%=fieldvalue%>));
                    </script>
                </td></tr>
            </table>
      <%}else{%>
<%
	          if(fieldhtmltype.equals("2") && fieldtype.equals("2")){
	        	if(isprint == true){
%>
       		  		<span style="word-wrap:break-word"><%=fieldvalue%></span>
<%
       		  	}else{
                  session.setAttribute("FCKEDDesc_"+requestid+"_"+userid+"_"+fieldid+"_-1",fieldvalue);
                  htmlfckfield_body.add("FCKiframe"+fieldid);
%>
<input type="hidden" id="FCKiframefieldid" value="FCKiframe<%=fieldid%>"/>
      <iframe id="FCKiframe<%=fieldid%>" name="FCKiframe<%=fieldid%>" src="/workflow/request/ShowFckEditorDesc.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>&requestid=<%=requestid%>&userid=<%=userid%>&fieldid=<%=fieldid%>&rowno=-1"  width="100%" height="100%" marginheight="0" marginwidth="0" allowTransparency="true" frameborder="0"></iframe>
<%
       		  	}
	          }else{
	          	String toPvalue = "";
							if(fieldtype.equals("5")){
								  if(isbill.equals("0")){
							        	RecordSet_nf2.executeSql("select * from workflow_formdict where id = " + fieldid);
										 if(RecordSet_nf2.next()){
										   qfws = Util.getIntValue(RecordSet_nf2.getString("qfws"),2);
										 }
									} 
							 
								if(qfws==1&&fieldvalue.length()>0){
									fieldvalue=fieldvalue.substring(0, (fieldvalue.indexOf(".")+qfws+1));
								}
							 
								if(fieldvalue.matches("-*\\d+\\.?\\d*")){	
									if(Math.round(Double.parseDouble(fieldvalue))!=Double.parseDouble(fieldvalue)){
											// update by liaodong for qc75759 in 2013年10月23日 start 
											  //NumberFormat formatter = new DecimalFormat("###,###"); 
											  NumberFormat formatter = new DecimalFormat("###,###.######");     
											//end 
											toPvalue = formatter.format(Double.parseDouble(fieldvalue))+""; 
											if(toPvalue.substring(0, toPvalue.indexOf(".")).equals("")){
											toPvalue = "0"+formatter.format(Double.parseDouble(fieldvalue))+""; 
											}					
									}else {
									  NumberFormat formatter = new DecimalFormat("###,###.######");					
								      toPvalue = formatter.format(Double.parseDouble(fieldvalue))+""; 
									}
										
								}else{
									  toPvalue = fieldvalue;
								}
								
							
								
							}else if(fieldtype.equals("3")){
								    int decimaldigits_t = 2;
								if (fieldtype.equals("3")) {
									int digitsIndex = fielddbtype.indexOf(",");
									if (digitsIndex > -1) {
										decimaldigits_t = Util.getIntValue(
												fielddbtype.substring(
														digitsIndex + 1,
														fielddbtype.length() - 1),
												2);
									} else {
										decimaldigits_t = 2;
									}
									fieldvalue = Util.toDecimalDigits(fieldvalue,decimaldigits_t);
								}
							}
%>
        <span id="field<%=fieldid%>span" style="word-break:break-all;word-wrap:break-word"><%=fieldvalue%></span>
<script>			
	var fieldfieldidspan = document.getElementById('field<%=fieldid%>span');
	var afieldFieldHtml = fieldfieldidspan.getElementsByTagName('a');
	for(var i=0;i<afieldFieldHtml.length;i++){
		afieldFieldHtml[i].target='_blank';
	}
</script>
<%
	          }
%>					
      <%}
      /*------xwj for td3131 20051116 end--------*/
        }                                                           // 单行,多行文本框条件结束



        else if(fieldhtmltype.equals("3")){                         // 浏览按钮 (涉及workflow_broswerurl表)
            String url=BrowserComInfo.getBrowserurl(fieldtype);     // 浏览按钮弹出页面的url
            String linkurl=BrowserComInfo.getLinkurl(fieldtype);    // 浏览值点击的时候链接的url
            String showname = "";                                                   // 值显示的名称
            String showid = "";                                                     // 值
    		
    		if("fieldIdOrgId_fieldId".equals(fnaWfSetMap.get(fieldid+"")) || "fieldIdOrgId2_fieldId".equals(fnaWfSetMap.get(fieldid+""))){				
    			HashMap<String, String> otherReturnVal = new HashMap<String, String>();
    			fieldtype = FnaCommon.getOrgBtnTypeByFnaFieldType(Util.getIntValue(fieldid), Util.getIntValue(fieldtype), 0, requestid, 
    				fnaWfSetMap, reqDataMap, 
    				user.getLanguage(), 
    				otherPara_hs1918, otherReturnVal)+"";
    			if(otherReturnVal.containsKey("newOrgIdDefValue")){
    				fieldvalue = Util.null2String(otherReturnVal.get("newOrgIdDefValue"));
    			}
    		}



            String tablename=""; //浏览框对应的表,比如人力资源表



             String columname=""; //浏览框对应的表名称字段



             String keycolumname="";   //浏览框对应的表值字段





            if(fieldtype.equals("2") || fieldtype.equals("19")){    // 日期和时间



      %>
        <%=fieldvalue%>
      <%
            } else if(!fieldvalue.equals("")) {
                ArrayList tempshowidlist=Util.TokenizerString(fieldvalue,",");
                if(fieldtype.equals("8") || fieldtype.equals("135")){
                    //项目，多项目
                    for(int k=0;k<tempshowidlist.size();k++){
                        if(!linkurl.equals("") && !isprint){
                            showname+="<a href='"+linkurl+tempshowidlist.get(k)+"&requestid="+requestid+"' target='_new'>"+ProjectInfoComInfo1.getProjectInfoname((String)tempshowidlist.get(k))+"</a>&nbsp";
                        }else{
                        showname+=ProjectInfoComInfo1.getProjectInfoname((String)tempshowidlist.get(k))+" ";
                        }
                    }
                }else if(fieldtype.equals("17")){//打印的时候还是按老样子显示



                    
                    weaver.workflow.request.WorkflowJspBean workflowJspBean2 = new weaver.workflow.request.WorkflowJspBean();
				  	workflowJspBean2.setRequestid(requestid);
                	StringBuffer sbf = new StringBuffer(fieldvalue);
                	showname=workflowJspBean2.getMultiResourceShowName(sbf, linkurl,fieldid,languageidfromrequest);
                	
                	String[]fieldvalarray = fieldvalue.split(",");
                	List<String> fieldvalList = new ArrayList<String>();
                	for (int z=0; z<fieldvalarray.length; z++) {
                	    if (!fieldvalList.contains(fieldvalarray[z])) {
                	        fieldvalList.add(fieldvalarray[z]);
                	    }
                	}
                	
                	boolean hasGroup = workflowJspBean2.isHasGroup();
                	if (fieldvalList.size() > 0 && hasGroup) {
                	  showname += "&nbsp;<span style='color:#bfbfc0;'>（"+SystemEnv.getHtmlLabelName(83698,user.getLanguage()) + fieldvalList.size() + SystemEnv.getHtmlLabelName(84097,user.getLanguage())+"）</span>";    
                	}
                	
                }else if(fieldtype.equals("1") ||fieldtype.equals("17")||fieldtype.equals("160")||fieldtype.equals("165")||fieldtype.equals("166")){
                    //人员，多人员
                    for(int k=0;k<tempshowidlist.size();k++){
                        if(!linkurl.equals("") && !isprint){
                        	if("/hrm/resource/HrmResource.jsp?id=".equals(linkurl)||"/hrm/hrmTab.jsp?_fromURL=HrmResource&id=".equals(linkurl)){
                        		showname+="<a href='javaScript:openhrm("+tempshowidlist.get(k)+");' onclick='pointerXY(event);'>"+ResourceComInfo.getResourcename((String)tempshowidlist.get(k))+"</a>&nbsp";
                          	}
                        	else
                            showname+="<a href='"+linkurl+tempshowidlist.get(k)+"' target='_new'>"+ResourceComInfo.getResourcename((String)tempshowidlist.get(k))+"</a>&nbsp";
                        }else{
                        showname+=ResourceComInfo.getResourcename((String)tempshowidlist.get(k))+" ";
                        }
                    }
                }
				else if(fieldtype.equals("161") || fieldtype.equals("162")){
                                                //自定义单选浏览框，自定义多选浏览框
												Browser browser=(Browser)StaticObj.getServiceByFullname(fielddbtype, Browser.class);
                                                for(int k=0;k<tempshowidlist.size();k++){
													try{
                                                        BrowserBean bb=browser.searchById(requestid+"^~^"+(String)tempshowidlist.get(k));
			                                            String desc=Util.null2String(bb.getDescription());
			                                            String name=Util.null2String(bb.getName());							
			                                            String href=Util.null2String(bb.getHref());
			                                            if(href.equals("")){
			                                            	showname+="<a title='"+desc+"'>"+name+"</a>&nbsp";
			                                            }else{
			                                            	showname+="<a title='"+desc+"' href='"+href+"' target='_blank'>"+name+"</a>&nbsp";
			                                            }
													}catch (Exception e){
													}
                                                }
                }else if(fieldtype.equals("256") ||fieldtype.equals("257")){//自定义树形单选



                	CustomTreeUtil customTreeUtil = new CustomTreeUtil();
					showid = fieldvalue;
					showname = customTreeUtil.getTreeFieldShowName(fieldvalue,fielddbtype);
					
				}else if(fieldtype.equals("269")){
                    
                	showname = Util.toScreen(MeetingBrowser.getRemindNames(fieldvalue, user.getLanguage()),user.getLanguage());
                    
                }else if(fieldtype.equals("142")){
                    //收发文单位



                    for(int k=0;k<tempshowidlist.size();k++){
                        if(!linkurl.equals("")){
                            showname+="<a href='"+linkurl+tempshowidlist.get(k)+"' target='_new'>"+docReceiveUnitComInfo_vba.getReceiveUnitName((String)tempshowidlist.get(k))+"</a>&nbsp";
                        }else{
                        showname+=docReceiveUnitComInfo_vba.getReceiveUnitName((String)tempshowidlist.get(k))+" ";
                        }
                    }
                }
				else if(fieldtype.equals("7") || fieldtype.equals("18")){
                    //客户，多客户
                    for(int k=0;k<tempshowidlist.size();k++){
                        if(!linkurl.equals("") && !isprint){
                            showname+="<a href='"+linkurl+tempshowidlist.get(k)+"&requestid="+requestid+"' target='_new'>"+CustomerInfoComInfo.getCustomerInfoname((String)tempshowidlist.get(k))+"</a>&nbsp";
                        }else{
                        showname+=CustomerInfoComInfo.getCustomerInfoname((String)tempshowidlist.get(k))+" ";
                        }
                    }
                }else if(fieldtype.equals("4") || fieldtype.equals("57")|| fieldtype.equals("167")|| fieldtype.equals("168")){
                    //部门，多部门
                    for(int k=0;k<tempshowidlist.size();k++){
                    	String showdeptname = "";
						String showdeptid = (String) tempshowidlist.get(k);
						if(!"".equals(showdeptid)){
							if(Integer.parseInt(showdeptid) < -1){
								showdeptname = deptVirComInfo.getDepartmentname(showdeptid);
							}else{
								showdeptname = DepartmentComInfo1.getDepartmentname(showdeptid);
							}
						}
                    
                        if(!linkurl.equals("") && !isprint){
                            showname+="<a href='"+linkurl+tempshowidlist.get(k)+"' target='_new'>"+showdeptname+"</a>&nbsp";
                        }else{
                        	showname+=showdeptname+" ";
                        }
                    }
                }else if(fieldtype.equals("164") || fieldtype.equals("194")){
                    //分部、多分部
                    for(int k=0;k<tempshowidlist.size();k++){
                 	    String showsubcompname = "";
						String showsubcompid = (String) tempshowidlist.get(k);
						if(!"".equals(showsubcompid)){
							if(Integer.parseInt(showsubcompid) < -1){
								showsubcompname = subCompVirComInfo.getSubCompanyname(showsubcompid);
							}else{
								showsubcompname = SubCompanyComInfo1.getSubCompanyname(showsubcompid);
							}
						}
                        if(!linkurl.equals("")){
                        		showname+="<a href='"+linkurl+tempshowidlist.get(k)+ "&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype+"' target='_new'>"+showsubcompname+"</a>&nbsp";
                        }else{
                        		showname+=showsubcompname+" ";
                        }
                    }
             	} else if(fieldtype.equals("9") || fieldtype.equals("37")){
                    //文档，多文档
                    for(int k=0;k<tempshowidlist.size();k++){
                        if (fieldtype.equals("9")&&docFlags.equals("1")&&!isprint)
                        {
                        //linkurl="WorkflowEditDoc.jsp?docId=";//????
                       String tempDoc=""+tempshowidlist.get(k);
                       showname+="<a href='javascript:createDoc("+fieldid+","+tempDoc+")' >"+DocComInfo1.getDocname((String)tempshowidlist.get(k))+"</a>&nbsp<button type=button  id='createdoc' style='display:none' class=AddDocFlow onclick=createDoc("+fieldid+","+tempDoc+")></button>";
                       
                        }
                        else
                        {
                        if(!linkurl.equals("") && !isprint){
                            //showname+="<a href='"+linkurl+tempshowidlist.get(k)+"' target='_new'>"+DocComInfo1.getDocname((String)tempshowidlist.get(k))+"</a>&nbsp";
                            showname+="<a href='"+linkurl+tempshowidlist.get(k)+"&requestid="+requestid+"&desrequestid="+desrequestid+"' target='_blank'>"+DocComInfo1.getDocname((String)tempshowidlist.get(k))+"</a>&nbsp";

                        }else{
                        showname+=DocComInfo1.getDocname((String)tempshowidlist.get(k))+" ";
                        }
                        }
                    }
                }else if(fieldtype.equals("23")){
                    //资产
                    for(int k=0;k<tempshowidlist.size();k++){
                        if(!linkurl.equals("") && !isprint){
                            showname+="<a href='"+linkurl+tempshowidlist.get(k)+"&requestid="+requestid+"' target='_new'>"+CapitalComInfo1.getCapitalname((String)tempshowidlist.get(k))+"</a>&nbsp";
                        }else{
                        showname+=CapitalComInfo1.getCapitalname((String)tempshowidlist.get(k))+" ";
                        }
                    }
                }else if(fieldtype.equals("16") || fieldtype.equals("152") || fieldtype.equals("171")){
                    //相关请求
                    for(int k=0;k<tempshowidlist.size();k++){
                        if(!linkurl.equals("") && !isprint){
                            int tempnum=Util.getIntValue(String.valueOf(session.getAttribute("slinkwfnum")));
                            tempnum++;
                            session.setAttribute("resrequestid"+tempnum,""+tempshowidlist.get(k));
                            session.setAttribute("slinkwfnum",""+tempnum);
                            session.setAttribute("haslinkworkflow","1");
                            showname+="<a href='"+linkurl+tempshowidlist.get(k)+"&wflinkno="+tempnum+"' target='_new'>"+WorkflowRequestComInfo1.getRequestName((String)tempshowidlist.get(k))+"</a>&nbsp";
                        }else{
                        showname+=WorkflowRequestComInfo1.getRequestName((String)tempshowidlist.get(k))+" ";
                        }
                    }
                }
//add by fanggsh for TD4528   20060621 begin
                else if(fieldtype.equals("141")){
                    //人力资源条件
                    ResourceConditionManager.setWorkflowid(workflowid);
					showname+=ResourceConditionManager.getFormShowName(fieldvalue,languageid);
                }
//add by fanggsh for TD4528   20060621 end
				//added by alan for td:10814
				else if(fieldtype.equals("142")) {
					//收发文单位



					 for(int k=0;k<tempshowidlist.size();k++){
						 if(!linkurl.equals("") && !isprint){
							 showname += "<a href='"+linkurl+tempshowidlist.get(k)+"' target='_new'>"+DocReceiveUnitComInfo.getReceiveUnitName(""+tempshowidlist.get(k))+"</a>&nbsp";
	                        }else{
	                            showname += DocReceiveUnitComInfo.getReceiveUnitName(""+tempshowidlist.get(k))+" ";
	                        }
					 }
				}
                //end by alan for td:10814
				else if(fieldtype.equals("224") || fieldtype.equals("225")|| fieldtype.equals("226") || fieldtype.equals("227")){
						//zzl
						showname+="<a title='"+fieldvalue+"'>"+fieldvalue+"</a>&nbsp";
				}else{
                    tablename=BrowserComInfo.getBrowsertablename(fieldtype); //浏览框对应的表,比如人力资源表



                    columname=BrowserComInfo.getBrowsercolumname(fieldtype); //浏览框对应的表名称字段



					 /*因为应聘库中(HrmCareerApply)的人员的firstname在新增时都为空，此处列名直接取上面查出来的(lastname+firstname)
					 会导致流程提交后应聘人不显示，所以此处做下特殊处理，只取应聘人的lastname	参考TD24866*/
					if(columname.equals("(lastname+firstname)"))
						columname = "lastname";
                    keycolumname=BrowserComInfo.getBrowserkeycolumname(fieldtype);   //浏览框对应的表值字段




                    if(fieldvalue.indexOf(",")!=-1){
                        sql= "select "+keycolumname+","+columname+" from "+tablename+" where "+keycolumname+" in( "+fieldvalue+")";
                    }
                    else {
                        sql= "select "+keycolumname+","+columname+" from "+tablename+" where "+keycolumname+"="+fieldvalue;
                    }
                    RecordSet.executeSql(sql);
                    while(RecordSet.next()){
					   if(fieldtype.equals("263")){
                             showname +=Util.toScreen(RecordSet.getString(2),languageidfromrequest)+" ";
					   }else{
                         if(!linkurl.equals("") && !isprint){
                            showname += "<a href='"+linkurl+RecordSet.getString(1)+"' target='_new'>"+Util.toScreen(RecordSet.getString(2),languageidfromrequest)+"</a>&nbsp";
                         }else{
                            showname +=Util.toScreen(RecordSet.getString(2),languageidfromrequest)+" ";
                         }
					   }
                    }    // end of while
                }
            %>
                    <%=showname%>
					<%if(fieldtype.equals("9")&&docFlags.equals("1")&&!isprint){
					if("1".equals(isTextInForm)){%>
					<div style="clear:both;height:650px;width:900px;overflow:hidden">
					<iframe id="ODocIframe" name="ODocIframe" src="/odoc/workflow/request/tableText.jsp?requestid=<%=requestid%>&workflowid=<%=workflowid%>&nodeid=<%=nodeid%>&formid=<%=formid%>" style="height:705px;width:99%">
					</iframe></div>
				<script>
					jQuery("#ODocIframe").parent().parent().parent().children(".fieldnameClass").css("vertical-align","top");
					jQuery("#ODocIframe").parent().parent().parent().children(".fieldnameClass").css("line-height","22px");
				</script>						
					<%}}%>
          <%
            }
        }                                                       // 浏览按钮条件结束
        else if(fieldhtmltype.equals("4")) {                    // check框



       %>
        <input notBeauty=true type=checkbox value=1 name="field<%=fieldid%>" DISABLED <%if(fieldvalue.equals("1")){%> checked <%}%>>
       <%
        }                                                       // check框条件结束



        else if(fieldhtmltype.equals("5")){                     // 选择框   select
       %>
         <select notBeauty=true name="field<%=fieldid%>" _printflag="1" DISABLED ><%
		   //如果是编辑状态就出现一个空白选项.不是编辑状态就是已办,办结等页面,不显示空白...
		if("1".equals(isEdit_)){%>
		<option value=""></option> <!--added by xwj for td3297 20051130 --> 
       <%}  else{ 
			//如果不是编辑状态,同时值还是空的,也显示一个空白选项.
			if("".equals(fieldvalue)){%>
			<option value=""></option><%
		}
		}
           if("1".equals(isEdit_))
            rs.executeProc("workflow_selectitembyid_new",""+fieldid+flag+isbill); 
			else
			 rs.executeProc("workflow_SelectItemSelectByid",""+fieldid+flag+isbill);  
            while(rs.next()){
                String tmpselectvalue = Util.null2String(rs.getString("selectvalue"));
                String tmpselectname = Util.toScreen(rs.getString("selectname"),languageidfromrequest);
       %>
        <option value="<%=tmpselectvalue%>"  <%if(fieldvalue.equals(tmpselectvalue)){%> selected <%}%>><%=tmpselectname%></option>
       <%
            }
       %>
        </select>
       <%
        //add by xhheng @20050318 for 附件上传
        }else if(fieldhtmltype.equals("6")){
        %>
          <%
		   fieldvalue = FileElement.delEmptyDicId(fieldvalue);
          if(!fieldvalue.equals("")) {
        	  boolean nodownloadnew = true;
       		  int AttachmentCountsnew = 0;
       		  int linknumnew= -1;  
          
          //modify by xhheng @20050512 for 1803
          %>
          <TABLE class=ListStyle style="border-collapse:collapse;border:0px;<% if(!isprint){%>width:400px;<%}%>" cols=3 id="field<%=fieldid%>_tab">
            <TBODY >
            <COL width="70%" >
            <COL width="17%" >
            <COL width="13%">
            <%
              
			  if("-2".equals(fieldvalue)){%>
			<tr>
				<td colSpan=3><font color="red">
				<%=SystemEnv.getHtmlLabelName(21710,languageidfromrequest)%></font>
				</td>
			</tr>
			  <%}else{
            sql="select id,docsubject,accessorycount,SecCategory from docdetail where id in("+fieldvalue+") order by id asc";
            int linknum=-1;
            boolean isfrist=false;
            int imgnum=fieldimgnum;
            RecordSet.executeSql(sql);
            int AttachmentCounts=RecordSet.getCounts();
            AttachmentCountsnew = AttachmentCounts;
            while(RecordSet.next()){
              isfrist=false;
              linknum++;
              String showid = Util.null2String(RecordSet.getString(1)) ;
              String tempshowname= Util.toScreen(RecordSet.getString(2),languageidfromrequest) ;
              int accessoryCount=RecordSet.getInt(3);
              String SecCategory=Util.null2String(RecordSet.getString(4));
              DocImageManager.resetParameter();
              DocImageManager.setDocid(Integer.parseInt(showid));
              DocImageManager.selectDocImageInfo();

              String docImagefileid = "";
              long docImagefileSize = 0;
              String docImagefilename = "";
              String fileExtendName = "";
              int versionId = 0;

              if(DocImageManager.next()){
                docImagefileid = DocImageManager.getImagefileid();
                docImagefileSize = DocImageManager.getImageFileSize(Util.getIntValue(docImagefileid));
                docImagefilename = DocImageManager.getImagefilename();
                fileExtendName = docImagefilename.substring(docImagefilename.lastIndexOf(".")+1).toLowerCase();
                versionId = DocImageManager.getVersionId();
              }
             if(accessoryCount>1){
               fileExtendName ="htm";
             }
              boolean nodownload=SecCategoryComInfo1.getNoDownload(SecCategory).equals("1")?true:false;
              nodownloadnew = nodownload;
              String imgSrc=AttachFileUtil.getImgStrbyExtendName(fileExtendName,20);
              if(fieldtype.equals("2")){
              if(linknum==0){
                  isfrist=true;
              %>
          <% 
           if(!"1".equals(forbidAttDownload) && !nodownload && AttachmentCounts>1 && linknum==0 && !isprint){
          %>
            <tr> 
              <td colSpan=3><nobr>
                  <button style="color:#123885;border:0px;line-height:20px;font-size:12px;padding:3px;background: #fff" type=button class=wffbtn accessKey=1  onclick="downloadsBatch('<%=fieldvalue%>','<%=requestid%>')">
                    [<%=SystemEnv.getHtmlLabelName(74,languageidfromrequest)+SystemEnv.getHtmlLabelName(332,languageidfromrequest)+SystemEnv.getHtmlLabelName(258,languageidfromrequest)%>]
                  </button>
              </td>
            </tr>
           <%}%> 
            <tr>
                <td colSpan=3>
                    <table cellpadding="0" cellspacing="0">
                        <tr>
              <%}
                  if(imgnum>0&&linknum>=imgnum){
                      imgnum+=fieldimgnum;
                      isfrist=true;
              %>
              </tr>
              <tr>
              <%
                  }
              %>
                  <input type=hidden name="field<%=fieldid%>_del_<%=linknum%>" value="0">
                  <input type=hidden name="field<%=fieldid%>_id_<%=linknum%>" value=<%=showid%>>
                  <td <%if(!isfrist){%>style="padding-left:15"<%}%>>
                     <table>
                      <tr>
                          <td align="center"><img src="/weaver/weaver.file.FileDownload?fileid=<%=docImagefileid%>&requestid=<%=requestid%>&desrequestid=<%=desrequestid%>" style="cursor:hand" alt="<%=docImagefilename%>" <%if(fieldimgwidth>0){%>width="<%=fieldimgwidth%>"<%}%> <%if(fieldimgheight>0){%>height="<%=fieldimgheight%>"<%}%> onclick="addDocReadTag('<%=showid%>');openAccessory('<%=docImagefileid%>')">
                          </td>
                      </tr>
                      <tr>
                              <%
                                  if (!nodownload && !isprint) {
                              %>
                              <td align="center"><nobr><a href="#" onmouseover="this.style.color='blue'" onclick="addDocReadTag('<%=showid%>');downloads('<%=docImagefileid%>');return false;" style="text-decoration:underline">[<span  style="cursor:hand;color:black;"><%=SystemEnv.getHtmlLabelName(258,languageidfromrequest)%></span>]</a></td>
                              <%}%>
                      </tr>
                        </table>
                    </td>
              <%}else{
              %>
              <tr style="border-bottom:1px solid #e6e6e6;height: 40px;">
              <td class="fieldvalueClass" valign="middle" style="word-break:normal;word-wrap:normal;">
              <div style="float:left;height:40px; line-height:38px;<% if(!isprint){%>width:270px;<%}%>" class="fieldClassChange">
              <div style="float:left;width:20px;height:40px; line-height:38px;">
              <span style="display:inline-block;vertical-align: middle;">
              <%=imgSrc%>
              </span>
              </div>
              <div style="float:left;">
              <%if(isprint){%>
              <span style="display:inline-block;<% if(!isprint){%>width:245px;<%}%>height:30px;padding-bottom:10px;vertical-align: middle;">
              <%=docImagefilename%>
              <%}else{ %>
              <span style="display:inline-block;width:245px;height:30px;padding-bottom:10px;overflow:hidden;white-space:nowrap;text-overflow:ellipsis;vertical-align: middle;">
	              <%if(accessoryCount==1 && (Util.isExt(fileExtendName)||fileExtendName.equalsIgnoreCase("pdf"))){
	            	// isAppendTypeField参数标识  当前字段类型是附件上传类型，不论该附件所在文档内容是否为空、或者存在最新版本，在该链接打开页面永远打开该附件内容、不显示该附件所在文档内容。



	              %>
	                <a style="cursor:pointer;color:#8b8b8b!important;margin-top:1px;" onmouseover="changefileaon(this)" onmouseout="changefileaout(this)" href="javascript:addDocReadTag('<%=showid%>');openFullWindowHaveBar('/docs/docs/DocDspExt.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>&id=<%=showid%>&versionId=<%=versionId%>&imagefileId=<%=docImagefileid%>&isFromAccessory=true&requestid=<%=requestid%>&desrequestid=<%=desrequestid%>&isAppendTypeField=1')" title="<%=docImagefilename%>"><%=docImagefilename%></a>&nbsp
	              <%}else{%>
	                <a style="cursor:pointer;color:#8b8b8b!important;margin-top:1px;" onmouseover="changefileaon(this)" onmouseout="changefileaout(this)" href="javascript:addDocReadTag('<%=showid%>');openAccessory('<%=docImagefileid%>')" title="<%=docImagefilename%>"><%=docImagefilename%></a>&nbsp
	              <%}
              }%>
              </span>
              </div>
              </div>
              </td>
              <%if(((!Util.isExt(fileExtendName))||!nodownload) && !isprint){%>
              <td >
               <div style="float:left;height:40px; line-height:38px;width:70px;padding-left:10px;" class="fieldClassChange">
                <span id = "selectDownload">
                <!-- 再次加一个nobr 标签 就可以 2012-08-27 ypc 修改 一行不该换行的元素换行 使用此标签 -->
                <nobr>
                		<span style="width:45px;display:inline-block;color:#898989;margin-top:1px;"><%=docImagefileSize / 1000%>K</span>
				  		<a style="display:inline-block;cursor:pointer;vertical-align:middle;width:20px;height:20px;background-image:url('/images/ecology8/workflow/fileupload/upload_wev8.png');" onclick="addDocReadTag('<%=showid%>');downloads('<%=docImagefileid%>')" title="<%=SystemEnv.getHtmlLabelName(31156,languageidfromrequest)%>"></a>
	                  <%-- 
	                  <button style="color:#123885;border:0px;line-height:20px;font-size:12px;padding:3px;background: #fff" type=button  class=wffbtn accessKey=1  onclick="addDocReadTag('<%=showid%>');top.location='/weaver/weaver.file.FileDownload?fileid=<%=docImagefileid%>&download=1&requestid=<%=requestid%>&desrequestid=<%=desrequestid%>&fromrequest=1'">
	                    [<U><%=linknum%></U>-<%=SystemEnv.getHtmlLabelName(258,languageidfromrequest)%>	(<%=docImagefileSize/1000%>K)]
	                  </button>--%>
                </nobr>
                </span>
                </div>
              </td>
              <%}%>
              <td>&nbsp;</td>
              </tr>
              
              <%}}
            linknumnew = linknum;
            if(fieldtype.equals("2")&&linknum>-1){%>
            </tr></table></td></tr>
            <%}}%>
            <%if(!isprint){ %>
            <tr>
            <td class="fieldvalueClass" valign="middle" colSpan=3> 
            	<% 
                   //if(isDownloadAll && AttachmentCounts>1 && (linknum+1)==AttachmentCounts){
                   if(!"1".equals(forbidAttDownload) && !nodownloadnew && AttachmentCountsnew>1 && linknumnew>=0){
                 %>
                 <span onclick="downloadsBatch('<%=fieldvalue%>','<%=requestid%>')" style="display:inline-block;height:25px;cursor:pointer;text-align:center;vertical-align:middle;line-height:25px;background-color: #6bcc44;color:#ffffff;padding:0 20px 0 14px;" onmouseover="uploadbuttonon(this)" onmouseout="uploadbuttonout(this)"><img src='/images/ecology8/workflow/fileupload/uploadall_wev8.png' style="width:20px;height:20px;padding-bottom:2px;" align=absMiddle><%=SystemEnv.getHtmlLabelName(332,languageidfromrequest)+SystemEnv.getHtmlLabelName(258,languageidfromrequest)%></span>
                 <%-- 
                 &nbsp;&nbsp;&nbsp;&nbsp;
                 <button style="color:#123885;border:0px;line-height:20px;font-size:12px;padding:3px;background: #fff" type=button class=wffbtn accessKey=1  onclick="top.location='/weaver/weaver.file.FileDownload?fieldvalue=<%=fieldvalue%>&download=1&downloadBatch=1&requestid=<%=requestid%>&fromrequest=1'">
                   [<%=SystemEnv.getHtmlLabelName(332,languageidfromrequest)+SystemEnv.getHtmlLabelName(258,languageidfromrequest)%>]
                 </button>--%>
                 <%}%>
	         </td>
            </tr>
            <%} %>
              </tbody>
              </table>
              <%
            }
        }     // 选择框条件结束 所有条件判定结束



       else if(fieldhtmltype.equals("7")){//特殊字段
           if(isbill.equals("0")) out.println(Util.null2String((String)specialfield.get(fieldid+"_0")));
           else out.println(Util.null2String((String)specialfield.get(fieldid+"_1")));
       }      
	   else if(fieldhtmltype.equals("9")){	//位置字段
			String locateData = LocateUtil.joinLoctionsField(workflowid,requestid,fieldname,fieldid,fieldvalue,user);

			String[] htmljs = locateData.split(LocateUtil.SPLIT_HTMLJS);
			out.println(htmljs[0]);
			out.println("<script language='javascript'>\n"+htmljs[1] + "</script>\n");
		}
       %>
      </td>
    </tr>
    <TR style="height:1px;"><TD class=Line2 colSpan=2></TD></TR>
<%
}       // 循环结束
}
%>

</TABLE>

<%
//add by mackjoe at 2006-06-07 td4491 有明细时才加载



boolean  hasdetailb=false;
if(!(isbill.equals("1")&&(formid==7||formid==156||formid==157||formid==158||formid==159))){
if(isbill.equals("0")) {
    RecordSet.executeSql("select count(*) from workflow_formfield  where isdetail='1' and formid="+formid);
}else{
    RecordSet.executeSql("select count(*) from workflow_billfield  where viewtype=1 and billid="+formid);
}
if(RecordSet.next()){
    if(RecordSet.getInt(1)>0) hasdetailb=true;
}
}
if(hasdetailb){
%>
<!--###########明细表单 Start##########-->
<%@ include file="/workflow/request/WorkflowViewRequestDetailBodyAction.jsp" %>
<!--###########明细表单 END########### -->
<%}%>
<script>

jQuery(document).ready(function () {
	var jeEles = jQuery("input[_printflag=1]");
	jeEles.each(function () {
		var jeEle = jQuery(this);
		var jeEleVal = jeEle.val();
		jeEle.hide();
		jeEle.after("<span>" + jeEleVal + "</span>");
		
	});
	
	jeEles = jQuery("select[_printflag=1]");
	jeEles.each(function () {
		var jeEle = jQuery(this);
		var jeOption = jeEle.children("[selected]")
		var jeEleVal = jeOption.text();
		jeEle.hide();
		jeEle.after("<span>" + jeEleVal + "</span>");
		
	});
});

function downloadsBatch(fieldvalue,requestid)
{ 
jQuery($GetEle("flowbody")).attr("onbeforeunload", "");
$G("fileDownload").src="/weaver/weaver.file.FileDownload?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&fieldvalue="+fieldvalue+"&download=1&downloadBatch=1&desrequestid=<%=desrequestid%>&requestid="+requestid;
}
function downloads(files){
	document.location.href="/weaver/weaver.file.FileDownload?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>&fileid="+files+"&download=1&requestid=<%=requestid%>&desrequestid=<%=desrequestid%>";
}

function createDoc(fieldbodyid,docVlaue)
{
	
   /*
   for(i=0;i<=1;i++){
  		parent.document.all("oTDtype_"+i).background="/images/tab2_wev8.png";
  		parent.document.all("oTDtype_"+i).className="cycleTD";
  	}
  	parent.document.all("oTDtype_1").background="/images/tab.active2_wev8.png";
  	parent.document.all("oTDtype_1").className="cycleTDCurrent";
  	*/
  	$GetEle("frmmain").action = "RequestDocView.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>&requestid=<%=requestid%>&docValue="+docVlaue;
  	$GetEle("frmmain").method.value = "crenew_"+fieldbodyid ;
  	$GetEle("frmmain").target="delzw";
    parent.delsave();
	if(check_form($GetEle("frmmain"),'requestname')){
      	if($GetEle("needoutprint")) $GetEle("needoutprint").value = "1";//标识点正文



      	$GetEle("frmmain").src.value='save';
        //附件上传
        StartUploadAll();
        checkuploadcomplet();
		parent.clicktext();//切换当前tab页到正文页面   
		if(document.getElementById("needoutprint")) document.getElementById("needoutprint").value = "";//标识点正文



    }


}

function uploadbuttonon(obj){
	var disabledflag = jQuery(obj).attr("disabled");
	if(!disabledflag){
		jQuery(obj).css("background-color","#52ab2f");
	}
}

function uploadbuttonout(obj){
	var disabledflag = jQuery(obj).attr("disabled");
	if(!disabledflag){
		jQuery(obj).css("background-color","#6bcc44");
	}
}

function changefileaon(obj){
	jQuery(obj).css("cssText","cursor:pointer;color:#008aff!important;text-decoration:underline!important;margin-top:1px;");
}

function changefileaout(obj){
	jQuery(obj).css("cssText","cursor:pointer;color:#8b8b8b!important;text-decoration:none!important;margin-top:1px;");
}

function openAccessory(fileId){ 
	openFullWindowHaveBar("/weaver/weaver.file.FileDownload?fileid="+fileId+"&requestid=<%=requestid%>&desrequestid=<%=desrequestid%>&fromrequest=1");
}
//** iframe自动适应页面 **//

function dyniframesize()
{
var dyniframe;
<%for (int i=0; i<htmlfckfield_body.size(); i++)
{%>
if (document.getElementById)
{
    //自动调整iframe高度
    dyniframe = document.getElementById("<%=htmlfckfield_body.get(i)%>");
    if (dyniframe && !window.opera)
    {
        if (dyniframe.contentDocument && dyniframe.contentDocument.body.offsetHeight){ //如果用户的浏览器是NetScape
            dyniframe.height = dyniframe.contentDocument.body.offsetHeight+20;
        }else if (dyniframe.Document && dyniframe.Document.body.scrollHeight){ //如果用户的浏览器是IE
            //alert(dyniframe.name+"|"+dyniframe.Document.body.scrollHeight);
            dyniframe.Document.body.bgColor="transparent";
            dyniframe.height = dyniframe.Document.body.scrollHeight+20;
        }
    }
}
<%}%>
<%if(fieldids.size()<1){%>
alert("<%=SystemEnv.getHtmlLabelName(22577,languageidfromrequest)%>");
<%}%>    
}
if (window.addEventListener)
window.addEventListener("load", dyniframesize, false);
else if (window.attachEvent)
window.attachEvent("onload", dyniframesize);
else
window.onload=dyniframesize;

jQuery(".wffbtn").mouseover(function(){
   jQuery(this).css("color","red");
}).mouseout(function(){
   jQuery(this).css("color","#123885");
});

//自动弹出打印
jQuery(document).ready(function(){
	<%if(isprint){%>
		//window.print();
	<%}%>
});
</script>
<input type=hidden name="desrequestid" value="<%=desrequestid%>">           <!--父流程id-->
<input type=hidden name="requestid" value="<%=requestid%>">           <!--请求id-->
<input type=hidden name="workflowid" value="<%=workflowid%>">       <!--工作流id-->
<input type=hidden name="nodeid" value="<%=nodeid%>">               <!--当前节点id-->
<input type=hidden name="nodetype" value="<%=nodetype%>">           <!--当前节点类型-->
<input type=hidden name="src" value="active">                       <!--操作类型 save和submit,reject,delete,active-->
<input type=hidden name="iscreate" value="0">                     <!--是否为创建节点 是:1 否 0 -->
<input type=hidden name="formid" value="<%=formid%>">               <!--表单的id-->
<input type=hidden name ="isbill" value="<%=isbill%>">            <!--是否单据 0:否 1:是-->
<input type=hidden name="billid" value="<%=billid%>">             <!--单据id-->

<input type=hidden name="rand" value="<%=System.currentTimeMillis()%>">
<input type=hidden name="needoutprint" value="">
<iframe name="delzw" width=0 height=0 style="border:none"></iframe>
