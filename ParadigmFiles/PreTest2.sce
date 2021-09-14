####
# Reversal Learning Task
# v1 -- Created on August 8th, 2019 by Paul Keselman
# v2 -- Modified on September 5th, 2019 by Paul Keselman
#			- Added a fixation cross between trials
#			- Added the ability to change image positions between
#			  ver1: (upper left + lower right) & ver2: (lower left + upper right).
#          the test version is recordded in the saved data file.
#        - Added Instruction screens for PreTest2 and Task
#        - In demo mode, each screen is now advanced with a spacebar
# v3 -- Modified on September 17th, 2019 by Paul Keselman
#        - Changed wording on the PreTest1, PreTest2 and Task instructions
#			- Added confirmation screen after the subject information is entered.
#			  The administrator is also informed if SubjectID, Visit# and Run#
#			  already exists.
#			- Added coin drop animation for correct responses
#        - Added custom logging. Depending on the task the log file will have
#			  the following name:
#					TestPrefix_subjectIDxVisit#_Run#_TestVersion_YYYYMMDDhhmmss.txt
#			  where TestPrefix is either PRLpre1, PRLpre2 or PRL and TestVersion
#          is either ver1 or ver2.
#
#####

### Scenario Parameters ###
no_logfile = true;
active_buttons = 3;
button_codes = 1,2,3; # Left, Right, Spacebar
response_matching = simple_matching; 

default_background_color = 205,205,205;
default_text_color = 0,0,0;
default_font_size = 40;

### Progam Paramters ###

# Edit program paramteres below the line "Begin PCL"

#------------------------------ Begin SDL ------------------------------#
begin;

### Pictures and text objects shared between trial slides ###

bitmap {
	filename = ""; preload = false; # Set in PCL
	width = 200; height = 200;
} Image1;
bitmap {
	filename = ""; preload = false; # Set in PCL
	width = 200; height = 200;
} Image2;
bitmap {
	filename = "Sack_1.jpg"; 
	width = 200; height = 200;
} RewardImage;
bitmap {
	filename = "Coin.png";
	width = 85; height = 85;
	transparent_color = 0,0,0;
} CoinImage;
bitmap {
	filename = ""; preload = false;# Set in PCL
	width = 100; height = 100;
	transparent_color = 255,255,255;
} FeedbackImage;
text {
	caption = "0";
	font_size = 50;
} RewardText;
text {
	caption = "";
	font_size = 50;
} FeedbackText;
line_graphic {
	line_color = 28,46,237;
	line_width = 5;
	coordinates = -110, -110, -110, 110, 110, 110, 110, -110, -110, -110;
} ResponseBox;

picture {
    text {caption = " ";} PromptQuestionText;
    x = 0; y = 200;
    text {caption = " ";} PromptAnswerText;
    x = 0; y = 0;
} PromptPic;

picture {
	bitmap Image1;
	x = 0; y = 0; # Set in PCL
	bitmap Image2;
	x = 0; y = 0; # Set in PCL
} ImagesPic;

picture {
	bitmap RewardImage;
	x = 0; y = 0; # Set in PCL
	text RewardText;
	x = 0; y = 0; # Set in PCL
} RewardPic;

### Trials ###

# Wait
trial {
	trial_duration = 1;
	picture {
		text {
			caption = "Please wait...";
		};
		x = 0; y = 0;
	};
} Wait;

# Ready screen
trial {
	trial_duration = forever;
	trial_type = correct_response;
	
	picture {
		text {
			caption = "Ready (press Spacebar to begin)";
		};
		x = 0; y = 0;
	};
	target_button = 3;
	
} ReadyScreen;

# Instruction screen
trial {
	trial_duration = 1; # set in PCL
	trial_type = fixed;
	
	picture {
		text {
			caption = ""; # set in PCL
		} InstructionsText;
		x = 0; y = 0;
	};
} InstructionsScreen;

# Task
trial { 
	trial_duration = 1; # Set in PCL
	trial_type = first_response;
	
	stimulus_event {
		picture {
			bitmap Image1;
			x = 0; y = 0; # Set in PCL
			bitmap Image2;
			x = 0; y = 0; # Set in PCL
			bitmap RewardImage;
			x = 0; y = 0; # Set in PCL
			text RewardText;
			x = 0; y = 0; # Set in PCL
		} TrialPic;
		target_button = 1;
		response_active = true;
		code = "Trial";
	} TrialEvent;

} Trial;

