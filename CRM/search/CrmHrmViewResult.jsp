
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetCO" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CRMSearchComInfo" class="weaver.crm.search.SearchComInfo" scope="session" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="RecordSetCT" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="CustomerTypeComInfo" class="weaver.crm.Maint.CustomerTypeComInfo" scope="page" />
<jsp:useBean id="CustomerDescComInfo" class="weaver.crm.Maint.CustomerDescComInfo" scope="page" />
<jsp:useBean id="CustomerSizeComInfo" class="weaver.crm.Maint.CustomerSizeComInfo" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="ContactWayComInfo" class="weaver.crm.Maint.ContactWayComInfo" scope="page" />
<jsp:useBean id="SectorInfoComInfo" class="weaver.crm.Maint.SectorInfoComInfo" scope="page" />
<jsp:useBean id="CustomerRatingComInfo" class="weaver.crm.Maint.CustomerRatingComInfo" scope="page" />
<jsp:useBean id="CreditInfoComInfo" class="weaver.crm.Maint.CreditInfoComInfo" scope="page" />
<jsp:useBean id="TradeInfoComInfo" class="weaver.crm.Maint.TradeInfoComInfo" scope="page" />
<jsp:useBean id="CustomerStatusComInfo" class="weaver.crm.Maint.CustomerStatusComInfo" scope="page" />
<jsp:useBean id="CountryComInfo" class="weaver.hrm.country.CountryComInfo" scope="page"/>
<jsp:useBean id="ProvinceComInfo" class="weaver.hrm.province.ProvinceComInfo" scope="page"/>
<jsp:useBean id="CityComInfo" class="weaver.hrm.city.CityComInfo" scope="page"/>
<jsp:useBean id="LanguageComInfo" class="weaver.systeminfo.language.LanguageComInfo" scope="page"/>
<jsp:useBean id="ContacterTitleComInfo" class="weaver.crm.Maint.ContacterTitleComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page" />
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page"/>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</HEAD>
<%
String imagefilename = "/images/hdDOC_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(527,user.getLanguage())+SystemEnv.getHtmlLabelName(356,user.getLanguage());
String needfav ="1";
String needhelp ="";

%>
<%
String userid = ""+user.getUID();
String loginType = ""+user.getLogintype();
String userSeclevel = user.getSeclevel();
String destination = Util.null2String(request.getParameter("destination"));
String msg = Util.null2String(request.getParameter("msg"));//report ：报表查看客户信息
String selectType = Util.null2String(CRMSearchComInfo.getSelectType());//mine 我的客户 ，share批量共享
String searchHrmId = Util.null2String(request.getParameter("searchHrmId"));
/*
if(!CRMSearchComInfo.getAccountManager().equals("")&&destination.equals("myAccount")){//从人事卡片点击客户数量
    userid = CRMSearchComInfo.getAccountManager();
    loginType = "1";
    userSeclevel = ResourceComInfo.getSeclevel(userid);
}
*/

int perpage=10;
char flag = 2;
String ProcPara = userid+flag+loginType;
RecordSet.executeProc("CRM_Customize_SelectByUid",ProcPara);

boolean hasCustomize = true;
if(RecordSet.getCounts()<=0){
	hasCustomize = false;
}else{
	RecordSet.first();
  perpage=RecordSet.getInt("perpage");
}
int pagenum=Util.getIntValue(request.getParameter("pagenum"),1);
if(perpage<=0 )	perpage=10;

int j=0;
int options[] = new int[6];
for(j=0;j<6;j++){
	if(hasCustomize){
		options[j] = RecordSet.getInt(j+2);
	}else{
		switch(j){
			case 0: options[j] = 101;break;
			case 1: options[j] = 203;break;
			default: options[j] = 0;
		}
	}
}

int nMaxCols = 0;
for(j=0;j<6;j++){
	if(options[j]!=0){
		nMaxCols = j+1 > nMaxCols ? j+1 : nMaxCols ;
	}
}
String leftjointable = CrmShareBase.getTempTable(userid);

String name="";
String text="";
String column="";
String orderkey="";
String target="\"_fullwindow\"";
String transmethod="";
String href="";
String linkkey="";

String strURL="";
String strData="";
String linkvaluecolumn="";

String tableInfo = "";
String backFields = "";
String colString = "";
String sqlFrom = "";
String sqlWhere = "";
String orderBy = "";
if(loginType.equals("1")){
	if (RecordSet.getDBType().equals("oracle")){
		backFields = "t1.id,t1.email,t1.status,(select t3.id from (select * from CRM_CustomerContacter order by main desc,id desc) t3 where t3.customerid = t1.id and rownum = 1) as contacterid";
		sqlFrom = "from CRM_CustomerInfo t1 left join ("+("select a.relateditemid from "+CrmShareBase.getTempTable(searchHrmId)+" a,"+CrmShareBase.getTempTable(userid)+" b where a.relateditemid=b.relateditemid")+") t2 on t1.id = t2.relateditemid";
		sqlWhere = CRMSearchComInfo.FormatSQLSearch(user.getLanguage())+" and t1.id = t2.relateditemid";
	} else {
		backFields = "t1.id,t1.email,t1.status,(select top 1 t3.id from CRM_CustomerContacter t3 where t3.customerid = t1.id order by main desc,id desc) as contacterid";
		sqlFrom = "from CRM_CustomerInfo t1 left join ("+("select a.relateditemid from "+CrmShareBase.getTempTable(searchHrmId)+" a,"+CrmShareBase.getTempTable(userid)+" b where a.relateditemid=b.relateditemid")+") t2 on t1.id = t2.relateditemid";
		sqlWhere = CRMSearchComInfo.FormatSQLSearch(user.getLanguage())+" and t1.id = t2.relateditemid";
	}
	orderBy = "t1.id";
}else{
	backFields = "t1.id,t1.email,t1.status,t3.id as contacterid";
	sqlFrom = "from CRM_CustomerInfo t1 left join CRM_CustomerContacter t3 on t1.id=t3.customerid";
	sqlWhere = CRMSearchComInfo.FormatSQLSearch(user.getLanguage())+" and t1.agent="+userid;
	orderBy = "t1.id";
}

