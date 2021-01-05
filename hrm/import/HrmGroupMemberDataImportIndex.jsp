<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.systeminfo.SystemEnv" %>
<%@ page import="java.util.*"%>
<%
response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
User user = HrmUserVarify.getUser (request , response) ;
//增加权限控制，只有管理员才能查看
if(!user.getLoginid().toLowerCase().equals("sysadmin")){
	response.sendRedirect("/notice/noright.jsp");
	return;
}

List<Hashtable<String, String>> list = new ArrayList<Hashtable<String, String>>();
//组织
Hashtable<String, String> item = new Hashtable<String, String>();
item.put("model","company");
item.put("label","376");
item.put("detiallabel","125432");
item.put("pathlabel","33596");
item.put("color","");
item.put("value","");
item.put("url","/hrm/HrmDialogTab.jsp?_fromURL=HrmResourceImport&importtype=company");
item.put("pathurl","/hrm/companyvirtual/HrmCompany_frm.jsp");
list.add(item);
//岗位
item = new Hashtable<String, String>();
item.put("model","jobtitle");
item.put("label","6086");
item.put("detiallabel","125443");
item.put("pathlabel","82664");
item.put("color","");
item.put("value","");
item.put("url","/hrm/HrmDialogTab.jsp?_fromURL=HrmResourceImport&importtype=jobtitle");
item.put("pathurl","/hrm/jobtitlestemplet/index.jsp");
list.add(item);
//人员
item = new Hashtable<String, String>();
item.put("model","resource");
item.put("label","1867");
item.put("detiallabel","125444");
item.put("pathlabel","33596");
item.put("color","");
item.put("value","");
item.put("url","/hrm/HrmTab.jsp?_fromURL=HrmImport");
item.put("pathurl","/hrm/companyvirtual/HrmCompany_frm.jsp");
list.add(item);
//组
item = new Hashtable<String, String>();
item.put("model","group");
item.put("label","2026");
item.put("detiallabel","125445");
item.put("pathlabel","18166");
item.put("color","");
item.put("value","");
item.put("url","/hrm/HrmDialogTab.jsp?_fromURL=HrmResourceImport&importtype=group");
item.put("pathurl","/systeminfo/menuconfig/CustomSetting.jsp?_fromURL=2");
list.add(item);
//个人数据
item = new Hashtable<String, String>();
item.put("model","resourcedetial");
item.put("label","125429");
item.put("detiallabel","125678");
item.put("pathlabel","33596");
item.put("color","");
item.put("value","");
item.put("url","/hrm/HrmDialogTab.jsp?_fromURL=HrmResourceImport&importtype=resourcedetial");
item.put("pathurl","/hrm/companyvirtual/HrmCompany_frm.jsp");
list.add(item);
//位置
/*
item = new Hashtable<String, String>();
item.put("model","city");
item.put("label","22981");
item.put("detiallabel","125450");
item.put("pathlabel","125451");
item.put("color","");
item.put("value","");
item.put("url","/hrm/HrmDialogTab.jsp?_fromURL=HrmResourceImport&importtype=city");
item.put("pathurl","");
list.add(item);
*/
item = new Hashtable<String, String>();
item.put("model","area");
item.put("label","126167");
item.put("detiallabel","126168");
item.put("pathlabel","126169");
item.put("color","");
item.put("value","");
item.put("url","/hrm/HrmDialogTab.jsp?_fromURL=HrmResourceImport&importtype=area");
item.put("pathurl","/hrm/area/HrmCountry_frm.jsp");
list.add(item);
//地点
item = new Hashtable<String, String>();
item.put("model","location");
item.put("label","378");
item.put("detiallabel","125447");
item.put("pathlabel","125448");
item.put("color","");
item.put("value","");
item.put("url","/hrm/HrmDialogTab.jsp?_fromURL=HrmResourceImport&importtype=location");
item.put("pathurl","/hrm/HrmTab.jsp?_fromURL=location");
list.add(item);
//专业
item = new Hashtable<String, String>();
item.put("model","special");
item.put("label","803");
item.put("detiallabel","125449");
item.put("pathlabel","16463");
item.put("color","");
item.put("value","");
item.put("url","/hrm/HrmDialogTab.jsp?_fromURL=HrmResourceImport&importtype=special");
item.put("pathurl","/hrm/HrmTab.jsp?_fromURL=speciality");
list.add(item);

