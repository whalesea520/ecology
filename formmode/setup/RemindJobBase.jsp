
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="weaver.general.Util" %>
<%@page import="weaver.formmode.data.FieldInfo"%>
<%@page import="weaver.formmode.service.AppInfoService"%>
<%@page import="weaver.formmode.virtualform.VirtualFormHandler"%>
<%@page import="weaver.formmode.service.CommonConstant"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ include file="/formmode/pub_detach.jsp"%>
<jsp:useBean id="checkSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="ReportTypeComInfo" class="weaver.workflow.report.ReportTypeComInfo" scope="page" />
<jsp:useBean id="formComInfo" class="weaver.workflow.form.FormComInfo" scope="page" />
<jsp:useBean id="billComInfo" class="weaver.workflow.workflow.BillComInfo" scope="page" />
<jsp:useBean id="workflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="SubComanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />

<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<%!

private String getFieldShowName(String fieldids, User user){
	String showname = "";
	String detailtable = "";
	if(!fieldids.equals("")&&!fieldids.equals("0")){
		RecordSet rs1 = new RecordSet();
		String sql = "select b.indexdesc,a.detailtable from workflow_billfield a,HtmlLabelIndex b where a.id in ("+fieldids+") and a.fieldlabel = b.id ";
		rs1.executeSql(sql);
		while(rs1.next()){
			detailtable = rs1.getString("detailtable");			
			if(detailtable.equals("")){
				showname = showname+","+rs1.getString("indexdesc");
			}else{
				showname = showname+","+rs1.getString("indexdesc")+"(" + SystemEnv.getHtmlLabelName(84496, user.getLanguage()) +detailtable.substring(detailtable.length()-1,detailtable.length())+")";
			}
			
		}
	}
	if(!showname.equals("")){
		showname = showname.substring(1);
	}
	return showname;
} 
%>
<HTML>
	<HEAD>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET />
		<link href="/formmode/css/formmode_wev8.css" type="text/css" rel="stylesheet" />
		<script type="text/javascript" src="../../js/weaver_wev8.js"></script>
		<script type="text/javascript" src="/formmode/js/WdatePicker/WdatePicker_wev8.js"></script>
		
		<script type="text/javascript" src="/formmode/js/ext-3.4.1/adapter/ext/ext-base_wev8.js"></script>
		<script type="text/javascript" src="/formmode/js/ext-3.4.1/ext-all_wev8.js"></script>
		
		<script type="text/javascript" src="/formmode/js/ext/lovCombo/ext-all_wev8.js"></script>
		<script type="text/javascript" src="/formmode/js/ext/lovCombo/Ext.ux.util_wev8.js"></script>
		<script type="text/javascript" src="/formmode/js/ext/lovCombo/Ext.ux.form.LovCombo_wev8.js"></script>
		<script type="text/javascript" src="/formmode/js/ext/lovCombo/Ext.ux.form.ThemeCombo_wev8.js"></script>
		<script type="text/javascript" src="/formmode/js/ext/ux/iconMgr_wev8.js"></script>
		
		<link rel="stylesheet" type="text/css" href="/formmode/js/ext-3.4.1/resources/css/ext-all_wev8.css" />
		
		<link rel="stylesheet" type="text/css" href="/formmode/js/ext/lovCombo/css/Ext.ux.form.LovCombo_wev8.css">
		<link rel="stylesheet" type="text/css" href="/formmode/js/ext/lovCombo/css/webpage_wev8.css">
		<link rel="stylesheet" type="text/css" href="/formmode/js/ext/lovCombo/css/lovcombo_wev8.css">
	
	
	
		<style type="text/css">
			.e8_tblForm_f{
				padding-left: 10px;
			}
			.e8_tblForm_b{
				font-weight: bold;
			}
			.x-shadow .xsml{
				display: none;
			}
			.x-shadow .xsmc{
				background: none;
			}
			
			.x-ie-shadow{
				background: none;
			}
			
			.x-form-field-wrap .x-form-trigger{
				background-image: url("/wui/theme/ecology8/skins/default/general/browser_wev8.png") !important;
				border: 0px;
			}
			
			.x-form-field-wrap .x-form-trigger-over{
				background-position: 0 0;
			}
			
			.x-trigger-wrap-focus .x-form-trigger{
				background-position: 0 0;
			}
			
.codeEditFlag{
    padding-left:20px;
    padding-right: 3px;
    height: 20px;
    background:transparent url('/formmode/images/code_wev8.png') no-repeat !important;
    cursor: pointer;
    margin-left: 2px;
    margin-top: 2px;
    position: relative;
    display: block;
    float: left;
}

.codeDownFlag{
    padding-left:20px;
    padding-right: 10px;
    height: 22px;
    background:transparent url('/formmode/images/codeDown_wev8.png') no-repeat !important;
    cursor: pointer;
    margin-left: 2px;
    position: relative;
    display: block;
    float: left;
}

td{white-space: nowrap;}
</style>

	</HEAD>
