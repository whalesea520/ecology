<%@page import="org.json.JSONObject"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>
<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="MatrixUtil" class="weaver.matrix.MatrixUtil" scope="page" />

<%
String cversion = "";
rs.executeSql("select * from license");
if(rs.next()){
	cversion = Util.null2String(rs.getString("cversion")).trim();
}

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = "";//通用设置
String needfav ="1";
String needhelp ="";
BaseBean bb = new BaseBean();

String param = request.getParameter("param");	

String matrixSql = " select * from MatrixInfo where issystem in (1,2) ";
rs.executeSql(matrixSql);
int matrixCount = rs.getCounts();

if("2".equals(param)){
		matrixSql = " select * from MatrixInfo where issystem in (1,2) ";
		rs.executeSql(matrixSql);
		while(rs.next()){
			String id = rs.getString("id");
			String tmpMatrixTable = "matrixtable_"+id;
			String tmpSql = " drop table "+tmpMatrixTable;
			rs1.executeSql(tmpSql);
			rs1.next();
			String dataSql = " delete from matrixfieldinfo where matrixid = "+id;
			rs1.executeSql(dataSql);
			rs1.next();
		}
		String deleteMatrixInfo = " delete from MatrixInfo where issystem in (1,2) ";
		rs.executeSql(deleteMatrixInfo);
		
   	   //同步E7部门、分部自定义字段到E8部门、分部数据表
   	   String testMatrix1 = MatrixUtil.sysE7DepartAndSubcompanyToE8(); 
   	   if("1".equals(testMatrix1)){
   		   bb.writeLog("E7部门、分部自定义自动同步至E8部门、分部成功.....");
   	   }else{
   		   bb.writeLog("E7部门、分部自定义自动同步至E8部门、分部失败：");
   	   }
    	   
   	   String testMatrix2 =  MatrixUtil.sysE8SubcompanyAndDepartToMatrix();
   	   if("1".equals(testMatrix2)){
   		   bb.writeLog("部门、分部自定义自动同步至管理矩阵成功.....");
   	   }else{
   		   bb.writeLog("部门、分部自定义自动同步至管理矩阵失败：");
   	   }
}

%>
	<wea:layout type="2col">
	    <wea:group context='检查矩阵相关全局设置' attributes="{'itemAreaDisplay':'display'}">
			<wea:item>矩阵基本信息生成</wea:item>
			<wea:item>			
				<%
					if(matrixCount != 2){
				%>	
			<img src="rejected_bg_wev8.gif"  />系统矩阵生成有误 <img src="refresh.png"  title="重新生成" style="cursor: pointer;" onclick="doRefresh(2)" /><br/>	
			
				<%
					}else{
				 %>
					<img src="ok.png"  /><p style="display:inline; color: blue;" >系统矩阵已经生成</p>
					<img src="refresh.png"  title="调整设置" style="cursor: pointer;" onclick="goNew('/matrixmanage/pages/Matrix.jsp')" /><br/>
				<%	
				}
				 %>
			</wea:item>
			<wea:item>矩阵自定义数据生成情况</wea:item>
			<wea:item>如果对于矩阵数据有疑问<img src="remind_wev8.png" title="系统矩阵的自定义数据缺失或者流程操作者没有转换成矩阵" />，点这里重新生成
			<img src="refresh.png"  title="重新生成" style="cursor: pointer;" onclick="doRefresh(2)" /><br/></wea:item>
	    </wea:group>
	    
	</wea:layout>