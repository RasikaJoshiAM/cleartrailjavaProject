package com.example.demo;
import java.nio.file.*;

public interface FileWatcherListener {
	public void fileCreated(Path path);
public void fileDeleted(Path path);
public void fileModify(Path path);
public void folderDeleted(Path path);
public void folderCreated(Path path);
}
