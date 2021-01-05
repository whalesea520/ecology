<%@page import="weaver.general.browserData.BrowserManager"%>
<%@page import="weaver.proj.search.SearchComInfo"%>
<%@page import="weaver.proj.util.SQLUtil"%>
<%@page import="weaver.proj.util.PropUtil"%>
<%@page import="weaver.cpt.util.html.HtmlElement"%>
<%@page import="java.util.Map.Entry"%>
<%@page import="org.json.JSONObject"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="weaver.proj.Maint.*"%>

<jsp:useBean id="AllManagers" class="weaver.hrm.resource.AllManagers" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="RecordSetV" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="ProjectStatusComInfo" class="weaver.proj.Maint.ProjectStatusComInfo" scope="page" />
<jsp:useBean id="ProjectTypeComInfo" class="weaver.proj.Maint.ProjectTypeComInfo" scope="page" />
<jsp:useBean id="WorkTypeComInfo" class="weaver.proj.Maint.WorkTypeComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="CptFieldComInfo" class="weaver.proj.util.PrjFieldComInfo" scope="page"/>
<jsp:useBean id="CptFieldManager" class="weaver.proj.util.PrjFieldManager" scope="page"/>
<%
//后退不会网页过期
response.setHeader("cache-control", "cache");
response.setHeader("pragma", "cache");

