
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.general.Util,org.json.*" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page" />
<html><head>
     <title>layout design</title>
	 <link href="../css/layoutdesign_wev8.css" rel="stylesheet" type="text/css">
	 <SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
</head>
<%

String imagefilename = "/images/hdDOC_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(33933,user.getLanguage());
String layoutid=Util.null2String(request.getParameter("layoutid"));
Map<String,String> datas=new HashMap<String,String>();
String layoutname = "";
String layoutdesc = "";
String rsstr;
String cellmergeinfo="";
if(!"".equals(layoutid)){
	rs.execute("select layouttable,cellmergeinfo,layoutname,layoutdesc  from  pagelayout  where id='"+layoutid+"'");
	if(rs.next()){
		datas.put("tableinfo",rs.getString("layouttable"));
		cellmergeinfo=rs.getString("cellmergeinfo");
		layoutname=rs.getString("layoutname");
		layoutdesc=rs.getString("layoutdesc");
	}
}
JSONObject obj=new JSONObject(datas);
rsstr=obj.toString();
%>



<body>

 <%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
 
 <%
    
	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;
	
	

%>
 
 <%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
 

<div style="height: 30px;background: rgb(248, 245, 245);padding-top: 10px;padding-left: 20px;">
  <div style="width:400px;float:left"><%=SystemEnv.getHtmlLabelName(22009,user.getLanguage())%>: <input type="text" class="inputstyle" value="<%=layoutname %>" name="layoutname" id="layoutname" style="width:330px" onchange='checkinput("layoutname","nameimage")'> 
        <SPAN id=nameimage><%if (layoutname.equals("")) {%><IMG src="/images/BacoError_wev8.gif" align=absMiddle><%}%></SPAN>
  </div>
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%>:  <input type="text" class="inputstyle" value="<%=layoutdesc %>" name="layoutdesc" id="layoutdesc"  style="width:330px">
</div>

<div class="layoutcontainer">
		    <input type='hidden' name='layoutid'  value='<%=layoutid%>'>

			<div style="position: absolute;top:-20px;height: 20px;overflow: hidden;width: 100%;border-top: 1px solid #F0EAEA;">
				<div class="inchmain" ><div style="margin-left: 3px;">0</div></div>
				<div class="inch" style="left: 5%"></div>
				<div class="inch" style="left: 10%"></div>
				<div class="inch" style="left: 15%"></div>
				<div class="inch" style="left: 20%"></div>
				<div class="inchmain" style="left: 25%"><div class="inchvalue">25</div></div>
				<div class="inch" style="left: 30%"></div>
				<div class="inch" style="left: 35%"></div>
				<div class="inch" style="left: 40%"></div>
				<div class="inch" style="left: 45%"></div>
				<div class="inchmain" style="left: 50%"><div class="inchvalue">50</div></div>
				<div class="inch" style="left: 55%"></div>
				<div class="inch" style="left: 60%"></div>
				<div class="inch" style="left: 65%"></div>
				<div class="inch" style="left: 70%"></div>
				<div class="inchmain" style="left: 74.9%"><div class="inchvalue">75</div></div>
				<div class="inch" style="left: 80%"></div>
				<div class="inch" style="left: 85%"></div>
				<div class="inch" style="left: 90%"></div>
				<div class="inch" style="left: 95%"></div>
				<div class="inchmain" style="left: 99.9%"><div class="inchvalue" style="margin-left: -25px;">100</div></div>
			</div>
			<div class="layouttablewrapper">

				<div class="vline wline">
				</div>
				<div class="vline eline">
				</div>
				<div class="hline nline">
				</div>
				<div class="hline sline">
				</div>

				<div class="imageicons">
					<div class="mergeicon" title="<%=SystemEnv.getHtmlLabelName(216,user.getLanguage())%>"></div>
					<div class="splitall" title="<%=SystemEnv.getHtmlLabelName(84067,user.getLanguage())%>"></div>
					<div class="hsplit" title="<%=SystemEnv.getHtmlLabelName(84068,user.getLanguage())%>"></div>
					<div class="vsplit" title="<%=SystemEnv.getHtmlLabelName(84069,user.getLanguage())%>"></div>
				</div>

				<table class="layouttable">
					<thead>
						<tr>
						   <th coord='0,-1' style='width:25%'></th><th coord='1,-1' style='width:25%'></th><th coord='2,-1' style='width:25%'></th><th coord='3,-1' style='width:25%'></th>
						</tr>
					</thead>
					<tr>
						<td  coord='0,0'>
						</td>
						<td  coord='1,0'>
						</td>
						<td coord='2,0'>
						</td>
						<td coord='3,0'>
						</td>
					</tr>
					<tr>
						<td coord='0,1'></td>
						<td coord='1,1'></td>
						<td coord='2,1'></td>
						<td coord='3,1'></td>
					</tr>
					<tr>
						<td coord='0,2'>
						</td>
						<td coord='1,2'></td>
						<td coord='2,2'>
						</td>
						<td coord='3,2'>
						</td>
					</tr>
					<tr>
						<td coord='0,3'></td>
						<td coord='1,3'></td>
						<td coord='2,3'></td>
						<td coord='3,3'></td>
					</tr>
				</table>
			</div>
		</div>
      
        <script src="../js/jquery_wev8.js"></script>
        <script src="../js/jquery-ui_wev8.js"></script>
        <script src="../js/layoutdesign_wev8.js"></script>
        <script>
		     jQuery(document).ready(function(){
			         var rtableinfo=<%=rsstr%>;
					 //恢复设置 
					 if(rtableinfo.tableinfo!==undefined && rtableinfo.tableinfo!==''){
						 <% if("".equals(cellmergeinfo)) { %>
						   rtableinfo.cellmergeinfo='<%=cellmergeinfo%>';
						 <%} else {%>
		                   rtableinfo.cellmergeinfo=<%=cellmergeinfo%>;
		                  <%
						  }
						  %>
					     layoutdesign.reciverLayout(rtableinfo);
					 }else{
					  // 初始设置
					    layoutdesign.initLayoutDesign(); 
					 } 
			});
			
			
			function submitData() {
				   if($("#layoutname").val() == "" && $("#layoutname").val().trim() == ""){
				      window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(84071,user.getLanguage())%>!");
				      return;
				   }
				   //alert("/page/layoutdesign/pages/layoutoperation.jsp?layoutid=<%=layoutid%>&method=checkname&name="+$("#layoutname").val());
				    var senddata = {};
				    senddata["method"]="checkname";
				    senddata["name"] = $("#layoutname").val();
				    $.ajax({
			          data: senddata,
			          type: "POST",
			          url: "/page/layoutdesign/pages/layoutoperation.jsp?layoutid=<%=layoutid%>",
			          timeout: 20000,
			          success: function (rs) {
			          data = $.parseJSON($.trim(rs));
			            if(rs && rs.trim()=='1'){
			                 window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(84072,user.getLanguage())%>!");
			             }else if(data&&data.__result__===false){
								top.Dialog.alert(data.__msg__);
						 }else{
			                layoutdesign.saveLayout();
			             }
			          }, fail: function () {
			              alert('<%=SystemEnv.getHtmlLabelName(84073,user.getLanguage())%>');
			          }
			      });
			   
			   
			}
			
		</script>
    </body>
</html>
