
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="OperateUtil" class="weaver.crm.util.OperateUtil" scope="page" />
	<%
		String workflowid = "518";//518 424
		String kh = "field10028";//field10028  field8403
		String sj = "field10034";//field10034  field8408
		String jsr = "field10030";//field10030  field8401
		String csr = "field10031";//field10031  field8402
		String txyj = "field10029";//field10029  field8405
		String userid = user.getUID()+"";
		String customerid = Util.null2String(request.getParameter("customerid"));
		String sellchanceid = Util.null2String(request.getParameter("sellchanceid"));
		if(customerid.equals("") && sellchanceid.equals("")){
			response.sendRedirect("/notice/noright.jsp");
            return;
		}
		String customername = "";
		String sellchancename = "";
		if(!sellchanceid.equals("")){ 
			if(!OperateUtil.checkRight(sellchanceid,userid,2,1)){
				response.sendRedirect("/notice/noright.jsp");
	            return;
			}
			rs.executeSql("select customerid,subject from CRM_SellChance where id="+sellchanceid);
			if(rs.next()){
				customerid = Util.null2String(rs.getString("customerid"));
				sellchancename = "<a href=javaScript:openFullWindowHaveBar('/CRM/manage/sellchance/SellChanceView.jsp?id="+sellchanceid+"')>"+Util.null2String(rs.getString("subject"))+"</a>";
			}
		}else if(!customerid.equals("")){ 
			if(!OperateUtil.checkRight(customerid,userid,1,1)){
				response.sendRedirect("/notice/noright.jsp");
	            return;
			}
		}
		customername = "<a href=javaScript:openFullWindowHaveBar('/CRM/manage/customer/CustomerBaseView.jsp?CustomerID="+customerid+"')>"+CustomerInfoComInfo.getCustomerInfoname(customerid)+"</a>";
		String cmid = CustomerInfoComInfo.getCustomerInfomanager(customerid);
		String cmname = "<a href='javaScript:openhrm("+cmid+ ");' onclick='pointerXY(event);'>"+ ResourceComInfo.getLastname(cmid) + "</a>";
	
		String managerid = ResourceComInfo.getManagerID(cmid);
		String managername = "<a href='javaScript:openhrm("+managerid+ ");' onclick='pointerXY(event);'>"+ ResourceComInfo.getLastname(managerid) + "</a>";
		
		String requestname = "";
		String content = "";
	%>
<HTML>
	<HEAD>
		<title>客户商机联系提醒</title>
		<style type="text/css">
			html,body{margin: 0px;padding: 0px;}
		</style>
	</HEAD>
	<BODY style="overflow: hidden">
		<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td valign="top">
					<iframe id="iframe1" width="100%" height="100%" marginwidth="0" marginheight="0" frameborder="0"
						src="/workflow/request/AddRequest.jsp?workflowid=<%=workflowid %>&isagent=0&beagenter=0"></iframe>
				</td>
			</tr>
		</table>
	</BODY>
	<script type="text/javascript">
		jQuery(document).ready(function(){
			var iframe1 = document.getElementById("iframe1");
			if (iframe1.attachEvent){ 
				iframe1.attachEvent("onload", function(){ 
					setFrame2();
				}); 
			} else { 
				iframe1.onload = function(){ 
					setFrame2()
				}; 
			} 
		});

		function setFrame2(){
			var iframe1 = document.getElementById("iframe1");
			var iframe2 = iframe1.contentWindow.document.getElementById("bodyiframe");
			if (iframe2.attachEvent){ 
				iframe2.attachEvent("onload", function(){ 
					setValue();
				}); 
			} else { 
				iframe2.onload = function(){ 
					setValue()
				}; 
			} 
		}

		function setValue(){
			try{
				var iframe1 = document.getElementById("iframe1");
				var iframe2 = iframe1.contentWindow.document.getElementById("bodyiframe");
				if(iframe2!=null){
					if(iframe2.contentWindow.document.getElementById('<%=kh%>')!=null){
						<%if(!requestname.equals("")){%>
						iframe2.contentWindow.document.getElementById('requestname').value = "<%=requestname%>";
						iframe2.contentWindow.document.getElementById('requestnamespan').innerHTML = "";
						iframe2.contentWindow.document.getElementById('field187').innerText = "<%=requestname%>";
						iframe2.contentWindow.document.getElementById('field187span').innerHTML = "";
						<%}%>
						<%if(!customerid.equals("")){%>
						iframe2.contentWindow.document.getElementById('<%=kh%>').value = "<%=customerid%>";
						iframe2.contentWindow.document.getElementById('<%=kh%>span').innerHTML = "<%=customername%>";
						<%}%>
						<%if(!sellchanceid.equals("")){%>
						iframe2.contentWindow.document.getElementById('<%=sj%>').value = "<%=sellchanceid%>";
						iframe2.contentWindow.document.getElementById('<%=sj%>span').innerHTML = "<%=sellchancename%>";
						<%}%>
						<%if(!cmid.equals("")){%>
						iframe2.contentWindow.document.getElementById('<%=jsr%>').value = "<%=cmid%>";
						iframe2.contentWindow.document.getElementById('<%=jsr%>span').innerHTML = "<%=cmname%>";
						<%}%>
						<%if(!managerid.equals("")){%>
						iframe2.contentWindow.document.getElementById('<%=csr%>').value = "<%=managerid%>";
						iframe2.contentWindow.document.getElementById('<%=csr%>span').innerHTML = "<%=managername%>";
						<%}%>
						<%if(!content.equals("")){%>
						iframe2.contentWindow.document.getElementById('<%=txyj%>').value = "<%=content%>";
						iframe2.contentWindow.document.getElementById('<%=txyj%>span').innerHTML = "";
						<%}%>
					}else{
						alert("<%=SystemEnv.getHtmlLabelName(21430,user.getLanguage())%>");
						window.close();
					}
				}
			}catch(e){
				
			}
		}
	</script>
</HTML>
