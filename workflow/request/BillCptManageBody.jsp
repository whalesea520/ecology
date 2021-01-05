
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.browserData.BrowserManager"%>
<%@ page import="weaver.workflow.request.RevisionConstants" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>
<%@ include file="/workflow/request/WorkflowManageRequestTitle.jsp" %>
<%@ page import="weaver.workflow.datainput.DynamicDataInput"%>
<%@ page import="weaver.interfaces.workflow.browser.Browser" %>
<%@ page import="weaver.interfaces.workflow.browser.BrowserBean" %>
<%@ page import="weaver.general.*" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="weaver.workflow.request.WFFreeFlowManager"%>
<jsp:useBean id="rscount" class="weaver.conn.RecordSet" scope="page"/> <!--xwj for @td2977 20051111-->
<jsp:useBean id="DocUtil" class="weaver.docs.docs.DocUtil" scope="page" />
<jsp:useBean id="RecordSet_nf1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rsaddop" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet_nf2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SecCategoryComInfo1" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="ProjectInfoComInfo1" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo1" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="DocComInfo1" class="weaver.docs.docs.DocComInfo" scope="page"/>
<jsp:useBean id="CapitalComInfo1" class="weaver.cpt.capital.CapitalComInfo" scope="page"/>
<jsp:useBean id="WorkflowRequestComInfo1" class="weaver.workflow.workflow.WorkflowRequestComInfo" scope="page"/>
<jsp:useBean id="RequestManager" class="weaver.workflow.request.RequestManager" scope="page"/>
<jsp:useBean id="ResourceConditionManager" class="weaver.workflow.request.ResourceConditionManager" scope="page"/>
<jsp:useBean id="SpecialField" class="weaver.workflow.field.SpecialFieldInfo" scope="page" />
<jsp:useBean id="WfLinkageInfo" class="weaver.workflow.workflow.WfLinkageInfo" scope="page"/>
<jsp:useBean id="WorkflowJspBean" class="weaver.workflow.request.WorkflowJspBean" scope="page"/>
<jsp:useBean id="BaseBean" class="weaver.general.BaseBean" scope="page"/>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
<%--
<script type="text/javascript" language="javascript" src="/FCKEditor/fckeditor_wev8.js"></script>
<script type="text/javascript" language="javascript" src="/FCKEditor/FCKEditorExt_wev8.js"></script>
 --%>
<link type="text/css" rel="stylesheet" href="/js/ecology8/weaverautocomplete/css/weaverautocomplete_wev8.css">
<!--签字意见-->
<link rel="stylesheet" type="text/css" href="/css/ecology8/workflowsign_wev8.css" />
<!-- browser 相关 -->
<script type="text/javascript" src="/js/workflow/wfbrow_wev8.js"></script>

<form name="frmmain" method="post" action="BillCptLossOperation.jsp" enctype="multipart/form-data">

<%
int languagebodyid = user.getLanguage() ;
HashMap specialfield = SpecialField.getFormSpecialField();//特殊字段的字段信息
ArrayList flowDocs=flowDoc.getDocFiled(""+workflowid); //得到流程建文挡的发文号字段
String codeField="";
if (flowDocs!=null&&flowDocs.size()>0)
{
codeField=""+flowDocs.get(0);
}
String docFlags=Util.null2String((String)session.getAttribute("requestAdd"+requestid));
String newTNflag=Util.null2String((String)session.getAttribute("requestAddNewNodes"+user.getUID()));
String flowDocField=Util.null2String((String)session.getAttribute("requestFlowDocField"+user.getUID()));
String bodychangattrstr="";
ArrayList managefckfields_billbody=new ArrayList();    
if (docFlags.equals("")) docFlags=Util.null2String((String)session.getAttribute("requestAdd"+user.getUID()));
%>
<!--请求的标题开始 -->
<div align="center">
<font style="font-size:14pt;FONT-WEIGHT: bold"><%=Util.toScreen(workflowname,user.getLanguage())%></font>
</div>
<title><%=Util.toScreen(workflowname,user.getLanguage())%></title>

<!--请求的标题结束 -->
<!--yl qc:67452 start-->
<iframe id="selectChange" frameborder=0 scrolling=no src=""  style="display:none"></iframe>
<!--yl qc:67452 end-->
<iframe id="datainputform" frameborder=0 scrolling=no src=""  style="display:none"></iframe>
<iframe id="workflowKeywordIframe" frameborder=0 scrolling=no src=""  style="display:none"></iframe>
<br>

<%
String isaffirmancebody=Util.null2String((String)session.getAttribute(user.getUID()+"_"+requestid+"isaffirmance"));//是否需要提交确认
String reEditbody=Util.null2String((String)session.getAttribute(user.getUID()+"_"+requestid+"reEdit"));//是否需要提交确认
// yl qc:67452 start
String selectInitJsStr = "";
String initIframeStr = "";
//yl qc:67452 end
int rqMessageType=-1;
int wfMessageType=-1;
String docCategory= "";
//String sqlWfMessage = "select a.messagetype,b.docCategory from workflow_requestbase a,workflow_base b where a.workflowid=b.id and a.requestid="+requestid ;
String sqlWfMessage = "select a.messagetype,b.docCategory,b.messagetype as wfMessageType from workflow_requestbase a,workflow_base b where a.workflowid=b.id and a.requestid="+requestid ;
RecordSet.executeSql(sqlWfMessage);
if (RecordSet.next()) {
    rqMessageType=RecordSet.getInt("messagetype");
    wfMessageType=RecordSet.getInt("wfMessageType");
	docCategory= RecordSet.getString("docCategory");
}
 int secid = Util.getIntValue(docCategory.substring(docCategory.lastIndexOf(",")+1),-1);
 int maxUploadImageSize = Util.getIntValue(SecCategoryComInfo1.getMaxUploadFileSize(""+secid),5); //从缓存中取
 if(maxUploadImageSize<=0){
 maxUploadImageSize = 5;
 }
 int uploadType = 0;
 String selectedfieldid = "";
 String result = RequestManager.getUpLoadTypeForSelect(workflowid);
 if(!result.equals("")){
 selectedfieldid = result.substring(0,result.indexOf(","));
 uploadType = Integer.valueOf(result.substring(result.indexOf(",")+1)).intValue();
 }
 boolean isCanuse = RequestManager.hasUsedType(workflowid);
 if(selectedfieldid.equals("") || selectedfieldid.equals("0")){
 	isCanuse = false;
 }

 String keywordismand="0";
String keywordisedit="0";
int titleFieldId=0;
int keywordFieldId=0;
RecordSet.execute("select titleFieldId,keywordFieldId from workflow_base where id="+workflowid);
if(RecordSet.next()){
	titleFieldId=Util.getIntValue(RecordSet.getString("titleFieldId"),0);
	keywordFieldId=Util.getIntValue(RecordSet.getString("keywordFieldId"),0);
}
ArrayList selfieldsadd=WfLinkageInfo.getSelectField(workflowid,nodeid,0);
ArrayList changefieldsadd=WfLinkageInfo.getChangeField(workflowid,nodeid,0);    
%>

<table class="ViewForm">
  <colgroup>
  <col width="20%">
  <col width="80%">

  <%//xwj for td1834 on 2005-05-22
    String isEdit_ = "-1";
    RecordSet.executeSql("select isedit from workflow_nodeform where nodeid = " + String.valueOf(nodeid) + " and fieldid = -1");
    if(RecordSet.next()){
   isEdit_ = Util.null2String(RecordSet.getString("isedit"));
    }

    //获得触发字段名 mackjoe 2005-07-22
    DynamicDataInput ddi=new DynamicDataInput(workflowid+"");
    String trrigerfield=ddi.GetEntryTriggerFieldName();

  %>

  <!--新建的第一行，包括说明和重要性 -->
  <tr class="Spacing" style="height:1px;">
    <td class="Line1" colSpan=2></td>
  </tr>
  <!--页面过大-->
<jsp:include page="WorkflowManageFirstRow.jsp" flush="true">
    <jsp:param name="nodeid" value="<%=nodeid%>" />
    <jsp:param name="isremark" value="<%=isremark%>" />
    <jsp:param name="nodetype" value="<%=nodetype%>" />
    <jsp:param name="isaffirmancebody" value="<%=isaffirmancebody%>" />
    <jsp:param name="reEditbody" value="<%=reEditbody%>" />
    <jsp:param name="requestid" value="<%=requestid%>" />
    <jsp:param name="requestlevel" value="<%=requestlevel%>" />
    <jsp:param name="rqMessageType" value="<%=rqMessageType%>" />
    <jsp:param name="wfMessageType" value="<%=wfMessageType%>" />
    <jsp:param name="isEdit_" value="<%=isEdit_%>" />
</jsp:include>
<input type="hidden" name="htmlfieldids">
<%

//查询表单或者单据的字段,字段的名称，字段的HTML类型和字段的类型（基于HTML类型的一个扩展）
newdocid =Util.null2String((String)session.getAttribute(userid+"_"+requestid+"newdocid"));
WorkflowJspBean.setBillid(billid);
WorkflowJspBean.setFormid(formid);
WorkflowJspBean.setIsbill(isbill);
WorkflowJspBean.setNodeid(nodeid);
WorkflowJspBean.setRequestid(requestid);
WorkflowJspBean.setUser(user);
WorkflowJspBean.setWorkflowid(workflowid);
WorkflowJspBean.getWorkflowFieldInfo();
ArrayList fieldids=WorkflowJspBean.getFieldids();             //字段队列
ArrayList fieldorders = WorkflowJspBean.getFieldorders();        //字段显示顺序队列 (单据文件不需要)
ArrayList languageids=WorkflowJspBean.getLanguageids();          //字段显示的语言(单据文件不需要)
ArrayList fieldlabels=WorkflowJspBean.getFieldlabels();          //单据的字段的label队列
ArrayList fieldhtmltypes=WorkflowJspBean.getFieldhtmltypes();       //单据的字段的html type队列
ArrayList fieldtypes=WorkflowJspBean.getFieldtypes();           //单据的字段的type队列
ArrayList fieldnames=WorkflowJspBean.getFieldnames();           //单据的字段的表字段名队列
ArrayList fieldvalues=WorkflowJspBean.getFieldvalues();          //字段的值
ArrayList fieldviewtypes=WorkflowJspBean.getFieldviewtypes();       //单据是否是detail表的字段1:是 0:否(如果是,将不显示)
ArrayList fieldimgwidths=WorkflowJspBean.getImgwidths();
ArrayList fieldimgheights=WorkflowJspBean.getImgheights();
ArrayList fieldimgnums=WorkflowJspBean.getImgnumprerows();
int fieldlen=0;  //字段类型长度
ArrayList fieldrealtype=WorkflowJspBean.getFieldrealtype();
String fielddbtype="";                              //字段数据类型
String textheight = "4";//xwj for @td2977 20051111
WorkflowJspBean.getWorkflowFieldViewAttr();

String bclick="";
String isbrowisMust = "";
// 确定字段是否显示，是否可以编辑，是否必须输入
ArrayList isfieldids=WorkflowJspBean.getIsfieldids();              //字段队列
ArrayList isviews=WorkflowJspBean.getIsviews();              //字段是否显示队列
ArrayList isedits=WorkflowJspBean.getIsedits();              //字段是否可以编辑队列
ArrayList ismands=WorkflowJspBean.getIsmands();              //字段是否必须输入队列

String losscountid="";
String beagenter=""+userid;
//获得被代理人
RecordSet.executeSql("select agentorbyagentid from workflow_currentoperator where usertype=0 and isremark='0' and requestid="+requestid+" and userid="+userid+" and nodeid="+nodeid+" order by id desc");
if(RecordSet.next()){
  int tembeagenter=RecordSet.getInt(1);
  if(tembeagenter>0) beagenter=""+tembeagenter;
}

