<%@page import="weaver.cpt.util.html.HtmlUtil"%>
<%@page import="weaver.cpt.util.html.HtmlElement"%>
<%@page import="java.util.Map.Entry"%>
<%@page import="org.json.JSONObject"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>

<%@page import="java.text.DecimalFormat"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.docs.docs.CustomFieldManager"%>
<jsp:useBean id="ProjTempletUtil" class="weaver.proj.Templet.ProjTempletUtil" scope="page" />
<jsp:useBean id="RecordSetFF" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet_cus" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetRight" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page" />
<jsp:useBean id="ProjectStatusComInfo" class="weaver.proj.Maint.ProjectStatusComInfo" scope="page" />
<jsp:useBean id="ProjectTypeComInfo" class="weaver.proj.Maint.ProjectTypeComInfo" scope="page" />
<jsp:useBean id="WorkTypeComInfo" class="weaver.proj.Maint.WorkTypeComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="AllManagers" class="weaver.hrm.resource.AllManagers" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="ContractComInfo" class="weaver.crm.Maint.ContractComInfo" scope="page"/>

<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page"/>
<jsp:useBean id="DocImageManager" class="weaver.docs.docs.DocImageManager" scope="page" />

<jsp:useBean id="CptFieldComInfo" class="weaver.proj.util.PrjFieldComInfo" scope="page"/>
<jsp:useBean id="CptFieldManager" class="weaver.proj.util.PrjFieldManager" scope="page"/>
<jsp:useBean id="PrjSettingsComInfo" class="weaver.proj.util.PrjSettingsComInfo" scope="page"/>
<jsp:useBean id="ProjectTransUtil" class="weaver.proj.util.ProjectTransUtil" scope="page"/>
<jsp:useBean id="CodeUtil" class="weaver.proj.util.CodeUtil" scope="page"/>
<%
String isclose = Util.null2String(request.getParameter("isclose"));
String isDialog = Util.null2String(request.getParameter("isdialog"));
String querystr=request.getQueryString();
weaver.system.CusFormSettingComInfo CusFormSettingComInfo = new weaver.system.CusFormSettingComInfo();
weaver.system.CusFormSetting CusFormSetting= CusFormSettingComInfo.getCusFormSetting("prj","PrjCardEdit");
if(CusFormSetting!=null&&CusFormSetting.getStatus()==2){//自定义布局页面
	//request.getRequestDispatcher("/proj/data/EditProject_l.jsp").forward(request, response);
	response.sendRedirect("/proj/data/EditProject_l.jsp"+"?"+querystr);
	return;
}
%>
<%
DecimalFormat df=new DecimalFormat("##0.00");
String ProjID = Util.null2String(request.getParameter("ProjID"));
String from = Util.null2String(request.getParameter("from"));

/*合同*/
String contractids_prj="";
String sql_conids="select id from CRM_Contract where projid ="+ProjID;
RecordSet.executeSql(sql_conids);
while(RecordSet.next()){
    contractids_prj += ","+ RecordSet.getString("id");
}
if(!contractids_prj.equals("")) contractids_prj =contractids_prj.substring(1);

String connames="";
if(!contractids_prj.equals("")){
    ArrayList conids_muti = Util.TokenizerString(contractids_prj,",");
    int connum = conids_muti.size();
    for(int i=0;i<connum;i++){
        connames= connames+"<a href=/CRM/data/ContractView.jsp?id="+conids_muti.get(i)+">"+Util.toScreen(ContractComInfo.getContractname(""+conids_muti.get(i)),user.getLanguage())+"</a>" +" ";               
    }
} 



/*项目状态*/
String sql_tatus="select isactived from Prj_TaskProcess where prjid="+ProjID;
RecordSet.executeSql(sql_tatus);
RecordSet.next();
String isactived=RecordSet.getString("isactived");
//isactived=0,为计划
//isactived=1,为提交计划
//isactived=2,为批准计划

String sql_prjstatus="select status,accessory from Prj_ProjectInfo where id = "+ProjID;
RecordSet.executeSql(sql_prjstatus);
RecordSet.next();
String status_prj=RecordSet.getString("status");
String project_accessory = Util.null2String(RecordSet.getString("accessory"));//相关附件
if(isactived.equals("2")&&(status_prj.equals("3")||status_prj.equals("4"))){//项目冻结或者项目完成
	response.sendRedirect("ViewProject.jsp?ProjID="+ProjID);
}
//status_prj=5&&isactived=2,立项批准
//status_prj=1,正常
//status_prj=2,延期
//status_prj=3,终止
//status_prj=4,冻结