# Fixation cross
trial {
	trial_duration = 1; # Set in PCL
	trial_type = fixed;
	
	picture {
		text {
			formatted_text = true;
			caption = "<b>+</b>";
			font_size = 80;
		};
		x = 0; y = 0; # Set in PCL
		bitmap RewardImage;
		x = 0; y = 0; # Set in PCL
		text RewardText;
		x = 0; y = 0; # Set in PCL
	} FixationPic;
} Fixation;

# Response feedback
trial {
	trial_duration = 1; # Set in PCL
	trial_type = fixed;
	
	picture {
			bitmap Image1;
			x = 0; y = 0; # Set in PCL
			bitmap Image2;
			x = 0; y = 0; # Set in PCL
			bitmap RewardImage;
			x = 0; y = 0; # Set in PCL
			text RewardText;
			x = 0; y = 0; # Set in PCL
			line_graphic ResponseBox;
			x = 0; y = 0; # Set in PCL	
			#text FeedbackText;
			bitmap FeedbackImage;
			x = 0; y = 0; # Set in PCL
		} FeedbackPic;
		code = "Feedback";
	
} Feedback;

# No responce feedback
trial { 
	trial_duration = 1; # Set in PCL
	trial_type = fixed;
	picture {
		text {
			caption = "Please Respond!";
			font_size = 50;
		} PleaseRespondText;
		x = 0; y = 0;
	};
	code = "PleaseRespond";
} PleaseRespond;

#------------------------------ Begin PCL ------------------------------#
begin_pcl;

### Instructions for Setting Paramters ###
# Experiment Type (Demo, PreTest1, PreTest2, Task)
# Number of blocks
# Number of trials per block (each number must be 3 or greater)
# Feeedback accuracy per block
#   Realistically, when the number of trials is large > 40, this number should be between 0.7 and 0.8,
#   otherwise the criteria placed on the trials make it impossible to generate a "random" array in a
#   reasonable amount of time. Setting the value to 1.0 (no randomness) is ok.
# Pass criteria for each block (number of correct responses in each block to advance to the next block)
#   Ex. 1 - for a pass criteria of 8 out of 10, enter {8,10}
#   Ex. 2 - for a pass creteria of 12 out of 12 (or 12 in a row), enter {12,12}
# Durations [ms]
#   duration for instructions (Not used in Task)
#   maximum duration of each trial
#   duration of the ITI fixation cross 
#   duration of the feedback
#   duration of the "Please Respond" feedback

string experiment_type = "PreTest2";
int num_blocks = 2;
array <int> num_trials[num_blocks] = {50,50};
array <double> feedback_accuracy[num_blocks] = {0.8, 0.8};  	
array <int> pass_criteria[num_blocks][2] = {{12,12},{12,12}};

int instructions_duration = 2500;
int trial_duration = 2500;
int fixation_duration = 1000;
int feedback_duration = 1000;												
int please_respond_duration = 1000;

string version = "ver1"; # ver1 (upper left + lower right) or ver2 (lower left + upper right) image positions

### Program Start -- Do not edit below this line ###

### Initialize varables ###

string input = "";
string subj_id_str = "";
string subj_visit_str = "";
string subj_run_str = "";

# Set input and output folders
string input_images_foldername = stimulus_directory + "\\" + "Pictures";
string output_foldername = stimulus_directory + "\\" + "Data_Files";

# initialize output file and filename
output_file data_file = new output_file;
string output_filename = "";
string output_filename_prefix = "";

# Define object positions
array <int> image1_position[2] = {0, 0}; # set below according to version
array <int> image2_position[2] = {0, 0};  # set below according to version
array <int> feedback_text_position[2] = {0, 0};  # set below according to version
array <int> fixation_position[2] = {-200, 0};
array <int> reward_bag_position[2] = {400, -200};
array <int> reward_text_position[2] = {400, -220};

### Subroutines ###

