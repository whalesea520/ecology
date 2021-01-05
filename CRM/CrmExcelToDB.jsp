
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*"%>
<%@ page import="java.net.*"%>
<%@page import="java.io.File"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rst" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CustomerStatusComInfo" class="weaver.crm.Maint.CustomerStatusComInfo" scope="page" />
<jsp:useBean id="CrmExcelToDB" class="weaver.crm.ExcelToDB.CrmExcelToDB" scope="page" />
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo"></jsp:useBean>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script LANGUAGE="JavaScript" SRC="/js/checkinput_wev8.js"></script>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<style type="">
	#bgAlpha{  
		 display:none;
		 position: absolute;
	     top:0;
	     left: 0;
	     width: 100%;
	     height:100%;
	     -ms-filter: "progid:DXImageTransform.Microsoft.Alpha(Opacity=30)"; /*IE8*/
	     filter:alpha(opacity=30);  /*IE5、IE5.5、IE6、IE7*/
	     opacity: 0.3;  /*Opera9.0+、Firefox1.5+、Safari、Chrome*/
	     z-index: 100;  /*让其位于in的下面*/
	     background:#fff;
	}
	
	#loading{
	    position:absolute;
	    left:35%;
	    background:#ffffff;
	    top:40%;
	    padding:8px;
	    z-index:20001;
	    height:auto;
	    display:none;
	    border:1px solid #ccc;
	    font-size: 12px;
	}
</style>
</head>
<% 



File file = new File(GCONST.getRootPath()+"CRM"+File.separator+"ExcelToDB.xls");
if(!file.exists()){
	CrmExcelToDB.generateExcel();
}
String basepath = Util.getRequestHost(request);
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(18038,user.getLanguage());
String needfav ="1";
String needhelp =""; 

String success= Util.null2String(request.getParameter("success"));
String isNUllData= Util.null2String(request.getParameter("isNUllData"));
String isErrTemplate = Util.null2String(request.getParameter("isErrTemplate"));
String isErreData = Util.null2String(request.getParameter("isErreData"));
%>   
<BODY> 
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(615,user.getLanguage())+",javascript:onSave(this),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<script type='text/javascript' src='/js/WeaverTablePlugins_wev8.js'></script>


<wea:layout attributes="{layoutTableId:topTitle}">
	<wea:group context="" attributes="{groupDisplay:none}">
		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
			<span title="<%=SystemEnv.getHtmlLabelName(725,user.getLanguage())%>" style="font-size: 12px;cursor: pointer;">
				<input class="e8_btn_top middle" onclick="onSave(this)" type="button" jQuery1392950000546="32" value="<%=SystemEnv.getHtmlLabelName(615,user.getLanguage()) %>"/>
			</span>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</wea:item>
	</wea:group>
</wea:layout>


