

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ page import="weaver.hrm.HrmUserVarify"%>
<%@ page import="weaver.hrm.User"%>
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page"/>
<jsp:useBean id="BrowserManager" class="weaver.general.browserData.BrowserManager" scope="page"/>
<jsp:useBean id="FieldInfo" class="weaver.workflow.mode.FieldInfo" scope="page"/>

<%
  User user = HrmUserVarify.getUser (request , response) ;
  if(user == null) {
      response.sendRedirect("/login/Login.jsp");
      return;
  }

  String workflowid = ""+Util.getIntValue(request.getParameter("workflowid"));
  String customid = Util.null2String(request.getParameter("customid"));
  String isfrom = Util.null2String(request.getParameter("isfrom"));
  boolean issimple = Util.null2String(request.getParameter("issimple")).equals("true")?true:false;

  /*内部类：用于存储自定义查询*/
  class CustomQuery{
    private String customQueryId;
    private String customQueryName;

    public CustomQuery(String id, String name){
      this.customQueryId = id;
      this.customQueryName = name;
    }

    public void setCustomQueryId(String id){
      customQueryId = id;
    }

    public String getCustomQueryId(){
      return this.customQueryId;

    }

    public void setCustomQueryName(String name){
      customQueryName = name;
    }

    public String getCustomQueryName(){
      return this.customQueryName;
    }
  }

  String defaultCustomQueryId = customid;
  String isbill       = "0";
  String formID       = "0";
  if(!customid.equals("")){
      RecordSet.execute("select * from workflow_custom where id="+customid);
      if(RecordSet.next()){
          isbill = Util.null2String(RecordSet.getString("isbill"));
          formID = Util.null2String(RecordSet.getString("formid"));
          workflowid = "";
      }
  }else{
      isbill = WorkflowComInfo.getIsBill(workflowid);
      formID = WorkflowComInfo.getFormId(workflowid);
  }

  /*获取符合条件的全部自定查询*/
  RecordSet.execute("select id,customName from workflow_custom where isbill='"+isbill+"'and formid="+formID);

  /*全部符合条件的自定义查询*/
  List<CustomQuery> customQueryList = new ArrayList<CustomQuery>();
  while(RecordSet.next()){
    CustomQuery cq = new CustomQuery(RecordSet.getString("id"), RecordSet.getString("customName"));
    customQueryList.add(cq);
  }

  /*如果针对流程没有定义任何自定义查询，则直接返回*/
  if(customQueryList.size() == 0) return;

  /*如果没有指定自定义查询编号，则默认显示第一个自定义查询*/
  if( customid.equals("") && customQueryList.size() > 0 ){
      defaultCustomQueryId = customQueryList.get(0).getCustomQueryId();
  }else{
    defaultCustomQueryId = customid;
  } 

%>

<wea:layout type="fourCol" attributes="{'expandAllGroup':'true'}">
  <wea:group context='<%=SystemEnv.getHtmlLabelName(84557,user.getLanguage())%>' attributes="{'class':'e8_title e8_title_1'}">

  <wea:item type="groupHead">
  <span class="noHide">
    <input id='customid' name='customid' type='hidden' value='<%=defaultCustomQueryId%>'/>
    <select id="cutomQuerySelect">
      <%
        for(int i = 0; i < customQueryList.size(); i++){
          CustomQuery cq = customQueryList.get(i);
          String selected = "";
          if(cq.getCustomQueryId().equals(defaultCustomQueryId)){
            selected = "selected";
          }

      %>
        <option value="<%=cq.getCustomQueryId()%>" <%=selected%> ><%=cq.getCustomQueryName()%></option> 
      <%}%>
    </select>
    </span>
   </wea:item>

<%//以下开始列出自定义查询条件
String sql = "";
if(isbill.equals("0")){
  sql = "select * from (select wcf.queryorder ,wcf.showorder ,wcf.fieldid as id,fieldname as name,wfl.fieldlable as label,wfd.fielddbtype as dbtype, wfd.fieldhtmltype as httype,wfd.type as type from Workflow_CustomDspField wcf,Workflow_Custom wc, workflow_formdict wfd,workflow_fieldlable wfl,workflow_formfield wff where wff.formid=wc.formid and wff.fieldid=wfl.fieldid and  wcf.customid=wc.id and wc.id="+defaultCustomQueryId+" and wc.isbill='0' and wcf.ifquery='1' and wfl.formid = wc.formid and wfl.isdefault = 1 and wfl.fieldid =wcf.fieldid and wfd.id = wcf.fieldid ";
}else if(isbill.equals("1")){
    if(RecordSet.getDBType().equals("oracle")){
	    sql = "select * from (select wcf.queryorder ,wcf.showorder ,wbf.id as id,wbf.fieldname as name,(select labelname from htmllabelinfo where indexid = wbf.fieldlabel and languageid=7) as label,wbf.fielddbtype as dbtype ,wbf.fieldhtmltype as httype, wbf.type as type from workflow_billfield wbf,Workflow_CustomDspField wcf,Workflow_Custom wc where wcf.customid=wc.id and wc.id="+defaultCustomQueryId+" and wc.isbill='1'  and wcf.ifquery='1' and wbf.billid=wc.formid and wbf.id=wcf.fieldid ";
    }else{
      sql = "select * from (select wcf.queryorder ,wcf.showorder ,wbf.id as id,wbf.fieldname as name,(select labelname from htmllabelinfo where indexid = wbf.fieldlabel and languageid=7) as label,wbf.fielddbtype as dbtype ,wbf.fieldhtmltype as httype, wbf.type as type from workflow_billfield wbf,Workflow_CustomDspField wcf,Workflow_Custom wc where wcf.customid=wc.id and wc.id="+defaultCustomQueryId+" and wc.isbill='1'  and wcf.ifquery='1' and wbf.billid=wc.formid and wbf.id=wcf.fieldid ";
    }
}

sql += " union select queryorder,showorder,fieldid as id,'' as name,'' as label,'' as dbtype,'' as httype,0 as type from Workflow_CustomDspField where ifquery='1' and fieldid in(-1,-2,-3,-4,-5,-6,-7,-8,-9) and customid="+defaultCustomQueryId;
sql+=") a order by a.queryorder,a.showorder,a.id";

