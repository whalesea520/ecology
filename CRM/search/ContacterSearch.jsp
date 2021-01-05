
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ page import="weaver.crm.util.CrmFieldComInfo"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rst" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page" />
<jsp:useBean id="CrmUtil" class="weaver.crm.util.CrmUtil" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/selectDateTime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</head>
<%
String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(572,user.getLanguage())+SystemEnv.getHtmlLabelName(527,user.getLanguage());
String needfav ="1";
String needhelp ="";


String customerid = Util.null2String(request.getParameter("customerid")) ;//,2,3,

String whereclause =  "where t1.customerid = t2.relateditemid " ;

if(!"".equals(customerid)){
	whereclause +=" and t1.customerid in ("+customerid+")";
}

rs.execute("select fieldhtmltype ,type,fieldname , candel,groupid from CRM_CustomerDefinField where usetable = 'CRM_CustomerContacter' and issearch= 1 and isopen=1");
String fieldName = "";
String fieldValue = "";
String htmlType = "";
String type= "";
Map map = new HashMap();
while(rs.next()){
	fieldName = rs.getString("fieldName");
	fieldValue = Util.null2String(Util.null2String(request.getParameter(fieldName)));
	htmlType = rs.getString("fieldhtmltype");
	type = rs.getString("type");
	
	if(fieldName.equals("") || fieldValue.equals("")){
		continue;
	}
	map.put(fieldName ,fieldValue);
	
	if(htmlType.equals("1") && (type.equals("2") || type.equals("3"))){//单行文本为数值类型
		whereclause +=  " and t1."+fieldName+" = "+fieldValue;
    }else if(type.equals("162")&&htmlType.equals("3")){
        //whereclause += " and t1."+fieldName+" = "+fieldValue;
        whereclause += " and ','+cast(t1."+fieldName+" as varchar(1000))+',' like '%,"+fieldValue+",%'";
	}else if(htmlType.equals("5") || htmlType.equals("3")){//下拉框 和 浏览框
		whereclause += " and t1."+fieldName+" = "+fieldValue;
	}else{
		whereclause += " and t1."+fieldName+" like '%"+fieldValue+"%'";
	}
}


Calendar today = Calendar.getInstance();

String birthbyage = "";
String birthbyageTo = "";

int tempyear = Util.getIntValue(Util.add0(today.get(Calendar.YEAR), 4));
String firstname = Util.null2String(request.getParameter("firstname"));//防止firstName没有作为查询想

if(!firstname.equals("")) {
     whereclause +=" and t1.firstname like '%"+firstname+"%'";
}

if(!birthbyage.equals("")) {
    if(RecordSet.getDBType().equalsIgnoreCase("oracle")){
        whereclause +=" and t1.birthday <='"+birthbyage+"' and t1.birthday is not null ";
    }else{
        whereclause +=" and t1.birthday <='"+birthbyage+"' and t1.birthday<>'' ";
    }
}
if(!birthbyageTo.equals("")) {
	if(RecordSet.getDBType().equalsIgnoreCase("oracle")){
        whereclause +=" and t1.birthday >='"+birthbyageTo+"' and t1.birthday is not null ";
    }else{
        whereclause +=" and t1.birthday >='"+birthbyageTo+"' and t1.birthday<>'' ";
    }
}
String leftjointable = CrmShareBase.getTempTable(""+user.getUID());

String backFields = "id, email,mobilephone,firstname, title, jobtitle, customerid";
String sqlFrom = " CRM_CustomerContacter t1 left join "+leftjointable+" t2 on t1.customerid = t2.relateditemid";
String operateString= "<operates width=\"15%\">";
	operateString+=" <popedom transmethod=\"weaver.crm.search.ContacterSearchTransMethod.getContractOpratePopedom\"  otherpara=\""+user.getUID()+"+"+user.getLogintype()+"+"+user.getLoginid()+"\"></popedom> ";
	//operateString+="     <operate  href=\"javascript:sendWeChat()\"  text=\""+SystemEnv.getHtmlLabelName(32642,user.getLanguage())+"\" target=\"_self\"  index=\"0\"/>";
	//operateString+="     <operate  href=\"javascript:sendEmail()\" otherpara=\"column:email\"  text=\""+SystemEnv.getHtmlLabelName(2051,user.getLanguage())+"\" target=\"_fullwindow\"  index=\"1\"/>";
	operateString+="     <operate  href=\"javascript:sendMsg()\" otherpara=\"column:mobilephone\"  text=\""+SystemEnv.getHtmlLabelName(16635,user.getLanguage())+"\" target=\"_fullwindow\"  index=\"2\"/>";
	operateString+="     <operate  href=\"/CRM/contacter/ContacterView.jsp\"  linkkey=\"ContacterID\" linkvaluecolumn=\"id\" text=\""+SystemEnv.getHtmlLabelName(367,user.getLanguage())+"\" target=\"_blank\"  index=\"3\"/>";
	//operateString+="     <operate  href=\"javascript:deleteInfo()\" otherpara=\"column:customerid\" text=\""+SystemEnv.getHtmlLabelName(23777,user.getLanguage())+"\" target=\"_fullwindow\"  index=\"4\"/>";
	operateString+="</operates>";
