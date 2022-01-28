package com.example.demo;

public class IndexFolderPair implements java.io.Serializable{
private String folderToBeIndex;
private String indexFolderPath;
public String getFolderToBeIndex() {
	return folderToBeIndex;
}
public void setFolderToBeIndex(String folderToBeIndex) {
	this.folderToBeIndex = folderToBeIndex;
}
public String getIndexFolderPath() {
	return indexFolderPath;
}
public void setIndexFolderPath(String indexFolderPath) {
	this.indexFolderPath = indexFolderPath;
}

}
