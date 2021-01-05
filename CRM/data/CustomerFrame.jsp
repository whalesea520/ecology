
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" " http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page import="weaver.crm.CrmShareBase"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ include file="/systeminfo/leftMenuCommon.jsp" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>


<%
int userid=user.getUID();

String iframesrc = "";
String type = Util.null2String(request.getParameter("type"));
if("mine".equals(type)){//我的客户
	iframesrc="/CRM/data/MineCustomerTabFrame.jsp?";
}
if("share".equals(type)){//批量共享
	iframesrc="/CRM/report/BatchShareTabFrame.jsp?";
}
if("search".equals(type)||"quick".equals(type)){//查询客户
	iframesrc="/CRM/search/SearchTabFrame.jsp?type="+type+"&";
}

if("monitor".equals(type)){//客户监控
	iframesrc="/system/systemmonitor/crm/CustomerMonitorTabName.jsp?";
}
%>

<link rel="stylesheet" href="/css/ecology8/request/leftNumMenu_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/leftNumMenu_wev8.js"></script>
<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>


<%

int mainType = 2;//客户状态 【0为type；1为description；2为status；3为size】
int subType = 1;//客户描述【0为type；1为description；2为status；3为size】
String[] tabArr = {"CRM_CustomerType","CRM_CustomerDesc","CRM_CustomerStatus","CRM_CustomerSize"};
String[] fieldArr = {"type","Description","status","size_n"};

RecordSet.execute("select mainType , subType from CRM_CustomerTypePersonal where userId = "+userid);
while(RecordSet.next()){
	mainType = RecordSet.getInt("mainType");
	subType = RecordSet.getInt("subType");
}
String menuUrl = iframesrc + "&mainType="+mainType+"&subType="+subType;

%>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
// RCFromPage="mailOption";//屏蔽右键菜单时使用
RCMenu += "{分类定制,javascript:setCustomerTypePersonal(),_self} " ;    
RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

</head>
<body>
<table cellspacing="0" cellpadding="0" class="flowsTable" style="width:100%;"  >

	<tr>
		<td class="leftTypeSearch">
			<div class="topMenuTitle">
				<span class="leftType">
				<span><img style="vertical-align:middle;" src="/images/ecology8/request/alltype_wev8.png" width="18"/></span>
				<span><%=SystemEnv.getHtmlLabelName(82857,user.getLanguage())%>(<%//=this.getCountByType(-1,null,-1,null,userid) %>)
				</span>
				</span>
				<span class="leftSearchSpan">
					&nbsp;<input type="text" class="leftSearchInput" />
				</span>
				
			</div>
		</td>
		
		<td rowspan="2">
			<iframe src="<%=menuUrl%>" class="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
		</td>
	</tr>
	
	<tr>
		<td style="width:23%;" class="flowMenusTd">
			<div class="flowMenuDiv"  >
				<div style="overflow:hidden;height:300px;position:relative;" id="overFlowDiv" >
					<div class="ulDiv" ></div>
				</div>
			</div>
		</td>
	</tr>
</table>
	
	
</body>
<script>

var demoLeftMenus="";
var menuUrl = "";
var mainType = "";
var subType = "";
var diag = null;
function refreshTab(newMainType , newSubType){
	if(diag){
		diag.close();
	}
	
	if(newMainType != mainType || newSubType != subType){
		mainType = newMainType;
		subType = newSubType;
		menuUrl = "<%=iframesrc%>&mainType="+mainType+"&subType="+subType;
		jQuery(".ulDiv").html("");
		jQuery.ajax({
			url:"/CRM/data/CustomerFrameOperation.jsp",
			async: true,
			beforeSend:function(){
				if(jQuery(".leftTypeSearch").css("display") === "none");
				else
					e8_before2();
			},
			complete:function(){
				e8_after2();
			},
			data:{
				mainType:mainType,
				subType:subType
			},
			success:function(data){
				demoLeftMenus = eval('('+data+')');
				flowPageManager.loadFunctions.leftNumMenu();
				jQuery(".ulDiv").height(jQuery(".ulDiv").children(":first").height());
				window.setTimeout(function(){
					jQuery(".ulDiv").height(jQuery(".ulDiv").children(":first").height());
				},1000);
			}
		});
	}
}


function setCustomerTypePersonal(){
	
	diag =getDialog("<%=SystemEnv.getHtmlLabelName(455,user.getLanguage())+SystemEnv.getHtmlLabelName(343,user.getLanguage()) %>",400,200);
	diag.URL = "/CRM/data/AddCustomerTypePersonal.jsp?"+new Date().getTime();
	diag.show();
	document.body.click();

}

function getDialog(title,width,height){
    var diag =new window.top.Dialog();
    diag.currentWindow = window; 
    diag.Modal = true;
    diag.Drag=true;
	diag.Width =width?width:680;
	diag.Height =height?height:420;
	diag.ShowButtonRow=false;
	diag.Title = title;
	return diag;
} 

</script>

<%!

	private int getCountByType(int mainType ,String mainTypeId, int subType , String subTypeId, int userid){
		int count = 0;
		try{
			CrmShareBase crmShareBase = new CrmShareBase();
			String leftjointable = crmShareBase.getTempTable(userid+"");
			String sql ="select count(DISTINCT id)  from CRM_CustomerInfo t1 left join "+leftjointable+"  t2 on t1.id = t2.relateditemid  where t1.id = t2.relateditemid and deleted=0";
			String[] fieldArr = {"type","Description","status","size_n"};
			
			if(-1 != mainType){
				sql += " and "+fieldArr[mainType] +" = "+mainTypeId;
			}
			
			if(-1 != subType){
				sql += " and "+fieldArr[subType] +" = "+subTypeId;
			}
			RecordSet rs = new RecordSet();
			rs.execute(sql);
			rs.next();
			count = rs.getInt(1);
		
		}catch(Exception e){
			e.printStackTrace();
		}
		
		return count;
	}

 %>
</html>