String tableString=""+
			  "<table  pageId=\""+PageIdConst.CRM_ContacterSearch+"\"  pagesize=\""+PageIdConst.getPageSize(PageIdConst.CRM_ContacterSearch,user.getUID(),PageIdConst.CRM)+"\" tabletype=\"none\">"+
			  "<sql backfields=\""+backFields+"\" sqlform=\""+Util.toHtmlForSplitPage(sqlFrom)+"\" sqlprimarykey=\"id\" sqlorderby=\"customerid\" sqlsortway=\"asc\" sqlisdistinct=\"true\" sqlwhere=\""+Util.toHtmlForSplitPage(whereclause)+"\"/>"+
			  "<head>"+                             
					  "<col width=\"35%\"  text=\""+SystemEnv.getHtmlLabelName(413,user.getLanguage())+"\" column=\"firstname\" orderkey=\"firstname\" target=\"_blank\" linkkey=\"ContacterID\" linkvaluecolumn=\"id\" href=\"/CRM/contacter/ContacterView.jsp\"/>"+
					  "<col width=\"25%\"  text=\""+SystemEnv.getHtmlLabelName(462,user.getLanguage())+"\" column=\"title\" orderkey=\"title\" transmethod=\"weaver.crm.Maint.ContacterTitleComInfo.getContacterTitlename\"/>"+
					  "<col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(640,user.getLanguage())+"\" column=\"jobtitle\" orderkey=\"jobtitle\"/>"+
					  "<col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(136,user.getLanguage())+"\"  column=\"customerid\" orderkey=\"customerid\" transmethod=\"weaver.crm.Maint.CustomerInfoComInfo.getCustomerInfoname\" linkkey=\"CustomerID\" href=\"/CRM/data/ViewCustomer.jsp\"/>"+ 
			  "</head>"+operateString+
			  "</table>";
 //System.err.println("select "+backFields+" from "+sqlFrom+"  "+whereclause); 
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:onReSearch(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<wea:layout attributes="{layoutTableId:topTitle}">
	<wea:group context="" attributes="{groupDisplay:none}">
		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
			<input type="text" class="searchInput"  id="searchName" name="searchName" value="<%=Util.null2String(map.get("firstname"))%>"/>
			<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage())%></span>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</wea:item>
	</wea:group>
</wea:layout>


<!-- 高级搜索 -->
<div class="advancedSearchDiv" id="advancedSearchDiv" style="display:none;" >
<FORM id=report name=report action=ContacterSearch.jsp method=post>
<wea:layout type="4col">
	<%
	CrmFieldComInfo comInfo = new CrmFieldComInfo() ;
	rs.execute("select * from CRM_CustomerDefinFieldGroup where usetable = 'CRM_CustomerContacter' order by dsporder asc");
	while(rs.next()){
		String groupid = rs.getString("id");
		rst.execute("select count(*) from CRM_CustomerDefinField where usetable = 'CRM_CustomerContacter' and issearch= 1 and groupid = "+groupid);
		rst.next();
		if(rst.getInt(1)==0){
			continue;
		}
		
		
		%>
		<wea:group context='<%=SystemEnv.getHtmlLabelName(rs.getInt("grouplabel"),user.getLanguage())%>'>
			<% while(comInfo.next()){
				if("CRM_CustomerContacter".equals(comInfo.getUsetable())&&groupid.equals(comInfo.getGroupid().toString())){
				//没有作为搜索条件、或者是附件则跳过
				if(comInfo.getIssearch().trim().equals("") || comInfo.getIssearch().trim().equals("0") || comInfo.getFieldhtmltype() == 6){
					continue;
				}
			%>
				
				<wea:item><%=CrmUtil.getHtmlLableName(comInfo , user)%></wea:item>
				<wea:item>
					<%=CrmUtil.getHtmlElementSetting(comInfo ,Util.null2String(map.get(comInfo.getFieldname())), user , "search")%>
				</wea:item>
			<%}}%>	
			
			<%if(rs.getString("id").equals("6")){ %>
				<wea:item><%=SystemEnv.getHtmlLabelName(21313,user.getLanguage())%></wea:item>
				<wea:item>
					<brow:browser viewType="0" name="customerid" 
			         browserUrl="/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp"
			         browserValue='<%=customerid%>' 
			         browserSpanValue = '<%=CustomerInfoComInfo.getCustomerInfoname(customerid)%>'
			         isSingle="true" hasBrowser="true"  hasInput="true" isMustInput='1'
			         completeUrl="/data.jsp?type=7" width="230px" ></brow:browser>
				</wea:item>
				
			<%} %>
		</wea:group>
	<%}%>	
		
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
<input type="hidden" name="pageId" id="pageId" value="<%=PageIdConst.CRM_ContacterSearch%>">
<wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" isShowTopInfo="true"/>		
		