<%
    
	if(!HrmUserVarify.checkUserRight("FORMMODEAPP:ALL", user)){
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
	String imagefilename = "/images/hdHRMCard_wev8.gif";
    String titlename = SystemEnv.getHtmlLabelName(30063,user.getLanguage());//自定义页面设置
	String needfav ="1";
	String needhelp ="";

	
	String modename = "";
	String isrefresh = Util.null2String(request.getParameter("isrefresh"));
	String id = Util.null2String(request.getParameter("id"),"0");
    String name = "";
	int isenable = 0;
	int remindtype = 0;
	int formid = 0;
	int modeid = 0;
	String appid = Util.null2String(request.getParameter("appid"),"1");
	int creator = 0;
	
	int remindtimetype = 0;
	int reminddatefield = 0;
	int remindtimetype2 = 0;
	int remindtimefield = 0;
	String remindtimevalue = "";
	String reminddate = "";
	String remindtime = "";
	
	int incrementway = 0;
	int incrementtype = 0;
	int incrementfield = 0;
	int incrementnum = 0;
	int incrementunit = 0;
	
	int remindway = 0;
	int sendertype = 1;
	int senderfield = 0;
	String reminddml = "";
	String remindjava = "";
	
	int conditionstype = 0;
	String conditionsfield = "";
	String conditionsfieldcn = "";
	String conditionssql = "";
	String conditionsjava = "";
	
	String subject = "";
	int remindcontenttype = 0;
	String remindcontenttext = "";
	String remindcontentjava = "";
	String remindcontentURL = "";
	String remindcontentaddress="";
	
	int receivertype = 0;
	String receiverdetail = "";
	int receiverfieldtype = 0;
	String receiverfield = "";
	int receiverlevel = 10;
	
	int triggerway = 0;
	int triggertype = 0;
	int triggercycletime = 0;
	String triggerexpression = "";
	
	String weeks = "";
	String months = "";
	String days = "";
	
	String formtype = "";
	
	//int remindSMS = 0;
	//int remindEmail = 0;
	//int remindWorkflow = 0;
	//int remindWeChat = 0;
	//int remindEmobile = 0;
	
	AppInfoService appInfoService = new AppInfoService();
	Map<String, Object> appInfo = new HashMap<String, Object>();
    appInfo = appInfoService.getAppInfoById(Util.getIntValue(appid));
	String treelevel = Util.null2String(appInfo.get("treelevel"));
	String sql = "select * from mode_remindjob where id="+id;
	RecordSet.executeSql(sql);
	while(RecordSet.next()){
	    name = Util.null2String(RecordSet.getString("name")) ;
	    isenable = Util.getIntValue(RecordSet.getString("isenable"),0);
	    remindtype = Util.getIntValue(RecordSet.getString("remindtype"),0);
	    formid = Util.getIntValue(RecordSet.getString("formid"),0);
	    modeid = Util.getIntValue(RecordSet.getString("modeid"),0);
	    appid = Util.null2String(RecordSet.getString("appid"));
	    creator = Util.getIntValue(RecordSet.getString("creator"),0);
	    
	    remindtimetype = Util.getIntValue(RecordSet.getString("remindtimetype"),0);
	    reminddatefield = Util.getIntValue(RecordSet.getString("reminddatefield"),0);
	    remindtimetype2 = Util.getIntValue(RecordSet.getString("remindtimetype2"),0);
	    remindtimefield = Util.getIntValue(RecordSet.getString("remindtimefield"),0);
	    remindtimevalue = Util.null2String(RecordSet.getString("remindtimevalue"));
	    reminddate = Util.null2String(RecordSet.getString("reminddate"));
	    remindtime = Util.null2String(RecordSet.getString("remindtime"));
	    
	    incrementway = Util.getIntValue(RecordSet.getString("incrementway"),0);
	    incrementtype = Util.getIntValue(RecordSet.getString("incrementtype"),0);
	    incrementfield = Util.getIntValue(RecordSet.getString("incrementfield"),0);
	    incrementnum = Util.getIntValue(RecordSet.getString("incrementnum"),0);
	    incrementunit = Util.getIntValue(RecordSet.getString("incrementunit"),0);
	    
	    remindway = Util.getIntValue(RecordSet.getString("remindway"),0);
	    sendertype = Util.getIntValue(RecordSet.getString("sendertype"),1);
	    senderfield = Util.getIntValue(RecordSet.getString("senderfield"),0);
	    reminddml = Util.null2String(RecordSet.getString("reminddml"));
	    remindjava = Util.null2String(RecordSet.getString("remindjava"));
	    
	    conditionstype = Util.getIntValue(RecordSet.getString("conditionstype"),0);
	    conditionsfield = Util.null2String(RecordSet.getString("conditionsfield"));
	    conditionsfieldcn = Util.null2String(RecordSet.getString("conditionsfieldcn"));
	    conditionssql = Util.null2String(RecordSet.getString("conditionssql"));
	    conditionsjava = Util.null2String(RecordSet.getString("conditionsjava"));
	    
	    subject = Util.null2String(RecordSet.getString("subject"));
	    remindcontenttype = Util.getIntValue(RecordSet.getString("remindcontenttype"),0);
	    remindcontenttext = Util.null2String(RecordSet.getString("remindcontenttext"));
	    remindcontentjava = Util.null2String(RecordSet.getString("remindcontentjava"));
	    remindcontentURL = Util.null2String(RecordSet.getString("remindcontenturl"));
	    remindcontentaddress = Util.null2String(RecordSet.getString("remindcontentaddress"));
	   
	    receivertype = Util.getIntValue(RecordSet.getString("receivertype"),0);
	    receiverdetail = Util.null2String(RecordSet.getString("receiverdetail"));
	    receiverfieldtype = Util.getIntValue(RecordSet.getString("receiverfieldtype"),0);
	    receiverfield = Util.null2String(RecordSet.getString("receiverfield"));
	    receiverlevel = Util.getIntValue(RecordSet.getString("receiverlevel"),10);
	    
	    triggerway = Util.getIntValue(RecordSet.getString("triggerway"),0);
	    triggertype = Util.getIntValue(RecordSet.getString("triggertype"),0);
	    triggerexpression = Util.null2String(RecordSet.getString("triggerexpression"));
	    triggercycletime = Util.getIntValue(RecordSet.getString("triggercycletime"),0);
	    
	    weeks = Util.null2String(RecordSet.getString("weeks"));
	    months = Util.null2String(RecordSet.getString("months"));
	    days = Util.null2String(RecordSet.getString("days"));
	    
	    formtype = Util.null2String(RecordSet.getString("formtype"));
	    
	    //remindSMS = Util.getIntValue(RecordSet.getString("remindSMS"),0);
        //remindEmail = Util.getIntValue(RecordSet.getString("remindEmail"),0);
        //remindWorkflow = Util.getIntValue(RecordSet.getString("remindWorkflow"),0);
        //remindWeChat = Util.getIntValue(RecordSet.getString("remindWeChat"),0);
        //remindEmobile = Util.getIntValue(RecordSet.getString("remindEmobile"),0);
	    
	}
	
	if(id.equals("0")){
    	remindcontentURL = "/mobilemode/formbasebrowserview.jsp?billid=$billid$&modeId=$modeId$&formId=$formId$";
    }
	    
	List mustInputList = new ArrayList();
	mustInputList.add("name");
	mustInputList.add("formid");
	String needInputImg = "<img align='absMiddle' src='/images/BacoError_wev8.gif' >";
	
	String subCompanyIdsql = "SELECT b.subcompanyid FROM mode_remindjob a,modeTreeField b WHERE a.appid=b.id AND a.id="+id;
	RecordSet recordSet = new RecordSet();
	recordSet.executeSql(subCompanyIdsql);
	int subCompanyId = -1;
	if(recordSet.next()){
		subCompanyId = recordSet.getInt("subCompanyId");
	}
	if(subCompanyId==-1){
		appInfo = appInfoService.getAppInfoById(Util.getIntValue(appid));
		subCompanyId = Util.getIntValue(Util.null2String(appInfo.get("subcompanyid")),-1);
	}
	String userRightStr = "FORMMODEAPP:ALL";
	Map rightMap = getCheckRightSubCompanyParam(userRightStr,user,fmdetachable, subCompanyId,"",request,response,session);
	int operatelevel = Util.getIntValue(Util.null2String(rightMap.get("operatelevel")),-1);
	subCompanyId = Util.getIntValue(Util.null2String(rightMap.get("subCompanyId")),-1);
	//判断是否有模块创建人字段
	Boolean haveCreater=false;
	boolean virtualform = VirtualFormHandler.isVirtualForm(formid);
	if(virtualform){
	    rs.executeSql("select fieldname FROM workflow_billfield  WHERE  billid ="+formid);
	    while(rs.next()){
	        String fieldname=Util.null2String(rs.getString("fieldname"));
	        if(fieldname.toLowerCase().equals("modedatacreater"))haveCreater=true;
	    }
	}else{
	    haveCreater=true;
	}
	
	String oldJavaFileName="";
	if(!"".equals(remindcontentjava)&&"".equals(remindcontentaddress)){
	    Map<String, String> sourceCodePackageNameMap = CommonConstant.SOURCECODE_PACKAGENAME_MAP;
	    String sourceCodePackageName = sourceCodePackageNameMap.get("7");
	    String classFullName = sourceCodePackageName + "." + remindcontentjava.replace(".java","");
	    remindcontentaddress=classFullName;
	    oldJavaFileName=remindcontentaddress;
	 }

	
%>

<%if(isrefresh.equals("1")){%>
<script type="text/javascript">
jQuery(function($){
	parent.parent.refreshCustomPage("<%=id%>");
});
</script>
<%}%>

	<BODY>
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		
		<%
		if(id.equals("0")){
			if(operatelevel>0&&!fmdetachable.equals("1")||fmdetachable.equals("1")&&!treelevel.equals("0")){
				RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self} " ;//保存
				RCMenuHeight += RCMenuHeightStep;
			}
		}else{
			if(operatelevel>0&&(!fmdetachable.equals("1")||fmdetachable.equals("1")&&treelevel.equals("0"))||fmdetachable.equals("1")&&!treelevel.equals("0")){
				RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self} " ;//保存
				RCMenuHeight += RCMenuHeightStep;
			}
			if(operatelevel>1){
				RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(),_self} " ;//删除
				RCMenuHeight += RCMenuHeightStep;
			}
			if(operatelevel>0&&(!fmdetachable.equals("1")||fmdetachable.equals("1")&&!treelevel.equals("0"))){
				RCMenu += "{"+SystemEnv.getHtmlLabelName(82210,user.getLanguage())+",javaScript:doAdd(),_self} " ;//新建提醒
				RCMenuHeight += RCMenuHeightStep ;
			}
		}
		if(remindtype==2){
		    //改造后
	        if(remindway!=0){
	            RCMenu += "{"+SystemEnv.getHtmlLabelName(383217,user.getLanguage())+",javaScript:onShowSql(),_self} " ;//到期提醒SQL
	            RCMenuHeight += RCMenuHeightStep ;
	        }
		}
		%>

		<FORM id=weaver name=frmMain action="/formmode/setup/RemindJobSettingsAction.jsp" method=post>
			<input type="hidden" name="appid" id="appid" value="<%=appid %>">
			<input type="hidden" name="operation" id="operation" value="saveorupdate">
			<input type="hidden" name="id" id="id" value="<%=id%>">
			<input type="hidden" name="creator" id="creator" value="<%=user.getUID()%>">
			<input type="hidden" name="iscreate" id="iscreate" value="<%=id.equals("0")?1:0 %>">
			
			<wea:layout type="1col" attributes="{'expandAllGroup':'true'}">
				<wea:group context='<%=SystemEnv.getHtmlLabelName(81711,user.getLanguage())%>' attributes="{'groupOperDisplay':none}"><!-- 基本信息 -->
					<wea:item>
				<TABLE class="e8_tblForm">
				<COLGROUP>
					<COL width="20%">
					<COL width="80%">
				</COLGROUP>
			  	<TBODY>
                    <TR>
                      <TD class="e8_tblForm_label"><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD><!-- 名称 -->
                      <TD class="e8_tblForm_field">
                      		<INPUT type=text class=Inputstyle style="width:80%" id="name" name="name" onchange='checkinput("name","nameSpan")' value="<%=name%>">
                      		<SPAN id=nameSpan>
                      			<%if(name.equals("")){%>
                      				<%=needInputImg %>	
                      			<%}%>
                      		</SPAN>
                      </TD>
                    </TR> 
                    <TR>
                      <TD class="e8_tblForm_label"><%=SystemEnv.getHtmlLabelName(18624,user.getLanguage())%><!-- 是否启用 --></TD>
                      <TD class="e8_tblForm_field">
                      		<INPUT type="checkbox" class=Inputstyle <%if(isenable!=0){%>checked="checked"<%} %> style="width:80%" id="isenable" onclick="changeBoxVal(this)" name="isenable"  value="<%=isenable %>">
                      </TD>
                    </TR>
                    <TR>
                      <TD class="e8_tblForm_label"><%=SystemEnv.getHtmlLabelName(82212,user.getLanguage())%><!-- 提醒类型 --></TD>
                      <TD class="e8_tblForm_field">
                      		<select name="remindtype" id="remindtype" onchange="remindtypeChange()" style="width: 200px;">
                      			<option value="1" <%if(remindtype==1){%>selected="selected"<%} %> ><%=SystemEnv.getHtmlLabelName(82213,user.getLanguage())%><!-- 即时提醒 --></option>
                      			<option value="2" <%if(remindtype==2){%>selected="selected"<%} %> ><%=SystemEnv.getHtmlLabelName(17497,user.getLanguage())%><!-- 到期提醒 --></option>
                      			<option value="3" <%if(remindtype==3){%>selected="selected"<%} %> ><%=SystemEnv.getHtmlLabelName(82214,user.getLanguage())%><!-- 循环提醒 --></option>
                      		</select>
                      </TD>
                    </TR>
                    <tr>
	                    <%   
		                     String bname = "";
					  		 RecordSet.executeSql("select * from workflow_bill where id='"+formid+"'");
					 		 if(RecordSet.next()){
					 			int tmplable = RecordSet.getInt("namelabel");
					 			bname = "<a href=\"#\" onclick=\"toformtab('"+formid+"')\">"+SystemEnv.getHtmlLabelName(tmplable,user.getLanguage())+"</a>";
					 		 }else{
					 			formid = 0;
					 		 }
					 		RecordSet.executeSql("select isvirtualform from ModeFormExtend where formid="+formid);
					 		int isvirtualform = 0;
					 		if(RecordSet.next()){
					 		    isvirtualform = RecordSet.getInt("isvirtualform");
					 		}
				  		 %>
				  		  <%if(isvirtualform==1){ bname = bname + "<div class=\"e8_data_virtualform\" title=\""+SystemEnv.getHtmlLabelName(33885,user.getLanguage())+"\">V</div>";} %><!-- 虚拟表单 -->
						<td class="e8_tblForm_label"><%=SystemEnv.getHtmlLabelName(15451,user.getLanguage())%><!-- 表单名称 --></td>
						<td class="e8_tblForm_field">
						<%
							String tempTitle = SystemEnv.getHtmlLabelNames("18214,31923",user.getLanguage());
						%>
						<brow:browser viewType="0" name="formid" browserValue='<%=formid+"" %>' 
					  		 		browserUrl="/systeminfo/BrowserMain.jsp?url=/formmode/setup/formBrowserForRemind.jsp"
											hasInput="false" isSingle="true" hasBrowser = "true" isMustInput="2"
											completeUrl="/data.jsp" linkUrl=""  width="222px"
											browserDialogWidth="500px" tempTitle="<%=tempTitle %>"
											browserSpanValue='<%=bname %>'
											onPropertyChange="formidChange()"
											></brow:browser>		
			
						</td>
					</tr>
					
					<tr  id="dataform">
					   <td class="e8_tblForm_label"><%=SystemEnv.getHtmlLabelName(563, user.getLanguage()) %><%=SystemEnv.getHtmlLabelName(128145, user.getLanguage()) %><!-- 数据表单 --></td>
					   <td class="e8_tblForm_field">
					       <select id="formtype" name="formtype" style="width: 200px;" onchange="formTypeChange();">
					           <option value="0"><%=SystemEnv.getHtmlLabelName(21778, user.getLanguage()) %></option>
					   <%
					      String formsql = "select detailtable from workflow_billfield where billid = "+formid+" group by detailtable";
					      RecordSet.executeSql(formsql);
					      while(RecordSet.next()){
					          String detailtable = RecordSet.getString("detailtable");
					          if(!detailtable.equals("")){
					        	 // detailtable = detailtable.substring(detailtable.length()-1,detailtable.length());
					        	  detailtable = detailtable.substring(detailtable.lastIndexOf("dt")+2,detailtable.length());
					  %>
					       <option value="<%=detailtable%>"  <%if(formtype.equals(detailtable)){ %> selected <%} %>><%=SystemEnv.getHtmlLabelName(126218, user.getLanguage()) %><%=detailtable %></option>
					  <% 	  
					          }
					      }
					   %>
					       </select>
					       
					   </td>
					</tr>
					
					
					<tr id="modetr" >
						<td class="e8_tblForm_label"><%=SystemEnv.getHtmlLabelName(28485,user.getLanguage())%><!-- 模块名称 --></td>
						<td class="e8_tblForm_field">
						<select id="modeid" name="modeid" style="width: 200px;" onchange="checkSelect('modeid','modeidSpan');">
							<option></option>
							<%
							boolean needImg = true;
							if(formid!=0){
								String modeSql = "select id,modename from modeinfo where formid="+formid+" and (isdelete is null or isdelete=0)";
								if(fmdetachable.equals("1")){
					              	CheckSubCompanyRight mSubRight = new CheckSubCompanyRight();
						  			int[] mSubCom = mSubRight.getSubComByUserRightId(user.getUID(),"ModeSetting:All",0);
						  			String subCompanyIds = "";
						  			for(int i=0;i<mSubCom.length;i++){
						  				if(i==0){
						  					subCompanyIds += ""+mSubCom[i];
						  				}else{
						  					subCompanyIds += ","+mSubCom[i];
						  				}
						  			}
						  			if(subCompanyIds.equals("")){
						  				modeSql+= " and 1=2 ";
						  			}else{
						  				modeSql+= " and subCompanyId in ("+subCompanyIds+") ";
						  			}
					          	}
								modeSql+="  order by id";
								rs.executeSql(modeSql);
								boolean isInSubCompany = false;
								boolean isselected = false;
								while(rs.next()){
									isselected = false;
									String mid = rs.getString("id");
									String mname = rs.getString("modename");
									if(mid.equals(modeid+"")){
										needImg = false;
										isselected = true;
									}
									if(mid.equals(""+modeid)){
										isInSubCompany = true;
									}
							%>
									<option <%if(isselected){%>selected="selected"<%} %> value="<%=mid %>"><%=mname %></option>
							<%} 
								if(!isInSubCompany){
									modeSql = "select id,modename from modeinfo where id="+modeid;
									rs.executeSql(modeSql);
									if(rs.next()){
										String mname = rs.getString("modename");
										needImg = false;
								%>
									<option  selected="selected"  value="<%=modeid %>"><%=mname %></option>
								<% } }
							} %>
						</select>
						<span id="modeidSpan">
							<%if(needImg){%>
                      			<%=needInputImg %>	
                      		<%}%>
						</span>
						</td>
					</tr>            
                      
                    <%
                    	String checkedStr1 = "";
                    	String checkedStr2 = "";
                    	String spanCss1 = "";
                    	String spanCss2 = "";
                    	if(id.equals("0")||remindtimetype==1){
                    		checkedStr1 = "checked";
                    		spanCss2 = "display:none;";
                    	}else{
                    		checkedStr2 = "checked";
                    		spanCss1 = "display:none;";
                    	}
                    	String trCss1 = "display:none;";
                    	if(remindtype==2){
                    		trCss1 = "";
                    	}
                    	String timeValueCss ="";
                    	String timefieldCss = "";
                    	if(remindtimetype2 == 0) {
                    		timeValueCss = "display:none;";
                    	} else {
                    		timefieldCss = "display:none;";
                    	}
                    %>
                    
                    <TR style="<%=trCss1 %>" class="remindtimeTR1">
                      <TD class="e8_tblForm_label"><%=SystemEnv.getHtmlLabelName(82215,user.getLanguage())%><!-- 到期时间 -->
                      <div class="cbboxContainer">
							<span class="cbboxEntry">
								<input type="checkbox" name="remindtimetype" <%=checkedStr1 %> value="1" onclick="changeSCT(this)" /><span class="cbboxLabel"><%=SystemEnv.getHtmlLabelName(82216,user.getLanguage())%><!-- 常量 --></span>
							</span>
							<span class="cbboxEntry">
								<input type="checkbox" name="remindtimetype" <%=checkedStr2 %> value="2" onclick="changeSCT(this)" /><span class="cbboxLabel"><%=SystemEnv.getHtmlLabelName(261,user.getLanguage())%><!-- 字段 --></span>
							</span>
						 </div>
                      </TD>
                      <TD class="e8_tblForm_field">
                      
                      <span id="remindtimetype_1"  class="remindtimetypeSpan" style="<%=spanCss1 %>">
                  		<table>
                      		<tr>
                      			<td class="e8_tblForm_f"><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%><!-- 日期  --></td>
                      			<td class="e8_tblForm_f">
                      			<input name="reminddate" class="calendar" style="width: 120px;" id="reminddate" onclick="WdatePicker()" onchange="checkinput('reminddate','reminddateSpan')" type="text" value="<%=reminddate %>">
                      			<span id="reminddateSpan">
                      				<%if(reminddate.equals("")){%>
                      					<%=needInputImg %>
                      				<%} %>
                      			</span>
							</td>
                      			<td class="e8_tblForm_f">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(277,user.getLanguage())%><!-- 时间 --> </td>
                      			<td class="e8_tblForm_f">
                      			<input name="remindtime" class="calendar" style="width: 120px;" id="remindtime" onclick="WdatePicker({dateFmt:'HH:mm:ss'})" onchange="checkinput('remindtime','remindtimeSpan')" type="text" value="<%=remindtime %>">
                      			<span id="remindtimeSpan">
                      				<%if(remindtime.equals("")){%>
                      					<%=needInputImg %>
                      				<%} %>
                      			</span>
							</td>
                      		</tr>
                      	</table>
                  	</span>
                  	
                      <span id="remindtimetype_2"  class="remindtimetypeSpan" style="<%=spanCss2 %>">
                      	<table>
                      		<tr>
                      			<td class="e8_tblForm_f"><%=SystemEnv.getHtmlLabelName(82217,user.getLanguage())%><!-- 日期字段 --> </td>
                      			<td class="e8_tblForm_f">
                      			<brow:browser viewType="0" id="reminddatefield" name="reminddatefield" browserValue='<%=reminddatefield+"" %>' 
			  		 				browserUrl="'+getShowUrl(1)+'"
									hasInput="false" isSingle="true" hasBrowser = "true" isMustInput="2"
									completeUrl="/data.jsp" linkUrl=""  width="222px"
									browserDialogWidth="510px"
									browserSpanValue='<%=getFieldShowName(reminddatefield+"", user) %>'
									_callback="checkIsSameTable"
								></brow:browser>
							</td>
                      			<td class="e8_tblForm_f">
                      				<select name="remindtimetype2" id="remindtimetype2" style="width: 80px;" onchange="onchangeRemindTimeType2(this)">
										<option value="0" <%if(remindtimetype2==0){%>selected="selected"<%} %>><%=SystemEnv.getHtmlLabelName(82218,user.getLanguage())%><!-- 时间字段 --></option>
										<option value="1" <%if(remindtimetype2==1){%>selected="selected"<%} %>><%=SystemEnv.getHtmlLabelName(126407,user.getLanguage())%><!-- 时间常量--></option>
									</select>
                      			</td>
                      			<td class="e8_tblForm_f">
                      			<div id="remindtimevaluediv" style="<%=timeValueCss%>">
                      				<input name="remindtimevalue" class="calendar" style="width: 120px;" id="remindtimevalue" onclick="WdatePicker({dateFmt:'HH:mm:ss'})" onchange="checkinput('remindtimevalue','remindtimevalueSpan')" type="text" value="<%=remindtimevalue %>">
                      				<span id="remindtimevalueSpan">
                      					<%if(remindtimevalue.equals("")){%>
                      						<%=needInputImg %>
                      					<%} %>
                      				</span>	
                      			</div>
                      			<div id="remindtimefielddiv" style="<%=timefieldCss%>">
                      				<brow:browser viewType="0" id="remindtimefield" name="remindtimefield" browserValue='<%=remindtimefield+"" %>' 
			  		 					browserUrl="'+getShowUrl(2)+'"
										hasInput="false" isSingle="true" hasBrowser = "true" isMustInput="2"
										completeUrl="/data.jsp" linkUrl=""  width="222px"
										browserDialogWidth="510px"
										browserSpanValue='<%=getFieldShowName(remindtimefield+"", user) %>'
										_callback="checkIsSameTable"
									></brow:browser>
								</div>
							</td>
                      		</tr>
                      	</table>
                     </span>
                      </TD>
                    </TR>                      
                   
                   <tr style="<%=trCss1 %>" class="remindtimeTR2">
						<td class="e8_tblForm_label e8_tblForm_last"><%=SystemEnv.getHtmlLabelName(82219,user.getLanguage())%><!-- 时间增量 --></td>
						<td class="e8_tblForm_field e8_tblForm_last">
							<table style="width: 100%;">
								<colgroup>
									<col style="width: 20%">
									<col style="width: 20%">
									<col style="width: 25%">
									<col style="width: 30%">
								</colgroup>
								<tr>
									<td>
										<select name="incrementway" id="incrementway" style="width: 80px;">
											<option value=""></option>
											<option value="1" <%if(incrementway==1){%>selected="selected"<%} %>><%=SystemEnv.getHtmlLabelName(17548,user.getLanguage())%><!-- 提前 --></option>
											<option value="2" <%if(incrementway==2){%>selected="selected"<%} %>><%=SystemEnv.getHtmlLabelName(82220,user.getLanguage())%><!-- 延迟 --></option>
										</select>
									</td>
									<td>
										<select name="incrementtype" id="incrementtype" style="width: 80px;" onchange="changeIncrementtype();">
											<option value="1" <%if(incrementtype==1){%>selected="selected"<%} %>><%=SystemEnv.getHtmlLabelName(82221,user.getLanguage())%><!-- 整数常量 --></option>
											<option value="2" <%if(incrementtype==2){%>selected="selected"<%} %>><%=SystemEnv.getHtmlLabelName(82222,user.getLanguage())%><!-- 整数字段 --></option>
										</select>
									</td>
									<td>
										<span id="incrementSpan1" <%if(incrementtype==2){%>style="display: none;"<%} %>><input type="text" style="width: 100%;" name="incrementnum" id="incrementnum" value="<%=incrementnum %>" /></span>
										<span id="incrementSpan2" <%if(incrementtype!=2){%>style="display: none;"<%} %>>
											<brow:browser viewType="0" id="tablekey" name="incrementfield" browserValue='<%=incrementfield+"" %>' 
						  		 				browserUrl="'+getShowUrl(3)+'"
												hasInput="false" isSingle="true" hasBrowser = "true" isMustInput="1"
												completeUrl="/data.jsp" linkUrl=""  width="222px"
												browserDialogWidth="510px"
												browserSpanValue='<%=getFieldShowName(incrementfield+"", user) %>'
											></brow:browser>
										</span>
									</td>
									<td>
										<select name="incrementunit" id="incrementunit" style="width: 80px;">
											<option value="1" <%if(incrementunit==1){%>selected="selected"<%} %>><%=SystemEnv.getHtmlLabelName(15049,user.getLanguage())%><!-- 分钟 --></option>
											<option value="2" <%if(incrementunit==2){%>selected="selected"<%} %>><%=SystemEnv.getHtmlLabelName(391,user.getLanguage())%><!-- 小时 --></option>
											<option value="3" <%if(incrementunit==3){%>selected="selected"<%} %>><%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%><!-- 天 --></option>
										</select>
									</td>
								</tr>
							</table>
						</td>
					</tr>
					</TBODY>
					</TABLE>
					</wea:item>
				</wea:group>
			
				<wea:group context='<%=SystemEnv.getHtmlLabelName(18121,user.getLanguage())%>' attributes="{'groupOperDisplay':none}"><!-- 提醒信息 -->
					<wea:item>
					
					
			
			<TABLE class="e8_tblForm">
				<COLGROUP>
					<COL width="20%">
					<COL width="80%">
				</COLGROUP>
			  	<TBODY>
                   
	                    <%   
		                     String bname = "<IMG src=\"/images/BacoError_wev8.gif\" align=absMiddle>";
					  		 RecordSet.executeSql("select * from workflow_bill where id='"+formid+"'");
					 		 
				  		 %>
						          
                      
                    <%
                    	String checkedStr1 = "";
                    	String checkedStr2 = "";
                    	String spanCss1 = "";
                    	String spanCss2 = "";
                    	if(id.equals("0")||remindtimetype==1){
                    		checkedStr1 = "checked";
                    		spanCss2 = "display:none;";
                    	}else{
                    		checkedStr2 = "checked";
                    		spanCss1 = "display:none;";
                    	}
                    	String trCss1 = "display:none;";
                    	if(remindtype==2){
                    		trCss1 = "";
                    	}
                    %>
                    
                    <TR  >
				       <td class="e8_tblForm_label" width="20%"><%=SystemEnv.getHtmlLabelName(18713,user.getLanguage())%><!-- 提醒方式 --></TD>
				       <TD class="e8_tblForm_field">
				       	 	
                      		<input type="radio" name="remindway" <%if(id.equals("0")||remindway==2){%>checked="checked"<%} %> value="2" onclick="changeRemindway();"><%=SystemEnv.getHtmlLabelName(17586,user.getLanguage())%><!-- 短信提醒 -->
                      		<input type="radio" name="remindway" <%if(remindway==3){%>checked="checked"<%} %> value="3" onclick="changeRemindway();"><%=SystemEnv.getHtmlLabelName(18845,user.getLanguage())%><!-- 邮件提醒 -->
                      		<input type="radio" name="remindway" <%if(remindway==4){%>checked="checked"<%} %> value="4" onclick="changeRemindway();"><%=SystemEnv.getHtmlLabelName(23042,user.getLanguage())%><!-- 流程提醒 -->
							<input type="radio" name="remindway" <%if(remindway==5){%>checked="checked"<%} %> value="5" onclick="changeRemindway();"><%=SystemEnv.getHtmlLabelName(128282,user.getLanguage())%><!-- 微信提醒-->
                      		<span id="weixinspan" style="color:red;<%if(remindway!=5){%>display:none<%} %>">
                      			<span title=''>
									<a href="javascript:openFullWindow('/formmode/setup/wechatSetHelpDoc.jsp')" title="<%=SystemEnv.getHtmlLabelName(128817,user.getLanguage())%>"><img align="absMiddle" src="/images/remind_wev8.png"></a>
								</span>
							</span>
				       </TD>
				     </TR>   
				     <TR   id="emailTR" style="display: none;">
				       <td class="e8_tblForm_label" width="20%">
				       		<span id="emailText3"><%=SystemEnv.getHtmlLabelName(82223,user.getLanguage())%></span><!-- 邮件标题 -->
				       		<span id="emailText4"><%=SystemEnv.getHtmlLabelName(26876,user.getLanguage())%></span><!-- 流程标题 -->
				       	</TD>
				       <TD class="e8_tblForm_field">
				       		<%=SystemEnv.getHtmlLabelName(82224,user.getLanguage())%><!-- 选择字段变量： -->
                   			<select id="subjectSelect" name="subjectSelect" style="width: 200px;" onchange="varSelectChange('subjectSelect','subject');checkinput('subject','subjectSpan')">
                   				<option></option>
                   				<%
                   				if(formid!=0){
                   					if(remindtype == 1 || remindtype == 3){
                   						sql = "select a.fieldname,a.detailtable,a.fieldlabel from workflow_billfield a where a.billid="+formid+" and a.viewtype=0 order by detailtable desc";
                   					}else{
                   						sql = "select a.fieldname,a.detailtable,a.fieldlabel from workflow_billfield a where a.billid="+formid+" order by detailtable desc";
                   					}
	                   				rs.executeSql(sql);
	                   				while(rs.next()){
	                   					String fieldname = rs.getString("fieldname");
	                   					String detailtable = rs.getString("detailtable");
	                   					int fieldlabel = Util.getIntValue(rs.getString("fieldlabel"), 0);
	                   					String indexdesc = SystemEnv.getHtmlLabelName(fieldlabel,user.getLanguage());
	                   					if(detailtable != null && !detailtable.equals("")){
	                   						String tempdetailtable = detailtable.substring(detailtable.length()-1,detailtable.length());
	                   						indexdesc += "("+SystemEnv.getHtmlLabelName(17463,user.getLanguage())+tempdetailtable+")";
	                   						fieldname = detailtable+"."+fieldname;
	                   					}
	                   					%>
	                   					<option value="<%=fieldname %>"><%=indexdesc %></option>
	                   					<%
	                   				}
                   				}
                   				%>
                   			</select>
                   			<br>
				       		<input type="text" name="subject" id="subject" value="<%=subject %>" onchange="checkinput('subject','subjectSpan')" style="width: 70%;">
				       		<span id="subjectSpan">
				       			<%if(subject.equals("")){%>
                					<%=needInputImg %>
                				<%} %>
				       		</span>
				      
                     			<span title='<%=SystemEnv.getHtmlLabelName(82362,user.getLanguage()).replace(SystemEnv.getHtmlLabelName(82223,user.getLanguage()),SystemEnv.getHtmlLabelName(229,user.getLanguage()))%>&#10;<%=SystemEnv.getHtmlLabelName(82363,user.getLanguage())%>' id="remind">
								<img align="absMiddle" src="/images/remind_wev8.png">
							</span>
				       </TD>
				     </TR>                   
                    <TR id="senderTR" style="display: none;">
				       <td class="e8_tblForm_label" width="20%">
				       		<span id="senderText2"><%=SystemEnv.getHtmlLabelName(82225,user.getLanguage())%></span><!-- 短信发送人 -->
				       		<span id="senderText4" style="display: none;" ><%=SystemEnv.getHtmlLabelName(28595,user.getLanguage())%></span><!-- 流程创建人 -->
				       </TD>
				       <TD class="e8_tblForm_field">
				       		<table style="width: 100%;">
				       			<colgroup>
				       				<col style="width: 25%">
				       				<col style="width: 75%">
				       			</colgroup>
				       			<tr>
				       				<td >
					       				<select id="sendertype" name="sendertype" onchange="changeSenderType();">
							       	 		<option value="1" <%if(sendertype==1){%>selected="selected"<%} %> ><%=SystemEnv.getHtmlLabelName(16139,user.getLanguage())%><!-- 系统管理员 --></option>
							       	 		<%if(haveCreater){%> <option value="2" <%if(sendertype==2){%>selected="selected"<%} %>  ><%=SystemEnv.getHtmlLabelName(28597,user.getLanguage())%><!-- 模块创建人 --></option><%} %>
							       	 		<option value="3" <%if(sendertype==3){%>selected="selected"<%} %> ><%=SystemEnv.getHtmlLabelName(82226,user.getLanguage())%><!-- 单人力资源字段 --></option>
							       	 	</select>
				       					
				       				</td>
				       				
				       				<td>
							       	 	<%
							       	 	String senderfieldSql = "select a.id,a.fieldname,b.labelname,a.detailtable from workflow_billfield a,HtmlLabelInfo b where a.billid="+formid+" and a.fieldlabel=b.indexid and b.languageid=7 and a.fieldhtmltype=3 and a.type=1 order by a.id asc,detailtable asc";
							       	 	RecordSet.executeSql(senderfieldSql);
							       	 	%>
							       	 	<span id="senderTextSpan" style="display: none;">
				       						<%=SystemEnv.getHtmlLabelName(261,user.getLanguage())%><!-- 字段 -->
							       	 	</span>
				       					<span id="senderfieldSpan">
						       				<select style="width: 160px;"  id="senderfield" name="senderfield" onchange="checkSelect('senderfield','senderfieldSpanImg');">
						       					<option value=""> </option>
						       					<%
						       						boolean needimg = true;
						       						while(RecordSet.next()){
						       							String fieldid = RecordSet.getString("id");
						       							String labelname = RecordSet.getString("labelname");
						       							String detailtable = RecordSet.getString("detailtable");
						       							String selectStr = "";
						       							if(detailtable != null && !detailtable.equals("")){
						       								if(detailtable.substring(detailtable.length()-1,detailtable.length()).equals(formtype)){
						       									labelname += "(" + SystemEnv.getHtmlLabelName(126218, user.getLanguage()) +formtype+")";
						       								}else{
						       									continue;
						       								}
						       							}
						       							if(fieldid.equals(""+senderfield)){
						       								selectStr = "selected";
						       								needimg = false;
						       							}
						       							%>
						       							<option value="<%=fieldid %>" <%=selectStr %> ><%=labelname %></option>
						       							<%
						       						}
						       					%>
						       				</select>
						       				
						       				<span id="senderfieldSpanImg">
			                      				<%if(needimg){%>
			                      					<%=needInputImg %>
			                      				<%} %>
			                      			</span>
				       					</span>
				       				</td>
				       			</tr>
				       		</table>
				       	 	
				       </TD>
				     </TR>
                    <TR id="remindcontentURL_TR" style="display: none;">       
                   	  <TD class="e8_tblForm_label">
                      	<%=SystemEnv.getHtmlLabelName(27415,user.getLanguage())%>url<!-- 提醒内容URL -->
                      </TD>
                      <TD class="e8_tblForm_field">
                      		<span class="remindcontenttypeSpan">
                      			<input type="text" name="remindcontentURL" id="remindcontentURL" value="<%=remindcontentURL%>" onchange="checkinput('remindcontentURL','remindcontentURLSpan')" style="width: 70%;">
                      			<span title='<%=SystemEnv.getHtmlLabelName(82358,user.getLanguage())%>&#10;$billid$：<%=SystemEnv.getHtmlLabelName(81287,user.getLanguage())%>，$modeId$：<%=SystemEnv.getHtmlLabelName(81301,user.getLanguage())%>，$formId$：<%=SystemEnv.getHtmlLabelName(32673,user.getLanguage())%>&#10;<%=SystemEnv.getHtmlLabelName(82363,user.getLanguage())%>' >
									<img align="absMiddle" src="/images/remind_wev8.png">
								</span>
                      		</span>
                      </TD>
                    </TR>
                    <TR>
                    <%
	                    checkedStr1 = "";
	                	checkedStr2 = "";
	                	spanCss1 = "";
	                	spanCss2 = "";
	                	if(id.equals("0")||conditionstype==1){
	                		checkedStr1 = "checked";
	                		spanCss2 = "display:none;";
	                	}else{
	                		checkedStr2 = "checked";
	                		spanCss1 = "display:none;";
	                	}
                    %>
                      <TD class="e8_tblForm_label">
                      	<%=SystemEnv.getHtmlLabelName(82227,user.getLanguage())%><!-- 提醒条件 -->
	                      <div class="cbboxContainer">
							<span class="cbboxEntry">
								<input type="checkbox" name="conditionstype" <%=checkedStr1 %> value="1" onclick="changeSCT(this)" /><span class="cbboxLabel"><%=SystemEnv.getHtmlLabelName(261,user.getLanguage())%><!-- 字段 --></span>
							</span>
							<span class="cbboxEntry">
								<input type="checkbox" name="conditionstype" <%=checkedStr2 %> value="2" onclick="changeSCT(this)" /><span class="cbboxLabel">sql</span>
							</span>
						 </div>
                      </TD>
                      <TD class="e8_tblForm_field">
                      		<%if(id.equals("0")){%>
                      			<span id="conditionstype_1" class="conditionstypeSpan" style="<%=spanCss1 %>" >
                      				<%=SystemEnv.getHtmlLabelName(82228,user.getLanguage())%><!-- 请先保存再设置条件 -->
                      			</span>
                      		<%}else{%>
                      			<span id="conditionstype_1" class="conditionstypeSpan" style="<%=spanCss1 %>" >
                      			<%
									conditionsfieldcn = conditionsfieldcn.replace(",","&#44;");
								%>
								<brow:browser viewType="0" id="conditionsfield" name="conditionsfield" browserValue="1" 
			  		 				browserUrl="'+getOnShowConditionUrl()+'"
									hasInput="false" isSingle="true" hasBrowser = "true" isMustInput="1"
									completeUrl="/data.jsp" linkUrl=""  width="228px"
									browserDialogWidth="610px" tempTitle="<%=SystemEnv.getHtmlLabelName(81602,user.getLanguage())%>"
									browserSpanValue='<%=conditionsfieldcn %>'
									_callback="reloadWin"
									></brow:browser>
                      			</span>
                      		<%} %>
                      		
                      		
                      		<span id="conditionstype_2" class="conditionstypeSpan" style="<%=spanCss2 %>" >
                      			<textarea rows="3" name="conditionssql" id="conditionssql" cols="80"><%=conditionssql %></textarea>
	                      		<div class="e8_label_desc" id="descSpan"><%=SystemEnv.getHtmlLabelName(82229,user.getLanguage())%><!-- 表单表名的别名为t1,查询条件的格式为: t1.a = '1' and t1.b = '3'。 --></div>
                      		</span>
                      		<span id="conditionsjavaSpan" style="display: none;">
                      			<input type="hidden" name="conditionsjava" id="conditionsjava" value="<%=conditionsjava %>">
                      		</span>
                      </TD>
                    </TR>
					<tr>       
					<%
						checkedStr1 = "";
	                	checkedStr2 = "";
	                	spanCss1 = "";
	                	spanCss2 = "";
	                	if(id.equals("0")||remindcontenttype==1){
	                		checkedStr1 = "checked";
	                		spanCss2 = "display:none;";
	                	}else{
	                		checkedStr2 = "checked";
	                		spanCss1 = "display:none;";
	                	}
                    %>          
                    <TD class="e8_tblForm_label">
                      	<%=SystemEnv.getHtmlLabelName(27415,user.getLanguage())%><!-- 提醒内容 -->
	                      <div class="cbboxContainer">
							<span class="cbboxEntry">
								<input type="checkbox" name="remindcontenttype" <%=checkedStr1 %> onclick="changeSCT(this)" value="1" /><span class="cbboxLabel"><%=SystemEnv.getHtmlLabelName(608,user.getLanguage())%><!-- 文本 --></span>
							</span>
							<span class="cbboxEntry">
								<input type="checkbox" name="remindcontenttype" <%=checkedStr2 %> onclick="changeSCT(this)" value="2" /><span class="cbboxLabel">java</span>
							</span>
						 </div>
                      </TD>
                      <TD class="e8_tblForm_field">
                      		<span id="remindcontenttype_1" class="remindcontenttypeSpan" style="<%=spanCss1 %>" >
                      			<%=SystemEnv.getHtmlLabelName(82224,user.getLanguage())%><!-- 选择字段变量： -->
                      			<select id="contentSelect" name="contentSelect" style="width: 200px;" onchange="varSelectChange('contentSelect','remindcontenttext');">
                      				<option></option>
                      				<%
	                   				if(formid!=0){
		                   				rs.beforFirst();
		                   				while(rs.next()){
		                   					String fieldname = rs.getString("fieldname");
		                   					String detailtable = rs.getString("detailtable");
		                   					int fieldlabel = Util.getIntValue(rs.getString("fieldlabel"), 0);
	                   						String indexdesc = SystemEnv.getHtmlLabelName(fieldlabel,user.getLanguage());
		                   					if(detailtable != null && !detailtable.equals("")){
		                   						String tempdetailtable = detailtable.substring(detailtable.length()-1,detailtable.length());
		                   						indexdesc += "("+SystemEnv.getHtmlLabelName(17463,user.getLanguage())+tempdetailtable+")";
		                   						fieldname = detailtable+"."+fieldname;
		                   					}
		                   					%>
		                   					<option value="<%=fieldname %>"><%=indexdesc %></option>
		                   					<%
		                   				}
	                   				}
	                   				%>
                      			</select>
                      			<br>
                      			<textarea name="remindcontenttext" id="remindcontenttext" onchange="checkinput('remindcontenttext','remindcontenttextSpan')" rows="3" style="width: 70%"><%=remindcontenttext %></textarea>
                      			<span id="remindcontenttextSpan">
                      				<%if(remindcontenttext.equals("")){%>
                      					<%=needInputImg %>
                      				<%} %>
                      			</span>
                      			
                      			<span title='<%=SystemEnv.getHtmlLabelName(82364,user.getLanguage())%>&#10;<%=SystemEnv.getHtmlLabelName(82363,user.getLanguage())%>' id="remind">
									<img align="absMiddle" src="/images/remind_wev8.png">
								</span>
                      		</span>
                      		<span id="remindcontenttype_2" class="remindcontenttypeSpan" style="<%=spanCss2 %>" >
                      			<input type="text" id="remindcontentaddress" name="remindcontentaddress"  onchange="checkinput('remindcontentaddress','remindcontentaddressSpan')" style="min-width:40%;float: left;" value="<%=remindcontentaddress%>"/>
					            <span id="remindcontentaddressSpan" style="float: left;padding-right: 3px;padding-top: 3px;">
                                    <%if(remindcontentaddress.equals("")){%>
                                        <%=needInputImg %>
                                    <%} %>
                                </span>
                                <%if(!"".equals(remindcontentjava)){%>
                                <span class="codeEditFlag" onclick="openCodeEdit();">
                                </span>
                                <input type="hidden" id="remindcontentjava" name="remindcontentjava" value="<%=remindcontentjava %>"/>
                                <%}%>
					            <span class="codeDownFlag" onclick="downloadMode()" title="<%=SystemEnv.getHtmlLabelName(382920, user
                                .getLanguage())%>"></span>
						         <br>
                                 <br><span style="Letter-spacing:1px;"><%=SystemEnv.getHtmlLabelName(384524, user
                                      .getLanguage())%>weaver.formmode.customjavacode.remindjob.XXX。</span>   
                      		</span>
                      </TD>
                    </TR>
					<tr>
                    <TD class="e8_tblForm_label">
                      	<%=SystemEnv.getHtmlLabelName(26731,user.getLanguage())%><!-- 提醒人员 -->
                      </TD>
                      <TD class="e8_tblForm_field">
                      		<select name="receivertype" id="receivertype" onchange="changeReceivertype();" >  
					           <option value="1" <%if(receivertype==1){%>selected="selected"<%} %> ><%=SystemEnv.getHtmlLabelName(1867,user.getLanguage())%></option> <!-- 人员 -->
					           <option value="2" <%if(receivertype==2){%>selected="selected"<%} %>><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></option><!-- 分部 -->
					           <option value="3" <%if(receivertype==3){%>selected="selected"<%} %>><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></option><!-- 部门 -->
					           <option value="4" <%if(receivertype==4){%>selected="selected"<%} %>><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></option><!-- 角色 -->
					           <option value="5" <%if(receivertype==5){%>selected="selected"<%} %>><%=SystemEnv.getHtmlLabelName(1340,user.getLanguage())%></option><!-- 所有人 -->
					           <%if(haveCreater){%><option value="6" <%if(receivertype==6){%>selected="selected"<%} %>><%=SystemEnv.getHtmlLabelName(28597,user.getLanguage())%></option><!-- 模块创建人 --><%}%>
					           <option value="1000" <%if(receivertype==1000){%>selected="selected"<%} %>><%=SystemEnv.getHtmlLabelName(28605,user.getLanguage())%></option><!-- 模块主字段 -->
					         </select>
					         	<span id="receiverfieldtypespan" <%if(receivertype!=1000){%>style="display: none;"<%} %>>
					            <span><%=SystemEnv.getHtmlLabelName(686,user.getLanguage())%></span><!-- 字段类型 -->
						         
						         <select style="width: 80px;" class=InputStyle id="receiverfieldtype" name="receiverfieldtype" onchange="changeFieldType(this)">
						         	<option value="1" <%if(receiverfieldtype==1){%>selected="selected"<%} %>><%=SystemEnv.getHtmlLabelName(1867,user.getLanguage())%></option><!-- 人员 -->
						         	<option value="2" <%if(receiverfieldtype==2){%>selected="selected"<%} %>><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></option><!-- 部门 -->
						         	<option value="3" <%if(receiverfieldtype==3){%>selected="selected"<%} %>><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></option><!-- 分部 -->
						         </select>
						         </span>
                      </TD>
                    </TR> 
                    <TR id="browserTr">
                    	<%
                    		String showspan1Css = "display:none";
                    		String showspan2Css = "display:none";
                    		String showspan3Css = "display:none";
                    		String showspan4Css = "display:none";
                    		String showspan1000Css = "display:none";
                    		FieldInfo fieldInfo = new FieldInfo();
                    		String value1 = "";
                    		String value2 = "";
                    		String value3 = "";
                    		String value4 = "";
                    		String value1000 = "";
                    		String showname1 = "";
                    		String showname2 = "";
                    		String showname3 = "";
                    		String showname4 = "";
                    		String showname1000 = "";
                    		int type = 0;
                    		if(id.equals("0")||receivertype==1){//人力资源
                    			type = 17;
                    			showspan1Css = "";
                    			value1 = receiverdetail;
                    			showname1 = fieldInfo.getFieldName(receiverdetail, type, "");
                    		}else if(receivertype==2){//分部
                    			type = 164;
                    			showspan2Css = "";
                    			value2 = receiverdetail;
                    			showname2 = fieldInfo.getFieldName(receiverdetail, type, "");
                    		}else if(receivertype==3){//部门
                    			type = 57;
                    			showspan3Css = "";
                    			value3 = receiverdetail;
                    			showname3 = fieldInfo.getFieldName(receiverdetail, type, "");
                    		}else if(receivertype==4){//角色
                    			type = 65;
                    			showspan4Css = "";
                    			value4 = receiverdetail;
                    			showname4 = fieldInfo.getFieldName(receiverdetail, type, "");
                    		}else if(receivertype==5){//所有人
                    			
                    		}else if(receivertype==1000){//字段
                    			value1000 = receiverdetail;
                    			showname1000 = getFieldShowName(receiverdetail, user);
                    			showspan1000Css = "";
                    		}
                    	%>
				     	<TD class="e8_tblForm_label" width="20%"><%=SystemEnv.getHtmlLabelName(172,user.getLanguage())%><!-- 选择 --></TD>
				     	<TD class="e8_tblForm_field">
				     	 <span id="showspan1" style="<%=showspan1Css %>">
				         	<brow:browser viewType="0" name="relatedid1" browserValue='<%=value1 %>' browserOnClick="" 
				         		browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids=" 
				         		hasInput="true"  width="50%" isSingle="false" hasBrowser="true" completeUrl="/data.jsp?type=17" browserSpanValue='<%=showname1 %>' isMustInput="2">
				         	</brow:browser>
				         </span>
				         <span id="showspan2" style="<%=showspan2Css %>">
				         	<brow:browser viewType="0" name="relatedid2" browserValue='<%=value2 %>' browserOnClick="" 
				         		browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser3.jsp?selectedids=&selectedDepartmentIds=" 
				         		hasInput="true"  width="50%" isSingle="false" hasBrowser="true" completeUrl="/data.jsp?type=194" browserSpanValue='<%=showname2 %>' isMustInput="2">
				         	</brow:browser>
				         </span>
				         <span id="showspan3" style="<%=showspan3Css %>">
				         	<brow:browser viewType="0" name="relatedid3" browserValue='<%=value3 %>' browserOnClick="" 
				         		browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp?selectedids=" 
				         		hasInput="true"  width="50%" isSingle="false" hasBrowser="true" completeUrl="/data.jsp?type=57" browserSpanValue='<%=showname3 %>' isMustInput="2">
				         	</brow:browser>
				         </span>
				         <span id="showspan4" style="<%=showspan4Css %>">
				         	<brow:browser viewType="0" name="relatedid4" browserValue='<%=value4 %>' browserOnClick="" 
				         		browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/roles/MutiRolesBrowser.jsp" 
				         		hasInput="true"  width="50%" isSingle="false" hasBrowser="true" completeUrl="/data.jsp?type=65" browserSpanValue='<%=showname4 %>' isMustInput="2">
				         	</brow:browser>
				         </span>
				         <span id="showspan1000" style="<%=showspan1000Css %>">
				         	<brow:browser viewType="0" name="relatedid1000" browserValue='<%=value1000 %>' browserOnClick="" getBrowserUrlFn="modefiledChange" 
				         		hasInput="false"  width="50%" isSingle="false" hasBrowser="true" completeUrl="/data.jsp?type=10000" browserSpanValue='<%=showname1000 %>' isMustInput="2">
				         	</brow:browser>
				         </span>
				     	</TD>
				     </TR>
				     <TR  id=showlevel_tr name=showlevel_tr style="display:none;height: 1px">
				       <td class="e8_tblForm_label" width="20%"><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></TD><!-- 安全级别 -->
				       <TD class="e8_tblForm_field">
				       	 <INPUT type=text name="receiverlevel" id="receiverlevel" class=InputStyle size=6 value="<%=receiverlevel %>"  onKeyPress="ItemCount_KeyPress()">
				         <span id=receiverlevelimage></span>
				       </TD>
				     </TR>
				     </TBODY>
				     </table>
				     </wea:item>
				</wea:group>
				
		     <wea:group context='<%=SystemEnv.getHtmlLabelName(82230,user.getLanguage())%>' attributes="{'groupOperDisplay':none}"><!-- 定时器 -->
				<wea:item>
				<TABLE class="e8_tblForm triggerTable">
				<COLGROUP>
					<COL width="20%">
					<COL width="80%">
				</COLGROUP>
			  	<TBODY>
						
				     <%
                   		String tr0Css = "display:none";
                   		String tr1Css = "display:none";
                   		String tr2Css = "display:none";
                   		String tr3Css = "display:none";
                   		String tr4Css = "display:none";
                   		String tr5Css = "display:none";
                   		String tr6Css = "display:none";
						if(id.equals("0")||remindtype==1){//即时提醒--全部隐藏
							
                   		}else if(triggerway==2){
                   			tr0Css = "";
                   			tr1Css = "";
                   			tr4Css = "";
                   		}else{
                   			tr0Css = "";
                   			tr1Css = "";
                   			tr2Css = "";
                   			tr3Css = "";
                   		}
						
                   		
                   	%>
				     <TR class="triggerTR1" style="<%=tr1Css %>">
                      <TD class="e8_tblForm_label">
                      	<%=SystemEnv.getHtmlLabelName(82231,user.getLanguage())%><!-- 定时器触发方式 -->
                      </TD>
                      <TD class="e8_tblForm_field">
                      		<select id="triggerway" name="triggerway" onchange="changeTriggerway();">
                      			<option value="1" <%if(id.equals("0")||triggerway==1){%>selected="selected"<%} %>><%=SystemEnv.getHtmlLabelName(82232,user.getLanguage())%><!-- 简单规则 --></option>
                      			<option value="2" <%if(triggerway==2){%>selected="selected"<%} %> ><%=SystemEnv.getHtmlLabelName(15636,user.getLanguage())%><!-- 表达式 --></option>
                      		</select>
                      </TD>
                    </TR> 
                   	
                    <TR class="triggerTR2" style="<%=tr2Css %>">
                      <TD class="e8_tblForm_label">
                      	<%=SystemEnv.getHtmlLabelName(82233,user.getLanguage())%><!-- 定时器运行频率 -->
                      </TD>
                      <TD class="e8_tblForm_field">
                      		<input type="radio" <%if(id.equals("0")||triggertype==1){%>checked="checked"<%} %> name="triggertype" value="1" onclick="changeTriggertype(1)" ><%=SystemEnv.getHtmlLabelName(15049,user.getLanguage())%><!-- 分钟 -->
                      		<input type="radio" <%if(triggertype==2){%>checked="checked"<%} %> name="triggertype" value="2" onclick="changeTriggertype(2)" ><%=SystemEnv.getHtmlLabelName(391,user.getLanguage())%><!-- 小时 -->
                      		<input type="radio" <%if(triggertype==3){%>checked="checked"<%} %> name="triggertype" value="3" onclick="changeTriggertype(3)" ><%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%><!-- 天 -->
                      		<input type="radio" <%if(triggertype==4){%>checked="checked"<%} %> name="triggertype" value="4" onclick="changeTriggertype(4)" ><%=SystemEnv.getHtmlLabelName(1926,user.getLanguage())%><!-- 周 -->
                      		<input type="radio" <%if(triggertype==5){%>checked="checked"<%} %> name="triggertype" value="5" onclick="changeTriggertype(5)" ><%=SystemEnv.getHtmlLabelName(6076,user.getLanguage())%><!-- 月 -->
                      		<input type="radio" <%if(triggertype==6){%>checked="checked"<%} %> name="triggertype" value="6" onclick="changeTriggertype(6)" ><%=SystemEnv.getHtmlLabelName(82234,user.getLanguage())%><!-- 仅一次 -->
                      </TD>
                    </TR>  
                    <TR class="triggerTR3" style="<%=tr3Css %>">
                      <TD class="e8_tblForm_label">
                      	<%=SystemEnv.getHtmlLabelName(82235,user.getLanguage())%><!-- 定时器循环周期 -->
                      </TD>
                      <TD class="e8_tblForm_field">
                      		<%if(id.equals("0")){
                      			triggercycletime = 5;
                      		} 
                      		String triggercycletimeStr = triggercycletime+"";
                      		if(triggercycletimeStr.equals("0")){
                      			triggercycletimeStr = "";
                      		}
                      		%>
                      		<%=SystemEnv.getHtmlLabelName(21977,user.getLanguage())%><!-- 每 --><input type="text" style="width: 50px;" name="triggercycletime" id="triggercycletime" onchange="checkinput('triggercycletime','triggercycletimeSpan')" value="<%=triggercycletimeStr %>">
                      		<span id="triggercycletimeSpan0"><%=SystemEnv.getHtmlLabelName(15049,user.getLanguage())%><!-- 分钟 --></span>
                      		<span id="triggercycletimeSpan">
                      		<%if(triggercycletimeStr.equals("")){%>
                      			<%=needInputImg %>
                      		<%} %>
                      		</span>
                      </TD>
                    </TR>  
                    
                     <TR class="triggerTR4" style="<%=tr4Css %>">
                      <TD class="e8_tblForm_label">
                      	<%=SystemEnv.getHtmlLabelName(82236,user.getLanguage())%><!-- 定时器表达式 -->
                      </TD>
                      <TD class="e8_tblForm_field">
                      		<input type="text" name="triggerexpression" id="triggerexpression" style="width:300px;"value="<%=triggerexpression%>" onchange="checkinput('triggerexpression','triggerexpressionSpan')"/>
							<span id="triggerexpressionSpan">
                      		<%if(triggerexpression.equals("")){%>
                      			<%=needInputImg %>
                      		<%} %>
                      		</span>
                      </TD>
                    </TR>
                    
                    <tr class="triggerTR5" style="<%=tr5Css %>" >
						<td class="e8_tblForm_label"  ><%=SystemEnv.getHtmlLabelName(82237,user.getLanguage())%><!-- 星期选择 --></td>
						<td class="e8_tblForm_field" >
						
							<table  style="width: 350px">
								<colgroup>
									<col style="width: 50px;">
									<col style="width: 180px;">
									<col style="width: 50px;">
								</colgroup>
								<tr>
									<td><span><input type="checkbox" onclick="selectAllWeek(this)"/><%=SystemEnv.getHtmlLabelName(556,user.getLanguage())%><!-- 全选 --></span></td>
									<td>
										<span id=weekdiv></span>
										<input type="hidden" name="weekval" id="weekval" onchange="checkinput('weekval','weekvalSpan')" value="<%=weeks %>">
									</td>
									<td>
										<span id="weekvalSpan">
											<%if(weeks.equals("")){%>
												<%=needInputImg %>
											<%} %>
										</span>
									</td>
								</tr>
							</table>
						</td>					
					</tr>
					<tr class="triggerTR6" style="<%=tr6Css %>" >
						<td class="e8_tblForm_label"  ><%=SystemEnv.getHtmlLabelName(82238,user.getLanguage())%><!-- 月份选择 --></td>
						<td class="e8_tblForm_field" >
						<table>
							<tr>
								<td width="80%" class="FieldValue" nowrap>
									<table  style="width: 380px">
										<colgroup>
											<col style="width: 50px;">
											<col style="width: 180px;">
											<col style="width: 50px;">
										</colgroup>
										<tr>
											<td><%=SystemEnv.getHtmlLabelName(887,user.getLanguage())%><!-- 月份 -->&nbsp;&nbsp;<input type="checkbox" onclick="selectAllMonth(this)"/><%=SystemEnv.getHtmlLabelName(556,user.getLanguage())%><!-- 全选 --></td>
											<td><span id="monthdiv"></span>
												<input type="hidden" name="monthval" id="monthval" onchange="checkinput('monthval','monthvalSpan0')" value="<%=months %>">
											</td>
											<td>
												<span id="monthvalSpan0">
													<%if(months.equals("")){%>
														<%=needInputImg %>
													<%} %>
												</span>
											</td>
										</tr>
									</table>
								</td>
							</tr>
							<tr>
								<td width="80%" class="FieldValue" nowrap>
									<table  style="width: 380px">
										<colgroup>
											<col style="width: 50px;">
											<col style="width: 180px;">
											<col style="width: 50px;">
										</colgroup>
										<tr>
											<td><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%><!-- 日期 -->&nbsp;&nbsp;<input type="checkbox" onclick="selectAllMonthday(this)" /><%=SystemEnv.getHtmlLabelName(556,user.getLanguage())%><!-- 全选 --></td>
											<td><span id=daydiv ></span>
												<input type="hidden" name="dayval" id="dayval" onchange="checkinput('dayval','dayvalSpan0')" value="<%=days %>">
											</td>
											<td>
												<span id="dayvalSpan0">
													<%if(days.equals("")){%>
														<%=needInputImg %>
													<%} %>
												</span>
											</td>
										</tr>
									</table>
								</td>
							</tr>
						</table>
						</td>					
					</tr>
			 	</TBODY>
			</TABLE>
			</wea:item>
				</wea:group>
			</wea:layout>
			
			<div style="height: 40px;"></div>
		</FORM>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<script type="text/javascript">
