<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WFManager" class="weaver.workflow.workflow.WFManager" scope="session"/>
<jsp:useBean id="FormComInfo" class="weaver.workflow.form.FormComInfo" scope="page" />
<jsp:useBean id="BillComInfo" class="weaver.workflow.workflow.BillComInfo" scope="page" />
<jsp:useBean id="FieldComInfo" class="weaver.workflow.field.FieldComInfo" scope="page" />
<jsp:useBean id="FormFieldMainManager" class="weaver.workflow.form.FormFieldMainManager" scope="page" />
<%FormFieldMainManager.resetParameter();%>
<jsp:useBean id="WFNodeMainManager" class="weaver.workflow.workflow.WFNodeMainManager" scope="page" />
<%WFNodeMainManager.resetParameter();%>
<jsp:useBean id="WFNodeFieldMainManager" class="weaver.workflow.workflow.WFNodeFieldMainManager" scope="page" />
<%WFNodeFieldMainManager.resetParameter();%>
<jsp:useBean id="WFNodeDtlFieldManager" class="weaver.workflow.workflow.WFNodeDtlFieldManager" scope="page" />
<%WFNodeDtlFieldManager.resetParameter();%>
<jsp:useBean id="WorkTypeComInfo" class="weaver.workflow.workflow.WorkTypeComInfo" scope="page" />
<jsp:useBean id="DocChangeManager" class="weaver.docs.change.DocChangeManager" scope="page" />
<%
    String ajax=Util.null2String(request.getParameter("ajax"));
	int design = Util.getIntValue(request.getParameter("design"),0);
	
	if(!HrmUserVarify.checkUserRight("DocChange:Setting", user)){
		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
	String isclose = Util.null2String(request.getParameter("isclose"));
	String isDialog = Util.null2String(request.getParameter("isdialog"));
%>
<html>
<%
	boolean isChangeField = DocChangeManager.isChangeField;//是否交换流程字段
	isChangeField = true;
	String view = "disabled";
	boolean isEdit = Util.null2String(request.getParameter("isEdit")).equals("1");  
	String wfname="";
	String wfdes="";
	String title="";
	String isbill = "";
	String iscust = "";
	int wfid=0;
	int formid=0;
	int nodeid=-1;
	wfid=Util.getIntValue(Util.null2String(request.getParameter("wfid")),0);
	nodeid=Util.getIntValue(Util.null2String(request.getParameter("nodeid")),-1);
	int changeid = Util.getIntValue(Util.null2String(request.getParameter("docchangeid")),-1);
    String nodename="";
    String nodetype="";
    String modetype="";
    int printdes=0;
    int showdes=0;
    int viewtypeall=0;
    int viewdescall=0;
    int showtype=0;
    int vtapprove=0;
    int vtrealize=0;
    int vtforward=0;
    int vtpostil=0;
    int vtrecipient=0;
    int vtreject=0;
    int vtsuperintend=0;
    int vtover=0;
    int vdcomments=0;
    int vddeptname=0;
    int vdoperator=0;
    int vddate=0;
    int vdtime=0;
    int stnull=0;
    //获取当前版本的字段信息
    String version = "1";
    RecordSet.executeSql("SELECT max(version) FROM DocChangeWfField WHERE workflowid="+wfid);
    if(RecordSet.next()) {
    	version = Util.null2String(RecordSet.getString(1)); 
    }
    if(version.equals("")) {
    	isEdit = true;
    	version = "1";
    }
    if(isEdit) view = "";
    Map fieldsMap = new HashMap();
    RecordSet.executeSql("SELECT * FROM DocChangeWfField WHERE workflowid="+wfid+" AND version="+version);
    while(RecordSet.next()){
    	fieldsMap.put(RecordSet.getInt("fieldid")+"",RecordSet.getInt("isChange")+","+RecordSet.getInt("isCompany"));
    }
    RecordSet.executeSql("select a.*,b.nodename from workflow_flownode a,workflow_nodebase b where (b.IsFreeNode is null or b.IsFreeNode!='1') and b.id=a.nodeid and a.workflowid="+wfid+" and a.nodetype='3'");
    if(RecordSet.next()){
        nodetype=RecordSet.getString("nodetype");
        nodename=RecordSet.getString("nodename");
        nodeid = RecordSet.getInt("nodeid");
        modetype="0";//Util.null2String(RecordSet.getString("ismode"));
        showdes=Util.getIntValue(Util.null2String(RecordSet.getString("showdes")),0);
        printdes=Util.getIntValue(Util.null2String(RecordSet.getString("printdes")),0);
        viewtypeall=Util.getIntValue(Util.null2String(RecordSet.getString("viewtypeall")),0);
        viewdescall=Util.getIntValue(Util.null2String(RecordSet.getString("viewdescall")),0);
        showtype=Util.getIntValue(Util.null2String(RecordSet.getString("showtype")),0);
        vtapprove=Util.getIntValue(Util.null2String(RecordSet.getString("vtapprove")),0);
        vtrealize=Util.getIntValue(Util.null2String(RecordSet.getString("vtrealize")),0);
        vtforward=Util.getIntValue(Util.null2String(RecordSet.getString("vtforward")),0);
        vtpostil=Util.getIntValue(Util.null2String(RecordSet.getString("vtpostil")),0);
        vtrecipient=Util.getIntValue(Util.null2String(RecordSet.getString("vtrecipient")),0);
        vtreject=Util.getIntValue(Util.null2String(RecordSet.getString("vtreject")),0);
        vtsuperintend=Util.getIntValue(Util.null2String(RecordSet.getString("vtsuperintend")),0);
        vtover=Util.getIntValue(Util.null2String(RecordSet.getString("vtover")),0);
        vdcomments=Util.getIntValue(Util.null2String(RecordSet.getString("vdcomments")),0);
        vddeptname=Util.getIntValue(Util.null2String(RecordSet.getString("vddeptname")),0);
        vdoperator=Util.getIntValue(Util.null2String(RecordSet.getString("vdoperator")),0);
        vddate=Util.getIntValue(Util.null2String(RecordSet.getString("vddate")),0);
        vdtime=Util.getIntValue(Util.null2String(RecordSet.getString("vdtime")),0);
        stnull=Util.getIntValue(Util.null2String(RecordSet.getString("stnull")),0);
    }
	title="edit";
	WFManager.setWfid(wfid);
	WFManager.getWfInfo();
	wfname=WFManager.getWfname();
	wfdes=WFManager.getWfdes();
	formid = WFManager.getFormid();
	isbill = WFManager.getIsBill();
	iscust = WFManager.getIsCust();
	int typeid = 0;
	typeid = WFManager.getTypeid();

    //add by mackjoe at 2005-12-16
    //显示类型

    //如果表单中设定了模板，节点自动引用表单模板
    String showmode="";
    String printmode="";
    int showmodeid=0;
    int printmodeid=0;
    int showisform=0;
    int printisform=0;
    int isprint=0;
    int tempshowmodeid=0;
    String tempshowmdoe="";
    RecordSet.executeSql("select id,isprint,modename from workflow_nodemode where workflowid="+wfid+" and nodeid="+nodeid);
    while(RecordSet.next()){
        isprint=RecordSet.getInt("isprint");
        if(isprint==0){
            showmodeid=RecordSet.getInt("id");
            showmode=RecordSet.getString("modename");
            //printmodeid=showmodeid;
            //printmode=showmode;
        }else{
            if(isprint==1){
                printmodeid=RecordSet.getInt("id");
                printmode=RecordSet.getString("modename");
            }
        }
    }
    RecordSet.executeSql("select id,isprint,modename from workflow_formmode where formid="+formid+" and isbill="+isbill);
    while(RecordSet.next()){
        isprint=RecordSet.getInt("isprint");
        if(isprint==0){
            tempshowmodeid=RecordSet.getInt("id");
            tempshowmdoe=RecordSet.getString("modename");
            if(showmodeid<1 && showdes==0){
                showmodeid=tempshowmodeid;
                showmode=tempshowmdoe;
                showisform=1;
            }
        }else{
            if(printmodeid<1 && isprint==1 && printdes==0){
                printmodeid=RecordSet.getInt("id");
                printmode=RecordSet.getString("modename");
                printisform=1;
            }
        }
    }
    if(tempshowmodeid>0 && printmodeid<1 && printdes==0){
        printmodeid=tempshowmodeid;
        printmode=tempshowmdoe;
        printisform=1;
    }

    //end by mackjoe
%>
<head>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language=javascript >
	var parentWin = null;
	var dialog = null;
	try{
		parentWin = parent.parent.getParentWindow(parent);
		dialog = parent.parent.getDialog(parent);
		<%if(isclose.equals("1")){%>
			dialog.close();
		<%}%>
	}catch(e){}
</script>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(23025,user.getLanguage());
String needfav ="";
String needhelp ="";
%>
</head>

<body>
<%if("1".equals(isDialog)){ %>
<div class="zDialog_div_content">
<%} %>
<%
if(design==0) {
%>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%
}
%>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(!isEdit) {
	RCMenu += "{"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+",javascript:doEdit(this),_self} " ;
	RCMenuHeight += RCMenuHeightStep;
}
else {
	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave(this),_self} " ;
	RCMenuHeight += RCMenuHeightStep;
}
if(!"1".equals(isDialog)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:doReturn(this),_self} " ;
RCMenuHeight += RCMenuHeightStep;
}
%>
<%
if(!ajax.equals("1")){
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<%}else{%>
<%@ include file="/systeminfo/RightClickMenu1.jsp" %>
<%}%>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td></td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<%
			if(!isEdit) {
			%>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(93 ,user.getLanguage()) %>" class="e8_btn_top" onclick="doEdit(this)"/>
			<%}else { %>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86 ,user.getLanguage()) %>" class="e8_btn_top" onclick="doSave(this)"/>
			<%} %>
			<span title="<%=SystemEnv.getHtmlLabelName(23036 ,user.getLanguage()) %>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<form id="frmmain" name="frmmain" method=post action="DocChangeFieldOperation.jsp" >
