package com.example.demo;

import java.io.File;

public class FileIndexingThread extends Thread {
	private String extension;
	private File file;
	private FileIndexUtility fileIndexUtility;

	public FileIndexingThread(String extension, File file, FileIndexUtility fileIndexUtility) {
		this.extension = extension;
		this.file = file;
		this.fileIndexUtility = fileIndexUtility;
	}

	public String getExtension() {
		return extension;
	}

	public void setExtension(String extension) {
		this.extension = extension;
	}

	public File getFile() {
		return file;
	}

	public void setFile(File file) {
		this.file = file;
	}

	public void run() {
		this.fileIndexUtility.performIndexing(this.extension, this.file);
this.fileIndexUtility.increaseThreadsCountByOne();
	}
}
