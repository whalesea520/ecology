
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.text.*" %>
<%@ page import="weaver.general.Util,org.json.*" %>
<%@ page import="weaver.general.TimeUtil" %>
<%@ page import="weaver.general.SessionOper" %>
<%@ page import="weaver.hrm.performance.*" %>
<%@ page import="weaver.worktask.worktask.*" %>
<%@ page import="weaver.general.*" %>
<%@page import="weaver.workflow.workflow.GetShowCondition,weaver.hrm.resource.*"%>
<jsp:useBean id="recordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="recordSet_requestbase" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SecCategoryComInfo1" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="BaseBean" class="weaver.general.BaseBean" scope="page" />
<jsp:useBean id="taskManager" class="weaver.worktask.request.TaskManager" scope="page"/>
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%


int requestid = Util.getIntValue(request.getParameter("requestid"), 0);
//关联任务id
String retasklistid = Util.null2String(request.getParameter("tasklistid"));
Map<String,String>  taskResource = WorkTaskResourceUtil.getTaskResourceMap(requestid);
String liableperson = "",liablepersonname = "",enddate="",enddatetime="",taskcontent="",taskname="",checkor="",checkorname="",startdate="",startdatetime="";
int creater = 0;
//默认为正常状态
int urgency = 0;
String iscreate = "1";
if(requestid != 0){
	iscreate = "0";
	//已创建的任务
	ResourceComInfo  rc = new ResourceComInfo();
    recordSet_requestbase.execute("select *  from worktask_requestbase where requestid='"+requestid+"'");
    if(recordSet_requestbase.next()){
	    liableperson = Util.getIntValue(recordSet_requestbase.getString("liableperson"), 0)+"";
	    liablepersonname = rc.getResourcename(liableperson+"");
	    enddate =  recordSet_requestbase.getString("planenddate");
	    enddatetime = recordSet_requestbase.getString("planendtime");
		taskcontent = recordSet_requestbase.getString("taskcontent");
        taskname = recordSet_requestbase.getString("taskname");
		checkor = Util.getIntValue(recordSet_requestbase.getString("checkor"), 0)+"";
        checkorname = rc.getResourcename(checkor+"");
        urgency = recordSet_requestbase.getInt("urgency");
        //创建人
        creater = Util.getIntValue(recordSet_requestbase.getString("creater"),0);
	}
}else{
	 //新建任务
	 Date today = new Date();
	 SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
	 checkor = liableperson = user.getUID()+"";  
     checkorname = user.getUsername();
	 liablepersonname = checkorname;
	 enddate = format.format(today);
	 startdate = format.format(today);
	 format = new SimpleDateFormat("HH:mm");
     enddatetime = format.format(today);
     startdatetime = format.format(today);
   //创建人
     creater = user.getUID();
}
if(!"".equals(taskcontent)){
   taskcontent = taskcontent.replace("<br>","");
   taskcontent = taskcontent.replace("&nbsp;"," ");
}
//System.out.println("taskcontent=="+taskcontent);

int canCreateHistoryWorktask = Util.getIntValue(BaseBean.getPropValue("worktask", "canCreateHistoryWorktask"), 1);
session.setAttribute("relaterequest", "new");
String currentDay = TimeUtil.getCurrentDateString();
int isRefash = Util.getIntValue(request.getParameter("isRefash"), 0);
int wtid = Util.getIntValue(request.getParameter("wtid"), 0);
String worktaskName = "";
String hasCanCreateTasks = "false";

WTRequestManager wtRequestManager = new WTRequestManager(wtid);
wtRequestManager.setLanguageID(user.getLanguage());
wtRequestManager.setUserID(user.getUID());
Hashtable canCreateTasks_hs = wtRequestManager.getCanCreateTasks();
hasCanCreateTasks = (String)canCreateTasks_hs.get("hasCanCreateTasks");


if(!"true".equals(hasCanCreateTasks) && wtid!=0){
	response.sendRedirect("/notice/noright.jsp");
	return;
}
worktaskName = (String)canCreateTasks_hs.get("tasks_"+wtid);
String tasksSelectStr = (String)canCreateTasks_hs.get("tasksSelectStr");

Hashtable ret_hs_1 = wtRequestManager.getCreateFieldInfo();
ArrayList textheightList = (ArrayList)ret_hs_1.get("textheightList");
ArrayList idList = (ArrayList)ret_hs_1.get("idList");
ArrayList fieldnameList = (ArrayList)ret_hs_1.get("fieldnameList");
ArrayList crmnameList = (ArrayList)ret_hs_1.get("crmnameList");
ArrayList ismandList = (ArrayList)ret_hs_1.get("ismandList");
ArrayList fieldhtmltypeList = (ArrayList)ret_hs_1.get("fieldhtmltypeList");
ArrayList typeList = (ArrayList)ret_hs_1.get("typeList");
ArrayList iseditList = (ArrayList)ret_hs_1.get("iseditList");
ArrayList defaultvalueList = (ArrayList)ret_hs_1.get("defaultvalueList");
ArrayList defaultvaluecnList = (ArrayList)ret_hs_1.get("defaultvaluecnList");
ArrayList fieldlenList = (ArrayList)ret_hs_1.get("fieldlenList");
ArrayList issystemList = (ArrayList)ret_hs_1.get("issystemList");

//提醒设置
int remindtype = 0;
int beforestart = 0;
int beforestarttime = 0;
int beforestarttype = 0;
int beforestartper = 0;
int beforeend = 0;
int beforeendtime = 0;
int beforeendtype = 0;
int beforeendper = 0;
int annexmaincategory = 0;
int annexsubcategory = 0;
int annexseccategory = 0;
int issubmitremind = 0;
rs.execute("select * from worktask_base where id="+wtid);
if(rs.next()){
	remindtype = Util.getIntValue(rs.getString("remindtype"), 0);
	beforestart = Util.getIntValue(rs.getString("beforestart"), 0);
	beforestarttime = Util.getIntValue(rs.getString("beforestarttime"), 0);
	beforestarttype = Util.getIntValue(rs.getString("beforestarttype"), 0);
	beforestartper = Util.getIntValue(rs.getString("beforestartper"), 0);
	beforeend = Util.getIntValue(rs.getString("beforeend"), 0);
	beforeendtime = Util.getIntValue(rs.getString("beforeendtime"), 0);
	beforeendtype = Util.getIntValue(rs.getString("beforeendtype"), 0);
	beforeendper = Util.getIntValue(rs.getString("beforeendper"), 0);
	annexmaincategory = Util.getIntValue(rs.getString("annexmaincategory"), 0);
	annexsubcategory = Util.getIntValue(rs.getString("annexsubcategory"), 0);
	annexseccategory = Util.getIntValue(rs.getString("annexseccategory"), 0);
}

