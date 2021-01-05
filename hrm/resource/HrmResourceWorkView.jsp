<%
//固定页面头部增加以下代码
weaver.system.CusFormSettingComInfo CusFormSettingComInfo = new weaver.system.CusFormSettingComInfo();
weaver.system.CusFormSetting CusFormSetting= CusFormSettingComInfo.getCusFormSetting("hrm","HrmResourceBase");
if(CusFormSetting!=null){
	if(CusFormSetting.getStatus()==1){
		//原页面
	}else if(CusFormSetting.getStatus()==2){
		//自定义布局页面
		request.getRequestDispatcher("/hrm/resource/HrmResourceWorkViewNew.jsp").forward(request, response);
		return;
	}else if(CusFormSetting.getStatus()==3){
		//自定义页面
		String page_url = CusFormSetting.getPage_url();
		request.getRequestDispatcher(page_url).forward(request, response);
		return;
	}
}
%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util,weaver.docs.docs.CustomFieldManager" %>
<%@ page import="weaver.interfaces.workflow.browser.Browser" %>
<%@ page import="weaver.interfaces.workflow.browser.BrowserBean" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="dateUtil" class="weaver.common.DateUtil" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page" />
<jsp:useBean id="UseKindComInfo" class="weaver.hrm.job.UseKindComInfo" scope="page" />
<jsp:useBean id="SpecialityComInfo" class="weaver.hrm.job.SpecialityComInfo" scope="page" />
<jsp:useBean id="EducationLevelComInfo" class="weaver.hrm.job.EducationLevelComInfo" scope="page" />
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page"/>
<jsp:useBean id="CustomFieldTreeManager" class="weaver.hrm.resource.CustomFieldTreeManager" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="AllManagers" class="weaver.hrm.resource.AllManagers" scope="page"/>
<jsp:useBean id="HrmListValidate" class="weaver.hrm.resource.HrmListValidate" scope="page" />
<jsp:useBean id="HrmResourceFile" class="weaver.hrm.tools.HrmResourceFile" scope="page"/>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<HTML>
<%
LinkedHashMap ht = new LinkedHashMap();
 Calendar todaycal = Calendar.getInstance ();
  String today = Util.add0(todaycal.get(Calendar.YEAR), 4) +"-"+
                 Util.add0(todaycal.get(Calendar.MONTH) + 1, 2) +"-"+
                 Util.add0(todaycal.get(Calendar.DAY_OF_MONTH) , 2) ;
 String id = request.getParameter("id");
 int hrmid = user.getUID();
 AllManagers.getAll(id);
 int isView = Util.getIntValue(request.getParameter("isView"));

 int departmentid = user.getUserDepartment();

 boolean isfromtab =  Util.null2String(request.getParameter("isfromtab")).equals("true")?true:false;
 
 boolean ism = ResourceComInfo.isManager(hrmid,id);
 boolean iss = ResourceComInfo.isSysInfoView(hrmid,id);
 boolean isf = ResourceComInfo.isFinInfoView(hrmid,id);
 boolean isc = ResourceComInfo.isCapInfoView(hrmid,id);
// boolean iscre = ResourceComInfo.isCreaterOfResource(hrmid,id);
 boolean ishe = (hrmid == Util.getIntValue(id));
// boolean ishr = (HrmUserVarify.checkUserRight("HrmResourceEdit:Edit",user,departmentid));

  int scopeId = 3;
  String sql = "";
  sql = "select * from HrmResource where id = "+id;
  rs.executeSql(sql);
  rs.next();
    String probationenddate = Util.null2String(rs.getString("probationenddate"));
    String workstartdate = Util.null2String(rs.getString("startdate"));
    String workenddate = Util.null2String(rs.getString("enddate"));
    String usekind = Util.null2String(rs.getString("usekind"));
    int status = rs.getInt("status");

%>
<HEAD>
<%if(isfromtab) {%>
<base target='_blank'/>
<%} %>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
<link type="text/css" href="/js/tabs/css/e8tabs6_wev8.css" rel="stylesheet" />
<link rel="stylesheet" href="/css/ecology8/request/searchInput_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/searchInput_wev8.js"></script>
<script language=javascript src="/js/ecology8/hrm/HrmSearchInit_wev8.js"></script>
<link rel="stylesheet" href="/css/ecology8/request/seachBody_wev8.css" type="text/css" />
<link rel="stylesheet" href="/css/ecology8/request/hoverBtn_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/hoverBtn_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/request/titleCommon_wev8.js"></script>
<script type="text/javascript">

