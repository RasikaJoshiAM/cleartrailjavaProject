package com.example.demo;

import static java.nio.file.StandardWatchEventKinds.ENTRY_CREATE;
import static java.nio.file.StandardWatchEventKinds.ENTRY_DELETE;
import static java.nio.file.StandardWatchEventKinds.ENTRY_MODIFY;
import static org.assertj.core.api.Assertions.assertThatIllegalStateException;

import java.io.IOException;
import java.nio.file.FileSystems;
import java.nio.file.FileVisitResult;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.SimpleFileVisitor;
import java.nio.file.WatchEvent;
import java.nio.file.WatchKey;
import java.nio.file.WatchService;
import java.nio.file.attribute.BasicFileAttributes;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.Map;

public class FileWatcherThread implements Runnable {
	private Path dir;
	private FileWatcherListener fileWatcherListener;
	private WatchService watcher;
	private Map<WatchKey, Path> keys;
	private HashMap<String, WatchKey> paths;
private Thread thread;
	public FileWatcherThread() {
		try {
			this.watcher = FileSystems.getDefault().newWatchService();
			this.keys = new HashMap<WatchKey, Path>();
			this.paths = new HashMap<>();
		} catch (Exception e) {
			System.out.println(e);
		}
	}

	public void setDirectories(ArrayList<String> paths) {
		try {
			for (String path : paths) {
				this.dir = Paths.get(path);
				System.out.println("Applying watcher :" + this.dir);
				this.walkAndRegisterDirectories(this.dir);
			}
		} catch (Exception exception) {
			System.out.println("Exception in watcher :" + exception);
		}
	}

	public void setFileWatcherListener(FileWatcherListener fileWatcherListener) {
		this.fileWatcherListener = fileWatcherListener;
		this.thread = new Thread(this);
		this.thread.start();
	}
public void stopThread()
{
	this.thread.stop();
}
	public void run() {
		try {
			processEvents();
		} catch (Exception e) {
			System.out.println(e);
		}
	}

	public void removeWatcher(String dir) {
		LinkedList<String> pathsList = new LinkedList<>();
		for (String path : paths.keySet()) {
			if (path.startsWith(dir)) {
				pathsList.add(path);
				WatchKey watchKey = paths.get(path);
				watchKey.cancel();
				Path path1 = keys.remove(watchKey);
			}
		}
	}

	private void registerDirectory(Path dir) throws IOException {
		WatchKey key = dir.register(watcher, ENTRY_CREATE, ENTRY_DELETE, ENTRY_MODIFY);
		keys.put(key, dir);
		paths.put(dir.toString(), key);
	}

	public void walkAndRegisterDirectories(Path start) {
		try {
			Files.walkFileTree(start, new SimpleFileVisitor<Path>() {
				public FileVisitResult preVisitDirectory(Path dir, BasicFileAttributes attrs) throws IOException {
					registerDirectory(dir);
					return FileVisitResult.CONTINUE;
				}
			});
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	void processEvents() {
		while (true) {
			WatchKey key;
			try {
				key = watcher.take();
			} catch (Exception x) {
				System.out.println("Exception in process events :" + x);
				return;
			}
			Path dir = keys.get(key);
			System.out.println("Directory :" + dir);
			if (dir == null) {
				System.err.println("WatchKey not recognized!!");
				continue;
			}
			for (WatchEvent<?> event : key.pollEvents()) {
				WatchEvent.Kind kind = event.kind();
				Path name = ((WatchEvent<Path>) event).context();
				Path child = dir.resolve(name);
				if (kind == ENTRY_CREATE) {
System.out.println("Entry create :"+child);
					try {
						if (Files.isDirectory(child)) {
							walkAndRegisterDirectories(child);
							this.fileWatcherListener.folderCreated(child);
						} else {
							System.out.println("Child :" + child);
							this.fileWatcherListener.fileCreated(child);
						}
					} catch (Exception x) {
						System.out.println("Exception in watcher thread :" + x);
					}
				} else if (kind == ENTRY_DELETE) {
					System.out.println("Println :"+child);
					if (this.paths.containsKey(child.toString())) {
						this.removeWatcher(child.toString());
						this.fileWatcherListener.folderDeleted(child);
					} else {
						this.fileWatcherListener.fileDeleted(child);
					}

				} else if (kind == ENTRY_MODIFY) {
					System.out.println("Modification :"+child);
					System.out.println("Modify for folder has been called");
					if (Files.isDirectory(child)) {
					//	walkAndRegisterDirectories(child);
					} else {
						this.fileWatcherListener.fileModify(child);
					}

				}
			}
			boolean valid = key.reset();
			if (!valid) {
				keys.remove(key);
				if (keys.isEmpty()) {
					break;
				}
			}
		}

	}
}