if ((typeof Range !== "undefined") && !Range.prototype.createContextualFragment){
	Range.prototype.createContextualFragment = function(html){
		var frag = document.createDocumentFragment(),
		div = document.createElement("div");
		frag.appendChild(div);
		div.outerHTML = html;
		return frag;
	};
}
</script>

<script type="text/javascript">
jQuery(function($){
	$(".loading", window.parent.document).hide(); //隐藏加载图片
	if(jQuery("#receivertype").val()==1000){
		var sb = jQuery("#receiverfieldtype").attr("sb");
		$("#sbHolderSpan_"+sb).width(80);
		$("#sbSelector_"+sb).width(80);
		$("#sbOptions_"+sb).width(80);
	}
	$(".codeDelFlag").click(function(e){
		window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(23271,user.getLanguage())%>",function(){
			$("#remindcontentjava_span").html("");
			$("#remindcontentjava").val("");
			$(".codeDelFlag").hide();
		});
		e.stopPropagation(); 
	});
	var formtype = $("#formtype").val();
	if(formtype == 0){
       $("#descSpan").html("<%=SystemEnv.getHtmlLabelName(82229,user.getLanguage())%>");
    }else{
       $("#descSpan").html("<%=SystemEnv.getHtmlLabelName(83348,user.getLanguage())%>");
    }
	showLastLayoutTable();
	remindtypeChange();
	changeReceivertype();
	changeRemindway(true);
});