for(j=0;j<nMaxCols;j++){
	if(options[j]==0){
		continue;
	}
	RecordSetCO.executeProc("CRM_CustomizeOption_SelectByID",""+options[j]);
	if(RecordSetCO.getCounts()<=0)
		response.sendRedirect("/CRM/DBError.jsp?type=FindData_SRD_4");
	RecordSetCO.first();
	text = ((RecordSetCO.getInt("tabledesc")==1)?SystemEnv.getHtmlLabelName(136,user.getLanguage()):SystemEnv.getHtmlLabelName(572,user.getLanguage())) + SystemEnv.getHtmlLabelName(RecordSetCO.getInt("labelid"),user.getLanguage());
	if(RecordSetCO.getInt("tabledesc")==1){//这里处理防止出现相同的字段
		backFields += ",t1."+RecordSetCO.getString("fieldname");
		if((backFields.indexOf("."+RecordSetCO.getString("fieldname")+",")!=-1)||(backFields.indexOf("as "+RecordSetCO.getString("fieldname"))!=-1)){
            backFields += " as "+RecordSetCO.getString("fieldname")+j;
			column = name = RecordSetCO.getString("fieldname")+j;
			orderkey = "t1."+RecordSetCO.getString("fieldname");
		}else{
			column = name = RecordSetCO.getString("fieldname");
			orderkey = "t1."+RecordSetCO.getString("fieldname");
		}
	}else{
		if(loginType.equals("1")){
			if (RecordSet.getDBType().equals("oracle")){
				backFields += "," + "(select t3."+RecordSetCO.getString("fieldname")+" from (select * from CRM_CustomerContacter order by main desc,id desc) t3 where t3.customerid = t1.id and rownum = 1)";
				if((backFields.indexOf("."+RecordSetCO.getString("fieldname")+",")!=-1)||(backFields.indexOf("as "+RecordSetCO.getString("fieldname"))!=-1)){
					backFields += " as "+RecordSetCO.getString("fieldname")+j;
					column = name = RecordSetCO.getString("fieldname")+j;
					orderkey = RecordSetCO.getString("fieldname")+j;
				}else{
					backFields += " as "+RecordSetCO.getString("fieldname");
					column = name = RecordSetCO.getString("fieldname");
					orderkey = RecordSetCO.getString("fieldname");
				}
			} else {
				backFields += "," + "(select top 1 t3."+RecordSetCO.getString("fieldname")+" from CRM_CustomerContacter t3 where t3.customerid = t1.id order by main desc,id desc)";
				if((backFields.indexOf("."+RecordSetCO.getString("fieldname")+",")!=-1)||(backFields.indexOf("as "+RecordSetCO.getString("fieldname"))!=-1)){
					backFields += " as "+RecordSetCO.getString("fieldname")+j;
					column = name = RecordSetCO.getString("fieldname")+j;
					orderkey = RecordSetCO.getString("fieldname")+j;
				}else{
					backFields += " as "+RecordSetCO.getString("fieldname");
					column = name = RecordSetCO.getString("fieldname");
					orderkey = "t3."+RecordSetCO.getString("fieldname");
				}
			}
		} else {
			backFields += ",t3."+RecordSetCO.getString("fieldname");
			if((backFields.indexOf("."+RecordSetCO.getString("fieldname")+",")!=-1)||(backFields.indexOf("as "+RecordSetCO.getString("fieldname"))!=-1)){
				backFields += " as "+RecordSetCO.getString("fieldname")+j;
				column = name = RecordSetCO.getString("fieldname")+j;
				orderkey = "t3."+RecordSetCO.getString("fieldname");
			}else{
				column = name = RecordSetCO.getString("fieldname");
				orderkey = "t3."+RecordSetCO.getString("fieldname");
			}
		}
	}

	switch(options[j]){
		case 102:
		case 202://需要把相应数据转换成 语言
			transmethod = "\"weaver.systeminfo.language.LanguageComInfo.getLanguagename\"";
			break;
		case 106://需要把相应数据转换成 城市
			transmethod = "\"weaver.hrm.city.CityComInfo.getCityname\"";
			break;
		case 107://需要把相应数据转换成 国家
			transmethod = "\"weaver.hrm.country.CountryComInfo.getCountryname\"";
			break;
		case 108://需要把相应数据转换成 省份
			transmethod = "\"weaver.hrm.province.ProvinceComInfo.getProvincename\"";
			break;
		case 114://需要把相应数据转换成 联系方法
			transmethod = "\"weaver.crm.Maint.ContactWayComInfo.getContactWayname\"";
			break;
		case 115://需要把相应数据转换成 行业
			transmethod = "\"weaver.crm.Maint.SectorInfoComInfo.getSectorInfoname\"";
			break;
		case 116://需要把相应数据转换成 规模
			transmethod = "\"weaver.crm.Maint.CustomerSizeComInfo.getCustomerSizedesc\"";
			break;
		case 117://需要把相应数据转换成 类型
			transmethod = "\"weaver.crm.Maint.CustomerTypeComInfo.getCustomerTypename\"";
			break;
		case 119://需要把相应数据转换成 描述
			transmethod = "\"weaver.crm.Maint.CustomerDescComInfo.getCustomerDescname\"";
			break;
		case 120://需要把相应数据转换成 状态
			transmethod = "\"weaver.crm.Maint.CustomerStatusComInfo.getCustomerStatusname\"";
			break;
		case 121://需要把相应数据转换成 级别
			transmethod = "\"weaver.crm.Maint.CustomerRatingComInfo.getCustomerRatingname\"";
			break;
		case 122://需要把相应数据转换成 合同金额
			transmethod = "\"weaver.crm.Maint.TradeInfoComInfo.getTradeInfoname\"";
			break;
		case 123://需要把相应数据转换成 信用等级
			transmethod = "\"weaver.crm.Maint.CreditInfoComInfo.getCreditInfoname\"";
			break;
		case 201://需要把相应数据转换成 联系人称呼
			transmethod = "\"weaver.crm.Maint.ContacterTitleComInfo.getContacterTitlename\"";
			break;
		case 124:
		case 212://需要把相应数据转换成 员工信息 并制作超级链接
			strURL = "\"/hrm/resource/HrmResource.jsp\"";
			linkkey ="\"id\"";
			transmethod = "\"weaver.hrm.resource.ResourceComInfo.getResourcename\"";
			break;
		case 125://需要把相应数据转换成 部门信息 并制作超级链接
			strURL = "\"/hrm/company/HrmDepartmentDsp.jsp\"";
			linkkey ="\"id\"";
			transmethod = "\"weaver.hrm.company.DepartmentComInfo.getDepartmentname\"";
			break;
		case 126:
		case 127://需要把相应数据转换成 客户信息 并制作超级链接
			strURL = "\"/CRM/data/ViewCustomer.jsp\"";
			linkkey = "\"CustomerID\"";
			transmethod = "\"weaver.crm.Maint.CustomerInfoComInfo.getCustomerInfoname\"";
			break;
		case 101://制作超级链接
			strURL = "\"/CRM/data/ViewCustomer.jsp\"";
			linkkey = "\"CustomerID\"";
			linkvaluecolumn = "\"id\"";
			break;
		case 203:
		case 204:
		case 205://制作超级链接
			strURL = "\"/CRM/data/ViewContacter.jsp\"";
			linkkey = "\"ContacterID\"";
			linkvaluecolumn = "\"contacterid\"";
			break;

		default:break;
	}
	colString +="<col name=\""+name+"\" text=\""+text+"\" column=\""+column+"\"";
	if(options[j]==102||options[j]==202||options[j]==106||options[j]==107||options[j]==108||options[j]==114||options[j]==115||options[j]==116||options[j]==117||options[j]==119||options[j]==120||options[j]==121||
	options[j]==122||options[j]==123||options[j]==201||options[j]==124||options[j]==212||options[j]==125||options[j]==126||options[j]==127)
		colString +=" transmethod="+transmethod;
	if(options[j]==101||options[j]==124||options[j]==212||options[j]==125||options[j]==126||options[j]==127||options[j]==203||options[j]==204||options[j]==205)
		colString +=" href="+strURL+" linkkey="+linkkey;
	if(options[j]==101||options[j]==203||options[j]==204||options[j]==203)
		colString +=" linkvaluecolumn="+linkvaluecolumn;
	colString+=" orderkey=\""+orderkey+"\" target=\"_blank\"/>";
}

