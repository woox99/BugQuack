<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- c:out ; c:forEach etc. --> 
<%@ taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core" %>
<!-- Formatting (dates) --> 
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"  %>
<!-- form:form -->
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!-- for rendering errors on PUT routes -->
<%@ page isErrorPage="true" %>
<!-- for date formatting-->
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Bug Quack | ${activeUser.firstName } ${activeUser.lastName }</title>
<link rel="stylesheet" type="text/css" href="/css/global.css">
<link rel="stylesheet" type="text/css" href="/css/dashboard.css">
<script type="text/javascript" src="/js/dashboard.js"></script>
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
		<div class="addProject card" data-is-expanded="false">
			<div class="title">
				<div class="circleLink" onclick="expandAddProject(this);">
					<img class="addProjectButton" src="/assets/add.png" alt=""/>
				</div>
				<p>New Project</p>
			</div>
			<form class="newProjectForm" action="/createProject" method="post">
				<!-- New members id's will get appended to the name field -->
				<input class="currentMemberIdsHiddenInput" type="hidden" name="memberIds" value="${activeUser.id }" />
				<input type="hidden" name="ownerId" value="${activeUser.id }" />
				<p class="addMembersText">Add members by email now or later.</p>
				<div class="members">
						<div class="member owner">${activeUser.initials }</div>
						<div class="addedMembers members">
							<!--This is wear added members will get written to-->
						</div>
					<div class="addMember" onclick="showEmailInput();">
						<img src="/assets/add.png" alt="" />
					</div>
				</div>
				<div class="addEmail">
					<p class="memberFeedback">Enter member's email.</p>
					<input class="emailInput" type="text" value="bugquack@gmail.com" />
					<button type="button" class="findUserButton" onClick="findUser()">
						<img src="/assets/add.png" alt="" />
					</button>
				</div>
				<p>Project Name:</p>
				<p class="projectNameValidation" style="opacity: 0%">Project name must be 1 to 20 characters</p>
				<input class="projectNameInput" type="text" name="name" oninput="validateProjectName(this.value)"/>
				<div class="flex-end">
					<button type="submit" class="createButton" disabled="true">Create</button>
				</div>
			</form>
		</div>
			
			
			<div class="projects">
				<c:forEach var="project" items="${projects }">
					<div class="project card" id="${project.id }" data-is-expanded="false">
						<div class="unexpanded">
							<a class="circleLink" href="/project/${project.id }">
								<img src="/assets/arrow.png" alt="" />
							</a>
							<div>
								<p class="title"><a href="/project/${project.id }">${project.name }</a></p>
								<p class="updatedAtText">Last updated ${project.updatedAtString }</p>						
							</div>
							<div class="members">
								<c:forEach var="member" items="${project.team }">
									<c:if test="${project.owner.id == member.id }">
										<div class="member owner" style="background-color:${activeUser.colorTheme}">${member.initials }</div>
									</c:if>
									<c:if test="${project.owner.id != member.id }">
										<div class="member">${member.initials }</div>
									</c:if>
								</c:forEach>
							</div>
							<div class="icons" onclick="expandProject(${project.id})">
								<div class="getTaskCount">
									<c:set var="unresolvedTaskCount" value="0" />
									    <c:forEach var="task" items="${project.tasks}">
									        <c:if test="${task.assignedUsers.contains(activeUser) && !task.isResolved}">
									            <c:set var="unresolvedTaskCount" value="${unresolvedTaskCount + 1}" />
									        </c:if>
									    </c:forEach>
									    <p data-taskcount-element-project-id="${project.id}">${unresolvedTaskCount}</p>
									<img src="/assets/alert.png" alt="" />
								</div>
								<img src="/assets/add.png" class="expandButton" data-expandBtn-project-id="${project.id }" alt="" />
							</div>
						</div>
						
						
						<div class="expanded">
							<div class="tasks">
											<div class="task resolved">
												<div class="taskContents">
													<div class="checkbox">
														<img src="/assets/check.png" alt=""   />
													</div>
													<div>
														<p class="instructions">Create a Demo Account</p>
														<div class="stamp">
															<p> Resolved by ${activeUser.firstName } ${activeUser.lastName } on
																<fmt:formatDate value="${project.createdAt}" pattern="MMM dd"/>
																at
																<fmt:formatDate value="${project.createdAt}" pattern="h:mma"/>
															</p>
														</div>
													</div>
												</div>
											</div>
								<c:forEach var="task" items="${project.tasks }">
									<c:if test="${task.assignedUsers.contains(activeUser) && task.isResolved == false }">
										<div class="taskWrapper">
											<div class="task" data-is-resolved="${task.isResolved }" data-task-id="${task.id }" onClick="changeResolvedStatus(${task.id}, ${project.id })">
												<div class="taskContents">
													<div class="checkbox">
														<img style="display:none" src="/assets/check.png" alt="" data-checkmark-id="${task.id }"  />
													</div>
													<div>
														<p class="instructions">${task.instructions }</p>
														<div class="stamp">
															<p>Created by ${task.creator.firstName } ${task.creator.lastName} on 
																<fmt:formatDate value="${task.createdAt}" pattern="MMM dd"/>
																at
																<fmt:formatDate value="${task.createdAt}" pattern="h:mma"/>
															</p>
															<c:if test="${task.assignedUsers.size() > 1 }">
																<c:forEach var="member" items="${task.assignedUsers }">
																	<c:if test="${member != activeUser }">
																		<div class="member">${member.initials }</div>
																	</c:if>
																</c:forEach>									
															</c:if>
														</div>
													</div>
												</div>
											</div>
										</div>
									</c:if>
								</c:forEach>
							</div>
						</div>
					</div>
				</c:forEach>
			</div>
	</div>
</body>
</html>