function showLastLayoutTable(){
	var table = $(".triggerTable");
	var intervalTR = $(".intervalTR[_samepair]");
	var triggerTr = $(intervalTR.get(intervalTR.length-1));
	var nextTr1 = triggerTr.next();
	var nextTr2 = nextTr1.next();
	triggerTr.addClass("triggerTR0");
	nextTr1.addClass("triggerTR0");
	nextTr2.addClass("triggerTR0");
	
}
function onchangeRemindTimeType2(obj){
	var remindTimeType2 = $(obj).val();
	if(remindTimeType2 == 0) {//时间字段
		$("#remindtimevaluediv").hide();
		$("#remindtimefielddiv").show();
	} else if(remindTimeType2 == 1){//时间常量
		$("#remindtimevaluediv").show();
		$("#remindtimefielddiv").hide();
	}
}
function changeRemindway(isFirst){
	var remindway = getCheckBoxVal("remindway");
	if(remindway==2){
		$("#senderTR").show();
		$("#emailTR").hide();
		$("#remindcontentURL_TR").hide();
		$("#senderText2").show();
		$("#senderText4").hide();
		$("#weixinspan").hide();
		changeSenderType();
	}else if(remindway==3){
		$("#senderTR").hide();
		$("#emailTR").show();
		$("#remindcontentURL_TR").hide();
		$("#emailText4").hide();
		$("#emailText3").show();
		$("#weixinspan").hide();
		changeSenderType();
	}else if(remindway==4){
		$("#senderTR").show();
		$("#emailTR").show();
		$("#remindcontentURL_TR").hide();
		$("#senderText2").hide();
		$("#senderText4").show();
		
		$("#emailText3").hide();
		$("#emailText4").show();
		$("#weixinspan").hide();
		changeSenderType();
	}else if(remindway==5){
		$("#emailTR").hide();
		$("#senderTR").hide();
		if(!isFirst&&$("#remindcontentURL").val()==""){
			$("#remindcontentURL").val("/mobilemode/formbasebrowserview.jsp?billid=$billid$&modeId=$modeId$&formId=$formId$");
		}
		$("#remindcontentURL_TR").show();
		$("#weixinspan").show();
	}else {
		$("#emailTR").hide();
		$("#senderTR").hide();
		$("#remindcontentURL_TR").hide();
		$("#weixinspan").hide();
	}
}

