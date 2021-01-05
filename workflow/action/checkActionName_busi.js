function checkActionName(actionType,actionName,actionId){
var flag=true;
          $.ajax({
             type: "post",
             async: false,
             url: "/workflow/action/checkActionName.jsp",
             data: {actionType:actionType, actionName:actionName,actionId:actionId},
             dataType: "json",
             success: function(data){
  						if('false'==data.flag)
                    flag=false;
                      }
         });
         return flag;
}