<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.rdeploy.doc.SeccategoryShowModel" %>
<%@ page import="net.sf.json.JSONObject" %>
<jsp:useBean id="multiAclManager" class="weaver.rdeploy.doc.MultiAclManagerNew" scope="page" />
<%@ page import="weaver.hrm.*" %>
<jsp:useBean id="privateSeccategoryManager" class="weaver.rdeploy.doc.PrivateSeccategoryManager" scope="page" />
<%
	User user = HrmUserVarify.getUser (request , response) ;
	String categoryname = Util.null2String(request.getParameter("categoryname"));
	String foldertype = Util.null2String(request.getParameter("foldertype"));
	String parentid = Util.null2String(request.getParameter("parentid"));
	int categoryid=Util.getIntValue(Util.null2String(request.getParameter("categoryid")),0);
	String result = "";
	 RecordSet rs = new RecordSet();
	if(foldertype.equals("publicAll"))
	{
	    int pidtemp = Integer.parseInt(parentid);
	    String sql = "";
	    if(pidtemp <= 0)
	    {
	        sql = "select id from DocSecCategory where categoryname =  '"+categoryname+"' and ( parentid  = 0 or parentid is null)";
	    }
	    else
	    {
	        sql = "select id from DocSecCategory where categoryname =  '"+categoryname+"' and parentid  = " + parentid;
	    }
        rs.executeSql(sql);
        if(rs.next())
        {
            System.out.println(sql);
            Map<String,Object> map = new HashMap<String,Object>();
            map.put("exist", "true");
            JSONObject jsonObject = JSONObject.fromObject(map);
    	    result = jsonObject.toString();
        }
        else
        {
            result = multiAclManager.createSeccategory(user,categoryname,parentid,0);
        }
	}
	else if(foldertype.equals("privateAll")&&categoryid==0)
	{
	   System.out.println(parentid);
	    
	    int pidtemp = Integer.parseInt(parentid);
	    if(pidtemp <= 0)
        {
          String sql = "select id from DocPrivateSecCategory where categoryname = '"+user.getUID()+"_"+user.getLastname()+"' and parentid = 0";
            rs.executeSql(sql);
            if(rs.next())
            {
                pidtemp = rs.getInt("id");
            }
        }
	   String sql = "select id from DocPrivateSecCategory where categoryname = '"+categoryname+"' and parentid = " + pidtemp;
        rs.executeSql(sql);
        if(rs.next())
        {
            Map<String,Object> map = new HashMap<String,Object>();
            map.put("exist", "true");
            JSONObject jsonObject = JSONObject.fromObject(map);
    	    result = jsonObject.toString();
        }
        else
        {
            int pid = Integer.parseInt(parentid);
    	    SeccategoryShowModel seccategoryShowModel = privateSeccategoryManager.createSeccategory(user,categoryname,pid);
    	    JSONObject jsonObject = JSONObject.fromObject(seccategoryShowModel);
    	    result = jsonObject.toString();
        }
	}else if(foldertype.equals("privateAll")&&categoryid>0){
		Map<String,Object> map = new HashMap<String,Object>();
		if(categoryname.isEmpty()){
			map.put("result", "fail");
		}else{
			rs.executeSql("select categoryname,parentid from DocPrivateSecCategory where  id = " +categoryid);
			if(rs.next()){
				String categoryname_old = Util.null2String(rs.getString("categoryname"));
				int pid = Util.getIntValue(Util.null2String(rs.getString("parentid")),-1);
				if(categoryname_old.equals(categoryname)){
					map.put("result", "success");//相同
				}else if(!categoryname_old.equals(categoryname)&&pid==-1){
					map.put("result", "fail");
				}else {
					String sql = "select id from DocPrivateSecCategory where categoryname = '"+categoryname+"' and parentid = " + pid + " and id <> " +categoryid;
					rs.executeSql(sql);
					if(rs.next())
					{
						map.put("result", "exist");
					}
					else
					{
						boolean flag  = privateSeccategoryManager.renameSeccategory(user,categoryid,categoryname,pid);
						if(flag){
							map.put("result", "success");
						}else{
							map.put("result", "fail");
						}
					}
				}
			}else{
				map.put("result", "fail");
			}
		}
		JSONObject jsonObject = JSONObject.fromObject(map);
    	result = jsonObject.toString();
	}
	System.out.println(result);
	out.println(result);
%>