function changeSenderType(){
	var sendertype =  $("#sendertype").val();
	if(sendertype==3){
		$("#senderfieldSpan").show();
		$("#senderTextSpan").show();
	}else if(sendertype==4){
		$("#senderfieldSpan").hide();
		$("#senderTextSpan").hide();
	}else{
		$("#senderfieldSpan").hide();
		$("#senderTextSpan").hide();
	}
}

function getShowUrl(type){
	var formid = $("#formid").val();
	var formtype = $("#formtype").val();
	var url = "/formmode/setup/RemindFieldBrowser.jsp?formid="+formid+"&type="+type+"&formtype="+formtype;
	url = "/systeminfo/BrowserMain.jsp?url="+escape(url);
	return url;
}

function remindtypeChange(){
	var $ = jQuery;
	var remindtype = $("#remindtype");
	var formid = $("#formid").val();
	if(remindtype.val()==1){//即时提醒 
		$(".triggerTR0").hide();
		$(".triggerTR1").hide();
		$(".triggerTR2").hide();
		$(".triggerTR3").hide();
		$(".triggerTR4").hide();
		$(".triggerTR5").hide();
		$(".triggerTR6").hide();
		$(".remindtimeTR1").hide();
		$(".remindtimeTR2").hide();
		
	}else if(remindtype.val()==2){//到期提醒
		$(".triggerTR0").show();
		$(".triggerTR1").show();
		$(".triggerTR2").show();
		$(".remindtimeTR1").show();
		$(".remindtimeTR2").show();

		changeTriggerway();
	}else{//循环提醒		
		$(".triggerTR0").show();
		$(".triggerTR1").show();
		$(".triggerTR2").show();
		$(".remindtimeTR1").hide();
		$(".remindtimeTR2").hide();
		changeTriggerway();
	}
	if(formid != ""){
	    getModesByFormId(formid,0);
	}	
}

