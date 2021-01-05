
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="net.sf.json.*"%>
<%@page import="java.util.List"%>
<%@page import="java.util.*"%>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.systeminfo.SystemEnv" %>
<%@ page import="weaver.workflow.workflow.TestWorkflowCheck" %>
<jsp:useBean id="DocSearchComInfo" class="weaver.docs.search.DocSearchComInfo" scope="page"/>
<jsp:useBean id="SearchComInfo" class="weaver.proj.search.SearchComInfo" scope="page"/>
<jsp:useBean id="CptSearchComInfo" class="weaver.cpt.search.CptSearchComInfo" scope="page"/>
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page"/>
<jsp:useBean id="CoworkShareManager" class="weaver.cowork.CoworkShareManager" scope="page"/>
<jsp:useBean id="BlogShareManager" class="weaver.blog.BlogShareManager" scope="page"/>
<jsp:useBean id="WorkflowRequestUtil" class="weaver.workflow.search.WorkflowRequestUtil" scope="page"/>
<jsp:useBean id="MeetingUtil" class="weaver.meeting.MeetingUtil" scope="page"/>
<jsp:useBean id="WorkPlanShareUtil" class="weaver.WorkPlan.WorkPlanShareUtil" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />

<!-- 判断元素是否可以独立显示，引入样式 -->
<%
	String indie = Util.null2String(request.getParameter("indie"), "false");
	if ("true".equals(indie)) {
%>
		<%@ include file="/homepage/HpElementCss.jsp" %>
<%	} %>


<%
response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
User user = HrmUserVarify.getUser (request , response) ;


String resourceid = "" + user.getUID();
String currentUserId = "" + user.getUID();
String eid = request.getParameter("eid");

JSONArray json = new JSONArray();
JSONObject data = new JSONObject();

//流程
//data.put("name","item_workflow");
//data.put("value",new java.util.Random().nextInt(9999));
//json.add(data);
Object[] workflow = new String[2];
workflow[1] = ""+WorkflowRequestUtil.getRequestCount(user,resourceid);
workflow[0] = "/workflow/request/RequestView.jsp?resourceid="+resourceid+"&isfromtab=true";

//流程
//Object[] todo =DocSearchComInfo.getDocCount4Hrm(resourceid,user);
data.put("name","workflow");
data.put("value",workflow[1]);
data.put("url",workflow[0]);
json.add(data);

//文档
Object[] doc =DocSearchComInfo.getDocCount4Hrm(resourceid,user);
data.put("name","doc");
data.put("value",doc[1]);
data.put("url",doc[0]);
json.add(data);

//客户
String[] crm = CrmShareBase.getCrmCount4Hrm(resourceid,currentUserId);
data.put("name","crm");
data.put("value",crm[1]);
data.put("url",crm[0]);
json.add(data);

//项目
String[] project = SearchComInfo.getPrjCount4Hrm(resourceid,user);
data.put("name","project");
data.put("value",project[1]);
data.put("url",project[0]);
json.add(data);

//资产
String[] capital = CptSearchComInfo.getCptCount4Hrm(resourceid,user);

data.put("name","capital");
data.put("value",capital[1]);
data.put("url",capital[0]);
json.add(data);
	 
//协作
String[] cowork = CoworkShareManager.getCoworkCount4Hrm(resourceid,currentUserId);
data.put("name","cowork");
data.put("value",cowork[1]);
data.put("url",cowork[0]);
json.add(data);

//微博
String[] blog = BlogShareManager.getBlogCount4Hrm(resourceid);
data.put("name","blog");
data.put("value",blog[1]);
data.put("url",blog[0]);
json.add(data);


//会议
String[] meeting=MeetingUtil.getMeetingCount(user);
data.put("name","blog");
data.put("value",meeting[1]);
data.put("url",meeting[0]);
json.add(data);
//日程
String[] wp=WorkPlanShareUtil.getWPCount(user);
data.put("name","blog");
data.put("value",wp[1]);
data.put("url",wp[0]);
json.add(data);
//out.print(json.toString());

