

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ page import="weaver.hrm.HrmUserVarify"%>
<%@ page import="weaver.hrm.User"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page"/>
<jsp:useBean id="BrowserManager" class="weaver.general.browserData.BrowserManager" scope="page"/>
<%
  User user = HrmUserVarify.getUser (request , response) ;
  if(user == null) {
      response.sendRedirect("/login/Login.jsp");
      return;
  }

  String workflowid   = ""+Util.getIntValue(request.getParameter("workflowid"));
  String isbill       = "0";
  String formID       = "0";
  boolean issimple = Util.null2String(request.getParameter("issimple")).equals("true")?true:false;

  if(workflowid != null && !workflowid.equals("")){
    RecordSet.executeSql("select formid,isbill from workflow_base where id="+workflowid);
    if(RecordSet.next()){
      formID = RecordSet.getString("formid");
      isbill = RecordSet.getString("isbill");
    }
  }

%>

<wea:layout type="fourCol" attributes="{'expandAllGroup':'true'}">
  <wea:group context='<%=SystemEnv.getHtmlLabelName(21740,user.getLanguage())%>' attributes="{'class':'e8_title e8_title_1'}">

<%//以下开始列出表单字段

String sql = "";
if(isbill.equals("0")){
  sql = "select a.id,a.fieldname as name,a.fieldhtmltype as httype,a.fielddbtype as dbtype,a.type as type,b.fieldlable as label from workflow_formdict a, workflow_fieldlable b, workflow_formfield c where a.id=b.fieldid and a.id=c.fieldid and c.formid=b.formid and b.langurageid="+user.getLanguage()+" and b.formid="+formID+" order by c.fieldorder";
}else if(isbill.equals("1")){
    sql = "select id,fieldname as name,fieldlabel as label,fielddbtype as dbtype,fieldhtmltype as httype,type as type from workflow_billfield where viewtype=0 and billid="+formID;
}

