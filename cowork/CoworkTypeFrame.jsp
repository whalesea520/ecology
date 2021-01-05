
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.cowork.CoworkDAO"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ include file="/systeminfo/leftMenuCommon.jsp" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.cowork.CoworkLabelVO"%>
<jsp:useBean id="pack" class="weaver.general.ParameterPackage" scope="page"/>
<jsp:useBean id="CoworkItemMarkOperation" class="weaver.cowork.CoworkItemMarkOperation" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<%
int userid=user.getUID();
String layout=Util.null2String(request.getParameter("layout"),"1");
String width="100%";
if(layout.equals("1")) width="478px";
%>

<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
<link rel="stylesheet" href="/css/ecology8/request/searchInput_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/searchInput_wev8.js"></script>
<link rel="stylesheet" href="/css/ecology8/request/seachBody_wev8.css" type="text/css" />
<link rel="stylesheet" href="/css/ecology8/request/hoverBtn_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/hoverBtn_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/request/titleCommon_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/cowork/coworkTabFrame_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/cowork/coworkview_wev8.js"></script>

<style>
.frmCenterImgOpen {background:#B1D4D9 url('/wui/theme/ecology7/skins/default/general/toggler_wev8.png') no-repeat center center;height: 60px;cursor: pointer;}
.frmCenterImgClose {background:#B1D4D9 url('/wui/theme/ecology7/skins/default/general/toggler-open_wev8.png') no-repeat center center;height: 60px;cursor: pointer;}
#frmCenter{background:#B1D4D9;;cursor:e-resize;height:100%}
.layout_right2{position: absolute;left: 275px;top:0px;right:0px;width: 835px;}
.layout_left1{position: absolute;left: 0px;top:42px;width:275px;height:570px;overflow: hidden;}
.layout_left2{position: absolute;left: 0px;top:0px;width:275px;bottom:0px;overflow: hidden;}
</style>

</head>
<body scroll="no">
	<div class="e8_box demo2" id="rightContent">
		<ul class="tab_menu">
			<li class="e8_tree">
				<a onclick="showMenu()"><%=SystemEnv.getHtmlLabelName(32452,user.getLanguage()) %></a>
			</li>
			<li class="current">
				<a href="" target="tabcontentframe" layout="<%=layout%>" id = 'allTab' type='all' labelid=''><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></a>
			</li>
			<%
			List labelList=CoworkItemMarkOperation.getLabelList(userid+"","all");          //标签列表
			for(int i=0;i<labelList.size();i++){ 
				
                 CoworkLabelVO labelVO=(CoworkLabelVO)labelList.get(i);
                 String isUsed=labelVO.getIsUsed();
                 if(isUsed.equals("0")) continue;
                 String id=labelVO.getId();
                 String labelType=labelVO.getLabelType();
                 String labelName=labelVO.getName();
                 if(!labelType.equals("label"))
                	 labelName=SystemEnv.getHtmlLabelName(Integer.parseInt(labelVO.getName()),user.getLanguage());
                 else
                	 labelName=labelVO.getName();
            %>
            <li class="current">
				<a href="" target="tabcontentframe" layout="<%=layout%>" type='<%=labelType%>' labelid='<%=id%>' title='<%=labelName%>'><%=labelName%></a>
			</li>
            <%} %>
		</ul>
		<div id="rightBox" class="e8_rightBox"></div>
		<div class="tab_box">
		<div>
		<table style="width: 100%;height: 100%">
			<tr>
				<td style="width:<%=width%>;" id="itmeList">
					<iframe src="" id="tabcontentframe" name="tabcontentframe" class="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
				</td>
				<%if(layout.equals("1")){%>
				<td width="8" id="frmCenter" align=left valign=middle onmousedown="Resize_mousedown(event,this);"   onmouseup="Resize_mouseup(event,this);"   onmousemove="Resize_mousemove(event,this);">
					<div id="frmCenterImg" onclick="mnToggleleft(this)" class="frmCenterImgOpen"></div>
				</td>
				<td>
					<iframe id='ifmCoworkItemContent' src='/cowork/ViewCoWork.jsp?id=214' height=100% width="100%" border=0 frameborder="0" scrolling="auto"></iframe>
				</td>
				<%}%>
			</tr>
		</table>
		</div>
		</div>
	</div>	
	
	<div id="leftMenu" class="layout_left<%=layout%>" style="display: none;">
	<%
		CoworkDAO coworkdao=new CoworkDAO();
		Map mainTotal=coworkdao.getCoworkCount(user,"main");
		Map subTotal=coworkdao.getCoworkCount(user,"sub");
		String leftMenus="";
		String sql="select * from cowork_maintypes ORDER BY id asc";
		RecordSet.execute(sql);
		while(RecordSet.next()){
			String mainTypeId=RecordSet.getString("id");
			String mainTypeName=RecordSet.getString("typename");
			String mainflowAll=mainTotal.containsKey(mainTypeId)?(String)mainTotal.get(mainTypeId):"0";
			
			String submenus="";           
			sql="SELECT * from cowork_types where departmentid="+mainTypeId+" ORDER BY id asc";
			rs.execute(sql);
			while(rs.next()){
				String subTypeId=rs.getString("id");
				String subTypeName=rs.getString("typename");
				String subflowAll=subTotal.containsKey(subTypeId)?(String)subTotal.get(subTypeId):"0";
				submenus+=",{name:'"+subTypeName+"',"+
							 "attr:{subTypeId:'"+subTypeId+"'},"+
							 "numbers:{flowAll:"+subflowAll+"}"+
	           				"}";
			}
			submenus=submenus.length()>0?submenus.substring(1):submenus;
			submenus="["+submenus+"]";
			
			leftMenus+=",{"+
						 "name:'"+mainTypeName+"',"+
						 "attr:{mainTypeId:'"+mainTypeId+"'},"+
						 "numbers:{flowAll:"+mainflowAll+"},"+
						 "submenus:"+submenus+
			 		   "}";
		}
		leftMenus=leftMenus.length()>0?leftMenus.substring(1):leftMenus;
		leftMenus="["+leftMenus+"]";
	%>
	<script>
		var demoLeftMenus=eval("(<%=leftMenus%>)");
	</script>
	<table cellspacing="0" cellpadding="0" class="flowsTable" style="width: 100%">
		<tr>
			<td class="leftTypeSearch">
				<span class="leftType">
				<span><img style="vertical-align:middle;" src="/images/ecology8/request/alltype_wev8.png" width="18"/></span>
				<span><%=SystemEnv.getHtmlLabelName(21979,user.getLanguage())%></span>
				</span>
				<span class="leftSearchSpan">
					&nbsp;<input type="text" class="leftSearchInput" />
				</span>
			</td>
		</tr>
		<tr>
			<td style="width:23%;" class="flowMenusTd">
				<div class="flowMenuDiv"  >
					<div style="position:relative;overflow:hidden;height:525px" id="overFlowDiv">
						<div class="ulDiv" ></div>
					</div>
				</div>
			</td>
		</tr>
	</table>
	</div>
	
	
</body>
<script>
  $(document).ready(function(){
  		//refreshTab();
  });
  var   isResizing=false;   
  var clientX=0;        
  function   Resize_mousedown(event,obj){   
      clientX = event.clientX;            
      if("<%=isIE%>"=="true")
         obj.setCapture();
      else
         window.captureEvents(Event.MOUSEMOVE|Event.MOUSEUP);   
	  isResizing=true;   
  }   
  function   Resize_mousemove(event,obj){   
      if(!isResizing)   return   ;   
      var prevtd=jQuery(obj).prev();
      var width =prevtd.width()+event.clientX-clientX;
      clientX=event.clientX;
      prevtd.width(width);
  }   
  function   Resize_mouseup(event,obj){   
	  var coworkLeftWidth=jQuery("#itmeList").width();
	  addCookie("coworkLeftWidth",coworkLeftWidth,365*24*60*60*1000); //添加cookie
	  
	  if("<%=isIE%>"=="true")
         obj.releaseCapture();
      else
         window.releaseEvents(Event.MOUSEMOVE|Event.MOUSEUP); 
	  isResizing=false;   
  }
  
  //添加cookie
  function addCookie(objName,objValue,objHours){//添加cookie
		var str = objName + "=" + escape(objValue);
		if(objHours > 0){//为0时不设定过期时间，浏览器关闭时cookie自动消失
			var date = new Date();
			date.setTime(date.getTime() + objHours);
			str += "; expires=" + date.toGMTString();
		}
		document.cookie = str;
  }
  //读取cookie
  function getCookie(objName){//获取指定名称的cookie的值
		var arrStr = document.cookie.split("; ");
		for(var i = 0;i < arrStr.length;i ++){
		   var temp = arrStr[i].split("=");
		   if(temp[0] == objName) return unescape(temp[1]);
		}
  }
  
  /*收缩左边栏*/
  function mnToggleleft(obj){
		if(jQuery("#itmeList").is(":hidden")){
		        jQuery("#frmCenterImg").removeClass("frmCenterImgClose");
		        jQuery("#frmCenterImg").addClass("frmCenterImgOpen");
				jQuery("#itmeList").show();
		}else{
		        jQuery("#frmCenterImg").removeClass("frmCenterImgOpen");
		        jQuery("#frmCenterImg").addClass("frmCenterImgClose"); 
				jQuery("#itmeList").hide();
		}
   }
   
   function showMenu(){
   		if($("#leftMenu").is(":visible")){
   			if("<%=layout%>"=="2")
   				$("#rightContent").removeClass("layout_right2");
   			$("#leftMenu").hide();
   		}else{
	   		if("<%=layout%>"=="2")
	   			$("#rightContent").addClass("layout_right2");
	   		$("#leftMenu").show();
   		}
   		if("<%=layout%>"=="2")
   			update(".e8_box");
   }
   
</script>
</html>