function onBtnSearchClick(){
	jQuery("#searchfrm").submit();
}
</script>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(367,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(380,user.getLanguage())+SystemEnv.getHtmlLabelName(87,user.getLanguage());
String needfav ="1";
String needhelp ="";

int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
int hrmdetachable=Util.getIntValue(String.valueOf(session.getAttribute("hrmdetachable")),0);
int operatelevel=-1;
if(hrmdetachable==1){
    String deptid=ResourceComInfo.getDepartmentID(id);
    String subcompanyid=DepartmentComInfo.getSubcompanyid1(deptid)  ;
    operatelevel=CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"HrmResourceEdit:Edit",Util.getIntValue(subcompanyid));
}else{
    if(HrmUserVarify.checkUserRight("HrmResourceEdit:Edit", user))
        operatelevel=2;
}
boolean isSelf		=	false;
boolean isManager	=	false;
if (id.equals(""+user.getUID()) ){
		isSelf = true;
	}
while(AllManagers.next()){
	String tempmanagerid = AllManagers.getManagerID();
	if (tempmanagerid.equals(""+user.getUID())) {
		isManager = true;
	}
}
if(!((isSelf||isManager||operatelevel>=0)&&HrmListValidate.isValidate(12))){
	response.sendRedirect("/notice/noright.jsp") ;
}
%>
<BODY>


<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(status != 10&&operatelevel>0){
RCMenu += "{"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+",javascript:edit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(dateUtil.dayDiff(today,probationenddate)==3||dateUtil.dayDiff(today,workenddate)==3){
RCMenu += "{"+SystemEnv.getHtmlLabelName(15781,user.getLanguage())+",javascript:info(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(!isfromtab){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:viewBasicInfo(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
}
%>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<form action="" name="searchfrm" id="searchfrm">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<%if(status != 10&&operatelevel>0){ %>
				<input type=button class="e8_btn_top" onclick="edit();" value="<%=SystemEnv.getHtmlLabelName(93, user.getLanguage())%>"></input>
			<%}%>
		  <span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
</form>
<%if(!isfromtab){ %>
<TABLE class=Shadow>
<%}else{ %>
<TABLE width='100%'>
<%} %>
<tr>
<td valign="top">

