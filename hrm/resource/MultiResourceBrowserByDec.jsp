
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="org.json.JSONObject"%>
<%@ page import="weaver.workflow.browserdatadefinition.ConditionField"%> 
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />

<%
String f_weaver_belongto_userid=Util.fromScreen(request.getParameter("f_weaver_belongto_userid"),user.getLanguage());
String f_weaver_belongto_usertype=Util.fromScreen(request.getParameter("f_weaver_belongto_usertype"),user.getLanguage());
/***********流程浏览数据定义功能 begin**************/
String bdf_wfid = Util.null2String(request.getParameter("bdf_wfid"));
String bdf_fieldid = Util.null2String(request.getParameter("bdf_fieldid"));
String bdf_viewtype = Util.null2String(request.getParameter("bdf_viewtype"));
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
			filedvalue = Util.TokenizerString2(filedvalue,",")[0];
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
			filedvalue = conditionField.getValue();
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
	}
}
wfparam = "&lastname="+lastname+"&status="+status+"&subcompanyid="+subcompanyid
				+ "&departmentid="+departmentid+"&jobtitle="+jobtitle+"&roleid="+roleid+"&isinit=1";
//System.out.println(wfparam);
}
/***********流程浏览数据定义功能 end **************/

String selectedids=Util.null2String(request.getParameter("selectedids"));
    //页面传过来的自定义组id
String initgroupid=Util.null2String(request.getParameter("groupid"));
String coworkid=Util.null2String(request.getParameter("coworkid"));

String sqlwhere=Util.null2String(request.getParameter("sqlwhere"));
String status=Util.null2String(request.getParameter("status"));
int uid=user.getUID();
int beagenter = Util.getIntValue((String)session.getAttribute("beagenter_"+user.getUID()));
if(beagenter <= 0){
	beagenter = uid;
}
String isruledesign = Util.null2String(request.getParameter("isruledesign"));
//判断是否是管理员
boolean isadmin = false;
String adminsql = "select * from HrmResourceManager where id = " + beagenter;
RecordSet.executeSql(adminsql);
if(RecordSet.next()){
	isadmin = true;
}

if(isadmin && "true".equals(isruledesign)){
	beagenter = 1;
}

String resourcesingle=(String)session.getAttribute("decresourcemulti");
if(resourcesingle==null){
Cookie[] cks= request.getCookies();

for(int i=0;i<cks.length;i++){
//System.out.println("ck:"+cks[i].getName()+":"+cks[i].getValue());
if(cks[i].getName().equals("decresourcemulti"+uid)){
resourcesingle=cks[i].getValue();
break;
}
}
}
String tabid="0";
if(resourcesingle!=null&&resourcesingle.length()>0){
String[] atts=Util.TokenizerString2(resourcesingle,"|");
tabid=atts[0];
}

