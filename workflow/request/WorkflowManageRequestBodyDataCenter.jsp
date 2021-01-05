<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.workflow.datainput.DynamicDataInput"%>
<%@ page import="java.util.HashMap" %>
<%@ page import="weaver.workflow.request.RequestConstants" %>
<jsp:useBean id="rscount" class="weaver.conn.RecordSet" scope="page"/> <!--xwj for @td2977 20051111-->
<jsp:useBean id="DocUtil" class="weaver.docs.docs.DocUtil" scope="page" /> 
<jsp:useBean id="rs_item" class="weaver.conn.RecordSet" scope="page" />
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
<jsp:useBean id="docReceiveUnitComInfo_mbdc" class="weaver.docs.senddoc.DocReceiveUnitComInfo" scope="page"/>
<jsp:useBean id="BaseBean" class="weaver.general.BaseBean" scope="page"/>
<%
HashMap specialfield = SpecialField.getFormSpecialField();//特殊字段的字段信息
%>


<%
String selectInitJsStr = "";
String initIframeStr = "";
ArrayList flowDocs=flowDoc.getDocFiled(""+workflowid); //得到流程建文挡的发文号字段
String codeField="";
if (flowDocs!=null&&flowDocs.size()>0)
{
codeField=""+flowDocs.get(0);
}
String docFlags=Util.null2String((String)session.getAttribute("requestAdd"+requestid));
if (docFlags.equals("")) docFlags=Util.null2String((String)session.getAttribute("requestAdd"+user.getUID()));
if (!docFlags.equals("1")) {%>
<!--请求的标题开始 -->
<DIV align="center">
<font style="font-size:14pt;FONT-WEIGHT: bold"><%=Util.toScreen(workflowname,user.getLanguage())%></font>
</DIV>
<title><%=Util.toScreen(workflowname,user.getLanguage())%></title>
<%}%>
<!--请求的标题结束 -->
<iframe id="selectChange" frameborder=0 scrolling=no src=""  style="display:none"></iframe>
<iframe id="datainputform" frameborder=0 scrolling=no src=""  style="display:none"></iframe>
<BR>

