package com.example.demo.controllers;

import java.util.Collections;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

import com.example.demo.models.Project;
import com.example.demo.models.Task;
import com.example.demo.models.User;
import com.example.demo.services.ProjectService;
import com.example.demo.services.TaskService;
import com.example.demo.services.UserService;

import jakarta.servlet.http.HttpSession;

@Controller
public class MainController {
	
	@Autowired
	UserService userServ;
	@Autowired
	ProjectService projectServ;
	@Autowired
	TaskService taskServ;

	// ##### DISPLAY LANDING PAGE #####
	@RequestMapping("/")
	public String landingPage() {
		return "landingPage.jsp";
	}

	
	// ###### DISPLAY DASHBOARD PAGE #####
	@RequestMapping("/dashboard")
	public String dashboard(
			Model model,
			HttpSession session) {
		
		// If activeUserId is not set, return forbidden
		if(session.getAttribute("activeUserId") == null) {
			return "forbidden.jsp";
		}
		
		User activeUser = userServ.findUser( (Long) session.getAttribute("activeUserId"));
		
		// Get all projects associated with activeUser
		List<Project> projects = projectServ.findAllByTeamIsContaining(activeUser);
		Collections.reverse(projects);
		
		model.addAttribute("activeUser", activeUser);
		model.addAttribute("projects", projects);
		
		return "dashboard.jsp";
	}

	// ###### DISPLAY PROJECT PAGE #####
	@RequestMapping("/project/{projectId}")
	public String viewProject(
			@PathVariable Long projectId,
			Model model,
			HttpSession session) {
		
		// If activeUserId is not set, return forbidden
		if(session.getAttribute("activeUserId") == null) {
			return "forbidden.jsp";
		}
		
		Project project = projectServ.findProject(projectId);
		User activeUser = userServ.findUser((Long) session.getAttribute("activeUserId"));
		
		// Route protection
		if(!project.getTeam().contains(activeUser)) {
			return "forbidden.jsp";
		}
		
		// Get all unresolved tasks assigned to active user by project
		List<Task> activeUserUnresolvedTasks = taskServ.findActiveUserUnresolvedTasks(project, activeUser);
		// Get all resolved tasks assigned to active user by project
		List<Task> activeUserResolvedTasks = taskServ.findActiveUserResolvedTasks(project, activeUser);
		// Get all unresolved team tasks by project
		List<Task> teamUnresolvedTasks = taskServ.findTeamUnresolvedTasks(project, activeUser);
		// Get all resolved team tasks by project
		List<Task> teamResolvedTasks = taskServ.findTeamResolvedTasks(project, activeUser);
		
		model.addAttribute("project", project);
		model.addAttribute("activeUser", activeUser);
		model.addAttribute("teamSize", project.getTeam().size());
		model.addAttribute("activeUserUnresolvedTasks", activeUserUnresolvedTasks);
		model.addAttribute("activeUserResolvedTasks", activeUserResolvedTasks);
		model.addAttribute("teamUnresolvedTasks", teamUnresolvedTasks);
		model.addAttribute("teamResolvedTasks", teamResolvedTasks);

		return "project.jsp";
	}

	

}