// 得到每个字段的信息并在页面显示
String fieldnametemp="";
int tmpindextemp=0;
String fieldidtemp="";
for(int jj=0;jj<fieldids.size();jj++){  
  tmpindextemp= jj ;
   fieldidtemp=(String)fieldids.get(tmpindextemp);  //字段id
   fieldnametemp=(String)fieldnames.get(tmpindextemp);

if (fieldnametemp.equals("losscount"))  
	{losscountid=fieldidtemp;
     break;
	}
}
for(int i=0;i<fieldids.size();i++){         // 循环开始
	int tmpindex = i ;
    if(isbill.equals("0")) tmpindex = fieldorders.indexOf(""+i);     // 如果是表单, 得到表单顺序对应的 i

	String fieldid=(String)fieldids.get(tmpindex);  //字段id

    if( isbill.equals("1")) {
        String viewtype = (String)fieldviewtypes.get(tmpindex) ;   // 如果是单据的从表字段,不显示
        if( viewtype.equals("1") ) continue ;
    }

    String isview="0" ;    //字段是否显示
	String isedit="0" ;    //字段是否可以编辑
	String ismand="0" ;    //字段是否必须输入

    int isfieldidindex = isfieldids.indexOf(fieldid) ;
    if( isfieldidindex != -1 ) {
        isview=(String)isviews.get(isfieldidindex);    //字段是否显示
	    isedit=(String)isedits.get(isfieldidindex);    //字段是否可以编辑
	    ismand=(String)ismands.get(isfieldidindex);    //字段是否必须输入
    }
if(isremark==5 || isremark==9){
    isedit = "0";//抄送(需提交)不可编辑
    ismand="0";
}

//当自由流程设置当前节点的表单不可以编辑时，则全部表单字段都禁止编辑
if( !WFFreeFlowManager.allowFormEdit(requestid, nodeid) ){
    isedit = "0";
}

if ("1".equals(isedit)) {
    isbrowisMust = "1";
}

if ("1".equals(ismand)) {
    isbrowisMust = "2";
}

    String fieldname = "" ;                         //字段数据库表中的字段名
    String fieldhtmltype = "" ;                     //字段的页面类型
    String fieldtype = "" ;                         //字段的类型
    String fieldlable = "" ;                        //字段显示名
    int languageid = 0 ;
    int fieldimgwidth=0;                            //图片字段宽度
    int fieldimgheight=0;                           //图片字段高度
    int fieldimgnum=0;                              //每行显示图片个数

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
        languageid = user.getLanguage() ;
        fieldname=(String)fieldnames.get(tmpindex);
        fieldhtmltype=(String)fieldhtmltypes.get(tmpindex);
        fieldtype=(String)fieldtypes.get(tmpindex);
		fielddbtype=(String)fieldrealtype.get(tmpindex);
        fieldlable = SystemEnv.getHtmlLabelName( Util.getIntValue((String)fieldlabels.get(tmpindex),0),languageid );
        fieldimgwidth=Util.getIntValue((String)fieldimgwidths.get(tmpindex),0);
		fieldimgheight=Util.getIntValue((String)fieldimgheights.get(tmpindex),0);
		fieldimgnum=Util.getIntValue((String)fieldimgnums.get(tmpindex),0);
		
    }

    String fieldvalue=(String)fieldvalues.get(tmpindex);

	 fieldlen=0;
	if ((fielddbtype.toLowerCase()).indexOf("varchar")>-1)
	{
	   fieldlen=Util.getIntValue(fielddbtype.substring(fielddbtype.indexOf("(")+1,fielddbtype.length()-1));

	}
    if(fieldname.equals("manager")) {
	    String tmpmanagerid = ResourceComInfo.getManagerID(beagenter);
%>
	<input type=hidden name="field<%=fieldid%>" value="<%=tmpmanagerid%>">
<%
    if(isview.equals("1")){
%> <tr>
      <td <%if(fieldhtmltype.equals("2")){%> valign=top <%}%>> <%=Util.toScreen(fieldlable,languageid)%></td>
      <td class=field style="TEXT-VALIGN: center"><%=ResourceComInfo.getLastname(tmpmanagerid)%></td>
   </tr><tr style="height:1px;"><td class=Line2 colSpan=2></td></tr>
<%
    }
	    continue;
	}

	if(fieldname.equals("begindate")) newfromdate="field"+fieldid;      //开始日期,主要为开始日期不大于结束日期进行比较
	if(fieldname.equals("enddate")) newenddate="field"+fieldid;     //结束日期,主要为开始日期不大于结束日期进行比较
    if(fieldhtmltype.equals("3") && fieldvalue.equals("0")) fieldvalue = "" ;
	if((""+keywordFieldId).equals(fieldid)) keywordismand=ismand;
	if((""+keywordFieldId).equals(fieldid)) keywordisedit=isedit;     

    if(ismand.equals("1")&&!fieldid.equals(codeField))  needcheck+=",field"+fieldid;   //如果必须输入,加入必须输入的检查中

    // 下面开始逐行显示字段

    if(isview.equals("1")){         // 字段需要显示
%>
    <tr>
      <td <%if(fieldhtmltype.equals("2")){%> valign=top <%}%>> <%=Util.toScreen(fieldlable,languageid)%></td>
      <td class=fieldvalueClass style="word-wrap:break-word;word-break:break-all;TEXT-VALIGN: center">
      <%
        if(fieldhtmltype.equals("1")){                          // 单行文本框
            if(fieldtype.equals("1")){                          // 单行文本框中的文本
                if(isedit.equals("1") && isremark==0&&!fieldid.equals(codeField) && (!isaffirmancebody.equals("1") || !nodetype.equals("0") || reEditbody.equals("1"))){
					if(keywordFieldId>0&&(""+keywordFieldId).equals(fieldid)){
%>
<button class=Browser  onclick="onShowKeyword(field<%=fieldid%>.getAttribute('viewtype'))" title="<%=SystemEnv.getHtmlLabelName(21517,user.getLanguage())%>"></button>
<%
					}
                    if(ismand.equals("1")) {
      %>
        <input datatype="text" viewtype="<%=ismand%>" type=text class=Inputstyle name="field<%=fieldid%>" temptitle="<%=Util.toScreen(fieldlable,languageid)%>" size=50 value="<%=Util.toScreenForWorkflow(fieldvalue)%>" <%if(trrigerfield.indexOf("field"+fieldid)>=0){%> onBlur="datainput('field<%=fieldid%>');" <%}%> onChange="checkinput2('field<%=fieldid%>','field<%=fieldid%>span',this.getAttribute('viewtype'));checkLength('field<%=fieldid%>','<%=fieldlen%>','<%=Util.toScreen(fieldlable,languageid)%>','<%=SystemEnv.getHtmlLabelName(20246,user.getLanguage())%>','<%=SystemEnv.getHtmlLabelName(20247,user.getLanguage())%>')<%if(titleFieldId>0&&keywordFieldId>0&&(""+titleFieldId).equals(fieldid)){%>;changeKeyword()<%}%>">
        <span id="field<%=fieldid%>span"><% if(fieldvalue.equals("")){%><img src="/images/BacoError_wev8.gif" align=absmiddle><%}%></span>
      <%

				    }else{%>
        <input datatype="text" viewtype="<%=ismand%>" temptitle="<%=Util.toScreen(fieldlable,languageid)%>" onChange="checkinput2('field<%=fieldid%>','field<%=fieldid%>span',this.getAttribute('viewtype'));checkLength('field<%=fieldid%>','<%=fieldlen%>','<%=Util.toScreen(fieldlable,languageid)%>','<%=SystemEnv.getHtmlLabelName(20246,user.getLanguage())%>','<%=SystemEnv.getHtmlLabelName(20247,user.getLanguage())%>')<%if(titleFieldId>0&&keywordFieldId>0&&(""+titleFieldId).equals(fieldid)){%>;changeKeyword()<%}%>" type=text class=Inputstyle name="field<%=fieldid%>" <%if(trrigerfield.indexOf("field"+fieldid)>=0){%> onBlur="datainput('field<%=fieldid%>');" <%}%> value="<%=Util.toScreenForWorkflow(fieldvalue)%>" size=50>
        <span id="field<%=fieldid%>span"></span>
      <%            }
			    }
                else {
      %>
        <span id="field<%=fieldid%>span"><%=Util.toScreenForWorkflow(fieldvalue)%></span>
         <input type=hidden class=Inputstyle name="field<%=fieldid%>" value="<%=Util.toScreenForWorkflow(fieldvalue)%>" >
      <%
                }
                if(changefieldsadd.indexOf(fieldid)>=0){
%>
    <input type=hidden name="oldfieldview<%=fieldid%>" value="<%=Util.getIntValue(isview,0)+Util.getIntValue(isedit,0)+Util.getIntValue(ismand,0)%>" />
<%
    }
            }
		    else if(fieldtype.equals("2")){                     // 单行文本框中的整型
			    if(isedit.equals("1") && isremark==0 && (!isaffirmancebody.equals("1") || !nodetype.equals("0") || reEditbody.equals("1"))){
				    if(ismand.equals("1")) {
      %>
        <input datatype="int" viewtype="<%=ismand%>" type=text class=Inputstyle name="field<%=fieldid%>" temptitle="<%=Util.toScreen(fieldlable,languageid)%>" size=10 value="<%=fieldvalue%>"
		onKeyPress="ItemCount_KeyPress()" <%if(trrigerfield.indexOf("field"+fieldid)>=0){%>  onBlur="checkcount1(this);checkinput2('field<%=fieldid%>','field<%=fieldid%>span',this.getAttribute('viewtype'));datainput('field<%=fieldid%>')" <%}else{%> onBlur="checkcount1(this);checkinput2('field<%=fieldid%>','field<%=fieldid%>span',this.getAttribute('viewtype'))" <%}%>>
        <span id="field<%=fieldid%>span"><% if(fieldvalue.equals("")){%><img src="/images/BacoError_wev8.gif" align=absmiddle><%}%></span>
       <%

				    }else{%>
        <input datatype="int" viewtype="<%=ismand%>" temptitle="<%=Util.toScreen(fieldlable,languageid)%>" type=text class=Inputstyle name="field<%=fieldid%>" size=10 value="<%=fieldvalue%>" onKeyPress="ItemCount_KeyPress()"  <%if(trrigerfield.indexOf("field"+fieldid)>=0){%>  onBlur="checkcount1(this);checkinput2('field<%=fieldid%>','field<%=fieldid%>span',this.getAttribute('viewtype'));datainput('field<%=fieldid%>')" <%}else{%> onBlur="checkcount1(this);checkinput2('field<%=fieldid%>','field<%=fieldid%>span',this.getAttribute('viewtype'));" <%}%>>
        <span id="field<%=fieldid%>span"></span>
       <%           }
        if(changefieldsadd.indexOf(fieldid)>=0){
%>
    <input type=hidden name="oldfieldview<%=fieldid%>" value="<%=Util.getIntValue(isview,0)+Util.getIntValue(isedit,0)+Util.getIntValue(ismand,0)%>" />
<%
    }
			    }
                else {
      %>
        <span id="field<%=fieldid%>span"><%=fieldvalue%></span>
         <input datatype="int" type=hidden class=Inputstyle name="field<%=fieldid%>" value="<%=fieldvalue%>" >
      <%
                }
		    }
		    else if(fieldtype.equals("3")||fieldtype.equals("5")){                     // 单行文本框中的浮点型
			    if(isedit.equals("1") && isremark==0 && (!isaffirmancebody.equals("1") || !nodetype.equals("0") || reEditbody.equals("1"))){
				    if(ismand.equals("1")) {
       %>
        <input datatype="float" viewtype="<%=ismand%>" type=text class=Inputstyle name="field<%=fieldid%>" temptitle="<%=Util.toScreen(fieldlable,languageid)%>" size=20 value="<%=fieldvalue%>"
       onKeyPress="ItemNum_KeyPress('field<%=fieldid%>')" <%if(fieldtype.equals("5")){%>onfocus="changeToNormalFormat('field<%=fieldid%>')"<%}%> <%if(fieldname.equals("losscount")){%>  onBlur="checknumber1(this);checkinput2('field<%=fieldid%>','field<%=fieldid%>span',this.getAttribute('viewtype'));checkCountCpt('field<%=fieldid%>','capitalcount');<%if(fieldtype.equals("5")){%>changeToThousands('field<%=fieldid%>')<%}%>" <%}else{%> onBlur="checknumber1(this);checkinput2('field<%=fieldid%>','field<%=fieldid%>span',this.getAttribute('viewtype'));<%if(fieldtype.equals("5")){%>changeToThousands('field<%=fieldid%>')<%}%>" <%}%>>
        <span id="field<%=fieldid%>span"><% if(fieldvalue.equals("")){%><img src="/images/BacoError_wev8.gif" align=absmiddle><%}%></span>
       <%
    				}else{%>
        <input datatype="float" viewtype="<%=ismand%>" temptitle="<%=Util.toScreen(fieldlable,languageid)%>" type=text class=Inputstyle name="field<%=fieldid%>" size=20 value="<%=fieldvalue%>" onKeyPress="ItemNum_KeyPress('field<%=fieldid%>')" <%if(fieldtype.equals("5")){%>onfocus="changeToNormalFormat('field<%=fieldid%>')"<%}%> <%if(fieldname.equals("losscount")){%>  onBlur="checknumber1(this);checkinput2('field<%=fieldid%>','field<%=fieldid%>span',this.getAttribute('viewtype'));checkCountCpt('field<%=fieldid%>','capitalcount');<%if(fieldtype.equals("5")){%>changeToThousands('field<%=fieldid%>')<%}%>" <%}else{%> onBlur="checknumber1(this);checkinput2('field<%=fieldid%>','field<%=fieldid%>span',this.getAttribute('viewtype'));<%if(fieldtype.equals("5")){%>changeToThousands('field<%=fieldid%>')<%}%>" <%}%>>
        <span id="field<%=fieldid%>span"></span>
       <%           }
       if(changefieldsadd.indexOf(fieldid)>=0){
%>
    <input type=hidden name="oldfieldview<%=fieldid%>" value="<%=Util.getIntValue(isview,0)+Util.getIntValue(isedit,0)+Util.getIntValue(ismand,0)%>" />
<%
    }
			    }
                else {
      %>
        <span id="field<%=fieldid%>span"><%=fieldvalue%></span>
         <input datatype="float" type=hidden class=Inputstyle name="field<%=fieldid%>" value="<%=fieldvalue%>" >
      <%
                }
		    }
		    /*------------- xwj for td3131 20051116 begin----------*/
    else if(fieldtype.equals("4")){     // 单行文本框中的金额转换%>
            <table cols=2 id="field<%=fieldid%>_tab">
                <tr><td>
                <%
                    if(isedit.equals("1") && isremark==0 && (!isaffirmancebody.equals("1") || !nodetype.equals("0") || reEditbody.equals("1"))){
                    if(ismand.equals("1")) {%>
                        <input datatype="float" type=text class=Inputstyle name="field_lable<%=fieldid%>" temptitle="<%=Util.toScreen(fieldlable,languageid)%>" size=60
                            onfocus="FormatToNumber('<%=fieldid%>')"
                            onKeyPress="ItemNum_KeyPress('field_lable<%=fieldid%>')"
                            <%if(trrigerfield.indexOf("field"+fieldid)>=0){%>
                                onBlur="numberToFormat('<%=fieldid%>');
                                checkinput2('field_lable<%=fieldid%>','field_lable<%=fieldid%>span',field<%=fieldid%>.getAttribute('viewtype'));
                                datainput('field_lable<%=fieldid%>')"
                            <%}else{%>
                                onBlur="numberToFormat('<%=fieldid%>');
                                checkinput2('field_lable<%=fieldid%>','field_lable<%=fieldid%>span',field<%=fieldid%>.getAttribute('viewtype'))"
                            <%}%>
                        >
                    <span id="field_lable<%=fieldid%>span"><%if(fieldvalue.equals("")){%><img src="/images/BacoError_wev8.gif" align=absmiddle><%}%></span>
                    <%}else{%>
                        <input datatype="float" type=text class=Inputstyle name="field_lable<%=fieldid%>" size=60
                            onKeyPress="ItemNum_KeyPress('field_lable<%=fieldid%>')"
                            onfocus="FormatToNumber('<%=fieldid%>')"
                            <%if(trrigerfield.indexOf("field"+fieldid)>=0){%>
                                onBlur="numberToFormat('<%=fieldid%>');checkinput2('field_lable<%=fieldid%>','field_lable<%=fieldid%>span',field<%=fieldid%>.getAttribute('viewtype'));datainput('field_lable<%=fieldid%>')"
                            <%}else{%>
                                onBlur="numberToFormat('<%=fieldid%>');checkinput2('field_lable<%=fieldid%>','field_lable<%=fieldid%>span',field<%=fieldid%>.getAttribute('viewtype'))"
                            <%}%>
                        >
                    <%}%>
                    <span id="field<%=fieldid%>span"></span>
                    <input datatype="float" viewtype="<%=ismand%>" temptitle="<%=Util.toScreen(fieldlable,languageid)%>" type=hidden class=Inputstyle name="field<%=fieldid%>" value="<%=fieldvalue%>" >
                <%
                  if(changefieldsadd.indexOf(fieldid)>=0){
                %>
                    <input type=hidden name="oldfieldview<%=fieldid%>" value="<%=Util.getIntValue(isview,0)+Util.getIntValue(isedit,0)+Util.getIntValue(ismand,0)%>" />
                <%
                    }
                }else{%>
                    <span id="field<%=fieldid%>span"></span>
                    <input datatype="float" type=text class=Inputstyle name="field_lable<%=fieldid%>"  disabled="true" size=60>
                    <input datatype="float" type=hidden class=Inputstyle name="field<%=fieldid%>" value="<%=fieldvalue%>" >
                <%}%>
                </td></tr>
                <tr><td>
                    <input type=text class=Inputstyle size=60 name="field_chinglish<%=fieldid%>" readOnly="true">
                </td></tr>
                <script language="javascript">
                    document.all("field_lable"+<%=fieldid%>).value  = milfloatFormat(floatFormat(<%=fieldvalue%>));
                    document.all("field_chinglish"+<%=fieldid%>).value = numberChangeToChinese(<%=fieldvalue%>);
                </script>
            </table>
	    <%}
		    /*------------- xwj for td3131 20051116 end ----------*/

		  }                                                       // 单行文本框条件结束
	    else if(fieldhtmltype.equals("2")){                     // 多行文本框
	    /*-----xwj for @td2977 20051111 begin-----*/
	    if(isbill.equals("0")){
			 rscount.executeSql("select textheight from workflow_formdict where id = " + fieldid);
			 if(rscount.next()){
			 textheight = rscount.getString("textheight");
			 }
			 }
			    /*-----xwj for @td2977 20051111 begin-----*/
		    if(isedit.equals("1") && isremark==0 && (!isaffirmancebody.equals("1") || !nodetype.equals("0") || reEditbody.equals("1"))){
			    if(ismand.equals("1")) {
       %>
        <textarea class=Inputstyle viewtype="<%=ismand%>" temptitle="<%=Util.toScreen(fieldlable,languageid)%>" name="field<%=fieldid%>"  <%if(trrigerfield.indexOf("field"+fieldid)>=0){%> onBlur="datainput('field<%=fieldid%>');" <%}%>  onChange="checkinput2('field<%=fieldid%>','field<%=fieldid%>span',this.getAttribute('viewtype'));checkLengthfortext('field<%=fieldid%>','<%=fieldlen%>','<%=Util.toScreen(fieldlable,languageid)%>','<%=SystemEnv.getHtmlLabelName(20246,user.getLanguage())%>','<%=SystemEnv.getHtmlLabelName(20247,user.getLanguage())%>')"
		rows="<%=textheight%>" cols="40" style="width:80%;word-break:break-all;word-wrap:break-word" ><%=fieldtype.equals("2")?Util.toHtmltextarea(Util.encodeAnd(fieldvalue)):Util.toScreenToEdit(fieldvalue,user.getLanguage())%></textarea><!--xwj for @td2977 20051111-->
        <span id="field<%=fieldid%>span"><% if(fieldvalue.equals("")){%><img src="/images/BacoError_wev8.gif" align=absmiddle><%}%></span>
       <%
			    }else{
       %>
      <textarea class=Inputstyle viewtype="<%=ismand%>" temptitle="<%=Util.toScreen(fieldlable,languageid)%>" name="field<%=fieldid%>" rows="<%=textheight%>" onchange="checkinput2('field<%=fieldid%>','field<%=fieldid%>span',this.getAttribute('viewtype'));checkLengthfortext('field<%=fieldid%>','<%=fieldlen%>','<%=Util.toScreen(fieldlable,languageid)%>','<%=SystemEnv.getHtmlLabelName(20246,user.getLanguage())%>','<%=SystemEnv.getHtmlLabelName(20247,user.getLanguage())%>')" cols="40" <%if(trrigerfield.indexOf("field"+fieldid)>=0){%> onBlur="datainput('field<%=fieldid%>');" <%}%> style="width:80%;word-break:break-all;word-wrap:break-word"><%=fieldtype.equals("2")?Util.toHtmltextarea(Util.encodeAnd(fieldvalue)):Util.toScreenToEdit(fieldvalue,user.getLanguage())%></textarea><!--xwj for @td2977 20051111-->
      <span id="field<%=fieldid%>span"></span>
	   <%       }%>
	   <script>document.getElementById("htmlfieldids").value += "field<%=fieldid%>;<%=Util.toScreen(fieldlable,languagebodyid)%>;<%=fieldtype%>,";</script>
       <%  if (fieldtype.equals("2")) {%>
		    <script>
			   function funcField<%=fieldid%>(){
			   	FCKEditorExt.initEditor('frmmain','field<%=fieldid%>',<%=user.getLanguage()%>,FCKEditorExt.NO_IMAGE);
				<%if(ismand.equals("1"))
					out.println("FCKEditorExt.checkText('field"+fieldid+"span');");%>
				    FCKEditorExt.toolbarExpand(false);
			   }
				
				if (window.addEventListener){
				    window.addEventListener("load", funcField<%=fieldid%>, false);
				}else if (window.attachEvent){
				    window.attachEvent("onload", funcField<%=fieldid%>);
				}else{
				    window.onload=funcField<%=fieldid%>;
				}
			</script>
			<%}
            if(changefieldsadd.indexOf(fieldid)>=0){
            %>
                <input type=hidden name="oldfieldview<%=fieldid%>" value="<%=Util.getIntValue(isview,0)+Util.getIntValue(isedit,0)+Util.getIntValue(ismand,0)%>" />
            <%
                }
            }else {if(fieldtype.equals("2")){
                session.setAttribute("FCKEDDesc_"+requestid+"_"+userid+"_"+fieldid+"_-1",fieldvalue);
                managefckfields_billbody.add("FCKiframe"+fieldid);
            %>
         <iframe id="FCKiframe<%=fieldid%>" name="FCKiframe<%=fieldid%>" src="/workflow/request/ShowFckEditorDesc.jsp?requestid=<%=requestid%>&userid=<%=userid%>&fieldid=<%=fieldid%>&rowno=-1"  width="100%" height="100%" marginheight="0" marginwidth="0" allowTransparency="true" frameborder="0"></iframe>
         <textarea name="field<%=fieldid%>" style="display:none"><%=Util.toHtmltextarea(Util.encodeAnd(fieldvalue))%></textarea>
<%
				}else{
%>
        <span id="field<%=fieldid%>span" style="word-break:break-all;word-wrap:break-word"><%=fieldvalue%></span>
         <textarea name="field<%=fieldid%>" style="display:none"><%=Util.toScreenToEdit(fieldvalue,user.getLanguage())%></textarea>
<%
				}
      %>

      <%
            }
	    }                                                           // 多行文本框条件结束
	    else if(fieldhtmltype.equals("3")){                         // 浏览按钮 (涉及workflow_broswerurl表)
            String url=BrowserComInfo.getBrowserurl(fieldtype);     // 浏览按钮弹出页面的url
            String linkurl =BrowserComInfo.getLinkurl(fieldtype);   // 浏览值点击的时候链接的url
            String showname = "";                                                   // 值显示的名称
            String showid = "";                                                     // 值
            String hiddenlinkvalue="";    

            // 如果是多文档, 需要判定是否有新加入的文档,如果有,需要加在原来的后面
            if( (fieldtype.equals("37")||(fieldtype.equals("9")&&docFlags.equals("1"))) && fieldid.equals(docfileid) && !newdocid.equals("")) {
                if( ! fieldvalue.equals("") ) fieldvalue += "," ;
               if (fieldtype.equals("9")&&docFlags.equals("1"))
               fieldvalue=newdocid ;
               else
               fieldvalue += newdocid ;
            }

            if(!fieldvalue.equals("")) {
                ArrayList tempshowidlist=Util.TokenizerString(fieldvalue,",");
                if(fieldtype.equals("9") || fieldtype.equals("37")){
                    //文档，多文档
                    for(int k=0;k<tempshowidlist.size();k++){

                          if (fieldtype.equals("9")&&docFlags.equals("1"))
                        {
                        //linkurl="WorkflowEditDoc.jsp?docId=";//????
                       String tempDoc=""+tempshowidlist.get(k);
                       String tempDocView="0";
					   if(isedit.equals("1") && isremark==0){
						   tempDocView="1";
					   }
                       showname+="<a href='javascript:createDoc("+fieldid+","+tempDoc+","+tempDocView+")' >"+DocComInfo1.getDocname((String)tempshowidlist.get(k))+"</a>&nbsp<button id='createdoc' style='display:none' class=AddDocFlow onclick=createDoc("+fieldid+","+tempDoc+","+tempDocView+")></button>";

                        }
                        else
                        {
                        if(!linkurl.equals("")){
                            showname+="<a href='"+linkurl+tempshowidlist.get(k)+"&requestid="+requestid+"' target='_blank'>"+DocComInfo1.getDocname((String)tempshowidlist.get(k))+"</a>&nbsp";
                        }else{
                        showname+=DocComInfo1.getDocname((String)tempshowidlist.get(k))+" ";
                        }
                        }
                    }
                }else if(fieldtype.equals("16") || fieldtype.equals("152") || fieldtype.equals("171")){
                    //相关请求
                    for(int k=0;k<tempshowidlist.size();k++){
                        if(!linkurl.equals("")){
                            int tempnum=Util.getIntValue(String.valueOf(session.getAttribute("slinkwfnum")));
                            tempnum++;
                            session.setAttribute("resrequestid"+tempnum,""+tempshowidlist.get(k));
                            session.setAttribute("slinkwfnum",""+tempnum);
                            session.setAttribute("haslinkworkflow","1");
                            hiddenlinkvalue+="<input type=hidden name='slink"+fieldid+"_rq"+tempshowidlist.get(k)+"' value="+tempnum+">";
                            showname+="<a href='"+linkurl+tempshowidlist.get(k)+"&wflinkno="+tempnum+"' target='_new'>"+WorkflowRequestComInfo1.getRequestName((String)tempshowidlist.get(k))+"</a>&nbsp";
                        }else{
                        showname+=WorkflowRequestComInfo1.getRequestName((String)tempshowidlist.get(k))+" ";
                        }
                    }
                }else{
                    showname=WorkflowJspBean.getWorkflowBrowserShowName(fieldvalue,fieldtype,linkurl,showid,fielddbtype);
                }
            }
            
            if(isedit.equals("1") && isremark==0 && (!isaffirmancebody.equals("1") || !nodetype.equals("0") || reEditbody.equals("1"))){
//add by fanggsh 20060621 for TD4528 begin
               if(fieldtype.equals("160")){
                rsaddop.execute("select a.level_n from workflow_groupdetail a ,workflow_nodegroup b where a.groupid=b.id and a.type=50 and a.objid="+fieldid+" and b.nodeid in (select nodeid from workflow_flownode where workflowid="+workflowid+") ");
				String roleid="";
				if (rsaddop.next())

				{
				roleid=rsaddop.getString(1);
				}
				bclick = "onShowResourceRole('"+fieldid+"','"+url+"','"+linkurl+"','"+fieldtype+"',field"+fieldid+".getAttribute('viewtype'),'"+roleid+"')";
%>
<brow:browser viewType="0" name='<%="field"+fieldid%>' browserValue='<%=fieldvalue%>' browserSpanValue='<%=showname %>' browserOnClick='<%=bclick%>' hasInput="true" isSingle='<%=BrowserManager.browIsSingle(fieldtype)%>' hasBrowser = "true" isMustInput='<%=isbrowisMust %>' completeUrl='<%="javascript:getajaxurl(" + fieldtype + ")"%>' width="230px" needHidden="false" onPropertyChange='<%="wfbrowvaluechange(this," + fieldid + ")" %>'> </brow:browser>
<!--     
        <button class=Browser  onclick="onShowResourceRole('<%=fieldid%>','<%=url%>','<%=linkurl%>','<%=fieldtype%>',field<%=fieldid%>.getAttribute('viewtype'),'<%=roleid%>')" title="<%=SystemEnv.getHtmlLabelName(20570,user.getLanguage())%>"></button>
 -->            
<%
			  }
            else if(fieldtype.equals("161")||fieldtype.equals("162")){
             url+="?type="+fielddbtype;
             bclick = "onShowBrowser2('"+fieldid+"','"+url+"','"+linkurl+"','"+fieldtype+"',field"+fieldid+".viewtype);";
             if(trrigerfield.indexOf("field"+fieldid)>=0){
                 bclick += "datainput('field"+fieldid+"',field"+fieldid+".viewtype);";
             }
		    %>
		    <brow:browser viewType="0" name='<%="field"+fieldid%>' browserValue='<%=fieldvalue%>' browserSpanValue='<%=showname %>' browserOnClick='<%=bclick%>' hasInput="true" isSingle='<%=BrowserManager.browIsSingle(fieldtype)%>' hasBrowser = "true" isMustInput='<%=isbrowisMust %>' completeUrl='<%="javascript:getajaxurl(" + fieldtype + ")"%>' width="230px" needHidden="false" onPropertyChange='<%="wfbrowvaluechange(this," + fieldid + ")" %>'> </brow:browser>
		    <!-- <button class=Browser  onclick="onShowBrowser2('<%=fieldid%>','<%=url%>','<%=linkurl%>','<%=fieldtype%>',field<%=fieldid%>.getAttribute('viewtype'))" ></button> -->
		    <%
            }

			else if (fieldtype.equals("23"))  //资产
				{
				//System.out.println("showname:======="+showname);
				if(trrigerfield.indexOf("field"+fieldid)>=0){
			  	      bclick="onShowBrowser2('"+fieldid+"','"+url+"','"+linkurl+"','"+fieldtype+"','"+ismand+"');datainput('field"+fieldid+"');";
			  	   }else{
			  		  bclick="onShowBrowser2('"+fieldid+"','"+url+"','"+linkurl+"','"+fieldtype+"','"+ismand+"')";
			  	   }
				
				%>
				 <brow:browser viewType="0" name='<%="field"+fieldid%>' browserValue='<%=fieldvalue%>' browserSpanValue='<%=showname %>' browserOnClick='<%=bclick%>' hasInput="true" isSingle='<%=BrowserManager.browIsSingle(fieldtype)%>' hasBrowser = "true" isMustInput='<%=isbrowisMust %>' completeUrl='<%="javascript:getajaxurl(" + fieldtype + ")"%>' width="230px" needHidden="false" onPropertyChange='<%="wfbrowvaluechange(this," + fieldid + ")" %>'> </brow:browser>
				<!-- 
		        <button class=Browser  onclick="onShowCptCapital('<%=fieldid%>','<%=losscountid%>','capitalcount',field<%=fieldid%>.getAttribute('viewtype'))"></button>
				<input type='hidden' name='capitalcount' id='capitalcount'>	
				<input type='hidden' name='<%="field"+fieldid%>' id='<%="field"+fieldid%>' value="<%=fieldvalue %>" />	
				 -->	
				<%}
              else if(fieldtype.equals("141")){
            	  bclick = "onShowResourceConditionBrowser('"+fieldid+"','"+url+"','"+linkurl+"','"+fieldtype+"',field"+fieldid+".viewtype)";
%>
<brow:browser viewType="0" name='<%="field"+fieldid%>' browserValue='<%=fieldvalue%>' browserSpanValue='<%=showname %>' browserOnClick='<%=bclick%>' hasInput="true" isSingle='<%=BrowserManager.browIsSingle(fieldtype)%>' hasBrowser = "true" isMustInput='<%=isbrowisMust %>' completeUrl='<%="javascript:getajaxurl(" + fieldtype + ")"%>' width="230px" needHidden="false" onPropertyChange='<%="wfbrowvaluechange(this," + fieldid + ")" %>'> </brow:browser>
<!-- 
        <button class=Browser  onclick="onShowResourceConditionBrowser('<%=fieldid%>','<%=url%>','<%=linkurl%>','<%=fieldtype%>',field<%=fieldid%>.getAttribute('viewtype'))" title="<%=SystemEnv.getHtmlLabelName(172,user.getLanguage())%>"></button>
 -->        
<%
			  } else {
//add by fanggsh 20060621 for TD4528 end
                if( !fieldtype.equals("37") && !fieldtype.equals("9")) {    //  多文档特殊处理
                	
                	if(trrigerfield.indexOf("field"+fieldid)>=0){
					    bclick="onShowBrowser2('"+fieldid+"','"+url+"','"+linkurl+"','"+fieldtype+"',field"+fieldid+".getAttribute('viewtype'));datainput('field"+fieldid+"');";
					}else{
					    bclick="onShowBrowser2('"+fieldid+"','"+url+"','"+linkurl+"','"+fieldtype+"',field"+fieldid+".getAttribute('viewtype'))";
				    }
	   %>
	   
<!-- 	   
        <button class=Browser 
		<%if(trrigerfield.indexOf("field"+fieldid)>=0){%>      onclick="onShowBrowser2('<%=fieldid%>','<%=url%>','<%=linkurl%>','<%=fieldtype%>',field<%=fieldid%>.getAttribute('viewtype'));datainput('field<%=fieldid%>');"		
		<%}else{%>
		onclick="onShowBrowser2('<%=fieldid%>','<%=url%>','<%=linkurl%>','<%=fieldtype%>',field<%=fieldid%>.getAttribute('viewtype'))"
		<%}%> 
		title="<%=SystemEnv.getHtmlLabelName(172,user.getLanguage())%>">
		</button>
 -->			  
 		<brow:browser viewType="0" name='<%="field"+fieldid%>' browserValue='<%=fieldvalue%>' browserSpanValue='<%=showname %>' browserOnClick='<%=bclick%>' hasInput="true" isSingle='<%=BrowserManager.browIsSingle(fieldtype)%>' hasBrowser = "true" isMustInput='<%=isbrowisMust %>' completeUrl='<%="javascript:getajaxurl(" + fieldtype + ")"%>' width="230px" needHidden="false" onPropertyChange='<%="wfbrowvaluechange(this," + fieldid + ")" %>'> </brow:browser> 
       <%} else if(fieldtype.equals("37")){                         // 如果是多文档字段,加入新建文档按钮
    	   bclick = "onShowBrowser2('"+fieldid+"','"+url+"','"+linkurl+"','"+fieldtype+"',field"+fieldid+".viewtype)";
       %>
       <brow:browser viewType="0" name='<%="field"+fieldid%>' browserValue='<%=fieldvalue%>' browserSpanValue='<%=showname %>' browserOnClick='<%=bclick%>' hasInput="true" isSingle='<%=BrowserManager.browIsSingle(fieldtype)%>' hasBrowser = "true" isMustInput='<%=isbrowisMust %>' completeUrl='<%="javascript:getajaxurl(" + fieldtype + ")"%>' width="230px" needHidden="false" onPropertyChange='<%="wfbrowvaluechange(this," + fieldid + ")" %>'> </brow:browser>
       <!-- 
        <button class=AddDocFlow onclick="onShowBrowser2('<%=fieldid%>','<%=url%>','<%=linkurl%>','<%=fieldtype%>',field<%=fieldid%>.getAttribute('viewtype'))" > <%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></button>&nbsp;&nbsp;<button class=AddDocFlow onclick="onNewDoc(<%=fieldid%>)" title="<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%>"><%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%></button>
         -->
       <% }else if(fieldtype.equals("9")&&fieldid.equals(flowDocField)){
		     if(!"1".equals(newTNflag)){
		    	 
		    	 if(trrigerfield.indexOf("field"+fieldid)>=0){
		               	bclick="onShowBrowser2('"+fieldid+"','"+url+"','"+linkurl+"','"+fieldtype+"',field"+fieldid+".getAttribute('viewtype'));datainput('field"+fieldid+"');";
			  	   	}else{
			  		  	bclick="onShowBrowser2('"+fieldid+"','"+url+"','"+linkurl+"','"+fieldtype+"',field"+fieldid+".getAttribute('viewtype'))";
			  	   	}
	   %>
	   <brow:browser viewType="0" name='<%="field"+fieldid%>' browserValue='<%=fieldvalue%>' browserSpanValue='<%=showname %>' browserOnClick='<%=bclick%>' hasInput="true" isSingle='<%=BrowserManager.browIsSingle(fieldtype)%>' hasBrowser = "true" isMustInput='<%=isbrowisMust %>' completeUrl='<%="javascript:getajaxurl(" + fieldtype + ")"%>' width="230px" needHidden="false" onPropertyChange='<%="wfbrowvaluechange(this," + fieldid + ")" %>'> </brow:browser>
	   <!-- 
		<button class=Browser 
		<%if(trrigerfield.indexOf("field"+fieldid)>=0){%>      onclick="onShowBrowser2('<%=fieldid%>','<%=url%>','<%=linkurl%>','<%=fieldtype%>',field<%=fieldid%>.getAttribute('viewtype'));datainput('field<%=fieldid%>');"	
		<%}else{%>
		onclick="onShowBrowser2('<%=fieldid%>','<%=url%>','<%=linkurl%>','<%=fieldtype%>',field<%=fieldid%>.getAttribute('viewtype'))"
		<%}%> 
		title="<%=SystemEnv.getHtmlLabelName(172,user.getLanguage())%>">
		</button>
		 -->
	   <%}
	   }else{
	   
		   if(trrigerfield.indexOf("field"+fieldid)>=0){
		  	      bclick="onShowBrowser2('"+fieldid+"','"+url+"','"+linkurl+"','"+fieldtype+"','"+ismand+"');datainput('field"+fieldid+"');";
		  	   }else{
		  		  bclick="onShowBrowser2('"+fieldid+"','"+url+"','"+linkurl+"','"+fieldtype+"','"+ismand+"')";
		  	   }
	   %>
	   <brow:browser viewType="0" name='<%="field"+fieldid%>' browserValue='<%=fieldvalue%>' browserSpanValue='<%=showname %>' browserOnClick='<%=bclick%>' hasInput="true" isSingle='<%=BrowserManager.browIsSingle(fieldtype)%>' hasBrowser = "true" isMustInput='<%=isbrowisMust %>' completeUrl='<%="javascript:getajaxurl(" + fieldtype + ")"%>' width="230px" needHidden="false" onPropertyChange='<%="wfbrowvaluechange(this," + fieldid + ")" %>'> </brow:browser>
	    <!-- 
	    <button class=Browser <%if(trrigerfield.indexOf("field"+fieldid)>=0){%>
	      onclick="onShowBrowser2('<%=fieldid%>','<%=url%>','<%=linkurl%>','<%=fieldtype%>','<%=ismand%>');datainput('field<%=fieldid%>','<%=ismand%>');"
	   <%}else{%>
		  onclick="onShowBrowser2('<%=fieldid%>','<%=url%>','<%=linkurl%>','<%=fieldtype%>','<%=ismand%>')"
	   <%}%> 
		  title="<%=SystemEnv.getHtmlLabelName(172,user.getLanguage())%>">
	    </button>
	     -->
		<%}
	    if (fieldtype.equals("9") && fieldid.equals(flowDocField)){%>
	    <span id="createNewDoc">
			 <%if(docFlags.equals("1")&&fieldvalue.equals(""))  ///????????s
           {%>
           <button id="createdoc" class=AddDocFlow onclick="createDoc('<%=fieldid%>','','1')" title="<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%>"><%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%></button>
           <%}
            }%></span><%
            }
            }else{//view
            	%>
            	<%=showname %>
            	<%
            }
       %>
        &nbsp;
        <%if(fieldtype.equals("87")){%>
        <A href="/meeting/report/MeetingRoomPlan.jsp" target="blank"><%=SystemEnv.getHtmlLabelName(2193,user.getLanguage())%></A>
        <%}%>
        <!-- 
        <span id="field<%=fieldid%>span"><%=showname%>
       <%
            if( ismand.equals("1") && fieldvalue.equals("")){
       %>
        <img src="/images/BacoError_wev8.gif" align=absmiddle>
       <%
            }
       %>
        </span>
         -->
		   <%if (fieldtype.equals("9")||fieldtype.equals("161")||fieldtype.equals("162"))  {%>
		    <input type=hidden viewtype="<%=ismand%>" name="field<%=fieldid%>" value="<%=fieldvalue%>" temptitle="<%=Util.toScreen(fieldlable,languageid)%>" >
		   <%} else {%>
		   <input type=hidden viewtype="<%=ismand%>" name="field<%=fieldid%>" value="<%=fieldvalue%>"  temptitle="<%=Util.toScreen(fieldlable,languageid)%>" onpropertychange="checkLengthbrow('field<%=fieldid%>','field<%=fieldid%>span','<%=fieldlen%>','<%=Util.toScreen(fieldlable,languageid)%>','<%=SystemEnv.getHtmlLabelName(20246,user.getLanguage())%>','<%=SystemEnv.getHtmlLabelName(20247,user.getLanguage())%>',field<%=fieldid%>.getAttribute('viewtype'))">
			 <%}%>
           <%=hiddenlinkvalue%>
       <%
           if(changefieldsadd.indexOf(fieldid)>=0){
%>
    <input type=hidden name="oldfieldview<%=fieldid%>" value="<%=Util.getIntValue(isview,0)+Util.getIntValue(isedit,0)+Util.getIntValue(ismand,0)%>" />
<%
    }
	    }                                                       // 浏览按钮条件结束
	    else if(fieldhtmltype.equals("4")) {                    // check框
	   %>
        <input type=checkbox value=1 viewtype="<%=ismand%>" temptitle="<%=Util.toScreen(fieldlable,languageid)%>" <%if(isedit.equals("0") || isremark==1 || (isaffirmancebody.equals("1") && nodetype.equals("0") && !reEditbody.equals("1"))){%> DISABLED <%}else{%> name="field<%=fieldid%>" <%}if(trrigerfield.indexOf("field"+fieldid)>=0){%> onChange="datainput('field<%=fieldid%>');" <%}%> <%if(fieldvalue.equals("1")){%> checked <%}%> >
        <%if(isedit.equals("0") || isremark==1 || (isaffirmancebody.equals("1") && nodetype.equals("0") && !reEditbody.equals("1"))){%>
        <input type=hidden class=Inputstyle name="field<%=fieldid%>" value="<%=fieldvalue%>" >
        <%}%>
       <%
           if(changefieldsadd.indexOf(fieldid)>=0){
%>
    <input type=hidden name="oldfieldview<%=fieldid%>" value="<%=Util.getIntValue(isview,0)+Util.getIntValue(isedit,0)+Util.getIntValue(ismand,0)%>" />
<%
    }
        }                                                       // check框条件结束
        else if(fieldhtmltype.equals("5")){                     // 选择框   select

        //yl 67452   start
        //处理select字段联动
        String onchangeAddStr = "";
        int childfieldid_tmp = 0;
        if("0".equals(isbill)){
            rs.execute("select childfieldid from workflow_formdict where id="+fieldid);
        }else{
            rs.execute("select childfieldid from workflow_billfield where id="+fieldid);
        }
        if(rs.next()){
            childfieldid_tmp = Util.getIntValue(rs.getString("childfieldid"), 0);
        }
        int firstPfieldid_tmp = 0;
        boolean hasPfield = false;
        if("0".equals(isbill)){
            rs.execute("select id from workflow_formdict where childfieldid="+fieldid);
        }else{
            rs.execute("select id from workflow_billfield where childfieldid="+fieldid);
        }
        while(rs.next()){
            firstPfieldid_tmp = Util.getIntValue(rs.getString("id"), 0);
            if(fieldids.contains(""+firstPfieldid_tmp)){
                hasPfield = true;
                break;
            }
        }
        if(childfieldid_tmp != 0){//如果先出现子字段，则要把子字段下拉选项清空
            onchangeAddStr = " onchange = '" +  "$changeOption(this, "+fieldid+", "+childfieldid_tmp+");'";
        }

        //yl 67452   end
%>
      <script>
          function funcField<%=fieldid%>(){
              changeshowattr('<%=fieldid%>_0',document.getElementById('field<%=fieldid%>').value,-1,'<%=workflowid%>','<%=nodeid%>');
          }
          window.attachEvent("onload", funcField<%=fieldid%>);
      </script>


        <select class=inputstyle viewtype="<%=ismand%>"    <%=onchangeAddStr%>   temptitle="<%=Util.toScreen(fieldlable,languageid)%>" onBlur="checkinput2('field<%=fieldid%>','field<%=fieldid%>span',this.getAttribute('viewtype'));" <%if(isedit.equals("0") || isremark==1 || (isaffirmancebody.equals("1") && nodetype.equals("0") && !reEditbody.equals("1"))){%> DISABLED <%}else{%> name="field<%=fieldid%>" <%}if(trrigerfield.indexOf("field"+fieldid)>=0&&selfieldsadd.indexOf(fieldid)>=0){%> onChange="datainput('field<%=fieldid%>');changeshowattr('<%=fieldid%>_0',this.value,-1,<%=workflowid%>,<%=nodeid%>);" <%}else if(selfieldsadd.indexOf(fieldid)>=0){%> onChange="changeshowattr('<%=fieldid%>_0',this.value,-1,<%=workflowid%>,<%=nodeid%>);" <%}%>><!--added by xwj for td3313 20051206 -->
	    <option value=""></option><!--added by xwj for td3297 20051130 -->
	   <%
            // 查询选择框的所有可以选择的值
            rs.executeProc("workflow_selectitembyid_new",""+fieldid+flag+isbill);
             boolean checkempty = true;//xwj for td3313 20051206
			      String finalvalue = "";//xwj for td3313 20051206
           if(hasPfield == false){
            while(rs.next()){
                String tmpselectvalue = Util.null2String(rs.getString("selectvalue"));
                String tmpselectname = Util.toScreen(rs.getString("selectname"),user.getLanguage());
                 /* -------- xwj for td3313 20051206 begin -*/
                 if(tmpselectvalue.equals(fieldvalue)){
				          checkempty = false;
				          finalvalue = tmpselectvalue;
				         }
				         /* -------- xwj for td3313 20051206 end -*/
	   %>
	    <option value="<%=tmpselectvalue%>" <%if(fieldvalue.equals(tmpselectvalue)){%> selected <%}%>><%=tmpselectname%></option>
	   <%
                }
              }else{

                    while(rs.next()){
                        String tmpselectvalue = Util.null2String(rs.getString("selectvalue"));
                        String tmpselectname = Util.toScreen(rs.getString("selectname"),user.getLanguage());
                        if(tmpselectvalue.equals(fieldvalue)){
                            checkempty = false;
                            finalvalue = tmpselectvalue;
                        }
       %>
            <option value="<%=tmpselectvalue%>" <%if(fieldvalue.equals(tmpselectvalue)){%> selected <%}%>><%=tmpselectname%></option>
            <%
                    }
                    selectInitJsStr += "doInitChildSelect("+fieldid+","+firstPfieldid_tmp+",\""+finalvalue+"\");\n";
                    initIframeStr += "<iframe id=\"iframe_"+firstPfieldid_tmp+"_"+fieldid+"_00\" frameborder=0 scrolling=no src=\"\"  style=\"display:none\"></iframe>";
                }

                //yl 67452   end
           if(selfieldsadd.indexOf(fieldid)>=0) bodychangattrstr+="changeshowattr('"+fieldid+"_0','"+finalvalue+"',-1,"+workflowid+","+nodeid+");";
       %>
	    </select>

	    <!--xwj for td3313 20051206 begin-->
	    <span id="field<%=fieldid%>span">
	    <%
	     if(ismand.equals("1") && checkempty){
	    %>
       <img src='/images/BacoError_wev8.gif' align=absMiddle>
      <%
            }
       %>
	     </span>
	    <!--xwj for td3313 20051206 end-->

        <%if(isedit.equals("0") || isremark==1 || (isaffirmancebody.equals("1") && nodetype.equals("0") && !reEditbody.equals("1"))){%>
        <input type=hidden class=Inputstyle name="field<%=fieldid%>" value="<%=finalvalue%>" temptitle="<%=Util.toScreen(fieldlable,languageid)%>" >
        <%}%>
       <%
            if(changefieldsadd.indexOf(fieldid)>=0){
%>
    <input type=hidden name="oldfieldview<%=fieldid%>" value="<%=Util.getIntValue(isview,0)+Util.getIntValue(isedit,0)+Util.getIntValue(ismand,0)%>" />
<%
    }
        //add by xhheng @20050310 for 附件上传
        }else if(fieldhtmltype.equals("6")){
        %>
          <%if( isedit.equals("1") && isremark != 1 && (!isaffirmancebody.equals("1") || !nodetype.equals("0") || reEditbody.equals("1"))){%>
          <!--modify by xhheng @20050511 for 1803-->
          <table cols=3 id="field<%=fieldid%>_tab">
            <tbody >
            <col width="50%" >
            <col width="25%" >
            <col width="25%">
          <%
			if("-2".equals(fieldvalue)){%>
			<tr>
				<td colSpan=3><font color="red">
				<%=SystemEnv.getHtmlLabelName(21710,user.getLanguage())%></font>
				</td>
			</tr>
			  <%}else{
          if(!fieldvalue.equals("")) {
            sql="select id,docsubject,accessorycount from docdetail where id in("+fieldvalue+") order by id asc";
            RecordSet.executeSql(sql);
            int linknum=-1;
            int imgnum=fieldimgnum;
              boolean isfrist=false;
            while(RecordSet.next()){
                isfrist=false;
              linknum++;
              String showid = Util.null2String(RecordSet.getString(1)) ;
              String tempshowname= Util.toScreen(RecordSet.getString(2),user.getLanguage()) ;
              int accessoryCount=RecordSet.getInt(3);

              DocImageManager.resetParameter();
              DocImageManager.setDocid(Integer.parseInt(showid));
              DocImageManager.selectDocImageInfo();

              String docImagefileid = "";
              long docImagefileSize = 0;
              String docImagefilename = "";
              String fileExtendName = "";
              int versionId = 0;

              if(DocImageManager.next()){
                //DocImageManager会得到doc第一个附件的最新版本
                docImagefileid = DocImageManager.getImagefileid();
                docImagefileSize = DocImageManager.getImageFileSize(Util.getIntValue(docImagefileid));
                docImagefilename = DocImageManager.getImagefilename();
                fileExtendName = docImagefilename.substring(docImagefilename.lastIndexOf(".")+1).toLowerCase();
                versionId = DocImageManager.getVersionId();
              }
             if(accessoryCount>1){
               fileExtendName ="htm";
             }

              String imgSrc=AttachFileUtil.getImgStrbyExtendName(fileExtendName,20);
              if(fieldtype.equals("2")){
              if(linknum==0){
              isfrist=true;
              %>
            <tr>
                <td colSpan=3>
                    <table cellspacing="0" cellpadding="0">
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
                          <td colspan="2" align="center"><img src="/weaver/weaver.file.FileDownload?fileid=<%=docImagefileid%>&requestid=<%=requestid%>" style="cursor:hand" alt="<%=docImagefilename%>" <%if(fieldimgwidth>0){%>width="<%=fieldimgwidth%>"<%}%> <%if(fieldimgheight>0){%>height="<%=fieldimgheight%>"<%}%> onclick="addDocReadTag('<%=showid%>');openAccessory('<%=docImagefileid%>')">
                          </td>
                      </tr>
                      <tr>
                              <td align="center"><nobr>
                                  <a href="#" style="text-decoration:underline" onmouseover="this.style.color='blue'" onclick='onChangeSharetype("span<%=fieldid%>_id_<%=linknum%>","field<%=fieldid%>_del_<%=linknum%>","<%=ismand%>",oUpload<%=fieldid%>);return false;'>[<span style="cursor:hand;color:black;"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></span>]</a>
                                    <span id="span<%=fieldid%>_id_<%=linknum%>" name="span<%=fieldid%>_id_<%=linknum%>" style="visibility:hidden"><b><font COLOR="#FF0033">√</font></b><span></td>
                              <td align="center"><nobr>
                                  <a href="#" style="text-decoration:underline" onmouseover="this.style.color='blue'" onclick="addDocReadTag('<%=showid%>');downloads('<%=docImagefileid%>');return false;">[<span style="cursor:hand;color:black;"><%=SystemEnv.getHtmlLabelName(258,user.getLanguage())%></span>]</a>
                              </td>
                      </tr>
                        </table>
                    </td>
              <%}else{%>

          <tr>
            <input type=hidden name="field<%=fieldid%>_del_<%=linknum%>" value="0" >
            <td >
              <%=imgSrc%>

              <%if(accessoryCount==1 && (Util.isExt(fileExtendName)||fileExtendName.equalsIgnoreCase("pdf"))){%>
                <!--<a  style="cursor:hand" onclick="addDocReadTag('<%=showid%>');opendoc('<%=showid%>','<%=versionId%>','<%=docImagefileid%>')"><%=docImagefilename%></a>&nbsp-->
                <a  style="cursor:hand" onclick="addDocReadTag('<%=showid%>');openDocExt('<%=showid%>','<%=versionId%>','<%=docImagefileid%>',1)"><%=docImagefilename%></a>&nbsp
              <%}else{%>
                <!--<a style="cursor:hand" onclick="addDocReadTag('<%=showid%>');opendoc1('<%=showid%>')"><%=tempshowname%></a>&nbsp-->
                <a style="cursor:hand" onclick="addDocReadTag('<%=showid%>');openAccessory('<%=docImagefileid%>')"><%=docImagefilename%></a>&nbsp

              <%}%>
              <input type=hidden name="field<%=fieldid%>_id_<%=linknum%>" value=<%=showid%>>
            </td>
            <td >
                <button class=btnFlow accessKey=1  onclick='onChangeSharetype("span<%=fieldid%>_id_<%=linknum%>","field<%=fieldid%>_del_<%=linknum%>","<%=ismand%>",oUpload<%=fieldid%>)'><u><%=linknum%></u>-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>
                </button><span id="span<%=fieldid%>_id_<%=linknum%>" name="span<%=fieldid%>_id_<%=linknum%>" style="visibility:hidden">
                    <b><font COLOR="#FF0033">√</font></b>
                  <span>
            </td>
            <%if(accessoryCount==1){%>
            <td >
              <span id = "selectDownload">
                <%
                  boolean isLocked=SecCategoryComInfo1.isDefaultLockedDoc(Integer.parseInt(showid));
                  //if(!isLocked){
                %>
                  <button class=btnFlowd accessKey=1  onclick="addDocReadTag('<%=showid%>');downloads('<%=docImagefileid%>')">
                    <u><%=linknum%></u>-<%=SystemEnv.getHtmlLabelName(258,user.getLanguage())%>	  (<%=docImagefileSize/1000%>K)
                  </button>
                <%//}%>
              </span>
            </td>
            <%}%>
          </tr>
            <%}}
            if(fieldtype.equals("2")&&linknum>-1){%>
            </tr></table></td></tr>
            <%}%>
            <input type=hidden name="field<%=fieldid%>_idnum" value=<%=linknum+1%>>
            <input type=hidden name="field<%=fieldid%>_idnum_1" value=<%=linknum+1%>>
          <%}
		}%>
          <tr>
            <td colspan=3>
             <%
            String mainId="";
            String subId="";
            String secId="";
          if(docCategory!=null && !docCategory.equals("")){
            mainId=docCategory.substring(0,docCategory.indexOf(','));
            subId=docCategory.substring(docCategory.indexOf(',')+1,docCategory.lastIndexOf(','));
            secId=docCategory.substring(docCategory.lastIndexOf(',')+1,docCategory.length());
          }
          String picfiletypes="*.*";
          String filetypedesc="All Files";
          if(fieldtype.equals("2")){
              picfiletypes=BaseBean.getPropValue("PicFileTypes","PicFileTypes");
              filetypedesc="Images Files";
          }
                boolean canupload=true;
                if(uploadType == 0){if("".equals(mainId) && "".equals(subId) && "".equals(secId)){
                    canupload=false;
            %>
           <font color="red"> <%=SystemEnv.getHtmlLabelName(17616,user.getLanguage())+SystemEnv.getHtmlLabelName(92,user.getLanguage())+SystemEnv.getHtmlLabelName(15808,user.getLanguage())%>!</font>
           <%}}else if(!isCanuse){
               canupload=false;
           %>
           <font color="red"> <%=SystemEnv.getHtmlLabelName(17616,user.getLanguage())+SystemEnv.getHtmlLabelName(92,user.getLanguage())+SystemEnv.getHtmlLabelName(15808,user.getLanguage())%>!</font>
           <%}
           if(canupload){
           %>
            <script>
          var oUpload<%=fieldid%>;
          function fileupload<%=fieldid%>() {
        var settings = {
            flash_url : "/js/swfupload/swfupload.swf",
            upload_url: "/docs/docupload/MultiDocUploadByWorkflow.jsp",    // Relative to the SWF file
            post_params: {
                "mainId": "<%=mainId%>",
                "subId":"<%=subId%>",
                "secId":"<%=secId%>",
                "userid":"<%=user.getUID()%>",
                "logintype":"<%=user.getLogintype()%>",
                "workflowid":"<%=workflowid%>"
            },
            file_size_limit :"<%=maxUploadImageSize%> MB",
            file_types : "<%=picfiletypes%>",
            file_types_description : "<%=filetypedesc%>",
            file_upload_limit : 100,
            file_queue_limit : 0,
            custom_settings : {
                progressTarget : "fsUploadProgress<%=fieldid%>",
                cancelButtonId : "btnCancel<%=fieldid%>",
                uploadspan : "field<%=fieldid%>span",
                uploadfiedid : "field<%=fieldid%>"
            },
            debug: false,
            button_image_url : "/js/swfupload/add_wev8.png",
            button_placeholder_id : "spanButtonPlaceHolder<%=fieldid%>",
            button_width: 100,
            button_height: 18,
            button_text : '<span class="button"><%=SystemEnv.getHtmlLabelName(21406,user.getLanguage())%></span>',
            button_text_style : '.button { font-family: Helvetica, Arial, sans-serif; font-size: 12pt; } .buttonSmall { font-size: 10pt; }',
            button_text_top_padding: 0,
            button_text_left_padding: 18,
            button_window_mode: SWFUpload.WINDOW_MODE.TRANSPARENT,
            button_cursor: SWFUpload.CURSOR.HAND,

            // The event handler functions are defined in handlers.js
            file_queued_handler : fileQueued,
            file_queue_error_handler : fileQueueError,
            file_dialog_complete_handler : fileDialogComplete_1,
            upload_start_handler : uploadStart,
            upload_progress_handler : uploadProgress,
            upload_error_handler : uploadError,
            upload_success_handler : uploadSuccess_1,
            upload_complete_handler : uploadComplete_1,
            queue_complete_handler : queueComplete    // Queue plugin event
        };


        try {
            oUpload<%=fieldid%>=new SWFUpload(settings);
        } catch(e) {
            alert(e)
        }
    }
        	window.attachEvent("onload", fileupload<%=fieldid%>);
        </script>
      <TABLE class="ViewForm">
          <tr>
              <td colspan="2">
                  <div>
                      <span>
                      <span id="spanButtonPlaceHolder<%=fieldid%>"></span><!--选取多个文件-->
                      </span>
                      &nbsp;&nbsp;
								<span style="color:#262626;cursor:hand;TEXT-DECORATION:none" disabled onclick="oUpload<%=fieldid%>.cancelQueue();showmustinput(oUpload<%=fieldid%>);" id="btnCancel<%=fieldid%>">
									<span><img src="/js/swfupload/delete_wev8.gif" border="0"></span>
									<span style="height:19px"><font style="margin:0 0 0 -1"><%=SystemEnv.getHtmlLabelName(21407,user.getLanguage())%></font><!--清除所有选择--></span>
								</span><span id="uploadspan">(<%=SystemEnv.getHtmlLabelName(18976,user.getLanguage())%><%=maxUploadImageSize%><%=SystemEnv.getHtmlLabelName(18977,user.getLanguage())%>)</span>
                      <span id="field<%=fieldid%>span">
				<%
				 if(ismand.equals("1")&&fieldvalue.equals("")){
				%>
			   <img src='/images/BacoError_wev8.gif' align=absMiddle>
			  <%
					}
			   %>
	     </span>
                  </div>
                  <input  class=InputStyle  type=hidden size=60 name="field<%=fieldid%>" temptitle="<%=Util.toScreen(fieldlable,languageid)%>"  viewtype="<%=ismand%>" value="<%=fieldvalue%>">
              </td>
          </tr>
          <tr>
              <td colspan="2">
                  <div class="fieldset flash" id="fsUploadProgress<%=fieldid%>">
                  </div>
                  <div id="divStatus<%=fieldid%>"></div>
              </td>
          </tr>
      </TABLE>
            <%}%>
          <input type=hidden name='mainId' value=<%=mainId%>>
          <input type=hidden name='subId' value=<%=subId%>>
          <input type=hidden name='secId' value=<%=secId%>>
             </td>
          </tr>
      </TABLE>
          <%}else{
          if(!fieldvalue.equals("")) {
            %>
          <table cols=3 id="field<%=fieldid%>_tab">
            <tbody >
            <col width="50%" >
            <col width="25%" >
            <col width="25%">
            <%
            sql="select id,docsubject,accessorycount from docdetail where id in("+fieldvalue+") order by id asc";
            int linknum=-1;
            RecordSet.executeSql(sql);
            while(RecordSet.next()){
              linknum++;
              String showid = Util.null2String(RecordSet.getString(1)) ;
              String tempshowname= Util.toScreen(RecordSet.getString(2),user.getLanguage()) ;
              int accessoryCount=RecordSet.getInt(3);

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
              String imgSrc=AttachFileUtil.getImgStrbyExtendName(fileExtendName,20);
              %>
              <tr>
              <td colspan=3>
              <%=imgSrc%>
              <%if(accessoryCount==1 && (Util.isExt(fileExtendName)||fileExtendName.equalsIgnoreCase("pdf"))){%>
                <!--<a style="cursor:hand" onclick="addDocReadTag('<%=showid%>');opendoc('<%=showid%>','<%=versionId%>','<%=docImagefileid%>')"><%=docImagefilename%></a>&nbsp-->
                <a style="cursor:hand" onclick="addDocReadTag('<%=showid%>');openDocExt('<%=showid%>','<%=versionId%>','<%=docImagefileid%>',0)"><%=docImagefilename%></a>&nbsp

              <%}else{%>
                <!--<a style="cursor:hand" onclick="addDocReadTag('<%=showid%>');opendoc1('<%=showid%>')"><%=tempshowname%></a>&nbsp-->
                <a style="cursor:hand" onclick="addDocReadTag('<%=showid%>');openAccessory('<%=docImagefileid%>')"><%=docImagefilename%></a>&nbsp
              <%}%>
              <input type=hidden name="field<%=fieldid%>_id_<%=linknum%>" value=<%=showid%>> <!--xwj for td2893 20051017-->
              <%if(accessoryCount==1){%>
                <span id = "selectDownload">
                  <button class=btnFlowd accessKey=1  onclick="addDocReadTag('<%=showid%>');downloads('<%=docImagefileid%>')">
                    <u><%=linknum%></u>-<%=SystemEnv.getHtmlLabelName(258,user.getLanguage())%>	(<%=docImagefileSize/1000%>K)
                  </button>
                </span>
              </td>
              <%}%>
              </tr>
              <%}%>
              <input type=hidden name="field<%=fieldid%>_idnum" value=<%=linknum+1%>><!--xwj for td2893 20051017-->
              <input type=hidden name="field<%=fieldid%>" value=<%=fieldvalue%>>
              </tbody>
              </table>
              <%
            }
          }
        }     // 选择框条件结束 所有条件判定结束
       else if(fieldhtmltype.equals("7")){//特殊字段
           if(isbill.equals("0")) out.println(Util.null2String((String)specialfield.get(fieldid+"_0")));
           else out.println(Util.null2String((String)specialfield.get(fieldid+"_1")));
       }        
       %>
      </td>
    </tr><tr style="height:1px;"><td class=Line2 colSpan=2></td></tr>

<%
    }else {                              // 不显示的作为 hidden 保存信息
        if (fieldhtmltype.equals("6"))
        {   if (!fieldvalue.equals(""))
            {
            ArrayList fieldvalueas=Util.TokenizerString(fieldvalue,",");
            int linknum=-1;
            for(int j=0;j<fieldvalueas.size();j++){
              linknum++;
              String showid = Util.null2String(""+fieldvalueas.get(j)) ;
              %>
            <input type=hidden name="field<%=fieldid%>_id_<%=linknum%>" value=<%=showid%>>

          <%}%><input type=hidden name="field<%=fieldid%>_idnum" value=<%=linknum+1%>>
         <input type=hidden name="field<%=fieldid%>" value="<%=Util.toScreenToEdit(fieldvalue,user.getLanguage())%>" >
          <%
          }
          }

	if (fieldhtmltype.equals("2")&&fieldtype.equals("2")) {%>
	<textarea name="field<%=fieldid%>" style="display:none"><%=fieldvalue%></textarea>
	<%} else {%>
    <input type=hidden name="field<%=fieldid%>" value="<%=Util.toScreenToEdit(fieldvalue,user.getLanguage())%>" >
<%
	}} %>
<%
}       // 循环结束
%>

