
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.workflow.datainput.DynamicDataInput"%>
<%@ page import="weaver.workflow.request.RequestConstants" %>
<jsp:useBean id="WorkflowPhrase" class="weaver.workflow.sysPhrase.WorkflowPhrase" scope="page"/>
<jsp:useBean id="DocUtil" class="weaver.docs.docs.DocUtil" scope="page" />
<jsp:useBean id="rscount" class="weaver.conn.RecordSet" scope="page"/> 
<jsp:useBean id="rsaddop" class="weaver.conn.RecordSet" scope="page"/> 
<jsp:useBean id="RecordSet_nf1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet_nf2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs_item" class="weaver.conn.RecordSet" scope="page" />

<%@ page import="java.util.HashMap" %>
<%@ page import="weaver.system.code.*" %>
<jsp:useBean id="requestPreAddM" class="weaver.workflow.request.RequestPreAddinoperateManager" scope="page" />
<jsp:useBean id="SecCategoryComInfo1" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="ProjectInfoComInfo1" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo1" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="DocComInfo1" class="weaver.docs.docs.DocComInfo" scope="page"/>
<jsp:useBean id="CapitalComInfo1" class="weaver.cpt.capital.CapitalComInfo" scope="page"/>
<jsp:useBean id="WorkflowRequestComInfo1" class="weaver.workflow.workflow.WorkflowRequestComInfo" scope="page"/>
<jsp:useBean id="RequestManager" class="weaver.workflow.request.RequestManager" scope="page"/>
<jsp:useBean id="SpecialField" class="weaver.workflow.field.SpecialFieldInfo" scope="page" />
<%
HashMap specialfield = SpecialField.getFormSpecialField();//特殊字段的字段信息
%>
<!--请求的标题开始 -->

<%
String selectInitJsStr = "";
CodeBuild cbuild = new CodeBuild(Util.getIntValue(formid)); 
String  codeFields=Util.null2String(cbuild.haveCode());
ArrayList flowDocs=flowDoc.getDocFiled(""+workflowid); //得到流程建文挡的发文号字段
String codeField="";
if (flowDocs!=null&&flowDocs.size()>0)
{
codeField=""+flowDocs.get(0);
}	
if (!fromFlowDoc.equals("1")) {%>
<br>
<DIV align="center">
<font style="font-size:14pt;FONT-WEIGHT: bold"><%=Util.toScreen(workflowname,user.getLanguage())%></font>
</DIV>
<title><%=Util.toScreen(workflowname,user.getLanguage())%></title>
<%}%>
<!--请求的标题结束 -->

<!--TD4262 增加提示信息  开始-->
<div id='_xTable' style='background:#FFFFFF;padding-top:3px;width:100%' valign='top'>
</div>
<!--TD4262 增加提示信息  结束-->
<iframe id="selectChange" frameborder=0 scrolling=no src=""  style="display:none"></iframe>
<iframe id="datainputform" frameborder=0 scrolling=no src="javascript:false"  style="display:none"></iframe>
<iframe id="checkReportDataForm" frameborder=0 scrolling=no src="javascript:false"  style="display:none"></iframe>

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
 boolean isCanuse = RequestManager.hasUsedType(wfid);
 if(selectedfieldid.equals("") || selectedfieldid.equals("0")){
 	isCanuse = false;
 }
 String docFlags=(String)session.getAttribute("requestAdd"+user.getUID());
 String isSignDoc_add="";
String isSignWorkflow_add="";
String smsAlertsType="";
RecordSet.execute("select titleFieldId,keywordFieldId,isSignDoc,isSignWorkflow,smsAlertsType from workflow_base where id="+workflowid);
if(RecordSet.next()){
    isSignDoc_add=Util.null2String(RecordSet.getString("isSignDoc"));
    isSignWorkflow_add=Util.null2String(RecordSet.getString("isSignWorkflow"));
	smsAlertsType=Util.null2String(RecordSet.getString("smsAlertsType"));
}
%>
<script language=javascript>

