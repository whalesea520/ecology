
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/homepage/element/content/Common.jsp" %>
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

 if(!"".equals(strsqlwhere)){
	int tempPos=strsqlwhere.indexOf("^,^");
	if(tempPos!=-1){
	  strStock=strsqlwhere.substring(0,tempPos);
	  moreUrl=strsqlwhere.substring(tempPos+3,strsqlwhere.length());
	} else {
		strStock=strsqlwhere;		
	}
}

ArrayList stockidList=Util.TokenizerString(strStock,";");
if(stockidList==null) return;
%>
<TABLE  style="color:<%=hpsb.getEcolor()%>" id="_contenttable_<%=eid%>" class=Econtent  <%if(stockidList.size()>0) out.println(" height='120px' ");%>  width=100%>
   <TR>
	 <TD width=1px></TD>
	 <TD width='*' valign="center">
		<table  width="100%">
			<%
			for(int i=0;i<stockidList.size();i++){
				String stockid=(String)stockidList.get(i);
				String linkUrl=moreUrl+stockid;
				String imgUrl="";
				//if  (stockid.length()<2) return;
				//String flag=stockid.substring(0,2);
				//String code=stockid.substring(2,stockid.length());
				
				imgUrl="http://www.google.cn/finance/chart?tlf=24&q="+stockid;
				moreUrl="http://finance.google.cn/finance?client=ob&q="+stockid;
				//if(flag.equalsIgnoreCase("sh")||flag.equalsIgnoreCase("sz")){
				//	imgUrl="http://fchart.sina.com.cn/newchart/min/"+stockid+".gif";
				//} else if(flag.equalsIgnoreCase("hk")){
				//	imgUrl="http://biz.finance.sina.com.cn/hk/delay_chart.php?code="+code;
				//}
				//out.println(imgUrl);
				String showValue="";
				if("1".equals(linkmode))
					showValue="<a href='"+moreUrl+"' target='_self'><img   src=\""+imgUrl+"\" border=0></a>";
				else 
					showValue="<a href=\"javascript:openFullWindowForXtable('"+moreUrl+"')\"><img  src=\""+imgUrl+"\" border=0></a>";
			%>
			<tr><td width="100%">&nbsp;<%=showValue%></td></tr>
			<%if(i+1<stockidList.size()){%>
				<TR style="background:url('<%=hpsb.getEsparatorimg()%>')" height=1px><td></td></TR>
			<%}%>
			<%
			}
			%>
		</table>
	</TD>    
	<TD width=1px></TD>
  </TR>
</TABLE>