
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<%@ include file="/systeminfo/init_wev8.jsp" %>

<script language=javascript src="/js/weaver_wev8.js"></script>
<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css" type="text/css" />
<script language=javascript src="/js/ecology8/docs/docSearchInit_wev8.js"></script>
<script language=javascript src="/js/ecology8/docs/docExt_wev8.js"></script>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script type="text/javascript">

	function onBtnSearchClick(){
		doSearchForm();
	}

	var pluginName = {
		type:"input",
		name:"abbr#rowIndex#_abbr",
		notNull:false
	};
	
	var pluginId = {
		type:"hidden",
		name:"abbr#rowIndex#_subCompanyId",
		notNull:false
	};
	
	var pluginDefId = {
		type:"hidden",
		name:"abbr#rowIndex#_subComAbbrDefId",
		notNull:false
	}
	
	function afterDoWhenLoaded(){
		hideTH();
	}
	
</script>
<%

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(22764,user.getLanguage())+""+SystemEnv.getHtmlLabelName(141,user.getLanguage());
String needfav ="1";
String needhelp ="";
String navName = SystemEnv.getHtmlLabelName(22764,user.getLanguage());

%>

</head>
<body>

<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%

    int detachable=Util.getIntValue(String.valueOf(session.getAttribute("docdetachable")),0);
    int subCompanyId= -1;
    int operatelevel=0;

    if(detachable==1){  
        if(request.getParameter("subCompanyId")==null){
            subCompanyId=Util.getIntValue(String.valueOf(session.getAttribute("managestruabbr_subCompanyId")),-1);
        }else{
            subCompanyId=Util.getIntValue(request.getParameter("subCompanyId"),-1);
        }
        if(subCompanyId == -1){
            subCompanyId = user.getUserSubCompany1();
        }
        session.setAttribute("managestruabbr_subCompanyId",String.valueOf(subCompanyId));
        operatelevel= CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"StruAbbr:Maintenance",subCompanyId);
    }else{
        if(HrmUserVarify.checkUserRight("StruAbbr:Maintenance", user))
            operatelevel=2;
    }
    
    String qname = Util.null2String(request.getParameter("flowTitle"));
    if(subCompanyId!=-1&&subCompanyId!=0){
    	navName = SubCompanyComInfo.getSubCompanyname(""+subCompanyId);
    }
%>

<%
/*RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:doSearchForm(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;*/

if(operatelevel>=1){
    RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self}" ;
    RCMenuHeight += RCMenuHeightStep ;
}
%>

<script type="text/javascript">
	try{
		parent.setTabObjName("<%= navName %>");
	}catch(e){}
</script>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>


<form action="" name="frmmain" id="frmmain">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type=button class="e8_btn_top" onclick="submitData();" value="<%=SystemEnv.getHtmlLabelName(86, user.getLanguage())%>"></input>
			<input type="text" class="searchInput" name="flowTitle"  value="<%=qname %>"/>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
</form>


<form name="formstruabbr" method="post" action="/workflow/workflow/managestruabbr_operation.jsp">
<input type=hidden name=operation value="managestruabbr_subcompany">
<input type=hidden name=subCompanyId value="<%=subCompanyId%>">
<input type='hidden' name='tableMax' value='0'/>
<input type="hidden" name="pageId" _showCol="false" id="pageId" value="<%= PageIdConst.DOC_DOCABBRSUBCOMPANYLIST %>"/>

	  <%
				String sqlWhere = "(HrmSubCompany.canceled is null or HrmSubCompany.canceled='0')";
				if(!qname.equals("")){
					sqlWhere += " and HrmSubCompany.subCompanyName like '%"+qname+"%' ";
				}									
				String tableString=""+
				   "<table instanceid=\"docMouldTable\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.DOC_DOCABBRSUBCOMPANYLIST,user.getUID(),PageIdConst.DOC)+"\" tabletype=\"none\">"+
				    " <checkboxpopedom  id=\"checkbox\"  popedompara=\"true\" />"+
				   "<sql backfields=\"hrmsubcompany.showorder as showorder,HrmSubCompany.id as id,HrmSubCompany.subCompanyName,workflow_subComAbbrDef.id as subComAbbrDefId,workflow_subComAbbrDef.abbr\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+
				   "\"  sqlform=\"HrmSubCompany left join workflow_subComAbbrDef on HrmSubCompany.id=workflow_subComAbbrDef.subCompanyId \" sqlorderby=\"HrmSubCompany.showOrder\"  sqlprimarykey=\"HrmSubCompany.id\" sqlsortway=\"asc\"  sqldistinct=\"true\" />"+
				   "<head>"+							 
				   		"<col width=\"0%\" editPlugin=\"pluginId\"  hide=\"true\"  text=\"\"  column=\"id\" />"+
				   		"<col width=\"0%\" editPlugin=\"pluginDefId\"  hide=\"true\"  text=\"\"  column=\"subComAbbrDefId\" />"+
						 "<col width=\"40%\" text=\""+SystemEnv.getHtmlLabelName(1878,user.getLanguage())+"\"  column=\"subCompanyName\" />";
						 if(operatelevel>=1){
						 	tableString += "<col width=\"60%\" editPlugin=\"pluginName\"   text=\""+SystemEnv.getHtmlLabelName(22764,user.getLanguage())+"\" column=\"abbr\"/>";
						 }else{
						 	tableString += "<col width=\"60%\"   text=\""+SystemEnv.getHtmlLabelName(22764,user.getLanguage())+"\" column=\"abbr\"/>";
						 }
				   tableString += "</head></table>";
			%>
			<input type="hidden" _showCol="false" name="pageId" id="pageId" value="<%= PageIdConst.DOC_DOCABBRSUBCOMPANYLIST %>"/>
			<wea:layout>
				<wea:group context="" attributes="{'groupDisplay':'none'}">
					<wea:item attributes="{'isTableList':'true'}">
			 			<wea:SplitPageTag isShowTopInfo="false" tableString='<%=tableString%>' mode="run"  />
			 		</wea:item>
			 	</wea:group>
			 </wea:layout>

</form>

   <script language="javascript">
function submitData(){
		formstruabbr.submit();
}

function doSearchForm(){
    frmmain.submit();
}
</script>

</body>
</html>