function accesoryChanage(obj){
    var objValue = obj.value;
    if (objValue=="") return ;
    var fileLenth;
    try {
        File.FilePath=objValue;  
        fileLenth= File.getFileSize();  
    } catch (e){
        alert('<%=SystemEnv.getHtmlLabelName(20253,user.getLanguage())%>');
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
<%----- xwj for td3323 20051209 end ------%>


<TABLE class="ViewForm" >
  <COLGROUP>
  <COL width="20%">
  <COL width="80%">

  <!--新建的第一行，包括说明和重要性 -->

  <TR><TD class=Line1 colSpan=2></TD></TR>
  <TR>
    <TD><%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%></TD>
    <TD class=field>
      <!--modify by xhheng @20050318 for TD1689-->
      <%if(defaultName==1){%>
       <%--xwj for td1806 on 2005-05-09--%>
        <input type=text class=Inputstyle  name=requestname onChange="checkinput('requestname','requestnamespan')" size=<%=RequestConstants.RequestName_Size%> maxlength=<%=RequestConstants.RequestName_MaxLength%>  value = "<%=Util.toScreenToEdit( workflowname+"-"+username+"-"+currentdate,user.getLanguage() )%>" >
        <span id=requestnamespan></span>
      <%}else{%>
        <input type=text class=Inputstyle  name=requestname onChange="checkinput('requestname','requestnamespan')" size=<%=RequestConstants.RequestName_Size%> maxlength=<%=RequestConstants.RequestName_MaxLength%>  value = "" >
        <span id=requestnamespan><img src="/images/BacoError_wev8.gif" align=absmiddle></span>
      <%}%>
      <input type=radio value="0" name="requestlevel" checked><%=SystemEnv.getHtmlLabelName(225,user.getLanguage())%>
      <input type=radio value="1" name="requestlevel"><%=SystemEnv.getHtmlLabelName(15533,user.getLanguage())%>
      <input type=radio value="2" name="requestlevel"><%=SystemEnv.getHtmlLabelName(2087,user.getLanguage())%>
    </TD>
  </TR>
<TR><TD class=Line2 colSpan=2></TD></TR>
  <!--第一行结束 -->
  <!--add by xhheng @ 2005/01/24 for 消息提醒 Request06，短信设置行开始 -->
  <%
    if(messageType == 1){
  %>
  <TR>
    <TD > <%=SystemEnv.getHtmlLabelName(17586,user.getLanguage())%></TD>
    <td class=field>
	      <span id=messageTypeSpan></span>
	      <input type=radio value="0" name="messageType" <% if(smsAlertsType.equals("0")) {%> checked<%}%>><%=SystemEnv.getHtmlLabelName(17583,user.getLanguage())%>
	      <input type=radio value="1" name="messageType" <% if(smsAlertsType.equals("1")) {%> checked<%}%>><%=SystemEnv.getHtmlLabelName(17584,user.getLanguage())%>
	      <input type=radio value="2" name="messageType" <% if(smsAlertsType.equals("2")) {%> checked<%}%>><%=SystemEnv.getHtmlLabelName(17585,user.getLanguage())%>
	    </td>
  </TR>  	   	
  <TR><TD class=Line2 colSpan=2></TD></TR>
  <%}%>
  <!--短信设置行结束 -->  

<%

    int inprepIdTemp=0;
    String inprepfrequenceTemp="";
    RecordSet.executeSql("select inprepId,inprepfrequence  from T_InputReport where billId="+formid);
    if(RecordSet.next()){
		inprepIdTemp=Util.getIntValue(RecordSet.getString("inprepId"),0);
		inprepfrequenceTemp=Util.null2String(RecordSet.getString("inprepfrequence"));
    }
	String newReportUserId="";
	String newCrmId="";
    String newCrmIdIsMand="";
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
//获得触发字段名
DynamicDataInput ddi=new DynamicDataInput(workflowid+"");
String trrigerfield=ddi.GetEntryTriggerFieldName();

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

// 得到每个字段的信息并在页面显示

String preAdditionalValue = "";
boolean isSetFlag = false;//xwj for td3308 20051124
for(int i=0;i<fieldids.size();i++){         // 循环开始
 
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
	    String tmpmanagerid = ResourceComInfo.getManagerID(""+userid);
%>
	<input type=hidden name="field<%=fieldbodyid%>" value="<%=tmpmanagerid%>"
<%
	    continue;
	}
    if( ! isbodyview.equals("1") ) { //不显示即进行下一步循环,除了人力资源字段，应该隐藏人力资源字段，因为人力资源字段有可能作为流程下一节点的操作者
        if(fieldbodyhtmltype.equals("3") && (fieldbodytype.equals("1") ||fieldbodytype.equals("17")) && !preAdditionalValue.equals("")){           
           out.println("<input type=hidden name=field"+fieldbodyid+" value="+preAdditionalValue+">");
        }else if(!preAdditionalValue.equals("")){
        	out.println("<input type=hidden name=field"+fieldbodyid+" value="+preAdditionalValue+">");
        }        
        continue ;                  
    }
	if(fieldbodyname.equals("begindate")) newfromdate="field"+fieldbodyid;      //开始日期,主要为开始日期不大于结束日期进行比较
	if(fieldbodyname.equals("enddate")) newenddate="field"+fieldbodyid;     //结束日期,主要为开始日期不大于结束日期进行比较
	if(fieldbodyname.equals("reportUserId")){ newReportUserId="field"+fieldbodyid;} 
	if(fieldbodyname.equals("crmId")){ 
		newCrmId="field"+fieldbodyid;
		newCrmIdIsMand=isbodymand;
	} 


    //if(isbodymand.equals("1")&&!fieldbodyid.equals(codeField)&&!fieldbodyid.equals(codeField))  needcheck+=",field"+fieldbodyid;   //如果必须输入,加入必须输入的检查中(如果是发文号字段，不必输入检查，程序自动生成)
    if(isbodymand.equals("1")&&!fieldbodyid.equals(codeField)&&!fieldbodyname.equalsIgnoreCase("inprepDspDate")){
	    needcheck+=",field"+fieldbodyid;
	}

    // 下面开始逐行显示字段
%>
    <tr>
      <td <%if(fieldbodyhtmltype.equals("2")){%> valign=top <%}%>> <%=Util.toScreen(fieldbodylable,languagebodyid)%> </td>
      <td class=field>
      <%
        if(fieldbodyhtmltype.equals("1")){                          // 单行文本框
            if(fieldbodytype.equals("1")){                          // 单行文本框中的文本
                if(isbodyview.equals("1")){
//add by fanggsh 2007-08-16 for TD7025 begin
                    if(fieldbodyname.equalsIgnoreCase("inprepDspDate")){
						Calendar todayTemp = Calendar.getInstance();
						todayTemp.add(Calendar.DATE, -1) ;
						String currentyearTemp = Util.add0(todayTemp.get(Calendar.YEAR), 4) ;
						String currentmonthTemp = Util.add0(todayTemp.get(Calendar.MONTH) + 1, 2) ;
						String currentdayTemp = Util.add0(todayTemp.get(Calendar.DAY_OF_MONTH), 2) ;
						String currentdateTemp = currentyearTemp + "-" + currentmonthTemp + "-" + currentdayTemp ;

%>
						<% if(!inprepfrequenceTemp.equals("5") && !inprepfrequenceTemp.equals("0") && !inprepfrequenceTemp.equals("4")) { %>
						<%=SystemEnv.getHtmlLabelName(445,user.getLanguage())%>：<select name="year">
						<%  for(int iTemp=2 ; iTemp>-3;iTemp--) {
								int tempyear = Util.getIntValue(currentyearTemp) - iTemp ;
							    String selected = "" ;
								if( iTemp==0) selected = "selected" ;
						%>
						<option value="<%=tempyear%>" <%=selected%>><%=tempyear%></option>
						<%}%>
						</select>
						<% if(!inprepfrequenceTemp.equals("1")&&!inprepfrequenceTemp.equals("6")&&!inprepfrequenceTemp.equals("7")) { %>
						<%=SystemEnv.getHtmlLabelName(6076,user.getLanguage())%>：<select name="month">
						<option value="01" <%if(currentmonthTemp.equals("01")) {%>selected<%}%>>1</option>
						<option value="02" <%if(currentmonthTemp.equals("02")) {%>selected<%}%>>2</option>
						<option value="03" <%if(currentmonthTemp.equals("03")) {%>selected<%}%>>3</option>
						<option value="04" <%if(currentmonthTemp.equals("04")) {%>selected<%}%>>4</option>
						<option value="05" <%if(currentmonthTemp.equals("05")) {%>selected<%}%>>5</option>
						<option value="06" <%if(currentmonthTemp.equals("06")) {%>selected<%}%>>6</option>
						<option value="07" <%if(currentmonthTemp.equals("07")) {%>selected<%}%>>7</option>
						<option value="08" <%if(currentmonthTemp.equals("08")) {%>selected<%}%>>8</option>
						<option value="09" <%if(currentmonthTemp.equals("09")) {%>selected<%}%>>9</option>
						<option value="10" <%if(currentmonthTemp.equals("10")) {%>selected<%}%>>10</option>
						<option value="11" <%if(currentmonthTemp.equals("11")) {%>selected<%}%>>11</option>
						<option value="12" <%if(currentmonthTemp.equals("12")) {%>selected<%}%>>12</option>
						</select>
						<%}%>
						<% if(inprepfrequenceTemp.equals("3")) { %>
						<%=SystemEnv.getHtmlLabelName(129384, user.getLanguage())%>：<select name="day">
						<option value="05" <%if(currentdayTemp.compareTo("10") < 0 ) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(84483, user.getLanguage())%></option>
						<option value="15" <%if(currentdayTemp.compareTo("10")>=0 && currentdayTemp.compareTo("20")<0) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(84484, user.getLanguage())%></option>
						<option value="25" <%if(currentdayTemp.compareTo("20") >=0 ) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(84485, user.getLanguage())%></option>
						</select>
						<%}%>
						<% if(inprepfrequenceTemp.equals("6")) { %>
						<%=SystemEnv.getHtmlLabelName(20729, user.getLanguage())%>：<select name="month">
						<option value="01" <%if(currentmonthTemp.compareTo("07") < 0 ) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(82520, user.getLanguage())%></option>
						<option value="07" <%if(currentmonthTemp.compareTo("07") >=0 ) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(82521, user.getLanguage())%></option>
						</select>
						<%}%>
						<% if(inprepfrequenceTemp.equals("7")) { %>
						<%=SystemEnv.getHtmlLabelName(18280, user.getLanguage())%>：<select name="month">
						<option value="01" <%if(currentmonthTemp.compareTo("04") < 0 ) {%>selected<%}%>><%=SystemEnv.getHtmlLabelNames("27290,17495",user.getLanguage()) %></option>
						<option value="04" <%if(currentmonthTemp.compareTo("04")>=0 && currentmonthTemp.compareTo("07")<0) {%>selected<%}%>><%=SystemEnv.getHtmlLabelNames("27291,17495",user.getLanguage()) %></option>
						<option value="07" <%if(currentmonthTemp.compareTo("07")>=0 && currentmonthTemp.compareTo("10")<0) {%>selected<%}%>><%=SystemEnv.getHtmlLabelNames("27292,17495",user.getLanguage()) %></option>
						<option value="10" <%if(currentmonthTemp.compareTo("10") >=0 ) {%>selected<%}%>><%=SystemEnv.getHtmlLabelNames("27293,17495",user.getLanguage()) %></option>
						</select>
						<%}%>
						<%}  else {%>
						<BUTTON class=Calendar onClick="getDateThis()"></BUTTON> 
						    <SPAN id=datespan style="FONT-SIZE: x-small"><%=currentdateTemp%></SPAN> 
						    <input type="hidden" name="date" id="date" value="<%=currentdateTemp%>">
						<%}%>
<%

					}else{
//add by fanggsh 2007-08-16 for TD7025 end					
                if(isbodyedit.equals("1")&&!fieldbodyid.equals(codeField)&&!fieldbodyid.equals(codeFields)){

                    if(isbodymand.equals("1")) {
      %>
        <input datatype="text" type=text class=Inputstyle name="field<%=fieldbodyid%>" size=50 onChange="checkinput('field<%=fieldbodyid%>','field<%=fieldbodyid%>span');checkLength('field<%=fieldbodyid%>','<%=fieldlen%>','<%=Util.toScreen(fieldbodylable,languagebodyid)%>','<%=SystemEnv.getHtmlLabelName(20246,user.getLanguage())%>','<%=SystemEnv.getHtmlLabelName(20247,user.getLanguage())%>')"<%if(trrigerfield.indexOf("field"+fieldbodyid)>=0){%> onBlur="datainput('field<%=fieldbodyid%>');" <%}%> value="<%=preAdditionalValue%>">
        <span id="field<%=fieldbodyid%>span"><%if("".equals(preAdditionalValue)){%><img src="/images/BacoError_wev8.gif" align=absmiddle><%}%></span><!--modified by xwj for td3130 20051124-->
      <%

				    }else{%>
        <input datatype="text" type=text class=Inputstyle name="field<%=fieldbodyid%>" value="" size=50 onChange="checkLength('field<%=fieldbodyid%>','<%=fieldlen%>','<%=Util.toScreen(fieldbodylable,languagebodyid)%>','<%=SystemEnv.getHtmlLabelName(20246,user.getLanguage())%>','<%=SystemEnv.getHtmlLabelName(20247,user.getLanguage())%>')" <%if(trrigerfield.indexOf("field"+fieldbodyid)>=0){%> onBlur="datainput('field<%=fieldbodyid%>')" <%}%> value="<%=preAdditionalValue%>"><!--modified by xwj for td3130 20051124-->
      <%            }
		    }else{ %>
        <!--input  type=text class=Inputstyle name="field<%=fieldbodyid%>"  size=50 readonly-->
            <span id="field<%=fieldbodyid%>span"><%=preAdditionalValue%></span>
            <input  type=hidden class=Inputstyle name="field<%=fieldbodyid%>"  size=50 value="<%=preAdditionalValue%>"><!--modified by xwj for td3130 20051124-->
      <%          }
				}
            }
            }
		    else if(fieldbodytype.equals("2")){                     // 单行文本框中的整型
                if(isbodyview.equals("1")){
			    if(isbodyedit.equals("1")){
				    if(isbodymand.equals("1")) {
      %>
        <input  datatype="int" type=text class=Inputstyle name="field<%=fieldbodyid%>" size=20
		onKeyPress="ItemCount_KeyPress()" <%if(trrigerfield.indexOf("field"+fieldbodyid)>=0){%>onBlur="checkcount1(this);checkItemScale(this,'<%=SystemEnv.getHtmlLabelName(31181,user.getLanguage()).replace("12","9")%>',-999999999,999999999);checkinput('field<%=fieldbodyid%>','field<%=fieldbodyid%>span');datainput('field<%=fieldbodyid%>')" <%}else{%> onBlur="checkcount1(this);checkItemScale(this,'<%=SystemEnv.getHtmlLabelName(31181,user.getLanguage()).replace("12","9")%>',-999999999,999999999);checkinput('field<%=fieldbodyid%>','field<%=fieldbodyid%>span')" <%}%> value="<%=preAdditionalValue%>">
        <span id="field<%=fieldbodyid%>span"><%if("".equals(preAdditionalValue)){%><img src="/images/BacoError_wev8.gif" align=absmiddle><%}%></span><!--modified by xwj for td3130 20051124-->
       <%

				    }else{%>
        <input  datatype="int" type=text class=Inputstyle name="field<%=fieldbodyid%>" size=20 onKeyPress="ItemCount_KeyPress()" <%if(trrigerfield.indexOf("field"+fieldbodyid)>=0){%>onBlur="checkcount1(this);checkItemScale(this,'<%=SystemEnv.getHtmlLabelName(31181,user.getLanguage()).replace("12","9")%>',-999999999,999999999);datainput('field<%=fieldbodyid%>')" <%}else{%> onBlur="checkcount1(this);checkItemScale(this,'<%=SystemEnv.getHtmlLabelName(31181,user.getLanguage()).replace("12","9")%>',-999999999,999999999);" <%}%> value="<%=preAdditionalValue%>"> <!--modified by xwj for td3130 20051124-->
       <%           }
			    }else{  %>
         <!--input datatype="int" type=text class=Inputstyle name="field<%=fieldbodyid%>" size=20 readonly-->
         <span id="field<%=fieldbodyid%>span"><%=preAdditionalValue%></span>
         <input datatype="int" type=hidden class=Inputstyle name="field<%=fieldbodyid%>" value="<%=preAdditionalValue%>"><!--modified by xwj for td3130 20051124-->
        <%        }
            }
            }
		    else if(fieldbodytype.equals("3")){                     // 单行文本框中的浮点型
                if(isbodyview.equals("1")){
			    if(isbodyedit.equals("1")){
				    if(isbodymand.equals("1")) {
       %>
        <input datatype="float" type=text class=Inputstyle name="field<%=fieldbodyid%>" size=20
		onKeyPress="ItemNum_KeyPress()" <%if(trrigerfield.indexOf("field"+fieldbodyid)>=0){%>onBlur="checkFloat(this);checkinput('field<%=fieldbodyid%>','field<%=fieldbodyid%>span');datainput('field<%=fieldbodyid%>')" <%}else{%> onBlur="checkFloat(this);checkinput('field<%=fieldbodyid%>','field<%=fieldbodyid%>span')"<%}%> value="<%=preAdditionalValue%>">
        <span id="field<%=fieldbodyid%>span"><%if("".equals(preAdditionalValue)){%><img src="/images/BacoError_wev8.gif" align=absmiddle><%}%></span><!--modified by xwj for td3130 20051124-->
       <%
    				}else{%>
        <input datatype="float" type=text class=Inputstyle name="field<%=fieldbodyid%>" size=20 onKeyPress="ItemNum_KeyPress()"  <%if(trrigerfield.indexOf("field"+fieldbodyid)>=0){%>onBlur="checkFloat(this);datainput('field<%=fieldbodyid%>')" <%}else{%> onBlur="checkFloat(this)"<%}%> value="<%=preAdditionalValue%>"><!--modified by xwj for td3130 20051124-->
       <%           }
               }else{  %>
         <!--input datatype="float" type=text class=Inputstyle name="field<%=fieldbodyid%>"  size=20 readonly-->
         <span id="field<%=fieldbodyid%>span"><%=preAdditionalValue%></span>
         <input datatype="float" type=hidden class=Inputstyle name="field<%=fieldbodyid%>" value="<%=preAdditionalValue%>"><!--modified by xwj for td3130 20051124-->
        <%        }
		    }
	    }
	     /*-----------xwj for td3131 20051115 begin ----------*/
	    else if(fieldbodytype.equals("4")){%>
            <TABLE cols=2 id="field<%=fieldbodyid%>_tab">
            <tr><td>
                <%if(isbodyview.equals("1")){
                    if(isbodyedit.equals("1")){%>
                        <input datatype="float" type=text class=Inputstyle name="field_lable<%=fieldbodyid%>" size=60 
                            onfocus="FormatToNumber('<%=fieldbodyid%>')" 
                            onKeyPress="ItemNum_KeyPress('field_lable<%=fieldbodyid%>')"                             
                            <%if(trrigerfield.indexOf("field"+fieldbodyid)>=0){%>
                                onBlur="checkFloat(this);numberToFormat('<%=fieldbodyid%>') 
                                datainput('field_lable<%=fieldbodyid%>') 
                                <%if(isbodymand.equals("1")){%>
                                    checkinput('field_lable<%=fieldbodyid%>','field_lable<%=fieldbodyid%>span')
                                <%}%>"
                            <%}else{%>
                                onBlur="checkFloat(this);numberToFormat('<%=fieldbodyid%>') 
                                <%if(isbodymand.equals("1")){%>
                                    checkinput('field_lable<%=fieldbodyid%>','field_lable<%=fieldbodyid%>span')
                                <%}%>"
                            <%}%>
                        >
                        <span id="field_lable<%=fieldbodyid%>span"><%if("".equals(preAdditionalValue)&&isbodymand.equals("1")){%><img src="/images/BacoError_wev8.gif" align=absmiddle><%}%></span><!--modified by xwj for td3130 20051124-->
                        <span id="field<%=fieldbodyid%>span"></span>
                        <input datatype="float" type=hidden class=Inputstyle name="field<%=fieldbodyid%>" value="">
                    <%}else{%>
                        <span id="field<%=fieldbodyid%>span"></span>
                        <input datatype="float" type=text class=Inputstyle name="field_lable<%=fieldbodyid%>" disabled="true">
                        <input datatype="float" type=hidden class=Inputstyle name="field<%=fieldbodyid%>" value="">
                    <%}
                }
                if(!"".equals(preAdditionalValue)){%>
                    <script language="javascript">
                        $G("field_lable"+<%=fieldbodyid%>).value  = numberChangeToChinese(<%=preAdditionalValue%>);
                        $G("field"+<%=fieldbodyid%>).value  = <%=preAdditionalValue%>;
                    </script>
                <%}%>
            </td></tr>
            <tr><td>
                <input type=text class=Inputstyle size=60 name="field_chinglish<%=fieldbodyid%>" readOnly="true">
            </td></tr>
            </table>
	    <%}
	    /*-----------xwj for td3131 20051115 end ----------*/
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
        <textarea class=Inputstyle name="field<%=fieldbodyid%>" <%if(trrigerfield.indexOf("field"+fieldbodyid)>=0){%> onBlur="datainput('field<%=fieldbodyid%>');" <%}%> onChange="checkinput('field<%=fieldbodyid%>','field<%=fieldbodyid%>span');checkLengthfortext('field<%=fieldbodyid%>','<%=fieldlen%>','<%=Util.toScreen(fieldbodylable,languagebodyid)%>','<%=SystemEnv.getHtmlLabelName(20246,user.getLanguage())%>','<%=SystemEnv.getHtmlLabelName(20247,user.getLanguage())%>')"
		rows="<%=textheight%>" cols="40" style="width:80%" class=Inputstyle ><%=preAdditionalValue%></textarea><!--xwj for @td2977 20051111-->
        <span id="field<%=fieldbodyid%>span"><%if("".equals(preAdditionalValue)){%><img src="/images/BacoError_wev8.gif" align=absmiddle><%}%></span><!--modified by xwj for td3130 20051124-->
       <%
			    }else{
       %>
        <textarea class=Inputstyle onchange="checkLengthfortext('field<%=fieldbodyid%>','<%=fieldlen%>','<%=Util.toScreen(fieldbodylable,languagebodyid)%>','<%=SystemEnv.getHtmlLabelName(20246,user.getLanguage())%>','<%=SystemEnv.getHtmlLabelName(20247,user.getLanguage())%>')" name="field<%=fieldbodyid%>" <%if(trrigerfield.indexOf("field"+fieldbodyid)>=0){%> onBlur="datainput('field<%=fieldbodyid%>');" <%}%> rows="<%=textheight%>" cols="40" style="width:80%"><%=preAdditionalValue%></textarea><!--xwj for @td2977 20051111--><!--modified by xwj for td3130 20051124-->
       <%       }
            }else{  %>
                <span id="field<%=fieldbodyid%>span"><%=preAdditionalValue%></span>
                <input type=hidden class=Inputstyle name="field<%=fieldbodyid%>" value="<%=preAdditionalValue%>"><!--modified by xwj for td3130 20051124-->
         <!--textarea  class=Inputstyle name="field<%=fieldbodyid%>" rows="4" cols="40" style="width:80%"  readonly></textarea-->
        <%        }
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
            }else if((fieldbodytype.equals("1") ||fieldbodytype.equals("17")) && !hrmid.equals("")){ //浏览按钮为人,从前面的参数中获得人默认值
                showid = "" + Util.getIntValue(hrmid,0);
            }else if((fieldbodytype.equals("7") || fieldbodytype.equals("18")) && !crmid.equals("")){ //浏览按钮为CRM,从前面的参数中获得CRM默认值
                showid = "" + Util.getIntValue(crmid,0);
            }else if((fieldbodytype.equals("16") || fieldbodytype.equals("152")) && !reqid.equals("")){ //浏览按钮为REQ,从前面的参数中获得REQ默认值
                showid = "" + Util.getIntValue(reqid,0);
            }else if(fieldbodytype.equals("4") && !hrmid.equals("")){ //浏览按钮为部门,从前面的参数中获得人默认值(由人力资源的部门得到部门默认值)
                showid = "" + Util.getIntValue(ResourceComInfo.getDepartmentID(hrmid),0);
            }else if(fieldbodytype.equals("24") && !hrmid.equals("")){ //浏览按钮为职务,从前面的参数中获得人默认值(由人力资源的职务得到职务默认值)
                showid = "" + Util.getIntValue(ResourceComInfo.getJobTitle(hrmid),0);
            }else if(fieldbodytype.equals("32") && !hrmid.equals("")){ //浏览按钮为职务,从前面的参数中获得人默认值(由人力资源的职务得到职务默认值)
                showid = "" + Util.getIntValue(request.getParameter("TrainPlanId"),0);
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
                            showname+="<a href='"+linkurl+tempshowidlist.get(k)+"' target='_new'>"+ProjectInfoComInfo1.getProjectInfoname((String)tempshowidlist.get(k))+"</a>&nbsp";
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
                            showname+="<a href='"+linkurl+tempshowidlist.get(k)+"' target='_new'>"+ResourceComInfo.getResourcename((String)tempshowidlist.get(k))+"</a>&nbsp";
                        }else{
                        showname+=ResourceComInfo.getResourcename((String)tempshowidlist.get(k))+" ";
                        }
                    }
                }else if(fieldbodytype.equals("7") || fieldbodytype.equals("18")){
                    //客户，多客户
                    for(int k=0;k<tempshowidlist.size();k++){
                        if(!linkurl.equals("")){
                            showname+="<a href='"+linkurl+tempshowidlist.get(k)+"' target='_new'>"+CustomerInfoComInfo.getCustomerInfoname((String)tempshowidlist.get(k))+"</a>&nbsp";
                        }else{
                        showname+=CustomerInfoComInfo.getCustomerInfoname((String)tempshowidlist.get(k))+" ";
                        }
                    }
                }else if(fieldbodytype.equals("4") || fieldbodytype.equals("57")){
                    //部门，多部门
                    for(int k=0;k<tempshowidlist.size();k++){
                        if(!linkurl.equals("")){
                            showname+="<a href='"+linkurl+tempshowidlist.get(k)+"' target='_new'>"+DepartmentComInfo1.getDepartmentname((String)tempshowidlist.get(k))+"</a>&nbsp";
                        }else{
                        showname+=DepartmentComInfo1.getDepartmentname((String)tempshowidlist.get(k))+" ";
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
                            showname+="<a href='"+linkurl+tempshowidlist.get(k)+"' target='_new'>"+DocComInfo1.getDocname((String)tempshowidlist.get(k))+"</a>&nbsp";
                        }else{
                        showname+=DocComInfo1.getDocname((String)tempshowidlist.get(k))+" ";
                        }
                        }
                    }
                }else if(fieldbodytype.equals("23")){
                    //资产
                    for(int k=0;k<tempshowidlist.size();k++){
                        if(!linkurl.equals("")){
                            showname+="<a href='"+linkurl+tempshowidlist.get(k)+"' target='_new'>"+CapitalComInfo1.getCapitalname((String)tempshowidlist.get(k))+"</a>&nbsp";
                        }else{
                        showname+=CapitalComInfo1.getCapitalname((String)tempshowidlist.get(k))+" ";
                        }
                    }
                }else if(fieldbodytype.equals("16") || fieldbodytype.equals("152")){
                    //相关请求
                    for(int k=0;k<tempshowidlist.size();k++){
                        if(!linkurl.equals("")){
                            showname+="<a href='"+linkurl+tempshowidlist.get(k)+"' target='_new'>"+WorkflowRequestComInfo1.getRequestName((String)tempshowidlist.get(k))+"</a>&nbsp";
                        }else{
                        showname+=WorkflowRequestComInfo1.getRequestName((String)tempshowidlist.get(k))+" ";
                        }
                    }
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
	                            showname += "<a href='"+linkurl+showid+"' target='_new'>"+RecordSet.getString(1)+"</a>&nbsp";
	                        else
	                            showname +=RecordSet.getString(1) ;
	                    }
                    }
                }
            }

           //deleted by xwj for td3130 20051124

		    if(isbodyedit.equals("1")){
//add  by ben delweath rolepersone

              if(fieldbodytype.equals("160")){
                  rsaddop.execute("select a.level_n, a.level2_n from workflow_groupdetail a ,workflow_nodegroup b where a.groupid=b.id and a.type=50 and a.objid="+fieldbodyid+" and b.nodeid in (select destnodeid from workflow_nodelink where workflowid="+workflowid+" and nodeid="+nodeid+") ");
  				String roleid="";
  				int rolelevel_tmp = 0;
  				if (rsaddop.next())
  				{
  				roleid=rsaddop.getString(1);
  				rolelevel_tmp=Util.getIntValue(rsaddop.getString(2), 0);
  				roleid += "a"+rolelevel_tmp;
  				}
%>
        <button class=Browser  onclick="onShowResourceRole('<%=fieldbodyid%>','<%=url%>','<%=linkurl%>','<%=fieldbodytype%>','<%=isbodymand%>','<%=roleid%>')" title="<%=SystemEnv.getHtmlLabelName(20570,user.getLanguage())%>"></button>
<%
			  }
              else if(fieldbodytype.equals("141")){
%>
        <button class=Browser  onclick="onShowResourceConditionBrowser('<%=fieldbodyid%>','<%=url%>','<%=linkurl%>','<%=fieldbodytype%>','<%=isbodymand%>')" title="<%=SystemEnv.getHtmlLabelName(172,user.getLanguage())%>"></button>
<%
			  } else
//add by fanggsh 20060621 for TD4528 end
//add by fanggsh 2007-08-16 for TD7025 begin
                if(fieldbodyname.equalsIgnoreCase("crmId")){
%>
			  <button class=Browser onClick="onShowCustomerThis('<%=fieldbodyid%>','<%=isbodymand%>')" title="<%=SystemEnv.getHtmlLabelName(172,user.getLanguage())%>"></button>
<%
				}else
                if(fieldbodyname.equalsIgnoreCase("reportUserId")){
%>
			  <button class=Browser onClick="onShowReportUserIdThis('<%=fieldbodyid%>','<%=url%>','<%=linkurl%>','<%=fieldbodytype%>','<%=isbodymand%>')" title="<%=SystemEnv.getHtmlLabelName(172,user.getLanguage())%>"></button>
<%
				}else
//add by fanggsh 2007-08-16 for TD7025 end 
                if( !fieldbodytype.equals("37") ) {
					session.setAttribute("relaterequest","new");
					//  多文档特殊处理
	   %>
        <button class=Browser <%if(trrigerfield.indexOf("field"+fieldbodyid)>=0){%>onclick="onShowBrowser2('<%=fieldbodyid%>','<%=url%>','<%=linkurl%>','<%=fieldbodytype%>','<%=isbodymand%>');datainput('field<%=fieldbodyid%>');"<%}else{%> onclick="onShowBrowser2('<%=fieldbodyid%>','<%=url%>','<%=linkurl%>','<%=fieldbodytype%>','<%=isbodymand%>')"<%}%> title="<%=SystemEnv.getHtmlLabelName(172,user.getLanguage())%>"></button>
       <%       } else {                         // 如果是多文档字段,加入新建文档按钮
       %>
        <button class=AddDoc onclick="onShowBrowser2('<%=fieldbodyid%>','<%=url%>','<%=linkurl%>','<%=fieldbodytype%>','<%=isbodymand%>')" > <%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></button>&nbsp;&nbsp<button class=AddDoc onclick="onNewDoc(<%=fieldbodyid%>)" title="<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%>"><%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%></button>
       <%       }
           if (fieldbodytype.equals("9")&&docFlags.equals("1"))  ///是否有流程建文档s
           {%>
           <span id="CreateNewDoc"><button id="createdoc" class=AddDoc onclick="createDoc('<%=fieldbodyid%>','')" title="<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%>"><%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%></button>
           </span>
           <%}     
            }
       %>
      
        <input type=hidden name="field<%=fieldbodyid%>" value="<%=showid%>" <%if(trrigerfield.indexOf("field"+fieldbodyid)>=0){%> onChange="datainput('field<%=fieldbodyid%>');" <%}%>>
        <span id="field<%=fieldbodyid%>span"><%=Util.toScreen(showname,user.getLanguage())%>
       <%   if(isbodymand.equals("1") && showname.equals("")) {
       %>
           <img src="/images/BacoError_wev8.gif" align=absmiddle>
       <%
            }
       %>
        </span>
       <%
	    }                                                       // 浏览按钮条件结束
	    else if(fieldbodyhtmltype.equals("4")) {                  // check框
	   %>
        <input type=checkbox <%if("".equals(preAdditionalValue)){%>value=1<%}else{%>value=<%=preAdditionalValue%><%}%>  name="field<%=fieldbodyid%>" <%if(isbodyedit.equals("0")){%> DISABLED <%}%> <%if(trrigerfield.indexOf("field"+fieldbodyid)>=0){%> onChange="datainput('field<%=fieldbodyid%>');" <%}%>><!--modified by xwj for td3130 20051124-->
       <%
        }                                                       // check框条件结束
        else if(fieldbodyhtmltype.equals("5")){                     // 选择框   select
        	//处理select字段联动
         	String onchangeAddStr = "";
        	if("0".equals(isbill)){
        		rs_item.execute("select childfieldid from workflow_formdict where id="+fieldbodyid);
        	}else{
        		rs_item.execute("select childfieldid from workflow_billfield where id="+fieldbodyid);
        	}
        	int childfieldid_tmp = 0;
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
        <select class=inputstyle  <%if(isbodyedit.equals("0")){%>name="disfield<%=fieldbodyid%>"  DISABLED <%}else{%>name="field<%=fieldbodyid%>" <%}%> <%if(isbodymand.equals("1")){%>onBlur="checkinput('field<%=fieldbodyid%>','field<%=fieldbodyid%>span');"<%}%> <%if(trrigerfield.indexOf("field"+fieldbodyid)>=0){%> onChange="datainput('field<%=fieldbodyid%>');<%=onchangeAddStr%>" <%}%>><!--added by xwj for td3313 20051206 -->
	    <option value=""></option><!--added by xwj for td3297 20051130 -->
	   <%
            // 查询选择框的所有可以选择的值
       //char flag= Util.getSeparator() ;
	   boolean checkempty = true;//xwj for td3313 20051206
	   String finalvalue = "";//xwj for td3313 20051206
	   if(hasPfield==false || isbodyedit.equals("0")){
            rs.executeProc("workflow_SelectItemSelectByid",""+fieldbodyid+Util.getSeparator()+isbill);
            while(rs.next()){
                String tmpselectvalue = Util.null2String(rs.getString("selectvalue"));
                String tmpselectname = Util.toScreen(rs.getString("selectname"),user.getLanguage());
                String isdefault = Util.toScreen(rs.getString("isdefault"),user.getLanguage());//xwj for td2977 20051107
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
           //char flag= Util.getSeparator();
           rs.executeProc("workflow_SelectItemSelectByid",""+fieldbodyid+Util.getSeparator()+isbill);
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
       <IMG src='/images/BacoError_wev8.gif' align=absMiddle>
      <%
            }
       %>
	     </span>
	    <%if(isbodyedit.equals("0")){%>
        <input type=hidden class=Inputstyle name="field<%=fieldbodyid%>" value="<%=finalvalue%>" >
      <%}%>
	    <!--xwj for td3313 20051206 end-->
       <%
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
          
       
      %>
        <TABLE cols=2 id="field<%=fieldbodyid%>_tab">
          <TBODY >
          <tr>
            <!--modify by xhheng @20050512 for TD1803-->
            <td >
            <%if(uploadType == 0){if("".equals(mainId) && "".equals(subId) && "".equals(secId)){%>
           <font color="red"> <%=SystemEnv.getHtmlLabelName(17616,user.getLanguage())+SystemEnv.getHtmlLabelName(92,user.getLanguage())+SystemEnv.getHtmlLabelName(15808,user.getLanguage())%>!</font>
           <%}}else if(!isCanuse){%>
           <font color="red"> <%=SystemEnv.getHtmlLabelName(17616,user.getLanguage())+SystemEnv.getHtmlLabelName(92,user.getLanguage())+SystemEnv.getHtmlLabelName(15808,user.getLanguage())%>!</font>
           <%}%>
              <input   <%if(uploadType == 0){if("".equals(mainId) && "".equals(subId) && "".equals(secId)){%>disabled="true"<%}}else if(!isCanuse){%>disabled="true"<%}%> class=InputStyle  type=file size=60 name="field<%=fieldbodyid%>_1" onchange="accesoryChanage(this);checkinput('field<%=fieldbodyid%>_1','field<%=fieldbodyid%>span')">(<%=SystemEnv.getHtmlLabelName(18976,user.getLanguage())%><%=maxUploadImageSize%><%=SystemEnv.getHtmlLabelName(18977,user.getLanguage())%>)<%----- xwj for td3323 20051209 begin ------%>
			  <span id="field<%=fieldbodyid%>span">
				<%
				 if(isbodymand.equals("1")){
				needcheck+=",field"+fieldbodyid+"_1"; 
				%>
			   <IMG src='/images/BacoError_wev8.gif' align=absMiddle>
			  <%
					}
			   %>
	     </span>
            </td>
            <td >
              <button  <%if(uploadType == 0){if("".equals(mainId) && "".equals(subId) && "".equals(secId)){%>disabled="true"<%}}else if(!isCanuse){%>disabled="true"<%}%> class=AddDoc name="addacc_1" onclick="addannexRow('field<%=fieldbodyid%>')"><%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></button>
            </td>
          </tr>
          <TR>
            <TD class=Line2 colSpan=4></TD>
          </TR>
          </tbody>
          </table>
          <input type=hidden name='field<%=fieldbodyid%>_num' value="1">
          <input type=hidden name='mainId' value=<%=mainId%>>
          <input type=hidden name='subId' value=<%=subId%>>
          <input type=hidden name='secId' value=<%=secId%>>
          </div>
      <%
       }                                          // 选择框条件结束 所有条件判定结束
       else if(fieldbodyhtmltype.equals("7")){//特殊字段
           if(isbill.equals("0")) out.println(Util.null2String((String)specialfield.get(fieldbodyid+"_0")));
           else out.println(Util.null2String((String)specialfield.get(fieldbodyid+"_1")));
       }
       %>
      </td>
    </tr>
	 <TR><TD class=Line2 colSpan=2></TD></TR>
<%
    }       // 循环结束
