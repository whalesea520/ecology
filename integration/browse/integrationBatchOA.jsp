<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="com.weaver.integration.datesource.SAPInterationOutUtil"%>
<%@page import="com.weaver.integration.log.LogInfo"%>
<%@page import="com.weaver.integration.datesource.SAPFunctionParams"%>
<%@page import="com.weaver.integration.datesource.SAPFunctionImportParams"%>
<%@page import="com.weaver.integration.datesource.SAPFunctionExportParams"%>
<%@page import="com.weaver.integration.datesource.SAPFunctionBaseParamBean"%>
<%@page import="weaver.workflow.form.FormManager"%> 
<jsp:useBean id="FieldMainManager" class="weaver.workflow.field.FieldMainManager" scope="page" />
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WorkTypeComInfo" class="weaver.workflow.workflow.WorkTypeComInfo" scope="page" />

<HTML>
	<base target="_self">
<HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css></HEAD>
<%
		String formid=Util.getIntValue(request.getParameter("formid"),0)+"";
		String sFlag=Util.null2String(request.getParameter("sFlag"));
		String wf_id=Util.null2String(request.getParameter("wf_id"));//这个值来自于/integration/Monitoring/WfSystem.jsp
		String checkvalue=Util.null2String(request.getParameter("checkvalue"));//选中的一项值
		String updateTableName=Util.null2String(request.getParameter("updateTableName"));//得到主表或明显表的name,用于判断当前配置的浏览按钮放置在那张表中
		String w_type=Util.null2String(Util.getIntValue(request.getParameter("w_type"),0)+"");//0-表示是浏览按钮的配置信息，1-表示是节点后动作配置时的信息
		int isbill= Util.getIntValue(request.getParameter("isbill"),0);//0表示老表单,1表示新表单
		String srcType=Util.null2String(request.getParameter("srcType"));//这种情况来源于字段管理--新建字段 (detailfield=明细字段,mainfield=主字段)
		//接收回写表
		String backtable=Util.null2String(request.getParameter("backtable"));
		
		String se_fieldname=Util.null2String(request.getParameter("se_fieldname")).toUpperCase().trim();
		String  se_fielddesc=Util.null2String(request.getParameter("se_fielddesc")).toUpperCase().trim();
		
		//1输入参数，2--输入结构，7--输入表，3--输出参数，4--输出结构，5-输出表，6--权限设置
		String partype=Util.null2String(request.getParameter("partype"));
		//String formid="-139";
		//String updateTableName="formtable_main_139";
		String browsertype=Util.null2String(request.getParameter("browsertype"));
		if(!"".equals(wf_id)){
					RecordSet.execute("select formid,isbill from workflow_base where id="+wf_id+"");
					if(RecordSet.next()){
						formid=RecordSet.getString("formid");
						isbill=RecordSet.getInt("isbill");
					}
		} 
		
%>
<BODY>
<jsp:include page="/systeminfo/commonTabHead.jsp">
		   <jsp:param name="mouldID" value="integration"/>
		   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(19372,user.getLanguage()) %>"/> 
		</jsp:include>

<table id="topTitle" cellpadding="0" cellspacing="0" width="100%">
				<tr>
					<td width="160px">
					</td>
					<td class="rightSearchSpan"
						style="text-align: right; width: 500px !important">
						<input type="button" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>" id="zd_btn_submit_0" class="e8_btn_top" onclick="onseach()">						
						&nbsp;&nbsp;&nbsp;
						<span title="<%=SystemEnv.getHtmlLabelName(82753,user.getLanguage()) %>" class="cornerMenu"></span>
					</td>
				</tr>
			</table>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197 ,user.getLanguage())+",javascript:window.onseach(),_self} " ;
RCMenuHeight += RCMenuHeightStep;

RCMenu += "{"+SystemEnv.getHtmlLabelName(311 ,user.getLanguage())+",javascript:onClear(),_self} " ;
RCMenuHeight += RCMenuHeightStep;

RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:onCancel(),_self} " ;
RCMenuHeight += RCMenuHeightStep;

%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>


<form action="/integration/browse/integrationBatchOA.jsp" method="post"  id="SearchForm">



	<td valign="top">
	
		<wea:layout type="4Col">
			<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>' attributes="{'groupSHBtnDisplay':'none'}">
				<wea:item>
					<%=SystemEnv.getHtmlLabelName(685 ,user.getLanguage()) %>
				</wea:item>
				<wea:item>
					<input type='text' name='se_fieldname' value='<%=se_fieldname%>'>
				</wea:item>
				<wea:item>
					<%=SystemEnv.getHtmlLabelName(15456 ,user.getLanguage()) %>
				</wea:item>
				<wea:item>
					<input type='text' name='se_fielddesc' value='<%=se_fielddesc%>'>
				</wea:item>
			</wea:group>
		
		</wea:layout>
		<TABLE class=Shadow style="margin-bottom: 42px;">
		<tr>
		<td valign="top" width="100%">
			<input type='hidden'   name="formid"  value='<%=formid%>'>
			<input type="hidden"   name="updateTableName"  value="<%=updateTableName%>">
			<input type="hidden"   name="w_type"  value="<%=w_type%>">
			<input type="hidden"   name="isbill"  value="<%=isbill%>">
			<input type="hidden"   name="srcType"  value="<%=srcType%>">
			<input type="hidden"   name="backtable"  value="<%=backtable%>">
			<input type="hidden"   name="checkvalue"  value="<%=checkvalue%>">
			<input type="hidden"   name="partype"  value="<%=partype%>">
			<input type="hidden"   name="browsertype"  value="<%=browsertype%>">
		