</table>


<!--yl qc:67452 start-->
<%=initIframeStr%>
<!--yl qc:67452   end-->
<input type=hidden name="requestid" value=<%=requestid%>>           <!--请求id-->
<input type=hidden name="workflowid" value="<%=workflowid%>">       <!--工作流id-->
<input type=hidden name="workflowtype" value="<%=workflowtype%>">       <!--工作流类型-->
<input type=hidden name="nodeid" value="<%=nodeid%>">               <!--当前节点id-->
<input type=hidden name="nodetype" value="<%=nodetype%>">                     <!--当前节点类型-->
<input type=hidden name="src">                                <!--操作类型 save和submit,reject,delete-->
<input type=hidden name="iscreate" value="0">                     <!--是否为创建节点 是:1 否 0 -->
<input type=hidden name="formid" value="<%=formid%>">               <!--表单的id-->
<input type=hidden name ="isbill" value="<%=isbill%>">            <!--是否单据 0:否 1:是-->
<input type=hidden name="billid" value="<%=billid%>">             <!--单据id-->

<input type=hidden name ="method">                                <!--新建文档时候 method 为docnew-->
<input type=hidden name ="topage" value="<%=topage%>">				<!--返回的页面-->
<input type=hidden name ="needcheck" value="<%=needcheck%>">
<input type=hidden name ="inputcheck" value="">

