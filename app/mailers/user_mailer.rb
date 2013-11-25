class UserMailer < ActionMailer::Base
  default :from => "squashleaguemailer@gmail.com"
  
  def registration_confirmation(user, generated_password, url)
	  @user = user #use this as you would in a controller
	  @generated_password = generated_password
	  @url = url
  	mail(:to => "#{user.name} <#{user.email}>", :subject => "Registered")
  end
  
  def score_update_email(user, match)
  	@user= user
  	@match = match
  	@player1 = Player.find(match.player1_id)
  	@player2 = Player.find(match.player2_id)
  	p1_email = @player1.user.email
  	p2_email = @player2.user.email
  	p1_name = @player1.first_name
  	p2_name = @player2.first_name
		all_email_addresses = "#{p1_email},#{p2_email}"
		admin_users = User.where(:role => "admin")
		admin_emails = ""
		
		#bcc all admins for now
  	admin_users.each do |admin|
  		admin_emails = admin_emails + "#{admin.email},"
  	end
  	
  	admin_emails = admin_emails.chomp
  	puts admin_emails
  	mail(:to => "#{all_email_addresses}", :bcc => "#{admin_emails}", :subject => "SQUASH LEAGUE: #{p1_name}-#{p2_name} Match Scores")
  end
  
  def weekly_update_email(all_past_rounds, incomplete_matches, past_round, next_round, players_league_info_array, email_addresses)
  	  @all_past_rounds = all_past_rounds
  	  @incomplete_matches = incomplete_matches
  	  @past_round = past_round
			@next_round = next_round
			@players_league_info_array = players_league_info_array
			@email_addresses = email_addresses
	  	#mail(:to => "#{all_email_addresses}", :bcc => "#{admin_emails}", :subject => "SQUASH LEAGUE: #{p1_name}-#{p2_name} Match Scores")
	  	mail(:to => "saichaitanya88@gmail.com", :subject => "SQUASH LEAGUE: Weekly Update")
  end
  
end
