<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.system.code.*"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/WEB-INF/tld/browser.tld" prefix="brow"%>
<%@ page import="weaver.workflow.workflow.UserWFOperateLevel" %>
<%@ page import="weaver.workflow.workflow.WfRightManager" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WFManager" class="weaver.workflow.workflow.WFManager" scope="session"/>
<jsp:useBean id="FieldComInfo" class="weaver.workflow.field.FieldComInfo" scope="page" />
<jsp:useBean id="wfrm" class="weaver.workflow.workflow.WfRightManager" scope="page" />
<%
    String ajax=Util.null2String(request.getParameter("ajax"));
	boolean canEdit=true;
	int wfid=Util.getIntValue(Util.null2String(request.getParameter("wfid")),0);
	String rightStr = "FLOWCODE:All";
	if (!HrmUserVarify.checkUserRight(rightStr, user)) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
%>
<%@ include file="/workflow/workflow/addwf_checktetachable.jsp" %>
<html>
<%
	String isbill = "";
	int formid=0;
	String sql="";
	WFManager.setWfid(wfid);
	WFManager.getWfInfo();
	formid = WFManager.getFormid();
	isbill = WFManager.getIsBill();
    int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
    int subCompanyId= -1;
    int operatelevel=0;

    if(detachable == 1){
        subCompanyId =  WFManager.getSubCompanyId2();
    }
    boolean haspermission = wfrm.hasPermission3(wfid, 0, user, WfRightManager.OPERATION_CREATEDIR);
    operatelevel = UserWFOperateLevel.checkUserWfOperateLevel(detachable,subCompanyId,user,haspermission,"WorkflowManage:All");
  
	if (isbill.equals("0")){
		sql="select workflow_formfield.fieldid, workflow_fieldlable.fieldlable from workflow_formfield,workflow_fieldlable where workflow_formfield.fieldid=workflow_fieldlable.fieldid and workflow_fieldlable.formid=workflow_formfield.formid  and workflow_fieldlable.formid="+formid+" and (workflow_formfield.isdetail<>'1' or workflow_formfield.isdetail is null) and langurageid="+user.getLanguage();
	}else{
		sql="select id,fieldlabel from workflow_billfield where viewtype=0 and type='1' and fieldhtmltype='1' and billid="+formid;
	}
	//初始值

  //CodeBuild cbuild = new CodeBuild(formid); 
  //CodeBuild cbuild = new CodeBuild(formid,isbill);
  CodeBuild cbuild = new CodeBuild(formid,isbill,wfid);  
  boolean hasHistoryCode=cbuild.hasHistoryCode(RecordSet,wfid);
  CoderBean cbean = cbuild.getFlowCBuild();
  ArrayList coderMemberList = cbean.getMemberList();
  String isUse =  cbean.getUserUse();
  String fieldSequenceAlone =  cbean.getFieldSequenceAlone();
  String workflowSeqAlone =  cbean.getWorkflowSeqAlone();
  String dateSeqAlone =  cbean.getDateSeqAlone();
  String dateSeqselect =  cbean.getDateSeqSelect();
  String struSeqAlone =  cbean.getStruSeqAlone();
  String struSeqselect =  cbean.getStruSeqSelect();  
  String correspondField =  cbean.getCorrespondField();  
  String correspondDate =  cbean.getCorrespondDate(); 
  
  String selectCorrespondField = cbean.getSelectCorrespondField();
  
  List struSeqselectList = new ArrayList();
  //System.out.println("correspondField = "+correspondField);
  //System.out.println("correspondDate = "+correspondDate);
  //判断是否是E8新版保存
  boolean isE8Save = false;
  boolean isWorkflowSeqAlone=cbuild.isWorkflowSeqAlone(RecordSet,wfid);
  String E8sql = "select * from workflow_codeRegulate where concreteField  = '8' ";
  if(isWorkflowSeqAlone){
      E8sql += " and workflowId="+wfid;
  }else{
      E8sql += " and formId="+formid+" and isBill='"+isbill+"'";     
  }
  RecordSet.execute(E8sql);
  while(RecordSet.next()){
	  isE8Save = true;
  }
  //end
%>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(259,user.getLanguage());
String needfav ="";
String needhelp ="";
%>
<head>
<link href="/css/Weaver_wev8.css" type=text/css rel=stylesheet>
<script language="javascript" src="/js/weaver_wev8.js"></script>
<link type="text/css" href="/js/ecology8/base/jquery-ui_wev8.css" rel=stylesheet>
<script type="text/javascript" src="/js/ecology8/base/jquery-ui_wev8.js"></script>
<script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.bgiframe.min_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.ajaxQueue_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/jquery.autocomplete_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/browser_wev8.js'></script>
<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/jquery.autocomplete_wev8.css" />
<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/browser_wev8.css" />
<style type="text/css">
.Spacing{
height:1px!important;
}
.btstyle01{
width:16px;
height:17px;
cursor:pointer;
background:url('/images/ecology8/add_wev8.png') no-repeat;
border:none!important;
}
.btstyle02{
width:16px;
height:17px;
cursor:pointer;
background:url('/images/ecology8/add_hot_wev8.png') no-repeat;
border:none!important;
}
</style>
</head>
<body>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%
if(operatelevel>0){
	if(!ajax.equals("1"))
		RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:selectall(),_self} " ;
	else
		RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:flowCodeSave(this),_self} " ;
		RCMenuHeight += RCMenuHeightStep;

    if(!ajax.equals("1")) {
		RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",addwf.jsp?src=editwf&wfid="+wfid+",_self} " ;
		RCMenuHeight += RCMenuHeightStep;
    }

	if(!ajax.equals("1")){
		if(RecordSet.getDBType().equals("db2")){
			RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where int(operateitem)=88 and relatedid="+wfid+",_self} " ;
		}else{
			RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where operateitem=88 and relatedid="+wfid+",_self} " ;
		}	
		RCMenuHeight += RCMenuHeightStep ;
	}
}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<form id="frmCoder" name="frmCoder" method=post action="coderOperation.jsp" >
<%
if(ajax.equals("1")){
%>
<input type="hidden" name="ajax" value="1">
<%}%>
<%
	String fieldid=cbean.getCodeFieldId();
	List hisShowNameList =new ArrayList();
	hisShowNameList.add("18729");
	hisShowNameList.add("445");
	hisShowNameList.add("6076");
	hisShowNameList.add("18811");

	String SQL = null;

	if("1".equals(isbill)){
		SQL = "select formField.id,fieldLable.labelName as fieldLable "
                   + "from HtmlLabelInfo  fieldLable ,workflow_billfield  formField "
                   + "where fieldLable.indexId=formField.fieldLabel "
                   + "  and formField.billId= " + formid
                   + "  and formField.viewType=0 "
                   + "  and fieldLable.languageid =" + user.getLanguage();
	}else{
		SQL = "select formDict.ID, fieldLable.fieldLable "
                   + "from workflow_fieldLable fieldLable, workflow_formField formField, workflow_formdict formDict "
                   + "where fieldLable.formid = formField.formid and fieldLable.fieldid = formField.fieldid and formField.fieldid = formDict.ID and (formField.isdetail<>'1' or formField.isdetail is null) "
                   + "and formField.formid = " + formid
                   + " and fieldLable.langurageid = " + user.getLanguage();
	}

       String selectFieldSql=null;
       if("1".equals(isbill)){
       	selectFieldSql = SQL + " and formField.fieldHtmlType = '5' order by formField.dspOrder";
       }else{
           selectFieldSql = SQL + " and formDict.fieldHtmlType = '5' order by formField.fieldorder";
       }
       String subCompanyFieldSql=null;
       if("1".equals(isbill)){
       	subCompanyFieldSql = SQL + " and formField.fieldHtmlType = '3' and formField.type in(42,164,169,170) order by formField.dspOrder";
       }else{
           subCompanyFieldSql = SQL + " and formDict.fieldHtmlType = '3' and formDict.type in(42,164,169,170) order by formField.fieldorder";
       }
       String onlyDepartmentFieldSql=null;//部门编码 td add by 78162 
       if("1".equals(isbill)){
       	onlyDepartmentFieldSql = SQL + " and formField.fieldHtmlType = '3' and formField.type =4 order by formField.dspOrder";
       }else{
       	onlyDepartmentFieldSql = SQL + " and formDict.fieldHtmlType = '3' and formDict.type =4 order by formField.fieldorder";
       }        
       String departmentFieldSql=null;
       if("1".equals(isbill)){
       	departmentFieldSql = SQL + " and formField.fieldHtmlType = '3' and formField.type in(4,57,167,168) order by formField.dspOrder";
       }else{
           departmentFieldSql = SQL + " and formDict.fieldHtmlType = '3' and formDict.type in(4,57,167,168) order by formField.fieldorder";
       }
       String yearFieldSql=null;
       if("1".equals(isbill)){
       	//yearFieldSql = SQL + " and formField.fieldHtmlType = '3' and formField.type in(2,178) order by formField.dspOrder";
       	yearFieldSql = SQL + " and ((formField.fieldHtmlType = '3' and formField.type in(2))or(formField.fieldHtmlType = '5' and exists(select 1 from workflow_selectitem where isBill="+isbill+" and workflow_selectitem.fieldId=formField.id and selectName>'1900' and selectName<'2099'))) order by formField.dspOrder";
       }else{
           //yearFieldSql = SQL + " and formDict.fieldHtmlType = '3' and formDict.type in(2,178) order by formField.fieldorder";
           yearFieldSql = SQL + " and ((formDict.fieldHtmlType = '3' and formDict.type in(2))or(formDict.fieldHtmlType = '5' and exists(select 1 from workflow_selectitem where isBill="+isbill+" and workflow_selectitem.fieldId=formDict.id and selectName>'1900' and selectName<'2099'))) order by formField.fieldorder";
       }

       String monthFieldSql=null;
       if("1".equals(isbill)){
       	monthFieldSql = SQL + " and formField.fieldHtmlType = '3' and formField.type in(2) order by formField.dspOrder";
       }else{
           monthFieldSql = SQL + " and formDict.fieldHtmlType = '3' and formDict.type in(2) order by formField.fieldorder";
       }

       String dateFieldSql=null;
       if("1".equals(isbill)){
       	dateFieldSql = SQL + " and formField.fieldHtmlType = '3' and formField.type in(2) order by formField.dspOrder";
       }else{
           dateFieldSql = SQL + " and formDict.fieldHtmlType = '3' and formDict.type in(2) order by formField.fieldorder";
       }

	int tempFieldId=0;
	int selectFieldId=0;	
	