/*查看项目成员*/
String sql_mem="select members from Prj_ProjectInfo where id= "+ProjID ;
RecordSet.executeSql(sql_mem);
RecordSet.next();
String Members=RecordSet.getString("members");
String Memname="";
ArrayList Members_proj = Util.TokenizerString(Members,",");
int Membernum = Members_proj.size();

for(int i=0;i<Membernum;i++){
    Memname= Memname+"<a href=\"/hrm/resource/HrmResource.jsp?id="+Members_proj.get(i)+"\">"+Util.toScreen(ResourceComInfo.getResourcename(""+Members_proj.get(i)),user.getLanguage())+"</a>";
    Memname+=" ";
}

   
String needinputitems = "";
boolean hasFF = true;
RecordSetFF.executeProc("Base_FreeField_Select","p1");
if(RecordSetFF.getCounts()<=0)
	hasFF = false;
else
	RecordSetFF.first();

RecordSet.executeProc("PRJ_Find_LastModifier",ProjID);
RecordSet.first();
String Modifier = Util.toScreen(RecordSet.getString(1),user.getLanguage());
String ModifyDate = RecordSet.getString(2);

RecordSet.executeProc("Prj_ProjectInfo_SelectByID",ProjID);
if(RecordSet.getCounts()<=0)
	response.sendRedirect("/proj/DBError.jsp?type=FindData");
RecordSet.first();
String newStrXml = RecordSet.getString("relationXml");
/*权限－begin*/
String Creater = Util.toScreen(RecordSet.getString("creater"),user.getLanguage());
String CreateDate = RecordSet.getString("createdate");
String manager = RecordSet.getString("manager");
String department = RecordSet.getString("department");
String projTypeId=RecordSet.getString("prjtype");
String useridcheck=""+user.getUID();

boolean canview=false;
boolean canedit=false;
boolean ismanager=false;
boolean ismanagers=false;
boolean ismember=false;
boolean isrole=false;
 if(HrmUserVarify.checkUserRight("ViewProject:View",user,department) || HrmUserVarify.checkUserRight("EditProject:Edit",user,department)) {
	 canview=true;
	 canedit=true;
	 isrole=true;
 }
 if(useridcheck.equals(Creater)){
	 canview=true;
	 canedit=true;
 }
  if(useridcheck.equals(manager)){
	 canview=true;
	 canedit=true;
	 ismanager=true;
 }
