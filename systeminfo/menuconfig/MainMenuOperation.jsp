
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.systeminfo.menuconfig.MainMenuConfigHandler" %>
<%@ page import="java.util.ArrayList" %>
<%

int systemId = Util.getIntValue(request.getParameter("id"));

String nameString = Util.null2String(request.getParameter("valueT1"));
String valueString = Util.null2String(request.getParameter("valueT2"));
String checkedString = Util.null2String(request.getParameter("checkedString"));
String oldCheckedString = Util.null2String(request.getParameter("oldCheckedString"));
String oldIdString = Util.null2String(request.getParameter("oldIdString"));

String newIdString = "";

int userid=0;
userid=user.getUID();

MainMenuConfigHandler mainMenuConfigHandler = new MainMenuConfigHandler();

int infoId = 0;
int oldId = 0;
int visible = 1;
int oldVisible = 1;

int mViewIndex = 0;
int sViewIndex = 0;
int tViewIndex = 0;

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
            tViewIndex = 0;
            mViewIndex++;

            params = new int[] {userid, infoId, visible, mViewIndex};
            mainMenuConfigHandler.updateMainMenuConfig(params);
        }
        if(id.indexOf("t")!=-1){
            tViewIndex++;

            params = new int[] {userid, infoId, visible, tViewIndex};
            mainMenuConfigHandler.updateMainMenuConfig(params);
        }
        else{
            if(id.indexOf("s")!=-1){
                tViewIndex = 0;
                sViewIndex++;

                params = new int[] {userid, infoId, visible, sViewIndex};
                mainMenuConfigHandler.updateMainMenuConfig(params);
            }
        }
   }

   response.sendRedirect("MainMenuConfig.jsp?id="+systemId+"&saved=true");
%>