
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<%@page import="com.weaver.integration.datesource.*,com.weaver.integration.params.*,com.weaver.integration.log.*"%>
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
<html>
	<head>
		<title><%=SystemEnv.getHtmlLabelName(26968,user.getLanguage())%></title>
	</head>

	
	<!-- 业务逻辑 start-->
	<%
			
			
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
			String browserId = Util.null2String(request.getParameter("browserId"));
			String servId = Util.null2String(request.getParameter("servId"));
			String poolid = Util.null2String(request.getParameter("poolid"));
			
			SAPFunctionStatusBean ssb = ServiceParamsUtil.getStatusByServId(servId, new LogInfo());
			boolean impTableStatus = false;
			boolean impStructStatus = false;
			boolean impStrStatus = false;
			boolean expTableStatus = false;
			boolean expStructStatus = false;
			boolean expStrStatus = false;
			if(ssb != null) {
				impTableStatus = ssb.isImpTableStatus();
				impStructStatus = ssb.isImpStructStatus();
				impStrStatus = ssb.isImpStrStatus();
				expTableStatus = ssb.isExpTableStatus();
				expStructStatus = ssb.isExpStructStatus();
				expStrStatus = ssb.isExpStrStatus();
			}
			
			int sap_inParameter=1;//输入参数计数器
			int sap_inStructure=1;//输入结构计数器
			int sap_outParameter=1;
			int sap_outStructure=1;
			int sap_outTable=1;
			int int_authorizeRight=1;
			int sap_inTable=1;
			String sql="";
			String opera="";//
			opera = "".equals(browserId)?"save":"update";
			//第一个参数--输入参数
			ServiceParamModeStatusBean spmsb =new ServiceParamModeStatusBean();
			if(!"".equals(browserId)){//
					 spmsb =ServiceParamModeDisUtil.getServParModStaBeanById(servId, browserId);
			}
			StringBuffer sapinParameter01= new StringBuffer();