AllManagers.getAll(manager);
while(AllManagers.next()){
	String tempmanagerid = AllManagers.getManagerID();
	if (tempmanagerid.equals(""+user.getUID())) {
		canview=true;
		canedit=true;
		ismanagers=true;
	}
}
if (from.equals("viewProject")) {
	canedit=true;
}
if(!canedit){
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
/*权限－end*/


String isManagerFromView = Util.null2String(request.getParameter("isManager"));
String bbStyle="" ; // Browser button style.
String inputDisabled=""; //input disabled
String editable="yes";
if ("false".equals(isManagerFromView)){
    bbStyle="style='display:none'";
    inputDisabled = "readonly";
    editable="no";
}
%>
<%
String chkFields="";
String nameQuery=Util.null2String(request.getParameter("flowTitle"));
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<link href="/js/swfupload/default_wev8.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="/js/swfupload/swfupload_wev8.js"></script>
<script type="text/javascript" src="/js/swfupload/swfupload.queue_wev8.js"></script>
<script type="text/javascript" src="/js/swfupload/fileprogress_wev8.js"></script>
<script type="text/javascript" src="/js/swfupload/handlers_wev8.js"></script>

<SCRIPT language="javascript"  type='text/javascript' src="/js/weaver_wev8.js"></SCRIPT>
<SCRIPT language="javascript"  type='text/javascript' src="/js/ArrayList_wev8.js"></SCRIPT>
<SCRIPT language="javascript"  type='text/javascript' src="/js/projTask/TaskUtil_wev8.js"></SCRIPT>
<SCRIPT language="javascript"  type='text/javascript' src="/js/projTask/ProjTaskUtil_wev8.js"></SCRIPT>
<SCRIPT language="javascript"  type='text/javascript' src="/js/projTask/TaskDrag_wev8.js"></SCRIPT>
<SCRIPT language="javascript"  type='text/javascript' src="/js/projTask/ProjTask_wev8.js"></SCRIPT>  
<SCRIPT language="javascript"  type='text/vbScript' src="/js/projTask/ProjTask.vbs"></SCRIPT> 
<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>
<script type="text/javascript" src="/wui/common/js/ckeditor/ckeditor_wev8.js"></script>
<script type="text/javascript" src="/wui/common/js/ckeditor/ckeditorext_wev8.js"></script>
<script type="text/javascript">
var parentWin;
if("<%=isDialog %>"=="1"){
	parentWin = parent.parent.getParentWindow(parent.window);
	var parentDialog = parent.parent.getDialog(parent);
}
if("<%=isclose%>"=="1"){
	parentWin.onBtnSearchClick();
	parentWin.closeDialog();	
}
</script>


<script type="text/javascript">
var oUpload;
</script>

<style type="text/css">
.InputStyle{width:30%!important;}
.inputstyle{width:30%!important;}
.Inputstyle{width:30%!important;}
.inputStyle{width:30%!important;}
.e8_os{width:30%!important;}
select.InputStyle{width:10%!important;} 
select.inputstyle{width:10%!important;} 
select.inputStyle{width:10%!important;} 
select.Inputstyle{width:10%!important;} 
textarea.InputStyle{width:70%!important;} 
</style>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(610,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+" - "+Util.toScreen(RecordSet.getString("name"),user.getLanguage());
titlename += " <B>" + SystemEnv.getHtmlLabelName(401,user.getLanguage()) + ":</B>"+CreateDate ;
titlename += " <B>" + SystemEnv.getHtmlLabelName(623,user.getLanguage()) + ":</B>";
if(user.getLogintype().equals("1")) 
	titlename += " <A href=/hrm/resource/HrmResource.jsp?id=" + Creater + ">" + Util.toScreen(ResourceComInfo.getResourcename(Creater),user.getLanguage()) + "</a>";
titlename += " <B>" + SystemEnv.getHtmlLabelName(103,user.getLanguage()) + ":</B>"+ModifyDate ;
titlename += " <B>" + SystemEnv.getHtmlLabelName(623,user.getLanguage()) + ":</B>";
if(user.getLogintype().equals("1")) 
	titlename += " <A href=/hrm/resource/HrmResource.jsp?id=" + Modifier + ">" + Util.toScreen(ResourceComInfo.getResourcename(Modifier),user.getLanguage()) + "</a>";

String needfav ="1";
String needhelp ="";
%>
<BODY id="myBody" onbeforeunload="protectProj(event)">
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%
    RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(this),_self}";
    RCMenuHeight += RCMenuHeightStep;

    if(!"1".equals(isDialog)){
    	RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:goBack(),_self}";
        RCMenuHeight += RCMenuHeightStep;
    }
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<FORM id=frmain action="/proj/data/ProjectOperation.jsp" method=post enctype="multipart/form-data">
<input <%=inputDisabled%> type="hidden" name="method" value="edit">
<input <%=inputDisabled%> type="hidden" name="ProjID" value="<%=ProjID%>">
<input type ="hidden" name="isManagerFromView" value="<%=isManagerFromView%>">
<input type="hidden" name="accdocids" id="accdocids" value="">

<input  class=inputstyle maxLength=3 size=3 name="SecuLevel" type=hidden value="<%=Util.toScreenToEdit(RecordSet.getString("securelevel"),user.getLanguage())%>">
<input  type="hidden" name="status" value="<%=RecordSet.getString("status")%>"/>

<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
		<%
		if(canedit){
			%>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%> " class="e8_btn_top" onclick="submitData(this)"/>
			<%
		}
		%>
			<span id="advancedSearch" class="advancedSearch" style="display:none;"><%=SystemEnv.getHtmlLabelNames("347",user.getLanguage())%></span>
			<span title="<%=SystemEnv.getHtmlLabelNames("23036",user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>

