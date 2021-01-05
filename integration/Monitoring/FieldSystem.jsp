<%@page import="com.weaver.integration.util.IntegratedSapUtil"%>

<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="com.weaver.integration.entity.ComSapSearchList"%>
<%@page import="com.weaver.integration.entity.FieldSystemBean"%>
<%@page import="com.weaver.integration.entity.SapjarBean"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="SapUtil" class="com.weaver.integration.util.IntegratedUtil" scope="page"/>
<%@ include file="/integration/integrationinit.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs02" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="wf" class="weaver.workflow.workflow.WorkflowComInfo" scope="page"/>
<jsp:useBean id="WFNodeMainManager" class="weaver.workflow.workflow.WFNodeMainManager" scope="page" />
<jsp:useBean id="WFNodePortalMainManager" class="weaver.workflow.workflow.WFNodePortalMainManager" scope="page" />
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<link href="/css/Weaver_wev8.css" type=text/css rel=stylesheet>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<html>
<body>
			<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
			<%
			RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:doSubmit(1),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
			RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:doSubmit(2),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
			%>
			<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
			<%
					
		            String allidstr=Util.null2String(request.getParameter("allidstr"));
		            String poolid = "";//连接池id
					String hpid = "";//所属异构系统id
					String regserviceid = "";//注册服务的id
					String servicesid="";
	             	if(!"".equals(allidstr)){
							poolid=allidstr.split("_")[2];
							hpid=allidstr.split("_")[1];
							regserviceid=allidstr.split("_")[3];
							servicesid=3+"_"+hpid+"_"+poolid+"_"+regserviceid;
					}
		            String allidname=Util.null2String(request.getParameter("allidname"));
					if("".equals(allidname)&&!"".equals(poolid)&&!"".equals(hpid)&&!"".equals(regserviceid)&&!"".equals(servicesid)){
						rs.execute("select regname from sap_service where hpid="+hpid+" and poolid="+poolid+" and id="+regserviceid);
						if(rs.next()){
							allidname=Util.null2String(rs.getString("regname"));
						}
					}
             		String marks[]=request.getParameterValues("marks");//要被标记为删除的项
             		String mark_s=Util.null2String(request.getParameter("mark_s")).trim();//标识
             		String seordel=Util.null2String(request.getParameter("seordel")).trim();
             		String Effective=Util.null2String(request.getParameter("Effective")).trim();//是否有效 0有效，1无效
             		if("2".equals(seordel)){
	             		if(null!=marks){
	             			String tempmarks="";
	             			for(int i=0;i<marks.length;i++){
	             				rs.execute("update int_BrowserbaseInfo set isdelete=1 where mark='"+marks[i]+"'");
	             			}
	             		}
             		}
             		String sql="select  id,mark,w_nodeid,isbill,browsertype,nodelinkid,parurl,w_fid,ispreoperator  from int_BrowserbaseInfo where hpid='"+hpid+"' and poolid='"+poolid+"' and isdelete=0";
             				  sql+=" and regservice='"+regserviceid+ "' ";
             				  sql+="   order by id ";
             		rs.execute(sql);
			 %>
			 <form action="/integration/Monitoring/FieldSystem.jsp?checkmenu=2" method="post"  id="weaverfield">
			 <input type=hidden name="servicesid" id="servicesid" value="<%=servicesid%>">
			<table id="topTitle" cellpadding="0" cellspacing="0">
					<tr>
						<td></td>
						<td class="rightSearchSpan" style="text-align:right; width:630px!important">
							<input type="button" value="<%=SystemEnv.getHtmlLabelName(197 ,user.getLanguage()) %>" class="e8_btn_top" onclick="doSubmit(1)"/>
							<input type="button" value="<%=SystemEnv.getHtmlLabelName(91 ,user.getLanguage()) %>" class="e8_btn_top" onclick="doSubmit(2)"/>
							<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995 ,user.getLanguage()) %></span>&nbsp;&nbsp;
							<span title="<%=SystemEnv.getHtmlLabelName(23036 ,user.getLanguage()) %>" class="cornerMenu"></span>
						</td>
					</tr>
				</table>
				<div id="tabDiv" >
				   <span style="font-size:14px;font-weight:bold;">&nbsp;</span> 
				</div>
				
				<div class="cornerMenuDiv"></div>
				<div class="advancedSearchDiv" id="advancedSearchDiv">
					
				</div>
				<wea:layout type="4col">
						<wea:group context='<%= SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>'>
							<wea:item>
								<input type="hidden" name="seordel" id="seordel">
						     	<%=SystemEnv.getHtmlLabelName(28231,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(31708,user.getLanguage()) %>
						     </wea:item>
							<wea:item>
								<brow:browser viewType='0' name='allidstr' browserValue='<%=allidstr%>'
									browserOnClick='' browserUrl='/integration/browse/IntegrationServiceBrower.jsp?selectedids='
									hasInput='true'  isSingle='true' hasBrowser = 'true' isMustInput='1'  width='200px' linkUrl='#'
									browserSpanValue='<%=allidname %>'></brow:browser>
							</wea:item>
							<wea:item>
										<%=SystemEnv.getHtmlLabelName(15591,user.getLanguage()) %>
							</wea:item>
							<wea:item>
									 <select name="Effective">
									 			<option value=""><%=SystemEnv.getHtmlLabelName(332,user.getLanguage()) %></option>
									 			<option value="0"  <%if("0".equals(Effective)){out.println("selected='selected'");} %> ><%=SystemEnv.getHtmlLabelName(2246,user.getLanguage()) %></option>
									 			<option value="1"  <%if("1".equals(Effective)){out.println("selected='selected'");} %>><%=SystemEnv.getHtmlLabelName(2245,user.getLanguage()) %></option>
									 </select>
							</wea:item>
						</wea:group>
					</wea:layout>
						 <TABLE class=ListStyle cellspacing=1 style="line-height: 20px;table-layout: fixed;" id="sb">
						 		<colgroup>
						 				<col  width="30px">
						 				<col  width="*">
						 				<col  width="*">
						 				<col  width="*">
						 				<col  width="*">
						 				<col  width="*">
						 				<col  width="*">
						 		</colgroup>
								<TR class=header >
										<th><input type="checkbox"  onclick="checkAllBox(this)"></th>
										<th><%=SystemEnv.getHtmlLabelName(31633,user.getLanguage()) %></th>
										<th><%=SystemEnv.getHtmlLabelName(19532,user.getLanguage()) %></th>
										<th><%=SystemEnv.getHtmlLabelName(685,user.getLanguage()) %></th>
										<th><%=SystemEnv.getHtmlLabelName(21934,user.getLanguage()) %></th>
										<th><%=SystemEnv.getHtmlLabelName(30045,user.getLanguage()) %></th>
										<th><%=SystemEnv.getHtmlLabelName(31932,user.getLanguage()) %></th>
								</tr>
						<%
							int i=0;
							while(rs.next()){
								String []args0=new String[12];
								args0[0]=rs.getString("id");
								args0[1]=rs.getString("mark");
								args0[2]=rs.getString("w_nodeid");
								args0[3]=rs.getString("isbill");
								args0[4]=rs.getString("browsertype");
								args0[5]=rs.getString("parurl");
								args0[6]=rs.getString("nodelinkid");
								args0[7]=rs.getString("w_fid");
								args0[8]=user.getLanguage()+"";
								args0[9]=rs.getString("ispreoperator");
								args0[10]=Effective;
								args0[11]=i+"";
								String returnsz[]=IntegratedSapUtil.getMark_message(args0);
								out.println(returnsz[1]);
								i=Util.getIntValue(returnsz[0]);
							}
				%>	
								</TABLE>
		</form>
<script type="text/javascript">
	jQuery(document).ready(function () {
		$("#topTitle").topMenuTitle({searchFn:doRefresh});
		$(".topMenuTitle td:eq(0)").html($("#tabDiv").html());
		$("#tabDiv").remove();
		$("#advancedSearch").bind("click", function(){
		});
	});
	
	function doRefresh(){
		doSubmit("1");
	}
	
	function onchangeservice(){		
			var selectedids=$("#servicesid").val();
			var sid = window.showModalDialog("/integration/browse/IntegrationServiceBrower.jsp?selectedids="+selectedids, "", "dialogWidth:550px;dialogHeight:550px;");
			if(sid){
				$("#servicesid").attr("value",sid.id);
				if(sid.id!=""){
					$("#servicename").html(sid.name);
					$("#allidname").attr("value",sid.name);
					$("#allidstr").attr("value",sid.id);
					$("#imgsapn").html("");
				}else{
					$("#servicename").html("");
					$("#allidname").attr("value","");
					$("#allidstr").attr("value","");
					$("#servicesid").attr("value","");
					$("#imgsapn").html("<img src='/images/BacoError_wev8.gif' align=absMiddle>");
				}
			}
	}
	function seeBrower(url){
			if(url==""){
					alert("<%=SystemEnv.getHtmlLabelName(31637,user.getLanguage())%>!");
			}else{
				var left = Math.ceil((screen.width - 1086) / 2);   //实现居中
			    var top = Math.ceil((screen.height - 600) / 2);  //实现居中
			    var tempstatus = "dialogWidth:1086px;dialogHeight:600px;scroll:yes;status:no;dialogLeft:"+left+";dialogTop:"+top+";";
			    var urls = "/integration/browse/integrationBrowerMain.jsp"+url;
				var temp=window.showModalDialog(urls,"",tempstatus);
			}
	}
	function doSubmit(seordel){
			if(seordel=="2"){
				if($("#sb").find("input:checked[type='checkbox'][name='marks']").length>0){
					if(window.confirm("<%=SystemEnv.getHtmlLabelName(30695,user.getLanguage())%>?")){
							$("#seordel").val(seordel);
							$("#weaverfield").submit();
					}
				}else{
						alert("<%=SystemEnv.getHtmlLabelName(30678,user.getLanguage())%>");
				}
			}else{
				if($("#allidstr").val()!=""){
					$("#seordel").val(seordel);
					$("#weaverfield").submit();
				}else{
					alert("<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage())%>");
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
</script>
</body>
</html>
