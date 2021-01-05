
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.conn.RecordSetTrans"%>
<%@ include file="/page/maint/common/initNoCache.jsp"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />

<jsp:useBean id="hpec" class="weaver.homepage.cominfo.HomepageElementCominfo" scope="page"/>
<%	
	
	String eid=Util.null2String(request.getParameter("eid"));	
	String method=Util.null2String(request.getParameter("method"));	
	
	String tabId=Util.null2String(request.getParameter("tabId"));	
	String tabTitle=Util.null2String(request.getParameter("tabTitle"));	
	String ebaseid = Util.null2String(request.getParameter("ebaseid"));	
	//tabTitle = Util.toHtml2(tabTitle);
	tabTitle = tabTitle.replaceAll("'","''");
	String tabWhere=Util.null2String(request.getParameter("tabWhere"));
	if("reportForm".equals(ebaseid)){
		if(!HrmUserVarify.checkUserRight("ReportFormElement", user)){
			return;
		}
		tabWhere = Util.null2String(request.getParameter("sqltabWhere"));

	}
	String orderNum = Util.null2String(request.getParameter("orderNum"));
	String orders = Util.null2String(request.getParameter("orders"));
	
	Hashtable tabAddList =null;
	ArrayList tabRemoveList = null;
	
	
	if(session.getAttribute(eid+"_Add")!=null){
		tabAddList = (Hashtable)session.getAttribute(eid+"_Add");
	}else{
		tabAddList = new Hashtable();
		
	}
	
	if(session.getAttribute(eid+"_Remove")!=null){
		
		tabRemoveList = (ArrayList)session.getAttribute(eid+"_Remove");
	}else{
		tabRemoveList = new ArrayList();
	}
	
	if(method.equals("add")||method.equals("edit")){
		Hashtable hasTabParam = new Hashtable();	
		hasTabParam.put("eid",eid+"");
		hasTabParam.put("tabId",tabId);
		hasTabParam.put("tabTitle",tabTitle);
		hasTabParam.put("tabWhere",tabWhere);
		hasTabParam.put("orderNum",orderNum);
		tabAddList.put(tabId,hasTabParam);
		session.setAttribute(eid+"_Add",tabAddList);
	}else if(method.equals("delete")){
		String[] tabArr = tabId.split(";");
		for(String tmpS : tabArr){
			if(tabAddList.containsKey(tmpS)){
				tabAddList.remove(tmpS);	
			}
			tabRemoveList.add(tmpS);
				
			session.setAttribute(eid+"_Remove",tabRemoveList);
		}
	}else if(method.equals("submit")){
		
		Enumeration e =tabAddList.elements(); 
		boolean isfirst=true;
	//	Hashtable orderMap = new Hashtable();
		String firstSql = "update hpelement set strsqlwhere=? where id = ? and ebaseid<>'reportForm'";//不更新图表元素的strsqlwhere
		while(e.hasMoreElements()){ 
			Hashtable hasParam = (Hashtable)e.nextElement();
	//		String order = orderMap.get(hasParam.get("tabId"));
			String tabSql = "select * from hpNewsTabInfo where eid="+hasParam.get("eid")+" and tabId='"+hasParam.get("tabId")+"'";
			rs.execute(tabSql);
			if(rs.next()){
				tabSql = "update hpNewsTabInfo set sqlWhere = ?, tabTitle=?  where eid=? and tabId=?";
				rs.executeUpdate(tabSql,new Object[]{hasParam.get("tabWhere"),hasParam.get("tabTitle"),hasParam.get("eid"),hasParam.get("tabId")});

			}else{
				tabSql = "insert into hpNewsTabInfo (eid,tabid,tabTitle,sqlWhere) values(?,?,?,?)";
				rs.executeUpdate(tabSql,new Object[]{hasParam.get("eid"),hasParam.get("tabId"),hasParam.get("tabTitle"),hasParam.get("tabWhere")});
			}
			if(isfirst){
				rs.executeUpdate(firstSql,new Object[]{hasParam.get("tabWhere"),hasParam.get("eid")});
				hpec.updateHpElementCache(eid);
				isfirst = false;
			}
		}
		//更新页签序号，如果页面页签仅有拖拽更改，则需专门更新，此处专门更新行序
		if(orders != null && !"".equals(orders)){
			String[] arr = orders.split(";");
			String strSql="update hpNewsTabInfo set orderNum=? where eid=? and tabId =?";
			RecordSetTrans recordSetTrans = new RecordSetTrans();
			for(String str : arr){
				String[] tmp = str.split("_");
				recordSetTrans.executeUpdate(strSql,new Object[]{tmp[1],eid,tmp[0]});
			}
			recordSetTrans.commit();
		}
		for(int i=0;i<tabRemoveList.size();i++){
			rs.execute("delete from hpNewsTabInfo where eid="+eid+" and tabId='"+tabRemoveList.get(i)+"'");
			
		}
		//if(tabAddList.)
		session.removeAttribute(eid+"_Add");
		session.removeAttribute(eid+"_Remove");
	} else if(method.equals("cancel")){
		session.removeAttribute(eid+"_Add");
		session.removeAttribute(eid+"_Remove");
	}
%>