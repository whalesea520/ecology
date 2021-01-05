<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script src="/js/ecology8/jquery_wev8.js"></script>
</HEAD>
<body>
<div style="font-size:16px;">
<%
    int weaverTableRows = Util.getIntValue(request.getParameter("weaverTableRows"),0);//总行数  比如一共增加了10行，但删除了其中的5行，该值依然为10.
    int weaverTableRealRows = Util.getIntValue(request.getParameter("weaverTableRealRows"),0);//实际行数  比如一共增加了10行，但删除了其中的5行，该值就是5.
    String __weaverDeleteRows = Util.null2String(request.getParameter("__weaverDeleteRows"));//删除行的id

    out.println("总行数:"+weaverTableRows +" 实际行数"+weaverTableRealRows+" 删除数据的id:::"+__weaverDeleteRows);
    for(int i = 0 ; i < weaverTableRows ; i++){
        String fieldid = Util.null2String(request.getParameter("fieldid_"+i));
        String wb = Util.null2String(request.getParameter("wb_"+i));
        String xlk = Util.null2String(request.getParameter("xlk_"+i));
        String orderid = Util.null2String(request.getParameter("orderid_"+i));
        out.println("<br />第"+(i+1)+"行数据 {浏览按钮："+fieldid+" 文本："+wb+"  下拉框:"+xlk+"  排序:"+orderid+"}");
    }

%>
</div>
 </body>
</html>