function changeTriggerway(){
	var triggerway = $("#triggerway").val();
	if(triggerway==2){
		$(".triggerTR2").hide();
		$(".triggerTR3").hide();
		$(".triggerTR4").show();
		$(".triggerTR5").hide();
		$(".triggerTR6").hide();
	}else{
		$(".triggerTR2").show();
		$(".triggerTR3").show();
		$(".triggerTR4").hide();
		var triggertype = jQuery("[name=triggertype]");
		for(var i=0;i<triggertype.length;i++){
			if(triggertype.get(i).checked){
				changeTriggertype(triggertype.get(i).value);
				break;
			}
		}
	}
}

function getOnShowConditionUrl(){
	<%if(id.equals("0")){%>
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(82239,user.getLanguage())%>");//请先保存，再设置条件！
		return false;
	<%}%>
	var formtype = $("#formtype").val();
	var url = escape("/formmode/setup/RemindJobcondition.jsp?isbill=1&formid=<%=formid%>&id=<%=id%>&formtype="+formtype);
	url = "/systeminfo/BrowserMain.jsp?url="+url
    return url;
}

function reloadWin(){
	window.location.href = window.location.href;
}

function formidChange(){
	var $ = jQuery;
	var formid = $("#formid").val();
	var formtype = $("#formtype").val();
	getModesByFormId(formid,1);
	changeSenderField(formid);
	changeFormType(formid);
	getHrmField(formid,formtype);
	checkCreater(formid);
}


function formTypeChange(){
	var $ = jQuery;
	var formid = $("#formid").val();
	var formtype = $("#formtype").val();
    getModesByFormId(formid,0);
    getHrmField(formid,formtype);
    if(formtype == 0){
       $("#descSpan").html("<%=SystemEnv.getHtmlLabelName(82229,user.getLanguage())%>");
    }else{
       $("#descSpan").html("<%=SystemEnv.getHtmlLabelName(83348,user.getLanguage())%>");
    }
}

function getHrmField(formid,formtype){
    var $ = jQuery;
	var remindtype = $("#remindtype").val();
	var formtype = $("#formtype").val();
	$.ajax({
	   type: "POST",
	   url: "/formmode/setup/RemindJobSettingsAction.jsp?operation=getHrmField",
	   data: "formid="+formid+"&formtype="+formtype,
	   dataType:"json",
	   success: function(data){	       
			changeSelectItemData('senderfield',data);
	   }
	});
}

function checkCreater(formid){
    $.ajax({
       type: "POST",
       url: "/formmode/setup/RemindJobSettingsAction.jsp?operation=checkCreater",
       data: "formid="+formid,
       dataType:"json",
       success: function(data){
            var sendertype = $("#sendertype");
            sendertype.selectbox("detach");//禁用
            sendertype.empty();
            var varItem = new Option("","");   
            sendertype.append(" <option value='1'><%=SystemEnv.getHtmlLabelName(16139,user.getLanguage())%><!-- 系统管理员 --></option>");
            if(data.haveCreater==true){
              sendertype.append(" <option value='2'> <%=SystemEnv.getHtmlLabelName(28597,user.getLanguage())%><!-- 模块创建人 --></option>");
            };
            sendertype.append(" <option value='3'><%=SystemEnv.getHtmlLabelName(82226,user.getLanguage())%><!-- 单人力--></option>");
            sendertype.selectbox("attach");//启用    
                
            var receivertype = $("#receivertype");
            receivertype.selectbox("detach");//禁用
            receivertype.empty();
            receivertype.append("<option value='1'><%=SystemEnv.getHtmlLabelName(1867,user.getLanguage())%></option> <!-- 人员 -->");
            receivertype.append("<option value='2'><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></option> <!-- 分部 -->");
            receivertype.append("<option value='3'><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></option> <!-- 部门 -->");
            receivertype.append("<option value='4'><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></option> <!-- 角色 -->");
            receivertype.append("<option value='5'><%=SystemEnv.getHtmlLabelName(1340,user.getLanguage())%></option> <!-- 所有人 -->");
            if(data.haveCreater==true){
              receivertype.append("<option value='6'><%=SystemEnv.getHtmlLabelName(28597,user.getLanguage())%></option> <!-- 模块创建人 -->");
            };
            receivertype.append("<option value='1000'><%=SystemEnv.getHtmlLabelName(28605,user.getLanguage())%></option> <!-- 模块主字段 -->");
            receivertype.selectbox("attach");//启用 
            changeReceivertype();   
       }
    });
}

function changeFormType(formid){
	var $ = jQuery;
	$.ajax({
	   type: "POST",
	   url: "/formmode/setup/RemindJobSettingsAction.jsp?operation=changeFormType",
	   data: "formid="+formid, 
	   dataType:"json",
	   success: function(data){
	       var formtype = $("#formtype");
		   formtype.selectbox("detach");//禁用
		   formtype.empty();
		   var varItem = new Option("","");   		
		   for(var i=0;i<data.length;i++){  
				if(data[i].detailtable == ""){
				   formtype.append("<option value='0'><%=SystemEnv.getHtmlLabelName(21778, user.getLanguage()) %></option>"); 
				}else{
				   formtype.append("<option value='"+data[i].detailtable+"'><%=SystemEnv.getHtmlLabelName(126218, user.getLanguage()) %>"+data[i].detailtable+"</option>"); 
				}
		   }
		   formtype.selectbox("attach");//启用 
	   }
	});
}

