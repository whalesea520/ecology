
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util,weaver.docs.docs.CustomFieldManager" %>
<%@ page import="weaver.interfaces.workflow.browser.Browser" %>
<%@ page import="weaver.interfaces.workflow.browser.BrowserBean" %>
<%@ page import="weaver.general.browserData.BrowserManager"%>
<%@ page import="weaver.general.StaticObj" %>
<%@ page import="weaver.hrm.util.html.HtmlUtil"%>
<%@ page import="weaver.hrm.definedfield.HrmFieldManager"%>
<%@ page import="weaver.hrm.util.html.HtmlElement"%>
<%@ page import="org.json.JSONObject"%>
<jsp:useBean id="HrmListValidate" class="weaver.hrm.resource.HrmListValidate" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="UseKindComInfo" class="weaver.hrm.job.UseKindComInfo" scope="page" />
<jsp:useBean id="EducationLevelComInfo" class="weaver.hrm.job.EducationLevelComInfo" scope="page" />
<jsp:useBean id="SpecialityComInfo" class="weaver.hrm.job.SpecialityComInfo" scope="page" />
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page"/>
<jsp:useBean id="CustomFieldTreeManager" class="weaver.hrm.resource.CustomFieldTreeManager" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="HrmResourceFile" class="weaver.hrm.tools.HrmResourceFile" scope="page"/>
<jsp:useBean id="HrmFieldGroupComInfo" class="weaver.hrm.definedfield.HrmFieldGroupComInfo" scope="page"/>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<HTML>
<%
LinkedHashMap ht = new LinkedHashMap();
List<String> lsSamePair = new ArrayList<String>();
String id = request.getParameter("id");
String isView = request.getParameter("isView");

int lanrowindex = 0;
int edurowindex = 0;
int workrowindex = 0;
int trainrowindex = 0;
int cerrowindex = 0;
int rewardrowindex = 0;

String f_weaver_belongto_userid = HrmUserVarify.getcheckUserRightUserId("HrmResourceAdd:Add",user);
int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
int hrmdetachable=Util.getIntValue(String.valueOf(session.getAttribute("hrmdetachable")),0);
int operatelevel=-1;
if(hrmdetachable==1){
    String deptid=ResourceComInfo.getDepartmentID(id);
    String subcompanyid=DepartmentComInfo.getSubcompanyid1(deptid)  ;
    operatelevel=CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"HrmResourceEdit:Edit",Util.getIntValue(subcompanyid));
}else{
	String departmentidtmp = ResourceComInfo.getDepartmentID(id);
	if(HrmUserVarify.checkUserRight("HrmResourceEdit:Edit",user,departmentidtmp)){
		operatelevel=2;
	}
}
if(!(operatelevel>0)){
	response.sendRedirect("/notice/noright.jsp") ;
}