<%

			out.println("<TABLE ID=BrowseTable class='BroswerStyle'   cellspacing='1' width='100%'>");
			out.println("<TR class=DataHeader>");
			out.println("<TH style='display:none' ></TH>");
			out.println("<TH width=25% >"+SystemEnv.getHtmlLabelName(685 ,user.getLanguage())+"</TH>");
			out.println("<TH width=25% >"+SystemEnv.getHtmlLabelName(15456 ,user.getLanguage())+"</TH>");
			out.println("<TH width=25% >"+SystemEnv.getHtmlLabelName(17997 ,user.getLanguage())+"</TH>");
			out.println("</tr>");
		
			out.println("<TR class=Line  style='height:1px;'><th colspan='2' ></Th></TR> ");
			String sql="";
			
			if("0".equals(w_type))
			{
					if("0".equals(formid)&&0==isbill){
						
									//这种情况来源于字段管理--新建字段
									 FieldMainManager.resetParameter() ;
							        FieldMainManager.setUserid(user.getUID());
							        int jk=0;
				        			if("mainfield".equals(srcType)){
					       				FieldMainManager.selectAllCodViewField();
					       			 	while(FieldMainManager.next()){
					       			 			String  zh_Fieldname=FieldMainManager.getFieldManager().getFieldname().toUpperCase().trim();
												String  zh_Fielddesc=FieldMainManager.getFieldManager().getDescription().toUpperCase().trim();
												if(zh_Fieldname.indexOf(se_fieldname)==-1){
													continue;
												}
												if(zh_Fielddesc.indexOf(se_fielddesc)==-1){
													continue;
												}
												if(jk%2==0)
												{
													out.println("<tr class=DataDark>");
												}else
												{
													out.println("<tr class=DataLight>");
												}
											
											out.println("<td style='display:none'>1_"+FieldMainManager.getFieldManager().getFieldid()+"</td>");//主表是1
											out.println("<td>"+zh_Fieldname+"</td>");
											out.println("<td>"+zh_Fielddesc+"</td>");
											out.println("<td>"+SystemEnv.getHtmlLabelName(18549 ,user.getLanguage())+"</td>");	
											out.println("</tr>");
											jk++;
										}
								}else{
						         	
							         	if("1".equals(partype)||"2".equals(partype)||"7".equals(partype)){
								         		FieldMainManager.selectAllCodViewField();
							       			 	while(FieldMainManager.next()){
							       			 			String  zh_Fieldname=FieldMainManager.getFieldManager().getFieldname().toUpperCase().trim();
														String  zh_Fielddesc=FieldMainManager.getFieldManager().getDescription().toUpperCase().trim();
														if(zh_Fieldname.indexOf(se_fieldname)==-1){
															continue;
														}
														if(zh_Fielddesc.indexOf(se_fielddesc)==-1){
															continue;
														}
														if(jk%2==0)
														{
															out.println("<tr class=DataDark>");
														}else
														{
															out.println("<tr class=DataLight>");
														}
													
													out.println("<td style='display:none'>1_"+FieldMainManager.getFieldManager().getFieldid()+"</td>");//主表是1
													out.println("<td>"+zh_Fieldname+"</td>");
													out.println("<td>"+zh_Fielddesc+"</td>");
													out.println("<td>"+SystemEnv.getHtmlLabelName(18549 ,user.getLanguage())+"</td>");	
													out.println("</tr>");
													jk++;
												}
										  }	
							         
							         	
										        		 FieldMainManager.selectAllCodViewDetailField();
										        		 while(FieldMainManager.next()){
								        		 			String  zh_Fieldname=FieldMainManager.getFieldManager().getFieldname().toUpperCase().trim();
															String  zh_Fielddesc=FieldMainManager.getFieldManager().getDescription().toUpperCase().trim();
															if(zh_Fieldname.indexOf(se_fieldname)==-1){
																continue;
															}
															if(zh_Fielddesc.indexOf(se_fielddesc)==-1){
																continue;
															}
															if(jk%2==0)
															{
																out.println("<tr class=DataDark>");
															}else
															{
																out.println("<tr class=DataLight>");
															}
														
														out.println("<td style='display:none'>0_"+FieldMainManager.getFieldManager().getFieldid()+"</td>");//明细是0
														out.println("<td>"+zh_Fieldname+"</td>");
														out.println("<td>"+zh_Fielddesc+"</td>");
														out.println("<td>"+SystemEnv.getHtmlLabelName(18550 ,user.getLanguage())+"</td>");	
														out.println("</tr>");
														jk++;
													}
										
							        }	
						   
						        
							
					}else{
							FormManager fManager = new FormManager();
							 if((fManager.isDetailTable(updateTableName)||updateTableName.indexOf("$_$")>=0)){//明细表
									if("1".equals(partype)||"2".equals(partype)||"7".equals(partype)){
										//1输入参数，2--输入结构，7--输入表，3--输出参数，4--输出结构，5-输出表，6--权限设置
										//明细表的参数来源只能是当前明细表+当前主表
										sql="select * from workflow_billfield where billid='"+formid+"'  order by viewtype";
									}else{
										//明细表的参数来源只能是当前明细表
										sql="select * from workflow_billfield where billid='"+formid+"' and detailtable='"+updateTableName+"' order by viewtype";
									}
									if(("1".equals(partype)||"2".equals(partype)||"7".equals(partype))&&"227".equals(browsertype)){
											//多选浏览按钮的输入参数、输入结构、输入表的数据只能来源于主表
											sql="select * from workflow_billfield where billid='"+formid+"' and (detailtable is null or detailtable='')  order by viewtype";
									}
									
							}
							else {
								//主表
								//主表的参数来源，只能是主表
								sql="select * from workflow_billfield where billid='"+formid+"' and (detailtable is null or detailtable='')  order by viewtype";
							}
							RecordSet.execute(sql);
							int jk=0;
							while(RecordSet.next())
							{
								int fieldid_t = Util.getIntValue(RecordSet.getString("id"), 0);
								String  zh_Fieldname=RecordSet.getString("fieldname").toUpperCase().trim();
								String  zh_Fielddesc=SystemEnv.getHtmlLabelName(Util.getIntValue(RecordSet.getString("fieldlabel")),user.getLanguage()).toUpperCase().trim();
								if(zh_Fieldname.indexOf(se_fieldname)==-1){
									continue;
								}
								if(zh_Fielddesc.indexOf(se_fielddesc)==-1){
									continue;
								}
								if(jk%2==0)
								{
									out.println("<tr class=DataDark>");
								}else
								{
									out.println("<tr class=DataLight>");
								}
									if("1".equals(RecordSet.getString("viewtype")))
									{
										out.println("<td style='display:none'>0_"+fieldid_t+"</td>");//明细表是0
										out.println("<td>"+zh_Fieldname+"</td>");
										out.println("<td>"+zh_Fielddesc+"</td>");
										//out.println("<td>"+updateTableName+"表字段(明细表)</td>");
										out.println("<td>"+SystemEnv.getHtmlLabelName(19325 ,user.getLanguage())+"</td>");
									}else
									{
										out.println("<td style='display:none'>1_"+fieldid_t+"</td>");//主表是1
										out.println("<td>"+zh_Fieldname+"</td>");
										out.println("<td>"+zh_Fielddesc+"</td>");
										//out.println("<td>"+updateTableName+"表字段(主表)</td>");
										out.println("<td>"+SystemEnv.getHtmlLabelName(21778 ,user.getLanguage())+"</td>");
									}
								out.println("</tr>");
								jk++;
							}
					}
			}else//表示是节点后动作
			{
					
						List  sysname=new ArrayList();
						List  sysdesc=new ArrayList();
						
						
						int jk_s=0;
						int jk=0;
						if(!"5".equals(partype)){
									
							
							sysname.add("REQUESTNAME");
							sysdesc.add(SystemEnv.getHtmlLabelName(26876, user.getLanguage()));
							sysname.add("REQUESTID");
							sysdesc.add(SystemEnv.getHtmlLabelName(18376, user.getLanguage()));
							sysname.add("CREATER");
							sysdesc.add(SystemEnv.getHtmlLabelName(882, user.getLanguage()));
							sysname.add("CREATEDATE");
							sysdesc.add(SystemEnv.getHtmlLabelName(772, user.getLanguage()));
							sysname.add("CREATETIME");
							sysdesc.add(SystemEnv.getHtmlLabelName(1339, user.getLanguage()));
							sysname.add("WORKFLOWNAME");
							sysdesc.add(SystemEnv.getHtmlLabelName(16579, user.getLanguage()));
							sysname.add("CURRENTUSE");
							sysdesc.add(SystemEnv.getHtmlLabelName(20558, user.getLanguage()));
							sysname.add("CURRENTNODE");
							sysdesc.add(SystemEnv.getHtmlLabelName(18564, user.getLanguage()));
						
					//	sysname.add("REQUESTMARK");
						//sysdesc.add(SystemEnv.getHtmlLabelName(19502, user.getLanguage()));
					
						for(int i=0;i<sysname.size();i++){
						
								if("228".equals(browsertype)&&i==0){//屏蔽流程标题不要了
												continue;
								}
								String  zh_Fieldname=(sysname.get(i)+"").toUpperCase().trim();
								String  zh_Fielddesc=sysdesc.get(i)+"".toUpperCase().trim();
								
								if(zh_Fieldname.indexOf(se_fieldname)==-1){
									continue;
								}
								if(zh_Fielddesc.indexOf(se_fielddesc)==-1){
									continue;
								}
								if(jk_s%2==0)
								{
									out.println("<tr class=DataDark>");
								}else
								{
									out.println("<tr class=DataLight>");
								}
								out.println("<td style='display:none'>1_"+((i+1)*-1)+"</td>");//(1表示主表，0表示明细表)+字段的id+是否新表单字段
								out.println("<td>"+zh_Fieldname+"</td>");
								out.println("<td>"+zh_Fielddesc+"</td>");
								out.println("<td>"+SystemEnv.getHtmlLabelName(21778 ,user.getLanguage())+"("+SystemEnv.getHtmlLabelName(28415 ,user.getLanguage())+")</td>");
								out.println("</tr>");
								jk_s++;
						}
					
						
						//主表字段循环
						
						if(isbill == 0){
							sql = "select fd.id, fd.fieldname, fl.fieldlable as fieldlabel from workflow_formdict fd left join workflow_formfield ff on ff.fieldid=fd.id left join workflow_fieldlable fl on fl.fieldid=fd.id and fl.langurageid="+user.getLanguage()+" and fl.formid="+formid+" where ff.formid="+formid+" order by fd.id";
						}else{
							sql = "select bf.id, bf.fieldname, hl.labelname as fieldlabel from workflow_billfield bf left join htmllabelinfo hl on hl.indexid=bf.fieldlabel and hl.languageid="+user.getLanguage()+" where (viewtype=0 or viewtype is null) and billid="+formid+" order by bf.dsporder";
						}
						RecordSet.execute(sql);
					
						while(RecordSet.next())
						{
								int fieldid_t = Util.getIntValue(RecordSet.getString("id"), 0);
								String fieldname=Util.null2String(RecordSet.getString("fieldname")).toUpperCase().trim();
								String fieldlabel_t = Util.null2String(RecordSet.getString("fieldlabel")).toUpperCase().trim();
								if(fieldname.indexOf(se_fieldname)==-1){
									continue;
								}
								if(fieldlabel_t.indexOf(se_fielddesc)==-1){
									continue;
								}
								if(jk%2==0)
								{
									out.println("<tr class=DataDark>");
								}else
								{
									out.println("<tr class=DataLight>");
								}
								out.println("<td style='display:none'>1_"+fieldid_t+"</td>");//(1表示主表，0表示明细表)+字段的id+是否新表单字段
								out.println("<td>"+fieldname+"</td>");
								out.println("<td>"+fieldlabel_t+"</td>");
								out.println("<td>"+SystemEnv.getHtmlLabelName(21778 ,user.getLanguage())+"</td>");
							out.println("</tr>");
							jk++;
						}
						
					}
					if(!"".equals(backtable))
					{
						//明细表循环
						if(isbill == 0){
							sql = "select distinct groupid from workflow_formfield where formid="+formid+" and isdetail='1' order by groupid";
						}else{
							sql = "select tablename as groupid, title from Workflow_billdetailtable where billid="+formid+" order by orderid";
						}
						RecordSet.execute(sql);
						int groupCount = 0;
						while(RecordSet.next()){//明细表循环开始
							groupCount++;
							String groupid_tmp = "";
							if(isbill == 0){
								groupid_tmp = ""+Util.getIntValue(RecordSet.getString("groupid"), 0);
							}else{
								groupid_tmp = Util.null2String(RecordSet.getString("groupid"));
							}
							//System.out.println("groupid_tmp"+groupid_tmp);
							//System.out.println("backtable"+backtable);
							if(!groupid_tmp.equals(backtable.replace("mx_","")))
							{
								continue;
							}
							if(isbill == 0){
								sql = "select fd.id, fd.fieldname, fl.fieldlable as fieldlabel from workflow_formdictdetail fd left join workflow_formfield ff on ff.fieldid=fd.id and ff.isdetail='1' and ff.groupid="+groupid_tmp+" left join workflow_fieldlable fl on fl.fieldid=fd.id and fl.langurageid="+user.getLanguage()+" and fl.formid="+formid+" where ff.formid="+formid+" order by fd.id";
							}else{
								sql = "select bf.id, bf.fieldname, hl.labelname as fieldlabel from workflow_billfield bf left join htmllabelinfo hl on hl.indexid=bf.fieldlabel and hl.languageid="+user.getLanguage()+" where bf.detailtable='"+groupid_tmp+"' and bf.viewtype=1 and bf.billid="+formid+" order by bf.dsporder";
							}
							//明细表字段循环
							RecordSet rs=new RecordSet();
							rs.execute(sql);
							while(rs.next()){
								int fieldid_t = Util.getIntValue(rs.getString("id"), 0);
								String fieldname=Util.null2String(rs.getString("fieldname")).toUpperCase().trim();
								String fieldlabel_t = Util.null2String(rs.getString("fieldlabel")).toUpperCase().trim();
								if(fieldname.indexOf(se_fieldname)==-1){
									continue;
								}
								if(fieldlabel_t.indexOf(se_fielddesc)==-1){
									continue;
								}
								if(jk%2==0)
								{
									out.println("<tr class=DataDark>");
								}else
								{
									out.println("<tr class=DataLight>");
								}
								out.println("<td style='display:none'>0_"+fieldid_t+"</td>");//(1表示主表，0表示明细表)+字段的id+是否新表单字段
								out.println("<td>"+fieldname+"</td>");
								out.println("<td>"+fieldlabel_t+"</td>");
									out.println("<td>"+SystemEnv.getHtmlLabelName(19325, user.getLanguage())+groupCount+SystemEnv.getHtmlLabelName(261, user.getLanguage())+"</td>");
								out.println("</tr>");
								jk++;
							}
																
						}
					}
			}
	 	out.println("</TABLE>");
