
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.systeminfo.menuconfig.LeftMenuConfigHandler" %>
<%@ page import="java.util.ArrayList" %>
<%

String ret = Util.null2String(request.getParameter("ret"));

String nameString = Util.null2String(request.getParameter("valueT1"));
String valueString = Util.null2String(request.getParameter("valueT2"));
String checkedString = Util.null2String(request.getParameter("checkedString"));
String oldCheckedString = Util.null2String(request.getParameter("oldCheckedString"));
String oldIdString = Util.null2String(request.getParameter("oldIdString"));

int userid=0;
userid=user.getUID();

LeftMenuConfigHandler leftMenuConfigHandler = new LeftMenuConfigHandler();

int infoId = 0;
int oldId = 0;
int visible = 1;
int oldVisible = 1;

int mViewIndex = 0;
int sViewIndex = 0;

int[] params;

ArrayList ids = Util.TokenizerString(nameString,",");
ArrayList infoIds = Util.TokenizerString(valueString,",");
ArrayList visibles = Util.TokenizerString(checkedString,",");
ArrayList oldVisibles = Util.TokenizerString(oldCheckedString,",");
ArrayList oldIds = Util.TokenizerString(oldIdString,",");

    for(int i=0;i<ids.size();i++){
        String id = (String)ids.get(i);
        infoId = Util.getIntValue(infoIds.get(i).toString().substring(1));
        oldId = Util.getIntValue(oldIds.get(i).toString());

        visible = Util.getIntValue(visibles.get(i).toString());
        oldVisible = Util.getIntValue(oldVisibles.get(i).toString());

        if(oldId == infoId&&oldVisible == visible){
             continue;
        }

        if(id.indexOf("m")!=-1){
            sViewIndex = 0;
            mViewIndex++;
            params = new int[] {userid, infoId, visible, mViewIndex};
            leftMenuConfigHandler.updateLeftMenuConfig(params);
        }
        if(id.indexOf("s")!=-1){
            sViewIndex++;
            params = new int[] {userid, infoId, visible, sViewIndex};
            leftMenuConfigHandler.updateLeftMenuConfig(params);
        }

   }
   response.sendRedirect("LeftMenuConfig.jsp?saved=true");
%>