int maxUploadImageSize = 5;
maxUploadImageSize = Util.getIntValue(SecCategoryComInfo1.getMaxUploadFileSize(""+annexseccategory), 5);
if(maxUploadImageSize<=0){
	maxUploadImageSize = 5;
}
String startTimeType = "";
String endTimeType = "";
if(beforestarttype == 0){
	startTimeType = SystemEnv.getHtmlLabelName(1925,user.getLanguage());
}else if(beforestarttype == 1){
	startTimeType = SystemEnv.getHtmlLabelName(391,user.getLanguage());
}else{
	startTimeType = SystemEnv.getHtmlLabelName(15049,user.getLanguage());
}
if(beforeendtype == 0){
	endTimeType = SystemEnv.getHtmlLabelName(1925,user.getLanguage());
}else if(beforeendtype == 1){
	endTimeType = SystemEnv.getHtmlLabelName(391,user.getLanguage());
}else{
	endTimeType = SystemEnv.getHtmlLabelName(15049,user.getLanguage());
}
//更新操作
if(requestid != 0){
	remindtype = Util.getIntValue(recordSet_requestbase.getString("remindtype"), 0);
	beforestart = Util.getIntValue(recordSet_requestbase.getString("beforestart"), 0);
	issubmitremind = Util.getIntValue(recordSet_requestbase.getString("issubmitremind"), 0);
	beforestarttime = Util.getIntValue(recordSet_requestbase.getString("beforestarttime"), 0);
	beforestarttype = Util.getIntValue(recordSet_requestbase.getString("beforestarttype"), 0);
	beforestartper = Util.getIntValue(recordSet_requestbase.getString("beforestartper"), 0);
	beforeend = Util.getIntValue(recordSet_requestbase.getString("beforeend"), 0);
	//System.out.println("beforeend===="+beforeend);
	beforeendtime = Util.getIntValue(recordSet_requestbase.getString("beforeendtime"), 0);
	beforeendtype = Util.getIntValue(recordSet_requestbase.getString("beforeendtype"), 0);
	beforeendper = Util.getIntValue(recordSet_requestbase.getString("beforeendper"), 0);
	if(beforestarttype == 0){
		startTimeType = SystemEnv.getHtmlLabelName(1925,user.getLanguage());
	}else if(beforestarttype == 1){
		startTimeType = SystemEnv.getHtmlLabelName(391,user.getLanguage());
	}else{
		startTimeType = SystemEnv.getHtmlLabelName(15049,user.getLanguage());
	}
	if(beforeendtype == 0){
		endTimeType = SystemEnv.getHtmlLabelName(1925,user.getLanguage());
	}else if(beforeendtype == 1){
		endTimeType = SystemEnv.getHtmlLabelName(391,user.getLanguage());
	}else{
		endTimeType = SystemEnv.getHtmlLabelName(15049,user.getLanguage());
	}
}


String checkStr = "";

String needfav ="1";
String needhelp ="";
String titlename = SystemEnv.getHtmlLabelName(82, user.getLanguage())+": "+worktaskName;
String imagefilename = "/images/hdMaintenance_wev8.gif";

String planStartDate = "";
String planEndDate = "";
String planDays = "";
String needcheckField = "";
String checkorField = "";

//根据浏览框id值获取具体的名称
GetShowCondition broconditions=new GetShowCondition();
 //多选按钮id
String browsermoreids=",17,18,37,257,57,65,194,240,135,152,162,166,168,170,";

%>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
   //只有创建人本身 才可以保存 和 提交
   if(creater == user.getUID() || (user.getUID()+"").equals(liableperson)){
		if(!"0001".equals(retasklistid)){//编辑任务只有保存
			RCMenu += "{"+SystemEnv.getHtmlLabelName(615, user.getLanguage())+",javaScript:OnSubmit(),_self} " ;
			RCMenuHeight += RCMenuHeightStep;
		}
		RCMenu += "{"+SystemEnv.getHtmlLabelName(86, user.getLanguage())+",javaScript:OnSave(),_self} " ;
		RCMenuHeight += RCMenuHeightStep;
   }
   
   if(requestid != 0) {  //共享放在右键
	   RCMenu += "{"+SystemEnv.getHtmlLabelName(119, user.getLanguage())+",javaScript:OnShare(),_self} " ;
		RCMenuHeight += RCMenuHeightStep;
   }
	 
 
%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>


<!DOCTYPE html>
<html>
<head lang="en">
    <title></title>
    <link rel="stylesheet"  href="../css/worktaskcreate_wev8.css">
	<link rel="stylesheet"  href="../css/powerFloat_wev8.css">
</head>
<body>


<form name="taskform" id="taskform" method="post" action="AddWorktask.jsp">

<input type="hidden" name="wtid" id="wtid" value="<%=wtid%>">
<input type="hidden" name="operationType">
<input type="hidden" id="isCreate" name="isCreate" value="<%=iscreate%>">
<input type="hidden" id="needcheck" name="needcheck" value="wtid" >
<input type="hidden" id="functionPage" name="functionPage" value="AddWorktask.jsp" >
<input type="hidden" id="isRefash" name="isRefash" value="<%=isRefash%>" >
<input type="hidden" id="istemplate" name="istemplate" value="0" >
<input type="hidden" id="requestid" name="requestid" value="<%=requestid%>" >
<input type="hidden"  name="taskid_<%=requestid%>" value="<%=wtid%>" >
<input type="hidden"  name="retasklistid" value="<%=retasklistid%>" >



<div id="_xTable" style="background:#FFFFFF;padding:3px;width:100%;text-align: center;" valign="top">
</div>
<%  
//如果是保存未提交,则可以进行共享操作,移到右键
if(requestid != 0) { %>
<div class='wtshare' onclick='OnShare();' title='<%=SystemEnv.getHtmlLabelName(119,user.getLanguage())%>' style='display:none'>
     +
</div>
<% } %>