if(!HrmUserVarify.checkUserRight("EditProject:Delete",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<SCRIPT language="javascript" src="/proj/js/common_wev8.js"></script>
<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>
<script language=javascript src="/proj/js/myobserver_wev8.js"></script>
    
</HEAD>

<%
String src = Util.null2String(request.getParameter("src"));//不同的标签页
String paraid = Util.null2String(request.getParameter("paraid"));//项目类型
if(!"prjmonitorsearchcondition".equalsIgnoreCase(src)&&"".equals(paraid)){
	response.sendRedirect("/system/systemmonitor/proj/PrjMonitorSearchCondition.jsp") ;
	return ;
}
String nameQuery1 = Util.null2String(request.getParameter("flowTitle"));
String nameQuery = Util.null2String(request.getParameter("nameQuery"));
String worktype = Util.null2String(request.getParameter("WorkType"));
String prjid = Util.null2String(request.getParameter("prjid"));//项目编码
String procode = Util.null2String(request.getParameter("procode"));//项目编码
String planbegindate = Util.null2String(request.getParameter("planbegindate"));
String planbegindate1 = Util.null2String(request.getParameter("planbegindate1"));
String planenddate = Util.null2String(request.getParameter("planenddate"));
String planenddate1 = Util.null2String(request.getParameter("planenddate1"));
String actualbegindate = Util.null2String(request.getParameter("actualbegindate"));
String actualbegindate1 = Util.null2String(request.getParameter("actualbegindate1"));
String finish = Util.null2String(request.getParameter("finish"));
String finish1 = Util.null2String(request.getParameter("finish1"));
String prjstatus = Util.null2String(request.getParameter("prjstatus"));
String prjname = Util.null2String(request.getParameter("prjname"));
String manager = Util.null2String(request.getParameter("manager"));
String member = Util.null2String(request.getParameter("member"));//项目成员
String managerdept = Util.null2String(request.getParameter("managerdept"));
String managersubcom = Util.null2String(request.getParameter("managersubcom"));
String parentprj = Util.null2String(request.getParameter("parentprj"));
String crm = Util.null2String(request.getParameter("crm"));

    Date newdate = new Date() ;
    long datetime = newdate.getTime() ;
    Timestamp timestamp = new Timestamp(datetime) ;
    String CurrentDate = (timestamp.toString()).substring(0,4) + "-" + (timestamp.toString()).substring(5,7) + "-" +(timestamp.toString()).substring(8,10);
    String CurrentTime = (timestamp.toString()).substring(11,13) + ":" + (timestamp.toString()).substring(14,16) + ":" +(timestamp.toString()).substring(17,19);


    String imagefilename = "/images/hdReport_wev8.gif";
    String titlename = "";
    String needfav ="1";
    String needhelp ="";

    String pageId=Util.null2String(PropUtil.getPageId("prj_projmonitortab"));
%>

<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>


<%
//RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:document.weaver.submit(),_top} " ;
//RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(32136,user.getLanguage())+",javascript:batchDel(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",javascript:onLog(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

StringBuffer cusSql=new StringBuffer();//自定义字段条件
%>


<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<form name="weaver" id="weaver" method="post"  action="">
<input type="hidden" name="pageId" id="pageId" value="<%=pageId  %>" />
<input type="hidden" name="src" value="<%=src %>" >
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName( 32136 ,user.getLanguage()) %>" class="e8_btn_top"  onclick="batchDel()"/>
			<input type="text" class="searchInput" name="flowTitle" value="<%=nameQuery1 %>" />
			<span id="advancedSearch" class="advancedSearch" style="display:'';"><%=SystemEnv.getHtmlLabelNames("347",user.getLanguage())%></span>
			<span title="<%=SystemEnv.getHtmlLabelNames("23036",user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>		
<div class="advancedSearchDiv" id="advancedSearchDiv" >
<wea:layout type="4col">
	<wea:group context='<%=SystemEnv.getHtmlLabelNames("32905",user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelNames("1353",user.getLanguage())%></wea:item>
		<wea:item><input class="InputStyle" name="prjname" id="prjname" value='<%=prjname %>'></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelNames("17852",user.getLanguage())%></wea:item>
		<wea:item><input class="InputStyle" name="procode" id="procode" value='<%=procode %>'></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelNames("586",user.getLanguage())%></wea:item>
		<wea:item>
			<Select class="InputStyle" name="paraid">
				<option value=""><%=SystemEnv.getHtmlLabelNames("332",user.getLanguage())%></option>
				<%while(ProjectTypeComInfo .next()){%>
					<option value="<%=ProjectTypeComInfo.getProjectTypeid()%>"
					<%if(paraid.equals(ProjectTypeComInfo.getProjectTypeid ())){%> selected <%}%>
					>
					<%=ProjectTypeComInfo.getProjectTypename ()%></option>
				<%}%>
			</Select>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(432,user.getLanguage())%></wea:item>
		<wea:item>
			<Select class="InputStyle" name="WorkType">
				<option value=""></option>
				<%while(WorkTypeComInfo.next()){%>
					<option value="<%=WorkTypeComInfo.getWorkTypeid()%>"
					<%if(worktype.equals(WorkTypeComInfo.getWorkTypeid())){%> selected="true"<%}%>
					>
					<%=WorkTypeComInfo.getWorkTypename()%></option>
				<%}%>
			</Select>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelNames("783",user.getLanguage())%></wea:item>
		<wea:item>
			<brow:browser viewType="0" name="crm" 
				browserValue='<%=crm %>' 
				browserSpanValue='<%=CustomerInfoComInfo.getCustomerInfoname  (""+crm) %>'
				browserUrl="/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp"
				hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
				completeUrl="/data.jsp?type=7"  />
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelNames("83796",user.getLanguage())%></wea:item>
		<wea:item>
			<span class="wuiDateSpan" selectId="planbegindate_sel" selectValue="">
				  <input class=wuiDateSel type="hidden" name="planbegindate" value="<%=planbegindate%>">
				  <input class=wuiDateSel  type="hidden" name="planbegindate1" value="<%=planbegindate1%>">
			</span>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelNames("22170",user.getLanguage())%></wea:item>
		<wea:item>
			<span class="wuiDateSpan" selectId="planendate_sel" selectValue="">
				  <input class=wuiDateSel type="hidden" name="planenddate" value="<%=planenddate%>">
				  <input class=wuiDateSel  type="hidden" name="planenddate1" value="<%=planenddate1%>">
			</span>
		</wea:item>
		<wea:item>ID</wea:item>
		<wea:item><input class="InputStyle" name="prjid" id="prjid" value='<%=prjid %>'></wea:item>
	</wea:group>
	
	<wea:group context="" attributes="{'groupDisplay':'none'}">
    	<wea:item attributes="{'colspan':'full'}">
	    	<div style="width: 100%;text-align: right;">
	    		<span _status="1" id="moreSearch_Span" class="hideBlockDiv1" style="cursor:pointer;color:#ccc;">
					<%=SystemEnv.getHtmlLabelNames("89",user.getLanguage())%><img src="/wui/theme/ecology8/templates/default/images/1_wev8.png"></span>&nbsp;&nbsp;
	    	</div>
    	</wea:item>
    </wea:group>
	
	<wea:group context='<%=SystemEnv.getHtmlLabelNames("27858",user.getLanguage())%>' attributes="{'samePair':'moreKeyWord','groupOperDisplay':''}">	
		<wea:item><%=SystemEnv.getHtmlLabelName(587,user.getLanguage())%></wea:item>
		<wea:item>
			<Select class="InputStyle" name="prjstatus">
				<option value=""><%=SystemEnv.getHtmlLabelNames("332",user.getLanguage())%></option>
				<%while(ProjectStatusComInfo.next()){%>
					<option value="<%=ProjectStatusComInfo.getProjectStatusid ()%>"
					<%if(prjstatus.equals(ProjectStatusComInfo.getProjectStatusid())){%> selected="true"<%}%>
					>
					<%=ProjectStatusComInfo.getProjectStatusdesc ()%></option>
				<%}%>
			</Select>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelNames("636",user.getLanguage())%></wea:item>
		<wea:item>
			<brow:browser viewType="0" name="parentprj" 
				browserValue='<%=parentprj %>' 
				browserSpanValue='<%=ProjectInfoComInfo.getProjectInfoname  (""+parentprj) %>'
				browserUrl="/systeminfo/BrowserMain.jsp?url=/proj/data/ProjectBrowser.jsp"
				hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
				completeUrl="/data.jsp?type=8"  />
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelNames("847",user.getLanguage())%></wea:item>
		<wea:item>
			<input class=InputStyle style="width:60px!important;" maxlength=2 size=5 value="<%=finish%>" name="finish" onkeypress="return event.keyCode>=4&&event.keyCode<=57">
			-<input class=InputStyle style="width:60px!important;" maxlength=2 size=5 value="<%=finish1%>" name="finish1" onkeypress="return event.keyCode>=4&&event.keyCode<=57">
			%
		</wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelNames("16573",user.getLanguage())%></wea:item>
		<wea:item>
			<brow:browser viewType="0" name="manager" 
				browserValue='<%=manager %>' 
				browserSpanValue='<%=ResourceComInfo.getResourcename (""+manager) %>'
				browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
				hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
				completeUrl="/data.jsp"  />
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelNames("83797",user.getLanguage())%></wea:item>
		<wea:item>
			<brow:browser viewType="0" name="managerdept" 
				browserValue='<%=managerdept %>' 
				browserSpanValue='<%=DepartmentComInfo.getDepartmentname(""+managerdept ) %>'
				browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp"
				hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
				completeUrl="/data.jsp?type=4"  />
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelNames("83813",user.getLanguage())%></wea:item>
		<wea:item>
			<brow:browser viewType="0" name="managersubcom" 
				browserValue='<%=managersubcom %>' 
				browserSpanValue='<%=SubCompanyComInfo.getSubCompanyname(""+managersubcom ) %>'
				browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp"
				hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
				completeUrl="/data.jsp?type=164"  />
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelNames("18628",user.getLanguage())%></wea:item>
		<wea:item>
			<brow:browser viewType="0" name="member" 
				browserValue='<%=member %>' 
				browserSpanValue='<%=ResourceComInfo.getResourcename (""+member) %>'
				browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
				hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
				completeUrl="/data.jsp"  />
		</wea:item>
	</wea:group>
	
	<wea:group context='<%=SystemEnv.getHtmlLabelNames("16169",user.getLanguage())%>' attributes="{'samePair':'moreKeyWord','groupOperDisplay':''}">
<%
//cusfield

TreeMap<String,JSONObject> openfieldMap= CptFieldComInfo.getOpenFieldMap();
if(!openfieldMap.isEmpty()){
	Iterator it=openfieldMap.entrySet().iterator();
	while(it.hasNext()){
		Entry<String,JSONObject> entry=(Entry<String,JSONObject>)it.next();
		String k= entry.getKey();
		JSONObject v=new JSONObject(((JSONObject)entry.getValue()).toString());
		int fieldhtmltype= v.getInt("fieldhtmltype");
		String fieldid=v.getString("id");
		String fieldname=v.getString("fieldname");
		if(fieldhtmltype==2||fieldhtmltype==6||fieldhtmltype==7){
			continue;
		}
		int type=v.getInt("type");
		v.put("ismand", "0");//查询不用必填
		String val=Util.null2String(request.getParameter("field"+fieldid) );
		if(!"".equals(val)){
			if(fieldhtmltype==3){
	 			boolean isSingle="true".equalsIgnoreCase( BrowserManager.browIsSingle(""+type));
	 			if(isSingle){
	 				cusSql.append( " and "+fieldname+" ='"+val+"'  ");
	 			}else {
	 				String dbtype= RecordSetV .getDBType();
	 				if("oracle".equalsIgnoreCase(dbtype)){
	 					cusSql.append(SQLUtil.filteSql(RecordSetV .getDBType(),  " and ','+"+fieldname+"+',' like '%,"+val+",%'  "));
	 				}else{
	 					cusSql.append(" and ','+convert(varchar(2000),"+fieldname+")+',' like '%,"+val+",%'  ");
	 				}
	 				
				}
	 		}else if(fieldhtmltype==4){
	 			if("1".equals(val)){
	 				cusSql.append(" and "+fieldname+" ='"+val+"'  ");
	 			}
	 		}else if(fieldhtmltype==5){
	 			cusSql.append(" and exists(select 1 from prj_SelectItem ttt2 where ttt2.fieldid="+fieldid+" and ttt2.selectvalue='"+val+"' and ttt2.selectvalue=t1."+fieldname+" ) ");
	 		}else{
	 			cusSql.append(" and "+fieldname+" like'%"+val+"%'  ");
	 		}
		}
	%>
	<wea:item><%=SystemEnv.getHtmlLabelName(v.getInt("fieldlabel"),user.getLanguage())%></wea:item>
	<wea:item>
		<%=((HtmlElement)Class.forName(v.getString("eleclazzname")).newInstance()).getHtmlElementString(val, v, user) %>
	</wea:item>
	
	<%
	}
}

%>		
	</wea:group>
	
	
	<wea:group context="">
    	<wea:item type="toolbar">
    		<input class="zd_btn_submit" type="submit" name="submit1" value="<%=SystemEnv.getHtmlLabelNames("197",user.getLanguage())%>"/>
    		<input class="zd_btn_cancle" type="reset" name="reset" value="<%=SystemEnv.getHtmlLabelNames("2022",user.getLanguage())%>"/>
    		<input class="zd_btn_cancle" type="button" name="cancel" id="cancel" value="<%=SystemEnv.getHtmlLabelNames("201",user.getLanguage())%>"  />
    	</wea:item>
    </wea:group>
    
</wea:layout>
</div>

</form>

<%

String popedomOtherpara="";

//操作列参数
JSONObject operatorInfo=new JSONObject();
operatorInfo.put("userid", user.getUID());
operatorInfo.put("usertype", user.getLogintype());
operatorInfo.put("languageid", user.getLanguage());
operatorInfo.put("operatortype", "prj_monitorlist");//操作项类型
operatorInfo.put("operator_num", 8);//操作项数量
operatorInfo.put("operator_val", popedomOtherpara);

String userid=""+user.getUID();
String sqlWhere = " where 1=1 ";
if(!"".equals(prjid)){
	sqlWhere+=" and t1.id = '"+prjid+"' ";
}
if(!"".equals(paraid)){
	sqlWhere+=" and t1.prjtype = '"+paraid+"' ";
}


if(!"".equals(prjstatus)){
	sqlWhere+=" and t1.status='"+prjstatus+"' ";
}


if(!"".equals(planbegindate)){
	sqlWhere+=" and dbo.getPrjBeginDate(t1.id) >='"+planbegindate+"' ";
}
if(!"".equals(planbegindate1)){
	sqlWhere+=" and dbo.getPrjBeginDate(t1.id) <='"+planbegindate1+"' ";
}
if(!"".equals(planenddate)){
	sqlWhere+=" and dbo.getPrjEndDate(t1.id) >='"+planenddate+"' ";
}
if(!"".equals(planenddate1)){
	sqlWhere+=" and dbo.getPrjEndDate(t1.id) <='"+planenddate1+"' ";
}
if(!"".equals(finish)){
	sqlWhere+=" and dbo.getPrjFinish(t1.id) >='"+finish+"' ";
}
if(!"".equals(finish1)){
	sqlWhere+=" and dbo.getPrjFinish(t1.id) <='"+finish1+"' ";
}
if(!"".equals(member)){
	sqlWhere+=" and  ','+t1.members+',' like '%,"+member+",%' ";
}

sqlWhere=SQLUtil.filteSql(RecordSetV.getDBType(), sqlWhere);


if(!"".equals(prjname)){
	sqlWhere+=" and t1.name like '%"+prjname+"%' ";
	
}else if(!"".equals(nameQuery)){
	sqlWhere+=" and t1.name like '%"+nameQuery+"%' ";
}else if(!"".equals(nameQuery1)){
	sqlWhere+=" and t1.name like '%"+nameQuery1+"%' ";
}

if(!"".equals(procode)){
	sqlWhere+=" and t1.procode like '%"+procode+"%' ";
}
if(!"".equals(manager)){
	sqlWhere+=" and t1.manager = '"+manager+"' ";
}
if(!"".equals(managerdept)){
	sqlWhere+=" and t1.department = '"+managerdept+"' ";
}
if(!"".equals(managersubcom)){
	sqlWhere+=" and t1.subcompanyid1 = '"+managersubcom+"' ";
}
if(!"".equals(parentprj)){
	sqlWhere+=" and t1.parentid = '"+parentprj+"' ";
}
if(!"".equals(crm)){
	sqlWhere+=" and t1.description = '"+crm+"' ";
}
if(!"".equals(worktype)){
	sqlWhere+=" and t1.worktype = '"+worktype+"' ";
}

String cusSqlStr=cusSql.toString();
if(!"".equals(cusSqlStr )){
	sqlWhere+=cusSqlStr;
}

int perpage=15;                                 
String backfields = " t1.id,t1.id as prjid,t1.name,t1.procode,t1.prjtype,t1.worktype,t1.status,t1.manager,t1.members ";
backfields+=",dbo.getPrjBeginDate(t1.id) as begindate,dbo.getPrjEndDate(t1.id) as enddate,dbo.getPrjFinish(t1.id) as finish ";
backfields=SQLUtil.filteSql(RecordSetV.getDBType(), backfields);
String fromSql  = " Prj_ProjectInfo t1 ";
String orderby =" enddate,t1.id ";

int totalCount=0;
String sqlV="select count(t1.id) as totalcount from "+fromSql+" "+sqlWhere;
RecordSetV.executeSql(sqlV);
if(RecordSetV.next()){
	totalCount=RecordSetV.getInt(1);
}

String tableString=""+
        "<table  pageId=\""+pageId+"\"  instanceid=\"CptCapitalAssortmentTable\"  tabletype=\"checkbox\"  pagesize=\""+PageIdConst.getPageSize(pageId,user.getUID(),"prj")+"\"  >"+
        //" <checkboxpopedom  id=\"checkbox\" popedompara=\"column:id\" showmethod='weaver.proj.util.ProjectTransUtil.getCanDelPrjTask' />"+
        "<sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\" sqlprimarykey=\"t1.id\" sqlorderby=\""+orderby+"\" sqlsortway=\"asc\" sqldistinct=\"true\" />"+
        "<head>"+                             
              "<col width=\"10%\"  text=\"ID\" column=\"id\" orderkey=\"prjid\"  />"+
              "<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(1353,user.getLanguage())+"\" column=\"name\"  orderkey=\"name\"/>"+
              "<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(17852,user.getLanguage())+"\" column=\"procode\"  orderkey=\"procode\"/>"+
              "<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(16573,user.getLanguage())+"\" column=\"manager\" orderkey=\"manager\" transmethod='weaver.hrm.resource.ResourceComInfo.getResourcename'/>"+
              "<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(587,user.getLanguage())+"\" column=\"status\" orderkey=\"status\" transmethod='weaver.proj.Maint.ProjectStatusComInfo.getProjectStatusdesc'/>"+
              "<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(22170,user.getLanguage())+"\" column=\"enddate\" orderkey=\"enddate\"/>"+
        "</head>"+
        "<operates width=\"5%\">"+
         //"   <popedom column='id' otherpara='"+operatorInfo.toString() +"' transmethod='weaver.proj.util.ProjectTransUtil.getOperates'  ></popedom>"+
        "    <operate href=\"javascript:onDel()\" text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\" target=\"_self\" index=\"0\"/>"+
        "</operates>"+
        "</table>"; 
%>

<wea:SplitPageTag  tableString='<%=tableString %>'  mode="run" />



<script type="text/javascript">

function onDel(id){
	if(id){
		window.top.Dialog.confirm('<%=SystemEnv.getHtmlLabelNames("83600",user.getLanguage())%>',function(){
			jQuery.post(
				"/system/systemmonitor/MonitorOperation.jsp",
				{"operation":"deleteproj","deleteprojid":id},
				function(data){
					window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("83472",user.getLanguage())%>",function(){
						_table.reLoad();
						window.top.myprjtypetreeobserver.update();
					});
				}
			);
			
		});
	}
}
function onLog(){
	var url="/systeminfo/SysMaintenanceLog.jsp?isdialog=1&sqlwhere=where operateitem=95";
	var title="<%=SystemEnv.getHtmlLabelNames("32061",user.getLanguage())%>";
	openDialog(url,title,1000,700,true);
}