<input type="hidden" value="<%=design%>" name="design">
<%if(ajax.equals("1")){%>
<input type=hidden name=ajax value="1">
<%}%>
<wea:layout attributes="{'expandAllGroup':'true'}">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>' attributes="{'samePair':'BaseSetInfo','groupOperDisplay':'none'}">
		<%if(!ajax.equals("1")){%>
			<wea:item><%=SystemEnv.getHtmlLabelName(19587,user.getLanguage())%></wea:item>
	       <wea:item><%=version%></wea:item>
		   <wea:item><%=SystemEnv.getHtmlLabelName(23753,user.getLanguage())%></wea:item>
	       <wea:item><%=wfname%></wea:item>
	  	   <wea:item><%=SystemEnv.getHtmlLabelName(16579,user.getLanguage())%></wea:item>
		    <wea:item><%=WorkTypeComInfo.getWorkTypename(""+typeid)%></wea:item>
		    <wea:item><%=SystemEnv.getHtmlLabelName(15600,user.getLanguage())%></wea:item>
		    <%if(isbill.equals("0")){%>
		    <wea:item><%=FormComInfo.getFormname(""+formid)%></wea:item>
		    <%}
		    else if(isbill.equals("1")){
		    	int labelid = Util.getIntValue(BillComInfo.getBillLabel(""+formid));
		    %>
		    <wea:item><%=SystemEnv.getHtmlLabelName(labelid,user.getLanguage())%></wea:item>
		    <%}else{%>
		    <wea:item></wea:item>
		    <%}%>
		<%}%>
	</wea:group>
