
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="SalaryComInfo" class="weaver.hrm.finance.SalaryComInfo" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<%@ taglib uri="/browserTag" prefix="brow"%>
<%
if(!HrmUserVarify.checkUserRight("Compensation:Manager", user)){
  response.sendRedirect("/notice/noright.jsp");
  return;
}
String titlename = SystemEnv.getHtmlLabelName(803,user.getLanguage());
String subcompanyids=SubCompanyComInfo.getRightSubCompany(user.getUID(),"Compensation:Manager",0);
ArrayList subcompanylist=Util.TokenizerString(subcompanyids,",");
ArrayList itemlist=new ArrayList();
String items="";
for(int i=0;i<subcompanylist.size();i++){
    ArrayList tempitems=SalaryComInfo.getSubCompanyItemByType(Util.getIntValue((String)subcompanylist.get(i)),"'1'",false);
    for(int j=0;j<tempitems.size();j++){
        if(itemlist.indexOf((String)tempitems.get(j))<0){
            itemlist.add((String)tempitems.get(j));
        }
    }
}
for(int i=0;i<itemlist.size();i++){
    if(items.equals("")){
        items=(String)itemlist.get(i);
    }else{
        items+=","+itemlist.get(i);
    }
}

String qname = Util.null2String(request.getParameter("flowTitle"));
String resourceid = Util.null2String(request.getParameter("resourceid"));
String item_id = Util.null2String(request.getParameter("item_id"));
String changedateselect = Util.null2String(request.getParameter("changedateselect"));
String changedate_from = Util.null2String(request.getParameter("changedate_from"));
String changedate_to = Util.null2String(request.getParameter("changedate_to"));
if(!changedateselect.equals("") && !changedateselect.equals("0")&& !changedateselect.equals("6")){
	changedate_from = TimeUtil.getDateByOption(changedateselect,"0");
	changedate_to = TimeUtil.getDateByOption(changedateselect,"1");
}
String changeuser = Util.null2String(request.getParameter("changeuser"));

%>
<html>
	<head>
	<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
	<script language=javascript src="/js/ecology8/hrm/HrmSearchInit_wev8.js"></script>
	<script type="text/javascript">
	function onBtnSearchClick(){
		jQuery("#searchfrm").submit();
	}
	
	jQuery(document).ready(function(){
		parent.myCurrentindex=1;
		parent.setMyCurrentLi();
	})
	</script>
	</head>
	<body>
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<form action="" name="searchfrm" id="searchfrm">
		<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr>
				<td>
				</td>
				<td class="rightSearchSpan" style="text-align:right;">
					<input type="text" class="searchInput" name="flowTitle" value="<%=qname %>"/>
				  <span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage())%></span><span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
				</td>
			</tr>
		</table>
		<div class="advancedSearchDiv" id="advancedSearchDiv" style="display:none;" >
			<wea:layout type="4col">
				<wea:group context='<%=SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>'>
					<wea:item><%=SystemEnv.getHtmlLabelName(15818,user.getLanguage())%></wea:item>
					<wea:item>
	  				<brow:browser viewType="0"  name="resourceid" browserValue='<%=resourceid %>' 
            browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp?selectedids="
            hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
            completeUrl="/data.jsp" linkUrl="javascript:openhrm($id$)" width="165px"
            browserSpanValue='<%=Util.toScreen(ResourceComInfo.getResourcename(resourceid),user.getLanguage()) %>'>
            </brow:browser>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(15819,user.getLanguage())%></wea:item>
					<wea:item>
						<%
			    	//String url = "/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/finance/salary/SalaryItemBrowser.jsp?sqlwhere=where id in("+items+") and itemtype = 1 ";
					String url = "/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/finance/salary/SalaryItemBrowser.jsp?sqlwhere="+xssUtil.put(" where id in("+items+") and itemtype = 1 ");
			    	//String completeUrl = "/data.jsp?type=SalaryItem&whereClause= id in("+items+") and itemtype = 1";
			    	String completeUrl = "/data.jsp?type=SalaryItem&whereClause="+xssUtil.put(" id in("+items+") and itemtype = 1 ");
			    	%>
			      <brow:browser viewType="0" name="item_id" browserValue='<%=item_id %>' 
			          browserUrl='<%=url %>'hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
			          completeUrl='<%=completeUrl %>' width="165px" browserSpanValue='<%=Util.toScreen(SalaryComInfo.getSalaryname(item_id),user.getLanguage()) %>'>
			      </brow:browser>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(15820,user.getLanguage())%></wea:item>
					<wea:item>
		      	<select name="changedateselect" id="changedateselect" onchange="changeDate(this,'spanChangedate');" style="width: 135px">
		      		<option value="0" <%=changedateselect.equals("0")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
		      		<option value="1" <%=changedateselect.equals("1")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15537,user.getLanguage())%></option>
		      		<option value="2" <%=changedateselect.equals("2")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15539,user.getLanguage())%></option>
		      		<option value="3" <%=changedateselect.equals("3")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15541,user.getLanguage())%></option>
		      		<option value="4" <%=changedateselect.equals("4")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(21904,user.getLanguage())%></option>
		      		<option value="5" <%=changedateselect.equals("5")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15384,user.getLanguage())%></option>
		      		<option value="6" <%=changedateselect.equals("6")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(32530,user.getLanguage())%></option>
		      	</select>
						<span id=spanChangedate style="<%=changedateselect.equals("6")?"":"display:none;" %>">
							<BUTTON type="button" class=Calendar id=selectchangedate_from onclick="getDate(changedate_fromspan,changedate_from)"></BUTTON>
							<SPAN id=changedate_fromspan ><%=changedate_from%></SPAN>－
							<BUTTON type="button" class=Calendar id=selectchangedate_to onclick="getDate(changedate_tospan,changedate_to)"></BUTTON>
							<SPAN id=changedate_tospan ><%=changedate_to%></SPAN>
						</span>
       			<input class=inputstyle type="hidden" id="changedate_from" name="changedate_from" value="<%=changedate_from%>">
       			<input class=inputstyle type="hidden" id="changedate_to" name="changedate_to" value="<%=changedate_to%>">
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(15823,user.getLanguage())%></wea:item>
					<wea:item>
						<brow:browser viewType="0" name="changeuser" browserValue='<%=changeuser %>' 
            browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
            hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
            completeUrl="/data.jsp" linkUrl="javascript:openhrm($id$)" width="165px"
            browserSpanValue='<%=Util.toScreen(ResourceComInfo.getResourcename(changeuser),user.getLanguage()) %>'>
            </brow:browser>
					</wea:item>
				</wea:group>
				<wea:group context="">
					<wea:item type="toolbar">
						<input type="button" value="<%=SystemEnv.getHtmlLabelName(30947,user.getLanguage())%>" class="e8_btn_submit" onclick="onBtnSearchClick();"/>
						<input type="button" value="<%=SystemEnv.getHtmlLabelName(31129,user.getLanguage())%>" class="e8_btn_cancel" id="cancel"/>
					</wea:item>
				</wea:group>
			</wea:layout>
		</div>