<div id="worktaskdesign">
    <% if(!"".equals(retasklistid) && !"0001".equals(retasklistid)){ %>
	    <div class="remindmsg">
	        <%=SystemEnv.getHtmlLabelNames("31830,1332",user.getLanguage())%>： <%=taskManager.getRequestNameByTaskListID(retasklistid) %>
	    </div>
    <%}else if("0001".equals(retasklistid)){//标识 编辑已在进行、延期、验证状态 任务 %>
       <div class="remindmsg">
	        <%=SystemEnv.getHtmlLabelName(15284,user.getLanguage())%>： <%=taskManager.getRowInfoByid("worktask_requestbase","requestid",requestid+"","taskname") %>
	    </div>
    <%} %>
    <div class="worktask_base">
        <div class="lf">
            <span class="middlehelper"></span>
            <img src="../images/user_wev8.png" title='<%=SystemEnv.getHtmlLabelName(16936,user.getLanguage())%>' style="cursor: pointer;">
            <span class="dutyman resourceselection">
			        <!--责任人-->
					<brow:browser viewType="0" name='<%="field3_"+requestid%>'
						browserUrl="/hrm/resource/MutiResourceBrowser.jsp?selectedids=&resourceids="
						hasInput="true" isSingle="true" hasBrowser = "true" isMustInput="1"
						completeUrl="/data.jsp?type=17"   browserValue='<%=liableperson+""%>' browserSpanValue='<%=liablepersonname%>' width="90px">
					 </brow:browser> 	
			</span>
            <span class="splitline"></span>

			<input type="hidden" viewtype="1"  id="field11_<%=requestid%>" name="field11_<%=requestid%>" value="<%=startdate%>">
			<input type="hidden" viewtype="1"  id="field12_<%=requestid%>" name="field12_<%=requestid%>" value="<%=startdatetime%>">
			<input type="hidden" viewtype="1"  id="field13_<%=requestid%>" name="field13_<%=requestid%>" value="<%=enddate%>">
			<input type="hidden" viewtype="1"  id="field14_<%=requestid%>" name="field14_<%=requestid%>" value="<%=enddatetime%>">

			<input type="hidden" viewtype="1"  id="wfenddate" name="wfenddate" value="<%=enddate%> <%=enddatetime%>">
            <img src="../images/datepic_wev8.png"  title='<%=SystemEnv.getHtmlLabelName(22326,user.getLanguage())%>' class='datepic Calendar'  onclick="onShowPlanDateCompute('wfenddate', 'wfenddatespan', '1','yyyy-MM-dd HH:mm')" >
            <span name='wfenddatespan' id='wfenddatespan'><%=enddate%> <%=enddatetime%></span>
        </div>
        <div class="rf">
            <span class="middlehelper"></span>
            <span class="topbutton"></span>
            <span class="splitline"></span>
            <img src="../images/trace_wev8.png" title='<%=SystemEnv.getHtmlLabelName(83554,user.getLanguage())%>' class="trace"  style="display:none">
            <img src="../images/opmenu_wev8.png" class="opmenu" title='<%=SystemEnv.getHtmlLabelName(20622,user.getLanguage())%>' style="cursor: pointer;margin-left:8px">
            <img src="../images/saveitem_wev8.png" class="saveitem" style="display:none">
            <span class="splitline"></span>
            <img src="../images/closeitem_wev8.png" class="closeitem"  title='<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>' style="cursor: pointer;">
        </div>
    </div>
    

	<div class="worktask_detailinfo">
		          <div class="headinfo">
		              <div class="lf">
		                  <span class="middlehelper"></span>
		                  <span id='urgelevelshow' class="normal"><input type='hidden'  name='urgelevel'></span>
		                  <img src="../images/urgelevel_wev8.png" class='urgelevel' style="cursor: pointer;">
		                  <span><input type='text' placeholder='<%=SystemEnv.getHtmlLabelNames("33010,24986",user.getLanguage())%>' name='taskname' value='<%=taskname%>' style='width:300px;border:none;'/></span>
		              </div>
		              <div class="rf">
		                  <span class="middlehelper"></span>
		                  <img src="../images/user_wev8.png" title='<%=SystemEnv.getHtmlLabelName(22164,user.getLanguage())%>' style="cursor: pointer;" >
		                  <span class="resourceselection">
								<brow:browser viewType="0" name='<%="field2_"+requestid %>'
									browserUrl="/hrm/resource/MutiResourceBrowser.jsp?selectedids=&resourceids="
									hasInput="true" isSingle="true" hasBrowser = "true" isMustInput="1"
									completeUrl="/data.jsp?type=17"   browserValue='<%=checkor+""%>' browserSpanValue='<%=checkorname%>' width="110px">
								 </brow:browser> 	
						 </span>
		              </div>
		          </div>
		        <div class="fieldinfo taskcontent">
		            <span class="middlehelper"></span>
		            <span class='taskcontentdes'>
					   <!--计划任务-->
					   <textarea placeholder='<%=SystemEnv.getHtmlLabelNames("1332,81710",user.getLanguage())%>' class="taskcontentarea"  name='field7_<%=requestid%>'  style='width:100%;height:38px;overflow:auto;font-size:12px;border:none;resize:none;' ><%=taskcontent%></textarea>
					    
					</span>
		        </div>
		
		        <%
				 
				 for(int i=0; i<idList.size(); i++){
				   
					  int issystem_temp = Util.getIntValue((String)issystemList.get(i), 0);
					  //系统自带字段不展示
					  //if(issystem_temp == 1)
						  //continue;
				 %>
		           <div class="fieldinfo"><span class="middlehelper"></span>
					<%
					 
						int textheight_tmp = Util.getIntValue((String)textheightList.get(i), 0);
						int fieldid_tmp = Util.getIntValue((String)idList.get(i), 0);
						String fieldname_tmp = Util.null2String((String)fieldnameList.get(i));
						String crmname_tmp = Util.null2String((String)crmnameList.get(i));
						String fieldhtmltype_tmp = Util.null2String((String)fieldhtmltypeList.get(i));
						String type_tmp = Util.null2String((String)typeList.get(i));
						int isedit_tmp = Util.getIntValue((String)iseditList.get(i), 0);
						int ismand_tmp = Util.getIntValue((String)ismandList.get(i), 0);
						String value_tmp = Util.null2String((String)defaultvalueList.get(i));
						String defaultvaluecn_tmp = Util.null2String((String)defaultvaluecnList.get(i));
						String fieldlen_tmp = Util.null2String((String)fieldlenList.get(i));
						String sHtml = "";
						if(ismand_tmp == 1 && !"4".equals(fieldhtmltype_tmp)){
							checkStr += (",field" + fieldid_tmp + "_"+requestid);
						}
						if("planstartdate".equalsIgnoreCase(fieldname_tmp)){
							planStartDate = "field" + fieldid_tmp + "_"+requestid;
						}else if("planenddate".equalsIgnoreCase(fieldname_tmp)){
							planEndDate = "field" + fieldid_tmp + "_"+requestid;
						}else if("plandays".equalsIgnoreCase(fieldname_tmp)){
							planDays = "field" + fieldid_tmp + "_"+requestid;
							if("".equals(value_tmp.trim())){
								value_tmp = "0";
								defaultvaluecn_tmp = "0";
							}
						}else if("needcheck".equalsIgnoreCase(fieldname_tmp)){
							needcheckField = "field"+fieldid_tmp+"_";
						}else if("checkor".equalsIgnoreCase(fieldname_tmp)){
							checkorField = "field"+fieldid_tmp+"_";
						}
						
						int fieldtype = Util.getIntValue(type_tmp);
						
						//判断 浏览框 是否 多选
		                String isSingle = browsermoreids.indexOf(","+fieldtype+",")>-1?"false":"true";
		
		                //如果是已创建的任务,则获取当前值
						if(requestid != 0){
						   value_tmp = Util.null2String(recordSet_requestbase.getString(fieldname_tmp));
						}
						
						if(!"3".equals(fieldhtmltype_tmp) || ("3".equals(fieldhtmltype_tmp) && (fieldtype==2 || fieldtype==19))){//非浏览框,除日期浏览框
						   if(requestid == 0){
						     //创建表单元素
							 sHtml = wtRequestManager.getCellHtml(textheight_tmp,fieldid_tmp, fieldname_tmp, fieldlen_tmp, crmname_tmp, fieldhtmltype_tmp, type_tmp, isedit_tmp, ismand_tmp, value_tmp, defaultvaluecn_tmp);
						   }else{
		                      //编辑表单元素
		                      sHtml = wtRequestManager.getFieldCellWithValue(textheight_tmp,fieldid_tmp, fieldname_tmp, fieldlen_tmp, 
							    		crmname_tmp, fieldhtmltype_tmp, type_tmp, isedit_tmp, ismand_tmp, value_tmp, requestid);
						   }
						}
					%>
					       <% if(!"3".equals(fieldhtmltype_tmp)  || ("3".equals(fieldhtmltype_tmp) && (fieldtype==2 || fieldtype==19))){//非浏览框 %>
					           <span class="label"><%=crmname_tmp %></span><span><%=sHtml %></span>
					       <%}else{//浏览框 %>
					           <span class="label"><%=crmname_tmp %></span>
						       <span>
						               <%
						                String url=BrowserComInfo.getBrowserurl(""+fieldtype);     // 浏览按钮弹出页面的url
										String linkurl=BrowserComInfo.getLinkurl(""+fieldtype);    // 浏览值点击的时候链接的url
										//System.out.println("url="+url);
									   %>
										<%if(fieldtype==2 || fieldtype==19){// 这部分已无用%>
											<input type="hidden" name="field<%=fieldid_tmp%>_<%=requestid%>" value="<%=value_tmp%>" >
											<button class=Calendar type="button"   
											<%if(fieldtype==2){%>
											 onclick="onSearchWFDate(defaultvaluespan_<%=fieldid_tmp%>, field<%=fieldid_tmp%>_<%=requestid%>)"
											<%}else{%>
											 onclick ="onSearchWFTime(defaultvaluespan_<%=fieldid_tmp%>, field<%=fieldid_tmp%>_<%=requestid%>)"
											<%}%>
											 ></button>
											 <span name="defaultvaluespan_<%=fieldid_tmp%>" id="defaultvaluespan_<%=fieldid_tmp%>"><%=value_tmp%></span>
										<%}else if("liableperson".equalsIgnoreCase(fieldname_tmp) ){//责任人%>
											 <brow:browser viewType="0" name='<%="field"+fieldid_tmp+"_"+requestid%>'
												browserUrl='<%=url+"?selectedids=&resourceids="%>'
												hasInput="true" isSingle='<%=isSingle %>' hasBrowser = "true" isMustInput='1'
												completeUrl='<%="/data.jsp?type="+fieldtype %>'   browserValue='<%=user.getUID()+""%>' browserSpanValue='<%=user.getUsername() %>' width="260px">
									         </brow:browser> 	
										<%}else if(fieldtype==161 || fieldtype==162){%>
					                        <brow:browser viewType="0" name='<%="field"+fieldid_tmp+"_"+requestid%>'
												browserUrl='<%=url+"?type="+fieldlen_tmp%>'
												hasInput="false" isSingle='<%=isSingle %>' hasBrowser = "true" isMustInput='1'
												completeUrl='<%="/data.jsp?type="+fieldtype %>'   browserValue='<%=value_tmp%>' browserSpanValue='<%=broconditions.getShowCN("3", fieldtype+"", value_tmp, "1",fieldlen_tmp) %>' width="260px">
									       </brow:browser> 	
				                        <%}else if(ismand_tmp == 1){%>
											 <brow:browser viewType="0" name='<%="field"+fieldid_tmp+"_"+requestid%>'
											browserUrl='<%=url+"?selectedids=&resourceids="%>'
											hasInput="true" isSingle='<%=isSingle %>' hasBrowser = "true" isMustInput='2' _callback="afterBackBrowserData"
											completeUrl='<%="/data.jsp?type="+fieldtype %>' browserValue='<%=value_tmp%>' browserSpanValue='<%=broconditions.getShowCN("3", fieldtype+"", value_tmp, "1") %>'   width="260px">
								      			 </brow:browser> 	
										<%}else {%>
                                            <brow:browser viewType="0" name='<%="field"+fieldid_tmp+"_"+requestid%>'
											browserUrl='<%=url+"?selectedids=&resourceids="%>'
											hasInput="true" isSingle='<%=isSingle %>' hasBrowser = "true" isMustInput='1' _callback="afterBackBrowserData"
											completeUrl='<%="/data.jsp?type="+fieldtype %>' browserValue='<%=value_tmp%>' browserSpanValue='<%=broconditions.getShowCN("3", fieldtype+"", value_tmp, "1") %>'   width="260px">
								      			 </brow:browser> 	
										<% }%>
						        </span>
					       <%} %>
		               </div>
		        <%} %>
		
		    <div class="worktasklist" style="margin-bottom: 40px;">
		       <div class="head">
		           <div class="lf">
		               <span class="middlehelper"></span>
		               <span class="addpaddingbottom"><%=SystemEnv.getHtmlLabelNames("1332,491",user.getLanguage())%></span>
		           </div>
		           <div class="rf">
		               <span class="middlehelper"></span>
		               <img src="../images/addwt_wev8.png" title='<%=SystemEnv.getHtmlLabelName(83476,user.getLanguage())%>'  class="addpaddingbottom addwt">
		               <img src="../images/deletewt_wev8.png" title='<%=SystemEnv.getHtmlLabelName(23777,user.getLanguage())%>'  class="addpaddingbottom deletewt">
		           </div>
		       </div>
		       <div class="listbody">
		            <table >
		                 <colgroup>
		                      <col width="5%">
							  <col width="45%">
		                      <col width="25%">
		                      <col width="28%">
		                 </colgroup>
		                 <tbody >
		                     
		                 </tbody>
		            </table>
		       </div>
		    </div>
		
		    <div  class="worktasktabs">
			     <div class='headlinetop'></div>
		         <ul class="tabheader">
		             <li tabitem="taskexchange" ><%=SystemEnv.getHtmlLabelName(83556,user.getLanguage())%></li>
		             <li tabitem="taskremind"><%=SystemEnv.getHtmlLabelName(83558,user.getLanguage())%></li>
					 <li tabitem="taskresource"><%=SystemEnv.getHtmlLabelName(22672,user.getLanguage())%></li>
					 <li tabitem="tasklog"><%=SystemEnv.getHtmlLabelName(32061,user.getLanguage())%></li>
					 
				 </ul>
				 <div class='headlinebottom'></div>
		         <div class='panel' id='taskexchange'>
				       <ul>
		                  <li>
						    <!--
						     <div class='lcommentcontainer'>
								 <div class='lcommentinfo'>张三</div>
								 <div class='lcomment'>
									<img src="../images/chatblue_wev8.png" class='bluepoint'>
									<span  class='limgpointerholder'></span>
									<div class='lcommentdetail'>请尽快完成任务</div>
								 </div>
							 </div>
		
							 <div class='rcommentcontainer'>
								 <div class='rcommentinfo'>张三</div>
								 <div class='rcomment'>
									<img src="../images/chatgrey_wev8.png" class='greypoint'>
									<span  class='rimgpointerholder'></span>
									<div class='rcommentdetail'>请尽快完成任务</div>
								 </div>
							 </div>
		
							  <div class='rcommentcontainer'>
								 <div class='rcommentinfo'>张三</div>
								 <div class='rcomment'>
									<img src="../images/chatgrey_wev8.png" class='greypoint'>
									<span  class='rimgpointerholder'></span>
									<div class='rcommentdetail'>请尽快完成任务</div>
								 </div>
							 </div>
		                   -->
						  </li>
					   </ul>
				 </div>
				 <div class='panel' id='taskresource'>
				   <div class='resourcecontainer'>
		              <table >
					      <colgroup>
		                      <col width="20%">
							  <col width="80%">
		                  </colgroup>
					     <tr>
						   <td><%=SystemEnv.getHtmlLabelName(22194,user.getLanguage())%></td>
						   <td> 
						        <input type='hidden'  name='fileids' value='<%=taskResource.get("attachs")%>'>
								<div class='fileprocess'></div>
						        <div class='fileitems'></div>
						        <div  style='border: 1px solid #E7E7E7;width: 150px;height: 25px;position:relative;border-radius: 3px;'><span class='fileupload'></span></div>
						   </td>
						 </tr>
						 <tr>
						    <td><%=SystemEnv.getHtmlLabelName(857,user.getLanguage())%></td><td> <brow:browser viewType="0" name="docids" browserValue='<%=taskResource.get("docs")%>' 
											browserUrl="/systeminfo/BrowserMain.jsp?mouldID=doc&url=/docs/docs/MutiDocBrowser.jsp?documentids="
											hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='1'
											completeUrl="/data.jsp?type=9" linkUrl="/docs/docs/DocDsp.jsp" 
											language='<%=""+user.getLanguage() %>'
											temptitle='<%=SystemEnv.getHtmlLabelName(31519,user.getLanguage())%>'
											browserSpanValue='<%=taskResource.get("docspan")%>'></brow:browser></td>
						 </tr>
						 <tr>
						   <td><%=SystemEnv.getHtmlLabelName(1044,user.getLanguage())%></td>
						   <td>
						       <brow:browser viewType="0" name="requestids" browserValue='<%=taskResource.get("wfs")%>' 
								browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/workflow/request/MultiRequestBrowser.jsp?resourceids="
								hasInput="true"  isSingle="false" hasBrowser = "true" isMustInput='1' 
								completeUrl="/data.jsp?type=16" linkUrl="/workflow/request/ViewRequest.jsp?requestid==#id#&id=#id#" 
								browserSpanValue='<%=taskResource.get("wfspan")%>'></brow:browser>
						   </td>
						 </tr>
						  <tr>
						   <td><%=SystemEnv.getHtmlLabelName(783,user.getLanguage())%></td>
						   <td>
						       <brow:browser viewType="0" name="custids" browserValue='<%=taskResource.get("custs")%>' 
								browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/CRM/data/MutiCustomerBrowser.jsp?splitflag=,"
								hasInput="true"  isSingle="false" hasBrowser = "true" isMustInput='1' 
								completeUrl="/data.jsp?type=7" linkUrl="/workflow/request/ViewRequest.jsp?requestid==#id#&id=#id#" 
								browserSpanValue='<%=taskResource.get("custspan")%>'></brow:browser>
						   </td>
						 </tr>
						  <tr>
						   <td><%=SystemEnv.getHtmlLabelName(782,user.getLanguage())%></td>
						   <td>
						       <brow:browser viewType="0" name="projids" browserValue='<%=taskResource.get("projs")%>' 
								browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/proj/data/MultiProjectBrowser.jsp?splitflag=,"
								hasInput="true"  isSingle="false" hasBrowser = "true" isMustInput='1' 
								completeUrl="/data.jsp?type=8" linkUrl="/workflow/request/ViewRequest.jsp?requestid==#id#&id=#id#" 
								browserSpanValue='<%=taskResource.get("projspan")%>'></brow:browser>
						   </td>
						 </tr>
		
		                 
		
		
					</table>
		          </div>
		
				 </div>
				 <div class='panel' id='tasklog'>
				     <%=SystemEnv.getHtmlLabelName(32061,user.getLanguage())%>
				 </div>
				 <div class='panel' id='taskremind'>
				         <div class='remindcontainer'>  
							<table class='remindtable'>
							  <colgroup>
								  <col width="20%">
								  <col width="80%">
		                      </colgroup>
		                      <tr>
							    <td><%=SystemEnv.getHtmlLabelName(18713,user.getLanguage())%></td>
								<td>
								    <span class="middlehelper"></span>
									<INPUT type="radio" value="0" name="remindtype" id="remindtype" onclick="showRemindTime(this)" <%if (remindtype == 0) {%>checked<%}%>><span><%=SystemEnv.getHtmlLabelName(19782,user.getLanguage())%></span>
									<INPUT type="radio" value="1" name="remindtype" id="remindtype" onclick="showRemindTime(this)" <%if (remindtype == 1) {%>checked<%}%>><span><%=SystemEnv.getHtmlLabelName(17586,user.getLanguage())%></span>
									<INPUT type="radio" value="2" name="remindtype" id="remindtype" onclick="showRemindTime(this)" <%if (remindtype == 2) {%>checked<%}%>><span><%=SystemEnv.getHtmlLabelName(18845,user.getLanguage())%></span>
								</td>
							 </tr>
							  <tr class='remindset'	>
							    <td><%=SystemEnv.getHtmlLabelName(615,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(15148,user.getLanguage())%></td>
								<td>
								      <span class="middlehelper"></span>
								     <input type="checkbox" name="issubmitremind" value="1" <% if(issubmitremind == 1) { %>checked<% } %>/>
								</td>
							 </tr>
							 <tr  style='display:none;'>
							    <td><%=SystemEnv.getHtmlLabelName(18177,user.getLanguage())%></td>
								<td>
								    <span class="middlehelper"></span>
									<INPUT type="checkbox" name="beforestart" value="1" <% if(beforestart == 1) { %>checked<% } %>>
									<span><%=SystemEnv.getHtmlLabelName(19784,user.getLanguage())%></span>
									<INPUT class="InputStyle" type="text" name="beforestarttime"  id="beforestarttime" style="width:40px" size=5  value="<%= beforestarttime%>" onChange="inputChangeCheckBox('beforestarttime','beforestart')"/>
									<select name="beforestarttype" id="beforestarttype" onchange="onChangeStartTimeType(event)" style="display:'<%if(remindtype == 0) {%>none<%}%>'">
										<option value="0" <%if(beforestarttype == 0){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%></option>
										<option value="1" <%if(beforestarttype == 1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(391,user.getLanguage())%></option>
										<option value="2" <%if(beforestarttype == 2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15049,user.getLanguage())%></option>
									</select>
		                        </td>
							  </tr>
							  <tr style='display:none;'>
		                        <td><%=SystemEnv.getHtmlLabelName(18080,user.getLanguage())%></td>
		                        <td>
								    <span class="middlehelper"></span>
									<span><%=SystemEnv.getHtmlLabelName(21977, user.getLanguage())%></span>
									<INPUT class="InputStyle" type="text" name="beforestartper" id="beforestartper" style="width:40px" size=5  onChange="inputint('beforestartper')"  value="<%=beforestartper%>">
									<span id="beforestarttypespan" name="beforestarttypespan" ><%=startTimeType%></span>
							    </td>
							   </tr>
							   <tr class='remindset'> 
							     <td>
								    <%=SystemEnv.getHtmlLabelName(785,user.getLanguage())%>
								 </td>
		                         <td>
								        <span class="middlehelper"></span>
										<INPUT type="checkbox" name="beforeend" id="beforeend" value="1" <% if(beforeend == 1) { %>checked<% } %>>
										<span><%=SystemEnv.getHtmlLabelName(19785,user.getLanguage())%></span>
										<INPUT class="InputStyle" type="text" style="width:40px" name="beforeendtime" id="beforeendtime" size=5 value="<%= beforeendtime%>"  onChange="inputChangeCheckBox('beforeendtime','beforeend')">
										<select name="beforeendtype" id="beforeendtype" onChange="onChangeEndTimeType()" style="display:'<%if(remindtype == 0) {%>none<%}%>'">
											<option value="0" <%if(beforeendtype == 0){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%></option>
											<option value="1" <%if(beforeendtype == 1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(391,user.getLanguage())%></option>
											<option value="2" <%if(beforeendtype == 2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15049,user.getLanguage())%></option>
										</select>
								 </td>
							   </tr>
							   <tr class='remindset'>
		                         <td>
								    <%=SystemEnv.getHtmlLabelName(18080,user.getLanguage())%>
								 </td>
								 <td>
								     <span class="middlehelper"></span>
		                             <span><%=SystemEnv.getHtmlLabelName(21977, user.getLanguage())%></span>
									 <INPUT class="InputStyle" type="text" name="beforeendper"  id="beforeendper" style="width:40px" size=5 onChange="inputint('beforeendper')" value="<%=beforeendper%>">
									 <span id="beforeendtypespan" name="beforeendtypespan"><%=endTimeType%></span>
								 </td>
							   </tr>
							</table>
						</div>
				 </div>
			</div>
	  </div>
    
</div>

</form>
 <div id="worktaskmsg" > <image src="/express/task/images/loading1_wev8.gif"> </div>
 
 <div id="urgelevellist">
   <ul class="urgelevellist_ul">
	  <li onclick='setUrge(0);'>&nbsp;<span class='normal' title='<%=SystemEnv.getHtmlLabelName(225, user.getLanguage())%>' ></span>&nbsp;&nbsp;&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(225, user.getLanguage())%></li>
	  <li onclick='setUrge(1);'>&nbsp;<span title='<%=SystemEnv.getHtmlLabelName(25397, user.getLanguage())%>' class='important' ></span>&nbsp;&nbsp;&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(25397, user.getLanguage())%></li>
	  <li onclick='setUrge(2);'>&nbsp;<span title='<%=SystemEnv.getHtmlLabelName(2087, user.getLanguage())%>' class='urge' ></span>&nbsp;&nbsp;&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(2087, user.getLanguage())%></li>
   </ul>
 </div>


<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/base/jquery-ui_wev8.js"></script>
<script type='text/javascript' src='/js/jquery-autocomplete/jquery.autocomplete_wev8.js'></script>
<script type='text/javascript' src='../js/jquery-powerFloat-min_wev8.js'></script>

<style>
.float_list_ul{
   border: 1px solid #e5e5e5;
   min-height: 100px;
   border-bottom: none;
}

.float_list_ul li {
	line-height: 30px;
	border-bottom: 1px dashed #e5e5e5;
	border-top: none; 
	text-indent: 0px;
}

.float_list_ul li span{
	width: 100%;
    display: inline-block;
}

.float_list_ul li:hover {
	background: #f4fafc;
	cursor: pointer;
	color: #1097e4;
}

.float_list_ul .float_list_ul_li_select {
	background: #f4fafc;
	cursor: pointer;
	color: #1097e4;
}


#worktaskdesign .resourceselection .e8_innerShowContent{
  height: 20px;
}
</style>

<script language="javascript">
     
	 var requestid = <%=requestid%>;
	 //生成下拉框
     function getTaskSelectItems(){
		var items = [], value = '' ,opition;
	   var options = $("<%=tasksSelectStr.replaceAll("\"", "'")%>").find("option");
       for(var i=0,len=options.length;i<len;i++){
		  opition = $(options[i]); 
	      value = opition.attr("value");
	      if(value !='0'){
			  if(value == "<%=wtid%>"){
			      items.push("<span onclick='setWtType("+value+")' class='float_list_ul_li_select' wtid='"+value+"'>&nbsp;&nbsp;"+opition.html()+"</span>");
			  }else{
			      items.push("<span onclick='setWtType("+value+")' wtid='"+value+"'>&nbsp;&nbsp;"+opition.html()+"</span>");
			  }
		  }
	   }
	   return items;
	 }
    $(".opmenu").powerFloat({
		width: "200",
		eventType: "click",
		target: getTaskSelectItems(),
		targetMode: "list",
		offsets: {
			x: -2,
			y: 5
		}	
    });


	//更换任务类型
	function setWtType(wtid){
		 window.top.Dialog.confirm('<%=SystemEnv.getHtmlLabelName(83564,user.getLanguage())%>',function(){
		     window.location.href="/worktask/pages/worktask.jsp?wtid="+wtid+"&requestid=<%=requestid%>&tasklistid=<%=retasklistid%>";
		 }); 
	}


	//紧急程度
	$(".urgelevel").powerFloat({
		width: "70",
		eventType: "click",
		target: $("#urgelevellist"),
		offsets: {
			x: -15,
			y: 2
		}	
    });
    //设置紧急程度
    function  setUrge(status){
		  var  urgelevelshow =  $("#urgelevelshow"),urgeinput = urgelevelshow.find("input");
		  urgelevelshow.removeClass("normal").removeClass("important").removeClass("urge");
		  //正常
		  if(status === 0){
			 urgelevelshow.addClass("normal");
			 urgeinput.val(0);
			 urgelevelshow.attr("title",'<%=SystemEnv.getHtmlLabelName(225, user.getLanguage())%>');
		  //重要
		  }else if(status === 1){
			  urgelevelshow.addClass("important");
			  urgeinput.val(1);
			  urgelevelshow.attr("title",'<%=SystemEnv.getHtmlLabelName(25397, user.getLanguage())%>');
		  //紧急
		  }else if(status === 2){
			urgelevelshow.addClass("urge");
			urgeinput.val(2);
			urgelevelshow.attr("title",'<%=SystemEnv.getHtmlLabelName(2087, user.getLanguage())%>');
		  }	
		  if($("#urgelevellist").is(":visible"))
		     $(".urgelevel").trigger('click');
	
	}
	 /**
	生成任务清单人力资源浏览框
	**/
	function generatorResourceBrow(browcontainer,userid,username){
       var cuserid="",cusername="";
        if(userid ==='' && username === ''){
            cuserid = '<%=user.getUID()%>';
            cusername = '<%=user.getUsername()%>';
        }else{
           cuserid = userid;
           cusername = username;
        }
		browcontainer.e8Browser({
					name:'tasklistperson',
					viewType:"0",
					browserValue:cuserid,
					isMustInput:"1",
					browserSpanValue:cusername,
					hasInput:true,
					width:"110px",	
					linkUrl:"#",
					completeUrl:"/data.jsp?type=17",
					browserUrl:'/hrm/resource/MutiResourceBrowser.jsp?selectedids=&resourceids=',
					hasAdd:false,
					isSingle:true
		 });

	}
    /*共享*/
    function OnShare(){
		//location.href="/worktask/request/RequestShareSet.jsp?requestid=<%=requestid%>&wtid=<%=wtid%>";
		 var dlg=new window.top.Dialog();//定义Dialog对象
		// dialog.currentWindow = window;
	　　dlg.Model=false;
	　　dlg.Width=1000;//定义长度
	　　dlg.Height=550;
	　　dlg.URL="/worktask/request/RequestShareList.jsp?requestid=<%=requestid%>&wtid=<%=wtid%>";
	　　dlg.Title='<%=SystemEnv.getHtmlLabelName(119, user.getLanguage())%>';
		dlg.maxiumnable=false;
	　　dlg.show();
	}

/*开始提醒==根据任务类型设置提醒频率*/
function onChangeStartTimeType(){
	var timeTypeText = document.all("beforestarttype").options.item(document.all("beforestarttype").selectedIndex).innerText;
	document.getElementById("beforestarttypespan").innerHTML = timeTypeText;
}
/*截止提醒==根据任务类型设置提醒频率*/
function onChangeEndTimeType(){
	var timeTypeText = document.all("beforeendtype").options.item(document.all("beforeendtype").selectedIndex).innerText;
	document.getElementById("beforeendtypespan").innerHTML = timeTypeText;
}
</script>
<script language="javascript"  src="../js/jquery.placeholder_wev8.js"></script>
<script language="javascript"  defer="defer" src="/js/datetime_wev8.js"></script>
<script language="javascript"  src="/js/selectDateTime_wev8.js"></script>
<script language="javascript"  defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
<script language="javascript"  src="../js/worktask_wev8.js"></script>

<!--swfupload相关-->
<link href="/js/page/swfupload/default_wev8.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="/js/page/swfupload/swfupload_wev8.js"></script>
<script type="text/javascript" src="/js/page/swfupload/swfupload.queue_wev8.js"></script>
<script type="text/javascript" src="/js/page/swfupload/fileprogress_wev8.js"></script>
<script type="text/javascript" src="/js/page/swfupload/handlers_wev8.js"></script>
<script type='text/javascript' src='../js/jquery.expandable_wev8.js'></script>


<script>
var taskFormInit;
var jsonTextInit

$(document).ready(function(){
    setTopButtonTitle();
    //计算 worktask_detaillist 高度
    $(".worktask_detailinfo").css("height",($(window.top.document.body).height()-150)+'px');
    $('.worktask_detailinfo').perfectScrollbar();	
    
    $(".closeitem").bind('click',function(ev){ 
          <% if(!"".equals(retasklistid)){ %>
		  	 parent.window.hideLeftTaskPanel("childedittask");	 
		  <%}else{%>
		     parent.window.hideLeftTaskPanel("worktaskdetail");	 
		  <%}%>
    }); 
    
    
   // $('.taskcontentarea').height(22).height($('.taskcontentarea')[0].scrollHeight);
   // $('.taskcontentarea').live("keyup keydown",function(){
	//	var h=$(this);
	//	h.height(22).height(h[0].scrollHeight);
   //  });
	 $('.taskcontentarea').expandable({interval:300,duration:'fast'});
	 //判断 表单内容是否有变
	 taskFormInit = $("#taskform").serializeArray();
	 jsonTextInit = JSON.stringify({ taskform: taskFormInit }); 
});

//设置按钮标题，以及绑定事件
function setTopButtonTitle(){
   
	<%if(creater == user.getUID()  || (user.getUID()+"").equals(liableperson)){%>
	
	    <%if(!"0001".equals(retasklistid)){%>
	        $(".topbutton").html("<%=SystemEnv.getHtmlLabelName(615, user.getLanguage())%>");
			$(".topbutton").bind("click",function(){
			   OnSubmit();
			});
	    <%}else{%>
	        $(".topbutton").html("<%=SystemEnv.getHtmlLabelName(86, user.getLanguage())%>");
			$(".topbutton").bind("click",function(){
			   OnSave();
			});
	    <%}%>
		
	<%}%>
}

//判断 表单内容值 是否有变更
function taskContentsChange(){
   //alert(1);
   var taskForm = $("#taskform").serializeArray();
   var jsonText = JSON.stringify({ taskform: taskForm }); 
   if(jsonTextInit==jsonText){
      return false;
   }else{
      return true; 
   } 
   return true;
}



//初始化页面
function initPage(){
  
  //附件上传
  var fileupload = $(".fileupload"),fileuuid = new UUID();
  fileupload.attr("id",fileuuid);
  initSwfUpload(fileuuid);
  //设置紧急程度
  setUrge(<%=urgency%>);
  //初始化tab页
  initTabs(0);
  if(requestid === 0){
     initEndDate();
     setUrge(0);
     //$(".addwt").trigger('click'); 不默认初始化一行
	 //删除附件
     $(".fileitems").delegate(".fileclose","click",function(){
		 var self = $(this);
		 window.top.Dialog.confirm('<%=SystemEnv.getHtmlLabelName(82017,user.getLanguage())%>',function(){
			   self.parents(".filecontainer").remove();
			   setFileids();
		 });
	 });

  }else{
   //非创建页面   
    var workList = <%=wtRequestManager.getWorkTaskJsonListByRequestid(requestid+"")%>;
	//恢复工作清单信息
    for(var i=0;i<workList.length;i++){
      addTask(workList[i]);
    }
	if( workList.length ===0 ){
	 // $(".addwt").trigger('click'); 不默认初始化一行
	}
	//生成附件清单
	var filelist = <%=(taskResource.get("attachsjson").equals("")?"[]":taskResource.get("attachsjson"))%> ; 
    for(var i=0;i<filelist.length;i++){
	    var file="<span class='filecontainer' ><input type='hidden' value='"+filelist[i].fileid+"'><span class='middlehelper'></span><a class='filedes' target='_blank' href='/weaver/weaver.file.FileDownload?fileid="+filelist[i].fileid+"' > "+filelist[i].filename+" </a><span class='fileclose'>X</span></span>";
		$(".fileitems").append($(file));	
	}
	//删除附件
     $(".fileitems").delegate(".fileclose","click",function(){
		 var self = $(this);
		 window.top.Dialog.confirm('<%=SystemEnv.getHtmlLabelName(82017,user.getLanguage())%>',function(){
			   self.parents(".filecontainer").remove();
			   setFileids();
		 });
	 });
  }
}

initPage();


//设置上传的附件id
function setFileids(){

   var files = $(".filecontainer"),fileidel = $(".panel").find("input[name='fileids']");
   var fileids = [],fileid;
   for(var i=0,len=files.length;i<len;i++){
        fileid = $(files[i]).find("input[type='hidden']").val();
        fileids.push(fileid);
   }
   fileidel.val(fileids.join(",")); 
}


<%if (remindtype == 0) { %>
      $(".remindset").hide();
<% } %>

function showRemindTime(obj){
	if("0" == obj.value){
		$(".remindset").hide();
	}else{
		$(".remindset").show();
	}
}



 $( ".listbody table tbody" ).sortable({
   helper: function(e, tr)
  {
    var $originals = tr.children();
    var $helper = tr.clone();
    $helper.children().each(function(index)
    {
      $(this).width($originals.eq(index).width());
    });
    return $helper;
  }
 });

//初始化任务截止日期
function initEndDate(){
 
   var datenow = new Date().pattern("yyyy-MM-dd hh:mm");
   var datedetail = datenow.split(" ");
   $("#wfenddate").val(datenow);
   $("#wfenddatespan").html(datenow);
	$("#field13_<%=requestid%>").val(datedetail[0]);
	$("#field14_<%=requestid%>").val(datedetail[1]);
}




$('input, textarea').placeholder();



function afterBackBrowserData(event,datas,name){
   name = name.replace("field","");
   onChangeCheckor(name);
}

function onChangeCheckor(id){
	try{
		var ids = id.split("_");
		var fieldid = ids[0];
		var rowindex = ids[1];
		var fieldname1 = "field"+id;
		var fieldname2 = "<%=checkorField%>"+rowindex;
		var name = "<%=needcheckField%>"+rowindex;
		if(fieldname1 == fieldname2){
			if(document.getElementById("<%=checkorField%>"+rowindex).value==null || document.getElementById("<%=checkorField%>"+rowindex).value==""){
			     //alert(1);
				//document.getElementById("<%=needcheckField%>"+rowindex).checked = false;
				 changeCheckboxStatus4tzCheckBox(name,false);
			}else{
				//document.getElementById("<%=needcheckField%>"+rowindex).checked = true;
				 changeCheckboxStatus4tzCheckBox(name,true);
			}
		}
	}catch(e){}
}

//日期时间选择
function onShowPlanDateCompute(inputname, spanname, ismand,dateFmt){
	WdatePicker_onShowPlanDateCompute(inputname, spanname, ismand,dateFmt);
}
function WdatePicker_onShowPlanDateCompute(inputname, spanname, ismand,dateFmt){
	var returnvalue;
	var oncleaingFun = function(){
		  $dp.$(inputname).value = "";
			if(ismand == 1){
				$dp.$(spanname).innerHTML = "<img src='/images/BacoError_wev8.gif' align=absmiddle>";
			}else{
				$dp.$(spanname).innerHTML = "";
				$("#field13_<%=requestid%>").val("");
                $("#field14_<%=requestid%>").val("");
			}
			try{
				document.getElementById("<%=planDays%>").value = 0;
				try{
					if(document.getElementById("<%=planDays%>").type == "hidden"){
						document.getElementById("<%=planDays%>span").innerHTML = 0;
					}
				}catch(e){}
			}catch(e){}
	  }
	 WdatePicker({el:spanname,dateFmt:dateFmt,onpicked:function(dp){
		returnvalue = dp.cal.getDateStr();	
		var datenow = new Date().pattern("yyyy-MM-dd hh:mm");
        if(returnvalue < datenow){
			$dp.$(spanname).innerHTML = $dp.$(inputname).value;
		    window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(83568,user.getLanguage())%>!");
            return;
		}
		var datedetail = returnvalue.split(" ");
		$dp.$(spanname).innerHTML = returnvalue;
        $dp.$(inputname).value = returnvalue;
		$("#field13_<%=requestid%>").val(datedetail[0]);
        $("#field14_<%=requestid%>").val(datedetail[1]);
		
	},oncleared:oncleaingFun});

} 


function addDatePicker(span){
   var  spanbutton = $(span);
   var  spanshow = spanbutton.next("span");
   var  inputhidden = spanbutton.next().next("input[type='hidden']");

   WdatePicker({el:spanshow[0],dateFmt:"yyyy-MM-dd",onpicked:function(dp){
	    var taskenddate = $("#field13_<%=requestid%>").val();
        var returnvalue = dp.cal.getDateStr();	
		var datenow = new Date().pattern("yyyy-MM-dd");
		if(taskenddate===''){
		   window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(83569,user.getLanguage())%>!");
		   spanshow.html(inputhidden.val());
		   return;
		}
		if(returnvalue >  taskenddate){
		   window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(83571,user.getLanguage())%>!");
		   spanshow.html(inputhidden.val());
		   return;
		}
		if(returnvalue < datenow){
		   window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(83573,user.getLanguage())%>!");
		   spanshow.html(inputhidden.val());
		   return;
		}
		spanshow.html(returnvalue);
        inputhidden.val(returnvalue);
   
   },oncleared:function(){

        spanshow.html("<img src='/images/BacoError_wev8.gif' align=absmiddle>");
        inputhidden.val("");
        
   }});

}



/*检测表单是否完整*/
function checkForm(){
  var libman = $("#field3_<%=requestid%>").val(), taskname = $("input[name='taskname']").val(), checkman = $("#field2_<%=requestid%>").val() ,taskcontent = $("textarea[name='field7_<%=requestid%>']").val();
  var msg = "";
  if(libman === ''){
     msg = '<%=SystemEnv.getHtmlLabelNames("16936,82241",user.getLanguage())%>';
	 return msg;
  }
  if(taskname === ''){
     msg = '<%=SystemEnv.getHtmlLabelNames("24986,82241",user.getLanguage())%>';
	  return msg;
  }
  if(taskcontent === ''){ 
     msg = '<%=SystemEnv.getHtmlLabelNames("1332,81710,82241",user.getLanguage())%>';
	 return msg;
  }
  var tasklistcontents = $("input[name='tasklistcontent']");
  for(var i=0, len=tasklistcontents.length; i<len ;i++){
    if($(tasklistcontents[i]).val() === ''){
	   msg = '<%=SystemEnv.getHtmlLabelNames("1332,491,82755,82241",user.getLanguage())%>';
	   break;
	}
  }
  
  if(msg!==''){
    return msg;
  }   
  var tasklistpersons = $("input[name='tasklistperson']");
  for(var i=0, len=tasklistpersons.length; i<len ;i++){
    if($(tasklistpersons[i]).val() === ''){
	   msg = '<%=SystemEnv.getHtmlLabelNames("1332,491,16936,82241",user.getLanguage())%>';
	   break;
	}
  }
  if(msg!==''){
    return msg;
  }

  return msg;
  
}


//保存计划任务
function OnSave(){
     var msg = checkForm();
     if(msg !== ''){
	    window.top.Dialog.alert(msg);
		return;
	 }
    //责任人,计划内容,计划截至日期
	//document.all("needcheck").value = "field3_<%=requestid%>,field7_<%=requestid%>,field13_<%=requestid%>";
	document.all("needcheck").value = "field3_<%=requestid%>,field13_<%=requestid%><%=checkStr%>";
	if(check_form(document.taskform, document.all("needcheck").value) && checkWorkPlanRemind()){
		document.taskform.action = "/worktask/request/RequestOperation.jsp";
		document.taskform.operationType.value="save";
		showPrompt("<%=SystemEnv.getHtmlLabelName(22060,user.getLanguage())%>");
		//alert($("#field2_<%=requestid%>").val());
		doUpload();
		
	}
}
//提交
function OnSubmit(){
	 var msg = checkForm();
     if(msg !== ''){
	    window.top.Dialog.alert(msg);
		return;
	 }
	document.all("needcheck").value = "field3_<%=requestid%>,field13_<%=requestid%><%=checkStr%>";
	if(check_form(document.taskform, document.all("needcheck").value)){
		document.taskform.action = "/worktask/request/RequestOperation.jsp";
		document.taskform.operationType.value="Submit";
		showPrompt("<%=SystemEnv.getHtmlLabelName(22061,user.getLanguage())%>");
		document.taskform.submit();
	}
	
}

//检测计划提醒设置
function checkWorkPlanRemind(){
	//alert(document.frmmain.remindtype);
	if(document.taskform.remindtype[0].checked == false){
		if(document.taskform.issubmitremind.checked || document.taskform.beforeend.checked){
		    if(document.taskform.issubmitremind.checked){
		       $("#issubmitremind").val("1");
		    }else{
		       $("#issubmitremind").val("0");
		    }
		    if(document.taskform.beforeend.checked){
		       $("#beforeend").val("1");
		    }else{
		       $("#beforeend").val("0");
		    }
			return true;
		}else{
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(21978,user.getLanguage())%>");
			return false;
		}
	}else{
		document.taskform.beforestart.checked = false;
		document.taskform.beforeend.checked = false;
		document.taskform.beforestarttime.value = 0;
		document.taskform.beforeendtime.value = 0;
		document.taskform.beforestartper.value = 0;
		document.taskform.beforeendper.value = 0;
		return true;
	}
}

function doUpload(){

	jQuery(".uploadfield").each(function(){
		var oUploader=window[jQuery(this).attr("oUploaderIndex")];
		if(oUploader.getStats().files_queued != 0){ //判断是否需要上传
	     	 oUploader.startUpload(); 
	    }
	});
	doSaveAfterAccUpload();
}

function doSaveAfterAccUpload(){
	var isuploaded=true;
	jQuery(".uploadfield").each(function(){
		var oUploader=window[jQuery(this).attr("oUploaderIndex")];
		if(oUploader.getStats().files_queued != 0){ //判断上传是否完成
	     	 isuploaded=false; 
	    }
	});
	if(isuploaded){
		document.taskform.submit();
	}
}

</script>

</body>
</html>