</wea:layout>
<wea:layout>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(33487,user.getLanguage())%>' attributes="{'samePair':'DetailSetInfo','groupOperDisplay':'none'}">
		<wea:item attributes="{'colspan':'full','isTableList':'true'}">
<%if(!ajax.equals("1")){%>
<script>
function change(thisele) {
	var modeid= thisele.value;
    if(modeid=="1"){
        //odiv.style.display="none";
        //tdiv.style.display='';
        oDivOfAddWfNodeField.style.display="none";
        tDivOfAddWfNodeField.style.display='';
    }else{
        //odiv.style.display='';
        //tdiv.style.display="none";
        oDivOfAddWfNodeField.style.display='';
        tDivOfAddWfNodeField.style.display="none";
    }

}
</script>
<%}%>
<div id="oDivOfAddWfNodeField" <%if(modetype.equals("1")){%>style='display:none'<%}%>>
  <table class=ListStyle cellspacing=1 id="tab_dtl_list-1">
    <COLGROUP>
	<%if(isChangeField){%>
  	<COL width="50%">
  	<COL width="25%">
  	<COL width="25%">
	<%}else{%>
  	<COL width="70%">
  	<COL width="30%">
	<%}%>
<tr class=header>
            <td>
				<%=SystemEnv.getHtmlLabelName(685,user.getLanguage())%>
			</td>
			<%if(isChangeField){%>
            <td>
				<input type="checkbox" name="title_viewall" <%=view%> onclick="selectAll(this,'fieldid_node','tab_dtl_list-1');">
				<%=SystemEnv.getHtmlLabelName(23027,user.getLanguage())%>
			</td>
			<%}%>
            <td>
				<input type="checkbox" name="title_editall" <%=view%> onclick="selectAll(this,'fieldid_change','tab_dtl_list-1');">
				<%=SystemEnv.getHtmlLabelName(23026,user.getLanguage())%>
			</td>
