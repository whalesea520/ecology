
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="org.json.JSONObject"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%@ page import="weaver.workflow.browserdatadefinition.ConditionField"%> 
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CompanyVirtualComInfo" class="weaver.hrm.companyvirtual.CompanyVirtualComInfo" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
String show_virtual_org = Util.null2String(request.getParameter("show_virtual_org"));
String f_weaver_belongto_userid=Util.fromScreen(request.getParameter("f_weaver_belongto_userid"),user.getLanguage());
String f_weaver_belongto_usertype=Util.fromScreen(request.getParameter("f_weaver_belongto_usertype"),user.getLanguage());
/***********流程浏览数据定义功能 begin**************/
String bdf_wfid = Util.null2String(request.getParameter("bdf_wfid"));
String bdf_fieldid = Util.null2String(request.getParameter("bdf_fieldid"));
String bdf_viewtype = Util.null2String(request.getParameter("bdf_viewtype"));
String rightStr = Util.null2String(request.getParameter("rightStr"));
String personCmd = Util.null2String(request.getParameter("personCmd"));
String customParam = "&rightStr="+rightStr+"&personCmd="+personCmd;
List<ConditionField> lsConditionField = null;
if(bdf_wfid.length()>0){
	lsConditionField = ConditionField.readAll(Util.getIntValue(bdf_wfid),Util.getIntValue(bdf_fieldid),Util.getIntValue(bdf_viewtype));
}
String wfparam = "";
if(lsConditionField!=null&&lsConditionField.size()>0){
String lastname = Util.null2String(request.getParameter("lastname"));
String status = Util.null2String(request.getParameter("status"));
String subcompanyid = Util.null2String(request.getParameter("subcompanyid"));
String departmentid = Util.null2String(request.getParameter("departmentid"));
String jobtitle = Util.null2String(request.getParameter("jobtitle"));
String roleid = Util.null2String(request.getParameter("roleid"));
String virtualtype = Util.null2String(request.getParameter("virtualtype"));
for(ConditionField conditionField : lsConditionField ){
	boolean isHide = conditionField.isHide();
	//if(isHide)continue;
	String filedname = conditionField.getFieldName();
	String valuetype = conditionField.getValueType();
	boolean isGetValueFromFormField = conditionField.isGetValueFromFormField();
	String filedvalue = "";
	if(isGetValueFromFormField){
		//表单字段 bdf_fieldname
		filedvalue = Util.null2String(request.getParameter("bdf_"+filedname));
		if(filedvalue.length()>0){
			if(filedname.equals("subcompanyid")){
				filedvalue = conditionField.getSubcompanyIds(filedvalue);
			}else if(filedname.equals("departmentid")){
				filedvalue = conditionField.getDepartmentIds(filedvalue);
			}
		}
	}else{
		if(valuetype.equals("1")){
			//当前操作者所属
			if(filedname.equals("subcompanyid")){
				filedvalue = ""+ResourceComInfo.getSubCompanyID(""+user.getUID());
			}else if(filedname.equals("departmentid")){
				filedvalue = ""+ResourceComInfo.getDepartmentID(""+user.getUID());
			}
		}else{
			//指定字段
			if(filedname.equals("virtualtype")){
				filedvalue = conditionField.getValueType();
			}else{
				filedvalue = conditionField.getValue();
			}
		}
	}
	if(filedname.equals("lastname")){
		lastname = filedvalue;
	}else if(filedname.equals("status")){
		status = filedvalue;
		if(status.equals("8"))status="";
	}else if(filedname.equals("subcompanyid")){
		subcompanyid = filedvalue;
	}else if(filedname.equals("departmentid")){
		departmentid = filedvalue;
	}else if(filedname.equals("jobtitle")){
		jobtitle = filedvalue;
	}else if(filedname.equals("roleid")){
		roleid = filedvalue;
	}else if(filedname.equals("virtualtype")){
		virtualtype = filedvalue;
	}else if(filedname.equals("rightStr")){
		rightStr = filedvalue;
	}
	
	if(lastname.length()>0){
		wfparam = "lastname="+lastname+"";
	}
	
	if(status.length()>0 && !status.equals("8")){
		if(wfparam.length()>0)wfparam+=" and ";
		wfparam += "status="+status;
	}
	
	if(subcompanyid.length()>0){
		if(wfparam.length()>0)wfparam+=" and ";
		wfparam += "subcompanyid in ("+subcompanyid+")";
	}
	
	if(departmentid.length()>0){
		if(wfparam.length()>0)wfparam+=" and ";
		wfparam += "departmentid in ("+departmentid+")";
	}
	
	if(jobtitle.length()>0){
		if(wfparam.length()>0)wfparam+=" and ";
		wfparam += "jobtitle="+jobtitle;
	}
	
	if(roleid.length()>0){
		if(wfparam.length()>0)wfparam+=" and ";
		wfparam += "roleid="+roleid;
	}
	
	if(virtualtype.length()>0){
		if(wfparam.length()>0)wfparam+=" and ";
		wfparam += "virtualtype="+valuetype;
	}
}
wfparam = "&lastname="+lastname+"&status="+status+"&subcompanyid="+subcompanyid
+ "&departmentid="+departmentid+"&jobtitle="+jobtitle+"&roleid="+roleid+"&virtualtype="+virtualtype+"&isinit=1";
//System.out.println("wfparam=="+wfparam);
}
/***********流程浏览数据定义功能 end **************/

