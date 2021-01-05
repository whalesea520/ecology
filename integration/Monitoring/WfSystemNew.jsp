
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="com.weaver.integration.entity.ComSapSearchList"%>
<%@page import="com.weaver.integration.entity.FieldSystemBean"%>
<%@page import="com.weaver.integration.entity.SapjarBean"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<link href="/css/Weaver_wev8.css" type=text/css rel=stylesheet>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="SapUtil" class="com.weaver.integration.util.IntegratedUtil" scope="page"/>
<%@ include file="/integration/integrationinit.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs02" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="wf" class="weaver.workflow.workflow.WorkflowComInfo" scope="page"/>
<jsp:useBean id="WFNodeMainManager" class="weaver.workflow.workflow.WFNodeMainManager" scope="page" />
<jsp:useBean id="WFNodePortalMainManager" class="weaver.workflow.workflow.WFNodePortalMainManager" scope="page" />
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<html>
<body>
		<%
					String needhelp ="";
					String titlename=SystemEnv.getHtmlLabelName(31678,user.getLanguage());
					String imagefilename = "/images/hdMaintenance_wev8.gif";
					String method=Util.null2String(request.getParameter("method"));
					String closeDialog=Util.null2String(request.getParameter("closeDialog"));
					if("".equals(method)){method="new";}
					String  id =Util.null2String(request.getParameter("id"));
			        String  name="";
			        String  wfid="";
			        String  sapread="";
			        String  sapwrite ="";
			        String  wfcreateid="";
			        String  wftitle  ="";
			        String  wftitleAdd ="";
			        String  wflevel="";
			        String   isopen="";
			        String  scanInterval="60";
			        String  wfmark ="";
			        String wftitleAddDesc="";
			        String wfname="";
			        String isbille="";
					if("update".equals(method)){
						 rs.execute("select * from sap_thread where id='"+id+"'");
						 if(rs.next()){
						 	   id =Util.null2String(rs.getString("id"));
					          name=Util.null2String(rs.getString("name"));
					          wfid=Util.null2String(rs.getString("wfid"));
					          sapread=Util.null2String(rs.getString("sapread"));
					          sapwrite =Util.null2String(rs.getString("sapwrite"));
					          wfcreateid=Util.null2String(rs.getString("wfcreateid"));
					          wftitle  =Util.null2String(rs.getString("wftitle"));
					          wftitleAdd =Util.null2String(rs.getString("wftitleAdd"));
					          wflevel=Util.null2String(rs.getString("wflevel"));
					           isopen=Util.null2String(rs.getString("isopen"));
					          scanInterval=Util.null2String(rs.getString("scanInterval"));
					          wfmark =Util.null2String(rs.getString("wfmark"));
					          isbille=Util.null2String(rs.getString("isbille"));
						 }
						 if(!"".equals(wfid)){
						 	rs.execute("select workflowname from workflow_base where id='"+wfid+"'");
						 	if(rs.next()){
						 		wfname=rs.getString("workflowname");
						 	}
						 }
						  if(!"".equals(wftitleAdd)){
						  	int temp=Util.getIntValue(wftitleAdd);
						  	if(temp>0){
							  		if("0".equals(isbille)){
								  		rs.execute(" select description from workflow_formdict where id='"+wftitleAdd+"'");
									 	if(rs.next()){
									 		wftitleAddDesc=rs.getString("description");
									 	}
								  	}else{
								  		rs.execute("  select fieldlabel  from workflow_billfield where id="+wftitleAdd+"");
									 	if(rs.next()){
									 		wftitleAddDesc=SystemEnv.getHtmlLabelName(Util.getIntValue(rs.getString("fieldlabel")) ,user.getLanguage());
									 	}
								  	}
						  	}else{
								  	if(temp==-1){
								  			wftitleAddDesc=SystemEnv.getHtmlLabelName(26876, user.getLanguage());
								  	}else if(temp==-2){
								  			wftitleAddDesc=SystemEnv.getHtmlLabelName(18376, user.getLanguage());
								  	}else if(temp==-3){
								  			wftitleAddDesc=SystemEnv.getHtmlLabelName(882, user.getLanguage());
								  	}else if(temp==-4){
								  			wftitleAddDesc=SystemEnv.getHtmlLabelName(772, user.getLanguage());
								  	}else if(temp==-5){
								  			wftitleAddDesc=SystemEnv.getHtmlLabelName(1339, user.getLanguage());
								  	}else if(temp==-6){
								  			wftitleAddDesc=SystemEnv.getHtmlLabelName(16579, user.getLanguage());
								  	}else if(temp==-7){
								  			wftitleAddDesc=SystemEnv.getHtmlLabelName(20558, user.getLanguage());
								  	}else if(temp==-8){
								  			wftitleAddDesc=SystemEnv.getHtmlLabelName(18564, user.getLanguage());
								  	}
						
						  	}
						 }
					}
					
			 %>
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="integration"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(31698,user.getLanguage())%>"/> 
</jsp:include>

			<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
			<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
			<%
			RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSubmit(),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
			//RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:doBack(),_self} " ;
			//RCMenuHeight += RCMenuHeightStep ;
			%>
			<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0" width="100%">
	<tr>
		<td width="160px">
		</td>
		<td class="rightSearchSpan"
			style="text-align: right; width: 500px !important">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" id="zd_btn_submit_0" class="e8_btn_top" onclick="doSubmit();">
			&nbsp;&nbsp;&nbsp;
			<span title="<%=SystemEnv.getHtmlLabelName(82753,user.getLanguage()) %>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
			 <div style="padding-left: 10px;width:98%">
			 <form action="/integration/Monitoring/WfSystemOperation.jsp"  method="post"  name="weaver"  id="weaver">
				 <input type="hidden" name="method" id="method"  value="<%=method%>">
				 <input type="hidden" name="sid" id="sid"  value="<%=id%>">
				 <input type="hidden" name="isDialog" id="isDialog"  value="1">