</tr>

<!--xwj for td1834 on 2005-05-18  begin -->
<%
  int linecolor=0;
  if(nodeid!=-1 && isChangeField){
     boolean isCreateNode = false;
     //RecordSet.executeSql("select * from workflow_flownode where workflowid=" + String.valueOf(wfid) + " and nodetype = '0' and nodeid = " + String.valueOf(nodeid));
     if(nodetype.equals("0")){
     isCreateNode = true;
     }
	   WFNodeFieldMainManager.resetParameter();
	   WFNodeFieldMainManager.setNodeid(nodeid);
	   WFNodeFieldMainManager.setFieldid(-1);//"说明"字段在workflow_nodeform中的fieldid 定为 "-1"
	   WFNodeFieldMainManager.selectWfNodeField();
	%>
	 <tr <%if(linecolor==0){%> class=DataLight <%} else {%> class=DataDark <%}%> >
	    <td><%=SystemEnv.getHtmlLabelName(21192,user.getLanguage())%></td>
            <td><input type="checkbox" name="fieldid_node" <%=view%> <%if(fieldsMap.get("-1")!=null){out.print("checked");}%> value="-1"></td>
            <td></td>
  </tr>
	 <%
   if(linecolor==0) {
   linecolor=1;
   }
   else{
   linecolor=0;
   }

    WFNodeFieldMainManager.closeStatement();
}
  if(nodeid!=-1 && isChangeField){
     boolean isCreateNode = false;
     if(nodetype.equals("0")){
     isCreateNode = true;
     }
	   String edit="";
	   String man="";
	   WFNodeFieldMainManager.resetParameter();
	   WFNodeFieldMainManager.setNodeid(nodeid);
	   WFNodeFieldMainManager.setFieldid(-2);//"紧急程度"字段在workflow_nodeform中的fieldid 定为 "-2"
	   WFNodeFieldMainManager.selectWfNodeField();
	%>
	 <tr <%if(linecolor==0){%> class=DataLight <%} else {%> class=DataDark <%}%> >
	    <td><%=SystemEnv.getHtmlLabelName(15534,user.getLanguage())%></td>
            <td><input type="checkbox" name="fieldid_node" <%=view%> <%if(fieldsMap.get("-2")!=null){out.print("checked");}%> value="-2"></td>
            <td></td>
  </tr>
	 <%
   if(linecolor==0) {
   linecolor=1;
   }
   else{
   linecolor=0;
   }

    WFNodeFieldMainManager.closeStatement();
}
String messageType = WFManager.getMessageType();
  if(nodeid!=-1&&messageType.equals("1") && isChangeField){
     boolean isCreateNode = false;
     if(nodetype.equals("0")){
     isCreateNode = true;
     }
	   WFNodeFieldMainManager.resetParameter();
	   WFNodeFieldMainManager.setNodeid(nodeid);
	   WFNodeFieldMainManager.setFieldid(-3);//"是否短信提醒"字段在workflow_nodeform中的fieldid 定为 "-3"
	   WFNodeFieldMainManager.selectWfNodeField();
	%>
	 <tr <%if(linecolor==0){%> class=DataLight <%} else {%> class=DataDark <%}%> >
	    <td><%=SystemEnv.getHtmlLabelName(17582,user.getLanguage())%></td>
            <td><input type="checkbox" name="fieldid_node" value="-3" <%if(fieldsMap.get("-3")!=null){out.print("checked");}%> <%=view%> onClick="if(this.checked==false){document.nodefieldform.ismessage_edit.checked=false;document.nodefieldform.ismessage_man.checked=false;}" disabled ></td>
            <td></td>
  </tr>
	 <%
   if(linecolor==0) {
   linecolor=1;
   }
   else{
   linecolor=0;
   }
   WFNodeFieldMainManager.closeStatement();
  }