<input type=hidden name ="isMultiDoc" value=""><!--多文档新建-->
<input type="hidden" name="needwfback" id="needwfback" value="1" />
<input type="hidden" name="lastOperator"  id="lastOperator" value="<%=lastOperator%>"/>
<input type="hidden" name="lastOperateDate"  id="lastOperateDate" value="<%=lastOperateDate%>"/>
<input type="hidden" name="lastOperateTime"  id="lastOperateTime" value="<%=lastOperateTime%>"/>

<%@ include file="/workflow/request/WorkflowManageSign.jsp" %>
<input type="hidden" name="f_weaver_belongto_userid" value="<%=request.getParameter("f_weaver_belongto_userid") %>">
<input type="hidden" name="f_weaver_belongto_usertype" value="<%=request.getParameter("f_weaver_belongto_usertype") %>">
</form>
<script language="javascript">
/*
function funcClsDateTime(){
	var onlstr = new clsDateTime();
}                
if (window.addEventListener){
    window.addEventListener("load", funcClsDateTime, false);
}else if (window.attachEvent){
    window.attachEvent("onload", funcClsDateTime);
}else{
    window.onload=funcClsDateTime;
}*/
<%=bodychangattrstr%>

<%
String isFormSignature=null;
RecordSet.executeSql("select isFormSignature from workflow_flownode where workflowId="+workflowid+" and nodeId="+nodeid);
if(RecordSet.next()){
	isFormSignature = Util.null2String(RecordSet.getString("isFormSignature"));
}
%>