<FORM id=cms name=cms action="CrmExcelToDBOperation.jsp" method=post enctype="multipart/form-data">
<input type="hidden" name="operation" value="upload">
<wea:layout>
	<wea:group context="" attributes="{groupDisplay:none}">
		<wea:item attributes="{colspan:2}"><strong><%=SystemEnv.getHtmlLabelName(18038,user.getLanguage())%></strong></p></wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(16699,user.getLanguage())%></wea:item>
		<wea:item><input class=InputStyle  type=file size=40 name="filename" id="filename" style="width:40%"></wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(1278,user.getLanguage())%></wea:item>
		<wea:item>
			<brow:browser viewType="0" name="manager" 
				         browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
				         browserValue = '<%=String.valueOf(user.getUID()) %>'
				         browserSpanValue = '<%=user.getUsername()%>'
				         isSingle="true" hasBrowser="true"  hasInput="true" isMustInput='2'
				         completeUrl="/data.jsp" width="40%" ></brow:browser> 
		</wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></wea:item>
		<wea:item>
			<brow:browser viewType="0" name="CustomerStatus" 
				         browserUrl="/systeminfo/BrowserMain.jsp?url=/CRM/Maint/CustomerStatusBrowser.jsp"
				         browserValue = '<%=String.valueOf(1)%>'
				         browserSpanValue = '<%=CustomerStatusComInfo.getCustomerStatusname("1")%>'
				         isSingle="true" hasBrowser="true"  hasInput="true" isMustInput='2'
				         completeUrl="/data.jsp?type=customerStatus" width="40%" ></brow:browser> 
				         
				         
		</wea:item>
		
		
		<wea:item attributes="{colspan:2}"><strong><%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%></strong></p></wea:item>
		
			<wea:item attributes="{colspan:2}">
	           <p><strong><%=SystemEnv.getHtmlLabelName(28445,user.getLanguage())%>:</strong></p>
			   <div style="padding-left: 43px;">
		           <ul>
					<li><%=SystemEnv.getHtmlLabelName(28447,user.getLanguage())%><a href=ExcelToDB.xls style="color:blue !important;text-decoration: underline !important;"><%=SystemEnv.getHtmlLabelName(28446,user.getLanguage())%></a>，<span style="color:red"><%=SystemEnv.getHtmlLabelName(126071,user.getLanguage())%></span>。</li>
					<li><%=SystemEnv.getHtmlLabelName(84295,user.getLanguage())%></li>
					<li><%=SystemEnv.getHtmlLabelName(84297,user.getLanguage())%></li>
					<li><%=SystemEnv.getHtmlLabelName(84298,user.getLanguage())%></li>
					<li><%=SystemEnv.getHtmlLabelName(84300,user.getLanguage())%></li>
					<li><%=SystemEnv.getHtmlLabelName(84302,user.getLanguage())%></li>
		           </ul> 
		        </div>
			</wea:item>	
				
	  		<wea:item attributes="{colspan:2}">
	           <p><strong><%=SystemEnv.getHtmlLabelName(83397,user.getLanguage())%>:</strong></p>
				<div style="padding-left: 43px;">
					<ul>
						<li><%=SystemEnv.getHtmlLabelName(84288,user.getLanguage())%></li>
						<li><%=SystemEnv.getHtmlLabelName(84289,user.getLanguage())%></li>
						<li><%=SystemEnv.getHtmlLabelName(84290,user.getLanguage())%></li>
					</ul> 
				</div>
			</wea:item>	
		
			<wea:item attributes="{colspan:2}"><strong><%=SystemEnv.getHtmlLabelName(84303,user.getLanguage())%></strong></p></wea:item>
			
			<wea:item attributes="{colspan:2,'isTableList':'true'}">
				<wea:layout attributes="{cw1:50%,cw2:50%}">
					<wea:group context="" attributes="{groupDisplay:none}">
						<wea:item attributes="{'customAttrs':'id=msg valign=top'}">
							<font color="#FF0000">
							<p><strong><%=SystemEnv.getHtmlLabelName(18019,user.getLanguage())%></strong></p>
							<div style="padding-left: 43px;">
			                    <ul>
								<%
									rs.execute("select id, fieldlabel, fieldhtmltype , type from CRM_CustomerDefinField "+
											" where usetable = 'CRM_CustomerInfo' and isopen = 1 and fieldhtmltype <>6 and ismust = 1"+
											" and fieldname != 'status' and fieldname !='manager' ORDER BY dsporder ASC");
									while(rs.next()){
								%>
									 <li style="padding-bottom: 5px;">
									<%
										int fieldhtmltype= rs.getInt("fieldhtmltype");
										String info = SystemEnv.getHtmlLabelName(rs.getInt("fieldlabel"),user.getLanguage());
										if(1== fieldhtmltype || 2 == fieldhtmltype){
											out.print(info);
											continue;
										}
										if(3 == fieldhtmltype && 2 == rs.getInt("type")){//日期
											out.print(info);
											continue;
										}
										
										if(3 == fieldhtmltype && 2 != rs.getInt("type")){//浏览框
											String tablename = BrowserComInfo.getBrowsertablename(rs.getInt("type")+"");
											String columnname = BrowserComInfo.getBrowsercolumname(rs.getInt("type")+"");
											String sql_type="";
											if (rs.getDBType().equals("oracle")){
												sql_type="select "+columnname+" from "+tablename+" where rownum<=5";
											}else{
												sql_type="select top 5 "+columnname+" from "+tablename;
											}
											rst.execute(sql_type);
											String name = "";
											while(rst.next()){
												if(name.length()+rst.getString(1).length()>=40){
													break;
												}else{
													name+=rst.getString(1)+" , ";
												}
											}
											if(!name.equals("")){
												name = name.trim();
												name = name.substring(0,name.length()-1);
												info += "("+name+"……)";
											}
											
											out.print(info);
											continue;
										}
										if(4 == fieldhtmltype){//checkbox值
											info += "("+SystemEnv.getHtmlLabelName(82677,user.getLanguage())+" , "+SystemEnv.getHtmlLabelName(82676,user.getLanguage())+")";
											out.print(info);
											continue;
										}
										
										if(5 == fieldhtmltype){//下拉框值
											String sql_type="";
											if (rs.getDBType().equals("oracle")){
												sql_type="select selectname from crm_selectitem where rownum<=5 and fieldid = "+rs.getString("id");
											}else{
												sql_type="select top 5 selectname from crm_selectitem where fieldid = "+rs.getString("id");
											}
											rst.execute(sql_type);
											String name = "";
											while(rst.next()){
												if(name.length()+rst.getString(1).length()>=40){
													break;
												}else{
													name+=rst.getString(1)+" , ";
												}
											}
											if(!name.equals("")){
												name = name.trim();
												name = name.substring(0,name.length()-1);
												info += "("+name+"……)";
											}
											
											out.print(info);
											continue;
										}
									
									%>	 
										 <li>
									<%	
									}
									
									
									
									%>
			                    </ul>
			                  </div> 
			                  </font>
						</wea:item>
						
						<wea:item attributes="{customAttrs:'valign=top'}">
							<p><strong><%=SystemEnv.getHtmlLabelName(84305,user.getLanguage())%></strong></p>
							<div style="padding-left: 43px;">
			                    <ul>
								  <li style="padding-bottom: 10px;">
								  	<div style="background-color: red;display: inline">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</div>
								  	<span>&nbsp;<%=SystemEnv.getHtmlLabelName(84306,user.getLanguage())%></span>
								  </li>
							      <li style="padding-bottom: 10px;">
								  	<div style="background-color: #33CCCC;display: inline">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</div>
								  	<span>&nbsp;<%=SystemEnv.getHtmlLabelName(84307,user.getLanguage())%></span>
								  </li>
								  <li style="padding-bottom: 10px;">
								  	<div style="background-color: #FF9900;display: inline">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</div>
								  	<span>&nbsp;<%=SystemEnv.getHtmlLabelName(84308,user.getLanguage())%></span>
								  </li>
								  <li style="padding-bottom: 10px;">
								  	<div style="background-color: #99CC00;display: inline">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</div>
								  	<span>&nbsp;<%=SystemEnv.getHtmlLabelName(84309,user.getLanguage())%></span>
								  </li>
								  <li style="padding-bottom: 10px;">
								  	<div style="background-color: #CC99FF;display: inline">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</div>
								  	<span>&nbsp;<%=SystemEnv.getHtmlLabelName(84310,user.getLanguage())%></span>
								  </li>
								  <li style="padding-bottom: 10px;">
								  	<div style="background-color: yellow;display: inline">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</div>
								  	<span>&nbsp;<%=SystemEnv.getHtmlLabelName(84311,user.getLanguage())%></span>
								  </li>
								  <li style="padding-bottom: 10px;">
								  	<div style="background-color: #a1a3a6;display: inline">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</div>
								  	<span>&nbsp;<%=SystemEnv.getHtmlLabelName(84312,user.getLanguage())%></span>
								  </li>
								  <li style="padding-bottom: 10px;">
								  	<div style="background-color: #FF8080;display: inline">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</div>
								  	<span>&nbsp;<%=SystemEnv.getHtmlLabelName(84313,user.getLanguage())%></span>
								  </li>
			                    </ul>
			                 </div>  
						</wea:item>
					</wea:group>				
				</wea:layout>
			</wea:item>
			
	</wea:group>
