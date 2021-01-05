
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@page import="java.util.*"%>
<%@page import="java.sql.ResultSet"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<!-- 
人力资源、多人力资源、分权人力资源、分权多人力资源、部门、多部门、分权部门、分权多部门、分部、多分部、分权分部、分权多分部、角色、多角色、角色人员 
-->
<html>
	<head>
	</head>
	<body>
		<wea:layout type="2col">
			<wea:group context='<%=SystemEnv.getHtmlLabelName(83495,user.getLanguage())%>'>
				<wea:item><%=SystemEnv.getHtmlLabelName(23189,user.getLanguage())%></wea:item>
				<wea:item>
					<brow:browser viewType="0" name="resourceid" browserValue="" 
          browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp?sqlwhere= where HrmResource.ID = 693"
          hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
          completeUrl="/data.jsp" linkUrl="javascript:openhrm($id$)" >
          </brow:browser>
				</wea:item>
				<wea:item><%=SystemEnv.getHtmlLabelName(83496,user.getLanguage())%></wea:item>
				<wea:item>
					<brow:browser viewType="0" name="mutiresourceid" browserValue="" 
          browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?selectedids="
          hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='1'
          completeUrl="/data.jsp" linkUrl="javascript:openhrm($id$)" >
          </brow:browser>
				</wea:item>
				<wea:item><%=SystemEnv.getHtmlLabelName(21479,user.getLanguage())%></wea:item>
				<wea:item>
					<brow:browser viewType="0" name="resourceidbyright" browserValue="" 
          browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowserByDec.jsp?selectedids="
          hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
          completeUrl="/data.jsp" linkUrl="javascript:openhrm($id$)" >
          </brow:browser>
				</wea:item>
				<wea:item><%=SystemEnv.getHtmlLabelName(21480,user.getLanguage())%></wea:item>
				<wea:item>
					<brow:browser viewType="0" name="multiResourceBrowserByDec" browserValue="" 
          browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MultiResourceBrowserByDec.jsp?selectedids="
          hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='1'
          completeUrl="/data.jsp" linkUrl="javascript:openhrm($id$)" >
          </brow:browser>
				</wea:item>
				<wea:item><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></wea:item>
				<wea:item>
					<brow:browser viewType="0" name="departmentBrowser" browserValue="" 
          browserUrl="/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/company/DepartmentBrowser2.jsp?isedit=1&rightStr=HrmResourceAdd:Add"
          hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='1'
          completeUrl="/data.jsp?type=4">
          </brow:browser>
				</wea:item>
				<wea:item><%=SystemEnv.getHtmlLabelName(83497,user.getLanguage())%></wea:item>
				<wea:item>
					<brow:browser viewType="0" name="MutidepartmentBrowser" browserValue="" 
          browserUrl="/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/company/MutiDepartmentBrowser.jsp?selectedids="
          hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
          completeUrl="/data.jsp?type=4" >
          </brow:browser>
				</wea:item>
				<wea:item><%=SystemEnv.getHtmlLabelName(33553,user.getLanguage())%></wea:item>
				<wea:item>
					<brow:browser viewType="0" name="departmentBrowser" browserValue="" 
          browserUrl="/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/company/SubcompanyBrowser3.jsp?isedit=1&rightStr=HrmResourceAdd:Add"
          hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='1'
          completeUrl="/data.jsp?type=4">
          </brow:browser>
				</wea:item>
				<wea:item><%=SystemEnv.getHtmlLabelName(25512,user.getLanguage())%></wea:item>
				<wea:item>
					<brow:browser viewType="0" name="MutidepartmentBrowser" browserValue="" 
          browserUrl="/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/company/MutiSubcompanyBrowser.jsp?selectedids="
          hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
          completeUrl="/data.jsp?type=4" >
          </brow:browser>
				</wea:item>
				<wea:item><%=SystemEnv.getHtmlLabelName(83498,user.getLanguage())%></wea:item>
				<wea:item>
					<brow:browser viewType="0" name="departmentBrowserDec" browserValue="" 
          browserUrl="/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/company/DepartmentBrowserByDec.jsp?selectedids="
          hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
          completeUrl="/data.jsp?type=4" >
          </brow:browser>
				</wea:item>
				<wea:item><%=SystemEnv.getHtmlLabelName(21482,user.getLanguage())%></wea:item>
				<wea:item>
					<brow:browser viewType="0" name="MutidepartmentBrowserDec" browserValue="" 
          browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/MultiDepartmentBrowserByDecOrder.jsp?selectedids="
          hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
          completeUrl="/data.jsp?type=4" >
          </brow:browser>
				</wea:item>
				<wea:item><%=SystemEnv.getHtmlLabelName(83499,user.getLanguage())%></wea:item>
				<wea:item>
					<brow:browser viewType="0" name="subcompanyBrowserByDec" browserValue="" 
          browserUrl="/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/company/SubcompanyBrowser4.jsp?selectedids="
          hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
          completeUrl="/data.jsp?type=164" >
          </brow:browser>
				</wea:item>
				<wea:item><%=SystemEnv.getHtmlLabelName(83500,user.getLanguage())%></wea:item>
				<wea:item>
					<brow:browser viewType="0" name="multiSubcompanyBrowserByDec" browserValue="" 
          browserUrl="/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/company/MultiSubcompanyBrowserByDec2.jsp?selectedids="
          hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='1'
          completeUrl="/data.jsp?type=164" >
          </brow:browser>
				</wea:item>
			</wea:group>
		</wea:layout>
	</body>
</html>
