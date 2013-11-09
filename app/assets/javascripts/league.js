function showpane(id){

	//hide all div panes
	//show div pane with matching id

	$('div.tab-pane').hide();
	$('div#'+id).show();
	$('ul.rounds li').removeClass('active')
	$('ul.rounds li#'+id).addClass('active')
};
