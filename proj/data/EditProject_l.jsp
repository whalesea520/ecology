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
<%@ page import="weaver.formmode.tree.CustomTreeUtil"%>
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
<jsp:useBean id="PrjFieldManager" class="weaver.proj.util.PrjFieldManager" scope="page"/>
<jsp:useBean id="PrjSettingsComInfo" class="weaver.proj.util.PrjSettingsComInfo" scope="page"/>
<jsp:useBean id="ProjectTransUtil" class="weaver.proj.util.ProjectTransUtil" scope="page"/>
<jsp:useBean id="CodeUtil" class="weaver.proj.util.CodeUtil" scope="page"/>
<jsp:useBean id="CptCardGroupComInfo" class="weaver.proj.util.PrjCardGroupComInfo" scope="page" />
<%
String isclose = Util.null2String(request.getParameter("isclose"));
String isDialog = Util.null2String(request.getParameter("isdialog"));
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

//判断当前分部是否有配工作时间(总部)
String schedulesql = " select * from HrmSchedule where scheduleType='3' ";
boolean hasschedule = false;
RecordSetFF.executeSql(schedulesql);
if(RecordSetFF.next()){
	hasschedule = true;
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
String passnoworktime = RecordSet.getString("passnoworktime");
String department = RecordSet.getString("department");
String projTypeId=RecordSet.getString("prjtype");
int templetId=Util.getIntValue( RecordSet.getString("proTemplateId"),0);
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

String codeuse=CodeUtil.getPrjCodeUse();

String isManagerFromView = Util.null2String(request.getParameter("isManager"));
String bbStyle="" ; // Browser button style.
String inputDisabled=""; //input disabled
String editable="yes";
if ("false".equals(isManagerFromView)){
    bbStyle="style='display:none'";
    inputDisabled = "readonly";
    editable="no";
}
String prjname11 = Util.toScreenToEdit(RecordSet.getString("name"),user.getLanguage());
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
<!--引入ueditor相关文件-->
<script type="text/javascript" charset="UTF-8" src="/ueditor/ueditor.config_wev8.js"></script>
<script type="text/javascript" charset="UTF-8" src="/ueditor/ueditor.all.min_wev8.js"> </script>
<script type="text/javascript" charset="UTF-8" src="/ueditor/lang/zh-cn/zh-cn_wev8.js"></script>
<!--添加插件-->
<script type="text/javascript" charset="UTF-8" src="/ueditor/custbtn/appwfat_wev8.js"></script>
<link type="text/css" href="/ueditor/ueditorext_wf_wev8.css" rel="stylesheet"></link>
<!-- ckeditor的一些方法在uk中的实现 -->
<script type="text/javascript" charset="UTF-8" src="/js/workflow/ck2uk_wev8.js"></script>

<!-- word转html插件 -->
<script type="text/javascript" charset="UTF-8" src="/ueditor/custbtn/wordtohtml_wev8.js"></script>

<link href="/js/swfupload/default_wev8.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="/js/swfupload/swfupload_wev8.js"></script>
<script type="text/javascript" src="/js/swfupload/swfupload.queue_wev8.js"></script>
<script type="text/javascript" src="/js/swfupload/fileprogressBywf_wev8.js"></script>
<script type="text/javascript" src="/js/swfupload/handlersBywf_wev8.js"></script>

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
.e8_os{width:30%!important;}
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

<input <%=inputDisabled%> class=inputstyle maxLength=3 size=3 name="SecuLevel" type=hidden value="<%=Util.toScreenToEdit(RecordSet.getString("securelevel"),user.getLanguage())%>">
<input <%=inputDisabled%> type="hidden" name="status" value="<%=RecordSet.getString("status")%>"/>

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

<%
//项目类型自定义字段
String  sql_cus = "select * from prj_fielddata where id='"+ProjID+"' and scope='ProjCustomFieldReal' and scopeid='"+projTypeId+"' ";
RecordSet_cus.executeSql(sql_cus);
RecordSet_cus.next();


//int fieldcount=0;//用来定位字段
//int fieldsize=0;//用来定位字段数量
int groupcount=0;//用来定位组
String needHideField="status,prjtype,department,";//用来隐藏字段
//必填字段控制
String[]mandStr= Util.TokenizerString2(CptFieldComInfo.getMandFieldStr(""+projTypeId),",") ;
String checkStr="";
if(mandStr!=null&&mandStr.length>0){
	for(int i=0;i<mandStr.length;i++){
		if(mandStr[i].equals("procode")){
			continue;
		}
		if((","+needHideField).indexOf(","+mandStr[i]+",")>=0){
			continue;
		}
		if(mandStr[i].equals("members")){
			mandStr[i]="hrmids02";
		}
		checkStr+=mandStr[i]+",";
	}
}

%>

<wea:layout attributes="{'expandAllGroup':'true'}">

<%

TreeMap<String,TreeMap<String,JSONObject>> groupFieldMap=CptFieldComInfo.getGroupFieldMap(""+projTypeId);
CptCardGroupComInfo.setTofirstRow();
while(CptCardGroupComInfo.next()){
	String groupid=CptCardGroupComInfo.getGroupid();
	TreeMap<String,JSONObject> openfieldMap= groupFieldMap.get(groupid);
	if(openfieldMap==null||openfieldMap.size()==0){
		continue;
	}
	int grouplabel=Util.getIntValue( CptCardGroupComInfo.getLabel(),-1);
	groupcount++;
	%>
<wea:group context='<%=SystemEnv.getHtmlLabelName(grouplabel,user.getLanguage())%>'>	
<%
if(!openfieldMap.isEmpty()){
	//fieldsize=openfieldMap.size();
	Iterator it=openfieldMap.entrySet().iterator();
	while(it.hasNext()){
		//fieldcount++;
		Entry<String,JSONObject> entry=(Entry<String,JSONObject>)it.next();
		String k= entry.getKey();
		//JSONObject v= (JSONObject)entry.getValue().clone() ;
		JSONObject v=new JSONObject(((JSONObject)entry.getValue()).toString());
		int fieldlabel=v.getInt("fieldlabel");
		String fieldid=v.getString("id");
		String fieldName=v.getString("fieldname");
		int fieldhtmltype=v.getInt("fieldhtmltype");
		String fielddbtype = v.getString("fielddbtype");
		int type=v.getInt("type");
		int ismand=v.getInt("ismand");
		int issystem=v.getInt("issystem");
		String templeteFieldName=fieldName;
		if("procode".equals(fieldName)&&!"2".equals(codeuse)){//非手动编码
			continue;
		}else if("protemplateid".equals(fieldName)){//模板字段只需显示
			//if(templetId<=0){
			//	continue;
			//}
		}else if("department".equals(fieldName)){//部门字段不需要
			continue;
		}else if("status".equals(fieldName)){//状态字段不需要
			continue;
		}
		
		String fieldkind=v.getString("fieldkind");
		
		String fieldValue="";
		if("2".equals(fieldkind)){
			fieldValue=Util.null2String(RecordSet_cus.getString(fieldName));
		}else{
			fieldValue=Util.null2String(RecordSet.getString(fieldName));
		}
		
		if("2".equals(fieldkind)){
			fieldName="customfield"+fieldid.replace("prjtype_", "");
			v.put("id", fieldid.replace("prjtype_", ""));
		}
		
		if("members".equals( fieldName)||"hrmids02".equals(fieldName)){//项目成员原有特殊逻辑,不能改原来展现的元素名
			fieldName="hrmids02";
			fieldValue=Util.null2String(RecordSet.getString("members"));
			v.put("fieldname", fieldName);
		}
		String hideField="{}";
		if(needHideField.indexOf(","+fieldName+",")!=-1){
			hideField="{'samePair':'hideField'}";
		}
		
		//System.out.println("fieldname:"+fieldName+"\tfieldvalue:"+fieldValue);
	%>
	<wea:item attributes='<%=hideField %>'><%=SystemEnv.getHtmlLabelName(fieldlabel,user.getLanguage())%>
	<%if(fieldlabel==18628){ %><span style="margin-left:10px"><img src="/wechat/images/remind_wev8.png" align="absMiddle" title="<%=SystemEnv.getHtmlLabelName(124925,user.getLanguage())%>" /></span><% }%></wea:item>
	<wea:item attributes='<%=hideField %>'>
		<%if("name".equals(fieldName)){%>
			<input <%=inputDisabled%> class=inputstyle maxLength=500 size=500 id="name" name="name" onblur="checkLength()" onchange='checkinput("name","PrjNameimage")' value='<%=prjname11%>'>
			<SPAN id=PrjNameimage></SPAN>
			<span id="remind" style="cursor:hand" title='<%=SystemEnv.getHtmlLabelName(20246,user.getLanguage())%>500(<%=SystemEnv.getHtmlLabelName(20247,user.getLanguage())%>)'>
			<img src="/images/remind_wev8.png" align="absmiddle"  />
			</span>
		<%}else	if("protemplateid".equals(fieldName)){
			if(templetId>0){
				String tmpname="";
				RecordSetFF.executeSql("select templetName from Prj_Template where id="+templetId);
				if(RecordSetFF.next()){
					tmpname=Util.null2String( RecordSetFF.getString("templetName"));
				}
				%>
				<%=tmpname %>
				<input type="hidden" name=protemplateid value="<%=templetId %>" />
				<%
			}
		}else if("prjtype".equals(fieldName)){
			%>
			<%=ProjectTypeComInfo.getProjectTypename(""+projTypeId) %>
			<input type="hidden" name=prjtype value="<%=projTypeId %>" />
			<%
		}else if("passnoworktime".equals(fieldName)){
			%>
			<input type="checkbox" name=passnoworktime1 id="passnoworktime1" onclick="getPassnoworktime()"/>
			<input type="hidden" name=passnoworktime id="passnoworktime" value="<%=passnoworktime %>" />
			<%
		}else if("manager".equals(fieldName)){
			%>
			<brow:browser viewType="0" name="manager" browserValue='<%=manager%>' browserSpanValue='<%=Util.toScreen(ResourceComInfo.getResourcename(manager),user.getLanguage())%>' 
				browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
				hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='2' 
			    _callback="getPassnoworktime"
				completeUrl="/data.jsp"  />
			<% 
		}else{
			if(fieldhtmltype==3&&(type==161||type==162||type==256||type==257)){
				String showname = "";
				String urls= "";
				if(type==161||type==162){
					showname=PrjFieldManager.getBrowserFieldvalue(user,fieldValue, type, fielddbtype,false);
					urls=BrowserComInfo.getBrowserurl(""+type)+"?type="+fielddbtype;     // 浏览按钮弹出页面的
				}else{
					CustomTreeUtil customTreeUtil = new CustomTreeUtil();
			   	  	showname = customTreeUtil.getTreeFieldShowName(fieldValue,fielddbtype);
			   	  	urls=BrowserComInfo.getBrowserurl(""+type)+"?type="+fielddbtype+"_"+type;     // 浏览按钮弹出页面的url
				}
				
				String andChar="?";
				String isMustInput = "1" ; 
				if(ismand==1){
					isMustInput = "2";
				}
				String isSingleStr = "true";//单选
			    if(type==162||type==257){
			    	isSingleStr = "false";
			    }
				String showfieldname=1==issystem?fieldid:"field"+fieldid;
				if("2".equals(fieldkind)){//项目类型自定义字段的元素名
					showfieldname="customfield"+fieldid.replace("prjtype_", "");
				}
				String browserOnClick = "onShowBrowserCustom('"+showfieldname+"','"+urls+"','"+type+"','"+isMustInput+"')";
			%>
				<brow:browser viewType="0" name='<%=showfieldname%>' browserValue='<%=fieldValue%>' 
							 completeUrl='' width="500px" 
							browserOnClick="<%=browserOnClick%>" hasInput="true" isSingle="<%=isSingleStr%>" hasBrowser = "true" isMustInput="<%=isMustInput%>"
							idSplitFlag="," nameSplitFlag=","
							browserSpanValue='<%=showname%>'>
						</brow:browser>
						<input type=hidden name="<%=showfieldname%>_name" value="<%=showname%>">
			<%}else{ %>
				<%=((HtmlElement)Class.forName(v.getString("eleclazzname")).newInstance()).getHtmlElementString(fieldValue, v, user) %>
			<%}%>
			<%
		}
		%>
		
	</wea:item>
	<%
	}
}
%>
<%
	if(groupcount==1 && PrjSettingsComInfo.getPrj_acc() ){//附件位置
		String accsec=PrjSettingsComInfo.getPrj_accsec();
		String accsize=PrjSettingsComInfo.getPrj_accsize();
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
	<%
}
%>	
 	
 	
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
	var value = $("#name").val();
	var projectid = "<%=ProjID%>";
	 var returnValue = "";
	 var msg="<%=SystemEnv.getHtmlLabelNames("1353,18082",user.getLanguage())%>";
	 var URL = "/proj/data/CheckPrjName.jsp?prjName="+value+"&type=edit&projectid="+projectid+"&prjtypeid=<%=projTypeId %>&time="+new Date();
	 URL = encodeURI(URL);
	    var flag=false;
	    jQuery.ajax({
        url: URL,
        type: "post",
        async: false,
        success: function(data){
	    	returnValue = jQuery.trim(data);
           if('1'==returnValue) {
        	   window.top.Dialog.alert(msg);
			        flag=false;
			        $("#name").val("<%=prjname11%>");
			        checkinput("name","PrjNameimage");
	    		}
	    		else{
	    		    flag=true;
	    		}
        }
    });
	if(flag){
		    
	var chkFields = '<%=checkStr %>';
    if("<%=codeuse %>"=="2"){
    	chkFields+=",procode";
	}
    if(!check_form(frmain,chkFields)) return false;
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
    function getPassnoworktime(){
    	var temp = "0";
    	var tobj = document.getElementById("passnoworktime1");
    	if(tobj.checked==true){
    		if("<%=hasschedule%>"=="true"){
    			temp = "1";
    		}else{
    			var manager = $("#manager").val();
    			if(""==manager){
    				temp = "0";
    				//jNiceChecked
    				$("#passnoworktime1").next().attr("class","jNiceCheckbox");
    				$("#passnoworktime1").attr("checked",'false');
    				window.top.Dialog.alert('<%=SystemEnv.getHtmlLabelNames("125389,16573",user.getLanguage())%>');
    			}else{
    				var msg="<%=SystemEnv.getHtmlLabelName(84409,user.getLanguage())%>";
    				var URL = "/proj/data/CheckSchedule.jsp?manager="+manager+"&time="+new Date();
    			    var flag=false;
    			    jQuery.ajax({
    		        url: URL,
    		        type: "post",
    		        async: false,
    		        success: function(data){
    			    	returnValue = jQuery.trim(data);
    		            if('1'==returnValue) {
    		            	temp = "1";
    			    	}else{
    		    			temp = "0";
    						//jNiceChecked
    						$("#passnoworktime1").next().attr("class","jNiceCheckbox");
    						$("#passnoworktime1").attr("checked",'false');
    		    			window.top.Dialog.alert(msg);
    			    	}
    		        	}
    			    });
    			}
    		}
    	}
    	
    	$("#passnoworktime").val(temp);
    	//alert($("#passnoworktime").val());
    	
    }
    
    function doReturnSpanHtml(obj){
		var t_x = obj.substring(0, 1);
		if(t_x == ','){
			t_x = obj.substring(1, obj.length);
		}else{
			t_x = obj;
		}
		return t_x;
	}

	function onShowBrowserCustom(id, url, type1,isMustInput) {
		if (type1 == 256|| type1==257) {
			tmpids = $GetEle(id).value;
			url = url + "&selectedids=" + tmpids;
			url+="&iscustom=1";
		}else{
			tmpids = $GetEle(id).value;
			url = url + "|" + id + "&beanids=" + tmpids;
			url = url.substring(0, url.indexOf("url=") + 4) + escape(url.substr(url.indexOf("url=") + 4));
			url+="&iscustom=1";
		}
		var dialogurl = url;
		var prjdialog = new window.top.Dialog();
		prjdialog.currentWindow = window;
		prjdialog.URL = dialogurl;
		prjdialog.callbackfun = function (paramobj, id1) {
		
			if (id1 != null) {
			if (wuiUtil.getJsonValueByIndex(id1, 0) != "") {
				var ids = doReturnSpanHtml(wuiUtil.getJsonValueByIndex(id1, 0));
				var names = wuiUtil.getJsonValueByIndex(id1, 1);
				var descs = wuiUtil.getJsonValueByIndex(id1, 2);
				if (type1 == 161) {
					$G(id + "span").innerHTML = wrapshowhtml("<a title='" + names + "'>" + names + "</a>&nbsp",ids,1);
					$G(id).value = ids;
					$G(id + "_name").value = names;
				}
				if (type1 == 162) {
					var sHtml = "";
	
					var idArray = ids.split(",");
					var curnameArray = names.split(",");
					var curdescArray = descs.split(",");
	
					for ( var i = 0; i < idArray.length; i++) {
						var curid = idArray[i];
						var curname = curnameArray[i];
						var curdesc = curdescArray[i];
						if(curdesc==''||curdesc=='undefined'||curdesc==null){
							curdesc = curname;
						}
						if(curdesc){
							curdesc = curname;
						}
	
						sHtml +=  wrapshowhtml("<a title='" + curdesc + "' >" + curname + "</a>&nbsp",curid,1);
					}
	
					$G(id + "span").innerHTML = sHtml;
					$G(id).value = doReturnSpanHtml(wuiUtil.getJsonValueByIndex(id1, 0));
					$G(id + "_name").value = wuiUtil.getJsonValueByIndex(id1, 1);
				}
				if (type1 == 256||type1 == 257) {
					$G(id + "span").innerHTML =  names ;
					$G(id).value = ids;
					$G(id + "_name").value = names;
				}
				if (isMustInput == 2) {
					jQuery("#"+id+"spanimg").html("");
				}
			} else {
				$G(id + "span").innerHTML = "";
				$G(id).value = "";
				$G(id + "_name").value = "";
				if(isMustInput == 2){
					jQuery("#"+id+"spanimg").html("<img align='absmiddle' src='/images/BacoError_wev8.gif'>");
				}
			}
		}
			
		hoverShowNameSpan(".e8_showNameClass");
		   
		};
		
		prjdialog.Title = "<%=SystemEnv.getHtmlLabelName(18214,user.getLanguage())%>";//请选择
		prjdialog.Width = 550 ;
		if(url.indexOf("/MutiResourceBrowser.jsp")!=-1){ 
			prjdialog.Width=648; 
		}
		prjdialog.Height = 600;
		prjdialog.Drag = true;
		prjdialog.show();
	
	}
	
	function wrapshowhtml(ahtml, id,ismast) {
		var str = "<span class=\"e8_showNameClass\">";
		str += ahtml;
		var mastinput = 1;//2：必须输入 ；1：可编辑
		if(ismast){
			mastinput = ismast;
		}
		str += "<span class=\"e8_delClass\" id=\"" + id + "\" onclick=\"del(event,this,"+mastinput+",false,{});\" style=\"opacity: 0; visibility: hidden;\">&nbsp;x&nbsp;</span></span>";
		return str;
	}
	
	function openHrefWithChinese(url){
	    url = dealChineseOfFieldParams(url);
	    window.open(url);
	}
	
	//encodeURIComponent
	function dealChineseOfFieldParams(url){
		if(url.indexOf("/workflow/request/AddRequest.jsp")==-1 && url.indexOf("/formmode/view/AddFormMode.jsp") != 0) {
			return url;
		}
		var params = "";
		var path = url.substring(0,url.indexOf("?")+1);
		var filedparams = url.substring(url.indexOf("?")+1);
		var fieldparam = filedparams.split("&");
		 for(var i=0;i<fieldparam.length;i++) {
			var tmpindex = fieldparam[i].indexOf("=");
			if(tmpindex != -1) {
				var key = fieldparam[i].substring(0, tmpindex);
				var value = encodeURIComponent(fieldparam[i].substring(tmpindex+1));
				params+="&"+key+"="+value
			}
		} 
		return path+params.substring(1);
	}
	
    $(function(){
    	if("<%=passnoworktime%>"=="1"){
    		$("#passnoworktime1").next().attr("class","jNiceCheckbox jNiceChecked");
    		$("#passnoworktime1").attr("checked",'true');
        }
    	//$("#manager").bind('change',getPassnoworktime());
    	//impProjBase();
    });
</script> 

</BODY>
</HTML>

<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
<SCRIPT language="javascript" src="/js/selectDateTime_wev8.js"></script>
<script type="text/javascript">
function onShowTime(spanname,inputname){
	var dads  = document.getElementById("meizzDateLayer2").style;
	setLastSelectTime(inputname);
	/*var th = spanname;
	var ttop  = spanname.offsetTop; 
	var thei  = spanname.clientHeight;
	var tleft = spanname.offsetLeft; 
	var ttyp  = spanname.type;       
	while (spanname = spanname.offsetParent){
		ttop += spanname.offsetTop; 
		tleft += spanname.offsetLeft;
	}*/
	
	var th = $ele4p(spanname);
	var ttop  = $ele4p(spanname).offsetTop; 
	var thei  = $ele4p(spanname).clientHeight;
	var tleft = $ele4p(spanname).offsetLeft; 
	var ttyp  = $ele4p(spanname).type;    
	while (spanname = $ele4p(spanname).offsetParent){
		ttop += $ele4p(spanname).offsetTop; 
		tleft += $ele4p(spanname).offsetLeft;
	}
	//dads.top  = ((ttyp == "image") ? ttop + thei : ttop + thei - 50)+"px";
	dads.top = (jQuery(th).offset().top+8)+"px";
	//dads.left = (tleft - 5)+"px";
	dads.left = jQuery(th).offset().left+"px";
	
	
	//dads.top  = ((ttyp == "image") ? ttop + thei : ttop + thei + 22)+"px";
	//dads.left = tleft+"px";
	outObject = th;
	outValue = inputname;
	outButton = (arguments.length == 1) ? null : th;
	dads.display = '';
	bShow = true;
}
</script>
<script language=javascript src="/proj/js/common_wev8.js"></script>

