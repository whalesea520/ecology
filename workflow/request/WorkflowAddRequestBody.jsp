
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ page import="weaver.workflow.datainput.DynamicDataInput"%>
<%@ page import="weaver.workflow.request.RequestConstants" %>
<%@page import="weaver.general.Util"%>
<%@page import="weaver.general.browserData.BrowserManager"%>
<jsp:useBean id="WorkflowPhrase" class="weaver.workflow.sysPhrase.WorkflowPhrase" scope="page"/>
<jsp:useBean id="DocUtil" class="weaver.docs.docs.DocUtil" scope="page" /><%----- xwj for td3323 20051209  ------%>
<jsp:useBean id="rscount" class="weaver.conn.RecordSet" scope="page"/> <!--xwj for @td2977 20051111-->
<jsp:useBean id="rsaddop" class="weaver.conn.RecordSet" scope="page"/> <!--xwj for td3130 20051124-->
<jsp:useBean id="RecordSet_nf1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet_nf2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs_item" class="weaver.conn.RecordSet" scope="page" />
<%@ page import="weaver.interfaces.workflow.browser.Browser" %>
<%@ page import="weaver.interfaces.workflow.browser.BrowserBean" %>

<%@ page import="java.util.HashMap" %>
<%@ page import="weaver.system.code.*" %>
<%@ page import="weaver.general.TimeUtil" %>
<%@ page import="weaver.workflow.request.RevisionConstants" %>
<jsp:useBean id="requestPreAddM" class="weaver.workflow.request.RequestPreAddinoperateManager" scope="page" />
<jsp:useBean id="WfLinkageInfo" class="weaver.workflow.workflow.WfLinkageInfo" scope="page"/>
<jsp:useBean id="SpecialField" class="weaver.workflow.field.SpecialFieldInfo" scope="page" />
<jsp:useBean id="SecCategoryComInfo1" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="ProjectInfoComInfo1" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo1" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo1" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="DocComInfo1" class="weaver.docs.docs.DocComInfo" scope="page"/>
<jsp:useBean id="CapitalComInfo1" class="weaver.cpt.capital.CapitalComInfo" scope="page"/>
<jsp:useBean id="WorkflowRequestComInfo1" class="weaver.workflow.workflow.WorkflowRequestComInfo" scope="page"/>
<jsp:useBean id="RequestManager" class="weaver.workflow.request.RequestManager" scope="page"/>

<jsp:useBean id="ResourceConditionManager" class="weaver.workflow.request.ResourceConditionManager" scope="page"/>
<jsp:useBean id="BaseBean" class="weaver.general.BaseBean" scope="page"/>
<!--请求的标题开始 -->
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
<!-- 
<script type="text/javascript" language="javascript" src="/FCKEditor/fckeditor_wev8.js"></script>
<script type="text/javascript" language="javascript" src="/FCKEditor/CkeditorExt_wev8.js"></script>
 -->
 <link type="text/css" rel="stylesheet" href="/js/ecology8/weaverautocomplete/css/weaverautocomplete_wev8.css">
 <!-- 
 <script type="text/javascript" src="/wui/common/js/ckeditor/ckeditor_wev8.js"></script>
<script type="text/javascript" src="/wui/common/js/ckeditor/ckeditorext_wev8.js"></script>
 -->

<script type="text/javascript" src="../../js/weaver_wev8.js"></script>
<script type="text/javascript" src="/cpt/js/validate_wev8.js"></script>

<!--签字意见-->
<link rel="stylesheet" type="text/css" href="/css/ecology8/workflowsign_wev8.css" />

<script type="text/javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<script type="text/javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<!-- browser 相关 -->
<script type="text/javascript" src="/js/workflow/wfbrow_wev8.js"></script>
<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>
<!-- 明细样式 -->
<link href="/css/ecology8/workflowdetail_wev8.css" type="text/css" rel="stylesheet">

<%

//System.out.println("workflowaddrequestbody.jsp start...");

String selectInitJsStr = "";
String f_weaver_belongto_userid=request.getParameter("f_weaver_belongto_userid");//需要增加的代码
String f_weaver_belongto_usertype=request.getParameter("f_weaver_belongto_usertype");//需要增加的代码
user = HrmUserVarify.getUser(request, response, f_weaver_belongto_userid, f_weaver_belongto_usertype) ;//需要增加的代码
userid=user.getUID();                   //当前用户id
int usertype = 0;

// 得到每个字段的信息并在页面显示


String beagenter=""+userid;
//获得被代理人
int body_isagent=Util.getIntValue((String)session.getAttribute(workflowid+"isagent"+user.getUID()),0);
if(body_isagent==1){
    beagenter=""+Util.getIntValue((String)session.getAttribute(workflowid+"beagenter"+user.getUID()),0);
}

HashMap specialfield = SpecialField.getFormSpecialField();//特殊字段的字段信息


CodeBuild cbuild = new CodeBuild(Util.getIntValue(formid));
String  codeFields=Util.null2String(cbuild.haveCode());
ArrayList flowDocs=flowDoc.getDocFiled(""+workflowid); //得到流程建文挡的发文号字段


String codeField="";
Map secMaxUploads = new HashMap();//封装选择目录的信息


Map secCategorys = new HashMap();    
if (flowDocs!=null&&flowDocs.size()>0)
{
codeField=""+flowDocs.get(0);
}
ArrayList uploadfieldids=new ArrayList();
if (!fromFlowDoc.equals("1")) {%>
<br>
<div align="center">
<font style="font-size:14pt;FONT-WEIGHT: bold"><%=Util.toScreen(workflowname,user.getLanguage())%></font>
</div>
<title><%=Util.toScreen(workflowname,user.getLanguage())%></title>
<%}%>
<!--请求的标题结束 -->

<!--TD4262 增加提示信息  开始-->
<div id='_xTable' style='background:#FFFFFF;padding:3px;width:100%' valign='top'>
</div>
<!--TD4262 增加提示信息  结束-->
<iframe id="selectChange" frameborder=0 scrolling=no src=""  style="display:none"></iframe>
<iframe id="datainputform" frameborder=0 scrolling=no src=""  style="display:none"></iframe>
<iframe id="workflowKeywordIframe" frameborder=0 scrolling=no src=""  style="display:none"></iframe>

<%----- xwj for td3323 20051209 begin ------%>
<%
 int secid = Util.getIntValue(docCategory.substring(docCategory.lastIndexOf(",")+1),-1);
 int maxUploadImageSize = Util.getIntValue(SecCategoryComInfo1.getMaxUploadFileSize(""+secid),5);
 if(maxUploadImageSize<=0){
 maxUploadImageSize = 5;
 }
 int wfid = Util.getIntValue(workflowid, 0);
 int uploadType = 0;
 String selectedfieldid = "";
 String result = RequestManager.getUpLoadTypeForSelect(wfid);
 if(!result.equals("")){
 selectedfieldid = result.substring(0,result.indexOf(","));
 uploadType = Integer.valueOf(result.substring(result.indexOf(",")+1)).intValue();
 }
 //如果附件存放方式为选择目录，则重置默认值


 if(uploadType==1)
 {
	 maxUploadImageSize = 5;
 }
 boolean isCanuse = RequestManager.hasUsedType(wfid);
 if(selectedfieldid.equals("") || selectedfieldid.equals("0")){
 	isCanuse = false;
 }
 String docFlags=(String)session.getAttribute("requestAdd"+user.getUID());
String newTNflag=(String)session.getAttribute("requestAddNewNodes"+user.getUID());
String flowDocField=(String)session.getAttribute("requestFlowDocField"+user.getUID());

String keywordismand="0";
String keywordisedit="0";
int titleFieldId=0;
int keywordFieldId=0;
String isSignDoc_add="";
String isSignWorkflow_add="";
String smsAlertsType = "";
RecordSet.execute("select titleFieldId,keywordFieldId,isSignDoc,isSignWorkflow,smsAlertsType from workflow_base where id="+workflowid);
if(RecordSet.next()){
	titleFieldId=Util.getIntValue(RecordSet.getString("titleFieldId"),0);
	keywordFieldId=Util.getIntValue(RecordSet.getString("keywordFieldId"),0);
    isSignDoc_add=Util.null2String(RecordSet.getString("isSignDoc"));
    isSignWorkflow_add=Util.null2String(RecordSet.getString("isSignWorkflow"));
    smsAlertsType=Util.null2String(RecordSet.getString("smsAlertsType"));
}

 
  weaver.crm.Maint.CustomerInfoComInfo customerInfoComInfo = new weaver.crm.Maint.CustomerInfoComInfo();
  String usernamenew = "";
  	if(user.getLogintype().equals("1")){
  		usernamenew = username;
  	}
  	if(user.getLogintype().equals("2")){
  		usernamenew = customerInfoComInfo.getCustomerInfoname(""+user.getUID());
  	}
  	
   weaver.general.DateUtil   DateUtil=new weaver.general.DateUtil();
   String 	txtuseruse=DateUtil.getWFTitleNew(""+workflowid,""+user.getUID(),""+usernamenew,user.getLogintype());
  
if(body_isagent==1){
 
	txtuseruse=DateUtil.getWFTitleNew(""+workflowid,""+beagenter,""+username,user.getLogintype());
}



String selectfieldlable = "";
String selectfieldvalue = "";

if(uploadType==1 && !"".equals(selectedfieldid.trim())){
	
	String selectfieldsql = "";
	 if(isbill.equals("1")){
		 selectfieldsql = "SELECT bf.fieldlabel,bf.fieldname,b.tablename FROM workflow_billfield bf,workflow_bill b WHERE b.id=bf.billid AND bf.id="+selectedfieldid;
	 }else{
	 	 selectfieldsql = "select fl.fieldlable,fd.fieldname,'workflow_form' AS tablename  FROM workflow_fieldlable fl,workflow_formdict fd WHERE fl.fieldid=fd.id and fl.fieldid="+selectedfieldid+" AND fl.langurageid="+user.getLanguage()+" AND fl.formid="+formid;
	 }
 	 RecordSet_nf1.executeSql(selectfieldsql);
 	 if(RecordSet_nf1.next()){
 	    String _fieldlabel = RecordSet_nf1.getString(1);
 	    String _fieldname = RecordSet_nf1.getString("fieldname");
 	    String _tablename = RecordSet_nf1.getString("tablename");
 		if(isbill.equals("1")){
 			selectfieldlable = SystemEnv.getHtmlLabelName(Util.getIntValue(_fieldlabel),user.getLanguage());
 		}else{
 			selectfieldlable = _fieldlabel;
 		}
 		String _isdefault = ""; 
 		String _tdocCategory = "";	
        String _selectvalue = "";				
 		RecordSet_nf1.executeSql("SELECT selectvalue,docCategory,isdefault FROM workflow_SelectItem WHERE fieldid="+selectedfieldid+" ORDER BY listorder");
 		while(RecordSet_nf1.next()){
 		  	_tdocCategory = RecordSet_nf1.getString(2).trim();
 		  	_isdefault = Util.null2String(RecordSet_nf1.getString(3));
			_selectvalue = RecordSet_nf1.getString(1).trim();
 		  	if("y".equals(_isdefault)){
 		  		selectfieldvalue = _selectvalue;
 		  	}
 		  	if(!"".equals(_tdocCategory)){
 		  		int _tsecid = Util.getIntValue(_tdocCategory.substring(_tdocCategory.lastIndexOf(",")+1),-1);
                String _tMaxUploadFileSize = ""+Util.getIntValue(SecCategoryComInfo1.getMaxUploadFileSize(""+_tsecid),5);
                secMaxUploads.put(_selectvalue,_tMaxUploadFileSize);
                secCategorys.put(_selectvalue,_tdocCategory);
 		  	}
 		}
 	 }
}


%>
<script language=javascript>
function createAndRemoveObj(obj){
    objName = obj.name;
    //var  newObj = document.createElement("input");
    //newObj.name=objName;
    //newObj.className="InputStyle";
    //newObj.type="file";
    //newObj.size=70;
    //newObj.onchange=function(){accesoryChanage(this);};

    //var objParentNode = obj.parentNode;
    //var objNextNode = obj.nextSibling;
    //obj.removeNode();
    //objParentNode.insertBefore(newObj,objNextNode);
    tempObjonchange=obj.onchange;
    outerHTML="<input name="+objName+" class=InputStyle type=file size=60 >";  
    $GetEle(objName).outerHTML=outerHTML;       
    $GetEle(objName).onchange=tempObjonchange;
}
</script>
<%----- xwj for td3323 20051209 end ------%>

<input type=hidden name="workflowRequestLogId" value="-1">
<input type="hidden" name="htmlfieldids">

<input type=hidden name ="uploadType" id="uploadType" value="<%=uploadType %>">
<input type=hidden name ="selectfieldvalue" id="selectfieldvalue" value="<%=selectfieldvalue %>">

<table class="ViewForm" >
  <colgroup>
  <col width="20%">
  <col width="80%">

  <!--新建的第一行，包括说明和重要性 -->

  <tr style="height:1px;"><td class=Line1 colSpan=2></td></tr>
  <tr>
    <td class="fieldnameClass"><%=SystemEnv.getHtmlLabelName(21192,user.getLanguage())%></td>
    <td class=fieldvalueClass>
      <!--modify by xhheng @20050318 for TD1689-->
      <%if(defaultName==1){%>
       <%--xwj for td1806 on 2005-05-09--%>
        <input type=text class=Inputstyle  temptitle="<%=SystemEnv.getHtmlLabelName(21192,user.getLanguage())%>" name=requestname onChange="checkinput('requestname','requestnamespan');changeKeyword()" size=<%=RequestConstants.RequestName_Size%> maxlength=<%=RequestConstants.RequestName_MaxLength%>  value = "<%=Util.toScreenToEdit( txtuseruse,user.getLanguage() )%>" >
        <span id=requestnamespan>
		<%
		 if(txtuseruse.equals("")){
		%>	
		<img src="/images/BacoError_wev8.gif" align=absmiddle>
		 <%}
		%>
		
		</span>
      <%}else{%>
        <input type=text class=Inputstyle  temptitle="<%=SystemEnv.getHtmlLabelName(21192,user.getLanguage())%>" name=requestname onChange="checkinput('requestname','requestnamespan');changeKeyword()" size=<%=RequestConstants.RequestName_Size%> maxlength=<%=RequestConstants.RequestName_MaxLength%>  value = "" >
        <span id=requestnamespan><img src="/images/BacoError_wev8.gif" align=absmiddle></span>
      <%}%>
      <input type=radio value="0" name="requestlevel" checked><%=SystemEnv.getHtmlLabelName(225,user.getLanguage())%>
      <input type=radio value="1" name="requestlevel"><%=SystemEnv.getHtmlLabelName(15533,user.getLanguage())%>
      <input type=radio value="2" name="requestlevel"><%=SystemEnv.getHtmlLabelName(2087,user.getLanguage())%>
    </td>
  </tr>
<tr style="height:1px;"><td class=Line2 colSpan=2></td></tr>
  <!--第一行结束 -->
  <!--add by xhheng @ 2005/01/24 for 消息提醒 Request06，短信设置行开始 -->
  <%
    if(messageType == 1){
  %>
  <tr>
    <td class="fieldnameClass" > <%=SystemEnv.getHtmlLabelName(17586,user.getLanguage())%></td>
    <td class=fieldvalueClass>
	      <span id=messageTypeSpan></span>
	      <input type=radio value="0" name="messageType" <% if(smsAlertsType.equals("0")) {%> checked<%}%>><%=SystemEnv.getHtmlLabelName(17583,user.getLanguage())%>
	      <input type=radio value="1" name="messageType" <% if(smsAlertsType.equals("1")) {%> checked<%}%>><%=SystemEnv.getHtmlLabelName(17584,user.getLanguage())%>
	      <input type=radio value="2" name="messageType" <% if(smsAlertsType.equals("2")) {%> checked<%}%>><%=SystemEnv.getHtmlLabelName(17585,user.getLanguage())%>
	    </td>
  </tr>
  <tr style="height:1px;"><td class=Line2 colSpan=2></td></tr>

  <%}%>


  <!--短信设置行结束 -->

<%

//查询表单或者单据的字段,字段的名称，字段的HTML类型和字段的类型（基于HTML类型的一个扩展）

ArrayList fieldids=new ArrayList();             //字段队列
ArrayList fieldorders = new ArrayList();        //字段显示顺序队列 (单据文件不需要)
ArrayList languageids=new ArrayList();          //字段显示的语言(单据文件不需要)
ArrayList fieldlabels=new ArrayList();          //单据的字段的label队列
ArrayList fieldhtmltypes=new ArrayList();       //单据的字段的html type队列
ArrayList fieldtypes=new ArrayList();           //单据的字段的type队列
ArrayList fieldnames=new ArrayList();           //单据的字段的表字段名队列
ArrayList fieldviewtypes=new ArrayList();       //单据是否是detail表的字段1:是 0:否(如果是,将不显示)
ArrayList fieldrealtype=new ArrayList();
int detailno=0;
// 确定字段是否显示，是否可以编辑，是否必须输入
ArrayList isfieldids=new ArrayList();              //字段队列
ArrayList isviews=new ArrayList();              //字段是否显示队列
ArrayList isedits=new ArrayList();              //字段是否可以编辑队列
ArrayList ismands=new ArrayList();              //字段是否必须输入队列

String isbodyview="0" ;    //字段是否显示
String isbodyedit="0" ;    //字段是否可以编辑
String isbodymand="0" ;    //字段是否必须输入
String fieldbodyid="";
String fieldbodyname = "" ;                         //字段数据库表中的字段名


String fieldbodyhtmltype = "" ;                     //字段的页面类型


String fieldbodytype = "" ;                         //字段的类型


String fieldbodylable = "" ;                        //字段显示名


String fielddbtype="";                              //字段数据类型
int languagebodyid = 0 ;
int detailsum=0;
String isdetail = "";//xwj for @td2977 20051111
String textheight = "4";//xwj for @td2977 20051111
int fieldlen=0;  //字段类型长度

