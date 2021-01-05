<%@page import="com.weaver.integration.entity.SapjarBean"%>

<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="SapUtil" class="com.weaver.integration.util.IntegratedUtil" scope="page"/>
<%@ include file="/integration/integrationinit.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<html>
<style>
<%
	String titlename = SystemEnv.getHtmlLabelName(31697,user.getLanguage());

%>
/* ----------------------------------- 表格 ----------------------------------- */
*{
	font-size: 12px;
}
div.tabledata table {
	margin-top:10px;
	border-collapse:collapse;
	border:1px solid #888;
	}

div.tabledata th {
	padding:5px 0 5px 0;
	background-color:#ccc;
	border:1px solid #888;
	}

div.tabledata td {
	vertical-align:text-top;
	padding-top:4px;
	background-color:#efefef;
	border:1px solid #aaa;
	}

div.tabledata ul, div.tabledata li {
	list-style-type:none;
	margin:0;
	padding:0;
	}

div.tabledata td em{
	color:#ff0000;
	font-weight:normal;
	}



table.dataintable {
	font-family:Arial, Helvetica, sans-serif;
	margin-top:10px;
	margin-left:20px;
	margin-right:20px;
	margin-bottom:20px;
	border-collapse:collapse;
	border:1px solid #888;
	width:(100%-40px);
	}

table.dataintable pre {
	width:auto;
	margin:0;
	padding:0;
	border:0;
	background-color:transparent;
	}

table.dataintable th {
	vertical-align:baseline;
	padding:5px 15px 5px 5px;
	background-color:#ccc;
	border:1px solid #888;
	text-align:left;
	}

table.dataintable td {
	vertical-align:text-top;
	padding:5px 15px 5px 5px;
	background-color:#efefef;
	border:1px solid #aaa;
	}


table.dataintable p {margin:0 0 2px 0;}

div#maincontent table.dataintable ul, div#maincontent table.dataintable li {
	list-style-type:none;
	margin:0;
	padding:0;
	}

table.dataintable td em{
	color:#0000ff;
	font-weight:normal;
	}
	
table.dataintable .table_value {color:#0F93D2;}

.no_wrap {white-space:nowrap;}

div#maincontent table.dataintable ul.listintable {
	margin:20px;
	padding:0;
	}

div#maincontent table.dataintable ul.listintable  li{
	list-style-type:disc;
	}
.html5_new_note span {
	color:blue;
	font-weight:bold;
	}

tr.notsupported {
	color:#999999;
	}