String popedomOtherpara = loginType+"_"+userid+"_"+userSeclevel;
String operateString= "<operates width=\"15%\">";
       operateString+=" <popedom transmethod=\"weaver.splitepage.operate.SpopForCus.getCusOpratePopedom\"  otherpara=\""+popedomOtherpara+"\"></popedom> ";
       operateString+="     <operate href=\"javascript:sendEmail()\" otherpara=\"column:email\"  text=\""+SystemEnv.getHtmlLabelName(2051,user.getLanguage())+"\" target=\"_fullwindow\"  index=\"0\"/>";
       operateString+="     <operate href=\"javascript:doShare()\" text=\""+SystemEnv.getHtmlLabelName(119,user.getLanguage())+"\" target=\"_fullwindow\"  index=\"1\"/>";
       operateString+="     <operate href=\"/CRM/data/ViewContactLog.jsp\" linkkey=\"CustomerID\" linkvaluecolumn=\"id\" text=\""+SystemEnv.getHtmlLabelName(6082,user.getLanguage())+"\" target=\"_self\"  index=\"2\"/>";
       operateString+="     <operate href=\"/CRM/data/ViewLog.jsp\" linkkey=\"log=n&amp;CustomerID\" linkvaluecolumn=\"id\" text=\""+SystemEnv.getHtmlLabelName(83,user.getLanguage())+"\" target=\"_self\"  index=\"3\"/>";       
       operateString+="</operates>";
