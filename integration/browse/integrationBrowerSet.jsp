
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="com.weaver.integration.params.ServiceParamModeStatusBean"%>
<%@page import="com.weaver.integration.params.ServiceParamModeDisUtil"%>
<%@page import="com.weaver.integration.params.ServiceParamModeDisBean"%>
<%@page import="weaver.workflow.form.FormManager"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RecordSet02" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="inteutil" class="com.weaver.integration.util.IntegratedUtil" scope="page"/>
<jsp:useBean id="ssu" class="com.weaver.integration.util.SAPServcieUtil" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="RolesComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page"/>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page"/>
<link href="/css/Weaver_wev8.css" type=text/css rel=stylesheet>
<link href="/integration/css/intepublic_wev8.css" type=text/css rel=stylesheet>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<link type="text/css" href="/js/tabs/css/e8tabs6_wev8.css" rel="stylesheet" />
<jsp:useBean id="basebean" class="weaver.general.BaseBean" scope="page" />

<html>
	<head>
		<title><%=SystemEnv.getHtmlLabelName(26968 ,user.getLanguage())%></title>
		<style type="text/css">
			.toolbar{
				float: right;
				margin-right: 100px;
			}
			.hideBlockDiv{
				display:none!important;
			}
			
		</style>
	</head>

	
	<!-- 业务逻辑 start-->
	<%
			//对应OA字段的值为"",则认为固定值为""
			//节点后动作才能有输入表：因为如果在浏览按钮配置输入表的话，哪意味着需要js抓取流程页面表单的明细表数据
			//远程加载参数，可以防止数据库的函数字段变更，而引起这边的函数不能用的情况，及时地更新本地数据
			//本地加载参数，就是直接抓取本地的数据进行读取
			//只有新建的时候加载模板功能才有用，修改的时候暂时不开放。。。。
			//保存为模板什么意思？？
			//后台SAP-ABAP函数名是什么意思??
			//28245
			
			//function addOneFieldObjOA标准 
			//--------------<button> 浏览按钮
			//--------------<input>  隐藏的oa字段name
			//--------------<span>   显示的oa字段name
			//--------------<span>   显示img
			//--------------<input>  记录字段(是否主字段，字段的数据库id,)
			
			//table--id规则
			//第一个table id:sap_01   全选cbox_01                              添加add_01                子tableid chind01
			//第二个table id:sap_02   全选cbox_02_01,cbox_02_02,...cbox_02_n 添加add_02
			//第三个table id:sap_03   全选cbox_03     添加add_03
			//第四个table id:sap_04   全选cbox_04_01,cbox_04_02,...cbox_04_n 添加add_04
			//第五个table id:sap_05   全选cbox_05_01,cbox_05_02,...cbox_05_n 添加add_05
			String baseid=Util.null2String(request.getParameter("baseid"));
			int sap_inParameter=1;//输入参数计数器
			int sap_inStructure=1;//输入结构计数器
			int sap_outParameter=1;
			int sap_outStructure=1;
			int sap_outTable=1;
			int int_authorizeRight=1;
			int sap_inTable=1;
			int ismainfield=0;//是否明细表,0表示是主表,1表示是明细表
			String sql="";
			//add by wshen
			String actionid = Util.null2String(request.getParameter("actionid"));
			String partype = Util.null2String(request.getParameter("partype"),"1");

			String hiddenouttable=Util.null2String(request.getParameter("hiddenouttable"));//是否隐藏输出表
			String srcType=Util.null2String(request.getParameter("srcType"));//这种情况来源于字段管理--新建字段 (detailfield=明细字段,mainfield=主字段)
			String formid=Util.null2String(request.getParameter("formid"));//得到流程表单的formid
			String updateTableName=Util.null2String(request.getParameter("updateTableName"));//得到主表或明显表的name,用于判断当前配置的浏览按钮放置在那张表中
			FormManager fManager = new FormManager();
			if(fManager.isDetailTable(updateTableName)||updateTableName.indexOf("$_$")>=0){
				ismainfield=1;
			}
			String dataauth=Util.null2String(request.getParameter("dataauth"));//得到是否跳到数据授权界面
			String mark=Util.null2String(request.getParameter("mark"));
			String opera=Util.null2String(request.getParameter("opera"));//
			//用于判断是远程获取参数还是本地获取参数，1是本地获取参数，2是远程获取参数
			String  islocal="";
			String regservice=Util.null2String(request.getParameter("regservice"));//注册服务的服务id
			
			//1表示新建的时候change注册服务，2表示修改的时候change注册服务,"0"表示没用进行change操作
			String updateChangeService=Util.null2String(request.getParameter("updateChangeService"));
			//System.out.println("updateChangeService=="+updateChangeService);
			//通过注册服务的id,判断该数据源是否初始化了abap数据
			sql="select count(*) s from int_serviceParams where Servid="+regservice;
			if(RecordSet.execute(sql)&&	RecordSet.next()){
				if(Util.getIntValue(RecordSet.getString("s"),0)>0){
					islocal="1";//如果初始化了数据，就从本地读数据
				}
			}
			boolean loadflag=false;
			String loadmb="0";//前台页面是否”自动初始化模板”
			sql="select loadmb s from sap_service where id="+regservice;
			if(RecordSet.execute(sql)&&	RecordSet.next()){
				loadmb=Util.getIntValue(RecordSet.getString("s"),0)+"";
				if(loadmb.equals("1")&&"2".equals(updateChangeService)){//用于判断修改状态是否初始化模板
						loadflag=true;
				}
			}
			String paramModeId="";
			sql="select id from int_serviceParamMode where ServId='"+regservice+"'";
			if(RecordSet.execute(sql)&&	RecordSet.next()){
				paramModeId=Util.getIntValue(RecordSet.getString("id"),-1)+"";
			}
			
			ServiceParamModeStatusBean spmsb =new ServiceParamModeStatusBean();
			if(!"".equals(paramModeId)&&Util.getIntValue(paramModeId, -1)>0){//如果模板的id不为"",并且生成了模板id
					 spmsb =ServiceParamModeDisUtil.getServParModStaBeanById(regservice, paramModeId);
			}
			String w_type=Util.null2String(Util.getIntValue(request.getParameter("w_type"),0)+"");//0-表示是浏览按钮的配置信息，1-表示是节点后动作配置时的信息
			int isbill= Util.getIntValue(request.getParameter("isbill"),0);//0表示老表单,1表示新表单
			//节点id
			int nodeid = Util.getIntValue(Util.null2String(request.getParameter("nodeid")),0);
			//工作流的id
			int workflowid = Util.getIntValue(Util.null2String(request.getParameter("workflowid")),0);
			String oldautotypeid=",";//记录修改前的所有的int_authorizeRight表的id
			
			String browsertype=Util.null2String(Util.getIntValue(request.getParameter("browsertype"),226)+"");//226--单选浏览按钮,227--多选浏览按钮
			
			if("227".equals(browsertype)){
				srcType="detailfield";
			}
			if("".equals(opera)){opera="save";}
																																				
																				
													 										  	
	%>
	<!-- 业务逻辑 end-->
	
	
	<body>	
		
	<form  method="post" name="weaver"  id="weaver"   target="postiframe" action="/integration/browse/integrationBrowerOperation.jsp">
	
	<div class="e8_box demo2" id="seccategorybox">
    <ul class="tab_menu">
       	 <li class="current">
        	<a href="#sap_01" onclick="showItemAreaSap('#sap_01');jumpToAnchor('#baseInfoSet');return false;">
        		<%=SystemEnv.getHtmlLabelName(28245 ,user.getLanguage())%>
        	</a>
        </li>
         <li class="">
        	<a href="#sap_02" onclick="showItemAreaSap('#sap_02');jumpToAnchor('#baseInfoSet');return false;">
        		<%=SystemEnv.getHtmlLabelName(28251 ,user.getLanguage())%>
        	</a>
        </li>
        
        <%
    	if("1".equals(w_type))
		{
        %>
         <li class="">
        	<a href="#sap_07" onclick="showItemAreaSap('#sap_07');jumpToAnchor('#baseInfoSet');return false;">
        <%=SystemEnv.getHtmlLabelName(30712 ,user.getLanguage()) %>
        </a>
        </li>
        <%} %>
        <li class="">
        	<a href="#sap_03" onclick="showItemAreaSap('#sap_03');jumpToAnchor('#baseInfoSet');return false;">
        	<%=SystemEnv.getHtmlLabelName(28255 ,user.getLanguage())%>
        	</a>
        </li>
          <li class="">
        	<a href="#sap_04" onclick="showItemAreaSap('#sap_04');jumpToAnchor('#baseInfoSet');return false;">
        	<%=SystemEnv.getHtmlLabelName(28256 ,user.getLanguage())%>
        	</a>
        </li>
        
		<%
		if(!"y".equals(hiddenouttable))
		{
		%>
		<li class="">
			<a href="#sap_05" onclick="showItemAreaSap('#sap_05');jumpToAnchor('#baseInfoSet');return false;">
			<%=SystemEnv.getHtmlLabelName(28260 ,user.getLanguage())%>
			</a>
		</li>
		<% 
			}
		 %>
	<%
		if("update".equals(opera)&&"0".equals(w_type))
		{
	%>
		<li class="">
			<a href="#sap_06" onclick="showItemAreaSap('#sap_06');jumpToAnchor('#baseInfoSet');return false;">
			<%=SystemEnv.getHtmlLabelName(30620 ,user.getLanguage())%>
			</a>
		</li>
	<% 
		}
	 %>
												
												
        <%
        //if()
        %>
    </ul>
    <div id="rightBox" class="e8_rightBox">
    </div>
    <div class="tab_box" style="display:none;">
        <div>
        </div>
    </div>
