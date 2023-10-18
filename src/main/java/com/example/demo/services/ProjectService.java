package com.example.demo.services;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.models.Project;
import com.example.demo.models.Task;
import com.example.demo.models.User;
import com.example.demo.repositories.ProjectRepository;

@Service
public class ProjectService {
    
    @Autowired
    private ProjectRepository projectRepo;
	@Autowired
	UserService userServ;
    
    // ##### CREATE PROJECT #####
    public Project createProject(String name, Long ownerId, List<Long> memberIds) {
    	
    	User owner = userServ.findUser(ownerId);
    	
    	Project newProject = new Project();
    	newProject.setOwner(owner);
    	
    	// Add team members to project
    	List<User> team = new ArrayList<>();
    	for(Long id : memberIds) {
    		team.add(userServ.findUser(id));
    	}
    	newProject.setTeam(team);
    	
    	// Make first letter of each word of project name upper case
    	String words[] = name.split("\\s");
    	StringBuilder result = new StringBuilder();
    	
    	for (String word : words) {
            if (!word.isEmpty()) {
                if (result.length() > 0) {
                    result.append(" ");
                }
                result.append(Character.toUpperCase(word.charAt(0))).append(word.substring(1));
            }
        }
    	newProject.setName(result.toString());
    	
    	return projectRepo.save(newProject);
    }
    
    // ##### FIND ALL PROJECTS BY USER #####
    public List<Project> findAllByTeamIsContaining(User user){
        List<Project> projects = projectRepo.findAllByTeamIsContaining(user);

        // Sort the projects list by updatedAt
        Comparator<Project> projectComparator = Comparator.comparing(Project::getUpdatedAt);
        Collections.sort(projects, projectComparator);

        // Sort project.tasks by updated at for each project
        for (Project project : projects) {
            List<Task> tasks = project.getTasks();
            if (tasks != null && !tasks.isEmpty()) {
                Comparator<Task> taskComparator = Comparator.comparing(Task::getUpdatedAt);
                Collections.sort(tasks, taskComparator.reversed());
            }
        }
    	
    	return projects;
    }
    
    // ##### FIND PROJECT BY ID #####
    public Project findProject(Long projectId) {
    	Optional<Project> optionalProject = projectRepo.findById(projectId);
    	return optionalProject.isPresent() ? optionalProject.get() : null;
    }
    
    // ##### DELETE PROJECT #####
    public void deleteProject(Long projectId) {
    	projectRepo.deleteById(projectId);
    }
    
    // ##### UPDATE PROJECT #####
    public Project updateProject(Project project) {
    	return projectRepo.save(project);
    }
    
    // ##### UPDATED BY USER STAMP PROJECT #####
    public Project updatedByUser(Project project, User activeUser) {
    	// Update updatedAt DATE
    	Date now = new Date();
    	project.setUpdatedBy(activeUser.getFirstName() + " " + activeUser.getLastName());
    	project.setUpdatedAt(now);
    	
    	// Update updatedAtString
    	SimpleDateFormat dateFormat = new SimpleDateFormat("MMM d");
        SimpleDateFormat timeFormat = new SimpleDateFormat("h:mma"); 
        project.setUpdatedAtString("on " + dateFormat.format(now) + " at " + timeFormat.format(now));
        
    	return projectRepo.save(project);
    }

}