RecordSet.execute(sql);
//System.out.println("sql = "+sql);
for (int tmpcount = 0; RecordSet.next(); tmpcount++)
{
    String name = RecordSet.getString("name");
    String label = RecordSet.getString("label");
    String htmltype = RecordSet.getString("httype");
    String type = RecordSet.getString("type");
    String id = RecordSet.getString("id");
     String dbtype = Util.null2String(RecordSet.getString("dbtype"));
    if(isbill.equals("1")){
      label = SystemEnv.getHtmlLabelName(Util.getIntValue(label),user.getLanguage());
    }
    String display = "display:none;";
%>
    <wea:item>
      <input type="hidden" name="con<%=id%>_htmltype" value="<%=htmltype%>">
      <input type="hidden" name="con<%=id%>_type" value="<%=type%>">
      <input type="hidden" name="con<%=id%>_colname" value="<%=name%>">
      <input type='checkbox' name='check_con' title="<%=SystemEnv.getHtmlLabelName(20778,user.getLanguage())%>" value="<%=id%>" style="display:none"/> <%=label%>
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
          <option value="3"><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>   <!--包含-->
          <option value="4">><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>   <!--不包含-->
        </select>
        <input type=text class=InputStyle style="width:50%" name="con<%=id%>_value"   onblur="changelevel(this,'<%=tmpcount%>')" value="<%=Util.null2String(request.getParameter("con" + id + "_value"))%>">
        <SPAN id=remind style='cursor:hand' title='<%=SystemEnv.getHtmlLabelName(81509,user.getLanguage())%>'>
        <IMG src='/images/remind_wev8.png' align=absMiddle>
        </SPAN>    
      </wea:item> 
    <%}
     /**if block*/
    else if(htmltype.equals("1")&& !type.equals("1")){  //数字   <!--大于,大于或等于,小于,小于或等于,等于,不等于-->
    %>
    <wea:item>
      <select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90" >
        <option value="1"><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%></option>
        <option value="2"><%=SystemEnv.getHtmlLabelName(325,user.getLanguage())%></option>
        <option value="3"><%=SystemEnv.getHtmlLabelName(15509,user.getLanguage())%></option>
        <option value="4"><%=SystemEnv.getHtmlLabelName(326,user.getLanguage())%></option>
        <option value="5"><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
        <option value="6"><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
      </select>
      <%if(issimple){%><%=SystemEnv.getHtmlLabelName(325,user.getLanguage())%><%}%>
      <input type=text class=InputStyle size=10 name="con<%=id%>_value" onblur="checknumber('con<%=id%>_value');changelevel1(this,$G('con<%=id%>_value1'),'<%=tmpcount%>')" value="">
      <select class=inputstyle  name="con<%=id%>_opt1" style="<%=display%>width:90"  >
        <option value="1"><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%></option>
        <option value="2"><%=SystemEnv.getHtmlLabelName(325,user.getLanguage())%></option>
        <option value="3"><%=SystemEnv.getHtmlLabelName(15509,user.getLanguage())%></option>
        <option value="4"><%=SystemEnv.getHtmlLabelName(326,user.getLanguage())%></option>
        <option value="5"><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
        <option value="6"><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
      </select>
    <%if(issimple){%><%=SystemEnv.getHtmlLabelName(326,user.getLanguage())%><%}%>
    <input type=text class=InputStyle size=10 name="con<%=id%>_value1"  onblur="checknumber('con<%=id%>_value1');changelevel1(this,$G('con<%=id%>_value'),'<%=tmpcount%>')" value="<%=Util.null2String(request.getParameter("con" + id + "_value1"))%>">
    </wea:item>
    <%
    }
     /**if block*/
    else if(htmltype.equals("4")){   //check类型
    %>
    <wea:item>
    <input type="checkbox" value=1 name="con<%=id%>_value"  onchange="changelevel(this,'<%=tmpcount%>')" />
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

    <select class=inputstyle  name="con<%=id%>_value"  onchange="changelevel(this,'<%=tmpcount%>')" >
    <option value="" ></option>
    <%
    char flag=2;
    if(id.equals("_6")){
    %>
        <option value="0"><%=SystemEnv.getHtmlLabelName(125,user.getLanguage())%></option>
        <option value="1"><%=SystemEnv.getHtmlLabelName(142,user.getLanguage())%></option>
        <option value="2"><%=SystemEnv.getHtmlLabelName(725,user.getLanguage())%></option>
        <option value="3"><%=SystemEnv.getHtmlLabelName(251,user.getLanguage())%></option>
    <%
    }else if(id.equals("_2")){
    %>
      <option value="0"><%=SystemEnv.getHtmlLabelName(225,user.getLanguage())%></option>
      <option value="1"><%=SystemEnv.getHtmlLabelName(15533,user.getLanguage())%></option>
      <option value="2"><%=SystemEnv.getHtmlLabelName(2087,user.getLanguage())%></option>
    <%
    }else if(id.equals("_8")){
    %>
        <option value="0"><%=SystemEnv.getHtmlLabelName(2246,user.getLanguage())%></option>
        <option value="1"><%=SystemEnv.getHtmlLabelName(2245,user.getLanguage())%></option>
        <option value="2"><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
    <%
    }else{
    rs.executeProc("workflow_SelectItemSelectByid",""+id+flag+isbill);
    while(rs.next()){
      int tmpselectvalue = rs.getInt("selectvalue");
      String tmpselectname = rs.getString("selectname");
    %>
    <option value="<%=tmpselectvalue%>"><%=Util.toScreen(tmpselectname,user.getLanguage())%></option>
    <%}
    }%>
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
          <%
            String bclick = "onShowBrowser2('"+id+"','/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp','"+type+"','"+tmpcount+"')";
          	String opchange = "changelevel($('#con"+id+"_value').val(),'"+tmpcount+"')";
          %>
          <brow:browser viewType="0" name='<%="con"+id+"_value"%>' 
            browserValue='<%=request.getParameter("con"+id+"_value")%>' 
            browserSpanValue='<%=request.getParameter("con"+id+"_name")%>' 
            browserOnClick='<%=bclick%>' hasInput="true" 
            isSingle='<%=BrowserManager.browIsSingle(type)%>' 
            hasBrowser = "true" isMustInput='1' 
            completeUrl='<%="javascript:getajaxurl(" + type + ")"%>' 
            onPropertyChange='<%=opchange%>'
            needHidden="false"> 
          </brow:browser>
         <input type="hidden" id="con<%=id%>_value" name="con<%=id%>_value" value="<%=Util.null2String(request.getParameter("con" + id + "_value"))%>"/>
         <input type="hidden" id="con<%=id%>_name" name="con<%=id%>_name"/>  
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
          <%
            String bclick = "onShowBrowser2('"+id+"','/systeminfo/BrowserMain.jsp?url=/docs/docs/MutiDocBrowser.jsp','"+type+"','"+tmpcount+"')";
          String opchange = "changelevel($('#con"+id+"_value').val(),'"+tmpcount+"')";
          %>

           <brow:browser viewType="0" name='<%="con"+id+"_value"%>' 
            browserValue='<%=request.getParameter("con"+id+"_value")%>' 
            browserSpanValue='<%=request.getParameter("con"+id+"_name")%>' 
            browserOnClick='<%=bclick%>' hasInput="true" 
            isSingle='<%=BrowserManager.browIsSingle(type)%>' 
            hasBrowser = "true" isMustInput='1' 
            completeUrl='<%="javascript:getajaxurl(" + type + ")"%>' 
            onPropertyChange='<%=opchange%>'
            needHidden="false"> 
          </brow:browser>
         <input type="hidden" id="con<%=id%>_value" name="con<%=id%>_value" value="<%=Util.null2String(request.getParameter("con" + id + "_value"))%>"/>
         <input type="hidden" id="con<%=id%>_name" name="con<%=id%>_name"/>  
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

          <%
            String bclick = "onShowBrowser2('"+id+"','/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp','"+type+"','"+tmpcount+"')";
          String opchange = "changelevel($('#con"+id+"_value').val(),'"+tmpcount+"')";
          %>

          <brow:browser viewType="0" name='<%="con"+id+"_value"%>' 
            browserValue='<%=request.getParameter("con"+id+"_value")%>' 
            browserSpanValue='<%=request.getParameter("con"+id+"_name")%>' 
            browserOnClick='<%=bclick%>' hasInput="true" 
            isSingle='<%=BrowserManager.browIsSingle(type)%>' 
            hasBrowser = "true" isMustInput='1' 
            completeUrl='<%="javascript:getajaxurl(" + type + ")"%>' 
            onPropertyChange='<%=opchange%>'
            needHidden="false"> 
          </brow:browser>
         <input type="hidden" id="con<%=id%>_value" name="con<%=id%>_value" value="<%=Util.null2String(request.getParameter("con" + id + "_value"))%>"/>
         <input type="hidden" id="con<%=id%>_name" name="con<%=id%>_name"/>  
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

          <%
            String bclick = "onShowBrowser2('"+id+"','/systeminfo/BrowserMain.jsp?url=/CRM/data/MutiCustomerBrowser.jsp','"+type+"','"+tmpcount+"')";
          String opchange = "changelevel($('#con"+id+"_value').val(),'"+tmpcount+"')";
          %>

          <brow:browser viewType="0" name='<%="con"+id+"_value"%>' 
            browserValue='<%=request.getParameter("con"+id+"_value")%>' 
            browserSpanValue='<%=request.getParameter("con"+id+"_name")%>' 
            browserOnClick='<%=bclick%>' hasInput="true" 
            isSingle='<%=BrowserManager.browIsSingle(type)%>' 
            hasBrowser = "true" isMustInput='1' 
            completeUrl='<%="javascript:getajaxurl(" + type + ")"%>' 
            onPropertyChange='<%=opchange%>'
            needHidden="false"> 
          </brow:browser>
         <input type="hidden" id="con<%=id%>_value" name="con<%=id%>_value" value="<%=Util.null2String(request.getParameter("con" + id + "_value"))%>"/>
         <input type="hidden" id="con<%=id%>_name" name="con<%=id%>_name"/>    
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
          <%
            String bclick = "onShowBrowser2('"+id+"','/systeminfo/BrowserMain.jsp?url=/proj/data/MultiProjectBrowser.jsp','"+type+"','"+tmpcount+"')";
          String opchange = "changelevel($('#con"+id+"_value').val(),'"+tmpcount+"')";
          %>

           <brow:browser viewType="0" name='<%="con"+id+"_value"%>' 
            browserValue='<%=request.getParameter("con"+id+"_value")%>' 
            browserSpanValue='<%=request.getParameter("con"+id+"_name")%>' 
            browserOnClick='<%=bclick%>' hasInput="true" 
            isSingle='<%=BrowserManager.browIsSingle(type)%>' 
            hasBrowser = "true" isMustInput='1' 
            completeUrl='<%="javascript:getajaxurl(" + type + ")"%>' 
            onPropertyChange='<%=opchange%>'
            needHidden="false"> 
          </brow:browser>
         <input type="hidden" id="con<%=id%>_value" name="con<%=id%>_value" value="<%=Util.null2String(request.getParameter("con" + id + "_value"))%>"/>
         <input type="hidden" id="con<%=id%>_name" name="con<%=id%>_name"/>  
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

          <%
            String bclick = "onShowBrowser2('"+id+"','/systeminfo/BrowserMain.jsp?url=/workflow/request/MultiRequestBrowser.jsp','"+type+"','"+tmpcount+"')";
          String opchange = "changelevel($('#con"+id+"_value').val(),'"+tmpcount+"')";
          %>

           <brow:browser viewType="0" name='<%="con"+id+"_value"%>' 
            browserValue='<%=request.getParameter("con"+id+"_value")%>' 
            browserSpanValue='<%=request.getParameter("con"+id+"_name")%>' 
            browserOnClick='<%=bclick%>' hasInput="true" 
            isSingle='<%=BrowserManager.browIsSingle(type)%>' 
            hasBrowser = "true" isMustInput='1' 
            completeUrl='<%="javascript:getajaxurl(" + type + ")"%>' 
            onPropertyChange='<%=opchange%>'
            needHidden="false"> 
          </brow:browser> 
         <input type="hidden" id="con<%=id%>_value" name="con<%=id%>_value" value="<%=Util.null2String(request.getParameter("con" + id + "_value"))%>"/>
         <input type="hidden" id="con<%=id%>_name" name="con<%=id%>_name"/>  
    </wea:item>
	    <%}
	/**if block*/
	else if(htmltype.equals("3") && type.equals("24")){//职位的安全级别
		String bclick = "onShowBrowser2('"+id+"','/systeminfo/BrowserMain.jsp?url=/hrm/jobtitles/MutiJobTitlesBrowser.jsp','"+type+"','"+tmpcount+"')";
        String opchange = "changelevel($('#con"+id+"_value').val(),'"+tmpcount+"')";
	%>
	<wea:item>
		<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90">
			<option value="1"><%=SystemEnv.getHtmlLabelName(18987,user.getLanguage())%></option>
	       <option value="2"><%=SystemEnv.getHtmlLabelName(18988,user.getLanguage())%></option>
		</select>
		<brow:browser viewType="0" name='<%="con"+id+"_value"%>' 
	       browserValue='<%=request.getParameter("con"+id+"_value")%>' 
	       browserSpanValue='<%=request.getParameter("con"+id+"_name")%>' 
	       browserOnClick='<%=bclick%>'
	       hasInput="true" 
	       isSingle='false' 
	       onPropertyChange='<%=opchange%>'
	       hasBrowser = "true" isMustInput='1' 
	       completeUrl='<%="javascript:getajaxurl(" + type + ")"%>'
	       > 
	     </brow:browser>
	     <input type="hidden" id="con<%=id%>_value" name="con<%=id%>_value" value="<%=Util.null2String(request.getParameter("con" + id + "_value"))%>"/>
         <input type="hidden" id="con<%=id%>_name" name="con<%=id%>_name"/>  
	</wea:item>
	<%}//职位安全级别end
	else if(htmltype.equals("3") && type.equals("278")){//职位的安全级别
		String bclick = "onShowBrowser2('"+id+"','/systeminfo/BrowserMain.jsp?url=/hrm/jobtitles/JobTitlesBrowser.jsp','"+type+"','"+tmpcount+"')";
        String opchange = "changelevel($('#con"+id+"_value').val(),'"+tmpcount+"')";
	 %>
	 <wea:item>
			<select class=inputstyle  name="con<%=id%>_opt" style="width:90" style="float:left;">
				<option value="1"><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
	     	<option value="2"><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
			</select>
			<brow:browser viewType="0" name='<%="con"+id+"_value"%>' 
	         browserValue='<%=request.getParameter("con"+id+"_value")%>' 
	         browserSpanValue='<%=request.getParameter("con"+id+"_name")%>' 
	         browserOnClick='<%=bclick%>'
	         hasInput="true" 
	         isSingle='true' 
	         onPropertyChange='<%=opchange%>'
	         hasBrowser = "true" isMustInput='1' 
	         completeUrl='<%="javascript:getajaxurl(" + type + ")"%>'
	         > 
	       </brow:browser>
	       <input type="hidden" id="con<%=id%>_value" name="con<%=id%>_value" value="<%=Util.null2String(request.getParameter("con" + id + "_value"))%>"/>
           <input type="hidden" id="con<%=id%>_name" name="con<%=id%>_name"/>  
	 </wea:item>
	 <%}
	/**if block*/

     /**if block*/
    else if(htmltype.equals("3") && type.equals("24")){//职位的安全级别

    %>
    <wea:item>
    <select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90"  >
    <option value="1"><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%></option>
    <option value="2"><%=SystemEnv.getHtmlLabelName(325,user.getLanguage())%></option>
    <option value="3"><%=SystemEnv.getHtmlLabelName(15509,user.getLanguage())%></option>
    <option value="4"><%=SystemEnv.getHtmlLabelName(326,user.getLanguage())%></option>
    <option value="5"><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
    <option value="6"><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
    </select>
    <%if(issimple){%><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%><%}%>
    <input type=text class=InputStyle size=10 name="con<%=id%>_value"  onblur="changelevel1(this,$G('con<%=id%>_value1'),'<%=tmpcount%>')"  value="<%=Util.null2String(request.getParameter("con" + id + "_value"))%>">
    <select class=inputstyle  name="con<%=id%>_opt1" style="<%=display%>width:90" >
    <option value="1"><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%></option>
    <option value="2"><%=SystemEnv.getHtmlLabelName(325,user.getLanguage())%></option>
    <option value="3"><%=SystemEnv.getHtmlLabelName(15509,user.getLanguage())%></option>
    <option value="4"><%=SystemEnv.getHtmlLabelName(326,user.getLanguage())%></option>
    <option value="5"><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
    <option value="6"><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
    </select>
    <%if(issimple){%><%=SystemEnv.getHtmlLabelName(15509,user.getLanguage())%><%}%>
    <input type=text class=InputStyle size=10 name="con<%=id%>_value1"  onblur="changelevel1(this,$G('con<%=id%>_value'),'<%=tmpcount%>')"  value="<%=Util.null2String(request.getParameter("con" + id + "_value1"))%>" >
    </wea:item>
    <%}//职位安全级别end
     /**if block*/
    else if(htmltype.equals("3") &&( type.equals("2") || type.equals("19"))){    //日期
    %>
    <wea:item>
    <select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90">
    <option value="1"><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%></option>
    <option value="2" selected="selected"><%=SystemEnv.getHtmlLabelName(325,user.getLanguage())%></option>
    <option value="3"><%=SystemEnv.getHtmlLabelName(15509,user.getLanguage())%></option>
    <option value="4"><%=SystemEnv.getHtmlLabelName(326,user.getLanguage())%></option>
    <option value="5"><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
    <option value="6"><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
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
    <option value="4" selected="selected"><%=SystemEnv.getHtmlLabelName(326,user.getLanguage())%></option>
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
          <select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90" >
          <option value="1"><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
          <option value="2"><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
          </select>
          <%
            String bclick = "onShowBrowser('"+id+"','/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp','"+tmpcount+"')";
          String opchange = "changelevel($('#con"+id+"_value').val(),'"+tmpcount+"')";
          %>

          <brow:browser viewType="0" name='<%="con"+id+"_value"%>' 
            browserValue='<%=request.getParameter("con"+id+"_value")%>' 
            browserSpanValue='<%=request.getParameter("con"+id+"_name")%>' 
            browserOnClick='<%=bclick%>' hasInput="true" 
            isSingle='<%=BrowserManager.browIsSingle(type)%>' 
            hasBrowser = "true" isMustInput='1' 
            completeUrl='<%="javascript:getajaxurl(" + type + ")"%>' 
            onPropertyChange='<%=opchange%>'
            needHidden="false">  
          </brow:browser>
         <input type="hidden" id="con<%=id%>_value" name="con<%=id%>_value" value="<%=Util.null2String(request.getParameter("con" + id + "_value"))%>"/>
         <input type="hidden" id="con<%=id%>_name" name="con<%=id%>_name"/>  
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
          <%
            String bclick = "onShowBrowser('"+id+"','/systeminfo/BrowserMain.jsp?url=/docs/docs/DocBrowser.jsp','"+tmpcount+"')";
          String opchange = "changelevel($('#con"+id+"_value').val(),'"+tmpcount+"')";
          %>

         <brow:browser viewType="0" name='<%="con"+id+"_value"%>' 
            browserValue='<%=request.getParameter("con"+id+"_value")%>' 
            browserSpanValue='<%=request.getParameter("con"+id+"_name")%>' 
            browserOnClick='<%=bclick%>' hasInput="true" 
            isSingle='<%=BrowserManager.browIsSingle(type)%>' 
            hasBrowser = "true" isMustInput='1' 
            completeUrl='<%="javascript:getajaxurl(" + type + ")"%>' 
            onPropertyChange='<%=opchange%>'
            needHidden="false"> 
             </brow:browser>
          <input type="hidden" id="con<%=id%>_value" name="con<%=id%>_value" value="<%=Util.null2String(request.getParameter("con" + id + "_value"))%>"/>
         <input type="hidden" id="con<%=id%>_name" name="con<%=id%>_name"/>  
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
           <%
            String bclick = "onShowBrowser('"+id+"','/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp','"+tmpcount+"')";
           String opchange = "changelevel($('#con"+id+"_value').val(),'"+tmpcount+"')";
          %>

         <brow:browser viewType="0" name='<%="con"+id+"_value"%>' 
            browserValue='<%=request.getParameter("con"+id+"_value")%>' 
            browserSpanValue='<%=request.getParameter("con"+id+"_name")%>' 
            browserOnClick='<%=bclick%>' hasInput="true" 
            isSingle='<%=BrowserManager.browIsSingle(type)%>' 
            hasBrowser = "true" isMustInput='1' 
            completeUrl='<%="javascript:getajaxurl(" + type + ")"%>' 
            onPropertyChange='<%=opchange%>'
            needHidden="false"> 
             </brow:browser>
         <input type="hidden" id="con<%=id%>_value" name="con<%=id%>_value" value="<%=Util.null2String(request.getParameter("con" + id + "_value"))%>"/>
         <input type="hidden" id="con<%=id%>_name" name="con<%=id%>_name"/>  
          
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
          <%
            String bclick = "onShowBrowser('"+id+"','/systeminfo/BrowserMain.jsp?url=/proj/data/ProjectBrowser.jsp','"+tmpcount+"')";
          String opchange = "changelevel($('#con"+id+"_value').val(),'"+tmpcount+"')";
          %>

          <brow:browser viewType="0" name='<%="con"+id+"_value"%>' 
            browserValue='<%=request.getParameter("con"+id+"_value")%>' 
            browserSpanValue='<%=request.getParameter("con"+id+"_name")%>' 
            browserOnClick='<%=bclick%>' hasInput="true" 
            isSingle='<%=BrowserManager.browIsSingle(type)%>' 
            hasBrowser = "true" isMustInput='1' 
            completeUrl='<%="javascript:getajaxurl(" + type + ")"%>' 
            onPropertyChange='<%=opchange%>'
            needHidden="false"> 
             </brow:browser>
         <input type="hidden" id="con<%=id%>_value" name="con<%=id%>_value" value="<%=Util.null2String(request.getParameter("con" + id + "_value"))%>"/>
         <input type="hidden" id="con<%=id%>_name" name="con<%=id%>_name"/>  
        
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
          <%
            String bclick = "onShowBrowser('"+id+"','/systeminfo/BrowserMain.jsp?url=/workflow/request/RequestBrowser.jsp','"+tmpcount+"')";
          String opchange = "changelevel($('#con"+id+"_value').val(),'"+tmpcount+"')";
          %>

          <brow:browser viewType="0" name='<%="con"+id+"_value"%>' 
            browserValue='<%=request.getParameter("con"+id+"_value")%>' 
            browserSpanValue='<%=request.getParameter("con"+id+"_name")%>' 
            browserOnClick='<%=bclick%>' hasInput="true" 
            isSingle='<%=BrowserManager.browIsSingle(type)%>' 
            hasBrowser = "true" isMustInput='1' 
            completeUrl='<%="javascript:getajaxurl(" + type + ")"%>' 
            onPropertyChange='<%=opchange%>'
            needHidden="false"> 
             </brow:browser>
         <input type="hidden" id="con<%=id%>_value" name="con<%=id%>_value" value="<%=Util.null2String(request.getParameter("con" + id + "_value"))%>"/>
         <input type="hidden" id="con<%=id%>_name" name="con<%=id%>_name"/>  
         
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
           <%
            String bclick = "onShowBrowser('"+id+"','/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp','"+tmpcount+"')";
           String opchange = "changelevel($('#con"+id+"_value').val(),'"+tmpcount+"')";
          %>

          <brow:browser viewType="0" name='<%="con"+id+"_value"%>' 
            browserValue='<%=request.getParameter("con"+id+"_value")%>' 
            browserSpanValue='<%=request.getParameter("con"+id+"_name")%>' 
            browserOnClick='<%=bclick%>' hasInput="true" 
            isSingle='<%=BrowserManager.browIsSingle(type)%>' 
            hasBrowser = "true" isMustInput='1' 
            completeUrl='<%="javascript:getajaxurl(" + type + ")"%>' 
            onPropertyChange='<%=opchange%>'
            needHidden="false"> 
             </brow:browser>
         <input type="hidden" id="con<%=id%>_value" name="con<%=id%>_value" value="<%=Util.null2String(request.getParameter("con" + id + "_value"))%>"/>
         <input type="hidden" id="con<%=id%>_name" name="con<%=id%>_name"/>  
   
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
          <%
            String bclick = "onShowBrowser('"+id+"','/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp','"+tmpcount+"')";
          String opchange = "changelevel($('#con"+id+"_value').val(),'"+tmpcount+"')";
          %>

         <brow:browser viewType="0" name='<%="con"+id+"_value"%>' 
            browserValue='<%=request.getParameter("con"+id+"_value")%>' 
            browserSpanValue='<%=request.getParameter("con"+id+"_name")%>' 
            browserOnClick='<%=bclick%>' hasInput="true" 
            isSingle='<%=BrowserManager.browIsSingle(type)%>' 
            hasBrowser = "true" isMustInput='1' 
            completeUrl='<%="javascript:getajaxurl(" + type + ")"%>' 
            onPropertyChange='<%=opchange%>'
            needHidden="false"> 
             </brow:browser>
         <input type="hidden" id="con<%=id%>_value" name="con<%=id%>_value" value="<%=Util.null2String(request.getParameter("con" + id + "_value"))%>"/>
         <input type="hidden" id="con<%=id%>_name" name="con<%=id%>_name"/>  
         
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
          <%
            String urls = "/systeminfo/BrowserMain.jsp?url=/docs/sendDoc/DocReceiveUnitBrowserSingle.jsp";
            String bclick = "onShowBrowser('"+id+"','"+urls+"','"+tmpcount+"')";
            String opchange = "changelevel($('#con"+id+"_value').val(),'"+tmpcount+"')";
          %>

          <brow:browser viewType="0" name='<%="con"+id+"_value"%>' 
            browserValue='<%=request.getParameter("con"+id+"_value")%>' 
            browserSpanValue='<%=request.getParameter("con"+id+"_name")%>' 
            browserOnClick='<%=bclick%>' hasInput="true" 
            isSingle='<%=BrowserManager.browIsSingle(type)%>' 
            hasBrowser = "true" isMustInput='1' 
            completeUrl='<%="javascript:getajaxurl(" + type + ")"%>' 
            onPropertyChange='<%=opchange%>'
            needHidden="false"> 
             </brow:browser>
         <input type="hidden" id="con<%=id%>_value" name="con<%=id%>_value" value="<%=Util.null2String(request.getParameter("con" + id + "_value"))%>"/>
         <input type="hidden" id="con<%=id%>_name" name="con<%=id%>_name"/>  
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
          <%
            String urls=BrowserComInfo.getBrowserurl(type);     // 浏览按钮弹出页面的url
            String bclick = "onShowBrowser('"+id+"','"+urls+"','"+tmpcount+"')";
            String opchange = "changelevel($('#con"+id+"_value').val(),'"+tmpcount+"')";
          %>

          <brow:browser viewType="0" name='<%="con"+id+"_value"%>' 
            browserValue='<%=request.getParameter("con"+id+"_value")%>' 
            browserSpanValue='<%=request.getParameter("con"+id+"_name")%>' 
            browserOnClick='<%=bclick%>' hasInput="true" 
            isSingle='<%=BrowserManager.browIsSingle(type)%>' 
            hasBrowser = "true" isMustInput='1' 
            completeUrl='<%="javascript:getajaxurl(" + type + ")"%>' 
            onPropertyChange='<%=opchange%>'
            needHidden="false">
             </brow:browser> 
         <input type="hidden" id="con<%=id%>_value" name="con<%=id%>_value" value="<%=Util.null2String(request.getParameter("con" + id + "_value"))%>"/>
         <input type="hidden" id="con<%=id%>_name" name="con<%=id%>_name"/>  
          
          </wea:item>
    <%}
     /**if block*/
    else if(htmltype.equals("3") && id.equals("_5")){//工作流浏览框
    %>
          <wea:item>
          <input type=hidden  name="con<%=id%>_opt" value="1">
          <%
            String bclick = "onShowWorkFlowSerach('workflowid','workflowspan')";
          String opchange = "changelevel($('#con"+id+"_value').val(),'"+tmpcount+"')";
          %>

          <brow:browser viewType="0" name='<%="con"+id+"_value"%>' 
            browserValue='<%=request.getParameter("con"+id+"_value")%>' 
            browserSpanValue='<%=request.getParameter("con"+id+"_name")%>' 
            browserOnClick='<%=bclick%>' hasInput="true" 
            isSingle='<%=BrowserManager.browIsSingle(type)%>' 
            hasBrowser = "true" isMustInput='1' 
            completeUrl='<%="javascript:getajaxurl(" + type + ")"%>' 
            onPropertyChange='<%=opchange%>'
            needHidden="false"> 
             </brow:browser>
         <input type="hidden" id="con<%=id%>_value" name="con<%=id%>_value" value="<%=Util.null2String(request.getParameter("con" + id + "_value"))%>"/>
         <input type="hidden" id="con<%=id%>_name" name="con<%=id%>_name"/>  
          
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
          <%
            //QC173971 在自定义集成时加上该类型的id
            //String urls = BrowserComInfo.getBrowserurl(type)+"?type="+dbtype;     // 浏览按钮弹出页面的url
            String urls = BrowserComInfo.getBrowserurl(type)+"?type="+dbtype + "|" + id;     // 浏览按钮弹出页面的url
            String bclick = "onShowBrowser('"+id+"','"+urls+"','"+tmpcount+"')";
            String opchange = "changelevel($('#con"+id+"_value').val(),'"+tmpcount+"')";
          %>

         <brow:browser viewType="0" name='<%="con"+id+"_value"%>' 
            browserValue='<%=request.getParameter("con"+id+"_value")%>' 
            browserSpanValue='<%=request.getParameter("con"+id+"_name")%>' 
            browserOnClick='<%=bclick%>' hasInput="true" 
            isSingle='<%=BrowserManager.browIsSingle(type)%>' 
            hasBrowser = "true" isMustInput='1' 
            completeUrl='<%="javascript:getajaxurl(" + type + ")"%>' 
            onPropertyChange='<%=opchange%>'
            needHidden="false"> 
             </brow:browser>
         <input type="hidden" id="con<%=id%>_value" name="con<%=id%>_value" value="<%=Util.null2String(request.getParameter("con" + id + "_value"))%>"/>
         <input type="hidden" id="con<%=id%>_name" name="con<%=id%>_name"/>  
   
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
          <%
            String urls=BrowserComInfo.getBrowserurl(type);     // 浏览按钮弹出页面的url
            String bclick = "onShowBrowser('"+id+"','"+urls+"','"+tmpcount+"')";
            String opchange = "changelevel($('#con"+id+"_value').val(),'"+tmpcount+"')";
          %>

         <brow:browser viewType="0" name='<%="con"+id+"_value"%>' 
            browserValue='<%=request.getParameter("con"+id+"_value")%>' 
            browserSpanValue='<%=request.getParameter("con"+id+"_name")%>' 
            browserOnClick='<%=bclick%>' hasInput="true" 
            isSingle='<%=BrowserManager.browIsSingle(type)%>' 
            hasBrowser = "true" isMustInput='1' 
            completeUrl='<%="javascript:getajaxurl(" + type + ")"%>' 
            onPropertyChange='<%=opchange%>'
            needHidden="false">
             </brow:browser> 
         <input type="hidden" id="con<%=id%>_value" name="con<%=id%>_value" value="<%=Util.null2String(request.getParameter("con" + id + "_value"))%>"/>
         <input type="hidden" id="con<%=id%>_name" name="con<%=id%>_name"/>  
          </wea:item>
    <%} 
     /**if block*/
    else if (htmltype.equals("6")){   //附件上传同多文挡
    %>
    <wea:item>
    <select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90"   >
    <option value="1"><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
    <option value="2"><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
    </select>
    <%
      String bclick = "onShowBrowser('"+id+"','/systeminfo/BrowserMain.jsp?url=/docs/docs/DocBrowser.jsp?isworkflow=1','"+tmpcount+"')";
    String opchange = "changelevel($('#con"+id+"_value').val(),'"+tmpcount+"')";
    %>
    <brow:browser viewType="0" name='<%="con"+id+"_value"%>' 
        browserValue='<%=request.getParameter("con"+id+"_value")%>' 
        browserSpanValue='<%=request.getParameter("con"+id+"_name")%>' 
        browserOnClick='<%=bclick%>' hasInput="true" 
        isSingle='<%=BrowserManager.browIsSingle(type)%>' 
        hasBrowser = "true" isMustInput='1' 
        completeUrl='<%="javascript:getajaxurl(" + type + ")"%>' 
        onPropertyChange='<%=opchange%>'
        needHidden="false"> 
         </brow:browser>
     <input type="hidden" id="con<%=id%>_value" name="con<%=id%>_value" value="<%=Util.null2String(request.getParameter("con" + id + "_value"))%>"/>
     <input type="hidden" id="con<%=id%>_name" name="con<%=id%>_name"/>  
    
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
    }
  });
</script>