//		sapinParameter01.append("<TABLE class='ListStyle marginTop0 sapitem ' cellspacing=1 id='sap_01' style='height:100%;table-layout: fixed;'>");
		sapinParameter01.append("<TABLE class='ListStyle marginTop0 sapitem ' cellspacing=1 id='sap_01' style='table-layout: fixed;'>");
		sapinParameter01.append(" <colgroup> <col width='119px'/>  <col width='*' /> </colgroup>");

			sapinParameter01.append("<tr class=''>");
			sapinParameter01.append("<td colspan='2'>");
				sapinParameter01.append(" <TABLE class=ListStyle cellspacing=1 id='chind01' style='table-layout: fixed;'>");
				sapinParameter01.append(" <colgroup> <col width='113px'/> <col width='80px'/><col width='210px'/><col width='80px'/><col width='200px'/><col width='80px'/><col width='*'/></colgroup>");
				sapinParameter01.append(" <tr class=header>");
				sapinParameter01.append(" <td><input type='checkbox' id='cbox_01'/>"+SystemEnv.getHtmlLabelName(556,user.getLanguage())+"</td><td colspan='6'>"+SystemEnv.getHtmlLabelName(30605,user.getLanguage())+"</td>");
				sapinParameter01.append(" </tr>");
				
					if("update".equals(opera))
					{
							List list = ServiceParamModeDisUtil.getParamsModeDisById(servId, browserId, "import", false, "", "");
							if(list != null) {
								for(int i=0;i<list.size();i++) {
									ServiceParamModeDisBean spmdb = (ServiceParamModeDisBean)list.get(i);
									String input01="sap01_"+sap_inParameter;
									String input01Span="sap01_"+sap_inParameter+"Span";
									String input02="sapDesc01_"+sap_inParameter;
									String input03="con01_"+sap_inParameter;
									
									String temp = "<tr style='height:40px;'><td><input type='checkbox' name='cbox1'></td><td>"+SystemEnv.getHtmlLabelName(28247,user.getLanguage())+"</td>";
									temp += "<td style='padding-top:6px;'><span><button type='button' class='e8_browflow' onclick=addOneFieldObj(1,"+sap_inParameter+")></button></span>";
									temp += "<span id='"+input01Span+"' style='vertical-align: middle;width:7px;'></span>";
									temp += "<span style='vertical-align: middle;'><input type='text' name='"+input01+"' value='"+spmdb.getParamName()+"' style='border:1px solid #D4E9E9;height:28px;' onchange='javascript:sapFieldChange(1,this)'></span>";
									temp += "</td><td>"+SystemEnv.getHtmlLabelName(30708,user.getLanguage())+"</td><td style='padding-top:5px;'><input type='text' name='"+input02+"' style='border:1px solid #D4E9E9;width:185px;height:28px;' value='"+spmdb.getParamDesc()+"'></td>";
									temp += "<td>"+SystemEnv.getHtmlLabelName(453,user.getLanguage())+"</td><td style='padding-top:5px;'><input type='text' ";
									temp += "name='"+input03+"' value='"+spmdb.getParamCons()+"' style='border:1px solid #D4E9E9;width:170px;height:28px;'></td></tr>";
									sapinParameter01.append(temp);
									sap_inParameter++;
								}
							}
					}
			sapinParameter01.append(" </TABLE>");
			sapinParameter01.append("</td>");
			sapinParameter01.append("</tr>"); 
			sapinParameter01.append("</table>");
			
			//第二个参数--输入结构
			StringBuffer sapinParameter02= new StringBuffer();										  	
			sapinParameter02.append("<TABLE class='ListStyle marginTop0 sapitem' cellspacing=1 id='sap_02' style='table-layout: fixed;'>");
			sapinParameter02.append(" <colgroup> <col width='120px'/>  <col width='*' /> </colgroup>");										 
					if("update".equals(opera))
					{	
						List list = ServiceParamModeDisUtil.getParamsModeDisById(servId, browserId, "import", true, "struct", "");
						if(list != null) {
							for(int i=0;i<list.size();i++) {
								ServiceParamModeDisBean spmdb = (ServiceParamModeDisBean)list.get(i);
								String newstru="stru_"+sap_inStructure;
								String newstruSpan="stru_"+sap_inStructure+"span";
								String newname="cbox2_"+sap_inStructure;
								String bath="bath2_"+sap_inStructure;
								String newtable="sap_02"+"_"+sap_inStructure;
								String addFieldBtn = "addstru_"+sap_inStructure;
								String delFieldBtn = "delstru_"+sap_inStructure;
								int newchtable = ServiceParamModeDisUtil.getCompFieldCountByName(servId, browserId, "import", spmdb.getParamName());
								int childstu=1;
								String temp = "<tr class='DataDark'><td class='tdcenter'><input type='checkbox' name='cbox2'></td>"; 	
								temp += "<td style='padding-top:0px;padding-bottom:0px;'><table   cellspacing=1 style='width:100%;margin-top:0px;margin-bottom:0px;padding-top:0;padding-bottom:0;'><tr class='DataDark'><td style='width:50px;vertical-align: middle;'>"+SystemEnv.getHtmlLabelName(30609,user.getLanguage())+"</td><td style='width:220px;'><button type='button' class='e8_browflow' "; 
								temp += " style='vertical-align: middle;' onclick=addOneFieldObj(2,"+sap_inStructure+",'"+newstru+"')></button>"; 
								temp += "<span id='"+newstruSpan+"' style='vertical-align: middle;width:15px;'>"; 
								temp += " </span> <span><input type='text' name='"+newstru+"' id='"+newstru+"' value='"+spmdb.getParamName()+"' onchange='javascript:sapFieldChange(2,this)' style='width:180px;height:28px;border:1px solid #D4E9E9;vertical-align: middle;' ></span>";
								temp += " </td><td>";
								temp += " <input type='hidden' id='"+newname+"' name='"+newname+"' value='"+newchtable+"'></td></tr></table>";
								temp += " <TABLE class=ListStyle style='margin-top:0px;' cellspacing=1 id='"+newtable+"'>";
								temp += "  <tr class=header><td style='width:100px;'><input type='checkbox'"; 
								temp += " onclick='checkbox2(this,"+sap_inStructure+")'/>"+SystemEnv.getHtmlLabelName(556,user.getLanguage())+"</td><td style='text-align:right;' colspan='7'>";
								temp += "<input type='button'  class='addbtnB' id='"+bath+"'"; 
								temp += " onclick=addBathFieldObj(3,1,'"+newstru+"','"+sap_inStructure+"') title='"+SystemEnv.getHtmlLabelName(25055,user.getLanguage())+"'>"; 
								temp += " <input type='button' class='addbtn' id='"+addFieldBtn+"' ";  
								temp += " onclick=addBathFieldObj(3,2,'"+newstru+"','"+sap_inStructure+"') title='"+SystemEnv.getHtmlLabelName(611,user.getLanguage())+"'>";
								temp += " <input type='button' class='delbtn' id='"+delFieldBtn+"' "; 
								temp += " onclick=addBathFieldObj(3,3,'"+newstru+"','"+sap_inStructure+"') title"+SystemEnv.getHtmlLabelName(23777,user.getLanguage())+"'>"; 
								temp += "</td></tr>";
								
								List listtemp = ServiceParamModeDisUtil.getParamsModeDisById(servId, browserId, "import", false, "", spmdb.getParamName());
								if(listtemp != null) {
									for(int j=0;j<listtemp.size();j++) {
										ServiceParamModeDisBean spmdbtemp = (ServiceParamModeDisBean)listtemp.get(j);
										String input01="sap02_"+sap_inStructure+"_"+childstu;
										String input03="con02_"+sap_inStructure+"_"+childstu;
										String input01Desc = "sapDesc02_"+sap_inStructure+"_"+childstu;
										String input01Span="sap02_"+sap_inStructure+"_"+childstu+"span";
										String numstemp = sap_inStructure+"_"+childstu;
										temp += "<tr class='DataDark'><td><input type='checkbox' name='zibox'></td><td style='width:90px;vertical-align: middle;'>"+SystemEnv.getHtmlLabelName(28247,user.getLanguage())+"</td><td style='width:208px;padding-top: 6px;padding-bottom:6px;'>";
										temp += "<button type='button' style='vertical-align: middle;' class='e8_browflow'";
										temp += " onclick=addOneFieldObj(3,'"+numstemp+"','stru_"+sap_inStructure+"')></button>";
										temp += "<span id='"+input01Span+"' style='vertical-align: middle;width:7px;'></span>";
										temp += "<input type='text' name='"+input01+"'";  
										temp += " value='"+spmdbtemp.getParamName()+"' onchange='javascript:sapFieldChange(3,this)' style='vertical-align: middle;border:1px solid #D4E9E9;height:28px;'>";
										temp += "</td><td style='width:90px;vertical-align: middle;'>"+SystemEnv.getHtmlLabelName(30708,user.getLanguage())+"</td><td style='width:180px;padding-top: 5px;padding-bottom:5px;'>"; 
										temp += "<input type='text' name='"+input01Desc+"'";  
										temp += " value='"+spmdbtemp.getParamDesc()+"' style='vertical-align: middle;border:1px solid #D4E9E9;height:28px;'>";
										temp += "</td><td style='width:80px;vertical-align: middle;'>"+SystemEnv.getHtmlLabelName(453,user.getLanguage())+"</td>";
										temp += "<td style='padding-top:5px;padding-bottom:5px;'><input type='text' name='"+input03+"' value='"+spmdbtemp.getParamCons()+"' style='border:1px solid #D4E9E9;height:28px;'></td></tr>";
										childstu ++;
									}
								}
								temp += " </TABLE></td></tr>";
								sapinParameter02.append(temp);
								sap_inStructure++;
							}
						}
					}	
												  	
			sapinParameter02.append(" </TABLE>");													
														
			//第三个--输出参数							 
																			  	
			StringBuffer sapinParameter03= new StringBuffer();
			sapinParameter03.append("<TABLE class='ListStyle marginTop0 sapitem' cellspacing=1 id='sap_03' style='table-layout: fixed;'>");
			sapinParameter03.append(" <colgroup> <col width='119px'/>  <col width='*' /> </colgroup>");
			sapinParameter03.append("<tr class=''>");
			sapinParameter03.append("<td colspan='2'>");
			sapinParameter03.append(" <TABLE class=ListStyle cellspacing=1 id='chind03' style='table-layout: fixed;'>");
			sapinParameter03.append(" <colgroup> <col width='113px'/> <col width='80px'/><col width='210px'/><col width='80px'/><col width='*'/></colgroup>");
			sapinParameter03.append(" <tr class=header>");
			sapinParameter03.append(" <td><input type='checkbox' id='cbox_03'/>"+SystemEnv.getHtmlLabelName(556,user.getLanguage())+"</td><td colspan='4'>"+SystemEnv.getHtmlLabelName(30605,user.getLanguage())+"</td>");
			sapinParameter03.append(" </tr>");
			//sapinParameter03.append(" <TR class=Line style='height:1px'><TD colSpan=5 style='padding:0px'></TD></TR>");
					
			if("update".equals(opera)){
				List list = ServiceParamModeDisUtil.getParamsModeDisById(servId, browserId, "export", false, "", "");
				if(list != null) {
					for(int i=0;i<list.size();i++) {
						ServiceParamModeDisBean spmdb = (ServiceParamModeDisBean)list.get(i);
						String input01="sap03_"+sap_outParameter;
						String input01Span="sap03_"+sap_outParameter+"span";
						String input02="sapDesc03_"+sap_outParameter;//显示名--文本框
						String temp = "<tr style='height:40px;'><td><input type='checkbox' name='cbox3'></td><td>"+SystemEnv.getHtmlLabelName(28247,user.getLanguage())+"</td>";
						temp += "<td style='padding-top:6px;'><span><button type='button' class='e8_browflow' onclick=addOneFieldObj(4,"+sap_outParameter+")></button></span>";
						temp += "<span id='"+input01Span+"' style='vertical-align: middle;width:7px;'></span>";
						temp += "<span style='vertical-align: middle;'><input type='text' name='"+input01+"' value='"+spmdb.getParamName()+"' style='border:1px solid #D4E9E9;height:28px;' onchange='javascript:sapFieldChange(4,this)'></span>";
						temp += "</td><td>"+SystemEnv.getHtmlLabelName(30708,user.getLanguage())+"</td><td style='padding-top:5px;'><input type='text' name='"+input02+"' value='"+spmdb.getParamDesc()+"' style='border:1px solid #D4E9E9;width:185px;height:28px;'></td></tr>";
						sapinParameter03.append(temp);
						sap_outParameter++;
					}
				}		
			}
			
			sapinParameter03.append(" </TABLE>");
			sapinParameter03.append("</td>");
			sapinParameter03.append("</tr>"); 
			sapinParameter03.append("</table>");																		
																						
																					
			//第四个----输出结构																
																						
			StringBuffer sapinParameter04= new StringBuffer();
			sapinParameter04.append("<TABLE class='ListStyle marginTop0 sapitem' cellspacing=1 id='sap_04' style='table-layout: fixed;'>");
			sapinParameter04.append(" <colgroup> <col width='120px'/>  <col width='*' /> </colgroup>");										 
				
			
				if("update".equals(opera)) {	
					List list = ServiceParamModeDisUtil.getParamsModeDisById(servId, browserId, "export", true, "struct", "");
					if(list != null) {
						for(int i=0;i<list.size();i++) {
							ServiceParamModeDisBean spmdb = (ServiceParamModeDisBean)list.get(i);
							String stuname= spmdb.getParamName();
							String newname="cbox4"+"_"+sap_outStructure;
							String newtable="sap_04"+"_"+sap_outStructure;
							String newstru="outstru_"+sap_outStructure;
							String newstruSpan="outstru_"+sap_outStructure+"span";
							String bath="bath4_"+sap_outStructure;
							String addFieldBtn = "addoutstru_"+sap_outStructure;
							String delFieldBtn = "deloutstru_"+sap_outStructure;
							int newchtable = ServiceParamModeDisUtil.getCompFieldCountByName(servId, browserId, "export",stuname);
							int childstu=1;
							String temp = "<tr class='DataDark'><td class='tdcenter'><input type='checkbox' name='cbox4'></td>"; 	
							temp += "<td style='padding-top:0px;padding-bottom:0px;'><table   cellspacing=1 style='width:100%;margin-top:0px;margin-bottom:0px;padding-top:0;padding-bottom:0;'><tr class='DataDark'><td style='width:50px;vertical-align: middle;'>"+SystemEnv.getHtmlLabelName(30609,user.getLanguage())+"</td><td style='width:220px;'><button type='button' class='e8_browflow' "; 
							temp += " style='vertical-align: middle;' onclick=addOneFieldObj(5,"+sap_outStructure+",'"+newstru+"')></button>"; 
							temp += "<span id='"+newstruSpan+"' style='vertical-align: middle;width:12px;'>"; 
							temp += "</span> <span><input type='text' name='"+newstru+"' id='"+newstru+"' onchange='javascript:sapFieldChange(5,this)' value='"+stuname+"'  style='width:180px;height:28px;border:1px solid #D4E9E9;vertical-align: middle;' ></span>";
							temp += " </td><td>"; 
							temp += " <input type='hidden' id='"+newname+"' name='"+newname+"' value='"+newchtable+"'></td></tr></table>";
							temp += " <TABLE class=ListStyle style='margin-top:0px;width:100%;' cellspacing=1 id='"+newtable+"'>";
							temp += "  <tr class=header><td style='width:100px;'><input type='checkbox'"; 
							temp += " onclick='checkbox4(this,"+sap_outStructure+")'/>"+SystemEnv.getHtmlLabelName(556,user.getLanguage())+"</td>";
							temp += " <td colspan='4' style='text-align:right;'>";
							temp += " <input type='button'  class='addbtnB' id='"+bath+"'  onclick=addBathFieldObj(6,1,'"+newstru+"','"+sap_outStructure+"') title='"+SystemEnv.getHtmlLabelName(25055,user.getLanguage())+"'>"; 
							temp += " <input type='button' class='addbtn' id='"+addFieldBtn+"' "; 
							temp += " onclick=addBathFieldObj(6,2,'"+newstru+"','"+sap_outStructure+"') title='"+SystemEnv.getHtmlLabelName(611,user.getLanguage())+"'>";
							temp += " <input type='button' class='delbtn' id='"+delFieldBtn+"' "; 
							temp += " onclick=addBathFieldObj(6,3,'"+newstru+"','"+sap_outStructure+"') title='"+SystemEnv.getHtmlLabelName(23777,user.getLanguage())+"'>";
							//temp += " </td></tr> <TR class=Line style='height:1px'><TD  style='padding:0px' colspan='5'>";
							temp += " </TD></TR>";
							List listtemp = ServiceParamModeDisUtil.getParamsModeDisById(servId, browserId, "export", false, "", stuname);
							if(listtemp != null) {
								for(int j=0;j<listtemp.size();j++) {
									ServiceParamModeDisBean spmdbtemp = (ServiceParamModeDisBean)listtemp.get(j);
									String input01="sap04_"+sap_outStructure+"_"+childstu;
									String input01Span="sap04_"+sap_outStructure+"_"+childstu+"span";
									String input01Desc = "sapDesc04_"+sap_outStructure+"_"+childstu;
									String numstemp = sap_outStructure+"_"+childstu;
									temp += "<tr class='DataDark'><td style='width:100px;'><input type='checkbox' name='zibox'></td><td style='width:90px;vertical-align: middle;'>"+SystemEnv.getHtmlLabelName(28247,user.getLanguage())+"</td><td style='width:208px;padding-top: 6px;padding-bottom:6px;'>";
									temp += "<button type='button' style='vertical-align: middle;' class='e8_browflow'";
									temp += " onclick=addOneFieldObj(6,'"+numstemp+"','outstru_"+sap_outStructure+"')></button>";
									temp += "<span id='"+input01Span+"' style='vertical-align: middle;width:7px;'></span>";
									temp += "<input type='text' name='"+input01+"'";  
									temp += " value='"+spmdbtemp.getParamName()+"' onchange='javascript:sapFieldChange(6,this)' style='vertical-align: middle;border:1px solid #D4E9E9;height:28px;'>";
									temp += "</td><td style='width:90px;vertical-align: middle;'>"+SystemEnv.getHtmlLabelName(30708,user.getLanguage())+"</td><td style='padding-top: 5px;padding-bottom:5px;'>"; 
									temp += "<input type='text' name='"+input01Desc+"'";  
									temp += " value='"+spmdbtemp.getParamDesc()+"' style='vertical-align: middle;border:1px solid #D4E9E9;height:28px;'>";
									temp += "</td></tr>";
									childstu ++;
								}
							}
						
							
							temp += "</table></td></tr>";
							sapinParameter04.append(temp);//解决有输出结构，输出表显示不出来的问题
							sap_outStructure ++;
						}
					}
				}									  	
			sapinParameter04.append(" </TABLE>");																				
																					
													
																				
			//第五个----输出表																																		
			StringBuffer sapinParameter05= new StringBuffer();
			sapinParameter05.append("<TABLE class='ListStyle marginTop0 sapitem' cellspacing=1 id='sap_05' style='table-layout: fixed;'>");
			sapinParameter05.append(" <colgroup> <col width='120px'/>  <col width='*' /> </colgroup>");										 

			
			if("update".equals(opera))
			{
				List list = ServiceParamModeDisUtil.getParamsModeDisById(servId, browserId, "export", true, "table", "");
				if(list != null) {
					for(int i=0;i<list.size();i++) {
						ServiceParamModeDisBean spmdb = (ServiceParamModeDisBean)list.get(i);
						String stuname= spmdb.getParamName();
						String newname="cbox5"+"_"+sap_outTable;
						String newtable="sap_05"+"_"+sap_outTable;
						String newstru="outtable_"+sap_outTable;
						String newstruSpan="outtable_"+sap_outTable+"span";
						String bath="bath5_"+sap_outTable;
						String addFieldBtn = "addouttable_"+sap_outTable;
						String delFieldBtn = "delouttable_"+sap_outTable;
						int newchtable = ServiceParamModeDisUtil.getCompFieldCountByName(servId, browserId, "export",stuname);
						int childstu=1;
						String temp = "<tr class='DataDark'><td class='tdcenter'><input type='checkbox' name='cbox5'></td>"; 	
						temp += "<td style='padding-top:0px;padding-bottom:0px;'><table   cellspacing=1 style='width:100%;margin-top:0px;margin-bottom:0px;padding-top:0;padding-bottom:0;'><tr class='DataDark'><td style='width:50px;vertical-align: middle;'>表名</td><td style='width:220px;'><button type='button' class='e8_browflow' "; 
						temp += " style='vertical-align: middle;' onclick=addOneFieldObj(7,"+sap_outTable+",'"+newstru+"')></button>"; 
						temp += "<span id='"+newstruSpan+"' style='vertical-align: middle;width:12px;'>"; 
						temp += "</span> <span><input type='text' name='"+newstru+"' id='"+newstru+"' value='"+stuname+"' onchange='javascript:sapFieldChange(7,this)'  style='width:180px;height:28px;border:1px solid #D4E9E9;vertical-align: middle;' ></span>";
						temp += " </td><td>"; 
						temp += " <input type='hidden' id='"+newname+"' name='"+newname+"' value='"+newchtable+"'></td></tr></table>";
						temp += " <TABLE class=ListStyle style='margin-top:0px;width:100%;' cellspacing=1 id='"+newtable+"'>";
						temp += "  <tr class=header><td style='width:100px;'><input type='checkbox'"; 
						temp += " onclick='checkbox5(this,"+sap_outTable+")'/>"+SystemEnv.getHtmlLabelName(556,user.getLanguage())+"</td>";
						temp += " <td colspan='4' style='text-align:right;'>";
						temp += " <input type='button'  class='addbtnB' id='"+bath+"'  onclick=addBathFieldObj(8,1,'"+newstru+"','"+sap_outTable+"')  title='"+SystemEnv.getHtmlLabelName(25055,user.getLanguage())+"'>";
						temp += " <input type='button' class='addbtn' id='"+addFieldBtn+"' "; 
						temp += " onclick=addBathFieldObj(8,2,'"+newstru+"','"+sap_outTable+"')  title='"+SystemEnv.getHtmlLabelName(611,user.getLanguage())+"'>";
						temp += " <input type='button' class='delbtn' id='"+delFieldBtn+"' "; 
						temp += " onclick=addBathFieldObj(8,3,'"+newstru+"','"+sap_outTable+"')  title='"+SystemEnv.getHtmlLabelName(23777,user.getLanguage())+"'>";
						//temp += " </td></tr> <TR class=Line style='height:1px'><TD  style='padding:0px' colspan='5'>";
						temp += " </TD></TR>";	
						
						List listtemp = ServiceParamModeDisUtil.getParamsModeDisById(servId, browserId, "export", false, "", stuname);
						if(listtemp != null) {
							for(int j=0;j<listtemp.size();j++) {
								ServiceParamModeDisBean spmdbtemp = (ServiceParamModeDisBean)listtemp.get(j);
								String input01="sap05_"+sap_outTable+"_"+childstu;
								String input01Span="sap05_"+sap_outTable+"_"+childstu+"span";
								String input01Desc = "sapDesc05_"+sap_outTable+"_"+childstu;
								String numstemp = sap_outTable+"_"+childstu;
								temp += "<tr class='DataDark'><td style='width:100px;'><input type='checkbox' name='zibox'></td><td style='width:90px;vertical-align: middle;'>"+SystemEnv.getHtmlLabelName(28247,user.getLanguage())+"</td><td style='width:208px;padding-top: 6px;padding-bottom:6px;'>";
								temp += "<button type='button' style='vertical-align: middle;' class='e8_browflow'";
								temp += " onclick=addOneFieldObj(8,'"+numstemp+"','outtable_"+sap_outTable+"')></button>";
								temp += "<span id='"+input01Span+"' style='vertical-align: middle;width:7px;'></span>";
								temp += "<input type='text' name='"+input01+"'";  
								temp += " value='"+spmdbtemp.getParamName()+"' onchange='javascript:sapFieldChange(8,this)' style='vertical-align: middle;border:1px solid #D4E9E9;height:28px;'>";
								temp += "</td><td style='width:90px;vertical-align: middle;'>"+SystemEnv.getHtmlLabelName(30708,user.getLanguage())+"</td><td style='padding-top: 5px;padding-bottom:5px;'>"; 
								temp += "<input type='text' name='"+input01Desc+"'";  
								temp += " value='"+spmdbtemp.getParamDesc()+"' style='vertical-align: middle;border:1px solid #D4E9E9;height:28px;'>";
								temp += "</td></tr>";
								childstu ++;
							}
						}	
						temp += "</TABLE></td></tr>";
						sapinParameter05.append(temp);
						sap_outStructure ++;
					}
				}
			}	
			sapinParameter05.append(" </TABLE>");																			
																				
																				
			
			
			
			//第七个----输入表																																		
			StringBuffer sapinParameter07= new StringBuffer();
			sapinParameter07.append("<TABLE class='ListStyle marginTop0 sapitem' cellspacing=1 id='sap_07' style='table-layout: fixed;'>");
			sapinParameter07.append(" <colgroup> <col width='120px'/>  <col width='*' /> </colgroup>");										 
	
			
			if("update".equals(opera))
			{
				List list = ServiceParamModeDisUtil.getParamsModeDisById(servId, browserId, "import", true, "table", "");
				if(list != null) {
					for(int i=0;i<list.size();i++) {
						ServiceParamModeDisBean spmdb = (ServiceParamModeDisBean)list.get(i);
						String newname="cbox7"+"_"+sap_inTable;
						String newstru="outtable7_"+sap_inTable;
						String newtable="sap_07"+"_"+sap_inTable;
						String newstruSpan="outtable7_"+sap_inTable+"span";
						String bath="bath7_"+sap_inTable;
						String addFieldBtn = "addtable_"+sap_inTable;
						String delFieldBtn = "deltable_"+sap_inTable;
						String stuname= spmdb.getParamName();
						int newchtable = ServiceParamModeDisUtil.getCompFieldCountByName(servId, browserId, "import",stuname);
						int childstu=1;
						String temp = "<trclass='DataDark'><td class='tdcenter'><input type='checkbox' name='cbox7'></td>"; 	
						temp += "<td style='padding-top:0px;padding-bottom:0px;'>"; 
					   temp += "<table   cellspacing=1 style='width:100%;margin-top:0px;margin-bottom:0px;padding-top:0;padding-bottom:0;'><tr class='DataDark'><td style='width:50px;vertical-align: middle;'>表名</td><td style='width:220px;'><button type='button' class='e8_browflow' ";
					    temp += " style='vertical-align: middle;' onclick=addOneFieldObj(10,"+sap_inTable+",'"+newstru+"')></button>"; 
					    temp += "<span id='"+newstruSpan+"' style='vertical-align: middle;width:12px;'>"; 
					    temp += "</span> <span><input type='text' name='"+newstru+"' id='"+newstru+"' value='"+stuname+"' onchange='javascript:sapFieldChange(10,this)'  style='width:180px;height:28px;border:1px solid #D4E9E9;vertical-align: middle;' ></span>";
					    temp += " </td><td>"; 
					    temp += " <input type='hidden' id='"+newname+"' name='"+newname+"' value='"+newchtable+"'></td></tr></table>";
					    temp += " <TABLE class=ListStyle style='margin-top:0px;' cellspacing=1 id='"+newtable+"'>";
					    temp += "  <tr class=header><td style='width:100px;'><input type='checkbox'"; 
					    temp += " onclick='checkbox7(this,"+sap_inTable+")'/>"+SystemEnv.getHtmlLabelName(556,user.getLanguage())+"</td>";
					    temp += " <td colspan='7' style='text-align:right;'>";
					    temp += " <input type='button'  class='addbtnB' id='"+bath+"'  onclick=addBathFieldObj(11,1,'"+newstru+"','"+sap_inTable+"') title='"+SystemEnv.getHtmlLabelName(25055,user.getLanguage())+"'>"; 
					    temp += " <input type='button' class='addbtn' id='"+addFieldBtn+"' "; 
					    temp += " onclick=addBathFieldObj(11,2,'"+newstru+"','"+sap_inTable+"')  title='"+SystemEnv.getHtmlLabelName(611,user.getLanguage())+"'>";
					    temp += " <input type='button' class='delbtn' id='"+delFieldBtn+"' "; 
					    temp += " onclick=addBathFieldObj(11,3,'"+newstru+"','"+sap_inTable+"')  title='"+SystemEnv.getHtmlLabelName(23777,user.getLanguage())+"'>";
					    //temp += " </td></tr> <TR class=Line style='height:1px'><TD  style='padding:0px' colspan='8'></TD></TR>";
					    List listtemp = ServiceParamModeDisUtil.getParamsModeDisById(servId, browserId, "import", false, "", stuname); 
						if(listtemp != null) {
							for(int j=0;j<listtemp.size();j++) {
								ServiceParamModeDisBean spmdbtemp = (ServiceParamModeDisBean)listtemp.get(j);
								String input01="sap07_"+sap_inTable+"_"+childstu;
								String input01Span="sap07_"+sap_inTable+"_"+childstu+"span";
								String input03="con07_"+sap_inTable+"_"+childstu;
								String input01Desc = "sapDesc07_"+sap_inTable+"_"+childstu;
								String numstemp = sap_inTable+"_"+childstu;
								temp += "<tr class='DataDark'><td><input type='checkbox' name='zibox'></td><td style='width:90px;vertical-align: middle;'>"+SystemEnv.getHtmlLabelName(28247,user.getLanguage())+"</td><td style='width:208px;padding-top: 6px;padding-bottom:6px;'>";
								temp += "<button type='button' style='vertical-align: middle;' class='e8_browflow'";
								temp += " onclick=addOneFieldObj(11,'"+numstemp+"','outtable7_"+sap_inTable+"')></button>";
								temp += "<span id='"+input01Span+"' style='vertical-align: middle;width:7px;'></span>";
								temp += "<input type='text' name='"+input01+"'";  
								temp += " value='"+spmdbtemp.getParamName()+"' onchange='javascript:sapFieldChange(11,this)' style='vertical-align: middle;border:1px solid #D4E9E9;height:28px;'>";
								temp += "</td><td style='width:90px;vertical-align: middle;'>"+SystemEnv.getHtmlLabelName(30708,user.getLanguage())+"</td><td style='width:180px;padding-top: 5px;padding-bottom:5px;'>"; 
								temp += "<input type='text' name='"+input01Desc+"'";  
								temp += " value='"+spmdbtemp.getParamDesc()+"' style='vertical-align: middle;border:1px solid #D4E9E9;height:28px;'>";
								temp += "</td><td style='width:80px;vertical-align: middle;'>"+SystemEnv.getHtmlLabelName(453,user.getLanguage())+"</td>";
								temp += "<td style='padding-top:5px;padding-bottom:5px;'><input type='text' name='"+input03+"' value='"+spmdbtemp.getParamCons()+"' style='border:1px solid #D4E9E9;height:28px;'></td></tr>";
								childstu ++;
							}
						}
						temp += " </TABLE>";
						temp += " </td></tr>";
						sapinParameter07.append(temp);
						sap_inTable ++;
					}	
				}
			}		
			sapinParameter07.append(" </TABLE>");																		
													 										  	
	%>
	<!-- 业务逻辑 end-->
	
	
	<body>
	<form  method="post" name="weaver"  id="weaver" target="postiframe" action="/integration/serviceReg/serviceReg_3NewParamsModeOperation.jsp">
	
					<!--ListStyle 表格start  -->
				    <TABLE  cellspacing=1 style='table-layout: fixed;width: 100%' id="tableid">
						<COLGROUP>
							<COL width="120px"/>
							<COL width="120px"/>
							<COL width="*"/>
						</COLGROUP>
						<TR class=DataLight>	
							<TD colspan="3">
							<div class="e8_box demo2" id="seccategorybox">
							    <ul class="tab_menu">
							     <%
								  	if(impStrStatus) {
								  			    %>
							       	 <li class="current">
							        	<a href="#sap_01" onclick="showItemAreaSap('#sap_01');jumpToAnchor('#baseInfoSet');return false;">
							        		<%=SystemEnv.getHtmlLabelName(28245 ,user.getLanguage())%>
							        	</a>
							        </li>
							        <%} %>
							         <%
										if(impStructStatus) {
											    %>
							         <li class="">
							        	<a href="#sap_02" onclick="showItemAreaSap('#sap_02');jumpToAnchor('#baseInfoSet');return false;">
							        		<%=SystemEnv.getHtmlLabelName(28251 ,user.getLanguage())%>
							        	</a>
							        </li>
							        <%} %>
							       
							        <%
							        if(impTableStatus) 
									{
							        %>
							         <li class="">
							        	<a href="#sap_07" onclick="showItemAreaSap('#sap_07');jumpToAnchor('#baseInfoSet');return false;">
							        <%=SystemEnv.getHtmlLabelName(30712 ,user.getLanguage()) %>
							        </a>
							        </li>
							        <%} %>
							        <%
							         if(expStrStatus) {
							         %>
							        <li class="">
							        	<a href="#sap_03" onclick="showItemAreaSap('#sap_03');jumpToAnchor('#baseInfoSet');return false;">
							        	<%=SystemEnv.getHtmlLabelName(28255 ,user.getLanguage())%>
							        	</a>
							        </li>
							        <%} %>
							        <%
							        if(expStructStatus) {
							        %>
							          <li class="">
							        	<a href="#sap_04" onclick="showItemAreaSap('#sap_04');jumpToAnchor('#baseInfoSet');return false;">
							        	<%=SystemEnv.getHtmlLabelName(28256 ,user.getLanguage())%>
							        	</a>
							        </li>
							        <%} %>
									<%
									 if(expTableStatus)
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
								
							    </ul>
							    <div id="rightBox" class="e8_rightBox">
							    </div>
							    <div class="tab_box" style="display:none;">
							        <div>
							        </div>
							    </div>
							</div>
				<wea:layout type="2col" attributes="{layoutTableId:sap_01layout,customAttrs:'sapitem'}" css="shownone">
				  <wea:group context='<%=SystemEnv.getHtmlLabelName(28245 ,user.getLanguage()) %>' >
				    <wea:item attributes="{'colspan':'full','isTableList':'true'}">
						<TABLE width="200px" style="margin-top: -34px;margin-right: 26px;float: right;">
		            				<TR>
		            					<TD align=right>
		            							<input type="button" class="addbtnB" id='bath_01' accesskey="A" onclick="addBathFieldObj(1,1)" title="C-<%=SystemEnv.getHtmlLabelName(25055,user.getLanguage()) %>"> 								
												<input type="button" class="addbtn" id='add_01' accesskey="A" onclick="addBathFieldObj(1,2)" title="A-<%=SystemEnv.getHtmlLabelName(83476,user.getLanguage()) %>"> 
												<input type="button" class="delbtn"  id='del_01' accesskey="E" onclick="addBathFieldObj(1,3)" title="E-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage()) %>">
												<input type='hidden' id='hidden01' value='<%=spmsb.getImpstrcount() %>' name='hidden01'>
		            					</TD>
		            				</TR>
		          		</TABLE>		
									<!-- 第一个tab页里面的内容table--start -->
								<div id = "showScrollDiv" style ="border:0px solid #000;height:300px;width:100%;	overflow:auto;" >
									<%=sapinParameter01 %>
								</div>
					</wea:item>
					</wea:group>
					</wea:layout>
								   
				 <wea:layout type="2col" attributes="{layoutTableId:sap_02layout,layoutTableDisplay:none}">
				  <wea:group context='<%=SystemEnv.getHtmlLabelName(28251 ,user.getLanguage()) %>' >
				    <wea:item attributes="{'colspan':'full','isTableList':'true'}">
						<TABLE width="200px" style="margin-top: -34px;margin-right: 26px;float: right;">
		            				<TR>
		            					<TD align=right>
		            							<input type="button" class="addbtnB" id='bath_02' accesskey="A" onclick="addBathFieldObj(2,1)" title="C-<%=SystemEnv.getHtmlLabelName(25055,user.getLanguage()) %>"> 								
												<input type="button" class="addbtn" id='add_02' accesskey="A" onclick="addBathFieldObj(2,2)" title="A-<%=SystemEnv.getHtmlLabelName(83476,user.getLanguage()) %>"> 
												<input type="button" class="delbtn"  id='del_02' accesskey="E" onclick="addBathFieldObj(2,3)" title="E-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage()) %>">
												<input type='hidden' id='hidden02' name='hidden02' value='<%= spmsb.getImpstructcount()%>'>
										
		            					</TD>
		            				</TR>
		          		</TABLE>
								<div id = "showScrollDiv" style ="border:0px solid #000;height:300px;width:100%;	overflow:auto;" >
							<%=sapinParameter02 %>
									</div>
						</wea:item>
						</wea:group>
						</wea:layout>
									<!-- 第二个tab页里面的内容--end -->
									<!-- 第三个tab页里面的内容-start -->
			 <wea:layout type="2col" attributes="{layoutTableId:sap_03layout,layoutTableDisplay:none}" css="shownone">
				  <wea:group context='<%=SystemEnv.getHtmlLabelName(28255 ,user.getLanguage()) %>' >
				    <wea:item attributes="{'colspan':'full','isTableList':'true'}">
						<TABLE width="200px" style="margin-top: -34px;margin-right: 26px;float: right;">
		            				<TR>
		            					<TD align=right>
		            							<input type="button" class="addbtnB" id='bath_03' accesskey="A" onclick="addBathFieldObj(4,1)" title="C-<%=SystemEnv.getHtmlLabelName(25055,user.getLanguage()) %>"> 								
												<input type="button" class="addbtn" id='add_03' accesskey="A" onclick="addBathFieldObj(4,2)" title="A-<%=SystemEnv.getHtmlLabelName(83476,user.getLanguage()) %>"> 
												<input type="button" class="delbtn"  id='del_03' accesskey="E" onclick="addBathFieldObj(4,3)" title="E-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage()) %>">
												<input type='hidden' id='hidden03' name='hidden03' value='<%=spmsb.getExpstrcount() %>'>
										
		            					</TD>
		            				</TR>
		          		</TABLE>
								<div id = "showScrollDiv" style ="border:0px solid #000;height:300px;width:100%;	overflow:auto;" >
									<%=sapinParameter03 %>
								</div>
				</wea:item>
				</wea:group>
			</wea:layout>
									<!-- 第三个tab页里面的内容--end -->
									<!-- 第四个tab页里面的内容-start -->
				 <wea:layout type="2col" attributes="{layoutTableId:sap_04layout,layoutTableDisplay:none}" css="shownone">
				  <wea:group context='<%=SystemEnv.getHtmlLabelName(28256 ,user.getLanguage()) %>' >
				    <wea:item attributes="{'colspan':'full','isTableList':'true'}">
						<TABLE width="200px" style="margin-top: -34px;margin-right: 26px;float: right;">
		            				<TR>
		            					<TD align=right>
		            							<input type="button" class="addbtnB" id='bath_04' accesskey="A" onclick="addBathFieldObj(5,1)" title="C-<%=SystemEnv.getHtmlLabelName(25055,user.getLanguage()) %>"> 								
												<input type="button" class="addbtn" id='add_04' accesskey="A" onclick="addBathFieldObj(5,2)" title="A-<%=SystemEnv.getHtmlLabelName(83476,user.getLanguage()) %>"> 
												<input type="button" class="delbtn"  id='del_04' accesskey="E" onclick="addBathFieldObj(5,3)" title="E-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage()) %>">
												<input type='hidden' id='hidden04' name='hidden04' value='<%=spmsb.getExpstructcount()%>'>
										
		            					</TD>
		            				</TR>
		          		</TABLE>
								<div id = "showScrollDiv" style ="border:0px solid #000;height:300px;width:100%;	overflow:auto;" >
									<%=sapinParameter04 %>
									</div>
							</wea:item>
				</wea:group>
			</wea:layout>		
									<!-- 第四个tab页里面的内容--end -->
									<!-- 第五个tab页里面的内容-start -->
				<wea:layout type="2col" attributes="{layoutTableId:sap_05layout,layoutTableDisplay:none}" css="shownone">
				  <wea:group context='<%=SystemEnv.getHtmlLabelName(28260 ,user.getLanguage()) %>' >
				    <wea:item attributes="{'colspan':'full','isTableList':'true'}">
						<TABLE width="200px" style="margin-top: -34px;margin-right: 26px;float: right;">
		            				<TR>
		            					<TD align=right>
		            							<input type="button" class="addbtnB" id='bath_05' accesskey="A" onclick="addBathFieldObj(7,1)" title="C-<%=SystemEnv.getHtmlLabelName(25055,user.getLanguage()) %>"> 								
												<input type="button" class="addbtn" id='add_05' accesskey="A" onclick="addBathFieldObj(7,2)" title="A-<%=SystemEnv.getHtmlLabelName(83476,user.getLanguage()) %>"> 
												<input type="button" class="delbtn"  id='del_05' accesskey="E" onclick="addBathFieldObj(7,3)" title="E-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage()) %>">
												<input type='hidden' id='hidden05' name='hidden05' value='<%=spmsb.getExptablecount()%>'>
										
		            					</TD>
		            				</TR>
		          		</TABLE>
								<div id = "showScrollDiv" style ="border:0px solid #000;height:300px;width:100%;	overflow:auto;" >
									<%=sapinParameter05 %>
									</div>
						</wea:item>
				</wea:group>
			</wea:layout>	
									<!-- 第五个tab页里面的内容--end -->
									<!-- 第六个tab页里面的内容-start -->
									<!-- 第六个tab页里面的内容--end -->
									<!-- 第七个tab页里面的内容-start -->
					<wea:layout type="2col" attributes="{layoutTableId:sap_07layout,layoutTableDisplay:none}" css="shownone">
				  <wea:group context='<%=SystemEnv.getHtmlLabelName(30712 ,user.getLanguage()) %>' >
				    <wea:item attributes="{'colspan':'full','isTableList':'true'}">
						<TABLE width="200px" style="margin-top: -34px;margin-right: 26px;float: right;">
		            				<TR>
		            					<TD align=right>
		            							<input type="button" class="addbtnB" id='bath_07' accesskey="A" onclick="addBathFieldObj(10,1)" title="C-<%=SystemEnv.getHtmlLabelName(25055,user.getLanguage()) %>"> 								
												<input type="button" class="addbtn" id='add_07' accesskey="A" onclick="addBathFieldObj(10,2)"  title="A-<%=SystemEnv.getHtmlLabelName(83476,user.getLanguage()) %>"> 
												<input type="button" class="delbtn"  id='del_07' accesskey="E" onclick="addBathFieldObj(10,3)" title="E-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage()) %>">
												<input type='hidden' id='hidden07' name='hidden07'  value='<%=spmsb.getImptablecount() %>'>
										
		            					</TD>
		            				</TR>
		          		</TABLE>
								<div id = "showScrollDiv" style ="border:0px solid #000;height:300px;width:100%;	overflow:auto;" >
									<%=sapinParameter07 %>
									</div>
									</wea:item>
				</wea:group>
			</wea:layout>	
									
									<!-- 第七个tab页里面的内容--end -->
							</TD>
						</TR>
					</TABLE>
					<!--ListStyle 表格end  -->
					
					
				<input type="hidden" name="browserId" value="<%=browserId%>">	
				<input type="hidden" name="poolid" id="poolid" value="<%=poolid%>">
				<input type="hidden" name="servId" id="servId" value="<%=servId%>">
				
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
	
	function showItemAreaSap(selector){
		$(".LayoutTable[id^='sap']").hide();

		$(selector+"layout").show();
	}
			$(document).ready(function() {
				
			window.parent.document.getElementById("hidediv").style.display = "none";
			window.parent.document.getElementById("hidedivmsg").style.display = "none";
			$("#cbox_01").click (function(){
					//$("#sap_01 tr td:first-child [type=checkbox]").each(function(){ 
					//	var flag=$("#cbox_01").attr('checked');
						//$(this).attr('checked',flag);
					//});
					
					$("#chind01 tr").parent().find("input[type='checkbox']").each(
						function(){
							var flag=$("#cbox_01").attr('checked');
							$(this).attr('checked',flag);
							
							changeCheckboxStatus($(this),flag);
						}
					);
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
 	setInterval(flashText, 500);  
 	function flashText()
 	{
 		//控制iframe自适应内容高度
 		var ifheight=$("#tableid").height();
 		//window.parent.document.getElementById("maindiv").style.height=ifheight;
 	}


	function addOneFieldObjOACallBack(objjosn,temp){
		var obj= objjosn.obj;
		var haveimg = objjosn.haveimg
		if(temp)
		 	{
		 		 if (temp.names!=""&&temp.viewtype!="-1") {
					var tempname=temp.name.split("##");
					$(obj).next().val(tempname[1]);
				 }
		 	}
	}
	
 	//选择oa字段
 	//wfid流程的id
 	//浏览按钮对象
 	//haveimg是否有img这个span,0没有,1有
 	function addOneFieldObjOA(obj,haveimg)
 	{
 	
 			//function addOneFieldObjOA标准 
			//--------------<button> 浏览按钮
			//--------------<input>  隐藏的oa字段name
			//--------------<span>   显示的oa字段name
			//--------------<span>   显示img
			//--------------<input>  记录字段(是否主字段，字段的数据库id,)
 			var formid=$("#formid").val();
 			var checkvalue=$(obj).next().val();
 		 	//var temp=window.showModalDialog("/integration/browse/integrationBatchOA.jsp?formid=","","dialogWidth:600px;dialogHeight:600px;center:yes;scroll:yes;status:no");
 			var dialog = new window.top.Dialog();
 			dialog.currentWindow = window;
			dialog.Title = "<%=SystemEnv.getHtmlLabelName(19372,user.getLanguage()) %>";
		    dialog.URL = "/integration/browse/integrationBatchOA.jsp?formid=";
			dialog.Width = 660;
			dialog.Height = 660;
			dialog.Drag = true;
			dialog.callbackfun=addOneFieldObjOACallBack;
	 		dialog.callbackfunParam={obj:obj,haveimg:haveimg};
			dialog.textAlign = "center";
			dialog.show();
 			
 	}
 	
 	
 	function addOneFieldObjCallBack(objjosn,temp){
 		var type = objjosn.type;
 		var nums = objjosn.nums
 		var stuname =objjosn.stuname;
 	
 		if(type==1){
			var input01="sap01_"+nums;
			var input01Span="sap01_"+nums+"Span";
			var input02="sapDesc01_"+nums;
 			if(temp) {
	 		 if (temp.id!="" && temp.id != 0){
				$("input[name='"+input01+"']").attr("value",temp.id);
				$("input[name='"+input02+"']").attr("value",temp.name);
				$("#"+input01Span).html("");
			 }else {
				$("#"+input01Span).html("<img src='/images/BacoError_wev8.gif' align='center'>");
				$("input[name='"+input01+"']").attr("value","");
				$("input[name='"+input02+"']").attr("value","");
			 }
	 	}
 		}
 		if(type == 4) {
 			var input01="sap03_"+nums;
			var input01Span="sap03_"+nums+"span";
			var input02="sapDesc03_"+nums;
 			if(temp) {
 			 		 if (temp.id!="" && temp.id != 0){
 						$("input[name='"+input01+"']").attr("value",temp.id);
 						$("input[name='"+input02+"']").attr("value",temp.name);
 						$("#"+input01Span).html("");
 					 }else {
 						$("#"+input01Span).html("<img src='/images/BacoError_wev8.gif' align='center'>");
 						$("input[name='"+input01+"']").attr("value","");
 						$("input[name='"+input02+"']").attr("value","");
 					 }
 			 	}
 		}
 		
 		if(type == 2) {
			var input01="stru_"+nums;
			var input01Span="stru_"+nums+"span";
			var $bath2Btn = $("#bath2_"+nums);
 			var $addFieldBtn = $("#addstru_"+nums);
			var $delFieldBtn = $("#delstru_"+nums);
 			if(temp) {
		 			 if($.trim($("input[name='"+input01+"']").attr("value"))!=$.trim(temp.id)) {
			 				var lengthtemp3 = $("#cbox2"+"_"+nums).val();
			 				for(var i=1;i<=lengthtemp3;i++) {
			 					var input013="sap02_"+nums+"_"+i;
			 					$("input[name='"+input013+"']").parent().parent().remove();
			 				}
			 			 }

 			 		 if (temp.id!="" && temp.id != 0){
 						$("input[name='"+input01+"']").attr("value",temp.id);
 						$("#"+input01Span).html("");
 						 $bath2Btn.attr("disabled","");
 			 			 $addFieldBtn.attr("disabled","");
 						 $delFieldBtn.attr("disabled","");
 						 
 					 }else {
 						$("#"+input01Span).html("<img src='/images/BacoError_wev8.gif' align='center'>");
 						$("input[name='"+input01+"']").attr("value","");
 						 $bath2Btn.attr("disabled","disabled");
 			 			 $addFieldBtn.attr("disabled","disabled");
 						 $delFieldBtn.attr("disabled","disabled");
 					 }
 			 	}
 		}
 		if(type == 5) {
 			var input01="outstru_"+nums;
			var input01Span="outstru_"+nums+"span";
			var $bath2Btn = $("#bath4_"+nums);
 			var $addFieldBtn = $("#addoutstru_"+nums);
			var $delFieldBtn = $("#deloutstru_"+nums);
 			if(temp) {
 					 if($.trim($("input[name='"+input01+"']").attr("value"))!=$.trim(temp.id)) {
			 				var lengthtemp3 = $("#cbox4"+"_"+nums).val();
			 				for(var i=1;i<=lengthtemp3;i++) {
			 					var input013="sap04_"+nums+"_"+i;
			 					$("input[name='"+input013+"']").parent().parent().remove();
			 				}
			 			 }
 			 		 if (temp.id!="" && temp.id != 0){
 						$("input[name='"+input01+"']").attr("value",temp.id);
 						$("#"+input01Span).html("");
 						 $bath2Btn.attr("disabled","");
 			 			 $addFieldBtn.attr("disabled","");
 						 $delFieldBtn.attr("disabled","");
 						 
 					 }else {
 						$("#"+input01Span).html("<img src='/images/BacoError_wev8.gif' align='center'>");
 						$("input[name='"+input01+"']").attr("value","");
 						 $bath2Btn.attr("disabled","disabled");
 			 			 $addFieldBtn.attr("disabled","disabled");
 						 $delFieldBtn.attr("disabled","disabled");
 					 }
 			 	}
 		}
 		
 		if(type == 10) {
 		
 			var input01="outtable7_"+nums;
			var input01Span="outtable7_"+nums+"span";
			var $bath2Btn = $("#bath7_"+nums);
 			var $addFieldBtn = $("#addtable_"+nums);
			var $delFieldBtn = $("#deltable_"+nums);
 			if(temp) {
 					 if($.trim($("input[name='"+input01+"']").attr("value"))!=$.trim(temp.id)) {
			 				var lengthtemp3 = $("#cbox7"+"_"+nums).val();
			 				for(var i=1;i<=lengthtemp3;i++) {
			 					var input013="sap07_"+nums+"_"+i;
			 					$("input[name='"+input013+"']").parent().parent().remove();
			 				}
			 			 }
 			 		 if (temp.id!="" && temp.id != 0){
 						$("input[name='"+input01+"']").attr("value",temp.id);
 						$("#"+input01Span).html("");
 						 $bath2Btn.attr("disabled","");
 			 			 $addFieldBtn.attr("disabled","");
 						 $delFieldBtn.attr("disabled","");
 						 
 					 }else {
 						$("#"+input01Span).html("<img src='/images/BacoError_wev8.gif' align='center'>");
 						$("input[name='"+input01+"']").attr("value","");
 						 $bath2Btn.attr("disabled","disabled");
 			 			 $addFieldBtn.attr("disabled","disabled");
 						 $delFieldBtn.attr("disabled","disabled");
 					 }
 			 	}
 		}
 		
 		if(type == 7) {
 				var input01="outtable_"+nums;
				var input01Span="outtable_"+nums+"span";
				var $bath2Btn = $("#bath5_"+nums);
	 			var $addFieldBtn = $("#addouttable_"+nums);
				var $delFieldBtn = $("#delouttable_"+nums);
 				if(temp) {
 					 if($.trim($("input[name='"+input01+"']").attr("value"))!=$.trim(temp.id)) {
			 				var lengthtemp3 = $("#cbox5"+"_"+nums).val();
			 				for(var i=1;i<=lengthtemp3;i++) {
			 					var input013="sap05_"+nums+"_"+i;
			 					$("input[name='"+input013+"']").parent().parent().remove();
			 				}
			 			 }
 			 		 if (temp.id!="" && temp.id != 0){
 						$("input[name='"+input01+"']").attr("value",temp.id);
 						$("#"+input01Span).html("");
 						 $bath2Btn.attr("disabled","");
 			 			 $addFieldBtn.attr("disabled","");
 						 $delFieldBtn.attr("disabled","");
 						 
 					 }else {
 						$("#"+input01Span).html("<img src='/images/BacoError_wev8.gif' align='center'>");
 						$("input[name='"+input01+"']").attr("value","");
 						 $bath2Btn.attr("disabled","disabled");
 			 			 $addFieldBtn.attr("disabled","disabled");
 						 $delFieldBtn.attr("disabled","disabled");
 					 }
 			 	}
 			}
 		 	
 			if(type == 3) {
 				var input01="sap02_"+nums;
				var input01Span="sap02_"+nums+"span";
				var input02="sapDesc02_"+nums;
	 			if(temp) {
				 		 if (temp.id!="" && temp.id != 0){
							$("input[name='"+input01+"']").attr("value",temp.id);
							$("input[name='"+input02+"']").attr("value",temp.name);
							$("#"+input01Span).html("");
						 }else {
							$("#"+input01Span).html("<img src='/images/BacoError_wev8.gif' align='center'>");
							$("input[name='"+input01+"']").attr("value","");
							$("input[name='"+input02+"']").attr("value","");
						 }
				 	}
 			}
 			
 			if(type == 6) {
 				var input01="sap04_"+nums;
				var input01Span="sap04_"+nums+"span";
				var input02="sapDesc04_"+nums;
 				if(temp) {
			 		 if (temp.id!="" && temp.id != 0){
						$("input[name='"+input01+"']").attr("value",temp.id);
						$("input[name='"+input02+"']").attr("value",temp.name);
						$("#"+input01Span).html("");
					 }else {
						$("#"+input01Span).html("<img src='/images/BacoError_wev8.gif' align='center'>");
						$("input[name='"+input01+"']").attr("value","");
						$("input[name='"+input02+"']").attr("value","");
					 }
			 	}
 			}
 			
 			if(type == 11) {
 				var input01="sap07_"+nums;
				var input01Span="sap07_"+nums+"span";
				var input02="sapDesc07_"+nums;
 				if(temp) {
			 		 if (temp.id!="" && temp.id != 0){
						$("input[name='"+input01+"']").attr("value",temp.id);
						$("input[name='"+input02+"']").attr("value",temp.name);
						$("#"+input01Span).html("");
					 }else {
						$("#"+input01Span).html("<img src='/images/BacoError_wev8.gif' align='center'>");
						$("input[name='"+input01+"']").attr("value","");
						$("input[name='"+input02+"']").attr("value","");
					 }
			 	}
 			}
 			
 			if(type == 8) {
 				var input01="sap05_"+nums;
				var input01Span="sap05_"+nums+"span";
				var input02="sapDesc05_"+nums;
 				if(temp) {
			 		 if (temp.id!="" && temp.id != 0){
						$("input[name='"+input01+"']").attr("value",temp.id);
						$("input[name='"+input02+"']").attr("value",temp.name);
						$("#"+input01Span).html("");
					 }else {
						$("#"+input01Span).html("<img src='/images/BacoError_wev8.gif' align='center'>");
						$("input[name='"+input01+"']").attr("value","");
						$("input[name='"+input02+"']").attr("value","");
					 }
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
 	//type=9表示输入表,obj表示表名浏览按钮
 	//type=10表示输入表-->>某个表-->>>>sap字段,并且需要提供表的文本框的id
 	function addOneFieldObj(type,nums,stuname)
 	{
 			var url="";
 		    
 			if(type == 1) {
 				var input01="sap01_"+nums;
				var input01Span="sap01_"+nums+"Span";
				var input02="sapDesc01_"+nums;
 				var lengthtemp = $("#hidden01").val();
					var disValue = '';
					var numSum = 1;
					if(lengthtemp>=1) {
						for(var i=1;i<=lengthtemp;i++) {
							if(i == nums) continue;
							var valuetemp = $("input[name='sap01_"+i+"']").attr("value");
							if($.trim(valuetemp)== '') continue;
							if(numSum == 1) {
								disValue = valuetemp;
							}else {
								disValue += ","+valuetemp;
							}
							numSum ++;
						}
					}
 				//var temp=window.showModalDialog("/integration/serviceReg/serviceReg_3NewParamsModeSAP.jsp?operation=2&servId=<%=servId%>&poolid=<%=poolid%>&type=1&disValue="+disValue,"","dialogWidth:600px;dialogHeight:600px;center:yes;scroll:yes;status:no");
 				url="/integration/serviceReg/serviceReg_3NewParamsModeSAP.jsp?operation=2&servId=<%=servId%>&poolid=<%=poolid%>&type=1&disValue="+disValue;
 			}
 			
 			if(type == 4) {
 				var input01="sap03_"+nums;
				var input01Span="sap03_"+nums+"span";
				var input02="sapDesc03_"+nums;
 				var lengthtemp = $("#hidden03").val();
					var disValue = '';
					var numSum = 1;
					if(lengthtemp>=1) {
						for(var i=1;i<=lengthtemp;i++) {
							if(i == nums) continue;
							var valuetemp = $("input[name='sap03_"+i+"']").attr("value");
							if($.trim(valuetemp)== '') continue;
							if(numSum == 1) {
								disValue = valuetemp;
							}else {
								disValue += ","+valuetemp;
							}
							numSum ++;
						}
					}
 				//var temp=window.showModalDialog("/integration/serviceReg/serviceReg_3NewParamsModeSAP.jsp?operation=2&servId=<%=servId%>&poolid=<%=poolid %>&type=4&disValue="+disValue,"","dialogWidth:600px;dialogHeight:600px;center:yes;scroll:yes;status:no");
 				url="/integration/serviceReg/serviceReg_3NewParamsModeSAP.jsp?operation=2&servId=<%=servId%>&poolid=<%=poolid %>&type=4&disValue="+disValue;
 			}
 			
 			if(type == 2) {
 				var input01="stru_"+nums;
				var input01Span="stru_"+nums+"span";
				var $bath2Btn = $("#bath2_"+nums);
	 			var $addFieldBtn = $("#addstru_"+nums);
				var $delFieldBtn = $("#delstru_"+nums);
				var lengthtemp = $("#hidden02").val();
				var disValue = '';
				var numSum = 1;
				if(lengthtemp>=1) {
					for(var i=1;i<=lengthtemp;i++) {
						if(i == nums) continue;
						var valuetemp = $("input[name='stru_"+i+"']").attr("value");
						if($.trim(valuetemp)== '') continue;
						if(numSum == 1) {
							disValue = valuetemp;
						}else {
							disValue += ","+valuetemp;
						}
						numSum ++;
					}
				}
				//var temp=window.showModalDialog("/integration/serviceReg/serviceReg_3NewParamsModeSAP.jsp?operation=2&servId=<%=servId%>&poolid=<%=poolid %>&type=2&disValue="+disValue,"","dialogWidth:600px;dialogHeight:600px;center:yes;scroll:yes;status:no");
 				url="/integration/serviceReg/serviceReg_3NewParamsModeSAP.jsp?operation=2&servId=<%=servId%>&poolid=<%=poolid %>&type=2&disValue="+disValue;
				
 			}
 			
 			if(type == 5) {
 				var input01="outstru_"+nums;
				var input01Span="outstru_"+nums+"span";
				var $bath2Btn = $("#bath4_"+nums);
	 			var $addFieldBtn = $("#addoutstru_"+nums);
				var $delFieldBtn = $("#deloutstru_"+nums);
				var lengthtemp = $("#hidden04").val();
				var disValue = '';
				var numSum = 1;
				if(lengthtemp>=1) {
					for(var i=1;i<=lengthtemp;i++) {
						if(i == nums) continue;
						var valuetemp = $("input[name='outstru_"+i+"']").attr("value");
						if($.trim(valuetemp)== '') continue;
						if(numSum == 1) {
							disValue = valuetemp;
						}else {
							disValue += ","+valuetemp;
						}
						numSum ++;
					}
				}
				//var temp=window.showModalDialog("/integration/serviceReg/serviceReg_3NewParamsModeSAP.jsp?operation=2&servId=<%=servId%>&poolid=<%=poolid %>&type=5&disValue="+disValue,"","dialogWidth:600px;dialogHeight:600px;center:yes;scroll:yes;status:no");
 				url="/integration/serviceReg/serviceReg_3NewParamsModeSAP.jsp?operation=2&servId=<%=servId%>&poolid=<%=poolid %>&type=5&disValue="+disValue;
				
 			}
 			
 			if(type == 10) {
				
 				var input01="outtable7_"+nums;
				var input01Span="outtable7_"+nums+"span";
				var $bath2Btn = $("#bath7_"+nums);
	 			var $addFieldBtn = $("#addtable_"+nums);
				var $delFieldBtn = $("#deltable_"+nums);
				var lengthtemp = $("#hidden07").val();
				var disValue = '';
				var numSum = 1;
				if(lengthtemp>=1) {
					for(var i=1;i<=lengthtemp;i++) {
						if(i == nums) continue;
						var valuetemp = $("input[name='outtable7_"+i+"']").attr("value");
						if($.trim(valuetemp)== '') continue;
						if(numSum == 1) {
							disValue = valuetemp;
						}else {
							disValue += ","+valuetemp;
						}
						numSum ++;
					}
				}
				//var temp=window.showModalDialog("/integration/serviceReg/serviceReg_3NewParamsModeSAP.jsp?operation=2&servId=<%=servId%>&poolid=<%=poolid %>&type=10&disValue="+disValue,"","dialogWidth:600px;dialogHeight:600px;center:yes;scroll:yes;status:no");
 				url="/integration/serviceReg/serviceReg_3NewParamsModeSAP.jsp?operation=2&servId=<%=servId%>&poolid=<%=poolid %>&type=10&disValue="+disValue
				
 			}
 			
 			if(type == 7) {
 				var input01="outtable_"+nums;
				var input01Span="outtable_"+nums+"span";
				var $bath2Btn = $("#bath5_"+nums);
	 			var $addFieldBtn = $("#addouttable_"+nums);
				var $delFieldBtn = $("#delouttable_"+nums);
				var lengthtemp = $("#hidden05").val();
				var disValue = '';
				var numSum = 1;
				if(lengthtemp>=1) {
					for(var i=1;i<=lengthtemp;i++) {
						if(i == nums) continue;
						var valuetemp = $("input[name='outtable_"+i+"']").attr("value");
						if($.trim(valuetemp)== '') continue;
						if(numSum == 1) {
							disValue = valuetemp;
						}else {
							disValue += ","+valuetemp;
						}
						numSum ++;
					}
				}
				//var temp=window.showModalDialog("/integration/serviceReg/serviceReg_3NewParamsModeSAP.jsp?operation=2&servId=<%=servId%>&poolid=<%=poolid %>&type=7&disValue="+disValue,"","dialogWidth:600px;dialogHeight:600px;center:yes;scroll:yes;status:no");
 				url="/integration/serviceReg/serviceReg_3NewParamsModeSAP.jsp?operation=2&servId=<%=servId%>&poolid=<%=poolid %>&type=7&disValue="+disValue
 			}
 		 	
 			if(type == 3) {
 				var input01="sap02_"+nums;
				var input01Span="sap02_"+nums+"span";
				var input02="sapDesc02_"+nums;
				var chtable = input01.split("_")[1];
				var numtemp = input01.split("_")[2];
				var lengthtemp = $("#cbox2"+"_"+chtable).val();
				var disValue = '';
				
				var numSum = 1;
				if(lengthtemp>=1) {
					for(var i=1;i<=lengthtemp;i++) {
						if(i== numtemp)continue;
						var valuetemp = $("input[name='sap02_"+chtable+"_"+i+"']").attr("value");
						if($.trim(valuetemp)== '') continue;
						if(numSum == 1) {
							disValue = valuetemp;
						}else {
							disValue += ","+valuetemp;
						}
						numSum ++;
					}
				}	
				var stuortablevalue=$("#"+stuname).val();
 				if(stuortablevalue == ''){
 					alert("<%=SystemEnv.getHtmlLabelName(30715,user.getLanguage()) %>！");
 					return;
 				}
 				//var temp=window.showModalDialog("/integration/serviceReg/serviceReg_3NewParamsModeSAP.jsp?operation=2&servId=<%=servId%>&poolid=<%=poolid %>&type="+type+"&disValue="+disValue+"&stuortablevalue="+stuortablevalue,"","dialogWidth:600px;dialogHeight:600px;center:yes;scroll:yes;status:no");
 				url="/integration/serviceReg/serviceReg_3NewParamsModeSAP.jsp?operation=2&servId=<%=servId%>&poolid=<%=poolid %>&type="+type+"&disValue="+disValue+"&stuortablevalue="+stuortablevalue;
 			}
 			
 			if(type == 6) {
 				var input01="sap04_"+nums;
				var input01Span="sap04_"+nums+"span";
				var input02="sapDesc04_"+nums;
				var chtable = input01.split("_")[1];
				var numtemp = input01.split("_")[2];
				var lengthtemp = $("#cbox4"+"_"+chtable).val();
				var disValue = '';
				
				var numSum = 1;
				if(lengthtemp>=1) {
					for(var i=1;i<=lengthtemp;i++) {
						if(i== numtemp)continue;
						var valuetemp = $("input[name='sap04_"+chtable+"_"+i+"']").attr("value");
						if($.trim(valuetemp)== '') continue;
						if(numSum == 1) {
							disValue = valuetemp;
						}else {
							disValue += ","+valuetemp;
						}
						numSum ++;
					}
				}	
				var stuortablevalue=$("#"+stuname).val();
 				if(stuortablevalue == ''){
 					alert("<%=SystemEnv.getHtmlLabelName(30715,user.getLanguage())%>！");
 					return;
 				}
 				//var temp=window.showModalDialog("/integration/serviceReg/serviceReg_3NewParamsModeSAP.jsp?operation=2&servId=<%=servId%>&poolid=<%=poolid %>&type="+type+"&disValue="+disValue+"&stuortablevalue="+stuortablevalue,"","dialogWidth:600px;dialogHeight:600px;center:yes;scroll:yes;status:no");
 				url="/integration/serviceReg/serviceReg_3NewParamsModeSAP.jsp?operation=2&servId=<%=servId%>&poolid=<%=poolid %>&type="+type+"&disValue="+disValue+"&stuortablevalue="+stuortablevalue;
 			}
 			
 			if(type == 11) {
 				var input01="sap07_"+nums;
				var input01Span="sap07_"+nums+"span";
				var input02="sapDesc07_"+nums;
				var chtable = input01.split("_")[1];
				var numtemp = input01.split("_")[2];
				var lengthtemp = $("#cbox7"+"_"+chtable).val();
				var disValue = '';
				
				var numSum = 1;
				if(lengthtemp>=1) {
					for(var i=1;i<=lengthtemp;i++) {
						if(i== numtemp)continue;
						var valuetemp = $("input[name='sap07_"+chtable+"_"+i+"']").attr("value");
						if($.trim(valuetemp)== '') continue;
						if(numSum == 1) {
							disValue = valuetemp;
						}else {
							disValue += ","+valuetemp;
						}
						numSum ++;
					}
				}	
				var stuortablevalue=$("#"+stuname).val();
 				if(stuortablevalue == ''){
 					alert("<%=SystemEnv.getHtmlLabelName(30718,user.getLanguage())%>！");
 					return;
 				}
 				//var temp=window.showModalDialog("/integration/serviceReg/serviceReg_3NewParamsModeSAP.jsp?operation=2&servId=<%=servId%>&poolid=<%=poolid %>&type="+type+"&disValue="+disValue+"&stuortablevalue="+stuortablevalue,"","dialogWidth:600px;dialogHeight:600px;center:yes;scroll:yes;status:no");
 				url="/integration/serviceReg/serviceReg_3NewParamsModeSAP.jsp?operation=2&servId=<%=servId%>&poolid=<%=poolid %>&type="+type+"&disValue="+disValue+"&stuortablevalue="+stuortablevalue
 			}
 			
 			if(type == 8) {
 				var input01="sap05_"+nums;
				var input01Span="sap05_"+nums+"span";
				var input02="sapDesc05_"+nums;
				var chtable = input01.split("_")[1];
				var numtemp = input01.split("_")[2];
				var lengthtemp = $("#cbox5"+"_"+chtable).val();
				var disValue = '';
				
				var numSum = 1;
				if(lengthtemp>=1) {
					for(var i=1;i<=lengthtemp;i++) {
						if(i== numtemp)continue;
						var valuetemp = $("input[name='sap05_"+chtable+"_"+i+"']").attr("value");
						if($.trim(valuetemp)== '') continue;
						if(numSum == 1) {
							disValue = valuetemp;
						}else {
							disValue += ","+valuetemp;
						}
						numSum ++;
					}
				}	
				var stuortablevalue=$("#"+stuname).val();
 				if(stuortablevalue == ''){
 					alert("<%=SystemEnv.getHtmlLabelName(30721,user.getLanguage())%>！");
 					return;
 				}
 				//var temp=window.showModalDialog("/integration/serviceReg/serviceReg_3NewParamsModeSAP.jsp?operation=2&servId=<%=servId%>&poolid=<%=poolid %>&type="+type+"&disValue="+disValue+"&stuortablevalue="+stuortablevalue,"","dialogWidth:600px;dialogHeight:600px;center:yes;scroll:yes;status:no");
 				url ="/integration/serviceReg/serviceReg_3NewParamsModeSAP.jsp?operation=2&servId=<%=servId%>&poolid=<%=poolid %>&type="+type+"&disValue="+disValue+"&stuortablevalue="+stuortablevalue; 
 			}
 			
 			
 			var dialog = new window.top.Dialog();
 			dialog.currentWindow = window;
			dialog.Title = "SAP<%=SystemEnv.getHtmlLabelName(561,user.getLanguage()) %>";
		    dialog.URL = url;
			dialog.Width = 660;
			dialog.Height = 660;
			dialog.Drag = true;
			dialog.callbackfun=addOneFieldObjCallBack;
	 		dialog.callbackfunParam={type:type,nums:nums,stuname:stuname};
			dialog.textAlign = "center";
			dialog.show();
 			
 	}
 	
 	function sapFieldChange(type,obj) {
 		if(type == 1) {
 			var objname = $(obj).attr("name");
 			var hiddenNum = objname.substring(6);
 			var $objspan = $("#"+objname+"Span");
 			var objvalue = $(obj).attr("value");
 			if(objvalue == '') {
 				$objspan.html("<img src='/images/BacoError_wev8.gif' align='center'>");
 			}else {
 				$objspan.html("");
 				var hiddensum = $("#hidden01").attr("value");
 				for(var i=1;i<=hiddensum;i++) {
 					if(objname==('sap01_'+i)) continue;
 					var comtemp = $("input[name='sap01_"+i+"']").attr("value");
 					if($.trim(objvalue) == $.trim(comtemp)) {
 						alert("<%=SystemEnv.getHtmlLabelName(30723,user.getLanguage())%>！");
 						$(obj).attr("value","");
 						$objspan.html("<img src='/images/BacoError_wev8.gif' align='center'>");
 						return;
 					}
 				}
 				$.post("/integration/serviceReg/checkServiceParamsAjax.jsp",{type:1,seviceId:<%=servId%>,paramName:objvalue},function(data){ 
						if(!data["flag"]) {
							alert("<%=SystemEnv.getHtmlLabelName(30724,user.getLanguage())%>！");
	 						$(obj).attr("value","");
	 						$objspan.html("<img src='/images/BacoError_wev8.gif' align='center'>");
						}else {
							$("input[name='sapDesc01_"+hiddenNum+"']").attr("value",data["message"]);
						}	
				},"json");
 			}
 		}
 		
 		if(type == 4) {
 			var objname = $(obj).attr("name");
 			var hiddenNum = objname.substring(6);
 			var $objspan = $("#"+objname+"span");
 			var objvalue = $(obj).attr("value");
 			if(objvalue == '') {
 				$objspan.html("<img src='/images/BacoError_wev8.gif' align='center'>");
 			}else {
 				$objspan.html("");
 				var hiddensum = $("#hidden03").attr("value");
 				for(var i=1;i<=hiddensum;i++) {
 					if(objname==('sap03_'+i)) continue;
 					var comtemp = $("input[name='sap03_"+i+"']").attr("value");
 					if($.trim(objvalue) == $.trim(comtemp)) {
 						alert("<%=SystemEnv.getHtmlLabelName(30723,user.getLanguage())%>！");
 						$(obj).attr("value","");
 						$objspan.html("<img src='/images/BacoError_wev8.gif' align='center'>");
 						return;
 					}
 				}
 				$.post("/integration/serviceReg/checkServiceParamsAjax.jsp",{type:4,seviceId:<%=servId%>,paramName:objvalue},function(data){ 
						if(!data["flag"]) {
							alert("<%=SystemEnv.getHtmlLabelName(30724,user.getLanguage())%>！");
	 						$(obj).attr("value","");
	 						$objspan.html("<img src='/images/BacoError_wev8.gif' align='center'>");
						}else {
							$("input[name='sapDesc03_"+hiddenNum+"']").attr("value",data["message"]);
						}	
				},"json");
 			}	
 		}
 		
 	if(type == 2) {
 			var objname = $(obj).attr("name");
 			var hiddenNum = objname.substring(5);
 			var $objspan = $("#"+objname+"span");
 			var objvalue = $(obj).attr("value");
 			
 			var lengthtemp = $("#cbox2"+"_"+hiddenNum).val();
 		
			for(var i=1;i<=lengthtemp;i++) {
				var input01="sap02_"+hiddenNum+"_"+i;
				$("input[name='"+input01+"']").parent().parent().remove();
			}
			
 			var $bath2Btn = $("#bath2_"+hiddenNum);
 			var $addFieldBtn = $("#addstru_"+hiddenNum);
			var $delFieldBtn = $("#delstru_"+hiddenNum);
 			if(objvalue == '') {
 				$objspan.html("<img src='/images/BacoError_wev8.gif' align='center'>");
 				$bath2Btn.attr("disabled","disabled");
	 			 $addFieldBtn.attr("disabled","disabled");
				 $delFieldBtn.attr("disabled","disabled");
 			}else {
 				$objspan.html("");
 				var hiddensum = $("#hidden02").attr("value");
 				for(var i=1;i<=hiddensum;i++) {
 					if(objname==('stru_'+i)) continue;
 					var comtemp = $("input[name='stru_"+i+"']").attr("value");
 					if($.trim(objvalue) == $.trim(comtemp)) {
 						alert("<%=SystemEnv.getHtmlLabelName(30725,user.getLanguage())%>！");
 						$(obj).attr("value","");
 						$objspan.html("<img src='/images/BacoError_wev8.gif' align='center'>");
 						 $bath2Btn.attr("disabled","disabled");
 			 			 $addFieldBtn.attr("disabled","disabled");
 						 $delFieldBtn.attr("disabled","disabled");
 						return;
 					}
 				}
 				$.post("/integration/serviceReg/checkServiceParamsAjax.jsp",{type:2,seviceId:<%=servId%>,paramName:objvalue},function(data){ 
						if(!data["flag"]) {
							alert("<%=SystemEnv.getHtmlLabelName(30726,user.getLanguage())%>！");
	 						$(obj).attr("value","");
	 						$objspan.html("<img src='/images/BacoError_wev8.gif' align='center'>");
	 						 $bath2Btn.attr("disabled","disabled");
	 			 			 $addFieldBtn.attr("disabled","disabled");
	 						 $delFieldBtn.attr("disabled","disabled");
						}else {
							 $bath2Btn.attr("disabled","");
	 			 			 $addFieldBtn.attr("disabled","");
	 						 $delFieldBtn.attr("disabled","");
						}
				},"json");
 			}
 		}
 		
 		if(type == 5) {
 			
 			var objname = $(obj).attr("name");
 			var hiddenNum = objname.substring(8);
 			var $objspan = $("#"+objname+"span");
 			var objvalue = $(obj).attr("value");
 			var lengthtemp = $("#cbox4"+"_"+hiddenNum).val();
 			
 			for(var i=1;i<=lengthtemp;i++) {
				var input01="sap04_"+hiddenNum+"_"+i;
				$("input[name='"+input01+"']").parent().parent().remove();
			}
 			var $bath2Btn = $("#bath4_"+hiddenNum);
 			var $addFieldBtn = $("#addoutstru_"+hiddenNum);
			var $delFieldBtn = $("#deloutstru_"+hiddenNum);
 			if(objvalue == '') {
 				$objspan.html("<img src='/images/BacoError_wev8.gif' align='center'>");
 				$bath2Btn.attr("disabled","disabled");
	 			 $addFieldBtn.attr("disabled","disabled");
				 $delFieldBtn.attr("disabled","disabled");
 			}else {
 				$objspan.html("");
 				var hiddensum = $("#hidden04").attr("value");
 				for(var i=1;i<=hiddensum;i++) {
 					if(objname==('outstru_'+i)) continue;
 					var comtemp = $("input[name='outstru_"+i+"']").attr("value");
 					if($.trim(objvalue) == $.trim(comtemp)) {
 						alert("<%=SystemEnv.getHtmlLabelName(30725,user.getLanguage())%>！");
 						$(obj).attr("value","");
 						$objspan.html("<img src='/images/BacoError_wev8.gif' align='center'>");
 						 $bath2Btn.attr("disabled","disabled");
 			 			 $addFieldBtn.attr("disabled","disabled");
 						 $delFieldBtn.attr("disabled","disabled");
 						return;
 					}
 				}
 				$.post("/integration/serviceReg/checkServiceParamsAjax.jsp",{type:5,seviceId:<%=servId%>,paramName:objvalue},function(data){ 
						if(!data["flag"]) {
							alert("<%=SystemEnv.getHtmlLabelName(30726,user.getLanguage())%>！");
	 						$(obj).attr("value","");
	 						$objspan.html("<img src='/images/BacoError_wev8.gif' align='center'>");
	 						 $bath2Btn.attr("disabled","disabled");
	 			 			 $addFieldBtn.attr("disabled","disabled");
	 						 $delFieldBtn.attr("disabled","disabled");
						}else {
							 $bath2Btn.attr("disabled","");
	 			 			 $addFieldBtn.attr("disabled","");
	 						 $delFieldBtn.attr("disabled","");
						}
				},"json");
 			}
 		}
 		
 		if(type == 10) {
 			
 			var objname = $(obj).attr("name");
 			var hiddenNum = objname.substring(10);
 			var $objspan = $("#"+objname+"span");
 			var objvalue = $(obj).attr("value");
 			
 			var lengthtemp = $("#cbox7"+"_"+hiddenNum).val();
 		
			for(var i=1;i<=lengthtemp;i++) {
				var input01="sap07_"+hiddenNum+"_"+i;
				$("input[name='"+input01+"']").parent().parent().remove();
			}
			
 			var $bath2Btn = $("#bath7_"+hiddenNum);
 			var $addFieldBtn = $("#addtable_"+hiddenNum);
			var $delFieldBtn = $("#deltable_"+hiddenNum);
 			if(objvalue == '') {
 				$objspan.html("<img src='/images/BacoError_wev8.gif' align='center'>");
 				$bath2Btn.attr("disabled","disabled");
	 			 $addFieldBtn.attr("disabled","disabled");
				 $delFieldBtn.attr("disabled","disabled");
 			}else {
 				$objspan.html("");
 				var hiddensum = $("#hidden07").attr("value");
 				for(var i=1;i<=hiddensum;i++) {
 					if(objname==('outtable7_'+i)) continue;
 					var comtemp = $("input[name='outtable7_"+i+"']").attr("value");
 					if($.trim(objvalue) == $.trim(comtemp)) {
 						alert("<%=SystemEnv.getHtmlLabelName(30727,user.getLanguage())%>！");
 						$(obj).attr("value","");
 						$objspan.html("<img src='/images/BacoError_wev8.gif' align='center'>");
 						 $bath2Btn.attr("disabled","disabled");
 			 			 $addFieldBtn.attr("disabled","disabled");
 						 $delFieldBtn.attr("disabled","disabled");
 						return;
 					}
 				}
 				$.post("/integration/serviceReg/checkServiceParamsAjax.jsp",{type:10,seviceId:<%=servId%>,paramName:objvalue},function(data){ 
						if(!data["flag"]) {
							alert("<%=SystemEnv.getHtmlLabelName(30728,user.getLanguage())%>！");
	 						$(obj).attr("value","");
	 						$objspan.html("<img src='/images/BacoError_wev8.gif' align='center'>");
	 						 $bath2Btn.attr("disabled","disabled");
	 			 			 $addFieldBtn.attr("disabled","disabled");
	 						 $delFieldBtn.attr("disabled","disabled");
						}else {
							 $bath2Btn.attr("disabled","");
	 			 			 $addFieldBtn.attr("disabled","");
	 						 $delFieldBtn.attr("disabled","");
						}
				},"json");
 			}
 		}
 		
 		if(type == 7) {
 			var objname = $(obj).attr("name");
 			var hiddenNum = objname.substring(9);
 			var $objspan = $("#"+objname+"span");
 			var objvalue = $(obj).attr("value");
 			var lengthtemp = $("#cbox5"+"_"+hiddenNum).val();
 			
 			for(var i=1;i<=lengthtemp;i++) {
				var input01="sap05_"+hiddenNum+"_"+i;
				$("input[name='"+input01+"']").parent().parent().remove();
			}
 			var $bath2Btn = $("#bath5_"+hiddenNum);
 			var $addFieldBtn = $("#addouttable_"+hiddenNum);
			var $delFieldBtn = $("#delouttable_"+hiddenNum);
 			if(objvalue == '') {
 				$objspan.html("<img src='/images/BacoError_wev8.gif' align='center'>");
 				$bath2Btn.attr("disabled","disabled");
	 			 $addFieldBtn.attr("disabled","disabled");
				 $delFieldBtn.attr("disabled","disabled");
 			}else {
 				$objspan.html("");
 				var hiddensum = $("#hidden05").attr("value");
 				for(var i=1;i<=hiddensum;i++) {
 					if(objname==('outtable_'+i)) continue;
 					var comtemp = $("input[name='outtable_"+i+"']").attr("value");
 					if($.trim(objvalue) == $.trim(comtemp)) {
 						alert("<%=SystemEnv.getHtmlLabelName(30727,user.getLanguage())%>！");
 						$(obj).attr("value","");
 						$objspan.html("<img src='/images/BacoError_wev8.gif' align='center'>");
 						 $bath2Btn.attr("disabled","disabled");
 			 			 $addFieldBtn.attr("disabled","disabled");
 						 $delFieldBtn.attr("disabled","disabled");
 						return;
 					}
 				}
 				$.post("/integration/serviceReg/checkServiceParamsAjax.jsp",{type:7,seviceId:<%=servId%>,paramName:objvalue},function(data){ 
						if(!data["flag"]) {
							alert("<%=SystemEnv.getHtmlLabelName(30728,user.getLanguage())%>！");
	 						$(obj).attr("value","");
	 						$objspan.html("<img src='/images/BacoError_wev8.gif' align='center'>");
	 						 $bath2Btn.attr("disabled","disabled");
	 			 			 $addFieldBtn.attr("disabled","disabled");
	 						 $delFieldBtn.attr("disabled","disabled");
						}else {
							 $bath2Btn.attr("disabled","");
	 			 			 $addFieldBtn.attr("disabled","");
	 						 $delFieldBtn.attr("disabled","");
						}
				},"json");
 			}
 		}
 		
 		if(type == 3) {
 			var objname = $(obj).attr("name");
 			var chtabletemp = objname.split("_")[1];
 			var compParamName = $("#stru_"+chtabletemp).attr("value");
 			var nowtemp = objname.split("_")[2];
 			var $objspan = $("#"+objname+"span");
 			var objvalue = $(obj).attr("value");
 			var lengthtemp = $("#cbox2"+"_"+chtabletemp).val();
 			if(objvalue == '') {
 				$objspan.html("<img src='/images/BacoError_wev8.gif' align='center'>");
 			}else {
 				$objspan.html("");
 				for(var i=1;i<=lengthtemp;i++) {
 					if(objname==('sap02_'+chtabletemp+"_"+i)) continue;
 					var comtemp = $("input[name='sap02_"+chtabletemp+"_"+i+"']").attr("value");
 					if($.trim(objvalue) == $.trim(comtemp)) {
 						alert("<%=SystemEnv.getHtmlLabelName(30723,user.getLanguage())%>！");
 						$(obj).attr("value","");
 						$objspan.html("<img src='/images/BacoError_wev8.gif' align='center'>");
 						return;
 					}
 				}
 				$.post("/integration/serviceReg/checkServiceParamsAjax.jsp",{compParamName:compParamName,type:3,seviceId:<%=servId%>,paramName:objvalue},function(data){ 
						if(!data["flag"]) {
							alert("<%=SystemEnv.getHtmlLabelName(30724,user.getLanguage())%>！");
	 						$(obj).attr("value","");
	 						$objspan.html("<img src='/images/BacoError_wev8.gif' align='center'>");
						}else {
							$("input[name='sapDesc02_"+chtabletemp+"_"+nowtemp+"']").attr("value",data["message"]);
						}	
				},"json");
 			}
 		}
 		
 		if(type==6) {
 			var objname = $(obj).attr("name");
 			var chtabletemp = objname.split("_")[1];
 			var compParamName = $("#outstru_"+chtabletemp).attr("value");
 			var nowtemp = objname.split("_")[2];
 			var $objspan = $("#"+objname+"span");
 			var objvalue = $(obj).attr("value");
 			var lengthtemp = $("#cbox4"+"_"+chtabletemp).val();
 			if(objvalue == '') {
 				$objspan.html("<img src='/images/BacoError_wev8.gif' align='center'>");
 			}else {
 				$objspan.html("");
 				for(var i=1;i<=lengthtemp;i++) {
 					if(objname==('sap04_'+chtabletemp+"_"+i)) continue;
 					var comtemp = $("input[name='sap04_"+chtabletemp+"_"+i+"']").attr("value");
 					if($.trim(objvalue) == $.trim(comtemp)) {
 						alert("<%=SystemEnv.getHtmlLabelName(30723,user.getLanguage())%>！");
 						$(obj).attr("value","");
 						$objspan.html("<img src='/images/BacoError_wev8.gif' align='center'>");
 						return;
 					}
 				}
 				$.post("/integration/serviceReg/checkServiceParamsAjax.jsp",{compParamName:compParamName,type:6,seviceId:<%=servId%>,paramName:objvalue},function(data){ 
						if(!data["flag"]) {
							alert("<%=SystemEnv.getHtmlLabelName(30724,user.getLanguage())%>！");
	 						$(obj).attr("value","");
	 						$objspan.html("<img src='/images/BacoError_wev8.gif' align='center'>");
						}else {
							$("input[name='sapDesc04_"+chtabletemp+"_"+nowtemp+"']").attr("value",data["message"]);
						}	
				},"json");
 			}
 		}
 		
 		if(type==8) {
 			var objname = $(obj).attr("name");
 			var chtabletemp = objname.split("_")[1];
 			var compParamName = $("#outtable_"+chtabletemp).attr("value");
 			var nowtemp = objname.split("_")[2];
 			var $objspan = $("#"+objname+"span");
 			var objvalue = $(obj).attr("value");
 			var lengthtemp = $("#cbox5"+"_"+chtabletemp).val();
 			if(objvalue == '') {
 				$objspan.html("<img src='/images/BacoError_wev8.gif' align='center'>");
 			}else {
 				$objspan.html("");
 				for(var i=1;i<=lengthtemp;i++) {
 					if(objname==('sap05_'+chtabletemp+"_"+i)) continue;
 					var comtemp = $("input[name='sap05_"+chtabletemp+"_"+i+"']").attr("value");
 					if($.trim(objvalue) == $.trim(comtemp)) {
 						alert("<%=SystemEnv.getHtmlLabelName(30723,user.getLanguage())%>！");
 						$(obj).attr("value","");
 						$objspan.html("<img src='/images/BacoError_wev8.gif' align='center'>");
 						return;
 					}
 				}
 				$.post("/integration/serviceReg/checkServiceParamsAjax.jsp",{compParamName:compParamName,type:8,seviceId:<%=servId%>,paramName:objvalue},function(data){ 
						if(!data["flag"]) {
							alert("<%=SystemEnv.getHtmlLabelName(30724,user.getLanguage())%>！");
	 						$(obj).attr("value","");
	 						$objspan.html("<img src='/images/BacoError_wev8.gif' align='center'>");
						}else {
							$("input[name='sapDesc05_"+chtabletemp+"_"+nowtemp+"']").attr("value",data["message"]);
						}	
				},"json");
 			}
 		}
 		
 		if(type==11) {
 			var objname = $(obj).attr("name");
 			var chtabletemp = objname.split("_")[1];
 			var compParamName = $("#outtable7_"+chtabletemp).attr("value");
 			var nowtemp = objname.split("_")[2];
 			var $objspan = $("#"+objname+"span");
 			var objvalue = $(obj).attr("value");
 			var lengthtemp = $("#cbox7"+"_"+chtabletemp).val();
 			if(objvalue == '') {
 				$objspan.html("<img src='/images/BacoError_wev8.gif' align='center'>");
 			}else {
 				$objspan.html("");
 				for(var i=1;i<=lengthtemp;i++) {
 					if(objname==('sap07_'+chtabletemp+"_"+i)) continue;
 					var comtemp = $("input[name='sap07_"+chtabletemp+"_"+i+"']").attr("value");
 					if($.trim(objvalue) == $.trim(comtemp)) {
 						alert("<%=SystemEnv.getHtmlLabelName(30723,user.getLanguage())%>！");
 						$(obj).attr("value","");
 						$objspan.html("<img src='/images/BacoError_wev8.gif' align='center'>");
 						return;
 					}
 				}
 				$.post("/integration/serviceReg/checkServiceParamsAjax.jsp",{compParamName:compParamName,type:11,seviceId:<%=servId%>,paramName:objvalue},function(data){ 
						if(!data["flag"]) {
							alert("<%=SystemEnv.getHtmlLabelName(30724,user.getLanguage())%>！");
	 						$(obj).attr("value","");
	 						$objspan.html("<img src='/images/BacoError_wev8.gif' align='center'>");
						}else {
							$("input[name='sapDesc07_"+chtabletemp+"_"+nowtemp+"']").attr("value",data["message"]);
						}	
				},"json");
 			}
 		}
 		
 	}
 	
 	function addBathFieldObjCallBack1(objjosn,temp){
 		var type =objjosn.type;
 		var source = objjosn.source;
 		var stuname = objjosn.stuname
 		var chtable = objjosn.chtable
 		if(temp)
		{
			if (temp.id!="" && temp.id != 0) {
				var tempsz=temp.id.split("##");
				var tempname = temp.name.split("##");
				for(var ij=0;ij<tempsz.length;ij++)
				{
					if(tempsz[ij])
					{
						var shuzi=parseInt($("#hidden01").val())+1;
						var input01="sap01_"+shuzi;
						var input01Span="sap01_"+shuzi+"Span";
						var input02="sapDesc01_"+shuzi;
						var input03="con01_"+shuzi;
						var vTb=$("#chind01");
						var temp = "<td><input type='checkbox' name='cbox1'></td><td><%=SystemEnv.getHtmlLabelName(28247,user.getLanguage())%></td>";
						temp += "<td style='padding-top:6px;'><span><button type='button' class='e8_browflow' onclick=addOneFieldObj(1,"+shuzi+")></button></span>";
						temp += "<span id='"+input01Span+"' style='vertical-align: middle;width:7px;'></span>";
						temp += "<span style='vertical-align: middle;'><input type='text' name='"+input01+"' value='"+tempsz[ij]+"' style='border:1px solid #D4E9E9;height:28px;' onchange='javascript:sapFieldChange(1,this)'></span>";
						temp += "</td><td><%=SystemEnv.getHtmlLabelName(30708,user.getLanguage())%></td><td style='padding-top:5px;'><input type='text' name='"+input02+"' style='border:1px solid #D4E9E9;width:185px;height:28px;' value='"+tempname[ij]+"'></td>";
						temp += "<td><%=SystemEnv.getHtmlLabelName(453,user.getLanguage())%></td><td style='padding-top:5px;'><input type='text' ";
						temp += "name='"+input03+"' style='border:1px solid #D4E9E9;width:170px;height:28px;'></td>"
						var td = $(temp);
						var row = $("<tr class='DataDark'></tr>");
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
 	
 	function addBathFieldObjCallBack2(objjosn,temp){
 		var type =objjosn.type;
 		var source = objjosn.source;
 		var stuname = objjosn.stuname
 		var chtable = objjosn.chtable
 		
		if(temp)
		{
			if (temp.id!="" && temp.id != 0) 
			{
				var tempsz=temp.id.split("##");
				for(var ij=0;ij<tempsz.length;ij++)
				{
					if(tempsz[ij])
					{
							var chtable=parseInt($("#hidden02").val())+1;
							var shuzi=parseInt(chtable)+1;
							var newname="cbox2"+"_"+chtable;
							var newtable="sap_02"+"_"+chtable;
							var newstru="stru_"+chtable;
							var newstruSpan="stru_"+chtable+"span";
							var bath="bath2_"+chtable;
							var addFieldBtn = "addstru_"+chtable;
							var delFieldBtn = "delstru_"+chtable;
							
							var row = $("<tr class='DataDark'><td class='tdcenter'><input type='checkbox' name='cbox2'></td>"); 	
							var temp = "<td style='padding-top:0px;padding-bottom:0px;'><table   cellspacing=1 style='width:100%;margin-top:0px;margin-bottom:0px;padding-top:0;padding-bottom:0;'><tr class='DataDark'><td style='width:50px;vertical-align: middle;'><%=SystemEnv.getHtmlLabelName(30609,user.getLanguage())%></td><td style='width:220px;'><button type='button' class='e8_browflow' "; 
						    temp += " style='vertical-align: middle;' onclick=addOneFieldObj(2,"+chtable+",'"+newstru+"')></button>"; 
						    temp += "<span id='"+newstruSpan+"' style='vertical-align: middle;width:15px;'>"; 
						    temp += " </span> <span><input type='text' name='"+newstru+"' id='"+newstru+"' value='"+tempsz[ij]+"' onchange='javascript:sapFieldChange(2,this)' style='width:180px;height:28px;border:1px solid #D4E9E9;vertical-align: middle;' ></span>";
						    temp += " </td><td>";
						    temp += " <input type='hidden' id='"+newname+"' name='"+newname+"' value='0'></td></tr></table>";
						    temp += " <TABLE class=ListStyle style='margin-top:0px;' cellspacing=1 id='"+newtable+"'>";
						    temp += "  <tr class=header><td style='width:100px;'><input type='checkbox'"; 
						    temp += " onclick='checkbox2(this,"+chtable+")'/><%=SystemEnv.getHtmlLabelName(556,user.getLanguage())%></td><td style='text-align:right;' colspan='7'>";
						    temp += "<input type='button'  class='addbtnB' id='"+bath+"'"; 
						    temp += " onclick=addBathFieldObj(3,1,'"+newstru+"','"+chtable+"') title='<%=SystemEnv.getHtmlLabelName(25055,user.getLanguage())%>'>"; 
						    temp += " <input type='button' class='addbtn' id='"+addFieldBtn+"' ";  
						    temp += " onclick=addBathFieldObj(3,2,'"+newstru+"','"+chtable+"') title='<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>'>";
						    temp += " <input type='button' class='delbtn' id='"+delFieldBtn+"' "; 
						    temp += " onclick=addBathFieldObj(3,3,'"+newstru+"','"+chtable+"') title='<%=SystemEnv.getHtmlLabelName(23777,user.getLanguage())%>'>"; 
						    temp += "</td></tr>";
						    temp += " </TABLE>";
						   
							row.append(temp);	
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
 	
 	function addBathFieldObjCallBack3(objjosn,temp){
 		var type =objjosn.type;
 		var source = objjosn.source;
 		var stuname = objjosn.stuname
 		var chtable = objjosn.chtable
 		if(temp)
				{
		    	 	if (temp.id!="" && temp.id != 0)
		    	    {
							var tempsz=temp.id.split("##");
							var tempname = temp.name.split("##");
							for(var ij=0;ij<tempsz.length;ij++)
							{
								if(tempsz[ij])
								{
									//得到子表的对象
							 		var newtable=$("#sap_02"+"_"+chtable);
		 							var newchtable=parseInt($("#cbox2"+"_"+chtable).val())+1;
							 		var input01="sap02_"+chtable+"_"+newchtable;
									var input03="con02_"+chtable+"_"+newchtable;
									var input01Desc = "sapDesc02_"+chtable+"_"+newchtable;
									var input01Span="sap02_"+chtable+"_"+newchtable+"span";
									var numstemp = chtable+"_"+newchtable;
									var temp = "";
									temp += "<tr class='DataDark'><td><input type='checkbox' name='zibox'></td><td style='width:90px;vertical-align: middle;'><%=SystemEnv.getHtmlLabelName(28247,user.getLanguage())%></td><td style='width:208px;padding-top: 6px;padding-bottom:6px;'>";
									temp += "<button type='button' style='vertical-align: middle;' class='e8_browflow'";
									temp += " onclick=addOneFieldObj(3,'"+numstemp+"','"+stuname+"')></button>";
									temp += "<span id='"+input01Span+"' style='vertical-align: middle;width:7px;'></span>";
									temp += "<input type='text' name='"+input01+"'";  
									temp += " value='"+tempsz[ij]+"' onchange='javascript:sapFieldChange(3,this)' style='vertical-align: middle;border:1px solid #D4E9E9;height:28px;'>";
									temp += "</td><td style='width:90px;vertical-align: middle;'><%=SystemEnv.getHtmlLabelName(30708,user.getLanguage())%></td><td style='width:180px;padding-top: 5px;padding-bottom:5px;'>"; 
									temp += "<input type='text' name='"+input01Desc+"'";  
									temp += " value='"+tempname[ij]+"' style='vertical-align: middle;border:1px solid #D4E9E9;height:28px;'>";
									temp += "</td><td style='width:80px;vertical-align: middle;'><%=SystemEnv.getHtmlLabelName(453,user.getLanguage())%></td>";
									temp += "<td style='padding-top:5px;padding-bottom:5px;'><input type='text' name='"+input03+"' style='border:1px solid #D4E9E9;height:28px;'></td></tr>";
							 		newtable.append($(temp)); 
							 		$("#cbox2"+"_"+chtable).attr("value",newchtable);
						 		}
						 	}
					 }
				 }
						
						$('body').jNice();
 	}
 	
 	function addBathFieldObjCallBack4(objjosn,temp){
 		var type =objjosn.type;
 		var source = objjosn.source;
 		var stuname = objjosn.stuname
 		var chtable = objjosn.chtable
 		if(temp)
		{
    	 	if (temp.id!="" && temp.id != 0)
    	    {
					var tempsz=temp.id.split("##");
					var tempnames=temp.name.split("##");
					for(var ij=0;ij<tempsz.length;ij++)
					{
						if(tempsz[ij])
						{
							var shuzi=parseInt($("#hidden03").val())+1;
							var input01="sap03_"+shuzi;
							var input01Span="sap03_"+shuzi+"span";
							var input02="sapDesc03_"+shuzi;//显示名--文本框
							//var input04Span="setoa_"+shuzi+"span";
							var vTb=$("#chind03");
							var temp = "<td><input type='checkbox' name='cbox3'></td><td><%=SystemEnv.getHtmlLabelName(28247,user.getLanguage())%></td>";
							temp += "<td style='padding-top:6px;'><span><button type='button' class='e8_browflow' onclick=addOneFieldObj(4,"+shuzi+")></button></span>";
							temp += "<span id='"+input01Span+"' style='vertical-align: middle;width:7px;'></span>";
							temp += "<span style='vertical-align: middle;'><input type='text' name='"+input01+"' value='"+tempsz[ij]+"' style='border:1px solid #D4E9E9;height:28px;' onchange='javascript:sapFieldChange(4,this)'></span>";
							temp += "</td><td><%=SystemEnv.getHtmlLabelName(30708,user.getLanguage())%></td><td style='padding-top:5px;'><input type='text' name='"+input02+"' value='"+tempnames[ij]+"' style='border:1px solid #D4E9E9;width:185px;height:28px;' ></td>";
							var td = $(temp);
							var row = $("<tr style='height:40px;'></tr>");
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
 	
 	
 	function addBathFieldObjCallBack5(objjosn,temp){
 		var type =objjosn.type;
 		var source = objjosn.source;
 		var stuname = objjosn.stuname
 		var chtable = objjosn.chtable
 		if(temp)
		{
    	 	if (temp.id!="" && temp.id != 0)
    	    {
					var tempsz=temp.id.split("##");
					for(var ij=0;ij<tempsz.length;ij++)
					{
						if(tempsz[ij])
						{
							var chtable=parseInt($("#hidden04").val())+1;
							var newname="cbox4"+"_"+chtable;
							var newtable="sap_04"+"_"+chtable;
							var newstru="outstru_"+chtable;
							var newstruSpan="outstru_"+chtable+"span";
							var bath="bath4_"+chtable;
							var addFieldBtn = "addoutstru_"+chtable;
							var delFieldBtn = "deloutstru_"+chtable;
							var row = $("<tr class='DataDark'><td class='tdcenter'><input type='checkbox' name='cbox4'></td>"); 	
							var temp = "<td style='padding-top:0px;padding-bottom:0px;'><table   cellspacing=1 style='width:100%;margin-top:0px;margin-bottom:0px;padding-top:0;padding-bottom:0;'><tr class='DataDark'><td style='width:50px;vertical-align: middle;'><%=SystemEnv.getHtmlLabelName(30609,user.getLanguage()) %></td><td style='width:220px;'><button type='button' class='e8_browflow' "; 
							temp += " style='vertical-align: middle;' onclick=addOneFieldObj(5,"+chtable+",'"+newstru+"')></button>"; 
							temp += "<span id='"+newstruSpan+"' style='vertical-align: middle;width:12px;'>"; 
							temp += "</span> <span><input type='text' name='"+newstru+"' id='"+newstru+"' onchange='javascript:sapFieldChange(5,this)' value='"+tempsz[ij]+"'  style='width:180px;height:28px;border:1px solid #D4E9E9;vertical-align: middle;' ></span>";
							temp += " </td><td>"; 
							temp += " <input type='hidden' id='"+newname+"' name='"+newname+"' value='0'></td></tr></table>";
							temp += " <TABLE class=ListStyle style='margin-top:0px;width:100%;' cellspacing=1 id='"+newtable+"'>";
							temp += "  <tr class=header><td style='width:100px;'><input type='checkbox'"; 
							temp += " onclick='checkbox4(this,"+chtable+")'/><%=SystemEnv.getHtmlLabelName(556,user.getLanguage())%></td>";
							temp += " <td colspan='4' style='text-align:right;'>";
							temp += " <input type='button'  class='addbtnB' id='"+bath+"'  onclick=addBathFieldObj(6,1,'"+newstru+"','"+chtable+"') title='<%=SystemEnv.getHtmlLabelName(25055,user.getLanguage())%>'>"; 
							temp += " <input type='button' class='addbtn' id='"+addFieldBtn+"' "; 
							temp += " onclick=addBathFieldObj(6,2,'"+newstru+"','"+chtable+"') title='<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>'>";
							temp += " <input type='button' class='delbtn' id='"+delFieldBtn+"' "; 
							temp += " onclick=addBathFieldObj(6,3,'"+newstru+"','"+chtable+"') title='<%=SystemEnv.getHtmlLabelName(23777,user.getLanguage())%>'>";
							temp += " </TD></TR></TABLE>";
							row.append(temp);
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
 	
 	
 	function addBathFieldObjCallBack6(objjosn,temp){
 		var type =objjosn.type;
 		var source = objjosn.source;
 		var stuname = objjosn.stuname
 		var chtable = objjosn.chtable
 		if(temp)
		{
    	 	if (temp.id!="" && temp.id != 0)
    	    {
					var tempsz=temp.id.split("##");
					var tempnames=temp.name.split("##");
					for(var ij=0;ij<tempsz.length;ij++)
					{
						if(tempsz[ij])
						{
						
										
							//得到子表的id
					 		var newtable=$("#sap_04"+"_"+chtable);
					 		var newchtable=parseInt($("#cbox4"+"_"+chtable).val())+1;
					 		var input01="sap04_"+chtable+"_"+newchtable;
					 		var input01Span="sap04_"+chtable+"_"+newchtable+"span";
					 		var input01Desc = "sapDesc04_"+chtable+"_"+newchtable;
							var numstemp = chtable+"_"+newchtable;
							var temp = "";
							temp += "<tr class='DataDark'><td style='width:100px;'><input type='checkbox' name='zibox'></td><td style='width:90px;vertical-align: middle;'><%=SystemEnv.getHtmlLabelName(28247,user.getLanguage())%></td><td style='width:208px;padding-top: 6px;padding-bottom:6px;'>";
							temp += "<button type='button' style='vertical-align: middle;' class='e8_browflow'";
							temp += " onclick=addOneFieldObj(6,'"+numstemp+"','"+stuname+"')></button>";
							temp += "<span id='"+input01Span+"' style='vertical-align: middle;width:7px;'></span>";
							temp += "<input type='text' name='"+input01+"'";  
							temp += " value='"+tempsz[ij]+"' onchange='javascript:sapFieldChange(6,this)' style='vertical-align: middle;border:1px solid #D4E9E9;height:28px;'>";
							temp += "</td><td style='width:90px;vertical-align: middle;'><%=SystemEnv.getHtmlLabelName(30708,user.getLanguage())%></td><td style='padding-top: 5px;padding-bottom:5px;'>"; 
							temp += "<input type='text' name='"+input01Desc+"'";  
							temp += " value='"+tempnames[ij]+"' style='vertical-align: middle;border:1px solid #D4E9E9;height:28px;'>";
							temp += "</td></tr>";
							newtable.append($(temp)); 
					 		$("#cbox4"+"_"+chtable).attr("value",newchtable);
					 	}
					 }
			}
			}
			$('body').jNice();
 	}
 	
 	function addBathFieldObjCallBack7(objjosn,temp){
 		var type =objjosn.type;
 		var source = objjosn.source;
 		var stuname = objjosn.stuname
 		var chtable = objjosn.chtable
 		if(temp)
		{
    	 	if (temp.id!="" && temp.id != 0)
    	    {
					var tempsz=temp.id.split("##");
					for(var ij=0;ij<tempsz.length;ij++)
					{
						if(tempsz[ij])
						{
							var chtable=parseInt($("#hidden05").val())+1;
							var newname="cbox5"+"_"+chtable;
							var newtable="sap_05"+"_"+chtable;
							var newstru="outtable_"+chtable;
							var newstruSpan="outtable_"+chtable+"span";
							var bath="bath5_"+chtable;
							var addFieldBtn = "addouttable_"+chtable;
							var delFieldBtn = "delouttable_"+chtable;
							var row = $("<tr class='DataDark'><td class='tdcenter'><input type='checkbox' name='cbox5'></td>"); 	
							var temp = "<td style='padding-top:0px;padding-bottom:0px;'><table   cellspacing=1 style='width:100%;margin-top:0px;margin-bottom:0px;padding-top:0;padding-bottom:0;'><tr class='DataDark'><td style='width:50px;vertical-align: middle;'>表名</td><td style='width:220px;'><button type='button' class='e8_browflow' "; 
							temp += " style='vertical-align: middle;' onclick=addOneFieldObj(7,"+chtable+",'"+newstru+"')></button>"; 
							temp += "<span id='"+newstruSpan+"' style='vertical-align: middle;width:12px;'>"; 
							temp += "</span> <span><input type='text' name='"+newstru+"' id='"+newstru+"' value='"+tempsz[ij]+"' onchange='javascript:sapFieldChange(7,this)'  style='width:180px;height:28px;border:1px solid #D4E9E9;vertical-align: middle;' ></span>";
							temp += " </td><td>"; 
							temp += " <input type='hidden' id='"+newname+"' name='"+newname+"' value='0'></td></tr></table>";
							temp += " <TABLE class=ListStyle style='margin-top:0px;width:100%;' cellspacing=1 id='"+newtable+"'>";
							temp += "  <tr class=header><td style='width:100px;'><input type='checkbox'"; 
							temp += " onclick='checkbox5(this,"+chtable+")'/><%=SystemEnv.getHtmlLabelName(556,user.getLanguage())%></td>";
							temp += " <td colspan='4' style='text-align:right;'>";
							temp += " <input type='button'  class='addbtnB' id='"+bath+"'  onclick=addBathFieldObj(8,1,'"+newstru+"','"+chtable+"')  title='<%=SystemEnv.getHtmlLabelName(25055,user.getLanguage())%>'>"; 
							temp += " <input type='button' class='addbtn' id='"+addFieldBtn+"' "; 
							temp += " onclick=addBathFieldObj(8,2,'"+newstru+"','"+chtable+"') title='<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>'>";
							temp += " <input type='button' class='delbtn' id='"+delFieldBtn+"' "; 
							temp += " onclick=addBathFieldObj(8,3,'"+newstru+"','"+chtable+"')  title='<%=SystemEnv.getHtmlLabelName(23777,user.getLanguage())%>'>";
							temp += " </TD></TR></TABLE>";	
							row.append(temp);
							row.append("</td></tr>");
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
 	
 	
 	
 	function addBathFieldObjCallBack8(objjosn,temp){
 		var type =objjosn.type;
 		var source = objjosn.source;
 		var stuname = objjosn.stuname
 		var chtable = objjosn.chtable
 		if(temp)
		{
    	 	if (temp.id!="" && temp.id != 0)
    	    {
					var tempsz=temp.id.split("##");
					var tempnames=temp.name.split("##");
					for(var ij=0;ij<tempsz.length;ij++)
					{
						if(tempsz[ij])
						{
							//得到子表的id
					 		var newtable=$("#sap_05"+"_"+chtable);
					 		var newchtable=parseInt($("#cbox5"+"_"+chtable).val())+1;
					 		var input01="sap05_"+chtable+"_"+newchtable;
					 		var input01Span="sap05_"+chtable+"_"+newchtable+"span";
					 		var input01Desc = "sapDesc05_"+chtable+"_"+newchtable;
							var numstemp = chtable+"_"+newchtable;
							
							var temp = "";
							temp += "<tr class='DataDark'><td style='width:100px;'><input type='checkbox' name='zibox'></td><td style='width:90px;vertical-align: middle;'><%=SystemEnv.getHtmlLabelName(28247,user.getLanguage())%></td><td style='width:208px;padding-top: 6px;padding-bottom:6px;'>";
							temp += "<button type='button' style='vertical-align: middle;' class='e8_browflow'";
							temp += " onclick=addOneFieldObj(8,'"+numstemp+"','"+stuname+"')></button>";
							temp += "<span id='"+input01Span+"' style='vertical-align: middle;width:7px;'></span>";
							temp += "<input type='text' name='"+input01+"'";  
							temp += " value='"+tempsz[ij]+"' onchange='javascript:sapFieldChange(8,this)' style='vertical-align: middle;border:1px solid #D4E9E9;height:28px;'>";
							temp += "</td><td style='width:90px;vertical-align: middle;'><%=SystemEnv.getHtmlLabelName(30708,user.getLanguage())%></td><td style='padding-top: 5px;padding-bottom:5px;'>"; 
							temp += "<input type='text' name='"+input01Desc+"'";  
							temp += " value='"+tempnames[ij]+"' style='vertical-align: middle;border:1px solid #D4E9E9;height:28px;'>";
							temp += "</td></tr>";
							newtable.append($(temp)); 
					 		$("#cbox5"+"_"+chtable).attr("value",newchtable);
					 	}
					 }
			}
		}
	
		$('body').jNice();
 	}
 	
 	
 	function addBathFieldObjCallBack10(objjosn,temp){
 		var type =objjosn.type;
 		var source = objjosn.source;
 		var stuname = objjosn.stuname
 		var chtable = objjosn.chtable
 		if(temp)
		{
    	 	if (temp.id!="" && temp.id != 0)
    	    {
					var tempsz=temp.id.split("##");
					for(var ij=0;ij<tempsz.length;ij++)
					{
						if(tempsz[ij])
						{
							var chtable=parseInt($("#hidden07").val())+1;
							var newname="cbox7"+"_"+chtable;
							var newtable="sap_07"+"_"+chtable;
							var newstru="outtable7_"+chtable;
							var newstruSpan="outtable7_"+chtable+"span";
							var bath="bath7_"+chtable;
							var addFieldBtn = "addtable_"+chtable;
							var delFieldBtn = "deltable_"+chtable;
							
							var row = $("<tr class='DataDark'><td class='tdcenter'><input type='checkbox' name='cbox7'></td>"); 	
							var temp = "<td style='padding-top:0px;padding-bottom:0px;'><table   cellspacing=1 style='width:100%;margin-top:0px;margin-bottom:0px;padding-top:0;padding-bottom:0;'><tr class='DataDark'><td style='width:50px;vertical-align: middle;'>表名</td><td style='width:220px;'><button type='button' class='e8_browflow' "; 
							    temp += " style='vertical-align: middle;' onclick=addOneFieldObj(10,"+chtable+",'"+newstru+"')></button>"; 
							    temp += "<span id='"+newstruSpan+"' style='vertical-align: middle;width:12px;'>"; 
							    temp += "</span> <span><input type='text' name='"+newstru+"' id='"+newstru+"' value='"+tempsz[ij]+"' onchange='javascript:sapFieldChange(10,this)'  style='width:180px;height:28px;border:1px solid #D4E9E9;vertical-align: middle;' ></span>";
							    temp += " </td><td>"; 
							    temp += " <input type='hidden' id='"+newname+"' name='"+newname+"' value='0'></td></tr></table>";
							    temp += " <TABLE class=ListStyle style='margin-top:0px;' cellspacing=1 id='"+newtable+"'>";
							    temp += "  <tr class=header><td style='width:100px;'><input type='checkbox'"; 
							    temp += " onclick='checkbox7(this,"+chtable+")'/><%=SystemEnv.getHtmlLabelName(556,user.getLanguage())%></td>";
							    temp += " <td colspan='7' style='text-align:right;'>";
							    temp += " <input type='button'  class='addbtnB' id='"+bath+"'  onclick=addBathFieldObj(11,1,'"+newstru+"','"+chtable+"')  title='<%=SystemEnv.getHtmlLabelName(25055,user.getLanguage())%>'>"; 
							    temp += " <input type='button' class='addbtn' id='"+addFieldBtn+"' "; 
							    temp += " onclick=addBathFieldObj(11,2,'"+newstru+"','"+chtable+"')  title='<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>'>";
							    temp += " <input type='button' class='delbtn' id='"+delFieldBtn+"' "; 
							    temp += " onclick=addBathFieldObj(11,3,'"+newstru+"','"+chtable+"')  title='<%=SystemEnv.getHtmlLabelName(23777,user.getLanguage())%>'>";
							    temp += " </TD></TR></TABLE>";
								row.append(temp);
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
 	
 	
 	function addBathFieldObjCallBack11(objjosn,temp){
 		var type =objjosn.type;
 		var source = objjosn.source;
 		var stuname = objjosn.stuname
 		var chtable = objjosn.chtable
 		if(temp)
		{
    	 	if (temp.id!="" && temp.id != 0)
    	    {
					var tempsz=temp.id.split("##");
					var tempnames=temp.name.split("##");
					for(var ij=0;ij<tempsz.length;ij++)
					{
						if(tempsz[ij])
						{
							//得到子表的id
					 		var newtable=$("#sap_07"+"_"+chtable);
					 		var newchtable=parseInt($("#cbox7"+"_"+chtable).val())+1;
					 		var input01="sap07_"+chtable+"_"+newchtable;
					 		var input01Span="sap07_"+chtable+"_"+newchtable+"span";
							var input03="con07_"+chtable+"_"+newchtable;
							var input01Desc = "sapDesc07_"+chtable+"_"+newchtable;
							var numstemp = chtable+"_"+newchtable;
							var temp = "";
							temp += "<tr><td><input type='checkbox' name='zibox'></td><td style='width:90px;vertical-align: middle;'><%=SystemEnv.getHtmlLabelName(28247,user.getLanguage())%></td><td style='width:208px;padding-top: 6px;padding-bottom:6px;'>";
							temp += "<button type='button' style='vertical-align: middle;' class='browser'";
							temp += " onclick=addOneFieldObj(11,'"+numstemp+"','"+stuname+"')></button>";
							temp += "<span id='"+input01Span+"' style='vertical-align: middle;width:7px;'></span>";
							temp += "<input type='text' name='"+input01+"'";  
							temp += " value='"+tempsz[ij]+"' onchange='javascript:sapFieldChange(11,this)' style='vertical-align: middle;border:1px solid #D4E9E9;width:172px;height:28px;'>";
							temp += "</td><td style='width:90px;vertical-align: middle;'><%=SystemEnv.getHtmlLabelName(30708,user.getLanguage())%></td><td style='width:180px;padding-top: 5px;padding-bottom:5px;'>"; 
							temp += "<input type='text' name='"+input01Desc+"'";  
							temp += " value='"+tempnames[ij]+"' style='vertical-align: middle;border:1px solid #D4E9E9;width:172px;height:28px;'>";
							temp += "</td><td style='width:80px;vertical-align: middle;'><%=SystemEnv.getHtmlLabelName(453,user.getLanguage())%></td>";
							temp += "<td style='padding-top:5px;padding-bottom:5px;'><input type='text' name='"+input03+"' style='border:1px solid #D4E9E9;width:172px;height:28px;'></td></tr>";
							newtable.append($(temp)); 
					 		$("#cbox7"+"_"+chtable).attr("value",newchtable);
					 	}
					 }
			}
		}
	
		$('body').jNice();
 	}
 	//所有批量字段操作
 	//type=1表示输入参数,source=1(点击批量按钮),source=2(点击添加按钮),source=3(点击删除按钮)
 	//type=2表示输入结构,source=1(点击批量按钮),source=2(点击添加按钮),source=3(点击删除按钮)
 	//type=3表示输入结构,source=1(点击批量按钮),source=2(点击添加按钮),source=3(点击删除按钮),stuname(结构体的名称所在的文本框的id)必须有值,chtable(结构体的流水编号)必须有值
 	//type=4表示输出参数，source=1(点击批量按钮),source=2(点击添加按钮),source=3(点击删除按钮)
 	//type=5表示输出结构,source=1(点击批量按钮),source=2(点击添加按钮),source=3(点击删除按钮)
 	//type=6表示输出结构,source=1(点击批量按钮),source=2(点击添加按钮),source=3(点击删除按钮),stuname(结构体的名称所在的文本框的id)必须有值
 	//type=7表示输出表,source=1(点击批量按钮),source=2(点击添加按钮),source=3(点击删除按钮)
 	//type=8表示输出表,source=1(点击批量按钮),source=2(点击添加按钮),source=3(点击删除按钮),stuname(输出表的名称所在的文本框的id)必须有值
 	//type=9表示内容权限设置,source=1(点击批量按钮),source=2(点击添加按钮),source=3(点击删除按钮)
 	//type=10表示输入表
 	//type=11表示输入表
 	//type=12表示输出表的where条件管理表
 	function addBathFieldObj(type,source,stuname,chtable)
 	{
 		if(type=="1")
 		{
 				if(source=="1")
 				{
 						var lengthtemp = $("#hidden01").val();
 						var disValue = '';
 						var numSum = 1;
 						if(lengthtemp>=1) {
 							for(var i=1;i<=lengthtemp;i++) {
 								var valuetemp = $("input[name='sap01_"+i+"']").attr("value");
 								if($.trim(valuetemp)== '') continue;
 								if(numSum == 1) {
 									disValue = valuetemp;
 								}else {
 									disValue += ","+valuetemp;
 								}
 								numSum ++;
 							}
 						}
 						//var temp=window.showModalDialog(","","dialogWidth:600px;dialogHeight:600px;center:yes;scroll:yes;status:no");
						var dialog = new window.top.Dialog();
			 			dialog.currentWindow = window;
						dialog.Title = "SAP";
					    dialog.URL = "/integration/serviceReg/serviceReg_3NewParamsModeSAP.jsp?servId=<%=servId%>&poolid=<%=poolid %>&type="+type+"&disValue="+disValue;
						dialog.Width = 660;
						dialog.Height = 660;
						dialog.Drag = true;
						dialog.callbackfun=addBathFieldObjCallBack1;
				 		dialog.callbackfunParam={type:type,source:source,stuname:stuname,chtable:chtable};
						dialog.textAlign = "center";
						dialog.show();
						
 				}else if(source=="2")
 				{
 						var shuzi=parseInt($("#hidden01").val())+1;
						var input01="sap01_"+shuzi;
						var input01Span="sap01_"+shuzi+"Span";
						var input02="sapDesc01_"+shuzi;
						var input03="con01_"+shuzi;
						var vTb=$("#chind01");
						var temp = "<td><input type='checkbox' name='cbox1'></td><td><%=SystemEnv.getHtmlLabelName(28247,user.getLanguage())%></td>";
						temp += "<td style='padding-top:6px;'><span><button type='button' class='e8_browflow' onclick=addOneFieldObj(1,"+shuzi+")></button></span>";
						temp += "<span id='"+input01Span+"' style='vertical-align: middle;width:7px;'><img src='/images/BacoError_wev8.gif' align='center'></span>";
						temp += "<span style='vertical-align: middle;'><input type='text' name='"+input01+"' style='border:1px solid #D4E9E9;height:28px;' onchange='javascript:sapFieldChange(1,this)'></span>";
						temp += "</td><td><%=SystemEnv.getHtmlLabelName(30708,user.getLanguage())%></td><td style='padding-top:5px;'><input type='text' name='"+input02+"' style='border:1px solid #D4E9E9;width:185px;height:28px;'></td>";
						temp += "<td><%=SystemEnv.getHtmlLabelName(453,user.getLanguage())%></td><td style='padding-top:5px;'><input type='text' ";
						temp += "name='"+input03+"' style='border:1px solid #D4E9E9;width:170px;height:28px;'></td>"
						var td = $(temp);
						var row = $("<tr class='DataDark''></tr>");
						row.append(td); 
						vTb.append(row); 
						//得到表格的行数
						//var temp=$("#chind01").get(0).rows.length;
						$("#hidden01").attr("value",shuzi);
 				}else if(source=="3")
 				{
						var vTb=$("#chind01");
						var checked = $("#chind01 input[type='checkbox'][name='cbox1']:checked"); 
						if(checked.length>0){ 
							if(window.confirm("<%=SystemEnv.getHtmlLabelName(30695,user.getLanguage()) %>!")){
								$(checked).each(function(){ 
									if($(this).attr("checked")==true) 
									{ 
										$(this).parents("tr:first").remove(); 
										
									} 
								}); 
							}
						}else{
							alert("<%=SystemEnv.getHtmlLabelName(30993,user.getLanguage()) %>！");
						}
 				}
 					
 		}else if(type=="2")
 		{
 			if(source=="1")
 			{
 				    var lengthtemp = $("#hidden02").val();
					var disValue = '';
					var numSum = 1;
					if(lengthtemp>=1) {
						for(var i=1;i<=lengthtemp;i++) {
							var valuetemp = $("input[name='stru_"+i+"']").attr("value");
							if($.trim(valuetemp)== '') continue;
							if(numSum == 1) {
								disValue = valuetemp;
							}else {
								disValue += ","+valuetemp;
							}
							numSum ++;
						}
					}	
 				//var temp=window.showModalDialog("/integration/serviceReg/serviceReg_3NewParamsModeSAP.jsp?servId=<%=servId%>&poolid=<%=poolid %>&type="+type+"&disValue="+disValue,"","dialogWidth:600px;dialogHeight:600px;center:yes;scroll:yes;status:no");
					var dialog = new window.top.Dialog();
			 			dialog.currentWindow = window;
						dialog.Title = "SAP";
					    dialog.URL = "/integration/serviceReg/serviceReg_3NewParamsModeSAP.jsp?servId=<%=servId%>&poolid=<%=poolid %>&type="+type+"&disValue="+disValue;
						dialog.Width = 660;
						dialog.Height = 660;
						dialog.Drag = true;
						dialog.callbackfun=addBathFieldObjCallBack2;
				 		dialog.callbackfunParam={type:type,source:source,stuname:stuname,chtable:chtable};
						dialog.textAlign = "center";
						dialog.show();
					
 			}else if(source=="2")
 			{
 				var chtable=parseInt($("#hidden02").val())+1;
				var shuzi=parseInt(chtable)+1;
				var newname="cbox2"+"_"+chtable;
				var newtable="sap_02"+"_"+chtable;
				var newstru="stru_"+chtable;
				var newstruSpan="stru_"+chtable+"span";
				var bath="bath2_"+chtable;
				var addFieldBtn = "addstru_"+chtable;
				var delFieldBtn = "delstru_"+chtable;
				var row = $("<tr class='DataDark'><td class='tdcenter'><input type='checkbox' name='cbox2'></td>"); 	
				var temp = "<td style='padding-top:0px;padding-bottom:0px;'><table   cellspacing=1 style='width:100%;margin-top:0px;margin-bottom:0px;padding-top:0;padding-bottom:0;'><tr class='DataDark'><td style='width:50px;vertical-align: middle;'><%=SystemEnv.getHtmlLabelName(30609,user.getLanguage()) %></td><td style='width:220px;'><button type='button' class='e8_browflow' "; 
				    temp += " style='vertical-align: middle;' onclick=addOneFieldObj(2,"+chtable+",'"+newstru+"')></button>"; 
				    temp += "<span id='"+newstruSpan+"' style='vertical-align: middle;width:12px;'><img src='/images/BacoError_wev8.gif'"; 
				    temp += " align=absMiddle></span> <span><input type='text' name='"+newstru+"' id='"+newstru+"' onchange='javascript:sapFieldChange(2,this)'  style='width:180px;height:28px;border:1px solid #D4E9E9;vertical-align: middle;' ></span>";
				    temp += " </td><td>"; 
				    temp += " <input type='hidden' id='"+newname+"' name='"+newname+"' value='0'></td></tr></table>";
				    temp += " <TABLE class=ListStyle style='margin-top:0px;' cellspacing=1 id='"+newtable+"'>";
				    temp += "  <tr class=header><td style='width:100px;'><input type='checkbox'"; 
				    temp += " onclick='checkbox2(this,"+chtable+")'/><%=SystemEnv.getHtmlLabelName(556,user.getLanguage())%></td>";
				    temp += " <td colspan='7' style='text-align:right;'>";
				    temp += " <input type='button'  class='addbtnB' id='"+bath+"'  onclick=addBathFieldObj(3,1,'"+newstru+"','"+chtable+"') disabled='disabled' title=<%=SystemEnv.getHtmlLabelName(25055,user.getLanguage())%>'>"; 
				    temp += " <input type='button' class='addbtn' id='"+addFieldBtn+"' "; 
				    temp += " onclick=addBathFieldObj(3,2,'"+newstru+"','"+chtable+"') disabled='disabled' title='<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>'>";
				    temp += " <input type='button' class='delbtn' id='"+delFieldBtn+"' "; 
				    temp += " onclick=addBathFieldObj(3,3,'"+newstru+"','"+chtable+"') disabled='disabled' title='<%=SystemEnv.getHtmlLabelName(23777,user.getLanguage())%>'>";
				    temp += " </TD></TR></TABLE>";
					row.append(temp);
					
					row.append("</td></tr>");
					var vTb=$("#sap_02");
					vTb.append(row); 
					//得到表格的行数
					//var temp=$("#chind02").get(0).rows.length;
					$("#hidden02").attr("value",chtable);
 			}else if(source=="3")
 			{
 					var vTb=$("#sap_02");
					var checked = $("#sap_02 input[type='checkbox'][name='cbox2']:checked"); 
					if(checked.length>0){ 
							if(window.confirm("<%=SystemEnv.getHtmlLabelName(30695,user.getLanguage()) %>!")){
								$(checked).each(function(){ 
									if($(this).attr("checked")==true) 
									{ 
										$(this).parents("tr:first").remove(); 
									} 
								}); 
							}
				}else{
							alert("<%=SystemEnv.getHtmlLabelName(30993,user.getLanguage()) %>！");
						}
 			}
 		}else if(type=="3")
 		{
 			if(source=="1")
 			{
 				
 				var stuortablevalue=$("#"+stuname).val();
 				var lengthtemp = $("#cbox2"+"_"+chtable).val();
				var disValue = '';
				var numSum = 1;
				if(lengthtemp>=1) {
					for(var i=1;i<=lengthtemp;i++) {
						var valuetemp = $("input[name='sap02_"+chtable+"_"+i+"']").attr("value");
						if($.trim(valuetemp)== '') continue;
						if(numSum == 1) {
							disValue = valuetemp;
						}else {
							disValue += ","+valuetemp;
						}
						numSum ++;
					}
				}	
				
 				if(stuortablevalue == ''){
 					alert("<%=SystemEnv.getHtmlLabelName(30715,user.getLanguage()) %>！");
 					return;
 				}
 				//var temp=window.showModalDialog("/integration/serviceReg/serviceReg_3NewParamsModeSAP.jsp?servId=<%=servId%>&poolid=<%=poolid %>&type="+type+"&disValue="+disValue+"&stuortablevalue="+stuortablevalue,"","dialogWidth:600px;dialogHeight:600px;center:yes;scroll:yes;status:no");
				var dialog = new window.top.Dialog();
			 			dialog.currentWindow = window;
						dialog.Title = "SAP";
					    dialog.URL = "/integration/serviceReg/serviceReg_3NewParamsModeSAP.jsp?servId=<%=servId%>&poolid=<%=poolid %>&type="+type+"&disValue="+disValue+"&stuortablevalue="+stuortablevalue;
						dialog.Width = 660;
						dialog.Height = 660;
						dialog.Drag = true;
						dialog.callbackfun=addBathFieldObjCallBack3;
				 		dialog.callbackfunParam={type:type,source:source,stuname:stuname,chtable:chtable};
						dialog.textAlign = "center";
						dialog.show();
					
				
 			}else if(source=="2")
 			{
 				 		//得到子表的对象
					 		var newtable=$("#sap_02"+"_"+chtable);
					 		var newchtable=parseInt($("#cbox2"+"_"+chtable).val())+1;
					 		var input01="sap02_"+chtable+"_"+newchtable;
							var input03="con02_"+chtable+"_"+newchtable;
							var input01Desc = "sapDesc02_"+chtable+"_"+newchtable;
							var input01Span="sap02_"+chtable+"_"+newchtable+"span";
							var numstemp = chtable+"_"+newchtable;
							var temp = "";
							temp += "<tr class='DataDark'><td><input type='checkbox' name='zibox'></td><td style='width:90px;vertical-align: middle;'><%=SystemEnv.getHtmlLabelName(28247,user.getLanguage())%></td><td style='width:208px;padding-top: 6px;padding-bottom:6px;'>";
							temp += "<button type='button' style='vertical-align: middle;' class='e8_browflow'";
							temp += " onclick=addOneFieldObj(3,'"+numstemp+"','"+stuname+"')></button>";
							temp += "<span id='"+input01Span+"' style='vertical-align: middle;width:7px;'><img src='/images/BacoError_wev8.gif' align='center'></span>";
							temp += "<input type='text' name='"+input01+"'";  
							temp += " value='' onchange='javascript:sapFieldChange(3,this)' style='vertical-align: middle;border:1px solid #D4E9E9;height:28px;'>";
							temp += "</td><td style='width:90px;vertical-align: middle;'><%=SystemEnv.getHtmlLabelName(30708,user.getLanguage())%></td><td style='width:180px;padding-top: 5px;padding-bottom:5px;'>"; 
							temp += "<input type='text' name='"+input01Desc+"'";  
							temp += " value='' style='vertical-align: middle;border:1px solid #D4E9E9;height:28px;'>";
							temp += "</td><td style='width:80px;vertical-align: middle;'><%=SystemEnv.getHtmlLabelName(453,user.getLanguage())%></td>";
							temp += "<td style='padding-top:5px;padding-bottom:5px;'><input type='text' name='"+input03+"' style='border:1px solid #D4E9E9;height:28px;'></td></tr>";
					 		newtable.append($(temp)); 
					 		$("#cbox2"+"_"+chtable).attr("value",newchtable);
 			}else if(source=="3")
 			{
 				 		var checked = $("#sap_02"+"_"+chtable+" input[type='checkbox'][name='zibox']:checked");
 				 		if(checked.length>0){ 
							if(window.confirm("<%=SystemEnv.getHtmlLabelName(30695,user.getLanguage()) %>!")){ 
									$(checked).each(function(){ 
										if($(this).attr("checked")==true) 
										{ 
											$(this).parents("tr:first").remove(); 
										} 
									}); 
								}
						}else{
							alert("<%=SystemEnv.getHtmlLabelName(30993,user.getLanguage()) %>！");
						}
 			}
 		}else if(type=="4")
 		{
 			if(source=="1")
 			{
 				
 				var lengthtemp = $("#hidden03").val();
					var disValue = '';
					var numSum = 1;
					if(lengthtemp>=1) {
						for(var i=1;i<=lengthtemp;i++) {
							var valuetemp = $("input[name='sap03_"+i+"']").attr("value");
							if($.trim(valuetemp)== '') continue;
							if(numSum == 1) {
								disValue = valuetemp;
							}else {
								disValue += ","+valuetemp;
							}
							numSum ++;
						}
					}
					//var temp=window.showModalDialog(","","dialogWidth:600px;dialogHeight:600px;center:yes;scroll:yes;status:no");
				var dialog = new window.top.Dialog();
			 			dialog.currentWindow = window;
						dialog.Title = "SAP";
					    dialog.URL = "/integration/serviceReg/serviceReg_3NewParamsModeSAP.jsp?servId=<%=servId%>&poolid=<%=poolid %>&type="+type+"&disValue="+disValue;
						dialog.Width = 660;
						dialog.Height = 660;
						dialog.Drag = true;
						dialog.callbackfun=addBathFieldObjCallBack4;
				 		dialog.callbackfunParam={type:type,source:source,stuname:stuname,chtable:chtable};
						dialog.textAlign = "center";
						dialog.show();
				
				
 			}else if(source=="2")
 			{
 				
 					var shuzi=parseInt($("#hidden03").val())+1;
					var input01="sap03_"+shuzi;
					var input01Span="sap03_"+shuzi+"span";
					var input02="sapDesc03_"+shuzi;//显示名--文本框
					
					//var input04Span="setoa_"+shuzi+"span";
					var vTb=$("#chind03");
					var temp = "<td><input type='checkbox' name='cbox3'></td><td><%=SystemEnv.getHtmlLabelName(28247,user.getLanguage())%></td>";
					temp += "<td style='padding-top:6px;'><span><button type='button' class='e8_browflow' onclick=addOneFieldObj(4,"+shuzi+")></button></span>";
					temp += "<span id='"+input01Span+"' style='vertical-align: middle;width:7px;'><img src='/images/BacoError_wev8.gif' align='center'></span>";
					temp += "<span style='vertical-align: middle;'><input type='text' name='"+input01+"' value='' style='border:1px solid #D4E9E9;height:28px;' onchange='javascript:sapFieldChange(4,this)'></span>";
					temp += "</td><td><%=SystemEnv.getHtmlLabelName(30708,user.getLanguage())%></td><td style='padding-top:5px;'><input type='text' name='"+input02+"' style='border:1px solid #D4E9E9;width:185px;height:28px;' value=''></td>";
					var td = $(temp);
					var row = $("<tr style='height:40px;'></tr>");
					row.append(td); 
					vTb.append(row); 
					//得到表格的行数
					//var temp=$("#chind03").get(0).rows.length;
					$("#hidden03").attr("value",shuzi);
 			}else if(source=="3")
 			{
 					var vTb=$("#chind03");
					var checked = $("#chind03 input[type='checkbox'][name='cbox3']:checked"); 
					if(checked.length>0){ 
							if(window.confirm("<%=SystemEnv.getHtmlLabelName(30695,user.getLanguage()) %>!")){
								$(checked).each(function(){ 
									if($(this).attr("checked")==true) 
									{ 
										$(this).parents("tr:first").remove(); 
									} 
								}); 
						}
					}else{
							alert("<%=SystemEnv.getHtmlLabelName(30993,user.getLanguage()) %>！");
						}
 			}
 		}else if(type=="5")
 		{
 			if(source=="1")
 			{
 				 var lengthtemp = $("#hidden04").val();
					var disValue = '';
					var numSum = 1;
					if(lengthtemp>=1) {
						for(var i=1;i<=lengthtemp;i++) {
							var valuetemp = $("input[name='outstru_"+i+"']").attr("value");
							if($.trim(valuetemp)== '') continue;
							if(numSum == 1) {
								disValue = valuetemp;
							}else {
								disValue += ","+valuetemp;
							}
							numSum ++;
						}
					}	
				//var temp=window.showModalDialog(","","dialogWidth:600px;dialogHeight:600px;center:yes;scroll:yes;status:no");
				var dialog = new window.top.Dialog();
			 			dialog.currentWindow = window;
						dialog.Title = "SAP";
					    dialog.URL = "/integration/serviceReg/serviceReg_3NewParamsModeSAP.jsp?servId=<%=servId%>&poolid=<%=poolid %>&type="+type+"&disValue="+disValue;
						dialog.Width = 660;
						dialog.Height = 660;
						dialog.Drag = true;
						dialog.callbackfun=addBathFieldObjCallBack5;
				 		dialog.callbackfunParam={type:type,source:source,stuname:stuname,chtable:chtable};
						dialog.textAlign = "center";
						dialog.show();
				
				
 			}else if(source=="2")
 			{
 					var chtable=parseInt($("#hidden04").val())+1;
					var newname="cbox4"+"_"+chtable;
					var newtable="sap_04"+"_"+chtable;
					var newstru="outstru_"+chtable;
					var newstruSpan="outstru_"+chtable+"span";
					var bath="bath4_"+chtable;
					var addFieldBtn = "addoutstru_"+chtable;
					var delFieldBtn = "deloutstru_"+chtable;
					var row = $("<tr class='DataDark'><td class='tdcenter'><input type='checkbox' name='cbox4'></td>"); 	
					var temp = "<td style='padding-top:0px;padding-bottom:0px;'><table   cellspacing=1 style='width:100%;margin-top:0px;margin-bottom:0px;padding-top:0;padding-bottom:0;'><tr class='DataDark'><td style='width:50px;vertical-align: middle;'><%=SystemEnv.getHtmlLabelName(30609,user.getLanguage()) %></td><td style='width:220px;'><button type='button' class='e8_browflow' "; 
					temp += " style='vertical-align: middle;' onclick=addOneFieldObj(5,"+chtable+",'"+newstru+"')></button>"; 
					temp += "<span id='"+newstruSpan+"' style='vertical-align: middle;width:12px;'><img src='/images/BacoError_wev8.gif'"; 
					temp += " align=absMiddle></span> <span><input type='text' name='"+newstru+"' id='"+newstru+"' onchange='javascript:sapFieldChange(5,this)'  style='width:180px;height:28px;border:1px solid #D4E9E9;vertical-align: middle;' ></span>";
					temp += " </td><td>"; 
					temp += " <input type='hidden' id='"+newname+"' name='"+newname+"' value='0'></td></tr></table>";
					temp += " <TABLE class=ListStyle style='margin-top:0px;width:100%;' cellspacing=1 id='"+newtable+"'>";
					temp += "  <tr class=header><td style='width:100px;'><input type='checkbox'"; 
					temp += " onclick='checkbox4(this,"+chtable+")'/><%=SystemEnv.getHtmlLabelName(556,user.getLanguage())%></td>";
					temp += " <td colspan='4' style='text-align:right;'>";
					temp += " <input type='button'  class='addbtnB' id='"+bath+"'  onclick=addBathFieldObj(6,1,'"+newstru+"','"+chtable+"') disabled='disabled' title='<%=SystemEnv.getHtmlLabelName(25055,user.getLanguage())%>'>"; 
					temp += " <input type='button' class='addbtn' id='"+addFieldBtn+"' "; 
					temp += " onclick=addBathFieldObj(6,2,'"+newstru+"','"+chtable+"') disabled='disabled' title='<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>'>";
					temp += " <input type='button' class='delbtn' id='"+delFieldBtn+"' "; 
					temp += " onclick=addBathFieldObj(6,3,'"+newstru+"','"+chtable+"') disabled='disabled' title='<%=SystemEnv.getHtmlLabelName(23777,user.getLanguage())%>'>";
					temp += " </TD></TR></TABLE>";
					row.append(temp);
					row.append("</td></tr>");
					var vTb=$("#sap_04");
					vTb.append(row); 
						//var shuzi=parseInt(chtable)+1;
						//得到表格的行数
						$("#hidden04").attr("value",chtable);
 			}else if(source=="3")
 			{
 					var vTb=$("#sap_04");
					var checked = $("#sap_04 input[type='checkbox'][name='cbox4']:checked"); 
					if(checked.length>0){ 
					if(window.confirm("<%=SystemEnv.getHtmlLabelName(30695,user.getLanguage()) %>!")){
						$(checked).each(function(){ 
							if($(this).attr("checked")==true) 
							{ 
								$(this).parents("tr:first").remove(); 
							} 
						}); 
					}
					}else{
							alert("<%=SystemEnv.getHtmlLabelName(30993,user.getLanguage()) %>！");
						}
 			}
 		}else if(type=="6")
 		{
 			if(source=="1")
 			{
 					//alert("输出结构"+$("#"+stuname).val());
 					var stuortablevalue=$("#"+stuname).val();
 					var lengthtemp = $("#cbox4"+"_"+chtable).val();
 					var disValue = '';
 					var numSum = 1;
 					if(lengthtemp>=1) {
 					for(var i=1;i<=lengthtemp;i++) {
 						var valuetemp = $("input[name='sap04_"+chtable+"_"+i+"']").attr("value");
 						if($.trim(valuetemp)== '') continue;
 						if(numSum == 1) {
 							disValue = valuetemp;
 						}else {
 							disValue += ","+valuetemp;
 						}
 						numSum ++;
 					}
 					}	

 					if(stuortablevalue == ''){
 					alert("<%=SystemEnv.getHtmlLabelName(30715,user.getLanguage()) %>！");
 					return;
 					}
 					
 					//var temp=window.showModalDialog(","","dialogWidth:600px;dialogHeight:600px;center:yes;scroll:yes;status:no");
					var dialog = new window.top.Dialog();
			 			dialog.currentWindow = window;
						dialog.Title = "SAP";
					    dialog.URL = "/integration/serviceReg/serviceReg_3NewParamsModeSAP.jsp?servId=<%=servId%>&poolid=<%=poolid %>&type="+type+"&disValue="+disValue+"&stuortablevalue="+stuortablevalue;
						dialog.Width = 660;
						dialog.Height = 660;
						dialog.Drag = true;
						dialog.callbackfun=addBathFieldObjCallBack6;
				 		dialog.callbackfunParam={type:type,source:source,stuname:stuname,chtable:chtable};
						dialog.textAlign = "center";
						dialog.show();
					
					
					
 			}else if(source=="2")
 			{	
 			
 			
 					//得到子表的id
			 		var newtable=$("#sap_04"+"_"+chtable);
			 		var newchtable=parseInt($("#cbox4"+"_"+chtable).val())+1;
			 		var input01="sap04_"+chtable+"_"+newchtable;
			 		var input01Span="sap04_"+chtable+"_"+newchtable+"span";
			 		var input01Desc = "sapDesc04_"+chtable+"_"+newchtable;
					var numstemp = chtable+"_"+newchtable;
					var temp = "";
					temp += "<tr class='DataDark'><td style='width:100px;'><input type='checkbox' name='zibox'></td><td style='width:90px;vertical-align: middle;'><%=SystemEnv.getHtmlLabelName(28247,user.getLanguage())%></td><td style='width:208px;padding-top: 6px;padding-bottom:6px;'>";
					temp += "<button type='button' style='vertical-align: middle;' class='e8_browflow'";
					temp += " onclick=addOneFieldObj(6,'"+numstemp+"','"+stuname+"')></button>";
					temp += "<span id='"+input01Span+"' style='vertical-align: middle;width:7px;'><img src='/images/BacoError_wev8.gif' align='center'></span>";
					temp += "<input type='text' name='"+input01+"'";  
					temp += " value='' onchange='javascript:sapFieldChange(6,this)' style='vertical-align: middle;border:1px solid #D4E9E9;height:28px;'>";
					temp += "</td><td style='width:90px;vertical-align: middle;'><%=SystemEnv.getHtmlLabelName(30708,user.getLanguage())%></td><td style='padding-top: 5px;padding-bottom:5px;'>"; 
					temp += "<input type='text' name='"+input01Desc+"'";  
					temp += " value='' style='vertical-align: middle;border:1px solid #D4E9E9;height:28px;'>";
					temp += "</td></tr>";
					newtable.append($(temp)); 
			 		$("#cbox4"+"_"+chtable).attr("value",newchtable);
 			}else if(source=="3")
 			{
 				var checked = $("#sap_04"+"_"+chtable+" input[type='checkbox'][name='zibox']:checked");
 				if(checked.length>0){ 
					if(window.confirm("<%=SystemEnv.getHtmlLabelName(30695,user.getLanguage()) %>!")){
								$(checked).each(function(){ 
									if($(this).attr("checked")==true) 
									{ 
										$(this).parents("tr:first").remove(); 
									} 
								}); 
					}
				}else{
							alert("<%=SystemEnv.getHtmlLabelName(30993,user.getLanguage()) %>！");
						}
 			}
 		}else if(type=="7")
 		{
 			if(source=="1")
 			{
 				
 				 var lengthtemp = $("#hidden05").val();
					var disValue = '';
					var numSum = 1;
					if(lengthtemp>=1) {
						for(var i=1;i<=lengthtemp;i++) {
							var valuetemp = $("input[name='outtable_"+i+"']").attr("value");
							if($.trim(valuetemp)== '') continue;
							if(numSum == 1) {
								disValue = valuetemp;
							}else {
								disValue += ","+valuetemp;
							}
							numSum ++;
						}
					}	
				//var temp=window.showModalDialog(","","dialogWidth:600px;dialogHeight:600px;center:yes;scroll:yes;status:no");
				
				var dialog = new window.top.Dialog();
			 			dialog.currentWindow = window;
						dialog.Title = "SAP";
					    dialog.URL = "/integration/serviceReg/serviceReg_3NewParamsModeSAP.jsp?&servId=<%=servId%>&poolid=<%=poolid %>&type=7&disValue="+disValue;
						dialog.Width = 660;
						dialog.Height = 660;
						dialog.Drag = true;
						dialog.callbackfun=addBathFieldObjCallBack7;
				 		dialog.callbackfunParam={type:type,source:source,stuname:stuname,chtable:chtable};
						dialog.textAlign = "center";
						dialog.show();
						
				
			
 			}else if(source=="2")
 			{
 					var chtable=parseInt($("#hidden05").val())+1;
					var newname="cbox5"+"_"+chtable;
					var newtable="sap_05"+"_"+chtable;
					var newstru="outtable_"+chtable;
					var newstruSpan="outtable_"+chtable+"span";
					var bath="bath5_"+chtable;
					var addFieldBtn = "addouttable_"+chtable;
					var delFieldBtn = "delouttable_"+chtable;
					var row = $("<tr class='DataDark'><td class='tdcenter'><input type='checkbox' name='cbox5'></td>"); 	
					var temp = "<td style='padding-top:0px;padding-bottom:0px;'><table   cellspacing=1 style='width:100%;margin-top:0px;margin-bottom:0px;padding-top:0;padding-bottom:0;'><tr class='DataDark'><td style='width:50px;vertical-align: middle;'>表名</td><td style='width:220px;'><button type='button' class='e8_browflow' "; 
					temp += " style='vertical-align: middle;' onclick=addOneFieldObj(7,"+chtable+",'"+newstru+"')></button>"; 
					temp += "<span id='"+newstruSpan+"' style='vertical-align: middle;width:12px;'><img src='/images/BacoError_wev8.gif'"; 
					temp += " align=absMiddle></span> <span><input type='text' name='"+newstru+"' id='"+newstru+"' onchange='javascript:sapFieldChange(7,this)'  style='width:180px;height:28px;border:1px solid #D4E9E9;vertical-align: middle;' ></span>";
					temp += " </td><td>"; 
					temp += " <input type='hidden' id='"+newname+"' name='"+newname+"' value='0'></td></tr></table>";
					temp += " <TABLE class=ListStyle style='margin-top:0px;width:100%;' cellspacing=1 id='"+newtable+"'>";
					temp += "  <tr class=header><td style='width:100px;'><input type='checkbox'"; 
					temp += " onclick='checkbox5(this,"+chtable+")'/><%=SystemEnv.getHtmlLabelName(556,user.getLanguage())%></td>";
					temp += " <td colspan='4' style='text-align:right;'>";
					temp += " <input type='button'  class='addbtnB' id='"+bath+"'  onclick=addBathFieldObj(8,1,'"+newstru+"','"+chtable+"') disabled='disabled' title='<%=SystemEnv.getHtmlLabelName(25055,user.getLanguage())%>'>"; 
					temp += " <input type='button' class='addbtn' id='"+addFieldBtn+"' "; 
					temp += " onclick=addBathFieldObj(8,2,'"+newstru+"','"+chtable+"') disabled='disabled' title='<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>'>";
					temp += " <input type='button' class='delbtn' id='"+delFieldBtn+"' "; 
					temp += " onclick=addBathFieldObj(8,3,'"+newstru+"','"+chtable+"') disabled='disabled' title='<%=SystemEnv.getHtmlLabelName(23777,user.getLanguage())%>'>";
					temp += " </TD></TR></TABLE>";	
					row.append(temp);
					row.append("</td></tr>");
					var vTb=$("#sap_05");
					vTb.append(row);  
						//var shuzi=parseInt(chtable)+1;
						//得到表格的行数
						$("#hidden05").attr("value",chtable);
 			}else if(source=="3")
 			{
 					var vTb=$("#sap_05");
					var checked = $("#sap_05 input[type='checkbox'][name='cbox5']:checked"); 
						if(checked.length>0){ 
							if(window.confirm("<%=SystemEnv.getHtmlLabelName(30695,user.getLanguage()) %>!")){
							$(checked).each(function(){ 
								if($(this).attr("checked")==true) 
								{ 
									$(this).parents("tr:first").remove(); 
								} 
							}); 
						}
					}else{
							alert("<%=SystemEnv.getHtmlLabelName(30993,user.getLanguage()) %>！");
				}
 			}
 		}else if(type=="8")
 		{
 			if(source=="1")
 			{
 				//alert("输出表里面的输出参数"+($("#"+stuname).val()_);
 				var stuortablevalue=$("#"+stuname).val();
					var lengthtemp = $("#cbox5"+"_"+chtable).val();
					var disValue = '';
					var numSum = 1;
					if(lengthtemp>=1) {
					for(var i=1;i<=lengthtemp;i++) {
						var valuetemp = $("input[name='sap05_"+chtable+"_"+i+"']").attr("value");
						if($.trim(valuetemp)== '') continue;
						if(numSum == 1) {
							disValue = valuetemp;
						}else {
							disValue += ","+valuetemp;
						}
						numSum ++;
					}
					}	

					if(stuortablevalue == ''){
					alert("<%=SystemEnv.getHtmlLabelName(30715,user.getLanguage()) %>！");
					return;
					}
					
					//var temp=window.showModalDialog(","","dialogWidth:600px;dialogHeight:600px;center:yes;scroll:yes;status:no");
				
				var dialog = new window.top.Dialog();
			 			dialog.currentWindow = window;
						dialog.Title = "SAP";
					    dialog.URL = "/integration/serviceReg/serviceReg_3NewParamsModeSAP.jsp?servId=<%=servId%>&poolid=<%=poolid %>&type="+type+"&disValue="+disValue+"&stuortablevalue="+stuortablevalue;
						dialog.Width = 660;
						dialog.Height = 660;
						dialog.Drag = true;
						dialog.callbackfun=addBathFieldObjCallBack8;
				 		dialog.callbackfunParam={type:type,source:source,stuname:stuname,chtable:chtable};
						dialog.textAlign = "center";
						dialog.show();
				
 			}else if(source=="2") {
 				//得到子表的id
		 		var newtable=$("#sap_05"+"_"+chtable);
		 		var newchtable=parseInt($("#cbox5"+"_"+chtable).val())+1;
		 		var input01="sap05_"+chtable+"_"+newchtable;
		 		var input01Span="sap05_"+chtable+"_"+newchtable+"span";
		 		var input01Desc = "sapDesc05_"+chtable+"_"+newchtable;
				var numstemp = chtable+"_"+newchtable;
				
				var temp = "";
				temp += "<tr class='DataDark'><td style='width:100px;'><input type='checkbox' name='zibox'></td><td style='width:90px;vertical-align: middle;'><%=SystemEnv.getHtmlLabelName(28247,user.getLanguage())%></td><td style='width:208px;padding-top: 6px;padding-bottom:6px;'>";
				temp += "<button type='button' style='vertical-align: middle;' class='e8_browflow'";
				temp += " onclick=addOneFieldObj(8,'"+numstemp+"','"+stuname+"')></button>";
				temp += "<span id='"+input01Span+"' style='vertical-align: middle;width:7px;'><img src='/images/BacoError_wev8.gif' align='center'></span>";
				temp += "<input type='text' name='"+input01+"'";  
				temp += " value='' onchange='javascript:sapFieldChange(8,this)' style='vertical-align: middle;border:1px solid #D4E9E9;height:28px;'>";
				temp += "</td><td style='width:90px;vertical-align: middle;'><%=SystemEnv.getHtmlLabelName(30708,user.getLanguage())%></td><td style='padding-top: 5px;padding-bottom:5px;'>"; 
				temp += "<input type='text' name='"+input01Desc+"'";  
				temp += " value='' style='vertical-align: middle;border:1px solid #D4E9E9;height:28px;'>";
				temp += "</td></tr>";
				newtable.append($(temp)); 
		 		$("#cbox5"+"_"+chtable).attr("value",newchtable);
 			}
 			else if(source=="3")
 			{
 				 		var checked = $("#sap_05"+"_"+chtable+" input[type='checkbox'][name='zibox']:checked");
				 		if(checked.length>0){ 
						if(window.confirm("<%=SystemEnv.getHtmlLabelName(30695,user.getLanguage()) %>!")){
									$(checked).each(function(){ 
										if($(this).attr("checked")==true) 
										{ 
											$(this).parents("tr:first").remove(); 
										} 
									}); 
						}
						}else{
							alert("<%=SystemEnv.getHtmlLabelName(30993,user.getLanguage()) %>！");
						}
 			}
 		}else if(type=="10")
 		{
 			if(source=="1")
 			{
 				
 				 var lengthtemp = $("#hidden07").val();
					var disValue = '';
					var numSum = 1;
					if(lengthtemp>=1) {
						for(var i=1;i<=lengthtemp;i++) {
							var valuetemp = $("input[name='outtable7_"+i+"']").attr("value");
							if($.trim(valuetemp)== '') continue;
							if(numSum == 1) {
								disValue = valuetemp;
							}else {
								disValue += ","+valuetemp;
							}
							numSum ++;
						}
					}	
 				//var temp=window.showModalDialog(","","dialogWidth:600px;dialogHeight:600px;center:yes;scroll:yes;status:no");
				var dialog = new window.top.Dialog();
			 			dialog.currentWindow = window;
						dialog.Title = "SAP";
					    dialog.URL = "/integration/serviceReg/serviceReg_3NewParamsModeSAP.jsp?servId=<%=servId%>&poolid=<%=poolid %>&type="+type+"&disValue="+disValue;
						dialog.Width = 660;
						dialog.Height = 660;
						dialog.Drag = true;
						dialog.callbackfun=addBathFieldObjCallBack10;
				 		dialog.callbackfunParam={type:type,source:source,stuname:stuname,chtable:chtable};
						dialog.textAlign = "center";
						dialog.show();
				
			
 			}else if(source=="2")
 			{
 					var chtable=parseInt($("#hidden07").val())+1;
					var newname="cbox7"+"_"+chtable;
					var newtable="sap_07"+"_"+chtable;
					var newstru="outtable7_"+chtable;
					var newstruSpan="outtable7_"+chtable+"span";
					var bath="bath7_"+chtable;
					var addFieldBtn = "addtable_"+chtable;
					var delFieldBtn = "deltable_"+chtable;
					
					var row = $("<tr class='DataDark'><td class='tdcenter'><input type='checkbox' name='cbox7'></td>"); 	
					var temp = "<td style='padding-top:0px;padding-bottom:0px;'><table   cellspacing=1 style='width:100%;margin-top:0px;margin-bottom:0px;padding-top:0;padding-bottom:0;'><tr class='DataDark'><td style='width:50px;vertical-align: middle;'>表名</td><td style='width:220px;'><button type='button' class='e8_browflow' "; 
					    temp += " style='vertical-align: middle;' onclick=addOneFieldObj(10,"+chtable+",'"+newstru+"')></button>"; 
					    temp += "<span id='"+newstruSpan+"' style='vertical-align: middle;width:12px;'><img src='/images/BacoError_wev8.gif'"; 
					    temp += " align=absMiddle></span> <span><input type='text' name='"+newstru+"' id='"+newstru+"' onchange='javascript:sapFieldChange(10,this)'  style='width:180px;height:28px;border:1px solid #D4E9E9;vertical-align: middle;' ></span>";
					    temp += " </td><td>"; 
					    temp += " <input type='hidden' id='"+newname+"' name='"+newname+"' value='0'></td></tr></table>";
					    temp += " <TABLE class=ListStyle style='margin-top:0px;' cellspacing=1 id='"+newtable+"'>";
					    temp += "  <tr class=header><td style='width:100px;'><input type='checkbox'"; 
					    temp += " onclick='checkbox7(this,"+chtable+")'/><%=SystemEnv.getHtmlLabelName(556,user.getLanguage())%></td>";
					    temp += " <td colspan='7' style='text-align:right;'>";
					    temp += " <input type='button'  class='addbtnB' id='"+bath+"'  onclick=addBathFieldObj(11,1,'"+newstru+"','"+chtable+"') disabled='disabled' title='<%=SystemEnv.getHtmlLabelName(25055,user.getLanguage())%>'>"; 
					    temp += " <input type='button' class='addbtn' id='"+addFieldBtn+"' "; 
					    temp += " onclick=addBathFieldObj(11,2,'"+newstru+"','"+chtable+"') disabled='disabled'  title='<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>'>";
					    temp += " <input type='button' class='delbtn' id='"+delFieldBtn+"' "; 
					    temp += " onclick=addBathFieldObj(11,3,'"+newstru+"','"+chtable+"') disabled='disabled'  title='<%=SystemEnv.getHtmlLabelName(23777,user.getLanguage())%>'>";
					    temp += " </TD></TR></TABLE>";
						row.append(temp);
						var vTb=$("#sap_07");
						vTb.append(row); 
						//得到表格的行数
						$("#hidden07").attr("value",chtable);
 			}else if(source=="3")
 			{
 					var vTb=$("#sap_07");
					var checked = $("#sap_07 input[type='checkbox'][name='cbox7']:checked"); 
						if(checked.length>0){ 
							if(window.confirm("<%=SystemEnv.getHtmlLabelName(30695,user.getLanguage()) %>!")){ 
						$(checked).each(function(){ 
							if($(this).attr("checked")==true) 
							{ 
								$(this).parents("tr:first").remove(); 
							} 
						}); 
					}
					}else{
							alert("<%=SystemEnv.getHtmlLabelName(30993,user.getLanguage()) %>！");
						}
 			}
 		}else if(type=="11")
 		{
 			if(source=="1")
 			{
 				
 				var stuortablevalue=$("#"+stuname).val();
 				var lengthtemp = $("#cbox7"+"_"+chtable).val();
					var disValue = '';
					var numSum = 1;
					if(lengthtemp>=1) {
					for(var i=1;i<=lengthtemp;i++) {
						var valuetemp = $("input[name='sap07_"+chtable+"_"+i+"']").attr("value");
						if($.trim(valuetemp)== '') continue;
						if(numSum == 1) {
							disValue = valuetemp;
						}else {
							disValue += ","+valuetemp;
						}
						numSum ++;
					}
					}	

					if(stuortablevalue == ''){
					alert("<%=SystemEnv.getHtmlLabelName(30721,user.getLanguage()) %>！");
					return;
					}
					//var temp=window.showModalDialog("/integration/serviceReg/serviceReg_3NewParamsModeSAP.jsp?servId=<%=servId%>&poolid=<%=poolid%>&type="+type+"&disValue="+disValue+"&stuortablevalue="+stuortablevalue,"","dialogWidth:600px;dialogHeight:600px;center:yes;scroll:yes;status:no");
				var dialog = new window.top.Dialog();
			 			dialog.currentWindow = window;
						dialog.Title = "SAP";
					    dialog.URL = "/integration/serviceReg/serviceReg_3NewParamsModeSAP.jsp?servId=<%=servId%>&poolid=<%=poolid%>&type="+type+"&disValue="+disValue+"&stuortablevalue="+stuortablevalue;
						dialog.Width = 660;
						dialog.Height = 660;
						dialog.Drag = true;
						dialog.callbackfun=addBathFieldObjCallBack11;
				 		dialog.callbackfunParam={type:type,source:source,stuname:stuname,chtable:chtable};
						dialog.textAlign = "center";
						dialog.show();
				
				
 			}else if(source=="2")
 			{
 				//得到子表的id
		 		var newtable=$("#sap_07"+"_"+chtable);
		 		var newchtable=parseInt($("#cbox7"+"_"+chtable).val())+1;
		 		var input01="sap07_"+chtable+"_"+newchtable;
		 		var input01Span="sap07_"+chtable+"_"+newchtable+"span";
				var input03="con07_"+chtable+"_"+newchtable;
				var input01Desc = "sapDesc07_"+chtable+"_"+newchtable;
				var numstemp = chtable+"_"+newchtable;
				var temp = "";
				temp += "<tr class='DataDark'><td><input type='checkbox' name='zibox'></td><td style='width:90px;vertical-align: middle;'><%=SystemEnv.getHtmlLabelName(28247,user.getLanguage())%></td><td style='width:208px;padding-top: 6px;padding-bottom:6px;'>";
				temp += "<button type='button' style='vertical-align: middle;' class='e8_browflow'";
				temp += " onclick=addOneFieldObj(11,'"+numstemp+"','"+stuname+"')></button>";
				temp += "<span id='"+input01Span+"' style='vertical-align: middle;width:7px;'><img src='/images/BacoError_wev8.gif' align='center'></span>";
				temp += "<input type='text' name='"+input01+"'";  
				temp += " value='' onchange='javascript:sapFieldChange(11,this)' style='vertical-align: middle;border:1px solid #D4E9E9;height:28px;'>";
				temp += "</td><td style='width:90px;vertical-align: middle;'><%=SystemEnv.getHtmlLabelName(30708,user.getLanguage())%></td><td style='width:180px;padding-top: 5px;padding-bottom:5px;'>"; 
				temp += "<input type='text' name='"+input01Desc+"'";  
				temp += " value='' style='vertical-align: middle;border:1px solid #D4E9E9;height:28px;'>";
				temp += "</td><td style='width:80px;vertical-align: middle;'><%=SystemEnv.getHtmlLabelName(453,user.getLanguage())%></td>";
				temp += "<td style='padding-top:5px;padding-bottom:5px;'><input type='text' name='"+input03+"' style='border:1px solid #D4E9E9;height:28px;'></td></tr>";
				newtable.append($(temp)); 
		 		$("#cbox7"+"_"+chtable).attr("value",newchtable);
 			}
 			else if(source=="3")
 			{
 				 		var checked = $("#sap_07"+"_"+chtable+" input[type='checkbox'][name='zibox']:checked");
			 			if(checked.length>0){ 
						if(window.confirm("<%=SystemEnv.getHtmlLabelName(30695,user.getLanguage()) %>!")){
							$(checked).each(function(){ 
								if($(this).attr("checked")==true) 
								{ 
									$(this).parents("tr:first").remove(); 
								} 
							}); 
						}
						}else{
							alert("<%=SystemEnv.getHtmlLabelName(30993,user.getLanguage()) %>！");
						}
 			}
 		}
 		
 		$('body').jNice();
 	}

 	function checkRequired()
 	{
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
			alert("<%=SystemEnv.getHtmlLabelName(30622,user.getLanguage()) %>!");
			return false;
		}else
		{
			return true;
		}
 	}

	</script>
</html>