</form>
		<%
		String backfields = " a.*, b.lastname "; 
		String fromSql  = " from HrmSalaryChange a,HrmResource b ";
		String sqlWhere = " ";
		String orderby = "  changedate desc ";
    if(rs.getDBType().equals("oracle")){
    	sqlWhere=" where a.multresourceid=concat(concat(',',to_char(b.id)),',') and b.subcompanyid1 in("+subcompanyids+")";
	  }else{
	  	sqlWhere=" where a.multresourceid=','+CONVERT(varchar,b.id)+',' and b.subcompanyid1 in("+subcompanyids+")";
	  }
		String tableString = "";

		if(qname.length()>0){
			sqlWhere += " and b.lastname like '%"+qname+"%'";
		}		
		
		if(resourceid.length()>0){
			sqlWhere += " and b.id = "+resourceid;
		}	
		
		if(item_id.length()>0){
			sqlWhere += " and a.itemid = "+item_id;
		}	
		
		if(changedate_from.length()>0){
			sqlWhere += " and a.changedate >= '"+changedate_from+"'";
		}	
		
		if(changedate_to.length()>0){
			sqlWhere += " and a.changedate <= '"+changedate_to+"'";
		}	
		
		if(changeuser.length()>0){
			sqlWhere += " and a.changeuser = "+changeuser;
		}	
		//操作字符串
		tableString =" <table pageId=\""+PageIdConst.HRM_SalaryChangeLog+"\" tabletype=\"none\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.HRM_SalaryChangeLog,user.getUID(),PageIdConst.HRM)+"\" >"+
		"	   <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlorderby=\""+orderby+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\" sqlprimarykey=\"a.id\" sqlsortway=\"Desc\" />"+
    "			<head>"+
    "				<col width=\"10%\" text=\""+SystemEnv.getHtmlLabelName(15818,user.getLanguage())+"\" column=\"lastname\" orderkey=\"lastname\" />"+
    "				<col width=\"10%\" text=\""+SystemEnv.getHtmlLabelName(15815,user.getLanguage())+"\" column=\"itemid\" orderkey=\"itemid\" transmethod=\"weaver.hrm.finance.SalaryComInfo.getSalaryname\"/>"+
    "				<col width=\"10%\" text=\""+SystemEnv.getHtmlLabelName(15820,user.getLanguage())+"\" column=\"changedate\" orderkey=\"changedate\" />"+
    "				<col width=\"12%\" text=\""+SystemEnv.getHtmlLabelName(33599,user.getLanguage())+"\" column=\"oldvalue\" orderkey=\"oldvalue\" />"+
    "				<col width=\"12%\" text=\""+SystemEnv.getHtmlLabelName(104,user.getLanguage())+"\" column=\"changetype\" orderkey=\"changetype\" otherpara=\""+user.getLanguage()+"+"+"column:salary"+"\" transmethod=\"weaver.hrm.HrmTransMethod.getHrmSalaryChangeInfo\" />"+
    "				<col width=\"12%\" text=\""+SystemEnv.getHtmlLabelName(33600,user.getLanguage())+"\" column=\"newvalue\" orderkey=\"newvalue\" />"+
    "				<col width=\"24%\" text=\""+SystemEnv.getHtmlLabelName(1897,user.getLanguage())+"\" column=\"changeresion\" orderkey=\"changeresion\" />"+
    "				<col width=\"10%\" text=\""+SystemEnv.getHtmlLabelName(15823,user.getLanguage())+"\" column=\"changeuser\" orderkey=\"changeuser\" transmethod=\"weaver.hrm.resource.ResourceComInfo.getResourcename\"/>"+
    "			</head>"+
    " </table>";
%>
<input type="hidden" name="pageId" id="pageId" value="<%= PageIdConst.HRM_SalaryChangeLog %>"/>
<wea:SplitPageTag isShowTopInfo="false" tableString='<%=tableString%>' mode="run" /> 
	</body>
	<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</html>