%>
<script language=javascript src="/js/jquery/jquery_wev8.js"></script>
<style>
	html,body{
		margin:0px 0px 0px 0px;
		padding:0px;
	}

	#PortalCenter{
		width: 100%;
		height: 254px;
		table-layout: fixed;
	}
	
	.module{
		width: 100%;
		height: 100%;
		position: relative;
	}
	
	.company{
		background-color:#4fc4aa;
		background-image: url("images/company_wev8.png");
		background-position: center center;
		background-repeat: no-repeat;
	}
	
	.jobtitle{
		background-color:#44bfd9;
		background-image: url("images/jobtitle_wev8.png");
		background-position: center center;
		background-repeat: no-repeat;
	}
	
	.resource{
		background-color:#e9cc5f;
		background-image: url("images/resource_wev8.png");
		background-position: center center;
		background-repeat: no-repeat;
	}
	
	.group{
		background-color:#a38fe3;
		background-image: url("images/group_wev8.png");
		background-position: center center;
		background-repeat: no-repeat;
	}
	
	.resourcedetial{
		background-color:#a38fe3;
		background-image: url("images/resourcedetial_wev8.png");
		background-position: center center;
		background-repeat: no-repeat;
	}
	
	.city{
		background-color:#4fc4aa;
		background-image: url("images/city_wev8.png");
		background-position: center center;
		background-repeat: no-repeat;
	}
	
	.location{
		background-color:#e67b6e;
		background-image: url("images/location_wev8.png");
		background-position: center center;
		background-repeat: no-repeat;
	}
	
	.special{
		background-color:#44bfd9;
		background-image: url("images/special_wev8.png");
		background-position: center center;
		background-repeat: no-repeat;
	}
	.area{
		background-color:#4FC4AA;
		background-image: url("images/area_wev8.png");
		background-position: center center;
		background-repeat: no-repeat;
	}
	.item{
		position: absolute;
		right: 12px;
		bottom: 0px;
		color: #ffffff;
		padding-left: 15px;
		padding-bottom: 10px;
		font-size: 16px;
		font-family: 微软雅黑;
		cursor: pointer;
	}
	
	.title{
		height:80px;
		margin:auto;
		bottom: 0px;
		color: #ffffff;
		width:90%;
		font-size: 14px;
		vertical-align:middle;
		text-align:center;
		line-height:80px;
		font-family: 微软雅黑;
		display: none;
		cursor: pointer;
	}
	
	.line{  
		position: absolute;
		bottom: 40px;
		background: #929197;
		height: 1px;
		width: 90%;
		text-align: center;
		right: 12px;
		left: 12px;
		display: none;
	}
</style>

<div style="padding: 15px;">
	<table id="PortalCenter" cellpadding="1" cellspacing="0">
		<colgroup>
			<col width="25%">
			<col width="25%">
			<col width="25%">
			<col width="25%">
		</colgroup>
		<%
		int idx = 0;
		for(Hashtable<String,String> obj : list){
			item = obj;
			String model = item.get("model");
			int label = Integer.parseInt(item.get("label"));
			int detiallabel= Integer.parseInt(item.get("detiallabel"));
			int pathlabel = Integer.parseInt(item.get("pathlabel"));
			String color = item.get("color");
			String url = item.get("url")+"&title="+detiallabel;
			String pathurl = item.get("pathurl");
			if(idx%4==0)out.println("<tr>");
			idx++;
		%>
			<td style="height:127px;" >
				<div class="module <%=model%>" type="<%=model%>" color="<%=color%>">&nbsp;
					<div class="item" titleinfo='<%=SystemEnv.getHtmlLabelName(label,user.getLanguage())%>' pathurl="<%=pathurl%>" pathlabel='<%=SystemEnv.getHtmlLabelName(pathlabel,user.getLanguage())+">>"%>'><%=SystemEnv.getHtmlLabelName(label,user.getLanguage())%></div>
					<div class="line"></div>
					<div class="title" url="<%=url%>"><%=SystemEnv.getHtmlLabelName(detiallabel,user.getLanguage())%></div>
				</div>
			</td>
		<%if(idx%4==0)out.println("</tr>"); %>
		<%}%>
	</table>
</div>

<script type="text/javascript">
	$(".module").hover(function(){
		$(this).css("background-image","none");
		$(this).find(".title").show();
		$(this).find(".line").show();
		$(this).find(".item").css("font-size",'12px');
		$(this).find(".item").html($(this).find(".item").attr("pathlabel"));
		$(this).css("background-color",'#78777f');
		$(this).css("opacity",'0.8')
	},function(){
		$(this).css("background-image","url(images/"+$(this).attr("type")+"_wev8.png)");
		$(this).find(".title").hide();
		$(this).find(".line").hide();
		$(this).find(".item").css("font-size",'16px');
		$(this).find(".item").html($(this).find(".item").attr("titleinfo"));
		$(this).css("background-color",$(this).attr("color"));
		$(this).css("opacity",'1')
	})
	
	$(".title").click(function(){
		var url = $(this).attr("url");
		var title = $(this).html();
		openDialog(title, url);
	})
	
	$(".item").click(function(){
		var pathurl = $(this).attr("pathurl");
		window.parent.location.href=pathurl;
	})
	
	function openDialog(title,url){
		dialog = new window.top.Dialog();
		dialog.currentWindow = window;
		dialog.Title = title;
		dialog.Width = 800;
		dialog.Height = 600;
		dialog.Drag = true;
		dialog.URL = url;
		dialog.show();
	}
	
</script>

