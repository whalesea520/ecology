
function showVoting(){
     var voteids = "";//网上调查的id
     var voteshows = "";//网上调查是否弹出
     var forcevotes = "";//网上调查---> 强制调查
	  var title = "";//网上调查的id
     var params ={"ids":"1"};
	  jQuery.ajax({
	         url : "/docs/docs/DocCheckVote.jsp",
	         data :params,
	         dataType : "json",
	         type : "post",
	         success : function(data){
	                    if(data){
	                      voteids=data["voteids"];
						  voteshows=data["voteshows"];
						  forcevotes=data["forcevotes"];
						  title=data["title"];
						  if(voteids !=""){
	                       var arr = voteids.split(",");
	                       var autoshowarr = voteshows.split(",");
	                       var forcevotearr = forcevotes.split(",");
		                   for(i=0;i<arr.length;i++){
		                     //判断是否弹出调查
		                     if(autoshowarr[i] !='' || forcevotearr[i] !=''){//弹出
			                var diag_vote = new Dialog();
				            diag_vote.Width = 960;
				            diag_vote.Height = 800;
				            diag_vote.Modal = false;
				            diag_vote.Title = title;
				            diag_vote.URL = "/voting/VotingPoll.jsp?votingid="+arr[i];
				            if(forcevotearr[i] !=''){//强制调查
				              diag_vote.ShowCloseButton=false; 
				            }
				            diag_vote.show();
			               }
		                 }
	                 }
	               }



	           }
	        });

    
  }

$(document).ready(function(){

	showVoting()//弹出框相关
	//var addButtonKey ="addButton"//模块key
	//var addButtonHtmlStr = '<div  class="plugin_check_div"><div class="leftColor" onclick="signInOrSignOut(jQuery(this).attr(\'_signFlag\'))" style="overflow:hidden;text-overflow:ellipsis;cursor:pointer;" _signflag="1" id="sign_dispan">插件</div><img onclick="jQuery(this).next().trigger(\'click\')" src="/wui/theme/ecology8/page/images/signIn_wev8.png" style="cursor:pointer;"></div>' 
	//generatePluginAreaHtml(addButtonHtmlStr,addButtonKey);//向门户右上角添加按钮

})
