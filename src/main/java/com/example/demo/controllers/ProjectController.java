package com.example.demo.controllers;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.demo.models.Project;
import com.example.demo.models.User;
import com.example.demo.services.ProjectService;
import com.example.demo.services.UserService;

import jakarta.servlet.http.HttpSession;

@Controller
public class ProjectController {
	
	@Autowired
	UserService userServ;
	@Autowired
	ProjectService projectServ;

	// ###### CREATE PROJECT #####
	@PostMapping("/createProject")
	public String createProject(
			@RequestParam("name") String name,
			@RequestParam("ownerId") Long ownerId,
			@RequestParam("memberIds") List<Long> memberIds) {
		
		
		//Create project
		Project project = projectServ.createProject(name, ownerId, memberIds);
		
		//Update create by user stamp
		User activeUser = userServ.findUser(ownerId);
		projectServ.updatedByUser(project, activeUser);
		
		return "redirect:/dashboard";
	}
	
	// ###### DELETE PROJECT #####
	@RequestMapping("/deleteProject/{projectId}")
	public String deleteProject(
			@PathVariable Long projectId,
			HttpSession session) {
		
		// Route protection
		if(session.getAttribute("activeUserId") == null) {
			return "forbidden.jsp";
		}
		User activeUser = userServ.findUser( (Long) session.getAttribute("activeUserId"));
		Project project = projectServ.findProject(projectId);
		if(project.getOwner() != activeUser) {
			return "forbidden.jsp";
		}

		projectServ.deleteProject(projectId);
		
		return "redirect:/dashboard";
	}
	
	// ###### EDIT PROJECT #####
	@PostMapping("/editProject/{projectId}")
	public String editProject(
			@PathVariable Long projectId,
			@RequestParam("projectName") String projectName,
			HttpSession session) {
		
		Project project = projectServ.findProject(projectId);
		User activeUser = userServ.findUser( (Long) session.getAttribute("activeUserId"));

		project.setName(projectName);
		projectServ.updateProject(project);

		// Updated by user stamp
		projectServ.updatedByUser(project, activeUser);
		
		return "redirect:/project/" + projectId;
	}
	
	// ###### REMOVE TEAM MEMBER #####
	@RequestMapping("/removeMember/{projectId}")
	public String removeMember(
			@PathVariable Long projectId,
			HttpSession session) {
		
		Project project = projectServ.findProject(projectId);
		User activeUser = userServ.findUser( (Long) session.getAttribute("activeUserId"));
		
		// Route protection: if owner tries removing their self from team
		// Or if activeUser is not in project team
		if(project.getOwner() == activeUser || !project.getTeam().contains(activeUser)) {
			return "forbidden.jsp";
		}
		
		List<User> newTeam = project.getTeam();
		newTeam.remove(activeUser);
		project.setTeam(newTeam);
		projectServ.updateProject(project);
		projectServ.updatedByUser(project, activeUser);
		
		return "redirect:/dashboard";
	}
	
	// ##### GET MEMBER INFO BY EMAIL #####
	@RequestMapping("/getMemberInfoByEmail/{memberEmail}")
	@ResponseBody
	public Map<String, Object> getMemberIdByEmail(
			@PathVariable String memberEmail ) {
		
		User newMember = userServ.findUserByEmail(memberEmail);

		// Create a hashmap of newUser info instead of returning object
		// An object with a many to many relationship is breaking the JSON response
		Map<String, Object> memberInfo = new HashMap<>();
		
		// If no user was found, return a null response
		if(newMember == null) {
			memberInfo.put("id", null);
			return memberInfo;
		}
		
		memberInfo.put("id", newMember.getId());
		memberInfo.put("initials", newMember.getInitials());
		
		return memberInfo;
	}

	
	// ###### ADD TEAM MEMBER #####
	@RequestMapping("/addMember/{projectId}/{memberEmail}")
	public String addMember(
			@PathVariable Long projectId,
			@PathVariable String memberEmail,
			HttpSession session) {
		
		Project project = projectServ.findProject(projectId);
		User newMember = userServ.findUserByEmail(memberEmail);
		User activeUser = userServ.findUser((Long) session.getAttribute("activeUserId"));
		
		// Route protection
		if(session.getAttribute("activeUserId") == null || !project.getTeam().contains(activeUser))  {
			return "forbidden.jsp";
		}

		// If member is already in team, do nothing and redirect
		for(User member : project.getTeam()) {
			if(member == newMember) {
				return "redirect:/project/" + projectId;
			}
		}
		
		// If member wasn't already in team, add member to team and update team
		List<User> newTeam = project.getTeam();
		newTeam.add(newMember);
		project.setTeam(newTeam);
		projectServ.updateProject(project);
		
		// Updated by user stamp
		projectServ.updatedByUser(project, activeUser);
		return "redirect:/project/" + projectId;
	}


}