String openlink = "1";
List list = new ArrayList();
rs.execute("select id from DataCenterUserSetting where eid='"+eid+"' and userid="+resourceid);
if(!rs.next()){
	String insertStr = "insert into DataCenterUserSetting (userid,eid,openlink,todo,todocolor,asset,assetcolor,cowork,coworkcolor,proj,projcolor,customer,customercolor,blog,blogcolor,mydoc,mydoccolor,meetting,meettingcolor,workplan,workplancolor) values ('"+resourceid+"','"+eid+"','2','on','#33A3FF','on','#FFD200','on','#FD9000','on','#CB61FE','on','#6871E3','on','#56DE73','on','#FD2677','on','#6871E3','on','#CB61FE')";
	rs2.execute("select userid from DataCenterUserSetting where eid = "+eid+" and usertype=3");
	if(rs2.next()){
		String t_userid = rs2.getString("userid");
		insertStr = "insert into DataCenterUserSetting (userid,eid,openlink,todo,todocolor,asset,assetcolor,cowork,coworkcolor,proj,projcolor,customer,customercolor,blog,blogcolor,mydoc,mydoccolor,meetting,meettingcolor,workplan,workplancolor) select "+resourceid+",eid,openlink,todo,todocolor,asset,assetcolor,cowork,coworkcolor,proj,projcolor,customer,customercolor,blog,blogcolor,mydoc,mydoccolor,meetting,meettingcolor,workplan,workplancolor from DataCenterUserSetting where eid ="+eid+" and userid = "+t_userid;
	}
	rs2.execute(insertStr);
}

rs.execute("select openlink,todo,todocolor,asset,assetcolor,cowork,coworkcolor,proj,projcolor,customer,customercolor,blog,blogcolor,mydoc,mydoccolor,meetting,meettingcolor,workplan,workplancolor from DataCenterUserSetting where eid='"+eid+"' and userid="+resourceid);
if(rs.next()){
	openlink = Util.null2String(rs.getString("openlink"));
	if("on".equals(rs.getString("todo"))) {
		Hashtable item = new Hashtable();
		item.put("model","workflow");
		item.put("label","1207");
		item.put("color",rs.getString("todocolor"));
		item.put("value",workflow[1]);
		item.put("url",workflow[0]);
		list.add(item);
		//list.add("workflow,1207,"+rs.getString("todocolor")+","+workflow[0]+","+workflow[1]);
	}
	if("on".equals(rs.getString("asset"))) {
		Hashtable item = new Hashtable();
		item.put("model","capital");
		item.put("label","30044");
		item.put("color",rs.getString("assetcolor"));
		item.put("value",capital[1]);
		item.put("url",capital[0]);
		list.add(item);
		//list.add("capital,30044,"+rs.getString("assetcolor")+","+capital[0]+","+capital[1]);
	}
	if("on".equals(rs.getString("cowork"))) {
		Hashtable item = new Hashtable();
		item.put("model","cowork");
		item.put("label","17855");
		item.put("color",rs.getString("coworkcolor"));
		item.put("value",cowork[1]);
		item.put("url",cowork[0]);
		list.add(item);
		//list.add("cowork,17855,"+rs.getString("coworkcolor")+","+cowork[0]+","+cowork[1]);
	}
	if("on".equals(rs.getString("proj"))) {
		Hashtable item = new Hashtable();
		item.put("model","project");
		item.put("label","1211");
		item.put("color",rs.getString("projcolor"));
		item.put("value",project[1]);
		item.put("url",project[0]);
		list.add(item);
		//list.add("project,1211,"+rs.getString("projcolor")+","+project[0]+","+project[1]);
	}
	if("on".equals(rs.getString("customer"))){
		Hashtable item = new Hashtable();
		item.put("model","crm");
		item.put("label","6059");
		item.put("color",rs.getString("customercolor"));
		item.put("value",crm[1]);
		item.put("url",crm[0]);
		list.add(item);
		//list.add("crm,6059,"+rs.getString("customercolor")+","+crm[0]+","+crm[1]);
	}
	if("on".equals(rs.getString("blog"))){
		Hashtable item = new Hashtable();
		item.put("model","blog");
		item.put("label","26468");
		item.put("color",rs.getString("blogcolor"));
		item.put("value",blog[1]);
		item.put("url",blog[0]);
		list.add(item);
		//list.add("blog,26468,"+rs.getString("blogcolor")+","+blog[0]+","+blog[1]);
	}
	if("on".equals(rs.getString("mydoc"))) {
		Hashtable item = new Hashtable();
		item.put("model","doc");
		item.put("label","1212");
		item.put("color",rs.getString("mydoccolor"));
		item.put("value",doc[1]);
		item.put("url",doc[0]);
		list.add(item);
		//list.add("doc,1212,"+rs.getString("mydoccolor")+","+doc[0]+","+doc[1]);
	}
	
	
	if("on".equals(rs.getString("meetting"))) {
		Hashtable item = new Hashtable();
		item.put("model","meetting");
		item.put("label","2102");
		item.put("color",rs.getString("meettingcolor"));
		item.put("value",meeting[1]);
		item.put("url",meeting[0]);
		list.add(item);
		//list.add("doc,1212,"+rs.getString("mydoccolor")+","+doc[0]+","+doc[1]);
	}
	
	if("on".equals(rs.getString("workplan"))) {
		Hashtable item = new Hashtable();
		item.put("model","workplan");
		item.put("label","18480");
		item.put("color",rs.getString("workplancolor"));
		item.put("value",wp[1]);
		item.put("url",wp[0]);
		list.add(item);
		//list.add("doc,1212,"+rs.getString("mydoccolor")+","+doc[0]+","+doc[1]);
	}
}
int size = list.size();
%>

