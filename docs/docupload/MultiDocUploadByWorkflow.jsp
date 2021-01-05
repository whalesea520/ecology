
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.file.FileUpload" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="java.util.Map,java.util.HashMap" %>
<%@ page import="weaver.docs.docs.DocUpload" %>
<%@ page import="weaver.hrm.resource.ResourceComInfo" %>
<%@ page import="weaver.conn.RecordSet" %>


<%

	User user = HrmUserVarify.getUser(request, response);
	if (user == null) return;

    response.setHeader("cache-control", "no-cache");
    response.setHeader("pragma", "no-cache");
    response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
    //request.setCharacterEncoding("utf-8");


    FileUpload fu = new FileUpload(request, "utf-8");
    int mainId = Util.getIntValue(fu.getParameter("mainId"),0);
    int subId = Util.getIntValue(fu.getParameter("subId"),0);
    int secId = Util.getIntValue(fu.getParameter("secId"),0);
    int userid = Util.getIntValue(fu.getParameter("userid"));
    int logintype = Util.getIntValue(fu.getParameter("logintype"));
	RecordSet rs = new RecordSet();
	rs.executeSql("select count(1) as count from docseccategory where id ="+secId);
	rs.next();
	int count=rs.getInt("count");
	if( count<1 ){
		rs.writeLog("category "+secId+" is not exist");
		return ;
	}
    user = null;
    if (userid < 1) {
        user = HrmUserVarify.getUser(request, response);
    } else {
        //RecordSet rs = new RecordSet();
        user=new User();
        user.setUid(userid);
        if (logintype == 2) {
            rs.execute("CRM_CustomerInfo_SelectByID", "" + userid);
            if (rs.next()) {
                user.setLoginid(rs.getString("portalloginid"));
                user.setFirstname(rs.getString("name"));
                String languageidweaver = rs.getString("language");
                user.setLanguage(Util.getIntValue(languageidweaver, 7));
                user.setUserDepartment(Util.getIntValue(rs.getString("department"), 0));
                user.setUserSubCompany1(Util.getIntValue(rs.getString("subcompanyid1"), 0));
                user.setManagerid(rs.getString("manager"));
                user.setCountryid(rs.getString("country"));
                user.setEmail(rs.getString("email"));
                user.setLogintype("2");
                user.setSeclevel(rs.getString("seclevel"));
            }
        } else {
            ResourceComInfo rci = new ResourceComInfo();
            user.setLoginid(rci.getLoginID("" + userid));
            user.setLogintype("1");
            user.setFirstname(rci.getFirstname("" + userid));
            user.setLastname(rci.getLastname("" + userid));
            user.setSex(rci.getSexs("" + userid));
            user.setLanguage(Util.getIntValue(rci.getSystemLanguage("" + userid), 7));
            user.setTelephone(rci.getTelephone("" + userid));
            user.setMobile(rci.getMobile("" + userid));
            user.setEmail(rci.getEmail("" + userid));
            user.setLocationid(rci.getLocationid("" + userid));
            user.setResourcetype(rci.getResourcetype("" + userid));
            user.setJobtitle(rci.getJobTitle("" + userid));
            user.setJoblevel(rci.getJoblevel("" + userid));
            user.setSeclevel(rci.getSeclevel("" + userid));
            user.setUserDepartment(Util.getIntValue(rci.getDepartmentID("" + userid)));
            user.setUserSubCompany1(Util.getIntValue(rci.getSubCompanyID("" + userid)));
            user.setManagerid(rci.getManagerID("" + userid));
            user.setAssistantid(rci.getAssistantID("" + userid));
            user.setAccount(rci.getAccount("" + userid));
        }
    }
    if (user == null) return;
    String[] filedata = new String[1];
    filedata[0] = "Filedata";
    int[] returnarry = null;
    try{
    returnarry = DocUpload.uploadDocsToImgs(fu, user, filedata,mainId,subId,secId,"","");
		
	}catch(Exception e){
		fu.writeLog("uplodError:"+e);
		fu.writeLog("errorWorkflowid:"+Util.getIntValue(fu.getParameter("workflowid"),0));
	}
    String tempvalue = "";
    if (returnarry != null) {
        for (int i = 0; i < returnarry.length; i++) {
            if (returnarry[i] != -1)
                if (tempvalue.trim().equals(""))
                    tempvalue = String.valueOf(returnarry[i]);
                else
                    tempvalue = tempvalue + "," + String.valueOf(returnarry[i]);
        }
    }
    
    String returnFileid = Util.null2String(fu.getParameter("returnFileid"));
    
        
    if("1".equals(returnFileid)){
        String []values = tempvalue.split(",");
        
        rs.executeSql("select d.id,f.imagefileid from DocDetail d join DocImageFile di on d.id=di.docid join ImageFile f on f.imagefileid=di.imagefileid where d.id in(" + tempvalue + ")");
        Map<String,String> map = new HashMap<String,String>();
        while(rs.next()){
            map.put(rs.getString("id"),rs.getString("imagefileid") + "_" + rs.getString("id"));
        }
        tempvalue = "";
       for(String value : values){
            tempvalue += "," + map.get(value);
        }
       tempvalue = tempvalue.length() > 0 ? tempvalue.substring(1) : tempvalue;
    }
    
    fu.writeLog("from MultiPicUploadByWorkflow.jsp:workflowid"+Util.getIntValue(fu.getParameter("workflowid"),0)+",userid:"+userid+"returnValue:"+tempvalue);
    out.println(tempvalue);
%>