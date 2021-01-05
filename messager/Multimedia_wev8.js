var Multimedia={
	playSound:function(type){
		if(type=="reciveMessage"){
			//Debug.log("playSound", 2);
			var node=document.getElementById("SoundNewMessage");
			if(node!=null) {
				node.Play();
			}
		}
	}
}