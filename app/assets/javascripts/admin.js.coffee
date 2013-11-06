# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


retrieve_player = (id) -> $.get '../players/get_player/'+id, (data) -> 
														$('body').append "Successfully got the page."
