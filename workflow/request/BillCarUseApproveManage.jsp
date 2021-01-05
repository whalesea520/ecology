<%@ page import="weaver.workflow.request.RequestConstants" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/workflow/request/WorkflowManageRequestTitle.jsp" %>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ page import="java.util.Hashtable" %>
<jsp:useBean id="WFLinkInfo" class="weaver.workflow.request.WFLinkInfo" scope="page" />
<form name="frmmain" method="post" action="RequestOperation.jsp" enctype="multipart/form-data" style="background-color:#fff;">
<input type="hidden" name="needwfback" id="needwfback" value="1" />
<input type="hidden" name="lastOperator"  id="lastOperator" value="<%=lastOperator%>"/>
<input type="hidden" name="lastOperateDate"  id="lastOperateDate" value="<%=lastOperateDate%>"/>
<input type="hidden" name="lastOperateTime"  id="lastOperateTime" value="<%=lastOperateTime%>"/>

<%@ page import="weaver.workflow.datainput.DynamicDataInput"%>
<%@ page import="weaver.interfaces.workflow.browser.Browser" %>
<%@ page import="weaver.interfaces.workflow.browser.BrowserBean" %>
<jsp:useBean id="rscount" class="weaver.conn.RecordSet" scope="page"/> <!--xwj for @td2977 20051111-->
<jsp:useBean id="rsaddop" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="DocUtil" class="weaver.docs.docs.DocUtil" scope="page" /><%----- xwj for td3323 20051209  ------%>
<jsp:useBean id="RecordSet_nf1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet_nf2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="scci" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="BaseBean" class="weaver.general.BaseBean" scope="page"/>
<jsp:useBean id="WfLinkageInfo" class="weaver.workflow.workflow.WfLinkageInfo" scope="page"/>
<jsp:useBean id="SpecialField" class="weaver.workflow.field.SpecialFieldInfo" scope="page" />
<jsp:useBean id="SecCategoryComInfo1" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="RequestManager" class="weaver.workflow.request.RequestManager" scope="page"/>
<jsp:useBean id="ProjectInfoComInfo1" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo1" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="DocComInfo1" class="weaver.docs.docs.DocComInfo" scope="page"/>
<jsp:useBean id="CapitalComInfo1" class="weaver.cpt.capital.CapitalComInfo" scope="page"/>
<jsp:useBean id="WorkflowRequestComInfo1" class="weaver.workflow.workflow.WorkflowRequestComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo1" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="DocReceiveUnitComInfo" class="weaver.docs.senddoc.DocReceiveUnitComInfo" scope="page"/>
<jsp:useBean id="docReceiveUnitComInfo_mba" class="weaver.docs.senddoc.DocReceiveUnitComInfo" scope="page"/>
<jsp:useBean id="ResourceConditionManager" class="weaver.workflow.request.ResourceConditionManager" scope="page"/>
<jsp:useBean id="FileElement" class="weaver.workflow.field.FileElement" scope="page"/>

<!--请求的标题开始 -->
<DIV align="center">
<font style="font-size:14pt;FONT-WEIGHT: bold"><%=Util.toScreen(workflowname,user.getLanguage())%></font>
</DIV>
<!--请求的标题结束 -->

<!--yl qc:67452 start-->
<iframe id="selectChange" frameborder=0 scrolling=no src=""  style="display:none"></iframe>
<!--yl qc:67452 end-->
<iframe id="datainputform" frameborder=0 scrolling=no src=""  style="display:none"></iframe>

<%----- xwj for td3323 20051209 begin ------%>
<%@ include file="/activex/target/ocxVersion.jsp" %>
<OBJECT ID="oFile" <%=strWeaverOcxInfo%> STYLE="height:0px;width:0px;overflow:hidden;"></OBJECT>
<%
 RecordSet.executeProc("workflow_Workflowbase_SByID",workflowid+"");
    int uploadType = 0;
    String selectedfieldid = "";
    String result = RequestManager.getUpLoadTypeForSelect(workflowid);
    if(!result.equals("")){
        selectedfieldid = result.substring(0,result.indexOf(","));
        uploadType = Integer.valueOf(result.substring(result.indexOf(",")+1)).intValue();
    }
 String docCategory_ = "";
 if(RecordSet.next()){
	docCategory_ = RecordSet.getString("docCategory");
 }
 int secid = Util.getIntValue(docCategory_.substring(docCategory_.lastIndexOf(",")+1),-1);
 int maxUploadImageSize = DocUtil.getMaxUploadImageSize(secid);
 if(maxUploadImageSize<=0){
 maxUploadImageSize = 5;
 }
%>
<script language=javascript>
function accesoryChanage(obj){
    var objValue = obj.value;
    if (objValue=="") return ;
    var fileLenth;
    try {
        var oFile=document.getElementById("oFile");
        oFile.FilePath=objValue;  
        fileLenth= oFile.getFileSize();  
    } catch (e){
        alert("<%=SystemEnv.getHtmlLabelName(84479,user.getLanguage())%>");
        createAndRemoveObj(obj);
        return  ;
    }
    if (fileLenth==-1) {
        createAndRemoveObj(obj);
        return ;
    }
    var fileLenthByM = (fileLenth/(1024*1024)).toFixed(1)    
    if (fileLenthByM><%=maxUploadImageSize%>) {
        alert("<%=SystemEnv.getHtmlLabelName(84480,user.getLanguage())%>"+fileLenthByM+"<%=SystemEnv.getHtmlLabelName(84480,user.getLanguage())%>"+"<%=maxUploadImageSize%>"+"<%=SystemEnv.getHtmlLabelName(84482,user.getLanguage())%>");  
        createAndRemoveObj(obj);
    }
}

function createAndRemoveObj(obj){
    objName = obj.name;
    var  newObj = document.createElement("input");
    newObj.name=objName;
    newObj.className="InputStyle";
    newObj.type="file";
    newObj.size=70;
    newObj.onchange=function(){accesoryChanage(this);};
    
    var objParentNode = obj.parentNode;
    var objNextNode = obj.nextSibling;
    obj.removeNode();
    objParentNode.insertBefore(newObj,objNextNode); 
}