function batchDel(){
	var typeids = _xtable_CheckedCheckboxId();
	if(typeids==null || typeids=="") return ;
	window.top.Dialog.confirm('<%=SystemEnv.getHtmlLabelNames("83601",user.getLanguage())%>',function(){
		jQuery.ajax({
			url : "/system/systemmonitor/MonitorOperation.jsp",
			type : "post",
			async : true,
			data : {"operation":"deleteproj","deleteprojid":typeids},
			dataType : "html",
			contentType: "application/x-www-form-urlencoded; charset=utf-8", 
			success: function do4Success(msg){
				window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("83472",user.getLanguage())%>");
				_table.reLoad();
				window.top.myprjtypetreeobserver.update();
			}
		});
	});
}


$(function(){
	var cptgroupname='<%=ProjectTypeComInfo.getProjectTypename(paraid) %>';
	if(cptgroupname==''){
		cptgroupname='<%=SystemEnv.getHtmlLabelName(19870,user.getLanguage()) %>';
	}
	try{
		parent.setTabObjName(cptgroupname);
	}catch(e){}
});


jQuery(document).ready(function(){
	hideGroup("moreKeyWord");
	
	var showText = "";
	var hideText = "";
	jQuery("#moreSearch_Span").unbind("click").bind("click", function () {
		var _status = jQuery(this).attr("_status");
		var currentTREle = jQuery(this).closest("table").closest("TR");
		if (!!!_status || _status == "0") {
			jQuery(this).attr("_status", "1");
			jQuery(this).html(showText+"<image src='/wui/theme/ecology8/templates/default/images/1_wev8.png'>");
			currentTREle.next("TR.Spacing").next("TR.items").hide();
			hideGroup("moreKeyWord");
		} else {
			jQuery(this).attr("_status", "0");
			jQuery(this).html(hideText+"<image src='/wui/theme/ecology8/templates/default/images/2_wev8.png'>");
			currentTREle.next("TR.Spacing").next("TR.items").show();
			showGroup("moreKeyWord");
		}
	}).hover(function(){
		$(this).css("color","#000000");
	},function(){
		$(this).css("color","#cccccc");
	});
});


function initProgressbar(){
	$(".progressbar").each(function(i){
		var rate=parseInt($(this).attr("rate"));
		var status=parseInt($(this).attr("status"));
		$(this).find("div.progress-label").text(rate+"%");
		$(this).progressbar({value:rate});
		if(status===1){//overtime task
			$(this).find( ".ui-progressbar-value" ).css({'background':'red'});
		}
		
	});
}

function onBtnSearchClick(){
	weaver.submit();
}
$(function(){
	$("#topTitle").topMenuTitle({searchFn:onBtnSearchClick});
});
</script>
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</BODY>

</HTML>