String selectedids=Util.null2String(request.getParameter("selectedids"));//selectedids 支持分部 部门 共组混合形式
String resourceids=Util.null2String(request.getParameter("resourceids"));
if(selectedids.length()==0)selectedids=resourceids;
//selectedids= "744,subcom_31,group_18";
String isNoAccount=Util.null2String(request.getParameter("isNoAccount"));
String alllevel=Util.null2String(request.getParameter("alllevel"),"1");

String moduleManageDetach=Util.null2String(request.getParameter("moduleManageDetach"));//(模块管理分权-分权管理员专用)
//页面传过来的自定义组id
String workflow = Util.null2String(request.getParameter("workflow"));
String initgroupid=Util.null2String(request.getParameter("groupid"));
String coworkid=Util.null2String(request.getParameter("coworkid"));
String workID = Util.null2String(request.getParameter("workID"));
String cowtypeid = Util.null2String(request.getParameter("cowtypeid"));
String sqlwhere=Util.null2String(request.getParameter("sqlwhere"));
String status=Util.null2String(request.getParameter("status"));
String newmail = Util.null2String(request.getParameter("newmail"));
String managerid = Util.null2String(request.getParameter("managerid"));
String fromHrmStatusChange = Util.null2String(request.getParameter("fromHrmStatusChange"));

