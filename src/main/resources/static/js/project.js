//Global color theme variable
var colorTheme = null;


// Get color theme
const setColorTheme = (color) => {
		
	// Select the current palatte for display
	// Selectors cannot start with number so:
	if(color == '00a4ed'){
		color = 'blue';
	}
	palatte = document.querySelector(`.${color}`);
	palatte.style.border = '.15vw solid white';
	palatte.style.opacity = '100%'
	
	
	// Set color theme to activeUser's color theme
	if(color == 'blue'){
		color = '00a4ed';
	}
	color = '#' + color;
	document.documentElement.style.setProperty('--colorTheme', color);
	colorTheme = color;
	
}
// Change color theme
const changeColorTheme = (element, color) => {
	const palattes = document.querySelectorAll('.palatte')
	
	// Set user colorTheme
	fetch('/changeColorTheme/'+color, {method : 'POST'})
	
	// Change current DOM color theme
	color = '#' + color;
	document.documentElement.style.setProperty('--colorTheme', color);
	
	// Change selected color on color palatte
	for( const palatte of palattes){
		palatte.style.border = '.15vw solid #211f2a';
		palatte.style.opacity = '50%';
	}
	element.style.border = '.15vw solid white';
	element.style.opacity = '100%'
	
	colorTheme = color;
}

const showConfirmDelete = () => {
	const confirmDelete = document.querySelector(".confirmDelete");
	confirmDelete.style.display = "block";
}

const hideConfirmDelete = () => {
	const confirmDelete = document.querySelector(".confirmDelete");
	confirmDelete.style.display = "none";
}
const showConfirmLeaveTeam = () => {
	const confirmLeaveTeam = document.querySelector(".confirmLeaveTeam");
	confirmLeaveTeam.style.display = "block";
}
const hideConfirmLeaveTeam = () => {
	const confirmLeaveTeam = document.querySelector(".confirmLeaveTeam");
	confirmLeaveTeam.style.display = "none";
}


const showEditName = () => {
	const titleName = document.querySelector(".name");
	titleName.style.display = "none";
	
	const editTitle = document.querySelector(".editName");
	editTitle.style.display = "block";
	
}
const hideEditName = () => {
	const titleName = document.querySelector(".name");
	titleName.style.display = "flex";
	
	const editTitle = document.querySelector(".editName");
	editTitle.style.display = "none";
}
const activateSaveButton = () => {
	const saveButton = document.querySelector(".saveButton");
	saveButton.style.opacity = "100%";
	saveButton.disabled = false;
}

const showEmailInput = () => {
	addEmail = document.querySelector(".addEmail")
	addEmail.style.display = 'block';
}


// Expand add task element
const expandAddTask = () => {
	const addTaskElement = document.querySelector(".addTask");
	const isExpanded = addTaskElement.getAttribute('data-is-expanded');
	const expandButton = document.querySelector('.expandAddTaskButton');

	
	// If element is already expanded, un-expand
	if(isExpanded == 'true'){
		addTaskElement.style.height = '6.65vw';	
		addTaskElement.style.width = '20vw';
		addTaskElement.setAttribute('data-is-expanded', 'false');	
		expandButton.style.transform = 'rotate(0deg)';
	}
	else{
		// else expand element
		addTaskElement.style.height = "40vw";
		addTaskElement.style.width = "35vw";
		
		// change orientation of button
		expandButton.style.transform = 'rotate(45deg)';
		addTaskElement.setAttribute('data-is-expanded', 'true');	
	}	
}

// Add member to project
const addUser = projectId =>  {
	const emailInput = document.querySelector(".emailInput");
	const encodedEmail = encodeURIComponent(emailInput.value);
	const memberFeedback = document.querySelector(".memberFeedback")

	fetch('/getMemberInfoByEmail/' + encodedEmail) //change this to encoded. I think the @ in the email address is messing up java
        .then(res => res.json())
        .then(newMemberInfo => {
			if(newMemberInfo.id == null){
				memberFeedback.innerHTML = "Member not found."
				memberFeedback.style.opacity = "100%";
				
				setTimeout( function() {
					memberFeedback.style.opacity = "10%";
				}, 2000);
			}
			else{
				window.location.href = `/addMember/${projectId}/${encodedEmail}`;
			}
		})
}






// Select user to be assigned the task and add their id to the hidden input value array
const selectUser = (element) => {
	const isSelected = element.getAttribute('data-is-selected');
	const userId = element.getAttribute('data-userId');
	const hiddenInput = document.querySelector('.hiddenInput');
	const assignButton = document.querySelector('.assignButton')
	const currentAssignedUserIds = hiddenInput.value ? hiddenInput.value.split(',') : [];
	const newAssignedUserIds = [];

	// If user wasnt already selected, select them and add their id to the hidden input value array
	if(isSelected == 'false'){
		element.style.backgroundColor = colorTheme;
		element.style.color = '#211f2a';
		element.style.fontSize = '1.5rem';
		element.setAttribute('data-is-selected', "true");
		currentAssignedUserIds.push(userId);
		hiddenInput.value = currentAssignedUserIds;
	}
	// If they were selected, unselect them and remove their id to the hidden input value array
	else{
		element.style.backgroundColor = '#ff860000';
		element.style.color = 'white';
		element.style.fontSize = '1.3rem';
		element.setAttribute('data-is-selected', "false");	
		for(const id of currentAssignedUserIds){
			if(id != userId){
				newAssignedUserIds.push(id);
			}
		}
		hiddenInput.value = newAssignedUserIds;	
	}
	
	// If there are no users assigned to task, disable submit button
	if(hiddenInput.value == ''){
		assignButton.disabled = true;
		assignButton.style.opacity = "50%";
	} else {
		assignButton.disabled = false;
		assignButton.style.opacity = "100%";
	}
}

// Change the isResolved status of task
const changeResolvedStatus = (taskId) => {
	const tasks = document.querySelectorAll(`[data-task-id="${taskId}"]`);
	const isResolved = tasks[0].getAttribute('data-is-resolved');
	const checkmarks = document.querySelectorAll(`[data-checkmark-id="${taskId}"]`);
	const taskCountElement = document.querySelector('.taskCount')
	const taskCountValue = parseInt(taskCountElement.innerHTML, 10);
	
	console.log(taskCountValue)

	// If current status is false, set to true and set new style properties
	if(isResolved == 'false'){
		fetch('/changeResolvedStatus/' + taskId + '/true', {method: 'POST'})
		for(const task of tasks){
			task.setAttribute('data-is-resolved', 'true');
			task.style.opacity = '50%';
			task.querySelector('.instructions').style.textDecoration = 'line-through';
		}
		for(const checkmark of checkmarks){
			checkmark.style.display = 'block';
		}
		
		// Change unresolved task counter
		taskCountElement.innerHTML = taskCountValue - 1;
	}
	else{
		fetch('/changeResolvedStatus/' + taskId + '/false', {method: 'POST'})
		for(const task of tasks){
			task.setAttribute('data-is-resolved', 'false');
			task.style.opacity = '100%';
			task.querySelector('.instructions').style.textDecoration = 'none';
		}	
		for(const checkmark of checkmarks){
			checkmark.style.display = 'none';
		}
		
		// Change unresolved task counter
		taskCountElement.innerHTML = taskCountValue + 1;
	}
}