<wea:layout type="2Col">
    <wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>' attributes="{'groupDisplay':\"\"}">
	<wea:item><%=SystemEnv.getHtmlLabelName(31677,user.getLanguage())%></wea:item>
    <wea:item attributes="{colspan:3}">
        <wea:required id="namespan" required="true" value='<%=name%>'>
        <input type="text"   name="name" id="name" onchange="checkinput('name','namespan')"   value="<%=name%>"  maxlength="80">
        </wea:required>
    </wea:item>
	<wea:item><%=SystemEnv.getHtmlLabelName(30045,user.getLanguage())%></wea:item>
    <wea:item>
		<brow:browser viewType='0' name='wfid' browserValue='<%=wfid%>'
			browserOnClick='' browserUrl='/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser.jsp'
			hasInput='true'  isSingle='true' hasBrowser = 'true' isMustInput='2'  width='200px' linkUrl='#'
			browserSpanValue='<%=wfname %>'></brow:browser>
			&nbsp;<%=SystemEnv.getHtmlLabelName(31679,user.getLanguage()) %>
    </wea:item>
	<wea:item><%=SystemEnv.getHtmlLabelName(31680,user.getLanguage())%></wea:item>
    <wea:item>
		<button type='button' class='Browser'   onclick='onchangeservice(this,1)'></button> 
		<span><%=sapread%></span>
		<span><%if("new".equals(method)){%><img src="/images/BacoError_wev8.gif" align=absMiddle><%}%></span>
		<input type='hidden' name='sapread'  id='sapread'   value="<%=sapread%>">
    </wea:item>
	<wea:item><%=SystemEnv.getHtmlLabelName(31681,user.getLanguage())%></wea:item>
    <wea:item>
			<button type='button' class='Browser'   onclick='onchangeservice(this,2)'></button> 
			<span><%=sapwrite%></span>
			<span></span>
			<input type='hidden' name='sapwrite'  id='sapwrite'   value="<%=sapwrite%>">
		
    </wea:item>
	<wea:item><%=SystemEnv.getHtmlLabelName(882,user.getLanguage())%></wea:item>
    <wea:item>
		<brow:browser viewType='0' name='wfcreateid' browserValue='<%=wfcreateid%>'
			browserOnClick='' browserUrl='/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp'
			hasInput='true'  isSingle='true' hasBrowser = 'true' isMustInput='1'  width='200px' linkUrl='#'
			browserSpanValue='<%=ResourceComInfo.getLastname(wfcreateid) %>'></brow:browser>
        <button type="button" class=browser onClick="onShowResource(this)"></button>
		<span><%=ResourceComInfo.getLastname(wfcreateid) %></span>
		<input type="hidden"  name="wfcreateid"  id="wfcreateid"  value="<%=wfcreateid%>">
		&nbsp;<%=SystemEnv.getHtmlLabelName(31683,user.getLanguage()) %>
    </wea:item>
	<wea:item><%=SystemEnv.getHtmlLabelName(229,user.getLanguage())%></wea:item>
    <wea:item>
        <input type="text" name="wftitle" id="wftitle"  value="<%=wftitle%>"  maxlength="100" style="float:left;">
		<brow:browser viewType='0' name='wftitleAdd' browserValue='<%=wftitleAdd%>'
			browserOnClick='' getBrowserUrlFn="getWfTitleBrowserUrl" browserUrl=''
			hasInput='true'  isSingle='true' hasBrowser = 'true' isMustInput='1'  width='200px' linkUrl='#'
			browserSpanValue='<%=wftitleAddDesc %>'></brow:browser>
		&nbsp;+<%=SystemEnv.getHtmlLabelName(31684,user.getLanguage()) %>
    </wea:item>
	<wea:item><%=SystemEnv.getHtmlLabelName(139,user.getLanguage())%></wea:item>
    <wea:item>
        <select  name="wflevel" id="wflevel">
			<option value="0"  <%if("0".equals(wflevel)){out.println("selected='selected'");}%> ><%=SystemEnv.getHtmlLabelName(225,user.getLanguage()) %></option>
			<option value="1" <%if("1".equals(wflevel)){out.println("selected='selected'");}%>><%=SystemEnv.getHtmlLabelName(15533,user.getLanguage()) %></option>
			<option value="2"  <%if("2".equals(wflevel)){out.println("selected='selected'");}%>><%=SystemEnv.getHtmlLabelName(2087,user.getLanguage()) %></option>
		</select>
		&nbsp;<%=SystemEnv.getHtmlLabelName(31685,user.getLanguage()) %>
    </wea:item>
	<wea:item><%=SystemEnv.getHtmlLabelName(18624,user.getLanguage())%></wea:item>
    <wea:item>
        <select id="isopen" name="isopen">
			<option value="0"  <%if("0".equals(isopen)){out.println("selected='selected'");}%>><%=SystemEnv.getHtmlLabelName(31675,user.getLanguage()) %></option>
			<option value="1"  <%if("1".equals(isopen)){out.println("selected='selected'");}%>><%=SystemEnv.getHtmlLabelName(31676,user.getLanguage()) %></option>
		</select>
		&nbsp;<%=SystemEnv.getHtmlLabelName(31686,user.getLanguage()) %>
    </wea:item>
	<wea:item><%=SystemEnv.getHtmlLabelName(31687,user.getLanguage())%></wea:item>
    <wea:item>
        <input type="text"  name="scanInterval" id="scanInterval"  value="<%=scanInterval%>"  maxlength="3">&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(15049,user.getLanguage()) %>
		&nbsp;<%=SystemEnv.getHtmlLabelName(31688,user.getLanguage()) %>
    </wea:item>
	<wea:item><%=SystemEnv.getHtmlLabelName(26408,user.getLanguage())%></wea:item>
    <wea:item>
        <textarea rows="2" cols="40"  name="wfmark" id="wfmark"  onpropertychange="checkLength(this,100);" oninput="checkLength(this,100);"  ><%=wfmark %></textarea>
    </wea:item>
	</wea:group>
