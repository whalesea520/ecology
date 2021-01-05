<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.formmode.tree.CustomTreeData" %>
<%@page import="weaver.filter.XssUtil"%>
<jsp:useBean id="CustomTreeUtil" class="weaver.formmode.tree.CustomTreeUtil" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />

<%
	String sql = "";
	int mainid = Util.getIntValue(Util.null2String(request.getParameter("mainid")),0);
	String pid = Util.null2String(request.getParameter("pid"));
	String pids[] = pid.split(CustomTreeData.Separator);
	String customdetailid = pids[0];
	String supid = pids[1];
	String href = CustomTreeUtil.getRelateHrefAddress(mainid,customdetailid,supid);
	int isRefreshTree = Util.getIntValue(Util.null2String(request.getParameter("isRefreshTree")),0);
	if(!href.equals("")){
		if(href.indexOf("?")==-1){
			href = href+"?customTreeDataId="+pid;
		}else{
			href = href+"&customTreeDataId="+pid;
		}
		href = href + "&isRefreshTree="+isRefreshTree+"&mainid="+mainid;
	}
    String treesqlwhere = "&treesqlwhere=";
    int index = href.indexOf(treesqlwhere);
    if(index!=-1){
        XssUtil xs=new XssUtil();
        String tempStr = href.substring(0,index);
        String aftStr = href.substring(index+treesqlwhere.length());
        if(aftStr.indexOf("&")!=-1){
            String sqlwhere=aftStr.substring(0,aftStr.indexOf("&"));
            href = tempStr +treesqlwhere+xs.put(sqlwhere)+aftStr.substring(aftStr.indexOf("&"));
        }else{
            href = tempStr+treesqlwhere+xs.put(aftStr);
        }
    }
%>
<%=href%>