%>
<!--xwj for td1834 on 2005-05-18  end -->

<%
if(nodeid!=-1 && isbill.equals("0")){
//int linecolor=0; xwj for td1834 on 2005-05-18
FormFieldMainManager.setFormid(formid);
FormFieldMainManager.selectFormFieldLable();
int groupid=-1;
String dtldisabled="";
while(FormFieldMainManager.next()){
	int curid=FormFieldMainManager.getFieldid();
    String fieldname=FieldComInfo.getFieldname(""+curid);
	//if (fieldname.equals("manager")) continue;//字段为“manager”这个字段是程序后台所用，不必做必填之类的设置!
	String fieldhtmltype = FieldComInfo.getFieldhtmltype(""+curid);
	String fieldtype = FieldComInfo.getFieldType(""+curid);
	String ckChange = "";
	String ckCompany = "";
	String fdstr = Util.null2String((String)fieldsMap.get(curid+"")); 
	if(!isChangeField) {
		if(!Util.null2String(fieldtype).equals("142")) continue;//不交换流程字段的普通字段不显示
	}
	if(fdstr.indexOf("1,")!=-1)	ckChange = "checked";
	if(fdstr.indexOf(",1")!=-1)	ckCompany = "checked";
	
	String curlable = FormFieldMainManager.getFieldLable();
	 
    int curgroupid=FormFieldMainManager.getGroupid();
    //表单头group值为－1，会引起拼装checkbox语句的脚本错误，这里简单的处理为999
    if(curgroupid==-1) curgroupid=999;
    String isdetail = FormFieldMainManager.getIsdetail();
	WFNodeFieldMainManager.resetParameter();
	WFNodeFieldMainManager.setNodeid(nodeid);
	WFNodeFieldMainManager.setFieldid(curid);
	WFNodeFieldMainManager.selectWfNodeField();
    if(isdetail.equals("1") && curgroupid>groupid) {
        groupid=curgroupid;

        WFNodeDtlFieldManager.setNodeid(nodeid);
        WFNodeDtlFieldManager.setGroupid(curgroupid);
        WFNodeDtlFieldManager.selectWfNodeDtlField();
        String dtladd = WFNodeDtlFieldManager.getIsadd();
            if(dtladd.equals("1")) dtladd=" checked";
        String dtledit = WFNodeDtlFieldManager.getIsedit();
            if(dtledit.equals("1")) dtledit=" checked";
        String dtldelete = WFNodeDtlFieldManager.getIsdelete();
            if(dtldelete.equals("1")) dtldelete=" checked";
        String dtlhide = WFNodeDtlFieldManager.getIshide();
            if(dtlhide.equals("1")) dtlhide=" checked";
        if(!dtladd.equals(" checked") && !dtledit.equals(" checked")) 
            dtldisabled="disabled";
        else
            dtldisabled="";
        %>
        </table>
        <table class=ViewForm cellspacing=1 id="tab_dtl_<%=groupid%>" name="tab_dtl_'<%=groupid%>'">
            <COLGROUP>
            <COL width="20%">
            <COL width="80%">
            <tr>
                <td class=field colSpan=2><strong><%=SystemEnv.getHtmlLabelName(19325,user.getLanguage())%><%=groupid+1%><strong></td>
            </tr>    
            <TR><TD class="Line1" colSpan=2></TD></TR>
            </table>
            <table class=ListStyle cellspacing=1 id="tab_dtl_list<%=groupid%>" name="tab_dtl_list<%=groupid%>">
            <COLGROUP>
			<%if(isChangeField){%>
            <COL width="50%">
            <COL width="25%">
            <COL width="25%">
			<%}else{%>
		  	<COL width="70%">
		  	<COL width="30%">
			<%}%>
            <tr class=header>
                <td><%=SystemEnv.getHtmlLabelName(685,user.getLanguage())%></td>
			<%if(isChangeField){%>
            <td>
				<input type="checkbox" name="title_viewall" <%=view%> onclick="selectAll(this,'fieldid_node','tab_dtl_list<%=groupid%>');">
				<%=SystemEnv.getHtmlLabelName(23027,user.getLanguage())%>
			</td>
			<%}%>
            <td>
				<input type="checkbox" name="title_editall" <%=view%> onclick="selectAll(this,'fieldid_change','tab_dtl_list<%=groupid%>');">
				<%=SystemEnv.getHtmlLabelName(23026,user.getLanguage())%>
			</td>
            </tr>
        <%
    }
%>
 <tr <%if(linecolor==0){%> class=DataLight <%} else {%> class=DataDark <%}%> >

	    <td><%=Util.toScreen(curlable,user.getLanguage())%></td>
        <%if(isChangeField){%><td><input type="checkbox" onclick="<%=fieldtype.equals("142")?"check_fieldid_change(this)":"" %>" name="fieldid_node" value="<%=curid%>" <%=ckChange%> <%=view%>></td><%}%>
        <td><%if(fieldtype.equals("142")){%><input type="checkbox" name="fieldid_change" value="<%=curid%>" <%=ckCompany%> <%=view%>><%}%></td>
</tr>
<%
 if(linecolor==0) linecolor=1;
          else linecolor=0;
}
FormFieldMainManager.closeStatement();
}
else if(nodeid!=-1 && isbill.equals("1")){
//int linecolor=0; xwj for td1834 on 2005-05-18

boolean isNewForm = false;//是否是新表单 modify by myq for TD8730 on 2008.9.12
RecordSet.executeSql("select tablename from workflow_bill where id = "+formid);
if(RecordSet.next()){
	String temptablename = Util.null2String(RecordSet.getString("tablename"));
	if(temptablename.equals("formtable_main_"+formid*(-1))) isNewForm = true;
}

String sql = "select * from workflow_billfield where billid = "+formid +" order by viewtype,detailtable,dsporder ";
RecordSet.executeSql(sql);
String predetailtable=null;
int groupid=0;
String dtldisabled="";
while(RecordSet.next()){
	String fieldhtmltype = RecordSet.getString("fieldhtmltype");
	String fieldtype = RecordSet.getString("type");
	int curid=RecordSet.getInt("id");
	int curlabel = RecordSet.getInt("fieldlabel");
	int viewtype = RecordSet.getInt("viewtype");
	String detailtable = Util.null2String(RecordSet.getString("detailtable"));
	//判断是否选中
	String ckChange = "";
	String ckCompany = "";
	String fdstr = Util.null2String((String)fieldsMap.get(curid+"")); 
	if(!isChangeField) {
		if(!Util.null2String(fieldtype).equals("142")) continue;//不交换流程字段的普通字段不显示
	}
	
	if(fdstr.indexOf("1,")!=-1)	ckChange = "checked";
	if(fdstr.indexOf(",1")!=-1)	ckCompany = "checked";

	WFNodeFieldMainManager.resetParameter();
	WFNodeFieldMainManager.setNodeid(nodeid);
	WFNodeFieldMainManager.setFieldid(curid);
	WFNodeFieldMainManager.selectWfNodeField();
    if(viewtype==1 && !detailtable.equals(predetailtable)){
        groupid++;
        WFNodeDtlFieldManager.setNodeid(nodeid);
        WFNodeDtlFieldManager.setGroupid(groupid-1);
        WFNodeDtlFieldManager.selectWfNodeDtlField();
        String dtladd = WFNodeDtlFieldManager.getIsadd();
            if(dtladd.equals("1")) dtladd=" checked";
        String dtledit = WFNodeDtlFieldManager.getIsedit();
            if(dtledit.equals("1")) dtledit=" checked";
        String dtldelete = WFNodeDtlFieldManager.getIsdelete();
            if(dtldelete.equals("1")) dtldelete=" checked";
        String dtlhide = WFNodeDtlFieldManager.getIshide();
            if(dtlhide.equals("1")) dtlhide=" checked";
        predetailtable=detailtable;
        if((formid==156 || formid==157 || formid==158 || isNewForm) && !dtladd.equals(" checked") && !dtledit.equals(" checked"))
            dtldisabled="disabled";
        else
            dtldisabled="";
        %>
        </table>
        <%if(isNewForm){%>
        <!--table class=viewform cellspacing=1 id="tab_dtl_<%=groupid%>" name="tab_dtl_'<%=groupid%>'">
            <COLGROUP>
            <COL width="20%">
            <COL width="80%">
            <tr>
                <td class=field colSpan=2><strong><%=SystemEnv.getHtmlLabelName(19325,user.getLanguage())%><%=groupid%><strong></td>
            </tr>
            <%}%>
            <% if(formid==156 || formid==157 || formid==158){%>    
            <tr>
                <td><%=SystemEnv.getHtmlLabelName(19394,user.getLanguage())%></td>
                <td class=field><input type="checkbox" name="dtl_add_<%=groupid%>" onClick="checkChange('<%=String.valueOf(groupid)%>')" <%if(nodetype.equals("3")){%>disabled<%}else{%> <%=dtladd%><%}%>></td>
            </tr>
            <tr>
                <td><%=SystemEnv.getHtmlLabelName(19395,user.getLanguage())%></td>
                <td class=field><input type="checkbox" name="dtl_edit_<%=groupid%>" onClick="checkChange('<%=String.valueOf(groupid)%>')" <%if(nodetype.equals("3")){%>disabled<%}else{%> <%=dtledit%><%}%>></td>
            </tr>
            <tr>
                <td><%=SystemEnv.getHtmlLabelName(19396,user.getLanguage())%></td>
                <td class=field><input type="checkbox" name="dtl_del_<%=groupid%>" onClick="" <%if(nodetype.equals("3")){%>disabled<%}else{%> <%=dtldelete%><%}%>></td>
            </tr>
            <%}%>
            <TD colspan="2">
            <table class=ListStyle cellspacing=1 id="tab_dtl_list<%=groupid%>" >
            <COLGROUP>
			<%if(isChangeField){%>
            <COL width="50%">
            <COL width="25%">
            <COL width="25%">
			<%}else{%>
		  	<COL width="70%">
		  	<COL width="30%">
			<%}%>
            <tr class=header>
                <td><%=SystemEnv.getHtmlLabelName(685,user.getLanguage())%></td>
				<%if(isChangeField){%>
                <td>
					<input type="checkbox" name="node_viewall_g" <%=view%> onclick="selectAll(this,'fieldid_node','tab_dtl_list<%=groupid%>');">
					<%=SystemEnv.getHtmlLabelName(23027,user.getLanguage())%>
				</td>
				<%}%>
                <td>
					<input type="checkbox" name="node_editall_g" <%=view%> onclick="selectAll(this,'fieldid_change','tab_dtl_list<%=groupid%>');">
					<%=SystemEnv.getHtmlLabelName(23026,user.getLanguage())%>
				</td>
            </tr>
        <%

    }
%>
 <tr <%if(linecolor==0){%> class=DataLight <%} else {%> class=DataDark <%}%> >
	    <td><%=SystemEnv.getHtmlLabelName(curlabel,user.getLanguage())%></td>
        <%if(isChangeField){%><td><input type="checkbox"  onclick="<%=fieldtype.equals("142")?"check_fieldid_change(this)":"" %>" name="fieldid_node" value="<%=curid%>" <%=view%> <%=ckChange%>></td><%}%>
        <td><%if(fieldtype.equals("142")){%><input type="checkbox" name="fieldid_change" value="<%=curid%>" <%=ckCompany%> <%=view%>><%}%></td>
</tr>
<%
 if(linecolor==0) linecolor=1;
          else linecolor=0;
}
}
%>
</table>
</TD>
</table-->
</div>
</wea:item>
</wea:group>
</wea:layout>
<br>
<center>
<input type="hidden" value="wfnodefield" name="src">
  <input type="hidden" value="<%if(isEdit){%>1<%}else{%>0<%}%>" name="isEdit">
	<input type="hidden" value="<%=wfid%>" name="wfid">
  <input type="hidden" value="<%=nodeid%>" name="nodeid">
  <input type="hidden" value="<%=changeid%>" name="changeid">
