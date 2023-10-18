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
}

// Expand elements
const expandAddProject = () => {
	const expandButton = document.querySelector('.addProjectButton');
	const addProjectElement = document.querySelector('.addProject')
	const isExpanded = addProjectElement.getAttribute('data-is-expanded');
	const form = document.querySelector(".newProjectForm");
	
	// If element is already expanded, un-expand
	if(isExpanded == 'true'){
		addProjectElement.style.height = '6.65vw';	
		addProjectElement.style.width = '25vw';
		addProjectElement.setAttribute('data-is-expanded', 'false');	
		expandButton.style.transform = 'rotate(0deg)';
		form.style.display = "none";
	}
	else{
		// else expand element
		addProjectElement.style.height = "36vw";
		addProjectElement.style.width = "31vw";
		
		//Display form
		form.style.display = "block";
		
		// change orientation of button
		expandButton.style.transform = 'rotate(45deg)';
		addProjectElement.setAttribute('data-is-expanded', 'true');	
	}	
}

const hideAddProject = element => {
	const isExpanded = element.getAttribute('data-is-expanded');
	const addProjectElement = document.querySelector('.addProject');
	if(isExpanded == "true"){
		addProjectElement.style.height = '6.65vw';	
		addProjectElement.style.width = '25vw';	
		console.log(addProjectElement)
	}
}


const expandProject = (projectId) => {
	const project = document.getElementById(projectId);
	const expandBtn = document.querySelector(`[data-expandBtn-project-id="${projectId}"]`);
	const isExpanded = project.getAttribute("data-is-expanded");
	
	if(isExpanded == "false"){
		project.style.height = "25vw";
		expandBtn.style.transform = "rotate(45deg)";
		project.setAttribute("data-is-expanded", "true");
		setTimeout( () => {
			document.body.style.height = `${document.body.scrollHeight}px`;
		}, 500)
	}
	if(isExpanded == "true"){
		project.style.height = "6.65vw";
		expandBtn.style.transform = "rotate(0deg)";
		project.setAttribute("data-is-expanded", "false");
	}	
}
const showEmailInput = () => {
	addEmail = document.querySelector(".addEmail")
	addEmail.style.opacity = '100';
}

// Find user and add their id to memberIds hidden input
const findUser = () =>  {
	const emailInput = document.querySelector(".emailInput");
	const encodedEmail = encodeURIComponent(emailInput.value);
	const memberFeedback = document.querySelector(".memberFeedback")
	
	// Get the member object by email	
	fetch('/getMemberInfoByEmail/' + encodedEmail) //change this to encoded. I think the @ in the email address is messing up java
        .then(res => res.json())
        .then(newMemberInfo => {
        	const addedMembers = document.querySelector(".addedMembers");
        	const newMemberElement = document.createElement("div");
        	const memberFeedback = document.querySelector(".memberFeedback");
        	
			if(!newMemberInfo.id){
				memberFeedback.innerHTML = "Member not found."
				memberFeedback.style.opacity = "100%";
				
				setTimeout( function() {
					memberFeedback.style.opacity = "10%";
				}, 2000);
				
				return;	
			} else{
				memberFeedback.innerHTML = "Member added."
				memberFeedback.style.opacity = "100%";
				
				setTimeout( function() {
					memberFeedback.style.opacity = "10%";
				}, 2000);
			}
			
        	
        	newMemberElement.className = "member";
        	// Add initials to newly created member div for display
        	newMemberElement.innerHTML = newMemberInfo.initials;
        	// Add the newly created member div to addMembers div
        	addedMembers.appendChild(newMemberElement); 
        	
        	//Add newMember's id to hidden input
        	const hiddenInput = document.querySelector(".currentMemberIdsHiddenInput");
        	const newMemberId = newMemberInfo.id;
        	
        	let currentMemberIds = hiddenInput.value.split(',');
        	// let currentMemberIds = hiddenInput.value ? hiddenInput.value.split(',') : [];
        	currentMemberIds.push(newMemberId);
        	hiddenInput.value = currentMemberIds.join(',');
        	
        	hiddenInput.value = currentMemberIds;
        	
        	// Clear the email input field
            emailInput.value = "";
        })
        .catch(error => {
            console.error('Error:', error);
        });
}

const validateProjectName = projectName => {
	projectNameValidation = document.querySelector(".projectNameValidation");
	createButton = document.querySelector(".createButton");

	if(projectName.length > 0 && projectName.length < 21){
		createButton.disabled = false;
		projectNameValidation.style.opacity = "0%";
		createButton.style.opacity = "100%";
	}
	else{
		createButton.disabled = true;
		projectNameValidation.style.opacity = "100%";
		createButton.style.opacity = "25%";
	}
}


// Change the isResolved status of task
const changeResolvedStatus = (taskId, projectId) => {
	const tasks = document.querySelectorAll(`[data-task-id="${taskId}"]`);
	const isResolved = tasks[0].getAttribute('data-is-resolved');
	const checkmarks = document.querySelectorAll(`[data-checkmark-id="${taskId}"]`);
	const taskCountElement = document.querySelector(`[data-taskcount-element-project-id="${projectId}"]`)
	const taskCountValue = parseInt(taskCountElement.innerHTML, 10);
	
	// If current status is false, set to true and set new style properties
	if(isResolved == 'false'){
		fetch('/changeResolvedStatus/' + taskId + '/true', {method:'POST'})
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
		fetch('/changeResolvedStatus/' + taskId + '/false', {method:'POST'})
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