</div>
<TABLE  cellspacing=1 style='table-layout:fixed;' id="tableid" width="100%">
						
						<TR class=DataLight>	
							<TD colspan="3">

					<!--ListStyle 表格start  -->
			<wea:layout type="2col" attributes="{layoutTableId:sap_01layout,customAttrs:'sapitem'}" css="shownone">
				  <wea:group context='<%=SystemEnv.getHtmlLabelName(28245 ,user.getLanguage()) %>' >
				    <wea:item attributes="{'colspan':'full','isTableList':'true'}">
						<TABLE width="200px" style="margin-top: -34px;margin-right: 26px;float: right;">
		            				<TR>
		            					<TD align=right>
		            							<input type="button" class="addbtnB" id='bath_01' accesskey="A" onclick="addBathFieldObj(1,1)" title="C-<%=SystemEnv.getHtmlLabelName(25055,user.getLanguage()) %>"> 								
												<input type="button" class="addbtn" id='add_01' accesskey="A" onclick="addBathFieldObj(1,2)" title="A-<%=SystemEnv.getHtmlLabelName(83476,user.getLanguage()) %>"> 
												<input type="button" class="delbtn"  id='del_01' accesskey="E" onclick="addBathFieldObj(1,3)" title="E-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage()) %>">
										<% 
											String hidden01value = "";
											if(("save".equals(opera)&&"1".equals(loadmb))||loadflag){
												hidden01value = spmsb.getImpstrcount()+"";
													//sapinParameter01.append(spmsb.getImpstrcount());//模板里面的输入参数总数
											}else{
												hidden01value=inteutil.getSapInAndOutParameterCount("1",baseid);
													
											}
											%>
											<input type='hidden' id='hidden01' value='<%=hidden01value %>' name='hidden01' >
		            					</TD>
		            				</TR>
		          		</TABLE>
		          		
	        
			
	          	    
									
									
									<!-- 第一个tab页里面的内容table--start -->
									 	
							
			<TABLE class='ListStyle marginTop0 sapitem' cellspacing=1 id='sap_01' style='table-layout: fixed;'>
			
			<tr>
			<td>
				<!-- add by wshen-->
				<div id = "showScrollDiv" style ="border:0px solid #000;height:300px;width:100%;	overflow:auto;" >
				<TABLE  class="ListStyle"  id='chind01'>
					<colgroup>
				 <col width='10%'/>  
				 <col width='15%'/> 
				 <col width='15%'/> 
				 <col width='10%'/> 
				 <col width='15%'/> 
				 <col width='15%'/> 
				 <col width='10%'/>  
				 </colgroup> 
				<tr class="header">
					<td><input type='checkbox' id='cbox_01'/><%=SystemEnv.getHtmlLabelName(556 ,user.getLanguage()) %></td>
					<td ><%=SystemEnv.getHtmlLabelName(31731 ,user.getLanguage())%></td>
					<td ><%=SystemEnv.getHtmlLabelName(21934 ,user.getLanguage())%></td>
					<%
					if("0".equals(w_type)){
					%>
					<td ><input type='checkbox'  onclick=checkAllBox(this,4)><%=SystemEnv.getHtmlLabelName(15603 ,user.getLanguage())%></td>
					<td ><%=SystemEnv.getHtmlLabelName(15486 ,user.getLanguage())%></td>
					<%}%>
					<td ><%=SystemEnv.getHtmlLabelName(31732 ,user.getLanguage())%></td>
					<td ><%=SystemEnv.getHtmlLabelName(21934 ,user.getLanguage())%></td>
					<td ><%=SystemEnv.getHtmlLabelName(453 ,user.getLanguage())%></td>
				</tr>
				
					
					
					<%
					//修改的时候进行change的操作，并且change后的服务配置了模板（需要初始化模板）
				 	if(("save".equals(opera)&&"1".equals(loadmb))||loadflag)
					{		
									List list = ServiceParamModeDisUtil.getParamsModeDisById(regservice, paramModeId, "import", false, "", "");
									if(list != null) {
									for(int i=0;i<list.size();i++) {
													ServiceParamModeDisBean spmdb = (ServiceParamModeDisBean)list.get(i);
													String input01="sap01_"+sap_inParameter;
													String input01Span="sap01_"+sap_inParameter+"Span";
													String input02="oa01_"+sap_inParameter;
													String input02Span="oa01_"+sap_inParameter+"Span";
													String input03="con01_"+sap_inParameter;
													String address="add01_"+sap_inParameter;
													String inputOA="OAshow01_"+sap_inParameter;
													
													//是否显示
													String  ishowField="ishowField01_"+sap_inParameter;
													//是否只读
													String isrdField="isrdField01_"+sap_inParameter;
													//排序字段
													String isorderby="isorderby01_"+sap_inParameter;
													
													String inputSAP="show01_"+sap_inParameter;
													String inputSAPSpan="show01_"+sap_inParameter+"Span";
													
													String inputSAPvalue=spmdb.getParamDesc();
													
													
													String ParamName=spmdb.getParamName();
													String ParamCons=spmdb.getParamCons();
													
													
													if("0".equals(w_type))
													{
													%>
														
														<tr class='DataDark'>
															<td><input type='checkbox' name='cbox1'/></td>
															<td><button type='button' class='e8_browflow' onclick=addOneFieldObjOA(this,0)></button><input type='hidden'  name='<%=input02%>'  value=''/> <span></span> <span id='<%=input02Span%>'></span><input type=hidden name='<%=address%>' value=''></td>
															
															<td><SPAN><INPUT name=<%=inputOA%> type=hidden value=''></SPAN></td>
															<td><INPUT name=<%=ishowField%> value=1 type=checkbox></td>
															<td><INPUT type="text" class=orderfield name=<%=isorderby%> value=0></td>
															<td><button type='button' class='e8_browflow' onclick=addOneFieldObj(1,this)></button><input type='hidden' name='<%=input01%>'  value='<%=ParamName%>'/> <span><%=ParamName%></span><span id='<%=input01Span%>'></span></td>
															<td><INPUT name='<%=inputSAP%>'  type=text  class='styled input' value='<%=inputSAPvalue%>' onchange=checkinput('<%=inputSAP%>','<%=inputSAPSpan%>') /><span id=<%=inputSAPSpan%>></span></td>
															<td><input type='text' name='<%=input03%>' value='<%=ParamCons%>' class='constantfiedl'></td>
															</tr>
													<%		
													}else
													{
													%>		
															<tr class='DataDark'>
															<td><input type='checkbox' name='cbox1'/></td>
															<td><button type='button' class='e8_browflow' onclick=addOneFieldObjOA(this,0)></button><input type='hidden'  name='<%=input02%>'  value=''/> <span></span> <span id='<%=input02Span%>'></span><input type=hidden name='<%=address%>' value=''></td>
															<td><SPAN><INPUT name=<%=inputOA%> type=hidden value=''></SPAN></td>
															<td><button type='button' class='e8_browflow' onclick=addOneFieldObj(1,this)></button><input type='hidden' name='<%=input01%>'  value='<%=ParamName%>'/> <span><%=ParamName%></span><span id='<%=input01Span%>'></span></td>
															<td><%=inputSAPvalue %><SPAN><INPUT name='<%=inputSAP %>'  type=hidden  value='<%=inputSAPvalue%>' ></SPAN></td>
															<td><input type='text' name='<%=input03 %>' value='<%=ParamCons %>' class='constantfiedl'></td>
															</tr>
													<%
													}
													
													sap_inParameter++;
								
													
													
								}
						}					
					}else  if("update".equals(opera)&&!"2".equals(updateChangeService))
					{
							//依据浏览按钮的id,查出该浏览按钮的输入参数
							sql="select * from sap_inParameter where baseid='"+baseid+"' order by id ";	
							RecordSet.execute(sql);
							while(RecordSet.next())
							{
								String input01="sap01_"+sap_inParameter;
								String inputSAP="show01_"+sap_inParameter;
								String inputSAPSpan="show01_"+sap_inParameter+"Span";
								String input01Span="sap01_"+sap_inParameter+"Span";
								String inputOA="OAshow01_"+sap_inParameter;
								String input02="oa01_"+sap_inParameter;
								String input02Span="oa01_"+sap_inParameter+"Span";
								String input03="con01_"+sap_inParameter;
								String address="add01_"+sap_inParameter;
								//是否显示
								String  ishowField="ishowField01_"+sap_inParameter;
								//是否只读
								String isrdField="isrdField01_"+sap_inParameter;
								//排序字段
								String isorderby="isorderby01_"+sap_inParameter;
								
								String ismainfield01=RecordSet.getString("ismainfield");
								String fromfieldid01=RecordSet.getString("fromfieldid");
								String inputOAvalue=RecordSet.getString("oadesc");
								String ishowFieldvalue=RecordSet.getString("isshow");
								String isrdonlyvalue=RecordSet.getString("isrdonly");		
								String isorderbyvalue=RecordSet.getString("orderfield");			
								String shownamevalue=RecordSet.getString("showname");			
								if("0".equals(w_type))
								{
										
										%>
										<tr class='DataDark'>
										<td><input type='checkbox' name='cbox1'/></td>
										<td><button type='button' class='e8_browflow' onclick=addOneFieldObjOA(this,0)></button><input type='hidden'  name='<%=input02%>'  value='<%=RecordSet.getString("oafield")%>'/> <span><%=RecordSet.getString("oafield")%></span> <span id='<%=input02Span%>'></span><input type=hidden name='<%=address%>' value='<%=ismainfield01%>_<%=fromfieldid01%>'></td>
										<td><%=inputOAvalue%><SPAN><INPUT name=<%=inputOA%> type=hidden value='<%=inputOAvalue%>'></SPAN></td>
										<%
										String checked = "";
										if("1".equals(ishowFieldvalue)){
											checked = "checked";
										}
										%>
										<td><INPUT name=<%=ishowField%> value=1 type=checkbox <%=checked %>></td>
									
										<td><INPUT type="text" name=<%=isorderby%> value='<%=isorderbyvalue%>' class='orderfield'></td>
										<td><button type='button' class='e8_browflow' onclick=addOneFieldObj(1,this)></button><input type='hidden' name='<%=input01%>'  value='<%=RecordSet.getString("sapfield")%>'/> <span><%=RecordSet.getString("sapfield")%></span><span id='<%=input01Span%>'></span></td>
										<td><INPUT name='<%=inputSAP%>'  type=text  value='<%=shownamevalue%>'  onchange=checkinput('<%=inputSAP%>','<%=inputSAPSpan%>')><SPAN id='<%=inputSAPSpan%>'></SPAN></td>
										<td><input type='text' name='<%=input03%>' value='<%=RecordSet.getString("constant")%>'  class='constantfiedl'></td>
										</tr>
								<%
								}else
								{
									 %>	
										<tr class='DataDark'>
										<td><input type='checkbox' name='cbox1'/></td>
										<td><button type='button' class='e8_browflow' onclick=addOneFieldObjOA(this,0)></button><input type='hidden'  name='<%=input02%>'  value='<%=RecordSet.getString("oafield")%>'/> <span><%=RecordSet.getString("oafield")%></span> <span id='<%=input02Span%>'></span><input type=hidden name='<%=address%>' value='<%=ismainfield01%>_<%=fromfieldid01%>'></td>
										<td><%=inputOAvalue%><SPAN><INPUT name=<%=inputOA%> type=hidden value='<%=inputOAvalue%>'></SPAN></td>
										<td><button type='button' class='e8_browflow' onclick=addOneFieldObj(1,this)></button><input type='hidden' name='<%=input01%>'  value='<%=RecordSet.getString("sapfield")%>'/> <span><%=RecordSet.getString("sapfield")%></span><span id='<%=input01Span%>'></span></td>
										<td><%=shownamevalue%><SPAN><INPUT name='<%=inputSAP%>'  type=hidden  value='<%=shownamevalue%>' ></SPAN></td>
										<td><input type='text' name='<%=input03%>' value='<%=RecordSet.getString("constant")%>' class='constantfiedl'></td>
										</tr>
										<%
								}
								
								sap_inParameter++;
						}	
					}
					 %>
					</TABLE>
					</div>
				</td>
			</tr>	 
			</table> 	
				</wea:item>
		          		</wea:group>
	     </wea:layout>					 	
									 	
									 	
									 	
									 	
								    <!-- 第一个tab页里面的内容table--end -->
								    
									<!-- 第二个tab页里面的内容-start -->
										
			<wea:layout type="2col" attributes="{layoutTableId:'sap_02layout';layoutTableDisplay:none}">
			  <wea:group context='<%=SystemEnv.getHtmlLabelName(28251 ,user.getLanguage()) %>' >
			    <wea:item attributes="{'colspan':'full','isTableList':'true'}">

					<TABLE width="200px" style="margin-top: -34px;margin-right: 26px;float: right;">
	            				<TR>
	            					<TD align=right>
	            							<input type="button" class="addbtnB" id='bath_02' accesskey="A" onclick="addBathFieldObj(2,1)" title="C-<%=SystemEnv.getHtmlLabelName(25055,user.getLanguage()) %>"> 								
											<input type="button" class="addbtn" id='add_02' accesskey="A" onclick="addBathFieldObj(2,2)" title="A-<%=SystemEnv.getHtmlLabelName(83476,user.getLanguage()) %>"> 
											<input type="button" class="delbtn"  id='del_02' accesskey="E" onclick="addBathFieldObj(2,3)" title="E-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage()) %>">
									<%
										String hidden02="";
										
										if(("save".equals(opera)&&"1".equals(loadmb))||loadflag){
											
											hidden02=spmsb.getImpstructcount()+"";//模板里面的输入结构的总数
										}else{
											hidden02=inteutil.getSapInAndOutParameterCount("2",baseid);
										}
										%>
										<input type='hidden' id='hidden02' name='hidden02' value='<%=hidden02 %>'>
	            					</TD>
	            				</TR>
	          		</TABLE>

					<!-- add by wshen-->
					<div id = "showScrollDiv" style ="border:0px solid #000;height:300px;width:100%;	overflow:auto;" >
			<TABLE class='ListStyle marginTop0  sapitem' cellspacing=1 id='sap_02' style='table-layout: fixed;'>
			 	<colgroup> <col width='120px'/>  <col width='*' /> </colgroup>										 
				
			
					<%
					if(("save".equals(opera)&&"1".equals(loadmb))||loadflag){
						List list = ServiceParamModeDisUtil.getParamsModeDisById(regservice, paramModeId, "import", true, "struct", "");
						if(list != null) {
							for(int i=0;i<list.size();i++) {
								ServiceParamModeDisBean spmdb = (ServiceParamModeDisBean)list.get(i);
								
								String ParamName=spmdb.getParamName();
								String ParamCons=spmdb.getParamCons();
								
								
								String newstru="stru_"+sap_inStructure;
								String newstruSpan="stru_"+sap_inStructure+"Span";
								String newname="cbox2_"+sap_inStructure;
								String bath="bath2_"+sap_inStructure;
								String newtable="sap_02"+"_"+sap_inStructure;//30609
								 %>
								<tr class='DataDark'><td class='tdcenter'><input type='checkbox' name='cbox2'></td>	
								<td>


								<TABLE class=ListStyle cellspacing=1 id='<%=newtable%>' >	
									<tr class='DatDrak'>
										<td colspan=9>
										<span style='float:left'>
											<%=SystemEnv.getHtmlLabelName(30609 ,user.getLanguage())%>
										    <button type='button' class='e8_browflow' onclick=addOneFieldObj(2,this,'<%=newstru%>')></button>
										    <input type='hidden' class='selectmax_width' name='<%=newstru%>' id='<%=newstru%>' value='<%=ParamName%>' >
											<span><%=ParamName%></span>&nbsp;&nbsp;&nbsp;&nbsp;<span id='<%=newstruSpan%>'></span>	
											<input type='hidden' id='<%=newname%>' name='<%=newname%>'  value='<%=ServiceParamModeDisUtil.getCompFieldCountByName(regservice, paramModeId, "import", ParamName) %>'>
										</span>
										<span style='float:right'>
											<input type='button'  class='addbtnB' id='<%=bath%>' onclick=addBathFieldObj(3,1,'<%=newstru%>','<%=sap_inStructure%>') title='<%=SystemEnv.getHtmlLabelName(25055 ,user.getLanguage())%>'> 
											<input type='button' class='addbtn' onclick=addBathFieldObj(3,2,'<%=newstru%>','<%=sap_inStructure%>') title='<%=SystemEnv.getHtmlLabelName(611 ,user.getLanguage())%>'>
											<input type='button' class='delbtn' onclick=addBathFieldObj(3,3,'<%=newstru%>','<%=sap_inStructure%>') title='<%=SystemEnv.getHtmlLabelName(23777 ,user.getLanguage())%>'>
										</span>
										</td>
									</tr>
								
									<tr class=header>
										<td >
										<input type='checkbox' onclick='checkbox2(this,<%=sap_inStructure %>)'/><%=SystemEnv.getHtmlLabelName(556 ,user.getLanguage()) %></td>
								    	<td><%=SystemEnv.getHtmlLabelName(31731 ,user.getLanguage()) %>
										</td>
										<td><%=SystemEnv.getHtmlLabelName(21934 ,user.getLanguage())%>
										</td>
										<%
										if("0".equals(w_type))
										{
											 %>
										<td>
											<input type='checkbox' onclick=checkAllBox(this,4,2)><%=SystemEnv.getHtmlLabelName(15603 ,user.getLanguage()) %>
										</td>
										<td><%=SystemEnv.getHtmlLabelName(15486 ,user.getLanguage()) %>
										</td>
										<%
										}
										%>
		
								
									 <td><%=SystemEnv.getHtmlLabelName(31732 ,user.getLanguage())%>"
									 </td>
									 <td><%=SystemEnv.getHtmlLabelName(21934 ,user.getLanguage())%>"
									 </td>
									 <td><%=SystemEnv.getHtmlLabelName(453 ,user.getLanguage())%>"
									 </td>
								</tr>
								<%
								int childstu=1;
								
								List listtemp = ServiceParamModeDisUtil.getParamsModeDisById(regservice, paramModeId, "import", false, "", ParamName);
								if(listtemp != null) {
									for(int j=0;j<listtemp.size();j++) {
										ServiceParamModeDisBean spmdbtemp = (ServiceParamModeDisBean)listtemp.get(j);
										//得到子表的对象
			 							String child01="sap02_"+sap_inStructure+"_"+childstu;
			 							String child02="oa02_"+sap_inStructure+"_"+childstu;
			 							String child03="con02_"+sap_inStructure+"_"+childstu;
			 							
			 							String child01Span="sap02_"+sap_inStructure+"_"+childstu+"Span";
			 							String child02Span="oa02_"+sap_inStructure+"_"+childstu+"Span";
			 							String address="add02_"+sap_inStructure+"_"+childstu;
			 							
		 								//是否显示
										String ishowField="ishowField02_"+sap_inStructure+"_"+childstu;
										//是否只读
										String isrdField="isrdField02_"+sap_inStructure+"_"+childstu;
										//排序字段
										String isorderby="isorderby02_"+sap_inStructure+"_"+childstu;
										String inputSAP="show02_"+sap_inStructure+"_"+childstu;
										String inputSAPSpan="show02_"+sap_inStructure+"_"+childstu+"Span";
										
										String inputOA="OAshow02_"+sap_inStructure+"_"+childstu;
										
		 								String ParamDBName=spmdbtemp.getParamName();
										String ParamDBCons=spmdbtemp.getParamCons();
										String inputSAPvalue=spmdbtemp.getParamDesc();
			 							
										//value='"+ismainfield02+"_"+fromfieldid02+"'
			 							if("0".equals(w_type))
										{
			 								 %>
				 							<tr class='DataDark'>
												<td><input type='checkbox' name='zibox'></td>
												<td><button type='button' class='e8_browflow' onclick=addOneFieldObjOA(this,0)></button><input type='hidden' name='<%=child02%>' value='' ><span></span><span id='<%=child02Span%>'></span><input type=hidden name='<%=address%>' value=''></td>
												<td><SPAN><INPUT name=<%=inputOA%> type=hidden></SPAN></td>
												<td><INPUT name=<%=ishowField%> value=1 type=checkbox></td>
												<td><INPUT type="text" class=orderfield name=<%=isorderby%> value=0></td>
												<td><button type='button' class='e8_browflow' onclick=addOneFieldObj(3,this,'<%=newstru%>')></button><input type='hidden' name='<%=child01%>' value='<%=ParamDBName%>'><span><%=ParamDBName%></span><span id='<%=child01Span%>'></span></td>
												<td><INPUT name=<%=inputSAP%> type=text value='<%=inputSAPvalue%>'  onchange=checkinput('<%=inputSAP%>','<%=inputSAPSpan%>')><SPAN  id='<%=inputSAPSpan%>'></SPAN></td>
												<td><input type='text' name='<%=child03%>' value='<%=ParamDBCons%>'  class='constantfiedl'></td>
											</tr>
										<%
										}else
										{
											 %>
											<tr class='DataDark'>
												<td><input type='checkbox' name='zibox'></td>
												<td><button type='button' class='e8_browflow' onclick=addOneFieldObjOA(this,0)></button><input type='hidden' name='<%=child02%>' value='' ><span></span><span id='<%=child02Span%>'></span><input type=hidden name='<%=address%>' value=''></td>
												<td><SPAN><INPUT name=<%=inputOA%> type=hidden></SPAN></td>
												<td><button type='button' class='e8_browflow' onclick=addOneFieldObj(3,this,'<%=newstru%>')></button><input type='hidden' name='<%=child01%>' value='<%=ParamDBName%>'><span><%=ParamDBName%></span><span id='<%=child01Span%>'></span></td>
										  		 <td><%=inputSAPvalue%><SPAN><INPUT name=<%=inputSAP%> type=hidden value='<%=inputSAPvalue%>'></SPAN></td>
												<td><input type='text' name='<%=child03%>' value='<%=ParamDBCons%>'  class='constantfiedl'></td>
											</tr>
											<%
										}
										childstu++;
									}
								}
								 %>
									</TABLE>	
								</td>
							</tr>
							<%	
								sap_inStructure++;
							}
						}
					
					
					
					}else if("update".equals(opera)&&!"2".equals(updateChangeService))
					{	
						
						sql=" select * from sap_complexname where comtype=3 and  baseid='"+baseid+"' ";
						RecordSet.execute(sql);
						while(RecordSet.next())
						{
							//查出有多少个结构
							String newstru="stru_"+sap_inStructure;
							String newstruSpan="stru_"+sap_inStructure+"Span";
							String newname="cbox2_"+sap_inStructure;
							String bath="bath2_"+sap_inStructure;
							String newtable="sap_02"+"_"+sap_inStructure;//30609
							%>
							
							<tr class='DataDark'>
								<td class='tdcenter'><input type='checkbox' name='cbox2'></td>	
								<td>
							
							
									<input type='hidden' id='<%=newname%>' name='<%=newname%>' value='<%=inteutil.getSapInAndOutParameterCount("1",baseid,RecordSet.getString("id"))%>'>
									<TABLE class=ListStyle cellspacing=1 id='<%=newtable%>' >	
							
										<tr class='DataDark'>
											<td  colspan='9'>
												<span style='float:left'>
												
													<%=SystemEnv.getHtmlLabelName(30609 ,user.getLanguage())%>
													<button type='button' class='e8_browflow' onclick=addOneFieldObj(2,this,'<%=newstru%>')></button>
													<input type='hidden' class='selectmax_width' name='<%=newstru%>' id='<%=newstru%>' value='<%=RecordSet.getString("name")%>' >
													<span><%=RecordSet.getString("name")%></span>&nbsp;&nbsp;&nbsp;&nbsp;<span id='<%=newstruSpan%>'></span>	
													
												</span>
												<span style='float:right'>
													
													<input type='button'  class='addbtnB' id='<%=bath%>' onclick=addBathFieldObj(3,1,'<%=newstru%>','<%=sap_inStructure%>') 
													 title='<%=SystemEnv.getHtmlLabelName(25055 ,user.getLanguage())%>'> 
													<input type='button' class='addbtn' onclick=addBathFieldObj(3,2,'<%=newstru%>','<%=sap_inStructure%>') 
													 title='<%=SystemEnv.getHtmlLabelName(611 ,user.getLanguage())%>'>
													<input type='button' class='delbtn' onclick=addBathFieldObj(3,3,'<%=newstru%>','<%=sap_inStructure%>') title='<%=SystemEnv.getHtmlLabelName(23777 ,user.getLanguage())%>'>
													
												</span>
											</td>
										</tr>

								
							
							<tr class=header>
								<td >
									<input type='checkbox' onclick='checkbox2(this,<%=sap_inStructure%>)'/><%=SystemEnv.getHtmlLabelName(556 ,user.getLanguage())%>
								</td>
							    <td>
							    	<%=SystemEnv.getHtmlLabelName(31731 ,user.getLanguage())%>
								</td>
								<td>
									<%=SystemEnv.getHtmlLabelName(21934 ,user.getLanguage())%>
								</td>
							<%
							if("0".equals(w_type))
							{
								 %>
								<td><input type='checkbox' onclick=checkAllBox(this,4,2)>
									<%=SystemEnv.getHtmlLabelName(15603 ,user.getLanguage()) %>
								</td>
								<td><%=SystemEnv.getHtmlLabelName(15486 ,user.getLanguage()) %>
								</td>
								<%
							}
							 %>
							
								<td><%=SystemEnv.getHtmlLabelName(31732 ,user.getLanguage()) %>
								</td>
								 <td><%=SystemEnv.getHtmlLabelName(21934 ,user.getLanguage()) %>
								</td>
								 <td><%=SystemEnv.getHtmlLabelName(453 ,user.getLanguage())%>
								</td>
						
							</tr>
							<%
							int childstu=1;
							//得到某一个结构的所有项
							sql=" select * from sap_inStructure  where baseid='"+baseid+"' and nameid='"+RecordSet.getString("id")+"' order by id";
							RecordSet02.execute(sql);
							while(RecordSet02.next())
							{
									//得到子表的对象
		 							String child01="sap02_"+sap_inStructure+"_"+childstu;
		 							String child02="oa02_"+sap_inStructure+"_"+childstu;
		 							String child03="con02_"+sap_inStructure+"_"+childstu;
		 							
		 							String child01Span="sap02_"+sap_inStructure+"_"+childstu+"Span";
		 							String child02Span="oa02_"+sap_inStructure+"_"+childstu+"Span";
		 							String address="add02_"+sap_inStructure+"_"+childstu;
		 							String sapfield=RecordSet02.getString("sapfield");
		 							String oafield=RecordSet02.getString("oafield");
		 							String convalue=RecordSet02.getString("constant");
		 							String ismainfield02=RecordSet02.getString("ismainfield");
									String fromfieldid02=RecordSet02.getString("fromfieldid");
									
									String  inputSAP="show02_"+sap_inStructure+"_"+childstu;
									String inputSAPSpan="show02_"+sap_inStructure+"_"+childstu+"Span";
									String inputOA="OAshow02_"+sap_inStructure+"_"+childstu;
									//是否显示
									String ishowField="ishowField02_"+sap_inStructure+"_"+childstu;
									//是否只读
									String isrdField="isrdField02_"+sap_inStructure+"_"+childstu;
									//排序字段
									String isorderby="isorderby02_"+sap_inStructure+"_"+childstu;
									
									String inputOAvalue=RecordSet02.getString("oadesc");
									String ishowFieldvalue=RecordSet02.getString("isshow");
									String isrdonlyvalue=RecordSet02.getString("isrdonly");		
									String isorderbyvalue=RecordSet02.getString("orderfield");			
									String shownamevalue=RecordSet02.getString("showname");		
								
									//value='"+ismainfield02+"_"+fromfieldid02+"'
		 							if("0".equals(w_type))
									{
		 								 %>
			 							<tr class='DataDark'>
											<td><input type='checkbox' name='zibox'></td>
										
											<td>
												<button type='button' class='e8_browflow' onclick=addOneFieldObjOA(this,0)></button>
												<input type='hidden' name='<%=child02%>' value='<%=oafield%>' ><span><%=oafield%></span>
												<span id='<%=child02Span%>'></span><input type=hidden name='<%=address%>' value='<%=ismainfield02%>_<%=fromfieldid02%>'>
											</td>
											<td>
												<%=inputOAvalue%>
												<SPAN><INPUT name=<%=inputOA%> type=hidden value='<%=inputOAvalue%>'></SPAN>
											</td>
											<%
											String checked = "";
											if("1".equals(ishowFieldvalue)){
												checked ="checked";
											}
											%>
											<%--<td><INPUT name="ishowField" value=1  type=checkbox <%=checked %>></td>--%>
											<td><INPUT name="<%=ishowField%>" value=1  type=checkbox <%=checked %>></td>

											<td><INPUT name=<%=isorderby%> value='<%=isorderbyvalue%>' type="text" class='orderfield'></td>
											
											 
											
											<td>
												<button type='button' class='e8_browflow' onclick=addOneFieldObj(3,this,'<%=newstru%>')></button>
												<input type='hidden' name='<%=child01%>' value='<%=sapfield%>'><span><%=sapfield%></span><span id='<%=child01Span%>'></span>
											</td>
											
											<td>
												<INPUT name='<%=inputSAP%>'  type=text  value='<%=shownamevalue%>'  onchange=checkinput('<%=inputSAP%>','<%=inputSAPSpan%>')><SPAN id='<%=inputSAPSpan%>'></SPAN>
											</td>
											
											<td>
												<input type='text' name='<%=child03%>' value='<%=convalue%>' class='constantfiedl'>
											</td>
									
										</tr>
										<%
									}else
									{
										 %>
										<tr class='DataDark'>
											<td><input type='checkbox' name='zibox'></td>
											<td><button type='button' class='e8_browflow' onclick=addOneFieldObjOA(this,0)></button><input type='hidden' name='<%=child02%>' value='<%=oafield%>' ><span><%=oafield%></span><span id='<%=child02Span%>'></span><input type=hidden name='<%=address%>' value='<%=ismainfield02%>_<%=fromfieldid02%>'></td>
											<td><%=inputOAvalue%><SPAN><INPUT name=<%=inputOA%> type=hidden value='<%=inputOAvalue%>'></SPAN></td>
											<td><button type='button' class='e8_browflow' onclick=addOneFieldObj(3,this,'<%=newstru%>')></button><input type='hidden' name='<%=child01%>' value='<%=sapfield%>'><span><%=sapfield%></span><span id='<%=child01Span%>'></span></td>
											 <td><%=shownamevalue%><SPAN><INPUT name='<%=inputSAP%>'  type=hidden  value='<%=shownamevalue%>' ></SPAN></td>
											<td><input type='text' name='<%=child03%>' value='<%=convalue%>' class='constantfiedl' ></td>
											
										</tr>
										<%
									}
									childstu++;
							}
							%>
							</TABLE>
						</td>
					</tr>
					<%	
							sap_inStructure++;
						}
					}
					 %>
			</TABLE>
						</div>
			</wea:item>
       		</wea:group>
       		</wea:layout>	
									<!-- 第二个tab页里面的内容--end -->
									<!-- 第三个tab页里面的内容-start -->
			<wea:layout type="2col" attributes="{layoutTableId:'sap_03layout';layoutTableDisplay:none}">
			  <wea:group context='<%=SystemEnv.getHtmlLabelName(28255 ,user.getLanguage()) %>' >
			    <wea:item attributes="{'colspan':'full','isTableList':'true'}">
					<TABLE width="200px" style="margin-top: -34px;margin-right: 26px;float: right;">
	            				<TR>
	            					<TD align=right>
	            							<input type="button" class="addbtnB" id='bath_03' accesskey="A" onclick="addBathFieldObj(4,1)" title="C-<%=SystemEnv.getHtmlLabelName(25055,user.getLanguage()) %>"> 								
											<input type="button" class="addbtn" id='add_03' accesskey="A" onclick="addBathFieldObj(4,2)" title="A-<%=SystemEnv.getHtmlLabelName(83476,user.getLanguage()) %>"> 
											<input type="button" class="delbtn"  id='del_03' accesskey="E" onclick="addBathFieldObj(4,3)" title="E-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage()) %>">
											<%
												String hidden03="";
											
											if(("save".equals(opera)&&"1".equals(loadmb))||loadflag){
												hidden03=spmsb.getExpstrcount()+"";//模板里面的输出参数的总数
											}else{
												hidden03=inteutil.getSapInAndOutParameterCount("3",baseid);
											}
											%>
											<input type='hidden' id='hidden03' name='hidden03' value='<%=hidden03 %>'>
	            					</TD>
	            				</TR>
	          		</TABLE>
			<!-- add by wshen-->
			<div id = "showScrollDiv" style ="border:0px solid #000;height:300px;width:100%;	overflow:auto;" >
			<TABLE class='ListStyle marginTop0  sapitem' cellspacing=1 id='sap_03' style='table-layout: fixed;'>
			 <colgroup> <col width='120px'/>  <col width='*' /> </colgroup>
				
			
			
			<tr >
			<td colspan='2'>
				 <TABLE class=ListStyle cellspacing=1 id='chind03'>
				 <tr class=header>
					 <td><input type='checkbox' id='cbox_03'/><%=SystemEnv.getHtmlLabelName(556 ,user.getLanguage())%></td>
					 <td ><%=SystemEnv.getHtmlLabelName(31732 ,user.getLanguage())%></td>
				 <%
				if("0".equals(w_type)){
					%>
					 <td ><%=SystemEnv.getHtmlLabelName(606 ,user.getLanguage())%></td>
					 <td ><input type='checkbox' onclick=checkAllBox(this,4)></input><%=SystemEnv.getHtmlLabelName(15603 ,user.getLanguage())%></td>
					<%
				}else{
					 %>
					 <td ><%=SystemEnv.getHtmlLabelName(21934 ,user.getLanguage())%></td>
					 <%
				}
				 %>
					 <td ><%=SystemEnv.getHtmlLabelName(31731 ,user.getLanguage())%></td>
					 <td ><%=SystemEnv.getHtmlLabelName(21934 ,user.getLanguage())%></td>
				
				
				 </tr>
				<%
					if(("save".equals(opera)&&"1".equals(loadmb))||loadflag){
						List list = ServiceParamModeDisUtil.getParamsModeDisById(regservice, paramModeId, "export", false, "", "");
				 	   if(list != null) {
								   for(int i=0;i<list.size();i++) {
								   		ServiceParamModeDisBean spmdb = (ServiceParamModeDisBean)list.get(i);
										String input01="sap03_"+sap_outParameter;
										String input01Span="sap03_"+sap_outParameter+"Span";
										String input04="setoa3_"+sap_outParameter;
										String address="add03_"+sap_outParameter;
										String input02="show03_"+sap_outParameter;//显示名--文本框
										String input02Span="show03_"+sap_outParameter+"Span";//显示名--img
										String input03="dis03_"+sap_outParameter;//是否显示
										String inputOA="OAshow03_"+sap_outParameter;
										String ParamName=spmdb.getParamName();
										String ParamDesc=spmdb.getParamDesc();
										
									
										//value='"+ismainfield03+"_"+fromfieldid03+"'	
										if("0".equals(w_type))
										{
											 %>
											 <tr class='DataDark'>
												<td><input type='checkbox' name='cbox3'/></td>
												
												<td><button type='button' class='e8_browflow' onclick=addOneFieldObj(4,this)></button><input type='hidden' name='<%=input01%>' id='<%=input01%>'  value='<%=ParamName%>' ><span><%=ParamName%></span><span id='<%=input01Span%>'></span></td>
												<td><input type='text' name='<%=input02%>' value='<%=ParamDesc%>' onchange=checkinput('<%=input02%>','<%=input02Span%>')><span id='<%=input02Span%>'></span></td>
												<td><input type='checkbox' name='<%=input03%>' value=1 ></td>
												<td><button type='button' class='e8_browflow' onclick=addOneFieldObjOA(this,0)></button><input type='hidden' name='<%=input04%>' value=''><span></span><span></span><input type=hidden name='<%=address%>' value=''></td>
												<td><SPAN><INPUT name=<%=inputOA%> type=hidden></SPAN></td>
											 </tr>
											<%
										}else
										{
											%>
											 <tr class='DataDark'>
												 <td><input type='checkbox' name='cbox3'/></td>
												 <td><button type='button' class='e8_browflow' onclick=addOneFieldObj(4,this)></button><input type='hidden' name='<%=input01%>' id='<%=input01%>'  value='<%=ParamName%>' ><span><%=ParamName%></span><span id='<%=input01Span%>'></span></td>
												 <td><%=ParamDesc%><SPAN><INPUT name=<%=input02%> type=hidden value='<%=ParamDesc%>'></SPAN></td>
												 <td><button type='button' class='e8_browflow' onclick=addOneFieldObjOA(this,0)></button><input type='hidden' name='<%=input04%>' value=''><span></span><span></span><input type=hidden name='<%=address%>' value=''	></td>
												 <td><SPAN><INPUT name=<%=inputOA%> type=hidden></SPAN></td>
											 </tr>
											<%
										}
										
										sap_outParameter++;
									}
					}
							
					}else  if("update".equals(opera)&&!"2".equals(updateChangeService))
					{
						sql=" select * from sap_outParameter  where baseid='"+baseid+"' order by id";
						RecordSet.execute(sql);
						while(RecordSet.next())
						{
							String sapfield=RecordSet.getString("sapfield");
		 					String oafield=RecordSet.getString("oafield");
							String input01="sap03_"+sap_outParameter;
							String input01Span="sap03_"+sap_outParameter+"Span";
							String input04="setoa3_"+sap_outParameter;
							String address="add03_"+sap_outParameter;
							String input02="show03_"+sap_outParameter;//显示名--文本框
							String input02Span="show03_"+sap_outParameter+"Span";//显示名--img
							String input03="dis03_"+sap_outParameter;//是否显示
							String Display=RecordSet.getString("Display");
							String showname=RecordSet.getString("showname");
							String ismainfield03=RecordSet.getString("ismainfield");
							String fromfieldid03=RecordSet.getString("fromfieldid");
							
							String inputOA="OAshow03_"+sap_outParameter;
							//是否只读
							String isrdField="isrdField03_"+sap_outParameter;
							//排序字段
							String isorderby="isorderby03_"+sap_outParameter;
						
								
							String inputOAvalue=RecordSet.getString("oadesc");
							String ishowFieldvalue=RecordSet.getString("isshow");
							String isrdonlyvalue=RecordSet.getString("isrdonly");		
							String isorderbyvalue=RecordSet.getString("orderfield");			
							String shownamevalue=RecordSet.getString("showname");		
										
							//value='"+ismainfield03+"_"+fromfieldid03+"'	
							if("0".equals(w_type))
							{
								 %>
								 <tr class='DataDark'>
								 <td><input type='checkbox' name='cbox3'/></td>
								 <td><button type='button' class='e8_browflow' onclick=addOneFieldObj(4,this)></button><input type='hidden' name='<%=input01%>' id='<%=input01%>'  value='<%=sapfield%>' ><span><%=sapfield%></span><span id='<%=input01Span%>'></span></td>
								 <td><input type='text' name='<%=input02%>' value='<%=showname%>' onchange=checkinput('<%=input02%>','<%=input02Span%>')><span id='<%=input02Span%>'></span></td>
								 <td>
								 <%
								 	String checked="";
									if("1".equals(Display)){
										checked = "checked";
									}
								%>
									<input type='checkbox' name='<%=input03%>' value=1 <%=checked %>>
								 </td>
								<td><button type='button' class='e8_browflow' onclick=addOneFieldObjOA(this,0)></button><input type='hidden' name='<%=input04%>' value='<%=oafield%>'><span><%=oafield%></span><span></span><input type=hidden name='<%=address%>' value='<%=ismainfield03%>_<%=fromfieldid03%>'></td>
								 <td><%=inputOAvalue%><SPAN><INPUT name=<%=inputOA%>  value='<%=inputOAvalue%>' type=hidden></SPAN></td>
								 </tr>
								<%
							}else
							{
								 %>
								 <tr class='DataDark'>
									 <td><input type='checkbox' name='cbox3'/></td>
									 <td><button type='button' class='e8_browflow' onclick=addOneFieldObj(4,this)></button><input type='hidden' name='<%=input01%>' id='<%=input01%>'  value='<%=sapfield%>' ><span><%=sapfield%></span><span id='<%=input01Span%>'></span></td>
									 <td><%=shownamevalue%><SPAN><INPUT name=<%=input02%> type=hidden value='<%=shownamevalue%>'></SPAN></td>
									 <td><button type='button' class='e8_browflow' onclick=addOneFieldObjOA(this,0)></button><input type='hidden' name='<%=input04%>' value='<%=oafield%>'><span><%=oafield%></span><span></span><input type=hidden name='<%=address%>' value='<%=ismainfield03%>_<%=fromfieldid03%>'	></td>
									
									 <td><%=inputOAvalue%><SPAN><INPUT name=<%=inputOA%> type=hidden value='<%=inputOAvalue%>'></SPAN></td>
								 </tr>
								<%
							}
							
							sap_outParameter++;
						}
					}
				 %>
				</TABLE>
			</td>
		</tr>
		</table>
		</div>
		</wea:item>
		</wea:group>
		</wea:layout>
									<!-- 第三个tab页里面的内容--end -->
									<!-- 第四个tab页里面的内容-start -->
			<wea:layout type="2col" attributes="{layoutTableId:'sap_04layout';layoutTableDisplay:none}">
			  <wea:group context='<%=SystemEnv.getHtmlLabelName(28256 ,user.getLanguage()) %>' >
			    <wea:item attributes="{'colspan':'full','isTableList':'true'}">
					<TABLE width="200px" style="margin-top: -34px;margin-right: 26px;float: right;">
	            				<TR>
	            					<TD align=right>
	            							<input type="button" class="addbtnB" id='bath_04' accesskey="A" onclick="addBathFieldObj(5,1)" title="C-<%=SystemEnv.getHtmlLabelName(25055,user.getLanguage()) %>"> 								
											<input type="button" class="addbtn" id='add_04' accesskey="A" onclick="addBathFieldObj(5,2)" title="A-<%=SystemEnv.getHtmlLabelName(83476,user.getLanguage()) %>"> 
											<input type="button" class="delbtn"  id='del_04' accesskey="E" onclick="addBathFieldObj(5,3)" title="E-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage()) %>">
											<%
												String hidden04value="";
											
											if(("save".equals(opera)&&"1".equals(loadmb))||loadflag){
												hidden04value=spmsb.getExpstructcount()+"";//模板里面的输出结构的总数
											}else{
												hidden04value = inteutil.getSapInAndOutParameterCount("4",baseid);
											}
											%>
											<input type='hidden' id='hidden04' name='hidden04' value='<%=hidden04value %>'>
											
	            					</TD>
	            				</TR>
	          		</TABLE>
			<!-- add by wshen-->
			<div id = "showScrollDiv" style ="border:0px solid #000;height:300px;width:100%;	overflow:auto;" >
			<TABLE class='ListStyle marginTop0  sapitem' cellspacing=1 id='sap_04' style='table-layout: fixed;'>
			 <colgroup> <col width='120px'/>  <col width='*' /> </colgroup>										 
			
			<%
				if(("save".equals(opera)&&"1".equals(loadmb))||loadflag){
							List list = ServiceParamModeDisUtil.getParamsModeDisById(regservice, paramModeId, "export", true, "struct", "");
							if(list != null) {
								for(int i=0;i<list.size();i++) {
									ServiceParamModeDisBean spmdb = (ServiceParamModeDisBean)list.get(i);
									
											String ParamName=spmdb.getParamName();
											String ParamDesc=spmdb.getParamDesc();
											String ParamCons=spmdb.getParamCons();
											int newchtable = ServiceParamModeDisUtil.getCompFieldCountByName(regservice, paramModeId ,"export",ParamName);
											String newstru04="outstru_"+sap_outStructure;
											String bath04="bath4_"+sap_outStructure;
											String newname04="cbox4_"+sap_outStructure;
											String newtable04="sap_04_"+sap_outStructure;
											String newstru04Span="sap_04_"+sap_outStructure+"Span";
											 %>	
											 <tr class='DataDark'><td class='tdcenter'><input type='checkbox' name='cbox4'></td>	
											 <td>
											
											 <TABLE class=ListStyle cellspacing=1 id='<%=newtable04%>'>	
												 <tr class='DataDark'>	
													 <td colspan=9>	
														
														 <span style='float:left'>	
															<%=SystemEnv.getHtmlLabelName(30609 ,user.getLanguage())%>
														<button type='button' class='e8_browflow' onclick=addOneFieldObj(5,this)></button>
														<input type='hidden' class='selectmax_width' id='<%=newstru04%>' name='<%=newstru04%>' value='<%=ParamName%>' >
														<span><%=ParamName%></span><span id='<%=newstru04Span%>'></span>&nbsp;&nbsp;&nbsp; 
														<input type='hidden' id='<%=newname04%>' name='<%=newname04%>' value='<%=newchtable%>'>
												
														</span>
														<span style='float:right'>	
												
															<input type='button'  class='addbtnB' id='<%=bath04%>' onclick=addBathFieldObj(6,1,'<%=newstru04%>','<%=sap_outStructure%>') 
															 title='<%=SystemEnv.getHtmlLabelName(25055 ,user.getLanguage())%>'>
															<input type='button' class='addbtn' onclick=addBathFieldObj(6,2,'<%=newstru04%>','<%=sap_outStructure%>')
															 title='<%=SystemEnv.getHtmlLabelName(611 ,user.getLanguage())%>'>
															<input type='button' class='delbtn' onclick=addBathFieldObj(6,3,'<%=newstru04%>','<%=sap_outStructure%>')
															 title='<%=SystemEnv.getHtmlLabelName(23777 ,user.getLanguage())%>'>
														 </span>	
													 </td>	
													</tr>	
											
													
											
											
													<tr class=header>
													<td><input type='checkbox' id='cbox_04' onclick='checkbox4(this,<%=sap_outStructure%>)'/>
													<%=SystemEnv.getHtmlLabelName(556 ,user.getLanguage())%></td>
													<td><%=SystemEnv.getHtmlLabelName(31732 ,user.getLanguage())%></td>
													<%
													if("0".equals(w_type))
													{
														%>
														
														<td><%=SystemEnv.getHtmlLabelName(606 ,user.getLanguage())%></td>
														<td><input type='checkbox' onclick=checkAllBox(this,4,2)><%=SystemEnv.getHtmlLabelName(15603 ,user.getLanguage())%></td>									<%
													}else{
														 %>
														<td><%=SystemEnv.getHtmlLabelName(21934 ,user.getLanguage())%></td>
														<%
													}
													 %>
													 
											
														<td><%=SystemEnv.getHtmlLabelName(31731 ,user.getLanguage())%></td>
														<td><%=SystemEnv.getHtmlLabelName(21934 ,user.getLanguage())%></td>
													</tr>
													<%
											int childstu=1;
											List listtemp = ServiceParamModeDisUtil.getParamsModeDisById(regservice, paramModeId, "export", false, "", ParamName);
											if(listtemp != null) {
												for(int j=0;j<listtemp.size();j++) {
													ServiceParamModeDisBean spmdbtemp = (ServiceParamModeDisBean)listtemp.get(j);
													String ParamDBName=spmdbtemp.getParamName();
													String ParamDBDesc=spmdbtemp.getParamDesc();
													String ParamDBCons=spmdbtemp.getParamCons();
													//得到子表的对象
						 							String child01="sap04_"+sap_outStructure+"_"+childstu;
						 							String address="add04_"+sap_outStructure+"_"+childstu;
			 										String child01Span="sap04_"+sap_outStructure+"_"+childstu+"Span";
						 							String child05="setoa4_"+sap_outStructure+"_"+childstu;
			 										String input02="show04_"+sap_outStructure+"_"+childstu;//显示名--文本框
													String input02Span="show04_"+sap_outStructure+"_"+childstu+"Span";//显示名--img
													String input03="dis04_"+sap_outStructure+"_"+childstu;//是否显示
													String inputOA="OAshow04_"+sap_outStructure+"_"+childstu;
													if("0".equals(w_type))
													{
														 %>
														 <tr class='DataDark'>
															 <td><input type='checkbox' name='zibox'></td>
															 <td><button type='button' class='e8_browflow' onclick=addOneFieldObj(6,this,'<%=newstru04%>')></button><input type='hidden' name='<%=child01%>' value='<%=ParamDBName%>'/><span><%=ParamDBName%></span><span id='<%=child01Span%>'></span></td>
															 <td><input type='text' name='<%=input02%>' value='<%=ParamDBDesc%>' onchange=checkinput('<%=input02%>','<%=input02Span%>')><span id='<%=input02Span%>'></span></td>
															 <td>
															 <input type='checkbox' name='<%=input03%>' value=1 >
															 </td>
															 <td><button type='button' class='e8_browflow' onclick=addOneFieldObjOA(this,0)></button><input type='hidden' name='<%=child05%>' value=''/><span></span><span></span><input type=hidden name='<%=address%>' value=''></td>
															 <td><SPAN><INPUT name=<%=inputOA%>  type=hidden></SPAN></td>
														 </tr>
													<%
													}else
													{
														 %>
														 <tr class='DataDark'>
															 <td><input type='checkbox' name='zibox'></td>
															 <td><button type='button' class='e8_browflow' onclick=addOneFieldObj(6,this,'<%=newstru04%>')></button><input type='hidden' name='<%=child01%>' value='<%=ParamDBName%>'/><span><%=ParamDBName%></span><span id='<%=child01Span%>'></span></td>
															 <td><%=ParamDBDesc%><SPAN><INPUT name=<%=input02%>  type=hidden value='<%=ParamDBDesc%>'></SPAN></td>
															 <td><button type='button' class='e8_browflow' onclick=addOneFieldObjOA(this,0)></button><input type='hidden' name='<%=child05%>' value=''/><span></span><span></span><input type=hidden name='<%=address%>' value=''></td>
															 <td><SPAN><INPUT name=<%=inputOA%>  type=hidden></SPAN></td>
														 </tr>
														<%
													}
													childstu++;
												}
										}
											 %>
											</TABLE>
										</td>
										</tr>
										<%
										sap_outStructure++;
								}
							}
				}else if("update".equals(opera)&&!"2".equals(updateChangeService))
				{	
					
					sql=" select * from sap_complexname where comtype=4 and   baseid='"+baseid+"' ";
					RecordSet.execute(sql);
					while(RecordSet.next())
					{
							
							String stuname=RecordSet.getString("name");
							String newstru04="outstru_"+sap_outStructure;
							String bath04="bath4_"+sap_outStructure;
							String newname04="cbox4_"+sap_outStructure;
							String newtable04="sap_04_"+sap_outStructure;
							String newstru04Span="sap_04_"+sap_outStructure+"Span";
							 %>
									<tr class='DataDark'>
										<td class='tdcenter'><input type='checkbox' name='cbox4'></td>	
										<td>
									
										
											 <TABLE class=ListStyle cellspacing=1 id='<%=newtable04 %>'>	
											
											
												<tr class='DataDark'>
												<td  colspan='8'>
													<span style='float:left'>
											
													<%=SystemEnv.getHtmlLabelName(30609 ,user.getLanguage())%>
														<button type='button' class='e8_browflow' onclick=addOneFieldObj(5,this)></button>
														<input type='hidden' class='selectmax_width' id='<%=newstru04%>' name='<%=newstru04%>' value='<%=stuname%>' >
														<span><%=stuname%></span><span id='<%=newstru04Span%>'></span>&nbsp;&nbsp;&nbsp; 
														<input type='hidden' id='<%=newname04%>' name='<%=newname04%>' value='<%=inteutil.getSapInAndOutParameterCount("2",baseid,RecordSet.getString("id"))%>'>
											
													</span>
													<span style='float:right'>
											
														<input type='button'  class='addbtnB' id='<%=bath04%>' onclick=addBathFieldObj(6,1,'<%=newstru04%>','<%=sap_outStructure%>') 
														 title='<%=SystemEnv.getHtmlLabelName(25055 ,user.getLanguage())%>'>
														<input type='button' class='addbtn' onclick=addBathFieldObj(6,2,'<%=newstru04%>','<%=sap_outStructure%>') 
														 title='<%=SystemEnv.getHtmlLabelName(611 ,user.getLanguage())%>'>
														<input type='button' class='delbtn' onclick=addBathFieldObj(6,3,'<%=newstru04%>','<%=sap_outStructure%>') 
														 title='<%=SystemEnv.getHtmlLabelName(23777 ,user.getLanguage())%>'>
													
													</span>
												</td>
											</tr>
											
											 <tr class=header>
												<td>
													<input type='checkbox' id='cbox_04' onclick='checkbox4(this,<%=sap_outStructure%>)'/>
													<%=SystemEnv.getHtmlLabelName(556 ,user.getLanguage())%>
												</td>
												<td>
													<%=SystemEnv.getHtmlLabelName(31732 ,user.getLanguage())%>
												</td>
											<%
											if("0".equals(w_type))
											{
												 %>
												<td><%=SystemEnv.getHtmlLabelName(606 ,user.getLanguage())%></td>
												<td><input type='checkbox' onclick=checkAllBox(this,4,2)><%=SystemEnv.getHtmlLabelName(15603 ,user.getLanguage())%></td>
												<%
											}else{
												 %>
												<td><%=SystemEnv.getHtmlLabelName(21934 ,user.getLanguage())%></td>
											<%
											}
											 %>
											
												<td><%=SystemEnv.getHtmlLabelName(31731 ,user.getLanguage()) %></td>
												<td><%=SystemEnv.getHtmlLabelName(21934 ,user.getLanguage()) %></td>
											
											</tr>
												<%
												int childstu=1;
												sql=" select * from sap_outStructure  where baseid='"+baseid+"' and nameid='"+RecordSet.getString("id")+"' order by id";
												RecordSet02.execute(sql);
												while(RecordSet02.next())
												{
													//得到子表的对象
						 							String child01="sap04_"+sap_outStructure+"_"+childstu;
						 							String address="add04_"+sap_outStructure+"_"+childstu;
			 										String child01Span="sap04_"+sap_outStructure+"_"+childstu+"Span";
						 							String child05="setoa4_"+sap_outStructure+"_"+childstu;
						 							String oafield=RecordSet02.getString("oafield");
			 										String sapfield=RecordSet02.getString("sapfield");
			 										String Display=RecordSet02.getString("Display");
			 										String input02="show04_"+sap_outStructure+"_"+childstu;//显示名--文本框
													String input02Span="show04_"+sap_outStructure+"_"+childstu+"Span";//显示名--img
													String input03="dis04_"+sap_outStructure+"_"+childstu;//是否显示
													String showname=RecordSet02.getString("showname");
													
													String ismainfield04=RecordSet02.getString("ismainfield");
													String fromfieldid04=RecordSet02.getString("fromfieldid");
													
													
													String inputOA="OAshow04_"+sap_outStructure+"_"+childstu;
													//是否只读
													String isrdField="isrdField04_"+sap_outStructure+"_"+childstu;
													//排序字段
													String isorderby="isorderby04_"+sap_outStructure+"_"+childstu;
														
													String inputOAvalue=RecordSet02.getString("oadesc");
													String ishowFieldvalue=RecordSet02.getString("isshow");
													String isrdonlyvalue=RecordSet02.getString("isrdonly");		
													String isorderbyvalue=RecordSet02.getString("orderfield");			
													String shownamevalue=RecordSet02.getString("showname");		
										
													
													if("0".equals(w_type))
													{
														 %>
														 <tr class='DataDark'>
															 <td><input type='checkbox' name='zibox'></td>
															 <td><button type='button' class='e8_browflow' onclick=addOneFieldObj(6,this,'<%=newstru04%>')></button>
															 <input type='hidden' name='<%=child01%>' value='<%=sapfield%>'/><span><%=sapfield%></span><span id='<%=child01Span%>'></span>
															 </td>
															 <td><input type='text' name='<%=input02%>' value='<%=showname%>' onchange=checkinput('<%=input02%>','<%=input02Span%>')><span id='<%=input02Span%>'></span></td>
															 <td>
																 <%
																 String checked="";
																if("1".equals(Display)){
																	checked = "checked";
																}
															 	%>
															 <input type='checkbox' name='<%= input03%>' value=1 <%=checked %>>
															 </td>
															 <td><button type='button' class='e8_browflow' onclick=addOneFieldObjOA(this,0)></button><input type='hidden' name='<%=child05%>' value='<%=oafield%>'/><span><%=oafield%></span><span></span><input type=hidden name='<%=address%>' value='<%=ismainfield04%>_<%=fromfieldid04%>'></td>
															 <td><%=inputOAvalue%><SPAN><INPUT name=<%=inputOA%>  value='<%=inputOAvalue%>' type=hidden></SPAN></td>
														
														 </tr>
														<%
													}else
													{
														 %>
														 <tr class='DataDark'>
														 <td><input type='checkbox' name='zibox'></td>
														 <td><button type='button' class='e8_browflow' onclick=addOneFieldObj(6,this,'<%=newstru04%>')></button><input type='hidden' name='<%=child01%>' value='<%=sapfield%>'/><span><%=sapfield%></span><span id='<%=child01Span%>'></span></td>
														 <td><%=showname%><SPAN><INPUT name=<%=input02%>  value='<%=showname%>' type=hidden></SPAN></td>
														 <td><button type='button' class='e8_browflow' onclick=addOneFieldObjOA(this,0)></button><input type='hidden' name='<%=child05%>' value='<%=oafield%>'/><span><%=oafield%></span><span></span><input type=hidden name='<%=address%>' value='<%=ismainfield04%>_<%=fromfieldid04%>'></td>
														 <td><%=inputOAvalue%><SPAN><INPUT name=<%=inputOA%>  value='<%=inputOAvalue%>' type=hidden></SPAN></td>
														
														 </tr>
														<%
													}
													childstu++;
												}
												 %>
											</TABLE>	
											
										</td>
								</tr>
							<%
							sap_outStructure++;
					}	
			}					
			 %>
			</TABLE>
			</div>
			</wea:item>
			</wea:group>
			</wea:layout>
									<!-- 第四个tab页里面的内容--end -->
									<!-- 第五个tab页里面的内容-start -->
			<wea:layout type="2col" attributes="{layoutTableId:'sap_05layout';layoutTableDisplay:none}">
			  <wea:group context='<%=SystemEnv.getHtmlLabelName(28260 ,user.getLanguage()) %>' >
			    <wea:item attributes="{'colspan':'full','isTableList':'true'}">
					<TABLE width="200px" style="margin-top: -34px;margin-right: 26px;float: right;">
	            				<TR>
	            					<TD align=right>
	            							<input type="button" class="addbtnB" id='bath_05' accesskey="A" onclick="addBathFieldObj(7,1)" title="C-<%=SystemEnv.getHtmlLabelName(25055,user.getLanguage()) %>"> 								
											<input type="button" class="addbtn" id='add_05' accesskey="A" onclick="addBathFieldObj(7,2)" title="A-<%=SystemEnv.getHtmlLabelName(83476,user.getLanguage()) %>"> 
											<input type="button" class="delbtn"  id='del_05' accesskey="E" onclick="addBathFieldObj(7,3)" title="E-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage()) %>">
											<%
											 String hidden05value = "";
											if(("save".equals(opera)&&"1".equals(loadmb))||loadflag){
												hidden05value = spmsb.getExptablecount()+"";//模板里面的输出表的总数
											}else{
												hidden05value = inteutil.getSapInAndOutParameterCount("5",baseid);
											}
											 %>
											  <input type='hidden' id='hidden05' name='hidden05' value='<%=hidden05value %>'>
	            					</TD>
	            				</TR>
	          		</TABLE>
			<!-- add by wshen-->
			<div id = "showScrollDiv" style ="border:0px solid #000;height:300px;width:100%;	overflow:auto;" >
			<TABLE class='ListStyle marginTop0  sapitem' cellspacing=1 id='sap_05' style='table-layout: fixed;'>
			 <colgroup> <col width='120px'/>  <col width='*' /> </colgroup>										 
			
			<%
			if(("save".equals(opera)&&"1".equals(loadmb))||loadflag){
				List list = ServiceParamModeDisUtil.getParamsModeDisById(regservice, paramModeId, "export", true, "table", "");
				if(list != null) {
					for(int i=0;i<list.size();i++) {
						ServiceParamModeDisBean spmdb = (ServiceParamModeDisBean)list.get(i);
						
						String ParamName=spmdb.getParamName();
						String ParamDesc=spmdb.getParamDesc();
						String ParamCons=spmdb.getParamCons();
						
						int newchtable = ServiceParamModeDisUtil.getCompFieldCountByName(regservice, paramModeId, "export",ParamName);
											
						String newstru05="outtable_"+sap_outTable;
						String newstru05Span="outtable_"+sap_outTable+"Span";
						String bath05="bath5_"+sap_outTable;
						String newname05="cbox5_"+sap_outTable;
						String newtable05="sap_05_"+sap_outTable;
						String newtable05son="sapson_05_"+sap_outTable;//where条件所在的表格
						String newtable05soncount="sapson_05count_"+sap_outTable;//where条件总行数
						String backtable="backtable5_"+sap_outTable;	//回写表
						String backoper="backoper5_"+sap_outTable;	//回写操作
						 %>
						 
						<tr class='DataDark'><td class='tdcenter'><input type='checkbox' name='cbox5'></td>
						<td> 
						
						
						 <TABLE class=ListStyle cellspacing=1 id='<%=newtable05%>'>
						 <tr class='DataDark'>
						 <td colspan=9>
						 <span style='float:left'>
							<%=SystemEnv.getHtmlLabelName(21900 ,user.getLanguage())%><button type='button' class='e8_browflow' onclick=addOneFieldObj(7,this)></button><input type='hidden' class='selectmax_width' id='<%=newstru05%>' name='<%=newstru05%>' value='<%=ParamName%>'><span><%=ParamName%></span><span id='<%=newstru05Span%>'></span>  
						<%
						if("1".equals(w_type)||"2".equals(w_type))
						{
							 %>
							<%=SystemEnv.getHtmlLabelName(30612 ,user.getLanguage())%><button type='button' class='e8_browflow' onclick=backtable(this)></button> 
							<input type='hidden' name='<%=backtable%>' id='<%=backtable%>'  value=''><span></span><span><img src='/images/BacoError_wev8.gif' align=absMiddle></span> 
							 <%=SystemEnv.getHtmlLabelName(30613 ,user.getLanguage())%><select name='<%=backoper%>' id='<%=backoper%>'>
							<option value=0><%=SystemEnv.getHtmlLabelName(30614 ,user.getLanguage())%></option> 
							<option value=1><%=SystemEnv.getHtmlLabelName(30615 ,user.getLanguage())%></option>
							<%
							if("1".equals(w_type)){
								 %>
								<option value=2><%=SystemEnv.getHtmlLabelName(103 ,user.getLanguage())%></option>
							<option value=3><%=SystemEnv.getHtmlLabelName(23777 ,user.getLanguage())%></option> 
							<%
							}
							 %>
							</select> 
						<%
						}
						 %>
						
							 <input type='hidden' id='<%=newname05%>' name='<%=newname05%>' value='<%=newchtable%>'>
							 </span>
							 <span style='float:right'>
							
							<input type='button'  class='addbtnB' id='<%=bath05%>' onclick=addBathFieldObj(8,1,'<%=newstru05%>','<%=sap_outTable%>','<%=backtable%>') 
							 title='<%=SystemEnv.getHtmlLabelName(25055 ,user.getLanguage())%>'> 
							<input type='button' class='addbtn' onclick=addBathFieldObj(8,2,'<%=newstru05%>','<%=sap_outTable%>','<%=backtable%>') 
							 title='<%=SystemEnv.getHtmlLabelName(611 ,user.getLanguage())%>'>
							<input type='button' class='delbtn' onclick=addBathFieldObj(8,3,'<%=newstru05%>','<%=sap_outTable%>') 
							 title='<%=SystemEnv.getHtmlLabelName(23777 ,user.getLanguage())%>'>
							
							 </span>
						 </td>
						 </tr>
						
						
					
						<tr class=header>
						<td>
						<input type='checkbox' onclick='checkbox5(this,<%=sap_outTable%>)'/><%=SystemEnv.getHtmlLabelName(556 ,user.getLanguage())%></td>
						<td><%=SystemEnv.getHtmlLabelName(31732 ,user.getLanguage())%>
						</td>
						<td><%=SystemEnv.getHtmlLabelName(606 ,user.getLanguage())%>
						</td>
						<%
						if("0".equals(w_type))
						{
							 %>
								<td><%=SystemEnv.getHtmlLabelName(338 ,user.getLanguage())%>
								</td>
								<td> <input type='checkbox' onclick=checkAllBox(this,5,2)><%=SystemEnv.getHtmlLabelName(15603 ,user.getLanguage())%>
								</td>
								<td> <input type='checkbox' onclick=checkAllBox(this,6,2)><%=SystemEnv.getHtmlLabelName(31733 ,user.getLanguage())%>
								</td>
								<td> <input type='checkbox' onclick=checkAllBox(this,7,2)><%=SystemEnv.getHtmlLabelName(20331 ,user.getLanguage())%>
								</td>
								<%
						}
						 %>
						
						<td><%=SystemEnv.getHtmlLabelName(31731 ,user.getLanguage())%>
						</td>
						<td><%=SystemEnv.getHtmlLabelName(21934 ,user.getLanguage())%>
						</td>
						</tr>
						
						<%		
						int childstu=1;
							
						
						List listtemp = ServiceParamModeDisUtil.getParamsModeDisById(regservice, paramModeId, "export", false, "", ParamName);
						if(listtemp != null) {
							for(int j=0;j<listtemp.size();j++) {
								ServiceParamModeDisBean spmdbtemp = (ServiceParamModeDisBean)listtemp.get(j);
								
								
								String ParamDBName=spmdbtemp.getParamName();
								String ParamDBDesc=spmdbtemp.getParamDesc();
								String ParamDBCons=spmdbtemp.getParamCons();
													
								String input01="sap05_"+sap_outTable+"_"+childstu;
								String input02="show05_"+sap_outTable+"_"+childstu;//显示名--文本框
								String input02Span="show05_"+sap_outTable+"_"+childstu+"Span";//显示名--img
								String input03="dis05_"+sap_outTable+"_"+childstu;//是否显示
								String input04="sea05_"+sap_outTable+"_"+childstu;
								String input05="key05_"+sap_outTable+"_"+childstu;
								String input06="setoa5_"+sap_outTable+"_"+childstu;
								String address="add05_"+sap_outTable+"_"+childstu;
								String input01Span="sap05_"+sap_outTable+"_"+childstu+"Span";
								String inputOA="OAshow05_"+sap_outTable+"_"+childstu;
								//是否只读
								String isrdField="isrdField05_"+sap_outTable+"_"+childstu;
								//排序字段
								String isorderby="isorderby05_"+sap_outTable+"_"+childstu;
								if("0".equals(w_type))
								{
									 %>
									<tr class='DataDark'>
									<td><input type='checkbox' name='zibox'></td>
									<td><button type='button' class='e8_browflow' onclick=addOneFieldObj(8,this,'<%=newstru05%>')></button><input type='hidden' name='<%=input01%>' value='<%=ParamDBName%>' ><span><%=ParamDBName%></span><span id='<%=input01Span%>'></span></td>
									
									<td><input type='text' name='<%=input02%>' value='<%=ParamDBDesc%>' onchange=checkinput('<%=input02%>','<%=input02Span%>')><span id='<%=input02Span%>'></span></td>
									
										<td><INPUT type="text" class=orderfield name=<%=isorderby%> value=0></td>
										 <td>
										 <input type='checkbox' name='<%=input03%>' value=1 >
										 </td>
											 <td>
										<input type='checkbox' name='<%=input05%>' value=1 >
										 </td>
										
										 <td>
										<input type='checkbox' name='<%=input04%>' value=1 >
										 </td>
										
										 <td><button type='button' class='e8_browflow' onclick=addOneFieldObjOA(this,0)></button><input type='hidden' name='<%=input06%>' value=''/><span></span><span></span><input type=hidden name='<%=address%>' value=''></td>
										 <td><SPAN><INPUT name=<%=inputOA%> type=hidden></SPAN></td>
									</tr>
									<%
								}else
								{ %>
									<tr class='DataDark'>
									<td><input type='checkbox' name='zibox'></td>
								
									<td><button type='button' class='e8_browflow' onclick=addOneFieldObj(8,this,'<%=newstru05%>')></button><input type='hidden' name='<%=input01%>' value='<%=ParamDBName%>' ><span><%=ParamDBName%></span><span id='<%=input01Span%>'></span></td>
									 <td><%=ParamDBDesc%><SPAN><INPUT name=<%=input02%> type=hidden value='<%=ParamDBDesc%>'></SPAN></td>
									<td><button type='button' class='e8_browflow' onclick=addOneFieldObjOA(this,'0','<%=backtable%>')></button><input type='hidden' name='<%=input06%>' value=''/><span></span><span><img src='/images/BacoError_wev8.gif' align=absMiddle></span><input type=hidden name='<%=address%>' value=''	></td>
									 <td><SPAN><INPUT name=<%=inputOA%> type=hidden></SPAN></td>
									</tr>
									<%
								}
								childstu++;
							}
						}
						 %>
						
						</TABLE>
						<%
						if("1".equals(w_type)||"2".equals(w_type))
						{ %>
							 <TABLE class=ListStyle cellspacing=1 id='<%=newtable05son%>'>
							 <tr class='DataDark'>
									 <td colspan=7>
									 <span style='float:left'>
										<%=SystemEnv.getHtmlLabelName(30616 ,user.getLanguage())%>
									 </span>
									 <span style='float:right'>
									 <input type='button'  class='addbtnB' onclick=addBathFieldObj(12,1,'<%=newstru05%>','<%=sap_outTable%>','<%=backtable%>') title='<%=SystemEnv.getHtmlLabelName(25055 ,user.getLanguage())%>'>
									  <input type='button' class='addbtn' onclick=addBathFieldObj(12,2,'<%=newstru05%>','<%=sap_outTable%>','<%=backtable%>') title='<%=SystemEnv.getHtmlLabelName(611 ,user.getLanguage())%>'>
									  <input type='button' class='delbtn' onclick=addBathFieldObj(12,3,'<%=newstru05%>','<%=sap_outTable%>') title='<%=SystemEnv.getHtmlLabelName(23777 ,user.getLanguage())%>'>
									  <input type='hidden' name='<%=newtable05soncount%>' id='<%=newtable05soncount%>' value='0'>
									 </span>
									 </td>
							 </tr>
							 <tr class=header>
									 <td>
									 <input type='checkbox' onclick=checkbox5son(this,<%=sap_outTable%>)><%=SystemEnv.getHtmlLabelName(556 ,user.getLanguage())%>
									 </td>
									 <td>
									 <%=SystemEnv.getHtmlLabelName(30617 ,user.getLanguage())%>
									 </td>
									 <td>
									<%=SystemEnv.getHtmlLabelName(21934 ,user.getLanguage())%>
									 </td>
									 <td>
									 <%=SystemEnv.getHtmlLabelName(30618 ,user.getLanguage())%>
									 </td>
									 <td>
									<%=SystemEnv.getHtmlLabelName(21934 ,user.getLanguage())%>
									 </td>
									 <td>
									 <%=SystemEnv.getHtmlLabelName(30619 ,user.getLanguage())%>
									 </td>
							 </tr>
							 </TABLE>
							<%
						}
						 %>
						</td></tr>
						<%
					    sap_outTable++;
					    
					}
				}
				
			 }else if("update".equals(opera)&&!"2".equals(updateChangeService))
			{
				 
					//查出所有的输出表
					sql=" select * from sap_complexname where comtype=2 and  baseid='"+baseid+"'  ";
					RecordSet.execute(sql);
					while(RecordSet.next())
					{		
							String newstru05="outtable_"+sap_outTable;
							String newstru05Span="outtable_"+sap_outTable+"Span";
							String bath05="bath5_"+sap_outTable;
							String newname05="cbox5_"+sap_outTable;
							String newtable05="sap_05_"+sap_outTable;
							String newtable05son="sapson_05_"+sap_outTable;//where条件所在的表格
							String newtable05soncount="sapson_05count_"+sap_outTable;//where条件总行数
							String backtable="backtable5_"+sap_outTable;	//回写表
							String backoper="backoper5_"+sap_outTable;	//回写操作
							String name=RecordSet.getString("name");
							String comid=RecordSet.getString("id");
							
							String backtablename=RecordSet.getString("backtable");
							String backoperate=RecordSet.getString("backoper");
							 %>
							<tr class='DataDark'>
								<td class='tdcenter'><input type='checkbox' name='cbox5'></td>
								<td> 
								
								 <TABLE class=ListStyle cellspacing=1 id='<%=newtable05%>'>
								 <tr class='DataDark'>
								 <td colspan=9>
								 <span  style='float:left'>
								 
							<%=SystemEnv.getHtmlLabelName(21900 ,user.getLanguage())%><button type='button' class='e8_browflow' onclick=addOneFieldObj(7,this)></button><input type='hidden' class='selectmax_width' id='<%=newstru05%>' name='<%=newstru05%>' value='<%=name%>'><span><%=name%></span><span id='<%=newstru05Span%>'></span>  
							<%
							if("1".equals(w_type)||"2".equals(w_type))
							{ %>
							
								<%=SystemEnv.getHtmlLabelName(30612 ,user.getLanguage())%><button type='button' class='e8_browflow' onclick=backtable(this)></button> 
								<input type='hidden' name='<%=backtable%>' id='<%=backtable%>'  value='<%=backtablename%>'><span><%=backtablename%></span><span></span> 
							
								 <%=SystemEnv.getHtmlLabelName(30613 ,user.getLanguage())%><select name='<%=backoper%>' id='<%=backoper%>'>
								<option value=0><%=SystemEnv.getHtmlLabelName(30614 ,user.getLanguage())%></option> 
								<%
								if("1".equals(backoperate))
								{ %>
									
									<option value=1 selected='selected'><%=SystemEnv.getHtmlLabelName(30615 ,user.getLanguage())%></option>
								<%
								}else
								{
									 %>
									<option value=1><%=SystemEnv.getHtmlLabelName(30615 ,user.getLanguage())%></option>
								<%
								}
								 
								if("1".equals(w_type)){
									if("2".equals(backoperate)){
										%>
										<option value=2 selected='selected'><%=SystemEnv.getHtmlLabelName(103 ,user.getLanguage())%></option>
									<%
									}else{
										 %>
										<option value=2><%=SystemEnv.getHtmlLabelName(103 ,user.getLanguage())%></option>
									<%
									}
									if("3".equals(backoperate)){
										 %>
										<option value=3 selected='selected'><%=SystemEnv.getHtmlLabelName(23777 ,user.getLanguage())%></option> 
									<%
									}else{
										 %>
										<option value=3><%=SystemEnv.getHtmlLabelName(23777 ,user.getLanguage())%></option> 
									<%
									}
								}
								 %>
								</select> 
							<%
							}
							%>
							 <input type='hidden' id='<%=newname05%>' name='<%=newname05%>' value='<%=inteutil.getSapInAndOutParameterCount("3",baseid,RecordSet.getString("id"))%>'>
							 </span>
							
							 <span style='float:right' >
							
							<input type='button'  class='addbtnB' id='<%=bath05%>' onclick=addBathFieldObj(8,1,'<%=newstru05%>','<%=sap_outTable%>','<%=backtable%>') 
							 title='<%=SystemEnv.getHtmlLabelName(25055 ,user.getLanguage())%>'> 
							<input type='button' class='addbtn' onclick=addBathFieldObj(8,2,'<%=newstru05%>','<%=sap_outTable%>','<%=backtable%>') 
							 title='<%=SystemEnv.getHtmlLabelName(611 ,user.getLanguage())%>'>
							<input type='button' class='delbtn' onclick=addBathFieldObj(8,3,'<%=newstru05%>','<%=sap_outTable%>') 
							 title='<%=SystemEnv.getHtmlLabelName(23777 ,user.getLanguage())%>'>
							 </span>
							
							
							
							 </td>
							 </tr>
							
							
							<tr class=header>
									<td>
									<input type='checkbox' onclick='checkbox5(this,<%=sap_outTable%>)'/><%=SystemEnv.getHtmlLabelName(556 ,user.getLanguage())%></td>
									<td><%=SystemEnv.getHtmlLabelName(31732 ,user.getLanguage())%>
									</td>
									<td><%=SystemEnv.getHtmlLabelName(606 ,user.getLanguage())%>
									</td>
									<%
									if("0".equals(w_type))
									{ %>
											<td><%=SystemEnv.getHtmlLabelName(338 ,user.getLanguage())%>
											</td>
											<td> <input type='checkbox' onclick=checkAllBox(this,5,2)><%=SystemEnv.getHtmlLabelName(15603 ,user.getLanguage())%>
											</td>
											<td> <input type='checkbox' onclick=checkAllBox(this,6,2)><%=SystemEnv.getHtmlLabelName(31733 ,user.getLanguage())%>
											</td>
											<td> <input type='checkbox' onclick=checkAllBox(this,7,2)><%=SystemEnv.getHtmlLabelName(20331 ,user.getLanguage())%>
											</td>
									<%
									}
									 %>
									<td><%=SystemEnv.getHtmlLabelName(31731 ,user.getLanguage())%>
									</td>
									<td><%=SystemEnv.getHtmlLabelName(21934 ,user.getLanguage())%>
									</td>
							</tr>
							
							<TD  style='padding:0px' colspan='9'>
							</TD>
							</TR>
								<%	
								int childstu=1;
								sql=" select * from sap_outTable  where baseid='"+baseid+"' and nameid='"+RecordSet.getString("id")+"' order by id";
								
							
								RecordSet02.execute(sql);
								while(RecordSet02.next())
								{
									
									String input01="sap05_"+sap_outTable+"_"+childstu;
									String input02="show05_"+sap_outTable+"_"+childstu;//显示名--文本框
									String input02Span="show05_"+sap_outTable+"_"+childstu+"Span";//显示名--img
									String input03="dis05_"+sap_outTable+"_"+childstu;//是否显示
									String input04="sea05_"+sap_outTable+"_"+childstu;
									String input05="key05_"+sap_outTable+"_"+childstu;
									String input06="setoa5_"+sap_outTable+"_"+childstu;
									String address="add05_"+sap_outTable+"_"+childstu;
									String sapfield=RecordSet02.getString("sapfield");
									String showname=RecordSet02.getString("showname");
									String Display=RecordSet02.getString("Display");
									String Search=RecordSet02.getString("Search");
									String Primarykey=RecordSet02.getString("Primarykey");
									String oafield=RecordSet02.getString("oafield");
									String input01Span="sap05_"+sap_outTable+"_"+childstu+"Span";
									String ismainfield05=RecordSet02.getString("ismainfield");
									String fromfieldid05=RecordSet02.getString("fromfieldid");
									
									String inputOA="OAshow05_"+sap_outTable+"_"+childstu;
									//是否只读
									String isrdField="isrdField05_"+sap_outTable+"_"+childstu;
									//排序字段
									String isorderby="isorderby05_"+sap_outTable+"_"+childstu;
										
									String inputOAvalue=RecordSet02.getString("oadesc");
									String ishowFieldvalue=RecordSet02.getString("isshow");
									String isrdonlyvalue=RecordSet02.getString("isrdonly");		
									String isorderbyvalue=RecordSet02.getString("orderfield");			
									String shownamevalue=RecordSet02.getString("showname");		
														
									//value='"+ismainfield05+"_"+fromfieldid05+"'	
									if("0".equals(w_type))
									{
										 %>
										<tr class='DataDark'>
										<td><input type='checkbox' name='zibox'></td>
										<td><button type='button' class='e8_browflow' onclick=addOneFieldObj(8,this,'<%=newstru05%>')></button><input type='hidden' name='<%=input01%>' value='<%=sapfield%>' ><span><%=sapfield%></span><span id='<%=input01Span%>'></span></td>
										<td><input type='text' name='<%=input02%>' value='<%=showname%>' onchange=checkinput('<%=input02%>','<%=input02Span%>')><span id='<%=input02Span%>'></span></td>
										
										<td><INPUT type="text" class=orderfield name=<%=isorderby%> value='<%=isorderbyvalue%>'></td>
										<td>
										<% 
											if("1".equals(Display)){
												%>
												<input type='checkbox' name='<%=input03%>' value=1 checked='checked'>
												<%
											}else{
												 %>
												<input type='checkbox' name='<%=input03%>' value=1 >
											<%
											}
											%>
										</td>
									
										
										
										 <td>
										 <%
										 	String checked="";
									
											if("1".equals(Primarykey)){
												checked = "checked";
												
											}
											 %>
											 <input type='checkbox' name='<%=input05%>' value=1 <%=checked %>>
										 </td>
										
										
										 <td>
										 <%
										 
											checked = "";
											if("1".equals(Search)){
											
												checked = "checked";
												
											}
										 %>
										<input type='checkbox' name='<%=input04 %>' value=1 <%=checked %>>
										</td>
										
										
										 <td><button type='button' class='e8_browflow' onclick=addOneFieldObjOA(this,0)></button>
										<input type='hidden' name='<%=input06%>' value='<%=oafield%>'/><span><%=oafield%></span><span></span>
										<input type=hidden name='<%=address%>' value='<%=ismainfield05%>_<%=fromfieldid05%>'>
										</td>
										 <td><%=inputOAvalue%><SPAN><INPUT name=<%=inputOA%> value='<%=inputOAvalue%>' type=hidden></SPAN></td>
									</tr>
									<%
									}else
									{
										%>
										<tr class='DataDark'>
										<td><input type='checkbox' name='zibox'></td>
										
										<td>
										<button type='button' class='e8_browflow' onclick=addOneFieldObj(8,this,'<%=newstru05%>')></button>
										<input type='hidden' name='<%=input01%>' value='<%=sapfield%>' ><span><%=sapfield%></span><span id='<%=input01Span%>'></span>
										</td>
										 <td><%=showname%><SPAN><INPUT name=<%=input02%> value='<%=showname%>' type=hidden></SPAN>
										</td>
										<td><button type='button' class='e8_browflow' onclick=addOneFieldObjOA(this,'','<%=backtable%>')></button>
										<input type='hidden' name='<%=input06%>' value='<%=oafield%>'/><span><%=oafield%></span><span></span>
										<input type=hidden name='<%=address%>' value='<%=ismainfield05%>_<%=fromfieldid05%>'	></td>
										 <td><%=inputOAvalue%><SPAN><INPUT name=<%=inputOA%> value='<%=inputOAvalue%>' type=hidden></SPAN></td>
						
										</tr>
										<%
									}
									childstu++;
								}
								 %>
								 </TABLE>
								 <%
							if("1".equals(w_type)||"2".equals(w_type))//where条件管理
							{ %>
								 <TABLE class=ListStyle cellspacing=1 id='<%=newtable05son%>'>
								 <tr class='DataDark'>
										 <td colspan=6>
										
										<span style='float:left'>
										<%=SystemEnv.getHtmlLabelName(30616 ,user.getLanguage())%>
										</span>
										<span style='float:right'>
											 
										<input type='button'  class='addbtnB' onclick=addBathFieldObj(12,1,'<%=newstru05%>','<%=sap_outTable%>','<%=backtable%>') 
										 title='<%=SystemEnv.getHtmlLabelName(25055 ,user.getLanguage())%>'>
										 <input type='button' class='addbtn' onclick=addBathFieldObj(12,2,'<%=newstru05%>','<%=sap_outTable%>','<%=backtable%>') 
										 title='<%=SystemEnv.getHtmlLabelName(611 ,user.getLanguage())%>'>
										<input type='button' class='delbtn' onclick=addBathFieldObj(12,3,'<%=newstru05%>','<%=sap_outTable%>') 
										 title='<%=SystemEnv.getHtmlLabelName(23777 ,user.getLanguage())%>'>
										<input type='hidden' name='<%=newtable05soncount%>' id='<%=newtable05soncount%>' value='<%=inteutil.getSapInAndOutParameterCount("5",baseid,comid)%>'>
										
										</span>
										 </td>
								 </tr>
								 <tr class=header>
										 <td>
										 <input type='checkbox' onclick=checkbox5son(this,<%=sap_outTable%>)><%=SystemEnv.getHtmlLabelName(556 ,user.getLanguage())%>
										 </td>
										 <td>
										 <%=SystemEnv.getHtmlLabelName(30617 ,user.getLanguage())%>
										 </td>
										 <td>
										<%=SystemEnv.getHtmlLabelName(21934 ,user.getLanguage())%>
										 </td>
										 <td>
										 <%=SystemEnv.getHtmlLabelName(30618 ,user.getLanguage())%>
										 </td>
										 <td>
										<%=SystemEnv.getHtmlLabelName(21934 ,user.getLanguage())%>
										 </td>
										 <td>
										 <%=SystemEnv.getHtmlLabelName(30619 ,user.getLanguage())%>
										 </td>
										
										
								 </tr>
								 <%
									int childsonstu=1;
									sql=" select * from sap_outparaprocess  where baseid='"+baseid+"' and nameid='"+comid+"' order by ordernum";
									//System.out.println("页面输出表的查询"+sql);
									RecordSet02.execute(sql);
									while(RecordSet02.next())
									{
											String input01="sap05son_"+sap_outTable+"_"+childsonstu;
											String input02="set05son_"+sap_outTable+"_"+childsonstu;
											String input03="add05son_"+sap_outTable+"_"+childsonstu;
											String input04="con05son_"+sap_outTable+"_"+childsonstu;
											String inputSAP="show05son_"+sap_outTable+"_"+childsonstu;
											String inputOA="OAshow05son_"+sap_outTable+"_"+childsonstu;
												
											String  outsapfield=RecordSet02.getString("sapfield");
											String  outoafield=RecordSet02.getString("oafield");
											String  outconstant=RecordSet02.getString("constant");
											String  outismainfield=RecordSet02.getString("ismainfield");
											String  outfromfieldid=RecordSet02.getString("fromfieldid");
											String shownamevalue=RecordSet02.getString("showname");	
											String inputOAvalue=RecordSet02.getString("oadesc");	
												
											String  outpingjie=outismainfield+"_"+outfromfieldid;
											 %>
											 <tr class='DataDark'>
											 <td>
											 <input type='checkbox' name='zibox'>
											 </td>
											 <td>
											 <button type='button' class='e8_browflow' onclick=addOneFieldObj(8,this,'<%=newstru05%>')></button><input type='hidden' name='<%=input01%>' value='<%=outsapfield%>'><span><%=outsapfield%></span><span ></span>
											 </td>
											 <td><%=shownamevalue%><SPAN><INPUT name=<%=inputSAP%> type=hidden value='<%=shownamevalue%>'></SPAN></td>
											 <td>
											 <button type='button' class='e8_browflow' onclick=addOneFieldObjOA(this,'0','<%=backtable%>')></button><input type='hidden' name='<%=input02%>' value='<%=outoafield%>'/><span><%=outoafield%></span><span></span><input type=hidden name='<%=input03%>' value='<%=outpingjie%>'>
											 </td>
											 <td><%=inputOAvalue%><SPAN><INPUT name=<%=inputOA%> type=hidden value='<%=inputOAvalue%>'></SPAN></td>
											 <td>
											 <input type='text' name='<%=input04%>' value='<%=outconstant%>' class='constantfiedl'>
											 </td>
											 </tr>
											<%
											childsonstu++;
									}
									 %>
								 </TABLE>
								<%
							}
								 %>
							</td></tr>
							<%
						sap_outTable++;
					}	
				}
			 %>
			</TABLE>
			</div>
			</wea:item>
			</wea:group>
			</wea:layout>
									<!-- 第五个tab页里面的内容--end -->
									<!-- 第六个tab页里面的内容-start -->
			
			<wea:layout type="2col" attributes="{layoutTableId:'sap_06layout';layoutTableDisplay:none}">
			  <wea:group context='<%=SystemEnv.getHtmlLabelName(30620 ,user.getLanguage()) %>' >
			    <wea:item attributes="{'colspan':'full','isTableList':'true'}">
					<TABLE width="200px" style="margin-top: -34px;margin-right: 26px;float: right;">
	            				<TR>
	            					<TD align=right>
	            							<input type="button" class="addbtnB" id='bath_06' accesskey="A" onclick="addBathFieldObj(9,1)" title="C-<%=SystemEnv.getHtmlLabelName(25055,user.getLanguage()) %>"> 								
											<input type="button" class="addbtn" id='add_06' accesskey="A" onclick="addBathFieldObj(9,2)" title="A-<%=SystemEnv.getHtmlLabelName(83476,user.getLanguage()) %>"> 
											<input type="button" class="delbtn"  id='del_06' accesskey="E" onclick="addBathFieldObj(9,3)" title="E-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage()) %>">
											
											<input type='hidden' id='hidden06' name='hidden06' value='<%=inteutil.getSapInAndOutParameterCount("6",baseid)%>'>
	            					</TD>
	            				</TR>
	          		</TABLE>
			<!-- add by wshen-->
			<div id = "showScrollDiv" style ="border:0px solid #000;height:300px;width:100%;	overflow:auto;" >
			<TABLE class='ListStyle marginTop0  sapitem' cellspacing=1 id='sap_06' style='table-layout: fixed;'>
			 <colgroup> <col width='110px'/>  <col width='*' /> </colgroup>										 
																			
			 <tr>	
			 <td colspan=2>																			
								  <TABLE class=ListStyle cellspacing=1 style='table-layout: fixed;' id='sap_06_son'>
								 <colgroup> <col width='30px'/> <col width='30%'/> <col width='*'/> </colgroup>					
								  <tr class=header>	
								  <td><input type='checkbox' id='cbox_06'/></td>	
								  <td><%=SystemEnv.getHtmlLabelName(28217 ,user.getLanguage())%></td>	
								
								  <td><%=SystemEnv.getHtmlLabelName(19480 ,user.getLanguage())%></td>	
								  </tr>	
								 
								<%
								sql=" select * from int_authorizeRight where baseid='"+baseid+"' order by ordernum";
								RecordSet.execute(sql);
								while(RecordSet.next())
								{	
									
									String autotype="autotype_"+int_authorizeRight;
									String autospan="autospan_"+int_authorizeRight;
									String autodeti="autodeti_"+int_authorizeRight;
									String autowfid="autowfid_"+int_authorizeRight;
									String autouserorwf="autouserorwf_"+int_authorizeRight;
									String autowfidspan="autowfidspan_"+int_authorizeRight;
									
									String	type=RecordSet.getString("type");
									String	resourceids=RecordSet.getString("resourceids");
									String	roleids =RecordSet.getString("roleids");
									String	wfids=RecordSet.getString("wfids");
									String  autotypeid=RecordSet.getString("id");
									oldautotypeid+=autotypeid+",";
									String[] hrmidarr = Util.TokenizerString2(resourceids,",");
									String hrmnames = "";
									for(int i = 0; i<hrmidarr.length; i++){
										hrmnames += ResourceComInfo.getLastname(hrmidarr[i]) + ",";
									}
									if(hrmnames.length() > 0){
										hrmnames = hrmnames.substring(0,hrmnames.length()-1);
									}	
									String[] roleidarr = Util.TokenizerString2(roleids,",");
									String rolenames = "";
									for(int i = 0; i<roleidarr.length; i++){
										rolenames += RolesComInfo.getRolesRemark(roleidarr[i]) + ",";
									}
									if(rolenames.length() > 0){
										rolenames = rolenames.substring(0,rolenames.length()-1);
									}
									String[] wfidarr = Util.TokenizerString2(wfids,",");
									String wfnames = "";
									for(int i = 0; i<wfidarr.length; i++){
										wfnames += WorkflowComInfo.getWorkflowname(wfidarr[i]) + ",";
									}
									if(wfnames.length() > 0){
										wfnames = wfnames.substring(0,wfnames.length()-1);
									}
									 %>
									  <tr class='DataDark'>
									 <td><input type='checkbox' name='autho'></td>
									 <td>
									 <select name='<%=autotype%>' id='<%=autotype%>' onchange=changerole('<%=autospan%>','<%=autouserorwf%>')>
									<option value=1><%=SystemEnv.getHtmlLabelName(179 ,user.getLanguage())%></option>
									<%
									if("2".equals(type))
									{ %>
										<option value=2 selected><%=SystemEnv.getHtmlLabelName(122 ,user.getLanguage())%></option>
									<%
									}else
									{ %>
										<option value=2 ><%=SystemEnv.getHtmlLabelName(122 ,user.getLanguage())%></option>
									<%
									}
									 %>
									</select>
									 <button type='button' class='e8_browflow' onclick=changebrotype(1,'<%=autotype%>','<%=autospan%>','<%=autouserorwf%>')></button>
									<%
									if("1".equals(type))
									{ %>
										 <span id='<%=autospan%>'><%=hrmnames%></span>
										 <input type='hidden' id='<%=autouserorwf%>' name='<%=autouserorwf%>' value='<%=resourceids%>'>
									<%
									}else if("2".equals(type))
									{ %>
										 <span id='<%=autospan%>'><%=rolenames%></span>
										 <input type='hidden' id='<%=autouserorwf%>' name='<%=autouserorwf%>' value='<%=roleids%>'>
									<%
									}
									 %>
									 </td>
								
									 <td>
									 <input class=e8_btn_submit type=button  value='<%=SystemEnv.getHtmlLabelName(19342 ,user.getLanguage())%>'   onclick=changebrotype(2,'<%=autodeti%>','')>
									 <input type='hidden' id='<%=autodeti%>' name='<%=autodeti%>' value='<%=autotypeid%>'>
									 </td>
									  </tr>	
									<%
									int_authorizeRight++;
								}
								 %>
								  </table>	
			 </td></tr>	
			 </TABLE>
				</div>
			 </wea:item>
			 </wea:group>
			 </wea:layout>
									<!-- 第六个tab页里面的内容--end -->
									<!-- 第七个tab页里面的内容-start -->
			<wea:layout type="2col" attributes="{layoutTableId:'sap_07layout';layoutTableDisplay:none}">
			  <wea:group context='<%=SystemEnv.getHtmlLabelName(30712 ,user.getLanguage()) %>' >
			    <wea:item attributes="{'colspan':'full','isTableList':'true'}">
					<TABLE width="200px" style="margin-top: -34px;margin-right: 26px;float: right;">
	            				<TR>
	            					<TD align=right>
	            							<input type="button" class="addbtnB" id='bath_07' accesskey="A" onclick="addBathFieldObj(10,1)" title="C-<%=SystemEnv.getHtmlLabelName(25055,user.getLanguage()) %>">
											<input type="button" class="addbtn" id='add_07' accesskey="A" onclick="addBathFieldObj(10,2)" title="A-<%=SystemEnv.getHtmlLabelName(83476,user.getLanguage()) %>">
											<input type="button" class="delbtn"  id='del_07' accesskey="E" onclick="addBathFieldObj(10,3)" title="E-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage()) %>">

											<%
											String hidden07value = "";
											if(("save".equals(opera)&&"1".equals(loadmb))||loadflag){
												hidden07value = spmsb.getImptablecount()+"";//模板里面的输入表的总数
											}else{
												hidden07value = inteutil.getSapInAndOutParameterCount("7",baseid);
											}
											
											 %>
											 <input type='hidden' id='hidden07' name='hidden07' value='<%=hidden07value %>'>
	            					</TD>
	            				</TR>
	          		</TABLE>
					<!-- add by wshen-->
					<div id = "showScrollDiv" style ="border:0px solid #000;height:300px;width:100%;	overflow:auto;" >
			<TABLE class='ListStyle marginTop0  sapitem' cellspacing=1 id='sap_07' style='table-layout: fixed;'>
			 <colgroup> <col width='120px'/>  <col width='*' /> </colgroup>										 
			
			<%
			if(("save".equals(opera)&&"1".equals(loadmb)&&"1".equals(w_type))||(loadflag&&"1".equals(w_type)))
			{
					List list = ServiceParamModeDisUtil.getParamsModeDisById(regservice, paramModeId, "import", true, "table", "");
					if(list != null) {
						
						for(int i=0;i<list.size();i++) {
								ServiceParamModeDisBean spmdb = (ServiceParamModeDisBean)list.get(i);
								String ParamName=spmdb.getParamName();
								String ParamDesc=spmdb.getParamDesc();
								String ParamCons=spmdb.getParamCons();
								
								int newchtable = ServiceParamModeDisUtil.getCompFieldCountByName(regservice, paramModeId, "import",ParamName);
									
								String newstru07="outtable7_"+sap_inTable;
								String newstru07Span="outtable7_"+sap_inTable+"Span";
								String bath07="bath7_"+sap_inTable;
								String newname07="cbox7_"+sap_inTable;
								String newtable07="sap_07_"+sap_inTable;
								String backtable="backtable7_"+sap_inTable;	//写入表
		
								 %>
								<tr class='DataDark'><td class='tdcenter'><input type='checkbox' name='cbox7'></td>
								<td >
								
								<TABLE class=ListStyle cellspacing=1 id='<%=newtable07%>'>
								<tr class='DataDark'>
								<td colspan=9>
								
								<span style='float:left'>
								<%=SystemEnv.getHtmlLabelName(21900 ,user.getLanguage())%><button type='button' class='e8_browflow' onclick=addOneFieldObj(10,this)></button><input type='hidden' class='selectmax_width' id='<%=newstru07%>' name='<%=newstru07%>' value='<%=ParamName%>'/><span><%=ParamName%></span><span id='<%=newstru07Span%>'></span>
								<input type='hidden' id='<%=newname07%>' name='<%=newname07%>' value='<%=newchtable%>'>
								&nbsp;
								<%=SystemEnv.getHtmlLabelName(31734 ,user.getLanguage())%><button type='button' class='e8_browflow' onclick=backtable(this)></button> 
								<input type='hidden' name='<%=backtable%>' id='<%=backtable%>'  value=''><span></span><span><img src='/images/BacoError_wev8.gif' align=absMiddle></span> 
								</span>
								<span style='float:right'>
								
								<input type='button'  class='addbtnB' id='<%=bath07%>' onclick=addBathFieldObj(11,1,'<%=newstru07%>','<%=sap_inTable%>','<%=backtable%>') 
								 title='<%=SystemEnv.getHtmlLabelName(25055 ,user.getLanguage())%>'> 
								<input type='button' class='addbtn' onclick=addBathFieldObj(11,2,'<%=newstru07%>','<%=sap_inTable%>','<%=backtable%>') 
								 title='<%=SystemEnv.getHtmlLabelName(611 ,user.getLanguage())%>'>
								<input type='button' class='delbtn' onclick=addBathFieldObj(11,3,'<%=newstru07%>','<%=sap_inTable%>')  title='<%=SystemEnv.getHtmlLabelName(23777 ,user.getLanguage())%>>
								
								</span>
								</td>
								</tr>
							
								
								
								
								<tr class=header><td><input type='checkbox' onclick='checkbox7(this,<%=sap_inTable%>)'/>
								<%=SystemEnv.getHtmlLabelName(556 ,user.getLanguage())%></td>
								<td><%=SystemEnv.getHtmlLabelName(31731 ,user.getLanguage())%></td>
								<td><%=SystemEnv.getHtmlLabelName(21934 ,user.getLanguage())%></td>
								<td><%=SystemEnv.getHtmlLabelName(31732 ,user.getLanguage())%></td>
								<td><%=SystemEnv.getHtmlLabelName(21934 ,user.getLanguage())%></td>
								<td><%=SystemEnv.getHtmlLabelName(453 ,user.getLanguage())%></td>
								</tr>
								<%		
								int childstu=1;
							
								List listtemp = ServiceParamModeDisUtil.getParamsModeDisById(regservice, paramModeId, "import", false, "", ParamName); 
								if(listtemp != null) {
									for(int j=0;j<listtemp.size();j++) {
													ServiceParamModeDisBean spmdbtemp = (ServiceParamModeDisBean)listtemp.get(j);
													String ParamDBName=spmdbtemp.getParamName();
													String ParamDBDesc=spmdbtemp.getParamDesc();
													String ParamDBCons=spmdbtemp.getParamCons();
													
													String input01="sap07_"+sap_inTable+"_"+childstu;
													String input02="show07_"+sap_inTable+"_"+childstu;//显示名--文本框
													String input02Span="show07_"+sap_inTable+"_"+childstu+"Span";//显示名--img
													String input03="con07_"+sap_inTable+"_"+childstu;
													String input06="setoa7_"+sap_inTable+"_"+childstu;
													String address="add07_"+sap_inTable+"_"+childstu;
													String input01Span="sap07_"+sap_inTable+"_"+childstu+"Span";
													String inputOA="OAshow07_"+sap_inTable+"_"+childstu;
													//value='"+ismainfield07+"_"+fromfieldid07+"'	
													 %>
													<tr class='DataDark'>
													<td><input type='checkbox' name='zibox'></td>
													 <td><button type='button' class='e8_browflow' onclick=addOneFieldObjOA(this,'0','<%=backtable%>')></button><input type='hidden' name='<%=input06%>' value=''/><span></span><span></span><input type=hidden name='<%=address%>' value=''	></td>
													<td><SPAN><INPUT name=<%=inputOA%> type=hidden></SPAN></td>
													<td><button type='button' class='e8_browflow' onclick=addOneFieldObj(11,this,'<%=newstru07%>')></button><input type='hidden' name='<%=input01%>' value='<%=ParamDBName%>'/><span><%=ParamDBName%></span><span id='<%=input01Span%>'></span></td>
													<td><%=ParamDBDesc%><SPAN><INPUT name=<%=input02%> type=hidden value='<%=ParamDBDesc%>'></SPAN></td>
													<td><input type='text' name='<%=input03%>' value='<%=ParamDBCons%>' class='constantfiedl'></td>
													</tr>
													<%
													childstu++;
									}
								}
								 %>
						</TABLE>
						</td></tr>
						<%
						sap_inTable++;	
						}
					}
			}else  if("update".equals(opera)&&!"2".equals(updateChangeService)&&"1".equals(w_type))
			{
				//查出所有的输入表
				sql=" select * from sap_complexname where comtype=1 and   baseid='"+baseid+"'  ";
				//System.out.println("输入表页面查询"+sql);
				RecordSet.execute(sql);
				while(RecordSet.next())
				{		
						String newstru07="outtable7_"+sap_inTable;
						String newstru07Span="outtable7_"+sap_inTable+"Span";
						String bath07="bath7_"+sap_inTable;
						String newname07="cbox7_"+sap_inTable;
						String newtable07="sap_07_"+sap_inTable;
						String backtable="backtable7_"+sap_inTable;	//写入表
						String name=RecordSet.getString("name");
						String backtablename=RecordSet.getString("backtable");//写入表
						 %>
						<tr class='DataDark'><td class='tdcenter'><input type='checkbox' name='cbox7'></td>
						<td>
						
						<TABLE class=ListStyle cellspacing=1 id='<%=newtable07%>'>
						<tr class='DataDark'>
						<td colspan=9>
						
						<span style='float:left'>
						<%=SystemEnv.getHtmlLabelName(21900 ,user.getLanguage())%><button type='button' class='e8_browflow' onclick=addOneFieldObj(10,this)></button><input type='hidden' class='selectmax_width' id='<%=newstru07%>' name='<%=newstru07%>' value='<%=name%>'/><span><%=name%></span><span id='<%=newstru07Span%>'></span>
						<input type='hidden' id='<%=newname07%>' name='<%=newname07%>' value='<%=inteutil.getSapInAndOutParameterCount("4",baseid,RecordSet.getString("id"))%>'>
						<%=SystemEnv.getHtmlLabelName(31734 ,user.getLanguage())%><button type='button' class='e8_browflow' onclick=backtable(this)></button> 
						<input type='hidden' name='<%=backtable%>' id='<%=backtable%>'  value='<%=backtablename%>'><span><%=backtablename%></span><span></span> 
						</span>
						<span style='float:right'>
						
						<input type='button'  class='addbtnB' id='<%=bath07%>' onclick=addBathFieldObj(11,1,'<%=newstru07%>','<%=sap_inTable%>','<%=backtable%>') 
						 title='<%=SystemEnv.getHtmlLabelName(25055 ,user.getLanguage())%>'> 
						<input type='button' class='addbtn' onclick=addBathFieldObj(11,2,'<%=newstru07%>','<%=sap_inTable%>','<%=backtable%>') 
						 title='<%=SystemEnv.getHtmlLabelName(611 ,user.getLanguage())%>'>
						<input type='button' class='delbtn' onclick=addBathFieldObj(11,3,'<%=newstru07%>','<%=sap_inTable%>') 
						 title='<%=SystemEnv.getHtmlLabelName(23777 ,user.getLanguage())%>'>
						
						</span>
						
						
						</td>
						
						</tr>
						<tr class=header><td><input type='checkbox' onclick='checkbox7(this,<%=sap_inTable%>)'/><%=SystemEnv.getHtmlLabelName(556 ,user.getLanguage())%></td>
						<td><%=SystemEnv.getHtmlLabelName(31731 ,user.getLanguage())%></td>
						<td><%=SystemEnv.getHtmlLabelName(21934 ,user.getLanguage())%></td>
						<td><%=SystemEnv.getHtmlLabelName(31732 ,user.getLanguage())%></td>
						<td><%=SystemEnv.getHtmlLabelName(21934 ,user.getLanguage())%></td>
						<td><%=SystemEnv.getHtmlLabelName(453 ,user.getLanguage())%></td>
	
					
						</tr>
						
							<%	
							int childstu=1;
							sql=" select * from sap_inTable  where baseid='"+baseid+"' and nameid='"+RecordSet.getString("id")+"' order by id";
							RecordSet02.execute(sql);
							while(RecordSet02.next())
							{
								
								String input01="sap07_"+sap_inTable+"_"+childstu;
								String input02="show07_"+sap_inTable+"_"+childstu;//显示名--文本框
								String input02Span="show07_"+sap_inTable+"_"+childstu+"Span";//显示名--img
								String input03="con07_"+sap_inTable+"_"+childstu;
								String input06="setoa7_"+sap_inTable+"_"+childstu;
								String address="add07_"+sap_inTable+"_"+childstu;
								String inputOA="OAshow07_"+sap_inTable+"_"+childstu;
									
								String sapfield=RecordSet02.getString("sapfield");
								String oafield=RecordSet02.getString("oafield");
								String constant7=RecordSet02.getString("constant");
								String input01Span="sap07_"+sap_inTable+"_"+childstu+"Span";
								String ismainfield07=RecordSet02.getString("ismainfield");
								String fromfieldid07=RecordSet02.getString("fromfieldid");
								String inputOAvalue=RecordSet02.getString("oadesc");
								String inputSAPvalue=RecordSet02.getString("showname");
								//value='"+ismainfield07+"_"+fromfieldid07+"'	
								 %>
								<tr class='DataDark'>
								<td><input type='checkbox' name='zibox'></td>
								 <td><button type='button' class='e8_browflow' onclick=addOneFieldObjOA(this,'0','<%=backtable%>')></button><input type='hidden' name='<%=input06%>' value='<%=oafield%>'/><span><%=oafield%></span><span></span><input type=hidden name='<%=address%>' value='<%=ismainfield07%>_<%=fromfieldid07%>'	></td>
								<td><%=inputOAvalue%><SPAN><INPUT name=<%=inputOA%> type=hidden value='<%=inputOAvalue%>'></SPAN></td>
								<td><button type='button' class='e8_browflow' onclick=addOneFieldObj(11,this,'<%=newstru07%>')></button><input type='hidden' name='<%=input01%>' value='<%=sapfield%>'/><span><%=sapfield%></span><span id='<%=input01Span%>'></span></td>
								<td><%=inputSAPvalue%><SPAN><INPUT name=<%=input02%> type=hidden value='<%=inputSAPvalue%>'></SPAN></td>
								<td><input type='text' name='<%=input03%>' value='<%=constant7%>' class='constantfiedl'></td>
								</tr>
								<%
								childstu++;
							}
							 %>
						</TABLE>
						</td></tr>
				<%
					sap_inTable++;
				}	
			}
			 %>
			 </TABLE>
				</div>
			 </wea:item>
			 </wea:group>
			 </wea:layout>		
									<!-- 第七个tab页里面的内容--end -->
							</TD>
						</TR>
					</TABLE>
					<!--ListStyle 表格end  -->
					
				<input type="hidden" name="islocal" id="islocal" value="<%=islocal%>">	
				<input type="hidden" name="w_enable" id="w_enable">
				<input type="hidden" name="w_actionorder" id="w_actionorder">		
				<input type="hidden" name="isbill" id="isbill" value="<%=isbill%>">
				<input type="hidden" name="ispreoperator" id="ispreoperator">
				<input type="hidden" name="nodelinkid" id="nodelinkid">
				<input type="hidden" name="nodeid" id="nodeid" value="<%=nodeid%>">
				<input type="hidden" name="workflowid" id="workflowid" value="<%=workflowid%>">
				<input type="hidden" name="ismainfield" id="ismainfield" value="<%=ismainfield%>">	
				<input type="hidden" name="updateTableName" id="updateTableName" value="<%=updateTableName%>">	
				<input type="hidden" name="formid" id="formid" value="<%=formid%>">	
				<input type="hidden" name="baseid" value="<%=baseid%>">	
				<input type="hidden" name="opera" value="<%=opera%>">	
				<input type="hidden" name="mark" id="mark" value="<%=mark%>">
				<input type="hidden" name="regservice" id="regservice" value="<%=regservice%>">
				<input type="hidden" name="oldautotypeid" id="oldautotypeid" value="<%=oldautotypeid%>">
				<input type="hidden" name="w_type" id="w_type" value="<%=w_type%>">
				<input type="hidden" name="hpid" id="hpid">
				<input type="hidden" name="authcontorl" id="authcontorl">
				<input type="hidden" name="browsertype" id="browsertype" value="<%=browsertype%>">
				<input type="hidden" name="poolid" id="poolid">
				<input type="hidden" name="brodesc" id="brodesc">
				<input type="hidden" name="dataauth" id="dataauth">
		<!--add by wshen-->
				<input type="hidden" name="actionid" id="actionid" value="<%=actionid%>">
				<!--选择的是哪个table-->
				<input type=hidden" name="partype"	 id="partype" value="<%=partype%>">
		<!--end-->

				<iframe src="" style="display: none;" id="postiframe" name="postiframe"></iframe>
	</form>
	</body>
	
	<script type="text/javascript">
	
	jQuery(document).ready(function(){
		jQuery('.e8_box').Tabs({
	    	getLine:1,
	    	image:false,
	    	needLine:false,
	    	needTopTitle:false,
	    	needInitBoxHeight:false
	    	
	    });
	})
	
	//通用的选中某列的所有checkbox的方法
	//obj:当前的checkbox对象
	//index:该列属于表格的第几列
	//temp:这个全选的checkbox位于表格的第几行
	function checkAllBox(obj,index,temp){
				
				index=parseInt(index-1);
				if(!temp){temp=0;}else{
					temp=parseInt(temp-1);
				}
				
				var flag="";
				if($(obj).parents("table:first")){
					$(obj).parents("table:first").find("tr").each(function(i){
							if(i==0){
									flag=$(this).find("td:eq("+index+")").find("input[type='checkbox']").attr('checked');
							}
							if(flag==undefined){
								if(i==1){
									flag=$(this).find("td:eq("+index+")").find("input[type='checkbox']").attr('checked');
								}
							}
							//alert($(this).html() )
							$(this).find("td:eq("+index+")").find("input[type='checkbox']").attr('checked',flag);
							
							changeCheckboxStatus($(this).find("td:eq("+index+")").find("input[type='checkbox']"),flag);
					});
				}
				
	}
	function showItemAreaSap(selector){
		$(".LayoutTable[id^='sap']").hide();
		// add by wshen
		var partype = ""+selector;
		$("#partype").val(partype.substring(6));
		//end add
		$(selector+"layout").show();
	}
	$(document).ready(function() {  
			$("#cbox_01").click (function(){
					var flag="";
					$(this).parents("table:first").find("tr").each(function(i){
								if(i==0){
										flag=$(this).find("td:eq(0)").find("input[type='checkbox']").attr('checked');
								}
								$(this).find("td:eq(0)").find("input[type='checkbox']").attr('checked',flag);
								changeCheckboxStatus($(this).find("td:eq(0)").find("input[type='checkbox']"),flag);
					})

			});
			$("#cbox_03").click (function(){
					//$("#sap_03 tr td:first-child [type=checkbox][name=cbox3]").each(function(){ 
						//var flag=$("#cbox_03").attr('checked');
						//$(this).attr('checked',flag);
					//});

					$("#chind03 tr").parent().find("input[type='checkbox'][name=cbox3]").each(
						function(){
							var flag=$("#cbox_03").attr('checked');
							$(this).attr('checked',flag);
							changeCheckboxStatus($(this),flag);
						}
					);
			});
			
			$("#cbox_06").click (function(){
					$("#sap_06 tr td:first-child [type=checkbox][name=autho]").each(function(){ 
						var flag=$("#cbox_06").attr('checked');
						$(this).attr('checked',flag);
						changeCheckboxStatus($(this),flag);
					});
			});		
			$("#saveDate").click (function(){
					weaver.submit();
			});
			
			$(".navigation li").click (function(){
					$(this).parent().children().removeClass("selectedli"); 
					$(this).addClass("selectedli");
					var temp=$(this).attr("item");
					if(temp<=7)
					{
						$("#sap_01").hide();
						$("#sap_02").hide();
						$("#sap_03").hide();
						$("#sap_04").hide();
						$("#sap_05").hide();
						$("#sap_06").hide();
						$("#sap_07").hide();
						$("#sap_0"+temp).show();
					}
					//$(this).blur();//控制失去焦点虚线
			});
			<%
				if("2".equals(dataauth))
				{
			%>
					$("#dataauthli").click();
			<%
				}
			%>
 	}); 

 	function checkbox2(obj,chtable)
 	{
 		//得到子表的id
 		var newtable=$("#sap_02"+"_"+chtable);
		$("#sap_02"+"_"+chtable+" tr td:first-child [type=checkbox][name=zibox]").each(function(){ 
			var flag=obj.checked;
			$(this).attr('checked',flag);
			changeCheckboxStatus($(this),flag);
		});
 	}

 	function checkbox4(obj,chtable)
 	{
 		//得到子表的id
 		var newtable=$("#sap_04"+"_"+chtable);
		$("#sap_04"+"_"+chtable+" tr td:first-child [type=checkbox][name=zibox]").each(function(){ 
			var flag=obj.checked;
			$(this).attr('checked',flag);
			changeCheckboxStatus($(this),flag);
		});
 	}
 	function checkbox5(obj,chtable)
 	{
 		//得到子表的id
 		var newtable=$("#sap_05"+"_"+chtable);
		$("#sap_05"+"_"+chtable+" tr td:first-child [type=checkbox][name=zibox]").each(function(){ 
			var flag=obj.checked;
			$(this).attr('checked',flag);
			changeCheckboxStatus($(this),flag);
		});
 	}
 	function checkbox7(obj,chtable)
 	{
 		//得到子表的id
 		var newtable=$("#sap_07"+"_"+chtable);
		$("#sap_07"+"_"+chtable+" tr td:first-child [type=checkbox][name=zibox]").each(function(){ 
			var flag=obj.checked;
			$(this).attr('checked',flag);
			changeCheckboxStatus($(this),flag);
		});
 	}
 	function checkbox5son(obj,chtable)
 	{
 		//得到子表的id
 		var newtable=$("#sapson_05"+"_"+chtable);
		$("#sapson_05"+"_"+chtable+" tr td:first-child [type=checkbox][name=zibox]").each(function(){ 
			var flag=obj.checked;
			$(this).attr('checked',flag);
			changeCheckboxStatus($(this),flag);
		});
 	}
 	//setInterval(flashText, 500);  
 	function flashText()
 	{
 		//控制iframe自适应内容高度
 		var ifheight=$("#tableid").height();
 		window.parent.document.getElementById("maindiv").style.height=ifheight;
 	}

 	//选择oa字段
 	//wfid流程的id
 	//浏览按钮对象
 	//haveimg是否有img这个span,0没有,1有
 	//backtable回写表对象
 	function addOneFieldObjOA(obj,haveimg,backtable)
 	{
 			var backtablevalue="";
 			if(backtable)//表明里面有值
 			{
 				if(!$("#"+backtable).val())//如果为空
 				{
 					
 					alert("<%=SystemEnv.getHtmlLabelName(30621 ,user.getLanguage()) %>"+"!");
 					return;
 				}
 				backtablevalue=$("#"+backtable).val();
 			}
 			
 			//function addOneFieldObjOA标准 ,即$(obj).next().next()，每个nex()后面的对象是什么
			//--------------<button> 浏览按钮
			//--------------<input>  隐藏的oa字段name
			//--------------<span>   显示的oa字段name
			//--------------<span>   显示img
			//--------------<input>  记录字段(是否主字段，字段的数据库id,)
 			var formid=$("#formid").val();
 			var checkvalue=$(obj).next().val();
 			var partype=$(".navigation").find(".selectedli").attr("item");
			if(partype==""||partype==null||partype=="undefined"){
				partype = $("#partype").val();
			}
 		 	//var temp=window.showModalDialog(","","dialogWidth:600px;dialogHeight:600px;center:yes;scroll:yes;status:no");
 			
			var dialog = new window.top.Dialog();
			
			dialog.currentWindow = window;
			dialog.Title = "<%=SystemEnv.getHtmlLabelName(19372,user.getLanguage()) %>";
		    dialog.URL = "/integration/browse/BrowserMain.jsp?url=/integration/browse/integrationBatchOA.jsp?formid="+formid+"&partype="+partype+"&updateTableName=<%=updateTableName%>&w_type=<%=w_type%>&isbill=<%=isbill%>&backtable="+backtablevalue+"&srcType=<%=srcType%>&browsertype=<%=browsertype%>";
			dialog.Width = 660;
			dialog.Height = 660;
			dialog.Drag = true;
			dialog.callbackfun=addOneFieldObjOACallBack;
	 		dialog.callbackfunParam={obj:obj,haveimg:haveimg,backtable:backtable};
			dialog.textAlign = "center";
			dialog.show();
		 	}
 	
 	function addOneFieldObjOACallBack(objjson,temp){
 		var obj = objjson.obj;
 		var haveimg=objjson.haveimg;
 		var backtable =objjson.backtable;
 		if(temp)
		 	{
		 		 if (temp.names!=""&&temp.viewtype!="-1")//表明弹出的浏览框里面选择了oa字段
		 		 {
					var tempname=temp.name.split(",");
					var tempdesc=temp.desc.split(",");
					
					$(obj).next().val(tempname[1]);
					<%
					if("0".equals(w_type))//0-表示是浏览按钮的配置信息，1-表示是节点后动作配置时的信息
					{
					%>
						
						if(haveimg=="0")//haveimg是否有img这个span,0没有,1有
						{
							$(obj).next().next().html(tempname[1]);
							$(obj).next().next().next().html("");
							//(1表示主表，0表示明细表)+字段的id+是否新表单字段
							$(obj).next().next().next().next().val(temp.viewtype.split(",")[1]);
							try{
								
								$(obj).parent().next().find("input").val(tempdesc[1]);
								$(obj).parent().next().html(tempdesc[1]+"<span>"+$(obj).parent().next().find("span").html()+"</span>");
							}catch(e){
								
							}
					
						}else
						{
							$(obj).next().next().html(tempname[1]);
							$(obj).next().next().next().html("");
							//(1表示主表，0表示明细表)+字段的id+是否新表单字段
							$(obj).next().next().next().next().val(temp.viewtype.split(",")[1]);
							
						}
						
					<%
					}else
					{
					%>
					
						
						if(haveimg=="0")//haveimg是否有img这个span,0没有,1有
						{
							$(obj).next().next().html(tempname[1]);
							//(1表示主表，0表示明细表)+字段的id+是否新表单字段
							$(obj).next().next().next().html("");
							$(obj).next().next().next().next().val(temp.viewtype.split(",")[1]);
							try{
								
								$(obj).parent().next().find("input").val(tempdesc[1]);
								$(obj).parent().next().html(tempdesc[1]+"<span>"+$(obj).parent().next().find("span").html()+"</span>");
							}catch(e){
								
							}
						}else
						{
							$(obj).next().next().html(tempname[1]);
							//(1表示主表，0表示明细表)+字段的id+是否新表单字段
							$(obj).next().next().next().html("");
							$(obj).next().next().next().next().val(temp.viewtype.split(",")[1]);
							try{
								
								$(obj).parent().next().find("input").val(tempdesc[1]);
								$(obj).parent().next().html(tempdesc[1]+"<span>"+$(obj).parent().next().find("span").html()+"</span>");
							}catch(e){
							
							}
						}
					<%	
					}
					%>
				 }else//点击“清空”的意思
				 {
				 	
				 	<%
					if("0".equals(w_type))//0-表示是浏览按钮的配置信息，1-表示是节点后动作配置时的信息
					{
					%>
						if(haveimg=="0")//haveimg是否有img这个span,0没有,1有
						{
							$(obj).next().val("");
				 			$(obj).next().next().html("");
				 			$(obj).next().next().next().html("");
				 			$(obj).next().next().next().next().val("");
				 			try{
								
								$(obj).parent().next().find("input").val("");
								$(obj).parent().next().html("<span>"+$(obj).parent().next().find("span").html()+"</span>");
							}catch(e){
								
							}
						}else
						{
							$(obj).next().val("");
				 			$(obj).next().next().html("");
							$(obj).next().next().next().html("<img src='/images/BacoError_wev8.gif' align=absMiddle>");
							//(1表示主表，0表示明细表)+字段的id+是否新表单字段
							$(obj).next().next().next().next().val("");
							
						}
					<%
					}else
					{
					%>
					
						if(haveimg=="0")//haveimg是否有img这个span,0没有,1有
						{
							$(obj).next().val("");
				 			$(obj).next().next().html("");
				 			$(obj).next().next().next().html("");
				 			$(obj).next().next().next().next().val("");
				 			try{
								
								$(obj).parent().next().find("input").val("");
								$(obj).parent().next().html("<span>"+$(obj).parent().next().find("span").html()+"</span>");
							}catch(e){
								
							}
						}else
						{
							$(obj).next().val("");
				 			$(obj).next().next().html("");
				 			$(obj).next().next().next().html("<img src='/images/BacoError_wev8.gif' align=absMiddle>");
				 			$(obj).next().next().next().next().val("");
				 			try{
								
								$(obj).parent().next().find("input").val("");
								$(obj).parent().next().html("<span>"+$(obj).parent().next().find("span").html()+"</span>");
							}catch(e){
								
							}
						}
					<%	
					}
					%>
				 }
		 	}
 	
 	}
 	
 	//所有单个字段操作
 	//type=1表示输入参数,obj表示sap字段浏览按钮
 	//type=2表示输入结构,obj表示结构体名浏览按钮的id
 	//type=3表示输入结构-->>某个结构体-->>sap字段,并且需要提供结构体的id
 	//type=4表示输出参数，obj表示sap字段浏览按钮
 	//type=5表示输出结构,obj表示结构体名浏览按钮
 	//type=6表示输出结构-->>某个结构-->>sap字段,并且需要提供结构体的的id
 	//type=7表示输出表,obj表示表名浏览按钮
 	//type=8表示输出表-->>某个表-->>>>sap字段,并且需要提供表的文本框的id
 	//type=9 ""留着不用
 	//type=10表示输入表，obj表示表名浏览按钮
 	//type=11表示输入表，>>某个表-->>>>sap字段,并且需要提供表的文本框的id
 	//type=12表示输出表的where条件管理表
 	function addOneFieldObj(type,obj,stuname)
 	{
 			//if(type=="3")
 			//{
 				//alert("输入结构的名称"+$("#"+stuname).val());
 			//}
 			//if(type=="6")
 			//{
 				//alert("输出结构的名称"+$("#"+stuname).val());
 			//}
 			//if(type=="8")
 			//{
 				//alert("输出表的名称"+$("#"+stuname).val());
 			//}
 			var islocal=$("#islocal").val();//判断本地获取参数，还是远程获取参数
 			var stuortablevalue=$("#"+stuname).val();
 			var checkvalue=$(obj).next().val();
 		 	
 			var dialog = new window.top.Dialog();
			
			dialog.currentWindow = window;
			dialog.Title = "SAP<%=SystemEnv.getHtmlLabelName(561,user.getLanguage()) %>";
		    dialog.URL = "/integration/browse/BrowserMain.jsp?url=/integration/browse/integrationBatchSap.jsp?type="+type+"&checkvalue="+checkvalue+"&operation=2&stuortablemark="+stuname+"&stuortablevalue="+stuortablevalue+"&regservice=<%=regservice%>"+"&islocal="+islocal;
			dialog.Width = 660;
			dialog.Height = 660;
			dialog.Drag = true;
			dialog.callbackfun=addOneFieldObjCallBack;
	 		dialog.callbackfunParam={obj:obj,type:type,stuname:stuname};
			dialog.textAlign = "center";
			dialog.show();
		 	
 			
 			
 	}
 	
 	function addOneFieldObjCallBack(objjson,temp){
 		var obj = objjson.obj;
 		var type = objjson.type;
 		var stuname = objjson.name;
 		if(temp)
		 	{
		 		 if (temp.id!="" && temp.id != 0)
		 		 {
					var tempsz=temp.id.split(",");
					var tempname=temp.name.split(",");
					$(obj).next().val(tempsz[1]);
					$(obj).next().next().html(tempsz[1]);
					$(obj).next().next().next().html("");
					try{
						if($(obj).parent()[0].tagName!="SPAN"){
							if($(obj).parent().next().find("input").attr("type")=="text"){
								$(obj).parent().next().find("input").val(tempname[1]);
								$(obj).parent().next().find("input").next().html("");
							}else{
								$(obj).parent().next().find("input").val(tempname[1]);
								$(obj).parent().next().html(tempname[1]+"<span>"+$(obj).parent().next().find("span").html()+"</span>");
							}
						}
						
					}catch(e){
					}
				 }else
				 {
				 	$(obj).next().val("");
				 	$(obj).next().next().html("");
				 	$(obj).next().next().next().html("<img src='/images/BacoError_wev8.gif' align=absMiddle>");
				 	try{
				 		if($(obj).parent()[0].tagName!="SPAN"){
								if($(obj).parent().next().find("input").attr("type")=="text"){
										$(obj).parent().next().find("input").val("");
										$(obj).parent().next().find("input").next().html("<img src='/images/BacoError_wev8.gif' align=absMiddle>");
								}else{
									$(obj).parent().next().find("input").val("");
									$(obj).parent().next().html("<span>"+$(obj).parent().next().find("span").html()+"</span>");
								}
						}
					}catch(e){
					}
				 }
				 if (temp.name!="")
		 		 {
		 		 	<%
					if("0".equals(w_type))
					{
					%>
			 		 	if(type=="6"||type=="4")
			 		 	{
				 		 	var tempsz=temp.name.split(",");
							$(obj).parent().next().next().find("input[type='text']").attr("value",tempsz[1])//赋值给显示名
							if(tempsz[1])//表明里面有值
							{
								$(obj).parent().next().next().find("span:not(.jNiceWrapper)").html("");
							}
						}
					<%
					}
					%>
		 		 }
		 	}
 	}
 	
 	function addBathFieldObjCallback(objjson,temp){
 		if(temp)
			{
     			 if (temp.id!="" && temp.id != 0) {
					var tempsz=temp.id.split(",");
					var tempname=temp.name.split(",");
					for(var ij=0;ij<tempsz.length;ij++)
					{
						if(tempsz[ij])
						{
							var shuzi=parseInt($("#hidden01").val())+1;
							var input01="sap01_"+shuzi;
							var inputSAP="show01_"+shuzi;
							var inputSAPSpan="show01_"+shuzi+"Span";
							var inputOA="OAshow01_"+shuzi;
							var input01Span="sap01_"+shuzi+"Span";
							var input02="oa01_"+shuzi;
							var input02Span="oa01_"+shuzi+"Span";
							var input03="con01_"+shuzi;
							var vTb=$("#chind01");
							var address="add01_"+shuzi;
							//是否显示
							var ishowField="ishowField01_"+shuzi;
							//是否只读
							var isrdField="isrdField01_"+shuzi;
							//排序字段
							var isorderby="isorderby01_"+shuzi;
							var row = $("<tr class='DataDark'></tr>"); 
							
							<%
								if("0".equals(w_type))
								{
							%>
								var td = $("<td><input type='checkbox' name='cbox1'></td>"
								
								+"<td><button type='button' class='e8_browflow' onclick=addOneFieldObjOA(this,0)></button><input type='hidden' name='"+input02+"'> <span></span><span id='"+input02Span+"'></span><input type=hidden name='"+address+"'></td>"
								+"<td><span><input type='hidden' name='"+inputOA+"'  value=''></span></td>"
								
								+"<td><input type='checkbox' name='"+ishowField+"' value='1'></td>"
								+"<td><input type='text' name='"+isorderby+"' value='0' class='orderfield'></td>"
								//+"<td><img src='/integration/images/jt_wev8.png' class='fx'></td>"
								
								
								+"<td><button type='button' class='e8_browflow' onclick=addOneFieldObj(1,this)></button><input type='hidden' name='"+input01+"'  value='"+tempsz[ij]+"'> <span>"+tempsz[ij]+"</span><span id='"+input01Span+"'></span></td>"
								+"<td> <input type='text' name='"+inputSAP+"'   value='"+tempname[ij]+"'   onchange=checkinput('"+inputSAP+"','"+inputSAPSpan+"') ><span id='"+inputSAPSpan+"'></span></td>"
								
								
								+"<td><input type='text' name='"+input03+"'  class='constantfiedl'></td>");
								
							 <%
								}else
								{
							%>
								var td = $("<td><input type='checkbox' name='cbox1'></td>"
								+"<td><button type='button' class='e8_browflow' onclick=addOneFieldObjOA(this,0)></button>"
								+"<input type='hidden' name='"+input02+"'> <span></span><span id='"+input02Span+"'></span>"
								+"<input type=hidden name='"+address+"'></td>"
								+"<td><span><input type='hidden' name='"+inputOA+"'  value=''></span></td>"
								+"<td><button type='button' class='e8_browflow' onclick=addOneFieldObj(1,this)></button>"
								+"<input type='hidden' name='"+input01+"'  value='"+tempsz[ij]+"'> "
								+"<span>"+tempsz[ij]+"</span><span id='"+input01Span+"'></span>"
								+"</td>"
								+"<td>"+tempname[ij]+" <span><input type='hidden' name='"+inputSAP+"'   value='"+tempname[ij]+"'></span></td>"
								+"<td><input type='text' name='"+input03+"' class='constantfiedl'></td>");
							<%		
								}
							%>
							row.append(td); 
							vTb.append(row); 
							//得到表格的行数
							//var temp=$("#chind01").get(0).rows.length;
							$("#hidden01").attr("value",shuzi);
						}
					}
				}
			}
			$('body').jNice();
 	}
 	
 	
 	function addBathFieldObjCallback2(objjson,temp){
 		var type = objjson.type;
 		var source =objjson.source;
 		var stuname =objjson.chtable;
 		var chtable =objjson.chtable;
 		var backtable =objjson.backtable;
 		if(temp)
					{
						if (temp.id!="" && temp.id != 0) 
						{
							var tempsz=temp.id.split(",");
							for(var ij=0;ij<tempsz.length;ij++)
							{
								if(tempsz[ij])
								{
										var chtable=parseInt($("#hidden02").val())+1;
										var shuzi=parseInt(chtable)+1;
										var newname="cbox2"+"_"+chtable;
										var newtable="sap_02"+"_"+chtable;
										var newstru="stru_"+chtable;
										var newstruSpan="stru_"+chtable+"Span";
										var bath="bath2_"+chtable;
										var row = $("<tr class='DataDark'><td class='tdcenter'><input type='checkbox' name='cbox2'></td>"); 	
											row.append("<td>"
													+"<TABLE class=ListStyle cellspacing=1 id='"+newtable+"' >"
													+"<tr>"
													+"<td colspan='10' >"
													+"<span style='float:left'>"
													+"<%=SystemEnv.getHtmlLabelName(30609 ,user.getLanguage())%><button type='button' class='e8_browflow' onclick=addOneFieldObj(2,this,'"+newstru+"')></button>"
													+"<input type='hidden' class='selectmax_width' id='"+newstru+"'  name='"+newstru+"' value='"+tempsz[ij]+"' ><span>"+tempsz[ij]+"</span><span id='"+newstruSpan+"'></span>" 
													+"<input type='hidden' id='"+newname+"' name='"+newname+"' value='0'>"
													+"</span>"
													+"<span style='float:right'>"
													+"<input type='button'  class='addbtnB' id='"+bath+"' onclick=addBathFieldObj(3,1,'"+newstru+"','"+chtable+"') title='<%=SystemEnv.getHtmlLabelName(25055 ,user.getLanguage())%>'>"
													+"<input type='button' class='addbtn' onclick=addBathFieldObj(3,2,'"+newstru+"','"+chtable+"') title='<%=SystemEnv.getHtmlLabelName(611 ,user.getLanguage())%>'>"
													+"<input type='button' class='delbtn' onclick=addBathFieldObj(3,3,'"+newstru+"','"+chtable+"') title='<%=SystemEnv.getHtmlLabelName(23777 ,user.getLanguage())%>'>"
													+"</span>"
													+"</td>"
													+"</tr >"
													+"  <tr class=header><td><input type='checkbox' onclick='checkbox2(this,"+chtable+")'/><%=SystemEnv.getHtmlLabelName(556 ,user.getLanguage())%></td>"
													+" <td><%=SystemEnv.getHtmlLabelName(31731 ,user.getLanguage())%>"
													+"</td>"
													+" <td><%=SystemEnv.getHtmlLabelName(21934 ,user.getLanguage())%>"
													+"</td>"
													<%
														if("0".equals(w_type))
														{
													%> 
													+" <td><input type='checkbox' onclick=checkAllBox(this,4,2)><%=SystemEnv.getHtmlLabelName(15603 ,user.getLanguage())%>"
													+"</td>"
													+" <td><%=SystemEnv.getHtmlLabelName(15486 ,user.getLanguage())%>"
													+"</td>"
													<%
														}
													%> 

				
													//+" <td>参数方向"
													//+"</td>"
													+" <td><%=SystemEnv.getHtmlLabelName(31732 ,user.getLanguage())%>"
													+"</td>"
													+" <td><%=SystemEnv.getHtmlLabelName(21934 ,user.getLanguage())%>"
													+"</td>"
													+" <td><%=SystemEnv.getHtmlLabelName(453 ,user.getLanguage())%>"
													+"</td>"
													+"</tr>"
													//+"  <TR class=Line style='height:1px'><TD  style='padding:0px' colspan='11'></TD></TR>"
													+" </TABLE>");
											row.append("</td></tr>");
											var vTb=$("#sap_02");
											vTb.append(row); 
											//得到表格的行数
											//var temp=$("#chind02").get(0).rows.length;
											$("#hidden02").attr("value",chtable);
								}
							}
						}
					}
			$('body').jNice();
 	}
 	
 	
 	function addBathFieldObjCallback3(objjson,temp){
 		var type = objjson.type;
 		var source =objjson.source;
 		var stuname =objjson.chtable;
 		var chtable =objjson.chtable;
 		var backtable =objjson.backtable;
 		if(temp)
				{
		    	 	if (temp.id!="" && temp.id != 0)
		    	    {
							var tempsz=temp.id.split(",");
							var tempname=temp.name.split(",");
							for(var ij=0;ij<tempsz.length;ij++)
							{
								if(tempsz[ij])
								{
									//得到子表的对象
							 		var newtable=$("#sap_02"+"_"+chtable);
							 		var newchtable=parseInt($("#cbox2"+"_"+chtable).val())+1;
							 		var input01="sap02_"+chtable+"_"+newchtable;
						
									var input02="oa02_"+chtable+"_"+newchtable;
									var input03="con02_"+chtable+"_"+newchtable;
									var input01Span="sap02_"+chtable+"_"+newchtable+"Span";
									var input02Span="oa02_"+chtable+"_"+newchtable+"Span";
									var address="add02_"+chtable+"_"+newchtable;
									
									var inputSAP="show02_"+chtable+"_"+newchtable;
									var inputSAPSpan="show02_"+chtable+"_"+newchtable+"Span";
									
									var inputOA="OAshow02_"+chtable+"_"+newchtable;
									//是否显示
									var ishowField="ishowField02_"+chtable+"_"+newchtable;
									//是否只读
									var isrdField="isrdField02_"+chtable+"_"+newchtable;
									//排序字段
									var isorderby="isorderby02_"+chtable+"_"+newchtable;
										
									<%
										if("0".equals(w_type))
										{
									%> 
							 			var row = $("<tr class='DataDark'><td><input type='checkbox' name='zibox'></td>"
							 			+"<td><button type='button' class='e8_browflow' onclick=addOneFieldObjOA(this,0)></button><input type='hidden' name='"+input02+"'><span></span><span id='"+input02Span+"'></span><input type=hidden name='"+address+"'></td>"
							 			+"<td><span><input type='hidden' name='"+inputOA+"'  value=''></span></td>"
										+"<td><input type='checkbox' name='"+ishowField+"' value='1'></td>"
										+"<td><input type='text' name='"+isorderby+"' value='0' class='orderfield'></td>"
									//	+"<td><img src='/integration/images/jt_wev8.png' class='fx'></td>"
							 		
							 			+"<td><button type='button' class='e8_browflow' onclick=addOneFieldObj(3,this,'"+stuname+"')></button><input type='hidden' name='"+input01+"'  value='"+tempsz[ij]+"'><span>"+tempsz[ij]+"</span><span id='"+input01Span+"'></span></td>"
							 			+"<td><input type='text' name='"+inputSAP+"'  value='"+tempname[ij]+"'  onchange=checkinput('"+inputSAP+"','"+inputSAPSpan+"')><span id='"+inputSAPSpan+"'></span></td>"
							 			
							 			+"<td><input type='text' name='"+input03+"' class='constantfiedl'></td>"
							 			+"</tr>");
							 		 <%
										}else
										{
									%>
										var row = $("<tr class='DataDark'>"
										+"<td><input type='checkbox' name='zibox'></td>"
										+"<td>"
										+"<button type='button' class='e8_browflow' onclick=addOneFieldObjOA(this,0)></button>"
										+"<input type='hidden' name='"+input02+"'><span></span><span id='"+input02Span+"'></span>"
										+"<input type=hidden name='"+address+"'></td>"
										+"<td><span><input type='hidden' name='"+inputOA+"'  value=''></span></td>"
										+"<td><button type='button' class='e8_browflow' onclick=addOneFieldObj(3,this,'"+stuname+"')></button>"
										+"<input type='hidden' name='"+input01+"'  value='"+tempsz[ij]+"'><span>"+tempsz[ij]+"</span>"
										+"<span id='"+input01Span+"'></span></td>"
										+"<td>"+tempname[ij]+"<span><input type='hidden' name='"+inputSAP+"'  value='"+tempname[ij]+"' ></span></td>"
										+"<td><input type='text' name='"+input03+"'  class='constantfiedl'></td>"
										+"</tr>");
									<%
										}
									%> 
							 		newtable.append(row); 
							 		$("#cbox2"+"_"+chtable).attr("value",newchtable);
						 		}
						 	}
					 }
				 }
				 $('body').jNice();
 	}
 	
 	function addBathFieldObjCallback4(objjson,temp){
 		var type = objjson.type;
 		var source =objjson.source;
 		var stuname =objjson.chtable;
 		var chtable =objjson.chtable;
 		var backtable =objjson.backtable;
 		if(temp)
				{
		    	 	if (temp.id!="" && temp.id != 0)
		    	    {
							var tempsz=temp.id.split(",");
							var tempnames=temp.name.split(",");
							for(var ij=0;ij<tempsz.length;ij++)
							{
								if(tempsz[ij])
								{
									var shuzi=parseInt($("#hidden03").val())+1;
									var input01="sap03_"+shuzi;
									var input01Span="sap03_"+shuzi+"Span";
									var input02="show03_"+shuzi;//显示名--文本框
									var input02Span="show03_"+shuzi+"Span";//显示名--img
									var inputSAP="show03_"+shuzi;
									var inputOA="OAshow03_"+shuzi;
									var input03="dis03_"+shuzi;//是否显示
									var input04="setoa3_"+shuzi;
									var address="add03_"+shuzi;
									//var input04Span="setoa_"+shuzi+"Span";
									var vTb=$("#chind03");
									var row = $("<tr class='DataDark'></tr>"); 
									var showimg="";
									if(!tempnames[ij])//空字符串默认等于false
									{
										showimg="<img src='/images/BacoError_wev8.gif' align=absMiddle>";
									}
									<%
										if("0".equals(w_type))
										{
									%> 
										var td = $("<td><input type='checkbox' name='cbox3'></td>"
										+"<td><button type='button' class='e8_browflow' onclick=addOneFieldObj(4,this)></button>"
										+"<input type='hidden' name='"+input01+"'  id='"+input01+"' value='"+tempsz[ij]+"'><span>"+tempsz[ij]+"</span>"
										+"<span id='"+input01Span+"'></span></td>"
										+"<td><input type='text' name='"+input02+"' onchange=checkinput('"+input02+"','"+input02Span+"') value='"+tempnames[ij]+"'>"
										+"<span id='"+input02Span+"'>"+showimg+"</span></td>"
										+"<td><input type='checkbox' name="+input03+" value=1></td>"
										//+"<td><img src='/integration/images/jt_wev8.png' class='fx'></td>"
										+"<td>"
										
										+"<button type='button' class='e8_browflow' onclick=addOneFieldObjOA(this,0)></button>"
										+"<input type=hidden name='"+input04+"'/><span></span><span></span>"
										+"<input type=hidden name='"+address+"'/>"
										
										+"</td>"
										+"<td> <span><input type='hidden' name='"+inputOA+"' ></span></td>"
										);
										
									<%
										}else
										{
									%>
										var td = $("<td>"
										+"<input type='checkbox' name='cbox3'></td>"
										+"<td><button type='button' class='e8_browflow' onclick=addOneFieldObj(4,this)></button>"
										+"<input type='hidden' name='"+input01+"'  id='"+input01+"' value='"+tempsz[ij]+"'>"
										+"<span>"+tempsz[ij]+"</span>"
										+"<span id='"+input01Span+"'></span></td>"
										+"<td>"+tempnames[ij]+"<SPAN><INPUT name="+input02+" type=hidden value='"+tempnames[ij]+"'></SPAN></td>"
										+"<td><button type='button' class='e8_browflow' onclick=addOneFieldObjOA(this,0)></button>"
										+"<input type='hidden' name='"+input04+"'><span></span><span></span>"
										+"<input type=hidden name='"+address+"'>"
										+"</td>"
										+"<td><SPAN><INPUT name="+inputOA+" type=hidden></SPAN></td>");
									<%		
										}
									%> 
									 
									row.append(td); 
									vTb.append(row); 
									//得到表格的行数
									//var temp=$("#chind03").get(0).rows.length;
									$("#hidden03").attr("value",shuzi);
								}
							}
						}
				}
				$('body').jNice();
 	}
 	
 	function addBathFieldObjCallback5(objjson,temp){
 		var type = objjson.type;
 		var source =objjson.source;
 		var stuname =objjson.chtable;
 		var chtable =objjson.chtable;
 		var backtable =objjson.backtable;
 		if(temp)
				{
		    	 	if (temp.id!="" && temp.id != 0)
		    	    {
							var tempsz=temp.id.split(",");
							for(var ij=0;ij<tempsz.length;ij++)
							{
								if(tempsz[ij])
								{
									var chtable=parseInt($("#hidden04").val())+1;
									var newname="cbox4"+"_"+chtable;
									var newtable="sap_04"+"_"+chtable;
									var newstru="outstru_"+chtable;
									
								
					
									var newstruSpan="outstru_"+chtable+"Span";
									var bath="bath4_"+chtable;
									var row = $("<tr class='DataDark'><td class='tdcenter'><input type='checkbox' name='cbox4'></td>"); 	
											row.append("<td>"
												
											  
												
												+"<TABLE class=ListStyle cellspacing=1 id='"+newtable+"' > "
												+"<tr>"
												+"<td colspan='6'>"
												+"<span style='float:left'>"
												+"<%=SystemEnv.getHtmlLabelName(30609 ,user.getLanguage())%>"
											    +"<button type='button' class='e8_browflow' onclick=addOneFieldObj(5,this)></button>"
											    +"<input type='hidden' class='selectmax_width' id='"+newstru+"' name='"+newstru+"' value='"+tempsz[ij]+"' >"
											    +"<span>"+tempsz[ij]+"</span><span id='"+newstruSpan+"'></span>" 
												+" <input type='hidden' id='"+newname+"' name='"+newname+"' value='0'>"
												+"</span>"
												+"<span style='float:right'>"
												+"<input type='button'  class='addbtnB' id='"+bath+"' onclick=addBathFieldObj(6,1,'"+newstru+"','"+chtable+"') title='<%=SystemEnv.getHtmlLabelName(25055 ,user.getLanguage())%>'> "
												+"<input type='button' class='addbtn' onclick=addBathFieldObj(6,2,'"+newstru+"','"+chtable+"') title='<%=SystemEnv.getHtmlLabelName(611 ,user.getLanguage())%>'>"
												+"<input type='button' class='delbtn' onclick=addBathFieldObj(6,3,'"+newstru+"','"+chtable+"') title='<%=SystemEnv.getHtmlLabelName(23777 ,user.getLanguage())%>'>"
												+"</span>"
													
												+"</td>"
												+"</tr>"
												+"  <tr class=header><td><input type='checkbox' onclick='checkbox4(this,"+chtable+")'/><%=SystemEnv.getHtmlLabelName(556 ,user.getLanguage())%></td>"
												+"<td><%=SystemEnv.getHtmlLabelName(31732 ,user.getLanguage())%></td>"
												<%
													if("0".equals(w_type))
													{
												%> 
													+"<td><%=SystemEnv.getHtmlLabelName(606 ,user.getLanguage())%></td>"
													+"<td><input type='checkbox' onclick=checkAllBox(this,4,2)><%=SystemEnv.getHtmlLabelName(15603 ,user.getLanguage())%></td>"
												<%
													}else{
												%>
													+"<td><%=SystemEnv.getHtmlLabelName(21934 ,user.getLanguage())%></td>"
												<%
													}
												%> 
												//+"<td>参数方向</td>"
												+"<td><%=SystemEnv.getHtmlLabelName(31731 ,user.getLanguage())%></td>"
												+"<td><%=SystemEnv.getHtmlLabelName(21934 ,user.getLanguage())%></td>"
												
											
												+"</tr>"
												//+"  <TR class=Line style='height:1px'><TD  style='padding:0px' colspan='6'></TD></TR>"
												+" </TABLE>");
										row.append("</td></tr>");
										var vTb=$("#sap_04");
										vTb.append(row); 
										//var shuzi=parseInt(chtable)+1;
										//得到表格的行数
										$("#hidden04").attr("value",chtable);
									}
								}
					}
				}
				$('body').jNice();
 	}
 	
 	function addBathFieldObjCallback6(objjson,temp){
 		var type = objjson.type;
 		var source =objjson.source;
 		var stuname =objjson.chtable;
 		var chtable =objjson.chtable;
 		var backtable =objjson.backtable;
 		if(temp)
					{
			    	 	if (temp.id!="" && temp.id != 0)
			    	    {
								var tempsz=temp.id.split(",");
								var tempnames=temp.name.split(",");
								for(var ij=0;ij<tempsz.length;ij++)
								{
									if(tempsz[ij])
									{
									
													
										//得到子表的id
								 		var newtable=$("#sap_04"+"_"+chtable);
								 		var newchtable=parseInt($("#cbox4"+"_"+chtable).val())+1;
								 		var input01="sap04_"+chtable+"_"+newchtable;
								 		var input01Span="sap04_"+chtable+"_"+newchtable+"Span";
								 		
							 			var inputSAP="show04_"+chtable+"_"+newchtable;
										var inputOA="OAshow04_"+chtable+"_"+newchtable;
									
								 		var input02="show04_"+chtable+"_"+newchtable;//显示名--文本框
								 		var input02Span="show04_"+chtable+"_"+newchtable+"Span";//显示名--img
										var input03="dis04_"+chtable+"_"+newchtable;//是否显示
										var input04="sea04_"+chtable+"_"+newchtable;
										var input05="setoa4_"+chtable+"_"+newchtable;
										var address="add04_"+chtable+"_"+newchtable;
										var showimg="";
										if(!tempnames[ij])//空字符串默认等于false
										{
											showimg="<img src='/images/BacoError_wev8.gif' align=absMiddle>";
										}
										<%
											if("0".equals(w_type))
											{
										%> 
											var row = $("<tr class='DataDark'><td><input type='checkbox' name='zibox'></td>"
											
											+"<td><button type='button' class='e8_browflow' onclick=addOneFieldObj(6,this,'"+stuname+"')></button>"
											+"<input type='hidden' name='"+input01+"' value='"+tempsz[ij]+"'><span>"+tempsz[ij]+"</span><span id='"+input01Span+"'></span></td>"
											+"<td><input type='text' name='"+input02+"' onchange=checkinput('"+input02+"','"+input02Span+"') value='"+tempnames[ij]+"'>"
											+"<span id='"+input02Span+"'>"+showimg+"</span></td>"
											+"<td><input type='checkbox' name="+input03+" value=1></td>"
											//+"<td ><img src='/integration/images/jt_wev8.png' class='fx'></td>"
											+"<td><button type='button' class='e8_browflow' onclick=addOneFieldObjOA(this,0)></button>"
											+"<input type='hidden' name='"+input05+"'><span></span><span></span>"
											+"<input type=hidden name='"+address+"'>"
											+"</td>"
											+"<td><span><input type='hidden' name='"+inputOA+"' ></span></td>"
											+"</tr>");
										<%
											}else
											{
										%>
											var row = $("<tr class='DataDark'>"
											+"<td><input type='checkbox' name='zibox'></td>"
											+"<td><button type='button' class='e8_browflow' onclick=addOneFieldObj(6,this,'"+stuname+"')></button>"
											+"<input type='hidden' name='"+input01+"' value='"+tempsz[ij]+"'><span>"+tempsz[ij]+"</span>"
											+"<span id='"+input01Span+"'></span></td>"
											+"<td>"+tempnames[ij]+"<span><input type='hidden' name='"+input02+"'  value='"+tempnames[ij]+"'></span></td>"
											+"<td><button type='button' class='e8_browflow' onclick=addOneFieldObjOA(this,0)></button>"
											+"<input type='hidden' name='"+input05+"'><span></span><span></span>"
											+"<input type=hidden name='"+address+"'>"
											+"</td>"
											+"<td><span><input type='hidden' name='"+inputOA+"' ></span></td>"
											+"</tr>");
										<%		
											}
										%> 
								 		 
								 		newtable.append(row); 
								 		$("#cbox4"+"_"+chtable).attr("value",newchtable);
								 	}
								 }
						}
					}
				$('body').jNice();
 	}
 	
 	function addBathFieldObjCallback7(objjson,temp){
 		var type = objjson.type;
 		var source =objjson.source;
 		var stuname =objjson.chtable;
 		var chtable =objjson.chtable;
 		var backtable =objjson.backtable;
 		if(temp)
				{
		    	 	if (temp.id!="" && temp.id != 0)
		    	    {
							var tempsz=temp.id.split(",");
							for(var ij=0;ij<tempsz.length;ij++)
							{
								if(tempsz[ij])
								{
									var chtable=parseInt($("#hidden05").val())+1;
									var newname="cbox5"+"_"+chtable;
									var newtable="sap_05"+"_"+chtable;
									var newstru="outtable_"+chtable;
									var newstruSpan="outtable_"+chtable+"Span";
									var bath="bath5_"+chtable;
									var newtable05son="sapson_05_"+chtable;//where条件所在的表格
									var newtable05soncount="sapson_05count_"+chtable;//where条件总行数
									var backtable="backtable5_"+chtable;	//回写表
									var backoper="backoper5_"+chtable;	//回写操作
									
									
									<%
										if("0".equals(w_type))
										{
									%>
										var row ="<tr class='DataDark'><td class='tdcenter'><input type='checkbox' name='cbox5'></td>"; 	
											 row+="<td>"
											 	+" <TABLE class=ListStyle cellspacing=1 id='"+newtable+"' '>"
											 	+"<tr class='DataDark'>"
											 	+"<td  colspan=9>"
											 	+"<span style='float:left'>"
											 	+" <%=SystemEnv.getHtmlLabelName(21900 ,user.getLanguage())%><button type='button' class='e8_browflow' onclick=addOneFieldObj(7,this)></button><input type='hidden' class='selectmax_width' id='"+newstru+"' name='"+newstru+"' value='"+tempsz[ij]+"'><span>"+tempsz[ij]+"</span><span id='"+newstruSpan+"'></span>"
											 	+" <input type='hidden' id='"+newname+"' name='"+newname+"' value='0'>"
											 	+"</span>"
											 	+"<span style='float:right'>"
											 	+"<input type='button'  class='addbtnB' id='"+bath+"' onclick=addBathFieldObj(8,1,'"+newstru+"','"+chtable+"') title='<%=SystemEnv.getHtmlLabelName(25055 ,user.getLanguage())%>'> "
												+"<input type='button' class='addbtn' onclick=addBathFieldObj(8,2,'"+newstru+"','"+chtable+"') title='<%=SystemEnv.getHtmlLabelName(611 ,user.getLanguage())%>'>"
												+"<input type='button' class='delbtn' onclick=addBathFieldObj(8,3,'"+newstru+"','"+chtable+"') title='<%=SystemEnv.getHtmlLabelName(23777 ,user.getLanguage())%>'>"
												+"</span>"
												+"</td>"
												+"</tr>"
												+"  <tr class=header><td><input type='checkbox' onclick='checkbox5(this,"+chtable+")'/><%=SystemEnv.getHtmlLabelName(556 ,user.getLanguage())%></td>"
												+"<td><%=SystemEnv.getHtmlLabelName(31732 ,user.getLanguage())%>"
												+"</td>"
												+"<td><%=SystemEnv.getHtmlLabelName(606 ,user.getLanguage())%>"
												+"</td>"
												+"<td><%=SystemEnv.getHtmlLabelName(338 ,user.getLanguage())%>"
												+"</td>"
												+"<td> <input type='checkbox' onclick=checkAllBox(this,5,2)><%=SystemEnv.getHtmlLabelName(15603 ,user.getLanguage())%>"
												+"</td>"
												+"<td> <input type='checkbox' onclick=checkAllBox(this,6,2)><%=SystemEnv.getHtmlLabelName(31733 ,user.getLanguage())%>"
												+"</td>"
												+"<td> <input type='checkbox' onclick=checkAllBox(this,7,2)><%=SystemEnv.getHtmlLabelName(20331 ,user.getLanguage())%>"
												+"</td>"
												//+"<td>参数方向"
												//+"</td>"
												+"<td><%=SystemEnv.getHtmlLabelName(31731 ,user.getLanguage())%>"
												+"</td>"
												+"<td><%=SystemEnv.getHtmlLabelName(21934 ,user.getLanguage())%>"
												+"</td>"
												+"</tr>"
												//+"  <TR class=Line style='height:1px'><TD  style='padding:0px' colspan='9'></TD></TR>"
												+" </TABLE>"
												+" </td></tr>";
									<%
										}else
										{
									%>
									
									
										var row ="<tr class='DataDark'><td class='tdcenter'><input type='checkbox' name='cbox5'></td>"; 	
											row+="<td>"
											+" <TABLE class=ListStyle cellspacing=1 id='"+newtable+"'>"
											+"<tr>"
											+"<td colspan=9>"
											+"<span style='float:left'>"
											+"<%=SystemEnv.getHtmlLabelName(21900 ,user.getLanguage())%><button type='button' class='e8_browflow' onclick=addOneFieldObj(7,this)></button><input type='hidden' class='selectmax_width' id='"+newstru+"' name='"+newstru+"' value='"+tempsz[ij]+"'><span>"+tempsz[ij]+"</span><span id='"+newstruSpan+"'></span>"
											+"&nbsp;"
											+"<%=SystemEnv.getHtmlLabelName(30612 ,user.getLanguage())%><button type='button' class='e8_browflow' onclick=backtable(this)></button>" 
											+"<input type='hidden' name='"+backtable+"' id='"+backtable+"' ><span><img src='/images/BacoError_wev8.gif' align=absMiddle></span><span></span>"
											+"&nbsp;"
											+"<%=SystemEnv.getHtmlLabelName(30613 ,user.getLanguage())%><select name='"+backoper+"' id='"+backoper+"'>"
											+"<option value=0><%=SystemEnv.getHtmlLabelName(30614 ,user.getLanguage())%></option>"
											+"<option value=1><%=SystemEnv.getHtmlLabelName(30615 ,user.getLanguage())%></option>";
											<%
												if("1".equals(w_type)){
											%>
											row+="<option value=2><%=SystemEnv.getHtmlLabelName(103 ,user.getLanguage())%></option>"
											+"<option value=3><%=SystemEnv.getHtmlLabelName(23777 ,user.getLanguage())%></option>";
											<%
												}
											%>
											row+="</select></span>"
											+"<span style='float:right'>"
											+"<input type='button'  class='addbtnB' id='"+bath+"' onclick=addBathFieldObj(8,1,'"+newstru+"','"+chtable+"','"+backtable+"') "
											+" title='<%=SystemEnv.getHtmlLabelName(25055 ,user.getLanguage())%>'> "
											+"<input type='button' class='addbtn' onclick=addBathFieldObj(8,2,'"+newstru+"','"+chtable+"','"+backtable+"') "
											+" title='<%=SystemEnv.getHtmlLabelName(611 ,user.getLanguage())%>'>"
											+"<input type='button' class='delbtn' onclick=addBathFieldObj(8,3,'"+newstru+"','"+chtable+"') "
											+" title='<%=SystemEnv.getHtmlLabelName(23777 ,user.getLanguage())%>'>"
											+" <input type='hidden' id='"+newname+"' name='"+newname+"' value='0'>"
											+"</span>"
											+"</td>"
											+"</tr>"
											+"  <tr class=header>"
											+"<td><input type='checkbox' onclick='checkbox5(this,"+chtable+")'/>"
											+"<%=SystemEnv.getHtmlLabelName(556 ,user.getLanguage())%></td>"
											+"<td><%=SystemEnv.getHtmlLabelName(31732 ,user.getLanguage())%>"
											+"</td>"
											+"<td><%=SystemEnv.getHtmlLabelName(21934 ,user.getLanguage())%>"
											+"</td>"
											+"<td><%=SystemEnv.getHtmlLabelName(31731 ,user.getLanguage())%>"
											+"</td>"
											+"<td><%=SystemEnv.getHtmlLabelName(21934 ,user.getLanguage())%>"
											+"</td>"
											
											+"</tr>"
											//+"  <TR class=Line style='height:1px'><TD  style='padding:0px' colspan='9'></TD></TR>"
											+" </TABLE>"
											+" <TABLE class=ListStyle cellspacing=1 id='"+newtable05son+"'> "
											+" <tr class='DataDark'> "
											+" <td colspan=6>"
											+"<span style='float:left'>"
											+" <%=SystemEnv.getHtmlLabelName(30616 ,user.getLanguage())%>"
											+"</span>"
											+"<span style='float:right'>"
											+" <input type='button'  class='addbtnB' onclick=addBathFieldObj(12,1,'"+newstru+"','"+chtable+"','"+backtable+"') "
											+" title='<%=SystemEnv.getHtmlLabelName(25055 ,user.getLanguage())%>'> "
											+"<input type='button' class='addbtn' onclick=addBathFieldObj(12,2,'"+newstru+"','"+chtable+"','"+backtable+"') "
											+" title='<%=SystemEnv.getHtmlLabelName(611 ,user.getLanguage())%>'>"
											+"<input type='button' class='delbtn' onclick=addBathFieldObj(12,3,'"+newstru+"','"+chtable+"') "
											+" title='<%=SystemEnv.getHtmlLabelName(23777 ,user.getLanguage())%>'>"
											+"<input type='hidden' name='"+newtable05soncount+"' id='"+newtable05soncount+"' value='0'> "
											+"</span>"
											+" </td>"
											
											+" </tr>"
											+" <tr class=header>"
											+" <td>"
											+" <input type=checkbox onclick='checkbox5son(this,"+chtable+")'<%=SystemEnv.getHtmlLabelName(556 ,user.getLanguage())%>"
											+" </td>"
											+" <td>"
											+" <%=SystemEnv.getHtmlLabelName(30617 ,user.getLanguage())%>"
											+" </td>"
											+" <td>"
											+" <%=SystemEnv.getHtmlLabelName(21934 ,user.getLanguage())%>"
											+" </td>"
											+" <td>"
											+" <%=SystemEnv.getHtmlLabelName(30618 ,user.getLanguage())%>"
											+" </td>"
											
											+" <td>"
											+" <%=SystemEnv.getHtmlLabelName(21934 ,user.getLanguage())%>"
											+" </td>"
											+" <td>"
											+" <%=SystemEnv.getHtmlLabelName(453 ,user.getLanguage())%>"
											+" </td>"
											+" </tr>"
											+" </td></tr>";
											
							
									<%		
										}
									%>
										var vTb=$("#sap_05");
										vTb.append(row); 
										//var shuzi=parseInt(chtable)+1;
										//得到表格的行数
										$("#hidden05").attr("value",chtable);
								}
							 }
						}
				}
				$('body').jNice();
 	}
 	
 	function addBathFieldObjCallback8(objjson,temp){
 		var type = objjson.type;
 		var source =objjson.source;
 		var stuname =objjson.chtable;
 		var chtable =objjson.chtable;
 		var backtable =objjson.backtable;
 		if(temp)
				{
		    	 	if (temp.id!="" && temp.id != 0)
		    	    {
							var tempsz=temp.id.split(",");
							var tempnames=temp.name.split(",");
							for(var ij=0;ij<tempsz.length;ij++)
							{
								if(tempsz[ij])
								{
								
									//得到子表的id
							 		var newtable=$("#sap_05"+"_"+chtable);
							 		var newchtable=parseInt($("#cbox5"+"_"+chtable).val())+1;
							 		var input01="sap05_"+chtable+"_"+newchtable;
							 		var input02="show05_"+chtable+"_"+newchtable;
							 		
							 		var inputSAP="show05_"+chtable+"_"+newchtable;
									var inputOA="OAshow05_"+chtable+"_"+newchtable;
									var isorderby="isorderby05_"+chtable+"_"+newchtable;
					
							 		var input01Span="sap05_"+chtable+"_"+newchtable+"Span";
							 		var input02Span="show05_"+chtable+"_"+newchtable+"Span";
									var input03="dis05_"+chtable+"_"+newchtable;
									var input04="sea05_"+chtable+"_"+newchtable;
									var input05="key05_"+chtable+"_"+newchtable;
									var input06="setoa5_"+chtable+"_"+newchtable;
									var address="add05_"+chtable+"_"+newchtable;
									var showimg="";
									if(!tempnames[ij])//空字符串默认等于false
									{
										showimg="<img src='/images/BacoError_wev8.gif' align=absMiddle>";
									}
									
									<%
										if("0".equals(w_type))
										{
									%> 
										var row = $("<tr class='DataDark'><td><input type='checkbox' name='zibox'></td>"
									
										
										+"<td><button type='button' class='e8_browflow' onclick=addOneFieldObj(8,this,'"+stuname+"')></button>"
										+"<input type='hidden' name='"+input01+"' value='"+tempsz[ij]+"'/><span>"+tempsz[ij]+"</span>"
										+"<span id='"+input01Span+"'></span></td>"
										+"<td><input type='text' name='"+input02+"' onchange=checkinput('"+input02+"','"+input02Span+"') value='"+tempnames[ij]+"'>"
										+"<span id='"+input02Span+"'>"+showimg+"</span></td>"
										+"<td><input type='text' name='"+isorderby+"' value='0' class='orderfield'></td>"
										+"<td><input type='checkbox' name="+input03+" value=1></td>"
										+"<td>"
										+"<input type='checkbox' name='"+input05+"' value=1></td>"
										+"<td>"
										+"<input type='checkbox' name='"+input04+"' value=1></td>"
										//+"<td><img src='/integration/images/jt_wev8.png' class='fx'></td>"
										+"<td>"
										+"<button type='button' class='e8_browflow' onclick=addOneFieldObjOA(this,0)></button>"
										+"<input type='hidden' name='"+input06+"'><span></span><span></span>"
										+"<input type=hidden name='"+address+"'>"
										+"</td>"
										+"<td><span><input type='hidden' name='"+inputOA+"' ></span></td>"
										+"</tr>");
									<%
										}else
										{
									%>
										var row = $("<tr class='DataDark'>"
										+"<td><input type='checkbox' name='zibox'></td>"
										+"<td><button type='button' class='e8_browflow' onclick=addOneFieldObj(8,this,'"+stuname+"')></button>"
										+"<input type='hidden' name='"+input01+"' value='"+tempsz[ij]+"'/><span>"+tempsz[ij]+"</span>"
										+"<span id='"+input01Span+"'></span></td>"
										+"<td>"+tempnames[ij]+"<span><input type='hidden' name='"+input02+"' value='"+tempnames[ij]+"'></span></td>"
										+"<td><button type='button' class='e8_browflow' onclick=addOneFieldObjOA(this,'','"+backtable+"')></button>"
										+"<input type='hidden' name='"+input06+"'><span></span>"
										+"<span><img src='/images/BacoError_wev8.gif' align=absMiddle></span>"
										+"<input type=hidden name='"+address+"'>"
										+"</td>"
										+"<td><span><input type='hidden' name='"+inputOA+"' ></span></td>"
										+"</tr>");
									<%		
										}
									%> 
										
							 		 
							 		newtable.append(row); 
							 		$("#cbox5"+"_"+chtable).attr("value",newchtable);
							 	}
							 }
					}
				}
				$('body').jNice();
 	}
 	
 	
 	function addBathFieldObjCallback10(objjson,temp){
 		var type = objjson.type;
 		var source =objjson.source;
 		var stuname =objjson.chtable;
 		var chtable =objjson.chtable;
 		var backtable =objjson.backtable;
 		if(temp)
				{
		    	 	if (temp.id!="" && temp.id != 0)
		    	    {
							var tempsz=temp.id.split(",");
							for(var ij=0;ij<tempsz.length;ij++)
							{
								if(tempsz[ij])
								{
									var chtable=parseInt($("#hidden07").val())+1;
									var newname="cbox7"+"_"+chtable;
									var newtable="sap_07"+"_"+chtable;
									var newstru="outtable7_"+chtable;
									var backtable="backtable7_"+chtable;	//写入表
									var newstruSpan="outtable7_"+chtable+"Span";
									var bath="bath7_"+chtable;
									var row = $("<tr class='DataDark'><td class='tdcenter'><input type='checkbox' name='cbox7'></td>"); 	
										row.append("<td>" 
												+"  <TABLE class=ListStyle cellspacing=1 id='"+newtable+"'>"
												+"<tr>"
												+"<td colspan=9>"
												+"<span style='float:left'>"
												+"<%=SystemEnv.getHtmlLabelName(21900 ,user.getLanguage())%><button type='button' class='e8_browflow' onclick=addOneFieldObj(10,this)></button><input type='hidden' class='selectmax_width' id='"+newstru+"' name='"+newstru+"' value='"+tempsz[ij]+"' ><span>"+tempsz[ij]+"</span> <span id='"+newstruSpan+"'></span>"
												+" <input type='hidden' id='"+newname+"' name='"+newname+"' value='0'>"
												+"<%=SystemEnv.getHtmlLabelName(31734 ,user.getLanguage())%><button type='button' class='e8_browflow' onclick=backtable(this)></button>"
												+"<input type='hidden' name='"+backtable+"' id='"+backtable+"' ><span></span><span><img src='/images/BacoError_wev8.gif' align=absMiddle></span>"
												+"</span>"
												+"<span style='float:right'>"
												+"<input type='button'  class='addbtnB' id='"+bath+"' onclick=addBathFieldObj(11,1,'"+newstru+"','"+chtable+"','"+backtable+"') "
												+" title='<%=SystemEnv.getHtmlLabelName(25055 ,user.getLanguage())%>'> "
												+"<input type='button' class='addbtn' onclick=addBathFieldObj(11,2,'"+newstru+"','"+chtable+"','"+backtable+"') "
												+" title='<%=SystemEnv.getHtmlLabelName(611 ,user.getLanguage())%>'>"
												+"<input type='button' class='delbtn' onclick=addBathFieldObj(11,3,'"+newstru+"','"+chtable+"') "
												+" title='<%=SystemEnv.getHtmlLabelName(23777 ,user.getLanguage())%>'>"
												+"</span>"
												+"</td>"
												+"</tr>"
												+"  <tr class=header>"
												+"<td><input type='checkbox' onclick='checkbox7(this,"+chtable+")'/><%=SystemEnv.getHtmlLabelName(556 ,user.getLanguage())%></td>"
												+"<td><%=SystemEnv.getHtmlLabelName(31731 ,user.getLanguage())%></td>"
												+"<td><%=SystemEnv.getHtmlLabelName(21934 ,user.getLanguage())%></td>"
												+"<td><%=SystemEnv.getHtmlLabelName(31732 ,user.getLanguage())%></td>"
												+"<td><%=SystemEnv.getHtmlLabelName(21934 ,user.getLanguage())%></td>"
												+"<td><%=SystemEnv.getHtmlLabelName(453 ,user.getLanguage())%></td>"
												+"</tr>"
												//+"  <TR class=Line style='height:1px'><TD  style='padding:0px' colspan='9'></TD></TR>"
												+" </TABLE>");
										row.append("</td></tr>");
										var vTb=$("#sap_07");
										vTb.append(row); 
										//得到表格的行数
										$("#hidden07").attr("value",chtable);
								}
							 }
						}
				}
				$('body').jNice();
 	}
 	
 	
 	function addBathFieldObjCallback11(objjson,temp){
 		var type = objjson.type;
 		var source =objjson.source;
 		var stuname =objjson.chtable;
 		var chtable =objjson.chtable;
 		var backtable =objjson.backtable;
 		if(temp)
				{
		    	 	if (temp.id!="" && temp.id != 0)
		    	    {
							var tempsz=temp.id.split(",");
							var tempnames=temp.name.split(",");
							for(var ij=0;ij<tempsz.length;ij++)
							{
								if(tempsz[ij])
								{
									//得到子表的id
							 		var newtable=$("#sap_07"+"_"+chtable);
							 		var newchtable=parseInt($("#cbox7"+"_"+chtable).val())+1;
							 		var input01="sap07_"+chtable+"_"+newchtable;
							 		var input02="show07_"+chtable+"_"+newchtable;
							 		var input01Span="sap07_"+chtable+"_"+newchtable+"Span";
							 		var input02Span="show07_"+chtable+"_"+newchtable+"Span";
									var input03="con07_"+chtable+"_"+newchtable;
									var input03Span="con07_"+chtable+"_"+newchtable+"Span";
									var input06="setoa7_"+chtable+"_"+newchtable;
									var input06Span="setoa7_"+chtable+"_"+newchtable+"Span";
									var address="add07_"+chtable+"_"+newchtable;
									
									var inputOA="OAshow07_"+chtable+"_"+newchtable;
									//是否显示
									var ishowField="ishowField07_"+chtable+"_"+newchtable;
									//是否只读
									var isrdField="isrdField07_"+chtable+"_"+newchtable;
									//排序字段
									var isorderby="isorderby07_"+chtable+"_"+newchtable;
						
									var showimg="";
									if(!tempnames[ij])//空字符串默认等于false
									{
										showimg="<img src='/images/BacoError_wev8.gif' align=absMiddle>";
									}
							 		var row = $("<tr class='DataDark'>"
							 		+"<td><input type='checkbox' name='zibox'></td>"
							 		+"<td>"
							 		+"<button type='button' class='e8_browflow' onclick=addOneFieldObjOA(this,'0','"+backtable+"')></button>"
							 		+"<input type='hidden' name='"+input06+"'><span></span><span id='"+input06Span+"'></span>"
							 		+"<input type=hidden name='"+address+"'></td>"
							 		+"<td><SPAN><INPUT name="+inputOA+" type=hidden></SPAN></td>"
							 		+"<td><button type='button' class='e8_browflow' onclick=addOneFieldObj(11,this,'"+stuname+"')></button>"
							 		+"<input type='hidden' name='"+input01+"' value='"+tempsz[ij]+"' onchange=checkinput('"+input01+"','"+input01Span+"')>"
							 		+"<span id='"+input01Span+"'>"+tempsz[ij]+"</span><span id='"+input01Span+"'></span>"
							 		+"</td>"
							 		+"<td>"+tempnames[ij]+"<SPAN><INPUT name="+input02+" type=hidden value='"+tempnames[ij]+"'></SPAN></td>"
							 		+"<td><input type='text' name='"+input03+"' class='constantfiedl' >"
							 		+"</td></tr>"); 
							 		newtable.append(row); 
							 		$("#cbox7"+"_"+chtable).attr("value",newchtable);
							 	}
							 }
					}
				}
				$('body').jNice();
 	}
 	
 	function addBathFieldObjCallback12(objjson,temp){
 		var type = objjson.type;
 		var source =objjson.source;
 		var stuname =objjson.chtable;
 		var chtable =objjson.chtable;
 		var backtable =objjson.backtable;
 		if(temp)
		{
    	 	if (temp.id!="" && temp.id != 0)
    	    {
					var tempsz=temp.id.split(",");
					var tempnames=temp.name.split(",");
					for(var ij=0;ij<tempsz.length;ij++)
					{
						if(tempsz[ij])
						{
								var newtable=$("#sapson_05_"+chtable);
				 				var newchtable=parseInt($("#sapson_05count_"+chtable).val())+1;
				 				var input01="sap05son_"+chtable+"_"+newchtable;
								var input02="set05son_"+chtable+"_"+newchtable;
								var input03="add05son_"+chtable+"_"+newchtable;
								var input04="con05son_"+chtable+"_"+newchtable;
								
								var inputSAP="show05son_"+chtable+"_"+newchtable;
								var inputOA="OAshow05son_"+chtable+"_"+newchtable;
								
				 				var row="<tr class='DataDark'><td><input type='checkbox' name='zibox'></td>";
								row+="<td><button type='button' class='e8_browflow' onclick=addOneFieldObj(8,this,'"+stuname+"')></button>"
									+"<input type='hidden' name='"+input01+"' value='"+tempsz[ij]+"'><span>"+tempsz[ij]+"</span><span></span></td>"
									+"<td>"+tempnames[ij]+"<SPAN><INPUT name="+inputSAP+" type=hidden value='"+tempnames[ij]+"'></SPAN></td>"
									+"<td> <button type='button' class='e8_browflow' onclick=addOneFieldObjOA(this,'0','"+backtable+"')></button>"
									+"<input type='hidden' name='"+input02+"'/><span></span><span></span>"
									+"<input type=hidden name='"+input03+"'></td>"
									+"<td><SPAN><INPUT name="+inputOA+" type=hidden></SPAN></td>"
									+"<td ><input type='text' name='"+input04+"' class='constantfiedl'></td>"
									+"</tr>";
						 		newtable.append(row); 
						 		$("#sapson_05count_"+chtable).attr("value",newchtable);
						
						}
					}
			}
		}
				$('body').jNice();
 	}
 	//所有批量字段操作
 	//backtable表示：回写表
 	//type=1表示输入参数,source=1(点击批量按钮),source=2(点击添加按钮),source=3(点击删除按钮)
 	//type=2表示输入结构,source=1(点击批量按钮),source=2(点击添加按钮),source=3(点击删除按钮)
 	//type=3表示输入结构,source=1(点击批量按钮),source=2(点击添加按钮),source=3(点击删除按钮),stuname(结构体的名称所在的文本框的id)必须有值,chtable(结构体的流水编号)必须有值
 	//type=4表示输出参数，source=1(点击批量按钮),source=2(点击添加按钮),source=3(点击删除按钮)
 	//type=5表示输出结构,source=1(点击批量按钮),source=2(点击添加按钮),source=3(点击删除按钮)
 	//type=6表示输出结构,source=1(点击批量按钮),source=2(点击添加按钮),source=3(点击删除按钮),stuname(结构体的名称所在的文本框的id)必须有值
 	//type=7表示输出表,source=1(点击批量按钮),source=2(点击添加按钮),source=3(点击删除按钮)
 	//type=8表示输出表,source=1(点击批量按钮),source=2(点击添加按钮),source=3(点击删除按钮),stuname(输出表的名称所在的文本框的id)必须有值
 	//type=9表示内容权限设置,source=1(点击批量按钮),source=2(点击添加按钮),source=3(点击删除按钮)
 	//type=10表示输入表,source=1(点击批量按钮),source=2(点击添加按钮),source=3(点击删除按钮)
 	//type=11表示输入表,source=1(点击批量按钮),source=2(点击添加按钮),source=3(点击删除按钮),stuname(输入表的名称所在的文本框的id)必须有值
 	//type=12表示输出表的where条件管理表
 	
 	function addBathFieldObj(type,source,stuname,chtable,backtable)
 	{
		var islocal=$("#islocal").val();//判断本地获取参数，还是远程获取参数
 		if(type=="1")
 		{
 				if(source=="1")
 				{
 						var dialog = new window.top.Dialog();
 						dialog.currentWindow = window;
						dialog.Title = "SAP<%=SystemEnv.getHtmlLabelName(561,user.getLanguage())%> ";
					    dialog.URL = "/integration/browse/BrowserMain.jsp?url=/integration/browse/integrationBatchSap.jsp?type="+type+"&regservice=<%=regservice%>&islocal="+islocal;
						dialog.Width = 660;
						dialog.Height = 660;
						dialog.Drag = true;
						dialog.callbackfun=addBathFieldObjCallback;
				 		dialog.callbackfunParam={type:type,source:source,backtable:backtable,chtable:chtable,stuname:stuname};
						dialog.textAlign = "center";
						dialog.show();
						
 				}else if(source=="2")
 				{
 						var shuzi=parseInt($("#hidden01").val())+1;
						var input01="sap01_"+shuzi;
						var input01Span="sap01_"+shuzi+"Span";
						var input02="oa01_"+shuzi;
						var inputSAP="show01_"+shuzi;
						var inputSAPSpan="show01_"+shuzi+"Span";
						var input02Span="oa01_"+shuzi+"Span";
						var input03="con01_"+shuzi;
						var vTb=$("#chind01");
						var address="add01_"+shuzi;
						
						var inputOA="OAshow01_"+shuzi;
						//是否显示
						var ishowField="ishowField01_"+shuzi;
						//是否只读
						var isrdField="isrdField01_"+shuzi;
						//排序字段
						var isorderby="isorderby01_"+shuzi;
										
						var row = $("<tr class='DataDark'></tr>");
						<%
							if("0".equals(w_type))
							{
						%> 
							var td = $("<td><input type='checkbox' name='cbox1'></td>"
							+"<td><button type='button' class='e8_browflow' onclick=addOneFieldObjOA(this,0)></button><input type='hidden' name='"+input02+"'> <span></span><span id='"+input02Span+"'></span><input type=hidden name='"+address+"'></td>"
							+"<td><span><input type='hidden' name='"+inputOA+"'  value=''></span></td>"
							+"<td><input type='checkbox' name='"+ishowField+"' value='1'></td>"
							+"<td><input type='text' name='"+isorderby+"' value='0' class='orderfield'></td>"
							//+"<td><img src='/integration/images/jt_wev8.png' class='fx'></td>"
							+"<td><button type='button' class='e8_browflow' onclick=addOneFieldObj(1,this)></button><input type='hidden' name='"+input01+"' ><span></span> <span id='"+input01Span+"'><img src='/images/BacoError_wev8.gif' align=absMiddle></span></td>"
							+"<td><input type='text' name='"+inputSAP+"'   onchange=checkinput('"+inputSAP+"','"+inputSAPSpan+"')><span id='"+inputSAPSpan+"'><img src='/images/BacoError_wev8.gif' align=absMiddle></span></td>"
							
							+"<td><input type='text' name='"+input03+"' class='constantfiedl'></td>");
						 <%
							}else
							{
						%> 
							var td = $("<td><input type='checkbox' name='cbox1'></td>"
							+"<td><button type='button' class='e8_browflow' onclick=addOneFieldObjOA(this,0)></button>"
							+"<input type='hidden' name='"+input02+"'> <span></span>"
							+"<span id='"+input02Span+"'></span><input type=hidden name='"+address+"'></td>"
							+"<td><span><input type='hidden' name='"+inputOA+"'  value=''></span></td>"
							+"<td><button type='button' class='e8_browflow' onclick=addOneFieldObj(1,this)></button>"
							+"<input type='hidden' name='"+input01+"' ><span></span> "
							+"<span id='"+input01Span+"'><img src='/images/BacoError_wev8.gif' align=absMiddle></span></td>"
							+"<td><span><input type='hidden' name='"+inputSAP+"'   value=''></span></td>"
							+"<td><input type='text' name='"+input03+"' class='constantfiedl'></td>");
						<%		
							}
						%>
										
						row.append(td); 
						vTb.append(row); 
						//得到表格的行数
						//var temp=$("#chind01").get(0).rows.length;
						$("#hidden01").attr("value",shuzi);
 				}else if(source=="3")
 				{
						var vTb=$("#chind01");
						//var checked = $("#chind01 input:checked[type='checkbox'][name='cbox1'][checked='true']"); 
						var checked = $("#chind01 input:checked[type='checkbox'][name='cbox1']"); 
						if(checked.length>0){ 
							if(window.confirm("<%=SystemEnv.getHtmlLabelName(30695 ,user.getLanguage())%>!")){
							$(checked).each(function(){ 
								if($(this).attr("checked")==true) 
								{ 
									$(this).parents("tr:first").remove(); 
									//var shuzi=parseInt($("#hidden01").val())-1;
									//得到表格的行数
									//var temp=$("#chind01").get(0).rows.length;
									//$("#hidden01").attr("value",shuzi);
								} 
							}); 
						}
						}else{
							alert("<%=SystemEnv.getHtmlLabelName(30993 ,user.getLanguage())%>！");
						}
 				}
 					
 		}else if(type=="2")
 		{
 			if(source=="1")
 			{
 					var dialog = new window.top.Dialog();
					dialog.currentWindow = window;
					dialog.Title = "SAP<%=SystemEnv.getHtmlLabelName(561,user.getLanguage()) %>";
				    dialog.URL = "/integration/browse/BrowserMain.jsp?url=/integration/browse/integrationBatchSap.jsp?type="+type+"&regservice=<%=regservice%>&islocal="+islocal;
					dialog.Width = 660;
					dialog.Height = 660;
					dialog.Drag = true;
					dialog.callbackfun=addBathFieldObjCallback2;
			 		dialog.callbackfunParam={type:type,source:source,backtable:backtable,chtable:chtable,stuname:stuname};
					dialog.textAlign = "center";
					dialog.show();
 					
 			}else if(source=="2")
 			{
 				// <COLGROUP><COL width='60px'/><COL width='80px'/><COL width='180px'/><COL width='80px'/><COL width='180px'/><COL width='60px'/><COL width='*'/></COLGROUP>
				//style='table-layout: fixed;'
				var chtable=parseInt($("#hidden02").val())+1;
				
				var shuzi=parseInt(chtable)+1;
				var newname="cbox2"+"_"+chtable;
				var newtable="sap_02"+"_"+chtable;
				var newstru="stru_"+chtable;
				var newstruSpan="stru_"+chtable+"Span";
				var bath="bath2_"+chtable;
				var row = $("<tr class='DataDark'><td class='tdcenter'><input type='checkbox' name='cbox2'></td>"); 	
					row.append("<td>"
							
							
							+"<TABLE class='ListStyle' cellspacing=1 id='"+newtable+"' >"
							+"<tr class=''>"
							+"<td colspan='10' >"
							+"<span style='float:left'>"
							+"<%=SystemEnv.getHtmlLabelName(30609 ,user.getLanguage())%>"
							+"<button type='button' class='e8_browflow' onclick=addOneFieldObj(2,this,'"+newstru+"')></button>"
							+"<input type='hidden' class='selectmax_width' name='"+newstru+"' id='"+newstru+"'><span></span>"
							+"<span id='"+newstruSpan+"'><img src='/images/BacoError_wev8.gif' align=absMiddle></span>" 
							+" <input type='hidden' id='"+newname+"' name='"+newname+"' value='0'>"
							+"</span>"
							+"<span style='float:right'>"
							+"<input type='button'  class='addbtnB' id='"+bath+"' onclick=addBathFieldObj(3,1,'"+newstru+"','"+chtable+"')"
							+" title='<%=SystemEnv.getHtmlLabelName(25055 ,user.getLanguage())%>'> "
							+"<input type='button' class='addbtn' onclick=addBathFieldObj(3,2,'"+newstru+"','"+chtable+"')"
							+" title='<%=SystemEnv.getHtmlLabelName(611 ,user.getLanguage())%>'>"
							+"<input type='button' class='delbtn' onclick=addBathFieldObj(3,3,'"+newstru+"','"+chtable+"')"
							+" title='<%=SystemEnv.getHtmlLabelName(23777 ,user.getLanguage())%>'>"						
							+"</span>"
							+"</td>"
							+"</tr>"
							+"  <tr class=header>"
							+"<td><input type='checkbox' onclick='checkbox2(this,"+chtable+")'/>"
							+"<%=SystemEnv.getHtmlLabelName(556 ,user.getLanguage())%></td>"
							+" <td><%=SystemEnv.getHtmlLabelName(31731 ,user.getLanguage())%>"
							+"</td>"
							+" <td><%=SystemEnv.getHtmlLabelName(21934 ,user.getLanguage())%>"
							+"</td>"
							<%
								if("0".equals(w_type))
								{
							%> 
							+" <td><input type='checkbox' onclick=checkAllBox(this,4,2)><%=SystemEnv.getHtmlLabelName(15603 ,user.getLanguage())%>"
							+"</td>"
							+" <td><%=SystemEnv.getHtmlLabelName(15486 ,user.getLanguage())%>"
							+"</td>"
							<%
								}
							%> 
	
							//+" <td>参数方向"
							//+"</td>"
							+" <td><%=SystemEnv.getHtmlLabelName(31732 ,user.getLanguage())%>"
							+"</td>"
							+" <td><%=SystemEnv.getHtmlLabelName(21934 ,user.getLanguage())%>"
							+"</td>"
							+" <td><%=SystemEnv.getHtmlLabelName(453 ,user.getLanguage())%>"
							+"</td>"
							
							+"</tr>"
							//+"  <TR class=Line style='height:1px'><td colspan=11></td></TR>"
							+" </TABLE>");
					row.append("</td></tr>");
					var vTb=$("#sap_02");
					vTb.append(row); 
					//得到表格的行数
					//var temp=$("#chind02").get(0).rows.length;
					$("#hidden02").attr("value",chtable);
 			}else if(source=="3")
 			{
 					var vTb=$("#sap_02");
					//var checked = $("#sap_02 input[type='checkbox'][name='cbox2'][checked=true]"); 
					var checked = $("#sap_02 input:checked[type='checkbox'][name='cbox2']"); 
					if(checked.length>0){ 
					if(window.confirm("<%=SystemEnv.getHtmlLabelName(30695 ,user.getLanguage())%>!")){
						$(checked).each(function(){ 
							if($(this).attr("checked")==true) 
							{ 
								$(this).parents("tr:first").remove(); 
							} 
						}); 
					}
					}else{
							alert("<%=SystemEnv.getHtmlLabelName(30993 ,user.getLanguage())%>！");
					}
 			}
 		}else if(type=="3")
 		{
 			if(source=="1")
 			{
 				
 				var stuortablevalue=$("#"+stuname).val()
 				
 				var dialog = new window.top.Dialog();
					dialog.currentWindow = window;
					dialog.Title = "SAP<%=SystemEnv.getHtmlLabelName(561,user.getLanguage()) %>";
				    dialog.URL = "/integration/browse/BrowserMain.jsp?url=/integration/browse/integrationBatchSap.jsp?type="+type+"&stuortablevalue="+stuortablevalue+"&regservice=<%=regservice%>&islocal="+islocal;
					dialog.Width = 660;
					dialog.Height = 660;
					dialog.Drag = true;
					dialog.callbackfun=addBathFieldObjCallback3;
			 		dialog.callbackfunParam={type:type,source:source,backtable:backtable,chtable:chtable,stuname:stuname};
					dialog.textAlign = "center";
					dialog.show();
 				
 			}else if(source=="2")
 			{
 				 		//得到子表的对象
					 		var newtable=$("#sap_02"+"_"+chtable);
					 		var newchtable=parseInt($("#cbox2"+"_"+chtable).val())+1;
					 		var input01="sap02_"+chtable+"_"+newchtable;
							var input02="oa02_"+chtable+"_"+newchtable;
							var inputSAP="show02_"+chtable+"_"+newchtable;
							var inputSAPSpan="show02_"+chtable+"_"+newchtable+"Span";
							var inputOA="OAshow02_"+chtable+"_"+newchtable;
							var input03="con02_"+chtable+"_"+newchtable;
							var input01Span="sap02_"+chtable+"_"+newchtable+"Span";
							var input02Span="oa02_"+chtable+"_"+newchtable+"Span";
							var address="add02_"+chtable+"_"+newchtable;
							//是否显示
							var ishowField="ishowField02_"+chtable+"_"+newchtable;
							//是否只读
							var isrdField="isrdField02_"+chtable+"_"+newchtable;
							//排序字段
							var isorderby="isorderby02_"+chtable+"_"+newchtable;
							<%
								if("0".equals(w_type))
								{
							%> 
					 			var row = $("<tr><td><input type='checkbox' name='zibox'></td>"
					 			+"<td><button type='button' class='e8_browflow' onclick=addOneFieldObjOA(this,0)></button><input type='hidden' name='"+input02+"'><span></span><span id='"+input02Span+"'></span><input type=hidden name='"+address+"'></td>"
					 			+"<td><span><input type='hidden' name='"+inputOA+"'  value=''></span></td>"
					 			+"<td><input type='checkbox' name='"+ishowField+"' value='1'></td>"
								+"<td><input type='text' name='"+isorderby+"' value='0' class='orderfield'></td>"
					 			//+"<td><img src='/integration/images/jt_wev8.png' class='fx'></td>"
					 		
					 			+"<td><button type='button' class='e8_browflow' onclick=addOneFieldObj(3,this,'"+stuname+"') ></button><input type='hidden' name='"+input01+"'><span></span><span id='"+input01Span+"'><img src='/images/BacoError_wev8.gif' align=absMiddle></span></td>"
					 			+"<td><input type='text' name='"+inputSAP+"'  onchange=checkinput('"+inputSAP+"','"+inputSAPSpan+"')  ><span id='"+inputSAPSpan+"'><img src='/images/BacoError_wev8.gif' align=absMiddle></span></td>"
					 			+"<td><input type='text' name='"+input03+"' class='constantfiedl'></td>"
					 			+"</tr>");
					 		<%
								}else
								{
							%>
								var row = $("<tr>"
								+"<td><input type='checkbox' name='zibox'></td>"
								+"<td><button type='button' class='e8_browflow' onclick=addOneFieldObjOA(this,0)></button>"
								+"<input type='hidden' name='"+input02+"'><span></span>"
								+"<span id='"+input02Span+"'></span><input type=hidden name='"+address+"'></td>"
								+"<td><span><input type='hidden' name='"+inputOA+"'  value=''></span></td>"
								+"<td><button type='button' class='e8_browflow' onclick=addOneFieldObj(3,this,'"+stuname+"') ></button>"
								+"<input type='hidden' name='"+input01+"'><span></span>"
								+"<span id='"+input01Span+"'><img src='/images/BacoError_wev8.gif' align=absMiddle></span></td>"
								+"<td><span><input type='hidden' name='"+inputSAP+"'   ></span></td>"
								+"<td><input type='text' name='"+input03+"'  class='constantfiedl'></td>"
								+"</tr>");
							<%
								}
							%> 
					 		newtable.append(row); 
					 		$("#cbox2"+"_"+chtable).attr("value",newchtable);
 			}else if(source=="3")
 			{
 				 		var checked = $("#sap_02"+"_"+chtable+" input:checked[type='checkbox'][name='zibox']"); 
 				 			if(checked.length>0){ 
							if(window.confirm("<%=SystemEnv.getHtmlLabelName(30695 ,user.getLanguage())%>!")){
								$(checked).each(function(){ 
									if($(this).attr("checked")==true) 
									{ 
										$(this).parents("tr:first").remove(); 
									} 
								}); 
							}
						}else{
							alert("<%=SystemEnv.getHtmlLabelName(30993 ,user.getLanguage())%>！");
						}
 			}
 		}else if(type=="4")
 		{
 			if(source=="1")
 			{
 				var dialog = new window.top.Dialog();
					dialog.currentWindow = window;
					dialog.Title = "SAP<%=SystemEnv.getHtmlLabelName(561,user.getLanguage()) %>";
				    dialog.URL = "/integration/browse/BrowserMain.jsp?url=/integration/browse/integrationBatchSap.jsp?type="+type+"&regservice=<%=regservice%>&islocal="+islocal;
					dialog.Width = 660;
					dialog.Height = 660;
					dialog.Drag = true;
					dialog.callbackfun=addBathFieldObjCallback4;
			 		dialog.callbackfunParam={type:type,source:source,backtable:backtable,chtable:chtable,stuname:stuname};
					dialog.textAlign = "center";
					dialog.show();
 				
				
 			}else if(source=="2")
 			{
 				
 					var shuzi=parseInt($("#hidden03").val())+1;
					var input01="sap03_"+shuzi;
					var input01Span="sap03_"+shuzi+"Span";
					var input02="show03_"+shuzi;//显示名--文本框
					
					var inputSAP="show03_"+shuzi;
					var inputOA="OAshow03_"+shuzi;
									
					var input02Span="show03_"+shuzi+"Span";//显示名--img
					var input03="dis03_"+shuzi;//是否显示
					var input04="setoa3_"+shuzi;
					//var input04Span="setoa_"+shuzi+"Span";
					var vTb=$("#chind03");
					var row = $("<tr class='DataDark'></tr>"); 
					var address="add03_"+shuzi;
					<%
						if("0".equals(w_type))
						{
					%> 
						var td = $("<td><input type='checkbox' name='cbox3'></td>"
						
						+"<td><button type='button' class='e8_browflow' onclick=addOneFieldObj(4,this)></button>"
						+"<input type='hidden' name='"+input01+"' id='"+input01+"'><span></span><span id='"+input01Span+"'><img src='/images/BacoError_wev8.gif' align=absMiddle></span></td>"
						+"<td><input type='text' name='"+input02+"' onchange=checkinput('"+input02+"','"+input02Span+"')>"
						+"<span id='"+input02Span+"'><img src='/images/BacoError_wev8.gif' align=absMiddle></span></td>"
						+"<td><input type='checkbox' name="+input03+" value=1></td>"
						//+"<td><img src='/integration/images/jt_wev8.png' class='fx'></td>"
						+"<td><button type='button' class='e8_browflow' onclick=addOneFieldObjOA(this,0)></button>"
						+"<input type='hidden' name='"+input04+"'/><span></span><span></span>"
						+"<input type=hidden name='"+address+"'>"
						+"</td>"
						+"<td ><span><input type='hidden' name='"+inputOA+"' ></span></td>");
					<%
						}else
						{
					%>
						var td = $("<td><input type='checkbox' name='cbox3'></td>"
						+"<td><button type='button' class='e8_browflow' onclick=addOneFieldObj(4,this)></button>"
						+"<input type='hidden' name='"+input01+"' id='"+input01+"'><span></span>"
						+"<span id='"+input01Span+"'><img src='/images/BacoError_wev8.gif' align=absMiddle></span>"
						+"<td><SPAN><INPUT name="+input02+" type=hidden></SPAN></td>"
						+"<td ><button type='button' class='e8_browflow' onclick=addOneFieldObjOA(this,0)></button>"
						+"<input type='hidden' name='"+input04+"'>"
						+"<span></span>"
						+"<span></span><input type=hidden name='"+address+"'>"
						+"</td>"
						+"<td ><span><input type='hidden' name='"+inputOA+"' ></span></td>");
					<%		
						}
					%> 
					row.append(td); 
					vTb.append(row); 
					//得到表格的行数
					//var temp=$("#chind03").get(0).rows.length;
					$("#hidden03").attr("value",shuzi);
 			}else if(source=="3")
 			{
 					var vTb=$("#chind03");
					var checked = $("#chind03 input:checked[type='checkbox'][name='cbox3']"); 
					if(checked.length>0){ 
					if(window.confirm("<%=SystemEnv.getHtmlLabelName(30695 ,user.getLanguage())%>!")){
						$(checked).each(function(){ 
							if($(this).attr("checked")==true) 
							{ 
								$(this).parents("tr:first").remove(); 
							} 
						}); 
					}
					}else{
							alert("<%=SystemEnv.getHtmlLabelName(30993 ,user.getLanguage())%>！");
						}
 			}
 		}else if(type=="5")
 		{
 			if(source=="1")
 			{
 				var dialog = new window.top.Dialog();
					dialog.currentWindow = window;
					dialog.Title = "SAP<%=SystemEnv.getHtmlLabelName(561,user.getLanguage()) %>";
				    dialog.URL = "/integration/browse/BrowserMain.jsp?url=/integration/browse/integrationBatchSap.jsp?type="+type+"&regservice=<%=regservice%>&islocal="+islocal;
					dialog.Width = 660;
					dialog.Height = 660;
					dialog.Drag = true;
					dialog.callbackfun=addBathFieldObjCallback5;
			 		dialog.callbackfunParam={type:type,source:source,backtable:backtable,chtable:chtable,stuname:stuname};
					dialog.textAlign = "center";
					dialog.show();
 				
				
 			}else if(source=="2")
 			{
 					var chtable=parseInt($("#hidden04").val())+1;
					var newname="cbox4"+"_"+chtable;
					var newtable="sap_04"+"_"+chtable;
					var newstru="outstru_"+chtable;
					var newstruSpan="outstru_"+chtable+"Span";
					var bath="bath4_"+chtable;
					var row = $("<tr class='DataDark'><td class='tdcenter'><input type='checkbox' name='cbox4'></td>"); 	
						row.append("<td>"
					
							+"<TABLE class=ListStyle cellspacing=1 id='"+newtable+"'>"
							+"<tr>"
							+"<td colspan='6'>"
							+"<span style='float:left'>"
							+"<%=SystemEnv.getHtmlLabelName(30609 ,user.getLanguage())%>"
							+"<button type='button' class='e8_browflow' onclick=addOneFieldObj(5,this)></button>"
							+"<input type='hidden' class='selectmax_width' id='"+newstru+"' name='"+newstru+"'><span></span>"
							+"<span id='"+newstruSpan+"'><img src='/images/BacoError_wev8.gif' align=absMiddle></span>" 
							+" <input type='hidden' id='"+newname+"' name='"+newname+"' value='0'>"
							+"</span>"
							+"<span style='float:right'>"
							+"<input type='button'  class='addbtnB' id='"+bath+"' onclick=addBathFieldObj(6,1,'"+newstru+"','"+chtable+"') title = '<%=SystemEnv.getHtmlLabelName(25055 ,user.getLanguage())%>'>"
							+" <input type='button' class='addbtn' onclick=addBathFieldObj(6,2,'"+newstru+"','"+chtable+"') title='<%=SystemEnv.getHtmlLabelName(611 ,user.getLanguage())%>'>"
							+"<input type='button' class='delbtn' onclick=addBathFieldObj(6,3,'"+newstru+"','"+chtable+"') title='<%=SystemEnv.getHtmlLabelName(23777 ,user.getLanguage())%>'>"
							+"</span>"
							+"</td>"
							+"</tr>"
							+"  <tr class=header>"
							+"<td><input type='checkbox' onclick='checkbox4(this,"+chtable+")'/><%=SystemEnv.getHtmlLabelName(556 ,user.getLanguage())%></td>"
							+"<td><%=SystemEnv.getHtmlLabelName(31732 ,user.getLanguage())%></td>"
							<%
								if("0".equals(w_type))
								{
							%> 
								+"<td><%=SystemEnv.getHtmlLabelName(606 ,user.getLanguage())%></td>"
								+"<td><input type='checkbox' onclick=checkAllBox(this,4,2)><%=SystemEnv.getHtmlLabelName(15603 ,user.getLanguage())%></td>"
							<%
								}else{
							%>
								+"<td><%=SystemEnv.getHtmlLabelName(21934 ,user.getLanguage())%></td>"
							<%
								}
							%> 
							//+"<td>参数方向</td>"
							+"<td><%=SystemEnv.getHtmlLabelName(31731 ,user.getLanguage())%></td>"
							+"<td><%=SystemEnv.getHtmlLabelName(21934 ,user.getLanguage())%></td>"
							
							+"</tr>"
							//+"  <TR class=Line style='height:1px'><TD  style='padding:0px' colspan='6'></TD></TR>"
							+" </TABLE>");
						row.append("</td></tr>");
						var vTb=$("#sap_04");
						vTb.append(row); 
						//var shuzi=parseInt(chtable)+1;
						//得到表格的行数
						$("#hidden04").attr("value",chtable);
 			}else if(source=="3")
 			{
 					var vTb=$("#sap_04");
					var checked = $("#sap_04 input:checked[type='checkbox'][name='cbox4']"); 
					if(checked.length>0){ 
						if(window.confirm("<%=SystemEnv.getHtmlLabelName(30695 ,user.getLanguage())%>!")){
									$(checked).each(function(){ 
										if($(this).attr("checked")==true) 
										{ 
											$(this).parents("tr:first").remove();
										} 
									});
						} 
					}else{
							alert("<%=SystemEnv.getHtmlLabelName(30993 ,user.getLanguage())%>！");
						}
 			}
 		}else if(type=="6")
 		{
 			if(source=="1")
 			{
 					//alert("输出结构"+$("#"+stuname).val());
 					var stuortablevalue=$("#"+stuname).val();
	 				
	 				var dialog = new window.top.Dialog();
					dialog.currentWindow = window;
					dialog.Title = "SAP<%=SystemEnv.getHtmlLabelName(561,user.getLanguage()) %>";
				    dialog.URL = "/integration/browse/BrowserMain.jsp?url=/integration/browse/integrationBatchSap.jsp?type="+type+"&stuortablevalue="+stuortablevalue+"&mark=<%=mark%>&regservice=<%=regservice%>&islocal="+islocal;
					dialog.Width = 660;
					dialog.Height = 660;
					dialog.Drag = true;
					dialog.callbackfun=addBathFieldObjCallback6;
			 		dialog.callbackfunParam={type:type,source:source,backtable:backtable,chtable:chtable,stuname:stuname};
					dialog.textAlign = "center";
					dialog.show();
					
 			}else if(source=="2")
 			{	
 			
 			
 					//得到子表的id
			 		var newtable=$("#sap_04"+"_"+chtable);
			 		var newchtable=parseInt($("#cbox4"+"_"+chtable).val())+1;
			 		var input01="sap04_"+chtable+"_"+newchtable;
			 		var input01Span="sap04_"+chtable+"_"+newchtable+"Span";
			 		
			 		var inputSAP="show04_"+chtable+"_"+newchtable;
					var inputOA="OAshow04_"+chtable+"_"+newchtable;
										
			 		var input02="show04_"+chtable+"_"+newchtable;//显示名--文本框
			 		var input02Span="show04_"+chtable+"_"+newchtable+"Span";//显示名--img
					var input03="dis04_"+chtable+"_"+newchtable;//是否显示
					var input04="sea04_"+chtable+"_"+newchtable;
					var input05="setoa4_"+chtable+"_"+newchtable;
					var address="add04_"+chtable+"_"+newchtable;
					
					<%
						if("0".equals(w_type))
						{
					%> 
						var row = $("<tr class='DataDark'>"
						+"<td><input type='checkbox' name='zibox'></td>"
						+"<td><button type='button' class='e8_browflow' onclick=addOneFieldObj(6,this,'"+stuname+"')></button>"
						+"<input type='hidden' name='"+input01+"' ><span></span><span id='"+input01Span+"'>"
						+"<img src='/images/BacoError_wev8.gif' align=absMiddle></span></td>"
						+"<td><input type='text' name='"+input02+"' onchange=checkinput('"+input02+"','"+input02Span+"')><span id='"+input02Span+"'>"
						+"<img src='/images/BacoError_wev8.gif' align=absMiddle></span></td>"
						+"<td><input type='checkbox' name="+input03+" value=1></td>"
						//+"<td><img src='/integration/images/jt_wev8.png' class='fx'></td>"
						+"<td><button type='button' class='e8_browflow' onclick=addOneFieldObjOA(this,0)></button>"
						+"<input type='hidden' name='"+input05+"'><span></span><span></span>"
						+"<input type=hidden name='"+address+"'>"
						+"</td>"
						+"<td><span><input type='hidden' name='"+inputOA+"' ></span></td>"
						+"</tr>");
					<%
						}else
						{
					%>
						var row = $("<tr class='DataDark'>"
						+"<td><input type='checkbox' name='zibox'></td>"
						+"<td><button type='button' class='e8_browflow' onclick=addOneFieldObj(6,this,'"+stuname+"')></button>"
						+"<input type='hidden' name='"+input01+"' ><span></span><span id='"+input01Span+"'>"
						+"<img src='/images/BacoError_wev8.gif' align=absMiddle></span></td>"
						+"<td><SPAN><INPUT name="+input02+"  type=hidden></SPAN></td>"
						+"<td><button type='button' class='e8_browflow' onclick=addOneFieldObjOA(this,0)></button>"
						+"<input type='hidden' name='"+input05+"'><span></span><span></span>"
						+"<input type=hidden name='"+address+"'>"
						+"</td>"
						+"<td><span><input type='hidden' name='"+inputOA+"' ></span></td>"
						+"</tr>");
					<%		
						}
					%> 
			 		newtable.append(row); 
			 		$("#cbox4"+"_"+chtable).attr("value",newchtable);
 			}else if(source=="3")
 			{
 				var checked = $("#sap_04"+"_"+chtable+" input:checked[type='checkbox'][name='zibox']");
 				if(checked.length>0){ 
				if(window.confirm("<%=SystemEnv.getHtmlLabelName(30695 ,user.getLanguage())%>!")){
					$(checked).each(function(){ 
						if($(this).attr("checked")==true) 
						{ 
							$(this).parents('tr:first').remove(); 
						} 
					}); 
				}
				}else{
							alert("<%=SystemEnv.getHtmlLabelName(30993 ,user.getLanguage())%>！");
						}
 			}
 		}else if(type=="7")
 		{
 			
 			if(source=="1")
 			{
 				var dialog = new window.top.Dialog();
				dialog.currentWindow = window;
				dialog.Title = "SAP<%=SystemEnv.getHtmlLabelName(561,user.getLanguage()) %>";
			    dialog.URL = "/integration/browse/BrowserMain.jsp?url=/integration/browse/integrationBatchSap.jsp?type="+type+"&regservice=<%=regservice%>&islocal="+islocal;
				dialog.Width = 660;
				dialog.Height = 660;
				dialog.Drag = true;
				dialog.callbackfun=addBathFieldObjCallback7;
		 		dialog.callbackfunParam={type:type,source:source,backtable:backtable,chtable:chtable,stuname:stuname};
				dialog.textAlign = "center";
				dialog.show();
 				
				
			
 			}else if(source=="2")
 			{
 					var chtable=parseInt($("#hidden05").val())+1;
					var newname="cbox5"+"_"+chtable;
					var newtable="sap_05"+"_"+chtable;
					var newstru="outtable_"+chtable;
					var newstruSpan="outtable_"+chtable+"Span";
					var bath="bath5_"+chtable;
					var newtable05son="sapson_05_"+chtable;//where条件所在的表格
					var newtable05soncount="sapson_05count_"+chtable;//where条件总行数
					
					var backtable="backtable5_"+chtable;	//回写表
					var backoper="backoper5_"+chtable;	//回写操作
					
					//sapinParameter05.append(" <TABLE  cellspacing=1>");
									//sapinParameter05.append(" <tr>");
									//sapinParameter05.append(" <td>");
									
					<%
						if("0".equals(w_type))
						{
					%>
						var row ="<tr class='DataDark'><td class='tdcenter'><input type='checkbox' name='cbox5'></td>"; 	
							row+="<td>"
							
								+" <TABLE class=ListStyle cellspacing=1 id='"+newtable+"'>"
								+"<tr class='DataDark'>"
								+"<td colspan=9>"
								+"<span style='float:left'>"
								+"<%=SystemEnv.getHtmlLabelName(21900 ,user.getLanguage())%>"
								+"<button type='button' class='e8_browflow' onclick=addOneFieldObj(7,this)></button>"
								+"<input type='hidden' class='selectmax_width' id='"+newstru+"' name='"+newstru+"' >"
								+"<span></span><span id='"+newstruSpan+"'><img src='/images/BacoError_wev8.gif' align=absMiddle></span>"
								+" <input type='hidden' id='"+newname+"' name='"+newname+"' value='0'>"
								+"</span>"
								+"<span style='float:right'>"
								+"<input type='button'  class='addbtnB' id='"+bath+"' onclick=addBathFieldObj(8,1,'"+newstru+"','"+chtable+"') "
								+" title='<%=SystemEnv.getHtmlLabelName(25055 ,user.getLanguage())%>'>"
								+" <input type='button' class='addbtn' onclick=addBathFieldObj(8,2,'"+newstru+"','"+chtable+"') "
								+" title='<%=SystemEnv.getHtmlLabelName(611 ,user.getLanguage())%>'>"
								+"<input type='button' class='delbtn' onclick=addBathFieldObj(8,3,'"+newstru+"','"+chtable+"') "
								+" title='<%=SystemEnv.getHtmlLabelName(23777 ,user.getLanguage())%>'>"
								+"</span>"
								+"</td>"
								+"</tr>"
								+"  <tr class=header><td >"
								+"<input type='checkbox' onclick='checkbox5(this,"+chtable+")'/><%=SystemEnv.getHtmlLabelName(556 ,user.getLanguage())%></td>"
								+"<td><%=SystemEnv.getHtmlLabelName(31732 ,user.getLanguage())%>"
								+"</td>"
								+"<td><%=SystemEnv.getHtmlLabelName(606 ,user.getLanguage())%>"
								+"</td>"
								+"<td><%=SystemEnv.getHtmlLabelName(338 ,user.getLanguage())%>"
								+"</td>"
								+"<td> <input type='checkbox' onclick=checkAllBox(this,5,2)><%=SystemEnv.getHtmlLabelName(15603 ,user.getLanguage())%>"
								+"</td>"
								+"<td> <input type='checkbox' onclick=checkAllBox(this,6,2)><%=SystemEnv.getHtmlLabelName(31733 ,user.getLanguage())%>"
								+"</td>"
								+"<td> <input type='checkbox' onclick=checkAllBox(this,7,2)><%=SystemEnv.getHtmlLabelName(20331 ,user.getLanguage())%>"
								+"</td>"
								//+"<td>参数方向"
								//+"</td>"
								+"<td><%=SystemEnv.getHtmlLabelName(31731 ,user.getLanguage())%>"
								+"</td>"
								+"<td><%=SystemEnv.getHtmlLabelName(21934 ,user.getLanguage())%>"
								+"</td>"
								+"</tr>"
								//+"  <TR class=Line style='height:1px'><TD  style='padding:0px' colspan='9'></TD></TR>"
								+" </TABLE>"
								+" </td></tr>";
					<%
						}else
						{
						
						//sapinParameter05.append(" <TABLE  cellspacing=1>");
									//sapinParameter05.append(" <tr>");
									//sapinParameter05.append(" <td>");
					%>
						var row ="<tr class='DataDark'><td class='tdcenter'><input type='checkbox' name='cbox5'></td>"; 	
						row+="<td>"
						
							+" <TABLE class=ListStyle cellspacing=1 id='"+newtable+"'>"
							+"<tr>"
							+"<td colspan=9>"
							+"<span style='float:left'>"
							+"<%=SystemEnv.getHtmlLabelName(21900 ,user.getLanguage())%><button type='button' class='e8_browflow' onclick=addOneFieldObj(7,this)></button><input type='hidden' class='selectmax_width' id='"+newstru+"' name='"+newstru+"' ><span></span><span id='"+newstruSpan+"'><img src='/images/BacoError_wev8.gif' align=absMiddle></span>"
							+"&nbsp;"
							+"<%=SystemEnv.getHtmlLabelName(30612 ,user.getLanguage())%><button type='button' class='e8_browflow' onclick=backtable(this)></button>" 
							+"<input type='hidden' name='"+backtable+"' id='"+backtable+"'><span></span><span><img src='/images/BacoError_wev8.gif' align=absMiddle></span>"
							+"&nbsp;"
							+"<%=SystemEnv.getHtmlLabelName(30613 ,user.getLanguage())%><select name='"+backoper+"'>"
							+"<option value=0><%=SystemEnv.getHtmlLabelName(30614 ,user.getLanguage())%></option>"
							+"<option value=1><%=SystemEnv.getHtmlLabelName(30615 ,user.getLanguage())%></option>";
							<%
								if("1".equals(w_type)){
							%>
							row+="<option value=2><%=SystemEnv.getHtmlLabelName(103 ,user.getLanguage())%></option>"
							+"<option value=3><%=SystemEnv.getHtmlLabelName(23777 ,user.getLanguage())%></option>";
							<%
								}
							%>
							row+="</select>"
							+" <input type='hidden' id='"+newname+"' name='"+newname+"' value='0'>"
							+"</span>"
							+"<span style='float:right'>"
							+"<input type='button'  class='addbtnB' id='"+bath+"' onclick=addBathFieldObj(8,1,'"+newstru+"','"+chtable+"','"+backtable+"') "
							+" title='<%=SystemEnv.getHtmlLabelName(25055 ,user.getLanguage())%>'> "
							+"<input type='button' class='addbtn' onclick=addBathFieldObj(8,2,'"+newstru+"','"+chtable+"','"+backtable+"') "
							+" title='<%=SystemEnv.getHtmlLabelName(611 ,user.getLanguage())%>'>"
							+"<input type='button' class='delbtn' onclick=addBathFieldObj(8,3,'"+newstru+"','"+chtable+"') "
							+" title='<%=SystemEnv.getHtmlLabelName(23777 ,user.getLanguage())%>'>"
							+"</span>"
							+"</td>"
							+"</tr>"
							+"  <tr class=header><td ><input type='checkbox' onclick='checkbox5(this,"+chtable+")'/>"
							+"<%=SystemEnv.getHtmlLabelName(556 ,user.getLanguage())%></td>"
							+"<td><%=SystemEnv.getHtmlLabelName(31732 ,user.getLanguage())%>"
							+"</td>"
							+"<td><%=SystemEnv.getHtmlLabelName(21934 ,user.getLanguage())%>"
							+"</td>"
							+"<td><%=SystemEnv.getHtmlLabelName(31731 ,user.getLanguage())%>"
							+"</td>"
							+"<td><%=SystemEnv.getHtmlLabelName(21934 ,user.getLanguage())%>"
							+"</td>"
							+"</tr>"
							//+"  <TR class=Line style='height:1px'><TD  style='padding:0px' colspan='9'></TD></TR>"
							+" </TABLE>"
							+" <TABLE class=ListStyle cellspacing=1 id='"+newtable05son+"'> "
							+" <tr class='DataDark'> "
							+" <td colspan=6>"
							+"<span style='float:left'>"
							+" <%=SystemEnv.getHtmlLabelName(30616 ,user.getLanguage())%>"
							+" <input type='hidden' name='"+newtable05soncount+"' id='"+newtable05soncount+"' value='0'> "
							+"</span>"
							+"<span style='float:right'>"
							+"<input type='button'  class='addbtnB' onclick=addBathFieldObj(12,1,'"+newstru+"','"+chtable+"','"+backtable+"') "
							+" title='<%=SystemEnv.getHtmlLabelName(25055 ,user.getLanguage())%>'> "
							+"<input type='button' class='addbtn' onclick=addBathFieldObj(12,2,'"+newstru+"','"+chtable+"','"+backtable+"') "
							+" title='<%=SystemEnv.getHtmlLabelName(611 ,user.getLanguage())%>'>"
							+"<input type='button' class='delbtn' onclick=addBathFieldObj(12,3,'"+newstru+"','"+chtable+"') "
							+" title='<%=SystemEnv.getHtmlLabelName(23777 ,user.getLanguage())%>'>"
							+"</span>"
							+" </td>"
							+" </tr>"
							+" <tr class=Header>"
							+" <td>"
							+" <input type=checkbox onclick='checkbox5son(this,"+chtable+")'<%=SystemEnv.getHtmlLabelName(556 ,user.getLanguage())%>"
							+" </td>"
							+" <td>"
							+" <%=SystemEnv.getHtmlLabelName(30617 ,user.getLanguage())%>"
							+" </td>"
							+" <td>"
							+" <%=SystemEnv.getHtmlLabelName(21934 ,user.getLanguage())%>"
							+" </td>"
							+" <td>"
							+" <%=SystemEnv.getHtmlLabelName(30618 ,user.getLanguage())%>"
							+" </td>"
							+" <td>"
							+" <%=SystemEnv.getHtmlLabelName(21934 ,user.getLanguage())%>"
							+" </td>"
							+" <td>"
							+" <%=SystemEnv.getHtmlLabelName(453 ,user.getLanguage())%>"
							+" </td>"
							+" </tr>"
					<%		
						}
					%>
						var vTb=$("#sap_05");
						vTb.append(row); 
						//var shuzi=parseInt(chtable)+1;
						//得到表格的行数
						$("#hidden05").attr("value",chtable);
 			}else if(source=="3")
 			{
 					var vTb=$("#sap_05");
					var checked = $("#sap_05 input:checked[type='checkbox'][name='cbox5']"); 
						if(checked.length>0){ 
							if(window.confirm("<%=SystemEnv.getHtmlLabelName(30695 ,user.getLanguage())%>!")){
						$(checked).each(function(){ 
							if($(this).attr("checked")==true) 
							{ 
								$(this).parents('tr:first').remove(); 
							} 
						}); 
					}
					}else{
							alert("<%=SystemEnv.getHtmlLabelName(30993 ,user.getLanguage())%>！");
						}
 			}
 		}else if(type=="8")
 		{
 			if(source=="1")
 			{
 				//alert("输出表里面的输出参数"+($("#"+stuname).val()_);
 				var stuortablevalue=$("#"+stuname).val();
 				
 				var dialog = new window.top.Dialog();
				dialog.currentWindow = window;
				dialog.Title = "SAP<%=SystemEnv.getHtmlLabelName(561,user.getLanguage()) %>";
			    dialog.URL = "/integration/browse/BrowserMain.jsp?url=/integration/browse/integrationBatchSap.jsp?type="+type+"&stuortablevalue="+stuortablevalue+"&regservice=<%=regservice%>&islocal="+islocal;
				dialog.Width = 660;
				dialog.Height = 660;
				dialog.Drag = true;
				dialog.callbackfun=addBathFieldObjCallback8;
		 		dialog.callbackfunParam={type:type,source:source,backtable:backtable,chtable:chtable,stuname:stuname};
				dialog.textAlign = "center";
				dialog.show();
 				
 				
 				
				
 			}else if(source=="2")
 			{
 				//得到子表的id
		 		var newtable=$("#sap_05"+"_"+chtable);
		 		var newchtable=parseInt($("#cbox5"+"_"+chtable).val())+1;
		 		var input01="sap05_"+chtable+"_"+newchtable;
		 		var input02="show05_"+chtable+"_"+newchtable;
		 		var input01Span="sap05_"+chtable+"_"+newchtable+"Span";
		 		var input02Span="show05_"+chtable+"_"+newchtable+"Span";
				var input03="dis05_"+chtable+"_"+newchtable;
				var input04="sea05_"+chtable+"_"+newchtable;
				var input05="key05_"+chtable+"_"+newchtable;
				var input06="setoa5_"+chtable+"_"+newchtable;
				var address="add05_"+chtable+"_"+newchtable;
				
				var inputSAP="show05_"+chtable+"_"+newchtable;
				var inputOA="OAshow05_"+chtable+"_"+newchtable;
				//排序字段
				var isorderby="isorderby05_"+chtable+"_"+newchtable;
							
				<%
					if("0".equals(w_type))
					{
				%> 
					var row = $("<tr class='DataDark'><td>"
					+"<input type='checkbox' name='zibox'></td>"
					+"<td><button type='button' class='e8_browflow' onclick=addOneFieldObj(8,this,'"+stuname+"')></button>"
					+"<input type='hidden' name='"+input01+"'><span></span> <span id='"+input01Span+"'><img src='/images/BacoError_wev8.gif' align=absMiddle></span></td>"
					+"<td><input type='text' name='"+input02+"' onchange=checkinput('"+input02+"','"+input02Span+"')> <span id='"+input02Span+"'>"
					+"<img src='/images/BacoError_wev8.gif' align=absMiddle></span></td>"
					+"<td><input type='text' name='"+isorderby+"' value='0' class='orderfield'></td>"
					+"<td><input type='checkbox' name="+input03+" value=1></td>"
					+"<td>"
					+"<input type='checkbox' name='"+input05+"' value=1></td>"
					+"<td><input type='checkbox' name='"+input04+"' value=1></td>"
					//+"<td><img src='/integration/images/jt_wev8.png' class='fx'></td>"
					+"<td><button type='button' class='e8_browflow' onclick=addOneFieldObjOA(this,0)></button>"
					+"<input type='hidden' name='"+input06+"'><span></span><span></span>"
					+"<input type=hidden name='"+address+"'>"
					+"</td>"
					+"<td><span><input type='hidden' name='"+inputOA+"' ></span></td>"
					+"</tr>");
				<%
					}else
					{
				%>
					var row = $("<tr class='DataDark'>"
					+"<td><input type='checkbox' name='zibox'></td>"
					+"<td><button type='button' class='e8_browflow' onclick=addOneFieldObj(8,this,'"+stuname+"')></button>"
					+"<input type='hidden' name='"+input01+"'><span></span> "
					+"<span id='"+input01Span+"'><img src='/images/BacoError_wev8.gif' align=absMiddle></span>"
					+"</td>"
					+"<td><SPAN><INPUT name="+input02+" type=hidden></SPAN></td>"
					+"<td><button type='button' class='e8_browflow' onclick=addOneFieldObjOA(this,'','"+backtable+"')></button>"
					+"<input type='hidden' name='"+input06+"'><span></span><span><img src='/images/BacoError_wev8.gif' align=absMiddle></span>"
					+"<input type=hidden name='"+address+"'>"
					+"</td>"
					+"<td><span><input type='hidden' name='"+inputOA+"' ></span></td>"
					+"</tr>");
				<%		
					}
				%> 
									
		 		 
		 		newtable.append(row); 
		 		$("#cbox5"+"_"+chtable).attr("value",newchtable);
 			}
 			else if(source=="3")
 			{
 				 		var checked = $("#sap_05"+"_"+chtable+" input:checked[type='checkbox'][name='zibox']");
 				 			if(checked.length>0){ 
							if(window.confirm("<%=SystemEnv.getHtmlLabelName(30695 ,user.getLanguage())%>!")){
							$(checked).each(function(){ 
								if($(this).attr("checked")==true) 
								{ 
									$(this).parents('tr:first').remove(); 
								} 
							}); 
						}
						}else{
							alert("<%=SystemEnv.getHtmlLabelName(30993 ,user.getLanguage())%>！");
						}
 			}
 		}else if(type=="9")
 		{
 			if(source=="1")
 			{
 					for(var i=0;i<2;i++)
 					{
 						var newtable=$("#sap_06_son");
		 				var newchtable=parseInt($("#hidden06").val())+1;
		 				var autotype="autotype_"+newchtable;
						var autospan="autospan_"+newchtable;
						var autotext="autotext_"+newchtable;
						var autouserorwf="autouserorwf_"+newchtable;
						var autodeti="autodeti_"+newchtable;
						var autowfid="autowfid_"+newchtable;
						var autowfidspan="autowfidspan_"+newchtable;
						var row="<tr class='DataDark'>";
						row+="<td><input type='checkbox' name='autho'></td>"
						+" <td>"
						+" <select name='"+autotype+"' id='"+autotype+"' onchange=changerole('"+autospan+"','"+autouserorwf+"')><option value=1><%=SystemEnv.getHtmlLabelName(179 ,user.getLanguage())%></option><option value=2><%=SystemEnv.getHtmlLabelName(122 ,user.getLanguage())%></option></select>"
						+" <button type='button' class='e8_browflow' onclick=changebrotype(1,'"+autotype+"','"+autospan+"','"+autouserorwf+"')></button>"
						+"	<span id='"+autospan+"'><IMG src='/images/BacoError_wev8.gif' align=absMiddle></span>"
						+"	<input type='hidden' id='"+autouserorwf+"' name='"+autouserorwf+"'>"
						+" </td>"
						//+" <td>"
						//+" 工作流程<button type='button' class='e8_browflow' onclick=changebrotype(3,'"+autowfid+"','"+autowfidspan+"')></button>"
						//+" <input type='hidden' id='"+autowfid+"' name='"+autowfid+"'>"
						//+"<span id='"+autowfidspan+"'><IMG src='/images/BacoError_wev8.gif' align=absMiddle></span>"
						//+" </td>"
						+" <td>"
						+" <input class=e8_btn_submit type=button value='<%=SystemEnv.getHtmlLabelName(19342 ,user.getLanguage())%>'   onclick=changebrotype(2,'"+autodeti+"','')>"
						+" <input type='hidden' id='"+autodeti+"' name='"+autodeti+"'>"
						+" </td>"
						+" </tr>";	
						newtable.append($(row)); 
				 		$("#hidden06").attr("value",newchtable);
 					}
 			}else if(source=="2")
 			{
 				var newtable=$("#sap_06_son");
 				var newchtable=parseInt($("#hidden06").val())+1;
 				var autotype="autotype_"+newchtable;
				var autospan="autospan_"+newchtable;
				var autotext="autotext_"+newchtable;
				var autouserorwf="autouserorwf_"+newchtable;
				var autodeti="autodeti_"+newchtable;
				var autowfid="autowfid_"+newchtable;
				var autowfidspan="autowfidspan_"+newchtable;
				var row="<tr class='DataDark'>";
				row+="<td><input type='checkbox' name='autho'></td>"
				+" <td>"
				+" <select name='"+autotype+"' id='"+autotype+"' onchange=changerole('"+autospan+"','"+autouserorwf+"')><option value=1><%=SystemEnv.getHtmlLabelName(179 ,user.getLanguage())%></option><option value=2><%=SystemEnv.getHtmlLabelName(122 ,user.getLanguage())%></option></select>"
				+" <button type='button' class='e8_browflow' onclick=changebrotype(1,'"+autotype+"','"+autospan+"','"+autouserorwf+"')></button>"
				+"	<span id='"+autospan+"'><IMG src='/images/BacoError_wev8.gif' align=absMiddle></span>"
				+"	<input type='hidden' id='"+autouserorwf+"' name='"+autouserorwf+"'>"
				+" </td>"
				//+" <td>"
				//+" 工作流程<button type='button' class='e8_browflow' onclick=changebrotype(3,'"+autowfid+"','"+autowfidspan+"')></button>"
				//+" <input type='hidden' id='"+autowfid+"' name='"+autowfid+"'>"
				//+"	<span id='"+autowfidspan+"'><IMG src='/images/BacoError_wev8.gif' align=absMiddle></span>"
				//+" </td>"
				+" <td>"
				+" <input class=e8_btn_submit type=button value='<%=SystemEnv.getHtmlLabelName(19342 ,user.getLanguage())%>'   onclick=changebrotype(2,'"+autodeti+"','')>"
				+" <input type='hidden' id='"+autodeti+"' name='"+autodeti+"'>"
				+" </td>"
				
				+" </tr>";	
				newtable.append($(row)); 
		 		$("#hidden06").attr("value",newchtable);
				
 			}else if(source=="3")
 			{
 				var checked = $("#sap_06_son input:checked[type='checkbox'][name='autho']");
 					if(checked.length>0){ 
							if(window.confirm("<%=SystemEnv.getHtmlLabelName(30695 ,user.getLanguage())%>!")){
						$(checked).each(function(){ 
							if($(this).attr("checked")==true) 
							{ 
								$(this).parents('tr:first').remove(); 
							} 
						});
					}
				}else{
							alert("<%=SystemEnv.getHtmlLabelName(30993 ,user.getLanguage())%>！");
						}
 			}
 			var isNewPlugisSelect = jQuery("#isNewPlugisSelect");
			if(isNewPlugisSelect.length>0&&isNewPlugisSelect.val()!="1"){
				// do nothing
			}else{
				beautySelect();
			}
 		}else if(type=="10")
 		{
 			if(source=="1")//输入表
 			{
 				var dialog = new window.top.Dialog();
				dialog.currentWindow = window;
				dialog.Title = "SAP<%=SystemEnv.getHtmlLabelName(561,user.getLanguage()) %>";
			    dialog.URL = "/integration/browse/BrowserMain.jsp?url=/integration/browse/integrationBatchSap.jsp?type="+type+"&regservice=<%=regservice%>&islocal="+islocal;
				dialog.Width = 660;
				dialog.Height = 660;
				dialog.Drag = true;
				dialog.callbackfun=addBathFieldObjCallback10;
		 		dialog.callbackfunParam={type:type,source:source,backtable:backtable,chtable:chtable,stuname:stuname};
				dialog.textAlign = "center";
				dialog.show();
 			
				
			
 			}else if(source=="2")
 			{
 					var chtable=parseInt($("#hidden07").val())+1;
					var newname="cbox7"+"_"+chtable;
					var newtable="sap_07"+"_"+chtable;
					var newstru="outtable7_"+chtable;
					var backtable="backtable7_"+chtable;	//写入表
					var newstruSpan="outtable7_"+chtable+"Span";
					var bath="bath7_"+chtable;
					var row = $("<tr class='DataDark'><td class='tdcenter'><input type='checkbox' name='cbox7'></td>"); 	
						row.append("<td>" 
								+" <TABLE class=ListStyle cellspacing=1 id='"+newtable+"'>"
								+"<tr>"
								+"<td  colspan=9>"
									+"<span style='float:left'>"
									+" <%=SystemEnv.getHtmlLabelName(21900 ,user.getLanguage())%><button type='button' class='e8_browflow' onclick=addOneFieldObj(10,this)></button><input type='hidden' class='selectmax_width' id='"+newstru+"' name='"+newstru+"'><span></span><span id='"+newstruSpan+"'><img src='/images/BacoError_wev8.gif' align=absMiddle></span>"
									+" <input type='hidden' id='"+newname+"' name='"+newname+"' value='0'>"
									+" <%=SystemEnv.getHtmlLabelName(31734 ,user.getLanguage())%><button type='button' class='e8_browflow' onclick=backtable(this)></button>"
									+" <input type='hidden' name='"+backtable+"' id='"+backtable+"' ><span></span><span><img src='/images/BacoError_wev8.gif' align=absMiddle></span>"
									+"</span>"
									+"<span style='float:right'>"
									+"<input type='button'  class='addbtnB' id='"+bath+"' onclick=addBathFieldObj(11,1,'"+newstru+"','"+chtable+"','"+backtable+"') "
									+" title='<%=SystemEnv.getHtmlLabelName(25055 ,user.getLanguage())%>'> "
									+"<input type='button' class='addbtn' onclick=addBathFieldObj(11,2,'"+newstru+"','"+chtable+"','"+backtable+"') "
									+" title='<%=SystemEnv.getHtmlLabelName(611 ,user.getLanguage())%>'>"
									+"<input type='button' class='delbtn' onclick=addBathFieldObj(11,3,'"+newstru+"','"+chtable+"') "
									+" title='<%=SystemEnv.getHtmlLabelName(23777 ,user.getLanguage())%>'>"
									+"</span>"
								+"</td>"
								+"</tr>"
								+"  <tr class=header><td>"
								+"<input type='checkbox' onclick='checkbox7(this,"+chtable+")'/><%=SystemEnv.getHtmlLabelName(556 ,user.getLanguage())%></td>"
								+"<td><%=SystemEnv.getHtmlLabelName(31731 ,user.getLanguage())%></td>"
								+"<td><%=SystemEnv.getHtmlLabelName(21934 ,user.getLanguage())%></td>"
								+"<td><%=SystemEnv.getHtmlLabelName(31732 ,user.getLanguage())%></td>"
								+"<td><%=SystemEnv.getHtmlLabelName(21934 ,user.getLanguage())%></td>"
								+"<td><%=SystemEnv.getHtmlLabelName(453 ,user.getLanguage())%></td>"
								+"</tr>"
								//+"  <TR class=Line style='height:1px'><TD  style='padding:0px' colspan='9'></TD></TR>"
								+" </TABLE>");
						row.append("</td></tr>");
						var vTb=$("#sap_07");
						vTb.append(row); 
						//得到表格的行数
						$("#hidden07").attr("value",chtable);
 			}else if(source=="3")
 			{
 					var vTb=$("#sap_07");
					var checked = $("#sap_07 input:checked[type='checkbox'][name='cbox7']"); 
						if(checked.length>0){ 
							if(window.confirm("<%=SystemEnv.getHtmlLabelName(30695 ,user.getLanguage())%>!")){
						$(checked).each(function(){ 
							if($(this).attr("checked")==true) 
							{ 
								$(this).parents('tr:first').remove(); 
							} 
						}); 
					}
					}else{
							alert("<%=SystemEnv.getHtmlLabelName(30993 ,user.getLanguage())%>！");
						}
 			}
 		}else if(type=="11")
 		{
 			if(source=="1")
 			{
 				
 				var stuortablevalue=$("#"+stuname).val();
 			
				var dialog = new window.top.Dialog();
				dialog.currentWindow = window;
				dialog.Title = "SAP<%=SystemEnv.getHtmlLabelName(561,user.getLanguage()) %>";
			    dialog.URL = "/integration/browse/BrowserMain.jsp?url=/integration/browse/integrationBatchSap.jsp?type="+type+"&stuortablevalue="+stuortablevalue+"&regservice=<%=regservice%>&islocal="+islocal;
				dialog.Width = 660;
				dialog.Height = 660;
				dialog.Drag = true;
				dialog.callbackfun=addBathFieldObjCallback11;
		 		dialog.callbackfunParam={type:type,source:source,backtable:backtable,chtable:chtable,stuname:stuname};
				dialog.textAlign = "center";
				dialog.show();
				
 			}else if(source=="2")
 			{
 				//得到子表的id
		 		var newtable=$("#sap_07"+"_"+chtable);
		 		var newchtable=parseInt($("#cbox7"+"_"+chtable).val())+1;
		 		var input01="sap07_"+chtable+"_"+newchtable;
		 		var input02="show07_"+chtable+"_"+newchtable;
		 		var input01Span="sap07_"+chtable+"_"+newchtable+"Span";
		 		var input02Span="show07_"+chtable+"_"+newchtable+"Span";
				var input03="con07_"+chtable+"_"+newchtable;
				var input03Span="con07_"+chtable+"_"+newchtable+"Span";
				var input06="setoa7_"+chtable+"_"+newchtable;
				var input06Span="setoa7_"+chtable+"_"+newchtable+"Span";
				var address="add07_"+chtable+"_"+newchtable;
				var inputOA="OAshow07_"+chtable+"_"+newchtable;
				//是否显示
				var ishowField="ishowField07_"+chtable+"_"+newchtable;
				//是否只读
				var isrdField="isrdField07_"+chtable+"_"+newchtable;
				//排序字段
				var isorderby="isorderby07_"+chtable+"_"+newchtable;
				
		 		var row = $("<tr class='DataDark'>"
		 		+"<td><input type='checkbox' name='zibox'></td>"
		 		+"<td><button type='button' class='e8_browflow' onclick=addOneFieldObjOA(this,'0','"+backtable+"')></button>"
		 		+"<input type='hidden' name='"+input06+"'><span></span><span id='"+input06Span+"'></span>"
		 		+"<input type=hidden name='"+address+"'></td>"
		 		+"<td><SPAN><INPUT name="+inputOA+" type=hidden></SPAN></td>"
		 		+"<td>"
		 		+"<button type='button' class='e8_browflow' onclick=addOneFieldObj(11,this,'"+stuname+"')></button>"
		 		+"<input type='hidden' name='"+input01+"'><span></span><span id='"+input01Span+"'>"
		 		+"<img src='/images/BacoError_wev8.gif' align=absMiddle></span></td>"
		 		+"<td><SPAN><INPUT name="+input02+" type=hidden value=''></SPAN></td>"
		 		+"<td><input type='text' name='"+input03+"'  class='constantfiedl'></td>"
		 		+"</tr>"); 
		 		newtable.append(row); 
		 		$("#cbox7"+"_"+chtable).attr("value",newchtable);
 			}
 			else if(source=="3")
 			{
 				 		var checked = $("#sap_07"+"_"+chtable+" input:checked[type='checkbox'][name='zibox']");
 				 		if(checked.length>0){ 
							if(window.confirm("<%=SystemEnv.getHtmlLabelName(30695 ,user.getLanguage())%>!")){
								$(checked).each(function(){ 
									if($(this).attr("checked")==true) 
									{ 
										$(this).parents('tr:first').remove(); 
									} 
								}); 
							}
						}else{
							alert("<%=SystemEnv.getHtmlLabelName(30993 ,user.getLanguage())%>！");
						}
 			}
 		}else if(type=="12")
 		{
 			if(source=="1")
 			{
 					var stuortablevalue=$("#"+stuname).val();
	 				var dialog = new window.top.Dialog();
					dialog.currentWindow = window;
					dialog.Title = "SAP<%=SystemEnv.getHtmlLabelName(561,user.getLanguage()) %>";
				    dialog.URL = "/integration/browse/BrowserMain.jsp?url=/integration/browse/integrationBatchSap.jsp?type="+type+"&stuortablevalue="+stuortablevalue+"&regservice=<%=regservice%>&islocal="+islocal;
					dialog.Width = 660;
					dialog.Height = 660;
					dialog.Drag = true;
					dialog.callbackfun=addBathFieldObjCallback12;
			 		dialog.callbackfunParam={type:type,source:source,backtable:backtable,chtable:chtable,stuname:stuname};
					dialog.textAlign = "center";
					dialog.show();
					
 				
 			}else if(source=="2")
 			{
 				var newtable=$("#sapson_05_"+chtable);
 				var newchtable=parseInt($("#sapson_05count_"+chtable).val())+1;
 				var input01="sap05son_"+chtable+"_"+newchtable;
				var input02="set05son_"+chtable+"_"+newchtable;
				var input03="add05son_"+chtable+"_"+newchtable;
				var input04="con05son_"+chtable+"_"+newchtable;
				var inputSAP="show05son_"+chtable+"_"+newchtable;
 				var row="<tr class='DataDark'><td><input type='checkbox' name='zibox'></td>";
				row+="<td>"
					+"<button type='button' class='e8_browflow' onclick=addOneFieldObj(8,this,'"+stuname+"')></button>"
					+"<input type='hidden' name='"+input01+"'><span></span><span ><img src='/images/BacoError_wev8.gif' align=absMiddle></span></td>"
					+"<td><SPAN><INPUT name="+inputSAP+" type=hidden></SPAN></td>"
					+"<td> <button type='button' class='e8_browflow' onclick=addOneFieldObjOA(this,'0','"+backtable+"')></button>"
					+"<input type='hidden' name='"+input02+"'/><span></span><span>"
					+"</span>"
					+"<input type=hidden name='"+input03+"'></td>"
					+"<td><SPAN><INPUT name="+inputOA+" type=hidden></SPAN></td>"
					+"<td><input type='text' name='"+input04+"' class='constantfiedl'>"
					+"</td>"
					+"</tr>";
		 		newtable.append(row); 
		 		$("#sapson_05count_"+chtable).attr("value",newchtable);
								
 			}else if(source=="3")
 			{
					var checked = $("#sapson_05"+"_"+chtable+" input:checked[type='checkbox'][name='zibox']");
						if(checked.length>0){ 
							if(window.confirm("<%=SystemEnv.getHtmlLabelName(30695 ,user.getLanguage())%>!")){
						$(checked).each(function(){
							if($(this).attr("checked")==true)
							{
								//$(this).parent('tr:first').remove();
								$(this).parent().parent().parent("tr:first").remove()
							}
						}); 
					}
					}else{
							alert("<%=SystemEnv.getHtmlLabelName(30993 ,user.getLanguage())%>！");
					}
 			}
 		}
 		
 		$('body').jNice();
 	}

 	function checkRequired()
 	{
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
			
			alert("<%=SystemEnv.getHtmlLabelName(30622 ,user.getLanguage())%>"+"!");
			return false;
		}else
		{
			return true;
		}
 	}

	function checkDobule(){
			var hidden01sz=[];
			var hidden02sz=[];
			var hidden03sz=[];
			var hidden04sz=[];
			var hidden05sz=[];
	
			var hidden01=parseInt($("#hidden01").val());
			var hidden02=parseInt($("#hidden02").val());
			var hidden03=parseInt($("#hidden03").val());
			var hidden04=parseInt($("#hidden04").val());
			var hidden05=parseInt($("#hidden05").val());
			
			//验证输入参数是否合法	
			for(var i=1;i<=hidden01;i++){
				var sap_valuq=document.getElementsByName("sap01_"+i)[0];
				if(sap_valuq){
					hidden01sz.push(sap_valuq.value);
				}
			}
			hidden01sz=hidden01sz.sort();
			for(var i = 0; i < hidden01sz.length - 1; i++){
				    if (hidden01sz[i] == hidden01sz[i+1]) {
				        alert("<%=SystemEnv.getHtmlLabelName(31735 ,user.getLanguage())%>:" +hidden01sz[i]);
				        return false;
				    }
			}
			//验证输入结构是否合法	
			for(var i=1;i<=hidden02;i++){
				var sap_valuq=document.getElementsByName("stru_"+i)[0];
				if(sap_valuq){
					hidden02sz.push(sap_valuq.value);
				}
			}
			hidden02sz=hidden02sz.sort();
			for(var i = 0; i < hidden02sz.length - 1; i++){
				    if (hidden02sz[i] == hidden02sz[i+1]) {
				        alert("<%=SystemEnv.getHtmlLabelName(31736 ,user.getLanguage())%>:" +hidden02sz[i]);
				        return false;
				    }
			}
			for(var i = 1; i<= hidden02sz.length; i++){
				  	var hidden02_box=parseInt($("#cbox2_"+i).val());
				  	var hidden02_boxsz=[];
				  	for(var j=1;j<=hidden02_box;j++){
				  			var sap_valuq=document.getElementsByName("sap02_"+i+"_"+j)[0];
							if(sap_valuq){
								hidden02_boxsz.push(sap_valuq.value);
							}
				  	}
				  	hidden02_boxsz=hidden02_boxsz.sort();
					for(var k = 0; k < hidden02_boxsz.length - 1; k++){
						    if (hidden02_boxsz[k] == hidden02_boxsz[k+1]) {
						        alert("<%=SystemEnv.getHtmlLabelName(28251 ,user.getLanguage())%>"+(document.getElementsByName("stru_"+i)[0].value)+"<%=SystemEnv.getHtmlLabelName(31737 ,user.getLanguage())%>:" +hidden02_boxsz[k]);
						        return false;
						    }
					}
			}
			
			//验证输出参数是否合法	
			for(var i=1;i<=hidden03;i++){
				var sap_valuq=document.getElementsByName("sap03_"+i)[0];
				if(sap_valuq){
					hidden03sz.push(sap_valuq.value);
				}
			}
			
			hidden03sz=hidden03sz.sort();
			for(var i = 0; i < hidden03sz.length - 1; i++){
				    if (hidden03sz[i] == hidden03sz[i+1]) {
				        alert("<%=SystemEnv.getHtmlLabelName(31738 ,user.getLanguage())%>:" +hidden03sz[i]);
				        return false;
				    }
			}
			
			
			//验证输出结构是否合法	
			for(var i=1;i<=hidden04;i++){
				var sap_valuq=document.getElementsByName("outstru_"+i)[0];
				if(sap_valuq){
					hidden04sz.push(sap_valuq.value);
				}
			}
			
			hidden04sz=hidden04sz.sort();
			for(var i = 0; i < hidden04sz.length - 1; i++){
				    if (hidden04sz[i] == hidden04sz[i+1]) {
				        alert("<%=SystemEnv.getHtmlLabelName(31739 ,user.getLanguage())%>:" +hidden04sz[i]);
				        return false;
				    }
			}
			
			for(var i = 1; i<= hidden04sz.length; i++){
				  	var hidden04_box=parseInt($("#cbox4_"+i).val());
				  	var hidden04_boxsz=[];
				  	for(var j=1;j<=hidden04_box;j++){
				  			var sap_valuq=document.getElementsByName("sap04_"+i+"_"+j)[0];
							if(sap_valuq){
								hidden04_boxsz.push(sap_valuq.value);
							}
				  	}
				  	hidden04_boxsz=hidden04_boxsz.sort();
					for(var k = 0; k < hidden04_boxsz.length - 1; k++){
						    if (hidden04_boxsz[k] == hidden04_boxsz[k+1]) {
						        alert("<%=SystemEnv.getHtmlLabelName(28256 ,user.getLanguage())%>"+(document.getElementsByName("outstru_"+i)[0].value)+"<%=SystemEnv.getHtmlLabelName(31737 ,user.getLanguage())%>:" +hidden04_boxsz[k]);
						        return false;
						    }
					}
			}
			
			//验证输出表是否合法	
			for(var i=1;i<=hidden05;i++){
				var sap_valuq=document.getElementsByName("outtable_"+i)[0];
				if(sap_valuq){
					hidden05sz.push(sap_valuq.value);
				}
			}
			
			<%
				if("0".equals(w_type)){
				//浏览按钮的输出表只能配置一个
			%>
					if(hidden05sz.length>1){
						alert("<%=SystemEnv.getHtmlLabelName(31747 ,user.getLanguage())%>!");
						return false;
					}
			<%
				}
			%>
					
			hidden05sz=hidden05sz.sort();
			for(var i = 0; i < hidden05sz.length - 1; i++){
				    if (hidden05sz[i] == hidden05sz[i+1]) {
				        alert("<%=SystemEnv.getHtmlLabelName(31740 ,user.getLanguage())%>:" +hidden05sz[i]);
				        return false;
				    }
			}
			
			for(var i = 1; i<= hidden05sz.length; i++){
				  	var hidden05_box=parseInt($("#cbox5_"+i).val());
				  	var hidden05_boxsz=[];
				  	for(var j=1;j<=hidden05_box;j++){
				  			var sap_valuq=document.getElementsByName("sap05_"+i+"_"+j)[0];
							if(sap_valuq){
								hidden05_boxsz.push(sap_valuq.value);
							}
				  	}
				  	hidden05_boxsz=hidden05_boxsz.sort();
					for(var k = 0; k < hidden05_boxsz.length - 1; k++){
						    if (hidden05_boxsz[k] == hidden05_boxsz[k+1]) {
						        alert("<%=SystemEnv.getHtmlLabelName(28260 ,user.getLanguage())%>"+(document.getElementsByName("outtable_"+i)[0].value)+"<%=SystemEnv.getHtmlLabelName(31737 ,user.getLanguage())%>:" +hidden05_boxsz[k]);
						        return false;
						    }
					}
			}
			
			return true;
	}
	
	function changebrotypeCallBack1(objjson,id){
		var type = objjson.type;
		var objone = objjson.objone;
		var objtwo = objjson.objtwo;
		var objthree = objjson.objthree;
		
		 if(id){
		    var jsid="";
			try {
		        jsid = new Array();jsid[0]=wuiUtil.getJsonValueByIndex(id, 0);jsid[1]=wuiUtil.getJsonValueByIndex(id, 1);
		    } catch(e) {
		        return;
		    }
		    if (jsid != null) {
		        if (jsid[0] != "" && jsid[1]!="") {
		            $GetEle(objtwo).innerHTML = jsid[1].substring(0);
		            $GetEle(objthree).value = jsid[0].substring(0);
		        } else {
		            $GetEle(objtwo).innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
		            $GetEle(objthree).value = "";
		        }
		    }
		 }
		
	}
	
	function changebrotypeCallBack2(objjson,id){
		var type = objjson.type;
		var objone = objjson.objone;
		var objtwo = objjson.objtwo;
		var objthree = objjson.objthree;
		
		if(id){
		    try {
		        jsid = new Array();jsid[0]=wuiUtil.getJsonValueByIndex(id, 0);jsid[1]=wuiUtil.getJsonValueByIndex(id, 1);
		        
		    } catch(e) {
		        return;
		    }
		    if (jsid != null) {
		        if (jsid[0] != "0" && jsid[1]!="") {
		            $GetEle(objtwo).innerHTML = jsid[1].substring(0);
		            $GetEle(objthree).value = jsid[0].substring(0);
		        } else {
		            $GetEle(objtwo).innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
		            $GetEle(objthree).value = "";
		        }
		    }
	   }
	}
	
		function changebrotypeCallBack3(objjson,id){
		var type = objjson.type;
		var objone = objjson.objone;
		var objtwo = objjson.objtwo;
		var objthree = objjson.objthree;
		
		if (id){
		        if (id.id!="" && id.id != 0) {
		        	var wfcheckids=id.id;
		        	var wfchecknames=id.name;
		        	wfcheckids =wfcheckids.substr(1);
		            $G(objone).value= wfcheckids;
		            wfchecknames =wfchecknames.substr(1);
		            
		              var sHtml="";
		              wfcheckids=wfcheckids.split(",");
			          wfchecknames=wfchecknames.split(",");
			          for(var i=0;i<wfcheckids.length;i++){
			              sHtml = sHtml+wfchecknames[i]+"&nbsp;";
			          }
			          $G(objtwo).innerHTML = sHtml;
		        }else
		        {
		        	 $G(objtwo).innerHTML ="<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
	          		 $G(objone).value="";
		        }
	       }
	}
	
 	function changebrotype(type,objone,objtwo,objthree)
 	{
 		if(type=="1")
 		{
			var selevalue=$("#"+objone).val();
			
			if(selevalue=="1")
			{
			    var  tmpids = $("#"+objthree).val();
			    var url="";
			    if(tmpids==""){ 
			    	 url="/hrm/resource/MutiResourceBrowser.jsp";
			    }else{
					url="/hrm/resource/MutiResourceBrowser.jsp?resourceids="+tmpids;
			    }
			     
			    var dialog = new window.top.Dialog();
			
				dialog.currentWindow = window;
				dialog.Title = "<%=SystemEnv.getHtmlLabelName(33210,user.getLanguage()) %>";
			    dialog.URL = "/systeminfo/BrowserMain.jsp?url="+url;
				dialog.Width = 660;
				dialog.Height = 660;
				dialog.Drag = true;
				dialog.callbackfun=changebrotypeCallBack1;
		 		dialog.callbackfunParam={type:type,objone:objone,objtwo:objtwo,objthree:objthree};
				dialog.textAlign = "center";
				dialog.show();
			  
			}else if(selevalue=="2")
			{
				var  tmpids = $("#"+objthree).val();
			    if(tmpids!="-1"){ 
			      url=escape("/hrm/roles/MutiRolesBrowser.jsp?resourceids="+tmpids);
			    }else{
			      url=escape("/hrm/roles/MutiRolesBrowser.jsp");
			    }
			    
			    var dialog = new window.top.Dialog();
			
				dialog.currentWindow = window;
				dialog.Title = "<%=SystemEnv.getHtmlLabelName(34190,user.getLanguage()) %>";
			    dialog.URL = "/systeminfo/BrowserMain.jsp?url="+url;
				dialog.Width = 660;
				dialog.Height = 660;
				dialog.Drag = true;
				dialog.callbackfun=changebrotypeCallBack2;
		 		dialog.callbackfunParam={type:type,objone:objone,objtwo:objtwo,objthree:objthree};
				dialog.textAlign = "center";
				dialog.show();
			}
		
 		}else if(type=="2")
 		{
 			var rightid=$("#"+objone).val();
 			if(rightid=="")
 			{
 				alert("<%=SystemEnv.getHtmlLabelName(30623 ,user.getLanguage())%>"+"!");
 			}else
 			{
	 			var mark=$("#mark").val();
	 			var dialog = new window.top.Dialog();
			
				dialog.currentWindow = window;
				dialog.Title = "SAP";
			    dialog.URL = "/integration/browse/integrationSAPDataAuthSetting.jsp?mark="+mark+"&rightid="+rightid;
				dialog.Width = 660;
				dialog.Height = 660;
				dialog.Drag = true;
				//dialog.callbackfun=changebrotypeCallBack2;
		 		//dialog.callbackfunParam={type:type,objone:objone,objtwo:objtwo,objthree:objthree};
				dialog.textAlign = "center";
				dialog.show();
 			}
 		}
 		else if(type=="3")
 		{
 			var wfids=$("#"+objone).val();
 			
 			var dialog = new window.top.Dialog();
			
				dialog.currentWindow = window;
				dialog.Title = "SAP";
			    dialog.URL = "/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowMutiBrowser.jsp?wfids="+wfids;
				dialog.Width = 660;
				dialog.Height = 660;
				dialog.Drag = true;
				dialog.callbackfun=changebrotypeCallBack3;
		 		dialog.callbackfunParam={type:type,objone:objone,objtwo:objtwo,objthree:objthree};
				dialog.textAlign = "center";
				dialog.show();
 			
 		}
 	}
 	function changerole(autospan,autodeti)
 	{
 		$("#"+autospan).html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
 		$("#"+autodeti).attr("value","");
 	}
 	
 	
 	function backtableCallback(objjson,temp){
 		
 		var obj = objjson.obj;
 					
 		if(temp)
 		{
 		 if (temp.id!="" && temp.id != 0)
 		 {
			var tempsz=temp.id.split(",");
			$(obj).next().val(tempsz[1]);
			$(obj).next().next().html(tempsz[1]);
			$(obj).next().next().next().html("");
		 }else
		 {
		 	$(obj).next().val("");
		 	$(obj).next().next().html("");
		 	$(obj).next().next().next().html("<img src='/images/BacoError_wev8.gif' align=absMiddle>");
		 }
		}
 	}
 	function backtable(obj)
 	{
 		
 	
 		var dialog = new window.top.Dialog();
			
		dialog.currentWindow = window;
		dialog.Title = "SAP";
	    dialog.URL = "/integration/browse/integrationBackTable.jsp?workflowid=<%=workflowid%>&formid=<%=formid%>&isbill=<%=isbill%>";
		dialog.Width = 660;
		dialog.Height = 660;
		dialog.Drag = true;
		dialog.callbackfun=backtableCallback;
		dialog.callbackfunParam={obj:obj};
		dialog.textAlign = "center";
		dialog.show();
	
 	}
	</script>
</html>


