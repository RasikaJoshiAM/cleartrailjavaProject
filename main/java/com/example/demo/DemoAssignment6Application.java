package com.example.demo;

import java.util.Scanner;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.ConfigurableApplicationContext;
import org.springframework.context.annotation.Bean;

@SpringBootApplication
public class DemoAssignment6Application {

	public static void main(String[] args) {
		ConfigurableApplicationContext ctx = SpringApplication.run(DemoAssignment6Application.class, args);
		try
		{
		Scanner sc = new Scanner(System.in);
		String message = sc.next();
		if (message.trim().equalsIgnoreCase("exit")) {
			ctx.getBean(FileIndexModel.class);
			System.out.println("before close");
			ctx.close();
		}
		sc.close();
		}catch(Exception e)
		{
			System.out.println("Exception in main :"+e);
		}
	}

	@Bean
	public FileIndexModel getDemoModel() {
		FileIndexModel fileIndexModel = new FileIndexModel();
		return fileIndexModel;
	}
}