# Subroutine to collect subject info
sub collect_subj_info
begin
	system_keyboard.set_delimiter('\n');
	system_keyboard.set_max_length(5);

	# Collect Subject ID
	PromptQuestionText.set_caption("Subject ID (5000 - 6000):"); 
	PromptQuestionText.redraw();

	loop until false begin
		input = system_keyboard.get_input(PromptPic, PromptAnswerText);

		if (int(input) >= 1 && int(input) <= 50000) then
			subj_id_str = input;
			break;
		end;
	end;

	# Collect Subject Visit
	PromptQuestionText.set_caption("Visit (1 - 100):"); 
	PromptQuestionText.redraw();
	
	loop until false begin
		input = system_keyboard.get_input(PromptPic, PromptAnswerText);

		if (int(input) >= 1 && int(input) <= 100) then
			subj_visit_str = input;
			break;
		end;
	end;
	
	# Collect Subject Run
	PromptQuestionText.set_caption("Run (1 - 10):"); 
	PromptQuestionText.redraw();
	
	loop until false begin
		input = system_keyboard.get_input(PromptPic, PromptAnswerText);

		if (int(input) >= 1 && int(input) <= 10) then
			subj_run_str = input;
			break;
		end;
	end;

end;

# Subroutine to check if subject already exists
sub bool check_data_files
begin
	
	bool subj_data_accepted = true;
	string entered_subj_info = output_filename_prefix + "_" + subj_id_str + "x" + subj_visit_str + "_" + subj_run_str;
	string str = "";

	array<string> data_files[0];
	get_directory_files(output_foldername, data_files);
	loop 
		int ii=1; 
		string filename;
		array<string> fileparts_arr[0]; 
		string existing_subj_info = "" ;
	until ii > data_files.count()
	begin
		filename = data_files[ii];
		filename.split("\\", fileparts_arr);
		filename = fileparts_arr[fileparts_arr.count()];
		filename.split("_", fileparts_arr);
		# Look at (prefix)_(subjectidxvisit#)_(run#)
		existing_subj_info = fileparts_arr[1] + "_" + fileparts_arr[2] + "_" + fileparts_arr[3];
		if existing_subj_info == entered_subj_info then
			subj_data_accepted = false;
			break;
		end;
		ii = ii + 1;
	end;
	
	system_keyboard.set_delimiter('\n');
	system_keyboard.set_max_length(1);
	
	if !subj_data_accepted then
		str = "The following subject data already exists!\n\n"; 
	else
		str = "You have entered:\n\n";		
	end;
	str = str + "    Subject ID: " + subj_id_str + "\n" +
					"    Visit: " + subj_visit_str + "\n" + 
					"    Run: " + subj_run_str + "\n\n\n" +
					"Press 'y' to continue or 'n' to re-enter information.";
	PromptQuestionText.set_caption(str);
	PromptQuestionText.set_align(PromptQuestionText.ALIGN_LEFT);
	PromptPic.set_part_y(1, -30);
	PromptQuestionText.redraw();
	
	loop until false begin
		input = system_keyboard.get_input(PromptPic, PromptAnswerText);
		
		if input == "y" then
			subj_data_accepted = true;
			break;
		elseif input == "n" then
			subj_data_accepted = false;
			break;
		end;
	end;
	
	# Reset text position
	PromptPic.set_part_y(1, 200);
	
	return subj_data_accepted;
	
end;

# Subroutine to confirm subject info


# Subroutine to add all elements of an array btw the specified indicies
sub int int_sum( array<int,1>& arr, int start_idx, int end_idx ) begin
    int sum = 0;

	if start_idx > arr.count() then
		start_idx = arr.count();
	end;
	
	if end_idx > arr.count() then
		end_idx = arr.count();
	end;

   loop int i = start_idx; until i > end_idx
   begin
		sum = sum + arr[i];
      i = i + 1;
   end;
   return sum
end;