int fieldid=Util.getIntValue(request.getParameter("fieldid"));
    int isdetail=Util.getIntValue(request.getParameter("isdetail"));
    int isbill=Util.getIntValue(request.getParameter("isbill"),1);
    boolean onlyselfdept=CheckSubCompanyRight.getDecentralizationAttr(beagenter,"Resources:decentralization",fieldid,isdetail,isbill);
    boolean isall=CheckSubCompanyRight.getIsall();
    String departments=CheckSubCompanyRight.getDepartmentids();
    String subcompanyids=CheckSubCompanyRight.getSubcompanyids();
    if(!isall){
    	 if(!isall){
         if(onlyselfdept){
         		if(departments.length()>0&&!departments.equals("0")){
             	sqlwhere=" where departmentid in("+departments+")";
         		}
         }else{
         		if(subcompanyids.length()>0&&!subcompanyids.equals("0")){
         			sqlwhere=" where subcompanyid1 in("+subcompanyids+")";
         		}
         }
     }
    }
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
</HEAD>
<body>
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
			        		<%=SystemEnv.getHtmlLabelName(18770,user.getLanguage())%><!-- 按组织结构 --> 
			        	</a>
			      </li>
			      <li class="<%=tabid.equals("1")?"current":"" %>">
			        	<a id="tabId1" href="javascript:resetbanner(1);">
			        		<%=SystemEnv.getHtmlLabelName(18771,user.getLanguage())%><!-- 按定义的组 --> 
			        	</a>
			      </li>
		    		<li class="<%=tabid.equals("2")?"current":"" %>">
			        	<a id="tabId2" href="javascript:resetbanner(2);">
			        		<%=SystemEnv.getHtmlLabelName(18412,user.getLanguage())%><!-- 组合查询 --> 
			        	</a>
			      </li>
			    </ul>
			    <div id="rightBox" class="e8_rightBox">
			    </div>
			</div>
		</div>
	</div>
	    <div class="tab_box">
        <div style="height: 100%;">
        		<IFRAME name=frame1 id=frame1 width="100%" onload="update();" height="30%" frameborder=no scrolling=no>
						<%=SystemEnv.getHtmlLabelName(15017, user.getLanguage())%></IFRAME>
            <iframe  id="frame2" name="frame2" class="flowFrame" src="/hrm/resource/MultiSelectByDec.jsp?f_weaver_belongto_userid=<%=f_weaver_belongto_userid %>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>&tabid=<%=tabid %>&selectedids=<%=selectedids%>&initgroupid=<%=initgroupid%>&coworkid=<%=coworkid%>&isdetail=<%=isdetail %>&isbill=<%=isbill %>&fieldid=<%=fieldid %>&detachable=1&sqlwhere=<%=xssUtil.put(sqlwhere)%><%=wfparam %>" frameborder="0" height="60%" width="100%"></iframe>
        </div>
	    </div>
	</div>
<script language=javascript>
	var tabid = null;
	function resetbanner(objid){
		tabid=objid;
		if(tabid == 0 ){		        
    	document.getElementById("frame1").src="/hrm/resource/SearchByOrganByDec.jsp?onlyselfdept=<%=onlyselfdept%>&isdetail=<%=isdetail %>&isbill=<%=isbill %>&fieldid=<%=fieldid %>&detachable=1&sqlwhere=<%=xssUtil.put(sqlwhere)%>&departments=<%=departments%>&subcompanyids=<%=subcompanyids%>&isall=<%=isall%>&bdf_wfid=<%=bdf_wfid%>&bdf_fieldid=<%=bdf_fieldid%>&bdf_viewtype=<%=bdf_viewtype%>&selectedids=<%=selectedids%>&f_weaver_belongto_userid=<%=f_weaver_belongto_userid %>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>&isruledesign=<%=isruledesign%>";
    }else if(tabid == 1){
			document.getElementById("frame1").src="/hrm/resource/SearchByGroupByDec.jsp?sqlwhere=<%=xssUtil.put(sqlwhere)%>&bdf_wfid=<%=bdf_wfid%>&bdf_fieldid=<%=bdf_fieldid%>&bdf_viewtype=<%=bdf_viewtype%>&selectedids=<%=selectedids%>&f_weaver_belongto_userid=<%=f_weaver_belongto_userid %>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>";
		}else if(tabid == 2){
			document.getElementById("frame1").src="/hrm/resource/SearchByDec.jsp?status=<%=status%>&isdetail=<%=isdetail %>&isbill=<%=isbill %>&fieldid=<%=fieldid %>&detachable=1&sqlwhere=<%=xssUtil.put(sqlwhere)%>&bdf_wfid=<%=bdf_wfid%>&bdf_fieldid=<%=bdf_fieldid%>&bdf_viewtype=<%=bdf_viewtype%><%=wfparam%>&selectedids=<%=selectedids%>&f_weaver_belongto_userid=<%=f_weaver_belongto_userid %>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>";
		}
	}

	function closeWindow(){
		window.parent.close();
	}
	resetbanner(<%=tabid%>);
	
	jQuery('.e8_box').Tabs({
	getLine:1,
	iframe:"frame1",
	needNotCalHeight:true,
	//contentID:"#frame1",
  mouldID:"<%=MouldIDConst.getID("hrm") %>",
  objName:<%=JSONObject.quote(SystemEnv.getHtmlLabelName(33210, user.getLanguage())) %>,
	staticOnLoad:true
});
</script>

</body>
</html>