</center>
</form>
<%if("1".equals(isDialog)){ %>
	</div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout needImportDefaultJsAndCss="false">
			<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
				<wea:item type="toolbar">
			    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.closeByHand()">
				</wea:item>
			</wea:group>
		</wea:layout>
	</div>
	<script type="text/javascript">
		jQuery(document).ready(function(){
			resizeDialog(document);
		});
	</script>
<%} %>
</body>

</html>
<script>
function doSave(mobj) {
	var fieldid_changes = jQuery("#oDivOfAddWfNodeField").find("input[name='fieldid_change']:checked");
	if(fieldid_changes.length>0){
		document.frmmain.submit();
		mobj.disabled = true;
	}else{
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(33489,user.getLanguage())%>");
	}
}

function doReturn(mobj) {
	location.href = '/docs/change/DocChangeSetting.jsp';
}

function doEdit(mobj) {
	document.frmmain.isEdit.value = '1';
	document.frmmain.action = location.href;
	document.frmmain.submit();
	mobj.disabled = true;
}
function check_fieldid_change(obj){
	var checked = jQuery(obj).attr("checked");
	if(!!checked){
		var change = jQuery(obj).closest("tr").children("td").eq(2).find("input[type='checkbox']");
		changeCheckboxStatus(change,checked);
	}
}

function selectAll(obj,objname,tbid) {
	var flag = obj.checked;
	var fields = document.getElementById(tbid).getElementsByTagName('INPUT');
	for(i=0; i<fields.length; i++) {
		if(fields[i].type=='checkbox' && fields[i].name==objname)
			fields[i].checked = flag;
			try
			{
				if(fields[i].checked)
					jQuery(fields[i].nextSibling).addClass("jNiceChecked");
				else
					jQuery(fields[i].nextSibling).removeClass("jNiceChecked");
			}
			catch(e)
			{
			}
	}
}
</script>