String tableString="<table  pagesize=\""+perpage+"\" tabletype=\"checkbox\">";
       tableString+="<sql backfields=\""+backFields+"\" sqlform=\""+Util.toHtmlForSplitPage(sqlFrom)+"\" sqlorderby=\""+orderBy+"\" sqlsortway=\"Desc\" sqlprimarykey=\"t1.id\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\" sqlisdistinct=\"true\" />";
       if("share".equals(selectType)){
    	   tableString += "<checkboxpopedom showmethod=\"weaver.crm.search.ContacterSearchTransMethod.getCustomerCheckInfo\" popedompara=\"column:id+column:status+"+user.getUID()+"\"  />";
			  
       }
       tableString+="<head>"+colString+"</head>";
       tableString+=operateString;
       tableString+="</table>";     
//out.println("select "+backFields+" "+sqlFrom+" "+sqlWhere+" order by "+orderBy);       
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:onReSearch(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(343,user.getLanguage())+",javascript:location.href='/CRM/search/Customize.jsp',_top} " ;
RCMenuHeight += RCMenuHeightStep ;

if(HrmUserVarify.checkUserRight("MailMerge:Merge", user)){
    RCMenu += "{"+SystemEnv.getHtmlLabelName(1226,user.getLanguage())+",javascript:sendMailBatch()',_top} " ;
    RCMenuHeight += RCMenuHeightStep ;
}
if(HrmUserVarify.checkUserRight("MutiApproveCustomerNoRequest", user)){
    RCMenu += "{"+SystemEnv.getHtmlLabelName(17529,user.getLanguage())+",javascript:location.href='/CRM/data/ChangeLevelCustomerList.jsp',_top} " ;
    RCMenuHeight += RCMenuHeightStep ;
}

if(HrmUserVarify.checkUserRight("EditCustomer:Delete", user)){
    RCMenu += "{"+"Excel,javascript:crmExport(),_top} " ;
    RCMenuHeight += RCMenuHeightStep;
}

%>

<%
if("report".equals(msg)){ %>
	<jsp:include page="/systeminfo/commonTabHead.jsp">
	   <jsp:param name="mouldID" value="customer"/>
	   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(20323,user.getLanguage()) %>"/>
	</jsp:include>
<%} %>
<wea:layout attributes="{layoutTableId:topTitle}">
	<wea:group context="" attributes="{groupDisplay:none}">
		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
			<%if("search".equals(selectType)){ %>
			<span style="font-size: 12px;cursor: pointer;">
				<input class="e8_btn_top middle" onclick="sendMailBatch()" type="button" jQuery1392950000546="32" value="<%=SystemEnv.getHtmlLabelName(2051,user.getLanguage()) %>"/>
			</span>
			<%} %>
			<%if("share".equals(selectType)){ %>
			<span style="font-size: 12px;cursor: pointer;">
				<input class="e8_btn_top middle" onclick="shareBatch()" type="button" jQuery1392950000546="32" value="<%=SystemEnv.getHtmlLabelName(18037,user.getLanguage()) %>"/>
			</span>
			<%} %>
			<%if("monitor".equals(selectType)){ %>
			<spanstyle="font-size: 12px;cursor: pointer;">
				<input class="e8_btn_top middle" onclick="deleteBatch()" type="button" jQuery1392950000546="32" value="<%=SystemEnv.getHtmlLabelName(32136,user.getLanguage()) %>"/>
			</span>
			<%} %>
			<span style="font-size: 12px;">
					<input type="text" class="searchInput"  id="searchCustomerName" name="searchCustomerName" value="<%=CRMSearchComInfo.getCustomerName()%>" />
			</span>
			<%if(!"report".equals(msg)){ %>
				<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage())%></span>
			<%} %>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</wea:item>
	</wea:group>
</wea:layout>



<div class="advancedSearchDiv" id="advancedSearchDiv" style="display:none;overflow: auto" >	
<FORM id=weaver name="weaver" action="/CRM/search/SearchOperation.jsp?selectType=<%=selectType %>" method="post">
<input type="hidden" name="destination" value="no">
<input type="hidden" name="searchtype" value="advanced">
<input type="hidden" name="actionKey" value="common"> 
<input name="FirstNameDesc" type="hidden" value="2">
<input name="LastNameDesc" type="hidden" value="2">
	

