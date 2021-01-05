<!DOCTYPE html>
<%@ page import="weaver.general.Util"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<jsp:useBean id="FieldRecord" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DataRecord" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="GetShowCondition" class="weaver.workflow.workflow.GetShowCondition" scope="page" />
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
//矩阵id
String matrixid = Util.null2String(request.getParameter("matrixid"));
//需要展示相关人员的信息
String objid = Util.null2String(request.getParameter("objid"));

String objidname = "";
if(!"".equals(objid)){
	objidname = ResourceComInfo.getLastname(objid);
}

// 是否 初始化 count 值标志。 0 是不初始化
String countinit = Util.null2String(request.getParameter("countinit"));

String method = Util.null2String(request.getParameter("method"));

boolean isOracle = FieldRecord.getDBType().equals("oracle");

int totalcount = 0;
StringBuffer backfileds = new StringBuffer();
StringBuffer wheresql = new StringBuffer();
String sql = "";
//存储字段的所有信息
List<Properties> proplist = new ArrayList<Properties>();

  //根据  matrixid olduserid 查询符合条件的记录数
  if("queryrecord".equals(method)){
	   //查询在 matrixid 矩阵中，涉及 olduserid 有多少条记录
	   //判断表名是否创建
		sql ="select *  from MatrixFieldInfo where matrixid="+matrixid+" order by fieldtype , priority asc";
	    
	    int count = 0;
	    FieldRecord.execute(sql);
		totalcount = FieldRecord.getCounts();
		
		if(!isOracle){
			while(FieldRecord.next()){//表格已创建,找出所有的字段
				String str = FieldRecord.getString("fieldname");
			
				//存储数据
				Properties prop = new Properties();
				prop.put("fieldname",str);
				prop.put("colwidth",FieldRecord.getString("colwidth"));
				prop.put("displayname",FieldRecord.getString("displayname"));
				prop.put("browsertypeid",FieldRecord.getString("browsertypeid"));
				prop.put("browservalue",FieldRecord.getString("browservalue"));
				prop.put("custombrowser",FieldRecord.getString("custombrowser"));
				proplist.add(prop);
				
				
			    count ++;
			    if(totalcount == count){//最后一条记录
			    	backfileds.append("','+"+str+"+',' as "+ str);
			        //只获取 取值 字段
			        if(!"0".equals(FieldRecord.getString("fieldtype"))){
			    		wheresql.append(str+" like '%,"+objid+",%'");
			        }
			    }else{//非最后一条记录
			    	backfileds.append("','+"+str+"+',' as "+ str+",");
			    	if(!"0".equals(FieldRecord.getString("fieldtype"))){
			    		wheresql.append(str+" like '%,"+objid+",%' or ");
			    	}
			    }
			}
		}else{
			while(FieldRecord.next()){//表格已创建,找出所有的字段
				String str = FieldRecord.getString("fieldname");
			    count ++;
			    
			    //存储数据
				Properties prop = new Properties();
				prop.put("fieldname",str);
				prop.put("colwidth",FieldRecord.getString("colwidth"));
				prop.put("displayname",FieldRecord.getString("displayname"));
				prop.put("browsertypeid",FieldRecord.getString("browsertypeid"));
				prop.put("browservalue",FieldRecord.getString("browservalue"));
				prop.put("custombrowser",FieldRecord.getString("custombrowser"));
				proplist.add(prop);
			    
			    if(totalcount == count){//最后一条记录
			    	backfileds.append("','||"+str+"||',' as "+ str);
			    	if(!"0".equals(FieldRecord.getString("fieldtype"))){
			    		wheresql.append(str+" like '%,"+objid+",%'");
			    	}
			    }else{//非最后一条记录
			    	backfileds.append("','||"+str+"||',' as "+ str+",");
			    	if(!"0".equals(FieldRecord.getString("fieldtype"))){
			    		wheresql.append(str+" like '%,"+objid+",%' or ");
			    	}
			    }
			}
		}
		
		if(!"".equals(backfileds+"")){//说明有字段，有表
			if(!isOracle){
			  sql = "select * from (select "+backfileds+" from Matrixtable_"+matrixid+") as matrixtable ";
			}else{
				sql = "select * from (select "+backfileds+" from Matrixtable_"+matrixid+") matrixtable ";
			}
			if(!"".equals(wheresql.toString())){
				sql += " where " + wheresql.toString();
			}
			DataRecord.execute(sql);
			totalcount = DataRecord.getCounts();
		}else{
			totalcount = 0;
		}
  }
  
%>

<style>
table.result {
    width: 100%;
}

table.result thead{
    background: #ECFDEA;
}

table.result th{
    color: #999;
    font-weight: 400;
    padding: 5px;
    height: 21px;
    background-color: rgb(248,248,248);
    border-bottom: 2px solid #B7E0FE;
}
table.result td{
    
    line-height: 20px;
    padding: 5px;
    text-align: center;
    height: 23px;
    border-bottom: 1px solid #e9e9e9;
}
</style>

<HTML>
	<HEAD>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<script type="text/javascript">
		$(function () {
		    <% if(!"0".equals(countinit)){ %>
			    parent.initCount(<%=totalcount %>);
			    parent.initUpdateCount(0);
			<% } %>
			
			var searchLength = "<%=objidname.length() %>";
			jQuery(".result td").each(function (){
				var text=jQuery(this).text();
				if(searchLength>0){
					innerText=text.toLowerCase();
					bindex=innerText.indexOf("<%=objidname%>");
					
					if(bindex!=-1){
						searchStr=text.substr(bindex,searchLength);
						innerHtml="<label class='search_view'><font color='#39ae1f'><%=objidname%></font></label>";

						text=text.replace(searchStr,innerHtml);
					}
				}
				jQuery(this).html(text);
				
			});
		});
	
 		</script>
	</head>
	<%
	    String imagefilename = "/images/hdMaintenance_wev8.gif";
	    String titlename = SystemEnv.getHtmlLabelName(33923, user.getLanguage());
	    String needfav = "1";
	    String needhelp = "";
	%>
	<BODY>
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		<%
		%>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		
		<table  class="result" cellspacing="0">
		   <thead>
		      <tr>
		          <%
		            for(Properties prop : proplist){ %>
			         <th width="<%=prop.getProperty("colwidth") %>px"><%=prop.getProperty("displayname") %></th>
			      <%} %>
		      </tr>
		   </thead>
		   
		   <tbody>
		       <% if(totalcount !=0){ %>
				      <% while(DataRecord.next()){ %>
						    <tr>
							      <% for(Properties prop : proplist){ 
							    	  	String fielddbtype = "";
							      		if(!prop.getProperty("custombrowser").equals("0")&&!prop.getProperty("custombrowser").equals("")){
							      			fielddbtype = prop.getProperty("browservalue");
							      		}
							      %>
							      
							        <td><%=GetShowCondition.getShowCN("3",prop.getProperty("browsertypeid"),DataRecord.getString(prop.getProperty("fieldname")),"0",fielddbtype) %></td>
							      <%} %>
						    </tr>
					  <%} %>
			   <%}else{ %>
			       <tr>
			           <td colspan="<%= proplist.size() %>"><%=SystemEnv.getHtmlLabelName(22521, user.getLanguage()) %></td>
			       </tr>
			   <%} %>
		  </tbody>
		   
		
		</table>
		
		
	</BODY>
</HTML>