%>
</td>
		</tr>
		</TABLE>
	
</form>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout needImportDefaultJsAndCss="false">
	<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
		<wea:item type="toolbar">
		 <input type="button" value="<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="onClear();"/>
		
	     <input type="button" value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="onCancel();"/>
	    </wea:item>
	</wea:group>
	</wea:layout>
</div>	
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include> 

</BODY></HTML>

<SCRIPT LANGUAGE="javascript">
var viewtypes = "";
var names = "";
var descs = "";
var dialog = top.getDialog(parent);

//多选
jQuery(window).ready(function(){
	//alert(jQuery("#BrowseTable").find("tr").length)
	jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind("click",function(event){
		
		if($(this)[0].tagName=="TR"&&event.target.tagName!="INPUT"){
							viewtypes = ","+jQuery(this).find("td:eq(0)").text()
					   		names =","+jQuery(this).find("td:eq(1)").text()
					   		descs=","+jQuery(this).find("td:eq(2)").text()
							<%if("1".equals(sFlag)){%>
							if(viewtypes.indexOf("_")>0){
								names=","+viewtypes.split("_")[1];								
							}
							<%}%>
					   		submitData();
		}
	})
	jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind("mouseover",function(){
		$(this).addClass("Selected")
	})
	jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind("mouseout",function(){
		$(this).removeClass("Selected")
	})

});

