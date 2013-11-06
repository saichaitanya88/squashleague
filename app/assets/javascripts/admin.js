function retrieve_player (id){
	$.get( "../players/get_player?id=" + id, function( p ) {
		$("input[id=player_first_name]").val( p.first_name );
		$("input[id=player_last_name]").val( p.last_name );
		$("input[id=player_id]").val( p.id );
	});
};

function retrieve_user (id){
	$.get( "../users/get_user?id=" + id, function( p ) {
		$("input[id=user_name]").val( p.user.name );
		$("input[id=user_id]").val( p.user.id );
		//Set the player_dropdown to p.player.user_id == data-user_id
		if (p.player == undefined){
			$("#user_player")[0][0].selected = true
		}
		else{
			$("option[user_id='" + p.player.user_id + "']")[0].selected = true
		}
	});
};

$(document).ready(function(){
	$("input[type=date]").datepicker();
	
	$("input[type=number]").keypress(function(event){
		var key = window.event ? event.keyCode : event.which;

    if (event.keyCode == 8 || event.keyCode == 46
     || event.keyCode == 37 || event.keyCode == 39) {
        return true;
    }
    else if ( key < 48 || key > 57 ) {
        return false;
    }
    else return true;
	});
	
});