%>
<%@ include file="/hrm/resource/uploader.jsp" %>
<HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<link rel="stylesheet" href="/wui/theme/ecology8/weaveredittable/css/WeaverEditTable_wev8.css">
<link href="/js/checkbox/jquery.tzCheckbox_wev8.css" type=text/css rel=stylesheet>
<link href="/js/ecology8/jNice/jNice/jNice_wev8.css" type=text/css rel=stylesheet>
<link href="/js/ecology8/selectbox/css/jquery.selectbox_wev8.css" type=text/css rel=stylesheet>
<script language=javascript src="/js/ecology8/selectbox/js/jquery.selectbox-0.2_wev8.js"></script>
<link href="/js/checkbox/jquery.tzCheckbox_wev8.css" type=text/css rel=stylesheet>
<script language=javascript src="/js/checkbox/jquery.tzRadio_wev8.js"></script>
<link rel="stylesheet" href="/wui/theme/ecology8/skins/default/wui_wev8.css">
<script  src="/wui/theme/ecology8/weaveredittable/js/WeaverEditTable_wev8.js"></script>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>
<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
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
<link type="text/css" href="/js/tabs/css/e8tabs2_wev8.css" rel="stylesheet" />
<style>
BUTTON.Browser1 {
  background-image: url("/wui/theme/ecology8/skins/default/general/browser_wev8.png") !important;
    width: 16px;
    height: 16px;
}
</style>
<script type="text/javascript">
var lanrowindex = 0;
var workrowindex = 0;
var edurowindex = 0;
var trainrowindex = 0;
var rewardrowindex = 0;
var cerrowindex = 0;
$(function(){
    $('.e8_box').Tabs({
    	getLine:1,
    	image:false,
    	needLine:false,
    	needTopTitle:false,
    	needInitBoxHeight:true,
    	needNotCalHeight:true
    });
});
</script>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(93,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(380,user.getLanguage())+SystemEnv.getHtmlLabelName(87,user.getLanguage());
String needfav ="1";
String needhelp ="";
String needinputitems="";
boolean isfromtab =  Util.null2String(request.getParameter("isfromtab")).equals("true")?true:false;
int scopeId = 3;
String sql = "";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:edit(this),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:viewWorkInfo(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type=button class="e8_btn_top" onclick="edit(this);" value="<%=SystemEnv.getHtmlLabelName(86, user.getLanguage())%>"></input>
		  <span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<FORM name=resourceworkedit id=resource action="HrmResourceOperation.jsp" method=post >
<input class=inputstyle type=hidden name=operation>
<input class=inputstyle type=hidden name=id value="<%=id%>">
<input class=inputstyle type=hidden name=lanrownum>
<input class=inputstyle type=hidden name=workrownum>
<input class=inputstyle type=hidden name=edurownum>
<input class=inputstyle type=hidden name=trainrownum>
<input class=inputstyle type=hidden name=rewardrownum>
<input class=inputstyle type=hidden name=cerrownum>
<input class=inputstyle type=hidden name=isView value="<%=isView%>">
<input class=inputstyle type=hidden name=isfromtab value="<%=isfromtab%>">
<input class=inputstyle type=hidden name=scopeid value="<%=scopeId%>">
<input class=inputstyle type=hidden id="f_weaver_belongto_userid" name="f_weaver_belongto_userid" value="<%=f_weaver_belongto_userid %>">

<wea:layout type="2col" attributes="{'expandAllGroup':'true'}">
<%
HrmFieldGroupComInfo.setTofirstRow();
HrmFieldManager hfm = new HrmFieldManager("HrmCustomFieldByInfoType",scopeId);
CustomFieldManager cfm = new CustomFieldManager("HrmCustomFieldByInfoType",scopeId);
hfm.getHrmData(Util.getIntValue(id));
cfm.getCustomData(Util.getIntValue(id));
while(HrmFieldGroupComInfo.next()){
	int grouptype = Util.getIntValue(HrmFieldGroupComInfo.getType());
	if(grouptype!=scopeId)continue;
	int grouplabel = Util.getIntValue(HrmFieldGroupComInfo.getLabel());
	int groupid = Util.getIntValue(HrmFieldGroupComInfo.getid());
	hfm.getCustomFields(groupid);
	if(hfm.getGroupCount()==0)continue;
	String groupattr = "{}";
	if(groupid==5 && !HrmListValidate.isValidate(47)){
		groupattr = "{'samePair':'group_"+groupid+"_"+47+"'}";
		lsSamePair.add("group_"+groupid+"_"+47);
	}
	if(groupid!=5 && !HrmListValidate.isValidate(48)){
		groupattr = "{'samePair':'group_"+groupid+"_"+48+"'}";
		lsSamePair.add("group_"+groupid+"_"+48);
	}
	%>
<wea:group context="<%=SystemEnv.getHtmlLabelName(grouplabel,user.getLanguage())%>" attributes="<%=groupattr %>">	
<%
	while(hfm.next()){
		if(!hfm.isUse())continue;
		int fieldlabel=Util.getIntValue(hfm.getLable());
		String fieldName=hfm.getFieldname();
		String fieldValue="";
		if(hfm.isBaseField(fieldName)){
			fieldValue = hfm.getHrmData(fieldName);
			if(hfm.isMand())  needinputitems+= ","+fieldName;
		}else{
			if(hfm.getHtmlType().equals("6") && groupid!=5 && !HrmListValidate.isValidate(48)){
				continue;
			}
			fieldValue = cfm.getData("field"+hfm.getFieldid());
			if(hfm.isMand())  needinputitems+= ",customfield"+hfm.getFieldid();
		}
		JSONObject hrmFieldConf = hfm.getHrmFieldConf(fieldName);
		String attr = "{}";
		if(hfm.getHtmlType().equals("6")){
			//附件上传
    	String[] resourceFile = HrmResourceFile.getResourceFile(""+id, scopeId, hfm.getFieldid());
    	int maxsize = 100;
   	%>
     <wea:item attributes="<%=attr %>"><%=SystemEnv.getHtmlLabelName(fieldlabel,user.getLanguage())%></wea:item>
     <wea:item attributes="<%=attr %>">
      <div id="uploadDiv" name="uploadDiv" maxsize="<%=maxsize%>" resourceId="<%=id%>" scopeId="<%=scopeId %>" fieldId="<%=hfm.getFieldid()%>"></div>
      <div>
        <%=resourceFile[1] %>
      	<input class=inputstyle type="hidden" id="customfield<%=hfm.getFieldid()%>" name="customfield<%=hfm.getFieldid()%>" value="<%=resourceFile[0].equals("")?"":"1" %>" onchange='checkinput("customfield<%=hfm.getFieldid()%>","customfield<%=hfm.getFieldid()%>span");'>
      		<SPAN id="customfield<%=hfm.getFieldid()%>span">
      		<%
							  if(hfm.isMand()&&resourceFile[0].equals("")) {
							%>
							    <IMG src="/images/BacoError_wev8.gif" align=absMiddle>
							<%
							  }
							%>
					</SPAN>
      </div>
     </wea:item>
	<%}else{%>
	<wea:item attributes="<%=attr %>"><%=SystemEnv.getHtmlLabelName(fieldlabel,user.getLanguage())%></wea:item>
	<wea:item attributes="<%=attr %>">
		<%=((HtmlElement)Class.forName(hrmFieldConf.getString("eleclazzname")).newInstance()).getHtmlElementString(fieldValue, hrmFieldConf, user) %>
	</wea:item>
	<%}
	}
%>
</wea:group>
<%} %>
</wea:layout>
      
<!-- tab 测试 -->
<div class="e8_box">
   <ul class="tab_menu">
		<li style='display:<%=HrmListValidate.isValidate(52)?"list-item":"none"%>;'>
        	<a href="javascript:void('0');" onclick="jsChangeTab('lan')" target="_self">
        		<%=SystemEnv.getHtmlLabelName(815,user.getLanguage()) %>
        	</a>
        </li>
        <li style='display:<%=HrmListValidate.isValidate(53)?"list-item":"none"%>;'>
        	<a href="javascript:void('0');" onclick="jsChangeTab('edu')" target="_self">
        		<%=SystemEnv.getHtmlLabelName(813,user.getLanguage()) %>
        	</a>
        </li>
       	<li style='display:<%=HrmListValidate.isValidate(54)?"list-item":"none"%>;'>
        	<a href="javascript:void('0');" onclick="jsChangeTab('work')" target="_self">
        		<%=SystemEnv.getHtmlLabelName(15716,user.getLanguage()) %>
        	</a>
        </li>
        <li style='display:<%=HrmListValidate.isValidate(55)?"list-item":"none"%>;'>
        	<a href="javascript:void('0');" onclick="jsChangeTab('train')" target="_self">
        		<%=SystemEnv.getHtmlLabelName(15717,user.getLanguage()) %>
        	</a>
        </li>
        <li style='display:<%=HrmListValidate.isValidate(56)?"list-item":"none"%>;'>
        	<a href="javascript:void('0');" onclick="jsChangeTab('cer')" target="_self">
        		<%=SystemEnv.getHtmlLabelName(1502,user.getLanguage()) %>
        	</a>
        </li>
        <li style='display:<%=HrmListValidate.isValidate(57)?"list-item":"none"%>;'>
        	<a href="javascript:void('0');" onclick="jsChangeTab('reward')" target="_self">
        		<%=SystemEnv.getHtmlLabelName(15718,user.getLanguage()) %>
        	</a>
        </li>
        <% 
        RecordSet.executeSql("select id, formlabel from cus_treeform where parentid="+scopeId+" order by scopeorder");
        while(RecordSet.next()){
            int subId = RecordSet.getInt("id");
            ht.put(("cus_list_"+subId),RecordSet.getString("formlabel"));
        }
        Iterator iter = ht.entrySet().iterator();
				while (iter.hasNext()){
				Map.Entry entry = (Map.Entry) iter.next();
      	String key = (String)entry.getKey();
     		String val = (String)entry.getValue();
     		%>
     	 <li style='display:<%=HrmListValidate.isValidate(58)?"list-item":"none"%>;'>
        	<a href="javascript:void('0');" onclick="jsChangeTab('<%=key %>')" target="_self"><%=val%></a>
         </li>
     		<%}%>
   </ul>
	    <div id="rightBox" class="e8_rightBox">
	    </div>
	    <div class="tab_box">
<div style="display: <%=HrmListValidate.isValidate(52)?"":"none" %>;">  
<div id="lan" class="lan_groupmain" style="width:100%"></div>
</div>
<script>
var items=[
{width:"16%",colname:"<%=SystemEnv.getHtmlLabelName(231,user.getLanguage())%>",itemhtml:"<input class=inputstyle type=text style='width:100%!important;' name='language'>"},
{width:"16%",colname:"<%=SystemEnv.getHtmlLabelName(15715,user.getLanguage())%>",itemhtml:"<select class=inputstyle style='width:90%!important;' name='level'><option value=0 selected ><%=SystemEnv.getHtmlLabelName(154,user.getLanguage())%></option><option value=1 ><%=SystemEnv.getHtmlLabelName(821,user.getLanguage())%></option><option value=2 ><%=SystemEnv.getHtmlLabelName(822,user.getLanguage())%></option><option value=3 ><%=SystemEnv.getHtmlLabelName(823,user.getLanguage())%></option></select>"},
{width:"63%",tdclass:"desclass",colname:"<%=SystemEnv.getHtmlLabelName(454,user.getLanguage())%>",itemhtml:"<input class=inputstyle type=text style='width:100%' name='memo'>"}];
<%
	sql = "select * from HrmLanguageAbility where resourceid = "+id+" order by id";
	rs.executeSql(sql);
	StringBuffer ajaxData = new StringBuffer();
	ajaxData.append("[");
  while(rs.next()){
		String language = Util.null2String(rs.getString("language"));
		String level = Util.null2String(rs.getString("level_n"));
		String memo = Util.null2String(rs.getString("memo"));
		lanrowindex++;
		ajaxData.append("[{name:\"language\",value:\""+language+"\",iseditable:true,type:\"input\"},");
		ajaxData.append("{name:\"level\",value:\""+level+"\",iseditable:true,type:\"select\"},");
		if(rs.getCounts()==lanrowindex){
			ajaxData.append("{name:\"memo\",value:\""+memo+"\",iseditable:true,type:\"input\"}]");
		}else{
			ajaxData.append("{name:\"memo\",value:\""+memo+"\",iseditable:true,type:\"input\"}],");
		}
  }
  ajaxData.append("]");
  //System.out.println(ajaxData.toString());
%>
var ajaxdata=<%=ajaxData.toString()%>;
lanrowindex = <%=lanrowindex%>;
var option= {
							openindex:true,
              basictitle:"<%=SystemEnv.getHtmlLabelName(815,user.getLanguage())%>",
              toolbarshow:true,
              colItems:items,
              usesimpledata: true,
              container:".lan_groupmain",
              initdatas: ajaxdata,
              addrowCallBack:function(obj,tr,entry) {
								lanrowindex=obj.count;
              },
              copyrowsCallBack:function(obj,tr,entry) {
								lanrowindex=obj.count;
              },
             	configCheckBox:true,
             	checkBoxItem:{"itemhtml":'<input name="check_lan" class="groupselectbox" type="checkbox" >',width:"5%"}
            };
           var group=new WeaverEditTable(option);
           
           //$("#lan").append(group.getContainer());

       </script>
<div style="display: <%=HrmListValidate.isValidate(53)?"":"none" %>;">       
<div id="edu" class="edu_groupmain" style="width:100%"></div>
</div>
<script>
var items=[
{width:"16%",colname:"<%=SystemEnv.getHtmlLabelName(1903,user.getLanguage())%>",itemhtml:"<input class=inputstyle type=text style='width:98%' name='school'>"},
{width:"16%",colname:"<%=SystemEnv.getHtmlLabelName(803,user.getLanguage())%>",itemhtml:"<span class='browser' name='speciality' completeurl='/data.jsp?type=speciality' browserurl='/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/speciality/SpecialityBrowser.jsp' hasInput='true' isSingle='false'></span>"},
{width:"16%",colname:"<%=SystemEnv.getHtmlLabelName(740,user.getLanguage())%>",itemhtml:"<input type='hidden' name='edustartdate' class='wuiDate'>"},
{width:"16%",colname:"<%=SystemEnv.getHtmlLabelName(741,user.getLanguage())%>",itemhtml:"<input type='hidden' name='eduenddate' class='wuiDate'>"},
{width:"16%",colname:"<%=SystemEnv.getHtmlLabelName(818,user.getLanguage())%>",itemhtml:"<span class='browser' name='educationlevel' completeurl='/data.jsp?type=educationlevel' browserurl='/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/educationlevel/EduLevelBrowser.jsp' hasInput='true' isSingle='false'></span>"},
{width:"15%",tdclass:"desclass",colname:"<%=SystemEnv.getHtmlLabelName(1942,user.getLanguage())%>",itemhtml:"<input class=inputstyle type=text style='width:98%' name='studydesc'>"}];
<%
	sql = "select * from HrmEducationInfo where resourceid = "+id+" order by id";
	rs.executeSql(sql);
	ajaxData = new StringBuffer();
	ajaxData.append("[");
  while(rs.next()){
    String startdate = Util.null2String(rs.getString("startdate"));
  	String enddate = Util.null2String(rs.getString("enddate"));
  	String school = Util.null2String(rs.getString("school"));
  	String speciality = Util.null2String(rs.getString("speciality"));
  	String educationlevel = Util.null2String(rs.getString("educationlevel"));
  	String studydesc = Util.null2String(rs.getString("studydesc"));
  	edurowindex++;
		ajaxData.append("[{name:\"school\",value:\""+school+"\",iseditable:true,type:\"input\"},");
		ajaxData.append("{name:\"speciality\",value:\""+speciality+"\",label:\""+SpecialityComInfo.getSpecialityname(speciality)+"\",iseditable:true,type:\"browser\"},");
		ajaxData.append("{name:\"edustartdate\",value:\""+startdate+"\",iseditable:true,type:\"date\"},");
		ajaxData.append("{name:\"eduenddate\",value:\""+enddate+"\",iseditable:true,type:\"date\"},");
		ajaxData.append("{name:\"educationlevel\",value:\""+educationlevel+"\",label:\""+EducationLevelComInfo.getEducationLevelname(educationlevel)+"\",iseditable:true,type:\"browser\"},");
		if(rs.getCounts()==edurowindex){
			ajaxData.append("{name:\"studydesc\",value:\""+studydesc+"\",iseditable:true,type:\"input\"}]");
		}else{
			ajaxData.append("{name:\"studydesc\",value:\""+studydesc+"\",iseditable:true,type:\"input\"}],");
		}
  }
  ajaxData.append("]");
  //System.out.println(ajaxData.toString());
%>
var ajaxdata=<%=ajaxData.toString()%>;
edurowindex = <%=edurowindex%>;
var option= {
							openindex:true,
              basictitle:"<%=SystemEnv.getHtmlLabelName(813,user.getLanguage())%>",
              toolbarshow:true,
              colItems:items,
              usesimpledata: true,
              container:".edu_groupmain",
              initdatas: ajaxdata,
              addrowCallBack:function(obj,tr,entry) {
								edurowindex=obj.count;
              },
              copyrowsCallBack:function(obj,tr,entry) {
								edurowindex=obj.count;
              },
             	configCheckBox:true,
             	checkBoxItem:{"itemhtml":'<input name="check_edu" class="groupselectbox" type="checkbox" >',width:"5%"}
            };
           var group=new WeaverEditTable(option);
           //$("#edu").append(group.getContainer());
       </script>
<div style="display: <%=HrmListValidate.isValidate(54)?"":"none" %>;">       
<div id="work" class="work_groupmain" style="width:100%"></div>
</div>
<script>
var items=[
{width:"16%",colname:"<%=SystemEnv.getHtmlLabelName(1976,user.getLanguage())%>",itemhtml:"<input class=inputstyle type=text  style='width:98%' name='company'>"},
{width:"16%",colname:"<%=SystemEnv.getHtmlLabelName(740,user.getLanguage())%>",itemhtml:"<input type='hidden' name='workstartdate' class='wuiDate'>"},
{width:"16%",colname:"<%=SystemEnv.getHtmlLabelName(741,user.getLanguage())%>",itemhtml:"<input type='hidden' name='workenddate' class='wuiDate'>"},
{width:"16%",colname:"<%=SystemEnv.getHtmlLabelName(1915,user.getLanguage())%>",itemhtml:"<input class=inputstyle type=text style='width:98%' name='jobtitle'>"},
{width:"16%",colname:"<%=SystemEnv.getHtmlLabelName(1977,user.getLanguage())%>",itemhtml:"<input class=inputstyle type=text style='width:98%' name='workdesc'>"},
{width:"15%",tdclass:"desclass",colname:"<%=SystemEnv.getHtmlLabelName(15676,user.getLanguage())%>",itemhtml:"<input class=inputstyle type=text style='width:98%' name='leavereason'>"}];
<%
  sql = "select * from HrmWorkResume where resourceid = "+id+" order by id";
  rs.executeSql(sql);

	ajaxData = new StringBuffer();
	ajaxData.append("[");
  while(rs.next()){
    String startdate = Util.null2String(rs.getString("startdate"));
		String enddate = Util.null2String(rs.getString("enddate"));
		String company = Util.null2String(rs.getString("company"));
		String jobtitle = Util.null2String(rs.getString("jobtitle"));
		String leavereason = Util.null2String(rs.getString("leavereason"));
		String workdesc = Util.null2String(rs.getString("workdesc"));
  	workrowindex++;
		ajaxData.append("[{name:\"company\",value:\""+company+"\",iseditable:true,type:\"input\"},");
		ajaxData.append("{name:\"workstartdate\",value:\""+startdate+"\",iseditable:true,type:\"date\"},");
		ajaxData.append("{name:\"workenddate\",value:\""+enddate+"\",iseditable:true,type:\"date\"},");
		ajaxData.append("{name:\"jobtitle\",value:\""+jobtitle+"\",iseditable:true,type:\"input\"},");
		ajaxData.append("{name:\"workdesc\",value:\""+workdesc+"\",iseditable:true,type:\"input\"},");
		if(rs.getCounts()==workrowindex){
			ajaxData.append("{name:\"leavereason\",value:\""+leavereason+"\",iseditable:true,type:\"input\"}]");
		}else{
			ajaxData.append("{name:\"leavereason\",value:\""+leavereason+"\",iseditable:true,type:\"input\"}],");
		}
  }
  ajaxData.append("]");
  //System.out.println(ajaxData.toString());
%>
var ajaxdata=<%=ajaxData.toString()%>;
workrowindex = <%=workrowindex%>;
var option= {
							openindex:true,
              basictitle:"<%=SystemEnv.getHtmlLabelName(15716,user.getLanguage())%>",
              toolbarshow:true,
              colItems:items,
              usesimpledata: true,
              initdatas: ajaxdata,
              container: ".work_groupmain",
              addrowCallBack:function(obj,tr,entry) {
								workrowindex=obj.count;
              },
              copyrowsCallBack:function(obj,tr,entry) {
								workrowindex=obj.count;
              },
             	configCheckBox:true,
             	checkBoxItem:{"itemhtml":'<input name="check_work" class="groupselectbox" type="checkbox" >',width:"5%"}
            };
           var group=new WeaverEditTable(option);
           //$("#work_groupmain").append(group.getContainer());
       </script>
<div style="display: <%=HrmListValidate.isValidate(55)?"":"none" %>;">       
<div id="train" class="train_groupmain" style="width:100%"></div>
</div>
<script>
var items=[
{width:"16%",colname:"<%=SystemEnv.getHtmlLabelName(15678,user.getLanguage())%>",itemhtml:"<input class=inputstyle type=text  style='width:98%' name='trainname'>"},
{width:"16%",colname:"<%=SystemEnv.getHtmlLabelName(15679,user.getLanguage())%>",itemhtml:"<input type='hidden' name='trainstartdate' class='wuiDate'>"},
{width:"16%",colname:"<%=SystemEnv.getHtmlLabelName(15680,user.getLanguage())%>",itemhtml:"<input type='hidden' name='trainenddate' class='wuiDate'>"},
{width:"16%",colname:"<%=SystemEnv.getHtmlLabelName(1974,user.getLanguage())%>",itemhtml:"<input class=inputstyle type=text style='width:98%' name='trainresource'>"},
{width:"31%",tdclass:"desclass",colname:"<%=SystemEnv.getHtmlLabelName(454,user.getLanguage())%>",itemhtml:"<input class=inputstyle type=text style='width:98%' name='trainmemo'>"}];
<%
	sql = "select * from HrmTrainBeforeWork where resourceid = "+id +" order by id";
	rs.executeSql(sql);

	ajaxData = new StringBuffer();
	ajaxData.append("[");
  while(rs.next()){
    String startdate = Util.null2String(rs.getString("trainstartdate"));
  	String enddate = Util.null2String(rs.getString("trainenddate"));
  	String trainname = Util.null2String(rs.getString("trainname"));
  	String trainresource = Util.null2String(rs.getString("trainresource"));
  	String trainmemo = Util.null2String(rs.getString("trainmemo"));
  	trainrowindex++;
		ajaxData.append("[{name:\"trainname\",value:\""+trainname+"\",iseditable:true,type:\"input\"},");
		ajaxData.append("{name:\"trainstartdate\",value:\""+startdate+"\",iseditable:true,type:\"date\"},");
		ajaxData.append("{name:\"trainenddate\",value:\""+enddate+"\",iseditable:true,type:\"date\"},");
		ajaxData.append("{name:\"trainresource\",value:\""+trainresource+"\",iseditable:true,type:\"input\"},");
		if(rs.getCounts()==trainrowindex){
			ajaxData.append("{name:\"trainmemo\",value:\""+trainmemo+"\",iseditable:true,type:\"input\"}]");
		}else{
			ajaxData.append("{name:\"trainmemo\",value:\""+trainmemo+"\",iseditable:true,type:\"input\"}],");
		}
  }
  ajaxData.append("]");
  //System.out.println(ajaxData.toString());
%>
var ajaxdata=<%=ajaxData.toString()%>;
trainrowindex = <%=trainrowindex%>;
var option= {
							openindex:true,
              basictitle:"<%=SystemEnv.getHtmlLabelName(15717,user.getLanguage())%>",
              toolbarshow:true,
              colItems:items,
              usesimpledata: true,
              initdatas: ajaxdata,
							container:".train_groupmain",
              addrowCallBack:function(obj,tr,entry) {
								trainrowindex=obj.count;
              },
              copyrowsCallBack:function(obj,tr,entry) {
								trainrowindex=obj.count;
              },
             	configCheckBox:true,
             	checkBoxItem:{"itemhtml":'<input name="check_train" class="groupselectbox" type="checkbox" >',width:"5%"}
            };
           var group=new WeaverEditTable(option);
           //$("#train_groupmain").append(group.getContainer());
</script>
<div style="display: <%=HrmListValidate.isValidate(56)?"":"none" %>;">  
<div id="cer" class="cer_groupmain" style="width:100%"></div>
</div>
<script>
var items=[
{width:"16%",colname:"<%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%>",itemhtml:"<input class=inputstyle type=text  style='width:98%' name='cername'>"},
{width:"16%",colname:"<%=SystemEnv.getHtmlLabelName(740,user.getLanguage())%>",itemhtml:"<input type='hidden' name='cerstartdate' class='wuiDate'>"},
{width:"16%",colname:"<%=SystemEnv.getHtmlLabelName(741,user.getLanguage())%>",itemhtml:"<input type='hidden' name='cerenddate' class='wuiDate'>"},
{width:"47%",tdclass:"desclass",colname:"<%=SystemEnv.getHtmlLabelName(15681,user.getLanguage())%>",itemhtml:"<input class=inputstyle type=text style='width:98%' name='cerresource'>"}];
<%
	sql = "select * from HrmCertification where resourceid = "+id+" order by id";
	rs.executeSql(sql);
	ajaxData = new StringBuffer();
	ajaxData.append("[");
	while(rs.next()){
		String startdate = Util.null2String(rs.getString("datefrom"));
		String enddate = Util.null2String(rs.getString("dateto"));
		String cername = Util.null2String(rs.getString("certname"));
		String cerresource = Util.null2String(rs.getString("awardfrom"));
  	cerrowindex++;
		ajaxData.append("[{name:\"cername\",value:\""+cername+"\",iseditable:true,type:\"input\"},");
		ajaxData.append("{name:\"cerstartdate\",value:\""+startdate+"\",iseditable:true,type:\"date\"},");
		ajaxData.append("{name:\"cerenddate\",value:\""+enddate+"\",iseditable:true,type:\"date\"},");
		if(rs.getCounts()==cerrowindex){
			ajaxData.append("{name:\"cerresource\",value:\""+cerresource+"\",iseditable:true,type:\"input\"}]");
		}else{
			ajaxData.append("{name:\"cerresource\",value:\""+cerresource+"\",iseditable:true,type:\"input\"}],");
		}
  }
  ajaxData.append("]");
  //System.out.println(ajaxData.toString());
%>
var ajaxdata=<%=ajaxData.toString()%>;
cerrowindex = <%=cerrowindex%>;
var option= {
							openindex:true,
              basictitle:"<%=SystemEnv.getHtmlLabelName(1502,user.getLanguage())%>",
              toolbarshow:true,
              colItems:items,
              usesimpledata: true,
              initdatas: ajaxdata,
             	container:".cer_groupmain",
              addrowCallBack:function(obj,tr,entry) {
								cerrowindex=obj.count;
              },
              copyrowsCallBack:function(obj,tr,entry) {
								cerrowindex=obj.count;
              },
             	configCheckBox:true,
             	checkBoxItem:{"itemhtml":'<input name="check_train" class="groupselectbox" type="checkbox" >',width:"5%"}
            };
           var group=new WeaverEditTable(option);
           //$("#cer_groupmain").append(group.getContainer()); 
</script>
<div style="display: <%=HrmListValidate.isValidate(57)?"":"none" %>;">  
<div id="reward" class="reward_groupmain" style="width:100%"></div>
</div>
<script>
var items=[
{width:"16%",colname:"<%=SystemEnv.getHtmlLabelName(15666,user.getLanguage())%>",itemhtml:"<input class=inputstyle type=text  style='width:98%' name='rewardname'>"},
{width:"16%",colname:"<%=SystemEnv.getHtmlLabelName(1962,user.getLanguage())%>",itemhtml:"<input type='hidden' name='rewarddate' class='wuiDate'>"},
{width:"63%",tdclass:"desclass",colname:"<%=SystemEnv.getHtmlLabelName(454,user.getLanguage())%>",itemhtml:"<input class=inputstyle type=text style='width:98%' name='rewardmemo'>"}];
<%
	sql = "select * from HrmRewardBeforeWork where resourceid = "+id+" order by id";
	rs.executeSql(sql);
	ajaxData = new StringBuffer();
	ajaxData.append("[");
	while(rs.next()){
		String rewarddate = Util.null2String(rs.getString("rewarddate"));
		String rewardname = Util.null2String(rs.getString("rewardname"));
		String rewardmemo = Util.null2String(rs.getString("rewardmemo"));
		rewardrowindex++;
		ajaxData.append("[{name:\"rewardname\",value:\""+rewardname+"\",iseditable:true,type:\"input\"},");
		ajaxData.append("{name:\"rewarddate\",value:\""+rewarddate+"\",iseditable:true,type:\"date\"},");
		if(rs.getCounts()==rewardrowindex){
			ajaxData.append("{name:\"rewardmemo\",value:\""+rewardmemo+"\",iseditable:true,type:\"input\"}]");
		}else{
			ajaxData.append("{name:\"rewardmemo\",value:\""+rewardmemo+"\",iseditable:true,type:\"input\"}],");
		}
  }
  ajaxData.append("]");
  //System.out.println(ajaxData.toString());
%>
var ajaxdata=<%=ajaxData.toString()%>;
rewardrowindex = <%=rewardrowindex%>;
var option= {
							openindex:true,
              basictitle:"<%=SystemEnv.getHtmlLabelName(15718,user.getLanguage())%>",
              toolbarshow:true,
              colItems:items,
              usesimpledata: true,
              initdatas: ajaxdata,
              container:".reward_groupmain",
              addrowCallBack:function(obj,tr,entry) {
								rewardrowindex=obj.count;
              },
              copyrowsCallBack:function(obj,tr,entry) {
								rewardrowindex=obj.count;
              },
             	configCheckBox:true,
             	checkBoxItem:{"itemhtml":'<input name="check_reward" class="groupselectbox" type="checkbox" >',width:"5%"}
            };
           var group=new WeaverEditTable(option);
           //$("#reward_groupmain").append(group.getContainer()); 
</script>
<%----------------------------自定义明细字段 begin--------------------------------------------%>

	 <%

         RecordSet.executeSql("select id, formlabel from cus_treeform where viewtype='1' and parentid="+scopeId+" order by scopeorder");
         //System.out.println("select id from cus_treeform where parentid="+scopeId);
         int recorderindex = 0 ;
         while(RecordSet.next()){
             recorderindex = 0 ;
             int subId = RecordSet.getInt("id");
             CustomFieldManager cfm2 = new CustomFieldManager("HrmCustomFieldByInfoType",subId);
             cfm2.getCustomFields();
             CustomFieldTreeManager.getMutiCustomData("HrmCustomFieldByInfoType", subId, Util.getIntValue(id,0));
             int colcount1 = cfm2.getSize() ;
             int colwidth1 = 0 ;
             int rowcount = 0;
             while(cfm2.next()){
            	 if(!cfm2.isUse())continue;
            	 rowcount++;
             }
             if(rowcount==0)continue;
             cfm2.beforeFirst();
             if( colcount1 != 0 ) {
                 colwidth1 = 95/colcount1 ;
     %>
<div style="display: <%=HrmListValidate.isValidate(58)?"":"none" %>;">  </div>
    <div id="cus_list_<%=subId%>" class="work_groupmaindemo_<%=subId%>" style="width:100%"></div>

	 <table Class=ListStyle  cellspacing="0" cellpadding="0">
        <tr class="DataLight">
            <td style="text-align: right;" colspan="2" >
            <BUTTON Class=addbtn type="button" accessKey=A onclick="addRow_<%=subId%>()"></BUTTON>
            <BUTTON class=delbtn type="button" accessKey=D onClick="if(isdel()){deleteRow_<%=subId%>();}"></BUTTON>
            </td>
        </tr>
       
        <tr>
            <td colspan=2>

            <table Class=ListStyle id="oTable_<%=subId%>" my_title="<%=RecordSet.getString("formlabel")%>" cellspacing="1" cellpadding="0">
            <COLGROUP>
            <tr class=header>
            <td width="5%">&nbsp;</td>
   <%

       while(cfm2.next()){
      	 if(!cfm2.isUse())continue;
		  String fieldlable =String.valueOf(cfm2.getLable());

   %>
		 <td width="<%=colwidth1%>%" nowrap><%=SystemEnv.getHtmlLabelName(Util.getIntValue(fieldlable),user.getLanguage())%></td>
           <%
	   }
       cfm2.beforeFirst();
%>
</tr>
<%

    boolean isttLight = false;
    while(CustomFieldTreeManager.nextMutiData()){
            isttLight = !isttLight ;
%>
            <TR class='<%=( isttLight ? "datalight" : "datadark" )%>'>
            <td width="5%"><input  type='checkbox' class='groupselectbox InputStyle'  name='check_node_<%=subId%>' value='<%=recorderindex%>'></td>
        <%
        while(cfm2.next()){
        	if(!cfm2.isUse())continue;
            String fieldid=String.valueOf(cfm2.getId());  //字段id
            String ismand=cfm2.isMand()?"1":"0";   //字段是否必须输入
            String fieldhtmltype = String.valueOf(cfm2.getHtmlType());
            String fieldtype=String.valueOf(cfm2.getType());
            String fieldvalue =  Util.null2String(CustomFieldTreeManager.getMutiData("field"+fieldid)) ;
            String dmlurl = cfm2.getDmrUrl();
            
            if(ismand.equals("1"))  needinputitems+= ",customfield"+fieldid+"_"+subId+"_"+recorderindex;
            //如果必须输入,加入必须输入的检查中
%>
            <td class=field nowrap style="TEXT-VALIGN: center">
<%
            if(fieldhtmltype.equals("1")){                          // 单行文本框
                if(fieldtype.equals("1")){                          // 单行文本框中的文本
                    if(ismand.equals("1")) {
%>
                        <input class=InputStyle style="width: 90%!important;" datatype="text" type=text name="customfield<%=fieldid%>_<%=subId%>_<%=recorderindex%>" size=10 value="<%=Util.toScreenToEdit(fieldvalue,user.getLanguage())%>" onChange="checkinput('customfield<%=fieldid%>_<%=subId%>_<%=recorderindex%>','customfield<%=fieldid%>_<%=subId%>_<%=recorderindex%>span')">
                        <span id="customfield<%=fieldid%>_<%=subId%>_<%=recorderindex%>span"><% if(fieldvalue.equals("")){%><img src="/images/BacoError_wev8.gif" align=absmiddle><%}%></span>
<%
                    }else{
%>
                        <input  class=InputStyle style="width: 90%!important;" datatype="text" type=text name="customfield<%=fieldid%>_<%=subId%>_<%=recorderindex%>" value="<%=Util.toScreenToEdit(fieldvalue,user.getLanguage())%>" size=10>
<%
                    }

                }else if(fieldtype.equals("2")){                     // 单行文本框中的整型
                    if(ismand.equals("1")) {
%>
                        <input class=InputStyle style="width: 90%!important;" datatype="int" type=text name="customfield<%=fieldid%>_<%=subId%>_<%=recorderindex%>" size=10 value="<%=fieldvalue%>"
                            onKeyPress="ItemCount_KeyPress()" onBlur="checkinput('customfield<%=fieldid%>_<%=subId%>_<%=recorderindex%>','customfield<%=fieldid%>_<%=subId%>_<%=recorderindex%>span')">
                        <span id="customfield<%=fieldid%>_<%=subId%>_<%=recorderindex%>span"><% if(fieldvalue.equals("")){%><img src="/images/BacoError_wev8.gif" align=absmiddle><%}%></span>
<%
                    }else{
%>
                        <input  class=InputStyle style="width: 90%!important;" datatype="int" type=text name="customfield<%=fieldid%>_<%=subId%>_<%=recorderindex%>" size=10 value="<%=fieldvalue%>" onKeyPress="ItemCount_KeyPress()" onBlur='checkcount1(this)'>
<%
                    }
                }else if(fieldtype.equals("3")){                     // 单行文本框中的浮点型
                    if(ismand.equals("1")) {
%>
                        <input class=InputStyle style="width: 90%!important;" datatype="float" type=text name="customfield<%=fieldid%>_<%=subId%>_<%=recorderindex%>" size=10 value="<%=fieldvalue%>"
                            onKeyPress="ItemNum_KeyPress()" onBlur="checknumber1(this);checkinput('customfield<%=fieldid%>_<%=subId%>_<%=recorderindex%>','customfield<%=fieldid%>_<%=subId%>_<%=recorderindex%>span')">
                        <span id="customfield<%=fieldid%>_<%=subId%>_<%=recorderindex%>span"><% if(fieldvalue.equals("")){%><img src="/images/BacoError_wev8.gif" align=absmiddle><%}%></span>
<%
                    }else{
%>
                        <input class=InputStyle style="width: 90%!important;" datatype="float" type=text name="customfield<%=fieldid%>_<%=subId%>_<%=recorderindex%>" size=10 value="<%=fieldvalue%>" onKeyPress="ItemNum_KeyPress()" onBlur='checknumber1(this)'>
<%
                    }
                }
            }else if(fieldhtmltype.equals("2")){                     // 多行文本框
                if(ismand.equals("1")) {
%>
                    <textarea class=InputStyle name="customfield<%=fieldid%>_<%=subId%>_<%=recorderindex%>"  onChange="checkinput('customfield<%=fieldid%>_<%=subId%>_<%=recorderindex%>','customfield<%=fieldid%>_<%=subId%>_<%=recorderindex%>span')"
                        rows="4" cols="40" style="width:80%" ><%=Util.toScreenToEdit(fieldvalue,user.getLanguage())%></textarea>
                    <span id="customfield<%=fieldid%>_<%=subId%>_<%=recorderindex%>span"><% if(fieldvalue.equals("")){%><img src="/images/BacoError_wev8.gif" align=absmiddle><%}%></span>
<%
                }else{
%>
                    <textarea class=InputStyle name="customfield<%=fieldid%>_<%=subId%>_<%=recorderindex%>" rows="4" cols="40" style="width:80%"><%=Util.toScreenToEdit(fieldvalue,user.getLanguage())%></textarea>
<%
                }
            }else if(fieldhtmltype.equals("3")){                         // 浏览按钮 (涉及workflow_broswerurl表)
                String url=BrowserComInfo.getBrowserurl(fieldtype);     // 浏览按钮弹出页面的url
                String linkurl=BrowserComInfo.getLinkurl(fieldtype);    // 浏览值点击的时候链接的url
                String showname = "";                                   // 新建时候默认值显示的名称
                String showid = "";                                     // 新建时候默认值
        		    if("161".equals(fieldtype) || "162".equals(fieldtype)) {
        		    	url = url + "?type=" + cfm2.getDmrUrl();
        		    	if(!"".equals(fieldvalue)) {
        			    	Browser browser=(Browser) StaticObj.getServiceByFullname(cfm2.getDmrUrl(), Browser.class);
        					try{
        						String[] fieldvalues = fieldvalue.split(",");
        						for(int i = 0;i < fieldvalues.length;i++) {
        	                        BrowserBean bb=browser.searchById(fieldvalues[i]);
        	                        String desc=Util.null2String(bb.getDescription());
        	                        String name=Util.null2String(bb.getName());
        	                        if(!"".equals(showname)) {
        		                        showname += ",";
        	                        }
        	                        showname += name;
        						}
        					}catch (Exception e){}
        		    	}
        		    }

                String newdocid = Util.null2String(request.getParameter("docid"));

                if( fieldtype.equals("37") && !newdocid.equals("")) {
                    if( ! fieldvalue.equals("") ) fieldvalue += "," ;
                    fieldvalue += newdocid ;
                }

                if(fieldtype.equals("2") ||fieldtype.equals("19")){
                  showname=fieldvalue; // 日期时间
                  String classname = "calendar";
                  if(fieldtype.equals("19"))classname = "Clock";
          		%>
                  <button class=<%=classname %> type=button onclick="onShowBrowser('<%=fieldid%>_<%=subId%>_<%=recorderindex%>','<%=url%>','<%=linkurl%>','<%=fieldtype%>','<%=ismand%>')" title="选择"></button>
                  <span id="customfield<%=fieldid%>_<%=subId%>_<%=recorderindex%>span"><%=showname%>
							<%
              if( ismand.equals("1") && fieldvalue.equals("") ){
							%>
                     <img src="/images/BacoError_wev8.gif" align=absmiddle>
							<%
              }
							%>
                  </span> <input type=hidden name="customfield<%=fieldid%>_<%=subId%>_<%=recorderindex%>" value="<%=fieldvalue%>">
              <%    
              }else{
              	if(!fieldvalue.equals("")&& !("161".equals(fieldtype) || "162".equals(fieldtype))) {
                    String tablename=BrowserComInfo.getBrowsertablename(fieldtype); //浏览框对应的表,比如人力资源表
                    String columname=BrowserComInfo.getBrowsercolumname(fieldtype); //浏览框对应的表名称字段
                    String keycolumname=BrowserComInfo.getBrowserkeycolumname(fieldtype);   //浏览框对应的表值字段
                    sql = "";

                    HashMap temRes = new HashMap();
                    
                    if(fieldtype.equals("17")|| fieldtype.equals("18")||fieldtype.equals("27")||fieldtype.equals("37")||fieldtype.equals("56")||fieldtype.equals("57")||fieldtype.equals("65")||fieldtype.equals("168")||fieldtype.equals("194")) {    // 多人力资源,多客户,多会议，多文档
                        sql= "select "+keycolumname+","+columname+" from "+tablename+" where "+keycolumname+" in( "+fieldvalue+")";
                    }
                    else {
                        sql= "select "+keycolumname+","+columname+" from "+tablename+" where "+keycolumname+"="+fieldvalue;
                    }

                    rs.executeSql(sql);
                    while(rs.next()){
                        showid = Util.null2String(rs.getString(1)) ;
                        String tempshowname= Util.toScreen(rs.getString(2),user.getLanguage()) ;
                        if(!linkurl.equals("")&&false)
                        //showname += "<a href='"+linkurl+showid+"'>"+tempshowname+"</a> " ;
                            temRes.put(String.valueOf(showid),"<a href='"+linkurl+showid+"'>"+tempshowname+"</a> ");
                        else{
                            //showname += tempshowname ;
                            temRes.put(String.valueOf(showid),tempshowname);
                        }
                    }
                    StringTokenizer temstk = new StringTokenizer(fieldvalue,",");
                    String temstkvalue = "";
                    while(temstk.hasMoreTokens()){
                        temstkvalue = temstk.nextToken();

                        if(temstkvalue.length()>0&&temRes.get(temstkvalue)!=null){
                        	if(showname.length()>0)showname+=",";
                          showname += temRes.get(temstkvalue);
                        }
                    }

                }
                String fieldname = "customfield"+fieldid+"_"+subId+"_"+recorderindex;
    	          String isSingle = BrowserManager.browIsSingle(""+fieldtype);
    	  		    String completeUrl = "/data.jsp?type="+fieldtype;
    	  		    
    	  				if(fieldtype.equals("161")||fieldtype.equals("162")){
    	  					if(url.endsWith(".jsp")){
    	  						url += "?type="+dmlurl+"|"+fieldvalue+"&mouldID=hrm";
    	  					}else{
    	  						url += "&type="+dmlurl+"|"+fieldvalue+"&mouldID=hrm";
    	  					}
    	  					if(dmlurl!=null){
    	  						completeUrl += "&fielddbtype="+dmlurl;
    	  					}
    	  				}
    	  				if(url.endsWith(".jsp")){
    	  					url+="?selectedids=";
    	  				}else{
    	  					url+="&selectedids=";
    	  				}
    	  				
    	  		    out.println("<span class='browser' name='"+fieldname+"' browserUrl='"+url+"' completeUrl='"+completeUrl+"' linkUrl='"+linkurl+"' isMustInput='1' browserValue='"+fieldvalue+"' browserspanvalue='"+showname+"' hasInput='true' isSingle='"+isSingle+"'></span>") ;
%>
<!-- 
                    <button class=Browser1  type="button" onclick="onShowBrowser('<%=fieldid%>_<%=subId%>_<%=recorderindex%>','<%=url%>','<%=linkurl%>','<%=fieldtype%>','<%=ismand%>')" title="<%=SystemEnv.getHtmlLabelName(33251,user.getLanguage())%>"></button>
                    <span id="customfield<%=fieldid%>_<%=subId%>_<%=recorderindex%>span"><%=showname%>
<%
                if( ismand.equals("1") && fieldvalue.equals("") ){
%>
                       <img src="/images/BacoError_wev8.gif" align=absmiddle>
<%
                }
%>
                    </span> <input type=hidden name="customfield<%=fieldid%>_<%=subId%>_<%=recorderindex%>" value="<%=fieldvalue%>">
                    -->
<%
              }
            }else if(fieldhtmltype.equals("4")) {                    // check框
%>              
                <!--xiaofeng,td1464-->
                <input class=InputStyle type=checkbox value=1 name="customfield<%=fieldid%>_<%=subId%>_<%=recorderindex%>0" <%if(fieldvalue.equals("1")){%> checked <%}%> onclick='changecheckbox(this,customfield<%=fieldid%>_<%=subId%>_<%=recorderindex%>)'>
                <input type= hidden name="customfield<%=fieldid%>_<%=subId%>_<%=recorderindex%>" value="<%=fieldvalue%>">
<%
            }else if(fieldhtmltype.equals("5")){                     // 选择框   select
                cfm2.getSelectItem(cfm2.getId());
%>
                <select class=InputStyle name="customfield<%=fieldid%>_<%=subId%>_<%=recorderindex%>" class=InputStyle>
<%
                while(cfm2.nextSelect()){
%>
                    <option value="<%=cfm2.getSelectValue()%>" <%=cfm2.getSelectValue().equals(fieldvalue)?"selected":""%>><%=cfm2.getSelectName()%>
<%
                }
%>
                </select>
<%
            }
%>
            </td>
<%
        }
        cfm2.beforeFirst();
        recorderindex ++ ;
    }

%>
</tr>

        </table>
        </td>
        </tr>
</table>
<input type='hidden' id=nodesnum_<%=subId%> name=nodesnum_<%=subId%> value="<%=recorderindex%>">

<script>
                function changecheckbox(obj,obj1){
                if(obj.checked)
                obj1.value='1'
                else
                obj1.value='0'
               
                }
</script>

<script language=javascript>
var rowindex_<%=subId%> = <%=recorderindex%> ;
var curindex_<%=subId%> = <%=recorderindex%> ;
function addRow_<%=subId%>(group){
   
    //oRow = oTable_<%=subId%>.insertRow(-1);
 		//oRow.className="DataLight";
 		
 		oRow=document.createElement("tr");
    oCell = oRow.insertCell(-1);
    //oCell.style.height=24;
    //oCell.style.background=getRowBg();


    var sHtml = "<input class='groupselectbox InputStyle' type='checkbox' name='check_node_<%=subId%>' value='"+rowindex_<%=subId%>+"'>";
    oCell.innerHTML = sHtml;

<%
    while(cfm2.next()){ 
    	
    	if(!cfm2.isUse())continue;// 循环开始
        String fieldhtml = "" ;
        String fieldid=String.valueOf(cfm2.getId());  //字段id
        String ismand=cfm2.isMand()?"1":"0";   //字段是否必须输入
        String fieldhtmltype = String.valueOf(cfm2.getHtmlType());
        String fieldtype=String.valueOf(cfm2.getType());

        if(ismand.equals("1"))  needinputitems+= ",customfield"+fieldid+"_"+subId+"_"+recorderindex;
        //如果必须输入,加入必须输入的检查中

        // 下面开始逐行显示字段

        if(fieldhtmltype.equals("1")){                          // 单行文本框
            if(fieldtype.equals("1")){                          // 单行文本框中的文本
                if(ismand.equals("1")) {
                    fieldhtml = "<input class=InputStyle style='width:90%!important;' datatype='text' type=text name='customfield"+fieldid+"_"+subId+"_\"+rowindex_"+subId+"+\"' size=10 onChange='checkinput1(customfield"+fieldid+"_"+subId+"_\"+rowindex_"+subId+"+\",customfield"+fieldid+"_"+subId+"_\"+rowindex_"+subId+"+\"span)'><span id='customfield"+fieldid+"_"+subId+"_\"+rowindex_"+subId+"+\"span'><img src='/images/BacoError_wev8.gif' align=absmiddle></span>" ;
                }else{
                    fieldhtml = "<input class=InputStyle style='width:90%!important;' datatype='text' type=text name='customfield"+fieldid+"_"+subId+"_\"+rowindex_"+subId+"+\"' value='' size=10>";
                }
            }else if(fieldtype.equals("2")){                     // 单行文本框中的整型
                if(ismand.equals("1")) {
                    fieldhtml = "<input class=InputStyle  style='width:90%!important;' datatype='int' type=text name='customfield"+fieldid+"_"+subId+"_\"+rowindex_"+subId+"+\"' size=10 onKeyPress='ItemCount_KeyPress()' onBlur='checkcount1(this);checkinput1(customfield"+fieldid+"_"+subId+"_\"+rowindex_"+subId+"+\",customfield"+fieldid+"_"+subId+"_\"+rowindex_"+subId+"+\"span)'><span id='customfield"+fieldid+"_"+subId+"_\"+rowindex_"+subId+"+\"span'><img src='/images/BacoError_wev8.gif' align=absmiddle></span>" ;
                }else{
                    fieldhtml = "<input class=InputStyle style='width:90%!important;' datatype='int' type=text name='customfield"+fieldid+"_"+subId+"_\"+rowindex_"+subId+"+\"' size=10 onKeyPress='ItemCount_KeyPress()' onBlur='checkcount1(this)'>" ;
                }
            }else if(fieldtype.equals("3")){                     // 单行文本框中的浮点型
                if(ismand.equals("1")) {
                    fieldhtml = "<input class=InputStyle style='width:90%!important;' datatype='float' type=text name='customfield"+fieldid+"_"+subId+"_\"+rowindex_"+subId+"+\"' size=10 onKeyPress='ItemNum_KeyPress()' onBlur='checknumber1(this);checkinput1(customfield"+fieldid+"_"+subId+"_\"+rowindex_"+subId+"+\",customfield"+fieldid+"_"+subId+"_\"+rowindex_"+subId+"+\"span)'><span id='customfield"+fieldid+"_"+subId+"_\"+rowindex_"+subId+"+\"span'><img src='/images/BacoError_wev8.gif' align=absmiddle></span>" ;
                }else{
                    fieldhtml = "<input class=InputStyle style='width:90%!important;' datatype='float' type=text name='customfield"+fieldid+"_"+subId+"_\"+rowindex_"+subId+"+\"' size=10 onKeyPress='ItemNum_KeyPress()' onBlur='checknumber1(this)'>" ;
                }
            }
        }else if(fieldhtmltype.equals("2")){                     // 多行文本框
            if(ismand.equals("1")) {
                fieldhtml = "<textarea class=InputStyle style='width:90%!important;' name='customfield"+fieldid+"_"+subId+"_\"+rowindex_"+subId+"+\"' onChange='checkinput1(customfield"+fieldid+"_"+subId+"_\"+rowindex_"+subId+"+\",customfield"+fieldid+"_"+subId+"_\"+rowindex_"+subId+"+\"span)' rows='4' cols='40' style='width:80%'></textarea><span id='customfield"+fieldid+"_"+subId+"_\"+rowindex_"+subId+"+\"span'><img src='/images/BacoError_wev8.gif' align=absmiddle></span>" ;
            }else{
                fieldhtml = "<textarea class=InputStyle style='width:90%!important;' name='customfield"+fieldid+"_"+subId+"_\"+rowindex_"+subId+"+\"' rows='4' cols='40' style='width:80%'></textarea>" ;
            }
        }else if(fieldhtmltype.equals("3")){                         // 浏览按钮 (涉及workflow_broswerurl表)
					if(fieldtype.equals("2") ||fieldtype.equals("19")){
            String url=BrowserComInfo.getBrowserurl(fieldtype);     // 浏览按钮弹出页面的url
            String linkurl=BrowserComInfo.getLinkurl(fieldtype);    // 浏览值点击的时候链接的url
            String classname = "calendar";
            if(fieldtype.equals("19"))classname = "Clock";
	          fieldhtml = "<button type='button' class='"+classname+"' onclick=onShowBrowser('" + fieldid + "_"+subId+"_\"+rowindex_"+subId+"+\"','" + url + "','" + linkurl + "','" + fieldtype + "','" + ismand + "') title='" + SystemEnv.getHtmlLabelName(172, user.getLanguage()) + "'></button>";
	          fieldhtml += "<input type=hidden name='customfield"+fieldid+"_"+subId+"_\"+rowindex_"+subId+"+\"' value=''><span id='customfield"+fieldid+"_"+subId+"_\"+rowindex_"+subId+"+\"span'>" ;
	          if(ismand.equals("1")) {
	          	fieldhtml += "<img src='/images/BacoError_wev8.gif' align=absmiddle>" ;
	          }
	          fieldhtml += "</span>" ;
         	}else{
        		String fieldname = "customfield"+fieldid+"_"+subId+"_\"+rowindex_"+subId+"+\"";
        		String url=BrowserComInfo.getBrowserurl(fieldtype);     // 浏览按钮弹出页面的url
            String linkurl=BrowserComInfo.getLinkurl(fieldtype);    // 浏览值点击的时候链接的url
            String isSingle = BrowserManager.browIsSingle(""+fieldtype);
            if("161".equals(fieldtype) || "162".equals(fieldtype)) {
    		    	url = url + "?type=" + cfm2.getDmrUrl();
    		    }
            String completeUrl = "/data.jsp?type="+fieldtype;
            /*
            if (!fieldtype.equals("37")) {    //  多文档特殊处理
                fieldhtml = "<button class=Browser type='button' onclick=\\\"onShowBrowser('" + fieldid + "_"+subId+"_\"+rowindex_"+subId+"+\"','" + url + "','" + linkurl + "','" + fieldtype + "','" + ismand + "')\\\" title='" + SystemEnv.getHtmlLabelName(172, user.getLanguage()) + "'></button>";
            } else {                         // 如果是多文档字段,加入新建文档按钮
                fieldhtml = "<button class=AddDoc onclick=\\\"onShowBrowser('" + fieldid + "_"+subId+"_\"+rowindex_"+subId+"+\"','" + url + "','" + linkurl + "','" + fieldtype + "','" + ismand + "')\\\">" + SystemEnv.getHtmlLabelName(611, user.getLanguage()) + "</button>";
            }
            fieldhtml += "<input type=hidden name='customfield"+fieldid+"_"+subId+"_\"+rowindex_"+subId+"+\"' value=''><span id='customfield"+fieldid+"_"+subId+"_\"+rowindex_"+subId+"+\"span'>" ;

            if(ismand.equals("1")) {
                fieldhtml += "<img src='/images/BacoError_wev8.gif' align=absmiddle>" ;
            }
            fieldhtml += "</span>" ;*/
            fieldhtml += "<span class='browser' name='"+fieldname+"' browserUrl='"+url+"' completeUrl='"+completeUrl+"' linkUrl='"+linkurl+"' isMustInput='1' browserspanvalue='' hasInput='true' isSingle='"+isSingle+"'></span>" ;
         	}
        }else if(fieldhtmltype.equals("4")) {                    // check框
            //xiaofeng,td1464
            fieldhtml += "<input class=InputStyle type=checkbox value=1 name='customfield"+fieldid+"_"+subId+"_\"+rowindex_"+subId+"+\"0'  onclick='changecheckbox(this,customfield"+fieldid+"_"+subId+"_\"+rowindex_"+subId+"+\")'" ;
            fieldhtml += ">" ;
            fieldhtml += "<input type=hidden value=0 name='customfield"+fieldid+"_"+subId+"_\"+rowindex_"+subId+"+\"' " ;
            fieldhtml += ">" ;
        }else if(fieldhtmltype.equals("5")){                     // 选择框   select
            fieldhtml += "<select class=InputStyle name='customfield"+fieldid+"_"+subId+"_\"+rowindex_"+subId+"+\"' " ;
            fieldhtml += ">" ;

            // 查询选择框的所有可以选择的值
            cfm2.getSelectItem(cfm2.getId());
            while(cfm2.nextSelect()){
                String tmpselectvalue = Util.null2String(cfm2.getSelectValue());
                String tmpselectname = Util.toScreen(cfm2.getSelectName(),user.getLanguage());
                fieldhtml += "<option value='"+tmpselectvalue+"'>"+tmpselectname+"</option>" ;
            }
            fieldhtml += "</select>" ;
        }                                          // 选择框条件结束 所有条件判定结束
%>
    oCell = oRow.insertCell(-1);
    //oCell.style.height=24;
    //oCell.style.background=getRowBg();
    oCell.className="field";
    
 
    var sHtml = "<%=fieldhtml%>" ;
    oCell.innerHTML = sHtml;
    
<%
    }       // 循环结束
%>
    rowindex_<%=subId%> += 1;
    jQuery("#nodesnum_<%=subId%>").val(rowindex_<%=subId%>) ;
    //jQuery("body").jNice();
    if(group)group.addCustomRow(oRow);
}


function deleteRow_<%=subId%>(){

    len = document.forms[0].elements.length;
    var i=0;
    var rowsum1 = 0;
    for(i=len-1; i >= 0;i--) {
        if (document.forms[0].elements[i].name=='check_node_<%=subId%>')
            rowsum1 += 1;
    }
    for(i=len-1; i >= 0;i--) {
        if (document.forms[0].elements[i].name=='check_node_<%=subId%>'){
            if(document.forms[0].elements[i].checked==true) {
                oTable_<%=subId%>.deleteRow(rowsum1);
				curindex_<%=subId%>--;
            }
            rowsum1 -=1;
        }
    }
}
</script>
<%
             }
%>
<%
         }
%>
<%----------------------------自定义明细字段 end  --------------------------------------------%>
</div>
</div>

</form>

<script type="text/javascript">
jQuery("table[id^='oTable_']").each(function(){
	var tab_index = jQuery(this).attr("id").split("_")[1]; 
	var items=[];
	var cellLen = jQuery(this).find("tr").eq(0).find("td").length;
	var cellWidth = 90/(cellLen-1);
	cellWidth = (Math.round(cellWidth*100)/100).toFixed(0);
	jQuery(this).find("tr").eq(0).find("td").each(function(index){
		if(jQuery.trim(jQuery(this).text())=="")return;
		//if(index==1)
			//items.push({width:"10px",colname:""+jQuery(this).text()+"",itemhtml:""});
		//else	
			items.push({width:cellWidth+"%",colname:""+jQuery(this).text()+"",itemhtml:""});
	});
	var ajaxdata=[];
	var option= {
							openindex:false,
              basictitle:jQuery(this).attr("my_title"),
              toolbarshow:true,
              colItems:items,
              usesimpledata: true,
              initdatas: ajaxdata,
              addrowtitle:"<%=SystemEnv.getHtmlLabelName(83452,user.getLanguage())%>",
              deleterowstitle:"<%=SystemEnv.getHtmlLabelName(83453,user.getLanguage())%>",
              container: ".work_groupmaindemo_"+tab_index,
             	configCheckBox:true,
             	checkBoxItem:{"itemhtml":'<input name="check_work" class="groupselectbox" type="checkbox" >',width:"5%"}
            };
           var group=new WeaverEditTable(option);
           group.getContainer().find(".additem").unbind();
           
           group.getContainer().find(".additem").click(function(){
             window["addRow_"+tab_index](group);
           });
           
          
           
  	//增加行
   	jQuery(this).find("tr").each(function(index){
    if(index==0)return;
		group.addCustomRow(this);
	});   
	jQuery(this).parent().parent().parent().remove();
});
</script>
<script language="JavaScript" src="/js/addRowBg_wev8.js" >
</script>
<script language=javascript>
  function viewBasicInfo(){
    location = "/hrm/resource/HrmResource.jsp?id=<%=id%>";
  }
  function viewPersonalInfo(){
    location = "/hrm/resource/HrmResourcePersonalView.jsp?id=<%=id%>";
  }
  function viewFinanceInfo(){
    location = "/hrm/resource/HrmResourceFinanceView.jsp?id=<%=id%>";
  }
  function viewSystemInfo(){
    location = "/hrm/resource/HrmResourceSystemView.jsp?id=<%=id%>";
  }
 var rowColor="" ;
 edurowindex = <%=edurowindex%>;
function addeduRow(){
	oRow = eduTable.insertRow(-1);
	ncol = jQuery(eduTable).find("tr:nth-child(3)").find("td").length;
    rowColor = getRowBg();
	for(j=0; j<ncol; j++) {
		oCell = oRow.insertCell(-1);
		oCell.style.height=24;
		oCell.style.background= rowColor;
		switch(j) {
			case 0:
                oCell.style.width=10;
				var oDiv = document.createElement("div");
				var sHtml = "<input class=inputstyle type='checkbox'  style='width:100%' name='check_edu' value='0'>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 1:
				var oDiv = document.createElement("div");
				var sHtml = "<input class=inputstyle type=text style='width:100%' name='school_"+edurowindex+"'>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 2:
				oCell.style.width=100;
				var oDiv = document.createElement("div");
				var sHtml = "<INPUT class='wuiBrowser' type=hidden name='speciality_"+edurowindex+"' _url='/systeminfo/BrowserMain.jsp?url=/hrm/speciality/SpecialityBrowser.jsp'>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				jQuery(oDiv).find(".wuiBrowser").modalDialog();
				break;
			case 3:
                oCell.style.width=100;
				var oDiv = document.createElement("div");
				var sHtml = "<BUTTON class=Calendar type='button' id=selectcontractdate onclick='getDate(edustartdatespan_"+edurowindex+" , edustartdate_"+edurowindex+")' > </BUTTON><SPAN id='edustartdatespan_"+edurowindex+"'></SPAN> <input class=inputstyle type=hidden id='edustartdate_"+edurowindex+"' name='edustartdate_"+edurowindex+"'>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
            case 4:
                oCell.style.width=100;
				var oDiv = document.createElement("div");
				var sHtml = "<BUTTON class=Calendar type='button' id=selectcontractdate onclick='getDate(eduenddatespan_"+edurowindex+" , eduenddate_"+edurowindex+")' > </BUTTON><SPAN id='eduenddatespan_"+edurowindex+"'></SPAN> <input class=inputstyle type=hidden id='eduenddate_"+edurowindex+"' name='eduenddate_"+edurowindex+"'>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
		    case 5:
				var oDiv = document.createElement("div");
				var sHtml = "<INPUT class='wuiBrowser' type=hidden name='educationlevel_"+edurowindex+"' _url='/systeminfo/BrowserMain.jsp?url=/hrm/educationlevel/EduLevelBrowser.jsp'>";
<!--				var sHtml = "<select class=InputStyle id=educationlevel style='width:100%' name='educationlevel_"+edurowindex+"'><option value=0 selected ><%=SystemEnv.getHtmlLabelName(811,user.getLanguage())%></option><option value=1 ><%=SystemEnv.getHtmlLabelName(819,user.getLanguage())%></option><option value=2 ><%=SystemEnv.getHtmlLabelName(764,user.getLanguage())%></option><!--<option value=12 ><%=SystemEnv.getHtmlLabelName(2122,user.getLanguage())%></option><option value=13 ><%=SystemEnv.getHtmlLabelName(2123,user.getLanguage())%></option>--><option value=3 ><%=SystemEnv.getHtmlLabelName(820,user.getLanguage())%></option><option value=4 ><%=SystemEnv.getHtmlLabelName(765,user.getLanguage())%></option><option value=5 ><%=SystemEnv.getHtmlLabelName(766,user.getLanguage())%></option><option value=6 ><%=SystemEnv.getHtmlLabelName(767,user.getLanguage())%></option><option value=7 ><%=SystemEnv.getHtmlLabelName(768,user.getLanguage())%></option><option value=8 ><%=SystemEnv.getHtmlLabelName(769,user.getLanguage())%></option><option value=9 >MBA</option><option value=10 >EMBA</option><option value=11 ><%=SystemEnv.getHtmlLabelName(2119,user.getLanguage())%></option></select>"-->
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				jQuery(oDiv).find(".wuiBrowser").modalDialog();
				break;
			case 6:
				var oDiv = document.createElement("div");
				var sHtml = "<input class=inputstyle type=text style='width:100%' name='studydesc_"+edurowindex+"'>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;

		}
	}
	edurowindex = edurowindex*1 +1;
		jQuery("body").jNice();
}
function deleteeduRow1()
{
	len = document.forms[0].elements.length;
	var i=0;
	var rowsum1 = 0 ;
	for(i=len-1; i >= 0;i--) {
		if (document.forms[0].elements[i].name=='check_edu')
			rowsum1 += 1;
	}
	for(i=len-1; i >= 0;i--) {
		if (document.forms[0].elements[i].name=='check_edu'){
			if(document.forms[0].elements[i].checked==true) {
				eduTable.deleteRow(rowsum1+2);
			}
			rowsum1 -=1;
		}

	}
}

workrowindex = <%=workrowindex%>

function addworkRow()
{
	ncol = jQuery(workTable).find("tr:nth-child(3)").find("td").length;
	rowColor = getRowBg();
	oRow = workTable.insertRow(-1);

	for(j=0; j<ncol; j++) {
		oCell = oRow.insertCell(-1);
		oCell.style.height=24;
		oCell.style.background= rowColor;
		switch(j) {
			case 0:
                oCell.style.width="10";
				var oDiv = document.createElement("div");
				var sHtml = "<input class=inputstyle type='checkbox'  style='width:100%' name='check_work' value='0'>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 1:
				//oCell.style.width="20%";
				var oDiv = document.createElement("div");
				var sHtml = "<input class=inputstyle type=text style='width:100%' name='company_"+workrowindex+"'>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 3:
                //oCell.style.width="15%";
				oCell.style.width=100;
				var oDiv = document.createElement("div");
				var sHtml = "<BUTTON class=Calendar type='button' id=selectcontractdate onclick='getDate(workstartdatespan_"+workrowindex+" , workstartdate_"+workrowindex+")' > </BUTTON><SPAN id='workstartdatespan_"+workrowindex+"'></SPAN> <input class=inputstyle type=hidden id='workstartdate_"+workrowindex+"' name='workstartdate_"+workrowindex+"'>";

				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 4:
				//oCell.style.width="12%";
				oCell.style.width=100;
				var oDiv = document.createElement("div");
				var sHtml = "<BUTTON class=Calendar type='button' id=selectcontractdate onclick='getDate(workenddatespan_"+workrowindex+" , workenddate_"+workrowindex+")' > </BUTTON><SPAN id='workenddatespan_"+workrowindex+"'></SPAN> <input class=inputstyle type=hidden id='workenddate_"+workrowindex+"' name='workenddate_"+workrowindex+"'>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
            case 2:
				//oCell.style.width="15%";
				var oDiv = document.createElement("div");
				var sHtml = "<input class=inputstyle type=text style='width:100%' name='jobtitle_"+workrowindex+"'>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
		    case 5:
				//oCell.style.width="20%";
				var oDiv = document.createElement("div");
				var sHtml = "<input class=inputstyle type=text  style='width:100%' name='workdesc_"+workrowindex+"'>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 6:
				//oCell.style.width="15%";
				var oDiv = document.createElement("div");
				var sHtml = "<input class=inputstyle type=text style='width:100%' name='leavereason_"+workrowindex+"'>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
		}
	}
	workrowindex = workrowindex*1 +1;
	jQuery("body").jNice();
}

function deleteworkRow1()
{
	len = document.forms[0].elements.length;
	var i=0;
	var rowsum1 = 0;
	for(i=len-1; i >= 0;i--) {
		if (document.forms[0].elements[i].name=='check_work')
			rowsum1 += 1;
	}
	for(i=len-1; i >= 0;i--) {
		if (document.forms[0].elements[i].name=='check_work'){
			if(document.forms[0].elements[i].checked==true) {
				workTable.deleteRow(rowsum1+2);
			}
			rowsum1 -=1;
		}

	}
}

trainrowindex = <%=trainrowindex%>
function addtrainRow()
{
	ncol = jQuery(trainTable).find("tr:nth-child(3)").find("td").length;
	rowColor = getRowBg();
	oRow = trainTable.insertRow(-1);

	for(j=0; j<ncol; j++) {
		oCell = oRow.insertCell(-1);
		oCell.style.height=24;
		oCell.style.background= rowColor;
		switch(j) {
			case 0:
                oCell.style.width=10;
				var oDiv = document.createElement("div");
				var sHtml = "<input class=inputstyle type='checkbox'  style='width:100%' name='check_train' value='0'>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 1:
				var oDiv = document.createElement("div");
				var sHtml = "<input class=inputstyle type=text style='width:100%' name='trainname_"+trainrowindex+"'>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 2:
                oCell.style.width=100;
				var oDiv = document.createElement("div");
				var sHtml = "<BUTTON class=Calendar type='button' id=selectcontractdate onclick='getDate(trainstartdatespan_"+trainrowindex+" , trainstartdate_"+trainrowindex+")' > </BUTTON><SPAN id='trainstartdatespan_"+trainrowindex+"'></SPAN> <input class=inputstyle type=hidden id='trainstartdate_"+trainrowindex+"' name='trainstartdate_"+trainrowindex+"'>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 3:
                oCell.style.width=100;
				var oDiv = document.createElement("div");
				var sHtml = "<BUTTON class=Calendar type='button' id=selectcontractdate onclick='getDate(trainenddatespan_"+trainrowindex+" , trainenddate_"+trainrowindex+")' > </BUTTON><SPAN id='trainenddatespan_"+trainrowindex+"'></SPAN> <input class=inputstyle type=hidden id='trainenddate_"+trainrowindex+"' name='trainenddate_"+trainrowindex+"'>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
            case 4:
				var oDiv = document.createElement("div");
				var sHtml = "<input class=inputstyle type=text style='width:100%' name='trainresource_"+trainrowindex+"'>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
		    case 5:
				var oDiv = document.createElement("div");
				var sHtml = "<input class=inputstyle type=text style='width:100%' name='trainmemo_"+trainrowindex+"'>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
		}
	}
	trainrowindex = trainrowindex*1 +1;
	jQuery("body").jNice();
}

function deletetrainRow1()
{
	len = document.forms[0].elements.length;
	var i=0;
	var rowsum1 = 0;
	for(i=len-1; i >= 0;i--) {
		if (document.forms[0].elements[i].name=='check_train')
			rowsum1 += 1;
	}
	for(i=len-1; i >= 0;i--) {
		if (document.forms[0].elements[i].name=='check_train'){
			if(document.forms[0].elements[i].checked==true) {
				trainTable.deleteRow(rowsum1+2);
			}
			rowsum1 -=1;
		}

	}
}


cerrowindex = <%=cerrowindex%>
function addcerRow()
{
	ncol = jQuery(cerTable).find("tr:nth-child(3)").find("td").length;
	rowColor = getRowBg();
	oRow = cerTable.insertRow(-1);

	for(j=0; j<ncol; j++) {
		oCell = oRow.insertCell(-1);
		oCell.style.height=24;
		oCell.style.background= rowColor;
		switch(j) {
			case 0:
                oCell.style.width=10;
				var oDiv = document.createElement("div");
				var sHtml = "<input class=inputstyle type='checkbox'  style='width:100%' name='check_cer' value='0'>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 1:
				var oDiv = document.createElement("div");
				var sHtml = "<input class=inputstyle type=text style='width:100%' name='cername_"+cerrowindex+"'>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 2:
                oCell.style.width=100;
				var oDiv = document.createElement("div");
				var sHtml = "<BUTTON class=Calendar type='button' id=selectcontractdate onclick='getDate(cerstartdatespan_"+cerrowindex+" , cerstartdate_"+cerrowindex+")' > </BUTTON><SPAN id='cerstartdatespan_"+cerrowindex+"'></SPAN> <input class=inputstyle type=hidden id='cerstartdate_"+cerrowindex+"' name='cerstartdate_"+cerrowindex+"'>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 3:
                oCell.style.width=100;
				var oDiv = document.createElement("div");
				var sHtml = "<BUTTON class=Calendar type='button' id=selectcontractdate onclick='getDate(cerenddatespan_"+cerrowindex+" , cerenddate_"+cerrowindex+")' > </BUTTON><SPAN id='cerenddatespan_"+cerrowindex+"'></SPAN> <input class=inputstyle type=hidden id='cerenddate_"+cerrowindex+"' name='cerenddate_"+cerrowindex+"'>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
            case 4:
				var oDiv = document.createElement("div");
				var sHtml = "<input class=inputstyle type=text style='width:100%' name='cerresource_"+cerrowindex+"'>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;

		}
	}
	cerrowindex = cerrowindex*1 +1;
	jQuery("body").jNice();
}

function deletecerRow1()
{
	len = document.forms[0].elements.length;
	var i=0;
	var rowsum1 = 0;
	for(i=len-1; i >= 0;i--) {
		if (document.forms[0].elements[i].name=='check_cer')
			rowsum1 += 1;
	}
	for(i=len-1; i >= 0;i--) {
		if (document.forms[0].elements[i].name=='check_cer'){
			if(document.forms[0].elements[i].checked==true) {
				cerTable.deleteRow(rowsum1+2);
			}
			rowsum1 -=1;
		}

	}
}

rewardrowindex = <%=rewardrowindex%>
function addrewardRow()
{
	ncol = jQuery(rewardTable).find("tr:nth-child(3)").find("td").length;
	rowColor = getRowBg();
	oRow = rewardTable.insertRow(-1);

	for(j=0; j<ncol; j++) {
		oCell = oRow.insertCell(-1);
		oCell.style.height=24;
		oCell.style.background= rowColor;
		switch(j) {
            case 0:
                oCell.style.width=10;
				var oDiv = document.createElement("div");
				var sHtml = "<input class=inputstyle type='checkbox'  style='width:100%' name='check_reward' value='0'>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 1:
				var oDiv = document.createElement("div");
				var sHtml = "<input class=inputstyle type=text style='width:100%' name='rewardname_"+rewardrowindex+"'>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 2:
                oCell.style.width=100;
				var oDiv = document.createElement("div");
				var sHtml = "<BUTTON class=Calendar type='button' id=selectcontractdate onclick='getDate(rewarddatespan_"+rewardrowindex+" , rewarddate_"+rewardrowindex+")' > </BUTTON><SPAN id='rewarddatespan_"+rewardrowindex+"'></SPAN> <input class=inputstyle type=hidden id='rewarddate_"+rewardrowindex+"' name='rewarddate_"+rewardrowindex+"'>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 3:
				var oDiv = document.createElement("div");
				var sHtml = "<input class=inputstyle type=text style='width:100%' name='rewardmemo_"+rewardrowindex+"'>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
		}
	}
	rewardrowindex = rewardrowindex*1 +1;
	jQuery("body").jNice();
}

function deleterewardRow1()
{
	len = document.forms[0].elements.length;
	var i=0;
	var rowsum1 = 0;
	for(i=len-1; i >= 0;i--) {
		if (document.forms[0].elements[i].name=='check_reward')
			rowsum1 += 1;
	}
	for(i=len-1; i >= 0;i--) {
		if (document.forms[0].elements[i].name=='check_reward'){
			if(document.forms[0].elements[i].checked==true) {
				rewardTable.deleteRow(rowsum1+2);
			}
			rowsum1 -=1;
		}

	}
}


function addlanRow(){
	oRow = lanTable.insertRow(-1);
	ncol = jQuery(lanTable).find("tr:nth-child(3)").find("td").length;
    rowColor = getRowBg();
	for(j=0; j<ncol; j++) {
		oCell = oRow.insertCell(-1);
		oCell.style.height=24;
		oCell.style.background= rowColor;
		switch(j) {
			case 0:
                oCell.style.width="10";
				var oDiv = document.createElement("div");
				var sHtml = "<input class=inputstyle type='checkbox'  name='check_lan' value='0'  style='width:100%'>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 1:
				var oDiv = document.createElement("div");
				var sHtml = "<input class=inputstyle type=text style='width:100%' name='language_"+lanrowindex+"'>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
		    case 2:
				var oDiv = document.createElement("div");
				var sHtml = "<select class=InputStyle id=level style='width:100%' name='level_"+lanrowindex+"'><option value=0 selected ><%=SystemEnv.getHtmlLabelName(154,user.getLanguage())%></option><option value=1 ><%=SystemEnv.getHtmlLabelName(821,user.getLanguage())%></option><option value=2 ><%=SystemEnv.getHtmlLabelName(822,user.getLanguage())%></option><option value=3 ><%=SystemEnv.getHtmlLabelName(823,user.getLanguage())%></option></select>"
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 3:
				var oDiv = document.createElement("div");
				var sHtml = "<input class=inputstyle type=text style='width:100%' name='memo_"+lanrowindex+"'>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;

		}
	}
	lanrowindex = lanrowindex*1 +1;
	jQuery("body").jNice();
}
function deletelanRow1()
{
	len = document.forms[0].elements.length;
	var i=0;
	var rowsum1 = 0 ;
	for(i=len-1; i >= 0;i--) {
		if (document.forms[0].elements[i].name=='check_lan')
			rowsum1 += 1;
	}
	for(i=len-1; i >= 0;i--) {
		if (document.forms[0].elements[i].name=='check_lan'){
			if(document.forms[0].elements[i].checked==true) {
				lanTable.deleteRow(rowsum1+2);
			}
			rowsum1 -=1;
		}

	}
}

var editbtn = null;
var upfilesnum = 0;
function edit(obj){
	editbtn = obj;
	jQuery("div[name=uploadDiv]").each(function(){
 		var oUploader=window[jQuery(this).attr("oUploaderIndex")];
   	if(oUploader.getStats().files_queued>0){
   		upfilesnum+=oUploader.getStats().files_queued;
   		oUploader.startUpload();
   		}
   });
 	if(upfilesnum==0) doSaveAfterAccUpload();
}

  function doSaveAfterAccUpload(){
	  var checkdate = false;
  	if(document.forms[0].enddate && document.forms[0].startdate)checkdate = true;
    if(checkdate&&document.forms[0].enddate.value != ""&&document.forms[0].startdate.value>document.forms[0].enddate.value){
    window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(16073,user.getLanguage())%>");
    }else{
      if(checkDateValidity()){
        if(check_form(document.resourceworkedit,'<%=needinputitems%>')){
        		 editbtn.disabled = true;
             document.resourceworkedit.lanrownum.value=lanrowindex;
             document.resourceworkedit.edurownum.value=edurowindex;
             document.resourceworkedit.workrownum.value=workrowindex;
             document.resourceworkedit.trainrownum.value=trainrowindex;
             document.resourceworkedit.rewardrownum.value=rewardrowindex;
             document.resourceworkedit.cerrownum.value=cerrowindex;
             document.resourceworkedit.operation.value="editwork";
             document.resourceworkedit.isfromtab.value=<%=isfromtab%>;
             document.resourceworkedit.submit();
        }
       }
    }
  }
  
  
  function viewWorkInfo(){
    location = "/hrm/resource/HrmResourceWorkView.jsp?isfromtab=<%=isfromtab%>&id=<%=id%>&isView=<%=isView%>";
  }

</script>
</td>
</tr>
</TABLE>
</BODY>
</HTML>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
<script type="text/javascript" src="/js/selectDateTime_wev8.js"></script>
<script language="javascript">
function onShowBrowser(id,url,linkurl,type1,ismand){
    spanname = "customfield"+id+"span";
	inputname = "customfield"+id;
	if (type1== 2 || type1 == 19){
		if (type1 == 2){
			onWorkFlowShowDate(spanname,inputname,ismand);
		}else{
			onWorkFlowShowTime(spanname,inputname,ismand);
		}
	}else{
		if (type1 != 17 && type1 != 18 && type1!=27 && type1!=37 && type1!=56 && type1!=57 && type1!=65 && type1!=4 && type1!=167 && type1!=164 && type1!=169 && type1!=170&& type1!=168&&type1!=161&&type1!=162){
			tmpids = jQuery("input[name=customfield"+id+"]").val();
			id1 = window.showModalDialog(url+"?resourceids="+tmpids);
		}else if (type1==4 || type1==167 || type1==164 || type1==169 || type1==170){
            tmpids = jQuery("input[name=customfield"+id+"]").val();
			id1 = window.showModalDialog(url+"?selectedids="+tmpids)
		}else if (type1==37){
            tmpids = jQuery("input[name=customfield"+id+"]").val();
			id1 = window.showModalDialog(url+"?documentids="+tmpids)
		}else if (type1==161||type1==162){
      		tmpids = jQuery("input[name=customfield"+id+"]").val();
			id1 = window.showModalDialog(url+"&selectedids="+tmpids)
		}else{
			tmpids = jQuery("input[name=customfield"+id+"]").val();
			id1 = window.showModalDialog(url+"?resourceids="+tmpids)
		}
		if (id1!=null){
			if (type1 == 17 || type1 == 18 || type1==27 || type1==37 || type1==56 || type1==57 || type1==65|| type1==168){
				if (id1.id!= ""  && id1.id!= "0"){
					ids = id1.id.split(",");
					names =id1.name.split(",");
					sHtml = "";
					id1ids="";
					id1idnum=0;
					for( var i=0;i<ids.length;i++){
						if(ids[i]!=""){
							curid=ids[i];
							curname=names[i];					
							sHtml = sHtml+"<a href="+linkurl+curid+">"+curname+"</a>&nbsp;";
							if(id1idnum==0){
								id1ids=curid;
								id1idnum++;
							}else{
								id1ids=id1ids+","+curid;
								id1idnum++;
							}
						}
					}
					
					jQuery("#customfield"+id+"span").html(sHtml);
					jQuery("input[name=customfield"+id+"]").val(id1ids);					
				}else{
					if (ismand==0){
						jQuery("#customfield"+id+"span").html("");
					}else{
						jQuery("#customfield"+id+"span").html("<img src='/images/BacoError_wev8.gif' align=absmiddle>");
						}
					jQuery("input[name=customfield"+id+"]").val("");
				}
			}else{
			   if  (id1.id!="" && id1.id!= "0"){
			        if (linkurl == ""){
						jQuery("#customfield"+id+"span").html(id1.name);
					}else{
						jQuery("#customfield"+id+"span").html("<a href="+linkurl+id1.id+">"+id1.name+"</a>");
					}
					jQuery("input[name=customfield"+id+"]").val(id1.id);
			   }else{
					if (ismand==0){
						jQuery("#customfield"+id+"span").html("");
					}else{
						jQuery("#customfield"+id+"span").html("<img src='/images/BacoError_wev8.gif' align=absmiddle>");
					}
					jQuery("input[name=customfield"+id+"]").val("");
				}
			}
		}
	}
}

function onShowResourceConditionBrowserBack(e,dialogId,name){
	if (wuiUtil.getJsonValueByIndex(dialogId, 0) != "") {
		var shareTypeValues = wuiUtil.getJsonValueByIndex(dialogId, 0);
		var shareTypeTexts = wuiUtil.getJsonValueByIndex(dialogId, 1);
		var relatedShareIdses = wuiUtil.getJsonValueByIndex(dialogId, 2);
		var relatedShareNameses = wuiUtil.getJsonValueByIndex(dialogId, 3);
		var rolelevelValues = wuiUtil.getJsonValueByIndex(dialogId, 4);
		var rolelevelTexts = wuiUtil.getJsonValueByIndex(dialogId, 5);
		var secLevelValues = wuiUtil.getJsonValueByIndex(dialogId, 6);
		var secLevelTexts = wuiUtil.getJsonValueByIndex(dialogId, 7);
	
		var sHtml = "";
		var fileIdValue = "";
		shareTypeValues = shareTypeValues.substr(1);
		shareTypeTexts = shareTypeTexts.substr(1);
		relatedShareIdses = relatedShareIdses.substr(1);
		relatedShareNameses = relatedShareNameses.substr(1);
		rolelevelValues = rolelevelValues.substr(1);
		rolelevelTexts = rolelevelTexts.substr(1);
		secLevelValues = secLevelValues.substr(1);
		secLevelTexts = secLevelTexts.substr(1);
	
		var shareTypeValueArray = shareTypeValues.split("~");
		var shareTypeTextArray = shareTypeTexts.split("~");
		var relatedShareIdseArray = relatedShareIdses.split("~");
		var relatedShareNameseArray = relatedShareNameses.split("~");
		var rolelevelValueArray = rolelevelValues.split("~");
		var rolelevelTextArray = rolelevelTexts.split("~");
		var secLevelValueArray = secLevelValues.split("~");
		var secLevelTextArray = secLevelTexts.split("~");
		for ( var _i = 0; _i < shareTypeValueArray.length; _i++) {
	
			var shareTypeValue = shareTypeValueArray[_i];
			var shareTypeText = shareTypeTextArray[_i];
			var relatedShareIds = relatedShareIdseArray[_i];
			var relatedShareNames = relatedShareNameseArray[_i];
			var rolelevelValue = rolelevelValueArray[_i];
			var rolelevelText = rolelevelTextArray[_i];
			var secLevelValue = secLevelValueArray[_i];
			var secLevelText = secLevelTextArray[_i];
	
			fileIdValue = fileIdValue + "~" + shareTypeValue + "_"
					+ relatedShareIds + "_" + rolelevelValue + "_"
					+ secLevelValue;

			if (shareTypeValue == "1") {
				sHtml = sHtml + "," + shareTypeText + "("
						+ relatedShareNames + ")";
			} else if (shareTypeValue == "2") {
				sHtml = sHtml
						+ ","
						+ shareTypeText
						+ "("
						+ relatedShareNames
						+ ")"
						+ "<%=SystemEnv.getHtmlLabelName(683, user.getLanguage())%>>="
						+ secLevelValue
						+ "<%=SystemEnv.getHtmlLabelName(18941, user.getLanguage())%>";
			} else if (shareTypeValue == "3") {
				sHtml = sHtml
						+ ","
						+ shareTypeText
						+ "("
						+ relatedShareNames
						+ ")"
						+ "<%=SystemEnv.getHtmlLabelName(683, user.getLanguage())%>>="
						+ secLevelValue
						+ "<%=SystemEnv.getHtmlLabelName(18942, user.getLanguage())%>";
			} else if (shareTypeValue == "4") {
				sHtml = sHtml
						+ ","
						+ shareTypeText
						+ "("
						+ relatedShareNames
						+ ")"
						+ "<%=SystemEnv.getHtmlLabelName(3005, user.getLanguage())%>="
						+ rolelevelText
						+ "  <%=SystemEnv.getHtmlLabelName(683, user.getLanguage())%>>="
						+ secLevelValue
						+ "<%=SystemEnv.getHtmlLabelName(18945, user.getLanguage())%>";
			} else {
				sHtml = sHtml
						+ ","
						+ "<%=SystemEnv.getHtmlLabelName(683, user.getLanguage())%>>="
						+ secLevelValue
						+ "<%=SystemEnv.getHtmlLabelName(18943, user.getLanguage())%>";
			}
		}
				
		sHtml = sHtml.substr(1);
		fileIdValue = fileIdValue.substr(1);

		jQuery("#"+name).val(fileIdValue);
		jQuery("#"+name+"span").html(sHtml);
	}else{
		if (ismand == 0) {
			jQuery("#"+name+"span").html("");
		} else {
			jQuery("#"+name+"span").html("<img src='/images/BacoError.gif' align=absmiddle>");
		}
		jQuery("#"+name).val("");
	}
}

/**
*       oTable ,表对象
*       row,开始的行
*       col1,开始日期的列
*       col2,结束日期的列
*/

function checkTableObjDate(oTable,row,col1,col2){
return "";
        var errorMessage ="";
        console.log(oTable);
        if(oTable.rows.length < row)  return  "";
        var description = oTable.rows.item(0).cells.item(0).innerText;
        var rowIndex = row -1 ;
        for(var i=rowIndex;i<oTable.rows.length;i++){
            var rowObj = oTable.rows[i];
            //alert(description +":" +rowObj.cells.item(col1).children(0).children(1).innerText);
            var startDate = $(rowObj.cells[col1].children[0].children[1]).text();
            var endDate =  $(rowObj.cells[col2].children[0].children[1]).text();
            if(compareDate(startDate,endDate)==1){
                //alert(description+": 第"+(i-rowIndex+1)+"行的\"开始日期\"必须在\"结束日期\"之前！");
                errorMessage = errorMessage + description+": <%=SystemEnv.getHtmlLabelName(15323,user.getLanguage())%>"+(i-rowIndex+1)+"<%=SystemEnv.getHtmlLabelName(83461,user.getLanguage())%>\"<%=SystemEnv.getHtmlLabelName(740,user.getLanguage())%>\"<%=SystemEnv.getHtmlLabelName(83462,user.getLanguage())%>\"<%=SystemEnv.getHtmlLabelName(24980,user.getLanguage())%>\"<%=SystemEnv.getHtmlLabelName(83463,user.getLanguage())%>"+"\n"  ;
            }

        }
        return errorMessage;
}

function checkDateValidity(){
     var isValide = false;
     var eduTableArray = new Array(edu,4,3,4)  ;
     var workTableArray = new Array(work,4,3,4)  ;
     var trainTableArray = new Array(train,4,2,3)  ;
     var cerTableArray = new Array(cer,4,2,3)  ;
     var oTableArray = new Array(eduTableArray,
                                 workTableArray,
                                 trainTableArray,
                                 cerTableArray
                                 );
     var errorMessage ="";
     for(var i=0;i<oTableArray.length;i++){
        var oTable = oTableArray[i][0];
        var row = oTableArray[i][1];
        var col1 = oTableArray[i][2];
        var col2 = oTableArray[i][3];
        var message = checkTableObjDate(oTable,row,col1,col2);
        if(message!="") errorMessage = errorMessage + message;
     }
     if(errorMessage!=""){
        window.top.Dialog.alert(errorMessage);
     }else{
        isValide = true;
     }

     return isValide;
}

/**
 *Author: Charoes Huang
 *compare two date string ,the date format is: yyyy-mm-dd hh:mm
 *return 0 if date1==date2
 *       1 if date1>date2
 *       -1 if date1<date2
*/
function compareDate(date1,date2){
	//format the date format to "mm-dd-yyyy hh:mm"
	var ss1 = date1.split("-",3);
	var ss2 = date2.split("-",3);

	date1 = ss1[1]+"-"+ss1[2]+"-"+ss1[0];
	date2 = ss2[1]+"-"+ss2[2]+"-"+ss2[0];

	var t1,t2;
	t1 = Date.parse(date1);
	t2 = Date.parse(date2);
	if(t1==t2) return 0;
	if(t1>t2) return 1;
	if(t1<t2) return -1;

    return 0;
}
 jQuery(document).ready(function(){
	  //绑定附件上传
	  if(jQuery("div[name=uploadDiv]").length>0)
	  	jQuery("div[name=uploadDiv]").each(function(){
	      bindUploaderDiv($(this),"relatedacc"); 
	    });
	   <%for(int i=0;lsSamePair!=null&&i<lsSamePair.size();i++){%>
		 hideGroup("<%=lsSamePair.get(i)%>");
		 <%}%>
	});

	function filedel(inputname,spanname,fileid){
		jQuery("#file"+fileid).remove();
		//删除附件
		jQuery.ajax({
		type:'post',
		url:'uploaderOperate.jsp',
		data:{"cmd":"delete","fileId":fileid},
		dataType:'text',
		success:function(msg){
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(83472,user.getLanguage())%>");
		},
		error:function(){
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(83473,user.getLanguage())%>");
		}
		});
	}
	
	jQuery(document).ready(function(){
		hideAll();
		jQuery(".tab_menu li").each(function (i) {
	    if (jQuery(this).css('display') == "list-item"){
	    	jQuery(this).find("a").click();
				return false;
	    }
	  });
  })

function hideAll(){
	jQuery("#lan").hide();
	jQuery("#edu").hide();
	jQuery("#work").hide();
	jQuery("#train").hide();
	jQuery("#cer").hide();
	jQuery("#reward").hide();
	<% 
	iter = ht.entrySet().iterator();
	while (iter.hasNext()){
	Map.Entry entry = (Map.Entry) iter.next();
	String key = (String)entry.getKey();
	String val = (String)entry.getValue();
	%>
	jQuery("#<%=key %>").hide();
	<% }%>
}

function jsChangeTab(id){
 hideAll();
 jQuery("#"+id).show();
}
</script>