<wea:layout type="4Col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(32905,user.getLanguage())%>'>
		<!-- 类型 -->
		<wea:item><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></wea:item>
	    <wea:item><INPUT class=InputStyle maxLength=50 size=30 name="CustomerName" id="CustomerName" value='<%=CRMSearchComInfo.getCustomerName()%>'></wea:item>
		     
		     
		<wea:item><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></wea:item>
		<wea:item>
			<select name="CustomerTypes" style="width: 120px;">
				<option value=""><%=SystemEnv.getHtmlLabelName(82857,user.getLanguage())%></option>
				<%
					RecordSetCT.executeProc("CRM_CustomerType_SelectAll","");
					while(RecordSetCT.next()){
						String tmpid=RecordSetCT.getString("id");
						if(CRMSearchComInfo.isCustomerTypeSel(Util.getIntValue(tmpid))){
							out.println("<option value='"+tmpid+"' selected='selected' >"+RecordSetCT.getString("fullname")+"</optin>");
						}else{
							out.println("<option value='"+tmpid+"'>"+RecordSetCT.getString("fullname")+"</optin>");
						}
					}
				%>
			</select>
		</wea:item>
		
		<%if(!user.getLogintype().equals("2")){%>
			<wea:item><%=SystemEnv.getHtmlLabelName(136,user.getLanguage())%>: <%=SystemEnv.getHtmlLabelName(144,user.getLanguage())%></wea:item>
			<wea:item>
				<brow:browser viewType="0" name="AccountManager" 
			         browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
			         browserValue='<%=CRMSearchComInfo.getAccountManager()%>' 
			         browserSpanValue = '<%=ResourceComInfo.getResourcename(CRMSearchComInfo.getAccountManager())%>'
			         isSingle="true" hasBrowser="true"  hasInput="true" isMustInput='1'
			         completeUrl="/data.jsp" width="80%" ></brow:browser> 
			</wea:item>
			
			<wea:item><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></wea:item>
			<wea:item>
				<select name="CustomerStatus" style="width: 120px;">
					<option value=""><%=SystemEnv.getHtmlLabelName(82857,user.getLanguage())%></option>
					<%
						RecordSetCT.execute("select id , fullname from CRM_CustomerStatus");
						while(RecordSetCT.next()){
							String tmpid = RecordSetCT.getString("id");
							if(CRMSearchComInfo.getCustomerStatus().equals(tmpid)){
								out.println("<option value='"+tmpid+"' selected='selected' >"+RecordSetCT.getString("fullname")+"</optin>");
							}else{
								out.println("<option value='"+tmpid+"'>"+RecordSetCT.getString("fullname")+"</optin>");
							}
						}
			
					%>
				</select>
			</wea:item>
		<%}else{ %>
			<wea:item><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></wea:item>
			<wea:item>
				<select name="CustomerStatus" style="width: 120px;">
					<option value=""><%=SystemEnv.getHtmlLabelName(82857,user.getLanguage())%></option>
					<%
						RecordSetCT.execute("select id , fullname from CRM_CustomerStatus");
						while(RecordSetCT.next()){
							String tmpid = RecordSetCT.getString("id");
							if(CRMSearchComInfo.getCustomerStatus().equals(tmpid)){
								out.println("<option value='"+tmpid+"' selected='selected' >"+RecordSetCT.getString("fullname")+"</optin>");
							}else{
								out.println("<option value='"+tmpid+"'>"+RecordSetCT.getString("fullname")+"</optin>");
							}
						}
					%>
				</select>
			</wea:item>
			
			<wea:item></wea:item><wea:item></wea:item>
		<%} %>
	</wea:group>
	
	<wea:group context='<%=SystemEnv.getHtmlLabelName(32843,user.getLanguage())%>' attributes="{'itemAreaDisplay':'none'}" >
		<!-- 客户 -->
		<wea:item><%=SystemEnv.getHtmlLabelName(377,user.getLanguage())%></wea:item>
		<wea:item>
			<brow:browser viewType="0" name="CustomerCountry" 
			 browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/country/CountryBrowser.jsp"
			 browserValue='<%=CRMSearchComInfo.getCustomerCountry()%>' 
			 browserSpanValue = '<%=CountryComInfo.getCountrydesc(CRMSearchComInfo.getCustomerCountry())%>'
			 isSingle="true" hasBrowser="true"  hasInput="true" isMustInput='1'
			 completeUrl="/data.jsp?type=1111" width="80%" ></brow:browser> 
		</wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(800,user.getLanguage())%></wea:item>
		<wea:item>
			<brow:browser viewType="0" name="CustomerProvince" 
			 browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/province/ProvinceBrowser.jsp"
			 browserValue='<%=CRMSearchComInfo.getCustomerProvince()%>' 
			 browserSpanValue = '<%=ProvinceComInfo.getProvincename(CRMSearchComInfo.getCustomerProvince())%>'
			 isSingle="true" hasBrowser="true"  hasInput="true" isMustInput='1'
			 completeUrl="/data.jsp?type=2222" width="80%" ></brow:browser> 
		</wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(493,user.getLanguage())%></wea:item>
		<wea:item>
			<brow:browser viewType="0" name="CityCode" 
			 browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/city/CityBrowser.jsp"
			 browserValue='<%=CRMSearchComInfo.getCustomerCity()%>' 
			 browserSpanValue = '<%=CityComInfo.getCityname(CRMSearchComInfo.getCustomerCity())%>'
			 isSingle="true" hasBrowser="true"  hasInput="true" isMustInput='1'
			 completeUrl="/data.jsp?type=58" width="80%" ></brow:browser> 
		</wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(277,user.getLanguage())%></wea:item>
		<wea:item>
			<BUTTON type="button" class=calendar id=SelectDate onclick=getfromDate()></BUTTON>&nbsp;
			<SPAN id=fromdatespan ><%=CRMSearchComInfo.getFromDate()%></SPAN>
			<input type="hidden" name="fromdate" value=<%=CRMSearchComInfo.getFromDate()%>>
			－<BUTTON type="button" class=calendar id=SelectDate onclick=getendDate()></BUTTON>&nbsp;
			<SPAN id=enddatespan ><%=CRMSearchComInfo.getEndDate()%></SPAN>
			<input type="hidden" name="enddate" value=<%=CRMSearchComInfo.getEndDate()%>>
		</wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(101,user.getLanguage())%></wea:item>
		<wea:item>
			<brow:browser viewType="0" name="PrjID" 
			 browserUrl="/systeminfo/BrowserMain.jsp?url=/proj/data/ProjectBrowser.jsp"
			 browserValue='<%=CRMSearchComInfo.getPrjID()%>' 
			 browserSpanValue = '<%=ProjectInfoComInfo.getProjectInfoname(CRMSearchComInfo.getPrjID())%>'
			 isSingle="true" hasBrowser="true"  hasInput="true" isMustInput='1'
			 completeUrl="/data.jsp?type=135" width="80%" ></brow:browser> 
		</wea:item>
				
		<!-- 联系人 -->
		<wea:item><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%></wea:item>
		<wea:item><INPUT class=InputStyle maxLength=50 size=30 name="ContacterFirstName" value='<%=CRMSearchComInfo.getContacterFirstName()%>'></wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(475,user.getLanguage())%></wea:item>
		<wea:item><INPUT class=InputStyle maxLength=50 size=30 name="ContacterLastName" value='<%=CRMSearchComInfo.getContacterLastName()%>'></wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(671,user.getLanguage())%></wea:item>
		<wea:item>
			<INPUT class=inputstyle style="width: 100px;" name=age size=5 maxlength=3  onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("age")' value=""><%=SystemEnv.getHtmlLabelName(15864,user.getLanguage())%>－
		  	<INPUT class=inputstyle style="width: 100px;" name=ageTo size=5 maxlength=3  onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("ageTo")' value=""><%=SystemEnv.getHtmlLabelName(15864,user.getLanguage())%>
		</wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(1887,user.getLanguage())%></wea:item>
		<wea:item>
			<INPUT class=InputStyle maxLength=100 size=30 name="IDCard" onKeyPress="ItemCount_KeyPress()" 
				onBlur='checknumber("IDCard")'  value="<%=CRMSearchComInfo.getContacterIDCard()%>">
		</wea:item>
		
		
		<!-- 分类信息 -->
		<%if(!user.getLogintype().equals("2")){%>
			<wea:item><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></wea:item>
			<wea:item>
				<brow:browser viewType="0" name="CustomerRegion" 
			         browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp"
			         browserValue='<%=CRMSearchComInfo.getCustomerRegion()%>' 
			         browserSpanValue = '<%=Util.null2String(CRMSearchComInfo.getCustomerRegion()).equals("")?"":DepartmentComInfo.getDepartmentName(CRMSearchComInfo.getCustomerRegion())%>'
			         isSingle="true" hasBrowser="true"  hasInput="true" isMustInput='1'
			         completeUrl="/data.jsp?type=4" width="80%" ></brow:browser> 
			</wea:item>
		<%}%>
				
		<wea:item><%=SystemEnv.getHtmlLabelName(132,user.getLanguage())%></wea:item>
		<wea:item>
			<brow:browser viewType="0" name="CustomerOrigin" 
		         browserUrl="/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp?sqlwhere=where t1.type in (3,4)"
		         browserValue='<%=CRMSearchComInfo.getCustomerOrigin()%>' 
		         browserSpanValue = '<%=CustomerInfoComInfo.getCustomerInfoname(CRMSearchComInfo.getCustomerOrigin())%>'
		         isSingle="true" hasBrowser="true"  hasInput="true" isMustInput='1'
		         completeUrl="/data.jsp?type=agent" width="80%" ></brow:browser> 
		</wea:item>
		
		
		
		<wea:item><%=SystemEnv.getHtmlLabelName(575,user.getLanguage())%></wea:item>
		<wea:item>
			<brow:browser viewType="0" name="CustomerSector" 
		         browserUrl="/systeminfo/BrowserMain.jsp?url=/CRM/Maint/SectorInfoBrowser.jsp"
		         browserValue='<%=CRMSearchComInfo.getCustomerSector()%>' 
		         browserSpanValue = '<%=SectorInfoComInfo.getSectorInfoname(CRMSearchComInfo.getCustomerSector())%>'
		         isSingle="true" hasBrowser="true"  hasInput="true" isMustInput='1'
		         completeUrl="/data.jsp?type=sector" width="80%" ></brow:browser>
		</wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></wea:item>
		<wea:item>
			<select name="CustomerDesc" style="width: 120px;">
				<option value=""><%=SystemEnv.getHtmlLabelName(82857,user.getLanguage())%></option>
				<%
					RecordSetCT.execute("select id , fullname from CRM_CustomerDesc");
					while(RecordSetCT.next()){
						String tmpid=RecordSetCT.getString("id");
						if(CRMSearchComInfo.getCustomerDesc().equals(tmpid)){
							out.println("<option value='"+tmpid+"' selected='selected' >"+RecordSetCT.getString("fullname")+"</optin>");
						}else{
							out.println("<option value='"+tmpid+"'>"+RecordSetCT.getString("fullname")+"</optin>");
						}
					}
				%>
			</select>
		</wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(15240,user.getLanguage())%></wea:item>
		<wea:item>
			<select name="ContactWay" style="width: 120px;">
				<option value=""><%=SystemEnv.getHtmlLabelName(82857,user.getLanguage())%></option>
				<%
					RecordSetCT.execute("select id , fullname from CRM_ContactWay");
					while(RecordSetCT.next()){
						String tmpid=RecordSetCT.getString("id");
						if(CRMSearchComInfo.getContactWay().equals(tmpid)){
							out.println("<option value='"+tmpid+"' selected='selected' >"+RecordSetCT.getString("fullname")+"</optin>");
						}else{
							out.println("<option value='"+tmpid+"'>"+RecordSetCT.getString("fullname")+"</optin>");
						}
					}
				%>
			</select>
		</wea:item> 
		
		<wea:item><%=SystemEnv.getHtmlLabelName(576,user.getLanguage())%></wea:item>
		<wea:item>
			<select name="CustomerSize" style="width: 120px;">
				<option value=""><%=SystemEnv.getHtmlLabelName(82857,user.getLanguage())%></option>
				<%
					RecordSetCT.execute("select id , fullname from CRM_CustomerSize");
					while(RecordSetCT.next()){
						String tmpid=RecordSetCT.getString("id");
						if(CRMSearchComInfo.getCustomerSize().equals(tmpid)){
							out.println("<option value='"+tmpid+"' selected='selected' >"+RecordSetCT.getString("fullname")+"</optin>");
						}else{
							out.println("<option value='"+tmpid+"'>"+RecordSetCT.getString("fullname")+"</optin>");
						}
					}
				%>
			</select>
		</wea:item>
		
		<!-- 高级信息 -->
		<wea:item><%=SystemEnv.getHtmlLabelName(581,user.getLanguage())%></wea:item>
		<wea:item>
			<brow:browser viewType="0" name="DebtorNumber" 
		         browserUrl="/systeminfo/BrowserMain.jsp?url=/CRM/Maint/TradeInfoBrowser.jsp"
		         browserValue='<%=CRMSearchComInfo.getDebtorNumber()%>' 
		         browserSpanValue = '<%=TradeInfoComInfo.getTradeInfoname(CRMSearchComInfo.getDebtorNumber())%>'
		         isSingle="true" hasBrowser="true"  hasInput="true" isMustInput='1'
		         completeUrl="/data.jsp?type=debtorNumber" width="80%" ></brow:browser>
		</wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(580,user.getLanguage())%></wea:item>
		<wea:item>
			<brow:browser viewType="0" name="CreditorNumber" 
		         browserUrl="/systeminfo/BrowserMain.jsp?url=/CRM/Maint/CreditInfoBrowser.jsp"
		         browserValue='<%=CRMSearchComInfo.getCreditorNumber()%>' 
		         browserSpanValue = '<%=CreditInfoComInfo.getCreditInfoname(CRMSearchComInfo.getCreditorNumber())%>'
		         isSingle="true" hasBrowser="true"  hasInput="true" isMustInput='1'
		         completeUrl="/data.jsp?type=creditorNumber" width="80%" ></brow:browser>
		</wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(110,user.getLanguage())%></wea:item>
		<wea:item>
			<INPUT class=InputStyle maxLength=50 size=30 name="CustomerAddress1" value="<%=CRMSearchComInfo.getCustomerAddress1()%>">
		</wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(479,user.getLanguage())%></wea:item>
		<wea:item>
			<INPUT class=InputStyle maxLength=50 size=30 name="CustomerPostcode" value="<%=CRMSearchComInfo.getCustomerPostcode()%>">
		</wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(421,user.getLanguage())%></wea:item>
		<wea:item>
			<INPUT class=InputStyle maxLength=50 size=30 name="CustomerTelephone" value="<%=CRMSearchComInfo.getCustomerTelephone()%>">
		</wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(591,user.getLanguage())%></wea:item>
		<wea:item>
			<brow:browser viewType="0" name="CustomerParent" 
		         browserUrl="/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp"
		         browserValue='<%=CRMSearchComInfo.getCustomerParent()%>' 
		         browserSpanValue = '<%=CustomerInfoComInfo.getCustomerInfoname(CRMSearchComInfo.getCustomerParent())%>'
		         isSingle="true" hasBrowser="true"  hasInput="true" isMustInput='1'
		         completeUrl="/data.jsp?type=7" width="80%" ></brow:browser>
		</wea:item>
		<!-- 联系人 -->
		<%if(!user.getLogintype().equals("2")){%>
			<wea:item><%=SystemEnv.getHtmlLabelName(572,user.getLanguage())%>: <%=SystemEnv.getHtmlLabelName(144,user.getLanguage())%></wea:item>
			<wea:item>
			  <brow:browser viewType="0" name="ContacterManager" 
				browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
				browserValue='<%=CRMSearchComInfo.getContacterManager()%>' 
				browserSpanValue = '<%=ResourceComInfo.getResourcename(CRMSearchComInfo.getContacterManager())%>'
				isSingle="true" hasBrowser="true"  hasInput="true" isMustInput='1'
				completeUrl="/data.jsp" width="80%" ></brow:browser>
			</wea:item>
		<%}%>
		
	    <wea:item><%=SystemEnv.getHtmlLabelName(572,user.getLanguage())%>: <%=SystemEnv.getHtmlLabelName(477,user.getLanguage())%></wea:item>
	    <wea:item><INPUT class=InputStyle maxLength=50 size=30 name="ContacterEmail" value='<%=CRMSearchComInfo.getContacterEmail()%>'></wea:item>
		<wea:item></wea:item><wea:item></wea:item>
	</wea:group>
		
	<wea:group context="" attributes="{'Display':'none'}">
		<wea:item type="toolbar">
			<input type="submit" class="e8_btn_submit" value="<%=SystemEnv.getHtmlLabelName(82529,user.getLanguage())%>" id="searchBtn"/>
			<span class="e8_sep_line">|</span>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(27088,user.getLanguage())%>" class="e8_btn_cancel" onclick="resetCondition()"/>
			<span class="e8_sep_line">|</span>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(32694,user.getLanguage())%>" class="e8_btn_cancel" id="cancel"/>
		</wea:item>
	</wea:group>