# Subroutine to generate the feedback array (w/ accuracy defined by acc) of size n for block b.
sub array <int,1> gen_trial_feedback_array(int arr_size, double acc, int b) begin
	
	# Initialize array	
	array <int> arr[0];
	int n = arr_size;
	
	# If acc = 1, arr is all 1s
	if acc == 1 then
		arr.resize(arr_size);
		arr.fill(1, arr_size, 1, 0);
		return arr;
	end;
	
	# Generate array satisfying certain conditions
	loop bool pass_fail = false; until pass_fail
	begin
		
		# Reset the array and pass_fail variable
		arr.resize(0);
		pass_fail = true;
		
		# Set the first 3 elements to 1
		if arr_size >= 3 then
			arr.add(1);
			arr.add(1);
			arr.add(1); 
		end;
		n = arr_size - 3;
		
		# Set the 4th element to 0 (Only if b = 2)
		if arr_size >= 4 && b == 2 then
			arr.add(0);
			n = n - 1;
		end;

		# Generate the rest of the array of 1s (80%) and 0s (20%)
		loop int i = 1; double rand; until i > n
		begin
			rand = random();
			if rand < acc then
				arr.add(1);
			else
				arr.add(0);
			end;
			i = i + 1;
		end;
	
		# Check if there are exactly 2 0s in the first 10 elements
		if arr.count() >= 10 then
			if int_sum(arr, 1, 10) != 8 then
				pass_fail = false;
			end;
		end;

		loop int i = 1; until !pass_fail || i > arr.count()
		begin
			
			# Check that there are no consecutive 0s
			if i >= 2 then
				if arr[i-1] == 0 && arr[i] == 0 then
					pass_fail = false;
				end;
			end;
		
			# Check that there are no more than 5 consecutive 1s
			if i >= 6 then
				if arr[i-5] == 1 && arr[i-4] == 1 && arr[i-3] == 1 && arr[i-2] == 1 && arr[i-1] == 1 && arr[i] == 1 then
					pass_fail = false;
				end;
			end;
		
			# Check if in a set of 7 elements there are no more than 2 0s
			if i >= 7 then
				if int_sum(arr, i-6, i) < 5 then
					pass_fail = false;
				end;
			end;
		
			# Check if in a set of 16 elements there are between 11 and 13 1s
			if i >= 16 then
				if int_sum(arr, i-15, i) < 11 || int_sum(arr, i-15, i) > 13 then
					pass_fail = false;
				end;
			end;
		
			i = i + 1;
		end;
						
	end;
	
	return arr;
end;

# Subroutine to choose a random picture from a folder
sub set_random_image(string foldername) begin
	array <string> image_filenames[0];
	get_directory_files(foldername, image_filenames);
	image_filenames.shuffle();
	Image1.set_filename(image_filenames[1]);
	Image2.set_filename(image_filenames[1]);
	Image1.load();
	Image2.load();
end;

# Subroutine to choose target_button (1 or 2)
sub int set_random_side begin
	double rand = random();
	int side = 0;
	
	if rand < 0.5 then
		side = 1;
	else
		side = 2;
	end;
	return side;
end;

# Subroutine to set feedback text
sub set_feedback_text(int hit_miss, int score) begin 
	
	if hit_miss == 1 then
		FeedbackImage.set_filename("GreenCheckmark.png");
	else
		FeedbackImage.set_filename("RedX.png");
	end;
	FeedbackImage.load();
	
	RewardText.set_caption(string(score));
	RewardText.redraw();
	
end;

# Subroutine to set feedback side (1 - upper left, 2 - lower right)
sub set_feedback_side(int side) begin
	
	if side == 1 then
		FeedbackPic.set_part_x(5, image1_position[1]);
		FeedbackPic.set_part_y(5, image1_position[2]);
	elseif side == 2 then
		FeedbackPic.set_part_x(5, image2_position[1]);
		FeedbackPic.set_part_y(5, image2_position[2]);
	end;
	
end;

# Subroutine to reverse side
sub int reverse_side(int side) begin

	int new_side = 0;
	if side == 1 then
		new_side = 2;
	elseif side == 2 then
		new_side = 1;
	end;
	return new_side;
	
end;