function changeSenderField(formid){
	var $ = jQuery;
	$.ajax({
	   type: "POST",
	   url: "/formmode/setup/RemindJobSettingsAction.jsp?operation=getHrmFieldByFormId",
	   data: "formid="+formid, 
	   dataType:"json",
	   success: function(data){
			var senderfield = $("#senderfield");
			senderfield.selectbox("detach");//禁用
			senderfield.empty();
			var varItem = new Option("","");   
			senderfield.append("<option value=''></option>");  
			for(var i=0;i<data.length;i++){
				senderfield.append("<option value='"+data[i].id+"'>"+data[i].labelname+"</option>"); 
			}
			senderfield.selectbox("attach");//启用
			changeSenderType();
	   }
	});
}

function getModesByFormId(formid,type){
	var $ = jQuery;
	var remindtype = $("#remindtype").val();
	var formtype = $("#formtype").val();
	$.ajax({
	   type: "POST",
	   url: "/formmode/setup/RemindJobSettingsAction.jsp?operation=getModesByFormId",
	   data: "formid="+formid+"&fmdetachable=<%=fmdetachable%>&subCompanyId=<%=subCompanyId%>&remindtype="+remindtype+"&formtype="+formtype,
	   dataType:"json",
	   success: function(data){
	        if(type == 1){
				changeSelectItemData('modeid',data.modedata);
				jQuery("#modeidSpan").html("<%=needInputImg%>");
			}
			changeSelectItemData('contentSelect',data.fielddata);
			changeSelectItemData('subjectSelect',data.fielddata);
	   }
	});
}

/**
 * 
 * @param {Object} selectid
 * @param {Object} dataArray  要求里面的obj对象的键为：value和text，分别对应select对象的value和text文本 
 */
function changeSelectItemData(selectid,dataArray){
	var $ = jQuery;
	var selectObj = $("#"+selectid);
	selectObj.selectbox("detach");//禁用
	selectObj.empty();
	var varItem = new Option("","");   
	selectObj.append("<option value=''></option>");  
	for(var i=0;i<dataArray.length;i++){
		selectObj.append("<option value='"+dataArray[i].value+"'>"+dataArray[i].text+"</option>"); 
	}
	selectObj.selectbox("attach");//启用
}

function varSelectChange(objid,targetid){
	var objvalue = $("#"+objid).val();
	if(objvalue==''){
		return;
	}
	var target = $("#"+targetid);
	target.val(target.val()+"$"+objvalue+"$");
	if('remindcontenttext' == targetid) {
		checkinput('remindcontenttext','remindcontenttextSpan');
	}
}

function changeSCT(cbObj){
	setTimeout(function(){	//checkbox用了插件，不延时checkbox的checked状态获取不准确
		var objV = cbObj.value;
		if(!cbObj.checked){
			changeCheckboxStatus(cbObj, true);
			return;
		}else{
			jQuery("input[type='checkbox'][name='"+cbObj.name+"']").each(function(){
				if(this.value != objV){
					changeCheckboxStatus(this, false);
				}
			});
		}
		
		jQuery("."+cbObj.name+"Span").hide();
		jQuery("#"+cbObj.name+"_"+objV).show();
	},100);
}

function changeIncrementtype(){
	var $ = jQuery;
	var incrementtype = $("#incrementtype").val();
	if(incrementtype==2){
		$("#incrementSpan1").hide();
		$("#incrementSpan2").show();
	}else{
		$("#incrementSpan1").show();
		$("#incrementSpan2").hide();
	}
	
}


function changeReceivertype(){
	var thisvalue=$GetEle("receivertype").value;
    var strAlert= ""
    $("span[id^='showspan']").css('display','none');
	if(thisvalue==1 || thisvalue==2 || thisvalue==3 || thisvalue==4 || thisvalue==1000){//需要浏览框
		$GetEle("browserTr").style.display = '';
		$GetEle("showspan"+thisvalue).style.display='';	//浏览框
	}else{
		$GetEle("browserTr").style.display = 'none';
		//$GetEle("showspan").style.display='none';	//不需要浏览框
	}
	if(thisvalue == 1||thisvalue == 6 || thisvalue==1001){//人员、创建人/Java不需要安全级别
		$GetEle("showlevel_tr").style.display='none';	//安全级别
	}else{
		$GetEle("showlevel_tr").style.display='';	//安全级别
	}
	if(thisvalue==1000){
		jQuery("#receiverfieldtypespan").show();
		var sb = jQuery("#receiverfieldtype").attr("sb");
		$("#sbHolderSpan_"+sb).width(80);
		$("#sbSelector_"+sb).width(80);
		$("#sbOptions_"+sb).width(80);
		if(jQuery("#receiverfieldtype").val()=='1'){
			jQuery("#showlevel_tr").hide();
		}else{
			jQuery("#showlevel_tr").show();
		}
	}else{
		jQuery("#receiverfieldtypespan").hide();
	}
}

function changeFieldType(obj){
	if(obj.value=='1'){
		jQuery("#showlevel_tr").hide();
	}else{
		jQuery("#showlevel_tr").show();
	}
	$GetEle("showspan").style.display='';	//浏览框
	$GetEle("relatedid").value="";
	$GetEle("showrelatedname").innerHTML="<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
}

function modefiledChange(){
    var tmpval = $GetEle("receiverfieldtype").value;
    var modeid = $("#modeid").val();
    if(modeid==""){
    	Dialog.alert("<%=SystemEnv.getHtmlLabelName(82240,user.getLanguage())%>");//请先选择模块！
    	return;
    }
    var formtype = $("#formtype").val();
	var tempurl1 = "/systeminfo/BrowserMain.jsp?url="+escape("/formmode/setup/MultiFormmodeShareFieldBrowser.jsp?type="+tmpval+"&selectedids=&modeId="+modeid+"&formtype="+formtype);
	return tempurl1;
}


function checkValues(ids,titles){
	var remindcontenttype =  getCheckBoxVal("remindcontenttype");
	for(var i=0;i<ids.length;i++){
		var id = ids[i];
		var title = titles[i];
		if(remindcontenttype==2&&id=="remindcontenttext"){//勾选的是Java，循环文本id，文本内容不检查
             continue;
		}
		if($("#"+id).val()==""){
			Dialog.alert("["+title+"] <%=SystemEnv.getHtmlLabelName(82241,user.getLanguage())%>");//不能为空！
			return false;
		}
	}
	return true;
}

function checkIsSameTable(event,datas,name,_callbackParams){
	var img = "<img align='absMiddle' src='/images/BacoError_wev8.gif'>";
	var remindtimetype2 = $("#remindtimetype2").val();
	if(remindtimetype2==1){//时间常量
		$("#remindtimefield").val("");
	    $("#remindtimefieldspanimg").html(img);
	    $("#remindtimefieldspan").html("");
		return;
	}
    var reminddatefield = $("#reminddatefield").val();
    var remindtimefield = $("#remindtimefield").val();
    if(reminddatefield != "" && remindtimefield != ""){
    var url = "/formmode/setup/Remindchecktable.jsp";
        $.post(
	        url,
	        {reminddatefield:reminddatefield,remindtimefield:remindtimefield},
	        function(data){
	        	var d = eval("("+data+")");
	        	if(d.flag == "false"){
	        	    Dialog.alert("<%=SystemEnv.getHtmlLabelName(126217,user.getLanguage())%>");//日期字段和时间字段必须是同一张表！
	        	    $("#"+name).val("");
	        	    $("#"+name+"spanimg").html(img);
	        	    $("a[href=#"+datas.id+"]").html("");
	        	}
	    })
    }
}

function submitData(){
	var ids = ["name"];
	var titles = ["<%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%>"];//名称
	ids.push("formid");
	titles.push("<%=SystemEnv.getHtmlLabelName(15451,user.getLanguage())%>");//表单名称
	ids.push("modeid");
	titles.push("<%=SystemEnv.getHtmlLabelName(28485,user.getLanguage())%>");//模块名称
	if($("#remindtype").val()==2){
		var remindtimetype = getCheckBoxVal("remindtimetype");
		if(remindtimetype==1){
			ids.push("reminddate");
			titles.push("<%=SystemEnv.getHtmlLabelName(82242,user.getLanguage())%>");//到期日期
			ids.push("remindtime");
			titles.push("<%=SystemEnv.getHtmlLabelName(82215,user.getLanguage())%>");//到期时间
		}else if(remindtimetype==2){
			ids.push("reminddatefield");
			titles.push("<%=SystemEnv.getHtmlLabelName(82243,user.getLanguage())%>");//到期日期字段
			var remindtimetype2 = $("#remindtimetype2").val();
			if(remindtimetype2==0){
				ids.push("remindtimefield");
				titles.push("<%=SystemEnv.getHtmlLabelName(82244,user.getLanguage())%>");//到期时间字段
			} else if (remindtimetype2==1){
				ids.push("remindtimevalue");
				titles.push("<%=SystemEnv.getHtmlLabelName(126407,user.getLanguage())%>");//到期时间常量
			}
		}
	}
	var remindway = getCheckBoxVal("remindway");
	if(remindway==2){
		var sendertype = $("#sendertype").val();
		if(sendertype==3){
			ids.push("senderfield");
			titles.push("<%=SystemEnv.getHtmlLabelName(82245,user.getLanguage())%>");//短信发送人字段
		}
	}else if(remindway==3){
		ids.push("subject");
		titles.push("<%=SystemEnv.getHtmlLabelName(82223,user.getLanguage())%>");//邮件标题
	}else if(remindway==4){
		var sendertype = $("#sendertype").val();
		if(sendertype==3){
			ids.push("senderfield");
			titles.push("<%=SystemEnv.getHtmlLabelName(28595,user.getLanguage())+SystemEnv.getHtmlLabelName(83842,user.getLanguage())%>");//流程创建人字段
		}
		ids.push("subject");
		titles.push("<%=SystemEnv.getHtmlLabelName(26876,user.getLanguage())%>");//流程标题
	}
	var remindcontenttype =  getCheckBoxVal("remindcontenttype");
	if(remindcontenttype==1){
		ids.push("remindcontenttext");
		titles.push("<%=SystemEnv.getHtmlLabelName(27415,user.getLanguage())%>");//提醒内容
	}else{
		//ids.push("remindcontentjava");
		ids.push("remindcontentaddress");
		titles.push("<%=SystemEnv.getHtmlLabelName(27415,user.getLanguage())%>");//提醒内容
	}
	ids.push("remindcontenttext");
	titles.push("<%=SystemEnv.getHtmlLabelName(27415,user.getLanguage())%>");//提醒内容
	var receivertype = jQuery("#receivertype").val();
	if(receivertype==1){
		ids.push("relatedid1");
		titles.push("<%=SystemEnv.getHtmlLabelName(82246,user.getLanguage())%>");//人员选择
	}else if(receivertype==2){
		ids.push("relatedid2");
		titles.push("<%=SystemEnv.getHtmlLabelName(82247,user.getLanguage())%>");//分部选择
	}else if(receivertype==3){
		ids.push("relatedid3");
		titles.push("<%=SystemEnv.getHtmlLabelName(82248,user.getLanguage())%>");//部门选择
	}else if(receivertype==4){
		ids.push("relatedid4");
		titles.push("<%=SystemEnv.getHtmlLabelName(82249,user.getLanguage())%>");//角色选择
	}else if(receivertype==1000){
		ids.push("relatedid1000");
		titles.push("<%=SystemEnv.getHtmlLabelName(81438,user.getLanguage())%>");//模块主字段
	}
	if($("#remindtype").val()==2||$("#remindtype").val()==3){
		var triggerway = jQuery("#triggerway").val();
		if(triggerway==1){
			var triggertype = getCheckBoxVal("triggertype");
			if(triggertype<=3){
				ids.push("triggercycletime");
				titles.push("<%=SystemEnv.getHtmlLabelName(82235,user.getLanguage())%>");//定时器循环周期
			}else if(triggertype==4){
				ids.push("weeks");
				titles.push("<%=SystemEnv.getHtmlLabelName(82237,user.getLanguage())%>");//星期选择
			}else if(triggertype==5){
				ids.push("months");
				titles.push("<%=SystemEnv.getHtmlLabelName(887,user.getLanguage())%>");//月份
				ids.push("days");
				titles.push("<%=SystemEnv.getHtmlLabelName(82250,user.getLanguage())%>");//月份日期
			}
		}else if(triggerway==2){
			ids.push("triggerexpression");
			titles.push("<%=SystemEnv.getHtmlLabelName(82251,user.getLanguage())%>");//定时器表达式 
		}
	}
	jQuery("#weekval").val(week.getValue());
	jQuery("#monthval").val(month.getValue());
	jQuery("#dayval").val(monthday.getValue());
	
	var remindcontentaddress =$("#remindcontentaddress").val();
    var checkAddress=true;
    if(remindcontentaddress!=""){
       var url = "/formmode/setup/codeEditAction.jsp?action=checkFileAddress&javafileAddress="+remindcontentaddress;
       $.ajax({
        url: url,
        data: "", 
        dataType: 'json',
        type: 'POST',
        async : false,
        success: function (result) {
           var status = result.status;
           if("0"==status){
             alert("<%=SystemEnv.getHtmlLabelName(382919, user.getLanguage())%>");
             checkAddress=false;
            }
        }
       });
    }
	if(checkValues(ids,titles)&&checkAddress){
		if("<%=oldJavaFileName%>"!=""&&remindcontentaddress=="<%=oldJavaFileName%>"){
	       $("#remindcontentaddress").val("");
	    }else{
	       $("#remindcontentjava").val("");
	    }
		$("#operation").val("saveorupdate");
        enableAllmenu();
        frmMain.submit();
	}
}