<FORM name=resourceworkinfo id=resourceworkinfo action="HrmResourceOperation.jsp" method=post >
<%if(HrmListValidate.isValidate(47)){ %>
<wea:layout type="2col">
<wea:group context='<%=SystemEnv.getHtmlLabelName(15688,user.getLanguage())%>'>
<wea:item><%=SystemEnv.getHtmlLabelName(804,user.getLanguage())%></wea:item>
<wea:item><%=UseKindComInfo.getUseKindname(usekind)%></wea:item>
<wea:item><%=SystemEnv.getHtmlLabelName(1970,user.getLanguage())%></wea:item>
<wea:item><%=workstartdate%></wea:item>
<wea:item><%=SystemEnv.getHtmlLabelName(15778,user.getLanguage())%></wea:item>
<wea:item>
	<%=probationenddate%>
	<input class=inputstyle type="hidden" name="probationenddate" value="<%=probationenddate%>">
</wea:item>
<wea:item><%=SystemEnv.getHtmlLabelName(15236,user.getLanguage())%></wea:item>
<wea:item>
	<%=workenddate%>
	<input class=inputstyle type="hidden" name="enddate" value="<%=workenddate%>">
</wea:item>
<%
    CustomFieldManager cfm = new CustomFieldManager("HrmCustomFieldByInfoType",scopeId);
    cfm.getCustomFields();
    cfm.getCustomData(Util.getIntValue(id,0));
    while(cfm.next()){
      	if(!cfm.isUse())continue;
        String fieldvalue = cfm.getData("field"+cfm.getId());
%>
      <wea:item> <%=SystemEnv.getHtmlLabelNames(cfm.getLable(),user.getLanguage())%> </wea:item>
      <wea:item>
      <%
        if(cfm.getHtmlType().equals("1")||cfm.getHtmlType().equals("2")){
      %>
      <%=fieldvalue%>
      <%
        }else if(cfm.getHtmlType().equals("3")){

        String fieldtype = String.valueOf(cfm.getType());
		    String url=BrowserComInfo.getBrowserurl(fieldtype);     // 浏览按钮弹出页面的url
		    String linkurl=BrowserComInfo.getLinkurl(fieldtype);    // 浏览值点击的时候链接的url
		    String showname = "";                                   // 新建时候默认值显示的名称
		    String showid = "";                                     // 新建时候默认值
		    if("161".equals(fieldtype) || "162".equals(fieldtype)) {
		    	url = url + "?type=" + cfm.getDmrUrl();
		    	if(!"".equals(fieldvalue)) {
			    	Browser browser=(Browser) StaticObj.getServiceByFullname(cfm.getDmrUrl(), Browser.class);
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
			if(fieldtype.equals("152")||fieldtype.equals("16")) linkurl = "/workflow/request/ViewRequest.jsp?requestid=";


            if(fieldtype.equals("2") ||fieldtype.equals("19")){
                showname=fieldvalue; // 日期时间
            }else if(!fieldvalue.equals("")&& !("161".equals(fieldtype) || "162".equals(fieldtype))) {
                String tablename=BrowserComInfo.getBrowsertablename(fieldtype); //浏览框对应的表,比如人力资源表
                String columname=BrowserComInfo.getBrowsercolumname(fieldtype); //浏览框对应的表名称字段
                String keycolumname=BrowserComInfo.getBrowserkeycolumname(fieldtype);   //浏览框对应的表值字段
                sql = "";

                HashMap temRes = new HashMap();

                if(fieldtype.equals("17")|| fieldtype.equals("18")||fieldtype.equals("27")||fieldtype.equals("37")||fieldtype.equals("56")||fieldtype.equals("57")||fieldtype.equals("65")||fieldtype.equals("168")||fieldtype.equals("194")) {    // 多人力资源,多客户,多会议，多文档
                    sql= "select "+keycolumname+","+columname+" from "+tablename+" where "+keycolumname+" in( "+fieldvalue+")";
                }
                else if(fieldtype.equals("152")){
					if(fieldvalue.equals("")) fieldvalue = "-1";
					else fieldvalue = "-1" + fieldvalue;
                	sql= "select "+keycolumname+","+columname+" from "+tablename+" where "+keycolumname+" in ("+fieldvalue+")";
                }
                else {
                    sql= "select "+keycolumname+","+columname+" from "+tablename+" where "+keycolumname+"="+fieldvalue;
                }

                RecordSet.executeSql(sql);
                while(RecordSet.next()){
                    showid = Util.null2String(RecordSet.getString(1)) ;
                    String tempshowname= Util.toScreen(RecordSet.getString(2),user.getLanguage()) ;
                    if(!linkurl.equals(""))
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
                        showname += temRes.get(temstkvalue);
                    }
                }

            }
      %>
        <span id="customfield<%=cfm.getId()%>span"><%=Util.toScreen(showname,user.getLanguage())%></span>
       <%
        }else if(cfm.getHtmlType().equals("4")){
       %>
        <input type=checkbox value=1 name="customfield<%=cfm.getId()%>" <%=fieldvalue.equals("1")?"checked":""%> disabled >
       <%
        }else if(cfm.getHtmlType().equals("5")){
            cfm.getSelectItem(cfm.getId());
       %>
       <%
            while(cfm.nextSelect()){
                if(cfm.getSelectValue().equals(fieldvalue)){
       %>
            <%=cfm.getSelectName()%>
       <%
                    break;
                }
            }
       %>
       <%
        }else if(cfm.getHtmlType().equals("6")){
        	String[] resourceFile = HrmResourceFile.getResourceFileView(id, scopeId, cfm.getId());
       %>
       	<span id="customfield<%=cfm.getId()%>span"><%=resourceFile[1]%></span>
       <%} %>
        </wea:item>
      <%}%>
      </wea:group>
      </wea:layout>
      <%} %>
<!-- tab 测试 -->

<jsp:include page="/hrm/resource/HrmResourceWorkViewNew_head.jsp" />

<input class=inputstyle type=hidden name=operation>
<input class=inputstyle type=hidden name=id value="<%=id%>">
</form>
</td>
</tr>
</TABLE>
<script language=javascript>

  function edit(){
    location = "/hrm/resource/HrmResourceWorkEdit.jsp?isfromtab=<%=isfromtab%>&id=<%=id%>&isView=<%=isView%>";
  }
  function info(){
    if(confirm("<%=SystemEnv.getHtmlLabelName(15782,user.getLanguage())%>")){
         document.resourceworkinfo.operation.value="info";
	 document.resourceworkinfo.submit();
    }
  }
  function viewBasicInfo(){
    if(<%=isView%> == 0){
      //location = "/hrm/resource/HrmResourceBasicInfo.jsp?id=<%=id%>";
      location = "/hrm/employee/EmployeeManage.jsp?hrmid=<%=id%>";
    }else{
      location = "/hrm/resource/HrmResource.jsp?id=<%=id%>";
    }
  }
  function viewPersonalInfo(){
    location = "/hrm/resource/HrmResourcePersonalView.jsp?id=<%=id%>&isView=<%=isView%>";
  }
  function viewFinanceInfo(){
    location = "/hrm/resource/HrmResourceFinanceView.jsp?id=<%=id%>&isView=<%=isView%>";
  }
  function viewSystemInfo(){
    location = "/hrm/resource/HrmResourceSystemView.jsp?id=<%=id%>&isView=<%=isView%>";
  }
  function viewCapitalInfo(){
    location = "/cpt/search/CptMyCapital.jsp?id=<%=id%>";
  }
</script>
</BODY>
</HTML>

