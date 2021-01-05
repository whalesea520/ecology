
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetCO" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CRMSearchComInfo" class="weaver.crm.search.SearchComInfo" scope="session" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />

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
<%
//判断是否有批量转移权限
if(!HrmUserVarify.checkUserRight("CRM_BatchTransfer:Operate", user)){
	response.sendRedirect("/notice/noright.jsp");
	return;
}
//判断是否在规定操作时间内
int transferStart = 0;
int transferEnd = 23;
RecordSet.executeSql("select transferStart,transferEnd from CRM_BatchOperateSetting");
if(RecordSet.next()){
	transferStart = RecordSet.getInt(1);
	transferEnd = RecordSet.getInt(2);
}
int hour = Integer.parseInt(TimeUtil.getFormartString(new Date(),"H"));
if(transferStart>transferEnd){
	if(!(hour > transferStart || hour == transferStart || hour < transferEnd)){
		response.sendRedirect("/CRM/data/TransferMutiCustomerInit.jsp");
		return;
	}
}else{
	if(!((hour > transferStart || hour == transferStart) && (hour < transferEnd))){
		response.sendRedirect("/CRM/data/TransferMutiCustomerInit.jsp");
		return;
	}
}

int transferCount = 100;//每次最多可转移客户数量 默认为100
RecordSet.executeSql("select transferCount from CRM_BatchOperateSetting");
if(RecordSet.next()){
	transferCount = RecordSet.getInt(1);
}

String customerids = Util.null2String(request.getParameter("customerids"));
String userid = ""+user.getUID();
String loginType = ""+user.getLogintype();
String userSeclevel = user.getSeclevel();

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

String CurrentUser = ""+user.getUID();
String logintype = ""+user.getLogintype();
String whereclause = CRMSearchComInfo.FormatSQLSearch(user.getLanguage()) + " and t1.status not in(7,8) ";
    
String tableInfo = "";
String backFields = "";
String colString = "";
String sqlFrom = "";
String sqlWhere = "";
String orderBy = "";
backFields = " t1.id " ;
sqlFrom = " from CRM_CustomerInfo  t1 ";
sqlWhere = " " + whereclause+" and (t1.deleted is null or t1.deleted=0) and t1.manager="+user.getUID() ;
//orderby = " t1.id ";
//CRM_SearchSql = "select t1.* into "+temptable+" from CRM_CustomerInfo  t1,CrmShareDetail  t2  "+whereclause+" and t1.deleted=0 and t1.id = t2.crmid and t2.usertype=1 and t2.userid="+CurrentUser + " order by t1.id desc ";
	    
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
			linkvaluecolumn = "\"id\"";
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
	colString+=" orderkey=\""+orderkey+"\" target=\"_fullwindow\"/>";
}

String contact_sql = (String)request.getSession().getAttribute("CRM_TRANSFER_CONTACTSQL");
if(!"".equals(contact_sql) && contact_sql != null){
	sqlWhere += contact_sql;
}

//out.print("select " + backFields + sqlFrom + sqlWhere);       
String tableString="<table  pagesize=\""+perpage+"\" tabletype=\"checkbox\">";
       tableString+="<sql backfields=\""+backFields+"\" sqlform=\""+Util.toHtmlForSplitPage(sqlFrom)+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\" sqlorderby=\""+orderBy+"\" sqlsortway=\"Desc\" sqlprimarykey=\"id\" sqlisdistinct=\"true\" />";
       tableString+="<head>"+colString+"</head>";
       tableString+="</table>";  
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</HEAD>
<%
String imagefilename = "/images/hdDOC_wev8.gif";
String titlename = "客户批量转移";
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%
	RCMenu += "{"+SystemEnv.getHtmlLabelName(364,user.getLanguage())+",javascript:location.href='/CRM/search/SearchSimple.jsp?actionKey=batchTransfer',_top} " ;
	RCMenuHeight += RCMenuHeightStep ;
	
	RCMenu += "{"+SystemEnv.getHtmlLabelName(80,user.getLanguage())+",javascript:transfer(),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;

    RCMenu += "{"+SystemEnv.getHtmlLabelName(18363,user.getLanguage())+",javascript:_table.firstPage(),_self}" ;
    RCMenuHeight += RCMenuHeightStep ;
    RCMenu += "{"+SystemEnv.getHtmlLabelName(1258,user.getLanguage())+",javascript:_table.prePage(),_self}" ;
    RCMenuHeight += RCMenuHeightStep ;
    RCMenu += "{"+SystemEnv.getHtmlLabelName(1259,user.getLanguage())+",javascript:_table.nextPage(),_self}" ;
    RCMenuHeight += RCMenuHeightStep ;
    RCMenu += "{"+SystemEnv.getHtmlLabelName(18362,user.getLanguage())+",javascript:_table.lastPage(),_self}" ;
    RCMenuHeight += RCMenuHeightStep ;
