<%@ page language="java" contentType="text/html; charset=GBK"%>
<%@ page import="java.net.URLEncoder "%>
<%@ page import="weaver.general.*"%>
<%@ page import="weaver.hrm.*"%>
<%@ page import="net.sf.json.JSONObject"%>
<%@ page import="org.apache.commons.httpclient.HttpClient"%>
<%@ page import="org.apache.commons.httpclient.methods.GetMethod"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="TransUtil" class="weaver.wxinterface.TransUtil" scope="page" />
<% 

	User user = HrmUserVarify.getUser(request, response);
	if (user == null||user.getUID()!=1) {
		return;
	}
	request.setCharacterEncoding("UTF-8");
	int status = 1;String msg = "";
	JSONObject json = new JSONObject();
	String operate = Util.null2String(request.getParameter("operate"));
	String nowtime = TimeUtil.getCurrentTimeString();//当天日期和时间
	try{
		if("getLocation".equals(operate)){//调用百度地图接口获取地理位置的经纬度信息
			String address = Util.null2String(request.getParameter("address"));
			if(!"".equals(address)){
				HttpClient http = new HttpClient();
				String url = "http://api.map.baidu.com/geocoder/v2/?address="+URLEncoder.encode(address,"UTF-8")
						+"&output=json&ak=IG2WvU9byUrBL0gTGI6PWPye";
				GetMethod getMethod = new GetMethod(url); 
				String data = "";
				try{
					http.executeMethod(getMethod);
	  				data = getMethod.getResponseBodyAsString();
				}catch(Exception e){
					e.printStackTrace();
					msg = "调用百度地图接口失败";
				}finally{
					getMethod.releaseConnection();  
				}
				if(!data.equals("")){
					JSONObject jsonData = JSONObject.fromObject(data);
					if(null!=jsonData){
						if(jsonData.getInt("status")==0){
							JSONObject location = jsonData.getJSONObject("result").getJSONObject("location");
							json.put("lat", location.getString("lat"));
							json.put("lng", location.getString("lng"));
							status = 0;
						}else{
							msg = jsonData.getString("msg");
						}
					}else{
						msg = "解析百度地图接口返回数据失败";
					}
				}
			}else{
				msg = "请输入地理位置";
			}
		}else if("addOrUpdateLS".equals(operate)){
			String lsid = Util.null2String(request.getParameter("lsid"));
			String address = Util.null2String(request.getParameter("address"));
			String lng = Util.null2String(request.getParameter("lng"));
			String lat = Util.null2String(request.getParameter("lat"));
			int distance = Util.getIntValue(request.getParameter("distance"),0);
			int resourcetype = Util.getIntValue(request.getParameter("resourcetype"),0);
			int ifforce = Util.getIntValue(request.getParameter("ifforce"),0);
			String resourceids = Util.null2String(request.getParameter("resourceids"));
			if(!"".equals(address)&&!"".equals(lng)&&!"".equals(lat)){
				StringBuffer sql = new StringBuffer();
				if(lsid.equals("")){
					sql.append("insert into WX_LocationSetting (resourceids,resourcetype,address,distance,lat,lng,createtime,ifforce)");
					sql.append(" values ('"+resourceids+"',"+resourcetype+",'"+address+"',"+distance);
					sql.append(",'"+lat+"','"+lng+"','"+nowtime+"',"+ifforce+")");
				}else{
					sql.append("update WX_LocationSetting set resourceids='"+resourceids+"',");
					sql.append("resourcetype="+resourcetype+",address='"+address+"',distance="+distance);
					sql.append(",lat='"+lat+"',lng='"+lng+"',ifforce="+ifforce+" where id = "+lsid);
				}
				rs.execute(sql.toString());
				status = 0;
			}else{
				msg = "相关参数不完整";
			}
		}else if("getLocationSetting".equals(operate)){
			String id = Util.null2String(request.getParameter("id"));
			if(!id.equals("")){
				rs.execute("select * from WX_LocationSetting where id = "+id);
				if(rs.next()){
					json.put("id", id);
					json.put("address", rs.getString("address"));
					json.put("lng", rs.getString("lng"));
					json.put("lat", rs.getString("lat"));
					json.put("distance", rs.getString("distance"));
					json.put("resourcetype", rs.getString("resourcetype"));
					json.put("resourceids", rs.getString("resourceids"));
					json.put("ifforce", Util.getIntValue(rs.getString("ifforce"),0));
					json.put("resourcenames", TransUtil.getResourceNames(Util.null2String(rs.getString("resourcetype")),Util.null2String(rs.getString("resourceids"))));
					status = 0;
				}else{
					msg = "没有查询到相关数据";
				}
			}else{
				msg = "没有获取到ID";
			}
		}else if("delLoactionSetting".equals(operate)){
			String ids = Util.null2String(request.getParameter("ids"));
			if (!"".equals(ids)) {
				String sql = "delete from WX_LocationSetting where id in (" + ids + ")";
				boolean flag = rs.execute(sql);
				if (flag) {
					status = 0;
				} else {
					msg = "执行删除SQL失败";
				}
			} else {
				msg = "相关参数不完整";
			}
		}
	}catch(Exception e){
		e.printStackTrace();
		msg = "程序出现异常，请联系管理员";
	}
	json.put("status", status);
	json.put("msg", msg);
	out.print(json.toString());
%>