</style>
<body  oncontextmenu=self.event.returnValue=false  style="padding: 0px;margin: 0px">
				<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
				<%
						List list =new ArrayList();
						rs.execute("select * from sap_jarsys ");
						while(rs.next()){
							SapjarBean s=new SapjarBean();
							 String jarid=rs.getString("id");
							 String jarurl=rs.getString("jarurl");
							 String jardesc=rs.getString("jardesc");
							 String jarname=rs.getString("jarname");
							 s.setJardesc(jardesc);
							 s.setJarid(jarid);
							 s.setJarname(jarname);
							 s.setJarurl(jarurl);
							 list.add(s);
						}
						//SapjarBean
				 %>
				<div>
  				<table class="dataintable"  style="width: 94%">
  						<caption>
  							
  								
												<img alt="" src="/integration/images/jars_wev8.gif"  align="middle" style="height: 100px;width: 100px;float: left">
												<div style="float: left;padding-top: 50px">
												<font style="color: red;font-weight: bold;">SAP-JCO-2.1.10<%=SystemEnv.getHtmlLabelName(31648,user.getLanguage()) %></font>
												<br>http://www.e-cology.com.cn/
												</div>
									
  						</caption>
  						<tr class="Title">
  								<th  colspan="4">SAP-JCO-2.1.10<%=SystemEnv.getHtmlLabelName(31648,user.getLanguage()) %></th>
  						</tr>
  						<%
  								String bf="";
  								for(int i=0;i<list.size();i++){
  								if(i%4==0&&i!=0){
  									bf+="</tr>";
  									bf+="<tr>";
  								}
  								if(i==0){
  									bf+="<tr>";
  								}
  								Object obj=list.get(i);
	  								if(null!=obj){
	  									SapjarBean s=(SapjarBean)obj;
	  									if(i>8){
	  										bf+="<td>0"+(i+1)+".&nbsp;<a style=\"cursor: pointer;\" href='"+s.getJarurl()+"'>"+s.getJarname()+"</a></td>";
	  									}else{
	  										bf+="<td>00"+(i+1)+".&nbsp;<a style=\"cursor: pointer;\" href='"+s.getJarurl()+"'>"+s.getJarname()+"</a></td>";
	  									}
  									}		
  								}
  								out.println(bf);
  						 %>
  						
  					
  				</table>
  				
  					<table class="dataintable"  style="width: 94%">
  						<tr class="Title">
  								<th  colspan="3">SAP-JCO-2.1.10<%=SystemEnv.getHtmlLabelName(31648,user.getLanguage()) %>(<%=SystemEnv.getHtmlLabelName(31649,user.getLanguage()) %>)</th>
  						</tr>
  						<tr>
  								<td><a style="cursor: pointer;" href='/integration/sapjar/sapjco21P_10-20007304.zip'>Windows 32bit</a></td>
  								<td><a style="cursor: pointer;" href='/integration/sapjar/sapjco21P_10-20007305.zip'>Windows 64bit sapjco-ntamd64</a></td>
  								<td><a style="cursor: pointer;" href='/integration/sapjar/sapjco21P_10-20007306.zip'>Windows 64bit sapjco-ntia64</a></td>
  						</tr>
  						
  					</table>	
  					
  					
  					<table class="dataintable"  style="width: 94%">
  						<tr class="Title">
  								<th  colspan="4">JCO<%=SystemEnv.getHtmlLabelName(31650,user.getLanguage()) %></th>
  						</tr>
  						<tr>
  								<td colspan="4">
  													1、<%=SystemEnv.getHtmlLabelName(31651,user.getLanguage()) %>【<%=SystemEnv.getHtmlLabelName(31652,user.getLanguage()) %>&nbsp;<%=SystemEnv.getHtmlLabelName(15194,user.getLanguage()) %>:librfc32.dll、sapjcorfc.dll】【<%=SystemEnv.getHtmlLabelName(31653,user.getLanguage()) %>&nbsp;<%=SystemEnv.getHtmlLabelName(15194,user.getLanguage()) %>:sapjco.jar】。
  								</td>
  						</tr>
  						<tr>
  							<td colspan="4">
  													2、<%=SystemEnv.getHtmlLabelName(31654,user.getLanguage()) %>。
  								</td>
  						</tr>
  						<tr>
  							<td colspan="4">
  													3、<%=SystemEnv.getHtmlLabelName(31655,user.getLanguage()) %>。
  								</td>
  						</tr>
  						<tr>
  							<td colspan="4">
  													4、<%=SystemEnv.getHtmlLabelName(31656,user.getLanguage()) %><br>
  							</td>
  						</tr>
  						<tr>
  							<td  rowspan="2"  style="text-align: center;vertical-align: middle;">
  													Windows	
  							</td>
  							<td>
  													<%=SystemEnv.getHtmlLabelName(31657,user.getLanguage()) %>:&nbsp;C:/windows/system32;&nbsp;Java/jdk1.6.0_27/bin<br>
  							</td>
  								<td  rowspan="2"  style="text-align: center;vertical-align: middle;">
  													Linux
  							</td>
  							<td>
  													<%=SystemEnv.getHtmlLabelName(31657,user.getLanguage()) %>:&nbsp;Java/jdk1.6.0_27/jre/lib/amd64<br>
  							</td>
  						</tr>
  							<tr>
  							
  							<td>
  													jar<%=SystemEnv.getHtmlLabelName(31658,user.getLanguage()) %>:&nbsp;ecology/web-inf/lib
  							</td>
  							
  							<td>
  													jar<%=SystemEnv.getHtmlLabelName(31658,user.getLanguage()) %>:&nbsp;ecology/web-inf/lib
  							</td>
  						</tr>
  					</table>	
  					
  					<table class="dataintable"  style="width: 94%">
  						<tr class="Title">
  								<th  colspan="3">JCO<%=SystemEnv.getHtmlLabelName(31659,user.getLanguage()) %></th>
  						</tr>
  						<tr>
  								<td  colspan="3">
  										001、<%=SystemEnv.getHtmlLabelName(31660,user.getLanguage()) %>
  								</td>
  						</tr>
  						<tr>
  								<td  colspan="3">
  										<%=SystemEnv.getHtmlLabelName(31661,user.getLanguage()) %>
  								</td>
  						</tr>
  						<tr>
  								<td  colspan="3">
  											<img src="/integration/images/001_wev8.png" >
  								</td>
  						</tr>
  						<tr>
  								<td  colspan="3">
  										002、<%=SystemEnv.getHtmlLabelName(31662,user.getLanguage()) %>
  								</td>
  						</tr>
  						<tr>
  								<td  colspan="3">
  										<%=SystemEnv.getHtmlLabelName(31663,user.getLanguage()) %>
  								</td>
  						</tr>
  						<tr>
  								<td  colspan="3">
  											<img src="/integration/images/002_wev8.png" >
  								</td>
  						</tr>
  						<tr>
  								<td  colspan="3">
  										003、<%=SystemEnv.getHtmlLabelName(31664,user.getLanguage()) %>
  								</td>
  						</tr>
  						<tr>
  								<td  colspan="3">
  										<%=SystemEnv.getHtmlLabelName(31665,user.getLanguage()) %>
  								</td>
  						</tr>
  						<tr>
  								<td  colspan="3">
  											<img src="/integration/images/003_wev8.png" >
  								</td>
  						</tr>
  						<tr>
  								<td  colspan="3">
  										004、<%=SystemEnv.getHtmlLabelName(31666,user.getLanguage()) %>
  								</td>
  						</tr>
  						<tr>
  								<td  colspan="3">
  										<%=SystemEnv.getHtmlLabelName(31667,user.getLanguage()) %>
  								</td>
  						</tr>
  						<tr>
  								<td  colspan="3">
  											<img src="/integration/images/004_wev8.png" >
  								</td>
  						</tr>
  						<tr>
  								<td  colspan="3">
  										005、<%=SystemEnv.getHtmlLabelName(31668,user.getLanguage()) %>
  								</td>
  						</tr>
  						<tr>
  								<td  colspan="3">
  										<%=SystemEnv.getHtmlLabelName(31669,user.getLanguage()) %>
  								</td>
  						</tr>
  						<tr>
  								<td  colspan="3">
  											<img src="/integration/images/005_wev8.png" >
  								</td>
  						</tr>
  						<tr>
  								<td  colspan="3">
  										006、<%=SystemEnv.getHtmlLabelName(31729,user.getLanguage()) %>
  								</td>
  						</tr>
  						<tr>
  								<td  colspan="3">
  										<%=SystemEnv.getHtmlLabelName(31730,user.getLanguage()) %>
  								</td>
  						</tr>
  						<tr>
  								<td  colspan="3">
  											<img src="/integration/images/006_wev8.png" >
  								</td>
  						</tr>
  					</table>	
  					
  					
  						<table class="dataintable"  style="width: 94%">
  						<tr class="Title">
  								<th  colspan="3"><%=SystemEnv.getHtmlLabelName(31670,user.getLanguage()) %></th>
  						</tr>
  						<tr>
  								<td  colspan="3">
  									<a style="cursor: pointer;" href='/integration/sapjar/JCO_API.rar'><%=SystemEnv.getHtmlLabelName(31671,user.getLanguage()) %></a>&nbsp;&nbsp;
  									<a style="cursor: pointer;" href='http://www.sap.com/china/index.epx' target="_black"><%=SystemEnv.getHtmlLabelName(31673,user.getLanguage()) %></a>&nbsp;&nbsp;
  								</td>
  						</tr>		
  					</table>	
				</div>
</body>
</html>