<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="java.util.*,java.sql.Timestamp" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.systeminfo.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RequestCheckUser" class="weaver.workflow.request.RequestCheckUser" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="FieldComInfo" class="weaver.workflow.field.FieldComInfo" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page"/>

<%	
User user = new User() ;
user = HrmUserVarify.checkUser(request , response) ;
int userid = 0;
int language = 7;
String logintype = "2";
String userName = "";
if (user==null)
{
user = new User() ;
user.setUid(0);
user.setLanguage(7);
user.setLogintype("2");
}
else
{
 userid = user.getUID();
 logintype = user.getLogintype();
 language = user.getLanguage() ;
 userName =  user.getUsername() ;
}

//获得工作流的基本信息
String workflowid = Util.null2String(request.getParameter("workflowid"));
String workflowname = WorkflowComInfo.getWorkflowname(workflowid);
workflowname = Util.processBody(workflowname,user.getLanguage()+"");
String workflowtype = WorkflowComInfo.getWorkflowtype(workflowid);   //工作流种类
String nodeid= "" ;
String formid= "" ;
String isbill="0";
int helpdocid = 0;

//获得当前用户的id，类型和名称。如果类型为1，表示为内部用户（人力资源），2为外部用户（CRM）

if(logintype.equals("1"))
	userName = Util.toScreen(ResourceComInfo.getResourcename(""+userid),language) ;
if(logintype.equals("2"))
	userName = Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(""+userid),language);


//查询该工作流的表单id，是否是单据（0否，1是），帮助文档id
RecordSet.executeProc("workflow_Workflowbase_SByID",workflowid);
if(RecordSet.next()){
	formid = Util.null2String(RecordSet.getString("formid"));
	isbill = ""+Util.getIntValue(RecordSet.getString("isbill"),0);
	helpdocid = Util.getIntValue(RecordSet.getString("helpdocid"),0);
}

//查询该工作流的当前节点id （即改工作流的创建节点 ）
RecordSet.executeProc("workflow_CreateNode_Select",workflowid);
if(RecordSet.next())  nodeid = Util.null2String(RecordSet.getString(1)) ;


/*检查用户是否有创建权限
RequestCheckUser.setUserid(userid);
RequestCheckUser.setWorkflowid(Util.getIntValue(workflowid,0));
RequestCheckUser.setLogintype(logintype);
RequestCheckUser.checkUser();
int  hasright=RequestCheckUser.getHasright();

if(hasright==0){
	response.sendRedirect("/notice/noright.jsp");
    return;
}*/


//对不同的模块来说,可以定义自己相关的内容，作为请求默认值，比如将 docid 赋值，作为该请求的默认文档
//默认的值可以赋多个，中间用逗号格开

String prjid = Util.null2String(request.getParameter("prjid"));
String docid = Util.null2String(request.getParameter("docid"));
String crmid = Util.null2String(request.getParameter("crmid"));
String hrmid = Util.null2String(request.getParameter("hrmid"));
if(hrmid.equals("") && logintype.equals("1")) hrmid = "" + userid ;
if(crmid.equals("") && logintype.equals("2")) crmid = "" + userid ;

//工作流建立完成后将返回的页面
String topage = Util.null2String(request.getParameter("topage"));




//获得当前的日期和时间
Calendar today = Calendar.getInstance();
String currentdate = Util.add0(today.get(Calendar.YEAR), 4) + "-" +
                     Util.add0(today.get(Calendar.MONTH) + 1, 2) + "-" +
                     Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;

String currenttime = Util.add0(today.get(Calendar.HOUR_OF_DAY), 2) + ":" +
                     Util.add0(today.get(Calendar.MINUTE), 2) + ":" +
                     Util.add0(today.get(Calendar.SECOND), 2) ;
        
//请求提交的时候需要检查必输的字段名，多个必输项用逗号格开，requestname为新建请求中第一行的请求说明，是每一个请求都必须有的
String needcheck="requestname";


//开始日期和结束日期比较用
String newfromdate="a";
String newenddate="b";

//TopTitle.jsp 页面参数
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(648,language)+":"
	+SystemEnv.getHtmlLabelName(125,language)+" - "+Util.toScreen(workflowname,language);
String needfav ="1";
String needhelp ="";

%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/weaver_wev8.js"></script>
</head>

<BODY>

<%
String createpage = "" ;
String operationpage = "" ;
if(isbill.equals("1")) {
    RecordSet.executeProc("bill_includepages_SelectByID",formid+"");
    if(RecordSet.next())  {
        createpage = Util.null2String(RecordSet.getString("createpage"));
        operationpage = Util.null2String(RecordSet.getString("operationpage"));
    }
}