<wea:layout attributes="{'expandAllGroup':'true'}">
	<!-- baseinfo -->
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></wea:item>
		<wea:item><input <%=inputDisabled%> class=inputstyle maxLength=50 size=50 name="name" onblur="checkLength()" onchange='checkinput("name","PrjNameimage")' value='<%=Util.toScreenToEdit(RecordSet.getString("name"),user.getLanguage())%>'><SPAN id=PrjNameimage></SPAN><span id="remind" style="cursor:hand" title='<%=SystemEnv.getHtmlLabelName(20246,user.getLanguage())%>50(<%=SystemEnv.getHtmlLabelName(20247,user.getLanguage())%>)'><img src="/images/remind_wev8.png" align="absmiddle"  /></span></wea:item>
<%
String isuse=CodeUtil.getPrjCodeUse();
if(!"0".equals(isuse)){
	%>
		<wea:item><%=SystemEnv.getHtmlLabelName(17852,user.getLanguage())%></wea:item>
		<wea:item><input type="text" class=inputstyle style="width:200px!important;" maxLength=50 size=30 name="procode" <%="1".equals(isuse)?"readonly='readonly' ":"" %> value='<%=RecordSet.getString("procode")%>'></wea:item>
	<%
}
%>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(586,user.getLanguage())%></wea:item>
		<wea:item>
			<input type="hidden" name="prjtype" value="<%=""+projTypeId%>" />
			<%=ProjectTypeComInfo.getProjectTypename(""+projTypeId)%>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(18375,user.getLanguage())%></wea:item>
		<wea:item>
			<%
                String templetId = RecordSet.getString("proTemplateId");
                if (!"".equals(templetId)) {
                    rs.executeSql("select templetName from Prj_Template where id="+templetId);
                    if (rs.next()){
                        out.println(rs.getString(1));
                    }
                }            
            %>
             <input  id="protemplateid" type="hidden" name="protemplateid" value="<%=templetId%>">
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(432,user.getLanguage())%></wea:item>
		<wea:item>
			<%
                String tempWorkType = Util.null2String(RecordSet.getString("worktype"));
                if (Util.getIntValue(tempWorkType)<1) tempWorkType="";
              %>
			<brow:browser viewType="0" name="worktype" browserValue='<%=tempWorkType%>' browserSpanValue='<%=WorkTypeComInfo.getWorkTypename(tempWorkType)%>' 
				browserUrl="/systeminfo/BrowserMain.jsp?url=/proj/Maint/WorkTypeBrowser.jsp"
				hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
				completeUrl="/data.jsp?type=245"  />
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(783,user.getLanguage())%></wea:item>
		<wea:item>
			<%
          	String PrjDescspan="";
          	if(!RecordSet.getString("description").equals("")){
				ArrayList arraycrmids = Util.TokenizerString(RecordSet.getString("description"),",");
				for(int i=0;i<arraycrmids.size();i++){
					PrjDescspan+=("<A href='/CRM/data/ViewCustomer.jsp?CustomerID="+arraycrmids.get(i)+"'>"
							+CustomerInfoComInfo.getCustomerInfoname(""+arraycrmids.get(i))+"</a>&nbsp");
				}
			}
			%>	
			<brow:browser viewType="0" name="description" browserValue='<%=RecordSet.getString("description")%>' browserSpanValue='<%=PrjDescspan%>' 
				browserUrl="/systeminfo/BrowserMain.jsp?url=/CRM/data/MutiCustomerBrowser.jsp"
				hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
				completeUrl="/data.jsp?type=7"  />
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(15263,user.getLanguage())%></wea:item>
		<wea:item>
			<input type=checkbox name="managerview" value=1 <%if(RecordSet.getString("ManagerView").equals("1")){%> checked <%}%> />
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(6161,user.getLanguage())%></wea:item>
		<wea:item>
          <%=connames%>
		</wea:item>
	</wea:group>
	
	
	<!-- manageinfo -->
	<wea:group context='<%=SystemEnv.getHtmlLabelName(27858,user.getLanguage())%>' attributes="{}">
		<wea:item><%=SystemEnv.getHtmlLabelName(636,user.getLanguage())%></wea:item>
		<wea:item>
			<brow:browser viewType="0" name="parentid" browserValue='<%=RecordSet.getString("parentid")%>' browserSpanValue='<%=Util.toScreen(ProjectInfoComInfo.getProjectInfoname(RecordSet.getString("parentid")),user.getLanguage())%>' 
				browserUrl="/systeminfo/BrowserMain.jsp?url=/proj/data/ProjectBrowser.jsp"
				hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
				completeUrl="/data.jsp?type=8"  />
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(144,user.getLanguage())%></wea:item>
		<wea:item>
			<brow:browser viewType="0" name="manager" browserValue='<%=RecordSet.getString("manager")%>' browserSpanValue='<%=Util.toScreen(ResourceComInfo.getResourcename(RecordSet.getString("manager")),user.getLanguage())%>' 
				browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
				hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='2'
				completeUrl="/data.jsp"  />
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(101,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(431,user.getLanguage())%></wea:item>
		<wea:item>
			<brow:browser viewType="0" name="hrmids02" browserValue='<%=Members%>' browserSpanValue='<%=ProjectTransUtil.getResourceNames(Members) %>' 
				browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp"
				hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='1' 
				completeUrl="/data.jsp"  />
		
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(624,user.getLanguage())%></wea:item>
		<wea:item>
			<input type=checkbox name="isblock" value=1 <%if(RecordSet.getString("isblock").equals("1")){%> checked <%}%> >
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(587,user.getLanguage())%></wea:item>
		<wea:item>
			<span id="prjstatus_span"><%=ProjectStatusComInfo.getProjectStatusdesc(status_prj) %></span>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(637,user.getLanguage())%></wea:item>
		<wea:item>
			<brow:browser viewType="0" name="envaluedoc" 
				browserValue='<%=Util.toScreenToEdit(RecordSet.getString("envaluedoc"),user.getLanguage())%>' 
				browserSpanValue='<%=Util.toScreen(DocComInfo.getDocname(RecordSet.getString("envaluedoc")),user.getLanguage())%>' 
				browserUrl="/systeminfo/BrowserMain.jsp?url=/docs/docs/DocBrowser.jsp"
				hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
				completeUrl="/data.jsp?type=9"  />
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(638,user.getLanguage())%></wea:item>
		<wea:item>
			<brow:browser viewType="0" name="confirmdoc" 
				browserValue='<%=Util.toScreenToEdit(RecordSet.getString("confirmdoc"),user.getLanguage())%>' 
				browserSpanValue='<%=Util.toScreen(DocComInfo.getDocname(RecordSet.getString("confirmdoc")),user.getLanguage())%>' 
				browserUrl="/systeminfo/BrowserMain.jsp?url=/docs/docs/DocBrowser.jsp"
				hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
				completeUrl="/data.jsp?type=9"  />
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(639,user.getLanguage())%></wea:item>
		<wea:item>
			<brow:browser viewType="0" name="proposedoc" 
				browserValue='<%=Util.toScreenToEdit(RecordSet.getString("proposedoc"),user.getLanguage())%>' 
				browserSpanValue='<%=Util.toScreen(DocComInfo.getDocname(RecordSet.getString("proposedoc")),user.getLanguage())%>' 
				browserUrl="/systeminfo/BrowserMain.jsp?url=/docs/docs/DocBrowser.jsp"
				hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
				completeUrl="/data.jsp?type=9"  />
		</wea:item>
		
<%
if(PrjSettingsComInfo.getPrj_acc()){//项目卡片附件
	%>
		<wea:item><%=SystemEnv.getHtmlLabelName(22194,user.getLanguage())%></wea:item>
		<wea:item>
			<%
			  String display = "0";
			  if(!project_accessory.equals("")) {
					display = "1";
					if(project_accessory.startsWith(",")){
						project_accessory= project_accessory.substring(1,project_accessory.length());
					}
					if(project_accessory.endsWith(",")){
						project_accessory= project_accessory.substring(0,project_accessory.length()-1);
					}
					String sql="select id,docsubject,accessorycount from docdetail where id in ("+project_accessory+")";
					rs.executeSql(sql);
					int linknum=-1;
					while(rs.next()){
					  linknum++;
					  String showid = Util.null2String(rs.getString(1)) ;
					  String tempshowname= Util.toScreen(rs.getString(2),user.getLanguage()) ;
					  int accessoryCount=rs.getInt(3);
	
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
	        %>
	            <input type=hidden name="field_del_<%=linknum%>" value="0" >
	              <%=imgSrc%>
	              <%if(accessoryCount==1 && (fileExtendName.equalsIgnoreCase("xls")||fileExtendName.equalsIgnoreCase("doc"))){%>
	                <a style="cursor:hand" onclick="opendoc('<%=showid%>','<%=versionId%>','<%=docImagefileid%>')"><%=docImagefilename%></a>&nbsp
	              <%}else{%>
	                <a style="cursor:hand" onclick="opendoc1('<%=showid%>')"><%=tempshowname%></a>&nbsp
	              <%}%>
	              <input type=hidden name="field_id_<%=linknum%>" value=<%=showid%>>
				    <button type="button" class=btnFlow accessKey=1 onclick='onChangeSharetype("span_id_<%=linknum%>","field_del_<%=linknum%>","<%=0%>")'>
					<u><%=linknum%></u>-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></button>
					<span id="span_id_<%=linknum%>" name="span_id_<%=linknum%>" style="visibility:hidden">
	                    <B><FONT COLOR="#FF0033">√</FONT></B>
	                </span>
	          <%}%>
	            <input type=hidden name="field_idnum" value=<%=linknum+1%>>
	            <input type=hidden name="field_idnum_1" value=<%=linknum+1%>>
	        <%}%> 
			<%  
			if(!"".equals(PrjSettingsComInfo.getPrj_accsec()) && Util.getIntValue(PrjSettingsComInfo.getPrj_accsize(),0)>0 ){
			%>
	        
	          <script type="text/javascript">
					window.onload = function() {
					  var settings = {
							flash_url : "/js/swfupload/swfupload.swf",
							upload_url: "/proj/data/uploadPrjAcc.jsp",
							post_params: {"method" : "uploadPrjAcc","secid":"<%=PrjSettingsComInfo.getPrj_accsec() %>"},
							file_size_limit : "<%=PrjSettingsComInfo.getPrj_accsize() %> MB",
							file_types : "*.*",
							file_types_description : "All Files",
							file_upload_limit : 100,
							file_queue_limit : 0,
							custom_settings : {
								progressTarget : "fsUploadProgress",
								cancelButtonId : "btnCancel"
							},
							debug: false,
							button_image_url : "/js/swfupload/add_wev8.png",
							button_placeholder_id : "spanButtonPlaceHolder",
			
							button_width: 100,
							button_height: 18,
							button_text : '<span class="button"><%=SystemEnv.getHtmlLabelName(21406,user.getLanguage())%></span>',
							button_text_style : '.button { font-family: Helvetica, Arial, sans-serif; font-size: 12pt; } .buttonSmall { font-size: 10pt; }',
							button_text_top_padding: 0,
							button_text_left_padding: 18,
								
							button_window_mode: SWFUpload.WINDOW_MODE.TRANSPARENT,
							button_cursor: SWFUpload.CURSOR.HAND,
							
							file_queued_handler : fileQueued,
							file_queue_error_handler : fileQueueError,
							file_dialog_complete_handler : fileDialogComplete_1,
							upload_start_handler : uploadStart,
							upload_progress_handler : uploadProgress,
							upload_error_handler : uploadError,
							upload_success_handler : uploadSuccess,
							upload_complete_handler : uploadComplete,
							queue_complete_handler : queueComplete	// Queue plugin event
						};
						try{
							oUpload = new SWFUpload(settings);
						} catch(e){alert(e)}
					}
			
					function fileDialogComplete_1(){
						document.getElementById("btnCancel1").disabled = false;
						fileDialogComplete
					}
					function uploadSuccess(fileObj,serverdata){
						var data=eval(serverdata);
						if(data){
							var a=data;
							if(a>0){
								jQuery("#accdocids").val(jQuery("#accdocids").val()+","+a);
							}
						}
					}
			
					function uploadComplete(fileObj) {
						try {
							if (this.getStats().files_queued === 0) {
								frmain.submit();
								document.getElementById(this.customSettings.cancelButtonId).disabled = true;
							} else {	
								this.startUpload();
							}
						} catch (ex) { this.debug(ex); }
			
					}
				</script>
				<div>
					<span> 
						<span id="spanButtonPlaceHolder"></span><!--选取多个文件-->
					</span>
					&nbsp;&nbsp;
					<span style="color:#262626;cursor:hand;TEXT-DECORATION:none" disabled onclick="oUpload.cancelQueue();" id="btnCancel1">
						<span><img src="/js/swfupload/delete_wev8.gif"  border="0"></span>
						<span style="height:19px"><font style="margin:0 0 0 -1"><%=SystemEnv.getHtmlLabelName(21407,user.getLanguage())%></font><!--清除所有选择--></span>
					</span>
				</div>
				<div class="fieldset flash" id="fsUploadProgress"></div>
				<div id="divStatus"></div>
				(<%=SystemEnv.getHtmlLabelName(18642,user.getLanguage())%>:<%=PrjSettingsComInfo.getPrj_accsize() %>M)
			<%}else{%>
			<font color="red"><%=SystemEnv.getHtmlLabelName(17616,user.getLanguage())+SystemEnv.getHtmlLabelName(92,user.getLanguage())+SystemEnv.getHtmlLabelName(15808,user.getLanguage())%>!</font>
	       <%}%>
		</wea:item>
	
	<%
}

%>
		
		
	</wea:group>
	
	
	<!-- otherinfo -->
	<wea:group context='<%=SystemEnv.getHtmlLabelName(410,user.getLanguage())%>'>
	<%
	//cusfield
	TreeMap<String,JSONObject> openfieldMap= CptFieldComInfo.getOpenFieldMap();
	if(openfieldMap!=null){
		Iterator it=openfieldMap.entrySet().iterator();
		while(it.hasNext()){
			Entry<String,JSONObject> entry=(Entry<String,JSONObject>)it.next();
			String k= entry.getKey();
			JSONObject v= entry.getValue();
		
		%>
		<wea:item><%=SystemEnv.getHtmlLabelName(v.getInt("fieldlabel"),user.getLanguage())%></wea:item>
		<wea:item>
			<%=((HtmlElement)Class.forName(v.getString("eleclazzname")).newInstance()).getHtmlElementString(Util.null2String(RecordSet.getString(v.getString("fieldname"))), v, user) %>
		</wea:item>
		
		<%
		}
	}
	
	%>		
	


<%
//项目类型自定义字段
String  sql_cus = "select * from cus_fielddata where id='"+ProjID+"' and scope='ProjCustomFieldReal' and scopeid='"+projTypeId+"' ";
RecordSet_cus.executeSql(sql_cus);
RecordSet_cus.next();
CustomFieldManager cfm = new CustomFieldManager("ProjCustomField",Util.getIntValue(RecordSet.getString("prjtype")));
cfm.getCustomFields4prj();    
cfm.getCustomData4prj("ProjCustomFieldReal",Util.getIntValue(RecordSet.getString("prjtype")),Util.getIntValue(ProjID));
    while(cfm.next()){
    	String fieldvalue = "";
        if(cfm.getHtmlType().equals("2")){
        	fieldvalue = Util.toHtmltextarea(RecordSet_cus.getString(cfm.getFieldName(""+cfm.getId())));
        }else{
        	fieldvalue = Util.toHtml(RecordSet_cus.getString(cfm.getFieldName(""+cfm.getId())));
        }
        String fieldValue=fieldvalue;
        JSONObject v=new JSONObject();
        v.put("fieldkind", "2");
        v.put("groupid", "3");
        v.put("id", ""+cfm.getId());
        v.put("fieldname", "customfield"+cfm.getId());
        v.put("fieldlabel", cfm.getLable4prj(user.getLanguage()));
        v.put("fielddbtype", cfm.getFieldDbType());
        v.put("fieldhtmltype", cfm.getHtmlType());
        v.put("ismand", cfm.isMand()?"1":"0");
        v.put("type", ""+cfm.getType());
        v.put("eleclazzname", HtmlUtil.getHtmlClassName(cfm.getHtmlType()));
        v.put("seltype", "prjtype");
        v.put("issystem", "0");
%>
<wea:item><%=cfm.getLable4prj(user.getLanguage())%></wea:item>
<wea:item>
<%=((HtmlElement)Class.forName(v.getString("eleclazzname")).newInstance()).getHtmlElementString(fieldValue, v, user) %>
</wea:item>
  
<%
}
%>



	
	</wea:group>
	
	
</wea:layout>

<%
//TD5205
//modified by hubo, 2006-10-26
//ProjTempletUtil.getViewProjTaskListStr(request, Util.getIntValue(ProjID));
%>
<TEXTAREA NAME="areaLinkXml" id="areaLinkXml" ROWS="6" COLS="100" style="display:none">
	
</TEXTAREA> 
<div style="height:100px!important;"></div>
</FORM>



<%
if("1".equals(isDialog)){
	%>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
<wea:layout>
	<wea:group context="">
    	<wea:item type="toolbar">
    		<input class="zd_btn_cancle" type="button" name="cancel" onclick="parentDialog.closeByHand();"  value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>"/>
    	</wea:item>
    </wea:group>
</wea:layout>
</div>	
	
	<%
}
%>


<script language="javaScript">  
    
   
    function submitData(obj){
 	   if (check_form(frmain,'name,prjtype,manager,hrmids02')) {
 	   		 var chkFields = '<%=chkFields%>';
 		   	 if(chkFields!=null && chkFields!=''){
 		   		var str = chkFields.split(",");
 		   		for(var j=0; j<str.length; j++){
 		   			var strValue = str[j];
 		   			if(!checkFields(strValue)) return false;
 		   		}
 		   	 }
             obj.disabled = true;  
             myBody.onbeforeunload=null;
           
             if(!oUpload){
             	frmain.submit();
             }else{
             	try {
             		if(oUpload.getStats().files_queued === 0){
                     	frmain.submit();
                     }else {
                     	oUpload.startUpload();
                     }
 				} catch (e) {
 					frmain.submit();
 				}
             	
             	
             }
             
         }
     }
    
    function goBack(){
    	try{
    		history.go(-1);
    	}catch(e){}
    }
        
    //判断SecuLevel 和LabourP input框中是否输入的是数字
    function ItemCount_KeyPress_SandL(){
     if(!(((window.event.keyCode>=48) && (window.event.keyCode<=57))))
      {
         window.event.keyCode=0;
      }
    }

    function checknumber_SandL(objectname){	
        valuechar = document.all(objectname).value.split("") ;
        isnumber = false ;
        for(i=0 ; i<valuechar.length ; i++) { charnumber = parseInt(valuechar[i]) ; if( isNaN(charnumber)) isnumber = true ;}
        if(isnumber) document.all(objectname).value = "" ;
    }
    
    function checkLength(){
			tmpvalue = document.all("PrjName").value;
			if(realLength(tmpvalue)>50){
				alert("<%=SystemEnv.getHtmlLabelName(20246,user.getLanguage())%>50(<%=SystemEnv.getHtmlLabelName(20247,user.getLanguage())%>)");
				//if(realLength(tmpvalue)==tmpvalue.length) document.all("PrjName").value=tmpvalue.substring(0,50);
				//else document.all("PrjName").value=tmpvalue.substring(0,25);
				while(true){
					tmpvalue = tmpvalue.substring(0,tmpvalue.length-1);
					//alert(tmpvalue);
					if(realLength(tmpvalue)<=50){
						document.all("PrjName").value = tmpvalue;
						return;
					}
				}
			}
		}
	
    function onChangeSharetype(delspan,delid,ismand){
    	fieldid=delid.substr(0,delid.indexOf("_"));
    	fieldidnum=fieldid+"_idnum_1";
    	fieldidspan=fieldid+"span";
    	fieldidspans=fieldid+"spans";
    	fieldid=fieldid+"_1";
        if(document.all(delspan).style.visibility=='visible'){
          document.all(delspan).style.visibility='hidden';
          document.all(delid).value='0';
    	  document.all(fieldidnum).value=parseInt(document.all(fieldidnum).value)+1;
        }else{
          document.all(delspan).style.visibility='visible';
          document.all(delid).value='1';
    	  document.all(fieldidnum).value=parseInt(document.all(fieldidnum).value)-1;
        }
    }
    function opendoc(showid,versionid,docImagefileid){
    	openFullWindowForXtable("/docs/docs/DocDspExt.jsp?id="+showid+"&imagefileId="+docImagefileid+"&from=accessory&wpflag=workplan");
    	
    }
    function opendoc1(showid){
    	openFullWindowForXtable("/docs/docs/DocDsp.jsp?id="+showid+"&isOpenFirstAss=1&wpflag=workplan");
    }

</script> 

</BODY>
</HTML>

<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>

