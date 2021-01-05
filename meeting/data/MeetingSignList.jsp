<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<div id="signlistdiv">
<%
	String orderby =" signTime desc";
	String tableString = "";
	int pagesize=10;
	String sqlwhere=" meetingid='"+meetingid+"' ";                        
	String backfields = " id,userid,attendType,signTime,signReson ";
	String fromSql  = " meeting_sign ";
	tableString =   " <table instanceid=\"\" tabletype=\"none\" pagesize=\""+pagesize+"\">"+
	   				"       <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\"  sqlwhere=\""+sqlwhere+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"id\" sqlsortway=\"asc\"  />"+
	                "       <head>"+
	                "           <col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(125530,user.getLanguage())+"\" column=\"userid\" orderkey=\"userid\" transmethod=\"weaver.meeting.Maint.MeetingTransMethod.getMeetingResource\" />"+
					"           <col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(2106,user.getLanguage())+"\" column=\"attendType\" orderkey=\"attendType\" otherpara=\""+user.getLanguage()+"\"  transmethod=\"weaver.meeting.Maint.MeetingTransMethod.checkAttendType\" />"+
	                "           <col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(20035,user.getLanguage())+"\" column=\"signTime\" orderkey=\"signTime\"  otherpara=\""+user.getLanguage()+"\"  transmethod=\"weaver.meeting.Maint.MeetingTransMethod.checkSignState\" />"+
	                "           <col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(128301,user.getLanguage())+"\" column=\"signReson\" orderkey=\"signReson\"  />"+
	                "       </head>";
	tableString +=  "		<operates>"+
					"		<popedom column=\"id\" otherpara=\""+isqrcode+"+column:signTime\" transmethod=\"weaver.meeting.Maint.MeetingTransMethod.checkSignOperate\"></popedom> "+
					"		<operate href=\"javascript:onDelN();\" text=\""+SystemEnv.getHtmlLabelName(15504,user.getLanguage())+"\" target=\"_self\" index=\"0\"/>"+
					"		<operate href=\"javascript:onEdit();\" text=\""+SystemEnv.getHtmlLabelName(27203,user.getLanguage())+"\" target=\"_self\" index=\"1\"/>"+
					"		</operates>"; 
	                 
	tableString +=  " </table>";
%>

<wea:layout type="2col">
	<%if(isqrcode){ %> 
 	<wea:group context='<%=SystemEnv.getHtmlLabelNames("2103,20032,30184",user.getLanguage())%>' attributes="{'groupDisplay':''}">
		<wea:item attributes="{'isTableList':'true'}">
			  <div style="text-align:center;margin-top:10px;border-bottom: 1px solid #E6E6E6;padding-bottom: 5px">
				<a href="JavaScript:void(0)" onclick="showDownloadQR()"><img border=0 src="<%="/weaver/weaver.meeting.qrcode.CreateQRCodeServlet?isUrl=1&content="+qrticket %>" width="160px" title="<%=SystemEnv.getHtmlLabelNames("125264,128122",user.getLanguage())%>"/></a>
				<br>
				<span style='color:#999999'><%= SystemEnv.getHtmlLabelName(128302,user.getLanguage())%></span>
			  </div>
			  <div id="QR_SizeShow" style="display:none; position: absolute;background: white;width: 60px;height: 90px;line-height: 30px;text-align: center;border: 1px solid #d6d6d6">
			  	<ul>
			  		<li style="list-style-type:none;cursor: pointer;" onclick="downloadQR('<%=qrticket%>',1)">240*240</li>
			  		<li style="list-style-type:none;cursor: pointer;" onclick="downloadQR('<%=qrticket%>',2)">480*480</li>
			  		<li style="list-style-type:none;cursor: pointer;" onclick="downloadQR('<%=qrticket%>',3)">960*960</li>
			  	</ul>
			   </div>
		 </wea:item>
	</wea:group>
	<%} %>
	<wea:group context='<%=SystemEnv.getHtmlLabelNames("20032,264",user.getLanguage())%>' attributes="{'groupDisplay':''}">
	<%if(isqrcode){ %> 
		<wea:item type="groupHead">
		<input type="button" title="<%=SystemEnv.getHtmlLabelName(28343,user.getLanguage()) %>" class="downloadbtn" onclick="exportSignExcel(<%=meetingid %>)"/>
		 <input Class="addbtn" type="button" onclick="onShowSignByHand()" title="<%=SystemEnv.getHtmlLabelName(27203,user.getLanguage())%>"></input>
	   </wea:item>
	 <%} %>
	   <wea:item attributes="{'isTableList':'true'}">
		  <wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" isShowTopInfo="false"/>
	   </wea:item>
	</wea:group>
 </wea:layout>
</div>
<script language="javascript">

function showDownloadQR(){
	var objDiv = $("#QR_SizeShow"); 
	$(objDiv).css("display","block"); 
	$(objDiv).css("left", event.clientX); 
	$(objDiv).css("top", event.clientY); 
	$(objDiv).find("li").hover(function(){
	    $(this).css("background-color","#deedfb");
	},function(){
	    $(this).css("background-color","");
	});
	
	$(objDiv).mouseleave(function(){
		$("#QR_SizeShow").hide(); 
	});
}

function downloadQR(content,size)
{	
	$("#QR_SizeShow").hide(); 
	document.location.href="/weaver/weaver.meeting.qrcode.CreateQRCodeServlet?isUrl=1&size="+size+"&content="+content+"&download=1&meetingid=<%=meetingid%>";
}

function onShowSignByHand(){
	showDialog("/meeting/data/MeetingOthTab.jsp?toflag=signByHand&qrticket=<%=qrticket %>&meetingid=<%=meetingid%>","<%=SystemEnv.getHtmlLabelName(20032, user.getLanguage())+(user.getLanguage()==8?" ":"")+SystemEnv.getHtmlLabelName(27203, user.getLanguage())%>", 600, 450);
}

function refashSignList(){
	_table.reLoad();
}

function onDelN(id){
	window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(128299, user.getLanguage())%>", function (){
			$.post("MeetingSignByHandOperation.jsp",{method:"delSign",meetingid:<%=meetingid%>,signid:id},function(datas){
				 refashSignList();
			});
	});
}

function onEdit(id){
	window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(128300, user.getLanguage())%>", function (){
		$.post("MeetingSignByHandOperation.jsp",{method:"ajaxSave",meetingid:<%=meetingid%>,signid:id},function(datas){
			 refashSignList();
		});
	});
}

</script>