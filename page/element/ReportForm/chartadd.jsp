<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%@page import="weaver.servicefiles.DataSourceXML"%>
<!-- modified by wcd 2014-07-02 [E7 to E8] -->
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%
	if(!HrmUserVarify.checkUserRight("ReportFormElement", user)){
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
//	String ctitle= Util.null2String(request.getParameter("tabTitle"));	
//	String sqlWhere = Util.null2String(request.getParameter("value"));
	String pagetype = Util.null2String(request.getParameter("pagetype"));
	String ispagedeal=Util.null2String(request.getParameter("ispagedeal"));
	String wfid = Util.null2String(request.getParameter("wfid"));
	String nodeid=Util.null2String(request.getParameter("nodeid"));
	String ctitle= "";
	String sqlWhere = "";	
    String eid=Util.null2String(request.getParameter("eid"));
    String tabId = Util.null2String(request.getParameter("tabId"));
    String ebaseid = Util.null2String(request.getParameter("ebaseid"));
    String method = Util.null2String(request.getParameter("method"));
	if (session.getAttribute(eid + "_Add") != null) {
		Hashtable tabAddList = (Hashtable) session.getAttribute(eid+ "_Add");
		if (tabAddList.containsKey(tabId)) {
			Hashtable tabInfo = (Hashtable) tabAddList.get(tabId);
			sqlWhere = (String) tabInfo.get("tabWhere");
			ctitle = (String) tabInfo.get("tabTitle");
		}
		
	}
	if("".equals(sqlWhere) && "".equals(ctitle)){
		rs.executeSql("select sqlWhere,tabTitle from hpNewsTabInfo where eid="+eid+" and tabid="+tabId);
	    if(rs.next()){ 
	    	sqlWhere=rs.getString("sqlWhere");
	    	ctitle=rs.getString("tabTitle");
	    }
	}
	String imagefilename = "/images/hdSystem_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(377,user.getLanguage());
	String needfav ="1";
	String needhelp ="";
	String hpid= "";
	rs.executeSql("select hpid from hpelement where id="+eid);
	if(rs.next()){
		hpid = rs.getString("hpid");
	}
	String ctype= "",cdot = "0",cwidth = "200",cheight = "200",cdb = "",csql = "";
	if(!"".equals(sqlWhere)){
		String[] arySqlWhere = sqlWhere.split("\\^,\\^",-1);
		if(arySqlWhere.length>5){
			ctype=arySqlWhere[0];
			cdot=arySqlWhere[1];
			cwidth=arySqlWhere[2];
			cheight=arySqlWhere[3];
			cdb=arySqlWhere[4];
			csql=arySqlWhere[5];
		}else{
			ctype=arySqlWhere[0];
			cwidth=arySqlWhere[1];
			cheight=arySqlWhere[2];
			cdb=arySqlWhere[3];
			csql=arySqlWhere[4];
		}
	}

	String isclose = Util.null2String(request.getParameter("isclose"));
	String isDialog = Util.null2String(request.getParameter("isdialog"));
	
	String repirtFormDBPoint="";
	String userLanguageId= user.getLanguage()+"";
    
	String sql =  "select * from hpreportformtype order by id" ;
    rs.execute(sql);
	String reportFormType="<select name='charttype_"+eid+"'>" ;
	while(rs.next()){
		if(rs.getString("id").equals("9")||rs.getString("id").equals("10")){
			continue;
		}
		if(ctype.equals(rs.getString("id"))){
			reportFormType+="<option selected value="+rs.getString("id")+">" +SystemEnv.getHtmlLabelName(Util.getIntValue(rs.getString("name")),Util.getIntValue(userLanguageId))+"</option>" ;
		}else{
			reportFormType+="<option value="+rs.getString("id")+">" +SystemEnv.getHtmlLabelName(Util.getIntValue(rs.getString("name")),Util.getIntValue(userLanguageId))+"</option>" ;
     	}
	}
    reportFormType+="</select>";

	String dbString ="<select name='chartdb_"+eid+"'>";
		DataSourceXML dataSourceXML =new DataSourceXML();
		ArrayList pointArrayList = dataSourceXML.getPointArrayList();
		dbString+="<option value=''"+("".equals(cdb)?"selected":"")+">"+SystemEnv.getHtmlLabelName(23999,Util.getIntValue(userLanguageId))+"</option>";
		for(int i=0;i<pointArrayList.size();i++){
			String point = (String)pointArrayList.get(i);
			String selected = point.equals(cdb)?"selected":"";
			dbString+="<option value="+point+" "+selected+">"+point+"</option>";
		}
	dbString+="</select>";
%>
<HTML>
	<HEAD>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<style>
           .paramdetail{
           	 margin-right: 10px;
		     cursor:pointer;
		   }
		   .paramdetail:hover{
		     color:#018efb;
		   }

		</style>
		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
        <script type="text/javascript">
			var parentWin = parent.parent.getParentWindow(parent);
			var dialog = parent.parent.getDialog(parent);
			if("<%=isclose%>"=="1"){
				parentWin.closeDialog();	
			}
		 	function doSave(){
		    	if(check_form(document.frmMain,'countryname,countrydesc') &&  checkform()){
		    		var dialog = parent.getDialog(window);
		    		parentWin = dialog.currentWindow;
		    		parentWin.doTabSave('<%=eid %>','<%=ebaseid %>','<%=tabId %>','<%=method %>');
				   	//document.frmMain.submit();
		  		}
		 	}
		 	function onCancel(){
				var dialog = parent.getDialog(window);	
				dialog.close();
			}
			/**
				验证SQL语句
			*/
			function checkSql(Obj){
				var sqlStr = jQuery(Obj).val();//event.srcElement.value;
				sqlStr = sqlStr.replace(/\n/g,"");
				sqlStr = sqlStr.replace(/\r/g,"");
				event.srcElement.value = sqlStr;
				sqlStr = " "+sqlStr.toUpperCase();
				if(sqlStr.indexOf(' INSERT ')!=-1||sqlStr.indexOf(' UPDATE ')!=-1 || sqlStr.indexOf(' DELETE ')!=-1 || sqlStr.indexOf(' CREATE ')!=-1|| sqlStr.indexOf(' DROP ')!=-1 ){
					//event.srcElement.value = "";
					jQuery(Obj).val("");
					jQuery(Obj).next("span").show();
					window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(22949,user.getLanguage())%>")
				}else{
				  if(sqlStr!==' '){
				      jQuery(Obj).next("span").hide();
				  }else{
					  jQuery(Obj).next("span").show();
				  }
			    }
				
			}
			function hasTitle(Obj){
				var valStr = jQuery(Obj).val();//event.srcElement.value;
				if(valStr!==''){
				    jQuery(Obj).next("span").hide();
				}else{
					jQuery(Obj).next("span").show();
				}
			}
			//检测表单
			function  checkform(){
			   var chartsql=jQuery(".chartsql").val();
			   if(chartsql==='')
			   {
                   window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(84020,user.getLanguage())%>");
			       return false;
			   }
			   return true;
			}
			function getNewsSettingString(eid){
				var paramarray=[];
				var chartype=$("select[name='charttype_"+eid+"']").val();
				paramarray.push(chartype);
				paramarray.push("^,^");
				var chartdot=$("input[name='chartdot_"+eid+"']").val();
				paramarray.push(chartdot);
				paramarray.push("^,^");
	            var chartwidth=$("input[name='chartwidth_"+eid+"']").val();
	            paramarray.push(chartwidth);
				paramarray.push("^,^");
				var chartheight=$("input[name='chartheight_"+eid+"']").val();
	            paramarray.push(chartheight);
				paramarray.push("^,^");
				var chartdb=$("select[name='chartdb_"+eid+"']").val();
	            paramarray.push(chartdb);
				paramarray.push("^,^");
	            var chartsql=$("textarea[name='chartsql_"+eid+"']").val();
	            chartsql = chartsql.replace(new RegExp(/count\(/g),'count (');
	            paramarray.push(chartsql);
				return paramarray.join("");
			}
		</script>
	</head>
	<BODY>
		<div class="zDialog_div_content">
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		<%
			RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave(),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
		%>	
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr>
				<td width="160px">
					</td>
				<td class="rightSearchSpan" style="text-align:right; width: 500px !important">
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" class="e8_btn_top" onclick="doSave();">
					<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
				</td>
			</tr>
		</table>
		<FORM id=weaver name=frmMain action="CountryOperation.jsp" method=post >
		
			<wea:layout type="2col">
				<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
					<wea:item><%=SystemEnv.getHtmlLabelName(84021,user.getLanguage())%></wea:item>
					<wea:item>
						<wea:required id="namespan" >
							 <%=reportFormType%>
						</wea:required>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(84022,user.getLanguage())%></wea:item>
					<wea:item  >
						<wea:required id="descspan" required="true">
							<input class=InputStyle maxLength=50 size=50 id='tabTitle_<%=eid %>' name=tabTitle_<%=eid %> onblur="hasTitle(this)" value="<%=ctitle %>"><!--<font color="#FF0000"><%=SystemEnv.getHtmlLabelName(27087,user.getLanguage())%></font>-->
						</wea:required>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(15212,user.getLanguage())%></wea:item>
					<wea:item>
						<wea:required id="descspan">
							<input  class=InputStyle maxLength=50 size=50 name="chartdot_<%=eid %>"  value="<%=cdot %>">
						</wea:required>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(84023,user.getLanguage())%></wea:item>
					<wea:item>
						<wea:required id="descspan" >
							<span><%=SystemEnv.getHtmlLabelName(203,Util.getIntValue(userLanguageId))%><input  type=text style='width:35px' name='chartwidth_<%=eid %>' class=inputStyle value='<%=cwidth %>'/>&nbsp;
							 <%=SystemEnv.getHtmlLabelName(207,Util.getIntValue(userLanguageId))%><input  type=text style='width:35px' class=inputStyle name='chartheight_<%=eid %>' value='<%=cheight %>'/>
							</span>
						</wea:required>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(28006,user.getLanguage())%></wea:item>
					<wea:item>
						<wea:required id="descspan" >
							<%=dbString%>
						</wea:required>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(84025,user.getLanguage())%></wea:item>
					<wea:item>
						<wea:required id="descspan" required="true">
							<textarea  name='chartsql_<%=eid %>'   style="height:70px;width:97%" class="inputStyle chartsql"  onblur="checkSql(this)"><%=csql %></textarea>
						</wea:required>
					</wea:item>
					
                    <wea:item></wea:item>
					<wea:item>
						  <span class='paramdetail' onclick="showparamDetail('<%=Integer.valueOf(hpid)%>','<%=eid%>', 'sys');"><%=SystemEnv.getHtmlLabelName(130008,user.getLanguage())%></span>
						  <% if(("wf".equals(pagetype) && "1".equals(ispagedeal)) || "hp_workflow_form".equals(pagetype)) {%>
							<span class='paramdetail' onclick="showparamDetail('<%=Integer.valueOf(hpid)%>','<%=eid%>', 'form');"><%=SystemEnv.getHtmlLabelName(130009,user.getLanguage())%></span>
					      <% } %>
					</wea:item>
				</wea:group>
			</wea:layout>		
			<input class=inputstyle type="hidden" name="operation" value="add">
		</form>
	</div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout type="2col">
	    	<wea:group context="">
		    	<wea:item type="toolbar">
					<input type="button" value="<%=SystemEnv.getHtmlLabelName("add".equals(method)?611:30986,user.getLanguage())%>" class="zd_btn_submit" onclick="doSave();">		    	
		    		<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" class="e8_btn_cancel" onclick="onCancel();">
		    	</wea:item>
		   	</wea:group>
	  	</wea:layout>
	</div>
	<script type="text/javascript">
		jQuery(document).ready(function(){
		//	resizeDialog(document);
			if($("textarea[name='chartsql_<%=eid %>']").val() != ''){
				$("textarea[name='chartsql_<%=eid %>']").next().hide();
			}
			if($("#tabTitle_<%=eid %>").val() != ''){
				$("#tabTitle_<%=eid %>").next().hide();
			}
		});
	</script>
    <script>
      	function showparamDetail(hpid,eid,varType){
		    var layout_dialog = new window.top.Dialog();
		    layout_dialog.currentWindow = window;   //传入当前window
	 	    layout_dialog.Width = 600;
			layout_dialog.Height = 650;
			layout_dialog.Modal = true;
			layout_dialog.Title = "<%=SystemEnv.getHtmlLabelName(84027,user.getLanguage())%>"; 
			layout_dialog.URL = "/synergy/maintenance/SynergyElementSet4ReportParamFrame.jsp?sbaseid="+hpid+"&eid="+eid+"&varType="+varType+"&wfid=<%=wfid%>&nodeid=<%=nodeid%>";
            layout_dialog.show();
		}
	</script>
	</BODY>
</HTML>
