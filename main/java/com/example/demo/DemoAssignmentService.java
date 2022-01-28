package com.example.demo;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.simp.SimpMessageSendingOperations;
import org.springframework.messaging.simp.annotation.SendToUser;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;



@Controller
public class DemoAssignmentService {
	@Autowired
	private SimpMessageSendingOperations messagingTemplate;
	@Autowired
	private FileIndexModel fileIndexModel;

	@RequestMapping("/MasterPageTopSection")
	public String MasterPageTopSection() {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("MasterPageTopSection");
		return "MasterPageTopSection";
	}

	@RequestMapping("/MasterPageTopSectionNew")
	public String MasterPageTopSectionNew() {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("MasterPageTopSectionNew");
		return "MasterPageTopSectionNew";
	}

	@RequestMapping("/MasterPageBottomSection")
	public String MasterPageBottomSection() {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("MasterPageBottomSection");
		return "MasterPageBottomSection";
	}
	@RequestMapping("/MasterPageBottomSectionNew")
	public String MasterPageBottomSectionNew() {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("MasterPageBottomSectionNew");
		return "MasterPageBottomSectionNew";
	}

	@RequestMapping("/ScrollTest")
	public String ScrollTest() {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("ScrollTest");
		return "ScrollTest";
	}

	@RequestMapping("/chartExample")
	public String ChartExample() {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("ChartExample");
		return "ChartExample";
	}

	@RequestMapping("/index")
	public String index() {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("index");
		return "index";
	}

	@RequestMapping("/createIndex")
	public String createIndex() {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("CreateIndex");
		return "CreateIndex";
	}

	@RequestMapping("/createIndexNew")
	public String createIndexNew() {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("CreateIndexNew");
		return "CreateIndexNew";
	}

	@RequestMapping("/tokensList")
	public String TokensList() {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("TokensList");
		return "TokensList";
	}

	@RequestMapping("/filesList")
	public String FilesList() {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("FilesList");
		return "FilesList";
	}

	@RequestMapping("/test")
	public String Test() {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("Test");
		return "Test";
	}

	@RequestMapping("/searchFileFromToken")
	public String SearchFileFromToken() {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("SearchFileFromToken");
		return "SearchFileFromToken";
	}

	@RequestMapping("/showFile")
	public String ShowFile() {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("ShowFile");
		return "ShowFile";
	}

	@RequestMapping("/wordCloudTest")
	public String WordCloudTest() {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("WordCloudTest");
		return "WordCloudTest";
	}
	@RequestMapping("/home")
	public String Home() {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("Home");
		return "Home";
	}
	@RequestMapping("/tempHome")
	public String TempHome() {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("TempHome");
		return "TempHome";
	}

	@MessageMapping("/hello")
	public void greeting() throws Exception {
		this.fileIndexModel.setMessagingTemplate(this.messagingTemplate);
	}
}