function checkBrowserInput(event,datas,name,_callbackParams){
	if(datas && datas.id!=""){
		jQuery("input[name='"+name+"']").val(datas.id);
	}else{
		jQuery("input[name='"+name+"']").val("");
		jQuery("#"+name+"span").html("");
	}
	
	//checkinput5(name,name+'span',document.getElementById(name).getAttribute('viewtype'));
	datainput(name,"0");
}
</script>
<%----- xwj for td3323 20051209 end ------%>
<TABLE class="ViewForm">
  <COLGROUP>
  <COL width="20%">
  <COL width="80%">

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
  <tr style="height:1px;"><td class=Line1 colSpan=2></td></tr>
  <TR>
    <TD class="fieldnameClass"><%=SystemEnv.getHtmlLabelName(21192,user.getLanguage())%></TD>
    <TD class="fieldvalueClass">
     
        <%if(!"1".equals(isEdit_)){//xwj for td1834 on 2005-05-22
          if(!"0".equals(nodetype)){%>
       <%=Util.toScreenToEdit(requestname,user.getLanguage())%>
       <input type=hidden name=requestname value="<%=Util.toScreenToEdit(requestname,user.getLanguage())%>">
          <%}
          else{%>
          <input type=text class=Inputstyle  name=requestname temptitle="<%=SystemEnv.getHtmlLabelName(21192,user.getLanguage()) %>" onChange="checkinput('requestname','requestnamespan')" size=<%=RequestConstants.RequestName_Size%> maxlength=<%=RequestConstants.RequestName_MaxLength%>  value = "<%=Util.toScreenToEdit(requestname,user.getLanguage())%>" >
        <span id=requestnamespan><%if("".equals(Util.toScreenToEdit(requestname,user.getLanguage()))){%><img src="/images/BacoError_wev8.gif" align=absmiddle><%}%></span>
          <%}
         }
       else{%>
        <input type=text class=Inputstyle  name=requestname temptitle="<%=SystemEnv.getHtmlLabelName(21192,user.getLanguage()) %>" onChange="checkinput('requestname','requestnamespan')" size=60  maxlength=100  value = "<%=Util.toScreenToEdit(requestname,user.getLanguage())%>" >
        <span id=requestnamespan><%if("".equals(Util.toScreenToEdit(requestname,user.getLanguage()))){%><img src="/images/BacoError_wev8.gif" align=absmiddle><%}%></span>
       <%}%>
     
      &nbsp;&nbsp;&nbsp;&nbsp;
      <%if(requestlevel.equals("0")){%><%=SystemEnv.getHtmlLabelName(225,user.getLanguage())%>
      <%} else if(requestlevel.equals("1")){%><%=SystemEnv.getHtmlLabelName(15533,user.getLanguage())%>
      <%} else if(requestlevel.equals("2")){%><%=SystemEnv.getHtmlLabelName(2087,user.getLanguage())%> <%}%>
     
     
      <!--add by xhheng @ 2005/01/25 for 消息提醒 Request06，流转过程中察看短信设置 -->
      &nbsp;&nbsp;&nbsp;&nbsp;
      <%
      String sqlWfMessage = "select messageType,docCategory from workflow_base where id="+workflowid;
      int wfMessageType=0;
      String docCategory="";
      rs.executeSql(sqlWfMessage);
      if (rs.next()) {
        wfMessageType=rs.getInt("messageType");
        docCategory=rs.getString("docCategory");
      }
      if(wfMessageType == 1){
          String sqlRqMessage = "select messageType from workflow_requestbase where requestid="+requestid;
          int rqMessageType=0;
          rs.executeSql(sqlRqMessage);
          if (rs.next()) {
            rqMessageType=rs.getInt("messageType");
          }%>
          <%
          String isEditMSG = "-1";
          if(!"0".equals(nodetype)){
              RecordSet.executeSql("select isedit from workflow_nodeform where nodeid = " + String.valueOf(nodeid) + " and fieldid = -3");
              if(RecordSet.next()) isEditMSG = Util.null2String(RecordSet.getString("isedit"));
          }%>
          <tr style="height: 1px;"><td class=Line2 colSpan=2></td></tr><!-- 微信提醒(QC:98106) -->
          <TR>
          <TD > <%=SystemEnv.getHtmlLabelName(17586,user.getLanguage())%></TD>
          <td class=field>
          <%if( "0".equals(nodetype) || (!"0".equals(nodetype)&&isEditMSG.equals("1")) ){%>
          <span id=messageTypeSpan></span>
          <input type=radio value="0" name="messageType"   <%if(rqMessageType==0){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(17583,user.getLanguage())%>
          <input type=radio value="1" name="messageType"   <%if(rqMessageType==1){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(17584,user.getLanguage())%>
          <input type=radio value="2" name="messageType"   <%if(rqMessageType==2){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(17585,user.getLanguage())%>
          <%}else{%>
          <%if(rqMessageType==0){%><%=SystemEnv.getHtmlLabelName(17583,user.getLanguage())%>
          <%} else if(rqMessageType==1){%><%=SystemEnv.getHtmlLabelName(17584,user.getLanguage())%>
          <%} else if(rqMessageType==2){%><%=SystemEnv.getHtmlLabelName(17585,user.getLanguage())%> <%}%>
			<input type="hidden" value="<%=rqMessageType%>" id="messageType" name="messageType">
          <%}%>
         <!-- 微信提醒(QC:98106) -->
          </TD></TR> 
        <%}%>
          <!--add by xhheng @ 2005/01/25 for 消息提醒 Request06，流转过程中察看短信设置 -->
      &nbsp;&nbsp;&nbsp;&nbsp;
      <%
      String sqlWfChats = "select chatsType from workflow_base where id="+workflowid;
      int wfChatsType=0; 
      rs.executeSql(sqlWfChats);
      if (rs.next()) {
        wfChatsType=rs.getInt("chatsType"); 
      }
      if(wfChatsType == 1){
          String sqlRqChats = "select chatsType from workflow_requestbase where requestid="+requestid;
          int rqChatsType=0;
          rs.executeSql(sqlRqChats);
          if (rs.next()) {
            rqChatsType=rs.getInt("chatsType");
          }%>
          <%
          String isEditChats = "-1"; 
              RecordSet.executeSql("select isedit from workflow_nodeform where nodeid = " + String.valueOf(nodeid) + " and fieldid = -5");
               if(RecordSet.next()) isEditChats = Util.null2String(RecordSet.getString("isedit"));
         %>
            <tr style="height: 1px;"><td class=Line2 colSpan=2></td></tr>
          <TR>
          <TD class="fieldnameClass"> <%=SystemEnv.getHtmlLabelName(32812,user.getLanguage())%></TD>
          <td class="fieldvalueClass">
          <%if(isEditChats.equals("1")){%>
          <span id=chatsTypeSpan></span>
          <input type=radio value="0" name="chatsType"   <%if(rqChatsType==0){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(19782,user.getLanguage())%>
          <input type=radio value="1" name="chatsType"   <%if(rqChatsType==1){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(26928,user.getLanguage())%>
           <%}else{%>
          <%if(rqChatsType==0){%><%=SystemEnv.getHtmlLabelName(19782,user.getLanguage())%>
          <%} else if(rqChatsType==1){%><%=SystemEnv.getHtmlLabelName(26928,user.getLanguage())%>
          <%}%>
			<input type="hidden" value="<%=rqChatsType%>" id="chatsType" name="chatsType">
          <%}%>
          </TD></TR> 
        <%}%>
      </TD>
  </TR>  	   	<TR  style="height: 1px;">
    <TD class="Line2" colSpan=2></TD>
  </TR>
  <!-- 微信提醒(QC:98106) -->
  <!--第一行结束 -->
  <%
  if(formid==163){%>
  <TR>
  	<TD class="fieldnameClass"><%=SystemEnv.getHtmlLabelName(19018,user.getLanguage())%></TD>
  	<TD class="fieldvalueClass"><a href="/car/CarUseInfo.jsp" target="_blank"><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%></a></TD>
  </TR>
  <tr style="height:1px;"><td class=Line1 colSpan=2></td></tr>
  <%}%>
<%
String docFlags=Util.null2String((String)session.getAttribute("requestAdd"+requestid));
if (docFlags.equals("")) docFlags=Util.null2String((String)session.getAttribute("requestAdd"+user.getUID()));

HashMap specialfield = SpecialField.getFormSpecialField();//特殊字段的字段信息

ArrayList selfieldsadd=WfLinkageInfo.getSelectField(workflowid,nodeid,0);
ArrayList changefieldsadd=WfLinkageInfo.getChangeField(workflowid,nodeid,0);

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
ArrayList fieldimgwidths=new ArrayList();
ArrayList fieldimgheights=new ArrayList();
ArrayList fieldimgnums=new ArrayList();
ArrayList fieldrealtype=new ArrayList();
String fielddbtype="";                              //字段数据类型

// yl qc:67452 start
String selectInitJsStr = "";
String initIframeStr = "";
//yl qc:67452 end

int detailno=0;
int detailsum=0;
String textheight = "4";//xwj for @td2977 20051111

if(isbill.equals("0")) {
    RecordSet.executeSql("select t2.fieldid,t2.fieldorder,t1.fieldlable,t1.langurageid from workflow_fieldlable t1,workflow_formfield t2 where t1.formid=t2.formid and t1.fieldid=t2.fieldid and (t2.isdetail<>'1' or t2.isdetail is null)  and t2.formid="+formid+"  and t1.langurageid="+user.getLanguage()+" order by t2.fieldorder");

    while(RecordSet.next()){
        fieldids.add(Util.null2String(RecordSet.getString("fieldid")));
        fieldorders.add(Util.null2String(RecordSet.getString("fieldorder")));
        fieldlabels.add(Util.null2String(RecordSet.getString("fieldlable")));
        languageids.add(Util.null2String(RecordSet.getString("langurageid")));
    }
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
        fieldimgwidths.add(Util.null2String(RecordSet.getString("imgwidth")));
        fieldimgheights.add(Util.null2String(RecordSet.getString("imgheight")));
        fieldimgnums.add(Util.null2String(RecordSet.getString("textheight")));
        fieldrealtype.add(Util.null2String(RecordSet.getString("fielddbtype")));
        
          RecordSet_nf1.executeSql("select * from workflow_nodeform where nodeid = "+nodeid+" and fieldid = " + RecordSet.getString("id"));
        if(!RecordSet_nf1.next()){
        RecordSet_nf2.executeSql("insert into workflow_nodeform(nodeid,fieldid,isview,isedit,ismandatory) values("+nodeid+","+RecordSet.getString("id")+",'1','1','0')");
        }
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

// 确定字段是否显示，是否可以编辑，是否必须输入
ArrayList isfieldids=new ArrayList();              //字段队列
ArrayList isviews=new ArrayList();              //字段是否显示队列
ArrayList isedits=new ArrayList();              //字段是否可以编辑队列
ArrayList ismands=new ArrayList();              //字段是否必须输入队列

String newfromtime="";
String newendtime="";

RecordSet.executeProc("workflow_FieldForm_Select",nodeid+"");
while(RecordSet.next()){
    isfieldids.add(Util.null2String(RecordSet.getString("fieldid")));
    isviews.add(Util.null2String(RecordSet.getString("isview")));
    isedits.add(Util.null2String(RecordSet.getString("isedit")));
    ismands.add(Util.null2String(RecordSet.getString("ismandatory")));
}

String beagenter=""+userid;
//获得被代理人
RecordSet.executeSql("select agentorbyagentid from workflow_currentoperator where usertype=0 and isremark='0' and requestid="+requestid+" and userid="+userid+" and nodeid="+nodeid+" order by id desc");
if(RecordSet.next()){
  int tembeagenter=RecordSet.getInt(1);
  if(tembeagenter>0) beagenter=""+tembeagenter;
}

// 得到每个字段的信息并在页面显示
Hashtable otherPara_hs = new Hashtable();
otherPara_hs.put("workflowid",Util.null2String(workflowid));
otherPara_hs.put("requestid",Util.null2String(requestid));
otherPara_hs.put("nodetype",Util.null2String(nodetype));
otherPara_hs.put("docCategory",Util.null2String(docCategory_));
otherPara_hs.put("maxUploadImageSize",Util.null2String(maxUploadImageSize));
otherPara_hs.put("canDelAcc","0");
otherPara_hs.put("changefieldsadd",changefieldsadd);

List uploadfieldids = new ArrayList();

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
	String isbrowsermustwrite = "0";//browser是否必填

    int isfieldidindex = isfieldids.indexOf(fieldid) ;
    if( isfieldidindex != -1 ) {
        isview=(String)isviews.get(isfieldidindex);    //字段是否显示
	    isedit=(String)isedits.get(isfieldidindex);    //字段是否可以编辑
	    ismand=(String)ismands.get(isfieldidindex);    //字段是否必须输入
	    isbrowsermustwrite = ismand.equals("1") ? "2" : "1";
    }

    String fieldname = "" ;                         //字段数据库表中的字段名

    String fieldhtmltype = "" ;                     //字段的页面类型

    String fieldtype = "" ;                         //字段的类型

    String fieldlable = "" ;                        //字段显示名

    int languageid = 0 ;
    int fieldimgwidth=0;                            //图片字段宽度
    int fieldimgheight=0;                           //图片字段高度
    int fieldimgnum=0;                              //每行显示图片个数

	String bclick="";

    if(isbill.equals("0")) {
        languageid= Util.getIntValue( (String)languageids.get(tmpindex), 0 ) ;    //需要更新

        fieldhtmltype=FieldComInfo.getFieldhtmltype(fieldid);
        fieldtype=FieldComInfo.getFieldType(fieldid);
        fieldlable=(String)fieldlabels.get(tmpindex);
        fieldname=FieldComInfo.getFieldname(fieldid);
        fieldimgwidth=FieldComInfo.getImgWidth(fieldid);
		fieldimgheight=FieldComInfo.getImgHeight(fieldid);
		fieldimgnum=FieldComInfo.getImgNumPreRow(fieldid);
		fielddbtype=FieldComInfo.getFielddbtype(fieldid);
    }
    else {
        languageid = user.getLanguage() ;
        fieldname=(String)fieldnames.get(tmpindex);
        fieldhtmltype=(String)fieldhtmltypes.get(tmpindex);
        fieldtype=(String)fieldtypes.get(tmpindex);
        fieldlable = SystemEnv.getHtmlLabelName( Util.getIntValue((String)fieldlabels.get(tmpindex),0),languageid );
        fieldimgwidth=Util.getIntValue((String)fieldimgwidths.get(tmpindex),0);
		fieldimgheight=Util.getIntValue((String)fieldimgheights.get(tmpindex),0);
		fieldimgnum=Util.getIntValue((String)fieldimgnums.get(tmpindex),0);
		fielddbtype=(String)fieldrealtype.get(tmpindex);
    }

    String fieldvalue=(String)fieldvalues.get(tmpindex);

    if(fieldname.equals("manager")) {
	    String tmpmanagerid = ResourceComInfo.getManagerID(""+beagenter);
%>
	<input type=hidden name="field<%=fieldid%>" value="<%=tmpmanagerid%>">
<%
        if(isview.equals("1")){
%> <tr>
      <td <%if(fieldhtmltype.equals("2")){%> valign=top <%}%> class="fieldnameClass"> <%=Util.toScreen(fieldlable,languageid)%> </td>
      <td class="fieldvalueClass"><%=ResourceComInfo.getLastname(tmpmanagerid)%></td>
   </tr><tr style="height:1px;"><td class=Line1 colSpan=2></td></tr>
<%
        }
	    continue;
	}
	if(fieldname.equalsIgnoreCase("startDate")) newfromdate="field"+fieldid; //开始日期,主要为开始日期不大于结束日期进行比较
	if(fieldname.equalsIgnoreCase("endDate")) newenddate="field"+fieldid;   //结束日期,主要为开始日期不大于结束日期进行比较
    if(fieldname.equalsIgnoreCase("startTime")) newfromtime="field"+fieldid; //开始时间

	if(fieldname.equalsIgnoreCase("endTime")) newendtime="field"+fieldid;	//结束时间
	
	if(fieldhtmltype.equals("3") && fieldvalue.equals("0")) fieldvalue = "" ;
    if(fieldhtmltype.equals("1") && (fieldtype.equals("2") || fieldtype.equals("3")) && Util.getDoubleValue(fieldvalue,0) == 0 ) fieldvalue = "" ;

    if(ismand.equals("1"))  needcheck+=",field"+fieldid;   //如果必须输入,加入必须输入的检查中

    // 下面开始逐行显示字段

    if(isview.equals("1")){         // 字段需要显示

%>
    <tr>
      <td <%if(fieldhtmltype.equals("2")){%> valign=top <%}%> class="fieldnameClass"> <%=Util.toScreen(fieldlable,languageid)%></td>
      <td class="fieldvalueClass" style="TEXT-VALIGN: center">
	  
      <%
        if(fieldhtmltype.equals("1")){                          // 单行文本框

            if(fieldtype.equals("1")){                          // 单行文本框中的文本

                if(isedit.equals("1") && isremark==0 ){
                    if(ismand.equals("1")) {
      %>
        <input datatype="text" viewtype="<%=ismand%>" temptitle="<%=fieldlable %>" type=text class=Inputstyle id="field<%=fieldid%>" name="field<%=fieldid%>" size=50 value="<%=Util.toScreenToEdit(fieldvalue,user.getLanguage())%>" <%if(trrigerfield.indexOf("field"+fieldid)>=0){%> onBlur="datainput('field<%=fieldid%>');" <%}%> onChange="checkinput('field<%=fieldid%>','field<%=fieldid%>span')">
        <span id="field<%=fieldid%>span"><% if(fieldvalue.equals("")){%><img src="/images/BacoError_wev8.gif" align=absmiddle><%}%></span>
      <%

				    }else{%>
        <input datatype="text" viewtype="<%=ismand%>" temptitle="<%=fieldlable %>" type=text class=Inputstyle id="field<%=fieldid%>" name="field<%=fieldid%>" <%if(trrigerfield.indexOf("field"+fieldid)>=0){%> onBlur="datainput('field<%=fieldid%>');checkinput2('field<%=fieldid%>','field<%=fieldid%>span',this.getAttribute('viewtype'));" <%}else{%> onchange="checkinput2('field<%=fieldid%>','field<%=fieldid%>span',this.getAttribute('viewtype'));" <%}%> value="<%=Util.toScreenToEdit(fieldvalue,user.getLanguage())%>" size=50>
        <span id="field<%=fieldid%>span"></span>
      <%            }
			    }
                else {
      %>
        <span id="field<%=fieldid%>span"><%=Util.toScreen(fieldvalue,user.getLanguage())%></span>
         <input type=hidden class=Inputstyle id="field<%=fieldid%>" name="field<%=fieldid%>" value="<%=Util.toScreenToEdit(fieldvalue,user.getLanguage())%>" >
      <%
                }
		    }
		    else if(fieldtype.equals("2")){                     // 单行文本框中的整型

			    if(isedit.equals("1") && isremark==0 ){
				    if(ismand.equals("1")) {
      %>
        <input datatype="int" type=text viewtype="<%=ismand%>" temptitle="<%=fieldlable %>" class=Inputstyle id="field<%=fieldid%>" name="field<%=fieldid%>" size=10 value="<%=fieldvalue%>" 
		onKeyPress="ItemCount_KeyPress()" <%if(trrigerfield.indexOf("field"+fieldid)>=0){%>  onBlur="checkcount1(this);checkinput('field<%=fieldid%>','field<%=fieldid%>span');datainput('field<%=fieldid%>')" <%}else{%> onBlur="checkcount1(this);checkinput('field<%=fieldid%>','field<%=fieldid%>span')" <%}%>>
        <span id="field<%=fieldid%>span"><% if(fieldvalue.equals("")){%><img src="/images/BacoError_wev8.gif" align=absmiddle><%}%></span>
       <%

				    }else{%>
        <input datatype="int" type=text viewtype="<%=ismand%>" temptitle="<%=fieldlable %>" class=Inputstyle id="field<%=fieldid%>" name="field<%=fieldid%>" size=10 value="<%=fieldvalue%>" onKeyPress="ItemCount_KeyPress()"  <%if(trrigerfield.indexOf("field"+fieldid)>=0){%>  onBlur="checkcount1(this);datainput('field<%=fieldid%>');checkinput2('field<%=fieldid%>','field<%=fieldid%>span',this.getAttribute('viewtype'));" <%}else{%> onBlur="checkcount1(this);checkinput2('field<%=fieldid%>','field<%=fieldid%>span',this.getAttribute('viewtype'));" <%}%>>
        <span id="field<%=fieldid%>span"></span>
       <%           }
			    }
                else {
      %>
        <span id="field<%=fieldid%>span"><%=fieldvalue%></span>
         <input datatype="int" type=hidden class=Inputstyle id="field<%=fieldid%>" name="field<%=fieldid%>" value="<%=fieldvalue%>" >
      <%
                }
		    }
		    else if(fieldtype.equals("3")){                     // 单行文本框中的浮点型
			    if(isedit.equals("1") && isremark==0 ){
				    if(ismand.equals("1")) {
       %>
        <input datatype="float" type=text class=Inputstyle viewtype="<%=ismand%>" temptitle="<%=fieldlable %>" id="field<%=fieldid%>" name="field<%=fieldid%>" size=10 value="<%=fieldvalue%>"	
       onKeyPress="ItemNum_KeyPress()" <%if(trrigerfield.indexOf("field"+fieldid)>=0){%>  onBlur="checknumber1(this);checkinput('field<%=fieldid%>','field<%=fieldid%>span');datainput('field<%=fieldid%>')" <%}else{%> onBlur="checknumber1(this);checkinput('field<%=fieldid%>','field<%=fieldid%>span')" <%}%>>
        <span id="field<%=fieldid%>span"><% if(fieldvalue.equals("")){%><img src="/images/BacoError_wev8.gif" align=absmiddle><%}%></span>
       <%
    				}else{%>
        <input datatype="float" type=text viewtype="<%=ismand%>" temptitle="<%=fieldlable %>" class=Inputstyle id="field<%=fieldid%>" name="field<%=fieldid%>" size=10 value="<%=fieldvalue%>" onKeyPress="ItemNum_KeyPress()" <%if(trrigerfield.indexOf("field"+fieldid)>=0){%>  onBlur="checknumber1(this);datainput('field<%=fieldid%>');checkinput2('field<%=fieldid%>','field<%=fieldid%>span',this.getAttribute('viewtype'));" <%}else{%> onBlur="checknumber1(this);checkinput2('field<%=fieldid%>','field<%=fieldid%>span',this.getAttribute('viewtype'));" <%}%>>
        <span id="field<%=fieldid%>span"></span>
       <%           }
			    }
                else {
      %>
        <span id="field<%=fieldid%>span"><%=fieldvalue%></span>
         <input datatype="float" type=hidden class=Inputstyle id="field<%=fieldid%>" name="field<%=fieldid%>" value="<%=fieldvalue%>" >
      <%
                }
		    }
		    /*------------- xwj for td3131 20051116 begin----------*/
    else if(fieldtype.equals("4")){     // 单行文本框中的金额转换%>                     
            <TABLE cols=2 id="field<%=fieldid%>_tab">
                <tr><td>
                <%if(isedit.equals("1") && isremark==0 ){
                    if(ismand.equals("1")) {%>
                        <input datatype="float" type=text class=Inputstyle temptitle="<%=fieldlable %>" id="field_lable<%=fieldid%>" name="field_lable<%=fieldid%>" size=60 
                            onfocus="FormatToNumber('<%=fieldid%>')"
                            onKeyPress="ItemNum_KeyPress('field_lable<%=fieldid%>')" 
                            <%if(trrigerfield.indexOf("field"+fieldid)>=0){%>
                                onBlur="numberToFormat('<%=fieldid%>');
                                checkinput('field_lable<%=fieldid%>','field_lable<%=fieldid%>span');
                                datainput('field_lable<%=fieldid%>')" 
                            <%}else{%>
                                onBlur="numberToFormat('<%=fieldid%>');
                                checkinput('field_lable<%=fieldid%>','field_lable<%=fieldid%>span')" 
                            <%}%>
                        >
                    <span id="field_lable<%=fieldid%>span"><%if(fieldvalue.equals("")){%><img src="/images/BacoError_wev8.gif" align=absmiddle><%}%></span>
                    <%}else{%>
                        <input datatype="float" type=text class=Inputstyle temptitle="<%=fieldlable %>" name="field_lable<%=fieldid%>" size=60  
                            onKeyPress="ItemNum_KeyPress('field_lable<%=fieldid%>')" 
                            onfocus="FormatToNumber('<%=fieldid%>')" 
                            <%if(trrigerfield.indexOf("field"+fieldid)>=0){%>
                                onBlur="numberToFormat('<%=fieldid%>');
                                datainput('field_lable<%=fieldid%>')" 
                            <%}else{%> 
                                onBlur="numberToFormat('<%=fieldid%>')" 
                            <%}%> 
                        >
                    <%}%>
                    <span id="field<%=fieldid%>span"></span>
                    <input datatype="float" type=hidden class=Inputstyle id="field<%=fieldid%>" name="field<%=fieldid%>" value="<%=fieldvalue%>" >
                <%}else{%>
                    <span id="field<%=fieldid%>span"></span>
                    <input datatype="float" type=text class=Inputstyle temptitle="<%=fieldlable %>" id="field_lable<%=fieldid%>" name="field_lable<%=fieldid%>"  disabled="true" size=60>
                    <input datatype="float" type=hidden class=Inputstyle id="field<%=fieldid%>" name="field<%=fieldid%>" value="<%=fieldvalue%>" >
                <%}%>
                </td></tr>
                <tr><td>
                    <input type=text class=Inputstyle temptitle="<%=fieldlable %>" size=60 id="field_chinglish<%=fieldid%>" name="field_chinglish<%=fieldid%>" readOnly="true">
                </td></tr>
                <script language="javascript">
                    document.all("field_lable"+<%=fieldid%>).value  = milfloatFormat(floatFormat(<%=fieldvalue%>));
                    document.all("field_chinglish"+<%=fieldid%>).value = numberChangeToChinese(<%=fieldvalue%>);
                </script>
            </table>
	    <%}
		    /*------------- xwj for td3131 20051116 end ----------*/
		    if(changefieldsadd.indexOf(fieldid)>=0){
%>
    <input type=hidden name="oldfieldview<%=fieldid%>" value="<%=Util.getIntValue(isview,0)+Util.getIntValue(isedit,0)+Util.getIntValue(ismand,0)%>" />
<%
    }
		  }                                                       // 单行文本框条件结束

	    else if(fieldhtmltype.equals("2")){                     // 多行文本框

	    /*-----xwj for @td2977 20051111 begin-----*/
	    if(isbill.equals("0")){
			 rscount.executeSql("select * from workflow_formdict where id = " + fieldid);
			 if(rscount.next()){
			 textheight = rscount.getString("textheight");
			 }
			 }
			    /*-----xwj for @td2977 20051111 begin-----*/
		    if(isedit.equals("1") && isremark==0 ){
			    if(ismand.equals("1")) {
       %>
        <textarea class=Inputstyle viewtype="<%=ismand%>" temptitle="<%=fieldlable %>" id="field<%=fieldid%>" name="field<%=fieldid%>"  <%if(trrigerfield.indexOf("field"+fieldid)>=0){%> onBlur="datainput('field<%=fieldid%>');" <%}%> onChange="checkinput('field<%=fieldid%>','field<%=fieldid%>span')"
		rows="<%=textheight%>" cols="40" style="width:80%" ><%=Util.toScreenToEdit(fieldvalue,user.getLanguage())%></textarea><!--xwj for @td2977 20051111-->
        <span id="field<%=fieldid%>span"><% if(fieldvalue.equals("")){%><img src="/images/BacoError_wev8.gif" align=absmiddle><%}%></span>
       <%
			    }else{
       %>
        <textarea class=Inputstyle viewtype="<%=ismand%>" temptitle="<%=fieldlable %>" id="field<%=fieldid%>" name="field<%=fieldid%>" rows="<%=textheight%>" cols="40" <%if(trrigerfield.indexOf("field"+fieldid)>=0){%> onBlur="datainput('field<%=fieldid%>');checkinput2('field<%=fieldid%>','field<%=fieldid%>span',this.getAttribute('viewtype'));" <%}else{%> onchange="checkinput2('field<%=fieldid%>','field<%=fieldid%>span',this.getAttribute('viewtype'));" <%}%> style="width:80%"><%=Util.toScreenToEdit(fieldvalue,user.getLanguage())%></textarea><!--xwj for @td2977 20051111-->
        <span id="field<%=fieldid%>span"></span>
       <%       }
		    }
            else {
      %>
        <span id="field<%=fieldid%>span"><%=Util.toScreen(fieldvalue,user.getLanguage())%></span>
         <input type=hidden class=Inputstyle id="field<%=fieldid%>" name="field<%=fieldid%>" value="<%=Util.toScreenToEdit(fieldvalue,user.getLanguage())%>" >
      <%
            }
            if(changefieldsadd.indexOf(fieldid)>=0){
%>
    <input type=hidden name="oldfieldview<%=fieldid%>" value="<%=Util.getIntValue(isview,0)+Util.getIntValue(isedit,0)+Util.getIntValue(ismand,0)%>" />
<%
    }
	    }                                                           // 多行文本框条件结束

	    else if(fieldhtmltype.equals("3")){                         // 浏览按钮 (涉及workflow_broswerurl表)
            String url=BrowserComInfo.getBrowserurl(fieldtype);     // 浏览按钮弹出页面的url
            String linkurl =BrowserComInfo.getLinkurl(fieldtype);   // 浏览值点击的时候链接的url
            String showname = "";                                                   // 值显示的名称
            String showid = "";                                                     // 值

            String hiddenlinkvalue=""; 
            
             String tablename=""; //浏览框对应的表,比如人力资源表

             String columname=""; //浏览框对应的表名称字段

             String keycolumname="";   //浏览框对应的表值字段

             if(fieldtype.equals("161")||fieldtype.equals("162")){
 				url+="?type="+fielddbtype;
 			 }
            // 如果是多文档, 需要判定是否有新加入的文档,如果有,需要加在原来的后面
            if( (fieldtype.equals("37")||(fieldtype.equals("9")&&docFlags.equals("1"))) && fieldid.equals(docfileid) && !newdocid.equals("")) {
                if( ! fieldvalue.equals("") ) fieldvalue += "," ;
               if (fieldtype.equals("9")&&docFlags.equals("1"))
               fieldvalue=newdocid ;
               else
               fieldvalue += newdocid ;
            }
            
           

            if(fieldtype.equals("2") ||fieldtype.equals("19")  )	showname=fieldvalue; // 日期时间
            else if(!fieldvalue.equals("")) {
                ArrayList tempshowidlist=Util.TokenizerString(fieldvalue,",");
                if(fieldtype.equals("8") || fieldtype.equals("135")){
                    //项目，多项目
                    for(int k=0;k<tempshowidlist.size();k++){
                        if(!linkurl.equals("")){
                            showname+="<a href='"+linkurl+tempshowidlist.get(k)+"' target='_new'>"+ProjectInfoComInfo1.getProjectInfoname((String)tempshowidlist.get(k))+"</a>&nbsp";
                        }else{
                        showname+=ProjectInfoComInfo1.getProjectInfoname((String)tempshowidlist.get(k))+" ";
                        }
                    }
                }else if(fieldtype.equals("1") ||fieldtype.equals("17")||fieldtype.equals("165")||fieldtype.equals("166")){
                    //人员，多人员
                    for(int k=0;k<tempshowidlist.size();k++){
                        if(!linkurl.equals("")){
                        	if("/hrm/resource/HrmResource.jsp?id=".equals(linkurl))
                            {
                        	   	showname+="<a href='javaScript:openhrm("+tempshowidlist.get(k)+");' onclick='pointerXY(event);'>"+ResourceComInfo.getResourcename((String)tempshowidlist.get(k))+"</a>&nbsp";
                            }
                     	    else
                            	showname+="<a href='"+linkurl+tempshowidlist.get(k)+"' target='_new'>"+ResourceComInfo.getResourcename((String)tempshowidlist.get(k))+"</a>&nbsp";
                        }else{
                        showname+=ResourceComInfo.getResourcename((String)tempshowidlist.get(k))+" ";
                        }
                    }
                }
				else if(fieldtype.equals("160")){
                    //角色人员
                    for(int k=0;k<tempshowidlist.size();k++){
                       if(!linkurl.equals(""))
                       {
                    	   if("/hrm/resource/HrmResource.jsp?id=".equals(linkurl))
                           {
                       	   		showname+="<a href='javaScript:openhrm("+tempshowidlist.get(k)+");' onclick='pointerXY(event);'>"+ResourceComInfo.getResourcename((String)tempshowidlist.get(k))+"</a>&nbsp";
                           }
                    	   else
                           		showname+="<a href='"+linkurl+tempshowidlist.get(k)+"' target='_new'>"+ResourceComInfo.getResourcename((String)tempshowidlist.get(k))+"</a>&nbsp";
                        }else{
                        showname+=ResourceComInfo.getResourcename((String)tempshowidlist.get(k))+" ";
                        }
                    }
                }else if(fieldtype.equals("142")){
                    //收发文单位

                    for(int k=0;k<tempshowidlist.size();k++){
                        if(!linkurl.equals("")){
                            showname+="<a href='"+linkurl+tempshowidlist.get(k)+"' target='_new'>"+docReceiveUnitComInfo_mba.getReceiveUnitName((String)tempshowidlist.get(k))+"</a>&nbsp";
                        }else{
                        showname+=docReceiveUnitComInfo_mba.getReceiveUnitName((String)tempshowidlist.get(k))+" ";
                        }
                    }
                }
				else if(fieldtype.equals("7") || fieldtype.equals("18")){
                    //客户，多客户
                    for(int k=0;k<tempshowidlist.size();k++){
                        if(!linkurl.equals("")){
                            showname+="<a href='"+linkurl+tempshowidlist.get(k)+"' target='_new'>"+CustomerInfoComInfo.getCustomerInfoname((String)tempshowidlist.get(k))+"</a>&nbsp";
                        }else{
                        showname+=CustomerInfoComInfo.getCustomerInfoname((String)tempshowidlist.get(k))+" ";
                        }
                    }
                }else if(fieldtype.equals("4") || fieldtype.equals("57")|| fieldtype.equals("167")|| fieldtype.equals("168")){
                    //部门，多部门
                    for(int k=0;k<tempshowidlist.size();k++){
                        if(!linkurl.equals("")){
                            showname+="<a href='"+linkurl+tempshowidlist.get(k)+"' target='_new'>"+DepartmentComInfo1.getDepartmentname((String)tempshowidlist.get(k))+"</a>&nbsp";
                        }else{
                        showname+=DepartmentComInfo1.getDepartmentname((String)tempshowidlist.get(k))+" ";
                        }
                    }
                }else if(fieldtype.equals("9") || fieldtype.equals("37")){
                    //文档，多文档
                    for(int k=0;k<tempshowidlist.size();k++){

                          if (fieldtype.equals("9")&&docFlags.equals("1"))
                        {
                        //linkurl="WorkflowEditDoc.jsp?docId=";//????
                       String tempDoc=""+tempshowidlist.get(k);
                       String tempDocView="0";
					   if(isedit.equals("1")){
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
                }else if(fieldtype.equals("23")){
                    //资产
                    for(int k=0;k<tempshowidlist.size();k++){
                        if(!linkurl.equals("")){
                            showname+="<a href='"+linkurl+tempshowidlist.get(k)+"' target='_new'>"+CapitalComInfo1.getCapitalname((String)tempshowidlist.get(k))+"</a>&nbsp";
                        }else{
                        showname+=CapitalComInfo1.getCapitalname((String)tempshowidlist.get(k))+" ";
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
                }
//add by fanggsh for TD4528   20060621 begin
                else if(fieldtype.equals("141")){
                    //人力资源条件
					showname+=ResourceConditionManager.getFormShowName(fieldvalue,languageid);
                }
//add by fanggsh for TD4528   20060621 end
				//added by alan for td:10814
				else if(fieldtype.equals("142")) {
					//收发文单位

					 for(int k=0;k<tempshowidlist.size();k++){
						 if(!linkurl.equals("")){
							 showname += "<a href='"+linkurl+tempshowidlist.get(k)+"' target='_new'>"+DocReceiveUnitComInfo.getReceiveUnitName(""+tempshowidlist.get(k))+"</a>&nbsp";
	                        }else{
	                            showname += DocReceiveUnitComInfo.getReceiveUnitName(""+tempshowidlist.get(k))+" ";
	                        }
					 }
				}
                //end by alan for td:10814
                else if(fieldtype.equals("161")){//自定义单选

                    showname = "";                                   // 新建时候默认值显示的名称
					String showdesc="";
				    showid =fieldvalue;                                     // 新建时候默认值

					try{
			            Browser browser=(Browser)StaticObj.getServiceByFullname(fielddbtype, Browser.class);
			            BrowserBean bb=browser.searchById(showid);
						String desc=Util.null2String(bb.getDescription());
						String name=Util.null2String(bb.getName());
                        String href=Util.null2String(bb.getHref());
                        if(href.equals("")){
                        	showname+="<a title='"+desc+"'>"+name+"</a>&nbsp";
                        }else{
                        	showname+="<a title='"+desc+"' href='"+href+"' target='_blank'>"+name+"</a>&nbsp";
                        }
					}catch(Exception e){
					}
                }
                else if(fieldtype.equals("162")){//自定义多选

		            showname = "";                                   // 新建时候默认值显示的名称
				    showid =fieldvalue;                                     // 新建时候默认值

					try{
			            Browser browser=(Browser)StaticObj.getServiceByFullname(fielddbtype, Browser.class);
						List l=Util.TokenizerString(showid,",");
			            for(int j=0;j<l.size();j++){
						    String curid=(String)l.get(j);
				            BrowserBean bb=browser.searchById(curid);
							String name=Util.null2String(bb.getName());
							//System.out.println("showname:"+showname);
							String desc=Util.null2String(bb.getDescription());
                            String href=Util.null2String(bb.getHref());
                            if(href.equals("")){
                            	showname+="<a title='"+desc+"'>"+name+"</a>&nbsp";
                            }else{
                            	showname+="<a title='"+desc+"' href='"+href+"' target='_blank'>"+name+"</a>&nbsp";
                            }
						}
					}catch(Exception e){
					}
                } else{
	                tablename=BrowserComInfo.getBrowsertablename(fieldtype); //浏览框对应的表,比如人力资源表

	                columname=BrowserComInfo.getBrowsercolumname(fieldtype); //浏览框对应的表名称字段

	                keycolumname=BrowserComInfo.getBrowserkeycolumname(fieldtype);   //浏览框对应的表值字段


                    if(fieldvalue.indexOf(",")!=-1){
                        sql= "select "+keycolumname+","+columname+" from "+tablename+" where "+keycolumname+" in( "+fieldvalue+")";
                    }
                    else {
                        sql= "select "+keycolumname+","+columname+" from "+tablename+" where "+keycolumname+"="+fieldvalue;
                    }
                    RecordSet.executeSql(sql);
                    while(RecordSet.next()){
                        showid = Util.null2String(RecordSet.getString(1)) ;
                        String tempshowname= Util.toScreen(RecordSet.getString(2),user.getLanguage()) ;
                        if(!linkurl.equals("")){
                             showname += "<a href='"+linkurl+showid+"' target='_new'>"+tempshowname+"</a>&nbsp";
                        }else{
                            showname +=tempshowname+" ";
                        }
                    }
                }
            }
            //add by dongping
            //永乐要求在审批会议的流程中增加会议室报表链接，点击后在新窗口显示会议室报表

            if (fieldtype.equals("118")) {
            	showname ="<a href=/meeting/report/MeetingRoomPlan.jsp target=blank>"+SystemEnv.getHtmlLabelName(2193,user.getLanguage())+"</a>" ;
             }
            if(isedit.equals("1") && isremark==0 ){
            	//----对一下浏览框做特殊处理-----
            	//人力资源和多人力资源 
				//分权人力资源、分权多人力资源
				//文档、多文档
				//项目、多项目
				//客户、多客户
				//资产、会议
				//成本中心、报销费用类型
				String paramStr = "";
				if(fieldtype.equals("1")||fieldtype.equals("17")
						||fieldtype.equals("165")||fieldtype.equals("166")
						||fieldtype.equals("9")||fieldtype.equals("37")
						||fieldtype.equals("8")||fieldtype.equals("135")
						||fieldtype.equals("7")||fieldtype.equals("18")
						||fieldtype.equals("23")||fieldtype.equals("28")
						||fieldtype.equals("251")||fieldtype.equals("22")
						){
					paramStr = "bdf_wfid="+workflowid+"&bdf_fieldid="+fieldid+"&bdf_viewtype=0";
					if(fieldtype.equals("251")||fieldtype.equals("22")){
						paramStr+= "&workflowid="+workflowid+"&fieldid="+fieldid;
					}
				}else if(fieldtype.equals("152")||fieldtype.equals("171")||fieldtype.equals("16")){
						paramStr = "currworkflowid="+workflowid+"&fieldid="+fieldid;
				}
				if(!paramStr.equals("")){
					if(url.indexOf("url=")!=-1){
						String urltemp = url.substring(url.indexOf("url=")+4);
						if(urltemp.indexOf("?")!=-1){
							url+= "&"+paramStr;
						}else{
							url+= "?"+paramStr;
						}
					}
				}
				
                if( !fieldtype.equals("37") ) {    //  多文档特殊处理
                    String roleid="";
                    if (fieldtype.equals("160")){
                        rsaddop.execute("select a.level_n, a.level2_n from workflow_groupdetail a ,workflow_nodegroup b where a.groupid=b.id and a.type=50 and a.objid="+fieldid+" and b.nodeid in (select nodeid from workflow_flownode where workflowid="+workflowid+" ) ");
                        int rolelevel_tmp = 0;
                        if (rsaddop.next())
                        {
                            roleid=rsaddop.getString(1);
                            rolelevel_tmp=Util.getIntValue(rsaddop.getString(2), 0);
                            roleid += "a"+rolelevel_tmp;
                        }
                        url = url + roleid + "_" + fieldvalue;
                    }
				if(trrigerfield.indexOf("field"+fieldid)>=0){
					bclick="onShowBrowser2('"+fieldid+"','"+url+"','"+linkurl+"','"+fieldtype+
						"',this.getAttribute('viewtype'));";
				}else{
					bclick="onShowBrowser2('"+fieldid+"','"+url+"','"+linkurl+"','"+fieldtype+
						"',field"+fieldid+".getAttribute('viewtype'));";
				}
				String completeUrl = "/data.jsp?type="+fieldtype+"&fielddbtype="+fielddbtype;
				if(fieldtype.equals("2") || fieldtype.equals("19")){
    				%>
    					<button type="button" class=calendar <%if(trrigerfield.indexOf("field"+fieldid)>=0){%>onclick="onShowBrowser2('<%=fieldid%>','<%=url%>','<%=linkurl%>','<%=fieldtype%>',field<%=fieldid%>.getAttribute('viewtype'));datainput('field<%=fieldid%>');"<%}else{%> onclick="onShowBrowser2('<%=fieldid%>','<%=url%>','<%=linkurl%>','<%=fieldtype%>',field<%=fieldid%>.getAttribute('viewtype'));datainput('field<%=fieldid%>');"<%}%> title="<%=SystemEnv.getHtmlLabelName(172,user.getLanguage())%>"></button>	
    					<span id="field<%=fieldid %>span">
    					<%
    					if(fieldvalue.equals("") && ismand.equals("1")){
    					%>
    					<img align="absMiddle" src="/images/BacoError_wev8.gif"/>
    					<%
    					}else{
    						out.print(fieldvalue);
    					}
    					%>
    					</span>
    				<%
    				}else{
	   %>
		<brow:browser viewType="0" temptitle="<%=fieldlable %>" name='<%="field"+fieldid%>' id='<%="field"+fieldid%>' browserValue='<%=fieldvalue%>' browserUrl='<%=url %>' hasInput="true" isSingle='<%=WFLinkInfo.browIsSingle(fieldtype)%>' hasBrowser = "true" isMustInput='<%=isbrowsermustwrite %>' completeUrl='<%=completeUrl %>' width="130px" needHidden="false" browserSpanValue='<%=showname%>'  _callback="checkBrowserInput"> </brow:browser>
	   <!--
        <button class=Browser viewtype="<%=ismand%>" <%if(trrigerfield.indexOf("field"+fieldid)>=0){%> onclick="onShowBrowser2('<%=fieldid%>','<%=url%>','<%=linkurl%>','<%=fieldtype%>',this.getAttribute('viewtype'));"<%}else{%> onclick="onShowBrowser2('<%=fieldid%>','<%=url%>','<%=linkurl%>','<%=fieldtype%>',field<%=fieldid%>.getAttribute('viewtype'));"<%}%> title="<%=SystemEnv.getHtmlLabelName(172,user.getLanguage())%>"></button>-->
       <%       }} else {                         // 如果是多文档字段,加入新建文档按钮
			bclick="onShowBrowser2('"+fieldid+"','"+url+"','"+linkurl+"','"+fieldtype+"','"+ismand+"')";
       %>
		<brow:browser viewType="0" temptitle="<%=fieldlable %>" name='<%="field"+fieldid%>' browserValue='<%=fieldvalue%>' browserUrl='<%=url %>' hasInput="true" isSingle='<%=WFLinkInfo.browIsSingle(fieldtype)%>' hasBrowser = "true" isMustInput='<%=isbrowsermustwrite %>' completeUrl="/data.jsp" width="130px" needHidden="false" browserSpanValue='<%=showname%>' _callback="checkBrowserInput"> </brow:browser>
	   <!--
        <button class=AddDoc onclick="onShowBrowser2('<%=fieldid%>','<%=url%>','<%=linkurl%>','<%=fieldtype%>','<%=ismand%>')" > <%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></button>-->
		&nbsp;&nbsp;<button class=AddDoc onclick="onNewDoc(<%=fieldid%>)" title="<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%>"><%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%></button>
       <%       }
            }
       %>
		<%
		   if(fieldtype.equals("2") || fieldtype.equals("19")  || fieldtype.equals("178") || fieldtype.equals("137")){
		}else if(fieldhtmltype.equals("3")){%>
       
		<%}%>
		<input type=hidden viewtype="<%=ismand%>" id="field<%=fieldid%>" name="field<%=fieldid%>" value="<%=fieldvalue%>">
       <%
       if(changefieldsadd.indexOf(fieldid)>=0){
%>
    <input type=hidden name="oldfieldview<%=fieldid%>" value="<%=Util.getIntValue(isview,0)+Util.getIntValue(isedit,0)+Util.getIntValue(ismand,0)%>" />
<%
    }
       if(isedit.equals("0")){
    		out.println(showname);
       }
	    }                                                       // 浏览按钮条件结束
	    else if(fieldhtmltype.equals("4")) {                    // check框

	   %>
        <input type=checkbox value=1 name="field<%=fieldid%>" <%if(isedit.equals("0") || isremark==1 ){%> DISABLED <%}%> <%if(trrigerfield.indexOf("field"+fieldid)>=0){%> onChange="datainput('field<%=fieldid%>');" <%}%> <%if(fieldvalue.equals("1")){%> checked <%}%> >
        <%if(isedit.equals("0") || isremark==1 ){%>
        <input type=hidden class=Inputstyle name="field<%=fieldid%>" value="<%=fieldvalue%>" >
        <%}%>       
       <%
        }                                                       // check框条件结束

        else if(fieldhtmltype.equals("5")){                     // 选择框   select

            //yl 67452   start
            String uploadMax = "";
            if(fieldid.equals(selectedfieldid)&&uploadType==1)
            {
                uploadMax = "changeMaxUpload('field"+fieldid+"');reAccesoryChanage();";
            }
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
        <select notBeauty=true class=inputstyle viewtype="<%=ismand%>" temptitle="<%=fieldlable %>" <%=onchangeAddStr%> id="field<%=fieldid%>" name="field<%=fieldid%>" <%if(isedit.equals("1")){%>onBlur="checkinput2('field<%=fieldid%>','field<%=fieldid%>span',this.getAttribute('viewtype'));"<%}%> <%if(isedit.equals("0") || isremark==1 ){%> DISABLED <%}%> <%if(trrigerfield.indexOf("field"+fieldid)>=0&&selfieldsadd.indexOf(fieldid)>=0){%> onChange="datainput('field<%=fieldid%>');changeshowattr('<%=fieldid%>_0',this.value,-1,<%=workflowid%>,<%=nodeid%>);" <%}else if(selfieldsadd.indexOf(fieldid)>=0){%> onchange="changeshowattr('<%=fieldid%>_0',this.value,-1,<%=workflowid%>,<%=nodeid%>);" <%}else if(trrigerfield.indexOf("field"+fieldid)>=0){%> onchange="datainput('field<%=fieldid%>');" <%}%>><!--added by xwj for td3313 20051206 -->
	    <option value=""></option><!--added by xwj for td3297 20051130 -->
	   <%
            // 查询选择框的所有可以选择的值

            rs.executeProc("workflow_selectitembyid_new",""+fieldid+flag+isbill);
             boolean checkempty = true;//xwj for td3313 20051206
			      String finalvalue = "";//xwj for td3313 20051206

           //yl 67452   start
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
            <%            }
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

            %>
	    </select>
	    
	    <!--xwj for td3313 20051206 begin-->
	    <span id="field<%=fieldid%>span">
	    <%
	     if(ismand.equals("1") && checkempty){
	    %>
       <IMG src='/images/BacoError_wev8.gif' align=absMiddle>
      <%
            }
       %>
	     </span>
	    <!--xwj for td3313 20051206 end-->
	    
        <%if(isedit.equals("0") || isremark==1 ){%>
        <input type=hidden class=Inputstyle name="field<%=fieldid%>" value="<%=finalvalue%>" >
        <%}%>
       <%
       if(changefieldsadd.indexOf(fieldid)>=0){
%>
    <input type=hidden name="oldfieldview<%=fieldid%>" value="<%=Util.getIntValue(isview,0)+Util.getIntValue(isedit,0)+Util.getIntValue(ismand,0)%>" />
<%
    }
        //add by xhheng @20050310 for 附件上传
        }else if(fieldhtmltype.equals("6")){
        	otherPara_hs.put("fieldimgwidth"+fieldid, Util.null2String(fieldimgwidth));
        	otherPara_hs.put("fieldimgheight"+fieldid, Util.null2String(fieldimgheight));
        	otherPara_hs.put("fieldimgnum"+fieldid, Util.null2String(fieldimgnum));
        	otherPara_hs.put("uploadfieldids", uploadfieldids);
        	uploadfieldids.add(fieldid);
        	
        	Hashtable ret_hs = FileElement.getHtmlElementString(Util.getIntValue(fieldid), fieldname, Util.getIntValue(fieldtype), fieldlable, 0, 0, 0, fieldvalue, 0, Util.getIntValue(isview), Util.getIntValue(isedit), Util.getIntValue(ismand), user, otherPara_hs);
        	out.println(Util.null2String(ret_hs.get("inputStr")));
        	out.println("<script>");
        	out.println(Util.null2String(ret_hs.get("jsStr")));
        	out.println("</script>");
        }
       else if(fieldhtmltype.equals("7")){
     	   out.println(Util.null2String((String)specialfield.get(fieldid+"_1")));
        }     // 选择框条件结束 所有条件判定结束

       %>
      </td>
    </tr><tr style="height:1px;"><td class=Line1 colSpan=2></td></tr>

<%
    }else {                              // 不显示的作为 hidden 保存信息
%>
    <input type=hidden name="field<%=fieldid%>" value="<%=Util.toScreenToEdit(fieldvalue,user.getLanguage())%>" >
<%
    }%>

	<%
}       // 循环结束
%>

</table>
<!--yl qc:67452 start-->
<%=initIframeStr%>
<!--yl qc:67452   end>


<!--#######明细表 Start#######-->
<%//@ include file="/workflow/request/WorkflowManageRequestDetailBody.jsp" %>
<!--#######明细表 END#########-->
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

<script language="javascript">

function onNewDoc(fieldid) {
    frmmain.action = "RequestOperation.jsp" ;
    frmmain.method.value = "docnew_"+fieldid ;
    document.frmmain.src.value='save';
    //附件上传
                        StartUploadAll();
                        checkuploadcomplet();
}

function onShowBrowser2(id,url,linkurl,type1,ismand, funFlag) {
	var id1 = null;
	
    if (type1 == 9  && "<%=docFlags%>" == "1" ) {
        if (wuiUtil.isNotNull(funFlag) && funFlag == 3) {
        	url = "/systeminfo/BrowserMain.jsp?url=/docs/docs/DocBrowser.jsp"
        } else {
	    	url = "/systeminfo/BrowserMain.jsp?url=/docs/docs/DocBrowserWord.jsp";
        }
	}
	
	if (type1 == 2 || type1 == 19 ) {
	    spanname = "field" + id + "span";
	    inputname = "field" + id;
	    
		if (type1 == 2) {
			onWorkFlowShowDate(spanname,inputname,ismand);
		} else {
			onWorkFlowShowTime(spanname, inputname, ismand);
		}
	} else {
	    if (type1 != 171 && type1 != 162 && type1 != 152 && type1 != 142 && type1 != 135 && type1 != 17 && type1 != 18 && type1!=27 && type1!=37 && type1!=56 && type1!=57 && type1!=65 && type1!=165 && type1!=166 && type1!=167 && type1!=168 && type1!=170 && type1!=194) {
				id1 = window.showModalDialog(url, window, "dialogWidth=550px;dialogHeight=550px");
		} else {
	        if (type1 == 135) {
				tmpids = $GetEle("field"+id).value;
				id1 = window.showModalDialog(url + "?projectids=" + tmpids, "", "dialogWidth=550px;dialogHeight=550px");
	        }else if (type1 == 4 || type1 == 164 || type1 == 169 || type1 == 170 || type1 == 194) {
		        tmpids = $GetEle("field"+id).value;
				id1 = window.showModalDialog(url + "?selectedids=" + tmpids, "", "dialogWidth=550px;dialogHeight=550px");
	        } else if (type1 == 37) { 
		        tmpids = $GetEle("field"+id).value;
				id1 = window.showModalDialog(url + "?documentids=" + tmpids, "", "dialogWidth=550px;dialogHeight=550px");
	        } else if (type1 == 142 ) {
		        tmpids = $GetEle("field"+id).value;
				id1 = window.showModalDialog(url + "?receiveUnitIds=" + tmpids, "", "dialogWidth=550px;dialogHeight=550px");
			} else if (type1 == 165 || type1 == 166 || type1 == 167 || type1 == 168 ) {
		        index = (id + "").indexOf("_");
		        if (index != -1) {
		        	tmpids=uescape("?isdetail=1&fieldid="& Mid(id,1,index-1)&"&resourceids="&$GetEle("field"+id).value);
		        	id1 = window.showModalDialog(url + tmpids, "", "dialogWidth=550px;dialogHeight=550px");
		        } else {
		        	tmpids = uescape("?fieldid=" + id + "&resourceids=" + $GetEle("field" + id).value);
		        	id1 = window.showModalDialog(url + tmpids, "", "dialogWidth=550px;dialogHeight=550px");
		        }
			} else if (type1 == 162 ) {
				tmpids = $GetEle("field"+id).value;
				
				if (wuiUtil.isNotNull(funFlag) && funFlag == 3) {
					url = url + "&beanids=" + tmpids;
					url = url.substring(0, url.indexOf("url=") + 4) + escape(url.substr(url.indexOf("url=") + 4));
					id1 = window.showModalDialog(url, "", "dialogWidth=550px;dialogHeight=550px");
				} else {
					url = url + "|" + id + "&beanids=" + tmpids;
					url = url.substring(0, url.indexOf("url=") + 4) + escape(url.substr(url.indexOf("url=") + 4));
					id1 = window.showModalDialog(url, window, "dialogWidth=550px;dialogHeight=550px");
				}
			} else {
		        tmpids = $GetEle("field" + id).value;
				id1 = window.showModalDialog(url + "?resourceids=" + tmpids, "", "dialogWidth=550px;dialogHeight=550px");
			}
		}
		
	    if (id1 != undefined && id1 != null) {
			if (type1 == 171 || type1 == 152 || type1 == 142 || type1 == 135 || type1 == 17 || type1 == 18 || type1==27 || type1==37 || type1==56 || type1==57 || type1==65 || type1==166 || type1==168 || type1==170) {
				if (wuiUtil.getJsonValueByIndex(id1, 0) != "" && wuiUtil.getJsonValueByIndex(id1, 0) != "0" ) {
					var resourceids = wuiUtil.getJsonValueByIndex(id1, 0);
					var resourcename = wuiUtil.getJsonValueByIndex(id1, 1);
					var sHtml = ""
					if(resourceids.substr(0,1)==","){
						resourceids = resourceids.substr(1);
						resourcename = resourcename.substr(1);
					}
					
					var resourceIdArray = resourceids.split(",");
					var resourceNameArray = resourcename.split(",");
					for (var _i=0; _i<resourceIdArray.length; _i++) {
						var curid = resourceIdArray[_i];
						var curname = resourceNameArray[_i];
						if (linkurl == "/hrm/resource/HrmResource.jsp?id=") {
							sHtml += "<a href=javaScript:openhrm(" + curid + "); onclick='pointerXY(event);'>" + curname + "</a>&nbsp";
						} else {
							sHtml += "<a href=" + linkurl + curid + " target=_blank>" + curname + "</a>&nbsp";
						}
					}
					
					$GetEle("field"+id+"span").innerHTML = sHtml;
					$GetEle("field"+id).value= resourceids;
				} else {
 					if (ismand == 0) {
 						$GetEle("field"+id+"span").innerHTML = "";
 					} else {
 						$GetEle("field"+id+"span").innerHTML = "<img src='/images/BacoError_wev8.gif' align=absmiddle>";
 					}
 					$GetEle("field"+id).value = "";
				}

			} else {
			   if (wuiUtil.getJsonValueByIndex(id1, 0) != "") {
	               if (type1 == 162) {
				   		var ids = wuiUtil.getJsonValueByIndex(id1, 0);
						var names = wuiUtil.getJsonValueByIndex(id1, 1);
						var descs = wuiUtil.getJsonValueByIndex(id1, 2);
						sHtml = ""
						if(ids.substr(0,1)==","){
							ids = ids.substr(1);
							names = names.substr(1);
							descs = descs.substr(1);
						}
						$GetEle("field"+id).value= ids;
						
						var idArray = ids.split(",");
						var nameArray = names.split(",");
						var descArray = descs.split(",");
						for (var _i=0; _i<idArray.length; _i++) {
							var curid = idArray[_i];
							var curname = nameArray[_i];
							var curdesc = descArray[_i];
							sHtml += "<a title='" + curdesc + "' >" + curname + "</a>&nbsp";
						}
						
						$GetEle("field" + id + "span").innerHTML = sHtml;
						return;
	               }
				   if (type1 == 161) {
					   	var ids = wuiUtil.getJsonValueByIndex(id1, 0);
					   	var names = wuiUtil.getJsonValueByIndex(id1, 1);
						var descs = wuiUtil.getJsonValueByIndex(id1, 2);
						$GetEle("field"+id).value = ids;
						sHtml = "<a title='" + descs + "'>" + names + "</a>&nbsp";
						$GetEle("field" + id + "span").innerHTML = sHtml
						return ;
				   }
	               if (type1 == 9 && "<%=docFlags%>" == "1") {
		                tempid = wuiUtil.getJsonValueByIndex(id1, 0);
		                $GetEle("field" + id + "span").innerHTML = "<a href='#' onclick=\"createDoc(" + id + ", " + tempid + ", 1)\">" + wuiUtil.getJsonValueByIndex(id1, 1) + "</a><button type=\"button\"  type=\"button\" id=\"createdoc\" style=\"display:none\" class=\"AddDocFlow\" onclick=\"createDoc(" + id + ", " + tempid + ",1)\"></button>";
	               } else {
	            	    if (linkurl == "") {
				        	$GetEle("field" + id + "span").innerHTML = wuiUtil.getJsonValueByIndex(id1, 1);
				        } else {
							if (linkurl == "/hrm/resource/HrmResource.jsp?id=") {
								$GetEle("field"+id+"span").innerHTML = "<a href=javaScript:openhrm("+ wuiUtil.getJsonValueByIndex(id1, 0) + "); onclick='pointerXY(event);'>" + wuiUtil.getJsonValueByIndex(id1, 1) + "</a>&nbsp";
							} else {
								$GetEle("field"+id+"span").innerHTML = "<a href=" + linkurl + wuiUtil.getJsonValueByIndex(id1, 0) + " target='_new'>"+ wuiUtil.getJsonValueByIndex(id1, 1) + "</a>";
							}
				        }
	               }
	               $GetEle("field"+id).value = wuiUtil.getJsonValueByIndex(id1, 0);
	                if (type1 == 9 && "<%=docFlags%>" == "1") {
	                	var evt = getEvent();
	               		var targetElement = evt.srcElement ? evt.srcElement : evt.target;
	               		jQuery(targetElement).next("span[id=CreateNewDoc]").html("");
	                }
			   } else {
					if (ismand == 0) {
						$GetEle("field"+id+"span").innerHTML = "";
					} else {
						$GetEle("field"+id+"span").innerHTML ="<img src='/images/BacoError_wev8.gif' align=absmiddle>"
					}
					$GetEle("field"+id).value="";
					if (type1 == 9 && "<%=docFlags%>" == "1"){
						var evt = getEvent();
	               		var targetElement = evt.srcElement ? evt.srcElement : evt.target;
	               		jQuery(targetElement).next("span[id=CreateNewDoc]").html("<button type=button  type=button id='createdoc' class=AddDocFlow onclick=createDoc(" + id + ",'','1') title='<%=SystemEnv.getHtmlLabelName(82, user.getLanguage())%>'><%=SystemEnv.getHtmlLabelName(82, user.getLanguage())%></button>");
					}
			   }
			}
		}
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
	try {
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
	        }else{
	                if(document.frmmain.<%=newenddate%>.value==document.frmmain.<%=newfromdate%>.value && document.frmmain.<%=newendtime%>.value<document.frmmain.<%=newfromtime%>.value){
	                    window.alert("<%=SystemEnv.getHtmlLabelName(15273,user.getLanguage())%>");
	                    return false;
	                }
	            }
	    }
	    return true;
	} catch (e) {
    	return true;
    }
}

function doTriggerInit(){
    var tempS = "<%=trrigerfield%>";
    var tempA = tempS.split(",");
    for(var i=0;i<tempA.length;i++){
        datainput(tempA[i]);
    }
} 
var tempvalue = "";
function datainput(parfield,type){                <!--数据导入-->
	  
	  if(",<%=trrigerfield%>,".indexOf(","+parfield+",")==-1){
	  	return;
	  }
	  if(jQuery("#"+parfield).val()==tempvalue && type!="0"){
	  	return;
	  }else{
	  	tempvalue = jQuery("#"+parfield).val();
	  }
      //var xmlhttp=XmlHttp.create();
      var StrData="id=<%=workflowid%>&formid=<%=formid%>&bill=<%=isbill%>&node=<%=nodeid%>&detailsum=<%=detailsum%>&trg="+parfield;
      <%
          ArrayList Linfieldname=ddi.GetInFieldName();
          ArrayList Lcondetionfieldname=ddi.GetConditionFieldName();
          for(int i=0;i<Linfieldname.size();i++){
              String temp=(String)Linfieldname.get(i);
      %>
          StrData+="&<%=temp%>="+document.all("<%=temp.substring(temp.indexOf("|")+1)%>").value;
      <%
          }
          for(int i=0;i<Lcondetionfieldname.size();i++){
              String temp=(String)Lcondetionfieldname.get(i);
      %>
          StrData+="&<%=temp%>="+document.all("<%=temp.substring(temp.indexOf("|")+1)%>").value;
      <%
          }
      %>
      //alert(StrData);
      document.all("datainputform").src="DataInputFrom.jsp?"+StrData;
      //xmlhttp.open("POST", "DataInputFrom.jsp", false); 
      //xmlhttp.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
      //xmlhttp.send(StrData);
  }
  function addannexRow(accname)
  {
    document.all(accname+'_num').value=parseInt(document.all(accname+'_num').value)+1;
    ncol = document.all(accname+'_tab').cols;
    oRow = document.all(accname+'_tab').insertRow(-1);
    for(j=0; j<ncol; j++) {
      oCell = oRow.insertCell(-1); 

      switch(j) {
        case 0:
          var oDiv = document.createElement("div");
          <%----- Modified by xwj for td3323 20051209  ------%>
          var sHtml = "<input class=InputStyle  type=file size=50 name='"+accname+"_"+document.all(accname+'_num').value+"' onchange='accesoryChanage(this)'> (此目录下最大只能上传<%=maxUploadImageSize%>M/个的附件) ";
          oDiv.innerHTML = sHtml;
          oCell.appendChild(oDiv);
          break;
        case 1:
          var oDiv = document.createElement("div");
          var sHtml = "&nbsp;";
          oDiv.innerHTML = sHtml;
          oCell.appendChild(oDiv);
          break;
        case 2:
          var oDiv = document.createElement("div");
          var sHtml = "&nbsp;";
          oDiv.innerHTML = sHtml;
          oCell.appendChild(oDiv);
          break;
      }
    }
  }


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
function openAccessory(fileId){
	jQuery($GetEle("flowbody")).attr("onbeforeunload", "");
	openFullWindowHaveBar("/weaver/weaver.file.FileDownload?fileid="+fileId+"&requestid=<%=requestid%>");
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

//hjun 2015-08-04 字段属性联动
jQuery(document).ready(function(){
<%
String sqlLink = "select * from workflow_viewattrlinkage where workflowid="+workflowid+" and nodeid="+nodeid;
RecordSet.executeSql(sqlLink);
while(RecordSet.next()){
	String selectfieldid = Util.null2String(RecordSet.getString("selectfieldid"));
	//String[] selectfieldidattr = selectedfieldid.split("_");
	selectfieldid = selectfieldid.substring(0, selectfieldid.indexOf("_"));
	String selectfieldvalue = Util.null2String(RecordSet.getString("selectfieldvalue"));
	String changefieldids = Util.null2String(RecordSet.getString("changefieldids"));
	String[] changefieldidarr = changefieldids.split(",");
	String viewattr = Util.null2String(RecordSet.getString("viewattr"));
	%>
	if(jQuery("#field<%=selectfieldid%>").val()=="<%=selectfieldvalue%>"){
		<%
		for(int i=0;i<changefieldidarr.length;i++){
			if(!"".equals(changefieldidarr[i])){
				String changefieldid = changefieldidarr[i].substring(0,changefieldidarr[i].indexOf("_"));
				if(viewattr.equals("2")){//必填
				%>
				//if("<%=viewattr%>"=="2"){
					jQuery("#field<%=changefieldid%>").attr("viewtype","1");
				//}
				<%
				}else{
				%>
				//else{
					jQuery("#field<%=changefieldid%>").attr("viewtype","0");
				//}
				<%
				}
			}
		}
		%>
	}
	<%
%>
	jQuery("#field<%=selectfieldid%>").change(function(){
		if(jQuery(this).val()=="<%=selectfieldvalue%>"){
		<%
		for(int i=0;i<changefieldidarr.length;i++){
			if(!"".equals(changefieldidarr[i])){
				//String[] changefieldidattr = changefieldidarr[i].split("_");
				String changefieldid = changefieldidarr[i].substring(0,changefieldidarr[i].indexOf("_"));
				%>
				//var val = $("#field<%=changefieldid%>").val();
				//$("#field<%=changefieldid%>").val("");
				<%
				if(viewattr.equals("2")){//必填
				%>
					//$("#field<%=changefieldid%>").attr("viewtype","1");
					document.getElementById("field<%=changefieldid%>").setAttribute("viewtype","1");
				<%
				}else{
				%>
					//$("#field<%=changefieldid%>").attr("viewtype","0");
					document.getElementById("field<%=changefieldid%>").setAttribute("viewtype","0");
				<%
				}
			}
		}
		%>
		}
	});
<%
}
%>
});
////字段联动 end

function checkinput5(elementname,spanid,viewtype){
	if (wuiUtil.isNullOrEmpty(viewtype)) {
		viewtype = $G(elementname).getAttribute("viewtype");
	}
	if(viewtype==1){
		var tmpvalue = "";
		try{
			tmpvalue = $GetEle(elementname).value;
		}catch(e){
			tmpvalue = $GetEle(elementname).value;
		}
		//alert();
		while(tmpvalue.indexOf(" ") >= 0){
			tmpvalue = tmpvalue.replace(" ", "");
		}
		while(tmpvalue.indexOf("\r\n") >= 0){
			tmpvalue = tmpvalue.replace("\r\n", "");
		}
		if(tmpvalue!=""){
			$GetEle(spanid+"img").innerHTML = "";
		}else{
			$GetEle(spanid+"img").innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
			//$GetEle(elementname).value = "";
		}
	}
}

</script>
	<%@ include file="/workflow/request/WorkflowManageSign.jsp" %>
</form>