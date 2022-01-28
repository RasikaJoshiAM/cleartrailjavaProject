package com.example.demo;

import java.util.Date;

public class FileStatistics implements java.io.Serializable {
	private String filePath;
	private String fileName;
	private int fileTokenCount;
	private long size;
	private Date date;
	private static final long serialVersionUID = 7829136421241571165L;
	private int numberOfLines;
	private int numberOfWords;

	public int getNumberOfWords() {
		return numberOfWords;
	}

	public void setNumberOfWords(int numberOfWords) {
		this.numberOfWords = numberOfWords;
	}

	public int getNumberOfLines() {
		return numberOfLines;
	}

	public void setNumberOfLines(int numberOfLines) {
		this.numberOfLines = numberOfLines;
	}

	public void setSize(long size) {
		this.size = size;
	}

	public long getSize() {
		return this.size;
	}

	public void setDate(Date date) {
		this.date = date;
	}

	public Date getDate() {
		return this.date;
	}

	public void setFileName(String fileName) {
		this.fileName = fileName;
	}

	public String getFileName() {
		return this.fileName;
	}

	public void setFilePath(String filePath) {
		this.filePath = filePath;
	}

	public String getFilePath() {
		return this.filePath;
	}

	public void setFileTokenCount(int fileTokenCount) {
		this.fileTokenCount = fileTokenCount;
	}

	public int getFileTokenCount() {
		return this.fileTokenCount;
	}
}