%>



<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
</colgroup>
<tr>
	<td height="10" colspan="3"></td>
</tr>
<tr>
	<td></td>
	<td valign="top">
		<form name=crmtransfer action="TransferMutiCustomerOperation.jsp" method="post" onsubmit="return false">
		<input type="checkbox" name="transfercrmid" style="display:none">
		<input type="checkbox" name="transfercrmid" style="display:none">
		<input type="hidden" name="customerids" value="">
			<TABLE class=Shadow>
				<tr>
					<td valign="top">
						<TABLE class=viewform>
							<tr>
								<td width="20%" style="padding-left: 5px"><%=SystemEnv.getHtmlLabelName(18733,user.getLanguage()) %></td>
								<td width="20%" class="Field">
									<BUTTON class=Browser onClick="onShowResource('hrmName','hrmId')" name=showresource></BUTTON>
									<INPUT class=inputstyle type=hidden name=hrmId value="">
									<span id=hrmName><IMG src='/images/BacoError_wev8.gif' align=absMiddle></span>
								</td>
								<td width="60%" class="Field" style="color: #800000">
									注意：根据系统设置每次最多只能转移 <%=transferCount %> 条记录！
								</td>
							</tr>
							<TR class=spacing><TD class=line1 colspan="3" style="padding-left: 5px"></TD></TR>
							<%
								String count = Util.null2String(request.getParameter("count"));
								String toid = Util.null2String(request.getParameter("toid"));
								if(!count.equals("")){
							%>
								<tr>
									<TD colspan="3" style="color: red;padding-left: 5px">
										提示：已成功转移<%=count %>个客户到<a href="javaScript:openhrm('<%=toid %>');" onclick='pointerXY(event);' style="color: red !important;"><u><%=ResourceComInfo.getLastname(toid)%></u></a>！
									</TD>
								</tr>
							<%
								}
							%>
							<tr>
								<td valign="top" colspan="3">
						     		<wea:SplitPageTag  tableString="<%=tableString%>"  mode="run" tableInfo="<%=tableInfo%>"/> 
								</td>
							</tr>
						</TABLE>
					</td>
				</tr>
			</TABLE>
		</form>
	</td>
	<td></td>
</tr>
<tr>
	<td height="10" colspan="3"></td>
</tr>
</table>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<script language="JavaScript">
var customerids = "<%=customerids%>";

function changeCheck(obj){
    if(obj.status){
        var rep = new RegExp(";"+obj.value,"g");
        customerids = customerids.replace(rep,"");
        customerids +=";"+obj.value;
    }else{
        var rep = new RegExp(";"+obj.value,"g");
        customerids = customerids.replace(rep,"");
    }
}

function checkAll(obj){
    var i;
    for(i= 0 ;i<document.all("transfercrmid").length-2; i++){
        if(obj.status&&!document.all("transfercrmid")[i].status){
            document.all("transfercrmid")[i].click();
        }else if(!obj.status&&document.all("transfercrmid")[i].status){
            document.all("transfercrmid")[i].click();
        }
    }
}


function changePageSubmit(pageStr){
    location=pageStr+"&customerids="+customerids;
    //alert(pageStr);
}

function onSearch(){
    document.all("customerids").value=customerids
    crmtransfer.submit();
}

function transfer(){
	//alert(_xtable_CheckedCheckboxId());
	if(document.all("hrmId").value==""){
		alert("请选择转移人!");
        return;
	}
    if(_xtable_CheckedCheckboxId()==""){
    	alert("请选择要转移的客户!");
        return;
    }
    var customerIds = _xtable_CheckedCheckboxId().split(",");
    if(customerIds.length><%=transferCount+1%>){
    	alert("每次转移客户数量不能大于<%=transferCount%>!");
        return;
    }
    
    if(confirm("确定转移所选择客户?")){
    	crmtransfer.action="TransferMutiCustomerOperation.jsp?customerids="+_xtable_CheckedCheckboxId();
        crmtransfer.submit();
    }
}
function onShowResource(spanname, inputname) {
    var id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp");
	try {
        jsid = new VBArray(id).toArray();
    } catch(e) {
        return;
    }
    var customerId = "";
	if (jsid != null) {
        if (jsid[0] != "0" && jsid[1]!="") {
            document.all(spanname).innerHTML = jsid[1];
            document.all(inputname).value = jsid[0];
            customerId = jsid[0];
        } else {
            document.all(spanname).innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
            document.all(inputname).value = "";
        }
    }
}
</script>
</body>
</html>