<%
String isaffirmancebody=Util.null2String((String)session.getAttribute(user.getUID()+"_"+requestid+"isaffirmance"));//是否需要提交确认
String reEditbody=Util.null2String((String)session.getAttribute(user.getUID()+"_"+requestid+"reEdit"));//是否需要提交确认
int rqMessageType=-1;
String docCategory= "";
String sqlWfMessage = "select a.messagetype,b.docCategory from workflow_requestbase a,workflow_base b where a.workflowid=b.id and a.requestid="+requestid ;
RecordSet.executeSql(sqlWfMessage);
if (RecordSet.next()) {
    rqMessageType=RecordSet.getInt("messagetype");
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
%>
<script language=javascript>
function accesoryChanage(obj){
    var objValue = obj.value;
    if (objValue=="") return ;
    var fileLenth;
    try {
        var oFile=$G("oFile");
        oFile.FilePath=objValue;
        fileLenth= oFile.getFileSize();
    } catch (e){
        alert("<%=SystemEnv.getHtmlLabelName(20253,user.getLanguage())%>");
        createAndRemoveObj(obj);
        return  ;
    }
    if (fileLenth==-1) {
        createAndRemoveObj(obj);
        return ;
    }
    var fileLenthByM = (fileLenth/(1024*1024)).toFixed(1)
    if (fileLenthByM><%=maxUploadImageSize%>) {
     	alert("<%=SystemEnv.getHtmlLabelName(20254,user.getLanguage())%>"+fileLenthByM+"M,<%=SystemEnv.getHtmlLabelName(20255,user.getLanguage())%><%=maxUploadImageSize%>M<%=SystemEnv.getHtmlLabelName(20256 ,user.getLanguage())%>");  
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
</script>

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
  <TR class="Spacing">
    <TD class="Line1" colSpan=2></TD>
  </TR>
  <%
boolean editflag = true;//流程的处理人可以编辑流程的优先级和是否短信提醒
if(isremark==1||isremark==8||isremark==9||isremark==7) editflag = false;//被转发人或被抄送人不能编辑
int wfMessageType=0;
RecordSet.executeSql("select messageType from workflow_base where id="+workflowid);
if (RecordSet.next()) {
    wfMessageType=RecordSet.getInt("messageType");
}
if(editflag&&"0".equals(nodetype)&&(!isaffirmancebody.equals("1")||reEditbody.equals("1"))){%>
  <TR>
    <TD><%=SystemEnv.getHtmlLabelName(21192,user.getLanguage())%></TD>
    <TD class=field>
        <input type=text class=Inputstyle  temptitle="<%=SystemEnv.getHtmlLabelName(21192,user.getLanguage())%>" name=requestname onChange="checkinput('requestname','requestnamespan')" size=<%=RequestConstants.RequestName_Size%> maxlength=<%=RequestConstants.RequestName_MaxLength%>  value = "<%=Util.toScreenToEdit(requestname,user.getLanguage())%>" >
        <span id=requestnamespan><%if("".equals(Util.toScreenToEdit(requestname,user.getLanguage()))){%><img src="/images/BacoError_wev8.gif" align=absmiddle><%}%></span>

        <input type=radio value="0" name="requestlevel" <%if(requestlevel.equals("0")){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(225,user.getLanguage())%>
        <input type=radio value="1" name="requestlevel" <%if(requestlevel.equals("1")){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(15533,user.getLanguage())%>
        <input type=radio value="2" name="requestlevel" <%if(requestlevel.equals("2")){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(2087,user.getLanguage())%>
      </TD>
  </TR>
  <TR>
    <TD class="Line2" colSpan=2></TD>
  </TR>

<%
      if (wfMessageType==1) {
%>
                  <TR>
                    <TD > <%=SystemEnv.getHtmlLabelName(17586,user.getLanguage())%></TD>
                    <td class=field>
                          <span id=messageTypeSpan></span>
                          <input type=radio value="0" name="messageType"   <%if(rqMessageType==0){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(17583,user.getLanguage())%>
                          <input type=radio value="1" name="messageType"   <%if(rqMessageType==1){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(17584,user.getLanguage())%>
                          <input type=radio value="2" name="messageType"   <%if(rqMessageType==2){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(17585,user.getLanguage())%>
                        </td>
                  </TR>
                  <TR><TD class=Line2 colSpan=2></TD></TR>
      <%}%>
<%}else if(editflag&&(!isaffirmancebody.equals("1")||reEditbody.equals("1"))){%>
  <TR>
    <TD><%=SystemEnv.getHtmlLabelName(21192,user.getLanguage())%></TD>
    <TD class=field>
        <%if("1".equals(isEdit_)&&(!isaffirmancebody.equals("1")||reEditbody.equals("1"))){%>
        <input type=text class=Inputstyle  temptitle="<%=SystemEnv.getHtmlLabelName(21192,user.getLanguage())%>" name=requestname onChange="checkinput('requestname','requestnamespan')" size=<%=RequestConstants.RequestName_Size%> maxlength=<%=RequestConstants.RequestName_MaxLength%>  value = "<%=Util.toScreenToEdit(requestname,user.getLanguage())%>" >
        <span id=requestnamespan><%if("".equals(Util.toScreenToEdit(requestname,user.getLanguage()))){%><img src="/images/BacoError_wev8.gif" align=absmiddle><%}%></span>
        <%}else{%>
       <%=Util.toScreenToEdit(requestname,user.getLanguage())%>
       <input type=hidden temptitle="<%=SystemEnv.getHtmlLabelName(21192,user.getLanguage())%>" name=requestname value="<%=Util.toScreenToEdit(requestname,user.getLanguage())%>">
        <%}%>

        <input type=radio value="0" name="requestlevel" <%if(requestlevel.equals("0")){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(225,user.getLanguage())%>
        <input type=radio value="1" name="requestlevel" <%if(requestlevel.equals("1")){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(15533,user.getLanguage())%>
        <input type=radio value="2" name="requestlevel" <%if(requestlevel.equals("2")){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(2087,user.getLanguage())%>
      </TD>
  </TR>
  <TR>
    <TD class="Line1" colSpan=2></TD>
  </TR>

<%
      if (wfMessageType==1) {
%>
                  <TR>
                    <TD > <%=SystemEnv.getHtmlLabelName(17586,user.getLanguage())%></TD>
                    <td class=field>
                          <span id=messageTypeSpan></span>
                          <input type=radio value="0" name="messageType"   <%if(rqMessageType==0){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(17583,user.getLanguage())%>
                          <input type=radio value="1" name="messageType"   <%if(rqMessageType==1){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(17584,user.getLanguage())%>
                          <input type=radio value="2" name="messageType"   <%if(rqMessageType==2){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(17585,user.getLanguage())%>
                        </td>
                  </TR>
                  <TR><TD class=Line2 colSpan=2></TD></TR>
      <%}%>
<%}else{%>
  <tr>
    <td><%=SystemEnv.getHtmlLabelName(21192,user.getLanguage())%></td>
    <td class=field>
       <%=Util.toScreenToEdit(requestname,user.getLanguage())%>
       <input type=hidden temptitle="<%=SystemEnv.getHtmlLabelName(21192,user.getLanguage())%>" name=requestname value="<%=Util.toScreenToEdit(requestname,user.getLanguage())%>">
       <input type=hidden name=requestlevel value="<%=requestlevel%>">
       <input type=hidden name=messageType value="<%=rqMessageType%>"> 
      &nbsp;&nbsp;&nbsp;&nbsp;
      <%if(requestlevel.equals("0")){%><%=SystemEnv.getHtmlLabelName(225,user.getLanguage())%>
      <%} else if(requestlevel.equals("1")){%><%=SystemEnv.getHtmlLabelName(15533,user.getLanguage())%>
      <%} else if(requestlevel.equals("2")){%><%=SystemEnv.getHtmlLabelName(2087,user.getLanguage())%> <%}%>
      &nbsp;&nbsp;&nbsp;&nbsp;
        <%if(rqMessageType==0){%><%=SystemEnv.getHtmlLabelName(17583,user.getLanguage())%>
        <%} else if(rqMessageType==1){%><%=SystemEnv.getHtmlLabelName(17584,user.getLanguage())%>
        <%} else if(rqMessageType==2){%><%=SystemEnv.getHtmlLabelName(17585,user.getLanguage())%> <%}%>
      </td>
  </tr>  	   	<tr >
    <td class="Line1" colSpan=2></td>
  </tr>
  <!--第一行结束 -->
<%}%>

<%

    int inprepIdTemp=0;
    String inprepfrequenceTemp="";
    String isInputMultiLine="";
    String inprepTableName="";
	String reportDate="";
    RecordSet.executeSql("select inprepId,inprepfrequence,isInputMultiLine,inprepTableName  from T_InputReport where billId="+formid);
    if(RecordSet.next()){
		inprepIdTemp=Util.getIntValue(RecordSet.getString("inprepId"),0);
		inprepfrequenceTemp=Util.null2String(RecordSet.getString("inprepfrequence"));
		isInputMultiLine=Util.null2String(RecordSet.getString("isInputMultiLine"));
		inprepTableName=Util.null2String(RecordSet.getString("inprepTableName"));
    }

	String sqlTemp=null;
	if(isInputMultiLine.equals("1")){
		sqlTemp="select reportDate from "+inprepTableName+"_main"+" where requestId="+requestid;
	}else{
		sqlTemp="select reportDate from "+inprepTableName+" where requestId="+requestid;
	}
    RecordSet.executeSql(sqlTemp);
    if(RecordSet.next()){
		reportDate=Util.null2String(RecordSet.getString("reportDate"));
    }
    Calendar todayTemp = Calendar.getInstance();
    todayTemp.add(Calendar.DATE, -1) ;
    String currentyearTemp = Util.add0(todayTemp.get(Calendar.YEAR), 4) ;
    String yearTemp = "" ;
    String monthTemp = "" ;
    String dayTemp = "" ;
    ArrayList  reportDateList =Util.TokenizerString(reportDate,"-");
    if(reportDateList.size()==3){
    	yearTemp=(String)reportDateList.get(0);
    	monthTemp=(String)reportDateList.get(1);
    	dayTemp=(String)reportDateList.get(2);
    }
    String dateTemp = reportDate ;

	String newReportUserId="";
	String newCrmId="";
    String newCrmIdIsMand="";
boolean DataIsCanModify="true".equals(session.getAttribute(userid+"_"+requestid+"IsCanModify"))?true:false;
boolean editbodydataflag=false;
if((isremark==0||DataIsCanModify) && (!isaffirmancebody.equals("1") || !nodetype.equals("0") || reEditbody.equals("1"))) editbodydataflag=true;
//查询表单或者单据的字段,字段的名称，字段的HTML类型和字段的类型（基于HTML类型的一个扩展）
newdocid =Util.null2String((String)session.getAttribute(userid+"_"+requestid+"newdocid"));
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
int fieldlen=0;  //字段类型长度
ArrayList fieldrealtype=new ArrayList(); 
String fielddbtype="";                              //字段数据类型
String textheight = "4";//xwj for @td2977 20051111

if(isbill.equals("0")) {
    RecordSet.executeSql("select t2.fieldid,t2.fieldorder,t1.fieldlable,t1.langurageid from workflow_fieldlable t1,workflow_formfield t2 where t1.formid=t2.formid and t1.fieldid=t2.fieldid and (t2.isdetail<>'1' or t2.isdetail is null) and   t1.langurageid="+user.getLanguage()+" and t2.formid="+formid+" order by t2.fieldorder");
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
		fieldrealtype.add(Util.null2String(RecordSet.getString("fielddbtype")));
        fieldimgwidths.add(Util.null2String(RecordSet.getString("imgwidth")));
        fieldimgheights.add(Util.null2String(RecordSet.getString("imgheight")));
        fieldimgnums.add(Util.null2String(RecordSet.getString("textheight")));
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

RecordSet.executeProc("workflow_FieldForm_Select", nodeid+"");
while(RecordSet.next()){
    isfieldids.add(Util.null2String(RecordSet.getString("fieldid")));
    isviews.add(Util.null2String(RecordSet.getString("isview")));
    isedits.add(Util.null2String(RecordSet.getString("isedit")));
    ismands.add(Util.null2String(RecordSet.getString("ismandatory")));
}



// 得到每个字段的信息并在页面显示

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
	int fieldimgwidth=0;                            //图片字段宽度
    int fieldimgheight=0;                           //图片字段高度
    int fieldimgnum=0;                              //每行显示图片个数

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
    String fieldname = "" ;                         //字段数据库表中的字段名
    String fieldhtmltype = "" ;                     //字段的页面类型
    String fieldtype = "" ;                         //字段的类型
    String fieldlable = "" ;                        //字段显示名
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
	    String tmpmanagerid = ResourceComInfo.getManagerID(""+userid);
%>
	<input type=hidden name="field<%=fieldid%>" value="<%=tmpmanagerid%>">
<%
	    continue;
	}

	if(fieldname.equals("begindate")) newfromdate="field"+fieldid;      //开始日期,主要为开始日期不大于结束日期进行比较
	if(fieldname.equals("enddate")) newenddate="field"+fieldid;     //结束日期,主要为开始日期不大于结束日期进行比较
	if(fieldname.equals("reportUserId")){ newReportUserId="field"+fieldid;} //
	if(fieldname.equals("crmId")){ 
		newCrmId="field"+fieldid;
		newCrmIdIsMand=ismand;
	}
    if(fieldhtmltype.equals("3") && fieldvalue.equals("0")) fieldvalue = "" ;
    //if(fieldhtmltype.equals("1") && (fieldtype.equals("2") || fieldtype.equals("3")) && Util.getDoubleValue(fieldvalue,0) == 0 ) fieldvalue = "" ;

    if(ismand.equals("1")&&!fieldid.equals(codeField)&&!fieldname.equalsIgnoreCase("inprepDspDate")){
		needcheck+=",field"+fieldid;   //如果必须输入,加入必须输入的检查中
	}

    // 下面开始逐行显示字段

    if(isview.equals("1")){         // 字段需要显示
%>
    <tr>
      <td <%if(fieldhtmltype.equals("2")){%> valign=top <%}%>> <%=Util.toScreen(fieldlable,languageid)%></td>
      <td class=field style="TEXT-VALIGN: center">
      <%
        if(fieldhtmltype.equals("1")){                          // 单行文本框
            if(fieldtype.equals("1")){                          // 单行文本框中的文本
                if(isedit.equals("1") && !fieldid.equals(codeField) && editbodydataflag){
//add by fanggsh 2007-08-16 for TD7025 begin
                  if(fieldname.equalsIgnoreCase("inprepDspDate")){


%>
						<% if(!inprepfrequenceTemp.equals("5") && !inprepfrequenceTemp.equals("0") && !inprepfrequenceTemp.equals("4")) { %>
						<%=SystemEnv.getHtmlLabelName(445,user.getLanguage())%>：<select name="year">
						<%  for(int iTemp=2 ; iTemp>-3;iTemp--) {
								int tempyear = Util.getIntValue(currentyearTemp) - iTemp ;
							    String selected = "" ;
								if( Util.getIntValue(yearTemp,0)==tempyear) selected = "selected" ;
						%>
						<option value="<%=tempyear%>" <%=selected%>><%=tempyear%></option>
						<%}%>
						</select>
						<% if(!inprepfrequenceTemp.equals("1")&&!inprepfrequenceTemp.equals("6")&&!inprepfrequenceTemp.equals("7")) { %>
						<%=SystemEnv.getHtmlLabelName(6076,user.getLanguage())%>：<select name="month">
						<option value="01" <%if(monthTemp.equals("01")) {%>selected<%}%>>1</option>
						<option value="02" <%if(monthTemp.equals("02")) {%>selected<%}%>>2</option>
						<option value="03" <%if(monthTemp.equals("03")) {%>selected<%}%>>3</option>
						<option value="04" <%if(monthTemp.equals("04")) {%>selected<%}%>>4</option>
						<option value="05" <%if(monthTemp.equals("05")) {%>selected<%}%>>5</option>
						<option value="06" <%if(monthTemp.equals("06")) {%>selected<%}%>>6</option>
						<option value="07" <%if(monthTemp.equals("07")) {%>selected<%}%>>7</option>
						<option value="08" <%if(monthTemp.equals("08")) {%>selected<%}%>>8</option>
						<option value="09" <%if(monthTemp.equals("09")) {%>selected<%}%>>9</option>
						<option value="10" <%if(monthTemp.equals("10")) {%>selected<%}%>>10</option>
						<option value="11" <%if(monthTemp.equals("11")) {%>selected<%}%>>11</option>
						<option value="12" <%if(monthTemp.equals("12")) {%>selected<%}%>>12</option>
						</select>
						<%}%>
						<% if(inprepfrequenceTemp.equals("3")) { %>
						<%=SystemEnv.getHtmlLabelName(129384, user.getLanguage())%>：<select name="day">
						<option value="05" <%if(dayTemp.compareTo("10") < 0 ) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(84483, user.getLanguage())%></option>
						<option value="15" <%if(dayTemp.compareTo("10")>=0 && dayTemp.compareTo("20")<0) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(84484, user.getLanguage())%></option>
						<option value="25" <%if(dayTemp.compareTo("20") >=0 ) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(84485, user.getLanguage())%></option>
						</select>
						<%}%>
						<% if(inprepfrequenceTemp.equals("6")) { %>
						<%=SystemEnv.getHtmlLabelName(20729, user.getLanguage())%>：<select name="month">
						<option value="01" <%if(monthTemp.compareTo("07") < 0 ) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(82520, user.getLanguage())%></option>
						<option value="07" <%if(monthTemp.compareTo("07") >=0 ) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(82521, user.getLanguage())%></option>
						</select>
						<%}%>
						<% if(inprepfrequenceTemp.equals("7")) { %>
						<%=SystemEnv.getHtmlLabelName(18280, user.getLanguage())%>：<select name="month">
						<option value="01" <%if(monthTemp.compareTo("04") < 0 ) {%>selected<%}%>><%=SystemEnv.getHtmlLabelNames("27290,17495",user.getLanguage()) %></option>
						<option value="04" <%if(monthTemp.compareTo("04")>=0 && monthTemp.compareTo("07")<0) {%>selected<%}%>><%=SystemEnv.getHtmlLabelNames("27291,17495",user.getLanguage()) %></option>
						<option value="07" <%if(monthTemp.compareTo("07")>=0 && monthTemp.compareTo("10")<0) {%>selected<%}%>><%=SystemEnv.getHtmlLabelNames("27291,17495",user.getLanguage()) %></option>
						<option value="10" <%if(monthTemp.compareTo("10") >=0 ) {%>selected<%}%>><%=SystemEnv.getHtmlLabelNames("27292,17495",user.getLanguage()) %></option>
						</select>
						<%}%>
						<%}  else {%>
						<BUTTON class=Calendar onClick="getDateThis()"></BUTTON> 
						    <SPAN id=datespan style="FONT-SIZE: x-small"><%=dateTemp%></SPAN> 
						    <input type="hidden" name="date" id="date" value="<%=dateTemp%>">
						<%}%>
<%

					}else{
                    if(ismand.equals("1")) {
      %>
        <input datatype="text" type=text class=Inputstyle name="field<%=fieldid%>" size=50 value="<%=Util.toScreenToEdit(fieldvalue,user.getLanguage())%>" <%if(trrigerfield.indexOf("field"+fieldid)>=0){%> onBlur="datainput('field<%=fieldid%>');" <%}%> onChange="checkinput('field<%=fieldid%>','field<%=fieldid%>span');checkLength('field<%=fieldid%>','<%=fieldlen%>','<%=Util.toScreen(fieldlable,languageid)%>','<%=SystemEnv.getHtmlLabelName(20246,user.getLanguage())%>','<%=SystemEnv.getHtmlLabelName(20247,user.getLanguage())%>')">
        <span id="field<%=fieldid%>span"><% if(fieldvalue.equals("")){%><img src="/images/BacoError_wev8.gif" align=absmiddle><%}%></span>
      <%

				    }else{%>
        <input datatype="text" onChange="checkLength('field<%=fieldid%>','<%=fieldlen%>','<%=Util.toScreen(fieldlable,languageid)%>','<%=SystemEnv.getHtmlLabelName(20246,user.getLanguage())%>','<%=SystemEnv.getHtmlLabelName(20247,user.getLanguage())%>')" type=text class=Inputstyle name="field<%=fieldid%>" <%if(trrigerfield.indexOf("field"+fieldid)>=0){%> onBlur="datainput('field<%=fieldid%>');" <%}%> value="<%=Util.toScreenToEdit(fieldvalue,user.getLanguage())%>" size=50>
      <%            }
		          }
			    }
                else {
      %>
        <span id="field<%=fieldid%>span"><%=Util.toScreen(fieldvalue,user.getLanguage())%></span>
         <input type=hidden class=Inputstyle name="field<%=fieldid%>" value="<%=Util.toScreenToEdit(fieldvalue,user.getLanguage())%>" >
      <%
			      if(fieldname.equalsIgnoreCase("inprepDspDate")){
%>
                 <input type=hidden class=Inputstyle name="year" value="<%=yearTemp%>" >
                 <input type=hidden class=Inputstyle name="month" value="<%=monthTemp%>" >
                 <input type=hidden class=Inputstyle name="day" value="<%=dayTemp%>" >
                 <input type=hidden class=Inputstyle name="date" value="<%=dateTemp%>" >
<%
			      }
                }
		    }
		    else if(fieldtype.equals("2")){                     // 单行文本框中的整型
			    if(isedit.equals("1") && editbodydataflag){
				    if(ismand.equals("1")) {
      %>
        <input datatype="int" type=text class=Inputstyle name="field<%=fieldid%>" size=10 value="<%=fieldvalue%>"
		onKeyPress="ItemCount_KeyPress()" <%if(trrigerfield.indexOf("field"+fieldid)>=0){%>  onBlur="checkcount1(this);checkinput('field<%=fieldid%>','field<%=fieldid%>span');datainput('field<%=fieldid%>')" <%}else{%> onBlur="checkcount1(this);checkinput('field<%=fieldid%>','field<%=fieldid%>span')" <%}%>>
        <span id="field<%=fieldid%>span"><% if(fieldvalue.equals("")){%><img src="/images/BacoError_wev8.gif" align=absmiddle><%}%></span>
       <%

				    }else{%>
        <input datatype="int" type=text class=Inputstyle name="field<%=fieldid%>" size=10 value="<%=fieldvalue%>" onKeyPress="ItemCount_KeyPress()"  <%if(trrigerfield.indexOf("field"+fieldid)>=0){%>  onBlur="checkcount1(this);datainput('field<%=fieldid%>')" <%}else{%> onBlur="checkcount1(this)" <%}%>>
       <%           }
			    }
                else {
      %>
        <span id="field<%=fieldid%>span"><%=fieldvalue%></span>
         <input datatype="int" type=hidden class=Inputstyle name="field<%=fieldid%>" value="<%=fieldvalue%>" >
      <%
                }
		    }
		    else if(fieldtype.equals("3")){                     // 单行文本框中的浮点型
			    if(isedit.equals("1") && editbodydataflag){
				    if(ismand.equals("1")) {
       %>
        <input datatype="float" type=text class=Inputstyle name="field<%=fieldid%>" size=10 value="<%=fieldvalue%>"
       onKeyPress="ItemNum_KeyPress()" <%if(trrigerfield.indexOf("field"+fieldid)>=0){%>  onBlur="checknumber1(this);checkinput('field<%=fieldid%>','field<%=fieldid%>span');datainput('field<%=fieldid%>')" <%}else{%> onBlur="checknumber1(this);checkinput('field<%=fieldid%>','field<%=fieldid%>span')" <%}%>>
        <span id="field<%=fieldid%>span"><% if(fieldvalue.equals("")){%><img src="/images/BacoError_wev8.gif" align=absmiddle><%}%></span>
       <%
    				}else{%>
        <input datatype="float" type=text class=Inputstyle name="field<%=fieldid%>" size=10 value="<%=fieldvalue%>" onKeyPress="ItemNum_KeyPress()" <%if(trrigerfield.indexOf("field"+fieldid)>=0){%>  onBlur="checknumber1(this);datainput('field<%=fieldid%>')" <%}else{%> onBlur="checknumber1(this)" <%}%>>
       <%           }
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
            <TABLE cols=2 id="field<%=fieldid%>_tab">
                <tr><td>
                <%
                    if(isedit.equals("1") && editbodydataflag){
                    if(ismand.equals("1")) {%>
                        <input datatype="float" type=text class=Inputstyle name="field_lable<%=fieldid%>" size=60
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
                        <input datatype="float" type=text class=Inputstyle name="field_lable<%=fieldid%>" size=60
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
                    <input datatype="float" type=hidden class=Inputstyle name="field<%=fieldid%>" value="<%=fieldvalue%>" >
                <%}else{%>
                    <span id="field<%=fieldid%>span"></span>
                    <input datatype="float" type=text class=Inputstyle name="field_lable<%=fieldid%>"  disabled="true" size=60>
                    <input datatype="float" type=hidden class=Inputstyle name="field<%=fieldid%>" value="<%=fieldvalue%>" >
                <%}%>
                </td></tr>
                <tr><td>
                    <input type=text class=Inputstyle size=60 name="field_chinglish<%=fieldid%>" readOnly="true">
                </td></tr>
                <script language="javascript">
                    $G("field_lable"+<%=fieldid%>).value  = milfloatFormat(floatFormat(<%=fieldvalue%>));
                    $G("field_chinglish"+<%=fieldid%>).value = numberChangeToChinese(<%=fieldvalue%>);
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
			 }else{
					rscount.executeSql("select * from workflow_billfield where viewtype=0 and id = " + fieldid+" and billid="+formid);
					if(rscount.next()){
						textheight = ""+Util.getIntValue(rscount.getString("textheight"), 4);
					}
				}
			    /*-----xwj for @td2977 20051111 begin-----*/
		    if(isedit.equals("1") && editbodydataflag){
			    if(ismand.equals("1")) {
       %>
        <textarea class=Inputstyle name="field<%=fieldid%>"  <%if(trrigerfield.indexOf("field"+fieldid)>=0){%> onBlur="datainput('field<%=fieldid%>');" <%}%>  onChange="checkinput('field<%=fieldid%>','field<%=fieldid%>span');checkLengthfortext('field<%=fieldid%>','<%=fieldlen%>','<%=Util.toScreen(fieldlable,languageid)%>','<%=SystemEnv.getHtmlLabelName(20246,user.getLanguage())%>','<%=SystemEnv.getHtmlLabelName(20247,user.getLanguage())%>')"
		rows="<%=textheight%>" cols="40" style="width:80%" ><%=Util.toScreenToEdit(fieldvalue,user.getLanguage())%></textarea><!--xwj for @td2977 20051111-->
        <span id="field<%=fieldid%>span"><% if(fieldvalue.equals("")){%><img src="/images/BacoError_wev8.gif" align=absmiddle><%}%></span>
       <%
			    }else{
       %>
        <textarea class=Inputstyle name="field<%=fieldid%>" rows="<%=textheight%>" onchange="checkLengthfortext('field<%=fieldid%>','<%=fieldlen%>','<%=Util.toScreen(fieldlable,languageid)%>','<%=SystemEnv.getHtmlLabelName(20246,user.getLanguage())%>','<%=SystemEnv.getHtmlLabelName(20247,user.getLanguage())%>')" cols="40" <%if(trrigerfield.indexOf("field"+fieldid)>=0){%> onBlur="datainput('field<%=fieldid%>');" <%}%> style="width:80%"><%=Util.toScreenToEdit(fieldvalue,user.getLanguage())%></textarea><!--xwj for @td2977 20051111-->
       <%       }
		    }
            else {
      %>
        <span id="field<%=fieldid%>span"><%=Util.toScreen(fieldvalue,user.getLanguage())%></span>
         <input type=hidden class=Inputstyle name="field<%=fieldid%>" value="<%=Util.toScreenToEdit(fieldvalue,user.getLanguage())%>" >
      <%
            }
	    }                                                           // 多行文本框条件结束
	    else if(fieldhtmltype.equals("3")){                         // 浏览按钮 (涉及workflow_broswerurl表)
            String url=BrowserComInfo.getBrowserurl(fieldtype);     // 浏览按钮弹出页面的url
            String linkurl =BrowserComInfo.getLinkurl(fieldtype);   // 浏览值点击的时候链接的url
            String showname = "";                                                   // 值显示的名称
            String showid = "";                                                     // 值

             String tablename=""; //浏览框对应的表,比如人力资源表
             String columname=""; //浏览框对应的表名称字段
             String keycolumname="";   //浏览框对应的表值字段
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
                }else if(fieldtype.equals("1") ||fieldtype.equals("17")){
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
                }else if(fieldtype.equals("142")){
                    //收发文单位
                    for(int k=0;k<tempshowidlist.size();k++){
                        if(!linkurl.equals("")){
                            showname+="<a href='"+linkurl+tempshowidlist.get(k)+"' target='_new'>"+docReceiveUnitComInfo_mbdc.getReceiveUnitName((String)tempshowidlist.get(k))+"</a>&nbsp";
                        }else{
                        showname+=docReceiveUnitComInfo_mbdc.getReceiveUnitName((String)tempshowidlist.get(k))+" ";
                        }
                    }
                }else if(fieldtype.equals("7") || fieldtype.equals("18")){
                    //客户，多客户
                    for(int k=0;k<tempshowidlist.size();k++){
                        if(!linkurl.equals("")){
                            showname+="<a href='"+linkurl+tempshowidlist.get(k)+"' target='_new'>"+CustomerInfoComInfo.getCustomerInfoname((String)tempshowidlist.get(k))+"</a>&nbsp";
                        }else{
                        showname+=CustomerInfoComInfo.getCustomerInfoname((String)tempshowidlist.get(k))+" ";
                        }
                    }
                }else if(fieldtype.equals("4") || fieldtype.equals("57")){
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

                       showname+="<a href='javascript:createDoc("+fieldid+","+tempDoc+","+isedit+")' >"+DocComInfo1.getDocname((String)tempshowidlist.get(k))+"</a>&nbsp<button id='createdoc' style='display:none' class=AddDoc onclick=createDoc("+fieldid+","+tempDoc+","+isedit+")></button>";

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
                }else if(fieldtype.equals("16") || fieldtype.equals("152")){
                    //相关请求
                    for(int k=0;k<tempshowidlist.size();k++){
                        if(!linkurl.equals("")){
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
					showname+=ResourceConditionManager.getFormShowName(fieldvalue,languageid);
                }
//add by fanggsh for TD4528   20060621 end
                else{
                     tablename=BrowserComInfo.getBrowsertablename(fieldtype); //浏览框对应的表,比如人力资源表
                     columname=BrowserComInfo.getBrowsercolumname(fieldtype); //浏览框对应的表名称字段
                     keycolumname=BrowserComInfo.getBrowserkeycolumname(fieldtype);   //浏览框对应的表值字段

                    //add by wang jinyong
                    HashMap temRes = new HashMap();

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
                        	if("/hrm/resource/HrmResource.jsp?id=".equals(linkurl))
                          	{
                        		showname+="<a href='javaScript:openhrm("+showid+");' onclick='pointerXY(event);'>"+tempshowname+"</a>&nbsp";
                          	}
                        	else 
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
            	showname ="<a href=/meeting/report/MeetingRoomPlan.jsp target=blank>"+SystemEnv.getHtmlLabelName(2193, user.getLanguage())+"</a>" ;
             }
            if(isedit.equals("1") && editbodydataflag){
//add by fanggsh 20060621 for TD4528 begin
               if(fieldtype.equals("160")){
                   rsaddop.execute("select a.level_n, a.level2_n from workflow_groupdetail a ,workflow_nodegroup b where a.groupid=b.id and a.type=50 and a.objid="+fieldid+" and b.nodeid in (select destnodeid from workflow_nodelink where workflowid="+workflowid+" and nodeid="+nodeid+") ");
   				String roleid="";
   				int rolelevel_tmp = 0;
   				if (rsaddop.next())
   				{
   				roleid=rsaddop.getString(1);
   				rolelevel_tmp=Util.getIntValue(rsaddop.getString(2), 0);
   				roleid += "a"+rolelevel_tmp;
   				}
%>
        <button class=Browser  onclick="onShowResourceRole('<%=fieldid%>','<%=url%>','<%=linkurl%>','<%=fieldtype%>','<%=ismand%>','<%=roleid%>')" title="<%=SystemEnv.getHtmlLabelName(20570,user.getLanguage())%>"></button>
<%
			  }
              else if(fieldtype.equals("141")){
%>
        <button class=Browser  onclick="onShowResourceConditionBrowser('<%=fieldid%>','<%=url%>','<%=linkurl%>','<%=fieldtype%>','<%=ismand%>')" title="<%=SystemEnv.getHtmlLabelName(172,user.getLanguage())%>"></button>
<%
			  } else {
//add by fanggsh 20060621 for TD4528 end
//add by fanggsh 2007-08-16 for TD7025 begin
                if(fieldname.equalsIgnoreCase("crmId")){
%>
			  <button class=Browser onClick="onShowCustomerThis('<%=fieldid%>','<%=ismand%>')"></button>
<%
				}else
                if(fieldname.equalsIgnoreCase("reportUserId")){
%>
			  <button class=Browser onClick="onShowReportUserIdThis('<%=fieldid%>','<%=url%>','<%=linkurl%>','<%=fieldtype%>','<%=ismand%>')" title="<%=SystemEnv.getHtmlLabelName(172,user.getLanguage())%>"></button>
<%
				}else
//add by fanggsh 2007-08-16 for TD7025 end 
                if( !fieldtype.equals("37") ) {    //  多文档特殊处理
	   %>
        <button class=Browser <%if(trrigerfield.indexOf("field"+fieldid)>=0){%> onclick="onShowBrowser2('<%=fieldid%>','<%=url%>','<%=linkurl%>','<%=fieldtype%>','<%=ismand%>');datainput('field<%=fieldid%>');"<%}else{%> onclick="onShowBrowser2('<%=fieldid%>','<%=url%>','<%=linkurl%>','<%=fieldtype%>','<%=ismand%>')"<%}%> title="<%=SystemEnv.getHtmlLabelName(172,user.getLanguage())%>"></button>
       <%       } else {                         // 如果是多文档字段,加入新建文档按钮
       %>
        <button class=AddDoc onclick="onShowBrowser2('<%=fieldid%>','<%=url%>','<%=linkurl%>','<%=fieldtype%>','<%=ismand%>')" > <%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></button>&nbsp;&nbsp;<button class=AddDoc onclick="onNewDoc(<%=fieldid%>)" title="<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%>"><%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%></button>
      <%       }
            if (fieldtype.equals("9"))
             {%><span id="createNewDoc"><%if(docFlags.equals("1")&&fieldvalue.equals(""))  ///????????s
           {%>
           <button id="createdoc" class=AddDoc onclick="createDoc('<%=fieldid%>','','1')" title="<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%>"><%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%></button>
           <%}
            }%></span><%
            }
            }
       %>
        <span id="field<%=fieldid%>span"><%=showname%>
       <%
            if( ismand.equals("1") && fieldvalue.equals("")){
       %>
        <img src="/images/BacoError_wev8.gif" align=absmiddle>
       <%
            }
       %>
        </span> <input type=hidden name="field<%=fieldid%>" value="<%=fieldvalue%>">
       <%
	    }                                                       // 浏览按钮条件结束
	    else if(fieldhtmltype.equals("4")) {                    // check框
	   %>
        <input type=checkbox value=1 <%if(isedit.equals("0") || !editbodydataflag){%> DISABLED <%}else{%> name="field<%=fieldid%>" <%}if(trrigerfield.indexOf("field"+fieldid)>=0){%> onChange="datainput('field<%=fieldid%>');" <%}%> <%if(fieldvalue.equals("1")){%> checked <%}%> >
        <%if(isedit.equals("0") || !editbodydataflag){%>
        <input type=hidden class=Inputstyle name="field<%=fieldid%>" value="<%=fieldvalue%>" >
        <%}%>
       <%
        }                                                       // check框条件结束
        else if(fieldhtmltype.equals("5")){                     // 选择框   select
        	//处理select字段联动
         	String onchangeAddStr = "";
        	int childfieldid_tmp = 0;
        	if("0".equals(isbill)){
        		rs_item.execute("select childfieldid from workflow_formdict where id="+fieldid);
        	}else{
        		rs_item.execute("select childfieldid from workflow_billfield where id="+fieldid);
        	}
        	if(rs_item.next()){
	       		childfieldid_tmp = Util.getIntValue(rs_item.getString("childfieldid"), 0);
        	}
        	int firstPfieldid_tmp = 0;
        	boolean hasPfield = false;
        	if("0".equals(isbill)){
        		rs_item.execute("select id from workflow_formdict where childfieldid="+fieldid);
        	}else{
        		rs_item.execute("select id from workflow_billfield where childfieldid="+fieldid);
        	}
        	while(rs_item.next()){
        		firstPfieldid_tmp = Util.getIntValue(rs_item.getString("id"), 0);
        		if(fieldids.contains(""+firstPfieldid_tmp)){
        			hasPfield = true;
        			break;
        		}
        	}
        	if(childfieldid_tmp != 0){//如果先出现子字段，则要把子字段下拉选项清空
				onchangeAddStr = "changeChildField(this, "+fieldid+", "+childfieldid_tmp+")";
			}
	   %>
        <select class=inputstyle  <%if(ismand.equals("1")){%>onBlur="checkinput('field<%=fieldid%>','field<%=fieldid%>span');"<%}%> <%if(isedit.equals("0") || !editbodydataflag){%> name="disfield<%=fieldid%>" DISABLED <%}else{%> name="field<%=fieldid%>" <%}if(trrigerfield.indexOf("field"+fieldid)>=0){%> onChange="datainput('field<%=fieldid%>');<%=onchangeAddStr%>" <%}%>><!--added by xwj for td3313 20051206 -->
	    <option value=""></option><!--added by xwj for td3297 20051130 -->
	   <%
            // 查询选择框的所有可以选择的值
            boolean checkempty = true;//xwj for td3313 20051206
			String finalvalue = "";//xwj for td3313 20051206
			if(hasPfield==false || isedit.equals("0") || !editbodydataflag){
	          rs.executeProc("workflow_SelectItemSelectByid",""+fieldid+flag+isbill);
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
				rs.executeProc("workflow_SelectItemSelectByid",""+fieldid+flag+isbill);
	    		  while(rs.next()){
	                String tmpselectvalue = Util.null2String(rs.getString("selectvalue"));
	                String tmpselectname = Util.toScreen(rs.getString("selectname"),user.getLanguage());
	                 /* -------- xwj for td3313 20051206 begin -*/
	                 if(tmpselectvalue.equals(fieldvalue)){
					 	checkempty = false;
					 	finalvalue = tmpselectvalue;
					 }
	    		  }
	    		  selectInitJsStr += "doInitChildSelect("+fieldid+","+firstPfieldid_tmp+",\""+finalvalue+"\");\n";
	    		  initIframeStr += "<iframe id=\"iframe_"+firstPfieldid_tmp+"_"+fieldid+"_00\" frameborder=0 scrolling=no src=\"\"  style=\"display:none\"></iframe>";
			}
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

        <%if(isedit.equals("0") || !editbodydataflag){%>
        <input type=hidden class=Inputstyle name="field<%=fieldid%>" value="<%=finalvalue%>" >
        <%}%>
       <%
        //add by xhheng @20050310 for 附件上传
        }else if(fieldhtmltype.equals("6")){
        	boolean isfrist=false;
        %>
          <%if( isedit.equals("1") && editbodydataflag){%>
          <!--modify by xhheng @20050511 for 1803-->
          <TABLE cols=3 id="field<%=fieldid%>_tab">
            <TBODY >
            <COL width="50%" >
            <COL width="25%" >
            <COL width="25%">
          <%
          if(!fieldvalue.equals("")) {
			  if("-2".equals(fieldvalue)){%>
			<tr>
				<td colSpan=3><font color="red">
				<%=SystemEnv.getHtmlLabelName(21710,user.getLanguage())%></font>
				</td>
			</tr>
			  <%}else{
            sql="select id,docsubject,accessorycount from docdetail where id in("+fieldvalue+") order by id asc";
            RecordSet.executeSql(sql);
            int linknum=-1;
            //boolean isfrist=false;
            int imgnum=fieldimgnum;
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
                     <table cellspacing="0" cellpadding="0">
                      <tr>
                          <td colspan="2" align="center"><img src="/weaver/weaver.file.FileDownload?fileid=<%=docImagefileid%>&requestid=<%=requestid%>" style="cursor:hand;margin:auto;" alt="<%=docImagefilename%>" <%if(fieldimgwidth>0){%>width="<%=fieldimgwidth%>"<%}%> <%if(fieldimgheight>0){%>height="<%=fieldimgheight%>"<%}%> onclick="addDocReadTag('<%=showid%>');openAccessory('<%=docImagefileid%>')">
                          </td>
                      </tr>
                      <tr>
                              <td align="center"><nobr>
                                  <a href="#" style="text-decoration:underline" onmouseover="this.style.color='blue'" onclick='onChangeSharetype("span<%=fieldid%>_id_<%=linknum%>","field<%=fieldid%>_del_<%=linknum%>","<%=ismand%>",oUpload<%=fieldid%>);return false;'>[<span style="cursor:hand;color:black;"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></span>]</a>
                                    <span id="span<%=fieldid%>_id_<%=linknum%>" name="span<%=fieldid%>_id_<%=linknum%>" style="visibility:hidden"><b><font COLOR="#FF0033">√</font></b><span></td>

                              <td align="center"><nobr>
                                  <a href="#" style="text-decoration:underline" onmouseover="this.style.color='blue'" onclick="addDocReadTag('<%=showid%>');downloads('<%=docImagefileid%>');return false;">[<span  style="cursor:hand;color:black;"><%=SystemEnv.getHtmlLabelName(258,user.getLanguage())%></span>]</a>
                              </td>
                      </tr>
                        </table>
                    </td>
              <%}else{%>

          <tr>
            <INPUT type=hidden name="field<%=fieldid%>_del_<%=linknum%>" value="0" >
            <td >
              <%=imgSrc%>

              <%if(accessoryCount==1 && (Util.isExt(fileExtendName)||fileExtendName.equalsIgnoreCase("pdf"))){%>
                <a  style="cursor:hand" onclick="addDocReadTag('<%=showid%>');opendoc('<%=showid%>','<%=versionId%>','<%=docImagefileid%>')"><%=docImagefilename%></a>&nbsp
              <%}else{%>
                <a style="cursor:hand" onclick="addDocReadTag('<%=showid%>');opendoc1('<%=showid%>')"><%=tempshowname%></a>&nbsp
      
              <%}%>
              <input type=hidden name="field<%=fieldid%>_id_<%=linknum%>" value=<%=showid%>>
            </td>
            <td >
                <BUTTON class=btn accessKey=1  onclick='onChangeSharetype("span<%=fieldid%>_id_<%=linknum%>","field<%=fieldid%>_del_<%=linknum%>","<%=ismand%>",oUpload<%=fieldid%>)'><U><%=linknum%></U>-<%=SystemEnv.getHtmlLabelName(91, user.getLanguage())%>
                  <span id="span<%=fieldid%>_id_<%=linknum%>" name="span<%=fieldid%>_id_<%=linknum%>" style="visibility:hidden">
                    <B><FONT COLOR="#FF0033">√</FONT></B>
                  <span>
                </BUTTON>
            </td>
            <%if(accessoryCount==1){%>
            <td >
              <span id = "selectDownload">
                <%
                  boolean isLocked=SecCategoryComInfo1.isDefaultLockedDoc(Integer.parseInt(showid));
                  //if(!isLocked){
                %>
                  <BUTTON class=btn accessKey=1  onclick="addDocReadTag('<%=showid%>');downloads('<%=docImagefileid%>')">
                    <U><%=linknum%></U>-<%=SystemEnv.getHtmlLabelName(258,user.getLanguage())%>	  (<%=docImagefileSize/1000%>K)
                  </BUTTON>
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
            <td >
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
               //uploadfieldids.add(fieldid);
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
        	//window.attachEvent("onload", fileupload<%=fieldid%>);
        	if (window.addEventListener){
  			    window.addEventListener("load", fileupload<%=fieldid%>, false);
  			}else if (window.attachEvent){
  			    window.attachEvent("onload", fileupload<%=fieldid%>);
  			}else{
  			    window.onload=fileupload<%=fieldid%>;
  			}	
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
          <TABLE cols=3 id="field<%=fieldid%>_tab">
            <TBODY >
            <COL width="50%" >
            <COL width="25%" >
            <COL width="25%">
            <%
            sql="select id,docsubject,accessorycount from docdetail where id in("+fieldvalue+") order by id asc";
            int linknum=-1;
            RecordSet.executeSql(sql);
            int imgnum=fieldimgnum;    
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
                     <table cellspacing="0" cellpadding="0"> 
                      <tr>
                          <td colspan="2" align="center"><img src="/weaver/weaver.file.FileDownload?fileid=<%=docImagefileid%>&requestid=<%=requestid%>" style="cursor:hand;margin:auto;" alt="<%=docImagefilename%>" <%if(fieldimgwidth>0){%>width="<%=fieldimgwidth%>"<%}%> <%if(fieldimgheight>0){%>height="<%=fieldimgheight%>"<%}%> onclick="addDocReadTag('<%=showid%>');openAccessory('<%=docImagefileid%>')">
                          </td>
                      </tr>
                      <tr>
                              <td align="center"><nobr>
                                  <a href="#" style="text-decoration:underline" onmouseover="this.style.color='blue'" onclick='onChangeSharetype("span<%=fieldid%>_id_<%=linknum%>","field<%=fieldid%>_del_<%=linknum%>","<%=ismand%>",oUpload<%=fieldid%>);return false;'>[<span style="cursor:hand;color:black;"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></span>]</a>
                                    <span id="span<%=fieldid%>_id_<%=linknum%>" name="span<%=fieldid%>_id_<%=linknum%>" style="visibility:hidden"><b><font COLOR="#FF0033">√</font></b><span></td>

                              <td align="center"><nobr>
                                  <a href="#" style="text-decoration:underline" onmouseover="this.style.color='blue'" onclick="addDocReadTag('<%=showid%>');downloads('<%=docImagefileid%>');return false;">[<span  style="cursor:hand;color:black;"><%=SystemEnv.getHtmlLabelName(258,user.getLanguage())%></span>]</a>
                              </td>
                      </tr>
                        </table>
                    </td>
              <%}else{%>

          <tr>
            <INPUT type=hidden name="field<%=fieldid%>_del_<%=linknum%>" value="0" >
              <td>
              <%=imgSrc%>
              <%if(accessoryCount==1 && (Util.isExt(fileExtendName)||fileExtendName.equalsIgnoreCase("pdf"))){%>
                <a style="cursor:hand" onclick="addDocReadTag('<%=showid%>');opendoc('<%=showid%>','<%=versionId%>','<%=docImagefileid%>')"><%=docImagefilename%></a>&nbsp
              <%}else{%>
                <a style="cursor:hand" onclick="addDocReadTag('<%=showid%>');opendoc1('<%=showid%>')"><%=tempshowname%></a>&nbsp
              <%}%>
              <input type=hidden name="field<%=fieldid%>_id_<%=linknum%>" value=<%=showid%>> <!--xwj for td2893 20051017-->
              </td>
              <%if(accessoryCount==1){%>
              <td >
                <span id = "selectDownload">
                  <BUTTON class=btn accessKey=1  onclick="addDocReadTag('<%=showid%>');downloads('<%=docImagefileid%>')">
                    <U><%=linknum%></U>-<%=SystemEnv.getHtmlLabelName(258,user.getLanguage())%>	(<%=docImagefileSize/1000%>K)
                  </BUTTON>
                </span>
              </td>
              <%}%>
              <td>&nbsp;</td>
              </tr>
              <%}}
            if(fieldtype.equals("2")&&linknum>-1){%>
            </tr></table></td></tr>
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
    </tr><TR><TD class=Line2 colSpan=2></TD></TR>

<%
    }else {                              // 不显示的作为 hidden 保存信息
        if (fieldhtmltype.equals("6"))
        {   if (!fieldvalue.equals(""))
            {
            ArrayList fieldvalueas=Util.TokenizerString(fieldvalue,",");
           // sql="select id,docsubject,accessorycount from docdetail where id in("+fieldvalue+") order by id asc";
           // RecordSet.executeSql(sql);
            int linknum=-1;
            for(int j=0;j<fieldvalueas.size();j++){
              linknum++;
              String showid = Util.null2String(""+fieldvalueas.get(j)) ;
              %>
            <input type=hidden name="field<%=fieldid%>_id_<%=linknum%>" value=<%=showid%>>

          <%}%><input type=hidden name="field<%=fieldid%>_idnum" value=<%=linknum+1%>>
          <%
          }
          }%>
    <input type=hidden name="field<%=fieldid%>" value="<%=Util.toScreenToEdit(fieldvalue,user.getLanguage())%>" >
<%
   } %>
<%
}       // 循环结束
%>

</table>

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
<input type=hidden name=isremark>
<input type=hidden name ="method">                                <!--新建文档时候 method 为docnew-->
<input type=hidden name ="topage" value="<%=topage%>">				<!--返回的页面-->
<input type=hidden name ="needcheck" value="<%=needcheck%>">
<input type=hidden name ="inputcheck" value="">

<script language="javascript">
function createDoc(fieldbodyid,docVlaue,isedit)
{
	/*
   for(i=0;i<=1;i++){
  		parent.$G("oTDtype_"+i).background="/images/tab2_wev8.png";
  		parent.$G("oTDtype_"+i).className="cycleTD";
  	}
  	parent.$G("oTDtype_1").background="/images/tab.active2_wev8.png";
  	parent.$G("oTDtype_1").className="cycleTDCurrent";
  	*/
  	frmmain.action = "RequestOperation.jsp?docView="+isedit+"&docValue="+docVlaue+"&isFromEditDocument=true";
    frmmain.method.value = "crenew_"+fieldbodyid ;
    if(check_form(document.frmmain,'requestname')){
      
        document.frmmain.src.value='save';
        //附件上传
                        StartUploadAll();
                        checkuploadcomplet();
    }
   

}
function onNewDoc(fieldid) {
    frmmain.action = "RequestOperation.jsp" ;
    frmmain.method.value = "docnew_"+fieldid ;
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

function datainput(parfield){                <!--数据导入-->
      //var xmlhttp=XmlHttp.create();
	  try{
		var src = event.srcElement || event.target; 
		if(src.tagName.toLowerCase() == 'button'){
			return ;
		}
	  }catch(e){}
      var detailsum="0";
      try{
          detailsum=$G("detailsum").value;
      }catch(e){ detailsum="0";}
      var tempdata = "";
      var temprand = $G("rand").value ;
      var StrData="id=<%=workflowid%>&formid=<%=formid%>&bill=<%=isbill%>&node=<%=nodeid%>&detailsum="+detailsum+"&trg="+parfield;
      <%
      if(!trrigerfield.trim().equals("")){
          ArrayList Linfieldname=ddi.GetInFieldName();
          ArrayList Lcondetionfieldname=ddi.GetConditionFieldName();
          for(int i=0;i<Linfieldname.size();i++){
              String temp=(String)Linfieldname.get(i);
      %>
         if($G("<%=temp.substring(temp.indexOf("|")+1)%>")) StrData+="&<%=temp%>="+$G("<%=temp.substring(temp.indexOf("|")+1)%>").value;
      <%
          }
          for(int i=0;i<Lcondetionfieldname.size();i++){
              String temp=(String)Lcondetionfieldname.get(i);
      %>
         if($G("<%=temp.substring(temp.indexOf("|")+1)%>")) StrData+="&<%=temp%>="+$G("<%=temp.substring(temp.indexOf("|")+1)%>").value;
      <%
          }
      }
      %>
      var tempParfieldArr = parfield.split(",");
	  for(var i=0;i<tempParfieldArr.length;i++){
		  	var tempParfield = tempParfieldArr[i];
		  	tempdata += $G(tempParfield).value+"," ;
	  }
	  StrData += "&trgv="+tempdata+"&rand="+temprand+"&tempflag="+Math.random();
      //$G("datainputform").src="DataInputFrom.jsp?"+StrData;
      if($G("datainput_"+parfield)){
		  	$G("datainput_"+parfield).src = "DataInputFrom.jsp?"+StrData;
	  }else{
	  		createIframe("datainput_"+parfield);
	  		$G("datainput_"+parfield).src = "DataInputFrom.jsp?"+StrData;
	  }
      //xmlhttp.open("POST", "DataInputFrom.jsp", false); 
      //xmlhttp.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
      //xmlhttp.send(StrData);
  }
  function addannexRow(accname)
  {
    $G(accname+'_num').value=parseInt($G(accname+'_num').value)+1;
    ncol = $G(accname+'_tab').cols;
    oRow = $G(accname+'_tab').insertRow(-1);
    for(j=0; j<ncol; j++) {
      oCell = oRow.insertCell(-1); 

      switch(j) {
        case 0:
          var oDiv = document.createElement("div");

          var sHtml = "<input class=InputStyle  type=file size=50 name='"+accname+"_"+$G(accname+'_num').value+"' onchange='accesoryChanage(this)'> (<%=SystemEnv.getHtmlLabelName(18976,user.getLanguage())%><%=maxUploadImageSize%><%=SystemEnv.getHtmlLabelName(18977,user.getLanguage())%>) ";
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

 function onChangeSharetype(delspan,delid,ismand,Uploadobj){
	fieldid=delid.substr(0,delid.indexOf("_"));
	fieldidnum=fieldid+"_idnum_1";
	fieldidspan=fieldid+"span";
	fieldidspans=fieldid+"spans";
	fieldid=fieldid+"_1";
	 var sHtml = "<input class=InputStyle  type=file size=50 name="+fieldid+" onchange='accesoryChanage(this)'> (<%=SystemEnv.getHtmlLabelName(18976,user.getLanguage())%><%=maxUploadImageSize%><%=SystemEnv.getHtmlLabelName(18977,user.getLanguage())%>) ";
	 var sHtml1 = "<input class=InputStyle  type=file size=50 name="+fieldid+" onchange=\"accesoryChanage(this);checkinput(\'"+fieldid+"\',\'"+fieldidspan+"\')\"> (<%=SystemEnv.getHtmlLabelName(18976,user.getLanguage())%><%=maxUploadImageSize%><%=SystemEnv.getHtmlLabelName(18977,user.getLanguage())%>) ";
	
    if($G(delspan).style.visibility=='visible'){
      $G(delspan).style.visibility='hidden';
      $G(delid).value='0';
	  $G(fieldidnum).value=parseInt($G(fieldidnum).value)+1;
    }else{
      $G(delspan).style.visibility='visible';
      $G(delid).value='1';
	  $G(fieldidnum).value=parseInt($G(fieldidnum).value)-1;
    }
	//alert($G(fieldidnum).value);
	if (ismand=="1")
	  {
	if ($G(fieldidnum).value=="0")
	  {
	    $G("needcheck").value=$G("needcheck").value+","+fieldid;
        if(Uploadobj.getStats().files_queued==0){
		$G(fieldidspan).innerHTML="<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
        }
		//$G(fieldidspans).innerHTML=sHtml1;
	  }
	  else
	  {   if ($G("needcheck").value.indexOf(","+fieldid)>0)
		  {
	     $G("needcheck").value=$G("needcheck").value.substr(0,$G("needcheck").value.indexOf(","+fieldid));
		 $G(fieldidspan).innerHTML="";
		 //$G(fieldidspans).innerHTML=sHtml;
		  }
	  }
	  }
	  
	  
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
    $G("selectChange").src = "SelectChange.jsp?"+paraStr;
    //alert($G("selectChange").src);
}
function doInitChildSelect(fieldid,pFieldid){
try{
	var pField = $G("field"+pFieldid);
	if(pField != null){
		var pFieldValue = pField.value;
		if(pFieldValue==null || pFieldValue==""){
			return;
		}
		if(pFieldValue!=null && pFieldValue!=""){
			var field = $G("field"+fieldid);
		    var paraStr = "fieldid="+pFieldid+"&childfieldid="+fieldid+"&isbill=<%=isbill%>&isdetail=0&selectvalue="+pFieldValue+"&childvalue="+finalvalue;
			$G("iframe_"+pFieldid+"_"+fieldid+"_00").src = "SelectChange.jsp?"+paraStr;
		}
	}
}catch(e){}
}
<%=selectInitJsStr%>
</script>
<SCRIPT LANGUAGE="VBS">

sub onShowResourceRole(id,url,linkurl,type1,ismand,roleid)
tmpids = $G("field"+id).value
url=url&roleid&"_"+tmpids
//url=url&"&resourceids="&tmpids

id1 = window.showModalDialog(url)
        if NOT isempty(id1) then
          
		   if id1(0)<> ""  and id1(0)<> "0"  then
		    
					resourceids = id1(0)
					resourcename = id1(1)
					sHtml = ""
					resourceids = Mid(resourceids,2,len(resourceids))
					$G("field"+id).value= resourceids
					resourcename = Mid(resourcename,2,len(resourcename))
					while InStr(resourceids,",") <> 0
						curid = Mid(resourceids,1,InStr(resourceids,",")-1)
						curname = Mid(resourcename,1,InStr(resourcename,",")-1)
						resourceids = Mid(resourceids,InStr(resourceids,",")+1,Len(resourceids))
						resourcename = Mid(resourcename,InStr(resourcename,",")+1,Len(resourcename))
						sHtml = sHtml&"<a href="&linkurl&curid&" target='_new'>"&curname&"</a>&nbsp"
					wend
					sHtml = sHtml&"<a href="&linkurl&resourceids&" target='_new'>"&resourcename&"</a>&nbsp"
					$G("field"+id+"span").innerHtml = sHtml

				else
					if ismand=0 then
						$G("field"+id+"span").innerHtml = empty
					else
						$G("field"+id+"span").innerHtml ="<img src='/images/BacoError_wev8.gif' align=absmiddle>"
					end if
					$G("field"+id).value=""
				end if
        end if
end sub

sub onShowBrowser2(id,url,linkurl,type1,ismand)
    if type1=9  and <%=docFlags%>="1" then
    url="/systeminfo/BrowserMain.jsp?url=/docs/docs/DocBrowserWord.jsp"
    end if
	if type1= 2 or type1 = 19 then
		id1 = window.showModalDialog(url,,"dialogHeight:320px;dialogwidth:275px")
		$G("field"+id+"span").innerHtml = id1
		$G("field"+id).value=id1
	else
		if type1<>162 and type1 <> 152 and type1 <> 142 and type1 <> 135 and type1 <> 17 and type1 <> 18 and type1<>27 and type1<>37 and type1<>56 and type1<>57 and type1<>65 and type1<>165 and type1<>166 and type1<>167 and type1<>168 and type1<>4 and type1<>167 and type1<>164 and type1<>169 and type1<>170 then
			id1 = window.showModalDialog(url)
		else
             if type1=135 then
			tmpids = $G("field"+id).value
			id1 = window.showModalDialog(url&"?projectids="&tmpids)
			elseif type1=4 or type1=167 or type1=164 or type1=169 or type1=170 then
            tmpids = $G("field"+id).value
			id1 = window.showModalDialog(url&"?selectedids="&tmpids)
            elseif type1=37 then
            tmpids = $G("field"+id).value
			id1 = window.showModalDialog(url&"?documentids="&tmpids)
            elseif type1=142 then
            tmpids = $G("field"+id).value
			id1 = window.showModalDialog(url&"?receiveUnitIds="&tmpids)
			elseif type1=162 then
			tmpids = $G("field"+id).value
			url = url&"&beanids="&tmpids
			url = Mid(url,1,(InStr(url,"url="))+3) & escape(Mid(url,(InStr(url,"url="))+4,len(url)))
			id1 = window.showModalDialog(url)
            elseif type1=165 or type1=166 or type1=167 or type1=168 then
            index=InStr(id,"_")
            if index>0 then
            tmpids=uescape("?isdetail=1&fieldid="& Mid(id,1,index-1)&"&resourceids="&$G("field"+id).value)
            id1 = window.showModalDialog(url&tmpids)
            else
            tmpids=uescape("?fieldid="&id&"&resourceids="&$G("field"+id).value)
            id1 = window.showModalDialog(url&tmpids)
            end if
            else
			tmpids = $G("field"+id).value
			id1 = window.showModalDialog(url&"?resourceids="&tmpids)
            end if
		end if
		if NOT isempty(id1) then
			if type1 = 152 or type1 = 142 or type1 = 135 or type1 = 17 or type1 = 18 or type1=27 or type1=37 or type1=56 or type1=57 or type1=65 or type1=166 or type1=168 or type1=170 then
				if id1(0)<> ""  and id1(0)<> "0" then
					resourceids = id1(0)
					resourcename = id1(1)
					sHtml = ""
					resourceids = Mid(resourceids,2,len(resourceids))
					$G("field"+id).value= resourceids
					resourcename = Mid(resourcename,2,len(resourcename))
					while InStr(resourceids,",") <> 0
						curid = Mid(resourceids,1,InStr(resourceids,",")-1)
						curname = Mid(resourcename,1,InStr(resourcename,",")-1)
						resourceids = Mid(resourceids,InStr(resourceids,",")+1,Len(resourceids))
						resourcename = Mid(resourcename,InStr(resourcename,",")+1,Len(resourcename))
					if linkurl = "/hrm/resource/HrmResource.jsp?id=" then
							sHtml = sHtml&"<a href=javaScript:openhrm("&curid&"); onclick='pointerXY(event);'>"&curname&"</a>&nbsp"
						else
							sHtml = sHtml&"<a href="&linkurl&curid&" target='_new'>"&curname&"</a>&nbsp"
					end if
						
					wend
						if linkurl = "/hrm/resource/HrmResource.jsp?id=" then
						sHtml = sHtml&"<a href=javaScript:openhrm("&resourceids&"); onclick='pointerXY(event);'>"&resourcename&"</a>&nbsp"
					else
						sHtml = sHtml&"<a href="&linkurl&resourceids&" target='_new'>"&resourcename&"</a>&nbsp"
					end if
					
					$G("field"+id+"span").innerHtml = sHtml

				else
					if ismand=0 then
						$G("field"+id+"span").innerHtml = empty
					else
						$G("field"+id+"span").innerHtml ="<img src='/images/BacoError_wev8.gif' align=absmiddle>"
					end if
					$G("field"+id).value=""
				end if

			else
              
			   if  id1(0)<>""   and id1(0)<> "0"  then
                   
                   if type1=9 and <%=docFlags%>="1" then
                    tempid=id1(0)
                    $G("field"+id+"span").innerHtml = "<a href='#' onclick='createDoc("+id+","+tempid+",1)'>"&id1(1)&"</a><button id='createdoc' style='display:none' class=AddDoc onclick=createDoc("+id+","+tempid+",1)></button>"
                    else
			        if linkurl = "" then
						$G("field"+id+"span").innerHtml = id1(1)
					else
						if linkurl = "/hrm/resource/HrmResource.jsp?id=" then
							$G("field"+id+"span").innerHtml = "<a href=javaScript:openhrm("&id1(0)&"); onclick='pointerXY(event);'>"&id1(1)&"</a>&nbsp"
						else
							$G("field"+id+"span").innerHtml = "<a href="&linkurl&id1(0)&">"&id1(1)&"</a>"
						end if
						
					end if
                    end if
					$G("field"+id).value=id1(0)
                    if (type1=9 and <%=docFlags%>="1") then
                    $G("CreateNewDoc").innerHtml=""
                    end if
				else
					if ismand=0 then
						$G("field"+id+"span").innerHtml = empty
					else
						$G("field"+id+"span").innerHtml ="<img src='/images/BacoError_wev8.gif' align=absmiddle>"
					end if
					$G("field"+id).value=""
  					if (type1=9 and <%=docFlags%>="1") then
                    $G("createNewDoc").innerHtml="<button id='createdoc' class=AddDoc onclick=createDoc("+id+",'','1') title='<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%>'><%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%></button>"
                    end if
				end if
			end if
		end if
	end if

end sub


sub onShowResourceConditionBrowser(id,url,linkurl,type1,ismand)

	tmpids = $G("field"+id).value
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

		$G("field"+id).value= fileIdValue
		$G("field"+id+"span").innerHtml = sHtml
	else	
        if ismand=0 then
                $G("field"+id+"span").innerHtml = empty
        else
                $G("field"+id+"span").innerHtml ="<img src='/images/BacoError_wev8.gif' align=absmiddle>"
        end if
        $G("field"+id).value=""
	end if
	end if

end sub

sub onShowCustomerThis(id,ismand)

    reportUserId=$G("<%=newReportUserId%>").value
	url="/systeminfo/BrowserMain.jsp?url=/datacenter/input/CustomerBrowserForBasicUnit.jsp?reportUserId="&reportUserId&"%26isSecurity=false%26inprepId=<%=inprepIdTemp%>%26isInit=1"
    dialogId = window.showModalDialog(url)

	if NOT isempty(dialogId) then
        if dialogId(0)<> "" then
		    $G("field"+id+"span").innerHtml = dialogId(1)
		    $G("field"+id).value = dialogId(0)
		else
			if ismand=0 then
				$G("field"+id+"span").innerHtml = empty
		        $G("field"+id).value =""
			else
				$G("field"+id+"span").innerHtml ="<img src='/images/BacoError_wev8.gif' align=absmiddle>"
		        $G("field"+id).value =""
			end if
		end if
	end if
end sub

sub onShowReportUserIdThis(id,url,linkurl,type1,ismand)

		id1 = window.showModalDialog(url)

		if NOT isempty(id1) then
		       hisReportUserId=$G("field"+id).value
			   if  hisReportUserId<>id1(0) then
			       $G("<%=newCrmId%>").value=""
				   if <%=newCrmIdIsMand%>=1 then 
			           $G("<%=newCrmId%>span").innerHtml = "<img src='/images/BacoError_wev8.gif' align=absmiddle>"
				   else
			           $G("<%=newCrmId%>span").innerHtml = empty
				   end if
			   end if
			   if  id1(0)<>""  and id1(0)<> "0"  then
                   
			        if linkurl = "" then
						$G("field"+id+"span").innerHtml = id1(1)
					else
						$G("field"+id+"span").innerHtml = "<a href="&linkurl&id1(0)&" target='_new'>"&id1(1)&"</a>"
					end if
					$G("field"+id).value=id1(0)

				else
					if ismand=0 then
						$G("field"+id+"span").innerHtml = empty
					else
						$G("field"+id+"span").innerHtml ="<img src='/images/BacoError_wev8.gif' align=absmiddle>"
					end if
					$G("field"+id).value=""
				end if
		end if
end sub
</script>