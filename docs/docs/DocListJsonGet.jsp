
<%@ page language="java" contentType="application/x-json;charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="org.json.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.docs.category.security.*" %>
<%@ page import="weaver.docs.category.*" %>
<%@ page import="weaver.systeminfo.menuconfig.LeftMenuInfoHandler" %>
<%@ page import="weaver.systeminfo.menuconfig.LeftMenuInfo" %>
<jsp:useBean id="DocDsp" class="weaver.docs.docs.DocDsp" scope="page"/>
<jsp:useBean id="MainCategoryComInfo" class="weaver.docs.category.MainCategoryComInfo" scope="page" />
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<jsp:useBean id="SecCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="UserDefaultManager" class="weaver.docs.tools.UserDefaultManager" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%

	User user = HrmUserVarify.getUser (request , response) ;
	if(user == null)  return ;
	int remainder = Util.getIntValue(request.getParameter("remainder"),0);    
	String type = Util.null2String(request.getParameter("type"));
    ArrayList mainids=new ArrayList();
    ArrayList subids=new ArrayList();
    ArrayList secids=new ArrayList();
 	mainids = (ArrayList) session.getAttribute("mainids");
 	subids  = (ArrayList)  session.getAttribute("subids");
	secids  = (ArrayList)  session.getAttribute("secids");
	int fromAdvancedMenu = Util.getIntValue((String)session.getAttribute("fromAdvancedMenu"),0);
	String isuserdefault = (String)session.getAttribute("isuserdefault");
	String selectArr = (String)session.getAttribute("selectArr");
    int showall = Util.getIntValue((String)session.getAttribute("showall"),0);
	String selectsubid = (String)session.getAttribute("selectsubid");


	JSONObject oJson= new JSONObject();	
	JSONArray children=new JSONArray();
 	
	for(int i=0;i<mainids.size();i++){
		
		String mainid = (String)mainids.get(i);
        String mainname = MainCategoryComInfo.getMainCategoryname(mainid);

		if( i%3 != remainder) continue;//分3列显示
	
        if((fromAdvancedMenu==1 || isuserdefault.equals("2") || (isuserdefault.equals("1") && !"".equals(selectArr))) && selectArr.indexOf("M"+mainid+"|") == -1)
        {
            continue;
        }

		JSONObject child=new JSONObject();	
		
		child.put("draggable",false);
		child.put("leaf",false);		
		child.put("text",mainname);	
		child.put("paras","type=1,xyz=2");
		child.put("iconCls","btn_floder_main");
		child.put("expanded",true);
		
		JSONArray childrenSub=new JSONArray();	
		
		for(int j=0;j<subids.size();j++){

            String subid = (String)subids.get(j);
            String subname = SubCategoryComInfo.getSubCategoryname(subid);
            String curmainid = SubCategoryComInfo.getMainCategoryid(subid);
      
            if(!curmainid.equals(mainid))
                continue;
            
            if((fromAdvancedMenu==1 || isuserdefault.equals("2") || (isuserdefault.equals("1") && !"".equals(selectArr))) && selectArr.indexOf("S"+subid+"|")==-1)
                continue;

			JSONObject childSub=new JSONObject();	
			childSub.put("draggable",false);
			childSub.put("leaf",false);
			childSub.put("text",subname);
			childSub.put("paras","type=1,xyz=2");			
			childSub.put("iconCls","btn_floder_sub");	
			childSub.put("expanded",true);
			
			JSONArray childrenSec=new JSONArray();

			for(int k=0;k<secids.size();k++){ 
                String secid = (String)secids.get(k);
                String secname=SecCategoryComInfo.getSecCategoryname(secid);
                String cursubid = SecCategoryComInfo.getSubCategoryid(secid);
                if(!cursubid.equals(subid)) continue;
				JSONObject childSec=new JSONObject();	
				childSec.put("draggable",false);
				childSec.put("leaf",true);
				childSec.put("text","<A href=\"#\" onClick=\"newDoc("+mainid+","+subid+","+secid+")\">"+secname+"</a>");
				childSec.put("paras","type=33,xyz=44");
				childSec.put("iconCls","btn_floder_sec");
				childrenSec.put(childSec);				
			}						

			childSub.put("children",childrenSec);				
			childrenSub.put(childSub);
		}
		
		child.put("children",childrenSub);	
		children.put(child);	
	}	

	//oJson.put("data",children);
    out.print(children.toString());
%>