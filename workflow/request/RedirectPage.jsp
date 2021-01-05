
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%

//String requestid=Util.null2String(request.getParameter("requestid"));
//String userid=Util.null2String(request.getParameter("userid"));
//String f_weaver_belongto_usertype=Util.null2String(request.getParameter("f_weaver_belongto_usertype"));
 
// System.out.println("========进入调整页面==A=====");
weaver.general.DateUtil DateUtil=new weaver.general.DateUtil();
if(DateUtil.isCurrendUserid(""+requestid,""+user.getUID())){
out.print("<script>wfforward('/workflow/request/ViewRequest.jsp?requestid="+requestid+"&f_weaver_belongto_userid="+user.getUID()+"&f_weaver_belongto_usertype="+Util.null2String(""+f_weaver_belongto_usertype)+"');</script>");
}else{
	%>
<script type="text/javascript">
	try{
		window.parent.opener.btnWfCenterReload.onclick();
	}catch(e){}	   

	try{
		window.parent.opener._table.reLoad();
	}catch(e){}
	try{	
		window.parent.opener.reLoad();
	}catch(e){}
	if (!!!window.parent.window.parent.window.document.getElementById("mainFrame")){
		//若是新增车辆则不关闭：
		try{
			var dialog = window.parent.window.parent.window.$("div[id^='_DialogDiv_']")[0];
			if(dialog){
				if(dialog.dialogInstance){
					window.parent.window.parent.window.location.reload();
					dialog.dialogInstance.close();
				}
			}else{
			closeWindow();
			}
		}catch(e){
		}
	} else {
		window.parent.window.parent.window.document.getElementById("mainFrame").src = '/workflow/request/RequestView.jsp?e' + new Date().getTime() + "="
	}

	function closeWindow(){
		try{
			window.open('','_top');	
			window.top.close();
		}catch(e){}
		try{
			parent.window.close();
		}catch(e){}	
	}
 </script>
 <%
 
}

%>