//yl qc:67452 start
function $changeOption(obj, fieldid, childfieldid){

    var paraStr = "fieldid="+fieldid+"&childfieldid="+childfieldid+"&isbill=1&isdetail=0&selectvalue="+obj.value;
    $GetEle("selectChange").src = "SelectChange.jsp?"+paraStr;
}
function doInitChildSelect(fieldid,pFieldid,finalvalue){
    try{
        var pField = $GetEle("field"+pFieldid);
        if(pField != null){
            var pFieldValue = pField.value;
            if(pFieldValue==null || pFieldValue==""){
                return;
            }
            if(pFieldValue!=null && pFieldValue!=""){
                var field = $GetEle("field"+fieldid);
                var paraStr = "fieldid="+pFieldid+"&childfieldid="+fieldid+"&isbill=<%=isbill%>&isdetail=0&selectvalue="+pFieldValue+"&childvalue="+finalvalue;
                $GetEle("iframe_"+pFieldid+"_"+fieldid+"_00").src = "SelectChange.jsp?"+paraStr;
            }
        }
    }catch(e){}
}
<%=selectInitJsStr%>
//yl qc:67452 end
function createDoc(fieldbodyid,docVlaue,isedit)
{
	/*
   for(i=0;i<=1;i++){
  		parent.document.all("oTDtype_"+i).background="/images/tab2_wev8.png";
  		parent.document.all("oTDtype_"+i).className="cycleTD";
  	}
  	parent.document.all("oTDtype_1").background="/images/tab.active2_wev8.png";
  	parent.document.all("oTDtype_1").className="cycleTDCurrent";
	*/
  	if("<%=isremark%>"==9||"<%=isremark%>"==1){
  		frmmain.action = "RequestDocView.jsp?requestid=<%=requestid%>&docValue="+docVlaue;
  	}else{
  	frmmain.action = "RequestOperation.jsp?docView="+isedit+"&docValue="+docVlaue+"&isFromEditDocument=true";
  	}
    frmmain.method.value = "crenew_"+fieldbodyid ;
    if(check_form(document.frmmain,'requestname')){

        document.frmmain.src.value='save';
        document.frmmain.isremark.value='0';
//保存签章数据
<%if("1".equals(isFormSignature)){%>
	                    if(SaveSignature()){
                            //附件上传
        StartUploadAll();
        checkuploadcomplet();
                        }else{
							if(isDocEmpty==1){
								alert("\""+"<%=SystemEnv.getHtmlLabelName(17614,user.getLanguage())%>"+"\""+"<%=SystemEnv.getHtmlLabelName(21423,user.getLanguage())%>");
								isDocEmpty=0;
							}else{
							    alert("<%=SystemEnv.getHtmlLabelName(21442,user.getLanguage())%>");
							}                        
							return ;
						}
<%}else{%>
                        //附件上传
        StartUploadAll();
        checkuploadcomplet();
<%}%>
    }


}



