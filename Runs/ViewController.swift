//
//  ViewController.swift
//  Runs
//
//  Created by Dawson Toth on 10/5/20.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
	@IBOutlet weak var tableview: UITableView!
	
	weak var timer: Timer?
	private let persistentContainer = NSPersistentContainer(name: "Days")
	private let start = Date(timeIntervalSince1970: 1602216000.000)
	private let days = [
		"6 Miles Easy",
		"6 Miles Easy",
		"Recovery",
		"6 Miles Easy",
		"6 Miles Easy",
		"6 Miles Easy",
		"8 Miles Easy",
		"6 Miles Easy",
		"12 x 400m @ 5k-10k Pace w. 400m jog rest",
		"Recovery",
		"6 Miles Easy",
		"6 Miles Easy",
		"6 Miles Easy",
		"8 Miles Easy",
		"6 Miles Easy",
		"8 x 600m @ 5k-10k Pace w. 400m jog rest",
		"Recovery",
		"6 Mile Tempo @ Goal MP",
		"7 Miles Easy",
		"6 Miles Easy",
		"10 Mile Long Run",
		"6 Miles Easy",
		"6 x 800m @ 5k-10k Pace w. 400m jog rest",
		"Recovery",
		"6 Mile Tempo @ Goal MP",
		"6 Miles Easy",
		"8 Miles Easy",
		"8 Miles Easy",
		"6 Miles Easy",
		"5 x 1km @ 5k-10k Pace w. 400m jog rest",
		"Recovery",
		"6 Mile Tempo @ Goal MP",
		"7 Miles Easy",
		"6 Miles Easy",
		"12 Mile Long Run",
		"6 Miles Easy",
		"4 x 1200m @ 5k-10k Pace w. 400m jog rest",
		"Recovery",
		"7 Mile Tempo @ Goal MP",
		"6 Miles Easy",
		"8 Miles Easy",
		"10 Miles Easy",
		"6 Miles Easy",
		"3 x Mile @ 5k-10k Pace w. 800m jog rest",
		"Recovery",
		"7 Mile Tempo @ Goal MP",
		"7 Miles Easy",
		"8 Miles Easy",
		"14 Mile Long Run",
		"6 Miles Easy",
		"4 x 1200m @ 5k-10k Pace w. 400m jog rest",
		"Recovery",
		"7 Mile Tempo @ Goal MP",
		"6 Miles Easy",
		"10 Miles Easy",
		"10 Mile Long Run",
		"8 Miles Easy",
		"5 x 1km @ 5k-10k Pace w. 400m jog rest",
		"Recovery",
		"8 Mile Tempo @ Goal MP",
		"7 Miles Easy",
		"8 Miles Easy",
		"15 Mile Long Run",
		"6 Miles Easy",
		"6 x 800m @ 5k-10k Pace w. 400m jog rest",
		"Recovery",
		"8 Mile Tempo @ Goal MP",
		"6 Miles Easy",
		"10 Miles Easy",
		"10 Mile Long Run",
		"8 Miles Easy",
		"6 x Mile @ MP - 10s w. 400m jog rest",
		"Recovery",
		"8 Mile Tempo @ Goal MP",
		"7 Miles Easy",
		"8 Miles Easy",
		"16 Mile Long Run",
		"6 Miles Easy",
		"4 x 1.5 Miles @ MP - 10s w. 800m jog rest",
		"Recovery",
		"9 Mile Tempo @ Goal MP",
		"6 Miles Easy",
		"10 Miles Easy",
		"10 Mile Long Run",
		"8 Miles Easy",
		"3 x 2 Miles @ MP - 10s w. 800m jog rest",
		"Recovery",
		"9 Mile Tempo @ Goal MP",
		"7 Miles Easy",
		"8 Miles Easy",
		"16 Mile Long Run",
		"6 Miles Easy",
		"2 x 3 Miles @ MP - 10s w. 1 Mile jog rest",
		"Recovery",
		"9 Mile Tempo @ Goal MP",
		"6 Miles Easy",
		"10 Miles Easy",
		"10 Mile Long Run",
		"8 Miles Easy",
		"3 x 2 Miles @ MP - 10s w. 800m jog rest",
		"Recovery",
		"10 Mile Tempo @ Goal MP",
		"7 Miles Easy",
		"8 Miles Easy",
		"16 Mile Long Run",
		"6 Miles Easy",
		"4 x 1.5 Miles @ MP - 10s w. 800m jog rest",
		"Recovery",
		"10 Mile Tempo @ Goal MP",
		"6 Miles Easy",
		"10 Miles Easy",
		"10 Mile Long Run",
		"8 Miles Easy",
		"6 x Mile @ MP - 10s w. 400m jog rest",
		"Recovery",
		"10 Mile Tempo @ Goal MP",
		"7 Miles Easy",
		"8 Miles Easy",
		"8 Miles Easy",
		"6 Miles Easy",
		"5 Miles Easy",
		"Recovery",
		"6 Miles Easy",
		"6 Miles Easy",
		"3 Miles Easy",
		"Race Day!",
	]
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		persistentContainer.loadPersistentStores { (persistentStoreDescription, error) in
			if let error = error {
				print("Unable to Load Persistent Store")
				print("\(error), \(error.localizedDescription)")
			}
		}
		
		tableview.delegate = self
		tableview.dataSource = self
		
		let now = Date()
		let onDay = Calendar.current.dateComponents([.day], from: start, to: now).day! - 3
		if (onDay > 0) {
			tableview.scrollToRow(at: IndexPath(row:onDay,section: 0), at: UITableView.ScrollPosition.top, animated: false)
		}
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		NotificationCenter.default.addObserver(self,
											   selector:#selector(applicationWillEnterForeground(_:)),
											   name:UIApplication.willEnterForegroundNotification,
											   object: nil)
		NotificationCenter.default.addObserver(self,
											   selector:#selector(willResignActiveNotification(_:)),
											   name:UIApplication.willResignActiveNotification,
											   object: nil)
		startTimer()
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		NotificationCenter.default.removeObserver(self)
		stopTimer()
	}
	
	@objc
	func applicationWillEnterForeground(_ notification: NSNotification) {
		tableview.reloadData()
		startTimer()
	}
	
	@objc
	func willResignActiveNotification(_ notification: NSNotification) {
		tableview.reloadData()
		stopTimer()
	}
	
	func startTimer() {
		timer?.invalidate()
		timer = Timer.scheduledTimer(withTimeInterval: 60.0, repeats: true) { [weak self] _ in
			self?.tableview.reloadData()
		}
	}
	
	func stopTimer() {
		timer?.invalidate()
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return days.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableview.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! RunCell
		cell.title?.text = days[indexPath.row]
		let now = Date()
		let shortFormatter = DateFormatter()
		shortFormatter.dateStyle = .short
		let dueOn = Calendar.current.date(byAdding: .day, value: indexPath.row, to: start)!
		let inDays = Calendar.current.dateComponents([.day], from: now, to: dueOn).day!
		if (dueOn > now) {
			cell.check.alpha = 0
			cell.due.alpha = 1
			cell.title.alpha = 1
			switch (inDays) {
			case 0:
				cell.due.text = "Today"
				break;
			case 1:
				cell.due.text = "Tomorrow"
				break;
			default:
				let dayFormatter = DateFormatter()
				dayFormatter.dateFormat = "EEEE"
				cell.due.text = "in \(inDays) days on \(dayFormatter.string(from: dueOn).capitalized) \(shortFormatter.string(from: dueOn))"
				break;
			}
		}
		else {
			cell.check.alpha = 1
			cell.due.alpha = 0.4
			cell.title.alpha = 0.4
			switch (inDays) {
			case 0:
				cell.due.text = "Yesterday"
				break;
			default:
				cell.due.text = "on \(shortFormatter.string(from: dueOn))"
				break;
			}
		}
		return cell
	}
}