int uid=user.getUID();
String MutiResourceBrowser=(String)session.getAttribute("MutiResourceBrowser");
if(MutiResourceBrowser==null){
	Cookie[] cks = request.getCookies();
	for (int i = 0; i < cks.length; i++) {
	  if (cks[i].getName().equals("MutiResourceBrowser" + uid)) {
	  	MutiResourceBrowser = cks[i].getValue();
	  	break;
	  }
	}
}
String tabid="0";
if(MutiResourceBrowser!=null&&MutiResourceBrowser.length()>0){
	String[] atts=Util.TokenizerString2(MutiResourceBrowser,"|");
	tabid=atts[0];
}
if(tabid.equals("0")){
	//如果最近使用为空，定位到同部门
	rs.executeSql("select count(*) from HrmResourceSelectRecord where resourceid ="+user.getUID());
	if(rs.next()){
		if(rs.getInt(1)==0) tabid="1";
	}
}
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
</HEAD>
<body scroll="no">
<input id="selectedids" name="selectedids" type="hidden" value="<%=selectedids%>">
<input id="isNoAccount" name="isNoAccount" type="hidden" value="<%=isNoAccount%>">
<input id="alllevel" name="alllevel" type="hidden" value="<%=alllevel%>">
<input id="tabchange" name="tabchange" type="hidden" value="0">
	<div class="e8_box demo2">
	<div class="e8_boxhead">
		<div class="div_e8_xtree" id="div_e8_xtree"></div>
        <div class="e8_tablogo" id="e8_tablogo"></div>
		<div class="e8_ultab">
			<div class="e8_navtab" id="e8_navtab">
				<span id="objName"></span>
			</div>
			<div>
			    <ul class="tab_menu">
			    	<li class="<%=tabid.equals("0")?"current":"" %>">
			        	<a id="tabId0" href="javascript:resetbanner(0);">
			        		<%=SystemEnv.getHtmlLabelName(24515,user.getLanguage())%><!-- 最近 --> 
			        	</a>
			      </li>
			      <li class="<%=tabid.equals("1")?"current":"" %>">
			        	<a id="tabId1" href="javascript:resetbanner(1);">
			        		<%=SystemEnv.getHtmlLabelName(18511,user.getLanguage())%><!-- 同部门 --> 
			        	</a>
			      </li>
			     	<li class="<%=tabid.equals("2")?"current":"" %>">
			        	<a id="tabId2" href="javascript:resetbanner(2);">
			        		<%=SystemEnv.getHtmlLabelName(15089,user.getLanguage())%><!-- 我的下属 --> 
			        	</a>
			      </li>
		    		<li class="<%=tabid.equals("3")?"current":"" %>">
			        	<a id="tabId3" href="javascript:resetbanner(3);">
			        		<%=SystemEnv.getHtmlLabelName(18770,user.getLanguage())%><!-- 按组织结构 --> 
			        	</a>
			      </li>
			      <li class="<%=tabid.equals("4")?"current":"" %>">
			        	<a id="tabId4" href="javascript:resetbanner(4);">
			        		<%=SystemEnv.getHtmlLabelName(81554,user.getLanguage())%><!-- 常用组 --> 
			        	</a>
				      <%
				  		boolean hasSuggest = false;
				  		String sql = "SELECT COUNT(1) from SysPoppupRemindInfoNew where type=25 and exists(select t2.id from HrmGroupSuggest t2 where t2.id=SysPoppupRemindInfoNew.requestid and status=0 ) ";
				  		if(user.getUID()==1){
				  			//管理员能看所有的
				  		}else{
				  			sql += " AND userid= "+user.getUID();
				  		}
				  		rs.executeSql(sql);
				  		if(rs.next()){
				  			if(rs.getInt(1)>0)hasSuggest = true;
				  		}
				  		boolean cansave = HrmUserVarify.checkUserRight("CustomGroup:Edit", user);
				      if(cansave){
								if(hasSuggest){	
							%>
							<img src="/hrm/group/icon/remind.png" title="<%=SystemEnv.getHtmlLabelName(126253, user.getLanguage()) %>" style="vertical-align: middle;padding-left: 5px;margin-bottom: -5px;" onclick="javascript:doRemind(0);">
							<%}else{%>
							<img src="/hrm/group/icon/remind1.png" title="<%=SystemEnv.getHtmlLabelName(126253, user.getLanguage()) %>" style="vertical-align: middle;padding-left: 5px;margin-bottom: -5px;" onclick="javascript:doRemind(1);">		
							<%}} %>
			      </li>
			    </ul>
			    <div id="rightBox" class="e8_rightBox">
			    </div>
			</div>
		</div>
	</div>
	    <div class="tab_box">
        <div>
        		<IFRAME name=frame1 id=frame1 width="100%" onload="" height="160px" frameborder=no scrolling=no></IFRAME>
        </div>
	    </div>
	</div>
<script type="text/javascript">
jQuery('.e8_box').Tabs({
	getLine:1,
	iframe:"frame1",
  mouldID:"<%=MouldIDConst.getID("hrm") %>",
  objName:<%=JSONObject.quote(SystemEnv.getHtmlLabelName(33210, user.getLanguage())) %>,
	staticOnLoad:true
});