%>

    <tr class="Title">
      <td colspan=2 align="center" valign="middle"><font style="font-size:14pt;FONT-WEIGHT: bold"><%=SystemEnv.getHtmlLabelName(17614,user.getLanguage())%></font></td>
    </tr>
    <tr>
      <td><%=SystemEnv.getHtmlLabelName(504,user.getLanguage())%></td>
      <td class=field>
      <!-- modify by xhheng @20050308 for TD 1692 -->
         <%
         //String workflowPhrases[] = WorkflowPhrase.getUserWorkflowPhrase(""+userid);
        //add by cyril on 2008-09-30 for td:9014
  		boolean isSuccess  = RecordSet.executeProc("sysPhrase_selectByHrmId",""+userid); 
  		String workflowPhrases[] = new String[RecordSet.getCounts()];
  		String workflowPhrasesContent[] = new String[RecordSet.getCounts()];
  		int m = 0 ;
  		if (isSuccess) {
  			while (RecordSet.next()){
  				workflowPhrases[m] = Util.null2String(RecordSet.getString("phraseShort"));
  				workflowPhrasesContent[m] = Util.toHtml(Util.null2String(RecordSet.getString("phrasedesc")));
  				m ++ ;
  			}
  		}
  		//end by cyril on 2008-09-30 for td:9014
         if(workflowPhrases.length>0){
         %>

                <select class=inputstyle  id="phraseselect" name=phraseselect style="width:80%" onChange='onAddPhrase(this.value)'>
                <option value="">－－<%=SystemEnv.getHtmlLabelName(22409,user.getLanguage())%>－－</option>
                <%
                  for (int i= 0 ; i <workflowPhrases.length;i++) {
                    String workflowPhrase = workflowPhrases[i] ;  %>
                    <option value="<%=workflowPhrasesContent[i]%>"><%=workflowPhrase%></option>
                <%}%>
                </select>

          <%}%>
				<input type="hidden" id="remarkText10404" name="remarkText10404" temptitle="<%=SystemEnv.getHtmlLabelName(504,user.getLanguage())%>" value="">
              <textarea class=Inputstyle name=remark id=remark rows=4 cols=40 style="width=80%;display:none" temptitle="<%=SystemEnv.getHtmlLabelName(504,user.getLanguage())%>" class=Inputstyle></textarea>
	  		   	<script>
	  		   	function funcremark_log(){
					FCKEditorExt.initEditor("frmmain","remark",<%=user.getLanguage()%>,FCKEditorExt.NO_IMAGE);
					FCKEditorExt.toolbarExpand(false,"remark");
				}
	  		  	//if(ieVersion>=8) window.attachEvent("onload", funcremark_log());
	  		  	//else  window.attachEvent("onload", funcremark_log);
	  		  	
	  		  	if (window.addEventListener){
	  			    window.addEventListener("load", funcremark_log, false);
	  			}else if (window.attachEvent){
	  			    if(ieVersion>=8) window.attachEvent("onload", funcremark_log());
	  		  		else window.attachEvent("onload", funcremark_log);
	  			}else{
	  			    window.onload=funcremark_log;
	  			}	
				</script>

       </td>
    </tr>
	 <TR><TD class=Line2 colSpan=2></TD></TR>
     <%
         if("1".equals(isSignDoc_add)){
         %>
          <tr>
            <td><%=SystemEnv.getHtmlLabelName(857,user.getLanguage())%></td>
            <td class=field>
                <input type="hidden" id="signdocids" name="signdocids">
                <button class=Browser onclick="onShowSignBrowser('/docs/docs/MutiDocBrowser.jsp','/docs/docs/DocDsp.jsp?isrequest=1&id=','signdocids','signdocspan',37)" title="<%=SystemEnv.getHtmlLabelName(857,user.getLanguage())%>"></button>
                <span id="signdocspan"></span>
            </td>
          </tr>
          <tr><td class=Line2 colSpan=2></td></tr>
         <%}%>
     <%
         if("1".equals(isSignWorkflow_add)){
         %>
          <tr>
            <td><%=SystemEnv.getHtmlLabelName(1044,user.getLanguage())%></td>
            <td class=field>
                <input type="hidden" id="signworkflowids" name="signworkflowids">
                <button class=Browser onclick="onShowSignBrowser('/workflow/request/MultiRequestBrowser.jsp','/workflow/request/ViewRequest.jsp?isrequest=1&requestid=','signworkflowids','signworkflowspan',152)" title="<%=SystemEnv.getHtmlLabelName(1044,user.getLanguage())%>"></button>
                <span id="signworkflowspan"></span>
            </td>
          </tr>
          <tr><td class=Line2 colSpan=2></td></tr>
         <%}%>
     <%
         String isannexupload_add=(String)session.getAttribute(userid+"_"+workflowid+"isannexupload");
         if("1".equals(isannexupload_add)){
            int annexmainId=0;
             int annexsubId=0;
             int annexsecId=0;
             String annexdocCategory_add=(String)session.getAttribute(userid+"_"+workflowid+"annexdocCategory");
             if("1".equals(isannexupload_add) && annexdocCategory_add!=null && !annexdocCategory_add.equals("")){
                annexmainId=Util.getIntValue(annexdocCategory_add.substring(0,annexdocCategory_add.indexOf(',')));
                annexsubId=Util.getIntValue(annexdocCategory_add.substring(annexdocCategory_add.indexOf(',')+1,annexdocCategory_add.lastIndexOf(',')));
                annexsecId=Util.getIntValue(annexdocCategory_add.substring(annexdocCategory_add.lastIndexOf(',')+1));
              }
             int annexmaxUploadImageSize=Util.getIntValue(SecCategoryComInfo1.getMaxUploadFileSize(""+annexsecId),5);
             if(annexmaxUploadImageSize<=0){
                annexmaxUploadImageSize = 5;
             }
         %>
          <tr>
            <td><%=SystemEnv.getHtmlLabelName(22194,user.getLanguage())%></td>
            <td class=field>
          <%if(annexsecId<1){%>
           <font color="red"> <%=SystemEnv.getHtmlLabelName(21418,user.getLanguage())+SystemEnv.getHtmlLabelName(15808,user.getLanguage())%>!</font>
           <%}else{%>
            <script>
          var oUploadannexupload;
          function fileuploadannexupload() {
        var settings = {
            flash_url : "/js/swfupload/swfupload.swf",
            upload_url: "/docs/docupload/MultiDocUploadByWorkflow.jsp",    // Relative to the SWF file
            post_params: {
                "mainId":"<%=annexmainId%>",
                "subId":"<%=annexsubId%>",
                "secId":"<%=annexsecId%>",
                "userid":"<%=user.getUID()%>",
                "logintype":"<%=user.getLogintype()%>"
            },
            file_size_limit :"<%=annexmaxUploadImageSize%> MB",
            file_types : "*.*",
            file_types_description : "All Files",
            file_upload_limit : 100,
            file_queue_limit : 0,
            custom_settings : {
                progressTarget : "fsUploadProgressannexupload",
                cancelButtonId : "btnCancelannexupload",
                uploadfiedid:"field-annexupload"
            },
            debug: false,


            // Button settings

            button_image_url : "/js/swfupload/add_wev8.png",    // Relative to the SWF file
            button_placeholder_id : "spanButtonPlaceHolderannexupload",

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
            file_dialog_complete_handler : fileDialogComplete_2,
            upload_start_handler : uploadStart,
            upload_progress_handler : uploadProgress,
            upload_error_handler : uploadError,
            upload_success_handler : uploadSuccess_1,
            upload_complete_handler : uploadComplete_1,
            queue_complete_handler : queueComplete    // Queue plugin event
        };


        try {
            oUploadannexupload=new SWFUpload(settings);
        } catch(e) {
            alert(e)
        }
    }
        	//window.attachEvent("onload", fileuploadannexupload);
        	if (window.addEventListener){
  			    window.addEventListener("load", fileuploadannexupload, false);
  			}else if (window.attachEvent){
  			    window.attachEvent("onload", fileuploadannexupload);
  			}else{
  			    window.onload=fileuploadannexupload;
  			}	
        </script>
      <TABLE class="ViewForm">
          <tr>
              <td colspan="2">
                  <div>
                      <span>
                      <span id="spanButtonPlaceHolderannexupload"></span><!--选取多个文件-->
                      </span>
                      &nbsp;&nbsp;
								<span style="color:#262626;cursor:hand;TEXT-DECORATION:none" disabled onclick="oUploadannexupload.cancelQueue();" id="btnCancelannexupload">
									<span><img src="/js/swfupload/delete_wev8.gif" border="0"></span>
									<span style="height:19px"><font style="margin:0 0 0 -1"><%=SystemEnv.getHtmlLabelName(21407,user.getLanguage())%></font><!--清除所有选择--></span>
								</span><span>(<%=SystemEnv.getHtmlLabelName(18976,user.getLanguage())%><%=annexmaxUploadImageSize%><%=SystemEnv.getHtmlLabelName(18977,user.getLanguage())%>)</span>
                  </div>
                  <input  class=InputStyle  type=hidden size=60 name="field-annexupload" >
              </td>
          </tr>
          <tr>
              <td colspan="2">
                  <div class="fieldset flash" id="fsUploadProgressannexupload">
                  </div>
                  <div id="divStatusannexupload"></div>
              </td>
          </tr>
      </TABLE>
              <input type=hidden name='annexmainId' value=<%=annexmainId%>>
              <input type=hidden name='annexsubId' value=<%=annexsubId%>>
              <input type=hidden name='annexsecId' value=<%=annexsecId%>>
          </td>
          </tr>
          <tr><td class=Line2 colSpan=2></td></tr>
         <%}}%>
  </table>