%>
<wea:layout type="fourCol">
	<%
		String  groupShow = "{'samePair':'groupShow','groupDisplay':'none',itemAreaDisplay:'none'}";
		if("1".equals(isUse)) groupShow = "{'samePair':'groupShow','groupDisplay':'',itemAreaDisplay:'block'}";
	%>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
		<wea:item ><%=SystemEnv.getHtmlLabelName(18095,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(19502,user.getLanguage())%></wea:item>
		<wea:item attributes="{'colspan':'3'}">
			<input class="inputStyle" tzCheckbox="true" onclick="toShowGroup(this)" type="checkbox" name="txtUserUse" value="1" <%if ("1".equals(isUse)) out.println("checked");%>>
		</wea:item>
		<%
			String  itemShow = "{'samePair':'itemShow','display':'none'}";
			if("1".equals(isUse)) itemShow = "{'samePair':'itemShow','display':''}";
			String  itemShowFor3 = "{'samePair':'itemShow','display':'none','colspan':'3'}";
			if("1".equals(isUse)) itemShowFor3 = "{'samePair':'itemShow','display':'','colspan':'3'}";
		 %>
		<wea:item attributes='<%=itemShow %>'><%=SystemEnv.getHtmlLabelName(19503,user.getLanguage())%></wea:item>
		<wea:item attributes='<%=itemShowFor3 %>'>
            <select id="selectField" name="selectField">
            <%  
            RecordSet.execute(sql);
            while (RecordSet.next()){
            	if (isbill.equals("0")){
	            	String htmltype=FieldComInfo.getFieldhtmltype(RecordSet.getString(1));
	            	String types=FieldComInfo.getFieldType(RecordSet.getString(1));
	            	if (!(htmltype.equals("1"))||!(types.equals("1"))) continue;
            	}
            %>
            <option  <%if (fieldid.equals(RecordSet.getString(1))) {%>selected<%}%>  value=<%=RecordSet.getString(1)%>><%if (isbill.equals("0")) {%><%=RecordSet.getString(2)%>
            <%} else {%>
            <%=SystemEnv.getHtmlLabelName(RecordSet.getInt(2),user.getLanguage())%>
            <%}%></option>
            <%}%>
            </select>
			<%if(!isbill.equals("0")){ %>
            <input type="button" id="addfield" name="addfield" class="btstyle01" onmouseover="showBt(this)" onmouseout="hiddenBt(this)" onclick="addField()"/>
            <%} %>
		</wea:item>
		<wea:item attributes='<%=itemShow %>'><%=SystemEnv.getHtmlLabelName(81822,user.getLanguage())%></wea:item>
		<%
			String browserValue = "";
			String browserSpanValue = "";
			String linksql = "SELECT a.id,a.nodeid,a.linkname,a.linkorder,a.isbulidcode,b.nodename "+ 
						" FROM workflow_nodelink a,workflow_nodebase b  "+
						" WHERE wfrequestid IS NULL  AND a.nodeid = b.id AND workflowid= "+wfid+
						" AND (b.isFreeNode != '1' OR b.isFreeNode IS null)  "+
						" ORDER BY a.linkorder,a.nodeid,a.id ";
			RecordSet.execute(linksql);
			while (RecordSet.next()){
				String isbulidcode = Util.null2String(RecordSet.getString("isbulidcode"));
				if(isbulidcode.equals("1")){
					browserValue += Util.null2String(RecordSet.getString("id")) +",";
					browserSpanValue += Util.null2String(RecordSet.getString("linkname")) +",";
				}
			}
			if(!"".equals(browserValue) && !"".equals(browserSpanValue)){
				browserValue = browserValue.substring(0, browserValue.length()-1);
				browserSpanValue = browserSpanValue.substring(0, browserSpanValue.length()-1);
			}
			//String completeUrl2 = "/data.jsp?type=workflowNodeBrowser&wfid="+wfid;
		%> 
		<wea:item attributes='<%=itemShowFor3 %>'>
			<brow:browser name="wfcode" viewType="0" hasBrowser="true" hasAdd="false" 
         		getBrowserUrlFn="getShowNodesUrl" isMustInput="1" isSingle="false" hasInput="true"
          		completeUrl=""  width="150px" browserValue='<%=browserValue %>' browserSpanValue='<%=browserSpanValue %>' />
		</wea:item>
	</wea:group>
	
	<wea:group context='<%=SystemEnv.getHtmlLabelName(83549,user.getLanguage())%>' attributes="<%=groupShow%>">
		<wea:item type="groupHead">
			<button type="button"  name="addCol" class="e8_btn_top middle" style="border:1px solid #aecef1 !important" onclick="addNewCol();" ><%=SystemEnv.getHtmlLabelName(17998,user.getLanguage())%></button>
			<%--
			<input type=button name="addCol" class=addbtn accessKey=A onClick="addNewCol()" title="<%=SystemEnv.getHtmlLabelName(17998,user.getLanguage())%>"></input> --%>
		</wea:item> 
		<wea:item attributes="{'isTableList':'true'}">
			<wea:layout needImportDefaultJsAndCss="false">
				<wea:group context="" attributes="{'groupDisplay':'none'}">
					<wea:item attributes="{'isTableList':'true'}">
						<wea:layout needImportDefaultJsAndCss="false" type="3col" attributes="{'formTableId':'codeRule'}">
							<wea:group context="" attributes="{'groupDisplay':'none'}">	
							<%
							if(!isE8Save){//E8前

							int index = 1;
							if(coderMemberList.size() > 0){
							for (int i=0;i<coderMemberList.size();i++){
								String[] codeMembers = (String[])coderMemberList.get(i);
								String codeMemberName = codeMembers[0];
								String codeMemberValue = codeMembers[1];
								String codeMemberType = codeMembers[2];
								if(hasHistoryCode&&hisShowNameList.indexOf(codeMemberName)==-1){
								 continue;
								}
								String attributes = "{'colspan':'full','trId':'TR_"+i+"','customer1':'member'}";
								String attrs = "{'codevalue':'"+codeMemberName+"'}";
							%>
							<!--  -->
							<%
							if ("2".equals(codeMemberType) && !"18729".equals(codeMemberName) && !"18811".equals(codeMemberName) && !"".equals(codeMemberValue) && codeMemberValue != null){   //2:input
							%>
							<% attrs = "{'codevalue':'"+codeMemberName+"','customAttrs':'concrete=7'}";%>
								<wea:item attributes='<%=attrs %>'>
								<span movingicon style="display:inline-block;width:20px;"><img src='/proj/img/move_wev8.png' title='<%=SystemEnv.getHtmlLabelName(82783, user.getLanguage())%>'/></span>
								<%=SystemEnv.getHtmlLabelName(27903,user.getLanguage()) + index%>
								</wea:item>
								<wea:item attributes='<%=attributes %>'>
								<%
								if (canEdit){
								%>
									<input type=text name="inputt<%=index%>" <%if (codeMemberName.equals("18811")) {%> onchange='checkint("inputt<%=i%>");proView();'<%} else {%>onchange=proView()<%}%> class=inputstyle   value="<%=codeMemberValue%>" >
									<input type=button style="Float:right;" name="deleteInputCol" class=delbtn accessKey=E onClick="deleteCol(this)" title="E-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>"></input>
									<input type="hidden" name="sortNum1" value="<%=index%>">
								<%} else {
									out.println("<div>"+codeMemberValue+"</div>");
								}  
								%>
								</wea:item>
							<%	index++; 
								}else if((!"2".equals(codeMemberType) || "18729".equals(codeMemberName)) && codeMemberValue != null && !codeMemberValue.equals("") && !codeMemberValue.equals("-1") || "18811".equals(codeMemberName)){ 
							%>
							<!--  -->

							<!--  -->
							<%if("2".equals(codeMemberType) && "18729".equals(codeMemberName)){
								attrs = "{'codevalue':'"+codeMemberName+"','customAttrs':'concrete=9'}";//字母
							}else if("2".equals(codeMemberType) && "18811".equals(codeMemberName)){
								attrs = "{'codevalue':'"+codeMemberName+"','customAttrs':'concrete=8'}";//流水号位数

							}else if("5".equals(codeMemberType) && "22755".equals(codeMemberName)){
								attrs = "{'codevalue':'"+codeMemberName+"','customAttrs':'concrete=0'}";//选择框字段

							}else if("5".equals(codeMemberType) && "22753".equals(codeMemberName)){
								attrs = "{'codevalue':'"+codeMemberName+"','customAttrs':'concrete=3'}";//上级分部
							}else if("5".equals(codeMemberType) && "141".equals(codeMemberName)){
								attrs = "{'codevalue':'"+codeMemberName+"','customAttrs':'concrete=2'}";//分部
							}else if("5".equals(codeMemberType) && "124".equals(codeMemberName)){
								attrs = "{'codevalue':'"+codeMemberName+"','customAttrs':'concrete=1'}";//部门
							}else if("5".equals(codeMemberType) && "445".equals(codeMemberName)){
								attrs = "{'codevalue':'"+codeMemberName+"','customAttrs':'concrete=4'}";//年

							}else if("5".equals(codeMemberType) && "6076".equals(codeMemberName)){
								attrs = "{'codevalue':'"+codeMemberName+"','customAttrs':'concrete=5'}";//月

							}else if("5".equals(codeMemberType) && "390".equals(codeMemberName)){
								attrs = "{'codevalue':'"+codeMemberName+"','customAttrs':'concrete=6'}";//日

							}
							%>
							
								<wea:item attributes='<%=attrs %>'>
								<span movingicon style="display:inline-block;width:20px;"><img src='/proj/img/move_wev8.png' title='<%=SystemEnv.getHtmlLabelName(82783, user.getLanguage())%>'/></span>
								<%=SystemEnv.getHtmlLabelName(Util.getIntValue(codeMemberName),user.getLanguage()) %>
								</wea:item>
								<wea:item attributes='<%=attributes %>'>
								<%
								if("1".equals(codeMemberType)){   //1:checkbox
									if("1".equals(codeMemberValue)){
										if(canEdit){
											out.println("<input id=chk_"+i+" type=checkbox class=inputstyle checked value=1  onclick=proView()>");
										}else{
											out.println("<div>"+SystemEnv.getHtmlLabelName(160,user.getLanguage())+"</div>");
										}
									}else{
										if(canEdit){
											out.println("<input id=chk_"+i+" type=checkbox class=inputstyle  value=1  onclick=proView()>");
										} else {
											out.println("<div>"+SystemEnv.getHtmlLabelName(165,user.getLanguage())+"</div>");
										}                              
									}
								} else if ("2".equals(codeMemberType) && "18729".equals(codeMemberName)){   //2:input
									if (canEdit){
									%>
										<input type=text name="inputt<%=i%>" <%if (codeMemberName.equals("18811")) {%> onchange='checkint("inputt<%=i%>");proView();'<%} else {%>onchange=proView()<%}%> class=inputstyle   value="<%=codeMemberValue%>">
										<input type=button style="Float:right;" name="deleteInputCol" class=delbtn accessKey=E onClick="deleteCol(this)" title="E-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>"></input>
										<input type=button style="Float:right;" name="addInputCol" class=addbtn accessKey=A onClick="addStringCol(this)" title="A-<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>"></input> 
									<%} else {
										out.println("<div>"+codeMemberValue+"</div>");
									} 
								}else if ("2".equals(codeMemberType) && "18811".equals(codeMemberName)){   //2:input
									if (canEdit){
									%>
										<input type=text name="inputt<%=i%>" maxlength="16" <%if (codeMemberName.equals("18811")) {%> onchange='checkint("inputt<%=i%>");proView();'<%} else {%>onchange=proView()<%}%> class=inputstyle   value="<%=codeMemberValue%>" >
										<input type=button style="Float:right;" name="addInputCol" class=addbtn accessKey=A onClick="addStringCol(this)" title="A-<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>"></input> 
									<%} else {
										out.println("<div>"+codeMemberValue+"</div>");
									} 
								}else if ("5".equals(codeMemberType)){   //5:select
									if (canEdit){
										if("22755".equals(codeMemberName)){
										%>
											<select class=inputstyle name="selectField_1" oldval="<%=codeMemberValue%>" onchange="checkselect('0',this)" style="width:100px!important;">
											<%
											RecordSet.executeSql(selectFieldSql);  
											while(RecordSet.next()){
											tempFieldId = RecordSet.getInt("ID");
											selectFieldId=tempFieldId;
											//System.out.println("codeMemberValue = " + codeMemberValue);
											%>
											<option value=<%= tempFieldId %> <% if((""+tempFieldId).equals(codeMemberValue)) { %> selected <% } %> ><%= Util.null2String(RecordSet.getString("fieldLable")) %></option>
											<%}%>
											</select>
											&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
											&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
											&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
											<span id="selectSpan" name="selectSpan">
											<button type="button"  class="e8_btn_top middle" style="border:1px solid #aecef1 !important" onclick="openDialogBeforSave(this);" ><%=SystemEnv.getHtmlLabelName(33872,user.getLanguage())%></button>
											</span>
											<%--<a href="javascript:void(0);" onClick="shortNameSetting(<%= wfid %>, <%= formid %>, <%= isbill %>,<%= "".equals(codeMemberValue)?"-1":codeMemberValue %>)"><%=SystemEnv.getHtmlLabelName(33872,user.getLanguage())%></a> --%>
											<input type=button style="Float:right;" name="deleteInputCol" class=delbtn accessKey=E onClick="deleteCol(this)" title="E-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>"></input>
											<input type=button style="Float:right;" name="addInputCol" class=addbtn accessKey=A onClick="addStringCol(this)" title="A-<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>"></input> 
											<input type="hidden"  name="selectNum0" value="1" >
										<% 	
										}else if("22806".equals(codeMemberName)){
										%>
											<select class=inputstyle name="fieldSequenceAlone_<%=i%>" onchange="proView()">
											<option value=-2 <% if(("-2").equals(codeMemberValue)) { %> selected <% } %>><%=SystemEnv.getHtmlLabelName(19225,user.getLanguage())%></option>
											<%
											RecordSet.executeSql(onlyDepartmentFieldSql);										
											while(RecordSet.next()){
											tempFieldId = RecordSet.getInt("ID");
											%>
											<option value=<%= tempFieldId %> <% if((""+tempFieldId).equals(codeMemberValue)) { %> selected <% } %> ><%= Util.null2String(RecordSet.getString("fieldLable")) %></option>
											<%}%>
											</select>
											<input type=button style="Float:right;" name="deleteInputCol" class=delbtn accessKey=E onClick="deleteCol(this)" title="E-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>"></input>
											<input type=button style="Float:right;" name="addInputCol" class=addbtn accessKey=A onClick="addStringCol(this)" title="A-<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>"></input> 
										<%											
										}else if("22753".equals(codeMemberName)){//上级分部
										%>
											<select class=inputstyle name="selectSupSub_1" oldval="<%=codeMemberValue%>" onchange="checkselect('3',this)">
											<option value=-2 <% if(("-2").equals(codeMemberValue)) { %> selected <% } %>><%=SystemEnv.getHtmlLabelName(22787,user.getLanguage())%></option>
											<%
											RecordSet.executeSql(subCompanyFieldSql);
											while(RecordSet.next()){
											tempFieldId = RecordSet.getInt("ID");
											%>
											<option value=<%= tempFieldId %> <% if((""+tempFieldId).equals(codeMemberValue)) { %> selected <% } %> ><%= Util.null2String(RecordSet.getString("fieldLable")) %></option>
											<%}%>
											</select>
											&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
											<%=SystemEnv.getHtmlLabelName(15935,user.getLanguage())%>&nbsp;&nbsp;&nbsp;&nbsp;
											<select class=inputstyle id="supselect" name="supselect" onchange="changesup(1)">
											
												<option value=0><%=SystemEnv.getHtmlLabelName(22764,user.getLanguage())%></option>
											<%
											RecordSet.executeSql("select enablesupsubcode from workflow_supSubComAbbr where workflowId ="+ wfid +" or formId = "+ formid);
											//System.out.println("RecordSet.getColCounts()supSubCom = "+RecordSet.getColCounts());
											String supSubShow = "";
											while(RecordSet.next()){
												supSubShow =  Util.null2String(RecordSet.getString("enablesupsubcode"));
											}
											if(supSubShow.equals("1")){
											%>
												<option value=1 selected ><%=SystemEnv.getHtmlLabelName(22289,user.getLanguage())%></option>
											
											</select>&nbsp;&nbsp;&nbsp;&nbsp;
											<span id="supSubspan1" name="supSubspan1" style="display:none;">
												<button type="button"  class="e8_btn_top middle" style="border:1px solid #aecef1 !important" onclick="openDialogBeforSave(this);" ><%=SystemEnv.getHtmlLabelName(33872,user.getLanguage())%></button>
												<%--<a href="javascript:void(0);" onClick="supSubComAbbr(<%= wfid %>, <%= formid %>, <%= isbill %>,<%= "".equals(codeMemberValue)?"-1":codeMemberValue %>)"><%=SystemEnv.getHtmlLabelName(33872,user.getLanguage())%></a> --%>
											</span>
											<%}else{%>
												<option value=1><%=SystemEnv.getHtmlLabelName(22289,user.getLanguage())%></option>
											</select>&nbsp;&nbsp;&nbsp;&nbsp;
											<span id="supSubspan1" name="supSubspan1" style="display:inline-block;">
												<button type="button"  class="e8_btn_top middle" style="border:1px solid #aecef1 !important" onclick="openDialogBeforSave(this);" ><%=SystemEnv.getHtmlLabelName(33872,user.getLanguage())%></button>
												<%--<a href="javascript:void(0);" onClick="supSubComAbbr(<%= wfid %>, <%= formid %>, <%= isbill %>,<%= "".equals(codeMemberValue)?"-1":codeMemberValue %>)"><%=SystemEnv.getHtmlLabelName(33872,user.getLanguage())%></a> --%>
											</span>
											<%} %>
											<input type=button style="Float:right;" name="deleteInputCol" class=delbtn accessKey=E onClick="deleteCol(this)" title="E-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>"></input>
											<input type=button style="Float:right;" name="addInputCol" class=addbtn accessKey=A onClick="addStringCol(this)" title="A-<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>"></input> 
											<input type="hidden"  name="selectNum3" value="1" >
										<%
										}else if("141".equals(codeMemberName)){//分部
										%>
											<select class=inputstyle name="selectSub_1" oldval="<%=codeMemberValue%>" onchange="checkselect('2',this)">
											<option value=-2 <% if(("-2").equals(codeMemberValue)) { %> selected <% } %>><%=SystemEnv.getHtmlLabelName(22788,user.getLanguage())%></option>
											<%
											RecordSet.executeSql(subCompanyFieldSql);  
											while(RecordSet.next()){
											tempFieldId = RecordSet.getInt("ID");
											%>
											<option value=<%= tempFieldId %> <% if((""+tempFieldId).equals(codeMemberValue)) { %> selected <% } %> ><%= Util.null2String(RecordSet.getString("fieldLable")) %></option>
											<%}%>
											</select>
											&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
											<%=SystemEnv.getHtmlLabelName(15935,user.getLanguage())%>&nbsp;&nbsp;&nbsp;&nbsp;
											<select class=inputstyle id="subselect" name="subselect" onchange="changesub(1)">
												<option value=0><%=SystemEnv.getHtmlLabelName(22764,user.getLanguage())%></option>
											<%
											RecordSet.executeSql("select enablesubcode from workflow_subComAbbr where workflowId ="+ wfid +" or formId = "+ formid);
											//System.out.println("RecordSet.getColCounts()subCom = "+RecordSet.getColCounts());
											String subComShow = "";
											while(RecordSet.next()){
												subComShow =  Util.null2String(RecordSet.getString("enablesubcode"));
											}
											if(subComShow.equals("1")){
											%>
												<option value=1 selected ><%=SystemEnv.getHtmlLabelName(22289,user.getLanguage())%></option>
											</select>&nbsp;&nbsp;&nbsp;&nbsp;
											<span id="subComspan1" name="subComspan1" style="display:none;">
												<button type="button"  class="e8_btn_top middle" style="border:1px solid #aecef1 !important" onclick="openDialogBeforSave(this);" ><%=SystemEnv.getHtmlLabelName(33872,user.getLanguage())%></button>
												<%--<a href="javascript:void(0);" onClick="subComAbbr(<%= wfid %>, <%= formid %>, <%= isbill %>,<%= "".equals(codeMemberValue)?"-1":codeMemberValue %>)"><%=SystemEnv.getHtmlLabelName(33872,user.getLanguage())%></a> --%>
											</span>
											<%}else{%>
												<option value=1><%=SystemEnv.getHtmlLabelName(22289,user.getLanguage())%></option>
											</select>&nbsp;&nbsp;&nbsp;&nbsp;
											<span id="subComspan1" name="subComspan1" style="display:inline-block;">
												<button type="button"  class="e8_btn_top middle" style="border:1px solid #aecef1 !important" onclick="openDialogBeforSave(this);" ><%=SystemEnv.getHtmlLabelName(33872,user.getLanguage())%></button>
												<%--<a href="javascript:void(0);" onClick="subComAbbr(<%= wfid %>, <%= formid %>, <%= isbill %>,<%= "".equals(codeMemberValue)?"-1":codeMemberValue %>)"><%=SystemEnv.getHtmlLabelName(33872,user.getLanguage())%></a> --%>
											</span>
											<%} %>
											<input type=button style="Float:right;" name="deleteInputCol" class=delbtn accessKey=E onClick="deleteCol(this)" title="E-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>"></input>
											<input type=button style="Float:right;" name="addInputCol" class=addbtn accessKey=A onClick="addStringCol(this)" title="A-<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>"></input> 
											<input type="hidden"  name="selectNum2" value="1" >
										<%
										}else if("124".equals(codeMemberName)){//部门
										%>
											<select class=inputstyle name="selectDept_1" oldval="<%=codeMemberValue%>" onchange="checkselect('1',this)">
											<option value=-2 <% if(("-2").equals(codeMemberValue)) { %> selected <% } %>><%=SystemEnv.getHtmlLabelName(19225,user.getLanguage())%></option>
											<%
											RecordSet.executeSql(departmentFieldSql);										
											while(RecordSet.next()){
											tempFieldId = RecordSet.getInt("ID");
											%>
											<option value=<%= tempFieldId %> <% if((""+tempFieldId).equals(codeMemberValue)) { %> selected <% } %> ><%= Util.null2String(RecordSet.getString("fieldLable")) %></option>
											<%}%>
											</select>
											&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
											<%=SystemEnv.getHtmlLabelName(15935,user.getLanguage())%>&nbsp;&nbsp;&nbsp;&nbsp;
											<select class=inputstyle id="deptselect" name="deptselect" onchange="changedept(1)">
												<option value=0><%=SystemEnv.getHtmlLabelName(22764,user.getLanguage())%></option>
											<%
											RecordSet.executeSql("select enableDeptcode from workflow_deptAbbr where workflowId ="+ wfid +" or formId = "+ formid);
											//System.out.println("RecordSet.getColCounts()dept = "+RecordSet.getColCounts());
											String deptShow = "";
											while(RecordSet.next()){
												deptShow =  Util.null2String(RecordSet.getString("enableDeptcode"));
											}
											if(deptShow.equals("1")){
											%>
												<option value=1 selected ><%=SystemEnv.getHtmlLabelName(15391,user.getLanguage())%></option>
											</select>&nbsp;&nbsp;&nbsp;&nbsp;
											<span id="deptspan1" name="deptspan1" style="display:none;">
												<button type="button"  class="e8_btn_top middle" style="border:1px solid #aecef1 !important" onclick="openDialogBeforSave(this);" ><%=SystemEnv.getHtmlLabelName(33872,user.getLanguage())%></button>
												<%--<a href="javascript:void(0);" onClick="deptAbbr(<%= wfid %>, <%= formid %>, <%= isbill %>,<%= "".equals(codeMemberValue)?"-1":codeMemberValue %>)"><%=SystemEnv.getHtmlLabelName(33872,user.getLanguage())%></a> --%>
											</span>
											<%}else{%>
												<option value=1><%=SystemEnv.getHtmlLabelName(15391,user.getLanguage())%></option>
											</select>&nbsp;&nbsp;&nbsp;&nbsp;
											<span id="deptspan1" name="deptspan1" style="display:inline-block;">
												<button type="button"  class="e8_btn_top middle" style="border:1px solid #aecef1 !important" onclick="openDialogBeforSave(this);" ><%=SystemEnv.getHtmlLabelName(33872,user.getLanguage())%></button>
												<%--<a href="javascript:void(0);" onClick="deptAbbr(<%= wfid %>, <%= formid %>, <%= isbill %>,<%= "".equals(codeMemberValue)?"-1":codeMemberValue %>)"><%=SystemEnv.getHtmlLabelName(33872,user.getLanguage())%></a> --%>
											</span>
											<%} %>
											<input type=button style="Float:right;" name="deleteInputCol" class=delbtn accessKey=E onClick="deleteCol(this)" title="E-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>"></input>
											<input type=button style="Float:right;" name="addInputCol" class=addbtn accessKey=A onClick="addStringCol(this)" title="A-<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>"></input> 
											<input type="hidden"  name="selectNum1" value="1" >
										<%
										}else if("445".equals(codeMemberName)){//年

										%>
											<select class=inputstyle name="selectYear_1" oldval="<%=codeMemberValue%>" onchange="checkselect('5',this)" >
											<option value=-2 <% if(("-2").equals(codeMemberValue)) { %> selected <% } %>><%=SystemEnv.getHtmlLabelName(22793,user.getLanguage())%></option>
											<%
											RecordSet.executeSql(yearFieldSql);										
											while(RecordSet.next()){
											tempFieldId = RecordSet.getInt("ID");

											%>
											<option value=<%= tempFieldId %> <% if((""+tempFieldId).equals(codeMemberValue)) { %> selected <% } %> ><%= Util.null2String(RecordSet.getString("fieldLable")) %></option>
											<%}%>
											</select>
											<input type=button style="Float:right;" name="deleteInputCol" class=delbtn accessKey=E onClick="deleteCol(this)" title="E-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>"></input>
											<input type=button style="Float:right;" name="addInputCol" class=addbtn accessKey=A onClick="addStringCol(this)" title="A-<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>"></input>
											<input type="hidden"  name="selectNum5" value="1" >
										<%
										}else if("6076".equals(codeMemberName)){//月

										%>
											<select class=inputstyle name="selectMonth_1" oldval="<%=codeMemberValue%>" onchange="checkselect('6',this)" >
											<option value=-2 <% if(("-2").equals(codeMemberValue)) { %> selected <% } %>><%=SystemEnv.getHtmlLabelName(22794,user.getLanguage())%></option>
											<%
											RecordSet.executeSql(monthFieldSql);										
											while(RecordSet.next()){
											tempFieldId = RecordSet.getInt("ID");

											%>
											<option value=<%= tempFieldId %> <% if((""+tempFieldId).equals(codeMemberValue)) { %> selected <% } %> ><%= Util.null2String(RecordSet.getString("fieldLable")) %></option>
											<%
											}
											%>
											</select>
											<input type=button style="Float:right;" name="deleteInputCol" class=delbtn accessKey=E onClick="deleteCol(this)" title="E-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>"></input>
											<input type=button style="Float:right;" name="addInputCol" class=addbtn accessKey=A onClick="addStringCol(this)" title="A-<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>"></input>
											<input type="hidden"  name="selectNum6" value="1" >
										<%
										}else if("390".equals(codeMemberName)||"16889".equals(codeMemberName)){//日

										%>
											<select class=inputstyle name="selectDay_1" oldval="<%=codeMemberValue%>" onchange="checkselect('7',this)" >
											<option value=-2 <% if(("-2").equals(codeMemberValue)) { %> selected <% } %>><%=SystemEnv.getHtmlLabelName(15625,user.getLanguage())%></option>
											<%
											RecordSet.executeSql(dateFieldSql);										
											while(RecordSet.next()){
											tempFieldId = RecordSet.getInt("ID");

											%>
											<option value=<%= tempFieldId %> <% if((""+tempFieldId).equals(codeMemberValue)) { %> selected <% } %> ><%= Util.null2String(RecordSet.getString("fieldLable")) %></option>
											<%} %>
											</select>
											<input type=button style="Float:right;" name="deleteInputCol" class=delbtn accessKey=E onClick="deleteCol(this)" title="E-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>"></input>
											<input type=button style="Float:right;" name="addInputCol" class=addbtn accessKey=A onClick="addStringCol(this)" title="A-<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>"></input>
											<input type="hidden"  name="selectNum7" value="1" >
										<%
										}
									} else {
									         
									} 
								}  
								%>
								</wea:item>
							<!--  -->
								<% } %>
							<!--  -->
							<%}
							}else{
								%>
								<%
									String attrs = "{'codevalue':'18811','customAttrs':'concrete=8'}"; 
									String attributes = "{'colspan':'full','trId':'TR_0','customer1':'member'}";
								%>
								<wea:item attributes='<%=attrs %>'>
								<span movingicon style="display:inline-block;width:20px;"><img src='/proj/img/move_wev8.png' title='<%=SystemEnv.getHtmlLabelName(82783, user.getLanguage())%>'/></span>
								<%=SystemEnv.getHtmlLabelName(18811,user.getLanguage())%>
								</wea:item>
								<wea:item attributes='<%=attributes %>'>
								<input type=text name="inputt0" maxlength="16" onchange='checkint("inputt0");proView();' class=inputstyle   value="" >
								<input type=button style="Float:right;" name="addInputCol" class=addbtn accessKey=A onClick="addStringCol(this)" title="A-<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>"></input> 
								</wea:item>
								<%	
							}
							}else{//E8

								int strindex = 1;//字符串字段

								int selectindex = 1;//选择框字段

								int deptindex = 1;//部门字段
								int subindex = 1;//分部字段
								int supsubindex = 1;//上级分部字段
								int yindex = 1;//年字段

								int mindex = 1;//月字段

								int dindex = 1;//日字段
								if(coderMemberList.size() > 0){
								for (int i=0;i<coderMemberList.size();i++){
									String[] codeMembers = (String[])coderMemberList.get(i);
									String codeMemberName = codeMembers[0];
									String codeMemberValue = codeMembers[1];
									String codeMemberType = codeMembers[2];
									String concreteField = "";
									String enablecode = "";
									if(codeMembers.length >= 4){
										concreteField = codeMembers[3];
										enablecode = codeMembers[4];
									}
									String attributes = "{'colspan':'full','trId':'TR_"+i+"','customer1':'member'}";
									String attrs = "{'codevalue':'"+codeMemberName+"'}";
								%>
								<!--  -->
								<%
								//7:input字符串

								if ("2".equals(codeMemberType) && !"".equals(codeMemberValue) && codeMemberValue != null && "7".equals(concreteField)){   
								%>
								<%attrs = "{'codevalue':'"+codeMemberName+"','customAttrs':'concrete=7'}"; %>
									<wea:item attributes='<%=attrs %>'>
									<span movingicon style="display:inline-block;width:20px;"><img src='/proj/img/move_wev8.png' title='<%=SystemEnv.getHtmlLabelName(82783, user.getLanguage())%>'/></span>
									<%=SystemEnv.getHtmlLabelName(27903,user.getLanguage()) + strindex%>
									</wea:item>
									<wea:item attributes='<%=attributes %>'>
									<%
									if (canEdit){
									%>
										<input type=text name="inputt<%=strindex%>" onchange=proView() class=inputstyle value="<%=codeMemberValue%>" >
										<input type=button style="Float:right;" name="deleteInputCol" class=delbtn accessKey=E onClick="deleteCol(this)" title="E-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>"></input>
										<input type="hidden" name="sortNum1" value="<%=strindex%>">
									<%} else {
										out.println("<div>"+codeMemberValue+"</div>");
									}
									%>
									</wea:item>
								<%	strindex++;
									//0:选择框字段

									}else if(codeMemberType.equals("5") && concreteField.equals("0")){
									%>
									<%attrs = "{'codevalue':'"+codeMemberName+"','customAttrs':'concrete=0'}"; %>
									<wea:item attributes='<%=attrs %>'>
									<span movingicon style="display:inline-block;width:20px;"><img src='/proj/img/move_wev8.png' title='<%=SystemEnv.getHtmlLabelName(82783, user.getLanguage())%>'/></span>
									<%=SystemEnv.getHtmlLabelName(22755,user.getLanguage())%>
									</wea:item>
									<wea:item attributes='<%=attributes %>'>
									<%
									if (canEdit){
									%>
									<select class=inputstyle name="selectField_<%=selectindex%>" oldval="<%=codeMemberValue%>" onchange="checkselect('0',this)" style="width:100px!important;">
									<%
									RecordSet.executeSql(selectFieldSql);  
									while(RecordSet.next()){
									tempFieldId = RecordSet.getInt("ID");
									selectFieldId=tempFieldId;
									//System.out.println("codeMemberValue = " + codeMemberValue);
									%>
									<option value=<%= tempFieldId %> <% if((""+tempFieldId).equals(codeMemberValue)) { %> selected <% } %> ><%= Util.null2String(RecordSet.getString("fieldLable")) %></option>
									<%}%>
									</select>
									&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
									&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
									&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
									<span id="selectSpan" name="selectSpan">
										<button type="button"  class="e8_btn_top middle" style="border:1px solid #aecef1 !important" onclick="openDialogBeforSave(this);" ><%=SystemEnv.getHtmlLabelName(33872,user.getLanguage())%></button>
									</span>
									<%--<a href="javascript:void(0);" onClick="shortNameSetting(<%= wfid %>, <%= formid %>, <%= isbill %>,<%= "".equals(codeMemberValue)?"-1":codeMemberValue %>)"><%=SystemEnv.getHtmlLabelName(33872,user.getLanguage())%></a> --%>
									<input type=button style="Float:right;" name="deleteInputCol" class=delbtn accessKey=E onClick="deleteCol(this)" title="E-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>"></input>
									<input type=button style="Float:right;" name="addInputCol" class=addbtn accessKey=A onClick="addStringCol(this)" title="A-<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>"></input> 
									<input type="hidden"  name="selectNum0" value="<%=selectindex%>" >
									<%} else {
										out.println("<div>"+codeMemberValue+"</div>");
									}
									%>
									</wea:item>
									<%
									selectindex++;
									//1:部门
									}else if(codeMemberType.equals("5") && concreteField.equals("1")){
									%>
									<%attrs = "{'codevalue':'"+codeMemberName+"','customAttrs':'concrete=1'}"; %>
									<wea:item attributes='<%=attrs %>'>
									<span movingicon style="display:inline-block;width:20px;"><img src='/proj/img/move_wev8.png' title='<%=SystemEnv.getHtmlLabelName(82783, user.getLanguage())%>'/></span>
									<%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%>
									</wea:item>
									<wea:item attributes='<%=attributes %>'>
									<%
									if (canEdit){
									%>
								
									<select class=inputstyle name="selectDept_<%=deptindex%>" oldval="<%=codeMemberValue%>" onchange="checkselect('1',this)">
									<option value=-2 <% if(("-2").equals(codeMemberValue)) { %> selected <% } %>><%=SystemEnv.getHtmlLabelName(19225,user.getLanguage())%></option>
									<%
									RecordSet.executeSql(departmentFieldSql);										
									while(RecordSet.next()){
									tempFieldId = RecordSet.getInt("ID");
									%>
									<option value=<%= tempFieldId %> <% if((""+tempFieldId).equals(codeMemberValue)) { %> selected <% } %> ><%= Util.null2String(RecordSet.getString("fieldLable")) %></option>
									<%}%>
									</select>
									&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
									<%=SystemEnv.getHtmlLabelName(15935,user.getLanguage())%>&nbsp;&nbsp;&nbsp;&nbsp;
									<select class=inputstyle id="deptselect<%=deptindex %>" name="deptselect<%=deptindex %>" onchange="changedept(<%=deptindex%>)">
										<option value=0><%=SystemEnv.getHtmlLabelName(22764,user.getLanguage())%></option>
									<%
									if(enablecode.equals("1")){
									%>
										<option value=1 selected ><%=SystemEnv.getHtmlLabelName(15391,user.getLanguage())%></option>
									</select>&nbsp;&nbsp;&nbsp;&nbsp;
									<span id="deptspan<%=deptindex %>" name="deptspan<%=deptindex %>" style="display:none;">
										<button type="button"  class="e8_btn_top middle" style="border:1px solid #aecef1 !important" onclick="openDialogBeforSave(this);" ><%=SystemEnv.getHtmlLabelName(33872,user.getLanguage())%></button>
										<%--<a href="javascript:void(0);" onClick="deptAbbr(<%= wfid %>, <%= formid %>, <%= isbill %>,<%= "".equals(codeMemberValue)?"-1":codeMemberValue %>)"><%=SystemEnv.getHtmlLabelName(33872,user.getLanguage())%></a> --%>
									</span>
									<%}else{%>
										<option value=1><%=SystemEnv.getHtmlLabelName(15391,user.getLanguage())%></option>
									</select>&nbsp;&nbsp;&nbsp;&nbsp;
									<span id="deptspan<%=deptindex %>" name="deptspan<%=deptindex %>" style="display:inline-block;">
										<button type="button"  class="e8_btn_top middle" style="border:1px solid #aecef1 !important" onclick="openDialogBeforSave(this);" ><%=SystemEnv.getHtmlLabelName(33872,user.getLanguage())%></button>
										<%--<a href="javascript:void(0);" onClick="deptAbbr(<%= wfid %>, <%= formid %>, <%= isbill %>,<%= "".equals(codeMemberValue)?"-1":codeMemberValue %>)"><%=SystemEnv.getHtmlLabelName(33872,user.getLanguage())%></a> --%>
									</span>
									<%} %>
									<input type=button style="Float:right;" name="deleteInputCol" class=delbtn accessKey=E onClick="deleteCol(this)" title="E-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>"></input>
									<input type=button style="Float:right;" name="addInputCol" class=addbtn accessKey=A onClick="addStringCol(this)" title="A-<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>"></input> 
									<input type="hidden"  name="selectNum1" value="<%=deptindex%>" >
									<%} else {
										out.println("<div>"+codeMemberValue+"</div>");
									}
									%>
									</wea:item>
									<%
									deptindex++;
									struSeqselectList.add("deptSelect");
									//2:分部
									}else if(codeMemberType.equals("5") && concreteField.equals("2")){
									%>
									<%attrs = "{'codevalue':'"+codeMemberName+"','customAttrs':'concrete=2'}"; %>
									<wea:item attributes='<%=attrs %>'>
									<span movingicon style="display:inline-block;width:20px;"><img src='/proj/img/move_wev8.png' title='<%=SystemEnv.getHtmlLabelName(82783, user.getLanguage())%>'/></span>
									<%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%>
									</wea:item>
									<wea:item attributes='<%=attributes %>'>
									<%
									if (canEdit){
									%>
									
									<select class=inputstyle name="selectSub_<%=subindex%>" oldval="<%=codeMemberValue%>" onchange="checkselect('2',this)">
									<option value=-2 <% if(("-2").equals(codeMemberValue)) { %> selected <% } %>><%=SystemEnv.getHtmlLabelName(22788,user.getLanguage())%></option>
									<%
									RecordSet.executeSql(subCompanyFieldSql);  
									while(RecordSet.next()){
									tempFieldId = RecordSet.getInt("ID");
									%>
									<option value=<%= tempFieldId %> <% if((""+tempFieldId).equals(codeMemberValue)) { %> selected <% } %> ><%= Util.null2String(RecordSet.getString("fieldLable")) %></option>
									<%}%>
									</select>
									&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
									<%=SystemEnv.getHtmlLabelName(15935,user.getLanguage())%>&nbsp;&nbsp;&nbsp;&nbsp;
									<select class=inputstyle id="subselect<%=subindex %>" name="subselect<%=subindex %>" onchange="changesub(<%=subindex%>)">
										<option value=0><%=SystemEnv.getHtmlLabelName(22764,user.getLanguage())%></option>
									<%
									if(enablecode.equals("1")){
									%>
										<option value=1 selected ><%=SystemEnv.getHtmlLabelName(22289,user.getLanguage())%></option>
									</select>&nbsp;&nbsp;&nbsp;&nbsp;
									<span id="subComspan<%=subindex %>" name="subComspan<%=subindex %>" style="display:none;">
										<button type="button"  class="e8_btn_top middle" style="border:1px solid #aecef1 !important" onclick="openDialogBeforSave(this);" ><%=SystemEnv.getHtmlLabelName(33872,user.getLanguage())%></button>
										<%--<a href="javascript:void(0);" onClick="subComAbbr(<%= wfid %>, <%= formid %>, <%= isbill %>,<%= "".equals(codeMemberValue)?"-1":codeMemberValue %>)"><%=SystemEnv.getHtmlLabelName(33872,user.getLanguage())%></a> --%>
									</span>
									<%}else{%>
										<option value=1><%=SystemEnv.getHtmlLabelName(22289,user.getLanguage())%></option>
									</select>&nbsp;&nbsp;&nbsp;&nbsp;
									<span id="subComspan<%=subindex %>" name="subComspan<%=subindex %>" style="display:inline-block;">
										<button type="button"  class="e8_btn_top middle" style="border:1px solid #aecef1 !important" onclick="openDialogBeforSave(this);" ><%=SystemEnv.getHtmlLabelName(33872,user.getLanguage())%></button>
										<%--<a href="javascript:void(0);" onClick="subComAbbr(<%= wfid %>, <%= formid %>, <%= isbill %>,<%= "".equals(codeMemberValue)?"-1":codeMemberValue %>)"><%=SystemEnv.getHtmlLabelName(33872,user.getLanguage())%></a> --%>
									</span>
									<%} %>
									<input type=button style="Float:right;" name="deleteInputCol" class=delbtn accessKey=E onClick="deleteCol(this)" title="E-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>"></input>
									<input type=button style="Float:right;" name="addInputCol" class=addbtn accessKey=A onClick="addStringCol(this)" title="A-<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>"></input> 
									<input type="hidden"  name="selectNum2" value="<%=subindex %>" >
									<%} else {
										out.println("<div>"+codeMemberValue+"</div>");
									}
									%>
									</wea:item>
									<%
									subindex++;
									struSeqselectList.add("subComSelect");
									//3:上级分部
									}else if(codeMemberType.equals("5") && concreteField.equals("3")){
									%>
									<%attrs = "{'codevalue':'"+codeMemberName+"','customAttrs':'concrete=3'}"; %>
									<wea:item attributes='<%=attrs %>'>
									<span movingicon style="display:inline-block;width:20px;"><img src='/proj/img/move_wev8.png' title='<%=SystemEnv.getHtmlLabelName(82783, user.getLanguage())%>'/></span>
									<%=SystemEnv.getHtmlLabelName(22753,user.getLanguage())%>
									</wea:item>
									<wea:item attributes='<%=attributes %>'>
									<%
									if (canEdit){
									%>
								
									<select class=inputstyle name="selectSupSub_<%=supsubindex%>" oldval="<%=codeMemberValue%>" onchange="checkselect('3',this)">
									<option value=-2 <% if(("-2").equals(codeMemberValue)) { %> selected <% } %>><%=SystemEnv.getHtmlLabelName(22787,user.getLanguage())%></option>
									<%
									RecordSet.executeSql(subCompanyFieldSql);
									while(RecordSet.next()){
									tempFieldId = RecordSet.getInt("ID");
									%>
									<option value=<%= tempFieldId %> <% if((""+tempFieldId).equals(codeMemberValue)) { %> selected <% } %> ><%= Util.null2String(RecordSet.getString("fieldLable")) %></option>
									<%}%>
									</select>
									&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
									<%=SystemEnv.getHtmlLabelName(15935,user.getLanguage())%>&nbsp;&nbsp;&nbsp;&nbsp;
									<select class=inputstyle id="supselect<%=supsubindex%>" name="supselect<%=supsubindex%>" onchange="changesup(<%=supsubindex%>)">
									
										<option value=0><%=SystemEnv.getHtmlLabelName(22764,user.getLanguage())%></option>
									<%
									if(enablecode.equals("1")){
									%>
										<option value=1 selected ><%=SystemEnv.getHtmlLabelName(22289,user.getLanguage())%></option>
									
									</select>&nbsp;&nbsp;&nbsp;&nbsp;
									<span id="supSubspan<%=supsubindex%>" name="supSubspan<%=supsubindex%>" style="display:none;">
										<button type="button"  class="e8_btn_top middle" style="border:1px solid #aecef1 !important" onclick="openDialogBeforSave(this);" ><%=SystemEnv.getHtmlLabelName(33872,user.getLanguage())%></button>
										<%--<a href="javascript:void(0);" onClick="supSubComAbbr(<%= wfid %>, <%= formid %>, <%= isbill %>,<%= "".equals(codeMemberValue)?"-1":codeMemberValue %>)"><%=SystemEnv.getHtmlLabelName(33872,user.getLanguage())%></a> --%>
									</span>
									<%}else{%>
										<option value=1><%=SystemEnv.getHtmlLabelName(22289,user.getLanguage())%></option>
									</select>&nbsp;&nbsp;&nbsp;&nbsp;
									<span id="supSubspan<%=supsubindex%>" name="supSubspan<%=supsubindex%>" style="display:inline-block;">
										<button type="button"  class="e8_btn_top middle" style="border:1px solid #aecef1 !important" onclick="openDialogBeforSave(this);" ><%=SystemEnv.getHtmlLabelName(33872,user.getLanguage())%></button>
										<%--<a href="javascript:void(0);" onClick="supSubComAbbr(<%= wfid %>, <%= formid %>, <%= isbill %>,<%= "".equals(codeMemberValue)?"-1":codeMemberValue %>)"><%=SystemEnv.getHtmlLabelName(33872,user.getLanguage())%></a> --%>
									</span>
									<%} %>
									<input type=button style="Float:right;" name="deleteInputCol" class=delbtn accessKey=E onClick="deleteCol(this)" title="E-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>"></input>
									<input type=button style="Float:right;" name="addInputCol" class=addbtn accessKey=A onClick="addStringCol(this)" title="A-<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>"></input> 
									<input type="hidden"  name="selectNum3" value="<%=supsubindex %>" >
									<%} else {
										out.println("<div>"+codeMemberValue+"</div>");
									}
									%>
									</wea:item>
									<%
									supsubindex++;
									struSeqselectList.add("supSubSelect");
									//4:年

									}else if(codeMemberType.equals("5") && concreteField.equals("4")){
									%>
									<%attrs = "{'codevalue':'"+codeMemberName+"','customAttrs':'concrete=4'}"; %>
									<wea:item attributes='<%=attrs %>'>
									<span movingicon style="display:inline-block;width:20px;"><img src='/proj/img/move_wev8.png' title='<%=SystemEnv.getHtmlLabelName(82783, user.getLanguage())%>'/></span>
									<%=SystemEnv.getHtmlLabelName(445,user.getLanguage())%>
									</wea:item>
									<wea:item attributes='<%=attributes %>'>
									<%
									if (canEdit){
									%>
									<select class=inputstyle name="selectYear_<%=yindex%>" oldval="<%=codeMemberValue%>" onchange="checkselect('5',this)" >
									<option value=-2 <% if(("-2").equals(codeMemberValue)) { %> selected <% } %>><%=SystemEnv.getHtmlLabelName(22793,user.getLanguage())%></option>
									<%
									RecordSet.executeSql(yearFieldSql);										
									while(RecordSet.next()){
									tempFieldId = RecordSet.getInt("ID");

									%>
									<option value=<%= tempFieldId %> <% if((""+tempFieldId).equals(codeMemberValue)) { %> selected <% } %> ><%= Util.null2String(RecordSet.getString("fieldLable")) %></option>
									<%}%>
									</select>
									<input type=button style="Float:right;" name="deleteInputCol" class=delbtn accessKey=E onClick="deleteCol(this)" title="E-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>"></input>
									<input type=button style="Float:right;" name="addInputCol" class=addbtn accessKey=A onClick="addStringCol(this)" title="A-<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>"></input>
									<input type="hidden"  name="selectNum5" value="<%=yindex %>" >
									<%} else {
										out.println("<div>"+codeMemberValue+"</div>");
									}
									%>
									</wea:item>
										
									<%
									yindex++;
									//5:月

									}else if(codeMemberType.equals("5") && concreteField.equals("5")){
									%>
									<%attrs = "{'codevalue':'"+codeMemberName+"','customAttrs':'concrete=5'}"; %>
									<wea:item attributes='<%=attrs %>'>
									<span movingicon style="display:inline-block;width:20px;"><img src='/proj/img/move_wev8.png' title='<%=SystemEnv.getHtmlLabelName(82783, user.getLanguage())%>'/></span>
									<%=SystemEnv.getHtmlLabelName(6076,user.getLanguage())%>
									</wea:item>
									<wea:item attributes='<%=attributes %>'>
									<%
									if (canEdit){
									%>
									<select class=inputstyle name="selectMonth_<%=mindex%>" oldval="<%=codeMemberValue%>" onchange="checkselect('6',this)" >
									<option value=-2 <% if(("-2").equals(codeMemberValue)) { %> selected <% } %>><%=SystemEnv.getHtmlLabelName(22794,user.getLanguage())%></option>
									<%
									RecordSet.executeSql(monthFieldSql);										
									while(RecordSet.next()){
									tempFieldId = RecordSet.getInt("ID");

									%>
									<option value=<%= tempFieldId %> <% if((""+tempFieldId).equals(codeMemberValue)) { %> selected <% } %> ><%= Util.null2String(RecordSet.getString("fieldLable")) %></option>
									<%
									}
									%>
									</select>
									<input type=button style="Float:right;" name="deleteInputCol" class=delbtn accessKey=E onClick="deleteCol(this)" title="E-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>"></input>
									<input type=button style="Float:right;" name="addInputCol" class=addbtn accessKey=A onClick="addStringCol(this)" title="A-<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>"></input>
									<input type="hidden"  name="selectNum6" value="<%=mindex %>" >
									<%} else {
										out.println("<div>"+codeMemberValue+"</div>");
									}
									%>
									</wea:item>
										
									<%	
									mindex++;
									//6:日

									}else if(codeMemberType.equals("5") && concreteField.equals("6")){
									%>
									<%attrs = "{'codevalue':'"+codeMemberName+"','customAttrs':'concrete=6'}"; %>
									<wea:item attributes='<%=attrs %>'>
									<span movingicon style="display:inline-block;width:20px;"><img src='/proj/img/move_wev8.png' title='<%=SystemEnv.getHtmlLabelName(82783, user.getLanguage())%>'/></span>
									<%=SystemEnv.getHtmlLabelName(390,user.getLanguage())%>
									</wea:item>
									<wea:item attributes='<%=attributes %>'>
									<%
									if (canEdit){
									%>
									<select class=inputstyle name="selectDay_<%=dindex%>" oldval="<%=codeMemberValue%>" onchange="checkselect('7',this)" >
									<option value=-2 <% if(("-2").equals(codeMemberValue)) { %> selected <% } %>><%=SystemEnv.getHtmlLabelName(15625,user.getLanguage())%></option>
									<%
									RecordSet.executeSql(dateFieldSql);										
									while(RecordSet.next()){
									tempFieldId = RecordSet.getInt("ID");

									%>
									<option value=<%= tempFieldId %> <% if((""+tempFieldId).equals(codeMemberValue)) { %> selected <% } %> ><%= Util.null2String(RecordSet.getString("fieldLable")) %></option>
									<%} %>
									</select>
									<input type=button style="Float:right;" name="deleteInputCol" class=delbtn accessKey=E onClick="deleteCol(this)" title="E-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>"></input>
									<input type=button style="Float:right;" name="addInputCol" class=addbtn accessKey=A onClick="addStringCol(this)" title="A-<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>"></input>
									<input type="hidden"  name="selectNum7" value="<%=dindex %>" >
									<%} else {
										out.println("<div>"+codeMemberValue+"</div>");
									}
									%>
									</wea:item>
										
									<%	
									dindex++;
									//8:流水号位数

									}else if(concreteField.equals("8")){
									%>
									<%attrs = "{'codevalue':'"+codeMemberName+"','customAttrs':'concrete=8'}"; %>
									<wea:item attributes='<%=attrs %>'>
									<span movingicon style="display:inline-block;width:20px;"><img src='/proj/img/move_wev8.png' title='<%=SystemEnv.getHtmlLabelName(82783, user.getLanguage())%>'/></span>
									<%=SystemEnv.getHtmlLabelName(18811,user.getLanguage())%>
									</wea:item>
									<wea:item attributes='<%=attributes %>'>
									<%
									if (canEdit){
									%>
									<input type=text name="inputt<%=i%>" maxlength="16" onchange='checkint("inputt<%=i%>");proView();' class=inputstyle   value="<%=codeMemberValue%>" >
									<input type=button style="Float:right;" name="addInputCol" class=addbtn accessKey=A onClick="addStringCol(this)" title="A-<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>"></input> 
									<%} else {
										out.println("<div>"+codeMemberValue+"</div>");
									}
									%>
									</wea:item>
									<%	
									}else if(concreteField.equals("9")){
									%>
									<%attrs = "{'codevalue':'"+codeMemberName+"','customAttrs':'concrete=9'}"; %>
									<wea:item attributes='<%=attrs %>'>
									<span movingicon style="display:inline-block;width:20px;"><img src='/proj/img/move_wev8.png' title='<%=SystemEnv.getHtmlLabelName(82783, user.getLanguage())%>'/></span>
									<%=SystemEnv.getHtmlLabelName(18729,user.getLanguage())%>
									</wea:item>
									<wea:item attributes='<%=attributes %>'>
									<%
									if (canEdit){
									%>
									<input type=text name="inputt<%=i%>" onchange=proView() class=inputstyle   value="<%=codeMemberValue%>">
									<input type=button style="Float:right;" name="deleteInputCol" class=delbtn accessKey=E onClick="deleteCol(this)" title="E-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>"></input>
									<input type=button style="Float:right;" name="addInputCol" class=addbtn accessKey=A onClick="addStringCol(this)" title="A-<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>"></input> 
									<%} else {
										out.println("<div>"+codeMemberValue+"</div>");
									}
									%>
									</wea:item>
									<%	
									}%>
								<!--  -->
								<%}
								}else{
									%>
									<%
										String attrs = "{'codevalue':'18811','customAttrs':'concrete=8'}"; 
										String attributes = "{'colspan':'full','trId':'TR_0','customer1':'member'}";
									%>
									<wea:item attributes='<%=attrs %>'>
									<span movingicon style="display:inline-block;width:20px;"><img src='/proj/img/move_wev8.png' title='<%=SystemEnv.getHtmlLabelName(82783, user.getLanguage())%>'/></span>
									<%=SystemEnv.getHtmlLabelName(18811,user.getLanguage())%>
									</wea:item>
									<wea:item attributes='<%=attributes %>'>
									<input type=text name="inputt0" maxlength="16" onchange='checkint("inputt0");proView();' class=inputstyle   value="" >
									<input type=button style="Float:right;" name="addInputCol" class=addbtn accessKey=A onClick="addStringCol(this)" title="A-<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>"></input> 
									
									</wea:item>
									<%	
								}
								}
							%>
							</wea:group>
						</wea:layout>
					</wea:item>
				</wea:group>
			</wea:layout>        		
		</wea:item>
	</wea:group>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(83550,user.getLanguage())%>' attributes="<%=groupShow%>" >
	<%if(!hasHistoryCode){
		String trFieldSequenceShow = "{'classTR':'notMove','samePair':'trFieldSequenceShow'}";
		String trFieldSequenceShow2 = "{'colspan':'full','classTR':'notMove','samePair':'trFieldSequenceShow'}";
		if(selectFieldId<=0){
			trFieldSequenceShow = "{'classTR':'notMove','display':'none','samePair':'trFieldSequenceShow'}";
			trFieldSequenceShow2 = "{'colspan':'full','classTR':'notMove','display':'none','samePair':'trFieldSequenceShow'}";
		}
	%>
	
	<!-- 流程、表单单独流水 -->
	<wea:item attributes="{'classTR':'notMove','samePair':'workflowSequenceShow'}"><%=SystemEnv.getHtmlLabelName(21189,user.getLanguage())%></wea:item>
	<wea:item attributes="{'colspan':'full','classTR':'notMove','samePair':'workflowSequenceShow'}">
		<input tzCheckbox="true" class="inputStyle" type="checkbox" onclick = "clickPrompt()"  name="workflowSeqAlone" value="1" <%if ("1".equals(workflowSeqAlone)){ out.println("checked");}else if("0".equals(workflowSeqAlone)){out.println("");}else{out.println("checked");}%> <%if(!canEdit){%>disabled<%}%>>
	</wea:item>
	<!-- 日期单独流水 -->
	<wea:item attributes="{'classTR':'notMove','samePair':'dateSequenceShow'}"><%=SystemEnv.getHtmlLabelName(19418,user.getLanguage())%></wea:item>
	<wea:item attributes="{'colspan':'full','classTR':'notMove','samePair':'dateSequenceShow'}">
		<input tzCheckbox="true" type="checkbox" name="dateSeqAlone" value="1" <%if ("1".equals(dateSeqAlone)) out.println("checked");%> >&nbsp;&nbsp;&nbsp;
		<select class="inputstyle" name="dateSeqselect" id="dateSeqselect" onchange="changeCurrentDate()">
			<option value="3" <%if ("3".equals(dateSeqselect)||"".equals(dateSeqselect)) out.println("selected");%>><%=SystemEnv.getHtmlLabelName(390,user.getLanguage())%></option>
			<option value="2" <%if ("2".equals(dateSeqselect)) out.println("selected");%>><%=SystemEnv.getHtmlLabelName(6076,user.getLanguage())%></option>
			<option value="1" <%if ("1".equals(dateSeqselect)) out.println("selected");%>><%=SystemEnv.getHtmlLabelName(445,user.getLanguage())%></option>
		</select>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<%=SystemEnv.getHtmlLabelName(33460,user.getLanguage())%>&nbsp;&nbsp;&nbsp;&nbsp;
		<!-- 日期选中值 -->
		<select class="inputstyle" name="dateCorrespondField" id="dateCorrespondField" >
			<option value=-2 >请选择</option>
		</select>

	</wea:item>
	<!-- 机构单独流水 -->
	<wea:item attributes="{'classTR':'notMove','samePair':'struSequenceShow'}"><%=SystemEnv.getHtmlLabelName(22756,user.getLanguage())%></wea:item>
	<wea:item attributes="{'colspan':'full','classTR':'notMove','samePair':'struSequenceShow'}">
		<input tzCheckbox="true" type="checkbox" name="struSeqAlone" value="1" <%if ("1".equals(struSeqAlone)) out.println("checked");%> >&nbsp;&nbsp;&nbsp;
		
		<select class="inputstyle" name="struSeqselect" id="struSeqselect" onchange="changeCurrentField()">
			<%if(struSeqselectList.contains("deptSelect")){%>
			<option value="3" <%if ("3".equals(struSeqselect)||"".equals(struSeqselect)) out.println("selected");%>><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></option>
			<%}
			if(struSeqselectList.contains("subComSelect")){
			%>
			<option value="2" <%if ("2".equals(struSeqselect)) out.println("selected");%>><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></option>
			<%}
			if(struSeqselectList.contains("supSubSelect")){
			%>
			<option value="1" <%if ("1".equals(struSeqselect)) out.println("selected");%>><%=SystemEnv.getHtmlLabelName(22753,user.getLanguage())%></option>
			<%} %>
		</select>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<%=SystemEnv.getHtmlLabelName(33460,user.getLanguage())%>&nbsp;&nbsp;&nbsp;&nbsp;
		<!-- 机构选中值 -->
		<select class="inputstyle" name="struCorrespondField" id="struCorrespondField" >
			<option value=-2 >-2</option>
		</select>

	<!-- 选择框字段单独流水 -->
	</wea:item>					
	<wea:item attributes='<%=trFieldSequenceShow %>'><%=SystemEnv.getHtmlLabelName(22215,user.getLanguage())%></wea:item>
	<wea:item attributes='<%=trFieldSequenceShow2 %>'>
		<input tzCheckbox="true" class="inputStyle" type="checkbox" name="fieldSequenceAlone" value="1" <%if ("1".equals(fieldSequenceAlone)) out.println("checked");%> <%if(!canEdit){%>disabled<%}%>>
		&nbsp;&nbsp;&nbsp;
		<select class="inputstyle" name="sltCorrespondField" id="sltCorrespondField" >
		  <option value=-2 >-2</option>
        </select>
	</wea:item>
	<%}%>
	
	<wea:item attributes="{'classTR':'notMove'}"><%=SystemEnv.getHtmlLabelName(221,user.getLanguage())%></wea:item>
	<wea:item attributes="{'colspan':'full','classTR':'notMove'}">
                    <table style="border:1px solid #0070C0;border-bottom:none;border-left:none;border-top:none;" cellspacing="0" cellpadding="0">
                    	<tr id="TR_pro"></tr>
                    </table>
	</wea:item>	
	<%--
	<%
	if(!hasHistoryCode){
		RecordSet.execute("select 1 from workflow_Code where (formId="+formid+" and isBill='"+isbill+"') or (flowId="+wfid+" and workflowSeqAlone='1')");
		if(RecordSet.next()){
	%> --%>
		<wea:item attributes="{'classTR':'notMove'}">
			<a href="#" onClick="beforeSeqSave(100)"><%=SystemEnv.getHtmlLabelName(20578,user.getLanguage())%></a>
		</wea:item>
		<wea:item attributes="{'colspan':'full','classTR':'notMove'}">
			<a href="#" onClick="beforeSeqSave(101)"><%=SystemEnv.getHtmlLabelName(22779,user.getLanguage())%></a>
		</wea:item>	
	<%--<%
		}
	}
	%>--%>
	</wea:group>
</wea:layout>
<br>
<center>
     <input type="hidden" name="wfid" value="<%=wfid%>" >
    <INPUT TYPE="hidden" NAME="postValue" id="postValue">
    <INPUT TYPE="hidden" NAME="formid" value="<%=formid%>">
    <INPUT TYPE="hidden" NAME="isBill" value="<%=isbill%>">    
    <INPUT TYPE="hidden" id="wfconcrete" NAME="wfconcrete" value="">    
    <INPUT TYPE="hidden" id="wfcodevalue" NAME="wfcodevalue" value="">    
<center>
</form>
<div style="display:none"><iframe name="wfcodeframe"></iframe></div>
</body>

<jsp:include page="wfcode_script.jsp">
    <jsp:param value="<%=canEdit %>" name="canEdit"/>
    <jsp:param value="<%=correspondDate %>" name="correspondDate"/>
    <jsp:param value="<%=selectCorrespondField %>" name="selectCorrespondField"/>
    <jsp:param value="<%=selectFieldSql %>" name="selectFieldSql"/>
    <jsp:param value="<%=departmentFieldSql %>" name="departmentFieldSql"/>
    <jsp:param value="<%=dateFieldSql %>" name="dateFieldSql"/>
    <jsp:param value="<%=monthFieldSql %>" name="monthFieldSql"/>
    <jsp:param value="<%=yearFieldSql %>" name="yearFieldSql"/>
    <jsp:param value="<%=subCompanyFieldSql %>" name="subCompanyFieldSql"/>
    <jsp:param value="<%=tempFieldId %>" name="tempFieldId"/>
    <jsp:param value="<%=formid %>" name="formid"/>
    <jsp:param value="<%=isbill %>" name="isbill"/>
    <jsp:param value="<%=correspondField %>" name="correspondField"/>
	<jsp:param value="<%=wfid %>" name="wfid"/>
</jsp:include>
</html>
