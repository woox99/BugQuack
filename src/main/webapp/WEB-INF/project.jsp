<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- c:out ; c:forEach etc. --> 
<%@ taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core" %>
<!-- Formatting (dates) --> 
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"  %>
<!-- form:form -->
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!-- for rendering errors on PUT routes -->
<%@ page isErrorPage="true" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Bug Quack | ${project.name }</title>
<link rel="stylesheet" type="text/css" href="/css/global.css">
<link rel="stylesheet" type="text/css" href="/css/project.css">
<script type="text/javascript" src="/js/project.js"></script>
</head>
<body onload="setColorTheme(`${activeUser.colorTheme}`)">
	
	<div class="nav">
		<div class="title">
			<img src="/assets/bug.png" alt="" />
			<p>Bug Quack</p>
		</div>
		<div class="colorPalette">
				<div class="orange palatte ff8600" onClick="changeColorTheme(this, 'ff8600')"></div>
				<div class="yellow palatte ffc41b" onClick="changeColorTheme(this, 'ffc41b')"></div>
				<div class="blue palatte 00a4ed" onClick="changeColorTheme(this, '00a4ed')"></div>
				<div class="purple palatte c300ff" onClick="changeColorTheme(this, 'c300ff')"></div>
		</div>
		<div class="links">
			<a href="/dashboard">${activeUser.initials }</a>
			<a class="logout" href="/logout">
				<img src="/assets/logout.png" alt="" />
			</a>
		</div>
	</div>
	
	
	
	<div class="container">
		<div class="projectTitle">
			<div class="name">
				<p class="projectName">${project.name }</p>
				<c:if test="${activeUser.id == project.owner.id }">
					<div class="icon" onclick="showEditName()">
						<img src="/assets/edit.png" alt="" />
					</div>
					<div class="icon" onClick="showConfirmDelete()">
						<img src="/assets/delete.png" alt="" onClick="showConfirmDelete()" />
					</div>
				</c:if>
				<c:if test="${activeUser.id != project.owner.id }">
					<div class="icon" onClick="showConfirmLeaveTeam()">
						<img src="/assets/delete.png" alt="" class="delete" />
					</div>
				</c:if>
			</div>
			<div class="editName">
				<form action="/editProject/${project.id }" method="post">
					<input class="editNameInput" type="text" name="projectName" value="${project.name }" onInput="activateSaveButton()"/>
					<button class="saveButton" type="submit" disabled="true" >Save</button>
					<button type="button" onClick="hideEditName()">Cancel</button>
				</form>
			</div>
			<div class="confirmDelete">
				<div class="confirmDeleteAlert">
					<p class="warning">Are you sure you want to delete?</p>
					<p style="font-size: 0.8rem;">This project will be deleted for all members in the team.</p>
					<p style="font-size: 0.8rem;">These actions cannot be undone.</p>
					<div class="buttons">
						<a href="/deleteProject/${project.id }">Delete</a>
						<button onClick="hideConfirmDelete()">Cancel</button>
					</div>
				</div>
			</div>
			<div class="confirmLeaveTeam">
				<div class="confirmLeaveTeamAlert">
					<p class="warning">Are you sure you want to leave the ${project.name } team?</p>
					<div class="buttons">
						<a href="/removeMember/${project.id }">Leave</a>
						<button onClick="hideConfirmLeaveTeam()">Cancel</button>
					</div>
				</div>
			</div>
		</div>
		<p class="projectStamp">Last updated by ${project.updatedBy } ${project.updatedAtString }
		</p>
		
		
		
		<div class="team card">
			<div class="teamContents">
				<p class="title">Team</p>
				<div class="members">
					<c:forEach var="member" items="${project.team }">
						<c:if test="${member == project.owner }">
							<div class="member owner">${member.initials }</div>
						</c:if>
						<c:if test="${member != project.owner }">
							<div class="member">${member.initials }</div>
						</c:if>
					</c:forEach>
					<div class="addMember" onclick="showEmailInput();">
						<img src="/assets/add.png" alt="" />
					</div>
				</div>
			</div>
		</div>
		
		
		<div class="addEmail" style="display:none;">
			<p class="memberFeedback">Enter member's email.</p>
			<input class="emailInput" name="memberEmail" type="email" value="bugquack@gmail.com" />
			<button type="submit" class="addUserButton"  onClick="addUser(${project.id})">
				<img src="/assets/add.png" alt="" />
			</button>
		</div>
		
		
		
		<div class="addTask card" data-is-expanded="false">
			<form action="/createTask/${project.id }" method="post">
				<div class="title">
					<div class="circleLink" onClick="expandAddTask()">
						<img class="expandAddTaskButton" src="/assets/add.png" alt="" />
					</div>
					<p>New Task</p>
				</div>
				<p class="membersText">Select members to assigned the task:</p>
				<div class="members">
					<c:if test="${project.team.size() == 1}">
						<div class="member owner" data-is-selected="false">${activeUser.initials }</div>
						<input type="hidden" name="assignedUserIds" value="${activeUser.id }"  />
					</c:if>
					<c:if test="${project.team.size() > 1 }">
						<c:forEach var="member" items="${project.team }">
							<div class="member" data-is-selected="false" data-userId="${member.id }" onClick="selectUser(this)">${member.initials }</div>
						</c:forEach>
						<!-- selected members id's will get written to hidden input value -->
						<input type="hidden" class="hiddenInput" name="assignedUserIds" value=""  />
					</c:if>
				</div>
				<p class="instructionsText">Instructions:</p>
				<textarea class="instructionsInput" name="instructions"></textarea>
				<div class="buttons">
					<c:if test="${project.team.size() == 1}">
						<button type="submit" class="assignButton">Assign</button>					
					</c:if>
					<c:if test="${project.team.size() > 1}">
						<button style="opacity:50%;" type="submit" class="assignButton" disabled="true">Assign</button>					
					</c:if>
				</div>
			</form>
		</div>
	
		
		<!-- Your Tasks -->
		<div class="yourTasks card">
			<div class="title">
				<p>Your Tasks</p>
				<div class="getTaskCount">
					<p class="taskCount">${activeUserUnresolvedTasks.size() }</p>
					<img src="/assets/alert.png" alt="" />
				</div>
			</div>
			<div class="tasks" >
					<c:forEach var="task" items="${activeUserUnresolvedTasks }">
						<div class="taskWrapper">
							<div class="task" data-is-resolved="${task.isResolved }" data-task-id="${task.id }" onClick="changeResolvedStatus(${task.id})">
								<div class="taskContents">
									<div class="checkbox">
										<img style="display:none" src="/assets/check.png" alt="" data-checkmark-id="${task.id }"  />
									</div>
									<div>
										<p class="instructions">${task.instructions }</p>
										<div class="stamp">
											<p>Created by ${task.creator.firstName } ${task.creator.lastName} ${task.updatedAtString }</p>									
										</div>
									</div>
								</div>
							</div>
						</div>
					</c:forEach>
					<c:forEach var="task" items="${activeUserResolvedTasks }">
						<div class="taskWrapper">
							<div class="task resolved" data-is-resolved="${task.isResolved }" data-task-id="${task.id }" onClick="changeResolvedStatus(${task.id})">
								<div class="taskContents">
									<div class="checkbox" >
										<img src="/assets/check.png" alt="" data-checkmark-id="${task.id }"  />
									</div>
									<div>
										<p class="instructions">${task.instructions }</p>
										<div class="stamp">
											<p style="font-size:10px;">Marked resolved by ${task.markedResolvedBy } ${task.updatedAtString } </p>				
										</div>
									</div>
								</div>
							</div>
						</div>
					</c:forEach>
			</div>
		</div>
		
		
		
		<!-- Team Tasks -->
		<div class="teamTasks card">
			<div class="title">
				<p>Team Tasks</p>
			</div>
			<div class="tasks" >
				<c:forEach var="task" items="${teamUnresolvedTasks }">
					<div class="taskWrapper">
						<div class="task" data-is-resolved="${task.isResolved }" data-task-id="${task.id }">
							<div class="taskContents">
								<div class="checkbox" onClick="changeResolvedStatus(${task.id})">
									<img style="display:none" src="/assets/check.png" alt="" data-checkmark-id="${task.id }"  />
								</div>
								<div>
									<p class="instructions">${task.instructions }</p>
									<div class="stamp">
										<p>Created by ${task.creator.firstName } ${task.creator.lastName} ${task.updatedAtString }</p>					
										<c:forEach var="member" items="${task.assignedUsers }">
											<c:if test="${member != activeUser }">
												<div class="member">${member.initials }</div>
											</c:if>
										</c:forEach>
									</div>				
								</div>
							</div>
						</div>
					</div>
				</c:forEach>
				<c:forEach var="task" items="${teamResolvedTasks }">
					<div class="taskWrapper">
						<div class="task resolved" data-is-resolved="${task.isResolved }" data-task-id="${task.id }">
							<div class="taskContents">
								<div class="checkbox" onClick="changeResolvedStatus(${task.id})">
									<img src="/assets/check.png" alt="" data-checkmark-id="${task.id }"  />
								</div>
								<div>
									<p class="instructions">${task.instructions }</p>
									<div class="stamp">
										<p>Marked resolved by ${task.markedResolvedBy } ${task.updatedAtString }</p>				
										<c:forEach var="member" items="${task.assignedUsers }">
											<c:if test="${member != activeUser }">
												<div class="member">${member.initials }</div>
											</c:if>	
										</c:forEach>
									</div>				
								</div>
							</div>
						</div>
					</div>
				</c:forEach>
			</div>
		</div>
	</div>
		
</body>
</html>