
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="net.sf.json.*"%>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.workflow.workflow.TestWorkflowCheck" %>
<jsp:useBean id="DocSearchComInfo" class="weaver.docs.search.DocSearchComInfo" scope="page"/>
<jsp:useBean id="SearchComInfo" class="weaver.proj.search.SearchComInfo" scope="page"/>
<jsp:useBean id="CptSearchComInfo" class="weaver.cpt.search.CptSearchComInfo" scope="page"/>
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page"/>
<jsp:useBean id="CoworkShareManager" class="weaver.cowork.CoworkShareManager" scope="page"/>
<jsp:useBean id="BlogShareManager" class="weaver.blog.BlogShareManager" scope="page"/>
<jsp:useBean id="WorkflowRequestUtil" class="weaver.workflow.search.WorkflowRequestUtil" scope="page"/>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
User user = HrmUserVarify.getUser (request , response) ;


String resourceid = "" + user.getUID();
String currentUserId = "" + user.getUID();

JSONArray json = new JSONArray();
JSONObject data = new JSONObject();

//流程
//data.put("name","item_workflow");
//data.put("value",new java.util.Random().nextInt(9999));
//json.add(data);
Object[] workflowInfo = new String[2];
workflowInfo[1] = ""+WorkflowRequestUtil.getRequestCount(user,resourceid);
workflowInfo[0] = "/workflow/request/RequestView.jsp?resourceid="+resourceid+"&isfromtab=true";

//文档
Object[] docInfo =DocSearchComInfo.getDocCount4Hrm(resourceid,user);
data.put("name","item_word");
data.put("value",docInfo[1]);
data.put("url",docInfo[0]);
json.add(data);

//客户
String[] crmInfo = CrmShareBase.getCrmCount4Hrm(resourceid,currentUserId);
data.put("name","item_custom");
data.put("value",crmInfo[1]);
data.put("url",crmInfo[0]);
json.add(data);

//项目
String[] prjInfo = SearchComInfo.getPrjCount4Hrm(resourceid,user);
data.put("name","item_project");
data.put("value",prjInfo[1]);
data.put("url",prjInfo[0]);
json.add(data);

//资产
String[] cptInfo = CptSearchComInfo.getCptCount4Hrm(resourceid,user);
data.put("name","item_cpt");
data.put("value",cptInfo[1]);
data.put("url",cptInfo[0]);
json.add(data);
	 
//协作
String[] coworkInfo = CoworkShareManager.getCoworkCount4Hrm(resourceid,currentUserId);
data.put("name","item_cowork");
data.put("value",coworkInfo[1]);
data.put("url",coworkInfo[0]);
json.add(data);

//微博
String[] weiboInfo = BlogShareManager.getBlogCount4Hrm(resourceid);
data.put("name","item_weibo");
data.put("value",weiboInfo[1]);
data.put("url",weiboInfo[0]);
json.add(data);

//out.print(json.toString());
%>
<script language=javascript src="/js/jquery/jquery_wev8.js"></script>

<style>
	html,body{
		margin:0px 0px 0px 0px;
		padding:0px;
	}

	#PortalCenter{
		width: 100%;
		height: 240px;
		table-layout: fixed;
		
	}
	#PortalCenter td{
		height: 120px;
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
	
	.num{
		position: absolute;
		left: 0px;
		bottom: 0px;
		color: #ffffff;
		padding-left: 15px;
		padding-bottom: 10px;
		font-size: 24px;
		font-family: 微软雅黑;
	}
	
	.title{
		height:80px;
		margin:auto;
		bottom: 0px;
		color: #ffffff;
		width:80px;
		font-size: 20px;
		vertical-align:middle;
		text-align:center;
		line-height:80px;
		font-family: 微软雅黑;
		display: none;
		
		
	}
</style>
<div>
	<table id="PortalCenter" cellpadding="1" cellspacing="0">
		<tr height="120px;">
			<td height="120px;">
			<div class="module workflow" type="workflow" url="<%=workflowInfo[0] %>">
				&nbsp;
				<div class="num">
				<%=workflowInfo[1] %>
				</div>
				<div class="title">
					<%=SystemEnv.getHtmlLabelName(1207,user.getLanguage())%>
				</div>
			</div>
			</td>
			<td>
				<table width="100%" height="100%" cellpadding="0" cellspacing="0">
					<tr>
						<td width="50%" style="padding-right:1px;">
							<div class="module capital" type="capital" url="<%=cptInfo[0] %>">
							&nbsp;
								<div class="num">
								<%=cptInfo[1] %>
								</div>
								<div class="title">
								<%=SystemEnv.getHtmlLabelName(535,user.getLanguage())%>
								</div>
							</div>
							
						</td>
						<td width="50%" style="padding-left: 1px;">
							<div class="module cowork" type="cowork" url="<%=coworkInfo[0] %>">
							&nbsp;
								<div class="num">
									<%=coworkInfo[1] %>
								</div>
								<div class="title">
								<%=SystemEnv.getHtmlLabelName(17855,user.getLanguage())%>
								</div>
							</div>
						</td>
					</tr>
				
				</table>
			</td>
			<td>
				<div class="module project" type="project" url="<%=prjInfo[0]%>">
				&nbsp;
					<div class="num">
						<%=prjInfo[1] %>
					</div>
					<div class="title">
					<%=SystemEnv.getHtmlLabelName(1211,user.getLanguage())%>
					</div>
				</div>
			</td>
			
		</tr>
		<tr>
			<td>
				<div class="module crm" type="crm" url="<%=crmInfo[0] %>">
				&nbsp;
					<div class="num">
						<%=crmInfo[1] %>
					</div>
					<div class="title">
					<%=SystemEnv.getHtmlLabelName(6059,user.getLanguage())%>
					</div>
				</div>
			</td>
			<td>
				<div class="module blog" type="blog" url="<%=weiboInfo[0] %>">
				&nbsp;
					<div class="num">
						<%=weiboInfo[1] %>
					</div>
					<div class="title">
					<%=SystemEnv.getHtmlLabelName(26468,user.getLanguage())%>
					</div>
				</div>
			</td>
			<td>
				<div class="module doc" type="doc" url="<%=docInfo[0] %>">
				&nbsp;
					<div class="num">
						<%=docInfo[1] %>
					</div>
					<div class="title">
					<%=SystemEnv.getHtmlLabelName(1212,user.getLanguage())%>
					</div>
				</div>
			</td>
			
		</tr>
		
	</table>
</div>

<script type="text/javascript">
	$(".module").hover(function(){
		$(this).css("background-image","none");
		$(this).find(".title").show();
		$(this).css("opacity",'0.8')
	},function(){
		$(this).css("background-image","url(/images/homepage/portalcenter/"+$(this).attr("type")+"_wev8.png)");
		$(this).find(".title").hide();
		$(this).css("opacity",'1')
	})
	
	$(".module").click(function(){
		window.open($(this).attr("url"));
	})
</script>