# Subroutine to write last response to the log file
sub log_data(int trial_num, int block_num, string trial_type, int feedbk_acc, int target_pos, stimulus_data stm_data) begin
	
	string resp_type = "";
	if stm_data.type() == stimulus_hit then
		resp_type = "correct";
	elseif stm_data.type() == stimulus_incorrect then
		resp_type = "incorrect";
	elseif stm_data.type() == stimulus_miss then
		resp_type = "miss";
	end;
	
	string feedbk_type = "";
	if  feedbk_acc == 1 then
		feedbk_type = "acc";
	elseif feedbk_acc == 0 then
		feedbk_type = "inacc";
	end;

	data_file.open_append(output_filename);
	# print data, subjID, Visit#, run# and test version
	data_file.print(date_time("yyyymmdd") + "\t" + subj_id_str + "\t" + subj_visit_str + "\t" + subj_run_str + "\t" + version + "\t");
	# print trial#, trial type, feedback given (1 or 0)
	data_file.print(string(trial_num) + "\t" + trial_type + "\t" + feedbk_type + "\t");
	# print target position, user response, response accuracy
	data_file.print(string(target_pos) + "\t" + string(stm_data.button()) + "\t" + resp_type + "\t");
	# print reaction time, test_version (image locations)
	data_file.print(string(stm_data.reaction_time()) + "\n");
	data_file.close();

end;

# Subroutine for coin drop feedback
sub coin_drop_feedback(int duration) begin
	int tic = 0;
	int toc = 0;
	int start_pos_y = reward_bag_position[2] + 200;
	int move_dist = 4;

	tic = clock.time();
	Feedback.set_duration(1);
	FeedbackPic.add_part(CoinImage, reward_bag_position[1], start_pos_y);
		loop int ii = 1; until ii > 25 
	begin
		FeedbackPic.set_part_y(7, start_pos_y - ii*move_dist);
		Feedback.present();
		ii = ii + 1;
	end;
	FeedbackPic.remove_part(7);
	toc = clock.time() - tic;

	if duration - toc > 0 then
		Feedback.set_duration(duration - toc);
	else
		Feedback.set_duration(forever);
	end;
	
	Feedback.present();
	Feedback.set_duration(duration);
end;

# Subroutine to present the demonstration video
sub present_demo begin
	
	# Disable buttons
	response_manager.set_button_active(1, false);
	response_manager.set_button_active(2, false);
	
	# Set durations and type
	InstructionsScreen.set_duration(forever);
	InstructionsScreen.set_type(first_response);
	Trial.set_duration(forever);
	Trial.set_type(first_response);
	Fixation.set_duration(forever);
	Fixation.set_type(first_response);
	Feedback.set_duration(forever);
	Feedback.set_type(first_response);
	
	# reset the trial parameters
	int side = set_random_side();
	set_feedback_side(side);
	set_random_image(input_images_foldername);
	set_feedback_text(1,0);
	
	# Present 1st trial
	InstructionsText.set_caption("Choose the animal in the correct location");
	InstructionsText.redraw();
	InstructionsScreen.present();
	Trial.present();
	set_feedback_text(1, 10); # correct feedback, score of +10
	coin_drop_feedback(forever);
	Fixation.present();
	
	# Present 2nd trial
	InstructionsText.set_caption("Continue choosing the animal in the correct location");
	InstructionsText.redraw();
	InstructionsScreen.present();
	Trial.present();
	set_feedback_text(1, 20); # correct feedback, score increases to +20
	coin_drop_feedback(forever);
	Fixation.present();
	
	# Present 3rd trial
	side = reverse_side(side); 
	set_feedback_side(side);
	InstructionsScreen.present();
	Trial.present();
	set_feedback_text(0, 20); # incorrect feedback, score remains at +20
	Feedback.present();
	Fixation.present();
	
	# Present 4th trial
	side = reverse_side(side);
	set_feedback_side(side);
	InstructionsScreen.present();
	Trial.present();
	set_feedback_text(1, 30); # correct feedback, score increases to +30
	coin_drop_feedback(forever);
	
	# Re-enable buttons
	response_manager.set_button_active(1, true);
	response_manager.set_button_active(2, true);
	
end;