</wea:layout>			
</FORM>
</div>




<wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" tableInfo="<%=tableInfo%>"/> 
		



<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<iframe id="searchexport" style="display:none"></iframe>
<%if("report".equals(msg)){ %>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout>
			<wea:group context="" attributes="{groupDisplay:none}">
				<wea:item type="toolbar">
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage()) %>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="parent.getDialog(window).close()">
				</wea:item>
			</wea:group>
		</wea:layout>
	</div>
	<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>  
<%} %>
<script language="javascript">

<%---onReSearch() edited by 徐蔚绛 2005-03-10 for TD:1546----%>
function onReSearch(){
if(1==1){
	weaver.destination.value="goSearch";
	weaver.submit();
	return;
}
<%if(Util.null2String(CRMSearchComInfo.getSearchtype()).equals("advanced")){%>
location.href="/CRM/search/SearchAdvanced.jsp?actionKey=common";
<%}else{%>
location.href="/CRM/search/SearchSimple.jsp?actionKey=common";
<%}%>
}

function crmExport(){
    searchexport.location="SearchResultExport.jsp";
}

function doEdit(crmid){
	var url = "/CRM/data/ViewCustomer.jsp?CustomerID="+crmid;
	openFullWindowHaveBar(url);
}

var dialog = null;
function closeDialog(){
	if(dialog)
		dialog.close();
}

