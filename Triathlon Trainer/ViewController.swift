//
//  ViewController.swift
//  Triathlon Trainer
//
//  Created by Justin Schaffner on 10/1/17.
//
//

import UIKit

class ViewController: UIViewController{//, UITableViewDataSource, UITableViewDelegate {

    // MARK: Properties
    @IBOutlet weak var scrLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    func updateLabel(newText: String){
        scrLabel.text = newText
        
    }
    
    /*// UITableViewDataSource Functions
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        //let label = UILabel(CGRect(x:0, y:0, width:200, height:50))
        //label.text = "Hello Man"
        cell.addSubview(label)
        return cell
    }
    
    
    // UITableViewDelegate Functions
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: IndexPath) -> CGFloat {
        return 50
    }

*/
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