</wea:layout>

		</form>
			</div>						
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout needImportDefaultJsAndCss="false">
	<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
		<wea:item type="toolbar">
	    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="onCancel();">
	 	</wea:item>
	</wea:group>
	</wea:layout>
</div>
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include> 
<script type="text/javascript">
	function onCancel(){
		var dialog = parent.getDialog(window);   //弹出窗口的引用，用于关闭页面
		dialog.close();
	}
	
	$(document).ready(function(){
		if("<%=closeDialog%>"=="close"){			
			var parentWin = parent.getParentWindow(window);
			parentWin.location.reload();
			onCancel();
		}
	});

	function doBack(){
		window.location.href="/integration/Monitoring/WfSystem.jsp?checkmenu=4";
	}
	function doSubmit(){
			var temp=0;
		$("span img").each(function (){
			if($(this).attr("src").indexOf("BacoError")>-1)
			{
				if($(this).css("display")=='inline')
				{
					temp++;
				}
			}
		});
		if(temp!=0)
		{
			alert("<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage()) %>");
			return false;
		}else
		{
			var tempVal = $("#wftitleAdd").val();
			if(tempVal!=""&&tempVal.indexOf(",")>-1){
				tempVal = tempVal.split(",")[1];
				$("#wftitleAdd").val(tempVal);
			}
			$("#weaver").submit();
		}
			
	}
	
	function getWfTitleBrowserUrl(){
		var wf_id=$("#wfid").val();
		var url="/integration/browse/BrowserMain.jsp?url=/integration/browse/integrationBatchOA.jsp?wf_id="+wf_id+"&partype=1&updateTableName=&w_type=2&backtable=&srcType=&browsertype=228&sFlag=1";
				
		return url;
	}
	function onShowField(obj){
				var wf_id=$("#wfid").val();
				//formid
				//isbill
				//
				var url="/integration/browse/BrowserMain.jsp?url=/integration/browse/integrationBatchOA.jsp?wf_id="+wf_id+"&partype=1&updateTableName=&w_type=2&backtable=&srcType=&browsertype=228";
				var temp = window.showModalDialog(url, "", "dialogWidth:550px;dialogHeight:550px;");
				if(temp){
		 		 if (temp.names!=""&&temp.viewtype!="-1"){
		 		 	//表明弹出的浏览框里面选择了oa字段
					var tempdesc=temp.desc.split(",");
					var tempid=temp.viewtype.split(",");
					$(obj).next().html(""+tempdesc[1]);
					$(obj).next().next().val((tempid[1]).split("_")[1]);
				}else{
					$(obj).next().html("");
					$(obj).next().next().val("");
				}
			}
	}
	
	
	function onShowResource(obj) {
				var id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp", "", "dialogWidth:550px;dialogHeight:550px;");
				if (id != null) {
			        if (wuiUtil.getJsonValueByIndex(id, 0) != "" && wuiUtil.getJsonValueByIndex(id, 0) != "0") {
						$(obj).next().html(wuiUtil.getJsonValueByIndex(id, 1));
						$(obj).next().next().val(wuiUtil.getJsonValueByIndex(id, 0));
			        } else {
						$(obj).next().html("");
						$(obj).next().next().val("");
			        }
				}
	}
	function onchangeservice(obj,type){		
		var wf_id=$("#wfid").val();
		if(wf_id==""){
			alert("<%=SystemEnv.getHtmlLabelName(31928,user.getLanguage()) %>!");
			return;
		}
		var mark=$(obj).next().next().next().val();
		var left = Math.ceil((screen.width - 1086) / 2);   //实现居中
	    var top = Math.ceil((screen.height - 600) / 2);  //实现居中
	    var hiddenouttable="";
	    if(type=="2"){
	    	hiddenouttable="y";
	    }
	    //?workflowId=3861&nodeid=4721&nodelinkid=0&ispreoperator=0&workflowid=3861&w_type=1
	    var tempstatus = "dialogWidth:1086px;dialogHeight:600px;scroll:yes;status:no;dialogLeft:"+left+";dialogTop:"+top+";";
	    var urls = "/integration/browse/integrationBrowerMain.jsp?workflowid="+wf_id+"&nodeid=0&nodelinkid=0&browsertype=228&ispreoperator=0&w_type=2&mark="+mark+"&hiddenouttable="+hiddenouttable;
		//var temp=window.showModalDialog(urls,"",tempstatus);
		var dialog = new window.top.Dialog();
		dialog.currentWindow = window;
		dialog.Title = "SAP";
	    dialog.URL = urls;
		dialog.Width = 660;
		dialog.Height = 660;
		dialog.DefaultMax = true;
		dialog.maxiumnable=true;
		dialog.callbackfun=function(temp){
			if(temp){
				$(obj).next().html(temp);
				$(obj).next().next().html("");
				$(obj).next().next().next().val(temp);
			}
		};
 		
		dialog.show();
		
		
	}
	function selectForm(obj){
	    var tempstatus = "dialogWidth:500px;dialogHeight:500px;scroll:yes;status:no;";
	    var urls = "/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser.jsp";
		var temp=window.showModalDialog(urls,"",tempstatus);
		if(temp){
			if(temp.id!=""){
				$(obj).next().html("");
				$(obj).next().next().html(temp.name);
				$(obj).next().next().next().val(temp.id);
				$("#wftitle").val(temp.name);
			}else{
				$(obj).next().html("<img src='/images/BacoError_wev8.gif' align=absMiddle>");
				$(obj).next().next().html("");
				$(obj).next().next().next().val("");
				$("#wftitle").val("");
			}
		}
	}
	
	//通用的选中表格某列的所有checkbox的方法
	function checkAllBox(obj){
				var T_table="";
				if($(obj).parent().parent().parent()[0].tagName=="TABLE"){
					T_table=$(obj).parent().parent().parent()[0];
				}else if($(obj).parent().parent().parent().parent()[0].tagName=="TABLE"){
					T_table=$(obj).parent().parent().parent().parent()[0];
				}
				 var countTD=$(T_table).find("tr:first").find("td").length;
				 if(countTD<=0){
				 		countTD=$(T_table).find("tr:first").find("th").length;
				 }
				 var tdindex=$(T_table).find("td").index($(obj).parent()[0]);
				 if(tdindex<0){
				 	 tdindex=$(T_table).find("th").index($(obj).parent()[0]);
				 }
				 if(tdindex>=countTD){
				 	tdindex=tdindex%countTD;
				 }
				 index=(tdindex);//表格的第几列
				 var trSeq = $(T_table).find("tr").index($(obj).parent().parent()[0]);//表格的第几行
				 var  flag="";
            	 $(T_table).find("tr").each(function(i){
            	 			if(i==0){
									flag=$(obj).attr('checked');
							}
							$(this).find("td:eq("+index+")").find("input[type='checkbox']").attr('checked',flag);
							$(this).find("th:eq("+index+")").find("input[type='checkbox']").attr('checked',flag);
				});
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