<input type=hidden name ="needcheck" value="<%=needcheck%>">
<input type=hidden name ="inputcheck" value="">
<%
//add by mackjoe at 2006-06-07 td4491 有明细时才加载
boolean  hasdetailb=false;
if(isbill.equals("0")) {
    RecordSet.executeSql("select count(*) from workflow_formfield  where isdetail='1' and formid="+formid);
}else{
    RecordSet.executeSql("select count(*) from workflow_billfield  where viewtype=1 and billid="+formid);
}
if(RecordSet.next()){
    if(RecordSet.getInt(1)>0) hasdetailb=true;
}

if(hasdetailb){
%>
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
<%}%>
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

<script language=javascript>

function createDoc(fieldbodyid,docVlaue)
{
   /*
   for(i=0;i<=1;i++){
  		parent.$G("oTDtype_"+i).background="/images/tab2_wev8.png";
  		parent.$G("oTDtype_"+i).className="cycleTD";
  	}
  	parent.$G("oTDtype_1").background="/images/tab.active2_wev8.png";
  	parent.$G("oTDtype_1").className="cycleTDCurrent";
  	*/
  	frmmain.action = "RequestOperation.jsp?docView=1&docValue="+docVlaue;
    frmmain.method.value = "crenew_"+fieldbodyid ;
    if(check_form(document.frmmain,'requestname')){
      
        document.frmmain.src.value='save';
        //附件上传
                        StartUploadAll();
                        checkuploadcomplet();
    }
   

}
function onNewDoc(fieldbodyid) {
   
    frmmain.action = "RequestOperation.jsp" ;
    frmmain.method.value = "docnew_"+fieldbodyid ;
    if(check_form(document.frmmain,'requestname')){
      
        document.frmmain.src.value='save';
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

    function checkReportData(src){
		var reportUserId=$G("<%=newReportUserId%>").value;
		var crmId=$G("<%=newCrmId%>").value;
		var year="";
		var month="";
		var day="";
		var date="";
		if($G("year")!=null){
			year=$G("year").value;
		}
		if($G("month")!=null){
			month=$G("month").value;
		}
		if($G("day")!=null){
			day=$G("day").value;
		}
		if($G("date")!=null){
			date=$G("date").value;
		}
		StrData="formid=<%=formid%>&reportUserId="+reportUserId+"&crmId="+crmId+"&year="+year+"&month="+month+"&day="+day+"&date="+date+"&src="+src;
		$G("checkReportDataForm").src="checkReportDataForm.jsp?"+StrData;
		//return false;
	}

    function checkReportDataReturn(ret,thedate,dspdate,src){

		if(ret==1||ret==2){
			alert(dspdate+" "+"<%=SystemEnv.getHtmlLabelName(20775,user.getLanguage())%>");
			return false;
		}
		if(src=="save"){
                    document.frmmain.src.value='save';
                    jQuery($GetEle("flowbody")).attr("onbeforeunload", "");

		           var content="<%=SystemEnv.getHtmlLabelName(18979,user.getLanguage())%>";
		           showPrompt(content);
                    //附件上传
                        StartUploadAll();
                        checkuploadcomplet();
		}else if(src=="submit"){
                document.frmmain.src.value='submit';
                jQuery($GetEle("flowbody")).attr("onbeforeunload", "");

		       var content="<%=SystemEnv.getHtmlLabelName(18978,user.getLanguage())%>";
		       showPrompt(content);

                //附件上传
                        StartUploadAll();
                        checkuploadcomplet();
				if(objSubmit!=""){
					objSubmit.disabled=true;
				}
                
		}else if(src=="Affirmance"){
                document.frmmain.src.value='save';
                jQuery($GetEle("flowbody")).attr("onbeforeunload", "")//added by xwj for td3425 20051231
				var content="<%=SystemEnv.getHtmlLabelName(18979,user.getLanguage())%>";
				showPrompt(content);
                //TD4262 增加提示信息  结束
                document.frmmain.topage.value="ViewRequest.jsp?isaffirmance=1&reEdit=0&fromFlowDoc=1";
                //附件上传
                        StartUploadAll();
                        checkuploadcomplet();
				if(objSubmit!=""){
					objSubmit.disabled=true;
				}                
		}
	}

    function doSave(){              <!-- 点击保存按钮 -->
        var ischeckok="";
        try{
        if(check_form(document.frmmain,$G("needcheck").value+$G("inputcheck").value))
          ischeckok="true";
        }catch(e){
          ischeckok="false";
        }
        if(ischeckok=="false"){
            if(check_form(document.frmmain,'<%=needcheck%>'))
                ischeckok="true";
        }
        if(ischeckok=="true"){
            if(checktimeok()&&checkReportData("save")) {
                    //document.frmmain.src.value='save';
                    //flowbody.onbeforeunload=null;//added by xwj for td3247 20051201

                   ////TD4262 增加提示信息  开始
		           //var content="<%=SystemEnv.getHtmlLabelName(18979,user.getLanguage())%>";
		           //showPrompt(content);
                   ////TD4262 增加提示信息  结束

                    //document.frmmain.submit();
                }
            }
    }

    function doSubmit(obj){            <!-- 点击提交 -->
      //modify by xhheng @20050328 for TD 1703
      //明细部必填check，通过try $G("needcheck")来检查,避免对原有无明细单据的修改
	   
        var ischeckok="";
        try{
        if(check_form(document.frmmain,$G("needcheck").value+$G("inputcheck").value))
          ischeckok="true";
        }catch(e){
          ischeckok="false";
        }
        if(ischeckok=="false"){
          if(check_form(document.frmmain,'<%=needcheck%>'))
            ischeckok="true";
        }
        if(ischeckok=="true"){
			objSubmit=obj;
            if(checktimeok()&&checkReportData("submit")) {
                //document.frmmain.src.value='submit';
                //// xwj for td2104 on 20050802
                ////$G("remark").value += "\n<%=username%> <%=currentdate%> <%=currenttime%>" ;
                //flowbody.onbeforeunload=null;//added by xwj for td3247 20051201

               ////TD4262 增加提示信息  开始
		      // var content="<%=SystemEnv.getHtmlLabelName(18978,user.getLanguage())%>";
		       //showPrompt(content);
               ////TD4262 增加提示信息  结束

                //document.frmmain.submit();
                //obj.disabled=true;
            }
        }
    }
	function onAddPhrase(phrase){            <!-- 添加常用短语 -->
    if(phrase!=null && phrase!=""){
		try{
			$G("remarkSpan").innerHTML = "";
		}catch(e){}
		try{
			var remarkHtml = FCKEditorExt.getHtml("remark");
			var remarkText = FCKEditorExt.getText("remark");
			if(remarkText==null || remarkText==""){
				FCKEditorExt.setHtml(phrase,"remark");
			}else{
				FCKEditorExt.setHtml(remarkHtml+"<p>"+phrase+"</p>","remark");
			}
		}catch(e){}
    }
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
    if($G("field_lable"+index).value != ""){
        $G("field_lable"+index).value = $G("field"+index).value;
    }else{
        $G("field"+index).value = "";
        $G("field_chinglish"+index).value = "";
    }
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
if($G("field_lable"+index).value != ""){
$G("field_lable"+index).value = chineseChangeToNumber($G("field_lable"+index).value);
$G("field"+index).value = $G("field_lable"+index).value;
}
else{
$G("field"+index).value = "";
}
}

  setTimeout("doTriggerInit()",1000);
  function doTriggerInit(){
      var tempS = "<%=trrigerfield%>";
      var tempA = tempS.split(",");
      for(var i=0;i<tempA.length;i++){
          datainput(tempA[i]);
      }
  }
  function datainput(parfield){                <!--数据导入-->
      //var xmlhttp=XmlHttp.create();
	  try{
			var src = event.srcElement || event.target; 
			if(src.tagName.toLowerCase() == 'button'){
				return ;
			}
	  }catch(e){}
      var tempdata = "";
      var temprand = $G("rand").value ;
      var StrData="id=<%=workflowid%>&formid=<%=formid%>&bill=<%=isbill%>&node=<%=nodeid%>&detailsum=<%=detailsum%>&trg="+parfield;
      <%
      if(!trrigerfield.trim().equals("")){
          ArrayList Linfieldname=ddi.GetInFieldName();
          ArrayList Lcondetionfieldname=ddi.GetConditionFieldName();
          for(int i=0;i<Linfieldname.size();i++){
              String temp=(String)Linfieldname.get(i);
      %>
        if($G("<%=temp.substring(temp.indexOf("|")+1)%>"))   StrData+="&<%=temp%>="+$G("<%=temp.substring(temp.indexOf("|")+1)%>").value;
      <%
          }
          for(int i=0;i<Lcondetionfieldname.size();i++){
              String temp=(String)Lcondetionfieldname.get(i);
      %>
         if($G("<%=temp.substring(temp.indexOf("|")+1)%>"))  StrData+="&<%=temp%>="+$G("<%=temp.substring(temp.indexOf("|")+1)%>").value;
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
      oCell.style.height=24;
      switch(j) {
        case 1:
          var oDiv = document.createElement("div");
          var sHtml = "";
          oDiv.innerHTML = sHtml;
          oCell.appendChild(oDiv);
          break;
        case 0:
          var oDiv = document.createElement("div");
          <%----- Modified by xwj for td3323 20051209  ------%>
          var sHtml = "<input class=InputStyle  type=file size=60 name='"+accname+"_"+$G(accname+'_num').value+"' onchange='accesoryChanage(this)'> (<%=SystemEnv.getHtmlLabelName(18976,user.getLanguage())%><%=maxUploadImageSize%><%=SystemEnv.getHtmlLabelName(18977,user.getLanguage())%>) ";
          oDiv.innerHTML = sHtml;
          oCell.appendChild(oDiv);
          break;
      }
    }
  }

//TD4262 增加提示信息  开始
//提示窗口
function showPrompt(content)
{

     var showTableDiv  = $G('_xTable');
     var message_table_Div = document.createElement("div")
     message_table_Div.id="message_table_Div";
     message_table_Div.className="xTable_message";
     showTableDiv.appendChild(message_table_Div);
     var message_table_Div  = $G("message_table_Div");
     message_table_Div.style.display="inline";
     message_table_Div.innerHTML=content;
     var pTop= document.body.offsetHeight/2+document.body.scrollTop-50;
     var pLeft= document.body.offsetWidth/2-50;
     message_table_Div.style.position="absolute"
     message_table_Div.style.top=pTop;
     message_table_Div.style.left=pLeft;

     message_table_Div.style.zIndex=1002;
     var oIframe = document.createElement('iframe');
     oIframe.id = 'HelpFrame';
     showTableDiv.appendChild(oIframe);
     oIframe.frameborder = 0;
     oIframe.style.position = 'absolute';
     oIframe.style.top = pTop;
     oIframe.style.left = pLeft;
     oIframe.style.zIndex = message_table_Div.style.zIndex - 1;
     oIframe.style.width = parseInt(message_table_Div.offsetWidth);
     oIframe.style.height = parseInt(message_table_Div.offsetHeight);
     oIframe.style.display = 'block';
}
//TD4262 增加提示信息  结束
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
    $G("selectChange").src = "SelectChange.jsp?"+paraStr;
    //alert($G("selectChange").src);
}
function doInitChildSelect(fieldid,pFieldid,finalvalue){
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
				var frm = document.createElement("iframe");
				frm.id = "iframe_"+pFieldid+"_"+fieldid+"_00";
				frm.style.display = "none";
			    document.body.appendChild(frm);
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
        if NOT isempty(id1) then
            if id1<>"" then
                $G("field"+id+"span").innerHtml = id1
                $G("field"+id).value=id1
            else
                if ismand=0 then
                    $G("field"+id+"span").innerHtml = empty
                else
                    $G("field"+id+"span").innerHtml ="<img src='/images/BacoError_wev8.gif' align=absmiddle>"
                end if
                $G("field"+id).value=""
            end if
        end if
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
			if  type1 = 152 or type1 = 142 or type1 = 135 or type1 = 17 or type1 = 18 or type1=27 or type1=37 or type1=56 or type1=57 or type1=65 or type1=166 or type1=168 or type1=170 then
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
			   if  id1(0)<>""  and id1(0)<> "0"  then
                   
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
							$G("field"+id+"span").innerHtml = "<a href="&linkurl&id1(0)&" target='_new'>"&id1(1)&"</a>"
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


sub getDateThis()
	returndate = window.showModalDialog("/systeminfo/Calendar.jsp",,"dialogHeight:320px;dialogwidth:275px")
	if returndate <> "" then
		$G("date").value= returndate
		datespan.innerHtml = returndate
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