if( ! createpage.equals("") ) {
%>
    <jsp:include page="<%=createpage%>" flush="true">
    <jsp:param name="workflowid" value="<%=workflowid%>" />
    <jsp:param name="workflowtype" value="<%=workflowtype%>" />
    <jsp:param name="nodeid" value="<%=nodeid%>" />
    <jsp:param name="formid" value="<%=formid%>" />
    <jsp:param name="prjid" value="<%=prjid%>" />
    <jsp:param name="docid" value="<%=docid%>" />
    <jsp:param name="hrmid" value="<%=hrmid%>" />
    <jsp:param name="crmid" value="<%=crmid%>" />
    <jsp:param name="topage" value="<%=topage%>" />
    <jsp:param name="currentdate" value="<%=currentdate%>" />
    <jsp:param name="currenttime" value="<%=currenttime%>" />
    <jsp:param name="topage" value="<%=topage%>" />
    </jsp:include>
<%
} else{ 
    if( operationpage.equals("") ) operationpage = "RequestOperation.jsp" ;
%>
    <form name="frmmain" method="post" action="<%=operationpage%>">
        <%@ include file="WorkflowAddRequestBody.jsp" %>
    </form>
<%}%>


<SCRIPT LANGUAGE=VBS>
sub onShowBrowser(id,url,linkurl,type1,ismand)
	if type1= 2 or type1 = 19 then
		id1 = window.showModalDialog(url,,"dialogHeight:320px;dialogwidth:275px")
		document.all("field"+id+"span").innerHtml = id1
		document.all("field"+id).value=id1
	else
		if type1 <> 17 and type1 <> 18 and type1<>27 and type1<>37 and type1<>45 and type1<>4 and type1<>167 and type1<>164 and type1<>169 and type1<>170 then
			id1 = window.showModalDialog(url)
		elseif type1=4 or type1=167 or type1=164 or type1=169 or type1=170 then
            tmpids = document.all("field"+id).value
			id1 = window.showModalDialog(url&"?selectedids="&tmpids)
		else
			tmpids = document.all("field"+id).value
			id1 = window.showModalDialog(url&"?resourceids="&tmpids)
		end if
		if NOT isempty(id1) then
			if type1 = 17 or type1 = 18 or type1=27 or type1=37 or type1=45 then
				if id1(0)<> ""  and id1(0)<> "0" then
					resourceids = id1(0)
					resourcename = id1(1)
					sHtml = ""
					resourceids = Mid(resourceids,2,len(resourceids))
					document.all("field"+id).value= resourceids
					resourcename = Mid(resourcename,2,len(resourcename))
					while InStr(resourceids,",") <> 0
						curid = Mid(resourceids,1,InStr(resourceids,",")-1)
						curname = Mid(resourcename,1,InStr(resourcename,",")-1)
						resourceids = Mid(resourceids,InStr(resourceids,",")+1,Len(resourceids))
						resourcename = Mid(resourcename,InStr(resourcename,",")+1,Len(resourcename))
						sHtml = sHtml&"<a href="&linkurl&curid&">"&curname&"</a>&nbsp"
					wend
					sHtml = sHtml&"<a href="&linkurl&resourceids&">"&resourcename&"</a>&nbsp"
					document.all("field"+id+"span").innerHtml = sHtml
					
				else
					if ismand=0 then
						document.all("field"+id+"span").innerHtml = empty
					else
						document.all("field"+id+"span").innerHtml ="<img src='/images/BacoError_wev8.gif' align=absmiddle>"
					end if
					document.all("field"+id).value=""
				end if
				
			else	
			   if  id1(0)<>""   and id1(0)<> "0"  then
			        if linkurl = "" then 
						document.all("field"+id+"span").innerHtml = id1(1)
					else 
						document.all("field"+id+"span").innerHtml = "<a href="&linkurl&id1(0)&">"&id1(1)&"</a>"
					end if
					document.all("field"+id).value=id1(0)
				else
					if ismand=0 then
						document.all("field"+id+"span").innerHtml = empty
					else
						document.all("field"+id+"span").innerHtml ="<img src='/images/BacoError_wev8.gif' align=absmiddle>"
					end if
					document.all("field"+id).value=""
				end if
			end if
		end if
	end if
end sub


sub getDate(i)
	returndate = window.showModalDialog("/systeminfo/Calendar.jsp",,"dialogHeight:320px;dialogwidth:275px")
	document.all("datespan"&i).innerHtml= returndate
	document.all("dff0"&i).value=returndate
end sub

</script>
<script language=javascript>
function check_form(thiswins,items)
{
	thiswin = thiswins
	items = items + ",";
	
	for(i=1;i<=thiswin.length;i++)
	{
	tmpname = thiswin.elements[i-1].name;
	tmpvalue = thiswin.elements[i-1].value;
	while(tmpvalue.indexOf(" ") == 0)
		tmpvalue = tmpvalue.substring(1,tmpvalue.length);
	
	if(tmpname!="" &&items.indexOf(tmpname+",")!=-1 && tmpvalue == ""){
		 alert("<%=SystemEnv.getHtmlNoteName(14,language)%>");
		 return false;
		}

	}
	return true;
}

function isdel(){
   if(!confirm("确定要删除吗？")){
       return false;
   }
       return true;
   } 


function issubmit(){
   if(!confirm("确定要提交吗？")){
       return false;
   }
       return true;
   } 
</script>
</body>
</html>



