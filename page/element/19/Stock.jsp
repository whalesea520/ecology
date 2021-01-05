
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/page/element/loginViewCommon.jsp"%>

<!-- 判断元素是否可以独立显示，引入样式 -->
<%
	String indie = Util.null2String(request.getParameter("indie"), "false");
	if ("true".equals(indie)) {
%>
		<%@ include file="/homepage/HpElementCss.jsp" %>
<%	} %>

<%
	/*
		基本信息
		--------------------------------------
		hpid:表首页ID
		subCompanyId:首页所属分部的分部ID
		eid:元素ID
		ebaseid:基本元素ID
		styleid:样式ID
		
		条件信息
		--------------------------------------
		strsqlwhere 格式为 条件1^,^条件2...
		perpage  显示页数
		linkmode 查看方式  1:当前页 2:弹出页

		
		字段信息
		--------------------------------------
		fieldIdList
		fieldColumnList
		fieldIsDate
		fieldTransMethodList
		fieldWidthList
		linkurlList
		valuecolumnList
		isLimitLengthList
	*/

%>
<%
String  strStock="";
String  moreUrl="";
String width="300";
String height="165";
 if(!"".equals(strsqlwhere)){
	int tempPos=strsqlwhere.indexOf("^,^");
	if(tempPos!=-1){
	  ArrayList valueList=Util.TokenizerString(strsqlwhere,"^,^");
	  if(valueList.size()==1){
		strStock=(String)valueList.get(0);
	  }else if(valueList.size()==3){
		  width=(String)valueList.get(0);
		  height=(String)valueList.get(1);
		  strStock=(String)valueList.get(2);
	  }else{
		  strStock=strsqlwhere.substring(strsqlwhere.lastIndexOf("^,^")+3);
	  }
	} else {
		strStock=strsqlwhere;		
	}
}
ArrayList stockidList=Util.TokenizerString(strStock,";");
if(stockidList==null) return;
%>
<TABLE id="_contenttable_<%=eid%>" class=Econtent  <%if(stockidList.size()>0) out.println(" height='120px' ");%>  width=100%>
   <TR>
	 
	 <TD width='100%' valign="">
	 <center>
		<table width="100%">
			<%
			for(int i=0;i<stockidList.size();i++){
				String[] stockidStr=Util.forHtml((String)stockidList.get(i)).split(":");
				if(stockidStr.length<2) continue;
				String stockType = stockidStr[0];
				String stockid = stockidStr[1];
				String linkUrl=moreUrl+stockid;
				String imgUrl="";
				
				imgUrl="http://image.sinajs.cn/newchart/min/n/sh"+stockid+".gif";
				moreUrl="http://finance.sina.com.cn/realstock/company/sh"+stockid+"/nc.shtml";
				if("SHA".equalsIgnoreCase(stockType)){
					imgUrl="http://image.sinajs.cn/newchart/min/n/sh"+stockid+".gif";
					moreUrl="http://finance.sina.com.cn/realstock/company/sh"+stockid+"/nc.shtml";
				} else if("SHE".equalsIgnoreCase(stockType)){
					imgUrl="http://image.sinajs.cn/newchart/min/n/sz"+stockid+".gif";
					moreUrl="http://finance.sina.com.cn/realstock/company/sz"+stockid+"/nc.shtml";
				}
				//out.println(imgUrl);
				String showValue="";
				String type = "1";
				if("1".equals(linkmode))
					showValue="<a href='"+moreUrl+"' target='_self'><img style='width:"+width+"px;height:"+height+"px;' src=\""+imgUrl+"\"  border=0></a>";
				else {
					type = "0";
					showValue="<a href=\"javascript:openFullWindowForXtable('"+moreUrl+"')\"><img style='width:"+width+"px;height:"+height+"px;' src=\""+imgUrl+"\"   border=0></a>";
				}
			%>
			
			<tr><td width="100%" align="center">&nbsp;<%=showValue%></td></tr>
			<%if(i+1<stockidList.size()){%>
			
				<TR class='sparator' style="height:1px" height=1px><td style='padding:0px'></td></TR>
			<%}%>
			<%
			}
			%>
		</table>
		</center>
	</TD>    
	
  </TR>
</TABLE>