String bclick="";
String isbrowisMust = "";

//获得触发字段名


DynamicDataInput ddi=new DynamicDataInput(workflowid+"");
String trrigerfield=ddi.GetEntryTriggerFieldName();
ArrayList selfieldsadd=WfLinkageInfo.getSelectField(Util.getIntValue(workflowid),Util.getIntValue(nodeid),0);
ArrayList changefieldsadd=WfLinkageInfo.getChangeField(Util.getIntValue(workflowid),Util.getIntValue(nodeid),0);
if(isbill.equals("0")) {
    RecordSet.executeSql("select t2.fieldid,t2.fieldorder,t1.fieldlable,t1.langurageid from workflow_fieldlable t1,workflow_formfield t2 where t1.formid=t2.formid and t1.fieldid=t2.fieldid and (t2.isdetail<>'1' or t2.isdetail is null)  and t2.formid="+formid+"  and t1.langurageid="+user.getLanguage()+" order by t2.fieldorder");

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
		//out.println("<b>LANGUAGE:"+Util.null2String(RecordSet.getString("languageid"))+"</b>");
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
		fieldrealtype.add(Util.null2String(RecordSet.getString("fielddbtype")));
        //字段显示不应该在这里处理，这样很消耗性能，屏蔽掉   mackjoe at 2006-06-07
        /*
            RecordSet_nf1.executeSql("select * from workflow_nodeform where nodeid = "+nodeid+" and fieldid = " + RecordSet.getString("id"));
        if(!RecordSet_nf1.next()){
        RecordSet_nf2.executeSql("insert into workflow_nodeform(nodeid,fieldid,isview,isedit,ismandatory) values("+nodeid+","+RecordSet.getString("id")+",'1','1','0')");
        }
        */
    }
}

RecordSet.executeProc("workflow_FieldForm_Select",nodeid+"");
while(RecordSet.next()){
    isfieldids.add(Util.null2String(RecordSet.getString("fieldid")));
    isviews.add(Util.null2String(RecordSet.getString("isview")));
    isedits.add(Util.null2String(RecordSet.getString("isedit")));
    ismands.add(Util.null2String(RecordSet.getString("ismandatory")));
}
//modify by mackjoe at 2006-06-07 td4491 将节点前附加操作移出循环外操作减少数据库访问量


//TD10029
ArrayList inoperatefields = new ArrayList();
ArrayList inoperatevalues = new ArrayList();
int fieldop1id=0;
requestPreAddM.setCreater(user.getUID());
requestPreAddM.setOptor(user.getUID());
requestPreAddM.setWorkflowid(Util.getIntValue(workflowid));
requestPreAddM.setNodeid(Util.getIntValue(nodeid));
Hashtable getPreAddRule_hs = requestPreAddM.getPreAddRule();
inoperatefields = (ArrayList)getPreAddRule_hs.get("inoperatefields");
inoperatevalues = (ArrayList)getPreAddRule_hs.get("inoperatevalues");


