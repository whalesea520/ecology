<%
//固定页面头部增加以下代码
weaver.system.CusFormSettingComInfo CusFormSettingComInfo = new weaver.system.CusFormSettingComInfo();
weaver.system.CusFormSetting CusFormSetting= CusFormSettingComInfo.getCusFormSetting("hrm","HrmResourceBase");
if(CusFormSetting!=null){
	if(CusFormSetting.getStatus()==1){
		//原页面
	}else if(CusFormSetting.getStatus()==2){
		//自定义布局页面
		request.getRequestDispatcher("/hrm/resource/HrmResourcePersonalViewNew.jsp").forward(request, response);
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
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="CustomFieldTreeManager" class="weaver.hrm.resource.CustomFieldTreeManager" scope="page" />
<jsp:useBean id="EducationLevelComInfo" class="weaver.hrm.job.EducationLevelComInfo" scope="page" />
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page"/>
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="HrmListValidate" class="weaver.hrm.resource.HrmListValidate" scope="page" />
<jsp:useBean id="HrmResourceFile" class="weaver.hrm.tools.HrmResourceFile" scope="page"/>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<html>
<%
LinkedHashMap ht = new LinkedHashMap();
 String id = request.getParameter("id");
 int hrmid = user.getUID();
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
int scopeId = 1;
String sql = "";
String sqlstatus = "select status from HrmResource where id = "+id;
rs.executeSql(sqlstatus);
rs.next();
int status = rs.getInt("status");
%>
<head>
<%if(isfromtab) {%>
<base target='_blank'/>
<%} %>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
<link rel="stylesheet" href="/css/ecology8/request/seachBody_wev8.css" type="text/css" />
<link rel="stylesheet" href="/css/ecology8/request/hoverBtn_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/hoverBtn_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/request/titleCommon_wev8.js"></script>
<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<link type="text/css" href="/js/tabs/css/e8tabs2_wev8.css" rel="stylesheet" />
<script type="text/javascript">
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
</head>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(367,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(6087,user.getLanguage())+SystemEnv.getHtmlLabelName(87,user.getLanguage());
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
if (id.equals(""+user.getUID()) ){
		isSelf = true;
	}
if(!((isSelf||operatelevel>=0)&&HrmListValidate.isValidate(11))){
	 response.sendRedirect("/notice/noright.jsp") ;
}
%>
<body>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(status != 10&&operatelevel>0){
RCMenu += "{"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+",javascript:edit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(!isfromtab){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:viewBasicInfo(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
}
%>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
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
<%if(!isfromtab){ %>
<TABLE class=Shadow>
<%}else {%>
<TABLE width='100%'>
<%} %>
<tr>
<td valign="top">
<FORM name=resourcepersonalinfo id=resource action="HrmResourceOperation.jsp" method=post >
<wea:layout type="2col">
<%if(HrmListValidate.isValidate(42)){ %>
<wea:group context='<%=SystemEnv.getHtmlLabelName(15687,user.getLanguage())%>'>
 <%
  sql ="select * from HrmResource where id = "+id;
  rs.executeSql(sql);
  while(rs.next()){
    String birthday = Util.null2String(rs.getString("birthday"));
    String folk = Util.null2String(rs.getString("folk"));
    String nativeplace = Util.null2String(rs.getString("nativeplace"));
    String regresidentplace = Util.null2String(rs.getString("regresidentplace"));
    String certificatenum = Util.null2String(rs.getString("certificatenum"));
    String maritalstatus = Util.null2String(rs.getString("maritalstatus"));
    String policy = Util.null2String(rs.getString("policy"));
    String bememberdate = Util.null2String(rs.getString("bememberdate"));
    String bepartydate = Util.null2String(rs.getString("bepartydate"));
    String islabouunion = Util.null2String(rs.getString("islabouunion"));
    String educationlevel = Util.null2String(rs.getString("educationlevel"));
    String degree = Util.null2String(rs.getString("degree"));
    String healthinfo = Util.null2String(rs.getString("healthinfo"));
    String height = Util.null2String(rs.getString("height"));
    String weight = Util.null2String(rs.getString("weight"));
    String residentplace = Util.null2String(rs.getString("residentplace"));
    String homeaddress = Util.null2String(rs.getString("homeaddress"));
    String tempresidentnumber = Util.null2String(rs.getString("tempresidentnumber"));
%>
<wea:item><%=SystemEnv.getHtmlLabelName(464,user.getLanguage())%></wea:item>
<wea:item><%=birthday%></wea:item>
<wea:item><%=SystemEnv.getHtmlLabelName(1886,user.getLanguage())%></wea:item>
<wea:item><%=folk%></wea:item>
<wea:item><%=SystemEnv.getHtmlLabelName(1840,user.getLanguage())%></wea:item>
<wea:item><%=nativeplace%></wea:item>
<wea:item><%=SystemEnv.getHtmlLabelName(15683,user.getLanguage())%></wea:item>
<wea:item><%=regresidentplace%></wea:item>
<wea:item><%=SystemEnv.getHtmlLabelName(1887,user.getLanguage())%></wea:item>
<wea:item><%=certificatenum%></wea:item>
<wea:item><%=SystemEnv.getHtmlLabelName(469,user.getLanguage())%></wea:item>
<wea:item>
<%if(maritalstatus.equals("0")){%><%=SystemEnv.getHtmlLabelName(470,user.getLanguage())%> <%}%>
<%if(maritalstatus.equals("1")){%><%=SystemEnv.getHtmlLabelName(471,user.getLanguage())%> <%}%>
<%if(maritalstatus.equals("2")){%><%=SystemEnv.getHtmlLabelName(472,user.getLanguage())%> <%}%>
</wea:item>
<wea:item><%=SystemEnv.getHtmlLabelName(1837,user.getLanguage())%></wea:item>
<wea:item><%=policy%></wea:item>
<wea:item><%=SystemEnv.getHtmlLabelName(1834,user.getLanguage())%></wea:item>
<wea:item><%=bememberdate%></wea:item>
<wea:item><%=SystemEnv.getHtmlLabelName(1835,user.getLanguage())%></wea:item>
<wea:item><%=bepartydate%></wea:item>
<wea:item><%=SystemEnv.getHtmlLabelName(15684,user.getLanguage())%></wea:item>
<wea:item>
<%if(islabouunion.equals("1")){%><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><%}%>
<%if(islabouunion.equals("0")){%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%>
</wea:item>
 <wea:item><%=SystemEnv.getHtmlLabelName(818,user.getLanguage())%></wea:item>
<wea:item><%=EducationLevelComInfo.getEducationLevelname(educationlevel)%></wea:item>
<wea:item><%=SystemEnv.getHtmlLabelName(1833,user.getLanguage())%></wea:item>
<wea:item><%=degree%></wea:item>
<wea:item><%=SystemEnv.getHtmlLabelName(1827,user.getLanguage())%></wea:item>
<wea:item>
<%if(healthinfo.equals("0")){%><%=SystemEnv.getHtmlLabelName(824,user.getLanguage())%><%}%>
<%if(healthinfo.equals("1")){%><%=SystemEnv.getHtmlLabelName(821,user.getLanguage())%><%}%>
<%if(healthinfo.equals("2")){%><%=SystemEnv.getHtmlLabelName(154,user.getLanguage())%><%}%>
<%if(healthinfo.equals("3")){%><%=SystemEnv.getHtmlLabelName(825,user.getLanguage())%><%}%>
</wea:item>
<wea:item><%=SystemEnv.getHtmlLabelName(1826,user.getLanguage())%></wea:item>
<wea:item><%=height%></wea:item>
<wea:item><%=SystemEnv.getHtmlLabelName(15674,user.getLanguage())%></wea:item>
<wea:item><%=weight%></wea:item>
<wea:item><%=SystemEnv.getHtmlLabelName(1829,user.getLanguage())%></wea:item>
<wea:item><%=residentplace%></wea:item>
<wea:item><%=SystemEnv.getHtmlLabelName(16018,user.getLanguage())%></wea:item>
<wea:item><%=homeaddress%></wea:item>
<wea:item><%=SystemEnv.getHtmlLabelName(15685,user.getLanguage())%></wea:item>
<wea:item><%=tempresidentnumber%></wea:item> 
<%}%>
<%  
    CustomFieldManager cfm = new CustomFieldManager("HrmCustomFieldByInfoType",scopeId);
    cfm.getCustomFields();
    cfm.getCustomData(Util.getIntValue(id,0));
    while(cfm.next()){
    	String fieldvalue = cfm.getData("field"+cfm.getId());
      if(!cfm.isUse())continue;
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

            if(fieldtype.equals("2") ||fieldtype.equals("19")){
                showname=fieldvalue; // 日期时间
            }else if(!fieldvalue.equals("")&& !("161".equals(fieldtype) || "162".equals(fieldtype))) {
                String tablename=BrowserComInfo.getBrowsertablename(fieldtype); //浏览框对应的表,比如人力资源表
                String columname=BrowserComInfo.getBrowsercolumname(fieldtype); //浏览框对应的表名称字段
                String keycolumname=BrowserComInfo.getBrowserkeycolumname(fieldtype);   //浏览框对应的表值字段
                sql = "";

                HashMap temRes = new HashMap();
				//System.out.println(fieldtype+"================>");
                if(fieldtype.equals("152") || fieldtype.equals("17")|| fieldtype.equals("18")||fieldtype.equals("27")||fieldtype.equals("37")||fieldtype.equals("56")||fieldtype.equals("57")||fieldtype.equals("65")||fieldtype.equals("168")||fieldtype.equals("194")) {    // 多人力资源,多客户,多会议，多文档
                    sql= "select "+keycolumname+","+columname+" from "+tablename+" where "+keycolumname+" in( "+fieldvalue+")";
                }
                else {
                    sql= "select "+keycolumname+","+columname+" from "+tablename+" where "+keycolumname+"="+fieldvalue;
                }
				//System.out.println(sql);
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
        <%=Util.toScreen(showname,user.getLanguage())%>
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
       	<%=resourceFile[1]%>
       <%} %>
       </wea:item>
  	<%}%>
  	</wea:group>
 <%} %> 	
  	</wea:layout>
  	<!-- tab 测试 -->
<div class="e8_box">
   <ul class="tab_menu">
   			<%if(HrmListValidate.isValidate(45)){%>
       	<li class="current">
        	<a href="javascript:void('0');" onclick="jsChangeTab('HrmFamilyInfo')" target="_self">
        		<%=SystemEnv.getHtmlLabelName(814,user.getLanguage()) %>
        	</a>
        </li>
        <%} %>
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
     		if(HrmListValidate.isValidate(46)){
     		%>
     		 <li>
        	<a href="javascript:void('0');" onclick="jsChangeTab('<%=key %>')" target="_self"><%=val%></a>
         </li>
     		<% }}%>
   </ul>
	    <div id="rightBox" class="e8_rightBox">
	    </div>
	    <div class="tab_box">
<wea:layout type="2col" attributes="{'expandAllGroup':'true'}">
<%
if(HrmListValidate.isValidate(45)){
  sql = "select * from HrmFamilyInfo where resourceid = "+id;
  rs.executeSql(sql);
%>
<wea:group context='<%=SystemEnv.getHtmlLabelName(814,user.getLanguage())%>' attributes="{'samePair':'HrmFamilyInfo','groupOperDisplay':'none'}">
<wea:item attributes="{'colspan':'2','isTableList':'true'}">
 	<wea:layout type="table" needImportDefaultJsAndCss="false" attributes="{'cols':'5','expandAllGroup':'true'}">
	<wea:group context="" attributes="{'groupDisplay':'none'}">
		<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(431,user.getLanguage())%></wea:item>
		<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(1944,user.getLanguage())%></wea:item>
		<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(1914,user.getLanguage())%></wea:item>
		<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(1915,user.getLanguage())%></wea:item>
		<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(110,user.getLanguage())%></wea:item>
<%
  while(rs.next()){
    String member = Util.null2String(rs.getString("member"));
	String title = Util.null2String(rs.getString("title"));
	String company = Util.null2String(rs.getString("company"));
	String jobtitle = Util.null2String(rs.getString("jobtitle"));
	String address = Util.null2String(rs.getString("address"));
%>
  <wea:item><%=member%></wea:item>
  <wea:item><%=title%></wea:item>
  <wea:item><%=company%></wea:item>
  <wea:item><%=jobtitle%></wea:item>
  <wea:item><%=address%></wea:item>
<%
  }
%>
</wea:group>
</wea:layout>
 	</wea:item>
 </wea:group>
 <%} %>
 <%if(HrmListValidate.isValidate(46)){ %>
<%----------------------------自定义明细字段 begin--------------------------------------------%>

	 <%
         RecordSet.executeSql("select id, formlabel from cus_treeform where parentid="+scopeId+" order by scopeorder");
       
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
                 colwidth1 = 100/colcount1 ;
                 ht.put(("cus_list_"+subId),RecordSet.getString("formlabel"));
                 
                 String attr = "{'samePair':'cus_list_"+subId+"','groupOperDisplay':'none'}";
     %>
<wea:group context='<%=RecordSet.getString("formlabel")%>' attributes="<%=attr %>">
<wea:item attributes="{'isTableList':'true'}">
<%
int col = 0;
while(cfm2.next()){
	if(!cfm2.isUse())continue;
col++;
}
cfm2.beforeFirst();
attr = "{'cols':'"+col+"','layoutTableId':'oTable_"+subId+"','expandAllGroup':'true'}";
%>
 	<wea:layout type="table" needImportDefaultJsAndCss="false" attributes='<%=attr %>'>
	<wea:group context="" attributes="{'groupDisplay':'none'}">
   <%
       while(cfm2.next()){
      	 if(!cfm2.isUse())continue;
		  String fieldlable =String.valueOf(cfm2.getLable());

   %>
		 <wea:item type="thead"><%=SystemEnv.getHtmlLabelName(Util.getIntValue(fieldlable),user.getLanguage())%></wea:item>
           <%
	   }
       cfm2.beforeFirst();

    while(CustomFieldTreeManager.nextMutiData()){
        while(cfm2.next()){
        	if(!cfm2.isUse())continue;
            String fieldid=String.valueOf(cfm2.getId());  //字段id
            String ismand=String.valueOf(cfm2.isMand());   //字段是否必须输入
            String fieldhtmltype = String.valueOf(cfm2.getHtmlType());
            String fieldtype=String.valueOf(cfm2.getType());
            String fieldvalue =  Util.null2String(CustomFieldTreeManager.getMutiData("field"+fieldid)) ;

%>
            <wea:item>
<%
            if(fieldhtmltype.equals("1")||fieldhtmltype.equals("2")){                          // 单行文本框
%>
                <%=Util.toScreenToEdit(fieldvalue,user.getLanguage())%>
<%
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
                }else if(!fieldvalue.equals("") && !("161".equals(fieldtype) || "162".equals(fieldtype))) {
                    String tablename=BrowserComInfo.getBrowsertablename(fieldtype); //浏览框对应的表,比如人力资源表
                    String columname=BrowserComInfo.getBrowsercolumname(fieldtype); //浏览框对应的表名称字段
                    String keycolumname=BrowserComInfo.getBrowserkeycolumname(fieldtype);   //浏览框对应的表值字段
                    sql = "";

                    HashMap temRes = new HashMap();

                    if(fieldtype.equals("17")|| fieldtype.equals("18")||fieldtype.equals("27")||fieldtype.equals("37")||fieldtype.equals("56")||fieldtype.equals("57")||fieldtype.equals("65")||fieldtype.equals("168")) {    // 多人力资源,多客户,多会议，多文档
                        sql= "select "+keycolumname+","+columname+" from "+tablename+" where "+keycolumname+" in( "+fieldvalue+")";
                    }
                    else {
                        sql= "select "+keycolumname+","+columname+" from "+tablename+" where "+keycolumname+"="+fieldvalue;
                    }

                    rs.executeSql(sql);
                    if(isfromtab){}
                   while(rs.next()){
                        showid = Util.null2String(rs.getString(1)) ;
                        String tempshowname= Util.toScreen(rs.getString(2),user.getLanguage()) ;
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
                    <%=showname%>
<%
            }else if(fieldhtmltype.equals("4")) {                    // check框
%>
                <input type=checkbox disabled value=1 name="customfield<%=fieldid%>_<%=subId%>_<%=recorderindex%>" <%if(fieldvalue.equals("1")){%> checked <%}%> >
<%
            }else if(cfm2.getHtmlType().equals("5")){
                cfm2.getSelectItem(cfm2.getId());
                while(cfm2.nextSelect()){
                    if(cfm2.getSelectValue().equals(fieldvalue)){
%>
            <%=cfm2.getSelectName()%>
<%
                        break;
                    }
                }
            }
%>
            </wea:item>
<%
        }
        cfm2.beforeFirst();
        recorderindex ++ ;
    }

%>
</wea:group>
</wea:layout>
</wea:item>
</wea:group>
<%}
             }
%>
<%
         }
%>
<%----------------------------自定义明细字段 end  --------------------------------------------%>
</wea:layout>
	    </div>
	</div>
</td>
   </tr>

   </tbody>
</table>
</form>

 <script language=javascript>
jQuery(document).ready(function(){
hideAll();
jsChangeTab("HrmFamilyInfo");
})

function hideAll(){
hideGroup("HrmFamilyInfo");
	<% 
	iter = ht.entrySet().iterator();
	while (iter.hasNext()){
	Map.Entry entry = (Map.Entry) iter.next();
	String key = (String)entry.getKey();
	String val = (String)entry.getValue();
	%>
	hideGroup("<%=key %>");
	<% }%>
}

function jsChangeTab(id){
 hideAll();
 showGroup(id);
}
  function edit(){
    location = "/hrm/resource/HrmResourcePersonalEdit.jsp?isfromtab=<%=isfromtab%>&id=<%=id%>&isView=<%=isView%>";
  }
  function viewBasicInfo(){
    if(<%=isView%> == 0){
      //location = "/hrm/resource/HrmResourceBasicInfo.jsp?id=<%=id%>";
      location = "/hrm/employee/EmployeeManage.jsp?hrmid=<%=id%>";
    }else{
      location = "/hrm/resource/HrmResource.jsp?id=<%=id%>";
    }
  }
  function viewWorkInfo(){
    location = "/hrm/resource/HrmResourceWorkView.jsp?id=<%=id%>&isView=<%=isView%>";
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
</body>
</html>