<style>
	html,body{
		margin:0px 0px 0px 0px;
		padding:0px;
	}

	.module{
		width: 100%;
		height: 100%;
		position: relative;
		cursor: pointer;
	}
	
	.workflow{
		background-color:#33a3ff;
		background-image: url("/images/homepage/portalcenter/workflow_wev8.png");
		background-position: center center;
		background-repeat: no-repeat;
	}
	
	.project{
		background-color:#cb61fe;
		background-image: url("/images/homepage/portalcenter/project_wev8.png");
		background-position: center center;
		background-repeat: no-repeat;
	}
	
	.capital{
		background-color:#ffd200;
		background-image: url("/images/homepage/portalcenter/capital_wev8.png");
		background-position: center center;
		background-repeat: no-repeat;
	}
	
	.cowork{
		background-color:#fd9000;
		background-image: url("/images/homepage/portalcenter/cowork_wev8.png");
		background-position: center center;
		background-repeat: no-repeat;
	}
	
	.crm{
		background-color:#6871e3;
		background-image: url("/images/homepage/portalcenter/crm_wev8.png");
		background-position: center center;
		background-repeat: no-repeat;
	}
	
	.blog{
		background-color:#56de37;
		background-image: url("/images/homepage/portalcenter/blog_wev8.png");
		background-position: center center;
		background-repeat: no-repeat;
		
	}
	
	
	.doc{
		background-color:#fd2677;
		background-image: url("/images/homepage/portalcenter/doc_wev8.png");
		background-position: center center;
		background-repeat: no-repeat;
		
	}
	
	.meetting{
		background-color:#fd2677;
		background-image: url("/images/homepage/portalcenter/meetting_wev8.png");
		background-position: center center;
		background-repeat: no-repeat;
		
	}
	
	.workplan{
		background-color:#fd2677;
		background-image: url("/images/homepage/portalcenter/workplan_wev8.png");
		background-position: center center;
		background-repeat: no-repeat;
		
	}