String preAdditionalValue = "";
boolean isSetFlag = false;//xwj for td3308 20051124
for(int i=0;i<fieldids.size();i++){         // 循环开始



    //数据初始化


	isbodyview="0";
	isbodyedit="0";
	isbodymand="0";

  int tmpindex = i ;
    if(isbill.equals("0")) tmpindex = fieldorders.indexOf(""+i);     // 如果是表单, 得到表单顺序对应的 i

	fieldbodyid=(String)fieldids.get(tmpindex);  //字段id
    if( isbill.equals("1")) {
        String viewtype = (String)fieldviewtypes.get(tmpindex) ;   // 如果是单据的从表字段,不显示


        if( viewtype.equals("1") ) continue ;
    }

 /*---xwj for td3130 20051124 begin ---*/
  preAdditionalValue = "";
  isSetFlag = false;//added by xwj for td3359 20051222
  //将节点前附加操作移出循环外操作减少数据库访问量


  //rsaddop.executeSql("select customervalue from workflow_addinoperate where workflowid=" + workflowid + " and ispreadd='1' and isnode = 1 and objid = "+nodeid+" and fieldid = " + fieldbodyid);
  int inoperateindex=inoperatefields.indexOf(fieldbodyid);
  if(inoperateindex>-1){
  isSetFlag = true;
  preAdditionalValue = (String)inoperatevalues.get(inoperateindex);
  }
  /*---xwj for td3130 20051124 end ---*/

    int isfieldidindex = isfieldids.indexOf(fieldbodyid) ;
    if( isfieldidindex != -1 ) {
        isbodyview=(String)isviews.get(isfieldidindex);    //字段是否显示
	    isbodyedit=(String)isedits.get(isfieldidindex);    //字段是否可以编辑
	    isbodymand=(String)ismands.get(isfieldidindex);    //字段是否必须输入
    }
    
    if ("1".equals(isbodyedit)) {
        isbrowisMust = "1";
    }
    
    if ("1".equals(isbodymand)) {
        isbrowisMust = "2";
    }

    if(isbill.equals("0")) {
        languagebodyid= Util.getIntValue( (String)languageids.get(tmpindex), 0 ) ;    //需要更新


        fieldbodyhtmltype=FieldComInfo.getFieldhtmltype(fieldbodyid);
        fieldbodytype=FieldComInfo.getFieldType(fieldbodyid);
        fieldbodylable=(String)fieldlabels.get(tmpindex);
        fieldbodyname=FieldComInfo.getFieldname(fieldbodyid);
		fielddbtype=FieldComInfo.getFielddbtype(fieldbodyid);

    }
    else {
        languagebodyid = user.getLanguage() ;
        fieldbodyname=(String)fieldnames.get(tmpindex);
        fieldbodyhtmltype=(String)fieldhtmltypes.get(tmpindex);
        fieldbodytype=(String)fieldtypes.get(tmpindex);
		fielddbtype=(String)fieldrealtype.get(tmpindex);
        fieldbodylable = SystemEnv.getHtmlLabelName( Util.getIntValue((String)fieldlabels.get(tmpindex),0),languagebodyid );
    }
	 fieldlen=0;
    if ((fielddbtype.toLowerCase()).indexOf("varchar")>-1)
	{
	   fieldlen=Util.getIntValue(fielddbtype.substring(fielddbtype.indexOf("(")+1,fielddbtype.length()-1));

	}
    if(fieldbodyname.equals("manager")) {
	    String tmpmanagerid = ResourceComInfo.getManagerID(beagenter);
%>
	<input type=hidden id="field<%=fieldbodyid%>" name="field<%=fieldbodyid%>"  value="<%=tmpmanagerid%>" />
<%
    if(isbodyview.equals("1")){
%> <tr>
      <td class="fieldnameClass" <%if(fieldbodyhtmltype.equals("2")){%> valign=top <%}%>> <%=Util.toScreen(fieldbodylable,languagebodyid)%> </td>
      <td class=fieldvalueClass><%=ResourceComInfo.getLastname(tmpmanagerid)%></td>
   </tr><tr style="height:1px;"><td class=Line2 colSpan=2></td></tr>
<%
    }
	    continue;
	}
    if( ! isbodyview.equals("1") ) { //不显示即进行下一步循环,除了人力资源字段，应该隐藏人力资源字段，因为人力资源字段有可能作为流程下一节点的操作者


        if(fieldbodyhtmltype.equals("3") && (fieldbodytype.equals("1") ||fieldbodytype.equals("17")||fieldbodytype.equals("165")||fieldbodytype.equals("166")) && !preAdditionalValue.equals("")){           
           out.println("<input type=hidden name=field"+fieldbodyid+" value="+preAdditionalValue+">");
        }else if(!preAdditionalValue.equals("")){
        	out.println("<input type=hidden name=field"+fieldbodyid+" value="+preAdditionalValue+">");
        }        
        continue ;                  
    }
	if(fieldbodyname.equals("begindate")) newfromdate="field"+fieldbodyid;      //开始日期,主要为开始日期不大于结束日期进行比较
	if(fieldbodyname.equals("enddate")) newenddate="field"+fieldbodyid;     //结束日期,主要为开始日期不大于结束日期进行比较
	if((""+keywordFieldId).equals(fieldbodyid)) keywordismand=isbodymand;     
	if((""+keywordFieldId).equals(fieldbodyid)) keywordisedit=isbodyedit;     

    if(isbodymand.equals("1")&&!fieldbodyid.equals(codeField)&&!fieldbodyid.equals(codeField))  needcheck+=",field"+fieldbodyid;   //如果必须输入,加入必须输入的检查中(如果是发问号字段，不必输入检查，程序自动生成)

    // 下面开始逐行显示字段
%>
    <tr>
      <td class="fieldnameClass" <%if(fieldbodyhtmltype.equals("2")){%> valign=top <%}%>> <%=Util.toScreen(fieldbodylable,languagebodyid)%> </td>
      <td class=fieldvalueClass style="word-wrap:break-word;word-break:break-all;">
      <%
        if(fieldbodyhtmltype.equals("1")){                          // 单行文本框


            if(fieldbodytype.equals("1")){                          // 单行文本框中的文本


                if(isbodyview.equals("1")){

                if(isbodyedit.equals("1")&&!fieldbodyid.equals(codeField)&&!fieldbodyid.equals(codeFields)){
					if(keywordFieldId>0&&(""+keywordFieldId).equals(fieldbodyid)){
%>
<button  id="field<%=fieldbodyid%>browser" name="field<%=fieldbodyid%>browser" type=button class=Browser  onclick="onShowKeyword(field<%=fieldbodyid%>.getAttribute('viewtype'))" title="<%=SystemEnv.getHtmlLabelName(21517,user.getLanguage())%>"></button>
<%
					}
                    if(isbodymand.equals("1")) {
      %>
        <input datatype="text" viewtype="<%=isbodymand%>" type=text class=Inputstyle temptitle="<%=Util.toScreen(fieldbodylable,languagebodyid)%>" id="field<%=fieldbodyid%>" name="field<%=fieldbodyid%>"  size=50 onChange="checkinput2('field<%=fieldbodyid%>','field<%=fieldbodyid%>span',this.getAttribute('viewtype'));checkLength('field<%=fieldbodyid%>','<%=fieldlen%>','<%=Util.toScreen(fieldbodylable,languagebodyid)%>','<%=SystemEnv.getHtmlLabelName(20246,user.getLanguage())%>','<%=SystemEnv.getHtmlLabelName(20247,user.getLanguage())%>')<%if(titleFieldId>0&&keywordFieldId>0&&(""+titleFieldId).equals(fieldbodyid)){%>;changeKeyword()<%}%>"<%if(trrigerfield.indexOf("field"+fieldbodyid)>=0){%> onBlur="datainput('field<%=fieldbodyid%>');" <%}%> value="<%=preAdditionalValue%>">
        <span id="field<%=fieldbodyid%>span"><%if("".equals(preAdditionalValue)){%><img src="/images/BacoError_wev8.gif" align=absmiddle><%}%></span><!--modified by xwj for td3130 20051124-->
      <%

				    }else{%>
        <input datatype="text" viewtype="<%=isbodymand%>" temptitle="<%=Util.toScreen(fieldbodylable,languagebodyid)%>" type=text class=Inputstyle id="field<%=fieldbodyid%>" name="field<%=fieldbodyid%>"  size=50 onChange="checkinput2('field<%=fieldbodyid%>','field<%=fieldbodyid%>span',this.getAttribute('viewtype'));checkLength('field<%=fieldbodyid%>','<%=fieldlen%>','<%=Util.toScreen(fieldbodylable,languagebodyid)%>','<%=SystemEnv.getHtmlLabelName(20246,user.getLanguage())%>','<%=SystemEnv.getHtmlLabelName(20247,user.getLanguage())%>')<%if(titleFieldId>0&&keywordFieldId>0&&(""+titleFieldId).equals(fieldbodyid)){%>;changeKeyword()<%}%>" <%if(trrigerfield.indexOf("field"+fieldbodyid)>=0){%> onBlur="datainput('field<%=fieldbodyid%>')" <%}%> value="<%=preAdditionalValue%>"><!--modified by xwj for td3130 20051124-->
        <span id="field<%=fieldbodyid%>span"></span>
      <%            }
		    }else{ %>
        <!--input  type=text class=Inputstyle id="field<%=fieldbodyid%>" name="field<%=fieldbodyid%>"   size=50 readonly-->
            <span id="field<%=fieldbodyid%>span"><%=preAdditionalValue%></span>
            <input  type=hidden class=Inputstyle id="field<%=fieldbodyid%>" name="field<%=fieldbodyid%>"   size=50 value="<%=preAdditionalValue%>"><!--modified by xwj for td3130 20051124-->
      <%          }
            }
            }
		    else if(fieldbodytype.equals("2")){                     // 单行文本框中的整型


                if(isbodyview.equals("1")){
			    if(isbodyedit.equals("1")){
				    if(isbodymand.equals("1")) {
      %>
        <input  datatype="int" viewtype="<%=isbodymand%>" type=text class=Inputstyle temptitle="<%=Util.toScreen(fieldbodylable,languagebodyid)%>" id="field<%=fieldbodyid%>" name="field<%=fieldbodyid%>"  size=20
		onKeyPress="ItemCount_KeyPress()" <%if(trrigerfield.indexOf("field"+fieldbodyid)>=0){%>onBlur="checkcount1(this);checkItemScale(this,'<%=SystemEnv.getHtmlLabelName(31181,user.getLanguage()).replace("12","9")%>',-999999999,999999999);checkinput2('field<%=fieldbodyid%>','field<%=fieldbodyid%>span',this.getAttribute('viewtype'));datainput('field<%=fieldbodyid%>')" <%}else{%> onBlur="checkcount1(this);checkItemScale(this,'<%=SystemEnv.getHtmlLabelName(31181,user.getLanguage()).replace("12","9")%>',-999999999,999999999);checkinput2('field<%=fieldbodyid%>','field<%=fieldbodyid%>span',this.getAttribute('viewtype'));" <%}%> value="<%=preAdditionalValue%>">
        <span id="field<%=fieldbodyid%>span"><%if("".equals(preAdditionalValue)){%><img src="/images/BacoError_wev8.gif" align=absmiddle><%}%></span><!--modified by xwj for td3130 20051124-->
       <%

				    }else{%>
        <input  datatype="int" viewtype="<%=isbodymand%>" temptitle="<%=Util.toScreen(fieldbodylable,languagebodyid)%>" type=text class=Inputstyle id="field<%=fieldbodyid%>" name="field<%=fieldbodyid%>"  size=20 onKeyPress="ItemCount_KeyPress()" <%if(trrigerfield.indexOf("field"+fieldbodyid)>=0){%>onBlur="checkcount1(this);checkItemScale(this,'<%=SystemEnv.getHtmlLabelName(31181,user.getLanguage()).replace("12","9")%>',-999999999,999999999);datainput('field<%=fieldbodyid%>');checkinput2('field<%=fieldbodyid%>','field<%=fieldbodyid%>span',this.getAttribute('viewtype'));" <%}else{%> onBlur="checkcount1(this);checkItemScale(this,'<%=SystemEnv.getHtmlLabelName(31181,user.getLanguage()).replace("12","9")%>',-999999999,999999999);checkinput2('field<%=fieldbodyid%>','field<%=fieldbodyid%>span',this.getAttribute('viewtype'));" <%}%> value="<%=preAdditionalValue%>"> <!--modified by xwj for td3130 20051124-->
        <span id="field<%=fieldbodyid%>span"></span>
       <%           }
			    }else{  %>
         <!--input datatype="int" type=text class=Inputstyle id="field<%=fieldbodyid%>" name="field<%=fieldbodyid%>"  size=20 readonly-->
         <span id="field<%=fieldbodyid%>span"><%=preAdditionalValue%></span>
         <input datatype="int" type=hidden class=Inputstyle id="field<%=fieldbodyid%>" name="field<%=fieldbodyid%>"  value="<%=preAdditionalValue%>"><!--modified by xwj for td3130 20051124-->
        <%        }
            }
            }
		    else if(fieldbodytype.equals("3")||fieldbodytype.equals("5")){                     // 单行文本框中的浮点型
		    	int decimaldigits_t = 2;
		    	if(fieldbodytype.equals("3")){
		    		int digitsIndex = fielddbtype.indexOf(",");
		        	if(digitsIndex > -1){
		        		decimaldigits_t = Util.getIntValue(fielddbtype.substring(digitsIndex+1, fielddbtype.length()-1), 2);
		        	}else{
		        		decimaldigits_t = 2;
		        	}
		    	}
                if(isbodyview.equals("1")){
			    if(isbodyedit.equals("1")){
				    if(isbodymand.equals("1")) {
       %>
        <input datatype="float" viewtype="<%=isbodymand%>" type=text class=Inputstyle temptitle="<%=Util.toScreen(fieldbodylable,languagebodyid)%>" id="field<%=fieldbodyid%>" name="field<%=fieldbodyid%>"  size=20
		onKeyPress="ItemDecimal_KeyPress('field<%=fieldbodyid%>',15,<%=decimaldigits_t%>)" <%if(fieldbodytype.equals("5")){%>onfocus="changeToNormalFormat('field<%=fieldbodyid%>')"<%}%> <%if(trrigerfield.indexOf("field"+fieldbodyid)>=0){%>onBlur="checkFloat(this);checkinput2('field<%=fieldbodyid%>','field<%=fieldbodyid%>span',this.getAttribute('viewtype'));datainput('field<%=fieldbodyid%>');<%if(fieldbodytype.equals("5")){%>changeToThousands('field<%=fieldbodyid%>')<%}%>"<%}else{%> onBlur="checkFloat(this);checkinput2('field<%=fieldbodyid%>','field<%=fieldbodyid%>span',this.getAttribute('viewtype'));<%if(fieldbodytype.equals("5")){%>changeToThousands('field<%=fieldbodyid%>')<%}%>"<%}%> value="<%=preAdditionalValue%>">
        <span id="field<%=fieldbodyid%>span"><%if("".equals(preAdditionalValue)){%><img src="/images/BacoError_wev8.gif" align=absmiddle><%}%></span><!--modified by xwj for td3130 20051124-->
       <%
    				}else{%>
        <input datatype="float" viewtype="<%=isbodymand%>" temptitle="<%=Util.toScreen(fieldbodylable,languagebodyid)%>" type=text class=Inputstyle id="field<%=fieldbodyid%>" name="field<%=fieldbodyid%>"  size=20 onKeyPress="ItemDecimal_KeyPress('field<%=fieldbodyid%>',15,<%=decimaldigits_t%>)" <%if(fieldbodytype.equals("5")){%>onfocus="changeToNormalFormat('field<%=fieldbodyid%>')"<%}%> <%if(trrigerfield.indexOf("field"+fieldbodyid)>=0){%>onBlur="checkFloat(this);datainput('field<%=fieldbodyid%>');checkinput2('field<%=fieldbodyid%>','field<%=fieldbodyid%>span',this.getAttribute('viewtype')); <%if(fieldbodytype.equals("5")){%>changeToThousands('field<%=fieldbodyid%>')<%}%> " <%}else{%> onBlur="checkFloat(this);checkinput2('field<%=fieldbodyid%>','field<%=fieldbodyid%>span',this.getAttribute('viewtype')); <%if(fieldbodytype.equals("5")){%>changeToThousands('field<%=fieldbodyid%>')<%}%> "<%}%> value="<%=preAdditionalValue%>"><!--modified by xwj for td3130 20051124-->
        <span id="field<%=fieldbodyid%>span"></span>
       <%           }
               }else{  %>
         <!--input datatype="float" type=text class=Inputstyle id="field<%=fieldbodyid%>" name="field<%=fieldbodyid%>"   size=20 readonly-->
         <span id="field<%=fieldbodyid%>span"><%=preAdditionalValue%></span>
         <input datatype="float" type=hidden class=Inputstyle id="field<%=fieldbodyid%>" name="field<%=fieldbodyid%>"  value="<%=preAdditionalValue%>"><!--modified by xwj for td3130 20051124-->
        <%        }
		    }
	    }
	     /*-----------xwj for td3131 20051115 begin ----------*/
	    else if(fieldbodytype.equals("4")){%>
            <table cols=2 id="field<%=fieldbodyid%>_tab">
            <tr><td>
                <%if(isbodyview.equals("1")){
                    if(isbodyedit.equals("1")){%>
                        <input datatype="float" viewtype="<%=isbodymand%>" type=text class=Inputstyle name="field_lable<%=fieldbodyid%>" size=60
                            onfocus="FormatToNumber('<%=fieldbodyid%>')"
                            onKeyPress="ItemNum_KeyPress('field_lable<%=fieldbodyid%>')"
                            <%if(trrigerfield.indexOf("field"+fieldbodyid)>=0){%>
                                onBlur="checkFloat(this);numberToFormat('<%=fieldbodyid%>');datainput('field_lable<%=fieldbodyid%>');checkinput2('field_lable<%=fieldbodyid%>','field_lable<%=fieldbodyid%>span',field<%=fieldbodyid%>.getAttribute('viewtype'))"
                            <%}else{%>
                                onBlur="checkFloat(this);numberToFormat('<%=fieldbodyid%>');checkinput2('field_lable<%=fieldbodyid%>','field_lable<%=fieldbodyid%>span',field<%=fieldbodyid%>.getAttribute('viewtype'))"
                            <%}%>
                        >
                        <span id="field_lable<%=fieldbodyid%>span"><%if("".equals(preAdditionalValue)&&isbodymand.equals("1")){%><img src="/images/BacoError_wev8.gif" align=absmiddle><%}%></span><!--modified by xwj for td3130 20051124-->
                        <span id="field<%=fieldbodyid%>span"></span>
                        <input datatype="float" viewtype="<%=isbodymand%>" type=hidden class=Inputstyle temptitle="<%=Util.toScreen(fieldbodylable,languagebodyid)%>" id="field<%=fieldbodyid%>" name="field<%=fieldbodyid%>"  value="">
                    <%}else{%>
                        <span id="field<%=fieldbodyid%>span"></span>
                        <input datatype="float" type=text class=Inputstyle name="field_lable<%=fieldbodyid%>" disabled="true">
                        <input datatype="float" type=hidden class=Inputstyle id="field<%=fieldbodyid%>" name="field<%=fieldbodyid%>"  value="">
                    <%}
                }
                if(!"".equals(preAdditionalValue)){%>
                    <script language="javascript">
                        $GetEle("field_lable"+<%=fieldbodyid%>).value  = numberChangeToChinese(<%=preAdditionalValue%>);
                        $GetEle("field"+<%=fieldbodyid%>).value  = <%=preAdditionalValue%>;
                    </script>
                <%}%>
            </td></tr>
            <tr><td>
                <input type=text class=Inputstyle size=60 name="field_chinglish<%=fieldbodyid%>" readOnly="true">
            </td></tr>
            </table>
	    <%}
	    /*-----------xwj for td3131 20051115 end ----------*/
        if(changefieldsadd.indexOf(fieldbodyid)>=0){
%>
    <input type=hidden name="oldfieldview<%=fieldbodyid%>" value="<%=Util.getIntValue(isbodyview,0)+Util.getIntValue(isbodyedit,0)+Util.getIntValue(isbodymand,0)%>" />
<%
    }
        }// 单行文本框条件结束


	    else if(fieldbodyhtmltype.equals("2")){                     // 多行文本框


	     /*-----xwj for @td2977 20051111 begin-----*/
	     if(isbill.equals("0")){
			 rscount.executeSql("select * from workflow_formdict where id = " + fieldbodyid);
			 if(rscount.next()){
			 textheight = rscount.getString("textheight");
			 }
			 }else{
					rscount.executeSql("select * from workflow_billfield where viewtype=0 and id = " + fieldbodyid+" and billid="+formid);
					if(rscount.next()){
						textheight = ""+Util.getIntValue(rscount.getString("textheight"), 4);
					}
				}
			    /*-----xwj for @td2977 20051111 begin-----*/
            if(isbodyview.equals("1")){
		    if(isbodyedit.equals("1")){
			    if(isbodymand.equals("1")) {
       %>
        <textarea class=Inputstyle viewtype="<%=isbodymand%>" temptitle="<%=Util.toScreen(fieldbodylable,languagebodyid)%>" id="field<%=fieldbodyid%>" name="field<%=fieldbodyid%>"  <%if(trrigerfield.indexOf("field"+fieldbodyid)>=0){%> onBlur="datainput('field<%=fieldbodyid%>');" <%}%> onChange="checkinput2('field<%=fieldbodyid%>','field<%=fieldbodyid%>span',this.getAttribute('viewtype'));checkLengthfortext('field<%=fieldbodyid%>','<%=fieldlen%>','<%=Util.toScreen(fieldbodylable,languagebodyid)%>','<%=SystemEnv.getHtmlLabelName(20246,user.getLanguage())%>','<%=SystemEnv.getHtmlLabelName(20247,user.getLanguage())%>')"
		rows="<%=textheight%>" cols="40" style="width:80%" class=Inputstyle ><%=preAdditionalValue%></textarea><!--xwj for @td2977 20051111-->
        <span id="field<%=fieldbodyid%>span"><%if("".equals(preAdditionalValue)){%><img src="/images/BacoError_wev8.gif" align=absmiddle><%}%></span><!--modified by xwj for td3130 20051124-->

       <%
			    }else{
       %>
        <textarea class=Inputstyle viewtype="<%=isbodymand%>" temptitle="<%=Util.toScreen(fieldbodylable,languagebodyid)%>" onchange="checkinput2('field<%=fieldbodyid%>','field<%=fieldbodyid%>span',this.getAttribute('viewtype'));checkLengthfortext('field<%=fieldbodyid%>','<%=fieldlen%>','<%=Util.toScreen(fieldbodylable,languagebodyid)%>','<%=SystemEnv.getHtmlLabelName(20246,user.getLanguage())%>','<%=SystemEnv.getHtmlLabelName(20247,user.getLanguage())%>')" id="field<%=fieldbodyid%>" name="field<%=fieldbodyid%>" id="field<%=fieldbodyid%>"  <%if(trrigerfield.indexOf("field"+fieldbodyid)>=0){%> onBlur="checkinput2('field<%=fieldbodyid%>','field<%=fieldbodyid%>span',this.getAttribute('viewtype'));datainput('field<%=fieldbodyid%>');" <%}%> rows="<%=textheight%>" cols="40" style="width:80%"><%=Util.encodeAnd(preAdditionalValue)%></textarea><!--xwj for @td2977 20051111--><!--modified by xwj for td3130 20051124-->
        <span id="field<%=fieldbodyid%>span"></span>
       <%       }%>
	   <script>$GetEle("htmlfieldids").value += "field<%=fieldbodyid%>;<%=Util.toScreen(fieldbodylable,languagebodyid)%>;<%=fieldbodytype%>,";</script>
       <%  if (fieldbodytype.equals("2")) {%>
		   	<script>function funcField<%=fieldbodyid%>(){
				CkeditorExt.initEditor('frmmain','field<%=fieldbodyid%>',<%=user.getLanguage()%>,CkeditorExt.NO_IMAGE,200);
				<%if(isbodyedit.equals("1"))out.println("CkeditorExt.checkText('field"+fieldbodyid+"span','field"+fieldbodyid+"');");%>
				CkeditorExt.toolbarExpand(false,"field<%=fieldbodyid%>");
				}
				//window.attachEvent("onload", funcField<%=fieldbodyid%>);
		   	if (window.addEventListener){
        	    window.addEventListener("load", funcField<%=fieldbodyid%>, false);
        	}else if (window.attachEvent){
        	    window.attachEvent("onload", funcField<%=fieldbodyid%>);
        	}else{
        	    window.onload=funcField<%=fieldbodyid%>;
        	}
			</script>
		<%} }else{  %>
                <span id="field<%=fieldbodyid%>span"><%=preAdditionalValue%></span>
                <input type=hidden class=Inputstyle id="field<%=fieldbodyid%>" name="field<%=fieldbodyid%>"  value='<%=preAdditionalValue%>'><!--modified by xwj for td3130 20051124-->
         <!--textarea  class=Inputstyle id="field<%=fieldbodyid%>" name="field<%=fieldbodyid%>"  rows="4" cols="40" style="width:80%"  readonly></textarea-->
        <%        }
	    }
        if(changefieldsadd.indexOf(fieldbodyid)>=0){
%>
    <input type=hidden name="oldfieldview<%=fieldbodyid%>" value="<%=Util.getIntValue(isbodyview,0)+Util.getIntValue(isbodyedit,0)+Util.getIntValue(isbodymand,0)%>" />
<%
    }
        }// 多行文本框条件结束


	    else if(fieldbodyhtmltype.equals("3")){                         // 浏览按钮 (涉及workflow_broswerurl表)
		    String url=BrowserComInfo.getBrowserurl(fieldbodytype);     // 浏览按钮弹出页面的url
		    String linkurl=BrowserComInfo.getLinkurl(fieldbodytype);    // 浏览值点击的时候链接的url
		    String showname = "";                                   // 新建时候默认值显示的名称
		    String showid = "";                                     // 新建时候默认值




            if((fieldbodytype.equals("8") || fieldbodytype.equals("135")) && !prjid.equals("")){       //浏览按钮为项目,从前面的参数中获得项目默认值


                showid = "" + Util.getIntValue(prjid,0);
            }else if((fieldbodytype.equals("9") || fieldbodytype.equals("37")) && !docid.equals("")){ //浏览按钮为文档,从前面的参数中获得文档默认值


                showid = "" + Util.getIntValue(docid,0);
            }else if((fieldbodytype.equals("1") ||fieldbodytype.equals("17")||fieldbodytype.equals("165")||fieldbodytype.equals("166")) && !hrmid.equals("")){ //浏览按钮为人,从前面的参数中获得人默认值


                showid = "" + Util.getIntValue(hrmid,0);
            }else if((fieldbodytype.equals("7") || fieldbodytype.equals("18")) && !crmid.equals("")){ //浏览按钮为CRM,从前面的参数中获得CRM默认值


                showid = "" + Util.getIntValue(crmid,0);
            }else if((fieldbodytype.equals("16") || fieldbodytype.equals("152") || fieldbodytype.equals("171")) && !reqid.equals("")){ //浏览按钮为REQ,从前面的参数中获得REQ默认值


                showid = "" + Util.getIntValue(reqid,0);
			}else if((fieldbodytype.equals("4") || fieldbodytype.equals("57") || fieldbodytype.equals("167") || fieldbodytype.equals("168")) && !hrmid.equals("")){ //浏览按钮为部门,从前面的参数中获得人默认值(由人力资源的部门得到部门默认值)
                showid = "" + Util.getIntValue(ResourceComInfo.getDepartmentID(hrmid),0);
            }else if(fieldbodytype.equals("24") && !hrmid.equals("")){ //浏览按钮为职务,从前面的参数中获得人默认值(由人力资源的职务得到职务默认值)
                showid = "" + Util.getIntValue(ResourceComInfo.getJobTitle(hrmid),0);
            }else if(fieldbodytype.equals("32") && !hrmid.equals("")){ //浏览按钮为职务,从前面的参数中获得人默认值(由人力资源的职务得到职务默认值)
                showid = "" + Util.getIntValue(request.getParameter("TrainPlanId"),0);
            }else if((fieldbodytype.equals("164") || fieldbodytype.equals("169") || fieldbodytype.equals("170") || fieldbodytype.equals("194")) && !hrmid.equals("")){ //浏览按钮为分部,从前面的参数中获得人默认值(由人力资源的分部得到分部默认值)
                showid = "" + Util.getIntValue(ResourceComInfo.getSubCompanyID(hrmid),0);
            }

            if(fieldbodytype.equals("2")){ //added by xwj for td3130 20051124
                 if(!isSetFlag){
                    showname = currentdate;
                    showid = currentdate;
                }else{
                    showname=preAdditionalValue;
                    showid=preAdditionalValue;
                }
            }
				if(fieldbodytype.equals("19")){ //added by ben 2008-3-14 默认当前时间
                 if(!isSetFlag){
                    showname = currenttime.substring(0,5);
                    showid = currenttime.substring(0,5);
                }else{
                    showname=preAdditionalValue;
                    showid=preAdditionalValue;
                }
            }
            if(showid.equals("0")) showid = "" ;


            if(isSetFlag){
            showid = preAdditionalValue;//added by xwj for td3308 20051213
           }

            if(fieldbodytype.equals("2") || fieldbodytype.equals("19")  )	showname=showid; // 日期时间
            else if(!showid.equals("")){       // 获得默认值对应的默认显示值,比如从部门id获得部门名称
                ArrayList tempshowidlist=Util.TokenizerString(showid,",");
                if(fieldbodytype.equals("8") || fieldbodytype.equals("135")){
                    //项目，多项目
                    for(int k=0;k<tempshowidlist.size();k++){
                        if(!linkurl.equals("")){
                            showname+="<a href='"+linkurl+tempshowidlist.get(k)+ "&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype+"' target='_new'>"+ProjectInfoComInfo1.getProjectInfoname((String)tempshowidlist.get(k))+"</a>&nbsp";
                        }else{
                        showname+=ProjectInfoComInfo1.getProjectInfoname((String)tempshowidlist.get(k))+" ";
                        }
                    }
                }else if(fieldbodytype.equals("1") ||fieldbodytype.equals("17")){
                    //人员，多人员
                    for(int k=0;k<tempshowidlist.size();k++){
                        if(!linkurl.equals("")){
                        	if("/hrm/resource/HrmResource.jsp?id=".equals(linkurl))
                          	{
                        		showname+="<a href='javaScript:openhrm("+tempshowidlist.get(k)+");' onclick='pointerXY(event);'>"+ResourceComInfo.getResourcename((String)tempshowidlist.get(k))+"</a>&nbsp";
                          	}
                        	else
                            	showname+="<a href='"+linkurl+tempshowidlist.get(k)+ "&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype+"' target='_new'>"+ResourceComInfo.getResourcename((String)tempshowidlist.get(k))+"</a>&nbsp";
                        }else{
                        showname+=ResourceComInfo.getResourcename((String)tempshowidlist.get(k))+" ";
                        }
                    }
                }else if(fieldbodytype.equals("7") || fieldbodytype.equals("18")){
                    //客户，多客户
                    for(int k=0;k<tempshowidlist.size();k++){
                        if(!linkurl.equals("")){
                            showname+="<a href='"+linkurl+tempshowidlist.get(k)+ "&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype+"' target='_new'>"+CustomerInfoComInfo.getCustomerInfoname((String)tempshowidlist.get(k))+"</a>&nbsp";
                        }else{
                        showname+=CustomerInfoComInfo.getCustomerInfoname((String)tempshowidlist.get(k))+" ";
                        }
                    }
                }else if(fieldbodytype.equals("4") || fieldbodytype.equals("57")){
                    //部门，多部门
                    for(int k=0;k<tempshowidlist.size();k++){
                        if(!linkurl.equals("")){
                            showname+="<a href='"+linkurl+tempshowidlist.get(k)+ "&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype+"' target='_new'>"+DepartmentComInfo1.getDepartmentname((String)tempshowidlist.get(k))+"</a>&nbsp";
                        }else{
                        showname+=DepartmentComInfo1.getDepartmentname((String)tempshowidlist.get(k))+" ";
                        }
                    }
                }else if(fieldbodytype.equals("164")){
                    //分部
                    for(int k=0;k<tempshowidlist.size();k++){
                        if(!linkurl.equals("")){
                            showname+="<a href='"+linkurl+tempshowidlist.get(k)+ "&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype+"' target='_new'>"+SubCompanyComInfo1.getSubCompanyname((String)tempshowidlist.get(k))+"</a>&nbsp";
                        }else{
                        showname+=SubCompanyComInfo1.getSubCompanyname((String)tempshowidlist.get(k))+" ";
                        }
                    }
                }else if(fieldbodytype.equals("9") || fieldbodytype.equals("37")){
                    //文档，多文档
                    for(int k=0;k<tempshowidlist.size();k++){
                        if (fieldbodytype.equals("9")&&docFlags.equals("1"))
                        {
                        //linkurl="WorkflowEditDoc.jsp?docId=";//维护正文
                         String tempDoc=""+tempshowidlist.get(k);
                       showname+="<a href='#' onlick='createDoc("+fieldbodyid+","+tempDoc+")'>"+DocComInfo1.getDocname((String)tempshowidlist.get(k))+"</a>&nbsp";
                        }
                        else
                        {
                        if(!linkurl.equals("")){
                            showname+="<a href='"+linkurl+tempshowidlist.get(k)+ "&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype+"' target='_new'>"+DocComInfo1.getDocname((String)tempshowidlist.get(k))+"</a>&nbsp";
                        }else{
                        showname+=DocComInfo1.getDocname((String)tempshowidlist.get(k))+" ";
                        }
                        }
                    }
                }else if(fieldbodytype.equals("23")){
                    //资产
                    for(int k=0;k<tempshowidlist.size();k++){
                        if(!linkurl.equals("")){
                            showname+="<a href='"+linkurl+tempshowidlist.get(k)+ "&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype+"' target='_new'>"+CapitalComInfo1.getCapitalname((String)tempshowidlist.get(k))+"</a>&nbsp";
                        }else{
                        showname+=CapitalComInfo1.getCapitalname((String)tempshowidlist.get(k))+" ";
                        }
                    }
                }else if(fieldbodytype.equals("16") || fieldbodytype.equals("152") || fieldbodytype.equals("171")){
                    //相关请求
                    for(int k=0;k<tempshowidlist.size();k++){
                        if(!linkurl.equals("")){
                            showname+="<a href='"+linkurl+tempshowidlist.get(k)+ "&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype+"' target='_new'>"+WorkflowRequestComInfo1.getRequestName((String)tempshowidlist.get(k))+"</a>&nbsp";
                        }else{
                        showname+=WorkflowRequestComInfo1.getRequestName((String)tempshowidlist.get(k))+" ";
                        }
                    }
                }else if(fieldbodytype.equals("161")||fieldbodytype.equals("162")){
                    
					Browser browser=(Browser)StaticObj.getServiceByFullname(fielddbtype, Browser.class);
                    for(int k=0;k<tempshowidlist.size();k++){
						try{
                            BrowserBean bb=browser.searchById((String)tempshowidlist.get(k));
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
                }else if(fieldbodytype.equals("141")){
                    //人力资源条件
					showname+=ResourceConditionManager.getFormShowName(preAdditionalValue,languagebodyid);                    
                }else{
                    String tablename=BrowserComInfo.getBrowsertablename(fieldbodytype);
                    String columname=BrowserComInfo.getBrowsercolumname(fieldbodytype);
                    String keycolumname=BrowserComInfo.getBrowserkeycolumname(fieldbodytype);
                    if(!tablename.equals("") && !columname.equals("") && !keycolumname.equals("")){
	                    String sql="";
	                    if(showid.indexOf(",")==-1){
	                        sql="select "+columname+" from "+tablename+" where "+keycolumname+"="+showid;
	                    }else{
	                        sql="select "+columname+" from "+tablename+" where "+keycolumname+" in("+showid+")";
	                    }

	                    RecordSet.executeSql(sql);
	                    while(RecordSet.next()) {
	                        if(!linkurl.equals(""))
	                            showname += "<a href='"+linkurl+showid+ "&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype+"' target='_new'>"+RecordSet.getString(1)+"</a>&nbsp";
	                        else
	                            showname +=RecordSet.getString(1) ;
	                    }
                    }
                }
            }



           //deleted by xwj for td3130 20051124

		    if(isbodyedit.equals("1")){

				if("16".equals(fieldbodytype)){   //请求
			if(url.indexOf("RequestBrowser.jsp?")>-1){
		    		url+="&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}else{
		    		url+="?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}
				/*if(linkurl.indexOf("ViewRequest.jsp?")>-1){
		    		linkurl+="&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}else{
		    		linkurl+="?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}*/
		}

	if("152".equals(fieldbodytype) || "171".equals(fieldbodytype)){   //多请求


			if(url.indexOf("MultiRequestBrowser.jsp?")>-1){
		    		url+="&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}else{
		    		url+="?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}
				/*if(linkurl.indexOf("ViewRequest.jsp?")>-1){
		    		linkurl+="&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}else{
		    		linkurl+="?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}*/
		}

		if("7".equals(fieldbodytype)){   //客户
			if(url.indexOf("CustomerBrowser.jsp?")>-1){
		    		url+="&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}else{
		    		url+="?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}
				/*if(linkurl.indexOf("ViewCustomer.jsp?")>-1){
		    		linkurl+="&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}else{
		    		linkurl+="?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}*/
		}

			if("9".equals(fieldbodytype)){   //文档
			if(url.indexOf("DocBrowser.jsp?")>-1){
		    		url+="&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}else{
		    		url+="?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}
				/*if(linkurl.indexOf("DocDsp.jsp?")>-1){
		    		linkurl+="&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}else{
		    		linkurl+="?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}*/
		}

			if("37".equals(fieldbodytype)){   //多文档


			if(url.indexOf("MutiDocBrowser.jsp?")>-1){
		    		url+="&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}else{
		    		url+="?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}
				/*if(linkurl.indexOf("DocDsp.jsp?")>-1){
		    		linkurl+="&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}else{
		    		linkurl+="?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}*/
		}

		if("1".equals( fieldbodytype)){   //单人力


			if(url.indexOf("ResourceBrowser.jsp?")>-1){
		    		url+="&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}else{
		    		url+="?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}
				/*if(linkurl.indexOf("HrmResource.jsp?")>-1){
		    		linkurl+="&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}else{
		    		linkurl+="?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}*/

		}

		

	/*	if("17".equals( fieldbodytype)){   ////多人力


			if(url.indexOf("MultiResourceBrowser.jsp?")>-1){
		    		url+="&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}else{
		    		url+="?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}
				/*if(linkurl.indexOf("hrmTab.jsp?")>-1){
		    		linkurl+="&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}else{
		    		linkurl+="?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}*

		}*/

		if("165".equals( fieldbodytype)){   //分权单人力


			if(url.indexOf("ResourceBrowserByDec.jsp?")>-1){
		    		url+="&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}else{
		    		url+="?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}
				/*if(linkurl.indexOf("HrmResource.jsp?")>-1){
		    		linkurl+="&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}else{
		    		linkurl+="?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}*/

		}

		

		if("166".equals( fieldbodytype)){   ////分权多人力


			if(url.indexOf("MultiResourceBrowserByDec.jsp?")>-1){
		    		url+="&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}else{
		    		url+="?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}
				/*if(linkurl.indexOf("hrmTab.jsp?")>-1){
		    		linkurl+="&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}else{
		    		linkurl+="?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}*/

		}

		if("167".equals( fieldbodytype)){   ////分权单部门


			if(url.indexOf("DepartmentBrowserByDec.jsp?")>-1){
		    		url+="&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}else{
		    		url+="?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}
				/*if(linkurl.indexOf("HrmDepartmentDsp.jsp?")>-1){
					//System.out.println("--linkurl---");
		    		linkurl+="&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}else{
		    		linkurl+="?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}*/

		}


		if("168".equals( fieldbodytype)){   ////分权多部门


			if(url.indexOf("MultiDepartmentBrowserByDecOrder.jsp?")>-1){
		    		url+="&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}else{
		    		url+="?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}
				/*if(linkurl.indexOf("HrmDepartmentDsp.jsp?")>-1){
		    		linkurl+="&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}else{
		    		linkurl+="?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}*/

		}

		if("169".equals( fieldbodytype)){   ////分权单分部


			if(url.indexOf("SubcompanyBrowserByDec.jsp?")>-1){
		    		url+="&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}else{
		    		url+="?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}
				/*if(linkurl.indexOf("HrmSubCompanyDsp.jsp?")>-1){
		    		linkurl+="&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}else{
		    		linkurl+="?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}*/

		}

		if("170".equals( fieldbodytype)){   ////分权多分部


			if(url.indexOf("MultiSubcompanyBrowserByDec.jsp?")>-1){
		    		url+="&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}else{
		    		url+="?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}
				/*if(linkurl.indexOf("HrmSubCompanyDsp.jsp?")>-1){
		    		linkurl+="&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}else{
		    		linkurl+="?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}*/

		}
//add  by ben delweath rolepersone

              if(fieldbodytype.equals("160")){
                  rsaddop.execute("select a.level_n, a.level2_n from workflow_groupdetail a ,workflow_nodegroup b where a.groupid=b.id and a.type=50 and a.objid="+fieldbodyid+" and b.nodeid in (select nodeid from workflow_flownode where workflowid="+workflowid+" ) ");
  				String roleid="";
  				int rolelevel_tmp = 0;
  				if (rsaddop.next())
  				{
  				roleid=rsaddop.getString(1);
  				rolelevel_tmp=Util.getIntValue(rsaddop.getString(2), 0);
  				roleid += "a"+rolelevel_tmp;
  				}
  				bclick = "onShowResourceRole('"+fieldbodyid+"','"+url+"','"+linkurl+"','"+fieldbodytype+"',field"+fieldbodyid+".getAttribute('viewtype'),'"+roleid+"')";
%>
		<brow:browser viewType="0" name='<%="field"+fieldbodyid%>' browserValue='<%=showid%>' browserSpanValue='<%=showname %>' browserOnClick='<%=bclick%>' hasInput="true" isSingle='<%=BrowserManager.browIsSingle(fieldbodytype)%>' hasBrowser = "true" isMustInput='<%=isbrowisMust %>' completeUrl='<%="javascript:getajaxurl(" + fieldbodytype + ")"%>' width="auto" needHidden="false" defaultRow="99" onPropertyChange='<%="wfbrowvaluechange(this," + fieldbodyid + ")" %>'> </brow:browser>
		<!-- 
        <button id="field<%=fieldbodyid%>browser" name="field<%=fieldbodyid%>browser"  type=button class=Browser  onclick="onShowResourceRole('<%=fieldbodyid%>','<%=url%>','<%=linkurl%>','<%=fieldbodytype%>',field<%=fieldbodyid%>.getAttribute('viewtype'),'<%=roleid%>')" title="<%=SystemEnv.getHtmlLabelName(20570,user.getLanguage())%>"></button>
         -->
<%
			  }
              else if(fieldbodytype.equals("161")||fieldbodytype.equals("162")){
              url+="?type="+fielddbtype;
              bclick = "onShowBrowser2('"+fieldbodyid+"','"+url+"','"+linkurl+"','"+fieldbodytype+"',field"+fieldbodyid+".viewtype);";
%>
		<brow:browser viewType="0" name='<%="field"+fieldbodyid%>' browserValue='<%=showid%>' browserSpanValue='<%=showname %>' browserOnClick='<%=bclick%>' hasInput="true" isSingle='<%=BrowserManager.browIsSingle(fieldbodytype)%>' hasBrowser = "true" isMustInput='<%=isbrowisMust %>' completeUrl='<%="javascript:getajaxurl(" + fieldbodytype + ")"%>' width="auto" needHidden="false" defaultRow="99" onPropertyChange='<%="wfbrowvaluechange(this," + fieldbodyid + ")" %>'> </brow:browser>
		<!-- 
        <button id="field<%=fieldbodyid%>browser" name="field<%=fieldbodyid%>browser" class=Browser  onclick="onShowBrowser2('<%=fieldbodyid%>','<%=url%>','<%=linkurl%>','<%=fieldbodytype%>',field<%=fieldbodyid%>.viewtype);<%if(trrigerfield.indexOf("field"+fieldbodyid)>=0){%>datainput('field<%=fieldbodyid%>',field<%=fieldbodyid%>.viewtype);<%}%>"></button>
         -->
<%
			  }
              else if(fieldbodytype.equals("141")){
                  bclick = "onShowResourceConditionBrowser('"+fieldbodyid+"','"+url+"','"+linkurl+"','"+fieldbodytype+"',field"+fieldbodyid+".viewtype)";
%>
		<brow:browser viewType="0" name='<%="field"+fieldbodyid%>' browserValue='<%=showid%>' browserSpanValue='<%=showname %>' browserOnClick='<%=bclick%>' hasInput="true" isSingle='<%=BrowserManager.browIsSingle(fieldbodytype)%>' hasBrowser = "true" isMustInput='<%=isbrowisMust %>' completeUrl='<%="javascript:getajaxurl(" + fieldbodytype + ")"%>' width="auto" needHidden="false" defaultRow="99" onPropertyChange='<%="wfbrowvaluechange(this," + fieldbodyid + ")" %>'> </brow:browser>
		<!-- 
        <button id="field<%=fieldbodyid%>browser" name="field<%=fieldbodyid%>browser" class=Browser  onclick="onShowResourceConditionBrowser('<%=fieldbodyid%>','<%=url%>','<%=linkurl%>','<%=fieldbodytype%>',field<%=fieldbodyid%>.viewtype)" title="<%=SystemEnv.getHtmlLabelName(172,user.getLanguage())%>"></button>
         -->
<%
			  } else
//add by fanggsh 20060621 for TD4528 end
                if(!fieldbodytype.equals("37")&&!fieldbodytype.equals("9")) {
					session.setAttribute("relaterequest","new");
					//  多文档特殊处理


				if(trrigerfield.indexOf("field"+fieldbodyid)>=0){
				    bclick="onShowBrowser2('"+fieldbodyid+"','"+url+"','"+linkurl+"','"+fieldbodytype+"',field"+fieldbodyid+".getAttribute('viewtype'));";
				}else{
				    bclick="onShowBrowser2('"+fieldbodyid+"','"+url+"','"+linkurl+"','"+fieldbodytype+"',field"+fieldbodyid+".getAttribute('viewtype'))";
			    }
	   %>
	   <brow:browser viewType="0" name='<%="field"+fieldbodyid%>' browserValue='<%=showid%>' browserSpanValue='<%=showname %>' browserOnClick='<%=bclick%>' hasInput="true" isSingle='<%=BrowserManager.browIsSingle(fieldbodytype)%>' hasBrowser = "true" isMustInput='<%=isbrowisMust %>' completeUrl='<%="javascript:getajaxurl(" + fieldbodytype + ")"%>' width="auto" needHidden="false" defaultRow="99" onPropertyChange='<%="wfbrowvaluechange(this," + fieldbodyid + ")" %>'
	   hasAdd='<%=fieldbodytype.equals("17") + "" %>' addBtnClass="resAddGroupClass" addOnClick='<%="showrescommongroup(this, " + fieldbodyid + ")" %>'> </brow:browser>
	   <!-- 
       <button id="field<%=fieldbodyid%>browser" name="field<%=fieldbodyid%>browser" class=Browser <%if(trrigerfield.indexOf("field"+fieldbodyid)>=0){%>
	      onclick="onShowBrowser2('<%=fieldbodyid%>','<%=url%>','<%=linkurl%>','<%=fieldbodytype%>',field<%=fieldbodyid%>.getAttribute('viewtype'));datainput('field<%=fieldbodyid%>');"
	   <%}else{%>
		  onclick="onShowBrowser2('<%=fieldbodyid%>','<%=url%>','<%=linkurl%>','<%=fieldbodytype%>',field<%=fieldbodyid%>.getAttribute('viewtype'))"
	   <%}%> 
		  title="<%=SystemEnv.getHtmlLabelName(172,user.getLanguage())%>">
	   </button>
	    -->
        <%}else if(fieldbodytype.equals("37")){                         // 如果是多文档字段,加入新建文档按钮
            bclick = "onShowBrowser2('"+fieldbodyid+"','"+url+"','"+linkurl+"','"+fieldbodytype+"',field"+fieldbodyid+".viewtype)";
       %>
        <brow:browser viewType="0" name='<%="field"+fieldbodyid%>' browserValue='<%=showid%>' browserSpanValue='<%=showname %>' browserOnClick='<%=bclick%>' hasInput="true" isSingle='<%=BrowserManager.browIsSingle(fieldbodytype)%>' hasBrowser = "true" isMustInput='<%=isbrowisMust %>' completeUrl='<%="javascript:getajaxurl(" + fieldbodytype + ")"%>' width="auto" needHidden="false" defaultRow="99" onPropertyChange='<%="wfbrowvaluechange(this," + fieldbodyid + ")" %>'> </brow:browser>
        <!-- 
        <button id="field<%=fieldbodyid%>browser" name="field<%=fieldbodyid%>browser" class=AddDocFlow onclick="onShowBrowser2('<%=fieldbodyid%>','<%=url%>','<%=linkurl%>','<%=fieldbodytype%>',field<%=fieldbodyid%>.viewtype)" > <%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></button>&nbsp;&nbsp<button class=AddDocFlow onclick="onNewDoc(<%=fieldbodyid%>)" title="<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%>"><%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%></button>
         -->
       <%}else if(fieldbodytype.equals("9") && fieldbodyid.equals(flowDocField)){       // 如果是多文档字段,加入新建文档按钮
	        if(!"1".equals(newTNflag)){
	           if(trrigerfield.indexOf("field"+fieldbodyid)>=0){
	               bclick="onShowBrowser2('"+fieldbodyid+"','"+url+"','"+linkurl+"','"+fieldbodytype+"',field"+fieldbodyid+".getAttribute('viewtype'));";
		  	   }else{
		  		  bclick="onShowBrowser2('"+fieldbodyid+"','"+url+"','"+linkurl+"','"+fieldbodytype+"',field"+fieldbodyid+".getAttribute('viewtype'))";
		  	   }
	   %>
	   <brow:browser viewType="0" name='<%="field"+fieldbodyid%>' browserValue='<%=showid%>' browserSpanValue='<%=showname %>' browserOnClick='<%=bclick%>' hasInput="true" isSingle='<%=BrowserManager.browIsSingle(fieldbodytype)%>' hasBrowser = "true" isMustInput='<%=isbrowisMust %>' completeUrl='<%="javascript:getajaxurl(" + fieldbodytype + ")"%>' width="auto" needHidden="false" defaultRow="99" onPropertyChange='<%="wfbrowvaluechange(this," + fieldbodyid + ")" %>'> </brow:browser>
	   <!-- 
       <button id="field<%=fieldbodyid%>browser" name="field<%=fieldbodyid%>browser" class=Browser <%if(trrigerfield.indexOf("field"+fieldbodyid)>=0){%>
	      onclick="onShowBrowser2('<%=fieldbodyid%>','<%=url%>','<%=linkurl%>','<%=fieldbodytype%>',field<%=fieldbodyid%>.getAttribute('viewtype'));datainput('field<%=fieldbodyid%>');"
	   <%}else{%>
		  onclick="onShowBrowser2('<%=fieldbodyid%>','<%=url%>','<%=linkurl%>','<%=fieldbodytype%>',field<%=fieldbodyid%>.getAttribute('viewtype'))"
	   <%}%> 
		  title="<%=SystemEnv.getHtmlLabelName(172,user.getLanguage())%>">
	   </button>
	    -->
       <%}
        }else{
            	if(trrigerfield.indexOf("field"+fieldbodyid)>=0){
		  	      bclick="onShowBrowser2('"+fieldbodyid+"','"+url+"','"+linkurl+"','"+fieldbodytype+"','"+isbodymand+"');datainput('field"+fieldbodyid+"');";
		  	   }else{
		  		  bclick="onShowBrowser2('"+fieldbodyid+"','"+url+"','"+linkurl+"','"+fieldbodytype+"','"+isbodymand+"')";
		  	   }
        %>
        <brow:browser viewType="0" name='<%="field"+fieldbodyid%>' browserValue='<%=showid%>' browserSpanValue='<%=showname %>' browserOnClick='<%=bclick%>' hasInput="true" isSingle='<%=BrowserManager.browIsSingle(fieldbodytype)%>' hasBrowser = "true" isMustInput='<%=isbrowisMust %>' completeUrl='<%="javascript:getajaxurl(" + fieldbodytype + ")"%>' width="auto" needHidden="false" defaultRow="99" onPropertyChange='<%="wfbrowvaluechange(this," + fieldbodyid + ")" %>'> </brow:browser>
        <!-- 
	    <button id="field<%=fieldbodyid%>browser" name="field<%=fieldbodyid%>browser" class=Browser <%if(trrigerfield.indexOf("field"+fieldbodyid)>=0){%>
	      onclick="onShowBrowser2('<%=fieldbodyid%>','<%=url%>','<%=linkurl%>','<%=fieldbodytype%>','<%=isbodymand%>');datainput('field<%=fieldbodyid%>');"
	   <%}else{%>
		  onclick="onShowBrowser2('<%=fieldbodyid%>','<%=url%>','<%=linkurl%>','<%=fieldbodytype%>','<%=isbodymand%>')"
	   <%}%> 
		  title="<%=SystemEnv.getHtmlLabelName(172,user.getLanguage())%>">
	    </button>
	     -->
	   <%}
           if(fieldbodytype.equals("9")&&docFlags.equals("1") && fieldbodyid.equals(flowDocField))  ///是否有流程建文档s
           {%>
           <span id="CreateNewDoc"><button id="field<%=fieldbodyid%>browser" name="field<%=fieldbodyid%>browser" id="createdoc" class=AddDocFlow onclick="createDoc('<%=fieldbodyid%>','')" title="<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%>"><%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%></button>
           </span>
           <%}
        }
	   if(fieldbodytype.equals("161")||fieldbodytype.equals("162")){%>
	   <input type=hidden viewtype="<%=isbodymand%>" temptitle="<%=Util.toScreen(fieldbodylable,languagebodyid)%>" id="field<%=fieldbodyid%>" name="field<%=fieldbodyid%>"  value="<%=showid%>" onpropertychange="<%if(trrigerfield.indexOf("field"+fieldbodyid)>=0){%>datainput('field<%=fieldbodyid%>');<%}%>">
       <%}
       else if (fieldbodytype.equals("9")&&docFlags.equals("1")) {%>
		<input type=hidden viewtype="<%=isbodymand%>" temptitle="<%=Util.toScreen(fieldbodylable,languagebodyid)%>" id="field<%=fieldbodyid%>" name="field<%=fieldbodyid%>"  value="<%=showid%>"  <%if(trrigerfield.indexOf("field"+fieldbodyid)>=0){%> onpropertychange="datainput('field<%=fieldbodyid%>');" <%}%>>
      <%} else {%>
        <input type=hidden viewtype="<%=isbodymand%>" temptitle="<%=Util.toScreen(fieldbodylable,languagebodyid)%>" id="field<%=fieldbodyid%>" name="field<%=fieldbodyid%>"  value="<%=showid%>" onpropertychange="checkLengthbrow('field<%=fieldbodyid%>','field<%=fieldbodyid%>span','<%=fieldlen%>','<%=Util.toScreen(fieldbodylable,languagebodyid)%>','<%=SystemEnv.getHtmlLabelName(20246,user.getLanguage())%>','<%=SystemEnv.getHtmlLabelName(20247,user.getLanguage())%>',field<%=fieldbodyid%>.getAttribute('viewtype'));<%if(trrigerfield.indexOf("field"+fieldbodyid)>=0){%>datainput('field<%=fieldbodyid%>')<%}%>"  >
		<%}%>
		<%if(!"1".equals(isbodyedit)){%>
        <span id="field<%=fieldbodyid%>span"><%=Util.toScreen(showname,user.getLanguage())%>
       <%   if(isbodymand.equals("1") && showname.equals("")) {
       %>
           <img src="/images/BacoError_wev8.gif" align=absmiddle>
       <%
            }
       %>
        </span>
         <%}%>
        &nbsp;&nbsp;
        <%if(fieldbodytype.equals("87")||fieldbodytype.equals("184")){%>
        <A href="/meeting/report/MeetingRoomPlan.jsp" target="blank"><%=SystemEnv.getHtmlLabelName(2193,user.getLanguage())%></A>
        <%}%>
       <%
        if(changefieldsadd.indexOf(fieldbodyid)>=0){
%>
    <input type=hidden name="oldfieldview<%=fieldbodyid%>" value="<%=Util.getIntValue(isbodyview,0)+Util.getIntValue(isbodyedit,0)+Util.getIntValue(isbodymand,0)%>" />
<%
    }
        }                                                       // 浏览按钮条件结束
	    else if(fieldbodyhtmltype.equals("4")) {                  // check框


	   %>
        <input type=checkbox viewtype="<%=isbodymand%>" temptitle="<%=Util.toScreen(fieldbodylable,languagebodyid)%>" value=1<%if(preAdditionalValue.equals("1")){%> checked<%}%>  id="field<%=fieldbodyid%>" name="field<%=fieldbodyid%>"  <%if(isbodyedit.equals("0")){%> DISABLED <%}%> <%if(trrigerfield.indexOf("field"+fieldbodyid)>=0){%> onChange="datainput('field<%=fieldbodyid%>');" <%}%>><!--modified by xwj for td3130 20051124-->
       <%
        if(changefieldsadd.indexOf(fieldbodyid)>=0){
%>
    <input type=hidden name="oldfieldview<%=fieldbodyid%>" value="<%=Util.getIntValue(isbodyview,0)+Util.getIntValue(isbodyedit,0)+Util.getIntValue(isbodymand,0)%>" />
<%
    }
        }                                                       // check框条件结束


        else if(fieldbodyhtmltype.equals("5")){                     // 选择框   select
        	//添加事件信息
        	String uploadMax = "";
        	if(fieldbodyid.equals(selectedfieldid)&&uploadType==1)
        	{
        		uploadMax = "changeMaxUpload('field"+fieldbodyid+"');reAccesoryChanage();"; 
        	}
        	//处理select字段联动
         	String onchangeAddStr = "";
        	int childfieldid_tmp = 0;
        	if("0".equals(isbill)){
        		rs_item.execute("select childfieldid from workflow_formdict where id="+fieldbodyid);
        	}else{
        		rs_item.execute("select childfieldid from workflow_billfield where id="+fieldbodyid);
        	}
        	if(rs_item.next()){
	       		childfieldid_tmp = Util.getIntValue(rs_item.getString("childfieldid"), 0);
        	}
        	int firstPfieldid_tmp = 0;
        	boolean hasPfield = false;
        	if("0".equals(isbill)){
        		rs_item.execute("select id from workflow_formdict where childfieldid="+fieldbodyid);
        	}else{
        		rs_item.execute("select id from workflow_billfield where childfieldid="+fieldbodyid);
        	}
        	while(rs_item.next()){
        		firstPfieldid_tmp = Util.getIntValue(rs_item.getString("id"), 0);
        		if(fieldids.contains(""+firstPfieldid_tmp)){
        			hasPfield = true;
        			break;
        		}
        	}
        	if(childfieldid_tmp != 0){//如果先出现子字段，则要把子字段下拉选项清空
				onchangeAddStr = "changeChildField(this, "+fieldbodyid+", "+childfieldid_tmp+")";
			}
	   %>
        <script>
        	function funcField<%=fieldbodyid%>(){
        	    changeshowattr('<%=fieldbodyid%>_0',$GetEle('field<%=fieldbodyid%>').value,-1,'<%=workflowid%>','<%=nodeid%>');
        	}
        	//window.attachEvent("onload", funcField<%=fieldbodyid%>);
        	if (window.addEventListener){
        	    window.addEventListener("load", funcField<%=fieldbodyid%>, false);
        	}else if (window.attachEvent){
        	    window.attachEvent("onload", funcField<%=fieldbodyid%>);
        	}else{
        	    window.onload=funcField<%=fieldbodyid%>;
        	}
        </script>
        <%
        if(!uploadMax.equals("")){
        %>
		<input type="hidden" id="uploadMaxField" name="uploadMaxField" isedit="<%=isbodyedit %>" value="<%=fieldbodyid%>" />
		<%
		}
		%>
        <select class=inputstyle viewtype="<%=isbodymand%>" temptitle="<%=Util.toScreen(fieldbodylable,languagebodyid)%>" <%if(isbodyedit.equals("0")){%> name="disfield<%=fieldbodyid%>" DISABLED <%}else{%> id="field<%=fieldbodyid%>" name="field<%=fieldbodyid%>"  <%}%> onBlur="checkinput2('field<%=fieldbodyid%>','field<%=fieldbodyid%>span',this.getAttribute('viewtype'));" onChange="<%=uploadMax%>;<%if(trrigerfield.indexOf("field"+fieldbodyid)>=0){%>datainput('field<%=fieldbodyid%>');<%}if(selfieldsadd.indexOf(fieldbodyid)>=0){%>changeshowattr('<%=fieldbodyid%>_0',this.value,-1,<%=workflowid%>,<%=nodeid%>);<%}if(isbill.equals("1")&&formid.equals("158")){%>balancestyleShow();<%}%><%=onchangeAddStr%>" ><!--added by xwj for td3313 20051206 -->
	    <option value=""></option><!--added by xwj for td3297 20051130 -->
	   <%
            // 查询选择框的所有可以选择的值


	   boolean checkempty = true;//xwj for td3313 20051206
	   String finalvalue = "";//xwj for td3313 20051206
	   if(hasPfield==false || isbodyedit.equals("0")){
            char flag= Util.getSeparator() ;
            rs.executeProc("workflow_selectitembyid_new",""+fieldbodyid+flag+isbill);
            while(rs.next()){
                String tmpselectvalue = Util.null2String(rs.getString("selectvalue"));
                String tmpselectname = Util.toScreen(rs.getString("selectname"),user.getLanguage());
                String isdefault = Util.toScreen(rs.getString("isdefault"),user.getLanguage());//xwj for td2977 20051107
                //获取选择目录的附件大小信息


                String tdocCategory = Util.toScreen(rs.getString("docCategory"),user.getLanguage());
                if(!"".equals(tdocCategory)&&fieldbodyid.equals(selectedfieldid)&&uploadType==1)
                {
                	int tsecid = Util.getIntValue(tdocCategory.substring(tdocCategory.lastIndexOf(",")+1),-1);
                	String tMaxUploadFileSize = ""+Util.getIntValue(SecCategoryComInfo1.getMaxUploadFileSize(""+tsecid),5);
                	secMaxUploads.put(tmpselectvalue,tMaxUploadFileSize);
                    secCategorys.put(tmpselectvalue,tdocCategory);
                	if("y".equals(isdefault)||tmpselectvalue.equals(preAdditionalValue)){
				          maxUploadImageSize = Util.getIntValue(tMaxUploadFileSize,5);
                          docCategory=tdocCategory;
				    }
                }
				         /* -------- xwj for td3313 20051206 begin -*/
				        if("".equals(preAdditionalValue)){
				         if("y".equals(isdefault)){
				          checkempty = false;
				          finalvalue = tmpselectvalue;
				         }
				        }
				        else{
				         if(tmpselectvalue.equals(preAdditionalValue)){
				          checkempty = false;
				          finalvalue = tmpselectvalue;
				         }
				        }
				         /* -------- xwj for td3313 20051206 end -*/
	   %>
	    <option value="<%=tmpselectvalue%>"  <%if("".equals(preAdditionalValue)){if("y".equals(isdefault)){%>selected<%}}else{if(tmpselectvalue.equals(preAdditionalValue)){%>selected<%}}//xwj for td2977 20051107%> ><%=tmpselectname%></option><!--modified by xwj for td3130 20051124-->
	   <%
            }
       }else{
           char flag= Util.getSeparator();
           rs.executeProc("workflow_selectitembyid_new",""+fieldbodyid+flag+isbill);
           while(rs.next()){
               String tmpselectvalue = Util.null2String(rs.getString("selectvalue"));
               String tmpselectname = Util.toScreen(rs.getString("selectname"),user.getLanguage());
               String isdefault = Util.toScreen(rs.getString("isdefault"),user.getLanguage());//xwj for td2977 20051107
				if("".equals(preAdditionalValue)){
					if("y".equals(isdefault)){
				    	checkempty = false;
				        finalvalue = tmpselectvalue;
				    }
				}else{
				    if(tmpselectvalue.equals(preAdditionalValue)){
				    	checkempty = false;
				        finalvalue = tmpselectvalue;
				    }
				}
           }
       	selectInitJsStr += "doInitChildSelect("+fieldbodyid+","+firstPfieldid_tmp+",\""+finalvalue+"\");\n";
       }
       %>
	    </select>
	    <!--xwj for td3313 20051206 begin-->
	    <span id="field<%=fieldbodyid%>span">
	    <%
	     if(isbodymand.equals("1") && checkempty){
	    %>
       <img src='/images/BacoError_wev8.gif' align=absMiddle>
      <%
            }
       %>
	     </span>
	    <%if(isbodyedit.equals("0")){%>
        <input type=hidden class=Inputstyle id="field<%=fieldbodyid%>" name="field<%=fieldbodyid%>"  value="<%=finalvalue%>" >
      <%}%>
	    <!--xwj for td3313 20051206 end-->
       <%
        if(changefieldsadd.indexOf(fieldbodyid)>=0){
%>
    <input type=hidden name="oldfieldview<%=fieldbodyid%>" value="<%=Util.getIntValue(isbodyview,0)+Util.getIntValue(isbodyedit,0)+Util.getIntValue(isbodymand,0)%>" />
<%
    }
        }                                                       // 选择框   select结束
       //add by xhheng @20050310 for 附件上传
       else if(fieldbodyhtmltype.equals("6")){

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
          if(fieldbodytype.equals("2")){
              picfiletypes=BaseBean.getPropValue("PicFileTypes","PicFileTypes");
              filetypedesc="Images Files";
          }
          if(isbodyedit.equals("1")){
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
               uploadfieldids.add(fieldbodyid);
           %>
            <script>
          var oUpload<%=fieldbodyid%>;
          function fileupload<%=fieldbodyid%>() {
        var language =  <%=user.getLanguage()%> ;
			  //alert("===language===="+language);
			  var settings;
			  if (language == 8)
			  {
				  settings = {
            flash_url : "/js/swfupload/swfupload.swf",
            upload_url: "/docs/docupload/MultiDocUploadByWorkflow.jsp",    // Relative to the SWF file
            post_params: {
                "mainId": "<%=mainId%>",
                "subId":"<%=subId%>",
                "secId":"<%=secId%>",
                "userid":"<%=userid%>",
                "logintype":"<%=logintype%>",
                "workflowid":"<%=workflowid%>"
            },
            file_size_limit :"<%=maxUploadImageSize%> MB",
            file_types : "<%=picfiletypes%>",
            file_types_description : "<%=filetypedesc%>",
            file_upload_limit : 100,
            file_queue_limit : 0,
            custom_settings : {
                progressTarget : "fsUploadProgress<%=fieldbodyid%>",
                cancelButtonId : "btnCancel<%=fieldbodyid%>",
                uploadspan : "field_<%=fieldbodyid%>span",
                uploadfiedid : "field<%=fieldbodyid%>"
            },
            debug: false,


            // Button settings

            button_image_url : "/images/ecology8/workflow/fileupload/begin1_wev8-2.png",    // Relative to the SWF file
            button_placeholder_id : "spanButtonPlaceHolder<%=fieldbodyid%>",

            button_width: 144,
            button_height: 26,
           
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
			  }	else{
         settings = {
            flash_url : "/js/swfupload/swfupload.swf",
            upload_url: "/docs/docupload/MultiDocUploadByWorkflow.jsp",    // Relative to the SWF file
            post_params: {
                "mainId": "<%=mainId%>",
                "subId":"<%=subId%>",
                "secId":"<%=secId%>",
                "userid":"<%=userid%>",
                "logintype":"<%=logintype%>",
                "workflowid":"<%=workflowid%>"
            },
            file_size_limit :"<%=maxUploadImageSize%> MB",
            file_types : "<%=picfiletypes%>",
            file_types_description : "<%=filetypedesc%>",
            file_upload_limit : 100,
            file_queue_limit : 0,
            custom_settings : {
                progressTarget : "fsUploadProgress<%=fieldbodyid%>",
                cancelButtonId : "btnCancel<%=fieldbodyid%>",
                uploadspan : "field_<%=fieldbodyid%>span",
                uploadfiedid : "field<%=fieldbodyid%>"
            },
            debug: false,


            // Button settings

            button_image_url : "/images/ecology8/workflow/fileupload/begin1_wev8.png",    // Relative to the SWF file
            button_placeholder_id : "spanButtonPlaceHolder<%=fieldbodyid%>",

            button_width: 104,
            button_height: 26,
   
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
			  }


        try {
            oUpload<%=fieldbodyid%>=new SWFUpload(settings);            
        } catch(e) {
            alert(e)
        }
    }
        	//window.attachEvent("onload", fileupload<%=fieldbodyid%>);
          	if (window.addEventListener){
	      	    window.addEventListener("load", fileupload<%=fieldbodyid%>, false);
	      	}else if (window.attachEvent){
	      	    window.attachEvent("onload", fileupload<%=fieldbodyid%>);
	      	}else{
	      	    window.onload=fileupload<%=fieldbodyid%>;
	      	}
        </script>
      <TABLE class="ViewForm" style="width:400px;">
          <tr>
              <td colspan="2" style="background-color:#ffffff;">
                  <div>
                   <span id="uploadspan" style="display:inline-block;line-height: 32px;"><%=SystemEnv.getHtmlLabelName(83523,user.getLanguage())%><%=maxUploadImageSize%><%=SystemEnv.getHtmlLabelName(83528,user.getLanguage())%>
                    </span>
                    <%
					if(isbodymand.equals("1")){
					%>
					<span id="field_<%=fieldbodyid%>span" style='display:inline-block;line-height: 32px;color:red;font-weight:normal;'><%=SystemEnv.getHtmlLabelName(81909,user.getLanguage())%></span>
					<%
					}
				   	%>
                  </div>
                  <div style="height: 30px;">
                  <div style="float:left;">
                  <span>
                     <span id="spanButtonPlaceHolder<%=fieldbodyid%>"></span><!--选取多个文件-->
                     </span>
                  </div>
                
                 <div style="width:10px!important;height:3px;float:left;"></div>
				 <div style="height: 30px;float:left;">
                  <button type="button" id="btnCancel<%=fieldbodyid%>" disabled="disabled" style="height:25px;text-align:center;vertical-align:middle;line-height:23px;background-color: #dfdfdf;color:#999999;padding:0 10px 0 4px;" onclick="clearAllQueue(oUpload<%=fieldbodyid%>);showmustinput(oUpload<%=fieldbodyid%>);" onmouseover="changebuttonon(this)" onmouseout="changebuttonout(this)"><img src='/images/ecology8/workflow/fileupload/clearallenable_wev8.png' style="width:20px;height:20px;" align=absMiddle><%= SystemEnv.getHtmlLabelName(21407,user.getLanguage())%></button>
		                <span id="field_<%=fieldbodyid%>spantest" style="display:none;">
						<%
						if(isbodymand.equals("1")){
						//needcheck+=",field"+fieldbodyid;
						%>
					   	<img src='/images/BacoError_wev8.gif' align=absMiddle> 
					  	<%
							}
					   	%>
			    	 	</span>
                  </div>
	              <div style="clear:both;"></div>
	              </div>
                  <!--  -----------------------------------------------  -->
                      
					<%--<span style="color:#262626;cursor:hand;TEXT-DECORATION:none" disabled onclick="oUpload<%=fieldbodyid%>.cancelQueue();showmustinput(oUpload<%=fieldbodyid%>);" id="btnCancel<%=fieldbodyid%>">
						<span><img src="/js/swfupload/delete_wev8.gif" border="0"></span>
						<span style="height:19px"><font style="margin:0 0 0 -1"><%=SystemEnv.getHtmlLabelName(21407,user.getLanguage())%></font><!--清除所有选择--></span>
					</span><span id="uploadspan">(<%=SystemEnv.getHtmlLabelName(83523,user.getLanguage())%><%=maxUploadImageSize%><%=SystemEnv.getHtmlLabelName(83528,user.getLanguage())%>)</span>
                      <span id="field<%=fieldbodyid%>span">
				<%
				 if(isbodymand.equals("1")){
				needcheck+=",field"+fieldbodyid;
				%>
			   <img src='/images/BacoError_wev8.gif' align=absMiddle>
			  <%
					}
			   %>
	     </span>
                  </div> --%>
                  <input  class=InputStyle  type=hidden size=60 id="field<%=fieldbodyid%>" name="field<%=fieldbodyid%>"  temptitle="<%=Util.toScreen(fieldbodylable,languagebodyid)%>"  viewtype="<%=isbodymand%>">
              </td>
          </tr>
          <tr>
              <td colspan="2">
              <div class="_uploadForClass">
                  <div class="fieldset flash" id="fsUploadProgress<%=fieldbodyid%>">
                  </div>
              </div>
                  <div id="divStatus<%=fieldbodyid%>"></div>
              </td>
          </tr>
      </TABLE>
            <%}%>
          <input type=hidden name='mainId' value=<%=mainId%>>
          <input type=hidden name='subId' value=<%=subId%>>
          <input type=hidden name='secId' value=<%=secId%>>
      <%
              }
          if(changefieldsadd.indexOf(fieldbodyid)>=0){
       	  	%>
    				<input type=hidden name="oldfieldview<%=fieldbodyid%>" value="<%=Util.getIntValue(isbodyview,0)+Util.getIntValue(isbodyedit,0)+Util.getIntValue(isbodymand,0)%>" />
    		<%
    			}
       }                                          // 选择框条件结束 所有条件判定结束


       else if(fieldbodyhtmltype.equals("7")){//特殊字段
           if(isbill.equals("0")) out.println(Util.null2String((String)specialfield.get(fieldbodyid+"_0")));
           else out.println(Util.null2String((String)specialfield.get(fieldbodyid+"_1")));
       }  
       else if(fieldbodyhtmltype.equals("9")){ // 位置字段
			out.println("<span>"+SystemEnv.getHtmlLabelName(126181, user.getLanguage())+"</span>");    //暂无位置信息
       }
       %>
      </td>
    </tr>
	 <tr style="height:1px;"><td class=Line2 colSpan=2></td></tr>
<%
    }       // 循环结束
%>
<input type=hidden name ="needcheck" value="<%=needcheck%>">
<input type=hidden name ="inputcheck" value="">
<%
//add by mackjoe at 2006-06-07 td4491 有明细时才加载


boolean  hasdetailb=false;
if(!(isbill.equals("1")&&(formid.equals("7")||formid.equals("156")||formid.equals("157")||formid.equals("158")||formid.equals("159")||formid.equals("19")||formid.equals("18")||formid.equals("224")||formid.equals("201")||formid.equals("220")))){
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
  </table>
  <jsp:include page="WorkflowAddRequestDetailBody.jsp" flush="true">
		<jsp:param name="workflowid" value="<%=workflowid%>" />
		<jsp:param name="nodeid" value="<%=nodeid%>" />
		<jsp:param name="formid" value="<%=formid%>" />
        <jsp:param name="detailsum" value="<%=detailsum%>"/>
        <jsp:param name="isbill" value="<%=isbill%>"/>
        <jsp:param name="currentdate" value="<%=currentdate%>" />
		<jsp:param name="currenttime" value="<%=currenttime%>" />
        <jsp:param name="needcheck" value="<%=needcheck%>" />
		<jsp:param name="prjid" value="<%=prjid%>" />
		<jsp:param name="reqid" value="<%=reqid%>" />
		<jsp:param name="docid" value="<%=docid%>" />
		<jsp:param name="hrmid" value="<%=hrmid%>" />
		<jsp:param name="crmid" value="<%=crmid%>" />
  </jsp:include>
  <table class="ViewForm" >
  <colgroup>
  <col width="20%">
  <col width="80%">
<%}%>
</table>
<%
String isSignMustInput="0";
String isHideInput="0";
String isFormSignature=null;
int formSignatureWidth=RevisionConstants.Form_Signature_Width_Default;
int formSignatureHeight=RevisionConstants.Form_Signature_Height_Default;
RecordSet.executeSql("select isFormSignature,formSignatureWidth,formSignatureHeight,issignmustinput,ishideinput from workflow_flownode where workflowId="+workflowid+" and nodeId="+nodeid);
if(RecordSet.next()){
	isFormSignature = Util.null2String(RecordSet.getString("isFormSignature"));
	formSignatureWidth= Util.getIntValue(RecordSet.getString("formSignatureWidth"),RevisionConstants.Form_Signature_Width_Default);
	formSignatureHeight= Util.getIntValue(RecordSet.getString("formSignatureHeight"),RevisionConstants.Form_Signature_Height_Default);
	isSignMustInput = ""+Util.getIntValue(RecordSet.getString("issignmustinput"), 0);
	isHideInput = ""+Util.getIntValue(RecordSet.getString("ishideinput"), 0);
}
int isUseWebRevision_t = Util.getIntValue(new weaver.general.BaseBean().getPropValue("weaver_iWebRevision","isUseWebRevision"), 0);
if(isUseWebRevision_t != 1){
	isFormSignature = "";
}
if(",158,157,156,7,159,14,15,18,19,201,17,21,".indexOf(","+formid+",") == -1){
%>
 
 <%
  //String workflowPhrases[] = WorkflowPhrase.getUserWorkflowPhrase(""+userid);
    //add by cyril on 2008-09-30 for td:9014
		boolean isSuccess  = RecordSet_nf1.executeProc("sysPhrase_selectByHrmId",""+userid);
		String workflowPhrases[] = new String[RecordSet_nf1.getCounts()];
		String workflowPhrasesContent[] = new String[RecordSet_nf1.getCounts()];
		int m = 0 ;
		if (isSuccess) {
			while (RecordSet_nf1.next()){
				workflowPhrases[m] = Util.null2String(RecordSet_nf1.getString("phraseShort"));
				workflowPhrasesContent[m] = Util.toHtml(Util.null2String(RecordSet_nf1.getString("phrasedesc")));
				m ++ ;
			}
		}
		//end by cyril on 2008-09-30 for td:9014
		
		
	String isannexupload_add=(String)session.getAttribute(userid+"_"+workflowid+"isannexupload");
	String workflowRequestLogId = "";
	String isSignDoc_edit=isSignDoc_add;
	String signdocids = "";
	String signdocname = "";
	String isSignWorkflow_edit = isSignWorkflow_add; 
	String signworkflowids = "";
	String signworkflowname = "";
	
	String isannexupload_edit = isannexupload_add;
	String annexdocids = "";
	String requestid = "-1";
	
	
	String myremark = "";
	int annexmainId=0;
    int annexsubId=0;
    int annexsecId=0;
    int annexmaxUploadImageSize = 0;
	if("1".equals(isannexupload_add)){
        
        String annexdocCategory_add=(String)session.getAttribute(userid+"_"+workflowid+"annexdocCategory");
         if("1".equals(isannexupload_add) && annexdocCategory_add!=null && !annexdocCategory_add.equals("")){
            annexmainId=Util.getIntValue(annexdocCategory_add.substring(0,annexdocCategory_add.indexOf(',')));
            annexsubId=Util.getIntValue(annexdocCategory_add.substring(annexdocCategory_add.indexOf(',')+1,annexdocCategory_add.lastIndexOf(',')));
            annexsecId=Util.getIntValue(annexdocCategory_add.substring(annexdocCategory_add.lastIndexOf(',')+1));
          }
         annexmaxUploadImageSize=Util.getIntValue(SecCategoryComInfo1.getMaxUploadFileSize(""+annexsecId),5);
         if(annexmaxUploadImageSize<=0){
            annexmaxUploadImageSize = 5;
         }
     }
	%>
	<br>
     <%@ include file="/workflow/request/WorkflowSignInput.jsp" %>
 
<%} %>
  

<input type=hidden name="workflowid" value="<%=workflowid%>">       <!--工作流id-->
<input type=hidden name="workflowtype" value="<%=workflowtype%>">   <!--工作流类型-->
<input type=hidden name="nodeid" value="<%=nodeid%>">               <!--当前节点id-->
<input type=hidden name="nodetype" value="0">                     <!--当前节点类型-->
<input type=hidden name="src">                                    <!--操作类型 save和submit,reject,delete-->
<input type=hidden name="iscreate" value="1">                     <!--是否为创建节点 是:1 否 0 -->
<input type=hidden name="formid" value="<%=formid%>">               <!--表单的id-->
<input type=hidden name ="topage" value="<%=topage%>">            <!--创建结束后返回的页面-->
<input type=hidden name ="isbill" value="<%=isbill%>">            <!--是否单据 0:否 1:是-->
<input type=hidden name ="method">                                <!--新建文档时候 method 为docnew-->

<input type=hidden name ="isMultiDoc" value=""><!--多文档新建-->

<input type=hidden name ="requestid" value="-1">
<input type=hidden name="rand" value="<%=System.currentTimeMillis()%>">
<input type=hidden name="needoutprint" value="">
<iframe name="delzw" width=0 height=0 style="border:none;"></iframe>

<script language=javascript>
//默认大小
var maxUploadImageSize = <%=maxUploadImageSize%>;
var uploaddocCategory="<%=docCategory%>";
//增加maxUpload参数，如果为0，表明为实时检测


function accesoryChanage(obj,maxUpload)
{
    var objValue = obj.value;
    if (objValue=="") return ;
    var fileLenth;
    try {
        File.FilePath=objValue;
        fileLenth= File.getFileSize();
    } catch (e){
        //alert('<%=SystemEnv.getHtmlLabelName(20253,user.getLanguage())%>');
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
    if(parseFloat(maxUpload)<=0)
    {
    	maxUpload = maxUploadImageSize;
    }
    if (fileLenthByM>maxUpload) {
        alert("<%=SystemEnv.getHtmlLabelName(20254,user.getLanguage())%>"+fileLenthByM+"M,<%=SystemEnv.getHtmlLabelName(20255,user.getLanguage())%>"+maxUpload+"M<%=SystemEnv.getHtmlLabelName(20256 ,user.getLanguage())%>");
        createAndRemoveObj(obj);
    }
}
//填充选择目录的附件大小信息


var selectValues = new Array();
var maxUploads = new Array();
var uploadCategorys=new Array();
function setMaxUploadInfo()
{
<%
if(secMaxUploads!=null&&secMaxUploads.size()>0)
{
	Set selectValues = secMaxUploads.keySet();

	for(Iterator i = selectValues.iterator();i.hasNext();)
	{
		String value = (String)i.next();
		String maxUpload = (String)secMaxUploads.get(value);
		String uplCategory=(String)secCategorys.get(value);
%>
		selectValues.push('<%=value%>');
		maxUploads.push('<%=maxUpload%>');
        uploadCategorys.push('<%=uplCategory%>');
<%
	}
}
%>
}


<%
if(uploadType==1 && !selectedfieldid.equals("")){
    int _selectfieldindex = inoperatefields.indexOf(selectedfieldid);
	if(_selectfieldindex>-1){
		selectfieldvalue = (String)inoperatevalues.get(_selectfieldindex);
	}
}

%>

setMaxUploadInfo();
//目录发生变化时，重新检测文件大小


function reAccesoryChanage()
{
	<%
    for(int i=0;i<uploadfieldids.size();i++){
    %>
    checkfilesize(oUpload<%=uploadfieldids.get(i)%>,maxUploadImageSize,uploaddocCategory);
    showmustinput(oUpload<%=uploadfieldids.get(i)%>);
    <%}%>
	
	checkfilesize2();
}

function changeMaxUpload2(fieldid,derecorderindex){

   var uploadMaxFieldisedit = jQuery("#uploadMaxField").attr("isedit");
   
   if(!!uploadMaxFieldisedit && uploadMaxFieldisedit=="1"){
	    var selectfieldv = jQuery("#"+fieldid).val();
		for(var i = 0;i<selectValues.length;i++)
		{
			var value = selectValues[i];
			if(value == selectfieldv)
			{
				maxUploadImageSize = parseFloat(maxUploads[i]);
                uploaddocCategory=uploadCategorys[i];
			}
		}
		jQuery("#selectfieldvalue").val(selectfieldv);
		if(selectfieldv=="")
		{
			maxUploadImageSize = 5;
			uploaddocCategory="";
			//var fieldlable = jQuery("#"+fieldid).attr("temptitle");
			var fieldlable = "<%=selectfieldlable%>";
			jQuery("span[id^='uploadspan']").each(function(){
				jQuery(this).html("<%=SystemEnv.getHtmlLabelName(125389,user.getLanguage())%> \""+fieldlable+"\"");
			});
		}else{
			jQuery("span[id^='uploadspan_"+derecorderindex+"']").each(function(){
				jQuery(this).html("<%=SystemEnv.getHtmlLabelName(83523,user.getLanguage())%>"+maxUploadImageSize+"<%=SystemEnv.getHtmlLabelName(83528,user.getLanguage())%>");
			});
		}
	}else{
   
    <%
	if(uploadType==1){
	    if(selectfieldvalue.equals("")){
	%>
			maxUploadImageSize = 5;
			uploaddocCategory = "";
			//var fieldlable = jQuery("#"+fieldid).attr("temptitle");
			var fieldlable = "<%=selectfieldlable%>";
			
			jQuery("span[id^='uploadspan_"+derecorderindex+"']").each(function(){
				jQuery(this).html("<%=SystemEnv.getHtmlLabelName(125389,user.getLanguage())%> \""+fieldlable+"\"");
			});
	<%  }else{%>
	        for(var i = 0;i<selectValues.length;i++)
			{
				var value = selectValues[i];
				if(value == "<%=selectfieldvalue%>")
				{
					maxUploadImageSize = parseFloat(maxUploads[i]);
	                uploaddocCategory=uploadCategorys[i];
				}
			}
			jQuery("span[id^='uploadspan_"+derecorderindex+"']").each(function(){
				jQuery(this).html("<%=SystemEnv.getHtmlLabelName(83523,user.getLanguage())%>"+maxUploadImageSize+"<%=SystemEnv.getHtmlLabelName(83528,user.getLanguage())%>");
			});
	<%
		}
	}
	%>
	
	}
}


//选择目录时，改变对应信息
function changeMaxUpload(fieldid)
{
	var efieldid = $GetEle(fieldid);
	if(efieldid)
	{
		var tselectValue = efieldid.value;
		for(var i = 0;i<selectValues.length;i++)
		{
			var value = selectValues[i];
			if(value == tselectValue)
			{
				maxUploadImageSize = parseFloat(maxUploads[i]);
                uploaddocCategory=uploadCategorys[i];
			}
		}
		var oUploadArray = new Array();
		var oUploadfieldidArray = new Array();
		<%
		if(uploadfieldids!=null){
		   	for(int i=0;i<uploadfieldids.size();i++){
		   %>
		oUploadArray.push(oUpload<%=uploadfieldids.get(i)%>);
		oUploadfieldidArray.push("<%=uploadfieldids.get(i)%>");
		<%
			}
		}
		%>
		jQuery("#selectfieldvalue").val(tselectValue);
		if(tselectValue=="")
		{
			maxUploadImageSize = 5;
			uploaddocCategory = "";
			attachmentDisabled(oUploadArray,true,oUploadfieldidArray);
			
			var fieldlable = jQuery("#"+fieldid).attr("temptitle");
			jQuery("span[id^='uploadspan']").each(function(){
				jQuery(this).html("<%=SystemEnv.getHtmlLabelName(125389,user.getLanguage())%> \""+fieldlable+"\"");
			});
		}else{
			jQuery("span[id^='uploadspan']").each(function(){
				var viewtype = jQuery(this).attr("viewtype");
				if(viewtype == 1){
				    jQuery(this).html("<%=SystemEnv.getHtmlLabelName(83523,user.getLanguage())%>"+maxUploadImageSize+"<%=SystemEnv.getHtmlLabelName(83528,user.getLanguage())%>");
				}else{
					jQuery(this).html("<%=SystemEnv.getHtmlLabelName(83523,user.getLanguage())%>"+maxUploadImageSize+"<%=SystemEnv.getHtmlLabelName(83528,user.getLanguage())%>");
				}
			});
			attachmentDisabled(oUploadArray,false,oUploadfieldidArray);
		}
	}
}


<%
if(uploadType==1){
%>

function initUploadMax(){
	try{
    	<%
    	if(selectfieldvalue.equals("")){
    	%>
		setTimeout(function(){
				var oUploadArray = new Array();
				var oUploadfieldidArray = new Array();
				<%
				if(uploadfieldids!=null){
				   	for(int i=0;i<uploadfieldids.size();i++){
				   %>
				   try{
					oUploadArray.push(oUpload<%=uploadfieldids.get(i)%>);
					oUploadfieldidArray.push("<%=uploadfieldids.get(i)%>");
				   }catch(e){}
				<%
					}
				}
				%>
				maxUploadImageSize = 5;
				uploaddocCategory = "";
				attachmentDisabled(oUploadArray,true,oUploadfieldidArray);
				
				var fieldlable = "<%=selectfieldlable%>";
				jQuery("span[id^='uploadspan']").each(function(){
					jQuery(this).html("<%=SystemEnv.getHtmlLabelName(125389,user.getLanguage())%> \""+fieldlable+"\"");
				});
			},2000);
		
		<%}else{%>
		
			for(var i = 0;i<selectValues.length;i++)
			{
				var value = selectValues[i];
				if(value == "<%=selectfieldvalue%>")
				{
					maxUploadImageSize = parseFloat(maxUploads[i]);
                	uploaddocCategory=uploadCategorys[i];
				}
			}
			jQuery("span[id^='uploadspan']").each(function(){
				jQuery(this).html("<%=SystemEnv.getHtmlLabelName(83523,user.getLanguage())%>"+maxUploadImageSize+"<%=SystemEnv.getHtmlLabelName(83528,user.getLanguage())%>");
			});
		<%}%>
    	
    }catch(e){}
}

initUploadMax();
<%}%>
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
}

*/
function createDoc(fieldbodyid,docVlaue)
{
	var _isagent = "";
    var _beagenter = "";
	if($GetEle("_isagent")!=null) _isagent=$GetEle("_isagent").value;
    if($GetEle("_beagenter")!=null) _beagenter=$GetEle("_beagenter").value;
  	$GetEle("frmmain").action = "RequestOperation.jsp?isagent="+_isagent+"&beagenter="+_beagenter+"&docView=1&docValue="+docVlaue;
    $GetEle("frmmain").method.value = "crenew_"+fieldbodyid ;
    $GetEle("frmmain").target="delzw";
    parent.delsave();
	if(check_form($GetEle("frmmain"),'requestname')){
		if($GetEle("needoutprint")) $GetEle("needoutprint").value = "1";//标识点正文


        $GetEle("frmmain").src.value='save';
//保存签章数据
<%if("1".equals(isFormSignature)&&!isHideInput.equals("1")){%>
						try{  
					        if(typeof(eval("SaveSignature"))=="function"){
					             if(SaveSignature()){
		                            //附件上传
		                            StartUploadAll();
		                            checkuploadcompletBydoc();
		                         }else{
									if(isDocEmpty==1){
										alert("\""+"<%=SystemEnv.getHtmlLabelName(17614,user.getLanguage())%>"+"\""+"<%=SystemEnv.getHtmlLabelName(21423,user.getLanguage())%>");
										isDocEmpty=0;
									}else{
										alert("<%=SystemEnv.getHtmlLabelName(21442,user.getLanguage())%>");
									}
									return ;
								 }
					        }
					    }catch(e){
					        StartUploadAll();
		                    checkuploadcompletBydoc();
					    }
	                 
<%}else{%>
                        //附件上传
	                    StartUploadAll();
	                    checkuploadcompletBydoc();
<%}%>
    }
}
function onNewDoc(fieldbodyid) {

    $GetEle("frmmain").action = "RequestOperation.jsp" ;
    $GetEle("frmmain").method.value = "docnew_"+fieldbodyid ;
    $GetEle("frmmain").isMultiDoc.value = fieldbodyid ;
    if(check_form($GetEle("frmmain"),'requestname')){

        $GetEle("frmmain").src.value='save';
        //附件上传
        StartUploadAll();
        checkuploadcomplet();
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


    function checktimeok(){         <!-- 结束日期不能小于开始日期 -->
        if ("<%=newenddate%>"!="b" && "<%=newfromdate%>"!="a" && $GetEle("<%=newenddate%>").value != "")
        {
            YearFrom=$GetEle("<%=newfromdate%>").value.substring(0,4);
            MonthFrom=$GetEle("<%=newfromdate%>").value.substring(5,7);
            DayFrom=$GetEle("<%=newfromdate%>").value.substring(8,10);
            YearTo=$GetEle("<%=newenddate%>").value.substring(0,4);
            MonthTo=$GetEle("<%=newenddate%>").value.substring(5,7);
            DayTo=$GetEle("<%=newenddate%>").value.substring(8,10);
            if (!DateCompare(YearFrom, MonthFrom, DayFrom,YearTo, MonthTo,DayTo )){
                window.alert("<%=SystemEnv.getHtmlLabelName(15273,user.getLanguage())%>");
                return false;
            }
        }
        return true;
    }
	function checkNodesNum()
	{
		var nodenum = 0;
		try
		{
		<%
		int checkdetailno = 0;
		//
		if(isbill.equals("1"))
		{
			if(formid.equals("7")||formid.equals("156") || formid.equals("157") || formid.equals("158") || formid.equals("159") || formid.equals("19")|| formid.equals("18")|| formid.equals("201")|| formid.equals("14"))
			{
				%>
			   	var rowneed = $GetEle('rowneed').value;
			   	var nodesnum = $GetEle('nodesnum').value;
			   	nodesnum = nodesnum*1;
			   	if(rowneed=="1")
			   	{
			   		if(nodesnum>0)
			   		{
			   			nodenum = 0;
			   		}
			   		else
			   		{
			   			nodenum = 1;
			   		}
			   	}
			   	else
			   	{
			   		nodenum = 0;
			   	}
			   	<%
			}
			else
			{
			    //单据
			    RecordSet.execute("select tablename,title from Workflow_billdetailtable where billid="+formid+" order by orderid");
			    //System.out.println("select tablename,title from Workflow_billdetailtable where billid="+formid+" order by orderid");
			    while(RecordSet.next())
			    {
	   	%>
	   	var rowneed = $GetEle('rowneed<%=checkdetailno%>').value;
	   	var nodesnum = $GetEle('nodesnum<%=checkdetailno%>').value;
	   	nodesnum = nodesnum*1;
	   	if(rowneed=="1")
	   	{
	   		if(nodesnum>0)
	   		{
	   			nodenum = 0;
	   		}
	   		else
	   		{
	   			nodenum = '<%=checkdetailno+1%>';
	   		}
	   	}
	   	else
	   	{
	   		nodenum = 0;
	   	}
	   	if(nodenum>0)
	   	{
	   		return nodenum;
	   	}
	   	<%
			   		checkdetailno ++;
			    }
			}
		}
		else
		{
		 	int checkGroupId=0;
		    RecordSet formrs=new RecordSet();
			formrs.execute("select distinct groupId from Workflow_formfield where formid="+formid+" and isdetail='1' order by groupid");
		    while (formrs.next())
		    {
		    	checkGroupId=formrs.getInt(1);
		    	%>
		       	var rowneed = $GetEle('rowneed<%=checkGroupId%>').value;
		       	var nodesnum = $GetEle('nodesnum<%=checkGroupId%>').value;
		       	nodesnum = nodesnum*1;
		       	if(rowneed=="1")
		       	{
		       		if(nodesnum>0)
		       		{
		       			nodenum = 0;
		       		}
		       		else
		       		{
		       			nodenum = <%=checkGroupId+1%>;
		       		}
		       	}
		       	else
		       	{
		       		nodenum = 0;
		       	}
		       	if(nodenum>0)
			   	{
			   		return nodenum;
			   	}
		       	<%
		    }
	    }
	    //多明细循环结束


		%>
		}
		catch(e)
		{
			nodenum = 0;
		}
		return nodenum;
	}
    function doSave(){              <!-- 点击保存按钮 -->
    	var nodenum = checkNodesNum();
    	if(nodenum>0)
    	{
    		alert("<%=SystemEnv.getHtmlLabelName(24827,user.getLanguage())%>"+nodenum+"<%=SystemEnv.getHtmlLabelName(24828,user.getLanguage())%>!");
    		return false;
    	}
        var ischeckok="";

        try{

		if(check_form($GetEle("frmmain"), "requestname"))
          ischeckok="true";
        }catch(e){
          ischeckok="false";
        }
        if(ischeckok=="false"){
            if(check_form($GetEle("frmmain"),'<%=needcheck%>'))
                ischeckok="true";
        }

<%
	if(isSignMustInput.equals("1")){
	    if("1".equals(isFormSignature)){
		}else{
%>
            if(ischeckok=="true"){
           	    //保存时不验证签字意见必填
            	//if(!check_form($GetEle("frmmain"),'remarkText10404')){
				//    ischeckok="false";
			    //}
		    }
<%
		}
	}
%>
        if(ischeckok=="true"){
			CkeditorExt.updateContent();
            if(checktimeok()) {
                    $GetEle("frmmain").src.value='save';
                    jQuery($GetEle("flowbody")).attr("onbeforeunload", "");//added by xwj for td3247 20051201

		
		if("<%=formid%>"==201&&"<%=isbill%>"==1){//资产报废单据明细中的资产报废数量大于库存数量，不能提交。


            try{
	    	nodesnum = $GetEle("nodesnum").value;
	    	for(var tempindex1=0;tempindex1<nodesnum;tempindex1++){
	    		try{
		    		var capitalcount = $GetEle("node_"+tempindex1+"_capitalcount").value*1;
		    		//修改。用ajax的方式从数据库获取最新的数量，防止选完资产延迟提交造成的数量不对问题
					$.ajax({
						url : '/cpt/capital/getCurrentCptcount.jsp',
						type:"post",	
						async:false,
						data:"cptid="+$GetEle("node_"+tempindex1+"_capitalid").value,					
						success:function(num){  
							capitalcount = num.trim();
						}
					});
		    		var fetchingnumber=$GetEle("node_"+tempindex1+"_number").value*1;
		    		if(fetchingnumber<=capitalcount){
			    		for(var tempindex2=0;tempindex2<nodesnum;tempindex2++){
			    			try{
				    			if(tempindex2!=tempindex1&&$GetEle("node_"+tempindex1+"_capitalid").value==$GetEle("node_"+tempindex2+"_capitalid").value){
				    				fetchingnumber = fetchingnumber*1 + $GetEle("node_"+tempindex2+"_number").value*1;
				    			}
			    			}catch(e){
						    	continue;
						    }
			    		}
		    		}
		    		if(fetchingnumber>capitalcount){
		    			alert("<%=SystemEnv.getHtmlLabelName(17273,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(1418,user.getLanguage())%>");
		    			return;
		    		}
	    		}catch(e){
			    	continue;
			    }
	    	}
            }catch(e){}
    	}
    	if("<%=formid%>"==19&&"<%=isbill%>"==1){//资产领用单据明细中的资产领用数量大于库存数量，不能提交。


	    	try{
	    	nodesnum = $GetEle("nodesnum").value;
	    	for(var tempindex1=0;tempindex1<nodesnum;tempindex1++){
	    		try{
		    		var capitalcount = $GetEle("node_"+tempindex1+"_capitalcount").value*1;
		    		//修改。用ajax的方式从数据库获取最新的数量，防止选完资产延迟提交造成的数量不对问题
					$.ajax({
						url : '/cpt/capital/getCurrentCptcount.jsp',
						type:"post",	
						async:false,
						data:"cptid="+$GetEle("node_"+tempindex1+"_capitalid").value,					
						success:function(num){  
							capitalcount = num.trim();
						}
					});
		    		var fetchingnumber=$GetEle("node_"+tempindex1+"_number").value*1;
		    		if(fetchingnumber<=capitalcount){
			    		for(var tempindex2=0;tempindex2<nodesnum;tempindex2++){
			    			try{
				    			if(tempindex2!=tempindex1&&$GetEle("node_"+tempindex1+"_capitalid").value==$GetEle("node_"+tempindex2+"_capitalid").value){
				    				fetchingnumber = fetchingnumber*1 + $GetEle("node_"+tempindex2+"_number").value*1;
				    			}
				    		}catch(e){
						    	continue;
						    }
			    		}
		    		}
		    		if(fetchingnumber>capitalcount){
		    			alert("<%=SystemEnv.getHtmlLabelName(15313,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(1446,user.getLanguage())%>");
		    			return;
		    		}
	    		}catch(e){
			    	continue;
			    }
	    	}
	    	}catch(e){}
    	}

    	if("<%=formid%>"==18&&"<%=isbill%>"==1){//资产调拨单据明细中的资产数量大于原有数量，不能提交。
    		try{
    	    	nodesnum = $GetEle("nodesnum").value;
    	    	for(var tempindex1=0;tempindex1<nodesnum;tempindex1++){
    	    		try{
    		    		var fetchingnumber=$GetEle("node_"+tempindex1+"_number").value*1;
   			    		for(var tempindex2=0;tempindex2<nodesnum;tempindex2++){
   			    			try{
   				    			if(tempindex2!=tempindex1&&$GetEle("node_"+tempindex1+"_capitalid").value==$GetEle("node_"+tempindex2+"_capitalid").value){
   				    				fetchingnumber = fetchingnumber*1 + $GetEle("node_"+tempindex2+"_number").value*1;
   				    			}
   			    			}catch(e){
   						    	continue;
   						    }
   			    		}
    		    		if(fetchingnumber>1){
    		    			alert("<%=SystemEnv.getHtmlLabelName(1437,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(1331,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(1418,user.getLanguage())%>");
    		    			return;
    		    		}
    	    		}catch(e){
    			    	continue;
    			    }
    	    	}
                }catch(e){}
		}

//保存签章数据
<%if("1".equals(isFormSignature)&&!isHideInput.equals("1")){%>
						try{  
					        if(typeof(eval("SaveSignature_save"))=="function"){
					              //保存时签字意见不验证必填
	                    if(SaveSignature_save()||!SaveSignature_save()){
                            //TD4262 增加提示信息  开始


                            var content="<%=SystemEnv.getHtmlLabelName(18979,user.getLanguage())%>";
                            showPrompt(content);
                            //TD4262 增加提示信息  结束
                            //附件上传                
                            StartUploadAll();
                            checkuploadcomplet();
                        }else{
							if(isDocEmpty==1){
								alert("\""+"<%=SystemEnv.getHtmlLabelName(17614,user.getLanguage())%>"+"\""+"<%=SystemEnv.getHtmlLabelName(21423,user.getLanguage())%>");
								//自动跳到签字意见锚点
								window.location.hash = "#fsUploadProgressannexuploadSimple";//重置锚点,否则,下次将不能定位


								window.location.hash = null;
								jQuery("#remarkShadowDiv").hide();
								jQuery("#signtabtoolbar").css("display","");
								jQuery("#signrighttool").css("display","");
								jQuery(".signaturebyhand").css("display","");
								isDocEmpty=0;
							}else{
							    alert("<%=SystemEnv.getHtmlLabelName(21442,user.getLanguage())%>");
							}
							return ;
						}
					        }
					    }catch(e){
					        var content="<%=SystemEnv.getHtmlLabelName(18979,user.getLanguage())%>";
                            showPrompt(content);
                            //TD4262 增加提示信息  结束
                            //附件上传                
                            StartUploadAll();
                            checkuploadcomplet(); 
					    }
                        
<%}else{%>
						//TD4262 增加提示信息  开始


						var content="<%=SystemEnv.getHtmlLabelName(18979,user.getLanguage())%>";
						showPrompt(content);
						//TD4262 增加提示信息  结束
						//附件上传                
						StartUploadAll();
						checkuploadcomplet();
<%}%>
                }
            }
    }

    function doSubmit(obj){            <!-- 点击提交 -->
    	var nodenum = checkNodesNum();
    	if(nodenum>0)
    	{
    		alert("<%=SystemEnv.getHtmlLabelName(24827,user.getLanguage())%>"+nodenum+"<%=SystemEnv.getHtmlLabelName(24828,user.getLanguage())%>!");
    		return false;
    	}
      //modify by xhheng @20050328 for TD 1703
      //明细部必填check，通过try $GetEle("needcheck")来检查,避免对原有无明细单据的修改



        var ischeckok="";
        try{
        if(check_form($GetEle("frmmain"),$GetEle("needcheck").value+$GetEle("inputcheck").value))
          ischeckok="true";
        }catch(e){
          ischeckok="false";
        }
        if(ischeckok=="false"){
          if(check_form($GetEle("frmmain"),'<%=needcheck%>'))
            ischeckok="true";
        }

<%
	if(isSignMustInput.equals("1")){
	    if("1".equals(isFormSignature)){
		}else{
%>
            if(ischeckok=="true"){
			    if(!check_form($GetEle("frmmain"),'remarkText10404')){
				    ischeckok="false";
			    }
		    }
<%
		}
	}
%>

        if(ischeckok=="true"){
			CkeditorExt.updateContent();
            if(checktimeok()) {
                $GetEle("frmmain").src.value='submit';
                // xwj for td2104 on 20050802
                //$GetEle("remark").value += "\n<%=username%> <%=currentdate%> <%=currenttime%>" ;
                jQuery($GetEle("flowbody")).attr("onbeforeunload", "");//added by xwj for td3247 20051201
         //add 2014-10-10 验证资产领用的数量

/**
		if("<%=formid%>"==19&&"<%=isbill%>"==1){ 
			var nodesum = $GetEle("nodesnum").value;
			var poststr="";
			var returnval="";
			for(var i=0;i<nodesum;i++){
				 poststr += "|"+$GetEle("node_"+i+"_capitalid").value*1+","+$GetEle("node_"+i+"_number").value*1;
			}
			if(poststr.length){
				checkcapitalnum(poststr,function(){
					cptcallback(obj);
				});
				return;
			}
		}
	
		//验证资产报废的数量


		if("<%=formid%>"==201&&"<%=isbill%>"==1){
			var nodesum = $GetEle("nodesnum").value;
			var poststr="";
			var returnval="";
			for(var i=0;i<nodesum;i++){
				 poststr += "|"+$GetEle("node_"+i+"_capitalid").value*1+","+$GetEle("node_"+i+"_number").value*1;
			}
			if(poststr.length){
				checkcapitalnum(poststr,function(){
					cptcallback(obj);
				});
				return;
			}
		}
		//验证资产调拨的数量


		if("<%=formid%>"==18&&"<%=isbill%>"==1){
			var nodesum = $GetEle("nodesnum").value;
			var poststr="";
			var returnval="";
			for(var i=0;i<nodesum;i++){
				 poststr += "|"+$GetEle("node_"+i+"_capitalid").value*1+","+$GetEle("node_"+i+"_number").value*1;
			}
			if(poststr.length){
				checkcapitalnum(poststr,function(){
					cptcallback(obj);
				});
				return;
			}
		}
		
		**/	         

    	if("<%=formid%>"==201&&"<%=isbill%>"==1){//资产报废单据明细中的资产报废数量大于库存数量，不能提交。


            try{
	    	nodesnum = $GetEle("nodesnum").value;
	    	for(var tempindex1=0;tempindex1<nodesnum;tempindex1++){
	    		try{
		    		var capitalcount = $GetEle("node_"+tempindex1+"_capitalcount").value*1;
		    		//修改。用ajax的方式从数据库获取最新的数量，防止选完资产延迟提交造成的数量不对问题
					$.ajax({
						url : '/cpt/capital/getCurrentCptcount.jsp',
						type:"post",	
						async:false,
						data:"cptid="+$GetEle("node_"+tempindex1+"_capitalid").value,					
						success:function(num){  
							capitalcount = num.trim();
						}
					});
		    		var fetchingnumber=$GetEle("node_"+tempindex1+"_number").value*1;
		    		if(fetchingnumber<=capitalcount){
			    		for(var tempindex2=0;tempindex2<nodesnum;tempindex2++){
			    			try{
				    			if(tempindex2!=tempindex1&&$GetEle("node_"+tempindex1+"_capitalid").value==$GetEle("node_"+tempindex2+"_capitalid").value){
				    				fetchingnumber = fetchingnumber*1 + $GetEle("node_"+tempindex2+"_number").value*1;
				    			}
			    			}catch(e){
						    	continue;
						    }
			    		}
		    		}
		    		if(fetchingnumber>capitalcount){
		    			alert("<%=SystemEnv.getHtmlLabelName(17273,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(1418,user.getLanguage())%>");
		    			return;
		    		}
	    		}catch(e){
			    	continue;
			    }
	    	}
            }catch(e){}
    	}
    	if("<%=formid%>"==19&&"<%=isbill%>"==1){//资产领用单据明细中的资产领用数量大于库存数量，不能提交。


	    	try{
	    	nodesnum = $GetEle("nodesnum").value;
	    	for(var tempindex1=0;tempindex1<nodesnum;tempindex1++){
	    		try{
		    		var capitalcount = $GetEle("node_"+tempindex1+"_capitalcount").value*1;
		    		//修改。用ajax的方式从数据库获取最新的数量，防止选完资产延迟提交造成的数量不对问题
					$.ajax({
						url : '/cpt/capital/getCurrentCptcount.jsp',
						type:"post",	
						async:false,
						data:"cptid="+$GetEle("node_"+tempindex1+"_capitalid").value,					
						success:function(num){  
							capitalcount = num.trim();
						}
					});
		    		var fetchingnumber=$GetEle("node_"+tempindex1+"_number").value*1;
		    		if(fetchingnumber<=capitalcount){
			    		for(var tempindex2=0;tempindex2<nodesnum;tempindex2++){
			    			try{
				    			if(tempindex2!=tempindex1&&$GetEle("node_"+tempindex1+"_capitalid").value==$GetEle("node_"+tempindex2+"_capitalid").value){
				    				fetchingnumber = fetchingnumber*1 + $GetEle("node_"+tempindex2+"_number").value*1;
				    			}
				    		}catch(e){
						    	continue;
						    }
			    		}
		    		}
		    		if(fetchingnumber>capitalcount){
		    			alert("<%=SystemEnv.getHtmlLabelName(15313,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(1446,user.getLanguage())%>");
		    			return;
		    		}
	    		}catch(e){
			    	continue;
			    }
	    	}
	    	}catch(e){}
    	}

    	if("<%=formid%>"==18&&"<%=isbill%>"==1){//资产调拨单据明细中的资产数量大于原有数量，不能提交。
    		try{
    	    	nodesnum = $GetEle("nodesnum").value;
    	    	for(var tempindex1=0;tempindex1<nodesnum;tempindex1++){
    	    		try{
    		    		var fetchingnumber=$GetEle("node_"+tempindex1+"_number").value*1;
   			    		for(var tempindex2=0;tempindex2<nodesnum;tempindex2++){
   			    			try{
   				    			if(tempindex2!=tempindex1&&$GetEle("node_"+tempindex1+"_capitalid").value==$GetEle("node_"+tempindex2+"_capitalid").value){
   				    				fetchingnumber = fetchingnumber*1 + $GetEle("node_"+tempindex2+"_number").value*1;
   				    			}
   			    			}catch(e){
   						    	continue;
   						    }
   			    		}
    		    		if(fetchingnumber>1){
    		    			alert("<%=SystemEnv.getHtmlLabelName(1437,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(1331,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(1418,user.getLanguage())%>");
    		    			return;
    		    		}
    	    		}catch(e){
    			    	continue;
    			    }
    	    	}
                }catch(e){}
		}

//保存签章数据
<%if("1".equals(isFormSignature)&&!isHideInput.equals("1")){%>
	                    try{  
					        if(typeof(eval("SaveSignature"))=="function"){
					              if(SaveSignature()){
		                            //TD4262 增加提示信息  开始


		                            var content="<%=SystemEnv.getHtmlLabelName(18978,user.getLanguage())%>";
		                            showPrompt(content);
		                            //TD4262 增加提示信息  结束
		
		                            obj.disabled=true;
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
							        }
							    }catch(e){
							        var content="<%=SystemEnv.getHtmlLabelName(18978,user.getLanguage())%>";
		                            showPrompt(content);
		                            //TD4262 增加提示信息  结束
		                            //附件上传                
		                            StartUploadAll();
		                            checkuploadcomplet();
							    }
	                    
<%}else{%>
                        //TD4262 增加提示信息  开始


                        var content="<%=SystemEnv.getHtmlLabelName(18978,user.getLanguage())%>";
                        showPrompt(content);
                        //TD4262 增加提示信息  结束
                        obj.disabled=true;
                        //附件上传
                        StartUploadAll();
                        checkuploadcomplet();
<%}%>
            }
        }
    }
    
    function cptcallback(obj){//tagtag
    	var isFormSignature="<%=isFormSignature %>";
    	var isHideInput="<%=isHideInput %>";
    	if(isFormSignature=="1"&&isHideInput!="1"){
    		
    		try{  
		        if(typeof(eval("SaveSignature"))=="function"){
		              if(SaveSignature()){
	                        //TD4262 增加提示信息  开始


	                        var content="<%=SystemEnv.getHtmlLabelName(18978,user.getLanguage())%>";
	                        showPrompt(content);
	                        //TD4262 增加提示信息  结束
	
	                        obj.disabled=true;
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
				      }
			    }catch(e){
			        var content="<%=SystemEnv.getHtmlLabelName(18978,user.getLanguage())%>";
                       showPrompt(content);
                       //TD4262 增加提示信息  结束
                       //附件上传                
                       StartUploadAll();
                       checkuploadcomplet();
			    }
    		
    	}else{
    		 //TD4262 增加提示信息  开始


            var content="<%=SystemEnv.getHtmlLabelName(18978,user.getLanguage())%>";
            showPrompt(content);
            //TD4262 增加提示信息  结束
            obj.disabled=true;
            //附件上传
            StartUploadAll();
            checkuploadcomplet();
    	}
    	
    	
    }    
    
	function onAddPhrase(phrase){            <!-- 添加常用短语 -->
    if(phrase!=null && phrase!=""){
    	$GetEle("remarkSpan").innerHTML = "";
		try{
			var remarkHtml = CkeditorExt.getHtml("remark");
			var remarkText = CkeditorExt.getText("remark");
			if(remarkText==null || remarkText==""){
				CkeditorExt.setHtml(phrase,"remark");
			}else{
				CkeditorExt.setHtml(remarkHtml+phrase,"remark");
			}
		}catch(e){}
    }
    $G("phraseselect").options[0].selected = true;
    }
<%-----------xwj for td3131 20051115 begin -----%>
//主表中金额转换字段调用


function numberToFormat(index){
    if($G("field_lable"+index).value != ""){
		var floatNum = floatFormat($G("field_lable"+index).value);
       	var val = numberChangeToChinese(floatNum)
       	if(val == ""){
       		alert("<%=SystemEnv.getHtmlLabelName(31181,user.getLanguage())%>");
            $G("field"+index).value = "";
            $G("field_lable"+index).value = "";
            $G("field_chinglish"+index).value = "";
       	} else {
	        $G("field"+index).value = floatNum;
	        $G("field_lable"+index).value = milfloatFormat(floatNum);
       		$G("field_chinglish"+index).value = val;
       	}
    }else{
        $G("field"+index).value = "";
        $G("field_chinglish"+index).value = "";
    }
}
function FormatToNumber(index){
	var elm = $GetEle("field_lable"+index);
	var n = getLocation(elm);
    if($GetEle("field_lable"+index).value != ""){
        $GetEle("field_lable"+index).value = $GetEle("field"+index).value;
    }else{
        $GetEle("field"+index).value = "";
        $GetEle("field_chinglish"+index).value = "";
    }
	setLocation(elm,n);
}
<%-----------xwj for td3131 20051115 end -----%>
//明细表中金额转换字段调用
function numberToChinese(index){
	if($G("field_lable"+index).value != ""){
		var floatNum = floatFormat($G("field_lable"+index).value);
		var val = numberChangeToChinese(floatNum);
		if(val == ""){
			alert("<%=SystemEnv.getHtmlLabelName(31181,user.getLanguage())%>");
			$G("field_lable"+index).value = "";
			$G("field"+index).value = "";
		}else{
			$G("field_lable"+index).value = val;
			$G("field"+index).value = floatNum;
		}
	} else {
		$G("field"+index).value = "";
	}
}
function ChineseToNumber(index){
if($GetEle("field_lable"+index).value != ""){
$GetEle("field_lable"+index).value = chineseChangeToNumber($GetEle("field_lable"+index).value);
$GetEle("field"+index).value = $GetEle("field_lable"+index).value;
}
else{
$GetEle("field"+index).value = "";
}
}

  setTimeout("doTriggerInit()",1000);
  function doTriggerInit(){
      var tempS = "<%=trrigerfield%>";
      datainput(tempS);
      //var tempA = tempS.split(",");
      //var tempInitJS = "";
      //for(var i=0;i<tempA.length;i++){
          //datainput(tempA[i]);
          //tempInitJS += "setTimeout(\"datainput('"+tempA[i]+"')\","+(i+1)*500+");";
      //}
      //eval(tempInitJS)
  }
  function datainput(parfield){                <!--数据导入-->
      //var xmlhttp=XmlHttp.create();
	try{
		if(event.propertyName && event.propertyName.toLowerCase() != "value"){
			return;
		}
		var src = event.srcElement || event.target; 
		if(src.tagName.toLowerCase() == 'button'){
			return ;
		}
	}catch(e){}
      var tempParfieldArr = parfield.split(",");
      var tempdata = "";
      var temprand = $GetEle("rand").value ;
      var StrData="id=<%=workflowid%>&formid=<%=formid%>&bill=<%=isbill%>&node=<%=nodeid%>&detailsum=<%=detailsum%>&trg="+parfield;
      for(var i=0;i<tempParfieldArr.length;i++){
      	var tempParfield = tempParfieldArr[i];
      	if (tempParfield != "") {
      		tempdata += $GetEle(tempParfield).value+"," ;
      	}
      <%
      if(!trrigerfield.trim().equals("")){
          ArrayList Linfieldname=ddi.GetInFieldName();
          ArrayList Lcondetionfieldname=ddi.GetConditionFieldName();
          for(int i=0;i<Linfieldname.size();i++){
              String temp=(String)Linfieldname.get(i);
      %>
          if($GetEle("<%=temp.substring(temp.indexOf("|")+1)%>")) StrData+="&<%=temp%>="+$GetEle("<%=temp.substring(temp.indexOf("|")+1)%>").value;
      <%
          }
          for(int i=0;i<Lcondetionfieldname.size();i++){
              String temp=(String)Lcondetionfieldname.get(i);
      %>
          if($GetEle("<%=temp.substring(temp.indexOf("|")+1)%>")) StrData+="&<%=temp%>="+$GetEle("<%=temp.substring(temp.indexOf("|")+1)%>").value;
      <%
          }
          }
      %>
      }
      StrData += "&trgv="+tempdata+"&rand="+temprand+"&tempflag="+Math.random();
      StrData = StrData.replace(/\+/g,"%2B");
      //$GetEle("datainputform").src="DataInputFrom.jsp?"+StrData;
      if($GetEle("datainput_"+parfield)){
		  	$GetEle("datainput_"+parfield).src = "DataInputFrom.jsp?"+StrData;
	  }else{
	  		createIframe("datainput_"+parfield);
	  		$GetEle("datainput_"+parfield).src = "DataInputFrom.jsp?"+StrData;
	  }
      //xmlhttp.open("POST", "DataInputFrom.jsp", false);
      //xmlhttp.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
      //xmlhttp.send(StrData);
  }


function uescape(url){
    return escape(url);
}
function showfieldpop(){
<%if(fieldids.size()<1){%>
alert("<%=SystemEnv.getHtmlLabelName(22577,user.getLanguage())%>");
<%}%>
}
if (window.addEventListener)
window.addEventListener("load", showfieldpop, false);
else if (window.attachEvent)
window.attachEvent("onload", showfieldpop);
else
window.onload=showfieldpop;

function changeChildField(obj, fieldid, childfieldid){
    var paraStr = "fieldid="+fieldid+"&childfieldid="+childfieldid+"&isbill=<%=isbill%>&isdetail=0&selectvalue="+obj.value;
    $GetEle("selectChange").src = "SelectChange.jsp?"+paraStr;
    //alert($GetEle("selectChange").src);
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
				var frm = document.createElement("iframe");
				frm.id = "iframe_"+pFieldid+"_"+fieldid+"_00";
				frm.style.display = "none";
			    document.body.appendChild(frm);
				$GetEle("iframe_"+pFieldid+"_"+fieldid+"_00").src = "SelectChange.jsp?"+paraStr;
			}
		}
	}catch(e){}
}
<%=selectInitJsStr%>


</script>
<jsp:include page="/workflow/request/WorkflowAddRequestBodyScript.jsp">
    <jsp:param name="formid" value="<%=formid%>" />
    <jsp:param name="isbill" value="<%=isbill%>" />
    <jsp:param name="titleFieldId" value="<%=titleFieldId%>" />
    <jsp:param name="keywordFieldId" value="<%=keywordFieldId%>" />
    <jsp:param name="keywordismand" value="<%=keywordismand%>" />
    <jsp:param name="keywordisedit" value="<%=keywordisedit%>" />

</jsp:include>
