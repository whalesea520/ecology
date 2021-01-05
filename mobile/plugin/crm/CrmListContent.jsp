
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@page import="weaver.hrm.resource.ResourceComInfo"%>
<%@ page import="weaver.splitepage.transform.SptmForMail" %>
<%@page import="weaver.general.SplitPageParaBean"%>
<%@page import="weaver.general.SplitPageUtil"%>
<%@page import="weaver.conn.RecordSet"%>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page" />
<jsp:useBean id="recordSet" class="weaver.conn.RecordSet" scope="page" />
<%
	String userid=""+user.getUID();
	String backfields="t1.id,t1.name";
	String leftjointable = CrmShareBase.getTempTable(userid);
	String sqlform = "from CRM_CustomerInfo t1 left join "+leftjointable+" t2 on t1.id = t2.relateditemid";
	String sqlprimarykey="t1.id";
	String sqlwhere="t1.deleted = 0  and t1.id = t2.relateditemid";
	String orderBy = "t1.id";
	
	String name=Util.null2String(request.getParameter("name"));
	String sector=Util.null2String(request.getParameter("sector"));
	String type=Util.null2String(request.getParameter("type"));
	
	if(!name.equals(""))
		sqlwhere+=" and name like '%"+name+"%'";
	
	if(!sector.equals(""))
		sqlwhere+=" and sector='"+sector+"'";
	
	if(!type.equals(""))
		sqlwhere+=" and type='"+type+"'";
	
	SplitPageParaBean spp = new SplitPageParaBean();
	SplitPageUtil spu=new SplitPageUtil();
	
	spp.setBackFields(backfields);
	spp.setSqlFrom(sqlform);
	spp.setPrimaryKey(sqlprimarykey);
	spp.setSqlOrderBy(orderBy);
	spp.setSortWay(spp.DESC);
	spp.setDistinct(true);
	
	spp.setSqlWhere(sqlwhere);
	spu.setSpp(spp);
	
	int total = spu.getRecordCount();
	int pagesize=10;
	int pageIndex = Util.getIntValue(request.getParameter("index"),1);
	
	int totalpage=total%pagesize==0?total/pagesize:(total/pagesize+1);
	RecordSet rs = spu.getCurrentPageRs(pageIndex, pagesize);
	 
	//加载数据的方式，0默认加载，1更多加载
	String loadtype=Util.null2String(request.getParameter("loadtype"));
	StringBuffer day0Table = new StringBuffer();
	while(rs.next()){
		day0Table.append(getTableString(rs,user));	
	}
	if("0".equals(loadtype)){
		//默认加载的时候，才输出这个
		day0Table.append("<input type='hidden' name='TotalPage'  id='TotalPage'  value='"+totalpage+"'>");	
	}
	out.clear();
%>
		<%=day0Table.toString() %>

		<%!
		
			public String getTableString(RecordSet rs ,User user){
				
				String id=rs.getString("id");
				String name=rs.getString("name");
			    
				String sql="select top 1 id,fullname,firstname,mobilephone from CRM_CustomerContacter where customerid ="+id+" order by main desc,id desc";
				RecordSet recordSet=new RecordSet();
				if(recordSet.getDBType().equals("oracle")){
					sql="select id,fullname,firstname,mobilephone from (select * from CRM_CustomerContacter order by main desc,id desc) t3 where t3.customerid ="+id+" and rownum = 1";
				}
				recordSet.execute(sql);
				
				String str="";
					 str+="<div class='listitem'  >";
					 str+="<table   id='tbl_"+id+"'  style='width:100%;height:100%;border:0;cellspacing:0;cellpadding:0;table-layout:fixed;'>";
					 str+="<tbody>";
					 str+="	<tr><td class='itempreview'>";
					 str+="	</td>";
					 str+="	<td class='itemcontent  trclick'  _id='"+id+"' _folderid='"+0+"' _star='"+0+"'  _isInternal='"+0+"'>";
					 str+="	<div class='itemcontenttitle'>";
					 str+="	<table style='width:100%;height:100%;border:0;cellspacing:0;cellpadding:0;table-layout:fixed;'>";
					 str+="	<tbody>";
					 str+="	<tr><td class='ictwz'>"+name+"</td>";
					 str+="	</tr></tbody>";
					 str+="	</table>";
					 str+="	</div>";
					 if(recordSet.next()){
					 	str+="	<div class='itemcontentitdt'> 联系人:"+recordSet.getString("firstname")+"&nbsp;&nbsp;"+"电话："+recordSet.getString("mobilephone")+"</div>";
					 }	
					 str+="</td>";
					 str+="<td class='itemnavpoint'   _id='"+id+"' _folderid='"+0+"' _star='"+1+"' _isInternal='"+1+"'>";
					 str+="<img src='/images/icon-right.png'>";
					 str+="</td></tr></tbody>";
					 str+="</table></div>";
				return str;
			}		
		
		%>