function addShareCallback(){
	closeDialog();
}

function doShare(crmid){

	 dialog=new window.top.Dialog();//定义Dialog对象
     dialog.currentWindow = window;
　　　dialog.Model=true;
　　　dialog.Width=500;//定义长度
　　　dialog.Height=250;
　　　dialog.URL="/CRM/data/AddShare.jsp?isfromtab=true&itemtype=2&CustomerID="+crmid+"&customername=";
　　　dialog.Title="<%=SystemEnv.getHtmlLabelName(19025,user.getLanguage())%>";
　　　dialog.show();
}

function doViewLog(crmid){

	 dialog=new window.top.Dialog();//定义Dialog对象
     dialog.currentWindow = window;
　　　dialog.Model=true;
　　　dialog.Width=900;//定义长度
　　　dialog.Height=600;
　　　dialog.URL="/CRM/data/ViewLog.jsp?log=n&CustomerID="+crmid;
　　　dialog.Title="<%=SystemEnv.getHtmlLabelName(31704,user.getLanguage())%>";
　　　dialog.show();

	//var url = "/CRM/data/ViewLog.jsp?log=n&CustomerID="+crmid;
	//openFullWindowHaveBar(url);
}

function sendEmail(crmid , email){
	
	var url = "/email/new/MailAdd.jsp?isInternal=0&to="+email;
	openFullWindowHaveBar(url);
}