</wea:layout>

<br>
</FORM>
<DIV id=bgAlpha></DIV>

<div id="loading" style="display:none;">	
		<span><img src="/images/loading2_wev8.gif" align="absmiddle"></span>
		<span  id="loading-msg" style="font-size:12"><%=SystemEnv.getHtmlLabelName(18623, user.getLanguage())%>...</span>
</div>
</body>

<iframe id="downFile" style="visibility: hidden;height: 0px;"></iframe>

<script language="javascript">

jQuery(function(){
	if("true" == "<%=isNUllData%>"){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(84314,user.getLanguage())%>");
		return;
	}
	
	if("true" == "<%=isErrTemplate%>"){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(84315,user.getLanguage())%>");
		return;
	}
	
	
	if("true" == "<%=isErreData%>"){
		window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(84316,user.getLanguage())%>",function(){
			jQuery("#downFile").attr("src","/weaver/weaver.crm.util.FileDownload");
		},function(){
			jQuery.post("/CRM/CrmExcelToDBOperation.jsp",{"operation":"deleteFile"})
		});
		return;
	}
	
	if("true" == "<%=isErrTemplate%>"){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(84315,user.getLanguage())%>");
		return;
	}
	
	if("false" == "<%=success%>"){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(33971,user.getLanguage())%>");
	}
	
	if("true" == "<%=success%>"){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(33970,user.getLanguage())%>");
	}
});

function onSave(obj){
	if(jQuery("#manager").val()=="" || jQuery("#CustomerStatus").val()==""){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(30702,user.getLanguage())%>");
		return;
	}

	if (cms.filename.value==""){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(18618,user.getLanguage())%>");
	}else{
		$("#bgAlpha").show();
		$("#loading").show();
		cms.submit();
		obj.disabled = true;
	}
}
</script>