var tabid = null;
var timeout1 = null;
function resetbanner(objid){
	clearTimeout(timeout1);
 	timeout1 = setTimeout(function(){
	  jQuery(".magic-line").show();
		tabid = objid;
		
		var selectedids = jQuery("#selectedids").val();
		var isNoAccount = jQuery("#isNoAccount").val();
		var alllevel = jQuery("#alllevel").val();
		var oldtabid = jQuery("#frame1").contents().find("input[name='tabid']").val();
		//if(oldtabid&&tabid!=oldtabid){
			//if(tabid==2)
				//alllevel=0;
			//else
				//alllevel=1;	
		//}
		$('.tab_menu').find('.current').removeClass('current');
		$('#tabId'+objid).parent('li').addClass('current');
		
		if(tabid==0){
			document.getElementById("frame1").src = "/social/im/newChatWin/SocialIMNewMultiSelect.jsp?show_virtual_org=<%=show_virtual_org%>&f_weaver_belongto_userid=<%=f_weaver_belongto_userid %>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>&tabid="+tabid+"&selectedids="+selectedids+"&sqlwhere=<%=xssUtil.put(sqlwhere)%>&status=<%=status%>&fromHrmStatusChange=<%=fromHrmStatusChange%>&isNoAccount="+isNoAccount+"&alllevel="+alllevel+"&managerid=<%=managerid%>&workflow=<%=workflow%>&bdf_wfid=<%=bdf_wfid%>&bdf_fieldid=<%=bdf_fieldid%>&bdf_viewtype=<%=bdf_viewtype%>&wfparam=<%=wfparam %><%=customParam%>";
		}else if(tabid==1){
			document.getElementById("frame1").src = "/social/im/newChatWin/SocialIMNewMultiSelect.jsp?show_virtual_org=<%=show_virtual_org%>&f_weaver_belongto_userid=<%=f_weaver_belongto_userid %>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>&tabid="+tabid+"&selectedids="+selectedids+"&sqlwhere=<%=xssUtil.put(sqlwhere)%>&status=<%=status%>&fromHrmStatusChange=<%=fromHrmStatusChange%>&isNoAccount="+isNoAccount+"&alllevel="+alllevel+"&managerid=<%=managerid%>&workflow=<%=workflow%>&bdf_wfid=<%=bdf_wfid%>&bdf_fieldid=<%=bdf_fieldid%>&bdf_viewtype=<%=bdf_viewtype%>&wfparam=<%=wfparam %><%=customParam%>";
		}else if(tabid==2){
			document.getElementById("frame1").src = "/social/im/newChatWin/SocialIMNewMultiSelect.jsp?show_virtual_org=<%=show_virtual_org%>&f_weaver_belongto_userid=<%=f_weaver_belongto_userid %>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>&tabid="+tabid+"&selectedids="+selectedids+"&sqlwhere=<%=xssUtil.put(sqlwhere)%>&status=<%=status%>&fromHrmStatusChange=<%=fromHrmStatusChange%>&isNoAccount="+isNoAccount+"&alllevel="+alllevel+"&managerid=<%=managerid%>&workflow=<%=workflow%>&bdf_wfid=<%=bdf_wfid%>&bdf_fieldid=<%=bdf_fieldid%>&bdf_viewtype=<%=bdf_viewtype%>&wfparam=<%=wfparam %><%=customParam%>";
		}else if(tabid==3){
			document.getElementById("frame1").src = "/social/im/newChatWin/SocialIMNewMultiSelect.jsp?show_virtual_org=<%=show_virtual_org%>&f_weaver_belongto_userid=<%=f_weaver_belongto_userid %>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>&tabid="+tabid+"&selectedids="+selectedids+"&sqlwhere=<%=xssUtil.put(sqlwhere)%>&status=<%=status%>&fromHrmStatusChange=<%=fromHrmStatusChange%>&isNoAccount="+isNoAccount+"&alllevel="+alllevel+"&managerid=<%=managerid%>&workflow=<%=workflow%>&bdf_wfid=<%=bdf_wfid%>&bdf_fieldid=<%=bdf_fieldid%>&bdf_viewtype=<%=bdf_viewtype%>&wfparam=<%=wfparam %><%=customParam%>";
		}else if(tabid==4){
			document.getElementById("frame1").src = "/social/im/newChatWin/SocialIMNewMultiSelect.jsp?show_virtual_org=<%=show_virtual_org%>&f_weaver_belongto_userid=<%=f_weaver_belongto_userid %>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>&tabid="+tabid+"&selectedids="+selectedids+"&sqlwhere=<%=xssUtil.put(sqlwhere)%>&status=<%=status%>&fromHrmStatusChange=<%=fromHrmStatusChange%>&isNoAccount="+isNoAccount+"&alllevel="+alllevel+"&managerid=<%=managerid%>&workflow=<%=workflow%>&bdf_wfid=<%=bdf_wfid%>&bdf_fieldid=<%=bdf_fieldid%>&bdf_viewtype=<%=bdf_viewtype%>&wfparam=<%=wfparam %><%=customParam%>";
		}
	},400);
}

function onCancel(){
	try{
		var win = window.Electron.currentWindow;
		win.close();
	}catch(ex1){}

}

function doClose(){
	try{
		var win = window.Electron.currentWindow;
        win.close();
	}catch(ex1){}
}


			
function doRemind(status){
	doOpen("/hrm/HrmDialogTab.jsp?_fromURL=hrmGroup&method=HrmGroupSuggestList&status="+status+"&isdialog=1","<%=SystemEnv.getHtmlLabelName(126253,user.getLanguage())%>",900,450);
}
resetbanner(<%=tabid%>);
</script>
</body>
</html>