</style>
<div style="height:100%;width:100%">
	<table id="PortalCenter" cellpadding="1" cellspacing="0">
	<%
	if(size<4){%>
		<tr>
		<%
		for(Object obj : list){
			Hashtable item = (Hashtable)obj;
			String model = (String)item.get("model");
			int label = Integer.parseInt((String)item.get("label"));
			String color = (String)item.get("color");
			String url = (String)item.get("url");
			String num = (String)item.get("value");
		%>
			<td style="height:100%;">
				<div class="module <%=model%>" type="<%=model%>" url="<%=url%>" style="background-color:<%=color%>;">
					<div class="num"><%=num%></div>
					<div class="mtitle" style="line-height:200px;"><%=SystemEnv.getHtmlLabelName(label,user.getLanguage())%></div>
				</div>
			</td>
		<%}%>
		</tr>
	<%}else if(size==4){
		for(int i=0;i<4;i++){
			Hashtable item = (Hashtable)list.get(i);
			String model = (String)item.get("model");
			int label = Integer.parseInt((String)item.get("label"));
			String color = (String)item.get("color");
			String url = (String)item.get("url");
			String num = (String)item.get("value");
			if(i==0||i==2) out.println("<tr>");
		%>
			<td style="height:50%;">
				<div class="module <%=model%>" type="<%=model%>" url="<%=url%>" style="background-color:<%=color%>;">
					<div class="num"><%=num%></div>
					<div class="mtitle"><%=SystemEnv.getHtmlLabelName(label,user.getLanguage())%></div>
				</div>
			</td>
		<%
		if(i==1||i==3) out.println("</tr>");
		}
	}else if(size==5){
		for(int i=0;i<5;i++){
			Hashtable item = (Hashtable)list.get(i);
			String model = (String)item.get("model");
			int label = Integer.parseInt((String)item.get("label"));
			String color = (String)item.get("color");
			String url = (String)item.get("url");
			String num = (String)item.get("value");
			String rowspan="";
			String style = "";
			String height = "height:50%;";
			if(i==0||i==3) out.println("<tr>");
			if(i==1) {
				rowspan="rowspan='2'";
				height = "height:100%;";
				style="style='line-height:100%;'";
			}
		if(i==0||i==2||i==3||i==4){
		%>
		   <td style="height:50%;" >
                    <div class="module <%=model%>" type="<%=model%>" url="<%=url%>" style="background-color:<%=color%>;height:120px;">
                        <div class="num"><%=num%></div>
                        <div class="mtitle" style='line-height:120px;'><%=SystemEnv.getHtmlLabelName(label,user.getLanguage())%></div>
                    </div>
                </td>
		    
		   <% 
		    }
		    if(i==1){%> 
			    <td style="height:100%;" rowspan='2'>
	                <div class="module <%=model%>" type="<%=model%>" url="<%=url%>" style="background-color:<%=color%>;height:240px;">
	                    <div class="num"><%=num%></div>
	                    <div class="mtitle" style='line-height:240px;'><%=SystemEnv.getHtmlLabelName(label,user.getLanguage())%></div>
	                </div>
	            </td>
		   
			
		<% }
			if(i==2||i==4) out.println("</tr>");
		}%>
	<%}else if(size==6){
		for(int i=0;i<6;i++){
			Hashtable item = (Hashtable)list.get(i);
			String model = (String)item.get("model");
			int label = Integer.parseInt((String)item.get("label"));
			String color = (String)item.get("color");
			String url = (String)item.get("url");
			String num = (String)item.get("value");
			if(i==0||i==3) out.println("<tr>");
		%>
			<td style="height:50%;">
				<div class="module <%=model%>" type="<%=model%>" url="<%=url%>" style="background-color:<%=color%>;">
					<div class="num"><%=num%></div>
					<div class="mtitle"><%=SystemEnv.getHtmlLabelName(label,user.getLanguage())%></div>
				</div>
			</td>
		<%
		if(i==2||i==5) out.println("</tr>");
		}
	}else if(size==7){
		for(int i=0;i<7;i++){
			Hashtable item = (Hashtable)list.get(i);
			String model = (String)item.get("model");
			int label = Integer.parseInt((String)item.get("label"));
			String color = (String)item.get("color");
			String url = (String)item.get("url");
			String num = (String)item.get("value");
			String colspan="colspan='2'";
			String width = "width:32%;";
			if(i==0||i==4) out.println("<tr>");
			if(i==1||i==2) {
				colspan="";
				width = "width:18%;";
			}
		%>
			<td style="height:50%;<%=width%>" <%=colspan%>>
				<div class="module <%=model%>" type="<%=model%>" url="<%=url%>" style="background-color:<%=color%>;">
					<div class="num"><%=num%></div>
					<div class="mtitle"><%=SystemEnv.getHtmlLabelName(label,user.getLanguage())%></div>
				</div>
			</td>
		<%
			if(i==3||i==6) out.println("</tr>");
		}%>
	<%}else if(size==8){
		for(int i=0;i<8;i++){
			Hashtable item = (Hashtable)list.get(i);
			String model = (String)item.get("model");
			int label = Integer.parseInt((String)item.get("label"));
			String color = (String)item.get("color");
			String url = (String)item.get("url");
			String num = (String)item.get("value");
			String colspan="colspan='2'";
			String width = "width:32%;";
			if(i==0||i==4) out.println("<tr>");
			if(i==1||i==2||i==4||i==5) {
				colspan="";
				width = "width:18%;";
			}
		%>
			<td style="height:50%;<%=width%>" <%=colspan%>>
				<div class="module <%=model%>" type="<%=model%>" url="<%=url%>" style="background-color:<%=color%>;">
					<div class="num"><%=num%></div>
					<div class="mtitle"><%=SystemEnv.getHtmlLabelName(label,user.getLanguage())%></div>
				</div>
			</td>
		<%
			if(i==3||i==7) out.println("</tr>");
		}
	}else if(size==9){

		for(int i=0;i<9;i++){
			Hashtable item = (Hashtable)list.get(i);
			String model = (String)item.get("model");
			int label = Integer.parseInt((String)item.get("label"));
			String color = (String)item.get("color");
			String url = (String)item.get("url");
			String num = (String)item.get("value");
			String colspan="colspan='2'";
			String width = "width:32%;";
			if(i==0||i==4) out.println("<tr>");
			if(i==1||i==2||i==4||i==5||i==7||i==8) {
				colspan="";
				width = "width:18%;";
			}
		%>
			<td style="height:50%;<%=width%>" <%=colspan%>>
				<div class="module <%=model%>" type="<%=model%>" url="<%=url%>" style="background-color:<%=color%>;">
					<div class="num"><%=num%></div>
					<div class="mtitle"><%=SystemEnv.getHtmlLabelName(label,user.getLanguage())%></div>
				</div>
			</td>
		<%
			if(i==3||i==8) out.println("</tr>");
		}
	
	}%>
	</table>
