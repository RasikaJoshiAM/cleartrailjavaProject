package com.example.demo;

import java.util.*;

import org.springframework.web.multipart.MultipartFile;

import java.io.*;

public class FileIndexData {
	private ArrayList<String> indexFoldersList;
	private String indexFilePath;
	private boolean isStopWordsfile;
	private boolean fileUploaded;

	public boolean isFileUploaded() {
		return fileUploaded;
	}

	public void setFileUploaded(boolean fileUploaded) {
		this.fileUploaded = fileUploaded;
	}

	public boolean getIsStopWordsFile() {
		return isStopWordsfile;
	}

	public void setStopWordsfile(boolean isStopWordsfile) {
		this.isStopWordsfile = isStopWordsfile;
	}

	public ArrayList<String> getIndexFoldersList() {
		return indexFoldersList;
	}

	public void setIndexFoldersList(ArrayList<String> indexFoldersList) {
		this.indexFoldersList = indexFoldersList;
	}

	public String getIndexFilePath() {
		return indexFilePath;
	}

	public void setIndexFilePath(String indexFilePath) {
		this.indexFilePath = indexFilePath;
	}

}