sub present_pretest2_demo(int side) begin

	# reset buttons
	response_manager.set_button_active(1, false);
	response_manager.set_button_active(2, false);
	response_manager.set_button_active(3, true);
	
	# set Trial duration
	InstructionsScreen.set_duration(forever);
	InstructionsScreen.set_type(first_response);
	Trial.set_duration(forever);
	Trial.set_type(first_response);
	Fixation.set_duration(forever);
	Fixation.set_type(first_response);
	Feedback.set_duration(forever);
	Feedback.set_type(first_response);
	
	# Present Instructions
	InstructionsText.set_caption("Let's review. Please watch the following.");
	InstructionsText.redraw();
	InstructionsScreen.present();
	
	# reset the score
	set_feedback_text(1,0);
	
	# Set side (passed into the subroutine)
	set_feedback_side(side);

	## Present Trial 1
	Trial.present();	
	set_feedback_text(1, 10); # Correct, increment score to 10 points
	coin_drop_feedback(forever);
	InstructionsText.set_caption("I got points! I want to get as many points as possible.\nLet's me try that animal again.");
	InstructionsText.redraw();
	InstructionsScreen.present();
	Fixation.present();
	
	## Present Trial 2
	Trial.present();
	set_feedback_text(1, 20); # Correct, increment score to 20 points
	coin_drop_feedback(forever);
	InstructionsText.set_caption("More points! Let's try that animal again.");
	InstructionsText.redraw();
	InstructionsScreen.present();
	Fixation.present();
	
	## Present Trial 3
	Trial.present();
	set_feedback_text(0, 20); # Incorrect, score remains at 20 points
	Feedback.present();
	InstructionsText.set_caption("I didn’t get points this time.\nThe correct location is USUALLY correct.\nLet's try the other location.");
	InstructionsText.redraw();
	InstructionsScreen.present();
	Fixation.present();
	
	## Present Trial 4
	side = reverse_side(side); 
	set_feedback_side(side);
	Trial.present();
	set_feedback_text(0, 20); # Incorrect, score remains at 20 points
	Feedback.present();
	InstructionsText.set_caption("Still no points.\nLet's go back to the location that gave me more points.");
	InstructionsText.redraw();
	InstructionsScreen.present();
	Fixation.present();
	
	## Present Trial 5
	side = reverse_side(side); 
	set_feedback_side(side);
	Trial.present();
	set_feedback_text(1, 30); # Correct, increment score to 30 points
	coin_drop_feedback(forever);
	InstructionsText.set_caption("I got points! Let's pick this location again.");
	InstructionsText.redraw();
	InstructionsScreen.present();
	Fixation.present();
	
	## Present Trial 6
	Trial.present();
	set_feedback_text(1, 40); # Correct, increment score to 40 points
	coin_drop_feedback(forever);
	InstructionsText.set_caption("I got points! Let's pick this location again.");
	InstructionsText.redraw();
	InstructionsScreen.present();
	Fixation.present();
	
	## Present Trial 7
	Trial.present();
	set_feedback_text(1, 50); # Correct, increment score to 40 points
	coin_drop_feedback(forever);
	InstructionsText.set_caption("I got points! Let's pick this location again.");
	InstructionsText.redraw();
	InstructionsScreen.present();
	Fixation.present();
	
	## Present Trial 8
	Trial.present();
	set_feedback_text(0, 50); # Incorrect, score remains at 50 points
	Feedback.present();
	InstructionsText.set_caption("I didn’t get points this time.\nThe correct location is USUALLY correct.\nLet's try the same location again.");
	InstructionsText.redraw();
	InstructionsScreen.present();
	Fixation.present();
	
	## Present Trial 9
	Trial.present();
	set_feedback_text(1, 60); # Correct, increment score to 60 points
	coin_drop_feedback(forever);
	
	## Present Instructions
	InstructionsText.set_caption("Now you try");
	InstructionsText.redraw();
	InstructionsScreen.present();
	
	# Reset Trial duration
	InstructionsScreen.set_duration(instructions_duration);
	InstructionsScreen.set_type(fixed);
	Trial.set_duration(trial_duration);
	Trial.set_type(first_response);
	Fixation.set_duration(fixation_duration);
	Fixation.set_type(fixed);
	Feedback.set_duration(feedback_duration);
	Feedback.set_type(fixed);
	
	# Re-enable response buttons
	response_manager.set_button_active(1, true);
	response_manager.set_button_active(2, true);
	response_manager.set_button_active(3, false);
	
	# Reset score feedback text
	set_feedback_text(1, 0);
	