<script>
function onReSearch(){
	report.submit();
}

//发送微信
function sendWeChat(contractid){
	
}

//发送邮件
function sendEmail(contractid , email){
	
	var url = "/email/new/MailAdd.jsp?isInternal=0&to="+email;
	openFullWindowHaveBar(url);
}

//发送短信
function sendMsg(contractid , mobilephone){
	
	 var dlg=new window.top.Dialog();//定义Dialog对象
     dlg.currentWindow = window;
　　　dlg.Model=true;
　　　dlg.Width=700;//定义长度
　　　dlg.Height=430;
　　　dlg.URL="/sms/SmsMessageEditTab.jsp?customernumber="+mobilephone;
　　　dlg.Title="<%=SystemEnv.getHtmlLabelName(16635,user.getLanguage())%>";
　　　dlg.show();

	//var url = "/sms/SmsMessageEdit.jsp?customernumber="+mobilephone;
	//openFullWindowHaveBar(url);
}

//编辑
function editInfo(contractid){
	var url="/CRM/data/EditContacter.jsp?log=n&ContacterID="+contractid
	openFullWindowHaveBar(url);
}

//删除
function deleteInfo(contractid){
	window.top.Dialog.confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>",function(){
		jQuery.post("/CRM/data/ContacterOperation.jsp",{"method":"delete","ContacterID":contractid},function(info){
			_table.reLoad();
		});
	});
	
}


function onShowCustomer(spanid,inputid){
	var currentids=jQuery("#"+inputid).val();
	   var id1=window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/data/MutiCustomerBrowser.jsp?resourceids="+currentids);
	   if(id1){
	       var ids=id1.id;
	       var names=id1.name;
	       if(ids.length>0){
	          var tempids=ids.split(",");
	          var tempnames=names.split(",");
	          var sHtml="";
	          for(var i=0;i<tempids.length;i++){
	              var tempid=tempids[i];
	              var tempname=tempnames[i];
	              if(tempid!='')
	                sHtml = sHtml+"<a href='javascript:void(0)' onclick=openFullWindowForXtable('/CRM/data/ViewCustomer.jsp?CustomerID="+tempid+"')>"+tempname+"</a>&nbsp;";
	          }
	          ids=ids+",";
	          
	          jQuery("#"+inputid).val(ids);
	          jQuery("#"+spanid).html(sHtml);
	       }else{
	          jQuery("#"+inputid).val("");
	          jQuery("#"+spanid).html("");
	       }
       }
}

function onShowResource(spanid,inputid){
	var currentids=jQuery("#"+inputid).val();
	   var id1=window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids="+currentids);
	   if(id1){
	       var ids=id1.id;
	       var names=id1.name;
	       if(ids.length>0){
	          var tempids=ids.split(",");
	          var tempnames=names.split(",");
	          var sHtml="";
	          for(var i=0;i<tempids.length;i++){
	              var tempid=tempids[i];
	              var tempname=tempnames[i];
	              if(tempid!='')
	                sHtml = sHtml+"<a href='javascript:void(0)' onclick=openFullWindowForXtable('/hrm/resource/HrmResource.jsp?id="+tempid+"')>"+tempname+"</a>&nbsp;";
	          }
	          ids=ids+",";
	          jQuery("#"+inputid).val(ids);
	          jQuery("#"+spanid).html(sHtml);
	       }else{
	          jQuery("#"+inputid).val("");
	          jQuery("#"+spanid).html("");
	       }
       }
}

$(document).ready(function(){
			
		jQuery("#topTitle").topMenuTitle({searchFn:searchName});
		jQuery("#hoverBtnSpan").hoverBtn();
				
});

function searchName(){
	var searchName = jQuery("#searchName").val();
	window.report.action = "/CRM/search/ContacterSearch.jsp?firstname="+searchName;
	window.report.submit();
}
</script>


</BODY>
</HTML>
