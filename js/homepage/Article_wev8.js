var NowImg = 1;
var bStart = 0;
var bStop =0;

function fnToggle() 
{
	var next = NowImg + 1;

	if(next == MaxImg+1) 
	{
		NowImg = MaxImg;
		next = 1;
	}
	if(bStop!=1)
	{

		if(bStart == 0)
		{
			bStart = 1;		
			setTimeout('fnToggle()', 4000);
			return;
		}
		else
		{
			oTransContainer.filters[0].Apply();

			document.images['oDIV'+next].style.display = "";
			document.images['oDIV'+NowImg].style.display = "none"; 

			oTransContainer.filters[0].Play(duration=2);

			if(NowImg == MaxImg) 
				NowImg = 1;
			else
				NowImg++;
		}
		setTimeout('fnToggle()', 5000);
	}
}


function toggleTo(docid,img,obj){	
	try{		
		bStop=1;		
		var newsimgs = jQuery(obj).parents("TABLE").find("#oTransContainer").find("IMG");
		var oDiv = "oDIV_"+docid+"_"+img;
		for(var i=0;i<newsimgs.length;i++){
			if(jQuery(newsimgs[i]).attr("id")==oDiv){
					jQuery(".moreimg_"+docid).hide();
					jQuery("#"+oDiv).parents("TD:first").find("IMG").hide();
					jQuery("#"+oDiv).show();
			}
		}
	}catch(e){
	}

}