end;

# Subroutine to present Task
sub present_task begin
	
	# Initialize variables
	int score = 0;
	int trial_target_button = 0;

	# Determine the feedback accuracy arrays (this migh take a few seconds)
	Wait.present();
	array <int> arr[0];
	array <int> feedback_accuracy_array[0][0];
	loop int b = 1; until b > num_blocks
	begin
		arr.resize(num_trials[b]);
		arr = gen_trial_feedback_array(num_trials[b], feedback_accuracy[b], b);
		feedback_accuracy_array.add(arr);
		b = b + 1;
	end;
	ReadyScreen.present();
	response_manager.set_button_active(3, false);

	# Set slide durations
	InstructionsScreen.set_duration(instructions_duration);
	Fixation.set_duration(fixation_duration);
	Trial.set_duration(trial_duration);
	Feedback.set_duration(feedback_duration);
	PleaseRespond.set_duration(please_respond_duration);

	# Randomly choose a picture for the experiment
	set_random_image(input_images_foldername);

	# Start block loop
	loop 
		int b = 1;
		string trial_type = "";
		array <int> resp_arr[0];
		bool pass_criteria_reached = false;
	until b > num_blocks
	begin
	
		term.print("Starting block #: ");
		term.print_line(b);
		
		# Reset pass criteria
		pass_criteria_reached = false;
	
		# Set trial_target_button. Reverse side for block 2, unless running PreTest2.
		if b == 1 then
			trial_target_button = set_random_side();
			trial_type = "acquisition";
		else
			if experiment_type != "PreTest2" then
				trial_target_button = reverse_side(trial_target_button);
				trial_type = "reversal";
			end;
		end;
		TrialEvent.set_target_button(trial_target_button);
	
		# Initialize response array
		resp_arr.resize(num_trials[b]);
		resp_arr.fill(1, num_trials[b], 0, 0);
		
		# Present Instructions
		if b == 1 then
			if experiment_type == "PreTest1" then
				InstructionsText.set_caption("Choose the animal in the correct location");
			elseif experiment_type == "PreTest2" then
				InstructionsText.set_caption("Choose the animal USUALLY in the correct location");
			elseif experiment_type == "Task" then
				InstructionsText.set_caption("Choose the animal USUALLY in the correct location");
			end;
			InstructionsText.redraw();
			InstructionsScreen.present();
		end;
		
		# Loop through the trials
		loop int t = 1; until t > num_trials[b]
		begin

			# Present trial
			Trial.present();

			# Check the response
			stimulus_data last = stimulus_manager.last_stimulus_data();
		
			# Present feedback
			if last.type() == stimulus_miss then
				PleaseRespond.present();
			else
				# Highlight the picture corresponding to the response
				set_feedback_side(last.button());
			
				# record response (set to 0 initially)
				if last.type() == stimulus_hit then
					resp_arr[t] = 1;
				end;
			
				# Display feedback and award points
				if last.type() == stimulus_hit && feedback_accuracy_array[b][t] == 1 then
					score = score + 10;
					set_feedback_text(1, score);
					coin_drop_feedback(feedback_duration);
				else
					set_feedback_text(0, score);
					Feedback.present();
				end;
			
				# Present Fixation cross
				Fixation.present();
			end;
			
			# Log data
			log_data(t, b, trial_type, feedback_accuracy_array[b][t], trial_target_button, last);
		
			# Decide whether to end the block
			if t >= pass_criteria[b][2] then
				if int_sum(resp_arr, t - pass_criteria[b][2] + 1, t) >= pass_criteria[b][1] then
					term.print("Pass criterial reached at trial #: ");
					term.print_line(t);
					t = num_trials[b];
					pass_criteria_reached = true;
				end;
			end;
			
			# Repeat the trial if there was no response
			if last.type() == stimulus_miss then
				t = t - 1;
			end;
		
			t = t + 1;
		end;
	
		# For PreTest2 decide whether to present a demonstration after block 1 and repeat
		if experiment_type == "PreTest2" && b == 1 then
			if !pass_criteria_reached then
				present_pretest2_demo(trial_target_button);
				# Reset score
				score = 0;
				set_feedback_text(1, score);
			else
				b = num_blocks;
			end;
		end;
		
		b = b + 1;
	
	end;

	# Present final instructions. Pressing any response button or spacebar will exit the experiment.
	response_manager.set_button_active(3, true);
	InstructionsScreen.set_duration(forever);
	InstructionsScreen.set_type(first_response);
	InstructionsText.set_caption("End");
	InstructionsText.redraw();
	InstructionsScreen.present();
	