</div>

<script type="text/javascript">
	$(".module").hover(function(){
		$(this).css("background-image","none");
		$(this).find(".mtitle").show();
		$(this).css("opacity",'0.8')
	},function(){
		$(this).css("background-image","url(/images/homepage/portalcenter/"+$(this).attr("type")+"_wev8.png)");
		$(this).find(".mtitle").hide();
		$(this).css("opacity",'1')
	})
	
	$(".module").click(function(){
		if("2"=="<%=openlink%>") window.open($(this).attr("url"));
		else parent.window.open($(this).attr("url"),"_self");
	})
	$(document).ready(function(){
		var curH = $('#PortalCenter').height() ;
		var style = $('#PortalCenter').parent().parent().attr("style");
		if(style==undefined || style.indexOf('height: auto') != -1 || curH < 50){
			$('#PortalCenter').parent().parent().height('240px') ;
		}
		var moduleSize=$('#PortalCenter').find(".module").length;
		if(moduleSize!=5){
			setCenterHeight()
			setDataCenterHeight()
		}
	});
	function  setCenterHeight(){
		$('#PortalCenter').find(".module").each(function(){
			var tH = $(this).height()
			$(this).find(".mtitle").height("100%")
			$(this).find(".mtitle").css('line-height',tH+'px');
		})
	}
	function  setDataCenterHeight(){
		$('#PortalCenter').find(".module").each(function(){
			var tH = $(this).find(".mtitle").css('line-height');
			$(this).height(tH);
		})
	}
</script>

