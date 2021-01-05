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
	String fileName_new = Util.null2String(request.getParameter("fileName")).trim();
	int imagefileid=Util.getIntValue(Util.null2String(request.getParameter("imagefileid")),0);
	int categoryid=Util.getIntValue(Util.null2String(request.getParameter("categoryid")),-1);
	String uid = Util.null2String(request.getParameter("uid")).trim();
	String result = "";
	RecordSet rs = new RecordSet();
	Map<String,Object> map = new HashMap<String,Object>();
	if(imagefileid<=0||fileName_new.isEmpty()){
		map.put("result", "fail");//文件id错误或新文件名为空,结束
	}else{
		if(categoryid <= 0)
        {
          String sql = "select id from DocPrivateSecCategory where categoryname = '"+user.getUID()+"_"+user.getLastname()+"' and parentid = 0";
            rs.executeSql(sql);
            if(rs.next())
            {
                categoryid = rs.getInt("id");
            }
        }
		if(categoryid>0){
			rs.executeSql("select filename from imagefileref where imagefileid = " + imagefileid + " and categoryid="+categoryid);
			if(rs.next())
			{
				String fileName_old=Util.null2String(rs.getString("filename"));
				if(fileName_new.equals(fileName_old)){
					map.put("result", "success");//新旧文件名相同,结束
				}else{
					String sql = "select id from imagefileref where filename = '"+fileName_new+"' and categoryid = " + categoryid + " and imagefileid <> " +imagefileid;
					rs.executeSql(sql);
					if(rs.next())
					{
						map.put("result", "exist");
					}else{
						boolean flag = privateSeccategoryManager.renameImageFile(user,imagefileid,fileName_new,categoryid,uid);
						if(flag){
							map.put("result", "success");
						}else{
							map.put("result", "fail");
						}
					}
				}
			}else{
				map.put("result", "fail");//根据文件id找不到文件,结束
			}
		}else{
			map.put("result", "fail");
		}
	}
	JSONObject jsonObject = JSONObject.fromObject(map);
	result = jsonObject.toString();
	System.out.println(result);
	out.println(result);
%>
