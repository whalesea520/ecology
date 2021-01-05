<%@ page language="java" pageEncoding="UTF-8" contentType="text/plain; charset=UTF-8"%>
<%@ page import="weaver.hrm.User" %>
<%@ page import="weaver.hrm.HrmUserVarify" %>
<%@ page import="ln.LN" %>
<%@ page import="weaver.fullsearch.SearchResultBean" %>
<%@ page import="org.apache.commons.lang3.StringUtils" %>
<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="weaver.general.FWHttpConnectionManager" %>
<%@ page import="org.apache.commons.httpclient.HttpMethod" %>
<%@ page import="org.apache.commons.httpclient.methods.PostMethod" %>
<%@ page import="org.apache.commons.httpclient.HttpClient" %>
<%@ page import="org.apache.commons.httpclient.NameValuePair" %>
<%@ page import="org.apache.log4j.Logger" %>
<%@ page import="java.io.PrintWriter" %><%@ page import="java.net.URLEncoder"%><%@ page import="java.util.Map"%><%@ page import="java.util.HashMap"%><%@ page import="net.sf.json.JSONObject"%><%@ page import="weaver.general.BaseBean"%>

<%
    User user = HrmUserVarify.getUser (request , response) ;
    if(user == null)  return ;
   //licence信息
    String companyNametools="";
    LN Licenseinit_1 = new LN();
    Licenseinit_1.CkHrmnum();
    companyNametools = Licenseinit_1.getCompanyname();
    String action = request.getParameter("action");
    if ("search".equals(action)) {
        String searchPage = request.getParameter("page");
        String searchfrom = request.getParameter("searchfrom");
        String hideTitle = request.getParameter("hideTitle");
        String noCheck = request.getParameter("noCheck");
        String searchType = request.getParameter("searchType");
        String contentType = request.getParameter("contentType");
        String key = request.getParameter("key");
        String jsonString = request.getParameter("jsonString");
        String belongtoShow = request.getParameter("belongtoShow");
        String sourceType = request.getParameter("sourceType");
        String cusContentType = request.getParameter("cusContentType");

        SearchResultBean searchResultBean = new SearchResultBean();
        searchResultBean.setUser(user);
        searchResultBean.setPage(StringUtils.isBlank(searchPage)?0:Integer.valueOf(searchPage));
        searchResultBean.setSearchType(searchType);
        searchResultBean.setContentType(contentType);
        searchResultBean.setKey(key);
        searchResultBean.setRequest(request);
        searchResultBean.setResponse(response);
        searchResultBean.setPageContext(pageContext);
        searchResultBean.setOtherString(jsonString);
        searchResultBean.setSourceType(sourceType);
        searchResultBean.setCusContentType(cusContentType);
        searchResultBean.setBelongtoShow(belongtoShow);
        String result = searchResultBean.searchResult();
        PrintWriter pw = response.getWriter();
        pw.write(URLEncoder.encode(result, "utf-8"));
        //pw.write(result.substring((result.length())/2, result.length()));
        pw.flush();
        pw.close();
    } else if ("track".equals(action)) {
        String recordInstructionUrl="";
        RecordSet rs=new RecordSet();
        rs.execute("select sValue from FullSearch_EAssistantSet where sKey='recordInstructionUrl'");
        if(rs.next()){
            recordInstructionUrl=rs.getString("sValue");
        }
        if(!"".equals(recordInstructionUrl)){
            String trackJson = request.getParameter("trackJson");
            HttpMethod method = new PostMethod(recordInstructionUrl+"/track/makeTrack.action");
            try {
                HttpClient client = FWHttpConnectionManager.getHttpClient();
                NameValuePair pair1 = new NameValuePair("trackJson", trackJson);
                method.setQueryString(new NameValuePair[]{pair1});
                int rspCode = client.executeMethod(method);
                String receive = method.getResponseBodyAsString();
            } catch (Exception e) {

            }finally{
                method.releaseConnection();
            }
        }
    } else if ("cowType".equals(action)) {
        Map<String, String> map = new HashMap<String, String>();
        String sql = "select id,typename from cowork_types";
        RecordSet rs = new RecordSet();
        rs.executeSql(sql);
        while (rs.next()) {
            map.put(rs.getString("id"), rs.getString("typename"));
        }
        PrintWriter pw = response.getWriter();
        pw.write(JSONObject.fromObject(map).toString());
        pw.flush();
        pw.close();
    }
%>