end;

### Start ###

# Set Image locations
if version == "ver1" then
	image1_position = {-400, 200};
	image2_position = {0, -200};
	feedback_text_position = {0, 200};
elseif version == "ver2" then
	image1_position = {-400, -200};
	image2_position = {0, 200};
	feedback_text_position = {0, -200};
else
	term.print_line("Undefined Test Version. Must be ver1 or ver2.");
	exit();
end;

# Set positions for Trial trial
TrialPic.set_part_x(1, image1_position[1]);
TrialPic.set_part_y(1, image1_position[2]);
TrialPic.set_part_x(2, image2_position[1]);
TrialPic.set_part_y(2, image2_position[2]);
TrialPic.set_part_x(3, reward_bag_position[1]);
TrialPic.set_part_y(3, reward_bag_position[2]);
TrialPic.set_part_x(4, reward_text_position[1]);
TrialPic.set_part_y(4, reward_text_position[2]);

# Set positions for Fixation trial
FixationPic.set_part_x(1, fixation_position[1]);
FixationPic.set_part_y(1, fixation_position[2]);
FixationPic.set_part_x(2, reward_bag_position[1]);
FixationPic.set_part_y(2, reward_bag_position[2]);
FixationPic.set_part_x(3, reward_text_position[1]);
FixationPic.set_part_y(3, reward_text_position[2]);

# Set positions for Feedback trial
FeedbackPic.set_part_x(1, image1_position[1]);
FeedbackPic.set_part_y(1, image1_position[2]);
FeedbackPic.set_part_x(2, image2_position[1]);
FeedbackPic.set_part_y(2, image2_position[2]);
FeedbackPic.set_part_x(3, reward_bag_position[1]);
FeedbackPic.set_part_y(3, reward_bag_position[2]);
FeedbackPic.set_part_x(4, reward_text_position[1]);
FeedbackPic.set_part_y(4, reward_text_position[2]);
FeedbackPic.set_part_x(6, feedback_text_position[1]);
FeedbackPic.set_part_y(6, feedback_text_position[2]);

# Set output filename
if experiment_type == "PreTest1" then
	output_filename_prefix = "PRLpre1";
elseif experiment_type == "PreTest2" then
	output_filename_prefix = "PRLpre2";
elseif experiment_type == "Task" then
	output_filename_prefix = "PRL";
end;

# Collect Subject Info
bool subj_data_accepted = false;
string temp_prefix = "";
loop until subj_data_accepted begin
	collect_subj_info();
	
	subj_data_accepted = check_data_files();
end;

# Create a data_file
if experiment_type == "PreTest1" || experiment_type == "PreTest2" || experiment_type == "Task" then
	output_filename = output_foldername + "\\" + output_filename_prefix + "_" + subj_id_str + "x" + subj_visit_str + "_";
	output_filename = output_filename + subj_run_str + "_" + version + "_" + date_time("yyyymmddhhnnss") + ".txt";

	data_file.open(output_filename);
	data_file.print("Date" + "\t" + "SubjectID" + "\t" + "Visit#" + "\t" + "Run#" + "\t" + "TestVersion" + "\t");
	data_file.print("Trial#" + "\t" + "TrialType" + "\t" + "Feedback" + "\t" + "TargetPosition" + "\t");
	data_file.print("Response" + "\t" + "Correct" + "\t" + "ResponseTime" + "\n");
	data_file.close();
end;

# Run Experiment
if experiment_type == "Demo" then
	present_demo();
elseif experiment_type == "PreTest1" then
	present_task();
elseif experiment_type == "PreTest2" then
	present_task();
elseif experiment_type == "Task" then
	present_task();
end;
