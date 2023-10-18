package com.example.demo.controllers;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.example.demo.models.LoginUser;
import com.example.demo.models.Project;
import com.example.demo.models.Task;
import com.example.demo.models.User;
import com.example.demo.services.ProjectService;
import com.example.demo.services.TaskService;
import com.example.demo.services.UserService;

import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;

@Controller
public class UserController {
	
	@Autowired
	UserService userServ;
	@Autowired
	ProjectService projectServ;
	@Autowired
	TaskService taskServ;

	// ##### DISPLAY LOGIN AND REGISTRATION PAGE #####
	@RequestMapping("/auth")
	public String index(
			@ModelAttribute("user") User user,
			@ModelAttribute("loginUser") LoginUser loginUser) {

		return "auth.jsp";
	}

	
	// ##### REGISTER USER #####
	@PostMapping("/register")
	public String register(
			Model model,
			HttpSession session,
			@Valid @ModelAttribute("user") User user,
			BindingResult result) {
		
		User activeUser = userServ.register(user, result);
		System.out.println(result);
		if(result.hasErrors()) {
			model.addAttribute("loginUser", new LoginUser());
			return "auth.jsp";
		}
		
		// set activeUser in session
		session.setAttribute("activeUserId", activeUser.getId());
		return "redirect:/dashboard";
	}
	
	
	// ##### LOGIN USER #####
	@PostMapping("/login")
	public String login(
			Model model,
			HttpSession session,
			@Valid @ModelAttribute("loginUser") LoginUser loginUser,
			BindingResult result) {
		
		User activeUser = userServ.login(loginUser, result);
		System.out.println(result);
		if(result.hasErrors()) {
			model.addAttribute("user", new User());
			return "auth.jsp";
		}

		session.setAttribute("activeUserId", activeUser.getId());
		return "redirect:/dashboard";
	}
	
	// ##### LOGOUT USER #####
	@RequestMapping("/logout")
	public String logout(
			HttpSession session) {
		
		// clear activeUser in session
		session.setAttribute("activeUserId", null);
		
		return "redirect:/";
	}
	
	// ##### CREATE DEMO ACCOUNT #####
	@RequestMapping("/demo")
	public String demo(
			HttpSession session,
			Model model) {
		
		// Create demo account and assign activeUser
		User activeUser = userServ.demoAccount();
		session.setAttribute("activeUserId", activeUser.getId());
		
		// Create Example Project
		List<Long> memberIds = new ArrayList<>();
		Long garettId = (long) 1;
		memberIds.add(activeUser.getId());
		memberIds.add(garettId);
		Project project = projectServ.createProject("example project", activeUser.getId(), memberIds);
		projectServ.updatedByUser(project, activeUser);
		
		// Create Example Tasks
		List<User> assignedUsers = new ArrayList<>();
		assignedUsers.add(activeUser);
		assignedUsers.add(userServ.findUser(garettId));
		
		Task task1 = new Task();
		task1.setProject(project);
		task1.setInstructions("Create a Demo Account.");
		task1.setCreator(activeUser);
		task1.setIsResolved(true);
		task1.setMarkedResolvedBy(activeUser.getFirstName() + " " + activeUser.getLastName());
		task1.setAssignedUsers(assignedUsers);
		taskServ.createTask(task1);

		Task task2 = new Task();
		task2.setProject(project);
		task2.setInstructions("Create a new task and assign a team member.");
		task2.setCreator(activeUser);
		task2.setAssignedUsers(assignedUsers);
		taskServ.createTask(task2);

		Task task4 = new Task();
		task4.setProject(project);
		task4.setInstructions("Add a member to your project team by email.");
		task4.setCreator(activeUser);
		task4.setAssignedUsers(assignedUsers);
		taskServ.createTask(task4);

		Task task3 = new Task();
		task3.setProject(project);
		task3.setInstructions("Create a new project.");
		task3.setCreator(activeUser);
		task3.setAssignedUsers(assignedUsers);
		taskServ.createTask(task3);
		
		return "redirect:/dashboard";
	}
	
	// ##### CHANGE COLOR THEME #####
	@PostMapping("/changeColorTheme/{color}")
	public String changeColorTheme(
			@PathVariable String color,
			HttpSession session) {
		
		User activeUser = userServ.findUser((Long) session.getAttribute("activeUserId"));

		activeUser.setColorTheme(color);
		userServ.updateUser(activeUser);
		
		return null;
	}



}