RecordSet.execute(sql);
for (int tmpcount = 0; RecordSet.next(); tmpcount++)
{
    //tmpcount++;
    String name = RecordSet.getString("name");
    String label = RecordSet.getString("label");
    String htmltype = RecordSet.getString("httype");
    String type = RecordSet.getString("type");
    String id = RecordSet.getString("id");
    String dbtype = Util.null2String(RecordSet.getString("dbtype"));

    //下面功能用于不处理系统默认字段，如需支持系统字段，请删除if代码块

    if(id.equals("-1") || id.equals("-2")
      || id.equals("-3") || id.equals("-4")
      || id.equals("-5") || id.equals("-6")
      || id.equals("-7") || id.equals("-8")
      || id.equals("-9") || id.equals("-10")){
      continue;
    }

     /*由于此页面暂时不处理表单中的系统字段，所及将此段代码注释，如需支持系统字段，请解开注释即可
    if(isbill.equals("1"))
    	label = SystemEnv.getHtmlLabelName(Util.getIntValue(label),user.getLanguage());
    /*
     初始化创建日期   -3
     节点类型         -6
     创建人           -4
     接收日期         -7
     工作流           -5
     当前状况         -8
     紧急程度         -2
     未操作者         -9
     请求说明         -1
    */
    /*由于此页面暂时不处理表单中的系统字段，所及将此段代码注释，如需支持系统字段，请解开注释即可
    if(id.equals("-1")){
        id="_1";
        name="requestname";
        label=SystemEnv.getHtmlLabelName(1334,user.getLanguage());
        htmltype="1";
        type="1";
    }else if(id.equals("-2")){
        id="_2";
        name="requestlevel";
        label=SystemEnv.getHtmlLabelName(15534,user.getLanguage());
        htmltype="5";
        type="1";
    }else if(id.equals("-3")){
        id="_3";
        name="createdate";
        label=SystemEnv.getHtmlLabelName(722,user.getLanguage());
        htmltype="3";
        type="2";
    }else if(id.equals("-4")){
        id="_4";
        name="creater";
        label=SystemEnv.getHtmlLabelName(882,user.getLanguage());
        htmltype="3";
        type="17";
    }else if(id.equals("-5")){
        id="_5";
        name="workflowid";
        label=SystemEnv.getHtmlLabelName(259,user.getLanguage());
        htmltype="3";
        type="-5";
    }else if(id.equals("-6")){
        id="_6";
        name="nodetype";
        label=SystemEnv.getHtmlLabelName(15536,user.getLanguage());
        htmltype="5";
        type="1";
    }else if(id.equals("-7")){
        id="_7";
        name="receivedate";
        label=SystemEnv.getHtmlLabelName(17994,user.getLanguage());
        htmltype="3";
        type="2";
    }else if(id.equals("-8")){
        id="_8";
        name="isdeleted";
        label=SystemEnv.getHtmlLabelName(169,user.getLanguage());
        htmltype="5";
        type="1";
    }else if(id.equals("-9")){
        id="_9";
        name="userid";
        label=SystemEnv.getHtmlLabelName(16354,user.getLanguage());
        htmltype="3";
        type="1";
    }
    */
    String display="display:none;";
%>
    <wea:item>
      <input type="hidden" name="con<%=id%>_htmltype" value="<%=htmltype%>">
      <input type="hidden" name="con<%=id%>_type" value="<%=type%>">
      <input type="hidden" name="con<%=id%>_colname" value="<%=name%>">
      <input type='checkbox' name='check_con' checked title="<%=SystemEnv.getHtmlLabelName(20778,user.getLanguage())%>" value="<%=id%>" style="display:none"/> <%=label%>
    </wea:item>
    <%
    /**if block*/
    if((htmltype.equals("1")&& type.equals("1"))||htmltype.equals("2")){  //文本框

    %>
      <wea:item>
        <select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90" >
          <%if(!htmltype.equals("2")){//TD9319 屏蔽掉多行文本框的“等于”和“不等于”操作，text数据库类型不支持该判断%>
          <option value="1"><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>     <!--等于-->
          <option value="2"><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>   <!--不等于-->
          <%}%>
          <option value="3" <%if(issimple){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>   <!--包含-->
          <option value="4"><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>   <!--不包含-->
        </select>
        <input type=text class=InputStyle style="width:50%" name="con<%=id%>_value" value="<%=Util.null2String(request.getParameter("con" + id + "_value"))%>">
        <%--
        <SPAN id=remind style='cursor:hand' title='<%=SystemEnv.getHtmlLabelName(81509,user.getLanguage())%>'>
        <IMG src='/images/remind_wev8.png' align=absMiddle>
        </SPAN>     --%>
      </wea:item> 
    <%}
     /**if block*/
    else if(htmltype.equals("1")&& !type.equals("1")){  //数字   <!--大于,大于或等于,小于,小于或等于,等于,不等于-->
    %>
    <wea:item>
      <div style="display:block;">
      <select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90" >
        <option value="1"><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%></option>
        <option value="2" <%if(issimple){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(325,user.getLanguage())%></option>
        <option value="3"><%=SystemEnv.getHtmlLabelName(15509,user.getLanguage())%></option>
        <option value="4"><%=SystemEnv.getHtmlLabelName(326,user.getLanguage())%></option>
        <option value="5"><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
        <option value="6"><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
      </select>
      <%if(issimple){%><%=SystemEnv.getHtmlLabelName(325,user.getLanguage())%><%}%>
      <input type=text class=InputStyle size=10 name="con<%=id%>_value" onblur="checknumber('con<%=id%>_value');" value="<%=Util.null2String(request.getParameter("con" + id + "_value"))%>">
      </div>
      <div style="display:block;">
      <select class=inputstyle  name="con<%=id%>_opt1" style="<%=display%>width:90"  >
        <option value="1"><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%></option>
        <option value="2"><%=SystemEnv.getHtmlLabelName(325,user.getLanguage())%></option>
        <option value="3"><%=SystemEnv.getHtmlLabelName(15509,user.getLanguage())%></option>
        <option value="4" <%if(issimple){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(326,user.getLanguage())%></option>
        <option value="5"><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
        <option value="6"><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
      </select>
      <%if(issimple){%><%=SystemEnv.getHtmlLabelName(326,user.getLanguage())%><%}%>
	  <input type=text class=InputStyle size=10 name="con<%=id%>_value1"  onblur="checknumber('con<%=id%>_value1');" value="<%=Util.null2String(request.getParameter("con" + id + "_value1"))%>">
	  </div>
    </wea:item>
    <%
    }
     /**if block*/
    else if(htmltype.equals("4")){   //check类型
    %>
    <wea:item>
      <input type="checkbox" value=1 name="con<%=id%>_value"/>
    </wea:item>
    <%}
     /**if block*/
    else if(htmltype.equals("5")){  //选择框

    %>
    <wea:item>
    <select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90" >
    <option value="1"><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
    <option value="2"><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
    </select>

    <select class=inputstyle  name="con<%=id%>_value">
    <option value="" ></option>
    <%
    char flag=2;
    
    RecordSet2.executeProc("workflow_SelectItemSelectByid",""+id+flag+isbill);
    while(RecordSet2.next()){
      int tmpselectvalue = RecordSet2.getInt("selectvalue");
      String tmpselectname = RecordSet2.getString("selectname");
    %>
    <option value="<%=tmpselectvalue%>"><%=Util.toScreen(tmpselectname,user.getLanguage())%></option>
    <%}%>
    </select>
    </wea:item>

    <%} 
     /**if block*/
    else if(htmltype.equals("3") && type.equals("1")){//浏览框单人力资源  条件为多人力 (like not lik)
    %>
    <wea:item>
          <select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90">
          <option value="1"><%=SystemEnv.getHtmlLabelName(18987,user.getLanguage())%></option>
          <option value="2"><%=SystemEnv.getHtmlLabelName(18988,user.getLanguage())%></option>
          </select>
          <brow:browser viewType="0" name='<%="con"+id+"_value"%>' 
            browserValue='<%=request.getParameter("con"+id+"_value")%>' 
            browserSpanValue='<%=FieldInfo.getFieldName(request.getParameter("con"+id+"_value"),Util.getIntValue(type),BrowserComInfo.getBrowserdbtype(type))%>' 
            browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?selectedids="
            hasInput="true" 
            isSingle='false' 
            hasBrowser = "true" isMustInput='1' 
            completeUrl='<%="javascript:getajaxurl(" + type + ")"%>'
            > 
          </brow:browser>
    </wea:item>
    <%} 
     /**if block*/
    else if(htmltype.equals("3") && type.equals("9")){//浏览框单文挡  条件为多文挡 (like not lik)
    %>
    <wea:item>
          <select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90" >
          <option value="1"><%=SystemEnv.getHtmlLabelName(18987,user.getLanguage())%></option>
          <option value="2"><%=SystemEnv.getHtmlLabelName(18988,user.getLanguage())%></option>
          </select>
           <brow:browser viewType="0" name='<%="con"+id+"_value"%>' 
            browserValue='<%=request.getParameter("con"+id+"_value")%>' 
            browserSpanValue='<%=FieldInfo.getFieldName(request.getParameter("con"+id+"_value"),Util.getIntValue(type),BrowserComInfo.getBrowserdbtype(type))%>' 
            browserUrl="/systeminfo/BrowserMain.jsp?url=/docs/docs/MutiDocBrowser.jsp?documentids="
            hasInput="true" 
            isSingle='<%=BrowserManager.browIsSingle(type)%>' 
            hasBrowser = "true" isMustInput='1' 
            completeUrl='<%="javascript:getajaxurl(" + type + ")"%>'
            > 
          </brow:browser>
    </wea:item>
    <%} 
     /**if block*/
    else if(htmltype.equals("3") && type.equals("4")){//浏览框单部门  条件为多部门 (like not lik)
    %>
    <wea:item>
          <select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90" >
          <option value="1"><%=SystemEnv.getHtmlLabelName(18987,user.getLanguage())%></option>
          <option value="2"><%=SystemEnv.getHtmlLabelName(18988,user.getLanguage())%></option>
          </select>
          <brow:browser viewType="0" name='<%="con"+id+"_value"%>' 
            browserValue='<%=request.getParameter("con"+id+"_value")%>' 
            browserSpanValue='<%=FieldInfo.getFieldName(request.getParameter("con"+id+"_value"),Util.getIntValue(type),BrowserComInfo.getBrowserdbtype(type))%>' 
            browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp?selectedids="
            hasInput="true" 
            isSingle='false' 
            hasBrowser = "true" isMustInput='1' 
            completeUrl='<%="javascript:getajaxurl(" + type + ")"%>'
            > 
          </brow:browser>
    </wea:item>
    <%} 
     /**if block*/
    else if(htmltype.equals("3") && type.equals("7")){//浏览框单客户  条件为多客户 (like not lik)
    %>
    <wea:item>
          <select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90"  >
          <option value="1"><%=SystemEnv.getHtmlLabelName(18987,user.getLanguage())%></option>
          <option value="2"><%=SystemEnv.getHtmlLabelName(18988,user.getLanguage())%></option>
          </select>
          <brow:browser viewType="0" name='<%="con"+id+"_value"%>' 
            browserValue='<%=request.getParameter("con"+id+"_value")%>' 
            browserSpanValue='<%=FieldInfo.getFieldName(request.getParameter("con"+id+"_value"),Util.getIntValue(type),BrowserComInfo.getBrowserdbtype(type))%>' 
            browserUrl="/systeminfo/BrowserMain.jsp?url=/CRM/data/MutiCustomerBrowser.jsp?resourceids="
            hasInput="true" 
            isSingle='<%=BrowserManager.browIsSingle(type)%>' 
            hasBrowser = "true" isMustInput='1' 
            completeUrl='<%="javascript:getajaxurl(" + type + ")"%>'
            > 
          </brow:browser>
    </wea:item>
    <%} 
     /**if block*/
    else if(htmltype.equals("3") && type.equals("8")){//浏览框单项目  条件为多项目 (like not lik)
    %>
    <wea:item>
          <select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90" >
          <option value="1"><%=SystemEnv.getHtmlLabelName(18987,user.getLanguage())%></option>
          <option value="2"><%=SystemEnv.getHtmlLabelName(18988,user.getLanguage())%></option>
          </select>
           <brow:browser viewType="0" name='<%="con"+id+"_value"%>' 
            browserValue='<%=request.getParameter("con"+id+"_value")%>' 
            browserSpanValue='<%=FieldInfo.getFieldName(request.getParameter("con"+id+"_value"),Util.getIntValue(type),BrowserComInfo.getBrowserdbtype(type))%>' 
            browserUrl="/systeminfo/BrowserMain.jsp?url=/proj/data/MultiProjectBrowser.jsp?projectids="
            hasInput="true" 
            isSingle='<%=BrowserManager.browIsSingle(type)%>' 
            hasBrowser = "true" isMustInput='1' 
            completeUrl='<%="javascript:getajaxurl(" + type + ")"%>'
            > 
          </brow:browser>
    </wea:item>
    <%} 
     /**if block*/
    else if(htmltype.equals("3") && type.equals("16")){//浏览框单请求  条件为多请求 (like not lik)
    %>
    <wea:item>
      <select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90" >
          <option value="1"><%=SystemEnv.getHtmlLabelName(18987,user.getLanguage())%></option>
          <option value="2"><%=SystemEnv.getHtmlLabelName(18988,user.getLanguage())%></option>
          </select>
           <brow:browser viewType="0" name='<%="con"+id+"_value"%>' 
            browserValue='<%=request.getParameter("con"+id+"_value")%>' 
            browserSpanValue='<%=FieldInfo.getFieldName(request.getParameter("con"+id+"_value"),Util.getIntValue(type),BrowserComInfo.getBrowserdbtype(type))%>' 
            browserUrl="/systeminfo/BrowserMain.jsp?url=/workflow/request/MultiRequestBrowser.jsp?resourceids="
            hasInput="true" 
            isSingle='<%=BrowserManager.browIsSingle(type)%>' 
            hasBrowser = "true" isMustInput='1' 
            completeUrl='<%="javascript:getajaxurl(" + type + ")"%>'
            > 
          </brow:browser>
    </wea:item>
    <%}
     /**if block*/
    else if(htmltype.equals("3") && type.equals("24")){//职位的安全级别

    %>
    <wea:item>
		<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90">
			<option value="1"><%=SystemEnv.getHtmlLabelName(18987,user.getLanguage())%></option>
	        <option value="2"><%=SystemEnv.getHtmlLabelName(18988,user.getLanguage())%></option>
		</select>
		<brow:browser viewType="0" name='<%="con"+id+"_value"%>' 
            browserValue='<%=request.getParameter("con"+id+"_value")%>' 
            browserSpanValue='<%=FieldInfo.getFieldName(request.getParameter("con"+id+"_value"),Util.getIntValue(type),BrowserComInfo.getBrowserdbtype(type))%>' 
            browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/jobtitles/MutiJobTitlesBrowser.jsp?selectedids="
            hasInput="true" 
            isSingle='false' 
            hasBrowser = "true" isMustInput='1' 
            completeUrl='<%="javascript:getajaxurl(" + type + ")"%>'
            > 
          </brow:browser>
    </wea:item>
    <%}//职位安全级别end
    else if(htmltype.equals("3") && type.equals("278")){//职位的安全级别
      %>
      <wea:item>
  		<select class=inputstyle  name="con<%=id%>_opt" style="width:90" style="float:left;">
  			<option value="1"><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
          	<option value="2"><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
  		</select>
  		<brow:browser viewType="0" name='<%="con"+id+"_value"%>' 
              browserValue='<%=request.getParameter("con"+id+"_value")%>' 
              browserSpanValue='<%=FieldInfo.getFieldName(request.getParameter("con"+id+"_value"),Util.getIntValue(type),BrowserComInfo.getBrowserdbtype(type))%>' 
              browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/jobtitles/JobTitlesBrowser.jsp?selectedids="
              hasInput="true" 
              isSingle='true' 
              hasBrowser = "true" isMustInput='1' 
              completeUrl='<%="javascript:getajaxurl(" + type + ")"%>'
              > 
            </brow:browser>
      </wea:item>
      <%}
     /**if block*/
    else if(htmltype.equals("3") &&( type.equals("2") || type.equals("19"))){    //日期
    %>
    <wea:item>
    <select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90">
    <option value="1"><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%></option>
    <option value="2" <%if(issimple){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(325,user.getLanguage())%></option>
    <option value="3"><%=SystemEnv.getHtmlLabelName(15509,user.getLanguage())%></option>
    <option value="4"><%=SystemEnv.getHtmlLabelName(326,user.getLanguage())%></option>
    <option value="5"><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
    <option value="6" ><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
    </select>
    <%if(issimple){%><%=SystemEnv.getHtmlLabelName(348,user.getLanguage())%><%}%>
    <button type=button  class=calendar
    <%if(type.equals("2")){%>
     onclick="onSearchWFQTDate(con<%=id%>_valuespan,con<%=id%>_value,con<%=id%>_value1,'<%=tmpcount%>')"
    <%}else{%>
     onclick ="onSearchWFQTTime(con<%=id%>_valuespan,con<%=id%>_value,con<%=id%>_value1,'<%=tmpcount%>')"
    <%}%>
     ></button>
    <input type=hidden name="con<%=id%>_value" value="<%=Util.null2String(request.getParameter("con" + id + "_value"))%>">
    <span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"><%=Util.null2String(request.getParameter("con" + id + "_value"))%></span>
    <select class=inputstyle  name="con<%=id%>_opt1" style="<%=display%>width:90"  >
    <option value="1"><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%></option>
    <option value="2"><%=SystemEnv.getHtmlLabelName(325,user.getLanguage())%></option>
    <option value="3"><%=SystemEnv.getHtmlLabelName(15509,user.getLanguage())%></option>
    <option value="4" <%if(issimple){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(326,user.getLanguage())%></option>
    <option value="5"><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
    <option value="6"><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
    </select>
    <%if(issimple){%><%=SystemEnv.getHtmlLabelName(349,user.getLanguage())%><%}%>
    <button type=button  class=calendar
    <%if(type.equals("2")){%>
     onclick="onSearchWFQTDate(con<%=id%>_value1span,con<%=id%>_value1,con<%=id%>_value,'<%=tmpcount%>')"
    <%}else{%>
     onclick ="onSearchWFQTTime(con<%=id%>_value1span,con<%=id%>_value1,con<%=id%>_value,'<%=tmpcount%>')"
    <%}%>
     ></button>
    <input type=hidden name="con<%=id%>_value1" value="<%=Util.null2String(request.getParameter("con" + id + "_value1"))%>">
    <span name="con<%=id%>_value1span" id="con<%=id%>_value1span"><%=Util.null2String(request.getParameter("con" + id + "_value1"))%></span>
    </wea:item>
    <%} 
     /**if block*/
    else if(htmltype.equals("3") && type.equals("17")){
    %>
          <wea:item>
          <select class=inputstyle  name="con<%=id%>_opt" style="width:90" >
          <option value="1"><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
          <option value="2"><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
          </select>
          <brow:browser viewType="0" name='<%="con"+id+"_value"%>' 
            browserValue='<%=request.getParameter("con"+id+"_value")%>' 
            browserSpanValue='<%=FieldInfo.getFieldName(request.getParameter("con"+id+"_value"),Util.getIntValue(type),BrowserComInfo.getBrowserdbtype(type))%>' 
            browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
            hasInput="true" 
            isSingle='true' 
            hasBrowser = "true" isMustInput='1' 
            completeUrl='<%="javascript:getajaxurl(" + type + ")"%>'
            >  
          </brow:browser>
    </wea:item>
    <%} 
     /**if block*/
    else if(htmltype.equals("3") && type.equals("37")){//浏览框  多选筐条件为单选筐(多文挡)
    %>
          <wea:item>
          <select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90" >
          <option value="1"><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
          <option value="2"><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
          </select>
         <brow:browser viewType="0" name='<%="con"+id+"_value"%>' 
            browserValue='<%=request.getParameter("con"+id+"_value")%>' 
            browserSpanValue='<%=FieldInfo.getFieldName(request.getParameter("con"+id+"_value"),Util.getIntValue(type),BrowserComInfo.getBrowserdbtype(type))%>' 
            browserUrl="/systeminfo/BrowserMain.jsp?url=/docs/docs/DocBrowser.jsp"
            hasInput="true" 
            isSingle='<%=BrowserManager.browIsSingle(type)%>' 
            hasBrowser = "true" isMustInput='1' 
            completeUrl='<%="javascript:getajaxurl(" + type + ")"%>'
            > 
             </brow:browser>
        </wea:item>
    <%} 
     /**if block*/
    else if(htmltype.equals("3") && type.equals("57")){//浏览框  多选筐条件为单选筐（多部门）

    %>
          <wea:item>
          <select class=inputstyle  name="con<%=id%>_opt" style="width:90" >
          <option value="1"><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
          <option value="2"><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
          </select>
         <brow:browser viewType="0" name='<%="con"+id+"_value"%>' 
            browserValue='<%=request.getParameter("con"+id+"_value")%>' 
            browserSpanValue='<%=FieldInfo.getFieldName(request.getParameter("con"+id+"_value"),Util.getIntValue(type),BrowserComInfo.getBrowserdbtype(type))%>' 
            browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="
            hasInput="true" 
            isSingle='true' 
            hasBrowser = "true" isMustInput='1' 
            completeUrl='<%="javascript:getajaxurl(" + type + ")"%>'
            > 
             </brow:browser>
          </wea:item>
    <%} 
    else if(htmltype.equals("3") && type.equals("164")){//浏览框  多选筐条件为单选筐（分部）
    %>
              <wea:item>
             <select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90" >
	          <option value="1"><%=SystemEnv.getHtmlLabelName(18987,user.getLanguage())%></option>
	          <option value="2"><%=SystemEnv.getHtmlLabelName(18988,user.getLanguage())%></option>
	          </select>
              <brow:browser viewType="0" name='<%="con"+id+"_value"%>' 
                browserValue='<%=request.getParameter("con"+id+"_value")%>' 
                browserSpanValue='<%=FieldInfo.getFieldName(request.getParameter("con"+id+"_value"),Util.getIntValue(type),BrowserComInfo.getBrowserdbtype(type))%>' 
                browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiSubcompanyBrowser.jsp?selectedids="
                hasInput="true" 
                isSingle='false' 
                hasBrowser = "true" isMustInput='1' 
                completeUrl='<%="javascript:getajaxurl(" + type + ")"%>'
                > 
              </brow:browser>
              </wea:item>
        <%}
    else if(htmltype.equals("3") && type.equals("194")){//浏览框  多选筐条件为单选筐（多分部）

        %>
              <wea:item>
              <select class=inputstyle  name="con<%=id%>_opt" style="width:90" >
              <option value="1"><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
              <option value="2"><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
              </select>
              <brow:browser viewType="0" name='<%="con"+id+"_value"%>' 
                browserValue='<%=request.getParameter("con"+id+"_value")%>' 
                browserSpanValue='<%=FieldInfo.getFieldName(request.getParameter("con"+id+"_value"),Util.getIntValue(type),BrowserComInfo.getBrowserdbtype(type))%>' 
                browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp?selectedids="
                hasInput="true" 
                isSingle='true' 
                hasBrowser = "true" isMustInput='1' 
                completeUrl='<%="javascript:getajaxurl(" + type + ")"%>'
                > 
              </brow:browser>
              </wea:item>
        <%}
    	else if(htmltype.equals("3") && type.equals("165")){//浏览框  多选筐条件为单选筐（分权单人力）

        %>
              <wea:item>
              <select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90" >
	          <option value="1"><%=SystemEnv.getHtmlLabelName(18987,user.getLanguage())%></option>
	          <option value="2"><%=SystemEnv.getHtmlLabelName(18988,user.getLanguage())%></option>
	          </select>
              <brow:browser viewType="0" name='<%="con"+id+"_value"%>' 
                browserValue='<%=request.getParameter("con"+id+"_value")%>' 
                browserSpanValue='<%=FieldInfo.getFieldName(request.getParameter("con"+id+"_value"),Util.getIntValue(type),BrowserComInfo.getBrowserdbtype(type))%>' 
                browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MultiResourceBrowserByDec.jsp?selectedids="
                hasInput="true" 
                isSingle='false' 
                hasBrowser = "true" isMustInput='1' 
                completeUrl='<%="javascript:getajaxurl(" + type + ")"%>'
                > 
              </brow:browser>
              </wea:item>
        <%}else if(htmltype.equals("3") && type.equals("166")){//浏览框  多选筐条件为单选筐（分权多人力）

            %>
                  <wea:item>
              <select class=inputstyle  name="con<%=id%>_opt" style="width:90" >
              <option value="1"><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
              <option value="2"><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
              </select>
             <brow:browser viewType="0" name='<%="con"+id+"_value"%>' 
                browserValue='<%=request.getParameter("con"+id+"_value")%>' 
                browserSpanValue='<%=FieldInfo.getFieldName(request.getParameter("con"+id+"_value"),Util.getIntValue(type),BrowserComInfo.getBrowserdbtype(type))%>' 
                browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowserByDec.jsp?selectedids="
                hasInput="true" 
                isSingle='true' 
                hasBrowser = "true" isMustInput='1' 
                completeUrl='<%="javascript:getajaxurl(" + type + ")"%>'
                > 
                 </brow:browser>
              </wea:item>
            <%}else if(htmltype.equals("3") && type.equals("167")){//浏览框  多选筐条件为单选筐（分权单部门）

                %>
                      <wea:item>
                      <select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90" >
        	          <option value="1"><%=SystemEnv.getHtmlLabelName(18987,user.getLanguage())%></option>
        	          <option value="2"><%=SystemEnv.getHtmlLabelName(18988,user.getLanguage())%></option>
        	          </select>
                      <brow:browser viewType="0" name='<%="con"+id+"_value"%>' 
                        browserValue='<%=request.getParameter("con"+id+"_value")%>' 
                        browserSpanValue='<%=FieldInfo.getFieldName(request.getParameter("con"+id+"_value"),Util.getIntValue(type),BrowserComInfo.getBrowserdbtype(type))%>' 
                        browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/MultiDepartmentBrowserByDecOrder.jsp?selectedids="
                        hasInput="true" 
                        isSingle='false' 
                        hasBrowser = "true" isMustInput='1' 
                        completeUrl='<%="javascript:getajaxurl(" + type + ")"%>'
                        > 
                      </brow:browser>
                      </wea:item>
                <%}
    else if(htmltype.equals("3") && type.equals("168")){//浏览框  多选筐条件为单选筐（分权多部门）

        %>
              <wea:item>
              <select class=inputstyle  name="con<%=id%>_opt" style="width:90" >
              <option value="1"><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
              <option value="2"><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
              </select>
             <brow:browser viewType="0" name='<%="con"+id+"_value"%>' 
                browserValue='<%=request.getParameter("con"+id+"_value")%>' 
                browserSpanValue='<%=FieldInfo.getFieldName(request.getParameter("con"+id+"_value"),Util.getIntValue(type),BrowserComInfo.getBrowserdbtype(type))%>' 
                browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowserByDec.jsp?selectedids="
                hasInput="true" 
                isSingle='true' 
                hasBrowser = "true" isMustInput='1' 
                completeUrl='<%="javascript:getajaxurl(" + type + ")"%>'
                > 
                 </brow:browser>
              </wea:item>
        <%}
    else if(htmltype.equals("3") && type.equals("169")){//浏览框  多选筐条件为单选筐（分权单分部）

        %>
              <wea:item>
              <select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90" >
	          <option value="1"><%=SystemEnv.getHtmlLabelName(18987,user.getLanguage())%></option>
	          <option value="2"><%=SystemEnv.getHtmlLabelName(18988,user.getLanguage())%></option>
	          </select>
              <brow:browser viewType="0" name='<%="con"+id+"_value"%>' 
                browserValue='<%=request.getParameter("con"+id+"_value")%>' 
                browserSpanValue='<%=FieldInfo.getFieldName(request.getParameter("con"+id+"_value"),Util.getIntValue(type),BrowserComInfo.getBrowserdbtype(type))%>' 
                browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/MultiSubcompanyBrowserByDec.jsp?selectedids="
                hasInput="true" 
                isSingle='false' 
                hasBrowser = "true" isMustInput='1' 
                completeUrl='<%="javascript:getajaxurl(" + type + ")"%>'
                > 
              </brow:browser>
              </wea:item>
        <%}
    else if(htmltype.equals("3") && type.equals("170")){//浏览框  多选筐条件为单选筐（分权多分部）

        %>
              <wea:item>
              <select class=inputstyle  name="con<%=id%>_opt" style="width:90" >
              <option value="1"><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
              <option value="2"><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
              </select>
             <brow:browser viewType="0" name='<%="con"+id+"_value"%>' 
                browserValue='<%=request.getParameter("con"+id+"_value")%>' 
                browserSpanValue='<%=FieldInfo.getFieldName(request.getParameter("con"+id+"_value"),Util.getIntValue(type),BrowserComInfo.getBrowserdbtype(type))%>' 
                browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowserByDec.jsp?selectedids="
                hasInput="true" 
                isSingle='true' 
                hasBrowser = "true" isMustInput='1' 
                completeUrl='<%="javascript:getajaxurl(" + type + ")"%>'
                > 
                 </brow:browser>
              </wea:item>
        <%}
     /**if block*/
    else if(htmltype.equals("3") && type.equals("135")){//浏览框  多选筐条件为单选筐（多项目 ）

    %>
          <wea:item>
          <select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90" >
          <option value="1"><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
          <option value="2"><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
          </select>
          <brow:browser viewType="0" name='<%="con"+id+"_value"%>' 
            browserValue='<%=request.getParameter("con"+id+"_value")%>' 
            browserSpanValue='<%=FieldInfo.getFieldName(request.getParameter("con"+id+"_value"),Util.getIntValue(type),BrowserComInfo.getBrowserdbtype(type))%>' 
            browserUrl="/systeminfo/BrowserMain.jsp?url=/proj/data/ProjectBrowser.jsp"
            hasInput="true" 
            isSingle='<%=BrowserManager.browIsSingle(type)%>' 
            hasBrowser = "true" isMustInput='1' 
            completeUrl='<%="javascript:getajaxurl(" + type + ")"%>'
            > 
             </brow:browser>
          </wea:item>
    <%} 
     /**if block*/
    else if(htmltype.equals("3") && type.equals("152")){//浏览框  多选筐条件为单选筐（多请求 ）

    %>
          <wea:item>
          <select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90" >
          <option value="1"><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
          <option value="2"><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
          </select>
          <brow:browser viewType="0" name='<%="con"+id+"_value"%>' 
            browserValue='<%=request.getParameter("con"+id+"_value")%>' 
            browserSpanValue='<%=FieldInfo.getFieldName(request.getParameter("con"+id+"_value"),Util.getIntValue(type),BrowserComInfo.getBrowserdbtype(type))%>' 
            browserUrl="/systeminfo/BrowserMain.jsp?url=/workflow/request/RequestBrowser.jsp"
            hasInput="true" 
            isSingle='<%=BrowserManager.browIsSingle(type)%>' 
            hasBrowser = "true" isMustInput='1' 
            completeUrl='<%="javascript:getajaxurl(" + type + ")"%>'
            > 
             </brow:browser>
          </wea:item>
    <%} 
     /**if block*/
    else if(htmltype.equals("3") && type.equals("18")){//浏览框  多选筐条件为单选筐
    %>
          <wea:item>
          <select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90" >
          <option value="1"><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
          <option value="2"><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
          </select>
          <brow:browser viewType="0" name='<%="con"+id+"_value"%>' 
            browserValue='<%=request.getParameter("con"+id+"_value")%>' 
            browserSpanValue='<%=FieldInfo.getFieldName(request.getParameter("con"+id+"_value"),Util.getIntValue(type),BrowserComInfo.getBrowserdbtype(type))%>' 
            browserUrl="/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp"
            hasInput="true" 
            isSingle='<%=BrowserManager.browIsSingle(type)%>' 
            hasBrowser = "true" isMustInput='1' 
            completeUrl='<%="javascript:getajaxurl(" + type + ")"%>'
            > 
             </brow:browser>
    </wea:item>
    <%}
     /**if block*/
    else if(htmltype.equals("3") && type.equals("160")){//浏览框  多选筐条件为单选筐
    %>
          <wea:item>
          <select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90"  >
          <option value="1"><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
          <option value="2"><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
          </select>
         <brow:browser viewType="0" name='<%="con"+id+"_value"%>' 
            browserValue='<%=request.getParameter("con"+id+"_value")%>' 
            browserSpanValue='<%=FieldInfo.getFieldName(request.getParameter("con"+id+"_value"),Util.getIntValue(type),BrowserComInfo.getBrowserdbtype(type))%>' 
            browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
            hasInput="true" 
            isSingle='<%=BrowserManager.browIsSingle(type)%>' 
            hasBrowser = "true" isMustInput='1' 
            completeUrl='<%="javascript:getajaxurl(" + type + ")"%>'
            > 
             </brow:browser>
          </wea:item>
    <%} 
     /**if block*/
    else if(htmltype.equals("3") && type.equals("142")){//浏览框多收发文单位

    %>
          <wea:item>
          <select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90" >
          <option value="1"><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
          <option value="2"><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
          </select>
          <brow:browser viewType="0" name='<%="con"+id+"_value"%>' 
            browserValue='<%=request.getParameter("con"+id+"_value")%>' 
            browserSpanValue='<%=FieldInfo.getFieldName(request.getParameter("con"+id+"_value"),Util.getIntValue(type),BrowserComInfo.getBrowserdbtype(type))%>' 
            browserUrl="/systeminfo/BrowserMain.jsp?url=/docs/sendDoc/DocReceiveUnitBrowserSingle.jsp"
            hasInput="true" 
            isSingle='<%=BrowserManager.browIsSingle(type)%>' 
            hasBrowser = "true" isMustInput='1' 
            completeUrl='<%="javascript:getajaxurl(" + type + ")"%>'
            > 
             </brow:browser>
          </wea:item>
    <%}
     /**if block*/
    else if(htmltype.equals("3") && (type.equals("141")||type.equals("56")||type.equals("27")||type.equals("118")||type.equals("65")||type.equals("64")||type.equals("137"))){//浏览框

    %>
          <wea:item>
          <select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90"  >
          <option value="1"><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
          <option value="2"><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
          </select>
          <brow:browser viewType="0" name='<%="con"+id+"_value"%>' 
            browserValue='<%=request.getParameter("con"+id+"_value")%>' 
            browserSpanValue='<%=FieldInfo.getFieldName(request.getParameter("con"+id+"_value"),Util.getIntValue(type),BrowserComInfo.getBrowserdbtype(type))%>' 
            browserUrl='<%=BrowserComInfo.getBrowserurl(type)%>'
            hasInput="true" 
            isSingle='<%=BrowserManager.browIsSingle(type)%>' 
            hasBrowser = "true" isMustInput='1' 
            completeUrl='<%="javascript:getajaxurl(" + type + ")"%>'
            >
             </brow:browser>
          </wea:item>
    <%}
     /**if block*/
    else if(htmltype.equals("3") && id.equals("_5")){//工作流浏览框
        String _browserUrl = "/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser.jsp?sqlwhere="+xssUtil.put(" where isvalid in ('1','3') ");
    %>
          <wea:item>
          <input type=hidden  name="con<%=id%>_opt" value="1">
          <brow:browser viewType="0" name='<%="con"+id+"_value"%>' 
            browserValue='<%=request.getParameter("con"+id+"_value")%>' 
            browserSpanValue='<%=FieldInfo.getFieldName(request.getParameter("con"+id+"_value"),Util.getIntValue(type),BrowserComInfo.getBrowserdbtype(type))%>' 
            browserUrl='<%=_browserUrl%>'
            hasInput="true" 
            isSingle='<%=BrowserManager.browIsSingle(type)%>' 
            hasBrowser = "true" isMustInput='1' 
            completeUrl='<%="javascript:getajaxurl(" + type + ")"%>'
            > 
             </brow:browser>
          </wea:item>
    <%} /**if block*/
    else if (htmltype.equals("3") && (type.equals("256") || type.equals("257"))){
    %>
          <wea:item>
          <select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90" >
          <option value="1"><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
          <option value="2"><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
          </select>
         <brow:browser viewType="0" name='<%="con"+id+"_value"%>' 
            browserValue='<%=request.getParameter("con"+id+"_value")%>' 
            browserSpanValue='<%=FieldInfo.getFieldName(request.getParameter("con"+id+"_value"),Util.getIntValue(type),BrowserComInfo.getBrowserdbtype(type))%>' 
            browserUrl='<%=BrowserComInfo.getBrowserurl(type)+"?type="+dbtype+"_"+type%>'
            hasInput="true" 
            isSingle='<%=BrowserManager.browIsSingle(type)%>' 
            hasBrowser = "true" isMustInput='1' 
            completeUrl='<%="javascript:getajaxurl(" + type + ")"%>'
            > 
             </brow:browser>
          </wea:item>
    <%} 
     /**if block*/
    else if (htmltype.equals("3") && (type.equals("161") || type.equals("162"))){
    %>
          <wea:item>
          <select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90" >
          <option value="1"><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
          <option value="2"><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
          </select>
         <brow:browser viewType="0" name='<%="con"+id+"_value"%>' 
            browserValue='<%=request.getParameter("con"+id+"_value")%>' 
            browserSpanValue='<%=FieldInfo.getFieldName(request.getParameter("con"+id+"_value"),Util.getIntValue(type),BrowserComInfo.getBrowserdbtype(type))%>' 
            browserUrl='<%=BrowserComInfo.getBrowserurl(type)+"?type="+dbtype%>'
            hasInput="true" 
            isSingle='<%=BrowserManager.browIsSingle(type)%>' 
            hasBrowser = "true" isMustInput='1' 
            completeUrl='<%="/data.jsp?isreport=1&type="+type+"&fielddbtype="+dbtype%>'
            > 
             </brow:browser>
          </wea:item>
    <%} 
    /**if block*/
    else if (htmltype.equals("3")&&(type.equals("226") || type.equals("227"))){
        %>
        	 <wea:item>
              <select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90" >
              <option value="1"><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
              <option value="2"><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
              </select>
             <brow:browser viewType="0" name='<%="con"+id+"_value"%>' 
                browserValue='<%=request.getParameter("con"+id+"_value")%>' 
                browserSpanValue='<%=FieldInfo.getFieldName(request.getParameter("con"+id+"_value"),Util.getIntValue(type),BrowserComInfo.getBrowserdbtype(type))%>' 
                browserUrl='<%=BrowserComInfo.getBrowserurl(type)+"?type="+dbtype+"|"+id+"&fromNodeorReport=1"%>'
                hasInput="true" 
                isSingle='<%=BrowserManager.browIsSingle(type)%>' 
                hasBrowser = "true" isMustInput='1' 
                completeUrl='<%="javascript:getajaxurl(" + type + ")"%>'
                >
                 </brow:browser>
              </wea:item>
        
        <%} 
     /**if block*/
    else if (htmltype.equals("3")){
    %>
          <wea:item>
          <select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90" >
          <option value="1"><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
          <option value="2"><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
          </select>
         <brow:browser viewType="0" name='<%="con"+id+"_value"%>' 
            browserValue='<%=request.getParameter("con"+id+"_value")%>' 
            browserSpanValue='<%=FieldInfo.getFieldName(request.getParameter("con"+id+"_value"),Util.getIntValue(type),BrowserComInfo.getBrowserdbtype(type))%>' 
            browserUrl='<%=BrowserComInfo.getBrowserurl(type)%>'
            hasInput="true" 
            isSingle='<%=BrowserManager.browIsSingle(type)%>' 
            hasBrowser = "true" isMustInput='1' 
            completeUrl='<%="javascript:getajaxurl(" + type + ")"%>'
            >
             </brow:browser>
          </wea:item>
    <%} 
     /**if block*/
    else if (htmltype.equals("6")){   //附件上传同多文挡
      String urls=BrowserComInfo.getBrowserurl(type);     // 浏览按钮弹出页面的url
    %>
    <wea:item>
    <select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90"   >
    <option value="1"><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
    <option value="2"><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
    </select>
    <brow:browser viewType="0" name='<%="con"+id+"_value"%>' 
        browserValue='<%=request.getParameter("con"+id+"_value")%>' 
        browserSpanValue='<%=FieldInfo.getFieldName(request.getParameter("con"+id+"_value"),Util.getIntValue(type),BrowserComInfo.getBrowserdbtype(type))%>' 
        browserUrl="/systeminfo/BrowserMain.jsp?url=/docs/docs/DocBrowser.jsp?isworkflow=1"
        hasInput="true" 
        isSingle='<%=BrowserManager.browIsSingle(type)%>' 
        hasBrowser = "true" isMustInput='1' 
        completeUrl='<%="javascript:getajaxurl(" + type + ")"%>'
        > 
         </brow:browser>
         </wea:item>
    <%}
     /**if block*/
    else{
    %>
     <wea:item>&nbsp;</wea:item>
    <%
    }
    %>

  <%}%>
 </wea:group>
</wea:layout>
<!--end 查询条件创建-->
<script type="text/javascript" language="javascript" src="/js/jquery/jquery_dialog_wev8.js"></script>
<script type="text/javascript">
  
  jQuery(document).ready(function(){
    var checkboxes = <%="'" + request.getParameter("checkboxes") + "'"%>;
    if(checkboxes == '' || !checkboxes) return;

    checkboxes = checkboxes.split(',');
    for(var i = 0 ; i < checkboxes.length; i++){
      var value = checkboxes[i];
      jQuery('input[type=checkbox][value='+value+']').attr('checked', true);
    }

    var allValues = <%="'" + request.getParameter("allValues") + "'"%>;
    if(allValues == '' || !allValues) return;

    var nameValueArray = allValues.split(",");
    for(var i = 0; i < nameValueArray.length; i++){
      var name = nameValueArray[i].split(":")[0];
      var value = nameValueArray[i].split(":")[1];

      if( jQuery("select[name="+name+"]") ){
        jQuery("select[name="+name+"]").val(value);
      }

      if( jQuery("input[type=checkbox][name="+name+"]") ){
        jQuery("input[type=checkbox][name="+name+"]").attr('checked', true);
      }
    }
  });
 

</script>