function btnok_onclick() {
	if(dialog){
		try{
	  	dialog.callback({name:names,desc:descs,viewtype: viewtypes});
	  	}catch(e){alert(e)}
	  	
	  	try{
		     dialog.close({name:names,desc:descs,viewtype: viewtypes});
		
		 }catch(e){alert(e)}
		dialog.callback();
	}else{
		window.parent.returnValue = { name:names,desc:descs,viewtype: viewtypes};//Array(documentids,documentnames)
    	window.parent.close();
	}
}
function onSubmit() {
		$G("SearchForm").submit()
}
function onReset() {
		$G("SearchForm").reset()
}
function submitData()
{
	btnok_onclick();
}
function onClear()
{
	if(dialog){
		try{
	  	dialog.callback({viewtype: "-1",name: "",desc:""});
	  	}catch(e){alert(e)}
	  	
	  	try{
		     dialog.close({viewtype: "-1",name: "",desc:""});
		
		 }catch(e){alert(e)}
    }else{
    	window.parent.returnValue = {viewtype: "-1",name: "",desc:""};
	    window.parent.close();
    }
}

function onCancel()
{
	if(dialog){
	  	dialog.close();
    }else{
	    window.parent.close();
    }
}

function onseach(){
	$("#SearchForm").submit()
}
</script>