function getCheckBoxVal(name){
	var boxs = jQuery("input[name="+name+"]");
	for(var i=0;i<boxs.length;i++){
		if(jQuery(boxs[i]).attr("checked")==true){
			return jQuery(boxs[i]).val();
		}
	}
}
function changeBoxVal(obj){
	if(obj.checked){
		obj.value = 1;
	}else{
		obj.value = 0;
	}
}

var utilTextArr = ["<%=SystemEnv.getHtmlLabelName(15049,user.getLanguage())%>","<%=SystemEnv.getHtmlLabelName(391,user.getLanguage())%>","<%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%>","<%=SystemEnv.getHtmlLabelName(1926,user.getLanguage())%>","<%=SystemEnv.getHtmlLabelName(6076,user.getLanguage())%>"];//分钟,小时,天,周,月
function changeTriggertype(type){
	if(type<=3){
		$("#triggercycletimeSpan0").html(utilTextArr[type-1]);
		if(type==0){
			$(".triggerTR3").hide();
		}else{
			$(".triggerTR3").show();
		}
		$(".triggerTR5").hide();
		$(".triggerTR6").hide();
	}else if(type==4){
		$(".triggerTR3").hide();
		$(".triggerTR5").show();
		$(".triggerTR6").hide();
	}else if(type==5){
		$(".triggerTR3").hide();
		$(".triggerTR5").hide();
		$(".triggerTR6").show();
	}else{
		$(".triggerTR3").hide();
		$(".triggerTR5").hide();
		$(".triggerTR6").hide();
	}
}
var diag_vote;
function toformtab(formid,isvirtualform){
		diag_vote = new window.top.Dialog();
		diag_vote.currentWindow = window;	
		var parm = "&formid="+formid;
		if(formid=='') {
			parm = '';
			diag_vote.Title = "<%=SystemEnv.getHtmlLabelName(82021,user.getLanguage())%>";//新建表单
		}else{
			diag_vote.Title = "<%=SystemEnv.getHtmlLabelName(82022,user.getLanguage())%>";//编辑表单
		}
		diag_vote.Width = 1000;
		diag_vote.Height = 600;
		diag_vote.Modal = true;
		
		diag_vote.URL = "/workflow/form/addDefineForm.jsp?dialog=1&isFromMode=1"+parm;
		diag_vote.isIframe=false;
		diag_vote.show();
}

function onDelete(){
	window.top.Dialog.confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>",function(){
		enableAllmenu();
		document.frmMain.operation.value="delete";
		document.frmMain.submit();
	});
}


function checkSelect(objid,objspanid){
	var img = "<img align='absMiddle' src='/images/BacoError_wev8.gif'>";
	var modeid= jQuery("#"+objid).val();
	var modeidSpan = jQuery("#"+objspanid);
	if(modeid!=""){
		modeidSpan.html("");
	}else{
		modeidSpan.html(img);
	}
}

function initRemindData(){
	if(confirm("<%=SystemEnv.getHtmlLabelName(82252,user.getLanguage())%>")){//确定要初始化到期提醒数据？
		$(".loading", window.parent.document).show();
		$.ajax({
		   type: "POST",
		   url: "/formmode/setup/RemindJobSettingsAction.jsp",
		   data: "operation=initRemindData&id=<%=id%>",
		   success: function(msg){
		     setTimeout(function(){
		    	 $(".loading", window.parent.document).hide();
		     },800);
		   }
		});
	}
}

//修改 
var dialog;
function onShowSql(){
    $("#rightMenu").css("visibility","hidden");
    dialog = new window.top.Dialog();
    dialog.currentWindow = window;
    dialog.Width = 600 ;
    dialog.Height = 165;
    dialog.normalDialog = false;
    var url = "/formmode/setup/RemindJobSql.jsp?id=<%=id%>&dialogid="+dialog.ID;
    dialog.callbackfun = function (paramobj, id1) {
        
    };
    dialog.URL = url;
    dialog.Title = "<%=SystemEnv.getHtmlLabelName(383217,user.getLanguage())%>";//
    //dialog.Drag = false;
    dialog.show();
}



function openCodeEdit(){
	top.openCodeEdit({
		"type" : "7",
		"filename" : $("#remindcontentjava").val()
	}, function(result){
		if(result){
			var fName = result["fileName"];
			$("#remindcontentjava_span").html(fName);
			$("#remindcontentjava").val(fName);
			$(".codeDelFlag").show();
		}
	});
}



//------------------------------
		Ext.BLANK_IMAGE_URL = '/formmode/js/ext/resources/images/default/s_wev8.gif';
		
		Ext.override(Ext.ux.form.LovCombo, {
			beforeBlur: Ext.emptyFn
		});
		var week; 
		var month;
		var monthday;
		var trigtype = '';
		Ext.onReady(function() {
			week = new Ext.ux.form.LovCombo({
				 id:'weeks'
				,renderTo:'weekdiv'
				,width:200
				,editable:false
				,hideOnSelect:false
				,maxHeight:200
				,store:[
					 [0, '<%=SystemEnv.getHtmlLabelName(398,user.getLanguage())%>']//星期日
					,[1, '<%=SystemEnv.getHtmlLabelName(392,user.getLanguage())%>']//星期一
					,[2, '<%=SystemEnv.getHtmlLabelName(393,user.getLanguage())%>']//星期二
					,[3, '<%=SystemEnv.getHtmlLabelName(394,user.getLanguage())%>']//星期三
					,[4, '<%=SystemEnv.getHtmlLabelName(395,user.getLanguage())%>']//星期四
					,[5, '<%=SystemEnv.getHtmlLabelName(396,user.getLanguage())%>']//星期五
					,[6, '<%=SystemEnv.getHtmlLabelName(397,user.getLanguage())%>']//星期六
				]
				,triggerAction:'all'
				,mode:'local'
			});
			<%if(!weeks.equals("")){%>
				week.setValue('<%=weeks%>');
			<%}%>
			changeSpanImg('<%=weeks%>',"weekvalSpan");
			
			week.beforeBlur = function(){
				changeSpanImg(week.getValue(),"weekvalSpan");
			}
			
			month = new Ext.ux.form.LovCombo({
				 id:'months'
				,renderTo:'monthdiv'
				,width:200
				,hideOnSelect:false
				,editable:false
				,maxHeight:200
				,store:[
					 [1, '<%=SystemEnv.getHtmlLabelName(1492,user.getLanguage())%>']//一月
					,[2, '<%=SystemEnv.getHtmlLabelName(1493,user.getLanguage())%>']//二月
					,[3, '<%=SystemEnv.getHtmlLabelName(1494,user.getLanguage())%>']//三月
					,[4, '<%=SystemEnv.getHtmlLabelName(1495,user.getLanguage())%>']//四月
					,[5, '<%=SystemEnv.getHtmlLabelName(1496,user.getLanguage())%>']//五月
					,[6, '<%=SystemEnv.getHtmlLabelName(1497,user.getLanguage())%>']//六月
					,[7, '<%=SystemEnv.getHtmlLabelName(1498,user.getLanguage())%>']//七月
					,[8, '<%=SystemEnv.getHtmlLabelName(1499,user.getLanguage())%>']//八月
					,[9, '<%=SystemEnv.getHtmlLabelName(1800,user.getLanguage())%>']//九月
					,[10, '<%=SystemEnv.getHtmlLabelName(1801,user.getLanguage())%>']//十月
					,[11, '<%=SystemEnv.getHtmlLabelName(1802,user.getLanguage())%>']//十一月
					,[12, '<%=SystemEnv.getHtmlLabelName(1803,user.getLanguage())%>']//十二月
				]
				,triggerAction:'all'
				,mode:'local'
			});
			<%if(!months.equals("")){%>
				month.setValue('<%=months%>');
			<%}%>
			changeSpanImg('<%=months%>',"monthvalSpan0");
			month.beforeBlur = function(){
				changeSpanImg(month.getValue(),"monthvalSpan0");
			}
			
			monthday = new Ext.ux.form.LovCombo({
				 id:'days'
				,renderTo:'daydiv'
				,width:200
				,editable:false
				,hideOnSelect:false
				,maxHeight:200
				,store:[
					 [1,'1'],[2,'2'],[3,'3'],[4,'4'],[5,'5'],[6,'6'],[7,'7'],[8,'8'],[9,'9']
					,[10,'10'],[11,'11'],[12,'12'],[13,'13'],[14,'14'],[15,'15'],[16,'16'],[17,'17']
					,[18,'18'],[19,'19'],[20,'20'],[21,'21'],[22,'22'],[23,'23'],[24,'24'],[25,'25']
					,[26,'26'],[27,'27'],[28,'28'],[29,'29'],[30,'30'],[31,'31']
				]
				,triggerAction:'all'
				,mode:'local'
			});
			<%if(!days.equals("")){%>
				monthday.setValue('<%=days%>');
			<%}%>
			changeSpanImg('<%=days%>',"dayvalSpan0");
			monthday.beforeBlur = function(){
				changeSpanImg(monthday.getValue(),"dayvalSpan0");
			}
		});
				
		function changeSpanImg(value,spanid){
			if(value==""){
				$("#"+spanid).html("<%=needInputImg%>");
			}else{
				$("#"+spanid).html("");
			}
		}
				
		function selectAllWeek(obj) {
			if(obj.checked) {
				week.setValue('0,1,2,3,4,5,6');
				changeSpanImg('0,1,2,3,4,5,6',"weekvalSpan");
			} else {
				week.setValue('');
				changeSpanImg('',"weekvalSpan");
			}
		}
		
		function selectAllMonth(obj) {
			if(obj.checked) {
				month.setValue('1,2,3,4,5,6,7,8,9,10,11,12');
				changeSpanImg('1,2,3,4,5,6,7,8,9,10,11,12',"monthvalSpan0");
			} else {
				month.setValue('');
				changeSpanImg('',"monthvalSpan0");
			}
		}
		
		function selectAllMonthday(obj) {
			if(obj.checked) {
				monthday.setValue('1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22.23,24,25,26,27,28,29,30,31');
				changeSpanImg('1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22.23,24,25,26,27,28,29,30,31',"dayvalSpan0");
			} else {
				monthday.setValue('');
				changeSpanImg('',"dayvalSpan0");
			}
		}
		
		function insert(id,content) {
			document.getElementById(id).innerHTML=content;
			show(id);
		}
		
		function doAdd(){
			parent.location.href = "/formmode/setup/RemindJobInfo.jsp?appid=<%=appid%>";
		}
		//浏览框链接 JS函数  zwbo
		function toformtabFormChoosed(data){
			var dataArr=data.split("_");
			var formid=dataArr[0];
			var isvirtualform=dataArr[1];
			toformtab(formid,isvirtualform);
		}
		function downloadMode(){
          top.location='/weaver/weaver.formmode.data.FileDownload?type=7';
        }
</script>
<style>
.Selected td.e8Selected input.inputStyle, .Selected td.e8Selected input.inputstyle, .Selected td.e8Selected input[type="text"], .Selected td.e8Selected input[type="password"], .Selected td.e8Selected input.Inputstyle, .Selected td.e8Selected input.InputStyle, .Selected td.e8Selected input.inputStyle, .Selected td.e8Selected .e8_innerShowContent, .Selected td.e8Selected textarea, .Selected td.e8Selected .sbHolder {
     border: 1px solid #e9e9e2;
}

.Selected td.e8Selected .e8_outScroll {
     border: 0px solid #e9e9e2;
}

.Selected td.e8Selected input.inputStyle, .Selected td.e8Selected input.inputstyle, .Selected td.e8Selected input[type="text"], .Selected td.e8Selected input[type="password"], .Selected td.e8Selected input.Inputstyle, .Selected td.e8Selected input.InputStyle, .Selected td.e8Selected input.inputStyle, .Selected td.e8Selected .e8_os, .Selected td.e8Selected textarea, .Selected td.e8Selected .sbHolder {
    border: 1px solid #e9e9e2;
}
a:hover{color:#0072C6 !important;}
.e8_data_virtualform{
    background: url(/formmode/images/circleBgGold_wev8.png) no-repeat 1px 1px;
    width: 16px;
    display:inline;
    color: #fff;
    font-size: 9px;
    font-style: italic;
    top: 5px;
    padding-left: 3px;
    padding-right: 6px;
    padding-top: 2px;
/*  padding-bottom: 4px; */
}

</style>
</style>

</BODY></HTML>
