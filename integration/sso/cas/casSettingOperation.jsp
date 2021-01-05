<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.interfaces.sso.cas.CasUtil" %>
<%@ page import="weaver.interfaces.sso.cas.CasSetting" %>
<%@ page import="java.util.regex.Matcher" %>
<%@ page import="java.util.regex.Pattern" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.conn.RecordSet" %>
<%!
public String getOaAddress(RecordSet recordSet){
	
	recordSet.executeProc("SystemSet_Select","");
	recordSet.next();
	String ecologyurl = Util.null2String(recordSet.getString("oaaddress"));
	String ecologyurlWithNoHttp = ecologyurl.replace("http://","").replace("https://","");
	if(ecologyurlWithNoHttp.indexOf("/")!=-1){
		ecologyurl = (ecologyurl.indexOf("http://")!=-1?"http://":"")+
		(ecologyurl.indexOf("https://")!=-1?"https://":"")+ecologyurlWithNoHttp.substring(0,ecologyurlWithNoHttp.indexOf("/"));
	}
	return ecologyurl;
}
public boolean accept(String str) {
    try {
      Pattern pattern = Pattern.compile("\\/+");
      Matcher match = pattern.matcher(str);                
      return match.matches();
    } catch (Exception e) {
      return true;
    }
  }
%>
<%
if(!HrmUserVarify.checkUserRight("CAS:ALL",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
RecordSet rs = new RecordSet();
rs.execute("select isuse from int_cas_setting ");
rs.next();
String oldIsUse = rs.getString(1);

String isuse= Util.null2String(request.getParameter("isuse"));isuse = "".equals(isuse)?"0":isuse;
String casserverurl= Util.null2String(request.getParameter("casserverurl"));
String casserverloginpage= Util.null2String(request.getParameter("casserverloginpage"));
String casserverlogoutpage= Util.null2String(request.getParameter("casserverlogoutpage"));
String ecologyurl= Util.null2String(request.getParameter("ecologyurl"));
if("".equals(ecologyurl)){
	ecologyurl = getOaAddress(rs);
}

String ecologyloginpage= Util.null2String(request.getParameter("ecologyloginpage"));
String pcauth= Util.null2String(request.getParameter("pcauth"));pcauth = "".equals(pcauth)?"0":pcauth;
String appauth= Util.null2String(request.getParameter("appauth"));appauth = "".equals(appauth)?"0":appauth;
String accounttype= Util.null2String(request.getParameter("accounttype"));accounttype = "".equals(accounttype)?"0":accounttype;
String customsql= Util.null2String(request.getParameter("customsql"));
String appauthAddress= Util.null2String(request.getParameter("appauthAddress"));
String saveType= Util.null2String(request.getParameter("saveType"));

String ids[] = request.getParameterValues("ids");
String excludeurl[] = request.getParameterValues("excludeurl");
for(int i=0;i<excludeurl.length;i++){
	excludeurl[i] = excludeurl[i].trim();
	if(accept(excludeurl[i])){
		response.sendRedirect("/integration/sso/cas/casSetting.jsp?msgid=2");
		return;
	} 
}

String excludedescription[] = request.getParameterValues("excludedescription");
	String sql = "update int_cas_setting set isuse="+isuse+",casserverurl='"+casserverurl+"',casserverloginpage='"+casserverloginpage+"',casserverlogoutpage='"+casserverlogoutpage
	+"',ecologyurl='"+ecologyurl+"',ecologyloginpage='"+ecologyloginpage+"',pcauth="+pcauth+",appauth="+appauth+",accounttype="+accounttype+",customsql='"+customsql+"'"+",appauthAddress='"+appauthAddress+"'";
	rs.executeSql(sql);
	
	
	List list = Arrays.asList(excludeurl);
	Set set = new HashSet(list);
	String [] noRepatExcludeurl=(String [])set.toArray(new String[0]);
	if(noRepatExcludeurl.length!=excludeurl.length){
		response.sendRedirect("/integration/sso/cas/casSetting.jsp?msgid=1");
		return;
	}

	rs.executeSql("delete from int_cas_exclueurl ");
   if(excludeurl!=null){
		for(int i=0;i<excludeurl.length;i++){
			String excludeurlVal=excludeurl[i];
			String excludedescriptionVal=excludedescription[i];
			String tempid = Util.null2String(ids[i]);
			tempid = tempid.equals("")?"0":tempid;
			if(!excludeurlVal.equals("") && Integer.parseInt(tempid)>=0)
				rs.executeSql("insert into int_cas_exclueurl(excludeurl,excludedescription) values('"+excludeurlVal+"','"+excludedescriptionVal+"')");
		}
	}
   
   //配置web.xml cas相关filter
   if("1".equals(isuse) && saveType.equals("1")){
	   CasUtil cs = new CasUtil();
	   cs.writeFilter();
   }
   if("0".equals(isuse) && saveType.equals("1")){
	   CasUtil cs = new CasUtil();
	   cs.deleteFilter();
   }
   new CasSetting().removeCASComInfoCache();
   response.sendRedirect("casSetting.jsp");
    %>
