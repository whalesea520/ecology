
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>

<%@ page import="com.weaver.integration.params.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<link href="/css/Weaver_wev8.css" type=text/css rel=stylesheet>
<link href="/integration/css/intepublic_wev8.css" type=text/css rel=stylesheet>
<link href="/integration/css/loading_wev8.css" type=text/css rel=stylesheet>
<jsp:useBean id="SapUtil" class="com.weaver.integration.util.IntegratedUtil" scope="page"/>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="basebean" class="weaver.general.BaseBean" scope="page" />
<%
			
if(!HrmUserVarify.checkUserRight("intergration:SAPsetting",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
			String browsertype=Util.null2String(request.getParameter("browsertype"));//如果=226表示是集成开发单选，=227表示是集成开发多选
			//add by wshen
			String actionid = Util.null2String(request.getParameter("actionid"));
			//获取完整的url--start
			String url = "";  
          /*   url = request.getContextPath();  
            url = url + request.getServletPath();   */
	        Enumeration names = request.getParameterNames();  
	        String requestPageUrl = "";  
	        if (null!=request.getQueryString()) {  
	           url = url + "?" + request.getQueryString();  
	           url=url.replace("&dataauth=2", "");//去掉这个参数，防止字段监控页面打开这个url的时候，默认选中权限设置tab页
	        }  
	     	session.setAttribute("newSAP_browse",url);
			//获取完整的url--end
			String title=""+SystemEnv.getHtmlLabelName(30655 ,user.getLanguage());
			if("227".equals(browsertype)){
					title=""+SystemEnv.getHtmlLabelName(31748 ,user.getLanguage());
			}
			String formid=Util.null2String(request.getParameter("formid"));//得到流程表单的formid
			String mark=Util.null2String(request.getParameter("mark")).trim();//浏览按钮标识的id
			String dataauth=Util.null2String(request.getParameter("dataauth"));//得到是否跳到数据授权界面
			String updateTableName=Util.null2String(request.getParameter("updateTableName"));//得到主表或明显表的name,用于判断当前配置的浏览按钮放置在那张表中
			String w_type=Util.null2String(Util.getIntValue(request.getParameter("w_type"),0)+"");//0-表示是浏览按钮的配置信息，1-表示是节点后动作配置时的信息,2---表示线程扫描SAP触发OA流程
			String srcType=Util.null2String(request.getParameter("srcType"));//这种情况来源于字段管理--新建字段 (detailfield=明细字段,mainfield=主字段)
			String hiddenouttable=Util.null2String(request.getParameter("hiddenouttable"));//是否隐藏输出表
			//工作流的id
			int workflowid = Util.getIntValue(Util.null2String(request.getParameter("workflowid")),0);
			String iframsr="/integration/browse/integrationSapDirections.jsp?w_type="+w_type;
			if("2".equals(w_type)){
					rs.execute("select formid,isbill from workflow_base where id="+workflowid+"");
					if(rs.next()){
						formid=rs.getString("formid");
					}
					title=""+SystemEnv.getHtmlLabelName(31749 ,user.getLanguage());
			}
			//String nodename = "";		
			//String workFlowName = "";
			int isbill = 0;//老表单还是新表单,0表示老表单1,表示新表单
			if(!"".equals(formid)){
				if(Util.getIntValue(formid)<0){
					isbill=1;
				}
			}
			//节点id
			int nodeid = Util.getIntValue(Util.null2String(request.getParameter("nodeid")),0);
			//是否节点后附加操作
			int ispreoperator = Util.getIntValue(request.getParameter("ispreoperator"), 0);
			//出口id
			int nodelinkid = Util.getIntValue(request.getParameter("nodelinkid"), 0);
		
			if("1".equals(w_type))
			{
				 title=""+SystemEnv.getHtmlLabelName(31750 ,user.getLanguage());
				//if(nodeid>0){
					//RecordSet.executeSql("select nodename from workflow_nodebase b where b.id = "+nodeid);
					//if(RecordSet.next()){
						//nodename = RecordSet.getString("nodename");
					//}
				//}
				if(workflowid>-1){
					//workFlowName = Util.null2String(WorkflowComInfo.getWorkflowname("" + workflowid));
					isbill = Util.getIntValue(WorkflowComInfo.getIsBill("" + workflowid), 0);
					formid = Util.getIntValue(WorkflowComInfo.getFormId("" + workflowid), 0)+"";
				}
				if("0".equals(formid)){
					String sqlGetFB = "select formid,isbill from workflow_base where isvalid='1' and id="+workflowid+" order by dsporder asc,workflowname,id";
					rs.execute(sqlGetFB);
					if(rs.next()){
						isbill = Util.getIntValue(Util.null2String(rs.getString("isbill")),0);
						formid = Util.getIntValue(Util.null2String(rs.getString("formid")), 0)+"";						
					}
				}
			}
					
			String opera="save";
			if(!"".equals(mark)){opera="update";}
			String hpid="";
			String poolid="";
			String baseid="";//浏览按钮的id
			String w_enable="";//是否启用
			String regservice="";//所属服务
			String brodesc="";
			String authcontorl="";
			String sid="";
			String servicesid="";
			//boolean flag = false;
			String regname="";
			String w_actionorder="";
			//依据浏览按钮的标识，查出浏览按钮的基本信息
			if("update".equals(opera))
			{
			
				String sql="select a.*,b.sid from int_BrowserbaseInfo a left join  int_heteProducts b on a.hpid=b.id where mark='"+mark+"'";
				if(RecordSet.execute(sql)&&RecordSet.next())
				{
					 baseid=RecordSet.getString("id");
					 hpid=RecordSet.getString("hpid");
					 poolid=RecordSet.getString("poolid");
					 w_actionorder=RecordSet.getString("w_actionorder");
					 sid=RecordSet.getString("sid");
					 regservice=RecordSet.getString("regservice");//所属服务
					 brodesc=RecordSet.getString("brodesc");
					 authcontorl=RecordSet.getString("authcontorl");
					 w_enable=RecordSet.getString("w_enable");
					 servicesid=sid+"_"+hpid+"_"+poolid+"_"+regservice;
					 if("1".equals(sid))//1--中间表,对应的数据源为dml数据源表(这是规定)
					 {
					 	rs.execute("select * from dml_service where id="+regservice);
					 	if(rs.next())
					 	{
					 		regname=rs.getString("regname");
					 	}
					 }else if("2".equals(sid))//2--webservice,对应的数据源为webservice据源表(这是规定)
					 {
					 	rs.execute("select * from ws_service where id="+regservice);
					 	if(rs.next())
					 	{
					 		regname=rs.getString("regname");
					 	}
					 }else if("3".equals(sid))//3---rfc,对应的数据源为sap数据源表(这是规定)
					 {
					 	rs.execute("select * from sap_service where id="+regservice);
					 	if(rs.next())
					 	{
					 		regname=rs.getString("regname");
					 	}
					 }
				}
				// flag = ServiceParamsUtil.isExitsLocalParams(regservice);
				//alter by shen
				 iframsr="/integration/browse/integrationBrowerSet.jsp?opera="+opera+"&baseid="+baseid+"&formid="+formid+"&updateTableName="+updateTableName+"&dataauth="+dataauth+"&mark="+mark+"&regservice="+regservice+"&w_type="+w_type+"&isbill="+isbill+"&nodeid="+nodeid+"&workflowid="+workflowid+"&srcType="+srcType+"&browsertype="+browsertype+"&hiddenouttable="+hiddenouttable+"&actionid="+actionid;
			}
		%>
<html>
	<head>
		<title></title>
		<style type="text/css">
			.selectItemCss {
				width:250px;
				margin-right: 0px;
			}
		</style>
	</head>
	<body>
	<%
		String saptitle = title;
		if(!"".equals(mark)){
			saptitle = saptitle+"-"+mark;
		}
		
	%>
	<jsp:include page="/systeminfo/commonTabHead.jsp">
		   <jsp:param name="mouldID" value="integration"/>
		   <jsp:param name="navName" value="<%=saptitle%>"/> 
		</jsp:include>

<table id="topTitle" cellpadding="0" cellspacing="0" width="100%">
				<tr>
					<td width="160px">
					</td>
					<td class="rightSearchSpan"
						style="text-align: right; width: 500px !important">
						<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" id="zd_btn_submit_0" class="e8_btn_top" onclick="doSubmit(this,1)">						
						<%
						if("0".equals(w_type))
						{
						%>
						<input type="button" value="<%=SystemEnv.getHtmlLabelName(30656,user.getLanguage())%>" id="zd_btn_submit_0" class="e8_btn_top" onclick="doSubmit(this,2)">						
						<%} %>
						&nbsp;&nbsp;&nbsp;
						<span title="<%=SystemEnv.getHtmlLabelName(82753,user.getLanguage()) %>" class="cornerMenu"></span>
					</td>
				</tr>
			</table>
		
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		<%
		RCMenu += "{"+SystemEnv.getHtmlLabelName(86 ,user.getLanguage())+",javascript:doSubmit(this,1),_self} " ;
		RCMenuHeight += RCMenuHeightStep ;
		//RCMenu += "{保存并存为模板,javascript:doSubmit(this,2),_self} " ;
		//RCMenuHeight += RCMenuHeightStep ;
		if("0".equals(w_type))
		{
			RCMenu += "{"+SystemEnv.getHtmlLabelName(30656 ,user.getLanguage())+",javascript:doSubmit(this,2),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
		}
		RCMenu += "{"+SystemEnv.getHtmlLabelName(201 ,user.getLanguage())+",javascript:doGoBack(this),_self} " ;
		RCMenuHeight += RCMenuHeightStep ;
		%>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		
		
		
		
		<div style="width: 100%;padding: 10px;" id="word">
		<input type="hidden" id="mark" name="mark" value="<%=mark%>">
		
		<wea:layout type="2Col">
			<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
				<wea:item>
					<%=SystemEnv.getHtmlLabelName(30657 ,user.getLanguage()) %>
				</wea:item>
				<wea:item>
					
								
					<brow:browser viewType='0' name='servicesid' browserValue='<%=servicesid%>'
									browserOnClick='' _callback='onchangeservice' browserUrl='/integration/browse/IntegrationServiceBrower.jsp?selectedids='
									hasInput='true'  isSingle='true' hasBrowser = 'true' isMustInput='2'  width='200px' linkUrl='#'
									browserSpanValue='<%=regname %>'></brow:browser>			
				</wea:item>
				
				<wea:item>
					<%=SystemEnv.getHtmlLabelName(30658 ,user.getLanguage()) %>
				</wea:item>
				<wea:item>
					<textarea rows="5" cols="80" id="brodesc" tabindex="1" onpropertychange="checkLength(this,100);" oninput="checkLength(this,100);"><%=brodesc%></textarea>
				</wea:item>
				<%
				if("0".equals(w_type))
				{
						 %>
				<wea:item>
					<%=SystemEnv.getHtmlLabelName(30659 ,user.getLanguage()) %>
				</wea:item>
				<wea:item>
					<input type="checkbox" name="authcontorl"  id="authcontorl" value="1" <%if("1".equals(authcontorl)){out.println("checked=checked");} %>>
				</wea:item>
				<%} %>
				<%
			
				if("1".equals(w_type))
				{
				%>
				<wea:item>
					<%=SystemEnv.getHtmlLabelName(18624 ,user.getLanguage()) %>
				</wea:item>
				<wea:item>
					<input type="checkbox" name="w_enable" id="w_enable" value="1" <%if("1".equals(w_enable)){out.println("checked='checked'");}%>>
				</wea:item>
				<wea:item>
					<%=SystemEnv.getHtmlLabelName(26419 ,user.getLanguage()) %>
				</wea:item>
				<wea:item>
					<input type="text"  maxlength="3" name="w_actionorder" id="w_actionorder" value="<%=w_actionorder%>"> 
								(<%=SystemEnv.getHtmlLabelName(31751 ,user.getLanguage()) %>)
				</wea:item>
				<%	
				}	
			 	%>
						 
			</wea:group>
		</wea:layout>
		<!-- Shadow表格-start -->
		
		<!-- Shadow表格-end -->
		<iframe src="<%=iframsr%>" style="width: 100%;height: 350px;" frameborder="0" scrolling="no" id="maindiv"  name="maindiv">
		</iframe>
		</div>
		
	
	<DIV class=huotu_dialog_overlay id="hidediv">
			
	</DIV>
	<div  id="hidedivmsg" class="bd_dialog_main">
						
	</div>
		
		<script type="text/javascript">
			$(window).ready(function(){
				var d_w=$(window).width();
				$("#word").width(d_w-22+"px");
			});
			var updateChangeService="0";//1表示新建的时候change注册服务，2表示修改的时候change注册服务,"0"表示没用进行change操作
			//判断iframe是否加载完成
			function iframeLoaded(iframeEl, callback) {
		     	if(iframeEl.attachEvent) {
		            iframeEl.attachEvent("onload", function() {
		                if(callback && typeof(callback) == "function") {
		                    callback();
		                }
		            });
		        } else {
		            iframeEl.onload = function() {
		                if(callback && typeof(callback) == "function") {
		                    callback();
		                }
		            }
		        }
		   }
		   //iframe加载完成后回调的函数
			function closeDIV()
			{
				document.getElementById("hidediv").style.display="none";
				document.getElementById("hidedivmsg").style.display="none";
			}
			
			
			function onchangeservice(event,datas,name,para)
			{
			
				<%
					if("save".equals(opera))
					{
				%>
						updateChangeService="1";
				<%
					}else if("update".equals(opera))
					{
				%>
						updateChangeService="2";
				<%
					}
				%>
					
				
				var sid = datas;
				if(sid)
				{
					
					if(sid.id!="")
					{
						var regservice = sid.id.split("_")[3];//服务的id
						//$("#servicesid").next().next().html("");
						var temp=document.body.clientWidth;
						$("#hidediv").css("height",temp);
						var h2=$("#hidedivmsg").css("height");
						var w2=$("#hidedivmsg").css("width");
						var a=(document.body.clientWidth)/2-140; 
						var b=(document.body.clientHeight)/2-40;
						$("#hidedivmsg").css("left",a);
						$("#hidedivmsg").css("top",b);
						$("#hidediv").show();
						$("#hidedivmsg").html("<%=SystemEnv.getHtmlLabelName(30661 ,user.getLanguage()) %>"+"...").show();
						var args0="?opera=<%=opera%>";
							args0+="&baseid=<%=baseid%>";
							args0+="&formid=<%=formid%>";
							args0+="&updateTableName=<%=updateTableName%>";
							args0+="&dataauth=<%=dataauth%>";
							args0+="&mark=<%=mark%>";
							args0+="&regservice="+regservice+"";
							args0+="&w_type=<%=w_type%>";
							args0+="&isbill=<%=isbill%>";
							args0+="&nodeid=<%=nodeid%>";
							args0+="&workflowid=<%=workflowid%>";
							args0+="&updateChangeService="+updateChangeService+"";
							args0+="&srcType=<%=srcType%>";
							args0+="&browsertype=<%=browsertype%>";	
							args0+="&hiddenouttable=<%=hiddenouttable%>";
						//add by wshen
							args0+="&actionid=<%=actionid%>";

						document.getElementById("maindiv").src="/integration/browse/integrationBrowerSet.jsp"+args0;
						iframeLoaded(document.getElementById("maindiv"),closeDIV);//回调
					}else
					{
						//$("#servicesid").next().next().html("<img src='/images/BacoError_wev8.gif' align=absMiddle>");
						document.getElementById("maindiv").src="/integration/browse/integrationSapDirections.jsp?w_type=<%=w_type%>";
						
					}
				}
			}
			//数据提交
			function doSubmit(obj,dataauth)
			{
				
				//验证外层页面的数据必填性
				var temp=0;
				$(" span img").each(function (){
					if($(this).attr("align")=='absMiddle')
					{
						if($(this).css("display")=='inline')
						{
							temp++;
						}
					}
				});
				if(temp!=0)
				{
					alert("<%=SystemEnv.getHtmlLabelName(30622 ,user.getLanguage()) %>"+"!");
					return;
				}
				try
				{
					window.frames["maindiv"].document.getElementById("mark").value;
				}catch(e)
				{
					//如果报错，表示下面的页面对象不存在
					alert("<%=SystemEnv.getHtmlLabelName(30663 ,user.getLanguage()) %>"+"!");
					return;
				}
				
				//验证内层页面的数据必填性
				if(window.frames["maindiv"].checkRequired()&&window.frames["maindiv"].checkDobule())
				{
					
					window.frames["maindiv"].document.getElementById("mark").value=$("#mark").val();
					window.frames["maindiv"].document.getElementById("hpid").value=$("#servicesid").val().split("_")[1];
					window.frames["maindiv"].document.getElementById("poolid").value=$("#servicesid").val().split("_")[2];
					window.frames["maindiv"].document.getElementById("regservice").value=$("#servicesid").val().split("_")[3];
					window.frames["maindiv"].document.getElementById("brodesc").value=$("#brodesc").val();
					window.frames["maindiv"].document.getElementById("w_actionorder").value=$("#w_actionorder").val();
					
					
					if($("#authcontorl").is(":checked"))//jquery判断复选框被选中
					{
						window.frames["maindiv"].document.getElementById("authcontorl").value="1";
					}
					window.frames["maindiv"].document.getElementById("ispreoperator").value="<%=ispreoperator%>";
					window.frames["maindiv"].document.getElementById("nodelinkid").value="<%=nodelinkid%>";
					if($("#w_enable").is(":checked"))//jquery判断复选框被选中
					{
						window.frames["maindiv"].document.getElementById("w_enable").value="1";
					}
					//判断是否显示数据授权界面
					window.frames["maindiv"].document.getElementById("dataauth").value=dataauth;
					var temp=document.body.clientWidth;
					$("#hidediv").css("height",temp);
					var h2=$("#hidedivmsg").css("height");
					var w2=$("#hidedivmsg").css("width");
					var a=(document.body.clientWidth)/2-140; 
					var b=(document.body.clientHeight)/2-40;
					$("#hidedivmsg").css("left",a);
					$("#hidedivmsg").css("top",b);
					$("#hidediv").show();
					$("#hidedivmsg").html("<%=SystemEnv.getHtmlLabelName(20240 ,user.getLanguage()) %>").show();
					window.frames["maindiv"].document.getElementById("weaver").submit();
				}
			}
			
			var dialog = top.getDialog(window)
			/* $(window).unload(function () {
			 	 alert($("#mark").val())
			 	 if($("#mark").val()!="")
			 	 {	
			 	 	if(dialog){
						try{
					  	dialog.callback($("#mark").val());
					  	}catch(e){alert(e)}
					  	
					  	try{
						     dialog.close($("#mark").val());
						
						 }catch(e){alert(e)}
					}else{
			 	 		window.returnValue=$("#mark").val();
			 	 	}
			 	 }	
			 });*/
			 function changeurl(utlstr)
			 {
			 	//参考http://www.jb51.net/article/21139.htm
			 	window.name = "__self"; 
				window.open(utlstr, "__self"); 
				
			 }
			 
			  function closeWindow(id)
			 {
			 	
			 	if(dialog){
						
					  		try{
						     dialog.callbackfun(id);
						
						 }catch(e){alert(e)}
					  	try{
						     dialog.close(id);
						
						 }catch(e){alert(e)}
					}else{
			 	 		window.returnValue=id;
			 	 		window.close();
			 	 	}
				
			 }
			 
			 function doGoBack() {
			 	
			  	if(dialog){
				 	dialog.close();
				 }else{
				 	window.close();
				 }
			 }
			 //限制文本域的长度
			function checkLength(obj,maxlength){
			    if(obj.value.length > maxlength){
			        obj.value = obj.value.substring(0,maxlength);
			    }
			}
		</script>
	</body>
</html>