function checkCountCpt(a,b){
	
    var stockamount = document.all(b).value;
    var useamount = document.all(a).value;
    if(eval(useamount)>eval(stockamount)){
        alert("<%=SystemEnv.getHtmlLabelName(6054,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(1331,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(1446,user.getLanguage())%>");
        document.all(a).value = stockamount;
    }
}

function openDocExt(showid,versionid,docImagefileid,isedit){
	jQuery($GetEle("flowbody")).attr("onbeforeunload", "");
    
	if(isedit==1){
		openFullWindowHaveBar("/docs/docs/DocEditExt.jsp?id="+showid+"&imagefileId="+docImagefileid+"&isFromAccessory=true&isrequest=1&requestid=<%=requestid%>");
	}else{
		openFullWindowHaveBar("/docs/docs/DocDspExt.jsp?id="+showid+"&imagefileId="+docImagefileid+"&isFromAccessory=true&isrequest=1&requestid=<%=requestid%>");
	}
}

function openAccessory(fileId){ 
	jQuery($GetEle("flowbody")).attr("onbeforeunload", "");
	openFullWindowHaveBar("/weaver/weaver.file.FileDownload?fileid="+fileId+"&requestid=<%=requestid%>");
}

function onNewDoc(fieldid) {
    frmmain.action = "RequestOperation.jsp" ;
    frmmain.method.value = "docnew_"+fieldid ;
    frmmain.isMultiDoc.value = fieldid ;
    document.frmmain.src.value='save';
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


function checktimeok(){         <!-- 结束日期不能小于开始日期 -->
    if ("<%=newenddate%>"!="b" && "<%=newfromdate%>"!="a" && document.frmmain.<%=newenddate%>.value != "")
    {
        YearFrom=document.frmmain.<%=newfromdate%>.value.substring(0,4);
        MonthFrom=document.frmmain.<%=newfromdate%>.value.substring(5,7);
        DayFrom=document.frmmain.<%=newfromdate%>.value.substring(8,10);
        YearTo=document.frmmain.<%=newenddate%>.value.substring(0,4);
        MonthTo=document.frmmain.<%=newenddate%>.value.substring(5,7);
        DayTo=document.frmmain.<%=newenddate%>.value.substring(8,10);
        if (!DateCompare(YearFrom, MonthFrom, DayFrom,YearTo, MonthTo,DayTo )){
            window.alert("<%=SystemEnv.getHtmlLabelName(15273,user.getLanguage())%>");
            return false;
        }
    }
    return true;
}

function doTriggerInit(){
    var tempS = "<%=trrigerfield%>";
    var tempA = tempS.split(",");
    for(var i=0;i<tempA.length;i++){
        datainput(tempA[i]);
    }
} 
function datainput(parfield){                <!--数据导入-->
      //var xmlhttp=XmlHttp.create();
      var detailsum="0";
      try{
          detailsum=document.all("detailsum").value;
      }catch(e){ detailsum="0";}
      var StrData="id=<%=workflowid%>&formid=<%=formid%>&bill=<%=isbill%>&node=<%=nodeid%>&detailsum="+detailsum+"&trg="+parfield;
      <%
      if(!trrigerfield.trim().equals("")){
          ArrayList Linfieldname=ddi.GetInFieldName();
          ArrayList Lcondetionfieldname=ddi.GetConditionFieldName();
          for(int i=0;i<Linfieldname.size();i++){
              String temp=(String)Linfieldname.get(i);
      %>
          if(parfield=="<%=temp.substring(temp.indexOf("|")+1)%>") StrData+="&<%=temp%>="+document.all("<%=temp.substring(temp.indexOf("|")+1)%>").value;
      <%
          }
          for(int i=0;i<Lcondetionfieldname.size();i++){
              String temp=(String)Lcondetionfieldname.get(i);
      %>
          StrData+="&<%=temp%>="+document.all("<%=temp.substring(temp.indexOf("|")+1)%>").value;
      <%
          }
      }
      %>
      document.all("datainputform").src="DataInputFrom.jsp?"+StrData;
  }
function getWFLinknum(wffiledname){
    if(document.all(wffiledname) != null){
        return document.all(wffiledname).value;
    }else{
        return 0;
    }
}

function changeKeyword(){
<%
	if(titleFieldId>0&&keywordFieldId>0){
%>
	    var titleObj=document.getElementById("field<%=titleFieldId%>");
	    var keywordObj=document.getElementById("field<%=keywordFieldId%>");

        if(titleObj!=null&&keywordObj!=null){

		    document.getElementById("workflowKeywordIframe").src="/docs/sendDoc/WorkflowKeywordIframe.jsp?operation=UpdateKeywordData&docTitle="+titleObj.value;
	    }
<%
    }else if(titleFieldId==-3&&keywordFieldId>0){
%>
	    var titleObj=document.getElementById("requestname");
	    var keywordObj=document.getElementById("field<%=keywordFieldId%>");

        if(titleObj!=null&&keywordObj!=null){

		    document.getElementById("workflowKeywordIframe").src="/docs/sendDoc/WorkflowKeywordIframe.jsp?operation=UpdateKeywordData&docTitle="+titleObj.value;
	    }
<%
   }
%>
}

function updateKeywordData(strKeyword){
<%
	if(keywordFieldId>0){
%>
	var keywordObj=document.getElementById("field<%=keywordFieldId%>");

    var keywordismand=<%=keywordismand%>;
    var keywordisedit=<%=keywordisedit%>;

	if(keywordObj!=null){
		if(keywordisedit==1){
			keywordObj.value=strKeyword;
			if(keywordismand==1){
				checkinput('field<%=keywordFieldId%>','field<%=keywordFieldId%>span');
			}
		}else{
			keywordObj.value=strKeyword;
			field<%=keywordFieldId%>span.innerHTML=strKeyword;
		}

	}
<%
    }
%>
}


function onShowKeyword(isbodymand){
<%
	if(keywordFieldId>0){
%>
	var keywordObj=document.getElementById("field<%=keywordFieldId%>");
	if(keywordObj!=null){
		strKeyword=keywordObj.value;
        tempUrl=escape("/docs/sendDoc/WorkflowKeywordBrowserMulti.jsp?strKeyword="+strKeyword);
		tempUrl=tempUrl.replace(/%A0/g,'%20');
        returnKeyword=window.showModalDialog("/systeminfo/BrowserMain.jsp?url="+tempUrl);
        
		if(typeof(returnKeyword)!="undefined"){
			keywordObj.value=returnKeyword;
			if(isbodymand==1){
				checkinput('field<%=keywordFieldId%>','field<%=keywordFieldId%>span');
			}
		}
	}
<%
    }
%>
}
function uescape(url){
    return escape(url);
}
//** iframe自动适应页面 **//

    function dyniframesize()
    {
    var dyniframe;
    <%
    for (int i=0; i<managefckfields_billbody.size(); i++)
    {%>
    if (document.getElementById)
    {
        //自动调整iframe高度
        dyniframe = document.getElementById("<%=managefckfields_billbody.get(i)%>");
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
    alert("<%=SystemEnv.getHtmlLabelName(22577,user.getLanguage())%>");
    <%}%>    
    }
    if (window.addEventListener)
    window.addEventListener("load", dyniframesize, false);
    else if (window.attachEvent)
    window.attachEvent("onload", dyniframesize);
    else
    window.onload=dyniframesize;
</script>
<script LANGUAGE="VBS">
sub onShowCptCapital(inputnames,inputnumbers,inputcount,ismand)

	spanname="field"+inputnames+"span"
    inputname="field"+inputnames
    inputnumber="field"+inputnumbers
	inputnumberspan="field"+inputnumbers+"span"
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/cpt/capital/CapitalBrowser.jsp?sqlwhere=where isdata='2'&cptstateid=1,2,3,4")
	if NOT isempty(id) then
	    if id(0)<> "" and id(0)<> "0" then
		document.all(spanname).innerHtml = id(1)
		document.all(inputname).value=id(0)
        document.all(inputnumber).value=id(7)
        document.all(inputcount).value=id(7)
        document.all(inputnumberspan).innerHtml =  ""
		else
		if ismand=1 then
		document.all(spanname).innerHtml =  "<img src='/images/BacoError_wev8.gif' align=absmiddle>"
		else 
		document.all(spanname).innerHtml =  ""
		end if
		document.all(inputname).value=""
		end if
	end if
end sub
sub onShowResourceRole(id,url,linkurl,type1,ismand,roleid)
tmpids = document.all("field"+id).value
url=url&roleid&"_"+tmpids
//url=url&"&resourceids="&tmpids

id1 = window.showModalDialog(url)
        if NOT isempty(id1) then

		   if id1(0)<> ""  and id1(0)<> "0"  then

					resourceids = id1(0)
					resourcename = id1(1)
					sHtml = ""
					resourceids = Mid(resourceids,2,len(resourceids))
					document.all("field"+id).value= resourceids
					resourcename = Mid(resourcename,2,len(resourcename))
					while InStr(resourceids,",") <> 0
						curid = Mid(resourceids,1,InStr(resourceids,",")-1)
						curname = Mid(resourcename,1,InStr(resourcename,",")-1)
						resourceids = Mid(resourceids,InStr(resourceids,",")+1,Len(resourceids))
						resourcename = Mid(resourcename,InStr(resourcename,",")+1,Len(resourcename))
						sHtml = sHtml&"<a href="&linkurl&curid&" target='_new'>"&curname&"</a>&nbsp"
					wend
					sHtml = sHtml&"<a href="&linkurl&resourceids&" target='_new'>"&resourcename&"</a>&nbsp"
					document.all("field"+id+"span").innerHtml = sHtml

				else
					if ismand=0 then
						document.all("field"+id+"span").innerHtml = empty
					else
						document.all("field"+id+"span").innerHtml ="<img src='/images/BacoError_wev8.gif' align=absmiddle>"
					end if
					document.all("field"+id).value=""
				end if
        end if
end sub

sub onShowBrowser2(id,url,linkurl,type1,ismand)

    if type1=9  and <%=docFlags%>="1" then
    url="/systeminfo/BrowserMain.jsp?url=/docs/docs/DocBrowserWord.jsp"
    end if
	if type1= 2 or type1 = 19 then
	    spanname = "field"+id+"span"
	    inputname = "field"+id
		if type1 = 2 then
		  onFlownoShowDate spanname,inputname,ismand
        else
	      onWorkFlowShowTime spanname,inputname,ismand
		end if
	else
		if  type1 <> 171 and type1 <> 152 and type1 <> 142 and type1 <> 135 and type1 <> 17 and type1 <> 18 and type1<>27 and type1<>37 and type1<>56 and type1<>57 and type1<>65 and type1<>165 and type1<>166 and type1<>167 and type1<>168 then
			id1 = window.showModalDialog(url)
		else
             if type1=135 then
			tmpids = document.all("field"+id).value
			id1 = window.showModalDialog(url&"?projectids="&tmpids)
            elseif type1=37 then
            tmpids = document.all("field"+id).value
			id1 = window.showModalDialog(url&"?documentids="&tmpids)
            elseif type1=142 then
            tmpids = document.all("field"+id).value
			id1 = window.showModalDialog(url&"?receiveUnitIds="&tmpids)
            elseif type1=165 or type1=166 or type1=167 or type1=168 then
            index=InStr(id,"_")
            if index>0 then
            tmpids=uescape("?isdetail=1&fieldid="& Mid(id,1,index-1)&"&resourceids="&document.all("field"+id).value)
            id1 = window.showModalDialog(url&tmpids)
            else
            tmpids=uescape("?fieldid="&id&"&resourceids="&document.all("field"+id).value)
            id1 = window.showModalDialog(url&tmpids)
            end if
            else
			tmpids = document.all("field"+id).value
			id1 = window.showModalDialog(url&"?resourceids="&tmpids)
            end if
		end if
		if NOT isempty(id1) then
			if type1 = 171 or type1 = 152 or type1 = 142 or type1 = 135 or type1 = 17 or type1 = 18 or type1=27 or type1=37 or type1=56 or type1=57 or type1=65 or type1=166 or type1=168 or type1=170 then
				if id1(0)<> ""  and id1(0)<> "0" then
					resourceids = id1(0)
					resourcename = id1(1)
					sHtml = ""
					resourceidss = Mid(resourceids,2,len(resourceids))
					resourceids = Mid(resourceids,2,len(resourceids))
                    tlinkurl=linkurl

					resourcename = Mid(resourcename,2,len(resourcename))
					while InStr(resourceids,",") <> 0
						curid = Mid(resourceids,1,InStr(resourceids,",")-1)
						curname = Mid(resourcename,1,InStr(resourcename,",")-1)
						resourceids = Mid(resourceids,InStr(resourceids,",")+1,Len(resourceids))
						resourcename = Mid(resourcename,InStr(resourcename,",")+1,Len(resourcename))
                        if type1 = 171 or type1 = 152 then
                        linkno=getWFLinknum("slink"&id&"_rq"&curid)
                        if linkno>0 then
                        curid=curid&"&wflinkno="&linkno
                        else
                        tlinkurl=Mid(linkurl,1,InStr(linkurl,"?"))&"requestid="
                        end if
                        end if
					if tlinkurl = "/hrm/resource/HrmResource.jsp?id=" then
							sHtml = sHtml&"<a href=javaScript:openhrm("&curid&"); onclick='pointerXY(event);'>"&curname&"</a>&nbsp"
						else
							sHtml = sHtml&"<a href="&tlinkurl&curid&" target='_new'>"&curname&"</a>&nbsp"
					end if
                        
					wend
                    if type1 = 171 or type1 = 152 then
                        linkno=getWFLinknum("slink"&id&"_rq"&resourceids)
                        if linkno>0 then
                        resourceids=resourceids&"&wflinkno="&linkno
                        else
                        tlinkurl=Mid(linkurl,1,InStr(linkurl,"?"))&"requestid="
                        end if
                    end if
					if tlinkurl = "/hrm/resource/HrmResource.jsp?id=" then
						sHtml = sHtml&"<a href=javaScript:openhrm("&resourceids&"); onclick='pointerXY(event);'>"&resourcename&"</a>&nbsp"
					else
						sHtml = sHtml&"<a href="&tlinkurl&resourceids&" target='_new'>"&resourcename&"</a>&nbsp"
					end if
                    
					document.all("field"+id+"span").innerHtml = sHtml
					document.all("field"+id).value= resourceidss
				else
					if ismand=0 then
						if type1=17 or type1=165 or type1=166 then
							document.all("field"+id+"span").value = ""
							document.all("field"+id+"name").value = ""
						else
						document.all("field"+id+"span").innerHtml = empty
						end if
					else
						document.all("field"+id+"span").innerHtml ="<img src='/images/BacoError_wev8.gif' align=absmiddle>"
					end if
					document.all("field"+id).value=""
				end if

			else

			   if  id1(0)<>""   and id1(0)<> "0"  then
                   if type1=162 then
				     ids = id1(0)
					names = id1(1)
					descs = id1(2)
					sHtml = ""
					ids = Mid(ids,1,len(ids))
					document.all("field"+id).value= ids
					names = Mid(names,1,len(names))
					descs = Mid(descs,1,len(descs))
					while InStr(ids,",") <> 0
						curid = Mid(ids,1,InStr(ids,","))
						curname = Mid(names,1,InStr(names,",")-1)
						curdesc = Mid(descs,1,InStr(descs,",")-1)
						ids = Mid(ids,InStr(ids,",")+1,Len(ids))
						names = Mid(names,InStr(names,",")+1,Len(names))
						descs = Mid(descs,InStr(descs,",")+1,Len(descs))
						sHtml = sHtml&"<a title='"&curdesc&"' >"&curname&"</a>&nbsp"
					wend
					sHtml = sHtml&"<a title='"&descs&"'>"&names&"</a>&nbsp"
					document.all("field"+id+"span").innerHtml = sHtml
                    exit sub
                   end if
				   if type1=161 then
				     name = id1(1)
					desc = id1(2)
				    document.all("field"+id).value=id1(0)
					sHtml = "<a title='"&desc&"'>"&name&"</a>&nbsp"
					document.all("field"+id+"span").innerHtml = sHtml
                    exit sub
                   end if
                   if type1 = 16 then
                        curid=id1(0)
                        linkno=getWFLinknum("slink"&id&"_rq"&curid)
                        if linkno>0 then
                        curid=curid&"&wflinkno="&linkno
                        else
                        linkurl=Mid(linkurl,1,InStr(linkurl,"?"))&"requestid="
                        end if
                        document.all("field"+id).value=id1(0)
						if linkurl = "/hrm/resource/HrmResource.jsp?id=" then
							document.all("field"+id+"span").innerHtml = "<a href=javaScript:openhrm("&curid&"); onclick='pointerXY(event);'>"&id1(1)&"</a>&nbsp"
						else
							document.all("field"+id+"span").innerHtml = "<a href="&linkurl&curid&" target='_new'>"&id1(1)&"</a>"
						end if
                        exit sub
                    end if
				   
                   if type1=9 and <%=docFlags%>="1" then
                    tempid=id1(0)
                    document.all("field"+id+"span").innerHtml = "<a href='#' onclick='createDoc("+id+","+tempid+",1)'>"&id1(1)&"</a><button id='createdoc' style='display:none' class=AddDoc onclick=createDoc("+id+","+tempid+",1)></button>"
                    else
			        if linkurl = "" then
						document.all("field"+id+"span").innerHtml = id1(1)
					else
						if linkurl = "/hrm/resource/HrmResource.jsp?id=" then
							document.all("field"+id+"span").innerHtml = "<a href=javaScript:openhrm("&id1(0)&"); onclick='pointerXY(event);'>"&id1(1)&"</a>&nbsp"
						else
							document.all("field"+id+"span").innerHtml = "<a href="&linkurl&id1(0)&" target='_new'>"&id1(1)&"</a>"
						end if
						
                    end if
                    end if
					document.all("field"+id).value=id1(0)
                    if (type1=9 and <%=docFlags%>="1") then
                    document.all("CreateNewDoc").innerHtml=""
                    end if

				else
					if ismand=0 then
						document.all("field"+id+"span").innerHtml = empty
					else
						document.all("field"+id+"span").innerHtml ="<img src='/images/BacoError_wev8.gif' align=absmiddle>"
					end if
					document.all("field"+id).value=""
  					if (type1=9 and <%=docFlags%>="1") then
                    document.all("createNewDoc").innerHtml="<button id='createdoc' class=AddDocFlow onclick=createDoc("+id+",'','1') title='<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%>'><%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%></button>"
                    end if
				end if
			end if
		end if
	end if

end sub


sub onShowResourceConditionBrowser(id,url,linkurl,type1,ismand)

	tmpids = document.all("field"+id).value
	dialogId = window.showModalDialog(url&"?resourceCondition="&tmpids)
	if (Not IsEmpty(dialogId)) then
	if dialogId(0)<> "" then
	    shareTypeValues = dialogId(0)
		shareTypeTexts = dialogId(1)
		relatedShareIdses = dialogId(2)
		relatedShareNameses = dialogId(3)
		rolelevelValues = dialogId(4)
		rolelevelTexts = dialogId(5)
		secLevelValues = dialogId(6)
		secLevelTexts = dialogId(7)

		sHtml = ""
		fileIdValue=""
		shareTypeValues = Mid(shareTypeValues,2,len(shareTypeValues))
		shareTypeTexts = Mid(shareTypeTexts,2,len(shareTypeTexts))
		relatedShareIdses = Mid(relatedShareIdses,2,len(relatedShareIdses))
		relatedShareNameses = Mid(relatedShareNameses,2,len(relatedShareNameses))
		rolelevelValues = Mid(rolelevelValues,2,len(rolelevelValues))
		rolelevelTexts = Mid(rolelevelTexts,2,len(rolelevelTexts))
		secLevelValues = Mid(secLevelValues,2,len(secLevelValues))
		secLevelTexts = Mid(secLevelTexts,2,len(secLevelTexts))


		while InStr(shareTypeValues,"~") <> 0

			shareTypeValue = Mid(shareTypeValues,1,InStr(shareTypeValues,"~")-1)
			shareTypeText = Mid(shareTypeTexts,1,InStr(shareTypeTexts,"~")-1)
			relatedShareIds = Mid(relatedShareIdses,1,InStr(relatedShareIdses,"~")-1)
			relatedShareNames = Mid(relatedShareNameses,1,InStr(relatedShareNameses,"~")-1)
			rolelevelValue = Mid(rolelevelValues,1,InStr(rolelevelValues,"~")-1)
			rolelevelText = Mid(rolelevelTexts,1,InStr(rolelevelTexts,"~")-1)
			secLevelValue = Mid(secLevelValues,1,InStr(secLevelValues,"~")-1)
			secLevelText = Mid(secLevelTexts,1,InStr(secLevelTexts,"~")-1)

			shareTypeValues = Mid(shareTypeValues,InStr(shareTypeValues,"~")+1,Len(shareTypeValues))
			shareTypeTexts = Mid(shareTypeTexts,InStr(shareTypeTexts,"~")+1,Len(shareTypeTexts))
			relatedShareIdses = Mid(relatedShareIdses,InStr(relatedShareIdses,"~")+1,Len(relatedShareIdses))
			relatedShareNameses = Mid(relatedShareNameses,InStr(relatedShareNameses,"~")+1,Len(relatedShareNameses))
			rolelevelValues = Mid(rolelevelValues,InStr(rolelevelValues,"~")+1,Len(rolelevelValues))
			rolelevelTexts = Mid(rolelevelTexts,InStr(rolelevelTexts,"~")+1,Len(rolelevelTexts))
			secLevelValues = Mid(secLevelValues,InStr(secLevelValues,"~")+1,Len(secLevelValues))
			secLevelTexts = Mid(secLevelTexts,InStr(secLevelTexts,"~")+1,Len(secLevelTexts))

            fileIdValue=fileIdValue&"~"&shareTypeValue&"_"&relatedShareIds&"_"&rolelevelValue&"_"&secLevelValue

	        if shareTypeValue= "1" then
			    sHtml = sHtml&","&shareTypeText&"("&relatedShareNames&")"
	        else	if  shareTypeValue= "2" then
			             sHtml = sHtml&","&shareTypeText&"("&relatedShareNames&")"&"<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>>="&secLevelValue&"<%=SystemEnv.getHtmlLabelName(18941,user.getLanguage())%>"
			        else   if shareTypeValue= "3" then
			                   sHtml = sHtml&","&shareTypeText&"("&relatedShareNames&")"&"<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>>="&secLevelValue&"<%=SystemEnv.getHtmlLabelName(18942,user.getLanguage())%>"
					       else  if shareTypeValue= "4" then
			                         sHtml = sHtml&","&shareTypeText&"("&relatedShareNames&")"&"<%=SystemEnv.getHtmlLabelName(3005,user.getLanguage())%>="&rolelevelText&"  <%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>>="&secLevelValue&"<%=SystemEnv.getHtmlLabelName(18945,user.getLanguage())%>"
						         else
			                         sHtml = sHtml&","&"<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>>="&secLevelValue&"<%=SystemEnv.getHtmlLabelName(18943,user.getLanguage())%>"
								 end if
						   end if
					end if
	        end if
		wend

            fileIdValue=fileIdValue&"~"&shareTypeValues&"_"&relatedShareIdses&"_"&rolelevelValues&"_"&secLevelValues


	        if shareTypeValues= "1" then
			    sHtml = sHtml&","&shareTypeTexts&"("&relatedShareNameses&")"
	        else	if  shareTypeValues= "2" then
			             sHtml = sHtml&","&shareTypeTexts&"("&relatedShareNameses&")"&"<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>>="&secLevelValues&"<%=SystemEnv.getHtmlLabelName(18941,user.getLanguage())%>"
			        else   if shareTypeValues= "3" then
			                   sHtml = sHtml&","&shareTypeTexts&"("&relatedShareNameses&")"&"<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>>="&secLevelValues&"<%=SystemEnv.getHtmlLabelName(18942,user.getLanguage())%>"
					       else  if shareTypeValues= "4" then
			                         sHtml = sHtml&","&shareTypeTexts&"("&relatedShareNameses&")"&"<%=SystemEnv.getHtmlLabelName(3005,user.getLanguage())%>="&rolelevelTexts&"  <%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>>="&secLevelValues&"<%=SystemEnv.getHtmlLabelName(18945,user.getLanguage())%>"
						         else
			                         sHtml = sHtml&","&"<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>>="&secLevelValues&"<%=SystemEnv.getHtmlLabelName(18943,user.getLanguage())%>"
								 end if
						   end if
					end if
	        end if

		sHtml = Mid(sHtml,2,len(sHtml))
		fileIdValue=Mid(fileIdValue,2,len(fileIdValue))

		document.all("field"+id).value= fileIdValue
		document.all("field"+id+"span").innerHtml = sHtml
	else
        if ismand=0 then
                document.all("field"+id+"span").innerHtml = empty
        else
                document.all("field"+id+"span").innerHtml ="<img src='/images/BacoError_wev8.gif' align=absmiddle>"
        end if
        document.all("field"+id).value=""
	end if
	end if

end sub
</script>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<script type="text/javascript" src="/js/selectDateTime_wev8.js"></script>