function sendMailBatch(){
	var customerids = _xtable_CheckedCheckboxId();
	if("" == customerids){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(22000,user.getLanguage())%>");
		return;
	}
	jQuery.post("/CRM/search/SearchResultOperation.jsp",{"customerids":customerids,"method":"getEmail"},function(emails){
		
		var url = "/email/new/MailAdd.jsp?isInternal=0&to="+emails;
		openFullWindowHaveBar(url);
	})
}



function  shareBatch(){

	
	var customerids = _xtable_CheckedCheckboxId();
	if("" == customerids){
		alert("<%=SystemEnv.getHtmlLabelName(22000,user.getLanguage())%>");
		return;
	}
	
	 dialog=new window.top.Dialog();//定义Dialog对象
     dialog.currentWindow = window;
　　　dialog.Model=true;
　　　dialog.Width=600;//定义长度
　　　dialog.Height=400;
　　　dialog.URL="/CRM/data/ShareMutiCustomerTo.jsp?selectType=share&customerids="+customerids;
　　　dialog.Title="<%=SystemEnv.getHtmlLabelName(19025,user.getLanguage())%>";
　　　dialog.show();
}

function deleteBatch(){
	
	var customerids = _xtable_CheckedCheckboxId();
	if("" == customerids){
		alert("<%=SystemEnv.getHtmlLabelName(22000,user.getLanguage())%>");
		return;
	}
	jQuery.post("/CRM/search/SearchResultOperation.jsp",{"customerids":customerids ,"method":"delete","userid":"<%=user.getUID()%>",
		"logintype":"<%=user.getLogintype()%>","loginid":"<%=user.getLoginid()%>"},function(){
		_table.reLoad();
	})
}
$(document).ready(function(){
			
	jQuery("#topTitle").topMenuTitle({searchFn:searchCustomerName});
	jQuery("#hoverBtnSpan").hoverBtn();
				
});
function searchCustomerName(){
	
	var CustomerName = jQuery("#searchCustomerName").val();
	jQuery("#CustomerName").val(CustomerName);
	window.weaver.submit();
	
}

function resetCondtion(){
	document.getElementById("weaver").reset();
}
</script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
</body>
</html>

